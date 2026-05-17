unit fdomains;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UGDAO, Dialogs, StdCtrls, Buttons, ExtCtrls,  Menus,
  AdvMenus, ComCtrls, ActnList, ImgList, AdvMenuStylers, uAppMetaData,
  AdvToolBtn, AdvEdit, advlued, UITypes, System.ImageList, System.Actions;

type
  TGDAODomainEvent = procedure(ADomain: TGDAODomain) of object;

  TfmDomains = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    AdvPopupMenu1: TAdvPopupMenu;
    miAddPhysicalDomain: TMenuItem;
    miDeleteDomain: TMenuItem;
    ActionList1: TActionList;
    acRemoveDomain: TAction;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    lvDomains: TListView;
    Label8: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    edDefault: TEdit;
    cbDataType: TComboBox;
    edSize: TAdvLUEdit;
    edSize2: TAdvLUEdit;
    edDomainName: TEdit;
    edPhysical: TEdit;
    edConstraint: TEdit;
    edSeed: TAdvLUEdit;
    Label10: TLabel;
    edIncrement: TAdvLUEdit;
    mInfo: TMemo;
    tvUsage: TTreeView;
    btAddInDatabase: TSpeedButton;
    btDeleteDomain: TSpeedButton;
    ImageList1: TImageList;
    lbInDatabase: TLabel;
    btAdd: TSpeedButton;
    miAddLogicalDomain: TMenuItem;
    cbNotNull: TCheckBox;
    procedure lvDomainsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormShow(Sender: TObject);
    procedure SaveTheProperty(Sender: TObject);
    procedure LoadProperty(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure lvDomainsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure btAddInDatabaseClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDeleteDomainClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FLoading: integer;
    FListChanging: integer;

    FModified : Boolean;
    FMetadata: TAppMetaData;
    FOnUpdateDomainName: TGDAODomainEvent;

    procedure AddNewDomain(AInDatabase: boolean);
    procedure LoadDomainList;
    procedure SetModified;
    function SelectedDomain: TGDAODomain;
    function SelectedDataType: TGDAODataType;
    procedure UpdateUsage(ADomain: TGDAODomain);
    procedure SetMetadata(const Value: TAppMetaData);
    procedure RefreshSelectedDataType;
    procedure LoadDomainProperties;
  protected
    property OnUpdateDomainName: TGDAODomainEvent read FOnUpdateDomainName write FOnUpdateDomainName;
  public
    procedure InitiateAction; override;
    procedure ShowDialog(ADomainToSelect: TGDAODomain = nil);
    property Modified: Boolean read FModified;
    property MetaData: TAppMetaData read FMetadata write SetMetadata;
  end;

implementation

uses
  Contnrs, uControlUtils, uAppUtils;

{$R *.dfm}

procedure TfmDomains.LoadDomainList;
var
  i: Integer;
  ADomain: TGDAODomain;
  AItem: TListItem;
  ToSelItem: TListItem;
begin
  ADomain := SelectedDomain;
  lvDomains.Items.BeginUpdate;
  try
    lvDomains.Items.Clear;
    lvDomains.Columns[0].Width := lvDomains.Width - 28;
    ToSelItem := nil;
    for i := 0 to FMetadata.DataDictionary.Domains.Count - 1 do
    begin
      AItem := lvDomains.Items.Add;
      AItem.ImageIndex := Ord(FMetaData.DataDictionary.Domains[i].InDatabase);
      AItem.Data := FMetadata.DataDictionary.Domains.Items[i];
      AItem.Caption := FMetadata.DataDictionary.Domains.Items[i].Name;

      if FMetaData.DataDictionary.Domains.Items[i] = ADomain then
        ToSelItem := AItem;
    end;
  finally
    lvDomains.Items.EndUpdate;
  end;

  if ToSelItem <> nil then
    ToSelItem.Selected := true;
end;

procedure TfmDomains.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmDomains.FormShow(Sender: TObject);
begin
  FModified  := false;
end;

procedure TfmDomains.InitiateAction;
var
  Top1, Top2: integer;
begin
  inherited;
  btDeleteDomain.Enabled := (SelectedDomain <> nil) and
    not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase);
  miDeleteDomain.Enabled := btDeleteDomain.Enabled;

  btAddInDatabase.Visible := FMetaData.DataDictionary.DatabaseType.EnableDomainsInDatabase;
  miAddPhysicalDomain.Visible := FMetaData.DataDictionary.DatabaseType.EnableDomainsInDatabase;

  if btAddInDatabase.Visible then
    Top1 := btAddInDatabase.Top + btAddInDatabase.Height
  else
    Top1 := btAddInDatabase.Top;
  Top2 := Top1 + btAdd.Height;

  if btAdd.Top <> Top1 then
    btAdd.Top := Top1;
  if btDeleteDomain.Top <> Top2 then
    btDeleteDomain.Top := Top2;
