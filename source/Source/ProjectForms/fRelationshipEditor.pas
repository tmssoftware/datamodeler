unit fRelationshipEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids, DBGrids, ComCtrls, Db, ImgList, Buttons, uGDAO, LangConst,
  ActnList, Menus, AdvToolBtn, AdvMenus, AdvMenuStylers, BaseGrid, AdvGrid, AdvCGrid,
  AdvPanel, dgConsts, AdvToolBar, AdvObj, AdvToolBarStylers, AdvUtil,
  System.ImageList;

type
  TGDAORelationshipEvent = procedure (ARelationship: TGDAORelationship) of object;

  TfmRelationshipEditor = class(TFrame)
    dsChave: TDataSource;
    pnRelationship: TPanel;
    ImageList1: TImageList;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    ScrollBox1: TScrollBox;
    AdvPanel4: TAdvPanel;
    Label1: TLabel;
    Label3: TLabel;
    edRelationName: TEdit;
    eddesc: TEdit;
    pnRelationKeys: TAdvPanel;
    AdvPanel2: TAdvPanel;
    rgMetodoExclusao: TRadioGroup;
    rgMetodoAlteracao: TRadioGroup;
    pnLinks: TAdvDockPanel;
    barLinks: TAdvToolBar;
    btLinkDiagram: TAdvToolBarButton;
    btLinkTable: TAdvToolBarButton;
    gKeys: TAdvColumnGrid;
    pnParentKey: TPanel;
    Label2: TLabel;
    cbParentKey: TComboBox;
    pnTipo: TPanel;
    pnBlank: TPanel;
    Splitter1: TSplitter;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    procedure rgMetodoExclusaoClick(Sender: TObject);
    procedure rgMetodoAlteracaoClick(Sender: TObject);
    procedure btLinkDiagramClick(Sender: TObject);
    procedure btLinkTableClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure gKeysCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
    procedure gKeysComboChange(Sender: TObject; ACol, ARow, AItemIndex: Integer; ASelection: string);
    procedure cbParentKeyDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cbParentKeyChange(Sender: TObject);
    procedure edRelationNameChange(Sender: TObject);
    procedure eddescChange(Sender: TObject);
  private
    FParentTable: TGDAOTable;
    FChildTable: TGDAOTable;
    FSelectedRelationship: TGDAORelationship;
    FInserting: boolean;
    FOnLinkClick: TDesignLinkClickEvent;
    FOnModified: TNotifyEvent;
    FOnUpdateRelationshipName: TGDAORelationshipEvent;
    FLoading: integer;
    procedure UpdateRelationshipKeyGrid;
    procedure Modified;
    procedure ClearKeysGrid;
    procedure ListParentKeys;
    procedure ListTableFields(ATable: TGDAOTable; AColumn: TGridColumnItem; ALink: TGDAORelationshipFieldLink);
    procedure RefreshRelationshipFields;
    procedure UpdatePanelRelationshipType;
    procedure SetSelectedRelationship(const Value: TGDAORelationship);
    procedure OnRelationshipNameChanged(var Msg: TMessage); message WM_DM_OBJECTNAME_CHANGED;
    procedure MakeFormReadOnly;
  public
    procedure RefreshFullFrameInformation;
    procedure ShowLink(ALinkType: TDesignLinkType; AObject: TObject);
    property OnLinkClick: TDesignLinkClickEvent read FOnLinkClick write FOnLinkClick;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property OnUpdateRelationshipName: TGDAORelationshipEvent read FOnUpdateRelationshipName write FOnUpdateRelationshipName;
    property SelectedRelationship: TGDAORelationship read FSelectedRelationship write SetSelectedRelationship;
    property Inserting: boolean read FInserting write FInserting;
  end;

implementation

uses
  Math;

const
  NEW_SUFIX = ' (new)';

{$R *.DFM}

{ TfrRelationshipEditor }

