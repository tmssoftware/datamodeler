unit fConversionMaps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,  ImgList, ComCtrls,
  ActnList, dgConsts, dgDBTypes, Grids, BaseGrid, AdvGrid,
  AdvCGrid, uDataTypeConversion, AdvObj, UITypes, AdvUtil, System.ImageList,
  System.Actions;

type
  TfmConversionMaps = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Panel1: TPanel;
    ActionList1: TActionList;
    acRemove: TAction;
    acEdit: TAction;
    ImageList1: TImageList;
    acAdd: TAction;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Button4: TButton;
    Image1: TImage;
    grMaps: TAdvColumnGrid;
    cbShowSystem: TCheckBox;
    procedure acRemoveUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acRemoveExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure lvMapsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure FormShow(Sender: TObject);
    procedure cbShowSystemClick(Sender: TObject);
    procedure grMapsGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadConversionMapGrid;
    function SelectedMap: TDataTypeConversionMap;
    function MapFromRow(ARow: integer): TDataTypeConversionMap;
  public
  end;

implementation

uses
  uSystemClass, uAppUtils;

{$R *.dfm}

procedure TfmConversionMaps.LoadConversionMapGrid;
var
  i : Integer;
  map: TDataTypeConversionMap;
  ARow: integer;
  ASelRow: integer;
begin
  grMaps.BeginUpdate;
  try
    ASelRow := grMaps.Row;
    SystemConfig.UpdateConversionMaps;
    grMaps.ClearRows(1, grMaps.Rowcount);
    grMaps.RowCount := 2;
    for i := 0 to SystemConfig.ConversionMapCount - 1 do
      if not SystemConfig.ConversionMaps[i].System or cbShowSystem.Checked then
      begin
        map := SystemConfig.ConversionMaps[i];
        ARow := grMaps.RowCount - 1;

        grMaps.Cells[0, ARow] := map.OriginalDBType.DisplayName;
        grMaps.Cells[1, ARow] := map.TargetDBType.DisplayName;
        grMaps.Cells[2, ARow] := map.ConversionName;
        grMaps.Objects[0, ARow] := map;
        grMaps.RowCount := grMaps.RowCount + 1;
      end;

    {Remove the remaining row}
    if grMaps.RowCount > 2 then
      grMaps.RowCount := grMaps.RowCount - 1;

    {Keep row select in grid options}
    grMaps.Options := grMaps.Options + [goRowSelect];

    {Reselect the previously selected row}
    if ASelRow >= grMaps.RowCount then
      grMaps.Row := grMaps.RowCount - 1
    else
    if ASelRow > 0 then
      grMaps.Row := ASelRow
    else
      grMaps.Row := 1;

  finally
    grMaps.EndUpdate;
  end;
end;

function TfmConversionMaps.SelectedMap: TDataTypeConversionMap;
begin
  result := MapFromRow(grMaps.Row);
end;

procedure TfmConversionMaps.acRemoveUpdate(Sender: TObject);
begin
  acRemove.Enabled := (SelectedMap <> nil) and not SelectedMap.System;
end;

procedure TfmConversionMaps.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TfmConversionMaps.cbShowSystemClick(Sender: TObject);
begin
  LoadConversionMapGrid;
end;

procedure TfmConversionMaps.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmConversionMaps.FormShow(Sender: TObject);
begin
  LoadConversionMapGrid;
end;

procedure TfmConversionMaps.grMapsGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if MapFromRow(ARow) <> nil then
  begin
    if MapFromRow(ARow).System then
      AFont.Color := clGray
    else
      AFont.Color := clWindowText;
  end;
end;

procedure TfmConversionMaps.acEditUpdate(Sender: TObject);
begin
  acEdit.Enabled := (SelectedMap <> nil);
  if (SelectedMap <> nil) and SelectedMap.System then
    acEdit.Caption := '&View'
  else
    acEdit.Caption := '&Edit';
end;

procedure TfmConversionMaps.acRemoveExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete selected conversion map? This action can''t be undone.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    SystemConfig.DeleteConversionMap(SelectedMap);
    LoadConversionMapGrid;
  end;
end;

procedure TfmConversionMaps.acEditExecute(Sender: TObject);
begin
  if SystemConfig.EditConversionMapDlg(SelectedMap) then
    LoadConversionMapGrid;
end;

procedure TfmConversionMaps.lvMapsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;

function TfmConversionMaps.MapFromRow(ARow: integer): TDataTypeConversionMap;
begin
  if (ARow > 0) and (ARow < grMaps.RowCount) and (grMaps.Objects[0, ARow] <> nil) then
    result := TDataTypeConversionMap(grMaps.Objects[0, ARow])
  else
    result := nil;
end;

procedure TfmConversionMaps.acAddExecute(Sender: TObject);
begin
  if SystemConfig.AddConversionMapDlg then
  begin
    LoadConversionMapGrid;
    grMaps.Row := grMaps.RowCount - 1;
  end;
end;

end.

