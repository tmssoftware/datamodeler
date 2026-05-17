unit uConnectionsFile;

interface

uses
  classes, SysUtils, Controls, fUserConnections, dgConsts, dgDBTypes;

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
    property ConnDBType: TDatabaseType read FDBType write FDBType;
  published
    property Name : String read FName write FName;
    property Settings: String read FSettings write FSettings;
    property ConnDBTypeID: string read GetConnDBType write SetConnDBType;
  end;

implementation

uses
  fUserConnectionEditor;

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

{ TConnectionSetting }

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

