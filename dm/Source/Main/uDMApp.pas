unit uDMApp;

{$I ../../dm.inc}
{.$DEFINE SIMPLE_MENU}

interface

uses
  Sysutils, Dialogs, Windows, Controls, Classes, Messages, Contnrs, Forms, fProject,
  FormSize, Types, UITypes, uAppRegistry;

type
  TDMApplication = class;

  TBaseDMAppUpdater = class(TComponent)
  private
    FDMApp: TDMApplication;
  protected
    property DMApp: TDMApplication read FDMApp write FDMApp;
  public
    procedure CheckForUpdates; virtual; abstract;
    procedure WebUpdateAlert; virtual; abstract;
  end;

  TDMProjectForm = class(TComponent)
  private
    FForm: TForm;
    FApp: TDMApplication;
    FIntProject: TfmProject;
    procedure SetProject(const Value: TfmProject);
{$IFDEF SIMPLE_MENU}
    procedure CreateNormalForm;
{$ELSE}
    procedure CreateRibbonForm;
{$ENDIF}
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AApp: TDMApplication); reintroduce;
    destructor Destroy; override;

    procedure ShowForm;
    procedure CloseProject(AutoDestroyForm: boolean);
    procedure NotifyCloseAll;

    procedure NotifyFormActivation;

    property App: TDMApplication read FApp;
    property Project: TfmProject read FIntProject write SetProject;
  end;

  TDMProjectForms = class(TObjectList)
  private
    function GetItems(Index: Integer): TDMProjectForm;
  public
    function Add(AProject: TDMProjectForm): Integer;
    property Forms[Index: Integer]: TDMProjectForm read GetItems; default;
  end;

  TDMApplication = class(TComponent)
  private
    FActiveForm: TDMProjectForm;
    FProjectForms: TDMProjectForms;
    FAppUpdater: TBaseDMAppUpdater;
    procedure ProjectFormDestroyed(AProjectForm: TDMProjectForm);
    function AddProjectForm: TDMProjectForm;
    function ActiveProjectForm: TDMProjectForm;
    procedure OpenProjectInForm(AProj: TfmProject);
    function DoSaveProject(AProjForm: TDMProjectForm; AFileName: string): boolean;
    procedure DoOpenProject(AFileName: string);
    function FindOpenedProject(AFileName: string): TDMProjectForm;
    procedure BroadcastMessage(Msg: Cardinal; wParam, lParam: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowForm(AProjectForm: TDMProjectForm);

    {Display the help file}
    procedure ShowHelp;

    {Enviornment functions}
    procedure EnvironmentOptionsDlg;

    {Actions for managing projects}
    procedure Init;
    procedure CloseAll;
    procedure CloseProject(AProjForm: TDMProjectForm; AutoDestroyForm: boolean);
    procedure OpenProjectDlg;
    function SaveProjectDlg(AProjForm: TDMProjectForm): boolean;
    function SaveProjectAsDlg(AProjForm: TDMProjectForm): boolean;
    procedure OpenRecentFile(AFileName: string);

    procedure NewProjectDlg(AImport: boolean);

    property ProjectForms: TDMProjectForms read FProjectForms;

    property Updater: TBaseDMAppUpdater read FAppUpdater;
  end;

function GlobalDMApp: TDMApplication;

implementation

uses
  ShellApi,
{$IFDEF SIMPLE_MENU}
  fMenu,
{$ELSE}
  fMenuRibbon,
{$ENDIF}

  uDialogs, LangConst, Math, uStrings,   uWebUpdate,   dgConsts, fEnvironmentSettings;

var
  _GlobalDMApp: TDMApplication;

function GlobalDMApp: TDMApplication;
begin
  result := _GlobalDMApp;
end;

{ TDMProjectForms }

function TDMProjectForms.Add(AProject: TDMProjectForm): integer;
begin
  result := inherited Add(AProject);
end;

function TDMProjectForms.GetItems(Index: Integer): TDMProjectForm;
begin
  result := TDMProjectForm(inherited Items[Index]);
end;

{ TDMApplication }

function TDMApplication.ActiveProjectForm: TDMProjectForm;
var
  c: integer;
begin
  {Try to get the effective active form in the screen}
  result := nil;
  for c := 0 to Screen.FormCount - 1 do
{$IFDEF SIMPLE_MENU}
    if Screen.Forms[c] is TfmMenu then
      result := TfmMenu(Screen.Forms[c]).DMProjectForm;
{$ELSE}
    if Screen.Forms[c] is TfmMenuRibbon then
      result := TfmMenuRibbon(Screen.Forms[c]).DMProjectForm;
{$ENDIF}
    

  {if not found (for example, if a modal dialog is opened, or a secondary form)
   then use the last form activated}
  if result = nil then
    result := FActiveForm;
end;

function TDMApplication.AddProjectForm: TDMProjectForm;
begin
  result := TDMProjectForm.Create(Self);
  FProjectForms.Add(result);
end;

procedure TDMApplication.BroadcastMessage(Msg: Cardinal; wParam, lParam: integer);
var
  c: integer;
begin
  for c := 0 to ProjectForms.Count - 1 do
    if ProjectForms[c].Project <> nil then
      PostMessage(ProjectForms[c].Project.Handle, Msg, wParam, lParam);

end;

procedure TDMApplication.CloseAll;
begin
  {Close all projects until only one remain. We can do the while until
   project forms go to zero, because it will never happen. Close Project
   will alwas keep one form in the screen}
  while ProjectForms.Count > 1 do
    CloseProject(ProjectForms[0], true);

  if ProjectForms.Count > 0 then
  begin
    {Now close the last project remaining}
    CloseProject(ProjectForms[0], true);

    {Now destroy the last form}
    ProjectForms[0].Free;
  end;
end;

procedure TDMApplication.CloseProject(AProjForm: TDMProjectForm; AutoDestroyForm: boolean);
begin
  if AProjForm.Project <> nil then
  begin
    {the next command raises an Abort exception if the user cancel project closing}
    if AProjForm.Project.Modified then
    begin
      AProjForm.ShowForm;
      case DialogMsg(
         SProjectHasUnsavedChanges +
         SSaveChangesBeforeClosing,mtConfirmation, [mbYes,mbNo,mbCancel], 0) of
        mrYes:
          if not SaveProjectDlg(AProjForm) then
            Abort;
        mrCancel:
          Abort;
      end;
    end;
    AProjForm.Project.Close;
    AProjForm.Project.Free;
    AProjForm.Project := nil;

    {If there are other project windows, then destroy the current one. If not,
     then keep it open with no project opened}
    if AutoDestroyForm and (ProjectForms.Count > 1) then
      AProjForm.Free;
  end;
end;

constructor TDMApplication.Create(AOwner: TComponent);
begin
  inherited;
  _GlobalDMApp := Self;
  FAppUpdater := TDMAppUpdater.Create(nil);
  FAppUpdater.DMApp := Self;
  FProjectForms := TDMProjectForms.Create(false);
end;

destructor TDMApplication.Destroy;
begin
  FreeAndNil(FAppUpdater);
  FreeAndNil(FProjectForms);
  _GlobalDMApp := nil;
  inherited;
end;

procedure TDMApplication.DoOpenProject(AFileName: string);
var
  ANewProj: TfmProject;
  AForm: TDMProjectForm;
  ProjOk: boolean;
begin
  if FileExists(AFileName) then
  begin
    AForm := FindOpenedProject(AFileName);
    if (AForm <> nil) then
    begin
      AForm.ShowForm;
    end
    else
    begin
      ANewProj := TfmProject.Create(nil);

      try
        ProjOk := ANewProj.Open(AFileName);
      except
        ANewProj.Free;
        raise;
      end;

      if ProjOk then
      begin
        ANewProj.Name := 'A' + IntToStr(GetTickCount);

        {If the project was created, then opens a form to hold it}
        OpenProjectInForm(ANewProj);
        DMRegistry.AddRecentFile(AFileName);
      end
      else
        ANewProj.Free;
    end;
  end;
end;

function TDMApplication.DoSaveProject(AProjForm: TDMProjectForm; AFileName: string): boolean;
begin
  try
    AProjForm.Project.DoSave(AFileName);
    DMRegistry.AddRecentFile(AFileName);
    if AProjForm.FForm <> nil then
      AProjForm.FForm.Perform(WM_DM_PROJECTSAVED, 0, 0);
    result := true;
  except
    on e: Exception do
    begin
      MessageDlg('Cannot save project file. Error: ' + e.Message, mtError, [mbOk], 0);
      result := false;
    end;
  end;
end;

procedure TDMApplication.EnvironmentOptionsDlg;
begin
  with TfmEnvironmentSettings.Create(nil) do
  try
    if Execute then
    begin
      BroadcastMessage(WM_DM_REFRESHOPENEDDIAGRAMS, 0, 0);
    end;
  finally
    Free;
  end;
end;

function TDMApplication.FindOpenedProject(AFileName: string): TDMProjectForm;
var
  c: Integer;
begin
  result := nil;
  for c := 0 to ProjectForms.Count - 1 do
    if (ProjectForms[c].Project <> nil) and
      SameText(ProjectForms[c].Project.MetaData.FileName, AFileName) then
      begin
        result := ProjectForms[c];
        break;
      end;
end;

procedure TDMApplication.Init;
begin
  AddProjectForm.ShowForm;

  {Open the file name passed in command line (if any)}
  if Trim(ParamStr(1)) <> '' then
    DoOpenProject(ParamStr(1))
  else
  if FileExists(DMRegistry.DefaultProject) then
  begin
    DoOpenProject(DMRegistry.DefaultProject);
    if DMRegistry.AutoRemoveDefaultProject then
    begin
      {auto show diagram of northwind}
      if SameText('northwind', ExtractFileName(ChangeFileExt(DMRegistry.DefaultProject, ''))) then
      begin
        if (ProjectForms.Count > 0) and (ProjectForms[0].Project <> nil)
          and (ProjectForms[0].Project.MetaData.DiagramObj.Diagrams.Count > 0) then
          SendMessage(ProjectForms[0].Project.Handle,
            WM_DM_SELECTELEMENT,
            integer(ProjectForms[0].Project.MetaData.DiagramObj.Diagrams[0]),
            0);
      end;


      {remove project}
      DMRegistry.DefaultProject := '';
      DMRegistry.AutoRemoveDefaultProject := false;
    end;
  end;

  Application.ProcessMessages;

  if DMRegistry.CheckUpdatesOnStart then
    Updater.WebUpdateAlert;
end;

procedure TDMApplication.NewProjectDlg(AImport: boolean);
var
  ANewProj: TfmProject;
begin
  ANewProj := TfmProject.Create(nil);
  if ANewProj.NewDlg(AImport) then
  begin
    ANewProj.Name := 'A' + IntToStr(GetTickCount);
    {If the project was created, then opens a form to hold it}
    OpenProjectInForm(ANewProj);
  end
  else
    ANewProj.Free;
end;

procedure TDMApplication.OpenProjectDlg;
var
  AFileName: string;
begin
  AFileName := '';
  if ExecuteOpenDialog(
    SOpenProject,
    DMProjectExtension,
    Format(SProjectsCaption, [DMProjectExtension, DMProjectExtension]),
    AFileName) then
  begin
    DoOpenProject(AFileName);
  end;
end;

procedure TDMApplication.OpenProjectInForm(AProj: TfmProject);
var
  AProjForm: TDMProjectForm;
begin
  {Get the form currently open in the screen. If the form doesn't exist
   or exists but there is already a project opened, then we must create another form}
  AProjForm := ActiveProjectForm;
  if (AProjForm = nil) or (AProjForm.Project <> nil) then
  begin
    AProjForm := AddProjectForm;
  end;
  AProjForm.Project := AProj;
  AProjForm.ShowForm;
end;

procedure TDMApplication.OpenRecentFile(AFileName: string);
begin
  if FileExists(AFileName) then
    DoOpenProject(AFileName)
  else
  begin
    DMRegistry.RemoveRecentFile(AFileName);
    ShowMessage(Format('This file could not be found.'#13#10'(%s)', [AFileName]));
  end;
end;

procedure TDMApplication.ProjectFormDestroyed(AProjectForm: TDMProjectForm);
begin
  if ProjectForms.Count = 0 then
    Application.Terminate;
end;

function TDMApplication.SaveProjectAsDlg(AProjForm: TDMProjectForm): boolean;
var
  AFileName: string;
begin
  result := false;
  if (AProjForm <> nil) and (AProjForm.Project <> nil) then
  begin
    AFileName := AProjForm.Project.MetaData.FileName;
    if ExecuteSaveDialog(
      SSaveProject, DMProjectExtension,
      Format(SProjectsCaption, [DMProjectExtension, DMProjectExtension]),
      AFileName)
    then
      result := DoSaveProject(AProjForm, AFileName);
  end;
end;

function TDMApplication.SaveProjectDlg(AProjForm: TDMProjectForm): boolean;
begin
  result := False;
  if (AProjForm <> nil) and (AProjForm.Project <> nil) then
  begin
    if AProjForm.Project.MetaData.FileName <> '' then
      result := DoSaveProject(AProjForm, AProjForm.Project.MetaData.FileName)
    else
      result := SaveProjectAsDlg(AProjForm);
  end;
end;

procedure TDMApplication.ShowForm(AProjectForm: TDMProjectForm);
begin
  if (AProjectForm <> nil) and (AProjectForm.FForm <> nil) then
  begin
    if not (AProjectForm.FForm.Visible) then
    begin
      if AProjectForm.FForm.WindowState <> wsMaximized then
        AProjectForm.FForm.WindowState := wsNormal;
      AProjectForm.FForm.Show;
    end
    else
      AProjectForm.FForm.SetFocus;
  end;
end;

procedure TDMApplication.ShowHelp;
var
  HelpFile: string;
begin
  HelpFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'datamodeler_manual.chm';
  if FileExists(HelpFile) then
    ShellExecute(0, 'open', PChar(HelpFile), nil, nil, SW_NORMAL);
end;

{ TDMProjectForm }

procedure TDMProjectForm.CloseProject(AutoDestroyForm: boolean);
begin
  if FApp <> nil then
    FApp.CloseProject(Self, AutoDestroyForm);
end;

constructor TDMProjectForm.Create(AApp: TDMApplication);
begin
  FApp := AApp;
  inherited Create(FApp);

  Name := 'A' + IntToStr(GetTickCount);
{$IFDEF SIMPLE_MENU}
  CreateNormalForm;
{$ELSE}
  CreateRibbonForm;
{$ENDIF}
end;

{$IFNDEF SIMPLE_MENU}
procedure TDMProjectForm.CreateRibbonForm;
begin
  FForm := TfmMenuRibbon.CreateFromDM(Self);
  FForm.FreeNotification(Self);
end;
{$ENDIF}

{$IFDEF SIMPLE_MENU}
procedure TDMProjectForm.CreateNormalForm;
begin
  FForm := TfmMenu.CreateFromDM(Self);
  FForm.FreeNotification(Self);
end;
{$ENDIF}

destructor TDMProjectForm.Destroy;
begin
  if FForm <> nil then
    FreeAndNil(FForm);
  if FIntProject <> nil then
    FreeAndNil(FIntProject);
    
  if FApp <> nil then
  begin
    if FApp.ProjectForms <> nil then
    begin
      FApp.ProjectForms.Remove(Self);
      FApp.ProjectFormDestroyed(Self);
    end;
  end;
  inherited;
end;

procedure TDMProjectForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FForm then
    begin
      FForm := nil;

      {if the form was destroyed, then destroy this TDMProjectForm. Unless of course,
       that the form was destroyed just because we're destroying this TDMProjectForm}
      if not (csDestroying in ComponentState) then
        Free;
    end;
    if AComponent = Project then
      {if the project is destroyed, then set project to nil. Set property (not field)
       so that SetProject is called and then the proper operations are done} 
      Project := nil;
  end;
end;

procedure TDMProjectForm.NotifyCloseAll;
begin
  PostMessage(FForm.Handle, WM_DM_CLOSE_ALL, 0, 0);
end;

procedure TDMProjectForm.NotifyFormActivation;
begin
  if FApp <> nil then
    FApp.FActiveForm := Self;
end;

procedure TDMProjectForm.SetProject(const Value: TfmProject);
begin
  if FIntProject <> Value then
  begin
    if FIntProject <> nil then
      FIntProject.RemoveFreeNotification(Self);
    FIntProject := Value;
    if FIntProject <> nil then
      FIntProject.FreeNotification(Self);

    if FForm <> nil then
      FForm.Perform(WM_DM_PROJECTCHANGED, 0, 0);
  end;
end;

procedure TDMProjectForm.ShowForm;
begin
  if (FApp <> nil) then
    FApp.ShowForm(Self);
end;

end.

