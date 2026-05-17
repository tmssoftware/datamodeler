unit uDatasetModule;

interface

uses
  DB, uSQLModule;

type
  TDatasetModule = class(TSQLModule)
  protected
    function _IntGetDataset: TDataset; virtual; abstract;
    function GetEOF: boolean; override;
  public
    function FieldAsString(const AFieldName: string): string; override;
    function FieldAsInteger(const AFieldName: string): integer; override;
    function FieldAsBoolean(const AFieldName: string): boolean; override;
    procedure Next; override;
    procedure Open(const SQL: string); override;
  public
    function Dataset: TDataset;
  end;

implementation

{ TDatasetModule }

function TDatasetModule.Dataset: TDataset;
begin
  Result := _IntGetDataset;
end;

function TDatasetModule.FieldAsBoolean(const AFieldName: string): boolean;
begin
  Result := Dataset.FieldByName(AFieldName).AsBoolean;
end;

function TDatasetModule.FieldAsInteger(const AFieldName: string): integer;
begin
  Result := Dataset.FieldByName(AFieldName).AsInteger;
end;

function TDatasetModule.FieldAsString(const AFieldName: string): string;
begin
  Result := Dataset.FieldByName(AFieldName).AsString;
end;

function TDatasetModule.GetEOF: boolean;
begin
  Result := Dataset.EOF;
end;

procedure TDatasetModule.Next;
begin
  Dataset.Next;
end;

procedure TDatasetModule.Open;
begin
  Dataset.Open;
end;

end.
