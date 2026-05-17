unit fEditConversionMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, AdvGrid, AdvCGrid, uDataTypeConversion,
  ExtCtrls,  uGDAO, dgDBTypes, AdvObj, AdvUtil;

type
  TfmEditConversionMap = class(TForm)
    grMap: TAdvColumnGrid;
    cbSourceDB: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbTargetDB: TComboBox;
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Label3: TLabel;
    edName: TEdit;
    Label4: TLabel;
    btCancel: TButton;
    btOk: TButton;
    procedure DBComboChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure grMapGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure grMapGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure grMapCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure grMapSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAutoName: boolean;
    FItems: TDataTypeConversionItems;
    FMap: TDataTypeConversionMap;
    FModified: boolean;
    FUserMap: TDataTypeConversionMap;
    FInternalEditFlag: boolean;
    function IsMapEditable: boolean;
    function GetMapItem(ARow: integer): TDataTypeConversionItem;

    function GetTargetDataType(ARow: integer): TGDAODataType;

    function GetSourceDB: TDatabaseType;
    function GetTargetDB: TDatabaseType;
    procedure SetMap(const Value: TDataTypeConversionMap);
    procedure ReloadConversionMap;
    procedure LoadConversionMapGrid;
    procedure DoAutoName;
    procedure UpdateEditableState;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ConversionMap: TDataTypeConversionMap read FUserMap write SetMap;
  end;

implementation

uses
  uDBProperties, dgConsts, uAppUtils;

{$R *.dfm}

{ TfmEditConversionMap }

procedure TfmEditConversionMap.btOkClick(Sender: TObject);
begin
  {Validation checks}
  if GetSourceDB = nil then
  begin
    cbSourceDB.SetFocus;
    raise EGUIException.Create('Please specify source database.');
  end;
  if GetTargetDB = nil then
  begin
    cbTargetDB.SetFocus;
    raise EGUIException.Create('Please specify target database.');
  end;
  if edName.Text = '' then
  begin
    edName.SetFocus;
    raise EGUIException.Create('Please specify a name for the conversion map.');
  end;

  FMap.ConversionItems.Assign(FItems);
  FMap.OriginalDBType := GetSourceDB;
  FMap.TargetDBType := GetTargetDB;
  FMap.ConversionName := edName.Text;
  ModalResult := mrOk;
end;

procedure TfmEditConversionMap.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

constructor TfmEditConversionMap.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TDataTypeConversionItems.Create;
end;

procedure TfmEditConversionMap.DBComboChange(Sender: TObject);
begin
  FModified := true;
  ReloadConversionMap;
  LoadConversionMapGrid;
  DoAutoName;
end;

destructor TfmEditConversionMap.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TfmEditConversionMap.DoAutoName;
begin
  if FAutoName and (GetSourceDB <> nil) and (GetTargetDB <> nil) then
  begin
    edName.Text := Format('%s to %s',
      [GetSourceDB.DisplayName, GetTargetDB.DisplayName]);

    {return flag back to true}
    FAutoName := true;
  end;
end;

procedure TfmEditConversionMap.edNameChange(Sender: TObject);
begin
  FAutoName := false;
  FModified := true;
end;

procedure TfmEditConversionMap.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmEditConversionMap.FormShow(Sender: TObject);
begin
  if GetSourceDB = nil then
    cbSourceDB.SetFocus
  else
  if GetTargetDB = nil then
    cbTargetDB.SetFocus
  else
  begin
    grMap.Row := 1;
    grMap.Col := 1;
    grMap.SetFocus;
  end;
end;

function TfmEditConversionMap.GetSourceDB: TDatabaseType;
begin
  if cbSourceDB.ItemIndex >= 0 then
    result := TDatabaseType(cbSourceDB.Items.Objects[cbSourceDB.ItemIndex])
  else
    result := nil;
end;

function TfmEditConversionMap.GetTargetDataType(ARow: integer): TGDAODataType;
begin
  if (GetTargetDB <> nil) and (GetMapItem(ARow) <> nil) then
    result := TGDAODataTypes(GetTargetDB.DataTypes).FindByName(GetMapItem(ARow).TargetDataType)
  else
    result := nil;
end;

function TfmEditConversionMap.GetTargetDB: TDatabaseType;
begin
  if cbTargetDB.ItemIndex >= 0 then
    result := TDatabaseType(cbTargetDB.Items.Objects[cbTargetDB.ItemIndex])
  else
    result := nil;
end;

procedure TfmEditConversionMap.grMapCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
var
  dsttype: TGDAODataType;
