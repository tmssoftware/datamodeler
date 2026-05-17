unit uProjectCheck;

interface

uses
  SysUtils, Classes, uGDAO, dgDBTypes, dgConsts;

type
  TProjectChecker  = class;
  TCheckReport     = class;
  TCheckReportItem = class;

  TConstraintChecks   = class;
  TConstraintCheck    = class;
  TFieldChecks        = class;
  TFieldCheck         = class;
  TIndexChecks        = class;
  TIndexCheck         = class;
  TObjectChecks       = class;
  TObjectCheck        = class;
  TRelationshipChecks = class;
  TRelationshipCheck  = class;
  TTableChecks        = class;
  TTableCheck         = class;
  TTriggerChecks      = class;
  TTriggerCheck       = class;
  TModelChecks        = class;
  TModelCheck         = class;

  {Keep the enumerated items in importante order (hint, warning, error)
   because the order of enumerated type is used to sort the report list.
   Don't forget to update CheckReportItemTypeName if you change order}
  TCheckReportItemType = (crtNone, crtHint, crtWarning, crtError);

  TConstraintCheckProc   = procedure(Constraint: TGDAOConstraint; Report: TCheckReport) of object;
  TFieldCheckProc        = procedure(Field: TGDAOField; Report: TCheckReport) of object;
  TIndexCheckProc        = procedure(Index: TGDAOIndex; Report: TCheckReport) of object;
  TObjectCheckProc       = procedure(ExtraObject: TGDAOObject; Report: TCheckReport) of object;
  TRelationshipCheckProc = procedure(Relationship: TGDAORelationship; Report: TCheckReport) of object;
  TTableCheckProc        = procedure(Table: TGDAOTable; Report: TCheckReport) of object;
  TTriggerCheckProc      = procedure(Trigger: TGDAOTrigger; Report: TCheckReport) of object;
  TModelCheckProc        = procedure(Model: TGDD; Report: TCheckReport) of object;

  TProjectChecker = class
  private
    FDBType: TDatabaseType;
    FConstraintChecks: TConstraintChecks;
    FFieldChecks: TFieldChecks;
    FIndexChecks: TIndexChecks;
    FObjectChecks: TObjectChecks;
    FRelationshipChecks: TRelationshipChecks;
    FTableChecks: TTableChecks;
    FTriggerChecks: TTriggerChecks;
    FModelChecks: TModelChecks;
    FMaxIdentifierName: integer;
    FCheckValidIdentifier: boolean;

    procedure LoadChecks;

    function HasName(AName: string): boolean;
    function ValidName(AName: string): boolean;
    function NameTooLong(AName: string): boolean;
    function IsReservedWord(AName: string): boolean;
    function ReservedWordErrorType: TCheckReportItemType;

    procedure ConstraintCheckName(AConstraint: TGDAOConstraint; AReport: TCheckReport);
    procedure ConstraintCheckExpression(AConstraint: TGDAOConstraint; AReport: TCheckReport);

    procedure FieldCheckName(AField: TGDAOField; AReport: TCheckReport);
    procedure FieldCheckSize(AField: TGDAOField; AReport: TCheckReport);
    procedure FieldCheckDefaultIdentity(AField: TGDAOField; AReport: TCheckReport);
    procedure FieldCheckComputedExpr(AField: TGDAOField; AReport: TCheckReport);
    procedure FieldCheckValidIdentity(AField: TGDAOField; AReport: TCheckReport);

    procedure IndexCheckName(AIndex: TGDAOIndex; AReport: TCheckReport);
    procedure IndexCheckFields(AIndex: TGDAOIndex; AReport: TCheckReport);

    procedure ObjectCheckName(AObject: TGDAOObject; AReport: TCheckReport);
    procedure ObjectCheckImplementation(AObject: TGDAOObject; AReport: TCheckReport);

    procedure RelationshipCheckName(ARelationship: TGDAORelationship; AReport: TCheckReport);
    procedure RelationshipCheckFields(ARelationship: TGDAORelationship; AReport: TCheckReport);
    procedure RelationshipCheckParentKey(ARelationship: TGDAORelationship; AReport: TCheckReport);
    procedure RelationshipCheckFieldTypes(ARelationship: TGDAORelationship; AReport: TCheckReport);
    procedure RelationshipCheckSelfCascade(ARelationship: TGDAORelationship; AReport: TCheckReport);

    procedure TableCheckDuplicateConstraints(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckDuplicateFields(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckDuplicateIndexes(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckDuplicateTriggers(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckDuplicateIdentities(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckMissingPrimaryKey(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckPrimaryKeyName(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckFieldCount(ATable: TGDAOTable; AReport: TCheckReport);
    procedure TableCheckName(ATable: TGDAOTable; AReport: TCheckReport);

    procedure TriggerCheckName(ATrigger: TGDAOTrigger; AReport: TCheckReport);
    procedure TriggerCheckImplementation(ATrigger: TGDAOTrigger; AReport: TCheckReport);

    procedure ModelCheckDuplicateTables(ADictionary: TGDD; AReport: TCheckReport);
    procedure ModelCheckDuplicateRelationships(ADictionary: TGDD; AReport: TCheckReport);
    procedure ModelCheckDuplicateObjects(ADictionary: TGDD; AReport: TCheckReport);
    procedure ModelCheckDuplicateDomains(ADictionary: TGDD; AReport: TCheckReport);
    procedure ModelCheckDuplicateIndexes(ADictionary: TGDD; AReport: TCheckReport);
    procedure ModelCheckDuplicatePrimaryKeys(ADictionary: TGDD; AReport: TCheckReport);
  public
    constructor Create;
    destructor Destroy; override;
    function CheckDataDictionary(ADataDictionary: TGDAODatabase; AReport: TCheckReport): boolean;
  end;

  TCheckReport = class(TCollection)
  private
    function GetItem(i: integer): TCheckReportItem;
    procedure SetItem(i: integer; const Value: TCheckReportItem);
    function Add(AType: TCheckReportItemType; ACaption: string; AObjectClass: TClass; AObjectName: string;
      AParentObjectName: string=''): TCheckReportItem; overload;
  public
    constructor Create;

    function Add(AType: TCheckReportItemType; ACaption: string; AConstraint: TGDAOConstraint): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; AField: TGDAOField): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; AIndex: TGDAOIndex): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; AObject: TGDAOObject): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; ARelationship: TGDAORelationship): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; ATable: TGDAOTable): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; ATrigger: TGDAOTrigger): TCheckReportItem; overload;
    function Add(AType: TCheckReportItemType; ACaption: string; ADomain: TGDAODomain): TCheckReportItem; overload;

    property Items[i: integer]: TCheckReportItem read GetItem write SetItem; default;
  end;

  TCheckReportItem = class(TCollectionItem)
  private
    FObjectClass: TClass;
    FItemType: TCheckReportItemType;
    FCaption: string;
    FDescription: string;
    FObjectName: string;
    FParentObjectName: string;
    procedure SetCaption(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetItemType(const Value: TCheckReportItemType);
    procedure SetObjectClass(const Value: TClass);
    procedure SetObjectName(const Value: string);
    procedure SetParentObjectName(const Value: string);
  public
    property ItemType: TCheckReportItemType read FItemType write SetItemType;
    property Caption: string read FCaption write SetCaption;
    property Description: string read FDescription write SetDescription;
    property ObjectClass: TClass read FObjectClass write SetObjectClass;
    property ObjectName: string read FObjectName write SetObjectName;
    property ParentObjectName: string read FParentObjectName write SetParentObjectName;
  end;

  TConstraintChecks = class(TCollection)
  private
    function GetItem(i: integer): TConstraintCheck;
    procedure SetItem(i: integer; const Value: TConstraintCheck);
  published
  public
    constructor Create;
    function Add(AProc: TConstraintCheckProc): TConstraintCheck;
    property Items[i: integer]: TConstraintCheck read GetItem write SetItem; default;
  end;

  TConstraintCheck = class(TCollectionItem)
  private
    FProc: TConstraintCheckProc;
  public
    property Execute: TConstraintCheckProc read FProc;
  end;

  TFieldChecks = class(TCollection)
  private
    function GetItem(i: integer): TFieldCheck;
    procedure SetItem(i: integer; const Value: TFieldCheck);
  public
    constructor Create;
    function Add(AProc: TFieldCheckProc): TFieldCheck;
    property Items[i: integer]: TFieldCheck read GetItem write SetItem; default;
  end;

  TFieldCheck = class(TCollectionITem)
  private
    FProc: TFieldCheckProc;
  public
    property Execute: TFieldCheckProc read FProc;
  end;

  TIndexChecks = class(TCollection)
  private
    function GetItem(i: integer): TIndexCheck;
    procedure SetItem(i: integer; const Value: TIndexCheck);
  published
  public
    constructor Create;
    function Add(AProc: TIndexCheckProc): TIndexCheck;
    property Items[i: integer]: TIndexCheck read GetItem write SetItem; default;
  end;

  TIndexCheck = class(TCollectionItem)
  private
    FProc: TIndexCheckProc;
  public
    property Execute: TIndexCheckProc read FProc;
  end;

  TObjectChecks = class(TCollection)
  private
    function GetItem(i: integer): TObjectCheck;
    procedure SetItem(i: integer; const Value: TObjectCheck);
  public
    constructor Create;
    function Add(AProc: TObjectCheckProc): TObjectCheck;
    property Items[i: integer]: TObjectCheck read GetItem write SetItem; default;
  end;

  TObjectCheck = class(TCollectionItem)
  private
    FProc: TObjectCheckProc;
  public
    property Execute: TObjectCheckProc read FProc;
  end;

  TRelationshipChecks = class(TCollection)
  private
    function GetItem(i: integer): TRelationshipCheck;
    procedure SetItem(i: integer; const Value: TRelationshipCheck);
  public
    constructor Create;
    function Add(AProc: TRelationshipCheckProc): TRelationshipCheck;
    property Items[i: integer]: TRelationshipCheck read GetItem write SetItem; default;
  end;

  TRelationshipCheck = class(TCollectionItem)
  private
    FProc: TRelationshipCheckProc;
  public
    property Execute: TRelationshipCheckProc read FProc;
  end;

  TTableChecks = class(TCollection)
  private
    function GetItem(i: integer): TTableCheck;
    procedure SetItem(i: integer; const Value: TTableCheck);
  public
    constructor Create;
    function Add(AProc: TTableCheckProc): TTableCheck;
    procedure Remove(AProc: TTableCheckProc);
    property Items[i: integer]: TTableCheck read GetItem write SetItem; default;
  end;

  TTableCheck = class(TCollectionItem)
  private
    FProc: TTableCheckProc;
  public
    property Execute: TTableCheckProc read FProc;
  end;

  TTriggerChecks = class(TCollection)
  private
    function GetItem(i: integer): TTriggerCheck;
    procedure SetItem(i: integer; const Value: TTriggerCheck);
  published
  public
    constructor Create;
    function Add(AProc: TTriggerCheckProc): TTriggerCheck;
    property Items[i: integer]: TTriggerCheck read GetItem write SetItem; default;
  end;

  TTriggerCheck = class(TCollectionItem)
  private
    FProc: TTriggerCheckProc;
  public
    property Execute: TTriggerCheckProc read FProc;
  end;

  TModelChecks = class(TCollection)
  private
    function GetItem(i: integer): TModelCheck;
    procedure SetItem(i: integer; const Value: TModelCheck);
  published
  public
    constructor Create;
    function Add(AProc: TModelCheckProc): TModelCheck;
    property Items[i: integer]: TModelCheck read GetItem write SetItem; default;
  end;

  TModelCheck = class(TCollectionItem)
  private
    FProc: TModelCheckProc;
  public
    property Execute: TModelCheckProc read FProc;
  end;

const
  CheckReportItemTypeName: array[TCheckReportItemType] of string =
    ('', 'Hint', 'Warning', 'Error');

function ProjectChecker: TProjectChecker;

implementation

uses
  uDBProperties, uStrings;

var
  vProjectChecker: TProjectChecker;

function ProjectChecker: TProjectChecker;
begin
  if not Assigned(vProjectChecker) then
    vProjectChecker := TProjectChecker.Create;
  result := vProjectChecker;
end;

{ TProjectCheck }

function TProjectChecker.CheckDataDictionary(ADataDictionary: TGDAODatabase; AReport: TCheckReport): boolean;
var
  i, j, k: integer;
  table: TGDAOTable;
begin
  FDBType := ADataDictionary.DatabaseType;

  LoadChecks;
  AReport.Clear;

  // tables
  for i := 0 to ADataDictionary.Tables.Count - 1 do
  begin
    table := ADataDictionary.Tables[i];
    if table.Visible then
    begin
      for j := 0 to FTableChecks.Count - 1 do
        FTableChecks[j].Execute(table, AReport);

      // fields
      for j := 0 to table.Fields.Count - 1 do
        for k := 0 to FFieldChecks.Count - 1 do
          FFieldChecks[k].Execute(table.Fields[j], AReport);

      // indexes
      for j := 0 to table.Indexes.Count - 1 do
        for k := 0 to FIndexChecks.Count - 1 do
          FIndexChecks[k].Execute(table.Indexes[j], AReport);

      // constraints
      for j := 0 to table.Constraints.Count - 1 do
        for k := 0 to FConstraintChecks.Count - 1 do
          FConstraintChecks[k].Execute(table.Constraints[j], AReport);

      // triggers
      for j := 0 to table.Triggers.Count - 1 do
        for k := 0 to FTriggerChecks.Count - 1 do
          FTriggerChecks[k].Execute(table.Triggers[j], AReport);
    end;
  end;

  // relationships
  for i := 0 to ADataDictionary.Relationships.Count - 1 do
    for j := 0 to FRelationshipChecks.Count - 1 do
    begin
      if ADataDictionary.Relationships[i].Visible then
        FRelationshipChecks[j].Execute(ADataDictionary.Relationships[i], AReport);
    end;

  // extra objects
  for i := 0 to ADataDictionary.Categories.Count - 1 do
    for j := 0 to ADataDictionary.Categories[i].Objects.Count - 1 do
      for k := 0 to FObjectChecks.Count - 1 do
      begin
        if ADataDictionary.Categories[i].Objects[j].Visible then
          FObjectChecks[k].Execute(ADataDictionary.Categories[i].Objects[j], AReport);
      end;

  // model
  for i := 0 to FModelChecks.Count - 1 do
    FModelChecks[i].Execute(ADataDictionary, AReport);

  result := AReport.Count = 0;
end;

{ TCheckReport }

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; AObjectClass: TClass;
  AObjectName, AParentObjectName: string): TCheckReportItem;
begin
  result := TCheckReportItem(inherited Add);
  with result do
  begin
    ItemType := AType;
    Caption := ACaption;
    ObjectClass := AObjectClass;
    ObjectName := AObjectName;
    ParentObjectName := AParentObjectName;
  end;
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; ATable: TGDAOTable): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAOTable, ATable.TableName);
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; AIndex: TGDAOIndex): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAOIndex, AIndex.IndexName, AIndex.OwnerTable.TableName);
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; AConstraint: TGDAOConstraint): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAOConstraint, AConstraint.ConstraintName, AConstraint.OwnerTable.TableName);
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; AObject: TGDAOObject): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAOObject, AObject.ObjectName, IntToStr(Ord(AObject.OwnerCategory.CategoryType)));
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; AField: TGDAOField): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAOField, AField.FieldName, AField.OwnerTable.TableName);
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; ARelationship: TGDAORelationship): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAORelationship, ARelationship.RelationshipName);
end;

