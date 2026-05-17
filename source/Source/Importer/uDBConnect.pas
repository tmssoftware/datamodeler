unit uDBConnect;

{$I ../../dm.inc}

interface

uses
  SysUtils, Classes, ProjectDBModule, qryretrv, uSQLModule,
  dgDBStructurer, Dialogs, dgConsts, dgBase, dgDBTypes;

const
  { AbsoluteDB connection params }
  SDBO_AbsoluteDatabase = 'DATABASE';
  SDBO_AbsolutePassword = 'PASSWORD';

  { Firebird connection params }
  SDBO_FirebirdServer = 'FB_SERVER';
  SDBO_FirebirdDatabase = 'FB_DATABASE';
  SDBO_FirebirdUserName = 'FB_USERNAME';
  SDBO_FirebirdPassword = 'FB_PASSWORD';
  SDBO_FirebirdVendorLib = 'FB_VENDORLIB';
  SDBO_FirebirdProtocol = 'FB_PROTOCOL';
  SDBO_FirebirdProtocolItem_TCP = 'TCP/IP';
  SDBO_FirebirdProtocolItem_Local = 'Local';
  SDBO_FirebirdCharset = 'FB_CHARSET';

  { NexusDB connection params }
  SDBO_NexusServer = 'SERVER';
  SDBO_NexusTransport = 'TRANSPORT';
  SDBO_NexusAliasName = 'ALIAS NAME';
  SDBO_NexusAliasPath = 'ALIAS PATH';
  SDBO_NexusUserName = 'USER NAME';
  SDBO_NexusPassword = 'PASSWORD';

  { SQLite connection params }
  SDBO_SQLiteDatabase = 'SQLITE_DATABASE';
  SDBO_SQLiteCreateFile = 'SQLITE_CREATEFILE';

  { SQL server connection params }
  SDBO_SQLServerDatabaseName = 'DATABASE NAME';
  SDBO_SqlServerServerName = 'SERVER NAME';
  SDBO_SqlServerUserName = 'USER NAME';
  SDBO_SqlServerPassword = 'PASSWORD';
  SDBO_SqlServerIntegratedSecurity = 'INTEGRATED SECURITY';
  SDBO_SqlServerODBCDriver = 'ODBC DRIVER';

type
  TDBConnection = class
  private
    FEngineType: TDBEngineType;
    FDatabaseType: TDatabaseType;
    FDBModule: TDatabaseModule;
    FRetriever: TDataRetriever;
    FStructurer: TDBStructurer;
    FDBParams: TStrings;
    FExclusive: boolean;
    FLoginPrompt: boolean;
    function GetConnected: boolean;
    procedure SetConnected(Value: boolean);
    procedure SetDBEngineType(Value: TDBEngineType);
    procedure SetDatabaseType(Value: TDatabaseType);
    procedure UpdateDatabaseParams;
    procedure SetExclusive(const Value: boolean);
    procedure SetLoginPrompt(const Value: boolean);
    function CreateDBStructurer(EngineType: TDBEngineType;
      ADBType: TDatabaseType): TDBStructurer;
    function CreateDataRetriever(EngineType: TDBEngineType;
      DBModule: TDatabaseModule; ADBType: TDatabaseType): TDataRetriever;
    function CreateDatabaseModule(EngineType: TDBEngineType): TDatabaseModule;
    property DBEngineType: TDBEngineType read FEngineType write SetDBEngineType;
  public
    constructor Create(AParams: string);
    destructor Destroy; override;
    function GetNewSQLModule(AOwner: TComponent): TSQLModule;

    property TheParams: TStrings read FDBParams;
    property DatabaseModule: TDatabaseModule read FDBModule;
    property DataRetriever: TDataRetriever read FRetriever;
    property DBStructurer: TDBStructurer read FStructurer;
    property Connected: boolean read GetConnected write SetConnected;
    property Exclusive: boolean read FExclusive write SetExclusive;
    property LoginPrompt: boolean read FLoginPrompt write SetLoginPrompt;
    property DatabaseType: TDatabaseType read FDatabaseType
      write SetDatabaseType;
  end;

  TSQLModuleFactory = class(TInterfacedObject, ISQLModuleFactory)
  strict private
    FConnection: TDBConnection;
  public
    constructor Create(AConnection: TDBConnection);
    function NewSQLModule: TSQLModule;
  end;

function CreateDBConnection(ADBType: TDatabaseType; AConnectStr: String)
  : TDBConnection;
