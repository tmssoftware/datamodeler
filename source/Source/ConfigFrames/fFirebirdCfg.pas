unit fFirebirdCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, dgConsts, dgDBTypes, Buttons, UITypes;

type
  TfrFirebirdCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel2: TPanel;
    lbServer: TLabel;
    Label3: TLabel;
    edServer: TEdit;
    TestConButton: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    edUserName: TEdit;
    edDatabase: TAdvFileNameEdit;
    Label2: TLabel;
    cbProtocol: TComboBox;
    Label1: TLabel;
    edVendorLib: TEdit;
    cbCharset: TComboBox;
    Label6: TLabel;
    procedure TestConButtonClick(Sender: TObject);
    procedure cbProtocolChange(Sender: TObject);
  private
    FedPassword: TPasswordEdit;
    FDBType: TDatabaseType;
    { Interface IUnknown }
    function QueryInterface(const IID: TGUID; out Obj):HRESULT; reintroduce; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure FrameInitialization(ADBType: TDatabaseType);
    function IsLocalProtocol: boolean;
  public
    function GetConnectionStrings: String;
    procedure SetExistingConfiguration(AConfig: String);
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
  end;

implementation
uses
  uStrings, uDBConnect;

{$R *.dfm}

{ TfrFirebirdCfg }

function TfrFirebirdCfg._AddRef: Integer;
begin
   result:=-1;
end;

function TfrFirebirdCfg._Release: Integer;
begin
   result:=-1;
end;

function TfrFirebirdCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

procedure TfrFirebirdCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := Panel2.Width;
  AHeight := Panel2.Height;
end;

function TfrFirebirdCfg.IsLocalProtocol: boolean;
begin
  Result := false;
  if cbProtocol.ItemIndex >= 0 then
    Result := SameText(cbProtocol.Items[cbProtocol.ItemIndex], SDBO_FirebirdProtocolItem_Local);
end;

procedure TfrFirebirdCfg.SetExistingConfiguration(AConfig: String);
var r : TStrings;
    //s : String;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    //s := r.Values['REMOTE DATABASE'];
    //edServerName.Text := copy(s, 1, pos(':', s));
    //edDatabase.Text := trim(copy(s, pos(':', s)+1, length(s)));
    edServer.Text := r.Values[SDBO_FirebirdServer];
    edVendorLib.Text := r.Values[SDBO_FirebirdVendorLib];
    cbCharset.Text := r.Values[SDBO_FirebirdCharset];
    if cbCharset.Text = '' then
      cbCharset.Text := 'UTF8';
    edDatabase.Text := r.Values[SDBO_FirebirdDatabase];
    edUserName.Text := r.Values[SDBO_FirebirdUserName];
    FedPassword.Text := UndoTheStr(r.Values[SDBO_FirebirdPassword]);
    cbProtocol.ItemIndex := cbProtocol.Items.Indexof(r.Values[SDBO_FirebirdProtocol]);
    if cbProtocol.ItemIndex = -1 then
      cbProtocol.ItemIndex := 0;
    cbProtocolChange(nil);
  finally
    r.Free;
  end;
end;

procedure TfrFirebirdCfg.TestConButtonClick(Sender: TObject);
var
  ATest: TDBConnection;
begin
  CheckSettings;
  try
    ATest := CreateAndConnectDBConnection(FDBType, GetConnectionStrings);
    ATest.Free;
    MessageDlg('Connection successful!', mtInformation, [mbOK], 0);
  except
    on e:exception do
      MessageDlg(e.Message, mtError, [mbOK],0);
  end;
end;

function TfrFirebirdCfg.GetConnectionStrings: String;
var
  r : TStrings;
begin
  r := TSTringList.Create;
  try
    if IsLocalProtocol then
      r.Values[SDBO_FirebirdServer] := ''
    else
      r.Values[SDBO_FirebirdServer] := edServer.Text;
    r.Values[SDBO_FirebirdVendorLib] := edVendorLib.Text;
    r.Values[SDBO_FirebirdCharset] := cbCharset.Text;
    r.Values[SDBO_FirebirdDatabase] := edDatabase.Text;
    r.Values[SDBO_FirebirdUserName] := edUserName.Text;
    r.Values[SDBO_FirebirdPassword] := DoTheStr(FedPassword.Text);
    if cbProtocol.ItemIndex >= 0 then
      r.Values[SDBO_FirebirdProtocol] := cbProtocol.Items[cbProtocol.ItemIndex]
    else
      r.Values[SDBO_FirebirdProtocol] := SDBO_FirebirdProtocolItem_TCP;
    Result := r.Text;
  finally
    r.Free;
  end;
end;

function TfrFirebirdCfg.PasswordIsRequired: Boolean;
begin
  Result := false;
end;

procedure TfrFirebirdCfg.cbProtocolChange(Sender: TObject);
begin
  edServer.Visible := not IsLocalProtocol;
  lbServer.Visible := edServer.Visible;
  if IsLocalProtocol then
    edServer.Text := '';
end;

procedure TfrFirebirdCfg.CheckSettings;
begin
  if (Trim(edServer.Text) = '') and not IsLocalProtocol then
  begin
    ShowMessage('Server name not specified.');
    edServer.SetFocus;
    Abort;
  end else
  if Trim(edDatabase.Text) = '' then
  begin
    ShowMessage('Database not specified.');
    edDatabase.SetFocus;
    Abort;
  end else
  if Trim(edUserName.Text) = '' then
  begin
    ShowMessage('User name not specified.');
    edUserName.SetFocus;
    Abort;
  end else
  if Trim(FedPassword.Text) = '' then
  begin
    ShowMessage('Password not specified.');
    FedPassword.SetFocus;
    Abort;
  end else
  if cbProtocol.ItemIndex = -1 then
  begin
    ShowMessage('Protocol not specified.');
    cbProtocol.SetFocus;
    Abort;
  end;
end;

procedure TfrFirebirdCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  edDatabase.Filter := 'Firebird/Interbase databases (*.fdb;*.gdb;*.ib)|*.fdb;*.gdb;*.ib|All files (*.*)|*.*';

  cbProtocol.Items.Clear;
  cbProtocol.Items.Add(SDBO_FirebirdProtocolItem_TCP);
  cbProtocol.Items.Add(SDBO_FirebirdProtocolItem_Local);
  FDBType := ADBType;
  edUserName.Enabled := true;
  if FEdPassword = nil then
  begin
    FEdPassword := TPasswordEdit.Create(Self);
    FEdPassword.Parent := edUserName.Parent;
    FEdPassword.Top := edUserName.Top;
    FEdPassword.Left := edUserName.Left + edUserName.Width + 5;
    FedPassword.Width := edDatabase.Left + edDatabase.Width - FEdPassword.Left;
    FEdPassword.Enabled := edUserName.Enabled;
    FEdPassword.TabOrder := edUserName.TabOrder + 1;
  end;
end;

end.


