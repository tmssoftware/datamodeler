unit uConfigFrameManager;

{$I ../../dm.inc}

interface

// --------------------------------------------------------------------------------------------
// Manager class for configuration frames for connecting to the different database types
// supported by the system.
// --------------------------------------------------------------------------------------------
// How to add a new database type:
// 1) in uDB, add the type to TDBType
// 2) compose the connection configuration frame for the database
// 3) add the unit name of the new frame to the uses clause of this unit
// 4) implement in dbconnection the way to translate the connection string
// --------------------------------------------------------------------------------------------

uses
  SysUtils, Forms, Controls,
  dgDBTypes, dgConsts, uDatabaseConfigFrames;

type
  TFrameClass = class of TFrame;

  TConfigFrameManager = class
  private
    FDBType : TDatabaseType;
    FFrame  : TFrame;
    procedure CreateDBFrame;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DestroyFrame;
    procedure AllocDBFrame(ADBType: TDatabaseType; AConnectionStr: string);
    procedure SetFrameParent(AParent: TWinControl);
    function GetConnectionString: String;
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
    property Frame: TFrame read FFrame;
    property CurrentDBType: TDatabaseType read FDBType;
  end;

implementation

uses
  fSQLServer2000Cfg, fSQLAzureCfg, fOracleCfg,
  fAbsoluteDBCfg,
  fNexusDBCfg,
  fFirebirdCfg,
  fMySQLCfg,
  fPostgreSQLCfg,
//  fAdvantageCfg,
  fElevateDBCfg,
  fSQLiteCfg,
  uDBProperties;

procedure TConfigFrameManager.AllocDBFrame(ADBType: TDatabaseType; AConnectionStr: string);
begin
  if FFrame <> nil then
    DestroyFrame;
  FDBType := ADBType;

  CreateDBFrame;

  (FFrame as IDatabaseConfigFrame).FrameInitialization(ADBType);
  (FFrame as IDatabaseConfigFrame).SetExistingConfiguration(AConnectionStr);
  FFrame.Align := alClient;
end;

procedure TConfigFrameManager.CheckSettings;
begin
  (FFrame as IDatabaseConfigFrame).CheckSettings;
end;

constructor TConfigFrameManager.Create;
begin
  FFrame := nil;
  FDBType := nil;
end;

procedure TConfigFrameManager.CreateDBFrame;
begin
  case TDBProperties.GetFixedDatabaseType(FDBType) of
    fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlServer2016:
      FFrame := TfrSqlServer2000Cfg.Create(nil);
    fdbOracle10g:
      FFrame := TfrOracleCfg.Create(nil);
    fdbFirebird2, fdbFirebird3, fdbInterbase2017:
      FFrame := TfrFirebirdCfg.Create(nil);

{$IFDEF ABSOLUTEDB}
    fdbAbsoluteDB:
      FFrame := TfrAbsoluteDBCfg.Create(nil);
{$ENDIF}
{$IFDEF NEXUSDB}
    fdbNexusDB3:
      FFrame := TfrNexusDBCfg.Create(nil);
{$ENDIF}
    fdbMySQL51, fdbMySQL57:
      FFrame := TfrMySQLCfg.Create(nil);
    fdbSqlAzure:
      FFrame := TfrSqlAzureCfg.Create(nil);
{$IFDEF ELEVATEDB}
    fdbElevateDB:
      FFrame := TfrElevateDBCfg.Create(nil);
{$ENDIF}
    fdbSQLite3:
      FFrame := TfrSQLiteCfg.Create(nil);
    fdbPostgreSQL9, fdbPostgreSQL11:
      FFrame := TfrPostgreSQLCfg.Create(nil);
    //advantage disabled: fdbAdvantage:
    //  FFrame := TfrAdvantageCfg.Create(nil);
  else
    raise EGUIException.Create('Database frame class not found.');
  end;
end;

destructor TConfigFrameManager.Destroy;
begin
  if FFrame <> nil then
    DestroyFrame;

  inherited;
end;

procedure TConfigFrameManager.DestroyFrame;
begin
  if Assigned(FFrame) then
  begin
    FFrame.Parent := nil;
    FFrame.Free;
    FFrame := nil;
  end;                                     
end;

function TConfigFrameManager.GetConnectionString: String;
begin
  if (FFrame <> nil) then
    result := (FFrame as IDatabaseConfigFrame).GetConnectionStrings
  else
    result := '';
end;

procedure TConfigFrameManager.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  if FFrame <> nil then
    (FFrame as IDatabaseConfigFrame).GetRecommendedSize(AWidth, AHeight)
  else
  begin
    AWidth := 0;
    AHeight := 0;
  end;
end;

function TConfigFrameManager.PasswordIsRequired: Boolean;
begin
  if FFrame <> nil then
    result := (FFrame as IDatabaseConfigFrame).PasswordIsRequired
  else
    result := false;
end;

procedure TConfigFrameManager.SetFrameParent(AParent: TWinControl);
begin
  if FFrame <>  nil then
    FFrame.Parent := AParent;
end;

end.

