unit fSQLAzureCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AdvEdit, AdvEdBtn, uDatabaseConfigFrames,
  AdvFileNameEdit, dgConsts, Buttons, uSQLModule, dgDBTypes, UITypes;

type
  TfrSQLAzureCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    edServerName: TEdit;
    cbDatabase: TComboBox;
    TestConButton: TBitBtn;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edUserName: TEdit;
    Label5: TLabel;
    procedure TestConButtonClick(Sender: TObject);
    procedure cbDatabaseDropDown(Sender: TObject);
  private
    FDBType: TDatabaseType;
    FDatabaseListLoaded: boolean;
    FedPassword: TPasswordEdit;
    function QueryInterface(const IID: TGUID; out Obj):HRESULT; reintroduce; stdcall;
    function _AddRef: Integer; stdcall;
    procedure FrameInitialization(ADBType: TDatabaseType);
    function _Release: Integer; stdcall;
    function DatabasesOnSQLServer(ConnStr: string; Databases: TStrings): boolean;
  public
    function GetConnectionStrings: String;
    procedure SetExistingConfiguration(AConfig: String);
    function PasswordIsRequired: Boolean;
    procedure CheckSettings;
    procedure GetRecommendedSize(var AWidth, AHeight: integer);
  end;

implementation

uses
  DB, ADODB, ActiveX, ComObj, AdoInt, OleDB, uStrings, uDBConnect;

{$R *.dfm}

{ TfrSQLAzureCfg }

function TfrSQLAzureCfg.DatabasesOnSQLServer(ConnStr: string; Databases : TStrings): boolean;
var
  dbc: TDBConnection;
  sm: TSQLModule;
begin
  result := false;
  Databases.Clear;
  try
    dbc := CreateAndConnectDBConnection(FDBType, ConnStr);
    try
      sm := dbc.GetNewSQLModule(nil);
      Databases.BeginUpdate;
      try
        sm.Open('select name from sys.databases');
        while not sm.EOF do
        begin
          Databases.Add(sm.FieldAsString('name'));
          sm.Next;
        end;
        result := true;
      finally
        sm.Free;
        Databases.EndUpdate;
      end;
    finally
      dbc.Free;
    end;
  except
    on e:exception do
      MessageDlg(e.Message,mtError, [mbOK],0);
  end;
end;

function TfrSQLAzureCfg._AddRef: Integer;
begin
  Result := -1;
end;

function TfrSQLAzureCfg._Release: Integer;
begin
  Result := -1;
end;

procedure TfrSQLAzureCfg.cbDatabaseDropDown(Sender: TObject);
begin
  if not FDatabaseListLoaded then
    FDatabaseListLoaded := DatabasesOnSQLServer(GetConnectionStrings, cbDatabase.Items);
end;

procedure TfrSQLAzureCfg.CheckSettings;
begin
  if Trim(edServerName.Text) = '' then
  begin
    ShowMessage('Server name not specified.');
    edServerName.SetFocus;
    Abort;
  end else
  if Trim(cbDatabase.Text) = '' then
  begin
    ShowMessage('Database name not specified.');
    cbDatabase.SetFocus;
    Abort;
  end
  else if Trim(edUserName.Text) = '' then
  begin
    ShowMessage('User name not specified.');
    edUserName.SetFocus;
    Abort;
  end
  else if Trim(FedPassword.Text) = '' then
  begin
    ShowMessage('Password not specified.');
    FedPassword.SetFocus;
    Abort;
  end;
end;

procedure TfrSQLAzureCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDatabaseListLoaded := false;
  FDBType := ADBType;
  if FEdPassword = nil then
  begin
    FEdPassword := TPasswordEdit.Create(Self);
    FEdPassword.Parent := edUserName.Parent;
    FEdPassword.Top := edUserName.Top;
    FedPassword.Width := edUserName.Width;
    FEdPassword.Left := edUserName.Left + edUserName.Width + 5;
    FEdPassword.Enabled := edUserName.Enabled;
  end;
end;

function TfrSQLAzureCfg.QueryInterface(const IID: TGUID;
  out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

function TfrSQLAzureCfg.GetConnectionStrings: String;
var
  r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Values['SERVER NAME'] := edServerName.Text;
    r.Values['DATABASE NAME'] := cbDatabase.Text;
    r.Values['USER NAME'] := edUserName.Text;
    r.Values['PASSWORD'] := DoTheStr(FedPassword.Text);
    result := r.Text;
  finally
    r.Free;
  end;
end;

procedure TfrSQLAzureCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := Panel2.Width;
  AHeight := Panel2.Height;
end;

function TfrSQLAzureCfg.PasswordIsRequired: Boolean;
begin
  result := false;
end;

procedure TfrSQLAzureCfg.SetExistingConfiguration(AConfig: String);
var
  r: TStrings;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    edServerName.Text := r.Values['SERVER NAME'];
    cbDatabase.Text := r.Values['DATABASE NAME'];
    edUserName.Text := r.Values['USER NAME'];
    FedPassword.Text := UndoTheStr(r.Values['PASSWORD']);
  finally
    r.Free;
  end;
end;

procedure TfrSQLAzureCfg.TestConButtonClick(Sender: TObject);
var
  ATest: TDBConnection;
begin
  if edServerName.Text = '' then
  begin
    MessageDlg('Server name cannot be empty.', mtWarning, [mbOK],0);
    Exit;
  end;
  if cbDatabase.Text = '' then
  begin
    MessageDlg('Database name cannot be empty.', mtWarning, [mbOK],0);
    Exit;
  end;

  try
    ATest := CreateAndConnectDBConnection(FDBType, GetConnectionStrings);
    ATest.Free;
    MessageDlg('Connection successful!', mtInformation, [mbOK], 0);
  except
    on e:exception do
      MessageDlg(e.Message, mtError, [mbOK],0);
  end;
end;

end.

