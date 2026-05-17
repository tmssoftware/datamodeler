unit fPostgreSQLCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, advlued, dgConsts, dgDBTypes, Buttons, UITypes;

type
  TfrPostgreSQLCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    edServer: TEdit;
    TestConButton: TBitBtn;
    edUserName: TEdit;
    cbDatabase: TComboBox;
    Label2: TLabel;
    edPort: TAdvLUEdit;
    Label6: TLabel;
    cbSchema: TComboBox;
    procedure TestConButtonClick(Sender: TObject);
    procedure cbDatabaseDropDown(Sender: TObject);
    procedure cbSchemaDropDown(Sender: TObject);
  private
    FedPassword: TPasswordEdit;
    FDatabaseListLoaded: boolean;
    FDBType: TDatabaseType;
    FSchemasListLoaded: boolean;
    function ListPostgreSQLSchemas(AConnectionStr: string; AList: TStrings): boolean;
    function ListPostgreSQLDatabases(AConnectionStr: string; AList: TStrings): boolean;
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
  uStrings, uDBConnect, uSQLModule;

const
  POSTGRESQL_DEFAULTPORT = 5432;

{$R *.dfm}                                                        

{ TfrPostgreSQLCfg }

function TfrPostgreSQLCfg._AddRef: Integer;
begin
   result:=-1;
end;

function TfrPostgreSQLCfg._Release: Integer;
begin
   result:=-1;
end;

function TfrPostgreSQLCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

function TfrPostgreSQLCfg.GetConnectionStrings: String;
begin
  with TStringList.Create do
  try
    Values['SERVER NAME'] := edServer.Text;
    Values['SERVER PORT'] := IntToStr(edPort.IntValue);
    Values['USER NAME'] := edUserName.Text;
    Values['PASSWORD'] := DoTheStr(FedPassword.Text);
    Values['DATABASE'] := cbDatabase.Text;
    if cbSchema.ItemIndex > 0 then
      Values['SCHEMA'] := cbSchema.Text;
    result := Text;
  finally
    Free;
  end;
end;

procedure TfrPostgreSQLCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := 0;
  AHeight := 0;
end;

function TfrPostgreSQLCfg.ListPostgreSQLDatabases(AConnectionStr: string; AList: TStrings): boolean;
var
  dbc: TDBConnection;
  sm: TSQLModule;
begin
  result := False;
  AList.Clear;
  try
    dbc := CreateAndConnectDBConnection(FDBType, AConnectionStr);
    try
      sm := dbc.GetNewSQLModule(nil);
      try
        sm.Open('SELECT datname FROM pg_database WHERE datistemplate = false');
        AList.BeginUpdate;
        try
          while not sm.EOF do
          begin
            AList.Add(sm.FieldAsString('datname'));
            sm.Next;
          end;
          result := True;
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

function TfrPostgreSQLCfg.ListPostgreSQLSchemas(AConnectionStr: string;
  AList: TStrings): boolean;
var
  dbc: TDBConnection;
  sm: TSQLModule;

begin
  result := false;
  AList.Clear;
  try
    AList.Add('(all)');
    dbc := CreateAndConnectDBConnection(FDBType, AConnectionStr);
    try
      sm := dbc.GetNewSQLModule(nil);
      try
        sm.Open('select schema_name from information_schema.schemata');
        AList.BeginUpdate;
        try
          while not sm.Eof do
          begin
            AList.Add(sm.FieldAsString('schema_name'));
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

procedure TfrPostgreSQLCfg.SetExistingConfiguration(AConfig: String);
begin
  with TStringList.Create do
  try
    Text := AConfig;
    edServer.Text := Values['SERVER NAME'];
    edPort.IntValue := StrToIntDef(Values['SERVER PORT'], POSTGRESQL_DEFAULTPORT);
    edUserName.Text := Values['USER NAME'];
    FedPassword.Text := UndoTheStr(Values['PASSWORD']);
    cbDatabase.Text := Values['DATABASE'];
  finally
    Free;
  end;
end;

procedure TfrPostgreSQLCfg.TestConButtonClick(Sender: TObject);
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

function TfrPostgreSQLCfg.PasswordIsRequired: Boolean;
begin
  Result := False;
end;

procedure TfrPostgreSQLCfg.cbDatabaseDropDown(Sender: TObject);
begin
  if not FDatabaseListLoaded then
  begin
    CheckSettings;
    FDatabaseListLoaded := ListPostgreSQLDatabases(GetConnectionStrings, cbDatabase.Items);
  end;
end;

procedure TfrPostgreSQLCfg.cbSchemaDropDown(Sender: TObject);
begin
  if not FSchemasListLoaded then
  begin
    CheckSettings;
    try
      FSchemasListLoaded := ListPostgreSQLSchemas(GetConnectionStrings, cbSchema.Items);
    finally
      cbSchema.ItemIndex := 0;
    end;
  end;
end;

procedure TfrPostgreSQLCfg.CheckSettings;
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
  end
  else if Trim(edUserName.Text) = '' then
  begin
    ShowMessage('User name not specified.');
    edUserName.SetFocus;
    Abort;
  end;
end;

procedure TfrPostgreSQLCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDBType := ADBType;
  FDatabaseListLoaded := False;
  edPort.IntValue := POSTGRESQL_DEFAULTPORT;
  edUserName.Enabled := True;

  if FedPassword = nil then
  begin
    FedPassword := TPasswordEdit.Create(Self);
    FedPassword.Parent := edUserName.Parent;
    FedPassword.Top := edUserName.Top;
    FedPassword.Left := edUserName.Left + edUserName.Width + 5;
    FedPassword.Width := edPort.Left + edPort.Width - FEdPassword.Left;
    FedPassword.Enabled := edUserName.Enabled;
    FedPassword.TabOrder := edUserName.TabOrder + 1;
  end;
end;

end.