begin
  if ARow > 0 then
  begin
    dsttype := GetTargetDataType(ARow);
    case ACol of
      2: CanEdit := (dsttype <> nil) and dsttype.SizeIsRequired;
      3: CanEdit := (dsttype <> nil) and dsttype.Size2IsRequired;
    end;
  end;

  {Turn the whole grid readonly if it's a system map}
  if not IsMapEditable then
    CanEdit := false;
end;

procedure TfmEditConversionMap.grMapGetDisplText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  item: TDataTypeConversionItem;
  dsttype: TGDAODataType;
begin
  if ARow > 0 then
  begin
    dsttype := GetTargetDataType(ARow);
    item := GetMapItem(ARow);
    case ACol of
      2: {Size/Length}
        if (dsttype <> nil) and (dsttype.SizeIsRequired) and (item <> nil) then
        begin
          if item.Size = 0 then
            Value := 'Keep'
          else
            Value := IntToStr(item.Size);
        end
        else
          Value := '-';
      3: {Precision}
        if (dsttype <> nil) and (dsttype.Size2IsRequired) and (item <> nil) then
        begin
          if item.Size2 = 0 then
            Value := 'Keep'
          else
            Value := IntToStr(item.Size2);
        end
        else
          Value := '-';
    end;
  end;
end;

procedure TfmEditConversionMap.grMapGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  item: TDataTypeConversionItem;
begin
  if ARow > 0 then
  begin
    item := GetMapItem(ARow);
      case ACol of
        2:
          if item <> nil then
            Value := IntToStr(item.Size);
        3:
          if item <> nil then
            Value := IntToStr(item.Size2);
      end;
  end;
end;

procedure TfmEditConversionMap.grMapSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  item: TDataTypeConversionItem;
begin
  if ARow > 0 then
  begin
    item := GetMapItem(ARow);
      case ACol of
        1:
          if item <> nil then
            item.TargetDataType := Value;
        2:
          if item <> nil then
            item.Size := StrToIntDef(Value, 0);
        3:
          if item <> nil then
            item.Size2 := StrToIntDef(Value, 0);
      end;
    grMap.Invalidate;
  end;
end;

procedure TfmEditConversionMap.Image1DblClick(Sender: TObject);
begin
  {Hidden feature!
   Ctrl + Shift + Right Alt + Double click on image makes form editable and
   turns the current map into a system map (so if it's a newly added mapped
   it will be created in system conversions directory}
  if (GetKeyState(VK_SHIFT) < 0) and (GetKeyState(VK_CONTROL) < 0)
    and (GetKeyState(VK_RMENU) < 0) then
  begin
    FInternalEditFlag := true;
    FMap.System := true;
    UpdateEditableState;
    Caption := Caption + ' - System';
  end;
end;

function TfmEditConversionMap.IsMapEditable: boolean;
begin
  result := not FMap.System or FInternalEditFlag;
end;

procedure TfmEditConversionMap.LoadConversionMapGrid;
var
  i : Integer;
  item: TDataTypeConversionItem;
  ARow: integer;
  ASelRow: integer;
begin
  {Load rows}
  grMap.BeginUpdate;
  try
    ASelRow := grMap.Row;
    grMap.ClearRows(1, grMap.Rowcount);
    if FItems.Count = 0 then
      grMap.RowCount := 2
    else
      grMap.RowCount := FItems.Count + 1;
    for i := 0 to FItems.Count - 1 do
    begin
      item := FItems[i];
      ARow := i + 1;

      grMap.Cells[0, ARow] := item.OriginalDataType;
      grMap.Cells[1, ARow] := item.TargetDataType;
      grMap.Ints[2, ARow] := item.Size;
      grMap.Ints[3, ARow] := item.Size2;
      grMap.Objects[0, ARow] := item;
    end;

    if ASelRow >= grMap.RowCount then
      grMap.Row := grMap.RowCount - 1
    else
    if ASelRow > 0 then
      grMap.Row := ASelRow
    else
      grMap.Row := 1;
  finally
    grMap.EndUpdate;
  end;

  grMap.Invalidate;

  {Load combobox items}
  grMap.Columns[1].ComboItems.Clear;
  if GetTargetDB <> nil then
    for i := 0 to TGDAODataTypes(GetTargetDB.DataTypes).Count - 1 do
      grMap.Columns[1].ComboItems.Add(
        TGDAODataTypes(GetTargetDB.DataTypes)[i].Name
        );
end;

function TfmEditConversionMap.GetMapItem(ARow: integer): TDataTypeConversionItem;
begin
  if (ARow > 0) and (ARow < grMap.RowCount) then
    result := TDataTypeConversionItem(grMap.Objects[0, ARow])
  else
    result := nil;
end;

procedure TfmEditConversionMap.ReloadConversionMap;
begin
  TDBProperties.FillDefaultConversionItems(FItems, GetSourceDB, GetTargetDB);
end;

procedure TfmEditConversionMap.SetMap(const Value: TDataTypeConversionMap);
begin
  FMap := Value;
  FItems.Assign(FMap.ConversionItems);
  TDBProperties.FillDatabaseTypes(cbSourceDB.Items, '');
  TDBProperties.FillDatabaseTypes(cbTargetDB.Items, '');

  edName.Text := FMap.ConversionName;

  {Set FAutoName after setting edName.Text}
  FAutoName := FMap.ConversionName = '';

  cbSourceDB.ItemIndex := cbSourceDB.Items.IndexOfObject(FMap.OriginalDBType);
  cbTargetDB.ItemIndex := cbTargetDB.Items.IndexOfObject(FMap.TargetDBType);
  LoadConversionMapGrid;
  FModified := false;

  UpdateEditableState;
end;

procedure TfmEditConversionMap.UpdateEditableState;
begin
  {update read only for system maps}
  cbSourceDB.Enabled := IsMapEditable;
  cbTargetDB.Enabled := IsMapEditable;
  edName.Enabled := IsMapEditable;
  btOk.Enabled := IsMapEditable;
end;


end.
