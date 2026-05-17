unit fElevateDBCfg;

{$I ../../dm.inc}

{$IFDEF ELEVATEDB}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, AdvDirectoryEdit, dgConsts, dgDBTypes, advlued,
  Buttons, ComCtrls, Grids, AdvObj, BaseGrid, AdvGrid, UITypes, AdvUtil;

type
  TfrElevateDBCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    PageControl1: TPageControl;
    tsBasic: TTabSheet;
    tsAdvanced: TTabSheet;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    pnLocal: TPanel;
    Label6: TLabel;
    edConfigPath: TAdvDirectoryEdit;
    pnRemote: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edServer: TEdit;
    edPort: TAdvLUEdit;
    TestConButton: TBitBtn;
    edUserName: TEdit;
    cbDatabase: TComboBox;
    rbLocal: TRadioButton;
    rbRemote: TRadioButton;
    cbServerType: TComboBox;
    cbAdvanced: TCheckBox;
    grAdvanced: TAdvStringGrid;
    procedure TestConButtonClick(Sender: TObject);
    procedure cbDatabaseDropDown(Sender: TObject);
    procedure rbLocalClick(Sender: TObject);
    procedure cbAdvancedClick(Sender: TObject);
    procedure grAdvancedGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grAdvancedGetEditorProp(Sender: TObject; ACol, ARow: Integer;
      AEditLink: TEditLink);
  private
    FedPassword: TPasswordEdit;
    FDBType: TDatabaseType;
    FDatabaseListLoaded: boolean;
    FUpdatingCheck: boolean;
    function QueryInterface(const IID: TGUID; out Obj):HRESULT; reintroduce; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure FrameInitialization(ADBType: TDatabaseType);
    function ListElevateDBDatabases(AConnectionStr: string; AList: TStrings): boolean;
    procedure BuildDefaultAdvancedGrid;
    procedure EnableAdvancedGrid;
  public
    function GetConnectionStrings: String;
    procedure SetExistingConfiguration(AConfig: String);
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
  end;

implementation

uses
  uStrings, uDBConnect, uSQLModule, ElevateProjectDBModule, edbComps;

{$R *.dfm}

const
  ELEVATEDB_DEFAULTPORT = 12010;

{ TfrElevateDBCfg }

function TfrElevateDBCfg._AddRef: Integer;
begin
  result := -1;
end;

function TfrElevateDBCfg._Release: Integer;
begin
  result := -1;
end;

function TfrElevateDBCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  if GetInterface(IID, Obj) then
    result := S_OK
  else
    result := E_NOINTERFACE;
end;

procedure TfrElevateDBCfg.rbLocalClick(Sender: TObject);
begin
  pnLocal.Visible := rbLocal.Checked;
  pnRemote.Visible := rbRemote.Checked;
end;

function TfrElevateDBCfg.GetConnectionStrings: String;
var
  I: integer;
begin
  with TStringList.Create do
  try
    if rbLocal.Checked then
      Values['CONFIG PATH'] := edConfigPath.Text
    else
    begin
      Values['SERVER NAME'] := edServer.Text;
      Values['SERVER PORT'] := IntToStr(edPort.IntValue);
    end;
    if cbServerType.ItemIndex = 1 then
      Values['SERVER TYPE'] := 'UNICODE'
    else
      Values['SERVER TYPE'] := 'ANSI';
    Values['USER NAME'] := edUserName.Text;
    Values['PASSWORD'] := DoTheStr(FedPassword.Text);
    Values['DATABASE'] := cbDatabase.Text;

    if cbAdvanced.Checked then
    begin
      Values['ADVANCED'] := 'TRUE';
      for I := 0 to grAdvanced.RowCount - 1 do
        Values[grAdvanced.Cells[0, I]] := grAdvanced.Cells[1, I];
    end;
    result := Text;
  finally
    Free;
  end;
end;

procedure TfrElevateDBCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := PageControl1.Width;
  AHeight := PageControl1.Height;
end;

procedure TfrElevateDBCfg.grAdvancedGetEditorProp(Sender: TObject; ACol,
  ARow: Integer; AEditLink: TEditLink);
