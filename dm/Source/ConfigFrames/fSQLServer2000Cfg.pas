unit fSQLServer2000Cfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AdvEdit, AdvEdBtn, uDatabaseConfigFrames,
  AdvFileNameEdit, dgConsts, Buttons, uSQLModule, dgDBTypes, UITypes,
  FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, Vcl.ComCtrls;

type
  TfrSQLServer2000Cfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    cboServers: TComboBox;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    rbIntegratedSecurity: TRadioButton;
    rbLoginInfo: TRadioButton;
    edUserName: TEdit;
    cboDatabases: TComboBox;
    TestConButton: TBitBtn;
    TabSheet2: TTabSheet;
    cbODBCDriver: TComboBox;
    Label2: TLabel;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    Label6: TLabel;
    edOdbcAdvanced: TEdit;
    procedure rbLoginInfoClick(Sender: TObject);
    procedure rbIntegratedSecurityClick(Sender: TObject);
    procedure cboServersClick(Sender: TObject);
    procedure TestConButtonClick(Sender: TObject);
    procedure cboServersDropDown(Sender: TObject);
    procedure cboDatabasesDropDown(Sender: TObject);
    procedure cbODBCDriverDropDown(Sender: TObject);
  private
    FDBType: TDatabaseType;
    FServerListLoaded: boolean;
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
  DB, ADODB, ActiveX, ComObj, AdoInt, OleDB, uStrings, uDatasetModule, uDBConnect;

{$R *.dfm}

{ TfrSQLServer2000Cfg }

procedure InternalListAvailableSQLServers(AEnumerator: string; Names : TStrings);
{$IFDEF WIN32}
var
  RSCon: ADORecordsetConstruction;
  Rowset: IRowset;
  SourcesRowset: ISourcesRowset;
  SourcesRecordset: _Recordset;
  SourcesName, SourcesType: TField;

  function PtCreateADOObject(const ClassID: TGUID): IUnknown;
  var
    Status: HResult;
    FPUControlWord: Word;
  begin
    asm
      FNSTCW FPUControlWord
    end;
    Status := CoCreateInstance(
      CLASS_Recordset,
      nil,
      CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
      IUnknown,
      Result);
    asm
      FNCLEX
      FLDCW FPUControlWord
    end;
    OleCheck(Status);
  end;
{$ENDIF}

begin
  Names.Clear;
{$IFDEF WIN32}
  try
    SourcesRecordset := PtCreateADOObject(CLASS_Recordset) as _Recordset;
    RSCon := SourcesRecordset as ADORecordsetConstruction;
    SourcesRowset := CreateComObject(ProgIDToClassID(AEnumerator)) as ISourcesRowset;
    OleCheck(SourcesRowset.GetSourcesRowset(nil, IRowset, 0, nil, IUnknown(Rowset)));
    RSCon.Rowset := RowSet;
    with TADODataSet.Create(nil) do
    try
      Recordset := SourcesRecordset;
      SourcesName := FieldByName('SOURCES_NAME'); { do not localize }
      SourcesType := FieldByName('SOURCES_TYPE'); { do not localize }
      Names.BeginUpdate;
      try
        while not EOF do
        begin
          if (SourcesType.AsInteger = DBSOURCETYPE_DATASOURCE) and (SourcesName.AsString <> '') then
            Names.Add(SourcesName.AsString);
          Next;
        end;
      finally
        Names.EndUpdate;
      end;
    finally
      Free;
    end;
  except
    //hide any sys errors
  end;
{$ENDIF}
end;

procedure ListAvailableSQLServers(Names : TStrings);
begin
  Names.Clear;
  InternalListAvailableSQLServers('SQLNCLI Enumerator', Names);
  if Names.Count = 0 then
    InternalListAvailableSQLServers('SQLOLEDB Enumerator', Names);
end;

type
  TInternalSQLModule = class(TSQLModule)
  end;

function TfrSQLServer2000Cfg.DatabasesOnSQLServer(ConnStr: string; Databases : TStrings): boolean;
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
        sm.Open('sp_databases');
        while not sm.EOF do
        begin
          Databases.Add(TDatasetModule(sm).Dataset.Fields[0].AsString);
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

function TfrSQLServer2000Cfg._AddRef: Integer;
begin
  Result := -1;
end;

function TfrSQLServer2000Cfg._Release: Integer;
begin
  Result := -1;
end;