function CreateAndConnectDBConnection(ADBType: TDatabaseType;
  AConnectStr: String): TDBConnection;

implementation

uses
{$IFDEF EUREKALOG}
  EEvents, EException,
{$ENDIF}
  {$IFNDEF LIGHT_DM}
  dFireDacModule,
  FireDacProjectDBModule,
  sqretrv,
  oraretrv,
  sqlite_retrv,
  postgresql_retrv,
  {$IFDEF AURELIUS_DLL}sqlanywhere_retrv,{$ENDIF}

  fbretrv,
  AbsoluteRetrv,
  nexusretrv,
  AbsoluteProjectDBModule,
  NexusProjectDBModule,
  dAbsoluteDBModule,
  dNexusDBModule,
  myretrv,
  // advantageretrv,
  // AdvantageProjectDBModule,
  // dAdvantageDBModule,
  elevateretrv,
  ElevateProjectDBModule,
  dElevateDBModule,
{$ENDIF}
  uStrings, uDBProperties;

function TDBConnection.CreateDatabaseModule(EngineType: TDBEngineType)
  : TDatabaseModule;
begin
{$IFDEF LIGHT_DM}
  result := nil;
{$ELSE}
  case EngineType of
    etFireDac:
      result := TdmFireDacProjectDBModule.Create(nil);
  {$IFDEF ABSOLUTEDB}
    etAbsoluteDB:
      result := TdmAbsoluteProjectDBModule.Create(nil);
  {$ENDIF}
  {$IFDEF NEXUSDB}
    etNexusDB:
      result := TdmNexusProjectDBModule.Create(nil);
  {$ENDIF}
    // etAdvantage:
    // result := TdmAdvantageProjectDBModule.Create(nil);
  {$IFDEF ELEVATEDB}
    etElevateDB:
      result := TdmElevateProjectDBModule.Create(nil, FDBParams);
  {$ENDIF}
  else
    result := nil;
  end;
{$ENDIF}
end;

function CreateSQLModule(AOwner: TComponent; EngineType: TDBEngineType;
  DBModule: TDatabaseModule): TSQLModule;
begin
{$IFDEF LIGHT_DM}
  raise EGUIException.Create('Invalid EngineType on CreateSQLModule call');
{$ELSE}
  case EngineType of
    etFireDac:
      result := TFireDacModule.Create(TdmFireDacProjectDBModule(DBModule)
        .Connection);
  {$IFDEF ABSOLUTEDB}
    etAbsoluteDB:
      result := TAbsoluteDBModule.Create(TdmAbsoluteProjectDBModule(DBModule)
        .Database.DatabaseName);
  {$ENDIF}
  {$IFDEF NEXUSDB}
    etNexusDB:
      result := TNexusModule.Create(TdmNexusProjectDBModule(DBModule));
  {$ENDIF}
    // etAdvantage:
    // result := TAdvantageModule.CreateModule(AOwner, TdmAdvantageProjectDBModule(DBModule).Connection);
  {$IFDEF ELEVATEDB}
    etElevateDB:
      result := TElevateDBModule.Create(TdmElevateProjectDBModule(DBModule));
  {$ENDIF}
  else
    raise EGUIException.Create('Invalid EngineType on CreateSQLModule call');
  end;
{$ENDIF}
end;

procedure SetDatabaseParamsEx(AConnection: TDBConnection;
  EngineType: TDBEngineType; DBType: TDatabaseType; DBModule: TDatabaseModule;
  AParams: TStrings; AExclusive: boolean; ALoginPrompt: boolean);

  function GetDBParamValue(const AParam: string): string;
  begin
    result := AParams.Values[AParam];
  end;

