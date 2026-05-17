unit uAppMetaData;

interface

uses
  Classes, Variants, Windows, SysUtils, DB, TypInfo, Controls, Forms, Menus, ComCtrls, Dialogs,
  uStrings, uGDAO,
  uGDAODiagrams,
  dgConsts, dgBase, dgCompare, dgDBTypes;

type
  TAppMetaData = class;

  TVersionControl = class;
  TVersion = class;

  TAppMetaData = class(TBaseAppMetaData)
  private
    FAMDFileVersion           : string;  // application version (updated by the builder or at runtime)
    FAppCaseToolVersion       : string;  // version of the builder that generated the application (updated by the builder or at runtime)
    { Aggregated objects }
    FDataDictionary           : TGDAODatabase;     // data dictionary object
    { internal }
    FModified                 : boolean;
    FOnModify                 : TNotifyEvent;
    FVersionControl           : TVersionControl;
    FDiagramObj               : TGDAODiagramsObject;
    FAutoVersionControl       : boolean;
    FFileNAme: string;
    FSavingVersionArchive: boolean;
    FOnPerformMessage: TMessageEvent;
    FAureliusExportOptions: string; // automatic version control when connecting to the database
    procedure SetOnModify(const Value: TNotifyEvent);
    procedure SetDataDictionary(const Value: TGDAODatabase);
    procedure SetDiagramObj(const Value: TGDAODiagramsObject);
    procedure SetVersionControl(const Value: TVersionControl);
    function IsPropertyStored: Boolean;
    procedure InternalSaveToFile(AFileName: string; IsVersionArchive: boolean);
  protected
    procedure Loaded; override;

    {function SyncronizeMetaData(AMetaDataRef: TAppMetaData; AVersionsComp: TComponent=nil;
     AShowResult: boolean=true): boolean;}

    //function SyncronizeMetaDataFile(AFileName: string; AShowResult: boolean=true): boolean;
    property AMDFileVersion:string read FAMDFileVersion write FAMDFileVersion;
    property AppCaseToolVersion:string read FAppCaseToolVersion write FAppCaseToolVersion;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    class function LoadFromFile(AFileName: string): TAppMetaData;
    procedure SaveToFile( AFileName:string);

    procedure PerformMessage(Msg: Cardinal; wParam: integer = 0; lParam: integer = 0);

    function GetVersionControlPath: String;
    procedure DesignTimeChange(Sender:TObject);
    function CloseLastVersion(AInfo: string; ATimeStamp: TDateTime=0): boolean;
    procedure AddFirstVersion;
    property OnModify: TNotifyEvent read FOnModify write SetOnModify;
    property OnPerformMessage: TMessageEvent read FOnPerformMessage write FOnPerformMessage;
    property Modified: boolean read FModified default false;
    property FileName: string read FFileName write FFileName;
 published
    property VersionControl: TVersionControl read FVersionControl write SetVersionControl stored IsPropertyStored;
    property DataDictionary: TGDAODatabase read FDataDictionary write SetDataDictionary;
    property DiagramObj: TGDAODiagramsObject read FDiagramObj write SetDiagramObj;
    property AureliusExportOptions: string read FAureliusExportOptions write FAureliusExportOptions;
 end;

  TVersionControl = class(TBaseVersionControl)
  private
    FAMD: TAppMetaData;
    function GetItem(i: integer): TVersion;
    procedure SetItem(i: integer; const Value: TVersion);
    procedure New_GetDictionaryFromVersion(AVersion: TVersion;
      ADictionary: TGDAODatabase);
  public
    constructor Create(AAMD: TAppMetaData);
    procedure GetDictionaryFromVersion(AVersion: TVersion; ADictionary: TGDAODatabase);
    function Add: TVersion;
    function CloseLastVersion(APath: string): boolean;
    function GetLastVersion : TVersion;
    function GetNextVersionID: Integer;
    function HasVersions: Boolean;
    function IndexOf(AVersion: TVersion): integer;
    procedure RemoveVersion(AVersion: TVersion);
    procedure RestoreVersion(AVersion: TVersion);
    property AMD: TAppMetaData read FAMD;
    property Items[i: integer]: TVersion read GetItem write SetItem; default;
  end;

  TVersion = class(TBaseVersion)
  private
    function GetVersionControl: TVersionControl;
    function GetAbsoluteFileName: string;
  public
    function IsCurrentVersion: boolean;
    property VersionControl: TVersionControl read GetVersionControl;
    property AbsoluteFileName: string read GetAbsoluteFileName;
  end;

