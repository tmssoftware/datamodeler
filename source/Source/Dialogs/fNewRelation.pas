unit fNewRelation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uGDAO, Dialogs, StdCtrls, Buttons, ExtCtrls,  ImgList, ComCtrls,
  ActnList, dgConsts, System.Actions;

type
  TfmNewRelation = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    btOk: TBitBtn;
    ActionList1: TActionList;
    acNewRelation: TAction;
    Label3: TLabel;
    Label4: TLabel;
    cbMaster: TComboBox;
    Label5: TLabel;
    cbDetail: TComboBox;
    btRelNID: TSpeedButton;
    btRelID: TSpeedButton;
    procedure acNewRelationExecute(Sender: TObject);
    procedure acNewRelationUpdate(Sender: TObject);
    procedure btRelNIDClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRelationshipType: TGDAORelationshipType;
    FDataDictionary: TGDAODatabase;
    FRelationship: TGDAORelationship;
    function GetChildTable: TGDAOTable;
    function GetParentTable: TGDAOTable;
    procedure LoadTables(ACombo: TComboBox);
    procedure SetDataDictionary(const Value: TGDAODatabase);
    procedure SetChildTable(const Value: TGDAOTable);
    procedure SetParentTable(const Value: TGDAOTable);
    property RelationshipType: TGDAORelationshipType read FRelationshipType;
  public
    property DataDictionary: TGDAODatabase read FDataDictionary write SetDataDictionary;
    property ParentTable: TGDAOTable read GetParentTable write SetParentTable;
    property ChildTable: TGDAOTable read GetChildTable write SetChildTable;
    property Relationship: TGDAORelationship read FRelationship;
  end;

implementation

uses
  fRelationshipDialog, uAppUtils;

{$R *.dfm}

procedure TfmNewRelation.acNewRelationExecute(Sender: TObject);
var
  newrel: TGDAORelationship;

  function NewRelationship(AType: TGDAORelationshipType; AChildTable, AParentTable: TGDAOTable): boolean;
  var
    recursemsg: boolean;
  begin
    newrel := DataDictionary.Relationships.Add;
    newrel.ParentTable := AParentTable;
    newrel.ChildTable := AChildTable;
    newrel.RelationshipType := AType;
    result := newrel.AutoCreateRelationshipKey(AParentTable.PrimaryKeyIndex, true {GlobalDMApp.AutoFieldInRelationship});
    recursemsg := not result;
    result := result and ShowRelationshipDialog(newrel);
    if not result then
    begin
      newrel.Free;
      newrel := nil;
    end;

    if recursemsg then
      ShowMessage('Recursive relationship. Cannot create.');
  end;

var
  ok: boolean;
begin
  // create new relationship
  if (RelationshipType <> ryUndefined) and (ParentTable <> nil) and (ChildTable <> nil) then
  begin
    case RelationshipType of
      ryIdentifying, ryNonIdentifying:
        begin
          ok := NewRelationship(RelationshipType, ChildTable, ParentTable);
          FRelationship := newrel;
        end;
      else
        ok := False;
    end;

    if ok then
      ModalResult := mrOk;
  end;
end;

procedure TfmNewRelation.acNewRelationUpdate(Sender: TObject);
begin
  acNewRelation.Enabled := (RelationshipType <> ryUndefined) and (ParentTable <> nil) and (ChildTable <> nil);
end;

procedure TfmNewRelation.btRelNIDClick(Sender: TObject);
begin
  FRelationshipType := TGDAORelationshipType(TSpeedButton(Sender).Tag);
end;

procedure TfmNewRelation.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FRelationshipType := ryNonIdentifying;
end;

function TfmNewRelation.GetChildTable: TGDAOTable;
begin
  if cbDetail.ItemIndex >= 0 then
    result := TGDAOTable(cbDetail.Items.Objects[cbDetail.ItemIndex])
  else
    result := nil;
end;

function TfmNewRelation.GetParentTable: TGDAOTable;
begin
  if cbMaster.ItemIndex >= 0 then
    result := TGDAOTable(cbMaster.Items.Objects[cbMaster.ItemIndex])
  else
    result := nil;
end;

procedure TfmNewRelation.LoadTables(ACombo: TComboBox);
var
  i: integer;
  obj: TObject;
begin
  if ACombo.ItemIndex >= 0 then
    obj := ACombo.Items.Objects[ACombo.ItemIndex]
  else
    obj := nil;

  ACombo.Items.Clear;
  for i := 0 to DataDictionary.Tables.Count - 1 do
    if DataDictionary.Tables[i].Visible then
      ACombo.Items.AddObject(DataDictionary.Tables[i].TableName, DataDictionary.Tables[i]);

  if obj <> nil then
    ACombo.ItemIndex := ACombo.Items.IndexOfObject(obj);
end;

procedure TfmNewRelation.SetChildTable(const Value: TGDAOTable);
begin
  cbDetail.ItemIndex := cbDetail.Items.IndexOfObject(Value);
end;

procedure TfmNewRelation.SetDataDictionary(const Value: TGDAODatabase);
begin
  FDataDictionary := Value;
  LoadTables(cbMaster);
  LoadTables(cbDetail);
end;

procedure TfmNewRelation.SetParentTable(const Value: TGDAOTable);
begin
  cbMaster.ItemIndex := cbMaster.Items.IndexOfObject(Value);
end;

end.

