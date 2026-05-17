unit dNexusDBModule;

{$I ../../dm.inc}

{$IFDEF NEXUSDB}

interface

uses
  SysUtils, Classes, DB, uSQLModule, uDatasetModule, nxdb, NexusProjectDBModule;

type
  TNexusModule = class(TDatasetModule)
  private
    FNexusQuery: TnxQuery;
  protected
    function _IntGetDataset: TDataset; override;
  public
    constructor Create(AProject: TdmNexusProjectDBModule);
      //NxDb: TnxDatabase);
    destructor Destroy; override;
    procedure Open(const SQL: string); override;
    procedure Execute(const SQL: string); override;
  end;

implementation

{ TNexusModule }

function TNexusModule._IntGetDataset: TDataset;
begin
  result := FNexusQuery;
end;

constructor TNexusModule.Create(AProject: TdmNexusProjectDBModule);
begin
  FNexusQuery := TnxQuery.Create(nil);
  FNexusQuery.Database := AProject.NexusDatabase;
end;

destructor TNexusModule.Destroy;
begin
  FNexusQuery.Free;
  inherited;
end;

procedure TNexusModule.Execute(const SQL: string);
begin
  FNexusQuery.Close;
  FNexusQuery.SQL.Text := SQL;
  FNexusQuery.ExecSQL;
end;

procedure TNexusModule.Open(const SQL: string);
begin
  FNexusQuery.Close;
  FNexusQuery.SQL.Text := SQL;
  FNexusQuery.Open;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

