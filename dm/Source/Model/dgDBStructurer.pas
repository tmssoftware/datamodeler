unit dgDBStructurer;

{$I ../../dm.inc}

interface

uses
  SysUtils, DB, Classes, uGDAO, dgBase, dgConsts, dgDBTypes, Contnrs;

type
  TDBStructurer = class;
  TatDBAction = class;
  TSQLScriptFilter = class;

  TCreatingObject = (coTable, coField);

  TBeforeExecuteActionEvent = procedure(Action: TatDBAction; var Continue: boolean; Script: TStrings) of object;
  TAfterExecuteActionEvent = procedure(Action: TatDBAction; Script: TStrings) of object;

  TBeforeRemoveIndexEvent = procedure(AIndexName: string; var CanRemove: boolean) of object;

  TExecuteSQLEvent = procedure(ASQL: string) of object;

  TatDBActionList = class(TObjectList);

  TSQLScriptFilterItem = (
    fiNone,
    fiTable,
    {fiField,} fiIndex, {fiConstraint,}
    fiRelationship, fiTrigger, fiObject,
    fiDomain,
    fiComments);

  TSQLScriptFilterItems = set of TSQLScriptFilterItem;

  TDBStructurer = class
  private
    FCheckForExistingObjects: boolean;
    FScript: TStrings;
    FUserName: string;
    FCurrentStep: integer;
    FLastStep: integer;
    FBeforeExecuteAction: TBeforeExecuteActionEvent;
    FAfterExecuteAction: TAfterExecuteActionEvent;
    FDBType: TDatabaseType;
    FOnExecuteSQL: TExecuteSQLEvent;
    procedure DoBeforeExecuteAction(Action: TatDBAction; var Continue: boolean; Script: TStringList);
    procedure DoAfterExecuteAction(AAction: TatDBAction; Script: TStringList);
    procedure FinishScript;
    property UserName: string read FUserName write FUserName;
  protected
    function CheckCreate(AObject: TCreatingObject; AObjectName: string; ASubObjectName: string=''; AMustExist: boolean=False): boolean; virtual;
    procedure CheckCreated(AObject: TCreatingObject; AObjectName: string; ASubObjectName: string=''); virtual;
    function Prefix: string; virtual;
    property DBType: TDatabaseType read FDBType write FDBType;
  public
    constructor Create; overload;
    destructor Destroy; override;

    class function Create(ADBType: TDatabaseType; AEngineType: TDBEngineType=dgConsts.etNone): TDBStructurer; overload;

    procedure ChangeDomain(ADomain: TGDAODomain); virtual; abstract;
    procedure ChangeFieldDefaultValue(AField, OldField: TGDAOField); virtual; abstract;
    procedure ChangeFieldExclusiveness(AField: TGDAOField); virtual; abstract;
    procedure ChangeFieldRequired(AField: TGDAOField); virtual; abstract;
    procedure ChangeFieldSize(AField: TGDAOField); virtual; abstract;
    procedure ChangeFieldType(AField: TGDAOField); virtual; abstract;

    procedure CreateExtraObject(AObject: TGDAOObject; UseAlter: boolean); virtual; abstract;

    procedure CreateField(AField: TGDAOField); virtual; abstract;
    procedure CreateIndex(AIndex: TGDAOIndex); virtual; abstract;
    procedure CreateRelationship(ARelationship: TGDAORelationship); virtual; abstract;
    procedure CreateDomain(ADomain: TGDAODomain); virtual; abstract;
    procedure CreateTable(ATable: TGDAOTable); overload; virtual; abstract;
    procedure CreateTableConstraint(AConstraint: TGDAOConstraint); virtual; abstract;
    procedure CreateTrigger(ATrigger: TGDAOTrigger); virtual;
    procedure CreatePrimaryKey(ATable: TGDAOTable); virtual; abstract;

    procedure ExecuteSQL(ASQL: string; AOrder: integer);

    procedure RemoveExtraObject(AObject: TGDAOObject); virtual; abstract;
    procedure RemoveField(AField: TGDAOField); virtual; abstract;
    procedure RemoveIndex(AIndex: TGDAOIndex); virtual; abstract;
    procedure RemoveDomain(ADomain: TGDAODomain); virtual; abstract;
    procedure RemoveRelationship(ARelationship: TGDAORelationship); virtual; abstract;
    procedure RemoveTable(ATable: TGDAOTable); virtual; abstract;
    procedure RemoveTableConstraint(AConstraint: TGDAOConstraint); virtual; abstract;
    procedure RemoveTrigger(ATrigger: TGDAOTrigger); virtual;
    procedure RemovePrimaryKey(ATable: TGDAOTable); virtual; abstract;

    procedure RenameField(AField: TGDAOField; AOldName: string); virtual; abstract;
    //procedure RenameIndex(AIndex: TGDAOIndex; AOldName: string); virtual; abstract;
    procedure RenameTable(ATable: TGDAOTable; AOldName: string); virtual; abstract;

    procedure CreateConstraintFieldCheck(AField: TGDAOField); virtual; abstract;
    procedure CreateConstraintFieldDefault(AField: TGDAOField); virtual; abstract;
    procedure CreateConstraintFieldNotNull(AField: TGDAOField); virtual; abstract;
    procedure RemoveConstraintFieldCheck(AField: TGDAOField); virtual; abstract;
    procedure RemoveConstraintFieldDefault(AField: TGDAOField); virtual; abstract;
    procedure RemoveConstraintFieldNotNull(AField: TGDAOField); virtual; abstract;

    procedure CommentDomain(ADomain: TGDAODomain); virtual; abstract;
    procedure CommentExtraObject(AObject: TGDAOObject); virtual; abstract;
    procedure CommentField(AField: TGDAOField); virtual; abstract;
    procedure CommentTable(ATable: TGDAOTable); virtual; abstract;
    procedure CommentTrigger(ATrigger: TGDAOTrigger); virtual; abstract;

    procedure GenerateScriptSQL(AActions: TatDBActionList; AStrings: TStrings);
    procedure GenerateScriptSQLDataDictionary(ADataDictionary: TGDAODatabase; AScript: TStrings; AFilter: TSQLScriptFilter=nil);
    procedure GenerateScriptSQLDropDataDictionary(ADataDictionary: TGDAODatabase; AScript: TStrings; AFilter: TSQLScriptFilter=nil);

    function SQLTerminator: string; virtual;

    property CheckForExistingObjects: boolean read FCheckForExistingObjects write FCheckForExistingObjects;
    property SQLScript: TStrings read FScript;
    property BeforeExecuteAction: TBeforeExecuteActionEvent read FBeforeExecuteAction write FBeforeExecuteAction;
    property AfterExecuteAction: TAfterExecuteActionEvent read FAfterExecuteAction write FAfterExecuteAction;

    property OnExecuteSQL: TExecuteSQLEvent read FOnExecuteSQL write FOnExecuteSQL;
    //property ObjectFilter: TDBStructurerObjectFilter read FObjectFilter write FObjectFilter;
  end;

  TatDBAction = class(TPersistent)
  private
    FDBStructurer: TDBStructurer;
  protected
    function GetDescription: string; virtual; abstract;
    function GetCategory: TCategoryAction; virtual; abstract;
    function GetDetails: string; virtual;
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); virtual;
  public
    constructor Create(AList: TatDBActionList);
    procedure ApplyDBAction(ADictionary: TGDAODatabase); virtual;
  published
    property Description: string read GetDescription;
    property Category: TCategoryAction read GetCategory;
    property Details: string read GetDetails;
  end;

  TSQLScriptFilter = class(TPersistent)
  private
    FItems: TSQLScriptFilterItems;
    FExcludedTables: TStrings;
    FCategories: TGDAOCategoryTypes;

    {IsTableIncluded is different than MustInclude(Table). This function
    only checks for the excluded tables list, and ignores if the filter items
    has the table object or not}
    function IsTableIncluded(ATable: TGDAOTable): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;

    function MustInclude(ATable: TGDAOTable): boolean; overload;
    function MustInclude(ARel: TGDAORelationship): boolean; overload;
    function MustInclude(AIndex: TGDAOIndex): boolean; overload;
    function MustInclude(AConstraint: TGDAOConstraint): boolean; overload;
    function MustInclude(ATrigger: TGDAOTrigger): boolean; overload;
    function MustInclude(AObject: TGDAOObject): boolean; overload;
    function MustInclude(ADomain: TGDAODomain): boolean; overload;
    function MustInclude(AField: TGDAOField): boolean; overload;
    function MustIncludePrimaryKey(ATable: TGDAOTable): boolean;
    function MustIncludeConstraint(AField: TGDAOField): boolean;
    function MustIncludeComments: boolean;

    property Items: TSQLScriptFilterItems read FItems write FItems;
    property Categories: TGDAOCategoryTypes read FCategories write FCategories;
    property ExcludedTables: TStrings read FExcludedTables;
  end;

  {$IFNDEF DATAMODELER}
  TDBConnection = class(TBaseDBConnection);
  {$ENDIF}