begin
{$IFNDEF LIGHT_DM}
  with DBModule do
  begin
    case EngineType of
      etFireDac:
        with TdmFireDacProjectDBModule(DBModule) do
        begin
          case TDBProperties.GetFixedDatabaseType(DBType) of
            fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlServer2016:
              begin
                DriverID := 'MSSQL';
                Server := GetDBParamValue(SDBO_SqlServerServerName);
                Database := GetDBParamValue(SDBO_SQLServerDatabaseName);
                UserName := GetDBParamValue(SDBO_SqlServerUserName);
                Password := UndoTheStr(GetDBParamValue(SDBO_SqlServerPassword));
                OSAuthent :=
                  GetDBParamValue(SDBO_SqlServerIntegratedSecurity) = 'TRUE';
                ODBCDriver := GetDBParamValue(SDBO_SqlServerODBCDriver);
              end;
            fdbSqlAzure:
              begin
                DriverID := 'MSSQL';
                Server := Format('tcp:%s.database.windows.net',
                  [GetDBParamValue(SDBO_SqlServerServerName)]);
                Database := GetDBParamValue(SDBO_SQLServerDatabaseName);
                UserName :=
                  Format('%s@%s', [GetDBParamValue(SDBO_SqlServerUserName),
                  GetDBParamValue(SDBO_SqlServerServerName)]);
                Password := UndoTheStr(GetDBParamValue(SDBO_SqlServerPassword));
              end;
            fdbOracle10g:
              begin
                DriverID := 'Ora';
                Database := GetDBParamValue('SERVER NAME');
                UserName := GetDBParamValue('USER NAME');
                Password := UndoTheStr(GetDBParamValue('PASSWORD'));
              end;
            fdbFirebird2, fdbFirebird3, fdbInterbase2017:
              begin
                DriverID := 'FB';
                if SameText(VendorLib, 'gds32.dll') or
                  (TDBProperties.GetFixedDatabaseType(DBType) = fdbInterbase2017) then
                  DriverID := 'IB';

                if GetDBParamValue(SDBO_FirebirdServer) <> '' then
                  Database := GetDBParamValue(SDBO_FirebirdServer) + ':' +
                    GetDBParamValue(SDBO_FirebirdDatabase)
                else
                  Database := GetDBParamValue(SDBO_FirebirdDatabase);
                UserName := GetDBParamValue(SDBO_FirebirdUserName);
                Password := UndoTheStr(GetDBParamValue(SDBO_FirebirdPassword));
                VendorLib := GetDBParamValue(SDBO_FirebirdVendorLib);

                if GetDBParamValue(SDBO_FirebirdCharset) = '' then
                  Custom[ADPARAM_CHARSET] := 'UTF8'
                else
                  Custom[ADPARAM_CHARSET] :=
                    GetDBParamValue(SDBO_FirebirdCharset)
              end;
            fdbMySQL51, fdbMySQL57:
              begin
                DriverID := 'MySQL';
                Server := GetDBParamValue('SERVER NAME');
                Port := StrToIntDef(GetDBParamValue('SERVER PORT'), 0);
                Database := GetDBParamValue('DATABASE');
                UserName := GetDBParamValue('USER NAME');
                Password := UndoTheStr(GetDBParamValue('PASSWORD'));
              end;
            fdbSQLite3:
              begin
                DriverID := 'SQLite';
                Database := GetDBParamValue(SDBO_SQLiteDatabase);
                if SameText(GetDBParamValue(SDBO_SQLiteCreateFile), 'FALSE')
                then
                  Custom[ADPARAM_OPENMODE] := 'ReadWrite'
                else
                  Custom[ADPARAM_OPENMODE] := 'CreateUTF16'
              end;
            fdbPostgreSQL9, fdbPostgreSQL11:
              begin
                DriverID := 'Pg';
                Server := GetDBParamValue('SERVER NAME');
                Port := StrToIntDef(GetDBParamValue('SERVER PORT'), 0);
                Database := GetDBParamValue('DATABASE');
                UserName := GetDBParamValue('USER NAME');
                Password := UndoTheStr(GetDBParamValue('PASSWORD'));
              end;
          end;
        end;
  {$IFDEF ABSOLUTEDB}
      etAbsoluteDB:
        with TdmAbsoluteProjectDBModule(DBModule) do
        begin
          Database.DatabaseFileName := GetDBParamValue(SDBO_AbsoluteDatabase);
          Database.Password :=
            UndoTheStr(GetDBParamValue(SDBO_AbsolutePassword));
        end;
  {$ENDIF}
  {$IFDEF NEXUSDB}
      etNexusDB:
        with TdmNexusProjectDBModule(DBModule) do
        begin
          SetParameters(StrToNxTransport(GetDBParamValue(SDBO_NexusTransport)),
            GetDBParamValue(SDBO_NexusServer),
            GetDBParamValue(SDBO_NexusAliasPath),
            GetDBParamValue(SDBO_NexusAliasName),
            GetDBParamValue(SDBO_NexusUserName),
            UndoTheStr(GetDBParamValue(SDBO_NexusPassword)));
        end;
  {$ENDIF}
      // etAdvantage:
      // with TdmAdvantageProjectDBModule(DBModule) do
      // begin
      // Connection.ConnectPath := GetDBParamValue('DATABASE');
      // Connection.UserName := GetDBParamValue(vConnectionStr_UserNameValue);
      // Connection.Password := UndoTheStr(GetDBParamValue(vConnectionStr_PasswordValue));
      // end;
      etElevateDB:
        ; // Do nothing because parameters are already set in constructor
      // with TdmElevateProjectDBModule(DBModule) do
      // begin
      // SetParameters(AParams);
      // end;
    end;
  end;
{$ENDIF}
end;

