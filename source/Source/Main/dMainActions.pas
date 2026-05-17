unit dMainActions;

interface

uses
  Windows, SysUtils, Classes, Dialogs, Forms, Controls, ActnList, dgConsts, fProject, uDMApp,
  uDiagramClass, UITypes, System.Actions;

type
  TdmMainActions = class(TDataModule)
    ActionListMenu: TActionList;
    acFileNew: TAction;
    acEditUndo: TAction;
    acProjectGenerate: TAction;
    acToolsConnections: TAction;
    acHelpHelp: TAction;
    acHelpAbout: TAction;
    acFileNewExisting: TAction;
    acFileOpen: TAction;
    acFileSave: TAction;
    acFileSaveAs: TAction;                                       
    acFileArchiveVersion: TAction;
    acFileReport_dummy: TAction;
    acFileClose: TAction;
    acEditRedo: TAction;
    acEditSelectAll: TAction;
    acDiagramNewTable: TAction;
    acDiagramNewRelationshipID: TAction;
    acDiagramNewRelationshipNonID: TAction;
    acDiagramNewRelationshipMN: TAction;
    acDiagramNewRelationshipSelf: TAction;
    acDiagramNewNote: TAction;
    acDiagramNewStamp: TAction;
    acDiagramExport: TAction;
    acDiagramPrint: TAction;
    acProjectNewTable: TAction;
    acProjectNewRelationship: TAction;
    acProjectDomains: TAction;
    acProjectCheck: TAction;
    acProjectMerge: TAction;
    acProjectVersionsManage: TAction;
    acProjectVersionsCompare: TAction;
    acProjectConvert: TAction;
    acProjectConversionsXXXXXX: TAction;
    acProjectSettings: TAction;
    acToolsSettings: TAction;
    acDiagramAllTables: TAction;
    acViewExplorer: TAction;
    acViewMessages: TAction;
    acToolsConversionMaps: TAction;
    acNewCategory1: TAction;
    acNewCategory2: TAction;
    acNewCategory3: TAction;
    acNewCategory4: TAction;
    acNewCategory5: TAction;
    acNewCategory6: TAction;
    acNewCategory7: TAction;
    acNewCategory8: TAction;
    acNewCategory9: TAction;
    acNewCategory10: TAction;
    acCategoryNewProcedure: TAction;
    acCategoryNewView: TAction;
    acHelpHomePage: TAction;
    acFileExit: TAction;
    acWebUpdate: TAction;
    acDiagramPreview: TAction;
    acExportAurelius: TAction;
    acAssignedProject: TAction;
    acDiagramLayout: TAction;
    acScripting: TAction;
    procedure acFileCloseExecute(Sender: TObject);
    procedure acViewExplorerUpdate(Sender: TObject);
    procedure acViewMessagesUpdate(Sender: TObject);
    procedure acToolsConnectionsExecute(Sender: TObject);
    procedure acToolsSettingsExecute(Sender: TObject);
    procedure acViewExplorerExecute(Sender: TObject);
    procedure acViewMessagesExecute(Sender: TObject);
    procedure acProjectCheckExecute(Sender: TObject);
    procedure acProjectConvertExecute(Sender: TObject);
    procedure acProjectDomainsExecute(Sender: TObject);
    procedure acProjectGenerateExecute(Sender: TObject);
    procedure acProjectMergeExecute(Sender: TObject);
    procedure acProjectNewRelationshipExecute(Sender: TObject);
    procedure acProjectNewTableExecute(Sender: TObject);
    procedure acProjectSettingsExecute(Sender: TObject);
    procedure acProjectVersionsCompareExecute(Sender: TObject);
    procedure acProjectVersionsCompareUpdate(Sender: TObject);
    procedure acProjectVersionsManageExecute(Sender: TObject);
    procedure acProjectVersionsManageUpdate(Sender: TObject);
    procedure acToolsConversionMapsExecute(Sender: TObject);
    procedure acDiagramAllTablesExecute(Sender: TObject);
    procedure acDiagramExportExecute(Sender: TObject);
    procedure acDiagramNewNoteExecute(Sender: TObject);
    procedure acDiagramNewRelationshipIDExecute(Sender: TObject);
    procedure acDiagramNewTableExecute(Sender: TObject);
    procedure acDiagramNewTableUpdate(Sender: TObject);
    procedure acDiagramPrintExecute(Sender: TObject);
    procedure acEditSelectAllExecute(Sender: TObject);
    procedure acFileArchiveVersionExecute(Sender: TObject);
    procedure acFileNewExecute(Sender: TObject);
    procedure acFileNewExistingExecute(Sender: TObject);
    procedure acFileOpenExecute(Sender: TObject);
    procedure acFileSaveAsExecute(Sender: TObject);
    procedure acFileSaveExecute(Sender: TObject);
    procedure acFileSaveUpdate(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure ActionProjectAssignedUpdate(Sender: TObject);
    procedure NewCategoryActionExecute(Sender: TObject);
    procedure NewCategoryActionUpdate(Sender: TObject);
    procedure acFileArchiveVersionUpdate(Sender: TObject);
    procedure acCategoryNewProcedureUpdate(Sender: TObject);
    procedure acCategoryNewProcedureExecute(Sender: TObject);
    procedure acCategoryNewViewUpdate(Sender: TObject);
    procedure acCategoryNewViewExecute(Sender: TObject);
    procedure acHelpHomePageExecute(Sender: TObject);
    procedure acFileExitExecute(Sender: TObject);
    procedure acWebUpdateExecute(Sender: TObject);
    procedure acWebUpdateUpdate(Sender: TObject);
    procedure acHelpHelpExecute(Sender: TObject);
    procedure acHelpHelpUpdate(Sender: TObject);
    procedure acDiagramNewRelationshipIDUpdate(Sender: TObject);
    procedure acProjectNewRelationshipUpdate(Sender: TObject);
    procedure acToolsSettingsUpdate(Sender: TObject);
    procedure acDiagramPrintUpdate(Sender: TObject);
    procedure acDiagramPreviewExecute(Sender: TObject);
    procedure acDiagramPreviewUpdate(Sender: TObject);
    procedure acFileNewUpdate(Sender: TObject);
    procedure acFileNewExistingUpdate(Sender: TObject);
    procedure acFileOpenUpdate(Sender: TObject);
    procedure acHelpHomePageUpdate(Sender: TObject);
    procedure acExportAureliusExecute(Sender: TObject);
    procedure acAssignedProjectExecute(Sender: TObject);
    procedure acDiagramLayoutUpdate(Sender: TObject);
    procedure acDiagramLayoutExecute(Sender: TObject);
    procedure acScriptingExecute(Sender: TObject);
    procedure acScriptingUpdate(Sender: TObject);
  private
    FDMProjectForm: TDMProjectForm;
    function DMApp: TDMApplication;
    function GetCurrentProject: TfmProject;
    procedure ObjectActionExecute(ACatType: TGDAOCategoryType);
    procedure ObjectActionUpdate(AAction: TAction; ACatType: TGDAOCategoryType);
    function GetCurrentDiagram: TDiagramClass;
    procedure CheckArchivedVersionsFileName;
  public
    SaveCount: integer;
    ViewCount: integer;
    property CurrentProject: TfmProject read GetCurrentProject;
    property CurrentDiagram: TDiagramClass read GetCurrentDiagram;
    property DMProjectForm: TDMProjectForm read FDMProjectForm write FDMProjectForm;
  end;

implementation

uses
  uSystemClass, ShellApi, uDialogs, DateUtils, LangConst, fCompareProjects, uAppUtils,
  fAddVersion, fCompareVersion,
  uAppMetadata, uScripting, uConsts;

{$R *.dfm}

procedure TdmMainActions.NewCategoryActionExecute(Sender: TObject);
var
  idx: integer;
begin
  idx := TComponent(Sender).Tag - 1;
  if (idx >= 0) and (idx < CurrentProject.MetaData.DataDictionary.Categories.Count) then
    CurrentProject.AddDDItem(plObject,
      CurrentProject.MetaData.DataDictionary.Categories[idx]);
end;

procedure TdmMainActions.NewCategoryActionUpdate(Sender: TObject);
var
  idx: integer;
begin
  idx := TComponent(Sender).Tag - 1;
  if (CurrentProject <> nil) and (idx >= 0) and
    (idx < CurrentProject.MetaData.DataDictionary.Categories.Count) then
  begin
    TAction(Sender).Visible := true;
    TAction(Sender).Enabled := true;
    TAction(Sender).Caption :=
      'New ' + CurrentProject.MetaData.DataDictionary.Categories[idx].CategoryNameS;
  end
  else
  begin
    TAction(Sender).Visible := false;
    TAction(Sender).Enabled := false;
  end;
end;

procedure TdmMainActions.ObjectActionExecute(ACatType: TGDAOCategoryType);
begin
  CurrentProject.AddDDItem(plObject,
    CurrentProject.MetaData.DataDictionary.Categories.FindByType(ACatType));
end;

procedure TdmMainActions.ObjectActionUpdate(AAction: TAction; ACatType: TGDAOCategoryType);
begin
  AAction.Enabled := (CurrentProject <> nil) and
    (CurrentProject.MetaData.DataDictionary.Categories.FindByType(ACatType) <> nil);
end;

procedure TdmMainActions.acToolsConversionMapsExecute(Sender: TObject);
begin
  SystemConfig.ManageConversionMapsDlg;
end;

procedure TdmMainActions.acDiagramAllTablesExecute(Sender: TObject);
begin
  CurrentProject.AddAllTablesToDiagram;
end;

procedure TdmMainActions.acDiagramExportExecute(Sender: TObject);
begin
  CurrentProject.CurrentDiagramFrame.ExportImage;
end;

procedure TdmMainActions.acDiagramLayoutExecute(Sender: TObject);
begin
//  CurrentProject.CurrentDiagramFrame.AutoLayout(false);
end;

procedure TdmMainActions.acDiagramLayoutUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(CurrentProject) and Assigned(CurrentProject.CurrentDiagramFrame);
end;

procedure TdmMainActions.acDiagramNewNoteExecute(Sender: TObject);
begin
  CurrentProject.InsertDiagramNote;
end;

procedure TdmMainActions.acDiagramNewRelationshipIDExecute(Sender: TObject);
begin
  CurrentProject.InsertDiagramRelationship(TGDAORelationshipType(TAction(Sender).Tag));
end;

procedure TdmMainActions.acDiagramNewRelationshipIDUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=
    Assigned(CurrentProject) and
    Assigned(CurrentProject.CurrentDiagramFrame) and
    Assigned(CurrentProject.MetaData) and
    Assigned(CurrentProject.MetaData.DataDictionary) and
    Assigned(CurrentProject.MetaData.DataDictionary.DatabaseType) and
    CurrentProject.MetaData.DataDictionary.DatabaseType.EnableRelationships;
end;

procedure TdmMainActions.acDiagramNewTableExecute(Sender: TObject);
begin
  CurrentProject.InsertDiagramTable;
end;

procedure TdmMainActions.acDiagramNewTableUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(CurrentProject) and Assigned(CurrentProject.CurrentDiagramFrame);
end;

procedure TdmMainActions.acDiagramPreviewExecute(Sender: TObject);
begin
  CurrentProject.CurrentDiagramFrame.PrintSettings.Title :=
    ExtractFileName(ChangeFileExt(CurrentProject.MetaData.FileName, ''));
  CurrentProject.CurrentDiagramFrame.Preview;
end;

procedure TdmMainActions.acDiagramPreviewUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(CurrentProject) and Assigned(CurrentProject.CurrentDiagramFrame);
end;

procedure TdmMainActions.acDiagramPrintExecute(Sender: TObject);
begin
  CurrentProject.CurrentDiagramFrame.PrintSettings.Title :=
    ExtractFileName(ChangeFileExt(CurrentProject.MetaData.FileName, ''));
  CurrentProject.CurrentDiagramFrame.Print(true);
end;

procedure TdmMainActions.acDiagramPrintUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(CurrentProject) and Assigned(CurrentProject.CurrentDiagramFrame);
end;

procedure TdmMainActions.acEditSelectAllExecute(Sender: TObject);
begin
  CurrentProject.CurrentDiagramFrame.SelectAll;
end;

procedure TdmMainActions.acExportAureliusExecute(Sender: TObject);
begin
  CurrentProject.AureliusExport;
end;

procedure TdmMainActions.acFileArchiveVersionExecute(Sender: TObject);
begin
  with TfrmAddVersion.create(nil) do
  try
    AMD := CurrentProject.MetaData;
    if ShowModal = mrOk then
    begin
      CurrentProject.DoSave(CurrentProject.Metadata.FileName);
    end;
  finally
    Free;
  end;
end;

procedure TdmMainActions.acFileArchiveVersionUpdate(Sender: TObject);
begin
  acFileArchiveVersion.Enabled := (CurrentProject <> nil) and (CurrentProject.MetaData.FileName <> '');
end;

procedure TdmMainActions.acHelpAboutExecute(Sender: TObject);
begin
  ShowMessage(Format(
     '''
     Version %s
     (c) 2010-%s tmssoftware.com
     ''',
     [GetDMVersion('%d.%d.%d.%d'),
      IntToStr(YearOf(Now))]
  ));
end;

procedure TdmMainActions.acHelpHelpExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.ShowHelp;
end;

procedure TdmMainActions.acHelpHelpUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (DMApp <> nil);
end;

procedure TdmMainActions.acHelpHomePageExecute(Sender: TObject);
begin
  ShellExecute(0, 'open', DATAMODELER_SITE, nil, nil, SW_NORMAL);
end;

procedure TdmMainActions.acHelpHomePageUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := True;
end;

procedure TdmMainActions.acAssignedProjectExecute(Sender: TObject);
begin
//
end;

procedure TdmMainActions.acCategoryNewProcedureExecute(Sender: TObject);
begin
  ObjectActionExecute(ctProcedure);
end;

procedure TdmMainActions.acCategoryNewProcedureUpdate(Sender: TObject);
begin
  ObjectActionUpdate(TAction(Sender), ctProcedure);
end;

procedure TdmMainActions.acCategoryNewViewExecute(Sender: TObject);
begin
  ObjectActionExecute(ctView);
end;

procedure TdmMainActions.acCategoryNewViewUpdate(Sender: TObject);
begin
  ObjectActionUpdate(TAction(Sender), ctView);
end;

procedure TdmMainActions.acProjectCheckExecute(Sender: TObject);
begin
  CurrentProject.CheckIntegrity;
end;

procedure TdmMainActions.acProjectConvertExecute(Sender: TObject);
begin
  CurrentProject.ShowConvertDatabaseDlg;
end;

procedure TdmMainActions.acProjectDomainsExecute(Sender: TObject);
begin
  CurrentProject.DomainsDialog;
end;

procedure TdmMainActions.acProjectGenerateExecute(Sender: TObject);
begin
  if Assigned(CurrentProject) then
    CurrentProject.ShowGenerateScriptDialog;
end;

procedure TdmMainActions.acProjectMergeExecute(Sender: TObject);
begin
  if Assigned(CurrentProject) then
    with TfrmCompareProjects.Create(nil) do
    try
      DoCompareProjects(CurrentProject.MetaData);
    finally
      Free;
    end;
end;

procedure TdmMainActions.acProjectNewRelationshipExecute(Sender: TObject);
begin
  if Assigned(CurrentProject) then
    CurrentProject.AddDDItem(plRelationship);
end;

procedure TdmMainActions.acProjectNewRelationshipUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=
    (CurrentProject <> nil) and
    Assigned(CurrentProject.MetaData) and
    Assigned(CurrentProject.MetaData.DataDictionary) and
    Assigned(CurrentProject.MetaData.DataDictionary.DatabaseType) and
    CurrentProject.MetaData.DataDictionary.DatabaseType.EnableRelationships;
end;

procedure TdmMainActions.acProjectNewTableExecute(Sender: TObject);
begin
  if Assigned(CurrentProject) then
    CurrentProject.AddDDItem(plTable);
end;

procedure TdmMainActions.acProjectSettingsExecute(Sender: TObject);
begin
  if CurrentProject<>nil then
    CurrentProject.Configure;
end;

procedure TdmMainActions.acProjectVersionsCompareExecute(Sender: TObject);
begin
  if Assigned(CurrentProject) then
  begin
    with TfrmCompareVersion.Create(nil) do
    try
      AMD := CurrentProject.MetaData;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TdmMainActions.acProjectVersionsCompareUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(CurrentProject) and (CurrentProject.MetaData.VersionControl.Count > 1);
end;

procedure TdmMainActions.acProjectVersionsManageExecute(Sender: TObject);
begin
  if Assigned(CurrentProject) then
    CurrentProject.ShowManageVersionsDlg;
end;

procedure TdmMainActions.acProjectVersionsManageUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Assigned(CurrentProject) and CurrentProject.MetaData.VersionControl.HasVersions;
end;

procedure TdmMainActions.acScriptingExecute(Sender: TObject);
begin
  LaunchScriptingIDE(CurrentProject.MetaData.DataDictionary);
end;

procedure TdmMainActions.acScriptingUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentProject <> nil) and (CurrentProject.MetaData <> nil)
    and (CurrentProject.MetaData.DataDictionary <> nil);
