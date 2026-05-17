unit ElevateProjectDBModule;

{$I ../../dm.inc}

{$IFDEF ELEVATEDB}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ProjectDBModule, DB, edbcomps;

type
  TdmElevateProjectDBModule = class(TDatabaseModule)
  private
    FSession: TEDBSession;
    FDatabase: TEDBDatabase;
    FEngine: TEDBEngine;
    procedure SetParameters(AParams: TStrings);
  public
    constructor Create(AOwner: TComponent; AParams: TStrings); reintroduce;
    destructor Destroy; override;
    function GetDBConnected: boolean; override;
    procedure SetDBConnected(Value: boolean); override;
    procedure GetDatabaseNames(AList: TStrings);
    property ElevateDatabase: TEDBDatabase read FDatabase;
  end;

implementation

uses
  uStrings;

{$R *.dfm}

{ TdmElevateProjectDBModule }

constructor TdmElevateProjectDBModule.Create(AOwner: TComponent; AParams: TStrings);
begin
  inherited Create(AOwner);
  FSession := TEDBSession.Create(nil);
  FSession.AutoSessionName := true;
  FDatabase := TEDBDatabase.Create(nil);
  FDatabase.SessionName := FSession.SessionName;
  FDatabase.DatabaseName := 'DMElevateDatabase' + IntToStr(GetTickCount);
  FEngine := TEDBEngine.Create(nil);
  SetParameters(AParams);
end;

destructor TdmElevateProjectDBModule.Destroy;
begin
  FEngine.Free;
  FDatabase.Free;
  FSession.Free;
  inherited;
end;

procedure TdmElevateProjectDBModule.GetDatabaseNames(AList: TStrings);
begin
  FSession.Connected := true;
  FSession.GetDatabases(AList);
end;

function TdmElevateProjectDBModule.GetDBConnected: boolean;
begin
  Result := FSession.Connected;
end;

procedure TdmElevateProjectDBModule.SetDBConnected(Value: boolean);
begin
  FSession.Connected := Value;
  FDatabase.Connected := Value;
  FEngine.Active := Value and (FSession.SessionType = stLocal);
end;

procedure TdmElevateProjectDBModule.SetParameters(AParams: TStrings);

  function CheckValue(const Name: string; var Value: string): boolean;
  begin
    Result := AParams.IndexOfName(Name) >= 0;
    if Result then
      Value := AParams.Values[Name];
  end;

var
  AServer: string;
  AConfigPath: string;
  APort: integer;
  AUserName: string;
  APassword: string;
  ADatabase: string;
  Value: string;
begin
  if SameText(AParams.Values['SERVER TYPE'], 'UNICODE') then
    FSession.CharacterSet := csUnicode
  else
    FSession.CharacterSet := csAnsi;

  AConfigPath := AParams.Values['CONFIG PATH'];
  AServer := AParams.Values['SERVER NAME'];
  APort := StrToIntDef(AParams.Values['SERVER PORT'], 0);
  AUserName := AParams.Values['USER NAME'];
  APassword := UndoTheStr(AParams.Values['PASSWORD']);
  ADatabase := AParams.Values['DATABASE'];

  if AServer > '' then
  begin
    FSession.SessionType := stRemote;
    {$IFDEF ELEVATEANSI}
    FSession.RemoteAddress := AnsiString(AServer);
    FSession.RemoteHost := AnsiString(AServer);
    {$ELSE}
    FSession.RemoteAddress := AServer;
    FSession.RemoteHost := AServer;
    {$ENDIF}
    FSession.RemotePort := APort;
  end
  else
  begin
    FSession.SessionType := stLocal;
    FEngine.Active := false;
    {$IFDEF ELEVATEANSI}
    FEngine.ConfigPath := AnsiString(AConfigPath);
    {$ELSE}
    FEngine.ConfigPath := AConfigPath;
    {$ENDIF}
  end;
  {$IFDEF ELEVATEANSI}
  FSession.LoginUser := AnsiString(AUserName);
  FSession.LoginPassword := AnsiString(APassword);
  FDatabase.Database := AnsiString(ADatabase);
  {$ELSE}
  FSession.LoginUser := AUserName;
  FSession.LoginPassword := APassword;
  FDatabase.Database := ADatabase;
  {$ENDIF}

  if SameText(AParams.Values['ADVANCED'], 'TRUE') then
  begin
    if FSession.SessionType = stLocal then
    begin
      FEngine.UseLocalSessionEngineSettings := true;

      if CheckValue('BackupExtension', Value) then
        FSession.LocalBackupExtension := Value;

      if CheckValue('CatalogName', Value) then
        FSession.LocalCatalogName := Value;

      if CheckValue('CatalogExtension', Value) then
        FSession.LocalCatalogExtension := Value;

      if CheckValue('ConfigExtension', Value) then
        FSession.LocalConfigExtension := Value;

      if CheckValue('ConfigName', Value) then
        FSession.LocalConfigName := Value;

      if CheckValue('EncryptionPassword', Value) then
        FSession.LocalEncryptionPassword := Value;

      if CheckValue('LockExtension', Value) then
        FSession.LocalLockExtension := Value;

      if CheckValue('LogExtension', Value) then
        FSession.LocalLogExtension := Value;

      if CheckValue('Signature', Value) then
        FSession.LocalSignature := Value;

      if CheckValue('TableBlobExtension', Value) then
        FSession.LocalTableBlobExtension := Value;

      if CheckValue('TableExtension', Value) then
        FSession.LocalTableExtension := Value;

      if CheckValue('TableIndexExtension', Value) then
        FSession.LocalTableIndexExtension := Value;
    end else
    begin
      if CheckValue('RemoteEncryption', Value) then
        FSession.RemoteEncryption := SameText(Value, 'True');

      if CheckValue('EncryptionPassword', Value) then
        FSession.RemoteEncryptionPassword := Value;

      if CheckValue('Signature', Value) then
        FSession.RemoteSignature := Value;
    end;
  end;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