procedure TfmRelationshipEditor.RefreshFullFrameInformation;
begin
  Inc(FLoading);
  try
    edRelationName.Text := FSelectedRelationship.RelationshipName;
    edDesc.Text         := FSelectedRelationship.Description;

    {Update primary key combo}
    ListParentKeys;

    {Update grid listing the current field links}
    UpdateRelationshipKeyGrid;

    {Update delete/update method in radio buttons}
    rgMetodoExclusao.ItemIndex := ord(FSelectedRelationship.DeleteMethod) - 1;
    rgMetodoAlteracao.ItemIndex := ord(FSelectedRelationship.UpdateMethod) - 1;

    {Update cardinality of relationship}
    UpdatePanelRelationshipType;
  finally
   Dec(FLoading);
  end;
end;

procedure TfmRelationshipEditor.RefreshRelationshipFields;
var
  i: integer;
begin
  for i := 0 to FSelectedRelationship.FieldLinks.Count - 1 do
    if FSelectedRelationship.FieldLinks[i].ChildField.GeneratedByRelationship then
      FSelectedRelationship.FieldLinks[i].ChildField.Free;

  FSelectedRelationship.FieldLinks.Clear;
  FSelectedRelationship.AutoCreateRelationshipKey(FSelectedRelationship.ParentIndex, true {GlobalDMApp.AutoFieldInRelationship});
end;

procedure TfmRelationshipEditor.MakeFormReadOnly;
begin
  pnRelationship.Enabled := False;
end;

procedure TfmRelationshipEditor.Modified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

procedure TfmRelationshipEditor.OnRelationshipNameChanged(var Msg: TMessage);
begin
  if TGDAORelationship(Msg.WParam) = FSelectedRelationship then
  begin
    inc(FLoading);
    try
      edRelationName.Text := FSelectedRelationship.RelationshipName;
    finally
      dec(FLoading);
    end;
  end;
end;

procedure TfmRelationshipEditor.UpdatePanelRelationshipType;
var
  S: string;
begin
   S := '';
   if FSelectedRelationship <> nil then
   begin
     S := SRelationshipType;
     case FSelectedRelationShip.Cardinality of
       rcOneToOne: S := S + SOneToOne;
       rcOneToMany: S := S + SOneToMany;
     else
       S := '';
     end;
   end;
   pnTipo.Caption := S;
end;

procedure TfmRelationshipEditor.SetSelectedRelationship(const Value: TGDAORelationship);
begin
  FSelectedRelationship := Value;
  FParentTable := FSelectedRelationship.ParentTable;
  FChildTable := FSelectedRelationship.ChildTable;
  RefreshFullFrameInformation;
  FrameResize(Self);

  if (FSelectedRelationship <> nil) and FSelectedRelationship.ReadOnly then
    MakeFormReadOnly;  
end;

procedure TfmRelationshipEditor.ShowLink(ALinkType: TDesignLinkType; AObject: TObject);
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

procedure TfmRelationshipEditor.rgMetodoExclusaoClick(Sender: TObject);
begin
   if Assigned(FSelectedRelationship) and (FLoading = 0) then
   begin
      Modified;
      FSelectedRelationship.DeleteMethod := TDeleteMethod(rgMetodoExclusao.ItemIndex + 1);
   end;
end;

procedure TfmRelationshipEditor.rgMetodoAlteracaoClick(Sender: TObject);
begin
   if Assigned(FSelectedRelationship) and (FLoading = 0) then
   begin
      Modified;
      FSelectedRelationship.UpdateMethod := TUpdateMethod(rgMetodoAlteracao.ItemIndex + 1);
   end;
end;

procedure TfmRelationshipEditor.FrameResize(Sender: TObject);
const
  DEFAULT_WIDTH = 700;
begin
  pnRelationship.Width := Min(DEFAULT_WIDTH, Width);
  gKeys.Columns[0].Width := gKeys.Width div 2;
end;

procedure TfmRelationshipEditor.gKeysCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
begin
  if (ACol = 1) and (ARow > 0) and (gKeys.Objects[0, ARow] <> nil) and Assigned(FChildTable) then
    ListTableFields(FChildTable, gKeys.Columns[1], TGDAORelationshipFieldLink(gKeys.Objects[0, ARow]));
