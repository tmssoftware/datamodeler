unit FireDacProjectDBModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ProjectDBModule, Db, FireDac.Stan.Intf, FireDac.Stan.Option, FireDac.Stan.Error,
  FireDac.UI.Intf, FireDac.Phys.Intf, FireDac.Stan.Def, FireDac.Stan.Pool,
  FireDac.Comp.Client, FireDac.Phys.Oracle, FireDac.Phys.MySQL, FireDac.Phys.IB,
  FireDac.Phys.ODBCBase, FireDac.Phys.MSSQL, FireDac.Phys.SQLite, FireDac.Comp.UI,
  FireDac.Phys.Pg, FireDac.VCLUI.Wait, FireDac.Phys.FB;

type
  TdmFireDacProjectDBModule = class(TDatabaseModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    FConnection: TFDConnection;
    ADPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    ADPhysIBDriverLink1: TFDPhysIBDriverLink;
    ADPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    ADPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    ADGUIxWaitCursor1: TFDGUIxWaitCursor;
    ADPhysPgDriverLink1: TFDPhysPgDriverLink;
    ADPhysFBDriverLink1: TFDPhysFBDriverLink;
    function GetServer: string;
    procedure SetServer(const Value: string);
    function GetDatabase: string;
    function GetOSAuthent: boolean;
    function GetPassword: string;
    function GetPort: integer;
    function GetUserName: string;
    procedure SetDatabase(const Value: string);
    procedure SetOSAuthent(const Value: boolean);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: integer);
    procedure SetUserName(const Value: string);
    function GetDriverID: string;
    procedure SetDriverID(const Value: string);
    function GetCustom(AParam: string): string;
    procedure SetCustom(AParam: string; const Value: string);
    function GetVendorLib: string;
    procedure SetVendorLib(const Value: string);
    function GetODBCDriver: string;
    procedure SetODBCDriver(const Value: string);
  protected
    function GetDBConnected: boolean; override;
    procedure SetDBConnected(Value: boolean); override;
  public
    class var LastReport: TStrings;
    class constructor Create;
    class destructor Destroy;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Connection: TFDConnection read FConnection;
    property DriverID: string read GetDriverID write SetDriverID;
    property Database: string read GetDatabase write SetDatabase;
    property OSAuthent: boolean read GetOSAuthent write SetOSAuthent;
    property ODBCDriver: string read GetODBCDriver write SetODBCDriver;
    property Password: string read GetPassword write SetPassword;
    property Port: integer read GetPort write SetPort;
    property Server: string read GetServer write SetServer;
    property UserName: string read GetUserName write SetUserName;
    property Custom[AParam: string]: string read GetCustom write SetCustom;
    property VendorLib: string read GetVendorLib write SetVendorLib;
  end;

const
  ADPARAM_DATABASE = 'Database';
  ADPARAM_OSAUTHENT = 'OSAuthent';
  ADPARAM_PASSWORD = 'Password';
  ADPARAM_PORT = 'Port';
  ADPARAM_SERVER = 'Server';
  ADPARAM_USERNAME = 'User_Name';
  ADPARAM_OPENMODE = 'OpenMode';
  ADPARAM_CHARSET = 'CharacterSet';

implementation

{$R *.DFM}

destructor TdmFireDacProjectDBModule.Destroy;
begin
  inherited;
end;

function TdmFireDacProjectDBModule.GetCustom(AParam: string): string;
begin
  result := FConnection.Params.Values[AParam];
end;

function TdmFireDacProjectDBModule.GetDatabase: string;
begin
  result := FConnection.Params.Values[ADPARAM_DATABASE];
end;

function TdmFireDacProjectDBModule.GetDBConnected: boolean;
begin
  result := FConnection.Connected;
end;

function TdmFireDacProjectDBModule.GetDriverID: string;
begin
  result := FConnection.DriverName;
end;

function TdmFireDacProjectDBModule.GetODBCDriver: string;
begin
  Result := ADPhysMSSQLDriverLink1.ODBCDriver;
end;

function TdmFireDacProjectDBModule.GetOSAuthent: boolean;
begin
  result := FConnection.Params.Values[ADPARAM_OSAUTHENT] = 'Yes';
