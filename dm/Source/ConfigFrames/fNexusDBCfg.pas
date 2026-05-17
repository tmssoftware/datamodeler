unit fNexusDBCfg;

{$I ../../dm.inc}

{$IFDEF NEXUSDB}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, AdvDirectoryEdit, dgConsts, dgDBTypes, Buttons,
  uDBConnect, UITypes,

  nxllTransport,

  NexusProjectDBModule;

type
  TnxDMServerInfo = class(TComponent)
  private
    ServerName: string;
    Transport: TnxDMTransportType;
    constructor _Create(AOwner: TComponent; AServerName: string; ATransport: TnxDMTransportType);
  end;

  TfrNexusDBCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel1: TPanel;
    pnServer: TPanel;
    Label1: TLabel;
    cbServers: TComboBox;
    pnServerSettings: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edServerName: TEdit;
    cbTransport: TComboBox;
    pnPath: TPanel;
    Label5: TLabel;
    edDatabasePath: TAdvDirectoryEdit;
    pnAlias: TPanel;
    Label4: TLabel;
    cbAliasName: TComboBox;
    pnUser: TPanel;
    lbPassword: TLabel;
    Label6: TLabel;
    edUserName: TEdit;
    TestConButton: TBitBtn;
    procedure TestConButtonClick(Sender: TObject);
    procedure cbServersChange(Sender: TObject);
    procedure edDatabasePathChange(Sender: TObject);
    procedure cbAliasNameChange(Sender: TObject);
    procedure cbAliasNameDropDown(Sender: TObject);
  private
    FedPassword: TPasswordEdit;
    FDBType: TDatabaseType;
    function QueryInterface(const IID: TGUID; out Obj):HRESULT; reintroduce; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure FrameInitialization(ADBType: TDatabaseType);
    function SelectedTransport: TnxDMTransportType;
    function SelectedServerInfo: TnxDMServerInfo;
    function SelectedServerName: string;
    procedure FillAliasCombo;
    procedure FillServersCombo;
    procedure AppendServerNames(AItems: TStrings; ACode: TnxDMTransportType);
  public
    function GetConnectionStrings: String;
    procedure SetExistingConfiguration(AConfig: String);
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
  end;

implementation
uses
  uStrings;

{$R *.dfm}

constructor TnxDMServerInfo._Create(AOwner: TComponent; AServerName: string; ATransport: TnxDMTransportType);
begin
  inherited Create(AOwner);
  ServerName := AServerName;
  Transport := ATransport;
end;

function TfrNexusDBCfg._AddRef: Integer;
begin
  Result := -1;
end;

function TfrNexusDBCfg._Release: Integer;
begin
  Result := -1;
end;

function TfrNexusDBCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

procedure TfrNexusDBCfg.AppendServerNames(AItems: TStrings; ACode: TnxDMTransportType);
const
  _TransportArray: array[TnxDMTransportType] of string =
    ('', 'Winsock', 'Named pipes', 'Shared memory');
var
  SL: TStrings;
  c: integer;
  ATransport: TnxBaseTransport;
begin
  ATransport := TdmNexusProjectDBModule.CreateNxTransport(ACode, Self);
  SL := TStringList.Create;
  try
    ATransport.GetServerNames(SL, 1000);
    for c := 0 to SL.Count - 1 do
    begin
      AItems.AddObject(
        Format('%s (%s)', [SL[c], _TransportArray[ACode]]),
        TnxDMServerInfo._Create(Self, SL[c], ACode)
      );
    end;
  finally
    ATransport.Free;
    SL.Free;
  end;
end;

function TfrNexusDBCfg.GetConnectionStrings: String;
var
  r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Values[SDBO_NexusServer] := SelectedServerName;
    r.Values[SDBO_NexusTransport] := IntToStr(Ord(SelectedTransport));
    r.Values[SDBO_NexusAliasName] := cbAliasName.Text;
    r.Values[SDBO_NexusAliasPath] := edDatabasePath.Text;
    r.Values[SDBO_NexusUserName] := edUserName.Text;
    r.Values[SDBO_NexusPassword] := DoTheStr(FedPassword.Text);
    Result := r.Text;
  finally
    r.Free;
  end;
end;

procedure TfrNexusDBCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := Panel1.Width;
  AHeight := Panel1.Height;
end;

function TfrNexusDBCfg.SelectedServerInfo: TnxDMServerInfo;
begin
  if cbServers.ItemIndex >= 0 then
    result := TnxDMServerInfo(cbServers.Items.Objects[cbServers.ItemIndex])
  else
    result := nil;
end;

function TfrNexusDBCfg.SelectedServerName: string;
begin
  if SelectedServerInfo <> nil then
    result := SelectedServerInfo.ServerName
  else
    result := edServerName.Text;
end;

function TfrNexusDBCfg.SelectedTransport: TnxDMTransportType;
begin
  if SelectedServerInfo <> nil then
    result := SelectedServerInfo.Transport
  else
  begin
    if cbTransport.ItemIndex >= 0 then
      result := TnxDMTransportType(integer((cbTransport.Items.Objects[cbTransport.ItemIndex])))
    else
      result := ndWinsock;
  end;
end;

procedure TfrNexusDBCfg.SetExistingConfiguration(AConfig: String);

  procedure ChooseServer(AName: string; ATrans: TnxDMTransportType);
  var
    c: integer;
    idx: integer;
    si: TnxDMServerInfo;
  begin
    if ATrans = ndInternal then
      idx := 0
    else
    begin
      idx := -1;
      for c := 0 to cbServers.Items.Count - 1 do
      begin
        si := TnxDMServerInfo(cbServers.Items.Objects[c]);
        if (si <> nil) and SameText(si.ServerName, AName) and (si.Transport = ATrans) then
        begin
          idx := c;
          break;
        end;
      end;

      {if server not found, set as custom server}
      if idx = -1 then
        idx := cbServers.Items.Count - 1;
    end;

    cbServers.ItemIndex := idx;
    cbServersChange(nil);
  end;

