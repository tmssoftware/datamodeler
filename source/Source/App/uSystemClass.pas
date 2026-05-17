unit uSystemClass;

interface

uses
  Classes, Windows, SysUtils, Contnrs, Controls, Forms, Types,
  uConnectionsFile,
  uDataTypeConversion;

const
  SConversionMapExt = '.dcm';

type
  TSystemClass = class
  private
    FMaps: TObjectList;
    FUserConnections : TConnectionsFile;
    function GetConnectionsFileName: String;
    function GetMap(Index: integer): TDataTypeConversionMap;

    function BuildConversionMapFileName(AMap: TDataTypeConversionMap): string;
    procedure UpdateConversionMapFile(AMap: TDataTypeConversionMap);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadUserConnectionsFile;
    procedure SaveUserConnectionsFile;

    {Conversion map manipulation methods}
    procedure UpdateConversionMaps;
    procedure ManageConversionMapsDlg;
    function AddConversionMapDlg: boolean;
    function EditConversionMapDlg(AMap: TDataTypeConversionMap): boolean;
    procedure DeleteConversionMap(AMap: TDataTypeConversionMap);
    function ConversionMapCount: integer;

    property ConversionMaps[Index: integer]: TDataTypeConversionMap read GetMap;
    property UserConnections: TConnectionsFile read FUserConnections;
  end;

function SystemConfig: TSystemClass;

implementation

uses
  fEditConversionMap, fConversionMaps, uStrings, uAppUtils;

var
  vSystemConfig: TSystemClass;

function SystemConfig: TSystemClass;
begin
  if not Assigned(vSystemConfig) then
    vSystemConfig := TSystemClass.Create;
  result := vSystemConfig;
end;

{ TSystemClass }

function TSystemClass.AddConversionMapDlg: boolean;
var
  ANewMap: TDataTypeConversionMap;
begin
  ANewMap := TDataTypeConversionMap.Create(nil);
  try
    result := EditConversionMapDlg(ANewMap);
    if result then
    begin
      ANewMap.FileName := BuildConversionMapFileName(ANewMap);
      UpdateConversionMapFile(ANewMap);
      FMaps.Add(ANewMap);
    end else
    begin
      ANewMap.Free;
      ANewMap := nil;
    end;
  except
    if ANewMap <> nil then
      ANewMap.Free;
    raise;
  end;
end;

function TSystemClass.BuildConversionMapFileName(AMap: TDataTypeConversionMap): string;

  function _BuildMapFileName(ABase: string): string;
  begin
    if AMap.System then
      result := GetDMConversionsFolder(true) + ChangeFileExt(ABase, SConversionMapExt)
    else
      result := GetDMCustomConversionsFolder(true) + ChangeFileExt(ABase, SConversionMapExt);
  end;

var
  ABaseName: string;
  i: integer;
begin
  ABaseName := Format('%s_%s', [AMap.OriginalDBType.DatabaseTypeID, AMap.TargetDBType.DatabaseTypeID]);
  result := _BuildMapFileName(ABaseName);
  i := 0;
  while FileExists(result) do
  begin
    inc(i);
    result := _BuildMapFileName(Format('%s_%d', [ABaseName, i]));
  end;
end;

function TSystemClass.ConversionMapCount: integer;
begin
  result := FMaps.Count;
end;

constructor TSystemClass.Create;
begin
  FMaps := TObjectList.Create(true);
  FUserConnections := TConnectionsFile.Create(nil);
  LoadUserConnectionsFile;
end;

procedure TSystemClass.DeleteConversionMap(AMap: TDataTypeConversionMap);
begin
  if FileExists(AMap.FileName) then
    DeleteFile(AMap.FileName);
  FMaps.Remove(AMap);
end;

destructor TSystemClass.Destroy;
begin
  FMaps.Free;
  SaveUserConnectionsFile;
  FUserConnections.Free;
  inherited;
end;

function TSystemClass.EditConversionMapDlg(AMap: TDataTypeConversionMap): boolean;
var
  edForm: TfmEditConversionMap;
begin
  edForm := TfmEditConversionMap.Create(nil);
  try
    edForm.ConversionMap := AMap;
    result := (edForm.ShowModal = mrOk);
    if result and (FileExists(AMap.FileName)) then
      UpdateConversionMapFile(AMap);
  finally
    edForm.Free;
  end;
end;

function TSystemClass.GetConnectionsFileName: String;
const
  CON_FILE_NAME = 'UsrConnections.bin';
begin
  // use the file from application path, if exists
  result := ExtractFilePath(Application.ExeName) + CON_FILE_NAME;
  if not FileExists(result) then
    result := GetDMAppDataFolder(true) + CON_FILE_NAME;
end;

procedure TSystemClass.LoadUserConnectionsFile;
var
  s : String;
begin
  s := GetConnectionsFileName;
  if FileExists(s) then
  begin
    if FUserConnections <> nil then
      FUserConnections.Free;
    FUserConnections := TConnectionsFile.Create(nil);

    LoadComponentFromFile(s, FUserConnections);
  end;
end;

procedure TSystemClass.SaveUserConnectionsFile;
begin
  SaveComponentToFile(GetConnectionsFileName, FUserConnections);
end;

function TSystemClass.GetMap(Index: integer): TDataTypeConversionMap;
begin
  result := TDataTypeConversionMap(FMaps[Index]);
end;

procedure TSystemClass.ManageConversionMapsDlg;
begin
  with TfmConversionMaps.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TSystemClass.UpdateConversionMapFile(AMap: TDataTypeConversionMap);
begin
  SaveComponentToFile(AMap.FileName, AMap);
end;

procedure TSystemClass.UpdateConversionMaps;

  procedure _FillFileNames(APath: string; SL: TStrings);
  var
    SR: TSearchRec;
    ARes: integer;
  begin
    SL.Clear;
    ARes := FindFirst(APath, faReadOnly or faArchive or faHidden, SR);
    while ARes = 0 do
    begin
      SL.Add(IncludeTrailingPathDelimiter(ExtractFilePath(APath)) + SR.Name);
      ARes := FindNext(SR);
    end;
    FindClose(SR);
  end;

  procedure _LoadMaps(SL: TStrings; ASystem: boolean);
  var
    c: integer;
    AMap: TDataTypeConversionMap;
  begin
    for c := 0 to SL.Count - 1 do
    begin
      AMap := TDataTypeConversionMap.Create(nil);
      FMaps.Add(AMap);
      AMap.System := ASystem;
      AMap.FileName := SL[c];
      LoadComponentFromFile(AMap.FileName, AMap);
    end;
  end;

var
  CustomSL: TStringList;
  SystemSL: TStringList;
begin
  CustomSL := TStringList.Create;
  SystemSL := TStringList.Create;
  try
    FMaps.Clear;
    _FillFileNames(GetDMConversionsFolder(true) + '*' + SConversionMapExt, SystemSL);
    _FillFileNames(GetDMCustomConversionsFolder(true) + '*' + SConversionMapExt, CustomSL);

    _LoadMaps(SystemSL, true);
    _LoadMaps(CustomSL, false);
  finally                           
    CustomSL.Free;
    SystemSL.Free;
  end;
end;


initialization

finalization
  if Assigned(vSystemConfig) then
    FreeAndNil(vSystemConfig);

end.