constructor TCheckReport.Create;
begin
  inherited Create(TCheckReportItem);
end;

function TCheckReport.GetItem(i: integer): TCheckReportItem;
begin
  result := TCheckReportItem(inherited Items[i]);
end;

procedure TCheckReport.SetItem(i: integer; const Value: TCheckReportItem);
begin
  Items[i].Assign(Value);
end;

procedure TProjectChecker.ConstraintCheckExpression(AConstraint: TGDAOConstraint; AReport: TCheckReport);
begin
  if Trim(AConstraint.Expression) = '' then
    AReport.Add(crtWarning, Format('Missing expression on check constraint "%s" (table "%s")', [AConstraint.ConstraintName, AConstraint.OwnerTable.TableName]), AConstraint);
end;

procedure TProjectChecker.ConstraintCheckName(AConstraint: TGDAOConstraint; AReport: TCheckReport);
begin
  if not HasName(AConstraint.ConstraintName) then
    AReport.Add(crtError, Format('Constraint has no name on table "%s"', [AConstraint.OwnerTable.TableName]), AConstraint)
  else
  if not ValidName(AConstraint.ConstraintName) then
    AReport.Add(crtError, Format('Invalid constraint name "%s" on table "%s"', [AConstraint.ConstraintName, AConstraint.OwnerTable.TableName]), AConstraint)
  else
  if IsReservedWord(AConstraint.ConstraintName) then
    AReport.Add(ReservedWordErrorType, Format('constraint name "%s" on table "%s" is a reserved word', [AConstraint.ConstraintName, AConstraint.OwnerTable.TableName]), AConstraint)
  else
  if NameTooLong(AConstraint.ConstraintName) then
    AReport.Add(crtWarning, Format('Name too long for constraint "%s" on table "%s". Maximum size is %d characters.', [AConstraint.ConstraintName, AConstraint.OwnerTable.TableName, FMaxIdentifierName]), AConstraint);
