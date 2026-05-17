unit fVersionDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,  ImgList, uAppMetaData, ActnList,
  ComCtrls, AdvDateTimePicker, uAppUtils, System.Actions, System.ImageList;

type
  TfrmVersionDetails = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    btClose: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    eddatetime: TAdvDateTimePicker;
    Label3: TLabel;
    minfo: TMemo;
    edfilename: TEdit;
    Label4: TLabel;
    lbversion: TLabel;
    lbfilesize: TLabel;
    iIcon: TImage;
    lbStatus: TLabel;
    iList: TImageList;
    btSave: TButton;
    btChangeFile: TSpeedButton;
    dlgOpen: TOpenDialog;
    ActionList1: TActionList;
    acSaveChanges: TAction;
    procedure acSaveChangesUpdate(Sender: TObject);
    procedure btChangeFileClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FVersion : TVersion;
    procedure SetVersionIcon;
    procedure UpdatefileSize(AFile: String);
  public
    procedure SetVersion(AVersion :TVersion);
  end;

implementation

uses
  uStrings;

{$R *.dfm}

{ TfrmVersionDetails }

procedure TfrmVersionDetails.acSaveChangesUpdate(Sender: TObject);
begin
  acSaveChanges.Enabled :=
    (FVersion.FileName <> edFileName.Text) or
    (FVersion.Information <> mInfo.Text) or
    (DateTimeToStr(FVersion.DateTime) <> DateTimeToStr(edDateTime.DateTime));
end;

procedure TfrmVersionDetails.btChangeFileClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    edFileName.Text := ExtractRelativePath(AddPathDelim(
      FVersion.VersionControl.AMD.GetVersionControlPath), dlgOpen.FileName);
    if lbFileSize.Visible then
      UpdateFileSize(AddPathDelim(FVersion.VersionControl.AMD.GetVersionControlPath) + edFileName.Text);
  end;
end;

procedure TfrmVersionDetails.btSaveClick(Sender: TObject);
begin
  FVersion.DateTime := edDateTime.DateTime;
  FVersion.FileName := edFileName.Text;
  FVersion.Information := mInfo.Text;
  ModalResult := mrOk;
end;

procedure TfrmVersionDetails.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfrmVersionDetails.SetVersion(AVersion: TVersion);
begin
  FVersion := AVersion;
  lbversion.Caption := Format('Version %d', [AVersion.VersionID]);
  eddatetime.DateTime := AVersion.DateTime;
  edfilename.Text   := AVersion.FileName;
  minfo.Text        := AVersion.Information;
  if lbFileSize.Visible then
    UpdateFileSize(AVersion.AbsoluteFileName);

  SetVersionIcon;
end;

procedure TfrmVersionDetails.SetVersionIcon;
begin
  if FVersion = FVersion.VersionControl.GetLastVersion then
  begin
    iList.GetBitmap(1, iIcon.Picture.Bitmap);
    lbStatus.Caption := 'Version is under construction';

    edDateTime.Color := clBtnFace;
    edDateTime.Enabled := False;
    mInfo.Color := clBtnFace;
    mInfo.ReadOnly := True;
    btChangeFile.Enabled := False;
  end
  else
  begin
    iList.GetBitmap(0, iIcon.Picture.Bitmap);
    lbStatus.Caption := 'Closed version';
    btChangeFile.Enabled := True;
  end;
end;

procedure TfrmVersionDetails.UpdatefileSize(AFile: String);
var ASize : String;
    arq : File of byte;
begin
  if FileExists(Afile) then
  begin
    ASize := '';
    lbfilesize.Font.Color := clBlack;
    try
      AssignFile(arq, AFile);
      Reset(arq);
      ASize := FloatToStrf(FileSize(arq)/1024, ffFixed, 16, 2)+'kb';
    finally
      Closefile(arq);
      lbfilesize.Caption := ASize;
    end;
  end;
end;

end.