end;

procedure TdmMainActions.ActionProjectAssignedUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrentProject <> nil;
end;

procedure TdmMainActions.acToolsConnectionsExecute(Sender: TObject);
begin
  SystemConfig.UserConnections.ManageConnectionsDlg;
end;

procedure TdmMainActions.acToolsSettingsExecute(Sender: TObject);
begin
  DMApp.EnvironmentOptionsDlg;
end;

procedure TdmMainActions.acToolsSettingsUpdate(Sender: TObject);
begin
  acToolsSettings.Enabled := DMApp <> nil;
end;

procedure TdmMainActions.acViewExplorerExecute(Sender: TObject);
begin
  if CurrentProject <> nil then
  begin
    if CurrentProject.IsExplorerPanelVisible then
      CurrentProject.HideExplorerPanel
    else
      CurrentProject.ShowExplorerPanel(false);
  end;
end;

procedure TdmMainActions.acViewExplorerUpdate(Sender: TObject);
begin
  acViewExplorer.Enabled := CurrentProject <> nil;
  acViewExplorer.Checked := (CurrentProject <> nil) and CurrentProject.IsExplorerPanelVisible;
  Inc(ViewCount);
end;

procedure TdmMainActions.acViewMessagesExecute(Sender: TObject);
begin
  if CurrentProject <> nil then
  begin
    if CurrentProject.IsMessagesPanelVisible then
      CurrentProject.HideMessagesPanel
    else
      CurrentProject.ShowMessagesPanel(false);
  end;
