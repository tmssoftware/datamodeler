unit fDuplicateTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, Buttons, ExtCtrls,  pngimage,
  uGDAO, System.Actions;

type
  TfmDuplicateTable = class(TForm)
    Label4: TLabel;
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    btOk: TBitBtn;
    cbTable: TComboBox;
    ActionList1: TActionList;
    acDuplicate: TAction;
    edNewTableName: TEdit;
    Label1: TLabel;
    procedure acDuplicateExecute(Sender: TObject);
    procedure acDuplicateUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FNewTable: TGDAOTable;
    FDataDictionary: TGDAODatabase;
    function GetTable: TGDAOTable;
    procedure LoadTables(ACombo: TComboBox);
  public
    procedure SetInfo(ADataDictionary: TGDAODatabase; ATable: TGDAOTable);
    property NewTable: TGDAOTable read FNewTable;
  end;

implementation

uses
  dgConsts, uAppUtils;

{$R *.dfm}

{ TfmDuplicateTable }

procedure TfmDuplicateTable.acDuplicateExecute(Sender: TObject);
begin
  if GetTable <> nil then
  begin
    if edNewTableName.Text = '' then
      raise EGUIException.Create('Please inform name of new table');
    if FDataDictionary.Tables.FindByName(edNewTableName.Text) <> nil then
      raise EGUIException.CreateFmt('Table "%s" already exists.', [edNewTableName.Text]);

    FNewTable := FDataDictionary.DuplicateTable(GetTable, edNewTableName.Text);
    ModalResult := mrOk;
  end;
end;

procedure TfmDuplicateTable.acDuplicateUpdate(Sender: TObject);
begin
  acDuplicate.Enabled := (GetTable <> nil);
end;

procedure TfmDuplicateTable.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

function TfmDuplicateTable.GetTable: TGDAOTable;
begin
  if cbTable.ItemIndex >= 0 then
    result := TGDAOTable(cbTable.Items.Objects[cbTable.ItemIndex])
  else
    result := nil;
end;

procedure TfmDuplicateTable.LoadTables(ACombo: TComboBox);
var
  i: integer;
  obj: TObject;
begin
  if ACombo.ItemIndex >= 0 then
    obj := ACombo.Items.Objects[ACombo.ItemIndex]
  else
    obj := nil;

  ACombo.Items.Clear;
  for i := 0 to FDataDictionary.Tables.Count - 1 do
    if FDataDictionary.Tables[i].Visible then
      ACombo.Items.AddObject(FDataDictionary.Tables[i].TableName, FDataDictionary.Tables[i]);

  if obj <> nil then
    ACombo.ItemIndex := ACombo.Items.IndexOfObject(obj);
end;

procedure TfmDuplicateTable.SetInfo(ADataDictionary: TGDAODatabase;
  ATable: TGDAOTable);
var
  i: integer;
  NewName: string;
begin
  FDataDictionary := ADataDictionary;
  LoadTables(cbTable);

  cbTable.ItemIndex := cbTable.Items.IndexOfObject(ATable);
  i := 0;
  repeat
    inc(i);
    NewName := Format('%s_%d', [ATable.TableName, i]);
  until FDataDictionary.TableByName(NewName) = nil;
  edNewTableName.Text := NewName;
end;

end.