{ TDBConnection }

constructor TDBConnection.Create(AParams: string);
begin
  FDBParams := TStringList.Create;
  FDBParams.Text := AParams;
  UpdateDatabaseParams;
  FEngineType := etNone;
  FDatabaseType := nil;
end;

function CreateDBConnection(ADBType: TDatabaseType; AConnectStr: String)
  : TDBConnection;
begin
  result := TDBConnection.Create(AConnectStr);
  try
    result.DatabaseType := ADBType;
    result.DBEngineType := ADBType.EngineType;
  except
    result.Free;
    raise;
  end;
end;

function CreateAndConnectDBConnection(ADBType: TDatabaseType;
  AConnectStr: String): TDBConnection;
begin
  result := CreateDBConnection(ADBType, AConnectStr);
  with result do
  begin
    try
      Connected := true;
    except
      on e: Exception do
      begin
        result.Free;
        raise EGUIException.Create(e.Message);
      end;
    end;
  end;
end;

procedure TDBConnection.SetDBEngineType(Value: TDBEngineType);
begin
  Connected := false;
  if Assigned(FDBModule) then
    FDBModule.Free;
  if Assigned(FRetriever) then
    FRetriever.Free;
  if Assigned(FStructurer) then
    FStructurer.Free;
  FEngineType := Value;
  FDBModule := CreateDatabaseModule(FEngineType);
  if Assigned(FDatabaseType) then
  begin
    FRetriever := CreateDataRetriever(FEngineType, FDBModule, FDatabaseType);
    FStructurer := CreateDBStructurer(FEngineType, FDatabaseType);
  end;
  UpdateDatabaseParams;
end;

destructor TDBConnection.Destroy;
begin
  Connected := false;
  if Assigned(FRetriever) then
    FRetriever.Free;
  if Assigned(FDBModule) then
    FDBModule.Free;
  if Assigned(FStructurer) then
    FStructurer.Free;
  FDBParams.Free;
  inherited;
end;

function TDBConnection.GetNewSQLModule(AOwner: TComponent): TSQLModule;
begin
  if Assigned(FDBModule) then
    result := CreateSQLModule(AOwner, FEngineType, FDBModule)
  else
    result := nil;
end;

function TDBConnection.GetConnected: boolean;
begin
  result := false;
  if Assigned(FDBModule) then
    result := FDBModule.DBConnected;
end;

procedure TDBConnection.SetConnected(Value: boolean);
begin
  if Assigned(FDBModule) then
  begin
    if not FDBModule.DBConnected and Value then
      UpdateDatabaseParams;
    FDBModule.DBConnected := Value;
  end;
end;

procedure TDBConnection.UpdateDatabaseParams;
begin
  if Assigned(FDBModule) then
  begin
    Connected := false;
    SetDatabaseParamsEx(Self, FEngineType, FDatabaseType, FDBModule, FDBParams,
      FExclusive, FLoginPrompt);
  end;
end;

procedure TDBConnection.SetDatabaseType(Value: TDatabaseType);
begin
  if Assigned(FRetriever) then
    FRetriever.Free;
  if Assigned(FStructurer) then
    FStructurer.Free;
  FDatabaseType := Value;
  if FEngineType <> etNone then
  begin
    FRetriever := CreateDataRetriever(FEngineType, FDBModule, FDatabaseType);
    FStructurer := CreateDBStructurer(FEngineType, FDatabaseType);
  end;
end;

function TDBConnection.CreateDBStructurer(EngineType: TDBEngineType;
  ADBType: TDatabaseType): TDBStructurer;
begin
  result := TDBStructurer.Create(ADBType, EngineType);
end;

procedure TDBConnection.SetExclusive(const Value: boolean);
begin
  FExclusive := Value;
end;

