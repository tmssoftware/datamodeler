unit fAddVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,  AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, uAppMetaData, UITypes;

type
  TfrmAddVersion = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    btOK: TBitBtn;
    minfo: TMemo;
    lbVersionNumber: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbTimestamp: TLabel;
    Label4: TLabel;
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FAMD: TAppMetaData;
    FTimeStamp: TDateTime;
  public
    property AMD: TAppMetaData read FAMD write FAMD;
  end;

implementation

uses
  uAppUtils;

{$R *.dfm}

procedure TfrmAddVersion.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmAddVersion.btOKClick(Sender: TObject);
begin
  FAMD.CloseLastVersion(mInfo.Text, FTimeStamp);
  MessageDlg(Format('Current version was added to version control. New version in use: %d',
    [FAMD.VersionControl.GetLastVersion.VersionID]), mtInformation, [mbOk],0);
  ModalResult := mrOk;
end;

procedure TfrmAddVersion.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FTimeStamp := Now;
end;

procedure TfrmAddVersion.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmAddVersion.FormShow(Sender: TObject);
begin
  // current version information
  if Assigned(FAMD) then
    with FAMD.VersionControl.GetLastVersion do
    begin
      lbVersionNumber.Caption := IntToStr(VersionID);
      lbTimeStamp.Caption := DateTimeToStr(FTimeStamp);
    end;
end;

end.

