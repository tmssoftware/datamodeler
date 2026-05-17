unit fMenu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus, StdCtrls,
  ActnList, AdvMenus, AdvToolBar, AdvToolBarStylers, AdvMenuStylers, ImgList, ComCtrls, ExtCtrls,
  fProject, dMainActions, dgConsts, LangConst, AdvGlowButton, uDMApp,
  System.ImageList;

type
  TfmMenu = class(TForm)
    imlSmall: TImageList;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    sbBar: TStatusBar;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvToolBar2: TAdvToolBar;                      
    popNew: TAdvPopupMenu;
    New1: TMenuItem;
    Newfromanexistingdatabase1: TMenuItem;
    popReopen: TAdvPopupMenu;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Diagram1: TMenuItem;
    miProject: TMenuItem;
    ools1: TMenuItem;
    Help1: TMenuItem;
    New2: TMenuItem;
    Newfromanexistingdatabase2: TMenuItem;
    Open1: TMenuItem;
    miReopen: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Archiveversion1: TMenuItem;
    N2: TMenuItem;
    Report1: TMenuItem;
    Closeproject1: TMenuItem;
    Exit1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N3: TMenuItem;
    Deleteobjecttreeview1: TMenuItem;
    Deleteobjectdiagram1: TMenuItem;
    Removeobject1: TMenuItem;
    Selectall1: TMenuItem;
    Newtable1: TMenuItem;
    Newidentifyingrelationship1: TMenuItem;
    Newnonidentifyingrelationship1: TMenuItem;
    Newmanytomanyrelationship1: TMenuItem;
    Newselfrelationship1: TMenuItem;
    Newnote1: TMenuItem;
    Newstamp1: TMenuItem;
    N4: TMenuItem;
    Printdiagram1: TMenuItem;
    Exportimage1: TMenuItem;
    Generatedatabase1: TMenuItem;
    Checkvalidation1: TMenuItem;
    N5: TMenuItem;
    Newtable2: TMenuItem;
    Newrelationship1: TMenuItem;
    mnNewObjects: TMenuItem;
    Domains1: TMenuItem;
    Merge1: TMenuItem;
    Manageversions1: TMenuItem;
    Compareversions1: TMenuItem;
    Converttoanotherdatabase1: TMenuItem;
    Databaseconversions1: TMenuItem;
    Projectsettings1: TMenuItem;
    Databaseconnections1: TMenuItem;
    Environmentsettings1: TMenuItem;
    Help2: TMenuItem;
    AboutTMSDataModeler1: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    Addalltables1: TMenuItem;
    View1: TMenuItem;
    ProjectExplorer1: TMenuItem;
    MessagesWindow1: TMenuItem;
    DataTypeConversionMaps1: TMenuItem;
    N6: TMenuItem;
    N11: TMenuItem;
    miNewCategory1: TMenuItem;
    miNewCategory2: TMenuItem;
    miNewCategory3: TMenuItem;
    miNewCategory4: TMenuItem;
    miNewCategory5: TMenuItem;
    miNewCategory6: TMenuItem;
    miNewCategory7: TMenuItem;
    miNewCategory8: TMenuItem;
    miNewCategory9: TMenuItem;
    miNewCategory10: TMenuItem;
    AdvToolBar4: TAdvToolBar;
    AdvGlowButton1: TAdvGlowButton;
    btOpen: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvGlowButton6: TAdvGlowButton;
    AdvToolBar5: TAdvToolBar;
    AdvGlowButton7: TAdvGlowButton;
    AdvToolBar6: TAdvToolBar;
    AdvGlowButton8: TAdvGlowButton;
    AdvGlowButton4: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    AdvGlowButton10: TAdvGlowButton;
    AdvGlowButton11: TAdvGlowButton;
    AdvGlowButton12: TAdvGlowButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btOpenDropDown(Sender: TObject);
    procedure File1Click(Sender: TObject);
  private
    FActions: TdmMainActions;
    FDMProjectForm: TDMProjectForm;
    FRecentFiles: TStringList;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure WDMProjectChanged(var Msg: TMessage); message WM_DM_PROJECTCHANGED;
    function DMApp: TDMApplication;
    procedure RecentFileMenuClick(Sender: TObject);
    procedure UpdateStatusBar;
    procedure UpdateStatusBarDatabaseType;
    procedure UpdateVersionControlInfo;
    procedure BuildRecentFilesMenu(AParentMenu: TMenuItem);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor CreateFromDM(AProjectForm: TDMProjectForm);
    destructor Destroy; override;
    procedure InitiateAction; override;
    property DMProjectForm: TDMProjectForm read FDMProjectForm;
  end;

