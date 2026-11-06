unit uConnectionsFile;

interface

uses
  classes, SysUtils, Controls, fUserConnections, dgConsts, dgDBTypes;

const
  {Project user option (TAppMetaData.UserOptions) holding the name of the user
   connection used by "Resync structure from database"}
  SResyncConnectionOption = 'DBResync_ConnectionName';

type
  TConnectionSetting  = class;
  TConnectionsList    = class;

  TConnectionsFile = class(TComponent)
  private
    FList : TConnectionsList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ManageConnectionsDlg;

    {Lets the user pick a connection of database type ADBType (all types when nil);
     connections can be created/edited through the connections manager.
     AName is the initial selection and returns the picked connection name}
    function SelectConnectionDlg(ADBType: TDatabaseType; var AName: string): boolean;
  published
    property List : TConnectionsList read FList write FList;
  end;

  TConnectionsList    = class(TCollection)
  private
    function GetItem(i: integer): TConnectionSetting;
    procedure SetItem(i: integer; const Value: TConnectionSetting);
  public
    constructor Create;
    function Add: TConnectionSetting;
    function IndexOf(AName: string): integer;
    property Items[i: integer]: TConnectionSetting read GetItem write SetItem; default;
  end;

  TConnectionSetting  = class(TCollectionItem)
  private
    FName     : String;
    FSettings : String;
    FDBType   : TDatabaseType;
    function GetConnDBType: string;
    procedure SetConnDBType(const Value: string);
  public
    function PasswordIsRequired: Boolean;
    function EditSettingDlg: Boolean;

    {Returns the connection string in AConnectStr; asks for user name and password
     when the connection does not store the password. False when cancelled}
    function ConnectionStringDlg(var AConnectStr: string): boolean;
    property ConnDBType: TDatabaseType read FDBType write FDBType;
  published
    property Name : String read FName write FName;
    property Settings: String read FSettings write FSettings;
    property ConnDBTypeID: string read GetConnDBType write SetConnDBType;
  end;

implementation

uses
  Forms, StdCtrls, Dialogs, UITypes, fUserConnectionEditor;

{ TConnectionsList }

function TConnectionsList.Add: TConnectionSetting;
begin
  Result := TConnectionSetting(inherited Add);
end;

constructor TConnectionsList.Create;
begin
  inherited Create(TConnectionSetting);
end;

function TConnectionsList.GetItem(i: integer): TConnectionSetting;
begin
  Result := TConnectionSetting(inherited Items[i]);
end;

function TConnectionsList.IndexOf(AName: string): integer;
begin
  for result:=0 to Count-1 do
    if SameText(Items[result].Name, AName) then
      exit;
  result := -1;
end;

procedure TConnectionsList.SetItem(i: integer;const Value: TConnectionSetting);
begin
  Items[i].Assign(Value);
end;

{ TConnectionsFile }

constructor TConnectionsFile.Create(AOwner: TComponent);
begin
  inherited;
    FList := TConnectionsList.Create;
end;

destructor TConnectionsFile.Destroy;
begin
  FList.Free;
  inherited;
end;

{ TConnectionsFile }

procedure TConnectionsFile.ManageConnectionsDlg;
begin
  with TfmUserConnections.Create(nil) do
  try
    ShowModal;
  finally
    free;
  end;
end;

function TConnectionsFile.SelectConnectionDlg(ADBType: TDatabaseType; var AName: string): boolean;
var
  form: TForm;
  combo: TComboBox;
  i, res: integer;

  procedure AddButton(const ACaption: string; ALeft, AWidth: integer; AResult: TModalResult);
  begin
    with TButton.Create(form) do
    begin
      Parent := form;
      Caption := ACaption;
      SetBounds(ALeft, 72, AWidth, 25);
      ModalResult := AResult;
      Default := AResult = mrOk;
      Cancel := AResult = mrCancel;
    end;
  end;

begin
  result := false;
  form := TForm.CreateNew(nil);
  try
    form.Caption := 'Select database connection';
    form.BorderStyle := bsDialog;
    form.Position := poScreenCenter;
    form.ClientWidth := 400;
    form.ClientHeight := 110;
    with TLabel.Create(form) do
    begin
      Parent := form;
      SetBounds(12, 12, 376, 15);
      Caption := 'Connection to the database of this project:';
    end;
    combo := TComboBox.Create(form);
    combo.Parent := form;
    combo.Style := csDropDownList;
    combo.SetBounds(12, 32, 376, 23);
    AddButton('&Manage connections...', 12, 140, mrRetry);
    AddButton('OK', 222, 80, mrOk);
    AddButton('Cancel', 308, 80, mrCancel);

    repeat
      combo.Items.Clear;
      for i := 0 to FList.Count - 1 do
        if (ADBType = nil) or (FList[i].ConnDBType = ADBType) then
          combo.Items.Add(FList[i].Name);
      combo.ItemIndex := combo.Items.IndexOf(AName);
      if (combo.ItemIndex < 0) and (combo.Items.Count > 0) then
        combo.ItemIndex := 0;

      res := form.ShowModal;
      if res = mrRetry then
        ManageConnectionsDlg
      else if (res = mrOk) and (combo.ItemIndex >= 0) then
      begin
        AName := combo.Items[combo.ItemIndex];
        result := true;
      end;
    until res <> mrRetry;
  finally
    form.Free;
  end;
end;

{ TConnectionSetting }

function TConnectionSetting.ConnectionStringDlg(var AConnectStr: string): boolean;
var
  s: TStringList;
  values: array[0..1] of string;
begin
  s := TStringList.Create;
  try
    s.Text := Settings;
    result := true;
    if PasswordIsRequired then
    begin
      values[0] := s.Values[vConnectionStr_UserNameValue];
      values[1] := '';
      // a prompt starting with #31 is shown as a password edit
      result := InputQuery(Format('Connection "%s"', [Name]),
        ['User name', #31'Password'], values);
      if result then
      begin
        s.Values[vConnectionStr_UserNameValue] := values[0];
        s.Values[vConnectionStr_PasswordValue] := values[1];
      end;
    end;
    AConnectStr := s.Text;
  finally
    s.Free;
  end;
end;

function TConnectionSetting.EditSettingDlg: Boolean;
var frm : TfmUserConnectionEditor;
begin
  frm := TfmUserConnectionEditor.Create(nil);
  try
    frm.SelectedSetting := self;
    Result := (frm.ShowModal = mrOk);
    if Result then
      Settings := frm.GetConnectionString;
  finally
    frm.free;
  end;
end;

function TConnectionSetting.GetConnDBType: string;
begin
  if Assigned(FDBType) then
    result := FDBType.DatabaseTypeID
  else
    result := '';
end;

function TConnectionSetting.PasswordIsRequired: Boolean;
var s : TStrings;
    idx : Integer;
begin
  s := TStringList.Create;
  try
    s.Text := FSettings;
    idx    := s.IndexOfName(vConnectionStr_PasswordValue);
    if idx > -1 then
      Result := (trim(s.ValueFromIndex[idx]) = '')
    else
      Result := false;
  finally
    s.Free;
  end;
end;

procedure TConnectionSetting.SetConnDBType(const Value: string);
begin
  FDBType := DatabaseTypes.FindByID(Value);
end;

end.