end;

constructor TProjectChecker.Create;
begin
  FConstraintChecks := TConstraintChecks.Create;
  FFieldChecks := TFieldChecks.Create;
  FIndexChecks := TIndexChecks.Create;
  FObjectChecks := TObjectChecks.Create;
  FRelationshipChecks := TRelationshipChecks.Create;
  FTableChecks := TTableChecks.Create;
  FTriggerChecks := TTriggerChecks.Create;
  FModelChecks := TModelChecks.Create;
  FMaxIdentifierName := MaxInt;
  FCheckValidIdentifier := true;
end;

destructor TProjectChecker.Destroy;
begin
  FConstraintChecks.Free;
  FFieldChecks.Free;
  FIndexChecks.Free;
  FObjectChecks.Free;
  FRelationshipChecks.Free;
  FTableChecks.Free;
  FTriggerChecks.Free;
  FModelChecks.Free;
  inherited;
end;

procedure TProjectChecker.FieldCheckComputedExpr(AField: TGDAOField;
  AReport: TCheckReport);
begin
  if AField.DataType.Computed and (Trim(AField.Expression) = '') then
  begin
    AReport.Add(crtError, Format('Empty expression on computed field. Field: "%s" on table "%s"',
      [AField.FieldName, AField.OwnerTable.TableName]), AField);
  end;
end;

procedure TProjectChecker.FieldCheckDefaultIdentity(AField: TGDAOField;
  AReport: TCheckReport);
begin
  if AField.DataType.SeedIsRequired and AField.DataType.IncrementIsRequired
    and (AField.DefaultValue <> '') then
  begin
    AReport.Add(crtError, Format('Identity field cannnot have a default value. Field: "%s" on table "%s"',
      [AField.FieldName, AField.OwnerTable.TableName]), AField);
  end;