const
  {order to sort sql commands}
  SQLSort_DropExtraObject                 = 0;
  SQLSort_DropProcedure                   = 10;
  SQLSort_DropView                        = 20;
  SQLSort_DropRelationship                = 100;
  SQLSort_ChangeDomain                    = 140;
  SQLSort_CreateDomain                    = 150;

  SQLSort_DropTableConstraint             = 200;
  SQLSort_DropTrigger                     = 300;
  SQLSort_DropIndex                       = 400;
  SQLSort_DropFieldConstraint             = 500;
  SQLSort_DropTable                       = 600;

  SQLSort_DropFunction                    = 610;
  SQLSort_DropSequence                    = 620;

  SQLSort_RenameTable                     = 700;
  SQLSort_RenameField                     = 800;
  SQLSort_DropField                       = 900;
  SQLSort_ChangeField                     = 1000;
  SQLSort_CreateField                     = 1100;

  SQLSort_CreateSequence                  = 1150;
  SQLSort_CreateFunction                  = 1160;
  SQLSort_CreateProcedureHeader           = 1170;

  SQLSort_CreateTable                     = 1200;
  SQLSort_CreateFieldConstraint           = 1300;
  SQLSort_CreateIndex                     = 1400;
  SQLSort_CreateTrigger                   = 1500;
  SQLSort_CreateTableConstraint           = 1600;

  SQLSort_CreateRelationship              = 1700;
  SQLSort_CreateView                      = 1780;
  SQLSort_CreateProcedure                 = 1790;
  SQLSort_CreateExtraObject               = 1800;
  SQLSort_DropDomain                      = 1900;

  SQLSort_CommentObject                   = 2000;

  SQLScriptAllFilterItems = [fiTable..fiComments];

