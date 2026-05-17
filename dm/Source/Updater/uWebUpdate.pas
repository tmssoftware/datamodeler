unit uWebUpdate;

interface
uses
  Windows, Messages, Types, Forms, Classes, WUpdate, fWebUpdate,
  controls, sysutils,
  dialogs, dWebUpdate, ExtCtrls, uDMApp;

type
  TDMAppUpdater = class;

  TDMAppUpdateThread = class(TThread)
  private
    FUpdater: TDMAppUpdater;
    procedure NotifyNewVersion;
  protected
    procedure Execute; override;
  public
    constructor Create(AUpdater: TDMAppUpdater);
    destructor Destroy; override;
  end;

  TDMAppUpdater = class(TBaseDMAppUpdater)
  private
    FContainer: TdmWebUpdate;
    FWebUpdate: TWebUpdate;
    FUpdateForm: TfmWebUpdateForm;
    FThread: TDMAppUpdateThread;

    FLastErrorCode: integer;
    FLastErrorMsg: string;
    procedure InitWebUpdate;
    procedure CreateObjects;
    procedure DestroyObjects;
    procedure BeforeRestart(Sender: TObject);
    procedure CheckOnStartToggle(Sender: TObject; ACheck: boolean);
    procedure ShowAlert;
    procedure WebAlertClick(Sender: TObject);
    procedure ThreadTerminate(Sender: TObject);
    procedure WebUpdateStatus(Sender: TObject; StatusStr: string; StatusCode, ErrCode: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CheckForUpdates; override;
    procedure WebUpdateAlert; override;
  end;

implementation

uses
  uAppRegistry, MMSystem, uStrings, uConsts, uAppUtils;

{ TDMAppUpdater }

procedure TDMAppUpdater.BeforeRestart(Sender: TObject);
begin
  DMApp.CloseAll;
end;

procedure TDMAppUpdater.CheckForUpdates;
begin
  {Do not check again while the thread is still running}
  if FThread <> nil then Exit;

  if FUpdateForm <> nil then
  begin
    FUpdateForm.ModalResult := mrCancel;
    Exit;
  end;

  CreateObjects;
  try
    FUpdateForm.CheckOnStart := DMRegistry.CheckUpdatesOnStart;
    FUpdateForm.OnCheckOnStartToggle := CheckOnStartToggle;

    FLastErrorCode := FWebUpdate.StartConnection;
    if (FLastErrorCode = 0) and FWebUpdate.NewVersionAvailable then
    begin
      FUpdateForm.WebUpdate := FWebUpdate;
      FUpdateForm.OnBeforeRestart := BeforeRestart;
      FUpdateForm.ShowModal;
    end else
    begin
      if FLastErrorCode = 0 then
        FUpdateForm.ShowUpdateOk
      else
        FUpdateForm.ShowUpdateError(Format('Error code: %d', [FLastErrorCode]));
      //Show updated application
      //Show error if any
    end;
  finally
    DestroyObjects;
  end;
end;

procedure TDMAppUpdater.CheckOnStartToggle(Sender: TObject; ACheck: boolean);
begin
  DMRegistry.CheckUpdatesOnStart := ACheck;
end;

constructor TDMAppUpdater.Create(AOwner: TComponent);
begin
  inherited;
  FContainer := TdmWebUpdate.Create(nil);
end;

procedure TDMAppUpdater.CreateObjects;
begin
  if FWebUpdate = nil then
  begin
    FWebUpdate := TWebUpdate.Create(nil);
    InitWebUpdate;
  end;
  if FUpdateForm = nil then
    FUpdateForm := TfmWebUpdateForm.Create(nil);
end;

destructor TDMAppUpdater.Destroy;
begin
  if (FThread <> nil) then
  begin
    {It should be very rare, but this code might cause problems if the thread
     terminates between the previous command (if thread <> nil) and the next one.
     In this case, the thread is terminated and the FThread.Free will fail.
     Let's use an empty try..except to avoid such problems}
    FThread.FreeOnTerminate := false;
    try
      {The command below will wait for the thread to finish, if it's not finished.
      We must set FreeOnTerminate to false otherwise when the thread is finished
      it will destroy itself, and the WaitFor method called during FThread.Free will
      raise an error - it doesn't test if the thread was destroyed while waiting for it}
      FThread.Free;
    except
    end;
  end;

  FContainer.Free;
  DestroyObjects;
  inherited;
end;

procedure TDMAppUpdater.DestroyObjects;
begin
  if FUpdateForm <> nil then
  begin
    FUpdateForm.Free;
    FUpdateForm := nil;
  end;
  if FWebUpdate <> nil then
  begin
    FWebUpdate.Free;
    FWebUpdate := nil;
  end;
end;

procedure TDMAppUpdater.InitWebUpdate;
begin
  FLastErrorCode := 0;
  FLastErrorMsg := '';
  with FWebUpdate do
  begin
    Logging := true;
    LogFileName := GetDMAppDataFolder + '\wupdate.log';
    URL := DATAMODELER_WEBUPDATE;
    UpdateUpdate := wuuSilent;

    OnStatus := WebUpdateStatus;

    //Agent: string
    //ApplyPatch: Boolean
    //Authenticate: TWebUpdateAuthentication
    //DateFormat: string
    //DateSeparator: Char
    //ExtractCAB: Boolean
    //ExistingConnection: Boolean
    //FTPDirectory: string
    //FTPPassive: Boolean
    //Host: string
    //HTTPKeepAliveAuthentication: Boolean
    //KeepIntermediateFiles: Boolean
    //LanguageID: string
    //LastURLEntry: TLastURLEntry
    //Password: string
    //Port: Integer
    //PostUpdateInfo: TPostUpdateInfo
    //Proxy: string
    //ProxyUserID: string
    //ProxyPassword: string
    //Signature: string
    //SignatureCheck: Boolean
    //TempDirectory: string
    //TimeFormat: string
    //TimeOut: integer
    //TimeSeparator: Char
    //UpdateType: TWebUpdateType
    //UpdateConnect: TWebUpdateConnect
    //UpdateUpdate: TWebUpdateUpdate
    //UserID:string
    //UseCRC32: Boolean
    //UseWinTempDir: Boolean
    //Utility: TWebUpdateUtility
    //VersionCheck: TWebUpdateVersionCheck
    //OnFileProgress:TWebUpdateFileProgress
    //OnFileDownloaded:TWebUpdateFileDownloaded
    //OnFileVersionCheck:TWebUpdateFileVersionCheck
    //OnProcessPostResult:TWebUpdateProcessPostResult
    //OnBeforePost: TWebUpdateBeforePost
    //OnProgress:TWebUpdateProgress
    //OnProgressCancel:TWebUpdateProgressCancel
    //OnStatus:TWebUpdateStatus
    //OnThreadUpdateDone:TWebUpdateThreadDone
    //OnAppRestart:TWebUpdateRestart
    //OnAppDoClose:TWebUpdateEvent
    //OnBeforeFileDownload: TWebUpdateBeforeDownload
    //OnCustomValidate:TWebUpdateCustomValidate
    //OnCustomProcess:TWebUpdateCustomProcess
    //OnGetFileList:TWebUpdateFileList
    //OnConvertPrefix:TWebUpdateConvertPrefix
    //OnSetAppParams: TWebUpdateSetParams
    //OnDownloadedWhatsNew: TWebUpdateTextDownloaded
    //OnDownloadedEULA: TWebUpdateTextDownloaded
    //OnFileNameFromURL: TWebUpdateFileNameFromURL
    //OnSuccess: TNotifyEvent
    //Version: string
  end;
end;

procedure TDMAppUpdater.ShowAlert;
begin
  {PlaySound(PChar('DM_WEBUPDATE_ALERT'), HInstance, SND_ASYNC or SND_RESOURCE);}
  with FContainer.TrayIcon do
  begin
    BalloonHint := 'A new version of TMS Data Modeler is available online.'#13#10+
      'Click here to update';
    BalloonTitle := 'TMS Data Modeler Update';
    BalloonFlags := bfInfo;
    BalloonTimeout := 30;
    Visible := true;
    OnBalloonClick := WebAlertClick;
    ShowBalloonHint;
  end;
end;

procedure TDMAppUpdater.ThreadTerminate(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
  begin
    DestroyObjects;
  end;
end;

procedure TDMAppUpdater.WebAlertClick(Sender: TObject);
begin
  FContainer.TrayIcon.Visible := false;
  CheckForUpdates;
end;

procedure TDMAppUpdater.WebUpdateAlert;
begin
  if FThread = nil then
  begin
    CreateObjects;
    FThread := TDMAppUpdateThread.Create(Self);
    FThread.OnTerminate := ThreadTerminate;
    FThread.Resume;
  end;
end;

procedure TDMAppUpdater.WebUpdateStatus(Sender: TObject; StatusStr: string;
  StatusCode, ErrCode: Integer);
begin
  if ErrCode <> 0 then
  begin
    FLastErrorCode := ErrCode;
    FLastErrorMsg := StatusStr;
  end;
end;

{ TDMAppUpdateThread }

constructor TDMAppUpdateThread.Create(AUpdater: TDMAppUpdater);
begin
  FreeOnTerminate := true;
  FUpdater := AUpdater;
  inherited Create(true);
end;

destructor TDMAppUpdateThread.Destroy;
begin
  if FUpdater <> nil then
    FUpdater.FThread := nil;
  inherited;
end;

procedure TDMAppUpdateThread.Execute;
begin
  if FUpdater.FWebUpdate.NewVersionAvailable then
    Synchronize(NotifyNewVersion);
end;

procedure TDMAppUpdateThread.NotifyNewVersion;
begin
  if (FUpdater <> nil) and not (csDestroying in FUpdater.ComponentState) then
    FUpdater.ShowAlert;
end;

end.