implementation

uses
  uDataTypeConversion, uDBProperties;

{ TAppMetaData }

constructor TAppMetaData.Create(AOwner: TComponent);
begin
   FAutoVersionControl:=false;
   inherited Create(AOwner);
   Name:='AppMetaData';

   FDataDictionary:=TGDAODatabase.Create(self);
   FVersionControl := TVersionControl.Create(Self);
   { diagram }
   FDiagramObj := TGDAODiagramsObject.Create;
   FDiagramObj.GDD := DataDictionary;
   VersionControlPath := '%projectdir%\versions';
end;

destructor TAppMetaData.Destroy;
begin
   if Assigned(FDataDictionary) then FDataDictionary.Free;
   if Assigned(FVersionControl) then FVersionControl.Free;
   if Assigned(FDiagramObj) then FDiagramObj.Free;
   inherited;
end;

procedure TAppMetaData.DesignTimeChange(Sender: TObject);
begin
   if not (csReading in ComponentState) then
   begin
      FModified:=true;
      if Assigned(FOnModify) then
         FOnModify(Sender);
   end;
end;

procedure TAppMetaData.AddFirstVersion;
begin
  with FVersionControl.Add do
  begin
    VersionID   := 1;
    DateTime    := now;
  end;
end;

function TAppMetaData.CloseLastVersion(AInfo: String; ATimeStamp: TDateTime): boolean;
var nextid : Integer;
begin
  // closing current version
  with VersionControl.GetLastVersion do
  begin
    Information := AInfo;
    if ATimeStamp > 0 then
      CloseDate := ATimeStamp
    else
      CloseDate := Now;
  end;
  Result := VersionControl.CloseLastVersion(GetVersionControlPath);
  // adding another version
  nextid := VersionControl.GetNextVersionID;
  with VersionControl.Add do
  begin
    VersionID   := NextId;
    DateTime    := Now;
  end;
end;

class function TAppMetaData.LoadFromFile(AFileName: string): TAppMetaData;
begin
  result := TAppMetaData.Create(nil);
  try
    result.FModified := false;
    try
      ReadComponentResFileText(AFileName, result);
//      Result.DataDictionary.RecreateIds;
      result.FileName := AFileName;
    except
      on e: Exception do
        raise EGUIException.Create(
          Format('The file "%s" is not a valid Data Modeler project file.'#13#10+
          'Internal error: %s',
            [ExtractFileName(AFileName), e.Message]));
    end;
    TDBProperties.AllocObjectCategories(result.DataDictionary);
  except
    result.Free;
    raise;
  end;
end;

procedure TAppMetaData.PerformMessage(Msg: Cardinal;
  wParam: integer = 0; lParam: integer = 0);
var
  AMsg: tagMsg;
  AHandled: boolean;
begin
  if Assigned(FOnPerformMessage) then
  begin
    AMsg.message := Msg;
    AMsg.wParam := wParam;
    AMsg.lParam := lParam;
    FOnPerformMessage(AMsg, AHandled);
  end;
end;

procedure TAppMetaData.Loaded;
begin
  inherited;
  DataDictionary.Loaded;
end;

procedure TAppMetaData.SetDataDictionary(const Value: TGDAODatabase);
begin
  TDBProperties.CopyDictionary(Value, FDataDictionary);
end;

procedure TAppMetaData.SetOnModify(const Value: TNotifyEvent);
begin
  FOnModify := Value;
end;

procedure TAppMetaData.SetDiagramObj(const Value: TGDAODiagramsObject);
begin
  FDiagramObj.Assign(Value);
end;

procedure TAppMetaData.SetVersionControl(const Value: TVersionControl);
begin
  FVersionControl.Assign(Value);
end;

function TAppMetaData.GetVersionControlPath: String;
var project_dir: string;
begin
  project_dir := '';
  if FileName > '' then
  begin
    project_dir := ExtractFilePath(FileName);
    if project_dir[length(project_dir)] = '\' then
        delete(project_dir, length(project_dir), 1);
  end;
  Result := LowerCase(VersionControlPath);
  if pos('%projectdir%', Result) > 0 then
    Result := ReplaceStr(Result, '%projectdir%', project_dir);
end;

procedure TAppMetaData.InternalSaveToFile(AFileName: string; IsVersionArchive: boolean);
begin
  FSavingVersionArchive := IsVersionArchive;
  try
    WriteComponentResFileText(AFileName, self);
  finally
    FSavingVersionArchive := false;
  end;
