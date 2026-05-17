unit fSQLiteCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, AdvDirectoryEdit, dgConsts, dgDBTypes, Buttons,
  uDBConnect, UITypes;

type
  TfrSQLiteCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel1: TPanel;
    pnPath: TPanel;
    Label5: TLabel;
    edDatabase: TAdvFileNameEdit;
    TestConButton: TBitBtn;
    cbCreateFile: TCheckBox;
    procedure TestConButtonClick(Sender: TObject);
  private
    FDBType: TDatabaseType;
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
  uStrings, IOUtils;

{$R *.dfm}

function TfrSQLiteCfg._AddRef: Integer;
begin
  Result := -1;
end;

function TfrSQLiteCfg._Release: Integer;
begin
  Result := -1;
end;

function TfrSQLiteCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

function TfrSQLiteCfg.GetConnectionStrings: String;
var
  r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Values[SDBO_SQLiteDatabase] := edDatabase.FileName;
    if cbCreateFile.Checked then
      r.Values[SDBO_SQLiteCreateFile] := 'TRUE'
    else
      r.Values[SDBO_SQLiteCreateFile] := 'FALSE';
    Result := r.Text;
  finally
    r.Free;
  end;
end;

procedure TfrSQLiteCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := Panel1.Width;
  AHeight := Panel1.Height;
end;

procedure TfrSQLiteCfg.SetExistingConfiguration(AConfig: String);
var
  r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    edDatabase.Text := r.Values[SDBO_SQLiteDatabase];
    cbCreateFile.Checked := not SameText(r.Values[SDBO_SQLiteCreateFile], 'FALSE');
  finally
    r.Free;
  end;
end;

procedure TfrSQLiteCfg.TestConButtonClick(Sender: TObject);
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

function TfrSQLiteCfg.PasswordIsRequired: Boolean;
begin
  Result := false;
end;

procedure TfrSQLiteCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  FDBType := ADBType;
  edDatabase.Text := '';
end;

procedure TfrSQLiteCfg.CheckSettings;
begin
  if Trim(edDatabase.Text) = '' then
  begin
    ShowMessage('Please specify the database file');
    edDatabase.SetFocus;
    Abort;
  end;
  if TPath.HasValidFileNameChars(edDatabase.Text, false) then
  begin
    ShowMessage('Invalid database file.');
    edDatabase.SetFocus;
    Abort;
  end;
  if not TDirectory.Exists(TPath.GetDirectoryName(edDatabase.Text)) then
  begin
    ShowMessage('Database file directory does not exist.');
    edDatabase.SetFocus;
    Abort;
  end;
end;

end.

