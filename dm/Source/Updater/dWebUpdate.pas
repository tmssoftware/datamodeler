unit dWebUpdate;

interface

uses
  Messages, SysUtils, Classes, ImgList, Controls, ExtCtrls, uDMTrayIcon,
  System.ImageList;


type
  TdmWebUpdate = class(TDataModule)
    ImageList1: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TDMTrayIcon;
  public
    { Public declarations }
    property TrayIcon: TDMTrayIcon read FTrayIcon;
  end;

implementation

{$R *.dfm}

procedure TdmWebUpdate.DataModuleCreate(Sender: TObject);
begin
  FTrayIcon := TDMTrayIcon.Create(Self);
end;

end.