procedure TfrSQLServer2000Cfg.cboDatabasesDropDown(Sender: TObject);
begin
  if not FDatabaseListLoaded then
  begin
    FDatabaseListLoaded := DatabasesOnSQLServer(GetConnectionStrings, cboDatabases.Items);
  end;
end;

procedure TfrSQLServer2000Cfg.cbODBCDriverDropDown(Sender: TObject);
begin
  FDPhysMSSQLDriverLink1.GetDrivers(cbODBCDriver.Items);
end;

procedure TfrSQLServer2000Cfg.cboServersClick(Sender: TObject);
begin
  FDatabaseListLoaded := false;
end;

procedure TfrSQLServer2000Cfg.cboServersDropDown(Sender: TObject);
begin
  if not FServerListLoaded then
  begin
    ListAvailableSQLServers(cboServers.Items);
    FServerListLoaded := true;
  end;
end;

procedure TfrSQLServer2000Cfg.CheckSettings;
begin
  if Trim(cboServers.Text) = '' then
  begin
    ShowMessage('Server name not specified.');
    cboServers.SetFocus;
    Abort;
  end else
  if Trim(cboDatabases.Text) = '' then
  begin
    ShowMessage('Database name not specified.');
    cboDatabases.SetFocus;
    Abort;
  end else
  if rbLoginInfo.Checked then
  begin
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
    end;

  end;
end;

procedure TfrSQLServer2000Cfg.FrameInitialization(ADBType: TDatabaseType);
begin
  cboServers.Items.Clear;
  cbODBCDriver.Items.Clear;
  edOdbcAdvanced.Text := '';
  FServerListLoaded := false;
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

function TfrSQLServer2000Cfg.QueryInterface(const IID: TGUID;
  out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

procedure TfrSQLServer2000Cfg.rbIntegratedSecurityClick(Sender: TObject);
begin
  edUserName.Enabled := false;
  FedPassword.Enabled := false;
end;

procedure TfrSQLServer2000Cfg.rbLoginInfoClick(Sender: TObject);
begin
  edUserName.Enabled := true;
  FedPassword.Enabled := true;
end;

function TfrSQLServer2000Cfg.GetConnectionStrings: String;
var
  r : TStrings;
begin
  r := TSTringList.Create;
  try
    r.Values['SERVER NAME'] := cboServers.Text;
    r.Values['DATABASE NAME'] := cboDatabases.Text;
    //r.Values['REMOTE DATABASE'] := cboServers.Text + ':' + cboDatabases.Text;
    r.Values['USER NAME'] := edUserName.Text;
    r.Values['PASSWORD'] := DoTheStr(FedPassword.Text);
    if rbIntegratedSecurity.Checked then
      r.Values['INTEGRATED SECURITY'] := 'TRUE'
    else
      r.Values['INTEGRATED SECURITY'] := 'FALSE';
    r.Values['ODBC DRIVER'] := cbODBCDriver.Text;
    r.Values['ODBC ADVANCED'] := edOdbcAdvanced.Text;
    Result := r.Text;
  finally
    r.Free;
  end;
end;

procedure TfrSQLServer2000Cfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := PageControl1.Width;
  AHeight := PageControl1.Height;
end;

function TfrSQLServer2000Cfg.PasswordIsRequired: Boolean;
begin
  Result := false;
end;

procedure TfrSQLServer2000Cfg.SetExistingConfiguration(AConfig: String);
var r : TStrings;
    //s : String;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    //s := r.Values['REMOTE DATABASE'];
    //edServerName.Text := copy(s, 1, pos(':', s));
    //edDatabase.Text := trim(copy(s, pos(':', s)+1, length(s)));
    cboServers.Text := r.Values['SERVER NAME'];
    cboDatabases.Text := r.Values['DATABASE NAME'];
    edUserName.Text := r.Values['USER NAME'];
    FedPassword.Text := UndoTheStr(r.Values['PASSWORD']);
    cbODBCDriver.Text := r.Values['ODBC DRIVER'];
    edOdbcAdvanced.Text := r.Values['ODBC ADVANCED'];
    if SameText(r.Values['INTEGRATED SECURITY'], 'FALSE') then
      rbLoginInfo.Checked := true
    else
      rbIntegratedSecurity.Checked := true;
  finally
    r.Free;
  end;
end;

procedure TfrSQLServer2000Cfg.TestConButtonClick(Sender: TObject);
var
  ATest: TDBConnection;
begin
  if cboServers.Text = '' then
  begin
    MessageDlg('Server name cannot be empty.', mtWarning, [mbOK],0);
    Exit;
  end;
  if cboDatabases.Text = '' then
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

