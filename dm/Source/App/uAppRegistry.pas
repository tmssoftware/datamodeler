unit uAppRegistry;

interface

uses
  Windows, Classes, SysUtils, Registry, Math;

type
  TDMMeasurementUnit = (dmuCentimeter, dmuMilimeter, dmuInch);

  TDMRegistry = class(TRegIniFile)
  private
    FDMBaseKey: string;
    FDMSettingsKey: string;
    FDMRecentFilesKey: string;
    function CheckDevgemsRegKey: boolean;
    procedure SaveRecentFiles(AStrings: TStrings);
    function GetCheckUpdates: boolean;
    procedure SetCheckUpdates(const Value: boolean);
    procedure OpenRecentFilesKey;
    function GetDefaultProject: string;
    function GetAutoRemoveDefaultProject: boolean;
    procedure SetAutoRemoveDefaultProject(const Value: boolean);
    procedure SetDefaultProject(const Value: string);
    function GetMeasUnit: TDMMeasurementUnit;
    procedure SetMeasUnit(const Value: TDMMeasurementUnit);
    function GetMessagesPanelHeight: integer;
    function GetProjectExplorerWidth: integer;
    procedure SetMessagesPanelHeight(const Value: integer);
    procedure SetProjectExplorerWidth(const Value: integer);
    function GetAutoFieldRelationship: boolean;
    procedure SetAutoFieldRelationship(const Value: boolean);
    function GetLastUsedConnection: string;
    procedure SetLastUsedConnection(const Value: string);
    function GetShowNavigator: boolean;
    procedure SetShowNavigator(const Value: boolean);
  public
    constructor Create;
    procedure GetRecentFiles(AStrings: TStrings);
    procedure AddRecentFile(AFileName: string);
    procedure RemoveRecentFile(AFileName: string);
    property SettingsKey: string read FDMSettingsKey;
    property CheckUpdatesOnStart: boolean read GetCheckUpdates write SetCheckUpdates;
    property DefaultProject: string read GetDefaultProject write SetDefaultProject;
    property AutoRemoveDefaultProject: boolean read GetAutoRemoveDefaultProject write SetAutoRemoveDefaultProject;
    property ProjectExplorerWidth: integer read GetProjectExplorerWidth write SetProjectExplorerWidth;
    property MessagesPanelHeight: integer read GetMessagesPanelHeight write SetMessagesPanelHeight;
    property LastUsedConnection: string read GetLastUsedConnection write SetLastUsedConnection;
    property ShowNavigator: boolean read GetShowNavigator write SetShowNavigator;
    property MeasurementUnit: TDMMeasurementUnit read GetMeasUnit write SetMeasUnit;
    property AutoFieldRelationship: boolean read GetAutoFieldRelationship write SetAutoFieldRelationship;
  end;

function DMRegistry: TDMRegistry;

implementation

const
  {registry constants}
  SREG_CheckUpdatesOnStart = 'CheckUpdatesOnStart';
  SREG_DefaultProject = 'DefaultProject';
  SREG_AutoRemoveDefaultProject = 'AutoRemoveDefaultProject';
  SREG_MeasurementUnit = 'MeasurementUnit';
  SREG_AutoFieldRelationship = 'AutoFieldRelationship';
  SREG_ProjectExplorerWidth = 'ProjectExplorerWidth';
  SREG_MessagesPanelHeight = 'MessagesPanelHeight';
  SREG_LastUsedConnection = 'LastUsedConnection';
  SREG_ShowNavigator = 'ShowNavigator';

const
  TMSREGKEY = '\Software\TMS Software\Data Modeler';
  DEVGEMSREGKEY = '\Software\Devgems\Data Modeler';

var
  _DMRegistry: TDMRegistry;

function DMRegistry: TDMRegistry;
begin
  if _DMRegistry = nil then
    _DMRegistry := TDMRegistry.Create;
  Result := _DMRegistry;
end;

{ TDMRegistry }

procedure TDMRegistry.AddRecentFile(AFileName: string);
var
  SL: TStrings;
  i: integer;
begin
  SL := TStringList.Create;
  try
    GetRecentFiles(SL);
    i := SL.IndexOf(AFileName);
    if i >= 0 then
      SL.Delete(i);
    SL.Insert(0, AFileName);
    SaveRecentFiles(SL);
  finally
    SL.Free;
  end;
end;

function TDMRegistry.CheckDevgemsRegKey: boolean;
begin
  // move Devgems registry key to TMS Software key
  result := True;
  if KeyExists(DEVGEMSREGKEY) and not KeyExists(TMSREGKEY) then
  begin
    MoveKey(DEVGEMSREGKEY, TMSREGKEY, True);
    if not KeyExists(TMSREGKEY) then
      result := False;
  end;
end;

constructor TDMRegistry.Create;
begin
  inherited Create;
  RootKey := HKEY_CURRENT_USER;
  if CheckDevgemsRegKey then
    FDMBaseKey := TMSREGKEY
  else
    FDMBaseKey := DEVGEMSREGKEY;
  FDMSettingsKey := FDMBaseKey + '\Settings';
  FDMRecentFilesKey := FDMSettingsKey + '\Recent Files';
end;

function TDMRegistry.GetAutoFieldRelationship: boolean;
begin
  Result := ReadBool(FDMSettingsKey, SREG_AutoFieldRelationship, false);
