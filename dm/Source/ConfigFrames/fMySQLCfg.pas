unit fMySQLCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, advlued, dgConsts, dgDBTypes, Buttons, UITypes;

type
  TfrMySQLCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
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
    procedure TestConButtonClick(Sender: TObject);
    procedure cbDatabaseDropDown(Sender: TObject);
  private
    FedPassword: TPasswordEdit;
    FDatabaseListLoaded: boolean;
    FDBType: TDatabaseType;
    function ListMySQLDatabases(AConnectionStr: string; AList: TStrings): boolean;
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
  MYSQL_DEFAULTPORT = 3306;

{$R *.dfm}                                                        

{ TfrMySQLCfg }

function TfrMySQLCfg._AddRef: Integer;
begin
   result:=-1;
end;

function TfrMySQLCfg._Release: Integer;
begin
   result:=-1;
end;

function TfrMySQLCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

function TfrMySQLCfg.GetConnectionStrings: String;
begin
  with TStringList.Create do
  try
    Values['SERVER NAME'] := edServer.Text;
    Values['SERVER PORT'] := IntToStr(edPort.IntValue);
    Values['USER NAME'] := edUserName.Text;
    Values['PASSWORD'] := DoTheStr(FedPassword.Text);
    Values['DATABASE'] := cbDatabase.Text;
    result := Text;
  finally
    Free;
  end;
end;

procedure TfrMySQLCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := 0;
  AHeight := 0;
end;

function TfrMySQLCfg.ListMySQLDatabases(AConnectionStr: string; AList: TStrings): boolean;
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
        sm.Open('SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA');
        AList.BeginUpdate;
        try
          while not sm.EOF do
          begin
            AList.Add(sm.FieldAsString('SCHEMA_NAME'));
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

procedure TfrMySQLCfg.SetExistingConfiguration(AConfig: String);
begin
  with TStringList.Create do
  try
    Text := AConfig;
    edServer.Text := Values['SERVER NAME'];
    edPort.IntValue := StrToIntDef(Values['SERVER PORT'], MYSQL_DEFAULTPORT);
    edUserName.Text := Values['USER NAME'];
    FedPassword.Text := UndoTheStr(Values['PASSWORD']);
    cbDatabase.Text := Values['DATABASE'];
  finally
    Free;
  end;
end;

procedure TfrMySQLCfg.TestConButtonClick(Sender: TObject);
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

function TfrMySQLCfg.PasswordIsRequired: Boolean;
begin
  Result := False;
end;

procedure TfrMySQLCfg.cbDatabaseDropDown(Sender: TObject);
begin
  if not FDatabaseListLoaded then
  begin
    CheckSettings;
    FDatabaseListLoaded := ListMySQLDatabases(GetConnectionStrings, cbDatabase.Items);
  end;
end;

procedure TfrMySQLCfg.CheckSettings;
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

procedure TfrMySQLCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDBType := ADBType;
  FDatabaseListLoaded := False;
  edPort.IntValue := MYSQL_DEFAULTPORT;
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

