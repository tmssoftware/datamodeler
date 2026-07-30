unit Aurelius.ExportForm;

interface

uses
  Generics.Collections, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FolderDialog, IniFiles, AdvDirectoryEdit, AdvEdit, UITypes,
  AdvEdBtn, AdvFileNameEdit, Aurelius.SourceGenerator.Options, Grids, AdvObj,
  BaseGrid, AdvGrid, AdvCGrid, Aurelius.SourceGenerator, AdvMemo, AdvmPS,
  uAppMetaData,
  ComCtrls, uGDAO, AdvCombo, ExtCtrls,  Buttons, Menus,
  ScrMemo, IDEMain, atScript, atScripter, AdvUtil, AdvMemoToolBar, AdvToolBar,
  AdvToolBarExt, ScrMps, ScrCodeList, System.Actions, Vcl.ActnList,
  IDEDialog;

type
  TfmAureliusExport = class(TForm)
    Label2: TLabel;
    FolderDialog1: TFolderDialog;
    edOutputDir: TAdvDirectoryEdit;
    PageControl1: TPageControl;
    tsMappings: TTabSheet;
    grTables: TAdvColumnGrid;
    PageControl2: TPageControl;
    tsFields: TTabSheet;
    grFields: TAdvColumnGrid;
    tsAssociations: TTabSheet;
    grAssociations: TAdvColumnGrid;
    edTableName: TAdvEdit;
    chTableNameDefault: TCheckBox;
    edFieldName: TAdvEdit;
    chFieldNameDefault: TCheckBox;
    chAssociationNameDefault: TCheckBox;
    edAssociationName: TAdvEdit;
    cbOneToOneMapping: TAdvComboBox;
    tsManyValued: TTabSheet;
    grManyValued: TAdvColumnGrid;
    chManyValuedNameDefault: TCheckBox;
    edManyValuedName: TAdvEdit;
    tsGeneral: TTabSheet;
    GroupBox1: TGroupBox;
    cbTableNameSource: TAdvComboBox;
    edTableNameFormat: TAdvEdit;
    GroupBox2: TGroupBox;
    cbAssociationNameSource: TAdvComboBox;
    edAssociationNameFormat: TAdvEdit;
    GroupBox3: TGroupBox;
    cbFieldNameSource: TAdvComboBox;
    edFieldNameFormat: TAdvEdit;
    GroupBox4: TGroupBox;
    cbManyValuedNameSource: TAdvComboBox;
    edManyValuedNameFormat: TAdvEdit;
    cbAssociationFetchMode: TAdvComboBox;
    cbManyValuedFetchMode: TAdvComboBox;
    GroupBox5: TGroupBox;
    cbDefaultOneToOneMapping: TAdvComboBox;
    cbDefaultAssociationFetchMode: TAdvComboBox;
    cbDefaultManyValuedFetchMode: TAdvComboBox;
    edDefaultAncestorClass: TAdvEdit;
    edMainUnitName: TAdvEdit;
    BitBtn2: TBitBtn;
    btOk: TBitBtn;
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    btSaveWithoutGenerating: TBitBtn;
    pmMappings: TPopupMenu;
    mnSelectAll: TMenuItem;
    mnUnselectAll: TMenuItem;
    mnSelectIfPresent: TMenuItem;
    mnUnselectIfPresent: TMenuItem;
    GroupBox6: TGroupBox;
    edDictionaryName: TAdvEdit;
    edDictionaryUnitName: TAdvEdit;
    GroupBox7: TGroupBox;
    cbGenerateDictionary: TCheckBox;
    cbCreateDescriptions: TCheckBox;
    cbTableNameSingularize: TCheckBox;
    cbManyValuedNameSingularize: TCheckBox;
    edDefaultDynPropContainer: TAdvEdit;
    tsAdvanced: TTabSheet;
    edDynPropContainer: TAdvEdit;
    chDynPropContainerDefault: TCheckBox;
    cbSequence: TAdvComboBox;
    cbCheckSequences: TAdvComboBox;
    cbDefaultAssociationCascade: TAdvComboBox;
    cbAssociationCascade: TAdvComboBox;
    cbRegisterEntities: TCheckBox;
    cbFieldNameCamelCase: TCheckBox;
    cbAssociationNameCamelCase: TCheckBox;
    cbManyValuedNameCamelCase: TCheckBox;
    cbTableNameCamelCase: TCheckBox;
    cbNoNullable: TCheckBox;
    cbTableNameRemoveUnderline: TCheckBox;
    cbFieldNameRemoveUnderline: TCheckBox;
    cbAssociationNameRemoveUnderline: TCheckBox;
    cbManyValuedNameRemoveUnderline: TCheckBox;
    cbFieldType: TAdvComboBox;
    chFieldTypeDefault: TCheckBox;
    edClassUnitName: TAdvEdit;
    edModelNames: TAdvEdit;
    N1: TMenuItem;
    ModelNames1: TMenuItem;
    mnUpdateFromDiagrams: TMenuItem;
    mnUpdateFromDiagramDefault: TMenuItem;
    ClearAll1: TMenuItem;
    tsPreview: TTabSheet;
    pcSourceUnits: TPageControl;
    tsScript: TTabSheet;
    Panel1: TPanel;
    mmScript: TIDEMemo;
    IDEEngine1: TIDEEngine;
    PopupMenu1: TPopupMenu;
    Button1: TButton;
    ScrPascalMemoStyler1: TScrPascalMemoStyler;
    ScrMemoFindDialog1: TScrMemoFindDialog;
    ActionList1: TActionList;
    acMemoFind: TAction;
    Button2: TButton;
    cbLegacyDictionary: TCheckBox;
    procedure grTablesClick(Sender: TObject);
    procedure grFieldsClick(Sender: TObject);
    procedure grAssociationsClick(Sender: TObject);
    procedure SaveMappingsProperty(Sender: TObject);
    procedure grTablesCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure grAssociationsCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure grFieldsCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure grManyValuedClick(Sender: TObject);
    procedure grManyValuedCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure SaveProperty(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btSaveWithoutGeneratingClick(Sender: TObject);
    procedure mnSelectAllClick(Sender: TObject);
    procedure mnUnselectAllClick(Sender: TObject);
    procedure grTablesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grFieldsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grAssociationsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grManyValuedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnUpdateFromDiagramsClick(Sender: TObject);
    procedure mnUpdateFromDiagramDefaultClick(Sender: TObject);
    procedure ClearAll1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure DeclareEvent(const ProcName, ArgType: string);
    procedure Button1Click(Sender: TObject);
    procedure acMemoFindExecute(Sender: TObject);
    procedure memoActionUpdate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FLoading: integer;
    FApp: TAppMetaData;
    FGenerator: TSourceGenerator;
    FOptions: TSourceGeneratorOptions;
    FSourceUnits: TArray<TSourceUnit>;
    FDebugScript: TatScript;
    procedure GenerateSourceCodeProc(Machine: TatVirtualMachine);
    procedure CreateIDEForm(Sender: TObject);
    function SelectedMemo: TScrMemo;
    procedure DiagramMenuClick(Sender: TObject);
    procedure FillDiagramMenuItems;
    function FindRowFromObject(AGrid: TAdvStringGrid; AObj: TObject): integer;
    function BelongsTo(AChild, AParent: TWinControl): boolean;
    procedure LoadProperties(AContainer: TWinControl);
    procedure SaveOptions;
    procedure LoadMappingsProperty(Sender: TObject);
    procedure LoadProperty(Sender: TObject);
    function ObjectFromGrid<E: class>(AGrid: TAdvStringGrid; ARow: integer = -1): E;
    procedure EmptyGrid(AGrid: TAdvStringGrid);
    procedure EnableGrid(AGrid: TAdvStringGrid; AEnable: boolean);
    procedure LoadTablesGrid;
    procedure LoadSequencesCombo;
    procedure LoadFieldsGrid(ATable: TGDAOTable);
    procedure LoadAssociationsGrid(ATable: TGDAOTable);
    procedure LoadManyValuedGrid(ATable: TGDAOTable);
    procedure LoadScript;
    function SelectedTable: TGDAOTable;
    function SelectedTableMapping: TTableMapping;

    function SelectedAssociationMapping: TAssociationMapping;
    function SelectedAssociation: TGDAORelationship;

    function SelectedFieldMapping: TFieldMapping;
    function SelectedField: TGDAOField;

    function SelectedManyValuedMapping: TAssociationMapping;
    function SelectedManyValued: TGDAORelationship;
    procedure SetMetadata(const Value: TAppMetaData);
    procedure ToggleSearchFooter(AGrid: TAdvStringGrid; ASearchColumn: integer);
    procedure GoToSequenceControl(ATable: TGDAOTable);
    procedure UpdatePreview;
  public
    procedure ProcessSelectedTables(AProc: TProc<TGDAOTable>);
    { Operations }
    procedure UpdateModelNamesFromDiagrams(IncludeDefault: Boolean);
    procedure ClearModelNames;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowDialog(AApp: TAppMetaData): boolean;
  end;

implementation

uses
  dgConsts,
  uDiagramClass, uTableDiagramBlock,
  Aurelius.SourceGenerator.Options.Xml,
  uGDAODiagrams, fIDEEditor, dIDEActions;

{$R *.dfm}

procedure TfmAureliusExport.acMemoFindExecute(Sender: TObject);
var
  fd: TScrMemoFindDialog;
begin
  fd := ScrMemoFindDialog1;
  fd.AdvMemo := SelectedMemo;
  fd.Options := fd.Options - [frWholeWord] + [frHideWholeWord, frHideUpDown];
  fd.Execute;
end;

function TfmAureliusExport.BelongsTo(AChild, AParent: TWinControl): boolean;
begin
  repeat
    if AChild.Parent = AParent then
      Exit(true);
    AChild := AChild.Parent;
  until AChild = nil;
  Result := false;
end;

procedure TfmAureliusExport.btOkClick(Sender: TObject);
begin
  if edOutputDir.Text = '' then
  begin
    ShowMessage('Please specifiy the output directory.');
    Exit;
  end;
  try
    FGenerator.GenerateSourceFiles(edOutputDir.Text);
  except
    on E: EMissingSequenceError do
    begin
      GoToSequenceControl(E.Table);
      raise;
    end
    else
      raise;
  end;
  SaveOptions;
  ModalResult := mrOk;
end;

procedure TfmAureliusExport.btSaveWithoutGeneratingClick(Sender: TObject);
begin
  SaveOptions;
  ModalResult := mrOk;
end;

procedure TfmAureliusExport.Button1Click(Sender: TObject);
begin
  mmScript.Lines.BeginUpdate;
  try
    DeclareEvent('OnColumnGenerated', 'TColumnGeneratedArgs');
    DeclareEvent('OnAssociationGenerated', 'TAssociationGeneratedArgs');
    DeclareEvent('OnManyValuedAssociationGenerated', 'TManyValuedAssociationGeneratedArgs');
    DeclareEvent('OnClassGenerated', 'TClassGeneratedArgs');
    DeclareEvent('OnUnitGenerated', 'TUnitGeneratedArgs');
  finally
    mmScript.Lines.EndUpdate;
  end;
  SaveProperty(mmScript);
end;

procedure TfmAureliusExport.Button2Click(Sender: TObject);
var
  Scripter: TIDEScripter;
  Engine: TIDEEngine;
  Dialog: TIDEDialog;
  ProjFile: TIDEProjectFile;
begin
  // Prepare a full isolated environment just for the debugging
  Scripter := nil;
  Engine := nil;
  Dialog := nil;
  try
    Dialog := TIDEDialog.Create(nil);
    Dialog.OnCreateIDEForm := CreateIDEForm;
    Engine := TIDEEngine.Create(nil);
    Scripter := TIDEScripter.Create(nil);
    Scripter.DefineMethod('GenerateSourceCode', 0, tkNone, nil, GenerateSourceCodeProc);

    Dialog.Engine := Engine;
    Engine.Scripter := Scripter;

    FGenerator.PrepareScripter(Scripter);

    Engine.Files.Clear;

    // Create the main unit which will execute the script file
    ProjFile := Engine.NewUnit(slPascal);
    ProjFile.UnitName := 'Launcher';
    ProjFile.Script.SourceCode.Text := 'GenerateSourceCode();';
    Engine.MainUnit := ProjFile;

    // Create the script unit
    ProjFile := Engine.NewUnit(slPascal);
    ProjFile.UnitName := 'Script';
    ProjFile.Script.SourceCode.Text := FOptions.Script;
    Engine.ActiveFile := ProjFile;
    FDebugScript := ProjFile.Script;

    Dialog.IDECloseAction := TIDECloseAction.icaNothing;

    Dialog.Execute;
    mmScript.Lines.Text := FDebugScript.SourceCode.Text;
    SaveProperty(mmScript);
  finally
    Dialog.Free;
    Engine.Free;
    Scripter.Free;
    FDebugScript := nil;
  end;
end;

procedure TfmAureliusExport.DeclareEvent(const ProcName, ArgType: string);
var
  Info: TatRoutineInfo;
  Param: TatVariableInfo;
begin
  {Declare the procedure in the source code, building the information about parameters}
  Info := TatRoutineInfo.Create(nil);
  try
    {convert information in Prop object to AInfo object}
    Info.Name := ProcName;
    Info.IsFunction := False;
    Param := Info.Variables.Add;
    Param.VarName := 'Args';
    Param.Modifier := moNone;
    Param.TypeDecl := ArgType;

    {declare the procedure in source code}
    IDEEngine1.DeclareProcedure(Info);
//    Line := IDEEngine1.DeclareProcedure(Info);
//    mmScript.SetCursor(2, Line);
  finally
    Info.Free;
  end;
end;

procedure TfmAureliusExport.ClearAll1Click(Sender: TObject);
begin
  ClearModelNames;
end;

procedure TfmAureliusExport.ClearModelNames;
var
  Msg: string;
begin
  Msg := 'This will clear field "Model Names" in all selected table mappings. ';
  Msg := Msg + #13#10 + 'Do you confirm this operation?';
  if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes then
    ProcessSelectedTables(
      procedure(Table: TGDAOTable)
      begin
        FGenerator.TableMapping(Table).ModelNames := '';
      end
    );

  LoadMappingsProperty(edModelNames);
end;

constructor TfmAureliusExport.Create(AOwner: TComponent);
begin
  inherited;
  FOptions := TSourceGeneratorOptions.Create;

  cbFieldType.Clear;
  cbFieldType.Items.Add('Boolean');
  cbFieldType.Items.Add('Currency');
  cbFieldType.Items.Add('Double');
  cbFieldType.Items.Add('Int64');
  cbFieldType.Items.Add('Integer');
  cbFieldType.Items.Add('String');
  cbFieldType.Items.Add('TBlob');
  cbFieldType.Items.Add('TDateTime');
  cbFieldType.Items.Add('TGuid');
  cbFieldType.Items.Add('WideString');
  cbFieldType.Items.Add('Nullable<Boolean>');
  cbFieldType.Items.Add('Nullable<Currency>');
  cbFieldType.Items.Add('Nullable<Double>');
  cbFieldType.Items.Add('Nullable<Int64>');
  cbFieldType.Items.Add('Nullable<Integer>');
  cbFieldType.Items.Add('Nullable<String>');
  cbFieldType.Items.Add('Nullable<TBlob>');
  cbFieldType.Items.Add('Nullable<TDateTime>');
  cbFieldType.Items.Add('Nullable<TGuid>');
  cbFieldType.Items.Add('Nullable<WideString>');
end;

procedure TfmAureliusExport.CreateIDEForm(Sender: TObject);
var
  Actions: TdmIDEActions;
  Form: TIDEEditorForm;
begin
  if Sender is TForm then
  begin
    Form := TIDEEditorForm(Sender);
    Actions := Form.IDEActions;
    Actions.acNewUnit.Visible := False;
    Actions.acNewForm.Visible := False;
    Actions.acOpenFile.Visible := False;
    Actions.acSaveAsFile.Visible := False;
    Actions.acCloseFile.Visible := False;
    Actions.acCloseAll.Visible := False;
    Actions.acSaveProjectAs.Visible := False;
    Actions.acRemoveFromProject.Visible := False;
    Actions.acNewProject.Visible := False;
    Actions.acOpenProject.Visible := False;
    Actions.acSaveFile.Visible := False;
    Actions.acSaveAll.Visible := False;
    Actions.acExit.Visible := False;

    Actions.acAlignToGrid.Visible := False;
    Actions.acToggleFormUnit.Visible := False;
    Actions.acLock.Visible := False;
    Actions.acDeleteControl.Visible := False;
    Actions.acAlignToGrid.Visible := False;
    Actions.acBringToFront.Visible := False;
    Actions.acSendToBack.Visible := False;
    Actions.acAlignDialog.Visible := False;
    Actions.acSizeDialog.Visible := False;
    Actions.acAlignmentPalette.Visible := False;
    Actions.acTabOrderDialog.Visible := False;
    Actions.acDesignerOptionsDlg.Visible := False;
    Actions.acSetMainUnit.Visible := False;


    Form.File1.Visible := False;
    Form.Project1.Visible := False;
    Form.Tools1.Visible := False;

    Form.ToolBar2.Visible := False;
    Form.ToolBar4.Visible := False;

    Form.ToolBar3.Left := 0;
    Form.ToolBar1.Left := 1;

    Form.acViewInspector.Visible := False;
    FOrm.acViewPalette.Visible := False;

    Form.ShowInspector(False);
    Form.ShowPalette(False);
  end;
end;

destructor TfmAureliusExport.Destroy;
begin
  IDEEngine1.Files.Clear;
  IDEEngine1.Scripter := nil;
  if FGenerator <> nil then
    FGenerator.Free;
  FOptions.Free;
  inherited;
end;

procedure TfmAureliusExport.DiagramMenuClick(Sender: TObject);
var
  Select: boolean;
  DiagramIdx: integer;
  c: Integer;
  Diagram: TDiagramClass;
  RowIdx: integer;
begin
  Select := TMenuItem(Sender).Tag <> -1;
  DiagramIdx := FApp.DiagramObj.Diagrams.IndexOf(StripHotKey(TMenuItem(Sender).Caption));
  if DiagramIdx = -1 then Exit;
  Diagram := FApp.DiagramObj.Diagrams[DiagramIdx].DiagramControl;
  for c := 0 to Diagram.BlockCount - 1 do
  begin
    if Diagram.Blocks[c] is TTableDiagramBlock then
    begin
      RowIdx := FindRowFromObject(grTables, TTableDiagramBlock(Diagram.Blocks[c]).Table);
      if RowIdx >= 0 then
      begin
        if grTables.IsChecked(0, RowIdx) <> Select then
        begin
          grTables.SetCheckBoxState(0, RowIdx, Select);
          grTablesCheckBoxChange(grTables, 0, RowIdx, Select);
        end;
      end;
    end;
  end;
end;

procedure TfmAureliusExport.EmptyGrid(AGrid: TAdvStringGrid);
begin
  AGrid.ClearRows(0, AGrid.Rowcount);
  AGrid.RowCount := 1;
  AGrid.Col      := 0;
  AGrid.Options := AGrid.Options + [goRowSelect];
  AGrid.MouseActions.SelectOnRightClick := true;
end;

procedure TfmAureliusExport.EnableGrid(AGrid: TAdvStringGrid; AEnable: boolean);
begin
  if AEnable then
  begin
    AGrid.Enabled := True;
  end
  else
  begin
    AGrid.ClearAll;
    AGrid.Enabled := False;
  end;
end;

procedure TfmAureliusExport.FillDiagramMenuItems;
var
  c: Integer;
  MenuItem: TMenuItem;
  MenuItem2: TMenuItem;
begin
  for c := 0 to FApp.DiagramObj.Diagrams.Count - 1 do
  begin
    MenuItem := TMenuItem.Create(mnSelectIfPresent);
    MenuItem.Caption := FApp.DiagramObj.Diagrams[c].DiagramName;
    MenuItem.OnClick := DiagramMenuClick;
    mnSelectIfPresent.Add(MenuItem);

    MenuItem2 := TMenuItem.Create(mnUnselectIfPresent);
    MenuItem2.Caption := FApp.DiagramObj.Diagrams[c].DiagramName;
    MenuItem2.OnClick := DiagramMenuClick;
    MenuItem2.Tag := -1;
    mnUnselectIfPresent.Add(MenuItem2);
  end;
end;

function TfmAureliusExport.FindRowFromObject(AGrid: TAdvStringGrid;
  AObj: TObject): integer;
var
  r: Integer;
begin
  Result := -1;
  for r := 0 to AGrid.RowCount - 1 do
    if AGrid.Objects[0, r] = AObj then
      Exit(r);
end;

procedure TfmAureliusExport.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := tsGeneral;
  PageControl2.ActivePage := tsFields;
end;

procedure TfmAureliusExport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  grid: TAdvStringGrid;
begin
  // Allow easy navigation in grid using up and down keys
  if (ActiveControl is TAdvEdit) and (Key in [VK_UP, VK_DOWN]) then
  begin
    // Find the context of control - closest grid. Always search for closer parents firsts
    if BelongsTo(ActiveControl, tsFields) then
      grid := grFields
    else
    if BelongsTo(ActiveControl, tsAssociations) then
      grid := grAssociations
    else
    if BelongsTo(ActiveControl, tsManyValued) then
      grid := grManyValued
    else
    if BelongsTo(ActiveCOntrol, tsMappings) then
      grid := grTables
    else
      grid := nil;

    if grid <> nil then
    begin
      case Key of
        VK_UP:
          if grid.Row > 0 then
            grid.Row := grid.Row - 1;
        VK_DOWN:
          if grid.Row < grid.RowCount - 1 then
            grid.Row := grid.Row + 1;
      end;
    end;
  end;
end;

procedure TfmAureliusExport.GenerateSourceCodeProc(Machine: TatVirtualMachine);
begin
  FGenerator.GenerateCodeUnits(FDebugScript);
end;

procedure TfmAureliusExport.GoToSequenceControl(ATable: TGDAOTable);
var
  I: integer;
begin
  for I := 0 to grTables.RowCount - 1 do
    if ATable = ObjectFromGrid<TGDAOTable>(grTables, I) then
    begin
      grTables.Row := I;
      grTablesClick(nil);
      PageControl1.ActivePage := tsMappings;
      PageControl2.ActivePage := tsAdvanced;
      if cbSequence.CanFocus and cbSequence.Enabled then
        cbSequence.SetFocus;
      break;
    end;
end;

procedure TfmAureliusExport.SaveOptions;
begin
  FApp.AureliusExportOptions := GetOptionsXml(FOptions);
end;

procedure TfmAureliusExport.SaveProperty(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    if (Sender = edOutputDir) then
      FOptions.OutputDir := edOutputDir.Text
    else
    if (Sender = cbTableNameSource) then
      FOptions.TableNameSource := TBaseNameSource(cbTableNameSource.ItemIndex)
    else
    if (Sender = edTableNameFormat) then
      FOptions.TableNameFormat := edTableNameFormat.Text
    else
    if (Sender = cbFieldNameSource) then
      FOptions.FieldNameSource := TBaseNameSource(cbFieldNameSource.ItemIndex)
    else
    if (Sender = edFieldNameFormat) then
      FOptions.FieldNameFormat := edFieldNameFormat.Text
    else
    if (Sender = cbAssociationNameSource) then
      FOptions.AssociationNameSource := TAssociationNameSource(cbAssociationNameSource.ItemIndex)
    else
    if (Sender = edAssociationNameFormat) then
      FOptions.AssociationNameFormat := edAssociationNameFormat.Text
    else
    if (Sender = cbManyValuedNameSource) then
      FOptions.ManyValuedNameSource := TAssociationNameSource(cbManyValuedNameSource.ItemIndex)
    else
    if (Sender = edManyValuedNameFormat) then
      FOptions.ManyValuedNameFormat := edManyValuedNameFormat.Text
    else
    if (Sender = cbDefaultAssociationFetchMode) then
      FOptions.DefaultAssociationFetchMode := TFetchMode(cbDefaultAssociationFetchMode.ItemIndex + 1)
    else
    if (Sender = cbDefaultAssociationCascade) then
      FOptions.DefaultAssociationCascadeDefinition := TCascadeDefinition(cbDefaultAssociationCascade.ItemIndex + 1)
    else
    if (Sender = cbDefaultManyValuedFetchMode) then
      FOptions.DefaultManyValuedFetchMode := TFetchMode(cbDefaultManyValuedFetchMode.ItemIndex + 1)
    else
    if (Sender = cbDefaultOneToOneMapping) then
      FOptions.DefaultOneToOneMapping := TOneToOneMapping(cbDefaultOneToOneMapping.ItemIndex + 1)
    else
    if (Sender = cbDefaultNonNativePascalTypeConvertion) then
      FOptions.DefaultNonNativePascalTypeConvertion := TNonNativePascalTypeConvertion(cbDefaultNonNativePascalTypeConvertion.ItemIndex)
    else
    if (Sender = cbCheckSequences) then
      FOptions.CheckSequencesMode := TCheckSequencesMode(cbCheckSequences.ItemIndex)
    else
    if (Sender = edDefaultAncestorClass) then
      FOptions.DefaultAncestorClass := edDefaultAncestorClass.Text
    else
    if (Sender = edDefaultDynPropContainer) then
      FOptions.DefaultDynPropContainer := edDefaultDynPropContainer.Text
    else
    if (Sender = edMainUnitName) then
      FOptions.MainUnitName := edMainUnitName.Text
    else
    if (Sender = edDictionaryName) then
      FOptions.DictionaryName := edDictionaryName.Text
    else
    if (Sender = edDictionaryUnitName) then
      FOptions.DictionaryUnitName := edDictionaryUnitName.Text
    else
    if (Sender = cbGenerateDictionary) then
      FOptions.OmitDictionary := not cbGenerateDictionary.Checked
    else
    if (Sender = cbLegacyDictionary) then
      FOptions.NewDictionary := not cbLegacyDictionary.Checked
    else
    if (Sender = cbCreateDescriptions) then
      FOptions.CreateDescriptions := cbCreateDescriptions.Checked
    else
    if (Sender = cbRegisterEntities) then
      FOptions.RegisterEntities := cbRegisterEntities.Checked
    else
    if (Sender = cbNoNullable) then
      FOptions.NoNullable := cbNoNullable.Checked
    else

    if (Sender = cbTableNameSingularize) then
      FOptions.TableNameSingularize := cbTableNameSingularize.Checked
    else
    if (Sender = cbManyValuedNameSingularize) then
      FOptions.ManyValuedNameSingularize := cbManyValuedNameSingularize.Checked
    else

    if (Sender = cbTableNameCamelCase) then
      FOptions.TableNameCamelCase := cbTableNameCamelCase.Checked
    else
    if (Sender = cbFieldNameCamelCase) then
      FOptions.FieldNameCamelCase := cbFieldNameCamelCase.Checked
    else
    if (Sender = cbAssociationNameCamelCase) then
      FOptions.AssociationNameCamelCase := cbAssociationNameCamelCase.Checked
    else
    if (Sender = cbManyValuedNameCamelCase) then
      FOptions.ManyValuedNameCamelCase := cbManyValuedNameCamelCase.Checked
    else

    if (Sender = cbTableNameRemoveUnderline) then
      FOptions.TableNameRemoveUnderline := cbTableNameRemoveUnderline.Checked
    else
    if (Sender = cbFieldNameRemoveUnderline) then
      FOptions.FieldNameRemoveUnderline := cbFieldNameRemoveUnderline.Checked
    else
    if (Sender = cbAssociationNameRemoveUnderline) then
      FOptions.AssociationNameRemoveUnderline := cbAssociationNameRemoveUnderline.Checked
    else
    if (Sender = cbManyValuedNameRemoveUnderline) then
      FOptions.ManyValuedNameRemoveUnderline := cbManyValuedNameRemoveUnderline.Checked
    else
    if (Sender = mmScript) then
      FOptions.Script := mmScript.Lines.Text;
  end;
end;

procedure TfmAureliusExport.SaveMappingsProperty(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    if (Sender = edTableName) and (SelectedTableMapping <> nil) then
    begin
      SelectedTableMapping.EntityClassName := edTableName.Text;
      LoadMappingsProperty(chTableNameDefault);
    end else
    if (Sender = chTableNameDefault) and (SelectedTableMapping <> nil) then
    begin
      if chTableNameDefault.Checked then
        SelectedTableMapping.EntityClassName := ''
      else
        SelectedTableMapping.EntityClassName := edTableName.Text;
      LoadMappingsProperty(edTableName);
    end else
    if (Sender = edDynPropContainer) and (SelectedTableMapping <> nil) then
    begin
      SelectedTableMapping.DynPropContainer := edDynPropContainer.Text;
      SelectedTableMapping.CustomContainer := True;
      LoadMappingsProperty(chDynPropContainerDefault);
    end else
    if (Sender = edModelNames) and (SelectedTableMapping <> nil) then
    begin
      SelectedTableMapping.ModelNames := edModelNames.Text;
    end else
    if (Sender = edClassUnitName) and (SelectedTableMapping <> nil) then
    begin
      SelectedTableMapping.ClassUnitName := edClassUnitName.Text;
    end else
    if (Sender = cbSequence) and (SelectedTableMapping <> nil) then
    begin
      SelectedTableMapping.SequenceName := cbSequence.Text;
    end else
    if (Sender = chDynPropContainerDefault) and (SelectedTableMapping <> nil) then
    begin
      SelectedTableMapping.CustomContainer := not chDynPropContainerDefault.Checked;
      LoadMappingsProperty(edDynPropContainer);
    end else
    if (Sender = edFieldName) and (SelectedFieldMapping <> nil) then
    begin
      SelectedFieldMapping.PropertyName := edFieldName.Text;
      LoadMappingsProperty(chFieldNameDefault);
    end else
    if (Sender = chFieldNameDefault) and (SelectedFieldMapping <> nil) then
    begin
      if chFieldNameDefault.Checked then
        SelectedFieldMapping.PropertyName := ''
      else
        SelectedFieldMapping.PropertyName := edFieldName.Text;
      LoadMappingsProperty(edFieldName);
    end else

    if (Sender = cbFieldType) and (SelectedFieldMapping <> nil) then
    begin
      SelectedFieldMapping.PropertyType := cbFieldType.Text;
      LoadMappingsProperty(chFieldTypeDefault);
    end else
    if (Sender = chFieldTypeDefault) and (SelectedFieldMapping <> nil) then
    begin
      if chFieldTypeDefault.Checked then
        SelectedFieldMapping.PropertyType := ''
      else
        SelectedFieldMapping.PropertyType := cbFieldType.Text;
      LoadMappingsProperty(cbFieldType);
    end else

    if (Sender = edAssociationName) and (SelectedAssociationMapping <> nil) then
    begin
      SelectedAssociationMapping.PropertyName := edAssociationName.Text;
      LoadMappingsProperty(chAssociationNameDefault);
    end else
    if (Sender = chAssociationNameDefault) and (SelectedAssociationMapping <> nil) then
    begin
      if chAssociationNameDefault.Checked then
        SelectedAssociationMapping.PropertyName := ''
      else
        SelectedAssociationMapping.PropertyName := edAssociationName.Text;
      LoadMappingsProperty(edAssociationName);
    end else
    if (Sender = cbAssociationFetchMode) and (SelectedAssociationMapping <> nil) then
    begin
      if cbAssociationFetchMode.ItemIndex > 0 then
        SelectedAssociationMapping.FetchMode := TFetchModeOptions(cbAssociationFetchMode.ItemIndex)
      else
        SelectedAssociationMapping.FetchMode := fmDefault;
    end else
    if (Sender = cbAssociationCascade) and (SelectedAssociationMapping <> nil) then
    begin
      if cbAssociationCascade.ItemIndex > 0 then
        SelectedAssociationMapping.CascadeDefinition := TCascadeDefinitionOptions(cbAssociationCascade.ItemIndex)
      else
        SelectedAssociationMapping.CascadeDefinition := cdDefault;
    end else
    if (Sender = cbOneToOneMapping) and (SelectedAssociationMapping <> nil) then
    begin
      if cbOneToOneMapping.ItemIndex > 0 then
        SelectedAssociationMapping.OneToOneMapping := TOneToOneMappingMode(cbOneToOneMapping.ItemIndex)
      else
        SelectedAssociationMapping.OneToOneMapping := omDefault;
    end else
    if (Sender = edManyValuedName) and (SelectedManyValuedMapping <> nil) then
    begin
      SelectedManyValuedMapping.ManyValuedPropertyName := edManyValuedName.Text;
      LoadMappingsProperty(chManyValuedNameDefault);
    end else
    if (Sender = chManyValuedNameDefault) and (SelectedManyValuedMapping <> nil) then
    begin
      if chManyValuedNameDefault.Checked then
        SelectedManyValuedMapping.ManyValuedPropertyName := ''
      else
        SelectedManyValuedMapping.ManyValuedPropertyName := edManyValuedName.Text;
      LoadMappingsProperty(edManyValuedName);
    end else
    if (Sender = cbManyValuedFetchMode) and (SelectedManyValuedMapping <> nil) then
    begin
      if cbManyValuedFetchMode.ItemIndex > 0 then
        SelectedManyValuedMapping.ManyValuedFetchMode := TFetchModeOptions(cbManyValuedFetchMode.ItemIndex)
      else
        SelectedManyValuedMapping.ManyValuedFetchMode := fmDefault;
    end else
  end;
end;

function TfmAureliusExport.SelectedAssociation: TGDAORelationship;
begin
  Result := ObjectFromGrid<TGDAORelationship>(grAssociations);
end;

function TfmAureliusExport.SelectedAssociationMapping: TAssociationMapping;
begin
  Result := FGenerator.AssociationMapping(SelectedAssociation);
end;

function TfmAureliusExport.SelectedField: TGDAOField;
begin
  Result := ObjectFromGrid<TGDAOField>(grFields);
end;

function TfmAureliusExport.SelectedFieldMapping: TFieldMapping;
begin
  Result := FGenerator.FieldMapping(SelectedField);
end;

function TfmAureliusExport.SelectedManyValued: TGDAORelationship;
begin
  Result := ObjectFromGrid<TGDAORelationship>(grManyValued);
end;

function TfmAureliusExport.SelectedManyValuedMapping: TAssociationMapping;
begin
  Result := FGenerator.ManyValuedMapping(SelectedManyValued);
end;

function TfmAureliusExport.SelectedMemo: TScrMemo;
begin
  Result := nil;
  if PageControl1.ActivePage = tsScript then
  begin
    if mmScript.Focused then
      Result := mmScript;
  end
  else
  if PageControl1.ActivePage = tsPreview then
  begin
    if (pcSourceUnits.ActivePage <> nil) and (pcSourceUnits.ActivePage.ControlCount > 0) then
      Result := pcSourceUnits.ActivePage.Controls[0] as TScrMemo;
  end;
end;

function TfmAureliusExport.SelectedTable: TGDAOTable;
begin
  Result := ObjectFromGrid<TGDAOTable>(grTables);
end;

function TfmAureliusExport.SelectedTableMapping: TTableMapping;
begin
  Result := FGenerator.TableMapping(SelectedTable);
end;

procedure TfmAureliusExport.grAssociationsCheckBoxChange(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
var
  association: TGDAORelationship;
begin
  association := ObjectFromGrid<TGDAORelationship>(grAssociations, ARow);
  if association <> nil then
  FGenerator.AssociationMapping(association).Excluded := not State;
end;

procedure TfmAureliusExport.grAssociationsClick(Sender: TObject);
begin
  LoadMappingsProperty(edAssociationName);
  LoadMappingsProperty(chAssociationNameDefault);
  LoadMappingsProperty(cbOneToOneMapping);
  LoadMappingsproperty(cbAssociationFetchMode);
  LoadMappingsproperty(cbAssociationCascade);
end;

procedure TfmAureliusExport.grAssociationsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = Ord('F')) then
    ToggleSearchFooter(TAdvStringGrid(Sender), 1);
end;

procedure TfmAureliusExport.grFieldsCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
  State: Boolean);
var
  field: TGDAOField;
begin
  field := ObjectFromGrid<TGDAOField>(grFields, ARow);
  if field <> nil then
    FGenerator.FieldMapping(field).Excluded := not State;
end;

procedure TfmAureliusExport.grFieldsClick(Sender: TObject);
begin
  LoadMappingsProperty(edFieldName);
  LoadMappingsProperty(chFieldNameDefault);
  LoadMappingsProperty(cbFieldType);
  LoadMappingsProperty(chFieldTypeDefault);
end;

procedure TfmAureliusExport.grFieldsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = Ord('F')) then
    ToggleSearchFooter(TAdvStringGrid(Sender), 1);
end;

procedure TfmAureliusExport.grManyValuedCheckBoxChange(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
var
  manyValued: TGDAORelationship;
begin
  manyValued := ObjectFromGrid<TGDAORelationship>(grManyValued, ARow);
  if manyValued <> nil then
  FGenerator.ManyValuedMapping(manyValued).ManyValuedIncluded := State;
end;

procedure TfmAureliusExport.grManyValuedClick(Sender: TObject);
begin
  LoadMappingsProperty(edManyValuedName);
  LoadMappingsProperty(chManyValuedNameDefault);
  LoadMappingsProperty(cbManyValuedFetchMode);
end;

procedure TfmAureliusExport.grManyValuedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = Ord('F')) then
    ToggleSearchFooter(TAdvStringGrid(Sender), 1);
end;

procedure TfmAureliusExport.grTablesCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
  State: Boolean);