end;

procedure TfmDomains.AddNewDomain(AInDatabase: boolean);
begin
  with lvDomains do if not IsEditing and Enabled then
  begin
    Inc(FListChanging);
    try
      SetModified;
      Selected := Items.Add;
      Selected.ImageIndex := Ord(AInDatabase);
      Selected.Focused := true;
      Selected.MakeVisible(false);
      Selected.Data := FMetaData.DataDictionary.Domains.Add;
      TGDAODomain(Selected.Data).InDatabase := AInDatabase;

      with TGDAODomain(Selected.Data) do
      begin
        Name         := FMetaData.DataDictionary.Domains.GetNewDomainName;
        DataTypeName := FMetaData.DataDictionary.DataTypes.Items[0].Name;
      end;
                                                                        
      Selected.Caption := TGDAODomain(Selected.Data).Name;
      LoadDomainProperties;

      PageControl1.ActivePage := TabSheet1;
      if edDomainName.Enabled and edDomainName.CanFocus then
      begin
        edDomainName.SelectAll;
        edDomainName.SetFocus;
      end;
    finally
      Dec(FListChanging);
    end;
  end;
end;

procedure TfmDomains.btDeleteDomainClick(Sender: TObject);
begin
  if Messagedlg('Delete selected domain?', mtconfirmation ,[mbYes, mbNo],0) = mrYes then
  begin
    if tvUsage.Items.Count > 0 then
      if MessageDlg(Format('The domain "%s" is in use. The settings will be copied to the references. Continue?', [SelectedDomain.Name]),
                    mtConfirmation, [mbYes, mbNo],0) <> mrYes then
        Exit;

    // updating references
    SelectedDomain.Free;
    lvDomains.Selected.Delete;
    SetModified;
  end;
end;

procedure TfmDomains.lvDomainsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if (FListChanging = 0) and (Change = ctState) and
    ((Item = lvDomains.Selected) or (lvDomains.Selected = nil)) then
  begin
    Inc(FListChanging);
    try
      LoadDomainProperties;
    finally
      Dec(FListChanging);
    end;
  end;
end;

procedure TfmDomains.lvDomainsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;

