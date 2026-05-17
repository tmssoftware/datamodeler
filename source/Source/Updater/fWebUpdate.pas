unit fWebUpdate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, AdvProgressBar, WUpdate;

type
  TCheckOnStartToggleEvent = procedure(Sender: TObject; ACheck: boolean) of object;

  TfmWebUpdateForm = class(TForm)
    ImageComputer: TImage;
    ImageWorld: TImage;
    Animate1: TAnimate;
    AdvProgressBar1: TAdvProgressBar;
    Label1: TLabel;
    ImageOk: TImage;
    Label2: TLabel;
    lbInfo: TLabel;
    Panel1: TPanel;
    btUpdateLater: TButton;
    btAction: TButton;
    CheckBox1: TCheckBox;
    ImageError: TImage;
    procedure btActionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btUpdateLaterClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FWebUpdate: TWebUpdate;
    FUpdating: boolean;
    FCancelled: boolean;
    FRestart: boolean;
    FOnBeforeRestart: TNotifyEvent;
    FOnCheckOnStartToggle: TCheckOnStartToggleEvent;
    FUpdatingCheckBox: boolean;

    FDialogMode: boolean;
    procedure WMClose(var Message: TWMClose); message WM_CLOSE;
    procedure SetWebUpdate(const Value: TWebUpdate);
    procedure WebUpdateCancel(Sender: TObject; var Cancel: Boolean);
    procedure WebUpdateFileProgress(Sender: TObject; filename: String; pos,
      size: Integer);
    procedure UpdateDone;
    procedure WebUpdateStatus(Sender: TObject; StatusStr: string;
      StatusCode, ErrCode: Integer);
    procedure WebUpdateRestart(Sender: TObject; var Allow: Boolean);
    function GetCheckOnStart: boolean;
    procedure SetCheckOnStart(const Value: boolean);
    { Private declarations }
  public
    destructor Destroy; override;
    procedure ShowUpdateOk;
    procedure ShowUpdateError(Msg: string);
    property WebUpdate: TWebUpdate read FWebUpdate write SetWebUpdate;
    property OnBeforeRestart: TNotifyEvent read FOnBeforeRestart write FOnBeforeRestart;
    property OnCheckOnStartToggle: TCheckOnStartToggleEvent read FOnCheckOnStartToggle write FOnCheckOnStartToggle;
    property CheckOnStart: boolean read GetCheckOnStart write SetCheckOnStart;
  end;

var
  fmWebUpdateForm: TfmWebUpdateForm;

implementation

{$R *.DFM}
{$R DMWebUpdate.RES}

procedure TfmWebUpdateForm.btActionClick(Sender: TObject);
begin
  if FDialogMode then
  begin
    Close;
    Exit;
  end;

  if FRestart then
  begin
    if Assigned(FOnBeforeRestart) then
      FOnBeforeRestart(Self);
    FWebUpdate.DoRestart;
    Close;
    Exit;
  end;

  if not FUpdating then
  begin

    FUpdating := true;
    try
      btUpdateLater.Visible := false;
      lbInfo.Visible := false;
      btAction.Caption := '&Cancel';
      Animate1.Visible := true;
      ImageWorld.Visible := true;
      Animate1.Active := true;
      AdvProgressBar1.Visible := true;
      Label1.Caption := Format('Updating to version %s. Downloading files...', [FWebUpdate.NewVersionInfo]);
      Application.ProcessMessages;
      FWebUpdate.DoUpdate;
      Label2.Caption := '';
      if FWebUpdate.Cancelled then
      begin
        Animate1.Active := false;
        Animate1.Visible := false;
        ImageWorld.Visible := false;
        AdvProgressBar1.Visible := false;
        Close;
        ShowMessage('Update process aborted.');
      end else
      if FWebUpdate.AppNeedsRestart then
      begin
        FRestart := true;

        ImageOk.Visible := true;
        AdvProgressBar1.Visible := false;
        Animate1.Active := false;
        Animate1.Visible := false;
        ImageWorld.Visible := false;
        ImageComputer.Visible := false;

        Label1.Caption := 'Done. Click "Restart Data Modeler" button to complete update process.';
        btAction.Caption := '&Restart Data Modeler';
        btAction.Left := btAction.Left - 150 + btAction.Width;
        btAction.Width := 150;
      end;
    finally
      FUpdating := false;
    end;
  end else
  begin
    FCancelled := true;
  end;
end;

procedure TfmWebUpdateForm.WebUpdateCancel(Sender: TObject; var Cancel: Boolean);
begin
  Cancel := FCancelled;
end;

procedure TfmWebUpdateForm.WebUpdateFileProgress(Sender: TObject; filename: String;
  pos, size: Integer);
var
  TotalFiles: integer;
  CurrentFile: integer;