var
  table: TGDAOTable;
begin
  table := ObjectFromGrid<TGDAOTable>(grTables, ARow);
  if table <> nil then
    FGenerator.TableMapping(table).Excluded := not State;
end;

procedure TfmAureliusExport.grTablesClick(Sender: TObject);
begin
  LoadFieldsGrid(SelectedTable);
  LoadAssociationsGrid(SelectedTable);
  LoadManyValuedGrid(SelectedTable);

  LoadMappingsProperty(edTableName);
  LoadMappingsProperty(cbSequence);
  LoadMappingsProperty(chTableNameDefault);
  LoadMappingsProperty(edDynPropContainer);
  LoadMappingsProperty(chDynPropContainerDefault);
  LoadMappingsProperty(edModelNames);
  LoadMappingsProperty(edClassUnitName);
end;

procedure TfmAureliusExport.grTablesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = Ord('F')) then
    ToggleSearchFooter(TAdvStringGrid(Sender), 1);
end;

procedure TfmAureliusExport.LoadAssociationsGrid(ATable: TGDAOTable);
var
  mapping: TAssociationMapping;
  associations: TList<TGDAORelationship>;
  association: TGDAORelationship;
  c: Integer;
  row: integer;
  selected: TGDAORelationship;
begin
  selected := SelectedAssociation;
  EmptyGrid(grAssociations);
  if ATable = nil then
  begin
    EnableGrid(grAssociations, false);
    grAssociationsClick(nil);
    Exit;
  end;
  associations := FGenerator.GetForeignRelationships(ATable);
  try
    grAssociations.RowCount := associations.Count;
    for c := 0 to associations.Count - 1 do
    begin
      association := associations[c];
      mapping := nil;
      FOptions.Associations.TryGetValue(association.RelID, mapping);
      row := c;

      grAssociations.Objects[0, row] := association;

      if not FGenerator.IsAssociationRequired(association) then
        grAssociations.AddCheckBox(0, row, (mapping = nil) or not mapping.Excluded, False);
      grAssociations.Cells[1, row] := FGenerator.AssociationPropertyName(association);
      if selected = association then
        grAssociations.Row := c;
    end;
    grAssociations.Options := grAssociations.Options + [goRowSelect];
    EnableGrid(grAssociations, associations.Count > 0);
  finally
    associations.Free;
  end;
  grAssociationsClick(nil);
