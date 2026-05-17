unit fMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uDMApp, AdvOfficeHint, AdvHintInfo, AdvStyleIF;

type
  TfmMainForm = class(TForm)
    AdvOfficeHint1: TAdvOfficeHint;
    procedure FormCreate(Sender: TObject);
  private
    procedure WMSyscommand(Var msg: TWmSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitAll;
  end;

var
  fmMainForm: TfmMainForm;

implementation

{$R *.dfm}

procedure TfmMainForm.InitAll;
begin
  GlobalDMApp.Init;
end;

constructor TfmMainForm.Create(AOwner: TComponent);
begin
  inherited;
  TDMApplication.Create(Application); // set GlobalDMApp
//  Application.ModalPopupMode := pmAuto;
end;

destructor TfmMainForm.Destroy;
begin
  GlobalDMApp.Free;
  inherited;
end;

procedure TfmMainForm.FormCreate(Sender: TObject);
begin
  ShowWindow(Application.handle, SW_HIDE);
  SetWindowLong(Application.handle,
                 GWL_EXSTYLE,
                 GetWindowLong(application.handle, GWL_EXSTYLE)
                  and not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW);
end;

procedure TfmMainForm.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.cmdtype and $FFF0) of
    SC_MINIMIZE:
      begin
        ShowWindow(handle, SW_MINIMIZE);
        msg.result := 0;
      end;
    SC_RESTORE:
      begin
        ShowWindow(handle, SW_RESTORE);
        msg.result := 0;
      end;
  else
    inherited;
  end;
end;

end.
