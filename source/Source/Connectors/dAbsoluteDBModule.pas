unit dAbsoluteDBModule;

{$I ../../dm.inc}

{$IFDEF ABSOLUTEDB}

interface

uses
  SysUtils, Classes, DB, uSQLModule, ABSMain, uDatasetModule;

type
  TAbsoluteDBModule = class(TDatasetModule)
  private
    FABSQuery: TABSQuery;
    FABSTable: TABSTable;
    function GetTable: TABSTable;
  protected
    function _IntGetDataset: TDataset; override;
  public
    constructor Create(DBName: string);
    destructor Destroy; override;
    procedure Open(const SQL: string); override;
    procedure Execute(const SQL: string); override;
    property Table: TABSTable read GetTable;
  end;

implementation

{ TAbsoluteDBModule }

function TAbsoluteDBModule._IntGetDataset: TDataset;
begin
  result := FABSQuery;
end;

constructor TAbsoluteDBModule.Create(DBName: string);
begin
  FABSQuery := TABSQuery.Create(nil);
  FABSTable := TABSTable.Create(nil);
  (Dataset as TABSQuery).DatabaseName := DBName;
  FABSTable.DatabaseName := DBName;
end;

destructor TAbsoluteDBModule.Destroy;
begin
  FABSQuery.Free;
  FABSTable.Free;
  inherited;
end;

procedure TAbsoluteDBModule.Execute(const SQL: string);
begin
  FABSQuery.Close;
  FABSQuery.SQL.Text := SQL;
  FABSQuery.ExecSQL;
end;

function TAbsoluteDBModule.GetTable: TABSTable;
begin
  result := FABSTable;
end;

procedure TAbsoluteDBModule.Open(const SQL: string);
begin
  FABSQuery.Close;
  FABSQuery.SQL.Text := SQL;
  FABSQuery.Open;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