implementation

uses
  uAppRegistry, uAppUtils, uStrings;

{$R *.DFM}

procedure TfmMenu.WDMProjectChanged(var Msg: TMessage);
begin
  if (FDMProjectForm <> nil) and (FDMProjectForm.Project <> nil) then
  begin
    if FDMProjectForm.Project.Parent <> Self then
    begin
      FDMProjectForm.Project.BorderStyle := bsNone;
      FDMProjectForm.Project.BorderIcons := [];
      FDMProjectForm.Project.Parent := Self;
      FDMProjectForm.Project.Align := alClient;
      FDMProjectForm.Project.Visible := true;
    end;
  end;
end;

procedure TfmMenu.WMActivate(var Msg: TWMActivate);
var
    I: Integer;
    F: TForm;
begin
  inherited;
  if FDMProjectForm <> nil then
    FDMProjectForm.NotifyFormActivation;

  {Handle bug with modal windows. Without this code, the form will be in front of modal forms}
  for I:=0 to Screen.FormCount - 1 do
  begin
      F:=Screen.Forms[I];
      if (fsModal in F.FormState) and F.Enabled then
      begin
          if Assigned(F.ActiveControl) then
              PostMessage(F.Handle, WM_NEXTDLGCTL, F.ActiveControl.Handle, 1);
          break;
      end;
  end;
end;

procedure TfmMenu.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
  end;
end;

destructor TfmMenu.Destroy;
begin
  FRecentFiles.Free;
  inherited;
end;

function TfmMenu.DMApp: TDMApplication;
begin
  if DMProjectForm <> nil then
    result := DMProjectForm.App
  else
    result := nil;
end;

procedure TfmMenu.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMenu.btOpenDropDown(Sender: TObject);
begin
  BuildRecentFilesMenu(popReopen.Items);
end;

procedure TfmMenu.BuildRecentFilesMenu(AParentMenu: TMenuItem);
var
  c: Integer;
  MI: TMenuItem;
begin
  AParentMenu.Clear;
  if DMApp <> nil then
  begin
    DMRegistry.GetRecentFiles(FRecentFiles);
    for c := 0 to FRecentFiles.Count - 1 do
    begin
      if c > 9 then break;
      MI := TMenuItem.Create(Self);
      MI.Tag := c;
      MI.Caption := Format('%d %s', [c, FRecentFiles[c]]);
      MI.OnClick := RecentFileMenuClick;
      AParentMenu.Add(MI);
    end;
  end;
end;