procedure TfmDomains.LoadProperty(Sender: TObject);
begin
  {set Loading flag because we are going to update wincontrols based
   on object properties. So, we don't want these updates to be considered
   end-user iteractions}
  Inc(FLoading);
  try
    if Sender = mInfo then
    begin
      if (SelectedDomain <> nil) then
      begin
        Enablecontrol(mInfo);
        mInfo.Lines.Text := SelectedDomain.Information;
      end
      else
      begin
        Enablecontrol(mInfo, false);
        mInfo.Lines.Text := ''
      end;
    end
    else
    { load the list of table fields }
    if (Sender = lvDomains) then
      LoadDomainList
    else
    if (Sender = edDomainName) then
    begin
      if (SelectedDomain <> nil) then
      begin
        EnableControl(edDomainName,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase));
        edDomainName.Text := SelectedDomain.Name;
      end
      else
      begin
        EnableControl(edDomainName, false);
        edDomainName.Text := '';
      end
    end
    else
    if (Sender = cbDataType) then
    begin
      if (SelectedDomain <> nil) then
      begin
        cbDataType.ItemIndex := cbDataType.Items.IndexOfObject(SelectedDomain.DataType);
        EnableControl(cbDataType,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase)
          and not SelectedDomain.IsInRelationship);
      end
      else
      begin
        cbDataType.Text := '';
        cbDataType.ItemIndex := -1;
        EnableControl(cbDataType, false);
      end;
      RefreshSelectedDataType;
    end
    else
    if (Sender = edPhysical) then
    begin
      if SelectedDataType <> nil then
        edPhysical.Text := SelectedDataType.Physical
      else
        edPhysical.Text := '';
    end
    else
    if (Sender = cbNotNull) then
    begin
      if (SelectedDomain <> nil) then
      begin
        cbNotNull.Checked := SelectedDomain.Required;
        EnableControl(cbNotNull,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase)
          and not SelectedDomain.IsInRelationship);
      end
      else
      begin
        EnableControl(cbNotNull, false);
        cbNotNull.Checked := false;
      end;
    end
    else
    if (Sender = edSize) then
    begin
      if (SelectedDomain <> nil) and (SelectedDomain.DataType.SizeIsRequired) then
      begin
        edSize.Text := IntToStr(SelectedDomain.Size);
        EnableControl(edSize,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase)
          and not SelectedDomain.IsInRelationship);
      end
      else
      begin
        EnableControl(edSize, false);
        edSize.Text := '';
      end;
    end
    else
    if (Sender = edSize2) then
    begin
      if (SelectedDomain <> nil) and (SelectedDomain.DataType.Size2IsRequired) then
      begin
        edSize2.Text := IntToStr(SelectedDomain.Size2);
        EnableControl(edSize2,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase)
          and not SelectedDomain.IsInRelationship);
      end
      else
      begin
        EnableControl(edSize2, false);
        edSize2.Text := '';
      end;
    end
    else
    if Sender = edSeed then
    begin
      if (SelectedDomain <> nil) and (SelectedDomain.DataType.SeedIsRequired) then
      begin
        EnableControl(edSeed,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase));
        edSeed.Text := IntToStr(SelectedDomain.SeedValue);
      end else
      begin
        edSeed.Text :=  '';
        EnableControl(edSeed, false);
      end;
    end
    else
    if Sender = edIncrement then
    begin
      if (SelectedDomain <> nil) and (SelectedDomain.DataType.IncrementIsRequired) then
      begin
        EnableControl(edIncrement,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase));
        edIncrement.Text := IntToStr(SelectedDomain.IncrementValue);
      end else
      begin
        edIncrement.Text :=  '';
        EnableControl(edIncrement, false);
      end;
    end
    else
    if (Sender = edDefault) then
    begin
      if (SelectedDomain <> nil) then
      begin
        edDefault.Text := SelectedDomain.DefaultValue;
        EnableControl(edDefault,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase)
          and (SelectedDomain.DataType <> nil)
          and not SelectedDomain.DataType.SeedIsRequired
          and not SelectedDomain.DataType.IncrementIsRequired);
      end
      else
      begin
        edDefault.Text := '';
        EnableControl(edDefault, false);
      end;
      LoadProperty(edConstraint);
    end
    else
    if (Sender = edConstraint) then
    begin
      if (SelectedDomain <> nil) then
      begin
        edConstraint.Text := SelectedDomain.ConstraintExpr;
        EnableControl(edConstraint,
          not (SelectedDomain.IsBeingUsed and SelectedDomain.InDatabase));
      end else
        EnableControl(edConstraint, false);
    end
    else
    if (Sender = tvUsage) then
    begin
      UpdateUsage(SelectedDomain);
      EnableControl(tvUsage, SelectedDomain <> nil)
    end else
    if (Sender = lbInDatabase) then
    begin
      if SelectedDomain <> nil then
      begin
        lbInDatabase.Visible := true;
        if SelectedDomain.InDatabase then
          lbInDatabase.Caption := 'Physical domain (kept in database)'
        else
          lbInDatabase.Caption := 'Logical domain (not in database)';
      end else
        lbInDatabase.Visible := false;
    end;
  finally
    Dec(FLoading);
  end;
