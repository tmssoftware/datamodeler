unit fOracleCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, dgConsts, dgDBTypes, Buttons, uSQLModule, UITypes;

type
  TfrOracleCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbService: TComboBox;
    TestConButton: TBitBtn;
    edUserName: TEdit;
    Label3: TLabel;
    cbSchema: TComboBox;
    procedure TestConButtonClick(Sender: TObject);
    procedure cbServiceDropDown(Sender: TObject);
    procedure cbSchemaDropDown(Sender: TObject);
  private
    FedPassword: TPasswordEdit;
    FDBType: TDatabaseType;
    FSchemasListLoaded: boolean;
    FServicesListLoaded: boolean;
    function ListOracleDatabaseSchemas(AConnectionStr: string; AList: TStrings): boolean;
    procedure ListOracleServices(AList: TStrings);
    function OracleHomeDirectory: string;
    { Interface IUnknown }
    function QueryInterface(const IID: TGUID; out Obj):HRESULT; reintroduce; stdcall; 
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure FrameInitialization(ADBType: TDatabaseType);
  public
    function GetConnectionStrings: String;
    procedure SetExistingConfiguration(AConfig: String);
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
  end;

implementation

uses
  Registry, uStrings, uDBConnect;

const
  ORACLE_HOME        = 'ORACLE_HOME';
  ORA_CRS_HOME       = 'ORA_CRS_HOME';
  REG_ORACLE_KEY     = 'Software\Oracle';
  REG_ORACLEHOME_KEY = 'Software\Oracle\KEY_OraDb10g_home1';
  TNS_FOLDER         = 'network\admin';
  TNS_FILENAME       = 'tnsnames.ora';
  
{$R *.dfm}

{ TfrOracleCfg }

function TfrOracleCfg._AddRef: Integer;
begin
  Result := -1;
end;

function TfrOracleCfg._Release: Integer;
begin
  Result := -1;
end;

function TfrOracleCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

procedure TfrOracleCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := Panel2.Width;
  AHeight := Panel2.Height;
end;

function TfrOracleCfg.ListOracleDatabaseSchemas(AConnectionStr: string; AList: TStrings): boolean;
var
  dbc: TDBConnection;
  sm: TSQLModule;

  function OraSystemUser(u: string): boolean;
  begin
    result := (u='DBSNMP') or (u='EXFSYS') or (u='MDSYS') or (u='ORDSYS') or (u='OUTLN') or (u='SYS')
      or (u='SYSMAN') or (u='SYSTEM') or (u='TSMSYS') or (u='WKSYS') or (u='WMSYS') or (u='XDB');
  end;
  
begin
  result := false;
  AList.Clear;
  try
    AList.Add('(user schema)');
    dbc := CreateAndConnectDBConnection(FDBType, AConnectionStr);
    try
      sm := dbc.GetNewSQLModule(nil);
      try
        sm.Open('SELECT USERNAME FROM ALL_USERS ORDER BY USERNAME');
        AList.BeginUpdate;
        try
          while not sm.Eof do
          begin
            if not OraSystemUser(sm.FieldAsString('USERNAME')) then
              AList.Add(sm.FieldAsString('USERNAME'));
            sm.Next;
          end;
          result := true;
        finally
          AList.EndUpdate;
        end;
      finally
        sm.Free;
      end;
    finally
      dbc.Free;
    end;
  except
    on e:exception do
      MessageDlg(e.Message,mtError, [mbOK],0);
  end;
end;

procedure TfrOracleCfg.ListOracleServices(AList: TStrings);
var
  tnsNamesFile, line: string;
  sl: TStringList;
  i: Integer;
begin
  AList.Clear;
  tnsNamesFile := Format('%s\%s\%s', [OracleHomeDirectory, TNS_FOLDER, TNS_FILENAME]);
  if FileExists(tnsNamesFile) then
  begin
    sl := TStringList.Create;
    try
      sl.LoadFromFile(tnsNamesFile);
      for i := 0 to sl.Count - 1 do
      begin
        line := Trim(sl[i]);
        if (line > '') and CharInSet(line[1], ['A'..'Z','a'..'z','_']) and (line[Length(line)] = '=') then
          AList.Add(Trim(Copy(line, 1, Length(line)-1)));
      end;
    finally
      sl.Free;
    end;  
  end;
end;

function TfrOracleCfg.OracleHomeDirectory: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey(REG_ORACLE_KEY, False) then
    begin
      result := reg.ReadString(ORA_CRS_HOME);
      reg.CloseKey;
      if (result = '') and reg.OpenKey(REG_ORACLEHOME_KEY, False) then
      begin
        result := reg.ReadString(ORACLE_HOME);
        reg.CloseKey;
      end;
    end;
  finally
    reg.Free;
  end;
end;

procedure TfrOracleCfg.SetExistingConfiguration(AConfig: String);
var r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    cbService.Text := r.Values['SERVER NAME'];
    edUserName.Text := r.Values['USER NAME'];
    FedPassword.Text := UndoTheStr(r.Values['PASSWORD']);
  finally
    r.Free;
  end;
end;

procedure TfrOracleCfg.TestConButtonClick(Sender: TObject);
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

function TfrOracleCfg.GetConnectionStrings: String;
var r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Values['SERVER NAME'] := cbService.Text;
    r.Values['USER NAME'] := edUserName.Text;
    r.Values['PASSWORD'] := DoTheStr(FedPassword.Text);
    if cbSchema.ItemIndex > 0 then
      r.Values['SCHEMA'] := cbSchema.Text;
    Result := r.Text;
  finally
    r.Free;
  end;
end;

function TfrOracleCfg.PasswordIsRequired: Boolean;
begin
  Result := false;
end;

procedure TfrOracleCfg.cbSchemaDropDown(Sender: TObject);
begin                                                                
  if not FSchemasListLoaded then
  begin
    CheckSettings;
    try
      FSchemasListLoaded := ListOracleDatabaseSchemas(GetConnectionStrings, cbSchema.Items);
    finally
      cbSchema.ItemIndex := 0;
    end;
  end;
end;

procedure TfrOracleCfg.cbServiceDropDown(Sender: TObject);
begin
  if not FServicesListLoaded then
  begin
    ListOracleServices(cbService.Items);
    FServicesListLoaded := True;
  end;
end;

procedure TfrOracleCfg.CheckSettings;
begin
  if Trim(cbService.Text) = '' then
  begin
    ShowMessage('Net service name not specified.');
    cbService.SetFocus;
    Abort;
  end else
  if Trim(edUserName.Text) = '' then
  begin
    ShowMessage('User name not specified.');
    edUserName.SetFocus;
    Abort;
  end;
end;

procedure TfrOracleCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDBType := ADBType;
  FServicesListLoaded := False;
  FSchemasListLoaded := False;
  edUserName.Enabled := True;
  
  if FedPassword = nil then
  begin
    FedPassword := TPasswordEdit.Create(Self);
    FedPassword.Parent := edUserName.Parent;
    FedPassword.Top := edUserName.Top;
    FedPassword.Left := edUserName.Left + edUserName.Width + 5;
    FedPassword.Width := cbService.Left + cbService.Width - FEdPassword.Left;
    FedPassword.Enabled := edUserName.Enabled;
    FedPassword.TabOrder := edUserName.TabOrder + 1;
  end;
end;

end.