end;

procedure TProjectChecker.FieldCheckName(AField: TGDAOField; AReport: TCheckReport);
begin
  if not HasName(AField.FieldName) then
    AReport.Add(crtError, Format('Field has no name on table "%s"', [AField.OwnerTable.TableName]), AField)
  else
  if not ValidName(AField.FieldName) then
    AReport.Add(crtError, Format('Invalid field name "%s" on table "%s"', [AField.FieldName, AField.OwnerTable.TableName]), AField)
  else
  if IsReservedWord(AField.FieldName) then
    AReport.Add(ReservedWordErrorType, Format('Field name "%s" on table "%s" is a reserved word', [AField.FieldName, AField.OwnerTable.TableName]), AField)
  else
  if NameTooLong(AField.FieldName) then
    AReport.Add(crtWarning, Format('Name too long for field "%s" on table "%s". Maximum size is %d characters.', [AField.FieldName, AField.OwnerTable.TableName, FMaxIdentifierName]), AField);
end;

procedure TProjectChecker.FieldCheckSize(AField: TGDAOField; AReport: TCheckReport);
begin
  if AField.DataType.SizeIsRequired then
  begin
    if not AField.DataType.CheckSize then
    begin
      if (AField.Size = 0) then
        AReport.Add(crtWarning, Format('Size was not specified on field "%s" (table "%s")',
          [AField.FieldName, AField.OwnerTable.TableName]), AField)
    end
    else
    begin
      if ((AField.Size < AField.DataType.MinSize) or (AField.Size > AField.DataType.MaxSize)) then
        AReport.Add(crtError, Format('Size out of range on field "%s" (table "%s"). Size must be between %d and %d.',
          [AField.FieldName, AField.OwnerTable.TableName,
           AField.DataType.MinSize, AField.DataType.MaxSize]), AField)
    end;
  end;
end;

procedure TProjectChecker.FieldCheckValidIdentity(AField: TGDAOField; AReport: TCheckReport);
begin
  if AField.DataType.IncrementIsRequired
    and (AField.IncrementValue = 0) then
  begin
    AReport.Add(crtError, Format('Increment value cannot be zero on identity fields. Field: "%s" on table "%s"',
      [AField.FieldName, AField.OwnerTable.TableName]), AField);
  end
  else
  if (AField.DataType.Counter or AField.DataType.SeedIsRequired or AField.DataType.IncrementIsRequired)
    and not AField.Required then
  begin
    AReport.Add(crtWarning, Format('Identity field must be required. Field: "%s" on table "%s"',
      [AField.FieldName, AField.OwnerTable.TableName]), AField); 
  end;
end;

function TProjectChecker.ReservedWordErrorType: TCheckReportItemType;
begin
  if FCheckValidIdentifier then
    result := crtError
  else
    result := crtWarning;
end;

function TProjectChecker.HasName(AName: string): boolean;
begin
  result := Trim(AName) <> '';
end;

procedure TProjectChecker.IndexCheckFields(AIndex: TGDAOIndex; AReport: TCheckReport);
begin
  if AIndex.IFields.Count = 0 then
    AReport.Add(crtError, Format('Index "%s" on table "%s" has no linked fields', [AIndex.IndexName, AIndex.OwnerTable.TableName]), AIndex);
end;

procedure TProjectChecker.IndexCheckName(AIndex: TGDAOIndex; AReport: TCheckReport);
begin
  if not HasName(AIndex.IndexName) then
    AReport.Add(crtError, Format('Index has no name on table "%s"', [AIndex.OwnerTable.TableName]), AIndex)
  else
  if not ValidName(AIndex.IndexName) then
    AReport.Add(crtError, Format('Invalid index name "%s" on table "%s"', [AIndex.IndexName, AIndex.OwnerTable.TableName]), AIndex)
  else
  if IsReservedWord(AIndex.IndexName) then
    AReport.Add(ReservedWordErrorType, Format('Index name "%s" on table "%s" is a reserved word', [AIndex.IndexName, AIndex.OwnerTable.TableName]), AIndex)
  else
  if NameTooLong(AIndex.IndexName) then
    AReport.Add(crtWarning, Format('Name too long for index "%s" on table "%s". Maximum size is %d characters.', [AIndex.IndexName, AIndex.OwnerTable.TableName, FMaxIdentifierName]), AIndex);
end;

