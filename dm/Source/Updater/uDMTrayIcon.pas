unit uDMTrayIcon;

interface
uses
  Messages, Classes, ExtCtrls;

type
  TDMTrayIcon = class(TTrayIcon)
  private
    FOnBalloonClick: TNotifyEvent;
  protected
    procedure WindowProc(var Message: TMessage); override;
  public
    property OnBalloonClick: TNotifyEvent read FOnBalloonClick write FOnBalloonClick;
  end;


implementation

{ TDMTrayIcon }

const
  {$EXTERNALSYM NIN_BALLOONSHOW}
  NIN_BALLOONSHOW       = $0400 + 2;
  {$EXTERNALSYM NIN_BALLOONHIDE}
  NIN_BALLOONHIDE       = $0400 + 3;
  {$EXTERNALSYM NIN_BALLOONTIMEOUT}
  NIN_BALLOONTIMEOUT    = $0400 + 4;
  {$EXTERNALSYM NIN_BALLOONUSERCLICK}
  NIN_BALLOONUSERCLICK  = $0400 + 5;

procedure TDMTrayIcon.WindowProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_SYSTEM_TRAY_MESSAGE:
      case Message.lParam of
        NIN_BALLOONHIDE, NIN_BALLOONTIMEOUT:
          Visible := false;
        NIN_BALLOONUSERCLICK:
          begin
            Visible := false;
            if Assigned(FOnBalloonClick) then
              FOnBalloonClick(Self);
          end;
      end;
  end;
end;

end.