var
  r : TStrings;
  t: TnxDMTransportType;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    cbAliasName.Text := r.Values[SDBO_NexusAliasName];
    edDatabasePath.Text := r.Values[SDBO_NexusAliasPath];
    edUserName.Text := r.Values[SDBO_NexusUserName];
    FedPassword.Text := UndoTheStr(r.Values[SDBO_NexusPassword]);
    t := TdmNexusProjectDBModule.StrToNxTransport(r.Values[SDBO_NexusTransport]);

    ChooseServer(r.Values[SDBO_NexusServer], t);

    edServerName.Text := r.Values[SDBO_NexusServer];
    cbTransport.ItemIndex := cbTransport.Items.IndexOfObject(TObject(Ord(t)));
    if (cbTransport.ItemIndex = -1) then
      cbTransport.ItemIndex := 0;
  finally
    r.Free;
  end;
end;

procedure TfrNexusDBCfg.TestConButtonClick(Sender: TObject);
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

function TfrNexusDBCfg.PasswordIsRequired: Boolean;
begin
  Result := false;
end;

procedure TfrNexusDBCfg.FillAliasCombo;
var
  ATest: TDBConnection;
begin
  cbAliasName.Items.Clear;
  try
    ATest := CreateDBConnection(FDBType, GetConnectionStrings);
    try
      if ATest.DatabaseModule is TdmNexusProjectDBModule then
        TdmNexusProjectDBModule(ATest.DatabaseModule).GetAliasNames(cbAliasName.Items);
    finally
      ATest.Free;
    end;
  except
    on e:exception do
      MessageDlg(e.Message, mtError, [mbOK],0);
  end;
end;

procedure TfrNexusDBCfg.FillServersCombo;
var
  SL: TStrings;
begin
  cbServers.Items.Clear;
  SL := TStringList.Create;
  try
    cbServers.Items.AddObject('Internal Server', TnxDMServerInfo._Create(Self, '', ndInternal));
    cbServers.ItemIndex := 0;
    cbServersChange(nil);
    try
      AppendServerNames(cbServers.Items, ndWinsock);
      AppendServerNames(cbServers.Items, ndNamedPipes);
//      AppendServerNames(cbServers.Items, ndSharedMemory);
    except
    end;
    cbServers.Items.AddObject('Custom defined server', nil);
  finally
    SL.Free;
  end;
end;

procedure TfrNexusDBCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDBType := ADBType;
  edServerName.Text := '';
  cbTransport.Items.Clear;
  cbTransport.Items.AddObject('Winsock', TObject(Ord(ndWinsock)));
  cbTransport.Items.AddObject('Named pipes', TObject(Ord(ndNamedPipes)));
  cbTransport.ItemIndex := 0;
  cbTransport.Enabled := true;

  if FEdPassword = nil then
  begin
    FEdPassword := TPasswordEdit.Create(Self);
    FEdPassword.Parent := lbPassword.Parent;
    FEdPassword.Top := edUserName.Top;
    FEdPassword.Left := lbPassword.Left;
    FedPassword.Width := cbTransport.Width;
    FEdPassword.Enabled := true;
    FEdPassword.TabOrder := edUserName.TabOrder + 1;
  end;

  FillServersCombo;
end;

procedure TfrNexusDBCfg.cbAliasNameChange(Sender: TObject);
begin
  edDatabasePath.Text := '';
end;

procedure TfrNexusDBCfg.cbAliasNameDropDown(Sender: TObject);
begin
  FillAliasCombo;
end;

procedure TfrNexusDBCfg.cbServersChange(Sender: TObject);
begin
  if SelectedServerInfo <> nil then
  begin
    case SelectedServerInfo.Transport of
      ndInternal:
        begin
          pnServerSettings.Visible := false;
          pnAlias.Visible := false;
        end;
      ndWinsock:
        begin
          pnServerSettings.Visible := false;
          pnAlias.Visible := true;
        end;
      ndNamedPipes:
        begin
          pnServerSettings.Visible := false;
          pnAlias.Visible := true;
        end;
      ndSharedMemory:
        begin
          pnServerSettings.Visible := false;
          pnAlias.Visible := true;
        end;
    end;
  end else
  begin
    pnServerSettings.Visible := true;
    pnAlias.Visible := true;
  end;
end;

procedure TfrNexusDBCfg.CheckSettings;
begin
  case SelectedTransport of
    ndInternal:
      begin
        if (Trim(edDatabasePath.Text) = '') then
        begin
          ShowMessage('Database path not specified.');
          edDatabasePath.SetFocus;
          Abort;
        end;
      end;
  else
      begin
        if (Trim(edDatabasePath.Text) = '') and (Trim(cbAliasName.Text) = '') then
        begin
          ShowMessage('Database path or alias name must be specified.');
          if edDatabasePath.Parent.Visible then
            edDatabasePath.SetFocus;
          Abort;
        end;
        if Trim(SelectedServerName) = '' then
        begin
          ShowMessage('Server name not specified.');
          if edServerName.Parent.Visible then
            edServerName.SetFocus;
          Abort;
        end;
      end;
  end;
end;

procedure TfrNexusDBCfg.edDatabasePathChange(Sender: TObject);
begin
  cbAliasName.Text := '';
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.


