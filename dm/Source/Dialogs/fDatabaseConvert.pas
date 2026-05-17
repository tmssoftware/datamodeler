unit fDatabaseConvert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uAppMetaData, Dialogs, StdCtrls, Buttons, ExtCtrls, 
  uDataTypeConversion, uGDAO, ActnList, Grids, BaseGrid, AdvGrid, AdvCGrid,
  AdvToolBtn, dgConsts, dgDBTypes, UITypes, System.Actions;

type
  TfmDatabaseConvert = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    btOk: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    cbDBType: TComboBox;
    ActionList1: TActionList;
    acOk: TAction;
    lbCurrentDBType: TLabel;
    lbMap: TLabel;
    cbMap: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure acOkUpdate(Sender: TObject);
    procedure acOkExecute(Sender: TObject);
    procedure cbDBTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAMD: TAppMetaData;
    function SelectedMap: TDataTypeConversionMap;
    function GetTargetDatabaseType: TDatabaseType;
    procedure UpdateInfo;
    procedure UpdateMapVisibility(AVisible: boolean);
    procedure FillConversionMaps(SL: TStrings; ADatabaseType: TDatabaseType);
    function HasConversionMap(ADatabaseType: TDatabaseType): boolean;
  public
    property AMD: TAppMetaData read FAMD write FAMD;
  end;

implementation

uses
  uDBProperties, uSystemClass, uAppUtils;

{$R *.dfm}

procedure TfmDatabaseConvert.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmDatabaseConvert.FormShow(Sender: TObject);
begin
  UpdateInfo;
end;

function TfmDatabaseConvert.GetTargetDatabaseType: TDatabaseType;
begin
  result := TDatabaseType(cbDBType.Items.Objects[cbDBTYpe.ItemIndex]);
end;

procedure TfmDatabaseConvert.UpdateMapVisibility(AVisible: boolean);
begin
  lbMap.Visible := AVisible;
  cbMap.Visible := AVisible;
end;

procedure TfmDatabaseConvert.FillConversionMaps(SL: TStrings; ADatabaseType: TDatabaseType);
var
  c: integer;
begin
  SL.Clear;
  for c := 0 to SystemConfig.ConversionMapCount - 1 do
    if (SystemConfig.ConversionMaps[c].TargetDBType = ADatabaseType)
      and (SystemConfig.ConversionMaps[c].OriginalDBType = FAMD.DataDictionary.DatabaseType) then
      SL.AddObject(SystemConfig.ConversionMaps[c].ConversionName,
        SystemConfig.ConversionMaps[c]);
end;

function TfmDatabaseConvert.HasConversionMap(ADatabaseType: TDatabaseType): boolean;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    FillConversionMaps(SL, ADatabaseType);
    result := SL.Count > 0;
  finally
    SL.Free;
  end;
end;

function TfmDatabaseConvert.SelectedMap: TDataTypeConversionMap;
begin
  if (cbMap.ItemIndex >= 0) and (cbMap.Items.Objects[cbMap.ItemIndex] <> nil) then
    result := TDataTypeConversionMap(cbMap.Items.Objects[cbMap.ItemIndex])
  else
    result := nil;
end;

procedure TfmDatabaseConvert.UpdateInfo;
var
  c: integer;
begin
  SystemConfig.UpdateConversionMaps;
  UpdateMapVisibility(false);

  lbCurrentDBType.Caption := FAMD.DataDictionary.DatabaseType.DisplayName;

  TDBProperties.FillDatabaseTypes(cbDBType.Items, '(choose target database)');
  cbDBType.ItemIndex := 0;

  { avoiding type duplication }
  cbDBType.Items.Delete( cbDBType.Items.IndexOfObject(FAMD.DataDictionary.DatabaseType) );

  {Remove items with no conversion map}
  for c := cbDBType.Items.Count - 1 downto 1 do
  begin
    if not HasConversionMap(TDatabaseType(cbDBType.Items.Objects[c])) then
      cbDBType.Items.Delete(c);
  end;
end;

procedure TfmDatabaseConvert.acOkUpdate(Sender: TObject);
begin
  acOk.Enabled := (cbDBType.ItemIndex > 0) and (SelectedMap <> nil);
end;

procedure TfmDatabaseConvert.cbDBTypeChange(Sender: TObject);
begin
  FillConversionMaps(cbMap.Items, GetTargetDatabaseType);
  if cbMap.Items.Count > 0 then
    cbMap.ItemIndex := 0;
  UpdateMapVisibility(cbMap.Items.Count > 1);
end;

procedure TfmDatabaseConvert.acOkExecute(Sender: TObject);
begin
  {Close all tabs before converting the project, otherwise all pointers
   of opened windows will become invalid and AV might occur. }
  FAMD.PerformMessage(WM_DM_CLOSEEXPLORERITEMS);
  TDBProperties.ConvertDataBaseType(FAMD.DataDictionary, SelectedMap);
  MessageDlg('Project converted successfully.', mtInformation, [mbOk], 0);
  ModalResult := mrOk;
end;

end.