begin
  if SameText(grAdvanced.Cells[0, ARow], 'RemoteEncryption') then
  begin
    grAdvanced.ClearComboString;
    grAdvanced.Combobox.Items.Add('False');
    grAdvanced.Combobox.Items.Add('True');
    grAdvanced.Combobox.DropDownCount := 2;
  end;
end;

procedure TfrElevateDBCfg.grAdvancedGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if SameText(grAdvanced.Cells[0, ARow], 'RemoteEncryption') then
    AEditor := TEditorType.edComboList;
end;

function TfrElevateDBCfg.ListElevateDBDatabases(AConnectionStr: string; AList: TStrings): boolean;
var
  dbc: TDBConnection;
begin
  result := False;
  AList.Clear;
  try
    dbc := CreateDBConnection(FDBType, AConnectionStr);
    try
      if dbc.DatabaseModule is TdmElevateProjectDBModule then
        TdmElevateProjectDBModule(dbc.DatabaseModule).GetDatabaseNames(AList);
    finally
      dbc.Free;
    end;
  except
    on e: Exception do
      MessageDlg(e.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrElevateDBCfg.SetExistingConfiguration(AConfig: String);
var
  I: integer;
  ConfigName: string;
begin
  with TStringList.Create do
  try
    Text := AConfig;
    edConfigPath.Text := Values['CONFIG PATH'];
    edServer.Text := Values['SERVER NAME'];
    edPort.IntValue := StrToIntDef(Values['SERVER PORT'], ELEVATEDB_DEFAULTPORT);
    edUserName.Text := Values['USER NAME'];
    FedPassword.Text := UndoTheStr(Values['PASSWORD']);
    cbDatabase.Text := Values['DATABASE'];
    if edServer.Text > '' then
      rbRemote.Checked := true
    else
      rbLocal.Checked := true;
    if SameText(Values['SERVER TYPE'], 'UNICODE') then
      cbServerType.ItemIndex := 1
    else
      cbServerType.ItemIndex := 0;

    FUpdatingCheck := true;
    cbAdvanced.Checked := SameText(Values['ADVANCED'], 'TRUE');
    FUpdatingCheck := false;
    if cbAdvanced.Checked then
    begin
      EnableAdvancedGrid;
      for I := 0 to grAdvanced.RowCount - 1 do
      begin
        ConfigName := grAdvanced.Cells[0, I];
        if IndexOfName(ConfigName) >= 0 then
          grAdvanced.Cells[1, I] := Values[ConfigName];
      end;
    end;
  finally
    Free;
  end;
end;

procedure TfrElevateDBCfg.TestConButtonClick(Sender: TObject);
var
  dbc: TDBConnection;
begin
  CheckSettings;
  try
    dbc := CreateAndConnectDBConnection(FDBType, GetConnectionStrings);
    dbc.Free;
    MessageDlg('Connection successful!', mtInformation, [mbOK], 0);
  except
    on e:exception do
      MessageDlg(e.Message, mtError, [mbOK],0);
  end;
end;

function TfrElevateDBCfg.PasswordIsRequired: Boolean;
begin
  result := false;
end;

procedure TfrElevateDBCfg.BuildDefaultAdvancedGrid;
var
  es: TEDBSession;
  r: integer;
begin
  es := TEDBSession.Create(nil);
  try
    grAdvanced.RowCount := 13;

    r := 0;
    grAdvanced.Cells[0, r] := 'BackupExtension';
    grAdvanced.Cells[1, r] := string(es.LocalBackupExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'CatalogName';
    grAdvanced.Cells[1, r] := string(es.LocalCatalogName);

    inc(r);
    grAdvanced.Cells[0, r] := 'CatalogExtension';
    grAdvanced.Cells[1, r] := string(es.LocalCatalogExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'ConfigExtension';
    grAdvanced.Cells[1, r] := string(es.LocalConfigExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'ConfigName';
    grAdvanced.Cells[1, r] := string(es.LocalConfigName);

    inc(r);
    grAdvanced.Cells[0, r] := 'EncryptionPassword';
    grAdvanced.Cells[1, r] := string(es.LocalEncryptionPassword);

    inc(r);
    grAdvanced.Cells[0, r] := 'LockExtension';
    grAdvanced.Cells[1, r] := string(es.LocalLockExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'LogExtension';
    grAdvanced.Cells[1, r] := string(es.LocalLogExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'RemoteEncryption';
    if es.RemoteEncryption then
      grAdvanced.Cells[1, r] := 'True'
    else
      grAdvanced.Cells[1, r] := 'False';

    inc(r);
    grAdvanced.Cells[0, r] := 'Signature';
    grAdvanced.Cells[1, r] := string(es.LocalSignature);

    inc(r);
    grAdvanced.Cells[0, r] := 'TableBlobExtension';
    grAdvanced.Cells[1, r] := string(es.LocalTableBlobExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'TableExtension';
    grAdvanced.Cells[1, r] := string(es.LocalTableExtension);

    inc(r);
    grAdvanced.Cells[0, r] := 'TableIndexExtension';
    grAdvanced.Cells[1, r] := string(es.LocalTableIndexExtension);
  finally
    es.Free;
  end;

end;

procedure TfrElevateDBCfg.cbAdvancedClick(Sender: TObject);
begin
  if FUpdatingCheck then Exit;

  FUpdatingCheck := true;
  try
    if cbAdvanced.Checked then
    begin
      EnableAdvancedGrid;
      PageControl1.ActivePage := tsAdvanced;
    end else
    begin
      if MessageDlg('This will restore advanced settings to default values. Are you sure you want to discard advanced settings?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        tsAdvanced.TabVisible := false;
      end else
        cbAdvanced.Checked := true;
    end;
  finally
    FUpdatingCheck := false;
  end;
end;

procedure TfrElevateDBCfg.cbDatabaseDropDown(Sender: TObject);
begin
  if not FDatabaseListLoaded then
  begin
    CheckSettings;
    FDatabaseListLoaded := ListElevateDBDatabases(GetConnectionStrings, cbDatabase.Items);
  end;
end;

procedure TfrElevateDBCfg.CheckSettings;
begin
  if cbServerType.ItemIndex = -1 then
  begin
    ShowMessage('Server type not specified');
    cbServerType.SetFocus;
    Abort;
  end;

  if rbLocal.Checked then
  begin
    if edConfigPath.Text = '' then
    begin
      ShowMessage('Config path not specified.');
      edConfigPath.SetFocus;
      Abort;
    end;
  end
  else if rbRemote.Checked then
  begin
    if Trim(edServer.Text) = '' then
    begin
      ShowMessage('Server not specified.');
      edServer.SetFocus;
      Abort;
    end
    else if edPort.IntValue <= 0 then
    begin
      ShowMessage('Invalid port number.');
      edPort.SetFocus;
      Abort;
    end;
  end
  else
  begin
    ShowMessage('Select Local or Remote option.');
    rbLocal.SetFocus;
    Abort;
  end;
end;

procedure TfrElevateDBCfg.EnableAdvancedGrid;
begin
  BuildDefaultAdvancedGrid;
  tsAdvanced.TabVisible := true;
end;

procedure TfrElevateDBCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDBType := ADBType;
  FDatabaseListLoaded := false;
  tsAdvanced.TabVisible := false;
  edPort.IntValue := ELEVATEDB_DEFAULTPORT;
  edUserName.Enabled := true;
  cbServerType.ItemIndex := 0;

  if FedPassword = nil then
  begin
    FedPassword := TPasswordEdit.Create(Self);
    FedPassword.Parent := edUserName.Parent;
    FedPassword.Top := edUserName.Top;
    FedPassword.Left := edUserName.Left + edUserName.Width + 5;
    FedPassword.Width := cbDatabase.Left + cbDatabase.Width - FEdPassword.Left;
    FedPassword.Enabled := edUserName.Enabled;
    FedPassword.TabOrder := edUserName.TabOrder + 1;
    FedPassword.Anchors := [akLeft, akTop, akRight];
  end;
  rbLocalClick(nil);
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

