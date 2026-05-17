unit fAbsoluteDBCfg;

{$I ../../dm.inc}

{$IFDEF ABSOLUTEDB}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, ExtCtrls,
  uDatabaseConfigFrames, dgConsts, dgDBTypes, Buttons, UITypes;

type
  TfrAbsoluteDBCfg = class(TFrame, IUnknown, IDatabaseConfigFrame)
    Panel2: TPanel;
    Label3: TLabel;
    TestConButton: TBitBtn;
    lbPassword: TLabel;
    edDatabase: TAdvFileNameEdit;
    procedure TestConButtonClick(Sender: TObject);
  private
    FedPassword: TPasswordEdit;
    FDBType: TDatabaseType;
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
  uStrings, uDBConnect;

{$R *.dfm}

{ TfrAbsoluteDBCfg }

function TfrAbsoluteDBCfg._AddRef: Integer;
begin
   result := -1;
end;

function TfrAbsoluteDBCfg._Release: Integer;
begin
   result := -1;
end;

function TfrAbsoluteDBCfg.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
   if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

procedure TfrAbsoluteDBCfg.GetRecommendedSize(var AWidth, AHeight: integer);
begin
  AWidth := Panel2.Width;
  AHeight := Panel2.Height;
end;

procedure TfrAbsoluteDBCfg.SetExistingConfiguration(AConfig: String);
var r : TStrings;
    //s : String;
begin
  r := TStringList.Create;
  try
    r.Text := AConfig;
    edDatabase.Text := r.Values[SDBO_AbsoluteDatabase];
    FedPassword.Text := UndoTheStr(r.Values[SDBO_AbsolutePassword]);
  finally
    r.Free;
  end;
end;

procedure TfrAbsoluteDBCfg.TestConButtonClick(Sender: TObject);
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

function TfrAbsoluteDBCfg.GetConnectionStrings: String;
var
  r : TStrings;
begin
  r := TStringList.Create;
  try
    r.Values[SDBO_AbsoluteDatabase] := edDatabase.Text;
    r.Values[SDBO_AbsolutePassword] := DoTheStr(FedPassword.Text);
    Result := r.Text;
  finally
    r.Free;
  end;
end;

function TfrAbsoluteDBCfg.PasswordIsRequired: Boolean;
begin
  Result := false;
end;

procedure TfrAbsoluteDBCfg.CheckSettings;
begin
  if Trim(edDatabase.Text) = '' then
  begin
    ShowMessage('Database file not specified.');
    edDatabase.SetFocus;
    Abort;
  end;
end;

procedure TfrAbsoluteDBCfg.FrameInitialization(ADBType: TDatabaseType);
begin
  edDatabase.Filter := 'Absolute Database Files (*.abs)|*.abs';

  FDBType := ADBType;
  if FEdPassword = nil then
  begin
    FEdPassword := TPasswordEdit.Create(Self);
    FEdPassword.Parent := lbPassword.Parent;
    FEdPassword.Top := lbPassword.Top + lbPassword.Height + 5;
    FEdPassword.Left := lbPassword.Left;
    FedPassword.Width := 150;
    FEdPassword.Enabled := true;
    FEdPassword.TabOrder := edDatabase.TabOrder + 1;
  end;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