implementation

uses
  atProgress, dgDBActions, dgGenericDBStructurer, dgCompare;

{ TDBStructurer }

constructor TDBStructurer.Create;
begin
   inherited;
   FScript := TStringList.Create;
   FCurrentStep:=0;
   FLastStep:=0;
end;

(*procedure TDBStructurer.CreateIndex(const ATabela, AIndexName,
  IndexField: string; IsUnique, IsPrimary: boolean);
begin
   CreateIndex(ATabela,AIndexName,[IndexField],IsUnique,IsPrimary);
end;*)

procedure TDBStructurer.CreateTrigger(ATrigger: TGDAOTrigger);
begin

end;

destructor TDBStructurer.Destroy;
begin
   inherited;
   FScript.Free;
end;

procedure TDBStructurer.DoAfterExecuteAction(AAction: TatDBAction; Script: TStringList);
begin
  if Assigned(FAfterExecuteAction) then
  begin
    Script.Clear;
    FAfterExecuteAction(AAction, Script);
    if Script.Count > 0 then
      SQLScript.AddStrings(Script);
  end;
end;

procedure TDBStructurer.DoBeforeExecuteAction(Action: TatDBAction; var Continue: boolean; Script: TStringList);
begin
  Continue := True;
  if Assigned(FBeforeExecuteAction) then
  begin
    Script.Clear;
    FBeforeExecuteAction(Action, Continue, Script);
    if Script.Count > 0 then
      SQLScript.AddStrings(Script);
  end;
