unit dFireDACModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, uSQLModule, FireDac.Stan.Intf, FireDac.Stan.Option, FireDac.Stan.Param,
  FireDac.Stan.Error, {FireDac.DatS.Manager, }FireDac.Phys.Intf, FireDac.DApt.Intf,
  FireDac.DApt, uDatasetModule,
  FireDac.Stan.Async, {FireDac.DApt.Manager, }FireDac.Comp.DataSet, FireDac.Comp.Client;

type
  TFireDacModule = class(TDatasetModule)
  private
    FFireDacDataset: TFDQuery;
  protected
    function _IntGetDataset: TDataset; override;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Open(const SQL: string); override;
    procedure Execute(const SQL: string); override;
    function MetaInfo: IFDPhysConnectionMetadata;
  end;

implementation

{TFireDacModule}

constructor TFireDacModule.Create(AConnection: TFDConnection);
begin
  FFireDacDataset := TFDQuery.Create(nil);
  (Dataset as TFDQuery).Connection := AConnection;
  FFireDacDataset.FetchOptions.Items := FFireDacDataset.FetchOptions.Items - [fiMeta];
end;

destructor TFireDacModule.Destroy;
begin
  FFireDacDataset.Free;
  inherited;
end;

procedure TFireDacModule.Execute(const SQL: string);
begin
  FFireDacDataset.Close;
  FFireDacDataset.SQL.Text := SQL;
  FFireDacDataset.OpenOrExecute;
end;

function TFireDacModule._IntGetDataset: TDataset;
begin
  result := FFireDacDataset;
end;

function TFireDacModule.MetaInfo: IFDPhysConnectionMetadata;
begin
  Result := FFireDacDataset.Connection.ConnectionMetaDataIntf;
end;

procedure TFireDacModule.Open(const SQL: string);
begin
  FFireDacDataset.Close;
  FFireDacDataset.SQL.Text := SQL;
  FFireDacDataset.OpenOrExecute;
end;

end.

