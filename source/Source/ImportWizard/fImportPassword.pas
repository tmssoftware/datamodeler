unit fImportPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrImportPassword = class(TFrame)
    Shader1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edUserName: TEdit;
    edPassword: TEdit;
    cbSavePassword: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
