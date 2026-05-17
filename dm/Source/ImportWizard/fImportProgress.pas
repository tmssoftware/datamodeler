unit fImportProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, ExtCtrls, StdCtrls,  UITypes;

type
  TfrImportProgress = class(TFrame)
    Panel1: TPanel;
    Shader1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    pbProgress: TProgressBar;
    lbStatus: TLabel;
  private
    { Private declarations }
  public
    procedure EndProgress;
  end;

implementation

{$R *.dfm}

{ TfrImportadorProgress }

procedure TfrImportProgress.EndProgress;
begin
  lbStatus.Caption := 'Done.';
  lbStatus.Font.Style := lbStatus.Font.Style + [fsBold];
  //Label1.Caption :=
  Label2.Caption := '';
end;

end.
