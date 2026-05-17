unit ProjectDBModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TDatabaseModule = class(TDataModule)
  private
    { Private declarations }
  protected
    function GetDBConnected: boolean; virtual; abstract;
    procedure SetDBConnected(Value: boolean); virtual; abstract;
  public
    { Public declarations }
    property DBConnected: boolean read GetDBConnected write SetDBConnected; 
  end;

implementation

{$R *.DFM}

end.
