unit uDatabaseConfigFrames;

{$I ../../dm.inc}

interface

uses
  Windows, Controls, StdCtrls, dgDBTypes;

type
  IDatabaseConfigFrame = interface
    ['{0AE744AF-F1E6-4042-80E1-EAE35CCFD53E}']
    function GetConnectionStrings:String;
    procedure SetExistingConfiguration(AConfig: String);
    procedure FrameInitialization(ADBType: TDatabaseType);
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
  end;

  TPasswordEdit = class(TEdit)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

implementation

{ TPasswordEdit }

procedure TPasswordEdit.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or ES_PASSWORD;
end;

end.