procedure TDBConnection.SetLoginPrompt(const Value: boolean);
begin
  FLoginPrompt := Value;
end;

function TDBConnection.CreateDataRetriever(EngineType: TDBEngineType;
  DBModule: TDatabaseModule; ADBType: TDatabaseType): TDataRetriever;
var
  Factory: ISQLModuleFactory;
begin
  Factory := TSQLModuleFactory.Create(Self);
  result := nil;
{$IFNDEF LIGHT_DM}
  case TDBProperties.GetFixedDatabaseType(ADBType) of
    fdbSqlServer2000:
      result := TSqlServer2000DataRetriever.Create(Factory);
    fdbSqlServer2005:
      result := TSqlServer2005DataRetriever.Create(Factory);
    fdbSqlServer2008:
      result := TSqlServer2008DataRetriever.Create(Factory);
    fdbSqlServer2016:
      result := TSqlServer2016DataRetriever.Create(Factory);
    fdbOracle10g:
      result := TOracle10gDataRetriever.Create(Factory, TheParams.Values['SCHEMA']);
    fdbFirebird2:
      result := TFirebird2DataRetriever.Create(Factory);
    fdbFirebird3:
      result := TFirebird3DataRetriever.Create(Factory);
    fdbInterbase2017:
      result := TInterbase2017DataRetriever.Create(Factory);
  {$IFDEF ABSOLUTEDB}
    fdbAbsoluteDB:
      result := TAbsoluteDataRetriever.Create(Factory);
  {$ENDIF}
  {$IFDEF NEXUSDB}
    fdbNexusDB3:
      result := TNexusDBDataRetriever.Create(Factory);
  {$ENDIF}
    fdbMySQL51:
      result := TMySQL51DataRetriever.Create(Factory, TheParams.Values['DATABASE']);
    fdbMySQL57:
      result := TMySQL57DataRetriever.Create(Factory, TheParams.Values['DATABASE']);
    fdbSqlAzure:
      result := TSqlAzureDataRetriever.Create(Factory);
  {$IFDEF ELEVATEDB}
    fdbElevateDB:
      result := TElevateDBDataRetriever.Create(Factory);
  {$ENDIF}
    fdbSQLite3:
      result := TSQLiteDataRetriever.Create(Factory);
    fdbPostgreSQL9:
      result := TPostgreSQL9DataRetriever.Create(Factory, TheParams.Values['SCHEMA']);
    fdbPostgreSQL11:
      result := TPostgreSQL11DataRetriever.Create(Factory, TheParams.Values['SCHEMA']);
    {$IFDEF AURELIUS_DLL}
    fdbSqlAnywhere:
      result := TSqlAnywhereDataRetriever.Create(Factory);
    {$ENDIF}
    // advantage disabled: fdbAdvantage:
    // result := TAdvantageDataRetriever.Create(Self);
  end;
{$ENDIF}
  if result = nil then
    raise EGUIException.Create
      ('Cannot create data retriever for specified database.');
end;

// function TDBConnection.IsSqlEmpty(const ASql: String): Boolean;
// begin
// With GetNewSQLModule(nil) do
// try
// SQL:=ASQL;
// Open;
// Result := Dataset.isEmpty;
// finally
// Free;
// end;
// end;

{$IFDEF EUREKALOG}
procedure EurekaLogCustomData(const ACustom: Pointer;
  AExceptionInfo: TEurekaExceptionInfo; ALogBuilder: TObject;
  ADataFields: TStrings; var ACallNextHandler: boolean);
var
  I: Integer;
  SL: TStrings;
begin
  SL := TdmFireDacProjectDBModule.LastReport;
  if SL = nil then
    Exit;
  for I := 0 to SL.Count - 1 do
    ADataFields.Values[IntToStr(I + 1)] := SL[I];
end;
{$ENDIF}

{ TSQLModuleFactory }

constructor TSQLModuleFactory.Create(AConnection: TDBConnection);
begin
  FConnection := AConnection;
end;

function TSQLModuleFactory.NewSQLModule: TSQLModule;
begin
  Result := FConnection.GetNewSQLModule(nil);
end;

initialization

{$IFDEF EUREKALOG}
RegisterEventCustomDataRequest(nil, EurekaLogCustomData);
{$ENDIF}

finalization

{$IFDEF EUREKALOG}
UnRegisterEventCustomDataRequest(nil, EurekaLogCustomData); // optional
{$ENDIF}

end.