end;

function TfmDomains.SelectedDomain: TGDAODomain;
begin
  if lvDomains.Selected <> nil then
    Result := TGDAODomain( lvDomains.Selected.Data )
  else
    Result := nil;
end;

function TfmDomains.SelectedDataType: TGDAODataType;
begin
  Result := nil;
  if cbDatatype.ItemIndex > -1 then
    Result := TGDAODatatype(cbDatatype.Items.Objects[ cbDatatype.ItemIndex]);
end;

procedure TfmDomains.LoadDomainProperties;
begin
  LoadProperty(edDomainName);
  LoadProperty(cbDataType);
  LoadProperty(edSize);
  LoadProperty(edSize2);
  LoadProperty(edPhysical);
  LoadProperty(cbNotNull);
  LoadProperty(edSeed);
  LoadProperty(edIncrement);
  LoadProperty(edDefault);
  LoadProperty(edConstraint);
  LoadProperty(mInfo);
  LoadProperty(tvUsage);
  LoadProperty(lbInDatabase);
end;

procedure TfmDomains.RefreshSelectedDataType;
begin
  LoadProperty(edSize);
  LoadProperty(edSize2);
  LoadProperty(edPhysical);
  LoadProperty(cbNotNull);
  LoadProperty(edDefault);
  LoadProperty(edConstraint);
  LoadProperty(edSeed);
  LoadProperty(edIncrement);
end;

procedure TfmDomains.SetMetadata(const Value: TAppMetaData);

  procedure LoadComboDataTypes;
  var
    i: Integer;
  begin
    cbDataType.Items.Clear;
    with FMetadata.DataDictionary.DataTypes do
    begin
      for i := 0 to count - 1 do
        cbDataType.Items.AddObject(Items[i].Name, TObject(Items[i]));
    end;
  end;

begin
  FMetaData := Value;

  {update visual items that depends on the metadata information}
  LoadComboDataTypes;

  LoadProperty(lvDomains);
  LoadDomainProperties;
end;

procedure TfmDomains.SetModified;
begin
  FModified := true;
end;

procedure TfmDomains.ShowDialog(ADomainToSelect: TGDAODomain);
var
  c: integer;
begin
  if ADomainToSelect <> nil then
    for c := 0 to lvDomains.Items.Count - 1 do
      if lvDomains.Items[c].Data = ADomainToSelect then
      begin
        lvDomains.Selected := lvDomains.Items[c];
        break;
      end;    

  ShowModal;
end;

procedure TfmDomains.UpdateUsage(ADomain: TGDAODomain);

  procedure AddUsage(AField: TGDAOField);
  var
    p: TTreeNode;
    a: Integer;
  begin
    // looking for parent (table)
    for a := 0 to tvUsage.Items.Count-1 do
      if (tvUsage.Items[a].Level = 0) and (TGDAOTable(tvUsage.Items[a].Data) = AField.OwnerTable) then
      begin
        tvUsage.Items.AddChild(tvUsage.Items[a], AField.FieldName);
        exit;
      end;
    // new parent
    p := tvUsage.Items.Add(nil, AField.OwnerTable.TableName);
    p.Data := AField.OwnerTable;
    tvUsage.Items.AddChild(p, AField.FieldName);
  end;