end;

procedure TfmRelationshipEditor.gKeysComboChange(Sender: TObject; ACol, ARow, AItemIndex: Integer; ASelection: string);
var
  AChildField: TGDAOField;
  AObj: TObject;
  AFieldLink: TGDAORelationshipFieldLink;
begin
  if (ACol = 1) and (ARow > 0) and (gKeys.Objects[1, ARow] <> nil)
    and (AItemIndex >= 0) then
  begin
    {Get the current field link from the specified row}
    AFieldLink := TGDAORelationshipFieldLink(gKeys.Objects[1, ARow]);

    {Get the child field to be assigned. If obj is nil, it means that
     a new field will be created}
    AObj := gKeys.Columns[ACol].ComboItems.Objects[AItemIndex];
    if AObj <> nil then
      AChildField := TGDAOField(AObj)
    else
      AChildField := SelectedRelationship.AutoCreateChildField(AFieldLink.ParentField);

    AFieldLink.ChildField := AChildField;
    UpdatePanelRelationshipType;

    {Force editing to finish so that to change the field, the combo must appear again
     and the table list must be refreshed. This avoids confusion with pointers in combo.Objects
     and fields being created/destroyed as user moves through the combo}
    gKeys.HideInplaceEdit;

    {Also, we need to set the cell text to the field name (to remove the new_sufix if it exists)
     because the next time the combo is displayed, it will not have the new_sufix anymore,
     and grid might get confused when open the combo again.
     It only happens if the field was newly created}
    //gKeys.Cells[ACol, ARow] := AChildField.FieldName;
  end;
end;

procedure TfmRelationshipEditor.ListParentKeys;
var
  i: integer;
begin
  cbParentKey.Items.BeginUpdate;
  try
    cbParentKey.Items.Clear;
    if Assigned(FParentTable) then
    begin
      cbParentKey.Items.AddObject(FParentTable.PrimaryKeyIndex.IndexName, FParentTable.PrimaryKeyIndex);

      // unique indexes
      for i := 0 to FParentTable.Indexes.Count-1 do
        if FParentTable.Indexes[i].IndexType in [itUnique, itUniqueKey] then
          cbParentKey.Items.AddObject(FParentTable.Indexes[i].IndexName, FParentTable.Indexes[i]);

      if FSelectedRelationship.ParentIndex <> nil then
      begin
        if cbParentKey.Items.IndexOfObject(FSelectedRelationship.ParentIndex) < 0 then
          cbParentKey.Items.AddObject(FSelectedRelationship.ParentIndex.IndexName, FSelectedRelationship.ParentIndex);
        cbParentKey.ItemIndex := cbParentKey.Items.IndexOfObject(FSelectedRelationship.ParentIndex);
      end else
        cbParentKey.ItemIndex := -1;
    end;
  finally
    cbParentKey.Items.EndUpdate;
  end;
end;

procedure TfmRelationshipEditor.ListTableFields(ATable: TGDAOTable; AColumn: TGridColumnItem; ALink: TGDAORelationshipFieldLink);
var
  i: integer;
  s: string;
  addNew: boolean;
begin
  AColumn.ComboItems.Clear;
  if (ALink <> nil) and (ALink.ParentField <> nil) then
  begin
    addNew := True;
    for i := 0 to ATable.Fields.Count - 1 do
      if ALink.ParentField.CompatibleForRelationship(ATable.Fields[i]) or (ALink.ChildField = ATable.Fields[i]) then
      begin
        s := ATable.Fields[i].FieldName;
        if Inserting and ATable.Fields[i].GeneratedByRelationship and (FSelectedRelationship.FieldLinks.IndexOfChildField(ATable.Fields[i]) >= 0) then
        begin
          s := s + NEW_SUFIX;
          addNew := False;
        end;
        AColumn.ComboItems.AddObject(s, ATable.Fields[i]);
      end;

    if addNew then
      AColumn.ComboItems.AddObject(ATable.Fields.GetNewFieldName(ALink.ParentField.FieldName) + NEW_SUFIX, nil);
  end;