end;

procedure TfmAureliusExport.LoadFieldsGrid(ATable: TGDAOTable);
var
  field: TGDAOField;
  fields: TList<TGDAOField>;
  mapping: TFieldMapping;
  c: Integer;
  row: integer;
  tableMapping: TTableMapping;
  selected: TGDAOField;
begin
  selected := SelectedField;
  EmptyGrid(grFields);
  if ATable = nil then
  begin
    EnableGrid(grFields, false);
    grFieldsClick(nil);
    Exit;
  end;
  FOptions.Tables.TryGetValue(ATable.TID, tableMapping);
  fields := FGenerator.GetPropertyFields(ATable);
  try
    grFields.RowCount := fields.Count;
    for c := 0 to fields.Count - 1 do
    begin
      field := fields[c];
      mapping := nil;
      if tableMapping <> nil then
        tableMapping.Fields.TryGetValue(field.FID, mapping);
      row := c;

      grFields.Objects[0, row] := field;
      if not field.Required then
        grfields.AddCheckBox(0, row, (mapping = nil) or not mapping.Excluded, False);
      grFields.Cells[1, row] := field.FieldName;
      if selected = field then
        grFields.Row := c;
    end;
    grFields.Options := grFields.Options + [goRowSelect];
    EnableGrid(grFields, fields.Count > 0);
  finally
    fields.Free;
  end;
  grFieldsClick(nil);
