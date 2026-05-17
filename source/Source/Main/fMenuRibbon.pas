unit fMenuRibbon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Menus, StdCtrls, ActnList,
  dMainActions, dDiagramOptions, uDMApp, LangConst, dgConsts, Dialogs, AdvToolBar,
  AdvToolBarStylers, AdvPreviewMenu, AdvPreviewMenuStylers, AdvShapeButton, AdvOfficeStatusBar,
  AdvOfficeStatusBarStylers, AdvGlowButton, AdvSelectors, AdvMenus, AdvOfficeButtons,
  AdvOfficeSelectors, ImgList, AdvOfficePager, AdvOfficeComboBox, AdvStyleIF, AdvGdip,
  GDIPPictureContainer, AdvGDIPicture, DgrCombo, System.ImageList;

type
  TfmMenuRibbon = class(TAdvToolBarForm)
    AdvPager: TAdvToolBarPager;
    pgHome: TAdvPage;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvShapeButton1: TAdvShapeButton;
    PrevMenu: TAdvPreviewMenu;
    AdvPreviewMenuOfficeStyler1: TAdvPreviewMenuOfficeStyler;
    sbBar: TAdvOfficeStatusBar;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    AdvQuickAccessToolBar: TAdvQuickAccessToolBar;
    btQuickSave: TAdvGlowButton;
    AdvToolBar1: TAdvToolBar;                             
    btGenerate: TAdvGlowButton;
    btCheck: TAdvGlowButton;
    pgDiagram: TAdvPage;
    AdvToolBar2: TAdvToolBar;
    btDiagAddTable: TAdvGlowButton;
    btDiagAddIdRel: TAdvGlowButton;
    btDiagAddNote: TAdvGlowButton;
    btDiagAddNonIDRel: TAdvGlowButton;
    AdvToolBar3: TAdvToolBar;
    btVersionArchive: TAdvGlowButton;
    btVersionCompare: TAdvGlowButton;
    btVersionManage: TAdvGlowButton;
    AdvToolBar4: TAdvToolBar;
    btNewTable: TAdvGlowButton;
    btNewRelationship: TAdvGlowButton;
    btNewObject: TAdvGlowButton;
    btNewView: TAdvGlowButton;
    btNewProcedure: TAdvGlowButton;
    pmObjects: TAdvPopupMenu;
    AdvToolBar5: TAdvToolBar;
    btViewMessages: TAdvGlowButton;
    btViewExplorer: TAdvGlowButton;
    AdvPage3: TAdvPage;
    toolbarDM: TAdvToolBar;
    btAbout: TAdvGlowButton;
    btManual: TAdvGlowButton;
    btHomePage: TAdvGlowButton;
    AdvPage4: TAdvPage;
    AdvToolBar7: TAdvToolBar;
    btToolsConnections: TAdvGlowButton;
    btToolsConversionMaps: TAdvGlowButton;
    btQuickOpen: TAdvGlowButton;
    btQuickNew: TAdvGlowButton;
    btProjectMerge: TAdvGlowButton;
    AdvToolBar8: TAdvToolBar;
    btProjectConvert: TAdvGlowButton;
    btProjectSettings: TAdvGlowButton;
    btProjectDomains: TAdvGlowButton;
    pmNew: TAdvPopupMenu;
    miNewProject: TMenuItem;
    miNewExisting: TMenuItem;
    btWebUpdate: TAdvGlowButton;
    AdvToolBar9: TAdvToolBar;
    btDiagPreview: TAdvGlowButton;
    barPageSetup: TAdvToolBar;
    btDiagPageOrientation: TAdvOfficeToolSelector;
    imOrientation: TImageList;
    btDiagPaperSize: TAdvOfficeToolSelector;
    btDiagExport: TAdvGlowButton;
    barDiagShape: TAdvToolBar;
    btDiagFontName: TAdvOfficeFontSelector;
    btDiagFontSize: TAdvOfficeFontSizeSelector;
    btDiagShapeColor: TAdvOfficeColorSelector;
    gdipicon: TAdvGDIPPicture;
    btDiagTextColor: TAdvOfficeColorSelector;
    AdvToolBar6: TAdvToolBar;
    btProjectAureliusExport: TAdvGlowButton;
    AdvToolBar10: TAdvToolBar;
    btDiagFind: TAdvGlowButton;
    btDiagDuplicate: TAdvGlowButton;
    AdvToolBar11: TAdvToolBar;
    btDiagNavigator: TAdvGlowButton;
    AdvToolBar12: TAdvToolBar;
    btDiagFitAll: TAdvGlowButton;
    btDiagZoom100: TAdvGlowButton;
    edDiagZoom: TDgrZoomSelector;
    btQuickClose: TAdvGlowButton;
    btScripting: TAdvGlowButton;
    ColorDialog1: TColorDialog;
    btDiagPrint: TAdvGlowButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AdvShapeButton1Click(Sender: TObject);
    procedure AdvShapeButton1DblClick(Sender: TObject);
    procedure AdvPagerMinButtonClick(Sender: TObject);
    procedure btDiagPageOrientationSelect(Sender: TObject; Index: Integer; Item: TAdvSelectorItem);
    procedure barPageSetupOptionClick(Sender: TObject; ClientPoint, ScreenPoint: TPoint);
    procedure btDiagPaperSizeSelect(Sender: TObject; Index: Integer; Item: TAdvSelectorItem);
    procedure btDiagShapeColorSelectColor(Sender: TObject; AColor: TColor);
    procedure btDiagFontNameSelectFontName(Sender: TObject; AName: string);
    procedure btDiagFontSizeSelectFontSize(Sender: TObject; ASize: Integer);
    procedure btDiagOutlineColorSelectColor(Sender: TObject; AColor: TColor);
    procedure btDiagTextColorSelectColor(Sender: TObject; AColor: TColor);
    procedure FormShow(Sender: TObject);
  private
    FActions: TdmMainActions;
    FDiagramActions: TdmDiagramOptions;
    FDMProjectForm: TDMProjectForm;
    FRecentFiles: TStringList;
    FPaperSizeLastPrinterIndex: integer;
    FPaperSizeLastPaperID: integer;
    FPaperSizeLastUnit: integer;
    FFormSizeCreated: Boolean;
    procedure WMSyscommand(Var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure WDMProjectChanged(var Msg: TMessage); message WM_DM_PROJECTCHANGED;
    procedure WDMProjectSaved(var Msg: TMessage); message WM_DM_PROJECTSAVED;
    procedure WDMDiagramPopupMenu(var Msg: TMessage); message WM_DM_DIAGRAMPOPUPMENU;
    procedure WDMDPageSetupDlg(var Msg: TMessage); message WM_DM_DIAGRAMPAGESETUPDLG;
    procedure WDMCloseAll(var Msg: TMessage); message WM_DM_CLOSE_ALL;
    procedure UpdateStatusBar;
    procedure UpdateStatusBarDatabaseType;
    procedure UpdateVersionControlInfo;
    procedure UpdatePageSelectors;
    procedure UpdateShapeSelectors;
    procedure UpdateZoomSelectors;
    procedure InitShapeSelectors;
    function MainMenuFromName(AName: string): TAdvPreviewMenuItem;
    function SubMenuFromName(MI: TAdvPreviewMenuItem; AName: string): TAdvPreviewSubMenuItem;
//    function MenuButtonFromName(AName: string): TButtonCollectionItem;
    procedure AssignMainMenuAction(AMenuName: string; AAction: TAction);
//    procedure AssignMenuButtonAction(AButtonName: string; AAction: TAction);
    procedure AssignMenuAction(AMenu: TMenuItem; AAction: TAction);
    procedure AssignButtonAction(AButton: TAdvGlowButton; AAction: TAction);
    //procedure AssignCheckAction(ACheck: TAdvOfficeCheckBox; AAction: TAction);
    procedure UpdateFormCaption;
    procedure UpdateObjectsMenu;
    procedure UpdateDiagramRibbonTab;
    procedure UpdateAppIcon;
    procedure pmObjectsMenuClick(Sender: TObject);
    function DMApp: TDMApplication;
    procedure BuildRecentFilesMenu;
    procedure RecentFileMenuClick(Sender: TObject);
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
  uAppRegistry, uStrings, uGDAO, fProject, atDiagram, Math, uDiagramClass, uAppMetaData, uAppUtils;

{$R *.dfm}

{ TfmMenuRibbon }

procedure TfmMenuRibbon.AdvPagerMinButtonClick(Sender: TObject);
begin
  WindowState := wsMinimized;
end;

procedure TfmMenuRibbon.AdvShapeButton1Click(Sender: TObject);
begin
  BuildRecentFilesMenu;
end;

procedure TfmMenuRibbon.AdvShapeButton1DblClick(Sender: TObject);
begin
  FActions.acFileExit.Execute;
end;

procedure TfmMenuRibbon.AssignButtonAction(AButton: TAdvGlowButton; AAction: TAction);
var
  ACaption: string;
begin
  ACaption := AButton.Caption;
  AButton.Action := AAction;
  AButton.Caption := ACaption;
end;

{procedure TfmMenuRibbon.AssignCheckAction(ACheck: TAdvOfficeCheckBox;
  AAction: TAction);
var
  ACaption: string;
begin
  ACaption := ACheck.Caption;
  ACheck.Action := AAction;
  ACheck.Caption := ACaption;
end;}

procedure TfmMenuRibbon.AssignMainMenuAction(AMenuName: string; AAction: TAction);
var
  MI: TAdvPreviewMenuItem;
  ASubName: string;
  SM: TAdvPreviewSubMenuItem;
  ACaption: string;
  P: integer;
begin
  P := Pos('|', AMenuName);
  if P > 0 then
  begin
    ASubName := Copy(AMenuName, P + 1, MaxInt);
    AMenuName := Copy(AMenuName, 1, P - 1);
    MI := MainMenuFromName(AMenuName);
    SM := SubMenuFromName(MI, ASubName);
    ACaption := SM.Title;
    SM.Action := AAction;
    SM.Title := ACaption;
  end
  else
  begin
    {Do not check for MI assigned in further operations. Let it raise an error so we will find
     wrongly referenced menu items}
    MI := MainMenuFromName(AMenuName);

    {Only assign onclick and the update events. Do not assign caption or other visual properties,
     that's why we're assigning action manually.
     So, save the caption and then put it back after action is assigned, this way
     we keep the caption specified at design-time in the ribbon (not in the action)}
    ACaption := MI.Caption;
    MI.Action := AAction;
    MI.Caption := ACaption;
  end;
end;

procedure TfmMenuRibbon.AssignMenuAction(AMenu: TMenuItem; AAction: TAction);
var
  ACaption: string;
begin
  ACaption := AMenu.Caption;
  AMenu.Action := AAction;
  AMenu.Caption := ACaption;
end;

//procedure TfmMenuRibbon.AssignMenuButtonAction(AButtonName: string;
//  AAction: TAction);
//var
//  MB: TButtonCollectionItem;
//  ACaption: string;
//begin
//  MB := MenuButtonFromName(AButtonName);
//
//  ACaption := MB.Caption;
//  MB.Action := AAction;
//  MB.Caption := ACaption;
//end;

procedure TfmMenuRibbon.barPageSetupOptionClick(Sender: TObject; ClientPoint,
  ScreenPoint: TPoint);
begin
  if FActions.CurrentDiagram <> nil then
    {See btDiagPaperSizeSelect for information why using messages. We don't need
     to use message here, but we will use it just to make all calls standard}
    PostMessage(Handle, WM_DM_DIAGRAMPAGESETUPDLG, 0, 0)
end;

procedure TfmMenuRibbon.btDiagPageOrientationSelect(Sender: TObject;
  Index: Integer; Item: TAdvSelectorItem);
begin
  if FActions.CurrentDiagram <> nil then
  begin
    case Index of
      1: FActions.CurrentDiagram.PageSettings.Orientation := dpoLandscape;
    else
      FActions.CurrentDiagram.PageSettings.Orientation := dpoPortrait;
    end;
    FActions.CurrentDiagram.Invalidate;
  end;
end;

procedure TfmMenuRibbon.btDiagPaperSizeSelect(Sender: TObject; Index: Integer;
  Item: TAdvSelectorItem);
begin
  FPaperSizeLastPaperID := -1; //forces update of selection for next drop down
  if (FActions.CurrentDiagram <> nil) and (Item <> nil) then
  begin
    if Item.Value = '-1' then
      {we must post a message instead of calling dialog directly, to work around a bug
       in tms selector. If we call dialog directly, the modal dialog will be hidden
       by the main form}
      PostMessage(Handle, WM_DM_DIAGRAMPAGESETUPDLG, 0, 0)
    else
      FActions.CurrentDiagram.PageSettings.ChangePaperID(
        StrToInt(Item.Value));
    FActions.CurrentDiagram.Invalidate;
  end;
end;

procedure TfmMenuRibbon.btDiagShapeColorSelectColor(Sender: TObject; AColor: TColor);
begin
  if FDiagramActions <> nil then
    FDiagramActions.SelectShapeColor(AColor);
end;

procedure TfmMenuRibbon.btDiagTextColorSelectColor(Sender: TObject; AColor: TColor);
begin
  if FDiagramActions <> nil then
    FDiagramActions.SelectTextColor(AColor);
end;

procedure TfmMenuRibbon.btDiagFontNameSelectFontName(Sender: TObject;
  AName: string);
begin
  if FDiagramActions <> nil then
    FDiagramActions.SelectObjectFontName(AName);
end;

procedure TfmMenuRibbon.btDiagFontSizeSelectFontSize(Sender: TObject;
  ASize: Integer);
begin
  if FDiagramActions <> nil then
    FDiagramActions.SelectObjectFontSize(ASize);
end;

procedure TfmMenuRibbon.btDiagOutlineColorSelectColor(Sender: TObject; AColor: TColor);
begin
  if FDiagramActions <> nil then
    FDiagramActions.SelectOutlineColor(AColor);
end;

constructor TfmMenuRibbon.CreateFromDM(AProjectForm: TDMProjectForm);
begin
  inherited Create(nil);
  FPaperSizeLastPrinterIndex := -1;
  FRecentFiles := TStringList.Create;
  FDMProjectForm := AProjectForm;
  FActions := TdmMainActions.Create(Self);
  FActions.DMProjectForm := FDMProjectForm;
  FDiagramActions := TdmDiagramOptions.Create(Self);
  FDiagramActions.DMProjectForm := FDMProjectForm;

  {Application Menu}
  AssignMainMenuAction('New|New Project', FActions.acFileNew);
  AssignMainMenuAction('New|Import From Database', FActions.acFileNewExisting);

  AssignMainMenuAction('Open', FActions.acFileOpen);
  AssignMainMenuAction('Save', FActions.acFileSave);
  AssignMainMenuAction('Save As', FActions.acFileSaveAs);
  AssignMainMenuAction('Archive Version', FActions.acFileArchiveVersion);
  AssignMainMenuAction('Close', FActions.acFileClose);
  AssignMainMenuAction('Export', FActions.acAssignedProject);
  AssignMainMenuAction('Export|Delphi (TMS Aurelius)', FActions.acExportAurelius);
  AssignMainMenuAction('Exit', FActions.acFileExit);
  AssignMainMenuAction('Options', FActions.acToolsSettings);

  AssignMenuAction(miNewProject, FActions.acFileNew);
  AssignMenuAction(miNewExisting, FActions.acFileNewExisting);

  {Quick toolbar}
  AssignButtonAction(btQuickNew, FActions.acFileNew);
  AssignButtonAction(btQuickOpen, FActions.acFileOpen);
  AssignButtonAction(btQuickSave, FActions.acFileSave);
  AssignButtonAction(btQuickClose, FActions.acFileClose);

  {Ribbon controls}
  AssignButtonAction(btGenerate, FActions.acProjectGenerate);
  AssignButtonAction(btCheck, FActions.acProjectCheck);
  AssignButtonAction(btProjectDomains, FActions.acProjectDomains);
  AssignButtonAction(btProjectConvert, FActions.acProjectConvert);
  AssignButtonAction(btProjectMerge, FActions.acProjectMerge);
  AssignButtonAction(btProjectSettings, FActions.acProjectSettings);
  AssignButtonAction(btScripting, FActions.acScripting);

  AssignButtonAction(btNewTable, FActions.acProjectNewTable);
  AssignButtonAction(btNewRelationship, FActions.acProjectNewRelationship);
  AssignButtonAction(btNewProcedure, FActions.acCategoryNewProcedure);
  AssignButtonAction(btNewView, FActions.acCategoryNewView);

  AssignButtonAction(btDiagAddTable, FActions.acDiagramNewTable);
  AssignButtonAction(btDiagAddIdRel, FActions.acDiagramNewRelationshipID);
  AssignButtonAction(btDiagAddNonIdRel, FActions.acDiagramNewRelationshipNonID);
  AssignButtonAction(btDiagAddNote, FActions.acDiagramNewNote);
  AssignButtonAction(btDiagPreview, FActions.acDiagramPreview);
  AssignButtonAction(btDiagPrint, FActions.acDiagramPrint);
  AssignButtonAction(btDiagExport, FActions.acDiagramExport);
  AssignButtonAction(btDiagFind, FDiagramActions.acDiagram_Find);
  AssignButtonAction(btDiagDuplicate, FDiagramActions.acDiagram_Duplicate);
  AssignButtonAction(btDiagNavigator, FDiagramActions.acDiagram_Navigator);

  AssignButtonAction(btDiagZoom100, FDiagramActions.acDiagram_ZoomTo100);
  AssignButtonAction(btDiagFitAll, FDiagramActions.acDiagram_ZoomToFit);

  AssignButtonAction(btVersionCompare, FActions.acProjectVersionsCompare);
  AssignButtonAction(btVersionArchive, FActions.acFileArchiveVersion);
  AssignButtonAction(btVersionManage, FActions.acProjectVersionsManage);

  AssignButtonAction(btViewExplorer, FActions.acViewExplorer);
  AssignButtonAction(btViewMessages, FActions.acViewMessages);

  AssignButtonAction(btToolsConnections, FActions.acToolsConnections);
  AssignButtonAction(btToolsConversionMaps, FActions.acToolsConversionMaps);
  AssignButtonAction(btProjectAureliusExport, FActions.acExportAurelius);

  AssignButtonAction(btAbout, FActions.acHelpAbout);
  AssignButtonAction(btManual, FActions.acHelpHelp);
  AssignButtonAction(btWebUpdate, FActions.acWebUpdate);
  AssignButtonAction(btHomePage, FActions.acHelpHomePage);

  AdvPager.ActivePageIndex := 0;

  InitShapeSelectors;
end;

procedure TfmMenuRibbon.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := ExStyle or WS_EX_APPWINDOW;
//    WndParent := GetDesktopwindow;
    WndParent := 0;
  end;
end;

destructor TfmMenuRibbon.Destroy;
begin
  FRecentFiles.Free;
  inherited;
end;

procedure TfmMenuRibbon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {If there is a project, then close it - form will be closed automatically if needed}
  if (FDMProjectForm <> nil) then
  begin
    FDMProjectForm.CloseProject(false);
    FDMProjectForm := nil;
  end;
  Action := caFree;
end;

type
  TInternalShapeButton = class(TAdvShapeButton)
  end;

procedure TfmMenuRibbon.FormCreate(Sender: TObject);
begin
  FFormSizeCreated := false;
  if Screen.PixelsPerInch <> PixelsPerInch then
    ScaleBy(Screen.PixelsPerInch, PixelsPerInch);

  TInternalShapeButton(AdvShapeButton1).IsDataModeler := True;
  pgDiagram.TabVisible := false;
  UpdateFormCaption;
  UpdateAppIcon;

  {keep style color in the background}
  Self.Color := AdvToolBarOfficeStyler1.Color.Color;

  SingleBorder := True;

  AdvQuickAccessToolBar.App.Picture.LoadFromResourceName(HInstance, 'DM_QAT_16');
end;

procedure TfmMenuRibbon.FormShow(Sender: TObject);
begin
  if not FFormSizeCreated then
  begin
    FFormSizeCreated := true;
    CreateFormSize(Self);
  end;
end;

procedure TfmMenuRibbon.InitiateAction;
begin
  inherited;
  UpdateStatusBar;
  UpdateObjectsMenu;
  UpdateDiagramRibbonTab;
  UpdateZoomSelectors;
  UpdatePageSelectors;
  UpdateShapeSelectors;
end;

procedure TfmMenuRibbon.InitShapeSelectors;
begin
  btDiagShapeColor.SelectedColor := clWhite;
  if btDiagShapeColor.Tools.Count > 0 then
  begin
    btDiagShapeColor.Tools[0].Caption := 'Default';
    btDiagShapeColor.Tools[0].BackgroundColor := clWhite;
  end;

  btDiagTextColor.SelectedColor := clBlack;
  if btDiagTextColor.Tools.Count > 0 then
  begin
    btDiagTextColor.Tools[0].Caption := 'Default';
    btDiagTextColor.Tools[0].BackgroundColor := clBlack;
  end;

  btDiagFontName.SetComponentStyle(tsOffice2003Blue);
  btDiagFontName.Text := 'Tahoma';

  btDiagFontSize.SetComponentStyle(tsOffice2003Blue);
  btDiagFontSize.Text := '';
end;

//function TfmMenuRibbon.MenuButtonFromName(AName: string): TButtonCollectionItem;
//var
//  c: integer;
//begin
//  result := nil;
//  for c := 0 to PrevMenu.Buttons.Count - 1 do
//    if SameText(AName, PrevMenu.Buttons[c].Caption) then
//    begin
//      result := PrevMenu.Buttons[c];
//      break;
//    end;
//end;

function TfmMenuRibbon.MainMenuFromName(AName: string): TAdvPreviewMenuItem;
var
  c: integer;
begin
  result := nil;
  for c := 0 to PrevMenu.MenuItems.Count - 1 do
    if SameText(AName, PrevMenu.MenuItems[c].Caption) then
    begin
      result := PrevMenu.MenuItems[c];
      break;
    end;
end;

procedure TfmMenuRibbon.pmObjectsMenuClick(Sender: TObject);
begin
  if (DMProjectForm <> nil) and (DMProjectForm.Project <> nil) then
  begin
    if TMenuItem(Sender).Tag < DMprojectForm.Project.MetaData.DataDictionary.Categories.Count then
    begin
      DMProjectForm.Project.AddDDItem(plObject,
        DMprojectForm.Project.MetaData.DataDictionary.Categories[TMenuItem(Sender).Tag]);
    end;
  end;
end;

function TfmMenuRibbon.DMApp: TDMApplication;
begin
  if DMProjectForm <> nil then
    result := DMProjectForm.App
  else
    result := nil;
end;

procedure TfmMenuRibbon.BuildRecentFilesMenu;

  function BuildRecentName(AFile: string): string;
  const
    MaxL = 35;
  var
    AShort: string;
    APath: string;
  begin
    if Length(AFile) <= MaxL then
      result := AFile
    else
    begin
      AShort := ExtractFileName(AFile);
      if Length(AShort) > MaxL then
        result := Copy(AShort, 1, MaxL) + '...'
      else
      begin
        APath := Copy(AFile, 1, MaxL - Length(AShort));
        while (Length(APath) > 0) and (APath[Length(APath)] <> '\') do
          APath := Copy(APath, 1, Length(APath) - 1);
        if APath > '' then
          result := APath + '...\' + AShort
        else
          result := AShort;
      end;
    end;
  end;

var
  c: Integer;
  MI: TAdvPreviewSubMenuItem;
  RecentName: string;
begin
  PrevMenu.SubMenuItems.Clear;
  DMRegistry.GetRecentFiles(FRecentFiles);
  for c := 0 to FRecentFiles.Count - 1 do
  begin
    if c > 9 then break;
    MI := PrevMenu.SubMenuItems.Add;
    MI.Tag := c;
    MI.ShortCutHint := IntToStr(c);
    RecentName := BuildRecentName(FRecentFiles[c]);
    MI.Title := Format('  &%d   %s', [c, RecentName]);
    if RecentName <> FRecentFiles[c] then
    begin
      MI.OfficeHint.Title := FRecentFiles[c];
    end;
    MI.OnClick := RecentFileMenuClick;
  end;
end;

procedure TfmMenuRibbon.RecentFileMenuClick(Sender: TObject);
begin
  if DMApp <> nil then
    DMApp.OpenRecentFile(FRecentFiles[TAdvPreviewSubMenuItem(Sender).Tag]);
end;

function TfmMenuRibbon.SubMenuFromName(MI: TAdvPreviewMenuItem; AName: string): TAdvPreviewSubMenuItem;
var
  c: Integer;
begin
  result := nil;
  for c := 0 to MI.SubItems.Count - 1 do
  if SameText(AName, MI.SubItems[c].Title) then
  begin
    result := MI.SubItems[c];
    break;
  end;
end;

procedure TfmMenuRibbon.UpdateAppIcon;
begin
  AdvPager.QuickAccessToolBar.App.Picture.Assign(gdipicon.Picture);
end;

procedure TfmMenuRibbon.UpdateDiagramRibbonTab;
begin
  if (DMProjectForm <> nil) and (DMProjectForm.Project <> nil) and
    (DMProjectForm.Project.CurrentDiagramFrame <> nil) then
  begin
    {if diagram tab was not visible, make it visible and focus it}
    if not pgDiagram.TabVisible then
    begin
      pgDiagram.TabVisible := true;
      AdvPager.ActivePage := pgDiagram;
    end;
  end
  else
  begin
    if pgDiagram.TabVisible then
    begin
      {if we must hide the diagram tab and the diagram tab IS selected,
       then we must go to the Home tab. Otherwise, keep the currently
       selected tab}
      if AdvPager.ActivePage = pgDiagram then
        AdvPager.ActivePage := pgHome;
      pgDiagram.TabVisible := false;
    end;
  end;
end;

procedure TfmMenuRibbon.UpdateFormCaption;
begin
  if (DMProjectForm <> nil) and (DMProjectForm.Project <> nil)
    and (ExtractFileName(DMProjectForm.Project.MetaData.FileName) <> '') then
    Caption := Format('%s - %s',
      [ExtractFileName(DMProjectForm.Project.MetaData.FileName), SDBToolCaption])
  else
    Caption := Format(SDBToolCaption, []);

  AdvPager.Caption.Caption := Caption;
end;

procedure TfmMenuRibbon.UpdateObjectsMenu;
var
  c: integer;
  Ok: boolean;
  Cats: TGDAOCategories;
begin
  if (DMProjectForm <> nil) and (DMProjectForm.Project <> nil) then
  begin
    Ok := false;
    Cats := DMProjectForm.Project.MetaData.DataDictionary.Categories;
    for c := 0 to pmObjects.Items.Count - 1 do
    begin
      pmObjects.Items[c].OnClick := pmObjectsMenuClick;
      pmObjects.Items[c].Tag := c;
      pmObjects.Items[c].Visible :=
        (c < Cats.Count) and
        (Cats[c].CategoryType <> ctProcedure) and
        (Cats[c].CategoryType <> ctView);
      if pmObjects.Items[c].Visible then
      begin
        Ok := true;
        pmObjects.Items[c].Caption := Cats[c].CategoryNameS;
      end;
    end;
    btNewObject.Enabled := Ok;
  end else
  begin
    for c := 0 to pmObjects.Items.Count - 1 do
      pmObjects.Items[c].Visible := false;
    btNewObject.Enabled := false;
  end;
end;                                         

procedure TfmMenuRibbon.UpdatePageSelectors;

  function BuildPaperCaption(AName: string; W, H: extended): string;
  var
    dgr: TDiagramClass;
  begin
    dgr := FActions.CurrentDiagram;
    if dgr <> nil then
    begin
      result := Format('%s   (%s %s x %s %s)', [
        AName,
        FormatFloat('0.##', dgr.MMToMeasUnit(W)),
        dgr.UnitSymbol,
        FormatFloat('0.##', dgr.MMToMeasUnit(H)),
        dgr.UnitSymbol
        ]);
    end
      else result := AName;
  end;

var
  selOr: integer;
  selPaperID: integer;
  diagramOk: boolean;
  c: integer;
  tool: TAdvSelectorItem;
  prn: TDiagramPrinter;
begin
  diagramOk := (FActions.CurrentDiagram <> nil);

  {Update toolbar}
  if diagramOK <> barPageSetup.Enabled then
    barPageSetup.Enabled := diagramOk;

  {Update Page Orientation}
  btDiagPageOrientation.Enabled := diagramOk;
  if diagramOk then
  begin
    case FActions.CurrentDiagram.PageSettings.Orientation of
      dpoLandscape: selOr := 1;
    else
      selOr := 0;
    end;
    if selOr <> btDiagPageOrientation.SelectedIndex then
      btDiagPageOrientation.SelectedIndex := selOr;
  end;

  {Update Paper Size}
  btDiagPaperSize.Enabled := diagramOk;
  if diagramOk then
  begin
    prn := FActions.CurrentDiagram.DPrinter;

    {only updates the component is the printer or paper size has changed}
    if (FPaperSizeLastPrinterIndex <> (atDiagram.DPrinters.PrinterIndex)) or
      (FPaperSizeLastPaperID <> (FActions.CurrentDiagram.PageSettings.PaperID)) or
      (FPaperSizeLastUnit <> Ord(FActions.CurrentDiagram.MeasUnit)) then
    begin
      selPaperID := -1;
      btDiagPaperSize.Tools.Clear;
      if prn = nil then Exit;
      
      for c  := 0 to Min(prn.PaperCount, 15) - 1 do
      begin
        tool := btDiagPaperSize.Tools.Add;
        tool.Caption := BuildPaperCaption(prn.Papers[c].PaperName,
          prn.Papers[c].PaperWidth, prn.Papers[c].PaperHeight);
        tool.Value := IntToStr(prn.Papers[c].PaperID);
        if prn.Papers[c].PaperID = FActions.CurrentDiagram.PageSettings.PaperID then
          selPaperID := c;
      end;

      {if the paper is not in the limited list, then add the selected paper}
      if selPaperID = -1 then
      begin
        tool := btDiagPaperSize.Tools.Add;
        tool.Caption := BuildPaperCaption(FActions.CurrentDiagram.PageSettings.PaperName,
          FActions.CurrentDiagram.PageSettings.PaperWidth,
          FActions.CurrentDiagram.PageSettings.PaperHeight);
        tool.Value := IntToStr(FActions.CurrentDiagram.PageSettings.PaperID);
        selPaperID := tool.Index;
      end;

      tool := btDiagPaperSize.Tools.Add;
      tool.Caption := 'More Paper Sizes...';
      tool.Value := '-1';

      btDiagPaperSize.SelectedIndex := selPaperID;

      FPaperSizeLastPrinterIndex := atDiagram.DPrinters.PrinterIndex;
      FPaperSizeLastPaperID := FActions.CurrentDiagram.PageSettings.PaperID;
      FPaperSizeLastUnit := Ord(FActions.CurrentDiagram.MeasUnit);
    end;
  end;
end;

procedure TfmMenuRibbon.UpdateShapeSelectors;
var
  diagramOk, textColorEnabled: boolean;
  AFontName: string;
  AFontSize: integer;
begin
  diagramOk := (FDiagramActions <> nil) and (FActions <> nil) and (FActions.CurrentDiagram <> nil);

  {Update toolbar}
  if diagramOK <> barDiagShape.Enabled then
    barDiagShape.Enabled := diagramOk;

  {Update Shape Color}
  if diagramOk <> btDiagShapeColor.Enabled then
    btDiagShapeColor.Enabled := diagramOk;
  if btDiagShapeColor.Enabled and (FActions.CurrentDiagram.SelectedBlockCount > 0) and
    (btDiagShapeColor.SelectedColor <> FActions.CurrentDiagram.FirstSelectedBlock.Color) then
    btDiagShapeColor.SelectedColor := FActions.CurrentDiagram.FirstSelectedBlock.Color;

  {Text Color not enabled for tables}
  textColorEnabled := diagramOk and (FActions.CurrentDiagram.SelectedBlockCount > 0) and (FActions.CurrentDiagram.FirstSelectedTable = nil);
  if textColorEnabled <> btDiagTextColor.Enabled then
    btDiagTextColor.Enabled := textColorEnabled;
  if btDiagTextColor.Enabled and
    (btDiagTextColor.SelectedColor <> FActions.CurrentDiagram.FirstSelectedBlock.Font.Color) then
    btDiagTextColor.SelectedColor := FActions.CurrentDiagram.FirstSelectedBlock.Font.Color;

  {Update Shape Font Name}
  if diagramOk <> btDiagFontName.Enabled then
    btDiagFontName.Enabled := diagramOk;

  if diagramOk and not btdiagFontName.Focused then
  begin
    AFontName := FDiagramActions.GetSelectedObjectFontName;
    if (AFontName = '') then
    begin
      if btDiagFontName.Text = '' then
        btDiagFontName.Text := FActions.CurrentDiagram.Font.Name;
    end else
    begin
      if (AFontName <> btDiagFontName.Text) then
        btDiagFontName.Text := AFontName;
    end;
  end;

  {Update Shape Font Size}
  if diagramOk <> btDiagFontSize.Enabled then
    btDiagFontSize.Enabled := diagramOk;

  if diagramOk and not btdiagFontSize.Focused then
  begin
    AFontSize := FDiagramActions.GetSelectedObjectFontSize;
    if (AFontSize = 0) then
    begin
      if btDiagFontSize.Text = '' then
        btDiagFontSize.Text := IntToStr(FActions.CurrentDiagram.Font.Size);
    end else
    begin
      if (IntToStr(AFontSize) <> btDiagFontSize.Text) then
        btDiagFontSize.Text := IntToStr(AFontSize);
    end;
  end;
end;

procedure TfmMenuRibbon.UpdateStatusBar;
begin
  UpdateVersionControlInfo;
  UpdateStatusBarDatabaseType;
end;

procedure TfmMenuRibbon.UpdateStatusBarDatabaseType;
var
  AText: string;
  AEnabled: boolean;
begin
  if Assigned(FDMProjectForm) and Assigned(FDMProjectForm.Project) and
    Assigned(FDMProjectForm.Project.MetaData) and Assigned(FDMProjectForm.Project.MetaData.DataDictionary) and
    Assigned(FDMProjectForm.Project.MetaData.DataDictionary.DatabaseType) then
  begin
    AText := 'Database: ' + FDMProjectForm.Project.MetaData.DataDictionary.DatabaseType.DisplayName;
    AEnabled := true;
  end
  else
  begin
    AText := 'No target database';
    AEnabled := false;
  end;
  if sbBar.Panels[0].Text <> AText then
    sbBar.Panels[0].Text := AText;
  if sbBar.Panels[0].Enabled <> AEnabled then
    sbBar.Panels[0].Enabled := AEnabled;
end;

procedure TfmMenuRibbon.UpdateVersionControlInfo;
var
  AText: string;
  AEnabled: boolean;
  version: TVersion;
begin
  if Assigned(FDMProjectForm) and Assigned(FDMProjectForm.Project) and Assigned(FDMProjectForm.Project.MetaData)
    and FDMProjectForm.Project.MetaData.VersionControl.HasVersions then
  begin
    version := FDMProjectForm.Project.MetaData.VersionControl.GetLastVersion;
    AEnabled := version <> nil;
    if AEnabled then
      AText := Format('Version: %d', [version.VersionID]);
  end
  else
  begin                                            
    AText := 'No version';
    AEnabled := false;
  end;
  if sbBar.Panels[1].Text <> AText then
    sbBar.Panels[1].Text := AText;
  if sbBar.Panels[1].Enabled <> AEnabled then
    sbBar.Panels[1].Enabled := AEnabled;
end;

procedure TfmMenuRibbon.UpdateZoomSelectors;
begin
  edDiagZoom.Diagram := FActions.CurrentDiagram;
end;

procedure TfmMenuRibbon.WDMCloseAll(var Msg: TMessage);
begin
  if DMApp <> nil then
    DMApp.CloseAll;
end;

procedure TfmMenuRibbon.WDMDiagramPopupMenu(var Msg: TMessage);
begin
  FDiagramActions.pmDiagram.PopupAtCursor;
end;

procedure TfmMenuRibbon.WDMDPageSetupDlg(var Msg: TMessage);
begin
  if FActions.CurrentDiagram <> nil then
    FActions.CurrentDiagram.PageSetupDlg;
end;

procedure TfmMenuRibbon.WDMProjectChanged(var Msg: TMessage);
begin
  if (FDMProjectForm <> nil) and (FDMProjectForm.Project <> nil) then
  begin
    if FDMProjectForm.Project.Parent <> Self then
    begin
      FDMProjectForm.Project.BorderStyle := bsNone;
      FDMProjectForm.Project.BorderIcons := [];
      FDMProjectForm.Project.Parent := Self;
      FDMProjectForm.Project.Visible := true;
      FDMProjectForm.Project.Align := alClient;

      {The good and old workaround to resize all controls in the panel}
      Self.Realign;
    end;
  end;
  UpdateFormCaption;
end;

procedure TfmMenuRibbon.WDMProjectSaved(var Msg: TMessage);
begin
  UpdateFormCaption;
end;

procedure TfmMenuRibbon.WMActivate(var Msg: TWMActivate);
var
    I: Integer;
    F: TForm;
begin
  inherited;
  if FDMProjectForm <> nil then
    FDMProjectForm.NotifyFormActivation;

  {Handle bug with modal windows. Without this code, the form will be in front of modal forms}
  for I := 0 to Screen.FormCount - 1 do
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

procedure TfmMenuRibbon.WMSyscommand(var msg: TWmSysCommand);
var
  c: integer;
  F: TForm;
begin
  case (msg.cmdtype and $FFF0) of
    SC_MINIMIZE:
      begin
        ShowWindow(handle, SW_MINIMIZE);
        msg.result := 0;
      end;
    SC_RESTORE:
      begin
        for c := 0 to Screen.FormCount - 1 do
        begin
          F := Screen.Forms[c];
          if (fsModal in F.FormState) and F.Enabled then
          begin
            msg.result := 0;
            exit;
          end;
        end;
        ShowWindow(handle, SW_RESTORE);
        msg.result := 0;
      end;
  else
    inherited;
  end;
end;

end.