end;

procedure TfmRelationshipEditor.eddescChange(Sender: TObject);
begin
  if (FSelectedRelationship <> nil) and (FLoading = 0) then
  begin
    FSelectedRelationship.Description := eddesc.Text;
    Modified;
  end;
end;

procedure TfmRelationshipEditor.edRelationNameChange(Sender: TObject);
begin
  if (FSelectedRelationship <> nil) and (FLoading = 0) then
  begin
    FSelectedRelationship.RelationshipName := edRelationName.Text;
    if Assigned(FOnUpdateRelationshipName) then
      FOnUpdateRelationshipName(FSelectedRelationship);
    Modified;
  end;
end;

procedure TfmRelationshipEditor.UpdateRelationshipKeyGrid;
var i : integer;
begin
  ClearKeysGrid;                          
  with FSelectedRelationship do
  begin
    gKeys.Columns[0].Header := Format('Parent table: <b>%s</b>', [ParentTableName]);
    gKeys.Columns[1].Header := Format('Child table: <b>%s</b>', [ChildTableName]);
    if assigned(FParentTable) and assigned(FChildTable) then
      for i:=0 to KeyLinkCount-1 do
      begin
        if not assigned(KeyLinks[i].ParentField) then
          raise EGUIException.Create(SMasterFieldEmpty);
        if not assigned(KeyLinks[i].ChildField) then
          raise EGUIException.Create(SDetailFieldEmpty);
        // fill key grid
        gKeys.Cells[0,i+1]   := KeyLinks[i].ParentFieldName;
        gKeys.Objects[0,i+1] := KeyLinks[i];
        gKeys.Cells[1,i+1]   := KeyLinks[i].ChildFieldName;
        if Inserting and KeyLinks[i].ChildField.GeneratedByRelationship then
          gKeys.Cells[1,i+1] := gKeys.Cells[1,i+1] + NEW_SUFIX;
        gKeys.Objects[1,i+1] := KeyLinks[i];
        gKeys.RowCount := gKeys.RowCount + 1;
      end;
    if gKeys.RowCount > 2 then
      gKeys.RowCount := gKeys.RowCount - 1;
  end;
end;

procedure TfmRelationshipEditor.btLinkDiagramClick(Sender: TObject);
begin
  if Assigned(FOnLinkClick) then
    FOnLinkClick(dltDiagram, TObject(btLinkDiagram.Tag));
  pnLinks.Hide;
end;

procedure TfmRelationshipEditor.btLinkTableClick(Sender: TObject);
begin
  if Assigned(FOnLinkClick) then
    FOnLinkClick(dltTable, TObject(btLinkTable.Tag));
  pnLinks.Hide;
end;

procedure TfmRelationshipEditor.cbParentKeyChange(Sender: TObject);
var
  pindex: TGDAOIndex;
begin
  if (FLoading = 0) then
  begin
    if cbParentKey.ItemIndex >= 0 then
    begin
      if cbParentKey.Items.Objects[cbParentKey.ItemIndex] = nil then
        pindex := nil
      else
        pindex := TGDAOIndex(cbParentKey.Items.Objects[cbParentKey.ItemIndex]);

      if FSelectedRelationship.ParentIndex <> pindex then
      begin
        FSelectedRelationship.ParentIndex := pindex;
        Inserting := True;
        RefreshRelationshipFields;
        UpdateRelationshipKeyGrid;
        UpdatePanelRelationshipType;
      end;
    end;
  end;
end;

procedure TfmRelationshipEditor.cbParentKeyDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var cb: TComboBox;
begin
  cb := TComboBox(Control);
  if Index = 0 then
    ImageList1.Draw(cb.Canvas, Rect.Left, Rect.Top, 6);
  cb.Canvas.TextOut(Rect.Left + ImageList1.Width, Rect.Top, cb.Items[Index]);
end;

procedure TfmRelationshipEditor.ClearKeysGrid;
begin
  gKeys.ClearRows(1, gKeys.Rowcount);
  gKeys.Col := 0;
  gKeys.RowCount := 2;
end;

end.