var
  AFldList: TObjectList;
  i: integer;
begin
  AFldList := TObjectList.Create(false);
  tvUsage.Items.BeginUpdate;
  try
    tvUsage.Items.Clear;
    if ADomain <> nil then
    begin
      ADomain.FillUsedFields(AFldList);
      for i := 0 to AFldList.Count - 1 do
        AddUsage(TGDAOField(AFldList[i]));
    end;
  finally
    tvUsage.Items.EndUpdate;
    AFldList.Free;
  end;
end;

procedure TfmDomains.BitBtn2Click(Sender: TObject);
begin
  ActiveControl := nil;
  Close;
end;

procedure TfmDomains.btAddClick(Sender: TObject);
begin
  AddNewDomain(false);
end;

procedure TfmDomains.btAddInDatabaseClick(Sender: TObject);
begin
  AddNewDomain(true);
end;

procedure TfmDomains.SaveTheProperty(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    if (Sender = edDomainName) and (SelectedDomain <> nil) then
    begin
      if SelectedDomain.Name <> edDomainName.Text then
        SetModified;
      SelectedDomain.Name := edDomainName.Text;
      if Assigned(FOnUpdateDomainName) then
        FOnUpdateDomainName(SelectedDomain);

      lvDomains.Selected.Caption := edDomainName.Text;
    end
    else
    if (Sender = cbDatatype) and (SelectedDomain <> nil) then
    begin
      if SelectedDataType <> nil then
      begin
        if SelectedDomain.DataTypeName <> SelectedDataType.Name then
          SetModified;
        SelectedDomain.DataTypeName := SelectedDataType.Name
      end;
    end
    else
    if (Sender = cbNotNull) and (SelectedDomain <> nil) then
    begin
      if SelectedDomain.Required <> cbNotNull.Checked then
        SetModified;
      SelectedDomain.Required := cbNotNull.Checked;
    end
    else
    if (Sender = edSize) and (SelectedDomain <> nil) then
    begin
      if SelectedDomain.Size <> StrToIntDef(edSize.Text, 0) then
        SetModified;
      SelectedDomain.Size := StrToIntDef(edSize.Text, 0);
    end
    else
    if (Sender = edSize2) and (SelectedDomain <> nil) then
    begin
      if SelectedDomain.Size2 <> StrToIntDef(edSize2.Text, 0) then
        SetModified;
      SelectedDomain.Size2 := StrToIntDef(edSize2.Text, 0);
    end
    else
    if (Sender = edDefault) and (SelectedDomain <> nil) then
    begin
      if (SelectedDomain.DefaultValue <> edDefault.Text) then
        SetModified;
      SelectedDomain.DefaultValue := edDefault.Text;
    end
    else
    if (Sender = edConstraint) and (SelectedDomain <> nil) then
    begin
      if (SelectedDomain.ConstraintExpr <> edConstraint.Text) then
        SetModified;
      SelectedDomain.ConstraintExpr := edConstraint.Text;
    end
    else
    if (Sender = mInfo) and (SelectedDomain <> nil) then
    begin
      if (SelectedDomain.Information <> mInfo.Text) then
        SetModified;
      SelectedDomain.Information := mInfo.Text;
    end
    else
    if (Sender = edSeed) and (SelectedDomain <> nil) then
    begin
      if (SelectedDomain.SeedValue <> StrToIntDef(edSeed.Text, 0)) then
        SetModified;
      SelectedDomain.SeedValue := StrToIntDef(edSeed.Text, 0);
    end
    else
    if (Sender = edIncrement) and (SelectedDomain <> nil) then
    begin
      if (SelectedDomain.IncrementValue <> StrToIntDef(edIncrement.Text, 0)) then
        SetModified;
      SelectedDomain.IncrementValue := StrToIntDef(edIncrement.Text, 0);
    end;

    LoadProperty(Sender);
  end;
end;

end.