end;

procedure TfmAureliusExport.LoadManyValuedGrid(ATable: TGDAOTable);
var
  mapping: TAssociationMapping;
  manyValuedList: TList<TGDAORelationship>;
  manyValued: TGDAORelationship;
  c: Integer;
  row: integer;
  selected: TGDAORelationship;
begin
  selected := SelectedManyValued;
  EmptyGrid(grManyValued);
  if ATable = nil then
  begin
    EnableGrid(grManyValued, false);
    grManyValuedClick(nil);
    Exit;
  end;
  ManyValuedList := FGenerator.GetPrimaryRelationships(ATable);
  try
    grManyValued.RowCount := ManyValuedList.Count;
    for c := 0 to ManyValuedList.Count - 1 do
    begin
      manyValued := ManyValuedList[c];
      mapping := nil;
      FOptions.Associations.TryGetValue(manyValued.RelID, mapping);
      row := c;

      grManyValued.Objects[0, row] := manyValued;
      grManyValued.AddCheckBox(0, row, (mapping <> nil) and mapping.ManyValuedIncluded, False);
      grManyValued.Cells[1, row] := FGenerator.ManyValuedAssociationPropertyName(manyValued);
      if selected = manyValued then
        grManyValued.Row := c;
    end;
    grManyValued.Options := grManyValued.Options + [goRowSelect];
    EnableGrid(grManyValued, ManyValuedList.Count > 0);
  finally
    ManyValuedList.Free;
  end;
  grManyValuedClick(nil);