constructor TfmMenu.CreateFromDM(AProjectForm: TDMProjectForm);
begin
  inherited Create(nil);
  FRecentFiles := TStringList.Create;
  FDMProjectForm := AProjectForm;
  FActions := TdmMainActions.Create(Self);
  FActions.DMProjectForm := FDMProjectForm;

  {Set all actions manually, because we can't trust on Delphi streaming system
   when we have more than one instance of TdmMainActions - it makes a confusion.
   Do not ever ever again, set actions through design time}
  AdvGlowButton1.Action := FActions.acFileNew;
  btOpen.Action := FActions.acFileOpen;
  AdvGlowButton3.Action := FActions.acFileSave;
  AdvGlowButton6.Action := FActions.acFileArchiveVersion;
  AdvGlowButton7.Action := FActions.acProjectCheck;
  AdvGlowButton4.Action := FActions.acProjectGenerate;
  AdvGlowButton5.Action := FActions.acProjectVersionsCompare;
  AdvGlowButton8.Action := FActions.acDiagramNewNote;
  AdvGlowButton10.Action := FActions.acDiagramNewRelationshipNonID;
  AdvGlowButton11.Action := FActions.acDiagramNewRelationshipID;
  AdvGlowButton12.Action := FActions.acDiagramNewTable;
  New1.Action := FActions.acFileNew;
  Newfromanexistingdatabase1.Action := FActions.acFileNewExisting;
  New2.Action := FActions.acFileNew;
  Newfromanexistingdatabase2.Action := FActions.acFileNewExisting;
  Open1.Action := FActions.acFileOpen;
  Save1.Action := FActions.acFileSave;
  Saveas1.Action := FActions.acFileSaveAs;
  Archiveversion1.Action := FActions.acFileArchiveVersion;
  //Report1.Action := FActions.acFileReport;
  Closeproject1.Action := FActions.acFileClose;
  Undo1.Action := FActions.acEditUndo;
  Redo1.Action := FActions.acEditRedo;
  Selectall1.Action := FActions.acEditSelectAll;
  ProjectExplorer1.Action := FActions.acViewExplorer;
  MessagesWindow1.Action := FActions.acViewMessages;
  Newtable1.Action := FActions.acDiagramNewTable;
  Newidentifyingrelationship1.Action := FActions.acDiagramNewRelationshipID;
  Newnonidentifyingrelationship1.Action := FActions.acDiagramNewRelationshipNonID;
  Newmanytomanyrelationship1.Action := FActions.acDiagramNewRelationshipMN;
  Newselfrelationship1.Action := FActions.acDiagramNewRelationshipSelf;
  Newnote1.Action := FActions.acDiagramNewNote;
  Newstamp1.Action := FActions.acDiagramNewStamp;
  Addalltables1.Action := FActions.acDiagramAllTables;
  Printdiagram1.Action := FActions.acDiagramPrint;
  Exportimage1.Action := FActions.acDiagramExport;
  Generatedatabase1.Action := FActions.acProjectGenerate;
  Checkvalidation1.Action := FActions.acProjectCheck;
  Newtable2.Action := FActions.acProjectNewTable;
  Newrelationship1.Action := FActions.acProjectNewRelationship;
  miNewCategory1.Action := FActions.acNewCategory1;
  miNewCategory2.Action := FActions.acNewCategory2;
  miNewCategory3.Action := FActions.acNewCategory3;
  miNewCategory4.Action := FActions.acNewCategory4;
  miNewCategory5.Action := FActions.acNewCategory5;
  miNewCategory6.Action := FActions.acNewCategory6;
  miNewCategory7.Action := FActions.acNewCategory7;
  miNewCategory8.Action := FActions.acNewCategory8;
  miNewCategory9.Action := FActions.acNewCategory9;
  miNewCategory10.Action := FActions.acNewCategory10;
  Domains1.Action := FActions.acProjectDomains;
  Merge1.Action := FActions.acProjectMerge;
  Manageversions1.Action := FActions.acProjectVersionsManage;
  Compareversions1.Action := FActions.acProjectVersionsCompare;
  Converttoanotherdatabase1.Action := FActions.acProjectConvert;
  Databaseconversions1.Action := FActions.acProjectConversionsXXXXXX;
  Projectsettings1.Action := FActions.acProjectSettings;
  Databaseconnections1.Action := FActions.acToolsConnections;
  Environmentsettings1.Action := FActions.acToolsSettings;
  DataTypeConversionMaps1.Action := FActions.acToolsConversionMaps;
  Help2.Action := FActions.acHelpHelp;
  AboutTMSDataModeler1.Action := FActions.acHelpAbout;
  Exit1.Action := FActions.acFileExit;
end;

procedure TfmMenu.File1Click(Sender: TObject);
begin
  BuildRecentFilesMenu(miReopen);
  miReopen.Enabled := miReopen.Count > 0;
end;

procedure TfmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {If there is a project, then close it - form will be closed automatically if needed}
  if (FDMProjectForm <> nil) then
    FDMProjectForm.CloseProject(false);
  Action := caFree;
end;

procedure TfmMenu.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  Caption := Format(SDBToolCaption, [GetDMVersion('%d.%d')]);

  {keep style color in the background}
  Self.Color := AdvToolBarOfficeStyler1.Color.Color;
end;

procedure TfmMenu.InitiateAction;
begin
  inherited;
  UpdateStatusBar;
end;

procedure TfmMenu.RecentFileMenuClick(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.OpenRecentFile(FRecentFiles[TMenuItem(Sender).Tag]);
end;

procedure TfmMenu.UpdateStatusBarDatabaseType;
begin
  if Assigned(FDMProjectForm) and Assigned(FDMProjectForm.Project) then
    sbBar.Panels[1].Text := 'Database type: ' + FDMProjectForm.Project.MetaData.DataDictionary.DatabaseType.DisplayName
  else
    sbBar.Panels[1].Text := '';
end;

procedure TfmMenu.UpdateVersionControlInfo;
begin
  if Assigned(FDMProjectForm) and Assigned(FDMProjectForm.Project) and FDMProjectForm.Project.MetaData.VersionControl.HasVersions then
  begin
    sbBar.Panels[2].Text := Format('Version: %d (under construction)',
      [FDMProjectForm.Project.MetaData.VersionControl.GetLastVersion.VersionID]);
  end else
    sbBar.Panels[2].Text := '';
end;

procedure TfmMenu.UpdateStatusBar;
begin
  UpdateVersionControlInfo;
  UpdateStatusBarDatabaseType;
end;

end.