procedure TProjectChecker.LoadChecks;
begin
  FConstraintChecks.Clear;
  FConstraintChecks.Add(ConstraintCheckName);
  FConstraintChecks.Add(ConstraintCheckExpression);

  FFieldChecks.Clear;
  FFieldChecks.Add(FieldCheckName);
  FFieldChecks.Add(FieldCheckSize);
  FFieldChecks.Add(FieldCheckDefaultIdentity);
  FFieldChecks.Add(FieldCheckComputedExpr);
  FFieldChecks.Add(FieldCheckValidIdentity);

  FIndexChecks.Clear;
  FIndexChecks.Add(IndexCheckName);
  FIndexChecks.Add(IndexCheckFields);

  FObjectChecks.Clear;
  FObjectChecks.Add(ObjectCheckName);
  FObjectChecks.Add(ObjectCheckImplementation);

  FRelationshipChecks.Clear;
  FRelationshipChecks.Add(RelationshipCheckName);
  FRelationshipChecks.Add(RelationshipCheckFields);
  FRelationshipChecks.Add(RelationshipCheckParentKey);
  FRelationshipChecks.Add(RelationshipCheckFieldTypes);

  FTableChecks.Clear;
  FTableChecks.Add(TableCheckName);
  FTableChecks.Add(TableCheckFieldCount);
  FTableChecks.Add(TableCheckMissingPrimaryKey);
  FTableChecks.Add(TableCheckPrimaryKeyName);
  FTableChecks.Add(TableCheckDuplicateConstraints);
  FTableChecks.Add(TableCheckDuplicateFields);
  FTableChecks.Add(TableCheckDuplicateIndexes);
  FTableChecks.Add(TableCheckDuplicateTriggers);
  FTableChecks.Add(TableCheckDuplicateIdentities);

  FTriggerChecks.Clear;
  FTriggerChecks.Add(TriggerCheckName);
  FTriggerChecks.Add(TriggerCheckImplementation);

  FModelChecks.Clear;
  FModelChecks.Add(ModelCheckDuplicateTables);
  FModelChecks.Add(ModelCheckDuplicateRelationships);
  FModelChecks.Add(ModelCheckDuplicateObjects);
  FModelChecks.Add(ModelCheckDuplicateDomains);

  FMaxIdentifierName := FDBType.MaxIdentifierLength;
  case TDBProperties.GetFixedDatabaseType(FDBType) of
    fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlServer2016, fdbSqlAzure:
      begin
        FCheckValidIdentifier := false;
        FRelationshipChecks.Add(RelationshipCheckSelfCascade);
        FModelChecks.Add(ModelCheckDuplicatePrimaryKeys);
      end;
    fdbFirebird2, fdbFirebird3, fdbInterbase2017:
      begin
        FCheckValidIdentifier := false;

        {Firebird can't have duplicated index names even for different tables}
        FTableChecks.Remove(TableCheckDuplicateIndexes);
        FModelChecks.Add(ModelCheckDuplicateIndexes);
      end;
    fdbAbsoluteDB:
      begin
        FCheckValidIdentifier := false;
        FRelationshipChecks.Clear;
        FConstraintChecks.Clear;
        FTriggerChecks.Clear;
        FObjectChecks.Clear;
      end;
    fdbNexusDB3:
      begin
        FCheckValidIdentifier := false;
      end;
    fdbOracle10g:
      begin
        FCheckValidIdentifier := true;
      end;
    fdbMySQL51, fdbMySQL57:
      begin
        FCheckValidIdentifier := false;
        FConstraintChecks.Clear;
      end;
    fdbElevateDB:
      begin
        FCheckValidIdentifier := false;
      end;
    fdbSQLite3:
      begin
        FCheckValidIdentifier := false;
        {SQLite can't have duplicated index names even for different tables}
        FTableChecks.Remove(TableCheckDuplicateIndexes);
        FModelChecks.Add(ModelCheckDuplicateIndexes);
      end;
    fdbPostgreSQL9, fdbPostgreSQL11:
      begin
        FCheckValidIdentifier := false;
      end;

    //advantage disabled: fdbAdvantage:
    //  begin
    //    //advantage
    //  end
  else
    begin
      FMaxIdentifierName := MaxInt;
      FCheckValidIdentifier := true;
    end;
  end;
end;

procedure TProjectChecker.ModelCheckDuplicateDomains(ADictionary: TGDD;
  AReport: TCheckReport);
var
  i, j: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to ADictionary.Domains.Count - 1 do
      for j := 0 to ADictionary.Domains.Count - 1 do
        if (i <> j)
          and SameText(ADictionary.Domains[i].Name, ADictionary.Domains[j].Name)
          and (sl.IndexOf(ADictionary.Domains[i].Name) < 0) then
        begin
          AReport.Add(crtError, Format('Duplicate domain name "%s"',
            [ADictionary.Domains[i].Name]),
            ADictionary.Domains[i]);
          sl.Add(ADictionary.Domains[i].Name);
        end;
  finally
    sl.Free;
  end;
end;

procedure TProjectChecker.ModelCheckDuplicateIndexes(ADictionary: TGDD;
  AReport: TCheckReport);
var
  i, j: integer;
  c, d: integer;
begin
  {When looking for duplicated indexes, report both indexes with same name,
   so both appear in the report. This is useful because indexes are "inside"
   tables, so it's hard to find the other index with same name}
  for i := 0 to ADictionary.Tables.Count - 1 do for j := 0 to ADictionary.Tables[i].Indexes.Count - 1 do
    for c := 0 to ADictionary.Tables.Count - 1 do for d := 0 to ADictionary.Tables[c].Indexes.Count - 1 do
      if not ((i = c) and (j = d))
        and SameText(ADictionary.Tables[i].Indexes[j].IndexName,
                     ADictionary.Tables[c].Indexes[d].IndexName) then
      begin
        AReport.Add(crtError, Format('Duplicate index name "%s" (table: "%s")',
          [ADictionary.Tables[i].Indexes[j].IndexName,
           ADictionary.Tables[i].TableName]),
          ADictionary.Tables[i].Indexes[j]);
      end;
end;

procedure TProjectChecker.ModelCheckDuplicateObjects(ADictionary: TGDD;
  AReport: TCheckReport);
var
  c, i, j: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for c := 0 to ADictionary.Categories.Count - 1 do
    begin
      sl.Clear;

      for i := 0 to ADictionary.Categories[c].Objects.Count - 1 do
        for j := 0 to ADictionary.Categories[c].Objects.Count - 1 do
          if (i <> j)
            and SameText(ADictionary.Categories[c].Objects[i].ObjectName,
                         ADictionary.Categories[c].Objects[j].ObjectName)
            and (sl.IndexOf(ADictionary.Categories[c].Objects[i].ObjectName) < 0) then
          begin
            AReport.Add(crtError, Format('Duplicate %s name "%s"',
              [ADictionary.Categories[c].CategoryNameS,
              ADictionary.Categories[c].Objects[i].ObjectName]),
              ADictionary.Categories[c].Objects[i]);
            sl.Add(ADictionary.Categories[c].Objects[i].ObjectName);
          end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TProjectChecker.ModelCheckDuplicatePrimaryKeys(ADictionary: TGDD;
  AReport: TCheckReport);
var
  i: integer;
  c: integer;
begin
  {When looking for duplicated indexes, report both indexes with same name,
   so both appear in the report. This is useful because indexes are "inside"
   tables, so it's hard to find the other index with same name}
  for i := 0 to ADictionary.Tables.Count - 1 do
    for c := 0 to ADictionary.Tables.Count - 1 do
      if (i <> c) and (ADictionary.Tables[i].PrimaryKeyIndex.IndexName <> '')
        and (ADictionary.Tables[c].PrimaryKeyIndex.IndexName <> '')
        and SameText(ADictionary.Tables[i].PrimaryKeyIndex.IndexName,
                     ADictionary.Tables[c].PrimaryKeyIndex.IndexName) then
      begin
        AReport.Add(crtError, Format('Duplicate primary key name "%s" (table: "%s")',
          [ADictionary.Tables[i].PrimaryKeyIndex.IndexName,
           ADictionary.Tables[i].TableName]),
          ADictionary.Tables[i]);
      end;
end;

procedure TProjectChecker.ModelCheckDuplicateRelationships(ADictionary: TGDD;
  AReport: TCheckReport);
var
  i, j: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to ADictionary.Relationships.Count - 1 do
      for j := 0 to ADictionary.Relationships.Count - 1 do
        if (i <> j)
          and SameText(ADictionary.Relationships[i].RelationshipName, ADictionary.Relationships[j].RelationshipName)
          and (sl.IndexOf(ADictionary.Relationships[i].RelationshipName) < 0) then
        begin
          AReport.Add(crtError, Format('Duplicate relationship name "%s"',
            [ADictionary.Relationships[i].RelationshipName]),
            ADictionary.Relationships[i]);
          sl.Add(ADictionary.Relationships[i].RelationshipName);
        end;
  finally
    sl.Free;
  end;
end;

procedure TProjectChecker.ModelCheckDuplicateTables(ADictionary: TGDD;
  AReport: TCheckReport);
var
  i, j: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to ADictionary.Tables.Count - 1 do
      for j := 0 to ADictionary.Tables.Count - 1 do
        if (i <> j)
          and SameText(ADictionary.Tables[i].TableName, ADictionary.Tables[j].TableName)
          and (sl.IndexOf(ADictionary.Tables[i].TableName) < 0) then
        begin
          AReport.Add(crtError, Format('Duplicate table name "%s"',
            [ADictionary.Tables[i].TableName]),
            ADictionary.Tables[i]);
          sl.Add(ADictionary.Tables[i].TableName);
        end;
  finally
    sl.Free;
  end;
end;

procedure TProjectChecker.ObjectCheckImplementation(AObject: TGDAOObject; AReport: TCheckReport);
begin
  if Trim(AObject.CreateImplementation) = '' then
    AReport.Add(crtWarning, Format('%s "%s" has no create implementation', [AObject.OwnerCategory.CategoryNameS, AObject.ObjectName]), AObject);
end;

procedure TProjectChecker.ObjectCheckName(AObject: TGDAOObject; AReport: TCheckReport);
begin
  if not HasName(AObject.ObjectName) then
    AReport.Add(crtError, Format('%s has no name', [AObject.OwnerCategory.CategoryNameS]), AObject)
  else
  if not ValidName(AObject.ObjectName) then
    AReport.Add(crtError, Format('Invalid %s name "%s"', [AObject.OwnerCategory.CategoryNameS, AObject.ObjectName]), AObject)
  else
  if IsReservedWord(AObject.ObjectName) then
    AReport.Add(ReservedWordErrorType, Format('%s name "%s" is a reserved word', [AObject.OwnerCategory.CategoryNameS, AObject.ObjectName]), AObject)
  else
  if NameTooLong(AObject.ObjectName) then
    AReport.Add(crtWarning, Format('Name too long for %s "%s". Maximum size is %d characters.', [AObject.OwnerCategory.CategoryNameS, AObject.ObjectName, FMaxIdentifierName]), AObject);
end;

procedure TProjectChecker.RelationshipCheckFields(ARelationship: TGDAORelationship; AReport: TCheckReport);
var i: integer;
begin               
  if (ARelationship.KeyLinkCount = 0) then
    AReport.Add(crtError, Format('Relationship "%s" has no linked fields', [ARelationship.RelationshipName]), ARelationship)
  else
  begin
    for i := 0 to ARelationship.KeyLinkCount - 1 do
      if ARelationship.KeyLinks[i].ParentField = nil then
        AReport.Add(crtError, Format('Missing parent field on relationship "%s" (link #%d)', [ARelationship.RelationshipName, i+1]), ARelationship)
      else if ARelationship.KeyLinks[i].ChildField = nil then
        AReport.Add(crtError, Format('Missing child field on relationship "%s" (link #%d)', [ARelationship.RelationshipName, i+1]), ARelationship);
  end;
end;

procedure TProjectChecker.RelationshipCheckFieldTypes(ARelationship: TGDAORelationship; AReport: TCheckReport);
var
  i: integer;
begin
  for i := 0 to ARelationship.KeyLinkCount - 1 do
    with ARelationship.KeyLinks[i] do
      if (ParentField <> nil) and not ParentField.CompatibleForRelationship(ChildField) then
        AReport.Add(crtWarning, Format('Incompatible data types ("%s"/"%s") on relationship "%s"',
          [ParentFieldName, ChildFieldName, ARelationship.RelationshipName]),
          ARelationship);
end;

procedure TProjectChecker.RelationshipCheckName(ARelationship: TGDAORelationship; AReport: TCheckReport);
begin
  if not HasName(ARelationship.RelationshipName) then
    AReport.Add(crtError, 'Relationship has no name', ARelationship)
  else
  if not ValidName(ARelationship.RelationshipName) then
    AReport.Add(crtError, Format('Invalid relationship name "%s"', [ARelationship.RelationshipName]), ARelationship)
  else
  if IsReservedWord(ARelationship.RelationshipName) then
    AReport.Add(ReservedWordErrorType, Format('Relationship name "%s" is a reserved word', [ARelationship.RelationshipName]), ARelationship)
  else
  if NameTooLong(ARelationship.RelationshipName) then
    AReport.Add(crtWarning, Format('Name too long for relationship "%s". Maximum size is %d characters.', [ARelationship.RelationshipName, FMaxIdentifierName]), ARelationship)
end;

procedure TProjectChecker.RelationshipCheckParentKey(ARelationship: TGDAORelationship; AReport: TCheckReport);
begin
  if Assigned(ARelationship.ParentIndex) and (not ARelationship.ParentIndex.IsPrimary) and not (ARelationship.ParentIndex.IndexType in [itUnique, itUniqueKey]) then
    AReport.Add(crtWarning, Format('Parent index "%s" of relationship "%s" is not unique',
      [ARelationship.ParentIndex.IndexName, ARelationship.RelationshipName]), ARelationship);
end;

procedure TProjectChecker.RelationshipCheckSelfCascade(
  ARelationship: TGDAORelationship; AReport: TCheckReport);
begin
  if Assigned(ARelationship.ParentTable) and (ARelationship.ParentTable = ARelationship.ChildTable) and
    ((ARelationship.UpdateMethod <> umRestrict) or (ARelationship.DeleteMethod <> dmRestrict)) then
    AReport.Add(crtError, Format('Relationship "%s" is self-referencing and can only accept ON DELETE NO ACTION and ON UPDATE NO ACTION methods.',
      [ARelationship.RelationshipName]), ARelationship);
end;

procedure TProjectChecker.TableCheckDuplicateConstraints(ATable: TGDAOTable; AReport: TCheckReport);
var
  i, j: integer;
  sl: TStringlist;
begin
  sl := TStringList.Create;
  try
    for i := 0 to ATable.Constraints.Count - 1 do
      for j := 0 to ATable.Constraints.Count - 1 do
        if (i <> j) and SameText(ATable.Constraints[i].ConstraintName, ATable.Constraints[j].ConstraintName)
          and (sl.IndexOf(ATable.Constraints[i].ConstraintName) < 0) then
        begin
          AReport.Add(crtError, Format('Duplicate constraint name "%s" on table "%s"',
            [ATable.Constraints[i].ConstraintName, ATable.TableName]), ATable.Constraints[j]);
          sl.Add(ATable.Constraints[i].ConstraintName);
        end;
  finally
    sl.Free;
  end;
end;

procedure TProjectChecker.TableCheckDuplicateFields(ATable: TGDAOTable; AReport: TCheckReport);
var
  i, j: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to ATable.Fields.Count - 1 do
      for j := 0 to ATable.Fields.Count - 1 do
        if (i <> j) and SameText(ATable.Fields[i].FieldName, ATable.Fields[j].FieldName)
          and (sl.IndexOf(ATable.Fields[i].FieldName) < 0) then
        begin
          AReport.Add(crtError, Format('Duplicate field name "%s" on table "%s"',
            [ATable.Fields[i].FieldName, ATable.TableName]), ATable.Fields[j]);
          sl.Add(ATable.Fields[i].FieldName);
        end;
  finally
    sl.Free;
  end;
end;

procedure TProjectChecker.TableCheckDuplicateIdentities(ATable: TGDAOTable;
  AReport: TCheckReport);
var
  HasIdentity: boolean;
  i: integer;
begin
  HasIdentity := false;
  for i := 0 to ATable.Fields.Count - 1 do
    if (ATable.Fields[i].DataType <> nil)
      and ATable.Fields[i].DataType.SeedIsRequired
      and ATable.Fields[i].DataType.IncrementIsRequired then
    begin
      if HasIdentity then
        AReport.Add(crtError, Format('Table "%s" contains two identity fields',
          [ATable.TableName]), ATable.Fields[i])
      else
        HasIdentity := true;
    end;
end;

procedure TProjectChecker.TableCheckDuplicateIndexes(ATable: TGDAOTable; AReport: TCheckReport);
var i, j: integer;
begin
  for i := 0 to ATable.Indexes.Count - 1 do
    ATable.Indexes[i].Data := nil;
  for i := 0 to ATable.Indexes.Count - 1 do
    if ATable.Indexes[i].Data = nil then
      for j := 0 to ATable.Indexes.Count - 1 do
        if (i <> j) and SameText(ATable.Indexes[i].IndexName, ATable.Indexes[j].IndexName) then
        begin
          ATable.Indexes[j].Data := pointer(1);
          AReport.Add(crtError, Format('Duplicate index name "%s" on table "%s"',
            [ATable.Indexes[i].IndexName, ATable.TableName]), ATable.Indexes[j]);
        end;
end;

procedure TProjectChecker.TableCheckDuplicateTriggers(ATable: TGDAOTable; AReport: TCheckReport);
var i, j: integer;
begin
  for i := 0 to ATable.Triggers.Count - 1 do
    ATable.Triggers[i].Data := nil;
  for i := 0 to ATable.Triggers.Count - 1 do
    if ATable.Triggers[i].Data = nil then
      for j := 0 to ATable.Triggers.Count - 1 do
        if (i <> j) and SameText(ATable.Triggers[i].Name, ATable.Triggers[j].Name) then
        begin
          ATable.Triggers[j].Data := pointer(1);
          AReport.Add(crtError, Format('Duplicate trigger name "%s" on table "%s"',
            [ATable.Triggers[i].Name, ATable.TableName]), ATable.Triggers[j]);
        end;
end;

procedure TProjectChecker.TableCheckFieldCount(ATable: TGDAOTable; AReport: TCheckReport);
begin
  if ATable.Fields.Count = 0 then
    AReport.Add(crtWarning, Format('Table "%s" has no fields', [ATable.TableName]), ATable);
end;

procedure TProjectChecker.TableCheckMissingPrimaryKey(ATable: TGDAOTable;
  AReport: TCheckReport);
begin
  if not ATable.HasPrimaryKey then
    AReport.Add(crtWarning, Format('Table "%s" has no primary key', [ATable.TableName]), ATable);
end;

procedure TProjectChecker.TableCheckName(ATable: TGDAOTable; AReport: TCheckReport);
begin
  if not HasName(ATable.TableName) then
    AReport.Add(crtError, 'Table has no name', ATable)
  else
  if not ValidName(ATable.TableName) then
    AReport.Add(crtError, Format('Invalid table name "%s"', [ATable.TableName]), ATable)
  else
  if IsReservedWord(ATable.TableName) then
    AReport.Add(ReservedWordErrorType, Format('Table name "%s" is a reserved word', [ATable.TableName]), ATable)
  else
  if NameTooLong(ATable.TableName) then
    AReport.Add(crtWarning, Format('Name too long for table "%s". Maximum size is %d characters.', [ATable.TableName, FMaxIdentifierName]), ATable);
end;

procedure TProjectChecker.TableCheckPrimaryKeyName(ATable: TGDAOTable;
  AReport: TCheckReport);
begin
  if ATable.HasPrimaryKey and not HasName(ATable.PrimaryKeyIndex.IndexName) then
    AReport.Add(crtWarning, Format('Primary key has no name in Table "%s"',
      [ATable.TableName]), ATable.PrimaryKeyIndex);
end;

procedure TProjectChecker.TriggerCheckImplementation(ATrigger: TGDAOTrigger; AReport: TCheckReport);
begin
  if Trim(ATrigger.ImplementationCode) = '' then
    AReport.Add(crtWarning, Format('Trigger "%s" on table "%s" has no implementation', [ATrigger.Name, ATrigger.OwnerTable.TableName]), ATrigger);
end;

procedure TProjectChecker.TriggerCheckName(ATrigger: TGDAOTrigger; AReport: TCheckReport);
begin
  if not HasName(ATrigger.Name) then
    AReport.Add(crtError, Format('Trigger has no name on table "%s"', [ATrigger.OwnerTable.TableName]), ATrigger)
  else
  if not ValidName(ATrigger.Name) then
    AReport.Add(crtError, Format('Invalid trigger name "%s" on table "%s"', [ATrigger.Name, ATrigger.OwnerTable.TableName]), ATrigger)
  else
  if IsReservedWord(ATrigger.Name) then
    AReport.Add(ReservedWordErrorType, Format('Trigger name "%s" on table "%s" is a reserved word', [ATrigger.Name, ATrigger.OwnerTable.TableName]), ATrigger)
  else
  if NameTooLong(ATrigger.Name) then
    AReport.Add(crtWarning, Format('Name too long for trigger "%s" on table "%s". Maximum size is %d characters.', [ATrigger.Name, ATrigger.OwnerTable.TableName, FMaxIdentifierName]), ATrigger);
end;

function TProjectChecker.ValidName(AName: string): boolean;
begin
  result := (IsValidIdentifier(AName) or not FCheckValidIdentifier);
end;

function TProjectChecker.IsReservedWord(AName: string): boolean;
begin
  result := FDBType.IsReservedWord(AName);
end;

function TProjectChecker.NameTooLong(AName: string): boolean;
begin
  result := Length(AName) > FMaxIdentifierName;
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string; ATrigger: TGDAOTrigger): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAOTrigger, ATrigger.Name, ATrigger.OwnerTable.TableName);
end;

function TCheckReport.Add(AType: TCheckReportItemType; ACaption: string;
  ADomain: TGDAODomain): TCheckReportItem;
begin
  result := Add(AType, ACaption, TGDAODomain, ADomain.Name);
end;

{ TCheckReportItem }

procedure TCheckReportItem.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TCheckReportItem.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TCheckReportItem.SetItemType(const Value: TCheckReportItemType);
begin
  FItemType := Value;
end;

procedure TCheckReportItem.SetObjectClass(const Value: TClass);
begin
  FObjectClass := Value;
end;

procedure TCheckReportItem.SetObjectName(const Value: string);
begin
  FObjectName := Value;
end;

procedure TCheckReportItem.SetParentObjectName(const Value: string);
begin
  FParentObjectName := Value;
end;

{ TTableChecks }

function TTableChecks.Add(AProc: TTableCheckProc): TTableCheck;
begin
  result := TTableCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TTableChecks.Create;
begin
  inherited Create(TTableCheck);
end;

function TTableChecks.GetItem(i: integer): TTableCheck;
begin
  result := TTableCheck(inherited Items[i]);
end;

procedure TTableChecks.Remove(AProc: TTableCheckProc);
var
  c: integer;
begin
  for c := 0 to Count - 1 do
    if (TMethod(Items[c].FProc).Data = TMethod(AProc).Data) and
       (TMethod(Items[c].FProc).Code = TMethod(AProc).Code) then
    begin
      Delete(c); 
      exit;
    end;
end;

procedure TTableChecks.SetItem(i: integer; const Value: TTableCheck);
begin
  Items[i].Assign(Value);
end;

{ TRelationshipChecks }

function TRelationshipChecks.Add(AProc: TRelationshipCheckProc): TRelationshipCheck;
begin
  result := TRelationshipCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TRelationshipChecks.Create;
begin
  inherited Create(TRelationshipCheck);
end;

function TRelationshipChecks.GetItem(i: integer): TRelationshipCheck;
begin
  result := TRelationshipCheck(inherited Items[i]);
end;

procedure TRelationshipChecks.SetItem(i: integer; const Value: TRelationshipCheck);
begin
  Items[i].Assign(Value);
end;

{ TObjectChecks }

function TObjectChecks.Add(AProc: TObjectCheckProc): TObjectCheck;
begin
  result := TObjectCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TObjectChecks.Create;
begin
  inherited Create(TObjectCheck);
end;

function TObjectChecks.GetItem(i: integer): TObjectCheck;
begin
  result := TObjectCheck(inherited Items[i]);
end;

procedure TObjectChecks.SetItem(i: integer; const Value: TObjectCheck);
begin
  Items[i].Assign(Value);
end;

{ TFieldChecks }

function TFieldChecks.Add(AProc: TFieldCheckProc): TFieldCheck;
begin
  result := TFieldCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TFieldChecks.Create;
begin
  inherited Create(TFieldCheck);
end;

function TFieldChecks.GetItem(i: integer): TFieldCheck;
begin
  result := TFieldCheck(inherited Items[i]);
end;

procedure TFieldChecks.SetItem(i: integer; const Value: TFieldCheck);
begin
  Items[i].Assign(Value);
end;

{ TConstraintChecks }

function TConstraintChecks.Add(AProc: TConstraintCheckProc): TConstraintCheck;
begin
  result := TConstraintCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TConstraintChecks.Create;
begin
  inherited Create(TConstraintCheck);
end;

function TConstraintChecks.GetItem(i: integer): TConstraintCheck;
begin
  result := TConstraintCheck(inherited Items[i]);
end;

procedure TConstraintChecks.SetItem(i: integer; const Value: TConstraintCheck);
begin
  Items[i].Assign(Value);
end;

{ TIndexChecks }

function TIndexChecks.Add(AProc: TIndexCheckProc): TIndexCheck;
begin
  result := TIndexCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TIndexChecks.Create;
begin
  inherited Create(TIndexCheck);
end;

function TIndexChecks.GetItem(i: integer): TIndexCheck;
begin
  result := TIndexCheck(inherited Items[i]);
end;

procedure TIndexChecks.SetItem(i: integer; const Value: TIndexCheck);
begin
  Items[i].Assign(Value);
end;

{ TTriggerChecks }

function TTriggerChecks.Add(AProc: TTriggerCheckProc): TTriggerCheck;
begin
  result := TTriggerCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TTriggerChecks.Create;
begin
  inherited Create(TTriggerCheck);
end;

function TTriggerChecks.GetItem(i: integer): TTriggerCheck;
begin
  result := TTriggerCheck(inherited Items[i]);
end;

procedure TTriggerChecks.SetItem(i: integer; const Value: TTriggerCheck);
begin
  Items[i].Assign(Value);
end;

{ TModelChecks }

function TModelChecks.Add(AProc: TModelCheckProc): TModelCheck;
begin
  result := TModelCheck(inherited Add);
  result.FProc := AProc;
end;

constructor TModelChecks.Create;
begin
  inherited Create(TModelCheck);
end;

function TModelChecks.GetItem(i: integer): TModelCheck;
begin
  result := TModelCheck(inherited Items[i]);
end;

procedure TModelChecks.SetItem(i: integer; const Value: TModelCheck);
begin
  Items[i].Assign(Value);
end;

initialization

finalization
  if Assigned(vProjectChecker) then
    FreeAndNil(vProjectChecker);

end.