end;

procedure TfmAureliusExport.LoadTablesGrid;
var
  table: TGDAOTable;
  mapping: TTableMapping;
  c: Integer;
  row: integer;
  selected: TGDAOTable;
begin
  selected := SelectedTable;
  EmptyGrid(grTables);
  grTables.RowCount := FApp.DataDictionary.Tables.Count;
  grTables.AddCheckBoxColumn(0);
  for c := 0 to FApp.DataDictionary.Tables.Count - 1 do
  begin
    table := FApp.DataDictionary.Tables[c];
    FOptions.Tables.TryGetValue(table.TID, mapping);
    row := c;

    // field object
    grTables.Objects[0, row] := table;
    // field properties
    grTables.SetCheckBoxState(0, row, (mapping = nil) or not mapping.Excluded);
    grTables.Cells[1, row] := table.TableName;
    if selected = table then
      grTables.Row := c;
  end;
  grTables.Options := grTables.Options + [goRowSelect];
  grTables.Sort(0);
  EnableGrid(grTables, FApp.DataDictionary.Tables.Count > 0);
  grTablesClick(nil);
end;

procedure TfmAureliusExport.MemoActionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := SelectedMemo <> nil;
end;

procedure TfmAureliusExport.mnSelectAllClick(Sender: TObject);
begin
  grTables.CheckAll(0);