end;

function TAppMetaData.IsPropertyStored: Boolean;
begin
  result := not FSavingVersionArchive;
end;

procedure TAppMetaData.SaveToFile(AFileName: string);
begin
  InternalSaveToFile(AFileName, false);
  FileName := AFileName;
end;                                  

{ TVersionControl }

function TVersionControl.CloseLastVersion(APath: string): Boolean;
begin
  try
    ForceDirectories(APath);
    GetLastVersion.FileName := ChangeFileExt(ExtractFileName(FAMD.FileName), Format('.%d',[GetLastVersion.VersionID]));
    FAMD.InternalSaveToFile(GetLastVersion.AbsoluteFileName, true); 
    Result := true;
  except
    Result := false;
  end;
end;

function TVersionControl.HasVersions: Boolean;
begin
  Result := (Count > 0);
end;

function TVersionControl.IndexOf(AVersion: TVersion): integer;
begin
  for result := 0 to Count - 1 do
    if AVersion=Items[result] then
      exit;
  result := -1;
end;

procedure TVersionControl.RemoveVersion(AVersion: TVersion);
begin
  if IndexOf(AVersion) >= 0 then
  begin
    if FileExists(AVersion.AbsoluteFileName) then
      DeleteFile(AVersion.AbsoluteFileName);
    Delete(IndexOf(AVersion));
  end;
end;

procedure TVersionControl.RestoreVersion(AVersion: TVersion);
var
  _AMD: TAppMetaData;
begin
  FAMD.PerformMessage(WM_DM_CLOSEEXPLORERITEMS);
  _AMD := TAppMetaData.LoadFromFile(AVersion.AbsoluteFileName);
  try
    TDBProperties.CopyDictionary(_AMD.DataDictionary, FAMD.DataDictionary);
    FAMD.DiagramObj.Assign(_AMD.DiagramObj);
    FAMD.PrjName := _AMD.PrjName;
    FAMD.PrjAuthor := _AMD.PrjAuthor;
    FAMD.PrjDescription := _AMD.PrjDescription;
    FAMD.VersionControlPath := _AMD.VersionControlPath;
    FAMD.UserOptions.Assign(_AMD.UserOptions);
  finally
    _AMD.Free;
  end;
end;

function TVersionControl.Add: TVersion;
begin
  Result := TVersion(inherited Add);
end;

constructor TVersionControl.Create(AAMD: TAppMetaData);
begin
  FAMD := AAMD;
  inherited Create(TVersion);
end;

procedure TVersionControl.New_GetDictionaryFromVersion(AVersion: TVersion;
  ADictionary: TGDAODatabase);
var
  _AMD: TAppMetaData;
begin
  //try
    _AMD := TAppMetaData.LoadFromFile(AVersion.AbsoluteFileName);
    try
      TDBProperties.CopyDictionary(_AMD.DataDictionary, ADictionary);
    finally
      _AMD.Free;
    end;
  {except
    on e: Exception do
      raise EGUIException.Create(
        Format('Could not load internal version file'#13#10'File name: "%s"'#13#10+
        'Internal error: %s',
          [AVersion.AbsoluteFileName, e.Message]));
  end;}
end;

procedure TVersionControl.GetDictionaryFromVersion(AVersion: TVersion;
  ADictionary: TGDAODatabase);
begin
    New_GetDictionaryFromVersion(AVersion, ADictionary)
end;

function TVersionControl.GetItem(i: integer): TVersion;
begin
  Result := TVersion(inherited Items[i]);
end;

function TVersionControl.GetLastVersion: TVersion;
begin
  Result := nil;
  if Count > 0 then
    Result := Items[Count-1];
end;

procedure TVersionControl.SetItem(i: integer; const Value: TVersion);
begin
  Items[i].Assign(Value);
end;

function TVersionControl.GetNextVersionID: Integer;
begin
  Result := 1;
  if GetLastVersion <> nil then
    Result := GetLastVersion.VersionID+1;
end;

{ TVersion }

function TVersion.GetAbsoluteFileName: string;
begin
  if (FileName > '') and IsPathRelative(FileName) then
    result := AddPathDelim(VersionControl.AMD.GetVersionControlPath) + FileName
  else
    result := FileName;
end;

function TVersion.GetVersionControl: TVersionControl;
begin
  result := TVersionControl(Collection);
end;

function TVersion.IsCurrentVersion: Boolean;
begin
  result := (TVersionControl(Collection).GetLastVersion = self);
end;

end.