end;

function TdmFireDacProjectDBModule.GetPassword: string;
begin
  result := FConnection.Params.Values[ADPARAM_PASSWORD];
end;

function TdmFireDacProjectDBModule.GetPort: integer;
begin
  result := StrToIntDef(FConnection.Params.Values[ADPARAM_PORT], 0);
end;

function TdmFireDacProjectDBModule.GetServer: string;
begin
  result := FConnection.Params.Values[ADPARAM_SERVER];
end;

function TdmFireDacProjectDBModule.GetUserName: string;
begin
  result := FConnection.Params.Values[ADPARAM_USERNAME];
end;

function TdmFireDacProjectDBModule.GetVendorLib: string;
begin
  Result := ADPhysIBDriverLink1.VendorLib;
end;

procedure TdmFireDacProjectDBModule.SetCustom(AParam: string;
  const Value: string);
begin
  FConnection.Params.Values[AParam] := Value;
end;

procedure TdmFireDacProjectDBModule.SetDatabase(const Value: string);
begin
  FConnection.Params.Values[ADPARAM_DATABASE] := Value;
end;

procedure TdmFireDacProjectDBModule.SetDBConnected(Value: boolean);
begin
  if Value then
    FConnection.GetInfoReport(LastReport);
  FConnection.Connected := Value;
end;

procedure TdmFireDacProjectDBModule.SetDriverID(const Value: string);
begin
  FConnection.Params.Clear;
  FConnection.DriverName := Value;
end;

procedure TdmFireDacProjectDBModule.SetODBCDriver(const Value: string);
begin
  ADPhysMSSQLDriverLink1.ODBCDriver := Value;
end;

procedure TdmFireDacProjectDBModule.SetOSAuthent(const Value: boolean);
begin
  if Value then
    FConnection.Params.Values[ADPARAM_OSAUTHENT] := 'Yes'
  else
    FConnection.Params.Values[ADPARAM_OSAUTHENT] := 'No';
end;

procedure TdmFireDacProjectDBModule.SetPassword(const Value: string);
begin
  FConnection.Params.Values[ADPARAM_PASSWORD] := Value;
end;

procedure TdmFireDacProjectDBModule.SetPort(const Value: integer);
begin
  if Value > 0 then
    FConnection.Params.Values[ADPARAM_PORT] := IntToStr(Value);
end;

procedure TdmFireDacProjectDBModule.SetServer(const Value: string);
begin
  FConnection.Params.Values[ADPARAM_SERVER] := Value;
end;

procedure TdmFireDacProjectDBModule.SetUserName(const Value: string);
begin
  FConnection.Params.Values[ADPARAM_USERNAME] := Value;
end;

procedure TdmFireDacProjectDBModule.SetVendorLib(const Value: string);
begin
  ADPhysIBDriverLink1.VendorLib := Value;
  ADPhysFBDriverLink1.VendorLib := Value;
end;

constructor TdmFireDacProjectDBModule.Create(AOwner: TComponent);
begin
  inherited;
  ADPhysMSSQLDriverLink1 := TFDPhysMSSQLDriverLink.Create(Self);
//  ADPhysMSSQLDriverLink1.ODBCDriver := 'SQL Server';
  ADPhysFBDriverLink1 := TFDPhysFBDriverLink.Create(Self);
  ADPhysIBDriverLink1 := TFDPhysIBDriverLink.Create(Self);
  ADPhysMySQLDriverLink1 := TFDPhysMySQLDriverLink.Create(Self);
  ADPhysOracleDriverLink1 := TFDPhysOracleDriverLink.Create(Self);
  ADGUIxWaitCursor1 := TFDGUIxWaitCursor.Create(Self);
  ADPhysPgDriverLink1 := TFDPhysPgDriverLink.Create(Self);
end;

class constructor TdmFireDacProjectDBModule.Create;
begin
  LastReport := TStringList.Create;
end;

procedure TdmFireDacProjectDBModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FConnection := TFDConnection.Create(Self);
  FConnection.LoginPrompt := false;
end;

class destructor TdmFireDacProjectDBModule.Destroy;
begin
  LastReport.Free;
end;

end.