end;

procedure TfmAureliusExport.mnUnselectAllClick(Sender: TObject);
begin
  grTables.UnCheckAll(0);
end;

procedure TfmAureliusExport.mnUpdateFromDiagramDefaultClick(Sender: TObject);
begin
  UpdateModelNamesFromDiagrams(True);
end;

procedure TfmAureliusExport.mnUpdateFromDiagramsClick(Sender: TObject);
begin
  UpdateModelNamesFromDiagrams(False);
end;

function TfmAureliusExport.ObjectFromGrid<E>(AGrid: TAdvStringGrid; ARow: integer = -1): E;
begin
  if ARow = -1 then
    ARow := AGrid.Row;
  if Assigned(AGrid.Objects[0, ARow]) and (AGrid.Objects[0, ARow] is E) then
    result := E(AGrid.Objects[0, ARow])
  else
    result := nil;
end;

procedure TfmAureliusExport.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = tsPreview then
    UpdatePreview;
end;

procedure TfmAureliusExport.ProcessSelectedTables(AProc: TProc<TGDAOTable>);
var
  I: Integer;
begin
  for I := 0 to grTables.RowCount - 1 do
    if not FGenerator.TableMapping(ObjectFromGrid<TGDAOTable>(grTables, I)).Excluded then
      AProc(ObjectFromGrid<TGDAOTable>(grTables, I));
end;

procedure TfmAureliusExport.SetMetadata(const Value: TAppMetaData);
begin
  FApp := Value;

  LoadOptionsFromXml(FOptions, FApp.AureliusExportOptions);
  FGenerator := TSourceGenerator.Create(FApp.DataDictionary, FOptions);
  IDEEngine1.Scripter := FGenerator.Scripter;

  mmScript.AutoCompletion.MaxWidth := 400;

  edOutputDir.Text := FOptions.OutputDir;
  LoadTablesGrid;
  LoadSequencesCombo;
  LoadProperties(tsGeneral);
  LoadProperties(tsScript);
  FillDiagramMenuItems;
end;

function TfmAureliusExport.ShowDialog(AApp: TAppMetaData): boolean;
begin
  SetMetaData(AApp);
  Result := ShowModal = mrOk;
end;

procedure TfmAureliusExport.ToggleSearchFooter(AGrid: TAdvStringGrid;
  ASearchColumn: integer);
