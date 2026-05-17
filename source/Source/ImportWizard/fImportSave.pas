unit fImportSave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrImportSave = class(TFrame)
    Panel1: TPanel;
    Shader1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    cbSave: TCheckBox;
    GroupBox1: TGroupBox;
    lbName: TLabel;
    edName: TEdit;
    procedure cbSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uControlUtils;

{$R *.dfm}

procedure TfrImportSave.cbSaveClick(Sender: TObject);
begin
  EnableControl(edName, cbSave.Checked);
  lbName.Enabled := cbSave.Checked;
  //cbSavePassword.Enabled := cbSave.Checked;
end;

end.
