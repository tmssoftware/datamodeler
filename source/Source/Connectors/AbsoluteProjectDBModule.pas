unit AbsoluteProjectDBModule;

{$I ../../dm.inc}

{$IFDEF ABSOLUTEDB}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ProjectDBModule, ABSMain;

type
  TdmAbsoluteProjectDBModule = class(TDatabaseModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    FABSDatabase: TABSDatabase;
  public
    function GetDBConnected: boolean; override;
    procedure SetDBConnected(Value: boolean); override;
    property Database: TABSDatabase read FABSDatabase;
  end;

implementation

{$R *.dfm}

{ TdmAbsoluteProjectDBModule }

procedure TdmAbsoluteProjectDBModule.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FABSDatabase := TABSDatabase.Create(Self);
  FABSDatabase.DatabaseName := '_AbsoluteDB_';
  FABSDatabase.Exclusive := False;
  FABSDatabase.MultiUser := False;
  FABSDatabase.SessionName := 'Default';
end;

function TdmAbsoluteProjectDBModule.GetDBConnected: boolean;
begin
  result := FABSDatabase.Connected;
end;

procedure TdmAbsoluteProjectDBModule.SetDBConnected(Value: boolean);
begin
  FABSDatabase.Connected := Value;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