end;

procedure TDBStructurer.ExecuteSQL(ASQL: string; AOrder: integer);
begin
  SQLScript.AddObject(ASQL, TObject(AOrder));

  if Assigned(FOnExecuteSQL) then
    FOnExecuteSQL(ASQL);  
end;

function SQLCompareProc(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := integer(List.Objects[Index1]) - integer(List.Objects[Index2]);
end;

procedure TDBStructurer.FinishScript;
begin
  TStringList(FScript).CustomSort(SQLCompareProc);
end;

procedure TDBStructurer.GenerateScriptSQL(AActions: TatDBActionList; AStrings: TStrings);
var
  i: integer;
  slScript: TStringList;
  canExecute: boolean;
  AProg: TatProgress;
begin
  slScript := TStringList.Create;
  AProg := TatProgress.Create(nil);
  try
    SQLScript.Clear;
    AProg.Caption := 'Progress';
    AProg.Options := [];
    AProg.FormPosition := fpScreenCenter;
    AProg.Start('Generating script', 0, AActions.Count div 10, 1);
    for i := 0 to AActions.Count - 1 do
      with TatDBAction(AActions.Items[i]) do
      begin
        DoBeforeExecuteAction(TatDBAction(AActions.Items[i]), canExecute, slScript);

        if canExecute then
        begin
          TatDBAction(AActions.Items[i]).ExecuteDBAction(Self);

          DoAfterExecuteAction(TatDBAction(AActions.Items[i]), slScript);
        end;
        if (i mod 10) = 9 then
          AProg.StepIt;
      end;
    FinishScript;
    AStrings.Text := SQLScript.Text;
  finally
    AProg.Free;
    slScript.Free;
  end;
end;

procedure TDBStructurer.GenerateScriptSQLDataDictionary(
  ADataDictionary: TGDAODatabase; AScript: TStrings;
  AFilter: TSQLScriptFilter);
var
  emptyDD: TGDAODatabase;
  dbActions: TatDBActionList;
begin
  emptyDD := TGDAODatabase.Create(nil);
  dbActions := nil;
  try
    emptyDD.DatabaseType := ADataDictionary.DatabaseType;
    dbActions := CompareDatabases(emptyDD, ADataDictionary, false, AFilter);
    GenerateScriptSQL(dbActions, AScript);
  finally
    emptyDD.Free;
    if dbActions <> nil then
      dbActions.Free;
  end;
end;

procedure TDBStructurer.GenerateScriptSQLDropDataDictionary(
  ADataDictionary: TGDAODatabase; AScript: TStrings;
  AFilter: TSQLScriptFilter);
var
  emptyDD: TGDAODatabase;
  dbActions: TatDBActionList;
begin
  emptyDD := TGDAODatabase.Create(nil);
  dbActions := nil;
  try
    emptyDD.DatabaseType := ADataDictionary.DatabaseType;
    dbActions := CompareDatabases(ADataDictionary, emptyDD, false, AFilter);
    GenerateScriptSQL(dbActions, AScript);
  finally
    emptyDD.Free;
    if dbActions <> nil then
      dbActions.Free;
  end;
end;

procedure TDBStructurer.RemoveTrigger(ATrigger: TGDAOTrigger);
begin

end;

function TDBStructurer.SQLTerminator: string;
begin
  result := ';';
end;

function TDBStructurer.CheckCreate(AObject: TCreatingObject; AObjectName, ASubObjectName: string; AMustExist: boolean): boolean;
begin
  result := True;
end;

procedure TDBStructurer.CheckCreated(AObject: TCreatingObject; AObjectName, ASubObjectName: string);
begin

end;

function TDBStructurer.Prefix: string;
begin
   result := UserName;
end;

class function TDBStructurer.Create(ADBType: TDatabaseType; AEngineType: TDBEngineType): TDBStructurer;
begin
  result := TGenericDBStructurer.Create(ADBType);
end;

{ TatDBAction }

procedure TatDBAction.ApplyDBAction(ADictionary: TGDAODatabase);
begin

end;

constructor TatDBAction.Create(AList: TatDBActionList);
begin
  if AList <> nil then
  begin
    AList.Add(Self);
  end;
end;

procedure TatDBAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  FDBStructurer := DBStructurer;
end;

function TatDBAction.GetDetails: string;
begin
  result:='';
end;

{ TSQLScriptFilter }

procedure TSQLScriptFilter.Assign(ASource: TPersistent);
begin
  if ASource is TSQLScriptFilter then
  begin
    FItems := TSQLScriptFilter(ASource).FItems;
    FCategories := TSQLScriptFilter(ASource).FCategories;
    FExcludedTables.Assign(TSQLScriptFilter(ASource).FExcludedTables);
  end else
    inherited Assign(ASource);
end;

constructor TSQLScriptFilter.Create;
begin
  FItems := SQLScriptAllFilterItems;
  FCategories := AllCategoryTypes;
  FExcludedTables := TStringList.Create;
end;

destructor TSQLScriptFilter.Destroy;
begin
  FExcludedTables.Free;
  inherited;
end;

function TSQLScriptFilter.IsTableIncluded(ATable: TGDAOTable): boolean;
begin
  result := (ATable <> nil) and (FExcludedTables.IndexOf(ATable.TableName) < 0);
end;

function TSQLScriptFilter.MustInclude(AIndex: TGDAOIndex): boolean;
begin
  result := (fiIndex in FItems)
    and (AIndex <> nil) and IsTableIncluded(AIndex.OwnerTable);
end;

function TSQLScriptFilter.MustInclude(ARel: TGDAORelationship): boolean;
begin
  result := (fiRelationship in FItems)
    and (ARel <> nil)
    and IsTableIncluded(ARel.ParentTable)
    and IsTableIncluded(ARel.ChildTable);
end;

function TSQLScriptFilter.MustInclude(ATable: TGDAOTable): boolean;
begin
  result := (fiTable in FItems)
    and IsTableIncluded(ATable);
end;

function TSQLScriptFilter.MustInclude(AConstraint: TGDAOConstraint): boolean;
begin
  {result := (fiConstraint in FItems)
    and (AConstraint <> nil)
    and IsTableIncluded(AConstraint.OwnerTable);}

  result := (AConstraint <> nil)
    and MustInclude(AConstraint.OwnerTable);
end;

function TSQLScriptFilter.MustInclude(ADomain: TGDAODomain): boolean;
begin
  result := (fiDomain in FItems);
end;

function TSQLScriptFilter.MustInclude(AObject: TGDAOObject): boolean;
begin
  result := (fiObject in FItems)
    and (AObject <> nil) and (AObject.OwnerCategory <> nil)
    and (AObject.OwnerCategory.CategoryType in Self.Categories);
end;

function TSQLScriptFilter.MustInclude(ATrigger: TGDAOTrigger): boolean;
begin
  result := (fiTrigger in FItems)
    and (ATrigger <> nil)
    and MustInclude(ATrigger.OwnerTable);
end;

function TSQLScriptFilter.MustInclude(AField: TGDAOField): boolean;
begin
  //result := (AField <> nil) and IsTableIncluded(AField.OwnerTable);

  result := (AField <> nil) and MustInclude(AField.OwnerTable);
end;

function TSQLScriptFilter.MustIncludeComments: boolean;
begin
  result := fiComments in FItems;
end;

function TSQLScriptFilter.MustIncludeConstraint(AField: TGDAOField): boolean;
begin
  {result := (fiConstraint in FItems)
    and (AField <> nil)
    and IsTableIncluded(AField.OwnerTable);}

  result := (AField <> nil)
    and MustInclude(AField.OwnerTable);
end;

function TSQLScriptFilter.MustIncludePrimaryKey(ATable: TGDAOTable): boolean;
begin
  {result := (fiConstraint in FItems)
    and IsTableIncluded(ATable);}

  result := MustInclude(ATable);
end;

end.