end;

function TDMRegistry.GetAutoRemoveDefaultProject: boolean;
begin
  result := ReadBool(FDMSettingsKey, SREG_AutoRemoveDefaultProject, false);
end;

function TDMRegistry.GetCheckUpdates: boolean;
begin
  result := ReadBool(FDMSettingsKey, SREG_CheckUpdatesOnStart, true);
end;

function TDMRegistry.GetDefaultProject: string;
begin
  Result := ReadString(FDMSettingsKey, SREG_DefaultProject, '');
end;

function TDMRegistry.GetLastUsedConnection: string;
begin
  Result := ReadString(FDMSettingsKey, SREG_LastUsedConnection, '');
end;

function TDMRegistry.GetMeasUnit: TDMMeasurementUnit;
var
  i: integer;
begin
  i := ReadInteger(FDMSettingsKey, SREG_MeasurementUnit, -1);

  {if i = -1 means it's not saved in the registry}
  if i = -1 then
  begin
    {if not saved in registry, then we will retrieve the current regional settings
    and set the default unit automatically}
    if GetLocaleChar(GetThreadLocale, LOCALE_IMEASURE, '0') = '1' then
      result := dmuInch
    else
      result := dmuCentimeter;

    {Save in registry so it's not persisted}
    SetMeasUnit(result);
  end else
  begin
    {if saved in registry, just convert to unit}
    case i of
      1: result := dmuMilimeter;
      2: result := dmuInch;
    else
      //default
      result := dmuCentimeter;
    end;
  end;
end;

function TDMRegistry.GetMessagesPanelHeight: integer;
begin
  result := ReadInteger(FDMSettingsKey, SREG_MessagesPanelHeight, 0);
end;

function TDMRegistry.GetProjectExplorerWidth: integer;
begin
  result := ReadInteger(FDMSettingsKey, SREG_ProjectExplorerWidth, 0);
end;

procedure TDMRegistry.GetRecentFiles(AStrings: TStrings);
var
  SL: TStringList;
  c: integer;
  i: integer;
begin
  OpenRecentFilesKey;
  SL := TStringList.Create;
  try
    GetValueNames(SL);
    AStrings.Clear;
    for c := 0 to SL.Count - 1 do
    begin
      i := StrToIntDef(Copy(SL[c], Length('File ') + 1, MaxInt), -1);
      if i >= 0 then
        AStrings.Insert(Min(i, AStrings.Count), ReadString('', SL[c], ''));
    end;
  finally
    SL.Free;
  end;
end;

function TDMRegistry.GetShowNavigator: boolean;
begin
  Result := ReadBool(FDMSettingsKey, SREG_ShowNavigator, true);
end;

procedure TDMRegistry.OpenRecentFilesKey;
begin
  RootKey := HKEY_CURRENT_USER;
  OpenKey(FDMBaseKey + '\Recent Files', true);
end;

procedure TDMRegistry.RemoveRecentFile(AFileName: string);
var
  SL: TStrings;
  i: integer;
begin
  SL := TStringList.Create;
  try
    GetRecentFiles(SL);
    i := SL.IndexOf(AFileName);
    if i >= 0 then
      SL.Delete(i);
    SaveRecentFiles(SL);
  finally
    SL.Free;
  end;
end;

procedure TDMRegistry.SaveRecentFiles(AStrings: TStrings);
var
  c: Integer;
begin
  {Clear all values saved}
  OpenRecentFilesKey;
  EraseSection('');

  {write all values}
  OpenRecentFilesKey;
  for c := 0 to AStrings.Count - 1 do
    WriteString('', 'File ' + IntToStr(c), AStrings[c]);
end;

procedure TDMRegistry.SetAutoFieldRelationship(const Value: boolean);
begin
  WriteBool(FDMSettingsKey, SREG_AutoFieldRelationship, Value);
end;

procedure TDMRegistry.SetAutoRemoveDefaultProject(const Value: boolean);
begin
  WriteBool(FDMSettingsKey, SREG_AutoRemoveDefaultProject, Value);
end;

procedure TDMRegistry.SetCheckUpdates(const Value: boolean);
begin
  WriteBool(FDMSettingsKey, SREG_CheckUpdatesOnStart, Value);
end;

procedure TDMRegistry.SetDefaultProject(const Value: string);
begin
  WriteString(FDMSettingsKey, SREG_DefaultProject, Value);
end;

procedure TDMRegistry.SetLastUsedConnection(const Value: string);
begin
  WriteString(FDMSettingsKey, SREG_LastUsedConnection, Value);
end;

procedure TDMRegistry.SetMeasUnit(const Value: TDMMeasurementUnit);
begin
  WriteInteger(FDMSettingsKey, SREG_MeasurementUnit, Ord(Value));
end;

procedure TDMRegistry.SetMessagesPanelHeight(const Value: integer);
begin
  WriteInteger(FDMSettingsKey, SREG_MessagesPanelHeight, Value);
end;

procedure TDMRegistry.SetProjectExplorerWidth(const Value: integer);
begin
  WriteInteger(FDMSettingsKey, SREG_ProjectExplorerWidth, Value);
end;

procedure TDMRegistry.SetShowNavigator(const Value: boolean);
begin
  WriteBool(FDMSettingsKey, SREG_ShowNavigator, Value);
end;

initialization
  _DMRegistry := nil;

end.