begin
  if AGrid.SearchFooter.Visible then
  begin
    AGrid.SearchFooter.Visible := false;
    AGrid.SetFocus;
  end
  else
  begin
    AGrid.SearchFooter.Visible := true;
    AGrid.SearchFooter.SearchColumn := ASearchColumn;
    AGrid.SearchFooter.ShowHighlight := false;
    AGrid.SearchFooter.ShowFindNext := false;
    AGrid.SearchFooter.ShowFindPrev := false;
    AGrid.SearchFooter.ShowMatchCase := false;
    AGrid.SearchFooter.ShowClose := true;
    AGrid.SearchPanel.EditControl.SetFocus;
  end;
end;

procedure TfmAureliusExport.UpdateModelNamesFromDiagrams(
  IncludeDefault: Boolean);
var
  Msg: string;
begin
  Msg := 'This will update field "Model Names" in all selected table mappings. ' +
    'One model name will be added for each diagram the table belongs to. ';
  if IncludeDefault then
    Msg := Msg + #13#10 + 'The model "Default" will also be included in all tables.';
  Msg := Msg + #13#10 + 'Do you confirm this operation?';
  if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes then
    ProcessSelectedTables(
      procedure(Table: TGDAOTable)
      var
        Names: string;
        Mapping: TTableMapping;
        I: Integer;
        HasDefault: Boolean;
      begin
        Names := '';
        Mapping := FGenerator.TableMapping(Table);
        HasDefault := False;
        for I := 0 to FApp.DiagramObj.Diagrams.Count - 1 do
          if FApp.DiagramObj.Diagrams[I].DiagramControl.FindTableBlock(Table) <> nil then
          begin
            if Names <> '' then
              Names := Names + ',';
            Names := Names + FApp.DiagramObj.Diagrams[I].DiagramName;
            if SameText('Default', FApp.DiagramObj.Diagrams[I].DiagramName) then
              HasDefault := True;
          end;
        if not HasDefault and IncludeDefault and (Names <> '') then
          Names := 'Default,' + Names;

        Mapping.ModelNames := Names;
      end
    );

  LoadMappingsProperty(edModelNames);
end;

procedure TfmAureliusExport.UpdatePreview;
var
  sourceUnit: TSourceUnit;
  tabSheet: TTabSheet;
  memo: TScrMemo;
begin
  FSourceUnits := FGenerator.GenerateSourceUnits;
  try
    while pcSourceUnits.PageCount > 0 do
      pcSourceUnits.Pages[0].Free;

    for sourceUnit in FSourceUnits do
    begin
      tabSheet := TTabSheet.Create(pcSourceUnits);
      tabSheet.Caption := sourceUnit.Name;
      tabSheet.PageControl := pcSourceUnits;
      memo := TScrMemo.Create(tabSheet);
      memo.Parent := tabSheet;
      memo.Align := alClient;
      memo.Lines.Text := sourceUnit.Source;
      memo.ReadOnly := True;
      memo.SyntaxStyles := ScrPascalMemoStyler1;
    end;

    if pcSourceUnits.PageCount > 0 then
      pcSourceUnits.ActivePageIndex := 0;

    FGenerator.CheckCircularReferences;
  finally
  end;
end;

procedure TfmAureliusExport.LoadMappingsProperty(Sender: TObject);
begin
  Inc(FLoading);
  try
    if Sender = edTableName then
    begin
      if SelectedTableMapping <> nil then
      begin
        edTableName.Text := FGenerator.ClassName(SelectedTable);
        edTableName.Enabled := True;
      end else
      begin
        edTableName.Text := '';
        edTableName.Enabled := false;
      end;
    end else
    if Sender = chTableNameDefault then
    begin
      chTableNameDefault.Enabled := SelectedTableMapping <> nil;
      if SelectedTableMapping <> nil then
        chTableNameDefault.Checked := SelectedTableMapping.DefaultNaming;
    end else

    if Sender = edDynPropContainer then
    begin
      if SelectedTableMapping <> nil then
      begin
        edDynPropContainer.Text := FGenerator.DynamicPropContainerName(SelectedTable);
        edDynPropContainer.Enabled := True;
      end else
      begin
        edDynPropContainer.Text := '';
        edDynPropContainer.Enabled := false;
      end;
    end else
    if Sender = edModelNames then
    begin
      if SelectedTableMapping <> nil then
      begin
        edModelNames.Text := SelectedTableMapping.ModelNames;
        edModelNames.Enabled := True;
      end else
      begin
        edModelNames.Text := '';
        edModelNames.Enabled := false;
      end;
    end else
    if Sender = edClassUnitName then
    begin
      if SelectedTableMapping <> nil then
      begin
        edClassUnitName.Text := SelectedTableMapping.ClassUnitName;
        edClassUnitName.Enabled := True;
      end else
      begin
        edClassUnitName.Text := '';
        edClassUnitName.Enabled := false;
      end;
    end else
    if Sender = cbSequence then
    begin
      if SelectedTableMapping <> nil then
      begin
        cbSequence.Text := SelectedTableMapping.SequenceName;
        cbSequence.Enabled := True;
      end else
      begin
        cbSequence.Text := '';
        cbSequence.Enabled := false;
      end;
    end else
    if Sender = chDynPropContainerDefault then
    begin
      chDynPropContainerDefault.Enabled := SelectedTableMapping <> nil;
      if SelectedTableMapping <> nil then
        chDynPropContainerDefault.Checked := not SelectedTableMapping.CustomContainer;
    end else
    if Sender = edFieldName then
    begin
      if SelectedFieldMapping <> nil then
      begin
        edFieldName.Text := FGenerator.PropertyName(SelectedField);
        edFieldName.Enabled := True;
      end else
      begin
        edFieldName.Text := '';
        edFieldName.Enabled := false;
      end;
    end else
    if Sender = chFieldNameDefault then
    begin
      chFieldNameDefault.Enabled := SelectedFieldMapping <> nil;
      if SelectedFieldMapping <> nil then
        chFieldNameDefault.Checked := SelectedFieldMapping.DefaultNaming;
    end else
    if Sender = cbFieldType then
    begin
      if SelectedFieldMapping <> nil then
      begin
        cbFieldType.Text := FGenerator.PropertyType(SelectedField);
        cbFieldType.Enabled := True;
      end else
      begin
        cbFieldType.Text := '';
        cbFieldType.Enabled := false;
      end;
    end else
    if Sender = chFieldTypeDefault then
    begin
      chFieldTypeDefault.Enabled := SelectedFieldMapping <> nil;
      if SelectedFieldMapping <> nil then
        chFieldTypeDefault.Checked := SelectedFieldMapping.DefaultType;
    end else

    if Sender = edAssociationName then
    begin
      if SelectedAssociationMapping <> nil then
      begin
        edAssociationName.Text := FGenerator.AssociationPropertyName(SelectedAssociation);
        edAssociationName.Enabled := True;
      end else
      begin
        edAssociationName.Text := '';
        edAssociationName.Enabled := false;
      end;
    end else
    if Sender = chAssociationNameDefault then
    begin
      chAssociationNameDefault.Enabled := SelectedAssociationMapping <> nil;
      if SelectedAssociationMapping <> nil then
        chAssociationNameDefault.Checked := SelectedAssociationMapping.DefaultNaming;
    end else
    if Sender = cbAssociationFetchMode then
    begin
      cbAssociationFetchMode.Enabled := (SelectedAssociationMapping <> nil);
      if cbAssociationFetchMode.Enabled then
        cbAssociationFetchMode.ItemIndex := Ord(SelectedAssociationMapping.FetchMode)
      else
        cbAssociationFetchMode.ItemIndex := 0;
    end else
    if Sender = cbAssociationCascade then
    begin
      cbAssociationCascade.Enabled := (SelectedAssociationMapping <> nil);
      if cbAssociationCascade.Enabled then
        cbAssociationCascade.ItemIndex := Ord(SelectedAssociationMapping.CascadeDefinition)
      else
        cbAssociationCascade.ItemIndex := 0;
    end else
    if Sender = cbOneToOneMapping then
    begin
      cbOneToOneMapping.Enabled := (SelectedAssociationMapping <> nil) and (SelectedAssociation.Cardinality = rcOneToOne);
      cbOneToOneMapping.Visible := cbOneToOneMapping.Enabled;
      if cbOneToOneMapping.Enabled then
        cbOneToOneMapping.ItemIndex := Ord(SelectedAssociationMapping.OneToOneMapping)
      else
        cbOneToOneMapping.ItemIndex := 0;
    end else
    if Sender = edManyValuedName then
    begin
      if SelectedManyValuedMapping <> nil then
      begin
        edManyValuedName.Text := FGenerator.ManyValuedAssociationPropertyName(SelectedManyValued);
        edManyValuedName.Enabled := True;
      end else
      begin
        edManyValuedName.Text := '';
        edManyValuedName.Enabled := false;
      end;
    end else
    if Sender = chManyValuedNameDefault then
    begin
      chManyValuedNameDefault.Enabled := SelectedManyValuedMapping <> nil;
      if SelectedManyValuedMapping <> nil then
        chManyValuedNameDefault.Checked := SelectedManyValuedMapping.ManyValuedDefaultNaming;
    end else
    if Sender = cbManyValuedFetchMode then
    begin
      cbManyValuedFetchMode.Enabled := (SelectedManyValuedMapping <> nil);
      if cbManyValuedFetchMode.Enabled then
        cbManyValuedFetchMode.ItemIndex := Ord(SelectedManyValuedMapping.ManyValuedFetchMode)
      else
        cbManyValuedFetchMode.ItemIndex := 0;
    end else
  finally
    Dec(FLoading);
  end;
