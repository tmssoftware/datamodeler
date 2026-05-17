unit NexusProjectDBModule;

{$I ../../dm.inc}

{$IFDEF NEXUSDB}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ProjectDBModule,
  nxllComponent, nxllTransport, nxptBasePooledTransport,
  nxtwWinsockTransport, nxtmSharedMemoryTransport, nxtnNamedPipeTransport,
  nxreRemoteServerEngine, nxsdServerEngine,
  nxpvPlatformImplementation, nxsrServerEngine, nxdb, nxsrSqlEngineBase,
  nxsqlEngine, nxseAllEngines;

type
  TnxDMTransportType = (ndInternal, ndWinsock, ndNamedPipes, ndSharedMemory);

  TdmNexusProjectDBModule = class(TDatabaseModule)
  private
    FServer: TnxServerEngine;
    FRemoteServer: TnxRemoteServerEngine;
    FSession: TnxSession;
    FDatabase: TnxDatabase;
    FTransport: TnxBaseTransport;
    procedure UpdateTransport(ATransport: TnxDMTransportType);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDBConnected: boolean; override;
    procedure SetDBConnected(Value: boolean); override;
    procedure GetAliasNames(AItems: TStrings);
    procedure SetParameters(ATransport: TnxDMTransportType;
      AServerName, AAliasPath, AAliasName, AUserName, APassword: string);
    class function CreateNxTransport(ATransport: TnxDMTransportType; AOwner: TComponent): TnxBaseTransport;
    class function StrToNxTransport(AStr: string): TnxDMTransportType;
    property NexusDatabase: TnxDatabase read FDatabase;
  end;

implementation

{$R *.dfm}

{ TdmNexusProjectDBModule }

constructor TdmNexusProjectDBModule.Create(AOwner: TComponent);
begin
  inherited;
  FServer := TnxServerEngine.Create(Self);
  FServer.SqlEngine := TnxSQLEngine.Create(Self);
  FRemoteServer := TnxRemoteServerEngine.Create(Self);
  FSession := TnxSession.Create(Self);
  FDatabase := TnxDatabase.Create(Self);
  FDatabase.Session := FSession;
  FTransport := nil;
end;

class function TdmNexusProjectDBModule.CreateNxTransport(
  ATransport: TnxDMTransportType; AOwner: TComponent): TnxBaseTransport;
begin
  result := nil;
  case ATransport of
    ndWinsock:
      result := TnxWinsockTransport.Create(AOwner);
    ndNamedPipes:
      result := TnxNamedPipeTransport.Create(AOwner);
    ndSharedMemory:
      result := TnxSharedMemoryTransport.Create(AOwner);
  end;
end;

destructor TdmNexusProjectDBModule.Destroy;
begin
  if FSession.Active then
  begin
    FSession.CloseInactiveTables;
    FSession.CloseInactiveFolders;
  end;
  inherited;
end;

procedure TdmNexusProjectDBModule.GetAliasNames(AItems: TStrings);
begin
  FSession.Active := true;
  FSession.GetAliasNames(AItems);
end;

function TdmNexusProjectDBModule.GetDBConnected: boolean;
begin
  result := FDatabase.Active;
end;

procedure TdmNexusProjectDBModule.SetDBConnected(Value: boolean);
begin
  FDatabase.Active := Value;
end;

procedure TdmNexusProjectDBModule.SetParameters(ATransport: TnxDMTransportType;
  AServerName, AAliasPath, AAliasName, AUserName, APassword: string);
var
  P: integer;
  Port, e: integer;
begin
  UpdateTransport(ATransport);
  if ATransport = ndInternal then
  begin
    FSession.ServerEngine := FServer;
  end else
  begin
    FSession.ServerEngine := FRemoteServer;
    FRemoteServer.Transport := FTransport;
    if FTransport <> nil then
    begin
      FTransport.ServerName := AServerName;

      {If transport is TCP/IP, then check for server:port syntax to set port number propertly}
      if FTransport is TnxWinsockTransport then
      begin
        P := Pos(':', AServerName);
        if P > 1 then
        begin
          Val(Copy(AServerName, P + 1, MaxInt), Port, e);
          AServerName := Copy(AServerName, 1, P - 1);
          TnxWinsockTransport(FTransport).ServerName := AServerName;
          if (Port <> 0) and (e = 0) then
            TnxWinsockTransport(FTransport).Port := Port;
        end;
      end;
    end;
  end;
  if AAliasName <> '' then
    FDatabase.AliasName := AAliasName
  else
    FDatabase.AliasPath := AAliasPath;
  FSession.UserName := AUserName;
  FSession.Password := APassword;
end;

class function TdmNexusProjectDBModule.StrToNxTransport(
  AStr: string): TnxDMTransportType;
var
  ti, dummy: integer;
begin
  result := ndInternal;
  {avoid errors - just being very careful}
  try
    Val(AStr, ti, dummy);
    if (ti >= Ord(Low(TnxDMTransportType))) and (ti <= Ord(High(TnxDMTransportType))) then
      result := TnxDMTransportType(ti);
  except
    result := ndInternal;
  end;
end;

procedure TdmNexusProjectDBModule.UpdateTransport(ATransport: TnxDMTransportType);
begin
  if FTransport <> nil then
  begin
    FTransport.Free;
    FTransport := nil;
  end;
  FTransport := CreateNxTransport(ATransport, Self);
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