begin
  TotalFiles := WebUpdate.FileList.Count;
  CurrentFile := WebUpdate.FileList.ActiveItem;

  if AdvProgressBar1.Max <> TotalFiles * 100 then
    AdvProgressBar1.Max := TotalFiles * 100;
  AdvProgressBar1.Position := CurrentFile * 100 + Round((pos / size) * 100);

 { Label2.Caption := Format('Retrieving file %d/%d (%sMB of %sMB downloaded)',
    [CurrentFile + 1, TotalFiles,
     FormatFloat('0.00', pos/1024/1024), FormatFloat('0.00', size/1024/1024)]);}
  Application.ProcessMessages;
end;

procedure TfmWebUpdateForm.WebUpdateStatus(Sender:TObject;StatusStr:string; StatusCode,ErrCode:Integer);
begin
  if StatusCode = WebUpdateNotFound then
    FWebUpdate.Cancel;
end;

procedure TfmWebUpdateForm.WebUpdateRestart(Sender:TObject; var Allow:Boolean);
begin
  Allow := FRestart;
end;

procedure TfmWebUpdateForm.SetWebUpdate(const Value: TWebUpdate);
begin
  Label2.Caption := '';
  ImageOk.Visible := false;
  AdvProgressBar1.Visible := false;
  Animate1.Active := false;
  Animate1.Visible := false;
  ImageWorld.Visible := false;
  ImageComputer.Visible := true;

  btAction.Caption := '&Update Now';
  FWebUpdate := Value;
  FCancelled := false;
  FRestart := false;
  FUpdating := false;

  lbInfo.Visible := true;
  lbInfo.Caption := Format(
    'A new version of Data Modeler is available online.'#13#10#13#10 +
    'New version available: %s'#13#10 +
    'Current version: %s',
    [FWebUpdate.NewVersionInfo, FWebUpdate.CurVersionInfo]);

  Label1.Caption := '';

  FDialogMode := false;
  FWebUpdate.OnFileProgress := WebUpdateFileProgress;
  FWebUpdate.OnProgressCancel := WebUpdateCancel;
  FWebUpdate.OnStatus := WebUpdateStatus;
  FWebUpdate.OnAppRestart := WebUpdateRestart;

  ActiveControl := btUpdateLater;
end;

procedure TfmWebUpdateForm.ShowUpdateError(Msg: string);
begin
  Label1.Caption := '';
  Label2.Caption := '';
  lbInfo.Visible := false;
  AdvProgressBar1.Visible := false;
  Animate1.Active := false;
  Animate1.Visible := false;
  ImageWorld.Visible := false;
  ImageComputer.Visible := false;
  btUpdateLater.Visible := false;

  ImageOk.Visible := false;
  ImageError.Visible := true;
  Label1.Caption := Format('Error while checking for updates. %s', [Msg]);
  Label1.Alignment := taCenter;
  btAction.Caption := '&Close';

  FDialogMode := true;
  ShowModal;
end;

procedure TfmWebUpdateForm.ShowUpdateOk;
begin
  Label1.Caption := '';
  Label2.Caption := '';
  lbInfo.Visible := false;
  AdvProgressBar1.Visible := false;
  Animate1.Active := false;
  Animate1.Visible := false;
  ImageWorld.Visible := false;
  ImageComputer.Visible := false;
  btUpdateLater.Visible := false;

  ImageOk.Visible := true;
  Label1.Caption := 'No updates available. The current version is the latest one.';
  Label1.Alignment := taCenter;
  btAction.Caption := '&Close';

  FDialogMode := true;
  ShowModal;
end;

procedure TfmWebUpdateForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not FDialogMode then
    UpdateDone;
end;

procedure TfmWebUpdateForm.FormCreate(Sender: TObject);
begin
  Animate1.ResName := 'DM_WEBUPDATE_ANIM';
end;

procedure TfmWebUpdateForm.UpdateDone;
begin
  if FWebUpdate <> nil then
    FWebUpdate.StopConnection;
  Close;
end;

procedure TfmWebUpdateForm.WMClose(var Message: TWMClose);
begin
  if FUpdating then
    FCancelled := true;
  Close;
end;

procedure TfmWebUpdateForm.btUpdateLaterClick(Sender: TObject);
begin
  Close;
end;

procedure TfmWebUpdateForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Perform(WM_CLOSE, 0, 0);
end;

procedure TfmWebUpdateForm.CheckBox1Click(Sender: TObject);
begin
  if not FUpdatingCheckBox and Assigned(OnCheckOnStartToggle) then
    FOnCheckOnStartToggle(Sender, CheckBox1.Checked);
end;

destructor TfmWebUpdateForm.Destroy;
begin
  if FWebUpdate <> nil then
  begin
    FWebUpdate.OnFileProgress := nil;
    FWebUpdate.OnProgressCancel := nil;
    FWebUpdate.OnStatus := nil;
    FWebUpdate.OnAppRestart := WebUpdateRestart;
  end;
  inherited;
end;

function TfmWebUpdateForm.GetCheckOnStart: boolean;
begin
  result := CheckBox1.Checked;
end;

procedure TfmWebUpdateForm.SetCheckOnStart(const Value: boolean);
begin
  FUpdatingCheckBox := true;
  try
    CheckBox1.Checked := Value;
  finally
    FUpdatingCheckBox := false;
  end;
end;

end.