end;

procedure TfmAureliusExport.LoadProperties(AContainer: TWinControl);
var
  c: Integer;
begin
  for c := 0 to AContainer.ControlCount - 1 do
  begin
    LoadProperty(AContainer.Controls[c]);
    if AContainer.Controls[c] is TWinControl then
      LoadProperties(TWinControl(AContainer.Controls[c]));
  end;
end;

procedure TfmAureliusExport.LoadProperty(Sender: TObject);
begin
  Inc(FLoading);
  try
    if Sender = cbTableNameSource then
      cbTableNameSource.ItemIndex := Ord(FOptions.TableNameSource)
    else
    if Sender = edTableNameFormat then
      edTableNameFormat.Text := FOptions.TableNameFormat
    else
    if Sender = cbFieldNameSource then
      cbFieldNameSource.ItemIndex := Ord(FOptions.FieldNameSource)
    else
    if Sender = edFieldNameFormat then
      edFieldNameFormat.Text := FOptions.FieldNameFormat
    else
    if Sender = cbAssociationNameSource then
      cbAssociationNameSource.ItemIndex := Ord(FOptions.AssociationNameSource)
    else
    if Sender = edAssociationNameFormat then
      edAssociationNameFormat.Text := FOptions.AssociationNameFormat
    else
    if Sender = cbManyValuedNameSource then
      cbManyValuedNameSource.ItemIndex := Ord(FOptions.ManyValuedNameSource)
    else
    if Sender = edManyValuedNameFormat then
      edManyValuedNameFormat.Text := FOptions.ManyValuedNameFormat
    else
    if Sender = cbDefaultAssociationFetchMode then
      cbDefaultAssociationFetchMode.ItemIndex := Ord(FOptions.DefaultAssociationFetchMode) - 1
    else
    if Sender = cbDefaultAssociationCascade then
      cbDefaultAssociationCascade.ItemIndex := Ord(FOptions.DefaultAssociationCascadeDefinition) - 1
    else
    if Sender = cbDefaultManyValuedFetchMode then
      cbDefaultManyValuedFetchMode.ItemIndex := Ord(FOptions.DefaultManyValuedFetchMode) - 1
    else
    if Sender = cbDefaultOneToOneMapping then
      cbDefaultOneToOneMapping.ItemIndex := Ord(FOptions.DefaultOneToOneMapping) - 1
    else
    if Sender = cbCheckSequences then
      cbCheckSequences.ItemIndex := Ord(FOptions.CheckSequencesMode)
    else
    if Sender = edDefaultAncestorClass then
      edDefaultAncestorClass.Text := FOptions.DefaultAncestorClass
    else
    if Sender = edDefaultDynPropContainer then
      edDefaultDynPropContainer.Text := FOptions.DefaultDynPropContainer
    else
    if Sender = edMainUnitName then
      edMainUnitName.Text := FOptions.MainUnitName
    else
    if Sender = edDictionaryName then
      edDictionaryName.Text := FOptions.DictionaryName
    else
    if Sender = edDictionaryUnitName then
      edDictionaryUnitName.Text := FOptions.DictionaryUnitName
    else
    if Sender = cbGenerateDictionary then
      cbGenerateDictionary.Checked := not FOptions.OmitDictionary
    else
    if Sender = cbLegacyDictionary then
      cbLegacyDictionary.Checked := not FOptions.NewDictionary
    else
    if Sender = cbCreateDescriptions then
      cbCreateDescriptions.Checked := FOptions.CreateDescriptions
    else
    if Sender = cbRegisterEntities then
      cbRegisterEntities.Checked := FOptions.RegisterEntities
    else
    if Sender = cbNoNullable then
      cbNoNullable.Checked := FOptions.NoNullable
    else
    if Sender = cbTableNameSingularize then
      cbTableNameSingularize.Checked := FOptions.TableNameSingularize
    else
    if Sender = cbManyValuedNameSingularize then
      cbManyValuedNameSingularize.Checked := FOptions.ManyValuedNameSingularize
    else

    if Sender = cbTableNameCamelCase then
      cbTableNameCamelCase.Checked := FOptions.TableNameCamelCase
    else
    if Sender = cbTableNameRemoveUnderline then
      cbTableNameRemoveUnderline.Checked := FOptions.TableNameRemoveUnderline
    else

    if Sender = cbFieldNameCamelCase then
      cbFieldNameCamelCase.Checked := FOptions.FieldNameCamelCase
    else
    if Sender = cbFieldNameRemoveUnderline then
      cbFieldNameRemoveUnderline.Checked := FOptions.FieldNameRemoveUnderline
    else

    if Sender = cbAssociationNameCamelCase then
      cbAssociationNameCamelCase.Checked := FOptions.AssociationNameCamelCase
    else
    if Sender = cbAssociationNameRemoveUnderline then
      cbAssociationNameRemoveUnderline.Checked := FOptions.AssociationNameRemoveUnderline
    else

    if Sender = cbManyValuedNameCamelCase then
      cbManyValuedNameCamelCase.Checked := FOptions.ManyValuedNameCamelCase
    else
    if Sender = cbManyValuedNameRemoveUnderline then
      cbManyValuedNameRemoveUnderline.Checked := FOptions.ManyValuedNameRemoveUnderline
    else
    if Sender = mmScript then
      LoadScript;
  finally
    Dec(FLoading);
  end;
end;

procedure TfmAureliusExport.LoadScript;
begin
  FGenerator.Scripter.CurrentScript.SourceCode.Text := FOptions.Script;
  IDEEngine1.SyncFilesFromScripts;
  if IDEEngine1.Files.Count > 0 then
    IDEEngine1.ActiveFile := IDEEngine1.Files[0];

//  IDEEngine1.Files.Clear;
//  IDEEngine1.NewUnit(slPascal);
//  mmScript.Lines.Text := FOptions.Script;
end;

procedure TfmAureliusExport.LoadSequencesCombo;
var
  Sequences: TGDAOObjects;
  I: Integer;
begin
  cbSequence.Items.Clear;
  cbSequence.Items.Add('(none)');
  if FApp.DataDictionary.Categories.FindByType(ctSequence) <> nil then
  begin
    Sequences := FApp.DataDictionary.Categories.FindByType(ctSequence).Objects;
    for I := 0 to Sequences.Count - 1 do
    begin
      cbSequence.AddItem(Sequences[I].ObjectName, Sequences[I]);
    end;
    cbSequence.Sorted := true;
  end;
end;

end.