end;

procedure TdmMainActions.acViewMessagesUpdate(Sender: TObject);
begin
  acViewMessages.Enabled := CurrentProject <> nil;
  acViewMessages.Checked := (CurrentProject <> nil) and CurrentProject.IsMessagesPanelVisible;
end;

procedure TdmMainActions.acWebUpdateExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.Updater.CheckForUpdates;
end;

procedure TdmMainActions.acWebUpdateUpdate(Sender: TObject);
begin
  acWebUpdate.Enabled := True;
end;

procedure TdmMainActions.CheckArchivedVersionsFileName;
var
  amd: TAppMetaData;
  newFileName, archivedFileName, newArchivedFileName: string;
  i: integer;
  slFiles: TStringList;
  version: TVersion;

  function GetFileName(s: string): string;
  begin
    result := ExtractFileName(s);
    Delete(result, Length(result) - Length(ExtractFileExt(s)) + 1, MaxInt);
  end;

begin
  // check if saved project has archived versions and its filenames
  amd := CurrentProject.MetaData;
  newFileName := GetFileName(ExtractFileName(amd.FileName));
  slFiles := TStringList.Create;
  try
    for i := 0 to amd.VersionControl.Count - 1 do
    begin
      version := amd.VersionControl.Items[i];
      if version.FileName > '' then
      begin
        archivedFileName := GetFileName(version.AbsoluteFileName);
        if not SameText(newFileName, archivedFileName) and (slFiles.IndexOf(archivedFileName) < 0) then
          slFiles.Add(archivedFileName);
      end;
    end;
    if slFiles.Count > 0 then
    begin
      if MessageDlg(Format(
        'The saved project contains versions archived in different file names (%s). '+
        'Do you want to update the files to name "%s"?', [slFiles.CommaText, newFileName]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then
      begin
        for i := 0 to amd.VersionControl.Count - 1 do
        begin
          version := amd.VersionControl.Items[i];
          if version.FileName > '' then
          begin
            newArchivedFileName := ExtractFilePath(version.AbsoluteFileName) + newFileName + ExtractFileExt(version.AbsoluteFileName);
            if not FileExists(version.AbsoluteFileName) or CopyFile(PChar(version.AbsoluteFileName), PChar(newArchivedFileName), false)
            then
            begin
              version.FileName := ExtractFileName(newArchivedFileName);
              CurrentProject.SetModified;
            end;
          end;
        end;
      end;
    end;
  finally
    slFiles.Free;
  end;
end;

function TdmMainActions.GetCurrentDiagram: TDiagramClass;
begin
  if CurrentProject <> nil then
    result := CurrentProject.CurrentDiagramFrame
  else
    result := nil;
end;

function TdmMainActions.GetCurrentProject: TfmProject;
begin
  if FDMProjectForm <> nil then
    result := FDMProjectForm.Project
  else
    result := nil;
end;

function TdmMainActions.DMApp: TDMApplication;
begin
  if (FDMProjectForm <> nil) then
    result := FDMProjectForm.App
  else
    result := nil;
end;

procedure TdmMainActions.acFileCloseExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.CloseProject(FDMProjectForm, true);
end;

procedure TdmMainActions.acFileExitExecute(Sender: TObject);
begin
  if FDMProjectForm <> nil then
    FDMProjectForm.NotifyCloseAll;
end;

procedure TdmMainActions.acFileNewExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.NewProjectDlg(false);
end;

procedure TdmMainActions.acFileNewExistingExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.NewProjectDlg(true);
end;

procedure TdmMainActions.acFileNewExistingUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := True;
end;

procedure TdmMainActions.acFileNewUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := True;
end;

procedure TdmMainActions.acFileOpenExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.OpenProjectDlg;
end;

procedure TdmMainActions.acFileOpenUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := True;
end;

procedure TdmMainActions.acFileSaveExecute(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.SaveProjectDlg(FDMProjectForm);
end;

procedure TdmMainActions.acFileSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentProject <> nil) and (CurrentProject.Modified);
  Inc(SaveCount);
end;

procedure TdmMainActions.acFileSaveAsExecute(Sender: TObject);
begin
  if (DMApp <> nil) then
  begin
    if DMApp.SaveProjectAsDlg(FDMProjectForm) then
      CheckArchivedVersionsFileName;
  end;
end;

end.

