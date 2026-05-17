unit dElevateDBModule;

{$I ../../dm.inc}

{$IFDEF ELEVATEDB}

interface

uses
  SysUtils, Classes, DB, uSQLModule, uDatasetModule, edbcomps, ElevateProjectDBModule;

type
  TElevateDBModule = class(TDatasetModule)
  private
    FQuery: TEDBQuery;
  protected
    function _IntGetDataset: TDataset; override;
  public
    constructor Create(AProject: TdmElevateProjectDBModule);
    destructor Destroy; override;
    procedure Open(const SQL: string); override;
    procedure Execute(const SQL: string); override;
  end;

implementation

{ TElevateDBModule }

constructor TElevateDBModule.Create(AProject: TdmElevateProjectDBModule);
begin
  FQuery := TEDBQuery.Create(nil);
  FQuery.DatabaseName := AProject.ElevateDatabase.DatabaseName;
  FQuery.SessionName := AProject.ElevateDatabase.SessionName;
end;

destructor TElevateDBModule.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TElevateDBModule.Execute(const SQL: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := SQL;
  FQuery.ExecSQL;
end;

procedure TElevateDBModule.Open(const SQL: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := SQL;
  FQuery.Open;
end;

function TElevateDBModule._IntGetDataset: TDataset;
begin
  result := FQuery;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

