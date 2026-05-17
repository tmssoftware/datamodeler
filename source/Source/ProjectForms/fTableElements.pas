unit fTableElements;

interface

uses
  Variants, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Menus, InspectorBar, Buttons, ImgList,
  fTriggersEditor, TypInfo, uStrings, UITypes,
  Mask, uAppMetaData, DB, uDialogs,
  Grids, DBGrids, LangConst, ActnList, AdvToolBtn, BaseGrid,
  uListviewcleaner, AdvMemo, AdvGrid, AdvCGrid, uGDAO, AdvMenus,
  AdvMenuStylers,
  AdvPanel, AdvEdit, ClipBrd, advlued, dgConsts, AdvToolBar, AdvObj,
  AdvToolBarStylers, AdvUtil, System.Actions, System.ImageList;

type
  TGDAOTableEvent = procedure(ATable: TGDAOTable) of object;

  TfmTableElements = class(TFrame)
    pnTableElements: TPanel;
    ImageList1: TImageList;
    ImageList2: TImageList;
    iActions: TImageList;
    ActionList1: TActionList;
    acIndex_AddField: TAction;
    acIndex_RemoveField: TAction;
    acTable_Remove: TAction;
    popFields: TAdvPopupMenu;
    miAddField: TMenuItem;
    miRemoveField: TMenuItem;
    acField_remove: TAction;
    popIndexes: TAdvPopupMenu;
    miAddIndex: TMenuItem;
    MenuItem4: TMenuItem;
    popIndexFields: TAdvPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    acIndex_RemoveIndex: TAction;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    popConstraints: TAdvPopupMenu;
    miAddConstraint: TMenuItem;
    MenuItem8: TMenuItem;
    acRemoveConstraint: TAction;
    pcTable: TPageControl;
    tsCamposTabela: TTabSheet;
    Splitter9: TSplitter;
    pnListFields: TPanel;
    gCampos: TAdvColumnGrid;
    tsIndicesTabela: TTabSheet;
    Panel7: TPanel;
    Splitter3: TSplitter;
    Panel8: TPanel;
    lvIndices: TListView;
    atPanel2: TPanel;
    tsTableConstraints: TTabSheet;
    Splitter14: TSplitter;
    Panel11: TPanel;
    lvConstraints: TListView;
    atPanel16: TPanel;
    Label74: TLabel;
    tsGatilhos: TTabSheet;
    AdvTabSheet7: TTabSheet;
    pnTableMain: TPanel;
    Label10: TLabel;
    edTableName: TEdit;
    N1: TMenuItem;
    miCopyField: TMenuItem;
    acField_duplicate: TAction;
    acMoveUp: TAction;
    acMoveDown: TAction;
    ScrollBox1: TScrollBox;
    AdvPanel2: TPanel;
    Label11: TLabel;
    Label6: TLabel;
    lbTipoFisico: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    edFieldName: TEdit;
    edTipoFisico: TEdit;
    cbDomain: TComboBox;
    chPrimaryKey: TCheckBox;
    gbFieldCheckConstraint: TPanel;
    Label14: TLabel;
    lbFieldCName: TLabel;
    edFieldCExpr: TEdit;
    edFieldCName: TEdit;
    chSpecificConstraint: TCheckBox;
    pnAutoIncrement: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    edSeed: TAdvLUEdit;
    edIncrement: TAdvLUEdit;
    edTamanhoCampo: TAdvLUEdit;
    edPrecision: TAdvLUEdit;
    ScrollBox2: TScrollBox;
    AdvPanel5: TAdvPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Button1: TButton;
    Button2: TButton;
    gCamposIndice: TAdvColumnGrid;
    AdvPanel4: TAdvPanel;
    Label12: TLabel;
    lbTipoIndice: TLabel;
    lbIndexOrder: TLabel;
    edIndexName: TEdit;
    cbTipoIndice: TComboBox;
    cbIndexOrder: TComboBox;
    AdvPanel6: TAdvPanel;
    Label65: TLabel;
    edConstraintName: TEdit;
    Label66: TLabel;
    edExpression: TEdit;
    frTriggersEditor: TfrTriggersEditor;
    acCopyListField: TAction;
    N2: TMenuItem;
    miMoveFieldUp: TMenuItem;
    miMoveFieldDown: TMenuItem;
    N3: TMenuItem;
    Copyfieldlisttoclipboard1: TMenuItem;
    acCopyListField_Insert: TAction;
    Copyfieldlisttoclipboard2: TMenuItem;
    acCopyListField_Update: TAction;
    N4: TMenuItem;
    INSERTcommand1: TMenuItem;
    UPDATEcommand1: TMenuItem;
    pnLinks: TAdvDockPanel;
    barLinks: TAdvToolBar;
    btLinkDiagram: TAdvToolBarButton;
    btLinkTable: TAdvToolBarButton;
    Panel2: TPanel;
    AdvToolButton1: TAdvToolButton;
    Bevel1: TBevel;
    AdvToolButton2: TAdvToolButton;
    AdvToolButton3: TAdvToolButton;
    btNewField: TAdvToolButton;
    Panel4: TPanel;
    AdvToolButton5: TAdvToolButton;
    Bevel2: TBevel;
    btNewIndex: TAdvToolButton;
    Panel12: TPanel;
    AdvToolButton6: TAdvToolButton;
    Bevel3: TBevel;
    btNewConstraint: TAdvToolButton;
    edComputedExpr: TEdit;
    lbComputedExpr: TLabel;
    cbTipoCampo: TComboBox;
    gbDefaultConstraint: TPanel;
    Label62: TLabel;
    lbFieldDefaultConstraint: TLabel;
    edFieldDefaultValue: TEdit;
    edFieldDefaultConstraint: TEdit;
    chSpecificDefaultValue: TCheckBox;
    gbNotNullConstraint: TPanel;
    chFieldNotNull: TCheckBox;
    lbFieldNotNullConstraint: TLabel;
    edFieldNotNullConstraint: TEdit;
    N5: TMenuItem;
    acViewRelationship: TMenuItem;
    pcFieldDetails: TPageControl;
    tsFieldMain: TTabSheet;
    tsFieldDescription: TTabSheet;
    mFieldComments: TMemo;
    mTableComments: TMemo;
    Label1: TLabel;
    Bevel4: TBevel;
    Label2: TLabel;
    Bevel5: TBevel;
    Label3: TLabel;
    Bevel6: TBevel;
    Label5: TLabel;
    Bevel7: TBevel;
    PanelFields: TPanel;
    FieldPanel: TPanel;
    Label9: TLabel;
    edTableCaption: TEdit;
    Label13: TLabel;
    edFieldCaption: TEdit;
    pnBlank: TPanel;
    Splitter1: TSplitter;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    miFindField: TMenuItem;
    chSpecificRequired: TCheckBox;
    procedure GravaPropriedade(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acIndex_AddFieldUpdate(Sender: TObject);
    procedure acIndex_RemoveFieldUpdate(Sender: TObject);
    procedure gCamposIndiceGetEditText(Sender: TObject; ACol, ARow: Integer; var Value: String);
    procedure acIndex_AddFieldExecute(Sender: TObject);
    procedure acIndex_RemoveFieldExecute(Sender: TObject);
    procedure gCamposIndiceSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
    procedure acField_removeExecute(Sender: TObject);
    procedure acField_removeUpdate(Sender: TObject);
    procedure miAddFieldClick(Sender: TObject);
    procedure miAddIndexClick(Sender: TObject);
    procedure acIndex_RemoveIndexExecute(Sender: TObject);
    procedure acIndex_RemoveIndexUpdate(Sender: TObject);
    procedure cbDomainChange(Sender: TObject);
    procedure chSpecificDefaultValueClick(Sender: TObject);
    procedure acRemoveConstraintUpdate(Sender: TObject);
    procedure acRemoveConstraintExecute(Sender: TObject);
    procedure miAddConstraintClick(Sender: TObject);
    procedure chSpecificConstraintClick(Sender: TObject);
    procedure gCamposClick(Sender: TObject);
    procedure gCamposGetCellBorder(Sender: TObject; ARow, ACol: Integer; APen: TPen; var Borders: TCellBorders);
    procedure gCamposGetCellColor(Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure acField_duplicateUpdate(Sender: TObject);
    procedure acField_duplicateExecute(Sender: TObject);
    procedure acMoveUpUpdate(Sender: TObject);
    procedure acMoveDownUpdate(Sender: TObject);
    procedure acMoveDownExecute(Sender: TObject);
    procedure acMoveUpExecute(Sender: TObject);
    procedure acCopyListFieldUpdate(Sender: TObject);
    procedure acCopyListFieldExecute(Sender: TObject);
    procedure acCopyListField_InsertUpdate(Sender: TObject);
    procedure acCopyListField_UpdateUpdate(Sender: TObject);
    procedure acCopyListField_InsertExecute(Sender: TObject);
    procedure acCopyListField_UpdateExecute(Sender: TObject);
    procedure btLinkDiagramClick(Sender: TObject);
    procedure btLinkTableClick(Sender: TObject);
    procedure gCamposIndiceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lvIndicesEdited(Sender: TObject; Item: TListItem; var S: string);
    procedure lvConstraintsEdited(Sender: TObject; Item: TListItem; var S: string);
    procedure lvIndicesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure lvConstraintsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure acViewRelationshipClick(Sender: TObject);
    procedure pcTableChange(Sender: TObject);
    procedure frTriggersEditorbtDeleteTriggerClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure miFindFieldClick(Sender: TObject);
    procedure chSpecificRequiredClick(Sender: TObject);
  private
    FIsNewObject             : Boolean;
    FLoading                 : integer;
    FOnModification          : TNotifyEvent;
    { listview update control }
    FIndexListChanging: boolean;
    FConstraintListChanging: boolean;
    FMetadata                : TAppMetaData;
    FSelectedTable           : TGDAOTable;
    FOnLinkClick             : TDesignLinkClickEvent;
    FOnUpdateTableName       : TGDAOTableEvent;

    function ProjectFormHandle: HWND;
    function SelectedField: TGDAOField;
    function FieldFromGrid(ARow: integer): TGDAOField;
    function SelectedIndex: TGDAOIndex;
    function GetListTableFields: String;
    procedure OnTableNameChanged(var Msg: TMessage); message WM_DM_OBJECTNAME_CHANGED;
    procedure OnDomainsChange(var Msg: TMessage); message WM_DM_REFRESH_DOMAINS;
    procedure OnNewTableAdded(var Msg: TMessage); message WM_DM_NEW_TABLE;
    procedure LoadIndexList(AList:TListView);
    procedure LoadIndexFieldsGrid(AIndex: TGDAOIndex);
    procedure UpdateFieldIcon(Arow: Integer);
    procedure LoadPredefinedTypes;
    procedure UpdateIndexControlsCompatibilities;
    procedure LoadProperty(Sender: TObject);
    procedure EmptyGrid(AGRid: TAdvColumnGrid);
    procedure SetModified(Sender: TObject);
    procedure SetMetadata(const AMetaData: TAppMetaData);
    procedure LoadTableConstraintsList;
    procedure LoadTableFieldGrid(ASelectField: TGDAOField = nil);
    procedure RefreshSelectedFieldDataType;
    procedure SelectListItemByCaption(AListView: TListView; ACaption: string; APartial: boolean);
    procedure LoadDomainCombo;
    procedure SetSelectedTable(const ATable: TGDAOTable);
    procedure ShowDatabaseFeatures;
    procedure UpdateIndexItemsPanel;
    procedure LoadFieldProperties;
    procedure AddDDItem(Sender: TObject);
    function DeleteDDItem(Sender: TObject): Boolean;
    procedure AddField;
    procedure DeleteSelectedField;
    procedure DuplicateSelectedField;
    procedure DoUpdateTableName(ATable: TGDAOTable);
    procedure DoUpdateFieldName(AField: TGDAOField);
    procedure MakeFormReadOnly(AExceptFields: boolean=False);
    function DisableEditableControls(AControl: TWinControl; AExceptFields: boolean=False): boolean;
    function EnableFieldControl(AControl: TWinControl; ADenyRestriction: TFieldRestriction; AExtraCondition: boolean=True): boolean;
    procedure ToggleSearchFooter(AGrid: TAdvStringGrid; ASearchColumn: integer);
    procedure PropagateFieldCaptionChange(AField: TGDAOField; ANewCaption: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure InitiateAction; override;
    procedure RefreshFullFrameInformation;
    procedure ShowLink(ALinkType: TDesignLinkType; AObject: TObject);
    procedure InitVisualElements;
    procedure ShowTableElement(AElement: TObject);
    property SelectedTable: TGDAOTable read FSelectedTable write SetSelectedTable;
    property OnModification: TNotifyEvent read FOnModification write FOnModification;
    property MetaData: TAppMetaData read FMetadata write SetMetadata;
    property OnLinkClick: TDesignLinkClickEvent read FOnLinkClick write FOnLinkClick;
    property OnUpdateTableName: TGDAOTableEvent read FOnUpdateTableName write FOnUpdateTableName;
  end;

implementation

uses
  Math, uDBProperties, uControlUtils, uAppRegistry;

{$R *.DFM}

function MoveCollectionItem(ACollection:TCollection;AIndex:integer;ATargetCollection:TCollection;ATarget:integer):TCollectionItem;
begin
   if (ACollection=ATargetCollection) then
   begin
      ACollection.Items[AIndex].Index:=ATarget;
      result:=nil;
   end
   else
   begin
      if ATarget>=ATargetCollection.Count then
         result:=ATargetCollection.Add
      else
         result:=ATargetCollection.Insert(ATarget);
      result.Assign( ACollection.Items[AIndex] );
      ACollection.Delete(AIndex);
   end;
end;

{ helper functions }

function ObtemChave(AItem:TObject):TObject;
begin
   { * keeps keys below 1000 for special signals, such as
       the attach mode of a new item being edited }
   result := nil;
   if AItem is TTreeView then
      with TTreeView(AItem) do
         if Assigned(Selected) and (integer(Selected.Data)>999) then
            result:=TObject(Selected.Data)
         else
   else
      if AItem is TListView then
      begin
         with TListView(AItem) do
            if Assigned(Selected) and (integer(Selected.Data)>999) then
               result:=TObject(Selected.Data);
      end
      else
        raise EGUIException.Create('Control type is not supported while retrieving key');
end;

procedure TfmTableElements.LoadPredefinedTypes;
var
  IndexType: TIndexType;
  IndexOrder: TIndexOrder;
begin
  cbTipoIndice.Items.Clear;
  for IndexType := Low(TIndexType) to High(TIndexType) do
    cbTipoIndice.Items.AddObject(IndexTypesStr[IndexType], TObject(Ord(IndexType)));

  cbIndexOrder.Items.Clear;
  for IndexOrder := Low(TIndexOrder) to High(TIndexOrder) do
    cbIndexOrder.Items.AddObject(IndexOrdersStr[IndexOrder], TObject(Ord(IndexOrder)));
end;

procedure TfmTableElements.LoadIndexList(AList:TListView);
var
  c: integer;
begin
   if not Assigned(SelectedTable) then
   begin
      AList.Items.Clear;
      EnableControl(AList, false);
      AList.Tag:=0;
   end
   else
      with AList do
      begin
         Enabled:=true;
         Items.BeginUpDate;
         try
            Items.Clear;

            {add primary key}
            with Items.Add do
            begin
              Caption := SelectedTable.PrimaryKeyIndex.IndexName;
              Data := SelectedTable.PrimaryKeyIndex;
              ImageIndex := 19;
            end;

            for c:=0 to SelectedTable.Indexes.Count - 1 do
               with Items.Add do
               begin
                  Caption := SelectedTable.Indexes[c].IndexName;
                  Data := SelectedTable.Indexes[c];
                  ImageIndex := -1;
               end;
            if Items.Count>0 then
            begin
               Selected:=Items[0];
               Selected.Focused:=true;
            end;
            Tag := integer(SelectedTable.Indexes);
            EnableControl(AList);
         finally
            Items.EndUpDate;
         end;
      end;
end;

procedure TfmTableElements.UpdateIndexItemsPanel;
begin
  LoadProperty(edIndexName);
  LoadProperty(cbTipoIndice);
  LoadProperty(gCamposIndice);
  LoadProperty(cbIndexOrder);
  LoadProperty(cbTipoIndice);
end;

procedure TfmTableElements.LoadProperty(Sender: TObject);
begin
  {set Loading flag because we are going to update wincontrols based
   on object properties. So, we don't want these updates to be considered
   end-user iteractions}
  Inc(FLoading);
  try
    if Sender = edTableName then
    begin
      EnableControl(edTableName, Assigned(FSelectedTable));
      if edTableName.Enabled then
        edTableName.Text := FSelectedTable.TableName
      else
        edTableName.Clear;
    end
    else if Sender = edTableCaption then
    begin
      EnableControl(edTableCaption, Assigned(FSelectedTable));
      if edTableCaption.Enabled then
        edTableCaption.Text := FSelectedTable.TableCaption
      else
        edTableCaption.Clear;
    end
    else if Sender = mTableComments then
    begin
      EnableControl(mTableComments, Assigned(FSelectedTable));
      if mTableComments.Enabled then
        mTableComments.Text := FSelectedTable.Description
      else
        mTableComments.Clear;
    end
    else if Sender = gCampos then { load the list of table fields }
      LoadTableFieldGrid
    else if Sender = lvIndices then
      LoadIndexList(lvIndices)
    else if Sender = lvConstraints then
      LoadTableConstraintsList
    else if Sender = edIndexName then { index properties }
    begin
      EnableControl(edIndexName, SelectedIndex <> nil);
      if edIndexName.Enabled then
        edIndexName.Text := SelectedIndex.IndexName
      else
        edIndexName.Clear;
    end
    else if Sender = cbTipoIndice then
    begin
      lbTipoIndice.Visible := (SelectedIndex <> nil) and not SelectedIndex.IsPrimary;
      cbTipoIndice.Visible := (SelectedIndex <> nil) and not SelectedIndex.IsPrimary;
      EnableControl(cbTipoIndice, (SelectedIndex <> nil) and not SelectedIndex.IsPrimary);
      if cbTipoIndice.Enabled then
        cbTipoIndice.ItemIndex := IndexOfKey(cbTipoIndice.Items, Ord(SelectedIndex.IndexType))
      else
        cbTipoIndice.ItemIndex := -1;
    end
    else if Sender = gCamposIndice then
      LoadIndexFieldsGrid(SelectedIndex)
    else if Sender = cbIndexOrder then
    begin
      EnableControl(cbIndexOrder, (SelectedIndex <> nil) and not FMetadata.DataDictionary.DatabaseType.EnableIndexOrderByField);
      if cbIndexOrder.Enabled then
        cbIndexOrder.ItemIndex := IndexOfKey(cbIndexOrder.Items, Ord(SelectedIndex.IndexOrder))
      else
        cbIndexOrder.ItemIndex := -1;
    end
    else if Sender = edFieldName then { field properties }
    begin
      if EnableFieldControl(edFieldName, frPartialReadOnly) then
        edFieldName.Text := SelectedField.FieldName
      else
        edFieldName.Clear;
    end
    else if Sender = edFieldCaption then
    begin
      if EnableFieldControl(edFieldCaption, frReadOnly) then
        edFieldCaption.Text := SelectedField.FieldCaption
      else
        edFieldCaption.Clear;
    end
    else if Sender = cbDomain then
    begin
      if EnableFieldControl(cbDomain, frReadOnly, (SelectedField <> nil) and not SelectedField.IsInRelationship) then
      begin
        if Assigned(SelectedField.Domain) then
          cbDomain.ItemIndex := cbDomain.Items.IndexOfObject(SelectedField.Domain)
        else
          cbDomain.ItemIndex := 0;
      end
      else
        cbDomain.ItemIndex := -1;
    end
    else if Sender = cbTipoCampo then
    begin
      if EnableFieldControl(cbTipoCampo, frReadOnly) then
      begin
        cbTipoCampo.ItemIndex := cbTipoCampo.Items.IndexOfObject(SelectedField.DataType);
        RefreshSelectedFieldDataType;
      end
      else
      begin
        edTipoFisico.Text := '';
        cbTipoCampo.ItemIndex := 0;
        pnAutoIncrement.Visible := false;
      end;
    end
    else if Sender = edTipoFisico then
    begin
      lbTipoFisico.Visible := (SelectedField = nil) or not SelectedField.DataType.Computed;
      edTipoFisico.Visible := (SelectedField = nil) or not SelectedField.DataType.Computed;
      if SelectedField <> nil then
        edTipoFisico.Text := SelectedField.DataType.BuildPhysicalExpression(SelectedField)
      else
        edTipoFisico.Text := '';
    end
    else if Sender = edTamanhoCampo then
    begin
      if EnableFieldControl(edTamanhoCampo, frReadOnly, (SelectedField <> nil) and SelectedField.DataType.SizeIsRequired
        and not Assigned(SelectedField.Domain) and not SelectedField.IsInRelationship) then
      begin
        if StrToIntDef(edTamanhoCampo.Text, 0) <> SelectedField.Size then
          edTamanhoCampo.Text := IntToStr(SelectedField.Size);
      end
      else
        if (SelectedField <> nil) and Assigned(SelectedField.Domain) and (SelectedField.Size <> 0) then
        begin
          if StrToIntDef(edTamanhoCampo.Text, 0) <> SelectedField.Size then
            edTamanhoCampo.Text := IntToStr(SelectedField.Size);
        end
        else
          edTamanhoCampo.Clear;
    end
    else if Sender = edPrecision then
    begin
      if EnableFieldControl(edPrecision, frReadOnly, (SelectedField <> nil) and SelectedField.DataType.Size2IsRequired
        and not Assigned(SelectedField.Domain) and not SelectedField.IsInRelationship) then
      begin
        if StrToIntDef(edPrecision.Text, 0) <> SelectedField.Size2 then
          edPrecision.Text := IntToStr(SelectedField.Size2);
      end
      else
        if (SelectedField <> nil) and Assigned(SelectedField.Domain) and (SelectedField.Size2 <> 0) then
        begin
          if StrToIntDef(edPrecision.Text, 0) <> SelectedField.Size2 then
            edPrecision.Text := IntToStr(SelectedField.Size2);
        end
        else
          edPrecision.Clear;
    end
    else if Sender = edComputedExpr then
    begin
      lbComputedExpr.Visible := (SelectedField <> nil) and SelectedField.DataType.Computed;
      edComputedExpr.Visible := (SelectedField <> nil) and SelectedField.DataType.Computed;
      if EnableFieldControl(edComputedExpr, frReadOnly, (SelectedField <> nil) and SelectedField.DataType.Computed) then
        edComputedExpr.Text := SelectedField.Expression
      else
        edComputedExpr.Clear;
    end
    else if Sender = edSeed then
    begin
      if EnableFieldControl(edSeed, frReadOnly, (SelectedField <> nil) and SelectedField.DataType.SeedIsRequired and not Assigned(SelectedField.Domain)) then
      begin
        if StrToIntDef(edSeed.Text, 0) <> SelectedField.SeedValue then
          edSeed.Text := IntToStr(SelectedField.SeedValue);
      end
      else
        edSeed.Clear;
    end
    else if Sender = edIncrement then
    begin
      if EnableFieldControl(edIncrement, frReadOnly, (SelectedField <> nil) and SelectedField.DataType.IncrementIsRequired and not Assigned(SelectedField.Domain)) then
      begin
        if StrToIntDef(edIncrement.Text, 0) <> SelectedField.IncrementValue then
          edIncrement.Text := IntToStr(SelectedField.IncrementValue);
      end
      else
        edIncrement.Clear;
    end
    else if Sender = chFieldNotNull then
    begin
      chFieldNotNull.Checked := (SelectedField <> nil) and SelectedField.Required;
      EnableFieldControl(chFieldNotNull, frPartialReadOnly,
        {not chPrimaryKey.Checked and }(
          (SelectedField <> nil) and SelectedField.IsRequiredEnabled
        )
      );
    end
    else if Sender = edFieldNotNullConstraint then
    begin
      if SelectedField <> nil then
        edFieldNotNullConstraint.Text :=  SelectedField.ConstraintNotNullName
      else
        edFieldNotNullConstraint.Clear;
    end
    else if Sender = chPrimaryKey then
    begin
      chPrimaryKey.Checked := (SelectedField <> nil) and SelectedField.InPrimaryKey;
      EnableFieldControl(chPrimaryKey, frPartialReadOnly);
    end
    else if Sender = chSpecificDefaultValue then
    begin
      if EnableFieldControl(chSpecificDefaultvalue, frReadOnly, (SelectedField <> nil) and Assigned(SelectedField.Domain)) then
        chSpecificDefaultValue.Checked := SelectedField.DefaultValueSpecific
      else
        chSpecificDefaultValue.Checked := false;
    end
    else if Sender = chSpecificRequired then
    begin
      if EnableFieldControl(chSpecificRequired, frReadOnly, (SelectedField <> nil) and Assigned(SelectedField.Domain)) then
        chSpecificRequired.Checked := SelectedField.RequiredSpecific
      else
        chSpecificRequired.Checked := false;
    end
    else if Sender = chSpecificConstraint then
    begin
      if EnableFieldControl(chSpecificConstraint, frPartialReadOnly, (SelectedField <> nil) and Assigned(SelectedField.Domain)) then
        chSpecificConstraint.Checked := SelectedField.ConstraintExprSpecific
      else
        chSpecificConstraint.Checked := false;
    end
    else if Sender = edFieldDefaultValue then
    begin
      if EnableFieldControl(edFieldDefaultValue, frReadOnly) then
      begin
        edFieldDefaultValue.Text := SelectedField.DefaultValue;
        EnableControl(edFieldDefaultValue, SelectedField.IsDefaultValueEnabled and (SelectedField.DataType <> nil)
          and not SelectedField.DataType.SeedIsRequired and not SelectedField.DataType.IncrementIsRequired);
      end
      else
        edFieldDefaultValue.Clear;
      EnableFieldControl(edFieldDefaultConstraint, frReadOnly, (edFieldDefaultValue.Text > '') and Assigned(FSelectedTable)
        and FSelectedTable.OwnerDatabase.DatabaseType.EnableConstraintDefaultName);
    end
    else if Sender = edFieldDefaultConstraint then
    begin
      if SelectedField <> nil then
        edFieldDefaultConstraint.Text := SelectedField.ConstraintDefaultName
      else
        edFieldDefaultConstraint.Clear;
    end
    else if Sender = mFieldComments then
    begin
      if EnableFieldControl(mFieldComments, frReadOnly) then
        mFieldComments.Text := SelectedField.Description
      else
        mFieldComments.Clear;
    end
    else if Sender = edFieldCExpr then
    begin
      if EnableFieldControl(edFieldCExpr, frPartialReadOnly, SelectedField <> nil) then
      begin
        edFieldCExpr.Text := SelectedField.ConstraintExpr;
        EnableControl(edFieldCExpr, SelectedField.IsConstraintExprEnabled);
      end
      else
        edFieldCExpr.Clear;
      EnableFieldControl(edFieldCName, frPartialReadOnly, (edFieldCExpr.Text > '') and Assigned(FSelectedTable) and
        FSelectedTable.OwnerDatabase.DatabaseType.EnableConstraintCheckFldName);
    end
    else if Sender = edFieldCName then
    begin
      if SelectedField <> nil then
       edFieldCName.Text := SelectedField.ConstraintName
      else
       edFieldCName.Text := '';
    end
    else if Sender = edConstraintName then { table constraint properties }
    begin
      EnableControl(edConstraintName, lvConstraints.Selected <> nil);
      if Assigned(ObtemChave(lvConstraints)) then
        edConstraintName.Text := TGDAOConstraint(ObtemChave(lvConstraints)).ConstraintName
      else
        edConstraintName.Text := '';
    end
    else if Sender = edExpression then
    begin
      EnableControl(edExpression, lvConstraints.Selected <> nil);
      if Assigned(ObtemChave(lvConstraints)) then
        edExpression.Text := TGDAOConstraint(ObtemChave(lvConstraints)).Expression
      else
        edExpression.Text := '';
    end;
  finally
    Dec(FLoading);
  end;
end;

procedure TfmTableElements.GravaPropriedade(Sender:TObject);
begin
  { Check if it's not manually loading (by LoadProperty method) to avoid recursion }
  if FLoading = 0 then
  begin
    { table properties }
    if (Sender = edTableName) and Assigned(FSelectedTable) then
    begin
      if FSelectedTable.TableName <> edTableName.Text then
        SetModified(self);
      FSelectedTable.TableName := edTableName.Text;
      DoUpdateTableName(FSelectedTable);
    end
    else if (Sender = edTableCaption) and Assigned(FSelectedTable) then
    begin
      if FSelectedTable.TableCaption <> edTableCaption.Text then
        SetModified(Self);
      FSelectedTable.TableCaption := edTableCaption.Text;
    end
    else if (Sender = mTableComments) and (FSelectedTable <> nil) then
    begin
      if FSelectedTable.Description <> mTableComments.Text then
        SetModified(self);
      FSelectedTable.Description := mTableComments.Text;
    end
    else if (Sender = edIndexName) and (SelectedIndex <> nil) then { index properties }
    begin
      if SelectedIndex.IndexName <> edIndexName.Text then
        SetModified(Self);
      SelectedIndex.IndexName := edIndexName.Text;
      lvIndices.Selected.Caption := edIndexName.Text;
    end
    else if Sender = cbTipoIndice then
    begin
      SetModified(self);
      SelectedIndex.IndexType := TIndexType(cbTipoIndice.Items.Objects[cbTipoIndice.ItemIndex]);
    end
    else if (Sender = cbIndexOrder) and (SelectedIndex.IndexOrder <> TIndexOrder(cbIndexOrder.Items.Objects[cbIndexOrder.ItemIndex])) then
    begin
      SetModified(self);
      SelectedIndex.IndexOrder := TIndexOrder(cbIndexOrder.Items.Objects[cbIndexOrder.ItemIndex]);
    end
    else if (Sender = edFieldName) and (SelectedField <> nil) then { field properties }
    begin
      if SelectedField.FieldName <> edFieldName.Text then
        SetModified(self);
      SelectedField.FieldName := edFieldName.Text;
      DoUpdateFieldName(SelectedField);
    end else if (Sender = edFieldCaption) and (SelectedField <> nil) then
    begin
      if SelectedField.FieldCaption <> edFieldCaption.Text then
      begin
        SetModified(Self);
        if DMRegistry.AutoFieldRelationship then
          PropagateFieldCaptionChange(SelectedField, edFieldCaption.Text);
      end;
      SelectedField.FieldCaption := edFieldCaption.Text;
    end
    else if Sender = cbDomain then
    begin
      SetModified(self);
      if cbDomain.ItemIndex = 0 then
        SelectedField.DomainName := ''
      else
        SelectedField.DomainName := TGDAODomain(cbDomain.Items.Objects[cbDomain.ItemIndex]).Name;
    end
    else if (Sender = cbTipoCampo) and (SelectedField.DataType <> TGDAODataType(cbTipoCampo.Items.Objects[cbTipoCampo.ItemIndex])) then
    begin
      SelectedField.DataTypeName := TGDAODataType(cbTipoCampo.Items.Objects[cbTipoCampo.ItemIndex]).Name;
      SetModified(self);
      RefreshSelectedFieldDataType;
    end
    else if Sender = edTamanhoCampo then
    begin
      if (SelectedField <> nil) and (SelectedField.Size <> StrToIntDef(edTamanhoCampo.Text, 0)) then
      begin
        SelectedField.Size := StrToIntDef(edTamanhoCampo.Text, 0);
        SetModified(Self);
      end;
      RefreshSelectedFieldDataType;
    end
    else if Sender = edPrecision then
    begin
      if (SelectedField <> nil) and (SelectedField.Size2 <> StrToIntDef(edPrecision.Text, 0)) then
      begin
        SelectedField.Size2 := StrToIntDef(edPrecision.Text, 0);
        SetModified(Self);
      end;
      RefreshSelectedFieldDataType;
    end
    else if Sender = edComputedExpr then
    begin
      if (SelectedField <> nil) and (SelectedField.Expression <> edComputedExpr.Text) then
      begin
        SelectedField.Expression := edComputedExpr.Text;
        SetModified(Self);
      end;
      RefreshSelectedFieldDataType;
    end
    else if Sender = edSeed then
    begin
      if (SelectedField <> nil) and (SelectedField.SeedValue <> StrToIntDef(edSeed.Text, 0)) then
      begin
        SelectedField.SeedValue := StrToIntDef(edSeed.Text, 0);
        SetModified(Self);
      end;
    end
    else if Sender = edIncrement then
    begin
      if (SelectedField <> nil) and (SelectedField.IncrementValue <> StrToIntDef(edIncrement.Text, 0)) then
      begin
        SelectedField.IncrementValue := StrToIntDef(edIncrement.Text, 0);
        SetModified(Self);
      end;
    end
    else if Sender = chFieldNotNull then
    begin
      if (SelectedField <> nil) and (SelectedField.Required <> chFieldNotNull.Checked) then
      begin
        SelectedField.Required := chFieldNotNull.Checked;
        SetModified(Self);
      end;
      gCampos.Invalidate;
    end
    else if Sender=chPrimaryKey then
    begin
      if (SelectedField <> nil) and (SelectedField.InPrimaryKey <> chPrimaryKey.Checked) then
      begin
        SelectedField.InPrimaryKey := chPrimaryKey.Checked;
        SetModified(Self);
      end;

//      EnableFieldControl(chFieldNotNull, frPartialReadOnly, not chPrimaryKey.Checked);
      if chPrimaryKey.Checked and chFieldNotNull.Enabled then
      begin
        chFieldNotNull.Checked := true;
        GravaPropriedade(chFieldNotNull);
      end;

      UpdateFieldIcon(gCampos.Row);
      UpdateIndexItemsPanel;
    end
    else if Sender = edFieldDefaultValue then
    begin
      if (SelectedField <> nil) and (SelectedField.DefaultValue <> edFieldDefaultValue.Text) then
      begin
        SelectedField.DefaultValue := edFieldDefaultValue.Text;
        SetModified(Self);
      end;
    end
    else if Sender = mFieldComments then
    begin
      if SelectedField.Description <> mFieldComments.Text then
        SetModified(self);
      SelectedField.Description := mFieldComments.Text;
    end
    else if Sender = edFieldCExpr then
    begin
      if (SelectedField <> nil) and (SelectedField.ConstraintExpr <> edFieldCExpr.Text) then
      begin
        SelectedField.ConstraintExpr := edFieldCExpr.Text;
        SetModified(Self);
      end;
    end
    else if Sender = edFieldCName then
    begin
      if (SelectedField <> nil) and (SelectedField.ConstraintName <> edFieldCName.Text) then
      begin
        SelectedField.ConstraintName := edFieldCName.Text;
        SetModified(Self);
      end;
    end
    else if Sender = edFieldNotNullConstraint then
    begin
     if (SelectedField <> nil) and (SelectedField.ConstraintNotNullName <> edFieldNotNullConstraint.Text) then
     begin
       SelectedField.ConstraintNotNullName := edFieldNotNullConstraint.Text;
       SetModified(Self);
     end;
    end
    else if Sender = edFieldDefaultConstraint then
    begin
      if (SelectedField <> nil) and (SelectedField.ConstraintDefaultName <> edFieldDefaultConstraint.Text) then
      begin
        SelectedField.ConstraintDefaultName := edFieldDefaultConstraint.Text;
        SetModified(Self);
      end;
    end
    else if (Sender=edConstraintName) and (TGDAOConstraint(lvConstraints.Selected.Data).ConstraintName <> edConstraintName.Text) then
    begin { save table constraint properties }
      if edConstraintName.Text > '' then
      begin
        lvConstraints.Selected.Caption := edConstraintName.Text;
        TGDAOConstraint(ObtemChave(lvConstraints)).ConstraintName := edConstraintName.Text;
        SetModified(self);
      end
      else
        LoadProperty(edConstraintName);
    end
    else if (Sender = edExpression) and (TGDAOConstraint(lvConstraints.Selected.Data).Expression <> edExpression.Text) then
    begin
      TGDAOConstraint(ObtemChave(lvConstraints)).Expression := edExpression.Text;
      SetModified(self);
    end;

    {Update controls after the update}
    LoadProperty(Sender);
  end;
end;

procedure TfmTableElements.InitiateAction;
begin
  inherited;
  acViewRelationship.Enabled := (SelectedField <> nil) and SelectedField.IsForeignKey;
end;

procedure TfmTableElements.InitVisualElements;
var
  c: integer;
begin
  for c := 0 to ComponentCount - 1 do
    if Components[c] is TWinControl then
    begin
      {workaround for the tms grid bug. If we set double buffered, any cell gets black
       if it is clicked twice.}
      if Components[c] <> gCampos then
        TWinControl(Components[c]).DoubleBuffered := true;
    end;

  pnTableMain.DoubleBuffered := true;
  pnTableElements.DoubleBuffered := true;

  pcTable.ActivePage := tsCamposTabela;
  pcFieldDetails.ActivePage := tsFieldMain;
  gCamposIndice.MouseActions.DirectComboDrop := true;
  gCamposIndice.MouseActions.DirectComboClose := true;
  gCamposIndice.MouseActions.DirectEdit := true;
end;

function TfmTableElements.SelectedField: TGDAOField;
begin
  result := FieldFromGrid(gCampos.Row);
end;

function TfmTableElements.SelectedIndex: TGDAOIndex;
begin
  if (lvIndices.Selected <> nil) and (integer(lvIndices.Selected.Data) > 999) then
    result := TGDAOIndex(lvIndices.Selected.Data)
  else
    result := nil;
end;

procedure TfmTableElements.SelectListItemByCaption(AListView: TListView;
  ACaption: string; APartial: boolean);
var
  c: integer;
begin
  with AListView do
    for c := 0 to Items.Count - 1 do
      if (APartial and (Pos(AnsiUpperCase(ACaption),AnsiUpperCase(Items[c].Caption))=1)) or
        (AnsiCompareText(ACaption,Items[c].Caption) = 0) then
      begin
        Selected := Items[c];
        Selected.Focused := true;
        Selected.MakeVisible(false);
        Break;
      end;
end;

function TfmTableElements.FieldFromGrid(ARow: integer): TGDAOField;
begin
  if Assigned(gCampos.Objects[0, ARow]) and (gCampos.Objects[0, ARow] is TGDAOField) then
    result := TGDAOField(gCampos.Objects[0, ARow])
  else
    result := nil;
end;

{ Indexes }

procedure TfmTableElements.lvIndicesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if not FIndexListChanging and (Change=ctState) and
    ((Item = lvIndices.Selected) or (lvIndices.Selected = nil)) then
  begin
    FIndexListChanging := true;
    try
      UpdateIndexItemsPanel;
      if FIsNewObject then
      begin
        edIndexName.SelectAll;
        edIndexName.SetFocus;
      end;
      FIsNewObject := false;
    finally
      FIndexListChanging := false;
    end;
  end;
end;

procedure TfmTableElements.lvIndicesEdited(Sender: TObject; Item: TListItem;
  var S: string);
begin
   with TListView(Sender) do
   begin
      if not Assigned(Selected.Data) then
      begin
        { end of insertion }
        if (S = '') then
        begin
          { ignore new null keys }
          Listviewcleaner.ListViewItemDeleted(Selected);
          Selected.Delete;
          exit;
        end
        else
        begin
          { add the new key }
          Selected.Data := pointer(TGDAOIndexes(Tag).Add(S));
          SetModified(self);
        end
      end
      else
      begin
        { end of edit }
        if (S='') then
          { discard the edit if the key name became null or if editing the selected item is not allowed }
          S:=Selected.Caption
        else
        begin
          { open the selected key and modify its name }
          if Sender = lvConstraints then
            TGDAOConstraint(Selected.Data).ConstraintName := s
          else
            TGDAOIndex(Selected.Data).IndexName := S;
          SetModified(self);
        end;
      end;
      { trigger OnChange for the edited item }
      if Assigned(OnChange) then OnChange(Sender,Item,ctState);

      if Assigned(Selected) then
      begin
         Selected.Caption:=S;
         Selected.MakeVisible(false);
      end;
   end;
end;

procedure TfmTableElements.FormClose(Sender: TObject; var Action: TCloseAction);
var
  c: integer;
begin
  { avoid calling OnChange on ListViews while destroying the form }
  for c:=0 to ComponentCount-1 do
    if Components[c] is TListView then
      TListView(Components[c]).OnChange:=nil;
end;

procedure TfmTableElements.FrameResize(Sender: TObject);
const
  DEFAULT_WIDTH = 700;
begin
  pnTableElements.Width := Min(DEFAULT_WIDTH, Width);
end;

procedure TfmTableElements.frTriggersEditorbtDeleteTriggerClick(Sender: TObject);
begin
  frTriggersEditor.btDeleteTriggerClick(Sender);
end;

procedure TfmTableElements.acIndex_AddFieldUpdate(Sender: TObject);
var
  l: TList;
begin
  l := nil;
  if (SelectedIndex <> nil) then
    l := SelectedIndex.GetTableAvailableFieldsList;
  try
    acIndex_AddField.Enabled := (Assigned(lvIndices.Selected)) and (l.Count > 0) and not SelectedIndex.OwnerTable.ReadOnly;
  finally
    if l <> nil then
      l.Free;
  end;
end;

procedure TfmTableElements.acIndex_RemoveFieldUpdate(Sender: TObject);
begin
  acIndex_RemoveField.Enabled := Assigned(lvIndices.Selected) and (gCamposIndice.Cells[0, gCamposIndice.Row] <> '');
end;

procedure TfmTableElements.LoadIndexFieldsGrid(AIndex: TGDAOIndex);
var
  c: integer;
begin
   gCamposIndice.ClearRows(1, gCamposIndice.Rowcount-1);
   if AIndex = nil then
   begin
      gCamposIndice.Rowcount := 2;
      gCamposIndice.Row := 1;
      gCamposIndice.Options := gCamposIndice.Options + [goRowSelect] - [goEditing];
      EnableControl(gCamposIndice, false);
   end
   else
      with gCamposIndice do
      begin
         EnableControl(gCamposIndice);
         Options := Options - [goRowSelect] + [goEditing];
         // removing row select mask
         RowCount := 1 + AIndex.IFields.Count + 2;
         RowCount := Rowcount - 1;

         for c:=0 to AIndex.IFields.Count-1 do
         begin
            Cells[0,c+1] := AIndex.IFields.Items[c].FieldName;
            Cells[1,c+1] := IndexFieldOrdersStr[AIndex.IFields.Items[c].FieldOrder];
         end;
         if AIndex.IFields.Count > 0 then
            RowCount := Rowcount - 1;
      end;
end;

procedure TfmTableElements.gCamposIndiceGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
var i, idx : Integer;
    l : TList;
    IndexFieldOrder: TIndexFieldOrder;
begin
  // table fields combo
  idx := 0;
  if ACol = 0 then
  begin
    with gCamposIndice.Combobox do
    begin
      Items.Clear;
      if Assigned(FSelectedTable) then
      begin
        l := SelectedIndex.GetTableAvailableFieldsList;
        try
          if Value <> '' then
            Items.AddObject(SelectedIndex.IFields.Items[ARow-1].FieldName,
                            TObject(SelectedIndex.IFields.Items[ARow-1].Field));
          for i := 0 to l.Count-1 do
          begin
            Items.AddObject(TGDAOField(l[i]).FieldName, TObject(l[i]));
            if (Value <> '') and (Value = TGDAOField(l[i]).FieldName) then
              idx := Items.Count-1;
          end;
          ItemIndex := idx;
        finally
          l.Free;
        end;
      end;
    end;
  end else
  begin
    with gCamposIndice.Combobox do
    begin
      Items.Clear;
      for IndexFieldOrder := Low(TIndexFieldOrder) to High(TIndexFieldOrder) do
      begin
        Items.Add(IndexFieldOrdersStr[IndexFieldOrder]);
        if (Value <> '') and (IndexFieldOrdersStr[IndexFieldOrder] = Value) then
          ItemIndex := Items.Count - 1;
      end;
    end;
  end
end;

procedure TfmTableElements.acIndex_AddFieldExecute(Sender: TObject);
begin
  if gCamposIndice.Cells[0, gCamposIndice.RowCount - 1] > '' then
  begin
    gCamposIndice.RowCount := gCamposIndice.RowCount + 1;
    gCamposIndice.Row      := gCamposIndice.RowCount-1;
  end;
  gCamposIndice.Cells[1, gCamposIndice.Row] := IndexFieldOrdersStr[ioAsc];
  gCamposIndice.Setfocus;
  gCamposIndice.Col := 0;
  gCamposIndice.ShowCellEdit;
end;

procedure TfmTableElements.acIndex_RemoveFieldExecute(Sender: TObject);
begin
  FIndexListChanging := true;
  try
    SelectedIndex.IFields.Delete(gCamposIndice.Row-1);
    LoadIndexFieldsGrid(SelectedIndex);
    LoadTableFieldGrid;
  finally
    FIndexListChanging := false;
  end;
  SetModified(nil);
end;

procedure TfmTableElements.gCamposIndiceSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if FIndexListChanging then exit;

  if ACol = 0 then
  begin
    // field combo
    if gCamposIndice.Combobox.ItemIndex > -1 then
    begin
      with SelectedIndex.IFields do
      begin
        if count < ARow then
          Add(TGDaoField(gCamposIndice.Combobox.Items.Objects[gCamposIndice.Combobox.ItemIndex]))
        else
          Field[ARow-1] := TGDaoField(gCamposIndice.Combobox.Items.Objects[gCamposIndice.Combobox.ItemIndex]);
      end;
      // auto ASC field order
      if gCamposIndice.Cells[1, ARow] = '' then
        gCamposIndice.Cells[1, ARow] := IndexFieldOrdersStr[ioAsc];
      SetModified(nil);

      LoadTableFieldGrid;
    end;
  end
  else
  if gCamposIndice.Cells[0,ARow] <> '' then
  begin
    // field order combo
    with SelectedIndex.IFields do
      Items[ARow-1].FieldOrder := TIndexFieldOrder(gCamposIndice.ComboBox.ItemIndex);
    SetModified(nil);
  end;
end;

procedure TfmTableElements.ToggleSearchFooter(AGrid: TAdvStringGrid;
  ASearchColumn: integer);
begin
  if AGrid.SearchFooter.Visible then
    AGrid.SearchFooter.Visible := false
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

procedure TfmTableElements.AddField;
begin
  if not FSelectedTable.ReadOnly then
  begin
    SetModified(Self);

    {Add the new field, reload the table grid, and pass the newly created
     field as the field to be selected}
    LoadTableFieldGrid(FSelectedTable.Fields.Add(
      FSelectedTable.Fields.GetNewFieldName,
      FMetadata.DataDictionary.DataTypes.GetDefaultDataType, 0,0, false));

    if edFieldName.Visible and edFieldName.CanFocus then
    begin
      edFieldName.SelectAll;
      edFieldName.SetFocus;
    end;
  end;
end;

procedure TfmTableElements.DeleteSelectedField;
var
  ToSelect: TGDAOField;
begin
  if (SelectedField <> nil) and not FSelectedTable.ReadOnly then
  begin
    if (SelectedField.IsInRelationship) then
      MessageDlg('This field belongs to a relationship and cannot be deleted.', mtError, [mbOk], 0)
    else
    begin
      if (DialogMsg(Format(SConfirmItemExclusion, [SelectedField.FieldName]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        {Before deleting the field, set the object to be selected
         after the field is destroyed}
        if SelectedField.Index < (SelectedTable.Fields.Count - 1) then
          ToSelect := SelectedTable.Fields[SelectedField.Index + 1]
        else
        if SelectedField.Index > 0 then
          ToSelect := SelectedTable.Fields[SelectedField.Index - 1]
        else
          ToSelect := nil;

        SelectedField.Free;
        SetModified(Self);
        LoadTableFieldGrid(ToSelect);

        {update index panel because the delete field might be present
         in the index grid, so it must be removed from there too}
        UpdateIndexItemsPanel;
      end;
    end;
  end;
end;

function TfmTableElements.DisableEditableControls(AControl: TWinControl; AExceptFields: boolean=False): boolean;
var
  i, j: integer;
  ctrl: TControl;
begin
  result := False;
  if AExceptFields and (AControl = tsCamposTabela) then
    exit;

  for i := 0 to AControl.ControlCount - 1 do
  begin
    ctrl := AControl.Controls[i];
    if ctrl is TAdvColumnGrid then
    begin
      for j := 0 to TAdvColumnGrid(ctrl).Columns.Count - 1 do
        TAdvColumnGrid(ctrl).Columns[j].ReadOnly := True;
      result := True;
    end
    else if ctrl is TListView then
    begin
      TListView(ctrl).ReadOnly := True;
      result := True;
    end
    else if ((ctrl is TWinControl) and DisableEditableControls(TWinControl(ctrl), AExceptFields)) or (ctrl is TPageControl) then
      result := True;
  end;
  AControl.Enabled := result;
end;

procedure TfmTableElements.DoUpdateFieldName(AField: TGDAOField);
begin
  gCampos.Cells[0, gCampos.Row] := AField.FieldName;
  LoadProperty(edFieldCaption);
end;

procedure TfmTableElements.DoUpdateTableName(ATable: TGDAOTable);
begin
  LoadProperty(edTableCaption);
  if Assigned(FOnUpdateTableName) then
    FOnUpdateTableName(ATable);
end;

procedure TfmTableElements.AddDDItem(Sender: TObject);
var
  s: string;
begin
  if (Sender is TListView) and not FSelectedTable.ReadOnly then
  begin
    with TListView(Sender) do
    begin
      if not IsEditing and Enabled then
      begin
        Selected:=Items.Add;
        Selected.Focused:=true;
        Selected.ImageIndex:=-1;
        Selected.MakeVisible(false);
        if Sender = lvIndices then
        begin
          s := FSelectedTable.Indexes.GetNewIndexName;
          Selected.Caption := s;
          FIsNewObject := true;
          lvIndicesEdited(Sender, Selected, S);
        end else if Sender = lvConstraints then
        begin
          s := FSelectedTable.Constraints.GetNewConstraintName;
          Selected.Caption := s;
          FIsNewObject := true;
          lvConstraintsEdited(Sender, Selected, S);
        end
        else
        begin
          Listviewcleaner.AddListViewItem(Selected);
          Selected.EditCaption;
        end;
      end;
    end;
  end;
end;

function TfmTableElements.DeleteDDItem(Sender: TObject): Boolean;
begin
  Result := false;
  if not FSelectedTable.ReadOnly then
  begin
    if (Sender = gCampos) and (SelectedField.IsInRelationship) then
      Messagedlg('Fields in relationship cannot be deleted', mtError, [mbOk],0)
    else
    begin
      if Sender is TListView then
      begin
        with TListView(Sender) do
        begin
          Selected.MakeVisible(false);
          begin
            if (DialogMsg(Format(SConfirmItemExclusion,[Selected.Caption]),mtConfirmation,[mbYes,mbNo],0)=mrYes) then
            begin
               { delete the collection item }
               if Assigned(Selected.Data) and (TObject(Selected.Data) is TCollectionItem) then
               with TCollectionItem(Selected.Data) do
               begin
                  Free;
                  Result := true;
                  SetModified(self);
                  Items.Delete(Selected.Index);
               end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmTableElements.acField_removeExecute(Sender: TObject);
begin
  DeleteSelectedField;
end;

procedure TfmTableElements.acField_removeUpdate(Sender: TObject);
begin
  acField_remove.Enabled := (SelectedField <> nil) and (SelectedField.Restriction = frNone)
    and (SelectedField.OwnerTable <> nil) and not SelectedField.OwnerTable.ReadOnly;
end;

procedure TfmTableElements.miAddFieldClick(Sender: TObject);
begin
  AddField;
end;

procedure TfmTableElements.miAddIndexClick(Sender: TObject);
begin
  AddDDItem(lvIndices);
end;

procedure TfmTableElements.miFindFieldClick(Sender: TObject);
begin
  ToggleSearchFooter(gCampos, 0);
end;

procedure TfmTableElements.acIndex_RemoveIndexExecute(Sender: TObject);
begin
  DeleteDDItem(lvIndices);
end;

procedure TfmTableElements.acIndex_RemoveIndexUpdate(Sender: TObject);
begin
  acIndex_RemoveIndex.Enabled := (SelectedIndex <> nil) and not (SelectedIndex.IsPrimary or SelectedIndex.OwnerTable.ReadOnly);
end;

procedure TfmTableElements.cbDomainChange(Sender: TObject);
begin
  GravaPropriedade(cbDomain);

  LoadProperty(cbTipoCampo);
  LoadProperty(edTamanhoCampo);
  LoadProperty(edPrecision);
  LoadProperty(edSeed);
  LoadProperty(edIncrement);
  LoadProperty(chSpecificDefaultValue);
  LoadProperty(chSpecificConstraint);
  LoadProperty(chSpecificRequired);
  LoadProperty(edFieldDefaultValue);
  LoadProperty(edFieldCExpr);
  LoadProperty(edFieldDefaultConstraint);
  LoadProperty(chFieldNotNull);

  if cbDomain.ItemIndex > 0 then
  begin
    // get domain internal types
    //SelectedField.AssignDomainSettings;
    with TGDAODomain(cbDomain.Items.Objects[cbDomain.ItemIndex]) do
    begin
      edFieldDefaultValue.Text  := DefaultValue;
      edFieldCExpr.Text   := ConstraintExpr;
    end;
  end else
  begin
    // restore values
    with SelectedField do
    begin
      cbTipoCampo.OnChange(nil);
      chSpecificDefaultValue.Checked := false;
      chSpecificRequired.Checked := false;
      chSpecificConstraint.Checked   := false;
      EnableFieldControl(edFieldDefaultValue, frReadOnly);
      EnableFieldControl(chFieldNotNull, frReadOnly);
      EnableFieldControl(edFieldCEXpr, frPartialReadOnly);
    end;
  end;
  RefreshSelectedFieldDataType;
end;

procedure TfmTableElements.MakeFormReadOnly(AExceptFields: boolean);
begin
  DisableEditableControls(pnTableElements, AExceptFields);
  btNewField.Enabled := AExceptFields;
  miAddField.Enabled := AExceptFields;
  btNewIndex.Enabled := False;
  miAddIndex.Enabled := False;
  btNewConstraint.Enabled := False;
  miAddConstraint.Enabled := False;
  frTriggersEditor.btAddTrigger.Enabled := False;
  frTriggersEditor.miAddTrigger.Enabled := False;
end;

procedure TfmTableElements.chSpecificDefaultValueClick(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    SelectedField.DefaultValueSpecific := chSpecificDefaultValue.Checked;
    EnableFieldControl(edFieldDefaultValue, frReadOnly, chSpecificDefaultValue.Checked
      or (SelectedField.Domain = nil));
    SetModified(self);
    if not chSpecificDefaultValue.Checked then
      edFieldDefaultValue.Text := SelectedField.DefaultValue;
  end;
end;

procedure TfmTableElements.chSpecificRequiredClick(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    SelectedField.RequiredSpecific := chSpecificRequired.Checked;
    EnableFieldControl(chFieldNotNull, frReadOnly, {not chPrimaryKey.Checked and }(chSpecificRequired.Checked
      or (SelectedField.Domain = nil)));
    SetModified(self);
    if not chSpecificRequired.Checked then
      chFieldNotNull.Checked := SelectedField.Required;
  end;
end;

constructor TfmTableElements.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csActionClient];
end;

procedure TfmTableElements.acRemoveConstraintUpdate(Sender: TObject);
begin
  acRemoveConstraint.Enabled := (lvConstraints.Selected <> nil) and not SelectedTable.ReadOnly;
end;

procedure TfmTableElements.acViewRelationshipClick(Sender: TObject);
var
  ARelList: TRelationshipList;
  c: Integer;
begin
  if (SelectedField <> nil) then
  begin
    ARelList := TRelationshipList.Create;
    try
      SelectedField.IsForeignKey(ARelList);
      for c := 0 to ARelList.Count - 1 do
        PostMessage(ProjectFormHandle, WM_DM_SELECTELEMENT,
          integer(ARelList.Items[c]), 0);
    finally
      ARelList.Free;
    end;
  end;
end;

procedure TfmTableElements.acRemoveConstraintExecute(Sender: TObject);
begin
  DeleteDDItem(lvConstraints);
end;

procedure TfmTableElements.miAddConstraintClick(Sender: TObject);
begin
  AddDDItem(lvConstraints)
end;

procedure TfmTableElements.LoadTableConstraintsList;
var
  i: Integer;
begin
  lvConstraints.Items.BeginUpdate;
  try
    lvConstraints.Items.Clear;
    if Assigned(FSelectedTable) then
    begin
      EnableControl(lvConstraints);
      with FSelectedTable.Constraints do
      begin
        for i := 0 to Count-1 do
          with lvConstraints.Items.Add do
          begin
            Caption := Items[i].ConstraintName;
            Data    := Items[i];
          end;
      end;
    end else
      EnableControl(lvConstraints, false);

  finally
    lvConstraints.Items.EndUpdate;
  end;
end;

procedure TfmTableElements.chSpecificConstraintClick(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    SelectedField.ConstraintExprSpecific := chSpecificConstraint.Checked;
    EnableFieldControl(edFieldCExpr, frPartialReadOnly, chSpecificConstraint.Checked
      or (SelectedField.Domain = nil));
    SetModified(self);
    if not chSpecificConstraint.Checked then
      edFieldCExpr.Text := SelectedField.ConstraintExpr;
  end;
end;

procedure TfmTableElements.lvConstraintsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if not FConstraintListChanging and (Change=ctState) and
    ((Item = lvConstraints.Selected) or (lvConstraints.Selected = nil)) then
  begin
    FConstraintListChanging := true;
    try
      LoadProperty(edConstraintName);
      LoadProperty(edExpression);
      if FIsNewObject then
      begin
        edConstraintName.SelectAll;
        edConstraintName.SetFocus;
      end;
      FIsNewObject := false;
    finally
      FConstraintListChanging := false;
    end;
  end;
end;

procedure TfmTableElements.lvConstraintsEdited(Sender: TObject; Item: TListItem;
  var S: string);
begin
   with TListView(Sender) do
   begin
      if not Assigned(Selected.Data) then
      begin
        { end of insertion }
        if (S='') then
        begin
          { ignore new null keys }
          Listviewcleaner.ListViewItemDeleted(Selected);
          Selected.Delete;
          exit;
        end
        else
        begin
          { add the new key }
          Selected.Data := FSelectedTable.Constraints.AddConstraint(S, '');
          SetModified(self);
        end
      end
      else
      begin
        { end of edit }
        if (S='') then
          { discard the edit if the key name became null or if editing the selected item is not allowed }
          S:=Selected.Caption
        else
        begin
          TGDAOConstraint(Selected.Data).ConstraintName := s;
          SetModified(self);
        end;
      end;
      { trigger OnChange for the edited item }
      if Assigned(OnChange) then OnChange(Sender,Item,ctState);

      { if a table was modified, suggest default values }

      { ensure the edited item remains visible even when the list is auto-sorted }
      if Assigned(Selected) then
      begin
         Selected.Caption:=S;
         Selected.MakeVisible(false);
      end;
   end;
end;

procedure TfmTableElements.UpdateIndexControlsCompatibilities;
begin
  if not FMetadata.DataDictionary.DatabaseType.EnableIndexOrderByField then
  begin
    EnableControl(cbIndexOrder, true);
    lbIndexOrder.Visible := true;
    lbIndexOrder.Enabled := true;
    cbIndexOrder.Visible := true;
    gCamposIndice.HideColumn(1)
  end
  else
  begin
    gCamposIndice.UnHideColumn(1);
    EnableControl(cbIndexOrder, false);
    lbIndexOrder.Visible := false;
    lbIndexOrder.Enabled := false;
    cbIndexOrder.Visible := false;
  end;
end;

procedure TfmTableElements.LoadTableFieldGrid(ASelectField: TGDAOField = nil);
var
  i: Integer;
  selectRow: integer;
  oldTopRow: integer;
begin
  gCampos.BeginUpdate;
  Inc(FLoading);
  try
    if ASelectField = nil then
      ASelectField := SelectedField;
    oldTopRow := gCampos.TopRow;

    EmptyGrid(gCampos);
    if Assigned(FSelectedTable) then
    begin
      EnableControl(gCampos);
      selectRow := 0;

      with FSelectedTable do
      begin
        for i := 0 to Fields.Count - 1 do
        begin
          // field object
          gCampos.Objects[0, i + 1] := Fields.Items[i];
          // field properties
          gCampos.Cells[0, i + 1] := Fields.Items[i].FieldName;
          gCampos.Cells[1, i + 1] := Fields.Items[i].GetGridDataTypeName;
          // iconm
          UpdateFieldIcon(i + 1);

          if ASelectField = Fields[i] then
            selectRow := i + 1;

          gCampos.Rowcount := gCampos.Rowcount + 1;
        end;
        if Fields.Count > 0 then
          gCampos.Rowcount := gCampos.Rowcount - 1;

        gCampos.TopRow := oldTopRow;
        if selectRow > 0 then
          gCampos.Row := selectRow;
        gCampos.Col := 0;
      end;
    end
    else
      EnableControl(gCampos, false);

    {reinclude rowselect because for some reason it's losing this property
     when grid is being updated}
    gCampos.Options := gCampos.Options + [goRowSelect];
  finally
    Dec(FLoading);
    gCampos.EndUpdate;
  end;

  LoadFieldProperties;
end;

procedure TfmTableElements.EmptyGrid(AGrid: TAdvColumnGrid);
begin
  AGrid.ClearRows(1, AGrid.Rowcount);
  AGrid.RowCount := 2;
  AGrid.Col      := 0;
  AGrid.Options := AGrid.Options + [goRowSelect];
  AGrid.MouseActions.SelectOnRightClick := true;
end;

function TfmTableElements.EnableFieldControl(AControl: TWinControl; ADenyRestriction: TFieldRestriction; AExtraCondition: boolean): boolean;
begin
  result := (SelectedField <> nil) and AExtraCondition;
  EnableControl(AControl, result);
  if result and ((SelectedField.Restriction >= ADenyRestriction) or SelectedField.OwnerTable.ReadOnly) then
    AControl.Enabled := False;
end;

procedure TfmTableElements.gCamposClick(Sender: TObject);
begin
  if (FLoading = 0) then
    LoadFieldProperties;
end;

procedure TfmTableElements.LoadFieldProperties;
begin
  LoadProperty(edFieldName);
  LoadProperty(edFieldCaption);
  LoadProperty(cbDomain);
  LoadProperty(cbTipoCampo);
  LoadProperty(chPrimaryKey);
  LoadProperty(edTamanhoCampo);
  LoadProperty(edPrecision);
  LoadProperty(edSeed);
  LoadProperty(edIncrement);
  LoadProperty(chFieldNotNull);
  LoadProperty(edFieldNotNullConstraint);
  LoadProperty(edFieldCName);
  LoadProperty(edFieldCExpr);
  LoadProperty(chSpecificDefaultValue);
  LoadProperty(chSpecificRequired);
  LoadProperty(chSpecificConstraint);
  LoadProperty(edFieldDefaultValue);
  LoadProperty(edFieldDefaultConstraint);
  LoadProperty(mFieldComments);
  LoadProperty(edComputedExpr);
end;

procedure TfmTableElements.UpdateFieldIcon(Arow: Integer);
var
  v: TCellVAlign;
begin
  v := vaCenter;
  if gCampos.Objects[0, ARow] <> nil then
  begin
    if FieldFromGrid(ARow).InPrimaryKey then
      gCampos.AddImageIdx(0, ARow, 19, haBeforeText, v) // primary
    else if FieldFromGrid(ARow).IsForeignKey then
      gCampos.AddImageIdx(0, ARow, 22, haBeforeText, v) // foreign
    else
      gCampos.AddImageIdx(0, ARow, 23, haBeforeText, v); // nada
    gCampos.Invalidate;
  end;
end;

procedure TfmTableElements.gCamposGetCellBorder(Sender: TObject; ARow,
  ACol: Integer; APen: TPen; var Borders: TCellBorders);
begin
  if ARow > 0 then
    Borders := [];
end;

procedure TfmTableElements.gCamposGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if FieldFromGrid(ARow) <> nil then
  begin
    if FieldFromGrid(ARow).Required then
      AFont.Style := [fsBold]
    else
      AFont.Style := [];
  end;
end;

procedure TfmTableElements.SetSelectedTable(const ATable: TGDAOTable);
begin
  FSelectedTable := ATable;
  RefreshFullFrameInformation;

  if FSelectedTable <> nil then
  begin
    if FSelectedTable.ReadOnly then
      MakeFormReadOnly;
  end;
end;

procedure TfmTableElements.SetModified(Sender: TObject);
begin
  if Assigned(OnModification) then
    OnModification(Sender);
end;

procedure TfmTableElements.LoadDomainCombo;
var
  i: Integer;
  SL: TStringList;
begin
  cbDomain.Items.Clear;
  with FMetadata.DataDictionary.Domains do
  begin
    SL := TStringList.Create;
    try
      for i := 0 to Count - 1 do
        SL.AddObject(Items[i].Name, TObject(Items[i]));
      SL.Sort;
      cbDomain.Items.Assign(SL);
    finally
      SL.Free;
    end;
  end;
  cbDomain.Items.InsertObject(0, SNoDomain, TObject(0));

  // updating screen information
  if (SelectedField <> nil) then
  begin
    LoadProperty(gCampos);
  end;
end;

procedure TfmTableElements.SetMetadata(const AMetaData: TAppMetaData);

  procedure LoadComboDataTypes;
  var
    i: Integer;
  begin
    cbTipoCampo.Items.Clear;
    with FMetadata.DataDictionary.DataTypes do
    begin
      for i := 0 to count - 1 do
        cbTipoCampo.Items.AddObject(Items[i].Name, TObject(Items[i]));
    end;
  end;

begin
  FMetaData := AMetaData;

  frTriggersEditor.FixedDBType := TDBProperties.GetFixedDatabaseType(FMetaData.DataDictionary.DatabaseType);

  {update visual items that depends on the metadata information}
  LoadComboDataTypes;
  LoadDomainCombo;
  UpdateIndexControlsCompatibilities;
  tsGatilhos.TabVisible := MetaData.DataDictionary.DatabaseType.EnableTableTriggers;
  tsTableConstraints.TabVisible := MetaData.DataDictionary.DatabaseType.EnableTableConstraints;
end;

procedure TfmTableElements.RefreshFullFrameInformation;
var
  c: integer;
begin
  if not (csDestroying in ComponentState) then
  begin
    FIsNewObject := false;
    LoadPredefinedTypes;

    {make it more generic so for new controls it won't be a problem}
    for c := 0 to ComponentCount - 1 do
      if Components[c] is TControl then
        LoadProperty(Components[c]);

    // triggers
    if MetaData.DataDictionary.DatabaseType.EnableTableTriggers then
    begin
      frTriggersEditor.UpdateList := True;
      if assigned(FSelectedTable) then
        frTriggersEditor.ListTriggers(FSelectedTable.Triggers, SetModified)
      else
        frTriggersEditor.DisableForm;
    end;

    ShowDatabaseFeatures;
  end;
end;

procedure TfmTableElements.OnTableNameChanged(var Msg: TMessage);
begin
  if TGDAOTable(Msg.WParam) = SelectedTable then
  begin
    LoadProperty(edTableName);
    LoadProperty(edTableCaption);
  end;
end;

procedure TfmTableElements.pcTableChange(Sender: TObject);
begin
  if pcTable.ActivePage = tsIndicesTabela then
    UpdateIndexItemsPanel;
end;

function TfmTableElements.ProjectFormHandle: HWND;
begin
  if (Owner is TWinControl) then
    result := TWinControl(Owner).Handle
  else
    result := 0;
end;

procedure TfmTableElements.PropagateFieldCaptionChange(AField: TGDAOField; ANewCaption: string);
var
  I: integer;
  J: Integer;
  Rel: TGDAORelationship;
begin
  if (Metadata <> nil) and (Metadata.DataDictionary <> nil) then
  begin
    for I := 0 to Metadata.DataDictionary.Relationships.Count - 1 do
    begin
      Rel := Metadata.DataDictionary.Relationships[I];
      for J := 0 to Rel.FieldLinks.Count - 1 do
        if (Rel.FieldLinks[J].ParentField = AField) and (Rel.FieldLinks[J].ChildField <> nil) then
          Rel.FieldLinks[J].ChildField.FieldCaption := ANewCaption;
    end;
  end;
end;

procedure TfmTableElements.acField_duplicateUpdate(Sender: TObject);
begin
  acField_duplicate.Enabled := (SelectedField <> nil) and (SelectedField.OwnerTable <> nil) and  not SelectedField.OwnerTable.ReadOnly;
end;

procedure TfmTableElements.acField_duplicateExecute(Sender: TObject);
begin
  DuplicateSelectedField;
end;

procedure TfmTableElements.DuplicateSelectedField;
var
  ANewField : TGDAOField;
  newName : String;
  i: integer;
begin
  if not FSelectedTable.ReadOnly then
  begin
    i := 0;
    repeat
      inc(i);
      newName := Format('%s_%d', [SelectedField.FieldName, i]);
    until SelectedTable.Fields.IndexOf(newName) < 0;
    ANewField := SelectedTable.Fields.Add(newName,
      SelectedField.DataType, SelectedField.Size, SelectedField.Size2, SelectedField.Required);
    ANewField.Assign(SelectedField);
    ANewField.UpdateId;
    LoadTableFieldGrid(ANewField);
  end;
end;

procedure TfmTableElements.OnDomainsChange(var Msg: TMessage);
begin
  LoadDomainCombo;
end;

procedure TfmTableElements.RefreshSelectedFieldDataType;
var
  ADataType: TGDAODataType;
begin
  gCampos.Cells[1, gCampos.Row] := SelectedField.GetGridDataTypeName;
  ADataType := SelectedField.DataType;
  LoadProperty(edTamanhoCampo);
  LoadProperty(edPrecision);
  LoadProperty(edTipoFisico);
  LoadProperty(edComputedExpr);
  LoadProperty(edFieldDefaultValue);
  LoadProperty(edFieldDefaultConstraint);
  LoadPRoperty(edFieldCExpr);
  LoadProperty(edSeed);
  LoadProperty(edIncrement);

  pnAutoIncrement.Visible := (ADataType.SeedIsRequired and ADataType.IncrementIsRequired);
  EnableFieldControl(cbTipoCampo, frReadOnly, (not Assigned(SelectedField.Domain)) and (not SelectedField.IsInRelationship));
end;

procedure TfmTableElements.acMoveUpUpdate(Sender: TObject);
begin
  acMoveUp.Enabled :=
    (FSelectedTable <> nil) and (FSelectedTable.Fields.Count > 0) and
    (SelectedField <> nil) and (SelectedField.Index > 0) and not FSelectedTable.ReadOnly;
end;

procedure TfmTableElements.acMoveDownUpdate(Sender: TObject);
begin
  acMoveDown.Enabled :=
    (FSelectedTable <> nil) and (FSelectedTable.Fields.Count > 0) and
    (SelectedField <> nil) and (SelectedField.Index + 1 < FSelectedTable.Fields.Count) and
    not FSelectedTable.ReadOnly;
end;

procedure TfmTableElements.acMoveDownExecute(Sender: TObject);
begin
  MoveCollectionItem(FSelectedTable.Fields, SelectedField.Index,
                     FSelectedTable.Fields, SelectedField.Index + 1);
  SetModified(Self);
  LoadTableFieldGrid;
end;

procedure TfmTableElements.acMoveUpExecute(Sender: TObject);
begin
  MoveCollectionItem(FSelectedTable.Fields, SelectedField.Index,
                     FSelectedTable.Fields, SelectedField.Index - 1);
  SetModified(Self);
  LoadTableFieldGrid;
end;

procedure TfmTableElements.OnNewTableAdded(var Msg: TMessage);
begin
  edTableName.SelectAll;
  edTableName.SetFocus;
end;

procedure TfmTableElements.acCopyListFieldUpdate(Sender: TObject);
begin
  acCopyListField.Enabled := FSelectedTable.Fields.Count > 0;
end;

procedure TfmTableElements.acCopyListFieldExecute(Sender: TObject);
begin
  Clipboard.SetTextBuf(pchar(GetListTableFields));
end;

function TfmTableElements.GetListTableFields: String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FSelectedTable.Fields.Count-1 do
    Result := Result + FSelectedTable.Fields.Items[i].FieldName + ', ';
  delete(Result, length(Result)-1, 2);
end;

procedure TfmTableElements.acCopyListField_InsertUpdate(Sender: TObject);
begin
  acCopyListField_Insert.Enabled := FSelectedTable.Fields.Count > 0;
end;

procedure TfmTableElements.acCopyListField_UpdateUpdate(Sender: TObject);
begin
  acCopyListField_Update.Enabled := FSelectedTable.fields.Count > 0;
end;

procedure TfmTableElements.acCopyListField_InsertExecute(Sender: TObject);
var
  s: String;
begin
  s := Format('INSERT INTO %s (%s) VALUES ()', [FSelectedTable.TableName, GetListTableFields]);
  Clipboard.SetTextBuf(pchar(s));
end;

procedure TfmTableElements.acCopyListField_UpdateExecute(Sender: TObject);
var
  a, s : String;
  i :Integer;
begin
  a := '';
  for i := 0 to FSelectedTable.Fields.Count-1 do
    a := a + FSelectedTable.Fields.Items[i].FieldName + '=, ';

  delete(a, length(a) - 1, 2);

  s := Format('UPDATE %s SET %s', [FSelectedTable.TableName, a]);
  Clipboard.SetTextBuf(pchar(s));
end;

procedure TfmTableElements.ShowDatabaseFeatures;

  procedure ShowField(ALabel: TLabel; AVisible: boolean);
  begin
    ALabel.Visible := AVisible;
    ALabel.FocusControl.Visible := AVisible;
  end;

var
  ADefHeight: integer;
  AConHeight: integer;
begin
  if Assigned(FSelectedTable) then
  begin
    ShowField(lbFieldNotNullConstraint, FSelectedTable.OwnerDatabase.DatabaseType.EnableConstraintNotNullName);
    ShowField(lbFieldCName, FSelectedTable.OwnerDatabase.DatabaseType.EnableConstraintCheckFldName);
    ShowField(lbFieldDefaultConstraint, FSelectedTable.OwnerDatabase.DatabaseType.EnableConstraintDefaultName);

    if lbFieldCName.Visible then
      AConHeight := edFieldCName.Top + edFieldCName.Height
    else
      AConHeight := edFieldCExpr.Top + edFieldCExpr.Height;
    gbFieldCheckConstraint.Height := AConHeight + 6;

    if lbFieldDefaultConstraint.Visible then
      ADefHeight := edFieldDefaultConstraint.Top + edFieldDefaultConstraint.Height
    else
      ADefHeight := edFieldDefaultValue.Top + edFieldDefaultValue.Height;
    gbDefaultConstraint.Height := ADefHeight + 6;

    gbFieldCheckConstraint.Top := gbNotNullConstraint.Top + gbNotNullConstraint.Height + 2;
    gbDefaultConstraint.Top := gbFieldCheckConstraint.Top + gbFieldCheckConstraint.Height + 2;
    pnAutoIncrement.Top := gbDefaultConstraint.Top + gbDefaultConstraint.Height + 2;

    {gbFieldCheckConstraint.Width := pnConstraints.Width - 2;
    gbNotNullConstraint.Width := pnConstraints.Width - 2;
    gbDefaultConstraint.Width := pnConstraints.Width - 2;}
  end;
end;

procedure TfmTableElements.ShowLink(ALinkType: TDesignLinkType; AObject: TObject);
begin
  case ALinkType of
    dltTable:
      with btLinkTable do
      begin
        Show;
        Tag := integer(AObject);
      end;
    dltDiagram:
      with btLinkDiagram do
      begin
        Show;
        Tag := integer(AObject);
      end;
  end;
  pnLinks.Show;
end;

procedure TfmTableElements.ShowTableElement(AElement: TObject);
var i: integer;
begin
  if AElement is TGDAOField then
  begin
    pcTable.ActivePage := tsCamposTabela;
    for i := 0 to gCampos.RowCount - 1 do
      if gCampos.Objects[0, i] = AElement then
      begin
        gCampos.SetFocus;
        gCampos.Row := i;
        break;
      end;
  end
  else if AElement is TGDAOIndex then
  begin
    pcTable.ActivePage := tsIndicesTabela;
    lvIndices.SetFocus;
    SelectListItemByCaption(lvIndices, TGDAOIndex(AElement).IndexName, False);
  end
  else if AElement is TGDAOConstraint then
  begin
    if MetaData.DataDictionary.DatabaseType.EnableTableConstraints then
    begin
      pcTable.ActivePage := tsTableConstraints;
      lvConstraints.SetFocus;
      SelectListItemByCaption(lvConstraints, TGDAOConstraint(AElement).ConstraintName, False);
    end;
  end
  else if AElement is TGDAOTrigger then
  begin
    if MetaData.DataDictionary.DatabaseType.EnableTableTriggers then
    begin
      pcTable.ActivePage := tsGatilhos;
      frTriggersEditor.lvTriggers.SetFocus;
      SelectListItemByCaption(frTriggersEditor.lvTriggers, TGDAOTrigger(AElement).Name, False);
    end;
  end;
end;

procedure TfmTableElements.btLinkDiagramClick(Sender: TObject);
begin
  if Assigned(FOnLinkClick) then
    FOnLinkClick(dltDiagram, TObject(btLinkDiagram.Tag));
  pnLinks.Hide;
end;

procedure TfmTableElements.btLinkTableClick(Sender: TObject);
begin
  if Assigned(FOnLinkClick) then
    FOnLinkClick(dltTable, TObject(btLinkTable.Tag));
  pnLinks.Hide;
end;

procedure TfmTableElements.gCamposIndiceKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift=[] then
    case Key of
      VK_DOWN:
        if gCamposIndice.Row = gCamposIndice.RowCount-1 then
          acIndex_AddField.Execute;
      VK_UP:
        if (gCamposIndice.RowCount > 1) and (gCamposIndice.Cells[0, gCamposIndice.Row] = '') then
          if acIndex_RemoveField.Enabled then
            acIndex_RemoveField.Execute
          else
            gCamposIndice.RemoveSelectedRows;
    end
  else if (Shift=[ssCtrl]) and (Key = Ord('W')) then
    lvIndices.SetFocus;
end;

end.
