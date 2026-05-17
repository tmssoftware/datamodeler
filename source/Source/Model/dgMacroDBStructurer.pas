unit dgMacroDBStructurer;

interface

uses
   SysUtils, Classes, DB, dgDBStructurer, uGDAO, dgConsts, uSQLMacro, atScript, atScripter,
   Vcl.ScripterInit;

type
  TMacroDBStructurer = class(TDBStructurer)
  private
    FScripter: TatScripter;
    FBasicScript: TatScript;

    {Context variables}
    FTable: TGDAOTable;
    FField: TGDAOField;
    FOldField: TGDAOField;
    FIndex: TGDAOIndex;
    FRelationship: TGDAORelationship;
    FDomain: TGDAODomain;
    FConstraint: TGDAOConstraint;
    FTrigger: TGDAOTrigger;
    FIField: TGDAOIField;
    FObject: TGDAOObject;

    FTableOldName: string;
    FFieldOldName: string;
    FIndexOldName: string;

    FScriptExpressions: TStringList;

    function BuildSQL(AExpression: string; IgnoreOptionals: boolean): string;
    function BuildIndexListFields(AIndex: TGDAOIndex; AIsUniqueKey: boolean): string;
    function BuildRelationshipListFields(ARelationship: TGDAORelationship; AParentFields: boolean): string;
    function BuildTableListConstraints(ATable: TGDAOTable): string;
    function BuildTableListFields(ATable: TGDAOTable): string;
    function BuildTableListPkFields(ATable: TGDAOTable): string;
    function BuildTableListRelationships(ATable: TGDAOTable): string;

    procedure ClearContext;
    function CheckExpression(AExpression: string): string;
    procedure ExpressionEvalProc(var AExprInfo: TSQLMacroExprInfo);

    procedure PrepareConstraintContext(AConstraint: TGDAOConstraint);
    procedure PrepareFieldContext(AField: TGDAOField; AOldName: string='';
      AOldField: TGDAOField = nil);
    procedure PrepareIndexContext(AIndex: TGDAOIndex; AOldName: string='');
    procedure PrepareDomainContext(ADomain: TGDAODomain);
    procedure PrepareRelationshipContext(ARelationship: TGDAORelationship);
    procedure PrepareTableContext(ATable: TGDAOTable; AOldName: string='');
    procedure PrepareTriggerContext(ATrigger: TGDAOTrigger);
    procedure PrepareObjectContext(AObject: TGDAOObject);

    function TranslateExpr(AExpr: string): string;
    function TranslateNativeId(AId: TSQLMacroNativeID): string;
    function TranslateEnumExpr(AIndex: integer; AExpr: string): string;

    function TranslateObjectCustomProp(AProp: TGDAOPropDef): string;

    procedure ScriptExprProc(AMachine: TatVirtualMachine);
    procedure ScriptIIFProc(AMachine: TatVirtualMachine);
    function ExtractProcedureHeader(ACode: string): string;
  protected
    property ScriptExpressions: TStringList read FScriptExpressions;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ChangeDomain(ADomain: TGDAODomain); override;
    procedure ChangeFieldDefaultValue(AField, OldField: TGDAOField); override;
    procedure ChangeFieldExclusiveness(AField: TGDAOField); override;
    procedure ChangeFieldRequired(AField: TGDAOField); override;
    procedure ChangeFieldSize(AField: TGDAOField); override;
    procedure ChangeFieldType(AField: TGDAOField); override;
    procedure CreateField(AField: TGDAOField); override;
    procedure CreateIndex(AIndex: TGDAOIndex); override;
    procedure CreateDomain(ADomain: TGDAODomain); override;
    procedure CreateRelationship(ARelationship: TGDAORelationship); override;
    procedure CreateTable(ATable: TGDAOTable); override;
    procedure CreateTableConstraint(AConstraint: TGDAOConstraint); override;
    procedure RemoveTableConstraint(AConstraint: TGDAOConstraint); override;
    procedure CreateTrigger(ATrigger: TGDAOTrigger); override;
    procedure CreatePrimaryKey(ATable: TGDAOTable); override;
    procedure GenerateSQL(ASQL: string; AOrder: integer);
    procedure RemoveField(AField: TGDAOField); override;
    procedure RemoveIndex(AIndex: TGDAOIndex); override;
    procedure RemoveDomain(ADomain: TGDAODomain); override;
    procedure RemoveRelationship(ARelationship: TGDAORelationship); override;
    procedure RemoveTable(ATable: TGDAOTable); override;
    procedure RemoveTrigger(ATrigger: TGDAOTrigger); override;
    procedure RemovePrimaryKey(ATable: TGDAOTable); override;
    procedure RenameField(AField: TGDAOField; AOldName: string); override;
    //procedure RenameIndex(AIndex: TGDAOIndex; AOldName: string); override;
    procedure RenameTable(ATable: TGDAOTable; AOldName: string); override;
    procedure CreateConstraintFieldCheck(AField: TGDAOField); override;
    procedure CreateConstraintFieldDefault(AField: TGDAOField); override;
    procedure CreateConstraintFieldNotNull(AField: TGDAOField); override;
    procedure RemoveConstraintFieldCheck(AField: TGDAOField); override;
    procedure RemoveConstraintFieldDefault(AField: TGDAOField); override;
    procedure RemoveConstraintFieldNotNull(AField: TGDAOField); override;
    procedure CreateExtraObject(AObject: TGDAOObject; UseAlter: boolean); override;
    procedure RemoveExtraObject(AObject: TGDAOObject); override;
    procedure CommentDomain(ADomain: TGDAODomain); override;
    procedure CommentExtraObject(AObject: TGDAOObject); override;
    procedure CommentField(AField: TGDAOField); override;
    procedure CommentTable(ATable: TGDAOTable); override;
    procedure CommentTrigger(ATrigger: TGDAOTrigger); override;
    function SQLTerminator: string; override;
  end;

implementation

uses
  dgMacroConsts, Variants, Math;

{ TMacroDBStructurer }

procedure TMacroDBStructurer.CreateField(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATEFIELD], false), SQLSort_CreateField);
end;

procedure TMacroDBStructurer.CreateIndex(AIndex: TGDAOIndex);
begin
  PrepareIndexContext(AIndex);
  if (AIndex.IndexType = itUniqueKey) and DBType.UniqueKeyWithSpecificSyntax then
    GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATEUNIQUE], false), SQLSort_CreateIndex)
  else
    GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATEINDEX], false), SQLSort_CreateIndex);
end;

procedure TMacroDBStructurer.CreatePrimaryKey(ATable: TGDAOTable);
begin
  PrepareTableContext(ATable);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATECONSTRAINTPK], false), SQLSort_CreateTableConstraint);
end;

procedure TMacroDBStructurer.CreateRelationship(ARelationship: TGDAORelationship);
begin
  PrepareRelationshipContext(ARelationship);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATERELATIONSHIP], false),
    SQLSort_CreateRelationship);
end;

procedure TMacroDBStructurer.RemoveConstraintFieldCheck(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVECONSTRAINTFLDCHECK], false),
    SQLSort_DropFieldConstraint);
end;

procedure TMacroDBStructurer.RemoveConstraintFieldDefault(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVECONSTRAINTFLDDEFAULT], false),
    SQLSort_DropFieldConstraint);
end;

procedure TMacroDBStructurer.RemoveConstraintFieldNotNull(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVECONSTRAINTFLDNOTNULL], false),
    SQLSort_DropFieldConstraint);
end;

procedure TMacroDBStructurer.RemoveDomain(ADomain: TGDAODomain);
begin
  PrepareDomainContext(ADomain);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVEDOMAIN], false),
    SQLSort_DropDomain);
end;

procedure TMacroDBStructurer.RemoveExtraObject(AObject: TGDAOObject);
var
  SortValue: integer;
begin
  PrepareObjectContext(AObject);
  case AObject.OwnerCategory.CategoryType of
    ctProcedure:
      SortValue := SQLSort_DropProcedure;
    ctView:
      SortValue := SQLSort_DropView;
    ctSequence:
      SortValue := SQLSort_DropSequence;
    ctFunction:
      SortValue := SQLSort_DropFunction;
  else
    SortValue := SQLSort_DropExtraObject;
  end;

  GenerateSQL(BuildSQL(AObject.DropImplementation, true), SortValue);
end;

procedure TMacroDBStructurer.RemoveField(AField: TGDAOField);
begin                 
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVEFIELD], false),
    SQLSort_DropField);
end;

procedure TMacroDBStructurer.RemoveIndex(AIndex: TGDAOIndex);
begin
  PrepareIndexContext(AIndex);
  if (AIndex.IndexType = itUniqueKey) and DBType.UniqueKeyWithSpecificSyntax then
    GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVEUNIQUE], false),
      SQLSort_DropIndex)
  else
    GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVEINDEX], false),
      SQLSort_DropIndex);
end;

procedure TMacroDBStructurer.RemovePrimaryKey(ATable: TGDAOTable);
begin                                                                  
  PrepareTableContext(ATable);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVECONSTRAINTPK], false), SQLSort_DropTableConstraint);
end;

procedure TMacroDBStructurer.RemoveRelationship(ARelationship: TGDAORelationship);
begin
  PrepareRelationshipContext(ARelationship);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVERELATIONSHIP], false),
    SQLSort_DropRelationship);
end;

procedure TMacroDBStructurer.RemoveTable(ATable: TGDAOTable);
begin
  PrepareTableContext(ATable);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVETABLE], false),
    SQLSort_DropTable);
end;

procedure TMacroDBStructurer.ExpressionEvalProc(var AExprInfo: TSQLMacroExprInfo);
begin
  AExprInfo.FinalString := TranslateExpr(AExprInfo.Expression);
end;

function TMacroDBStructurer.ExtractProcedureHeader(ACode: string): string;
var
  I, P, Len: Integer;
  S: string;
begin
  Len := Length(ACode);
  S := Uppercase(ACode);
  P := 0;
  I := 2;
  while (I + 2) <= Len do
  begin
    if
      CharInSet(S[I - 1], [' ', #13, #10, ')']) and
      (S[I] = 'A') and
      (S[I + 1] = 'S') and
      CharInSet(S[I + 2], [' ', #13, #10, '(']) then
    begin
      P := I;
      break;
    end;
    Inc(I);
  end;

  Result := ACode;

  if (P > 0) then
  begin
    Delete(Result, P, MaxInt);
    Result := Result + 'AS BEGIN SUSPEND; END';
  end;
end;

procedure TMacroDBStructurer.PrepareConstraintContext(AConstraint: TGDAOConstraint);
begin
  ClearContext;
  FConstraint := AConstraint;
  FTable := AConstraint.OwnerTable;
end;

procedure TMacroDBStructurer.PrepareDomainContext(ADomain: TGDAODomain);
begin
  ClearContext;
  FDomain := ADomain;
end;

procedure TMacroDBStructurer.PrepareFieldContext(AField: TGDAOField;
  AOldName: string = ''; AOldField: TGDAOField = nil);
begin
  ClearContext;
  FField := AField;
  FTable := AField.OwnerTable;
  FFieldOldName := AOldName;
  FOldField := AOldField;
end;

procedure TMacroDBStructurer.PrepareIndexContext(AIndex: TGDAOIndex; AOldName: string);
begin
  ClearContext;
  FIndex := AIndex;
  FTable := AIndex.OwnerTable;
  FIndexOldName := AOldName;
end;

procedure TMacroDBStructurer.PrepareObjectContext(AObject: TGDAOObject);
begin
  ClearContext;
  FObject := AObject;
end;

procedure TMacroDBStructurer.PrepareRelationshipContext(ARelationship: TGDAORelationship);
begin
  ClearContext;
  FRelationship := ARelationship;
  FTable := ARelationship.ChildTable;
end;

procedure TMacroDBStructurer.PrepareTableContext(ATable: TGDAOTable; AOldName: string);
begin
  ClearContext;
  FTable := ATable;
  FTableOldName := AOldName;
end;

procedure TMacroDBStructurer.PrepareTriggerContext(ATrigger: TGDAOTrigger);
begin
  ClearContext;
  FTrigger := ATrigger;
  FTable := ATrigger.OwnerTable;
end;

procedure TMacroDBStructurer.ChangeFieldRequired(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CHANGEFIELDREQUIRED], false),
    SQLSort_ChangeField);
end;

procedure TMacroDBStructurer.CreateTable(ATable: TGDAOTable);
begin
  PrepareTableContext(ATable);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATETABLE], false),
    SQLSort_CreateTable);
end;

constructor TMacroDBStructurer.Create;
begin
  inherited Create;
  FScriptExpressions := TStringList.Create;
  FScripter := TatScripter.Create(nil);
  FScripter.DefineMethod('Expr', 1, tkString, nil, ScriptExprProc);
  FScripter.DefineMethod('IIF', 3, tkString, nil, ScriptIIFProc);
  FScripter.DefineMethod('_IF', 3, tkString, nil, ScriptIIFProc);
  FScripter.Scripts.Clear;
  FBasicScript := FScripter.AddScript(slBasic);
end;

procedure TMacroDBStructurer.CreateConstraintFieldCheck(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATECONSTRAINTFLDCHECK], false),
    SQLSort_CreateFieldConstraint);
end;

procedure TMacroDBStructurer.CreateConstraintFieldDefault(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATECONSTRAINTFLDDEFAULT], false),
    SQLSort_CreateFieldConstraint);
end;

procedure TMacroDBStructurer.CreateConstraintFieldNotNull(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATECONSTRAINTFLDNOTNULL], false),
    SQLSort_CreateFieldConstraint);
end;

procedure TMacroDBStructurer.CreateDomain(ADomain: TGDAODomain);
begin
  PrepareDomainContext(ADomain);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATEDOMAIN], false),
    SQLSort_CreateDomain);
end;

procedure TMacroDBStructurer.CreateExtraObject(AObject: TGDAOObject; UseAlter: boolean);
var
  AMacroName: string;
  SortValue: integer;
  SortValueHeader: integer;
  IgnoreOptional: boolean;
  SavedCode: string;
begin
  PrepareObjectContext(AObject);
  SortValueHeader := -1;
  case AObject.OwnerCategory.CategoryType of
    ctProcedure:
      begin
        SortValue := SQLSort_CreateProcedure;
        SortValueHeader := SQLSort_CreateProcedureHeader;
      end;
    ctView:
      SortValue := SQLSort_CreateView;
    ctSequence:
      SortValue := SQLSort_CreateSequence;
    ctFunction:
      SortValue := SQLSort_CreateFunction;
  else
    SortValue := SQLSort_CreateExtraObject;
  end;

  IgnoreOptional := AObject.OwnerCategory.CategoryType <> TGDAOCategoryType.ctSequence;
  AMacroName := Format('Create%s', [GDAOCategoryMacroName[AObject.OwnerCategory.CategoryType]]);

  SavedCode := AObject.CreateImplementation;
  if UseAlter then
  begin
    AObject.CreateImplementation := ExtractProcedureHeader(SavedCode);

    if FScriptExpressions.IndexOfName(AMacroName) >= 0 then
      GenerateSQL(BuildSQL(FScriptExpressions.Values[AMacroName], IgnoreOptional), SortValueHeader)
    else
      GenerateSQL(BuildSQL(AObject.CreateImplementation, IgnoreOptional), SortValueHeader);

    AObject.CreateImplementation := StringReplace(SavedCode,
      'CREATE', 'ALTER', [rfIgnoreCase]);
  end;
  try
    if FScriptExpressions.IndexOfName(AMacroName) >= 0 then
      GenerateSQL(BuildSQL(FScriptExpressions.Values[AMacroName], IgnoreOptional), SortValue)
    else
      GenerateSQL(BuildSQL(AObject.CreateImplementation, IgnoreOptional), SortValue);
  finally
    AObject.CreateImplementation := SavedCode;
  end;
end;

destructor TMacroDBStructurer.Destroy;
begin
  FScriptExpressions.Free;
  FScripter.Free;
  inherited;
end;

procedure TMacroDBStructurer.ChangeFieldSize(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CHANGEFIELDSIZE], false),
    SQLSort_ChangeField);
end;

procedure TMacroDBStructurer.RenameTable(ATable: TGDAOTable; AOldName: string);
begin
  PrepareTableContext(ATable, AOldName);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_RENAMETABLE], false),
    SQLSort_RenameTable);
end;

procedure TMacroDBStructurer.ScriptExprProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    ReturnOutputArg(BuildSQL('<%' + GetInputArgAsString(0) + '%>', false));
end;

procedure TMacroDBStructurer.ScriptIIFProc(AMachine: TatVirtualMachine);
begin
  with AMachine do
    if GetInputArgAsBoolean(0) then
      ReturnOutputArg(GetInputArg(1))
    else
      ReturnOutputArg(GetInputArg(2));
end;

function TMacroDBStructurer.SQLTerminator: string;
begin
  result := FScriptExpressions.Values[SQL_DEFAULTTERMINATOR];
end;

function TMacroDBStructurer.TranslateObjectCustomProp(
  AProp: TGDAOPropDef): string;
begin
  result := '';
  if FObject <> nil then
    result := VarToSTr(FObject.ReadProp(AProp.PropName));  
end;

function TMacroDBStructurer.TranslateEnumExpr(AIndex: integer; AExpr: string): string;
var expr: string;
begin
  result := '';
  expr := FScriptExpressions.Values[AExpr];
  if expr > '' then
    with TStringList.Create do
    try
      CommaText := expr;
      if (AIndex >= 0) and (AIndex < Count) then
        result := Strings[AIndex];
    finally
      Free;
    end;
end;

function TMacroDBStructurer.TranslateExpr(AExpr: string): string;

  function CheckNativeId(var AId: TSQLMacroNativeId): boolean;
  var
    c: TSQLMacroNativeId;
  begin
    result := false;
    for c := Low(TSQLMacroNativeID) to High(TSQLMacroNativeID) do
    begin
      if SameText(NativeIDName[c], AExpr) then
      begin
        result := true;
        AId := c;
      end;
    end;
  end;

  function IsObjectCustomProp(var AProp: TGDAOPropDef): boolean;
  const
    SObjectPropPrefix = 'obj_';
  var
    APropName: string;
  begin
    AProp := nil;
    if (FObject <> nil) and (FObject.OwnerCategory <> nil)
      and SameText(Copy(AExpr, 1, Length(SObjectPropPrefix)), SObjectPropPrefix) then
    begin
      APropName := Copy(AExpr, Length(SObjectPropPrefix) + 1, MaxInt);
      AProp := FObject.OwnerCategory.PropDefs.FindProp(APropName);
    end;
    result := AProp <> nil;
  end;

var
  NativeID: TSQLMacroNativeId;
  AProp: TGDAOPropDef;
begin
  {Check native types}
  if CheckNativeId(NativeID) then
    result := TranslateNativeId(NativeID)
  else

  { Custom properties of objects}
  if IsObjectCustomProp(AProp) then
    result := TranslateObjectCustomProp(AProp)
  else
  

  { Reference to other identifiers }
  if FScriptExpressions.IndexOfName(AExpr) >= 0 then
    result := BuildSQL(FScriptExpressions.Values[AExpr], false)
  else

  { Script expression }
  if (Length(AExpr) > 0) and (AExpr[1] = '=') then
  begin
    FBasicScript.SourceCode.Text := Format('MAIN = %s',
      [Copy(AExpr, 2, MaxInt)]);
    result := VarToStr(FBasicScript.VirtualMachine.Execute);
  end;
end;

function TMacroDBStructurer.TranslateNativeId(AId: TSQLMacroNativeID): string;

  function DelimitedId(Id: string): string;
  begin
    (*if id is empty, do not delimit, otherwise we will return non-empty
     string, and the parser might incorrectly include pieces of code
     that should be excluded, like

      {CONSTRAINT <%constraintname%>}

      will return

      CONSTRAINT []
     *)
    if (Trim(Id) > '') and DBType.MustDelimitId(Id) then
      result :=
        TranslateExpr(SQL_OPENDELIMITEDID) +
        Id +
        TranslateExpr(SQL_CLOSEDELIMITEDID)
    else
      result := Id;
  end;

begin
  result := '';
  
  case AId of
    niTableName:
      if FTable <> nil then
        result := DelimitedId(FTable.TableName);
    niTableLstFields:
      if FTable <> nil then
        result := BuildTableListFields(FTable);
    niTableLstConstraints:
      if FTable <> nil then
        result := BuildTableListConstraints(FTable);
    niFieldName:
      if FField <> nil then
        result := DelimitedId(FField.FieldName);
    niFieldType:
      if (FField <> nil) and not FField.DataType.Computed then
        result := FField.DataType.BuildPhysicalExpression(FField);
    niFieldNull:
      if FField <> nil then
        result := TranslateEnumExpr(Integer(not FField.Required), SQL_FIELDNULL);
    niFieldDefault:
      if FField <> nil then
        result := FField.DefaultValue;
    niOldFieldDefault:
      if FOldField <> nil then
        result := FOldField.DefaultValue;
    niIndexType:
      if FIndex <> nil then
        result := TranslateEnumExpr(Ord(FIndex.IndexType), SQL_INDEXTYPE);
    niIndexName:
      if FIndex <> nil then
        result := DelimitedId(FIndex.IndexName);
    niIndexOrder:
      if FIndex <> nil then
        result := TranslateEnumExpr(Ord(FIndex.IndexOrder), SQL_INDEXORDER);
    niIndexFieldName:
      if (FIField <> nil) and (FIField.Field <> nil) then
        result := DelimitedId(FIField.Field.FieldName);
    niIndexFieldOrder:
      if FIField <> nil then
        result := TranslateEnumExpr(Ord(FIField.FieldOrder), SQL_INDEXFIELDORDER);
    niIndexLstFields:
      if FIndex <> nil then
        result := BuildIndexListFields(FIndex, false);

    niUniqueType:
      if FIndex <> nil then
        result := TranslateEnumExpr(Ord(FIndex.IndexType), SQL_UNIQUETYPE);
    niUniqueName:
      if FIndex <> nil then
        result := DelimitedId(FIndex.IndexName);
    niUniqueOrder:
      if FIndex <> nil then
        result := TranslateEnumExpr(Ord(FIndex.IndexOrder), SQL_UNIQUEORDER);
    niUniqueFieldName:
      if (FIField <> nil) and (FIField.Field <> nil) then
        result := DelimitedId(FIField.Field.FieldName);
    niUniqueFieldOrder:
      if FIField <> nil then
        result := TranslateEnumExpr(Ord(FIField.FieldOrder), SQL_UNIQUEFIELDORDER);
    niUniqueLstFields:
      if FIndex <> nil then
        result := BuildIndexListFields(FIndex, true);

    niRelName:
      if FRelationship <> nil then
        result := DelimitedId(FRelationship.RelationshipName);
    niRelChildTable:
      if FRelationship <> nil then
        result := DelimitedId(FRelationship.ChildTableName);
    niRelChildFields:
      if FRelationship <> nil then
        result := BuildRelationshipListFields(FRelationship, False);
    niRelParentTable:
      if FRelationship <> nil then
        result := DelimitedId(FRelationship.ParentTableName);
    niRelParentFields:
      if FRelationship <> nil then
        result := BuildRelationshipListFields(FRelationship, True);
    niRelDeleteAction:
      if FRelationship <> nil then
        result := TranslateEnumExpr(Ord(FRelationship.DeleteMethod), SQL_RELATIONSHIPDELETEACTION);
    niRelUpdateAction:
      if FRelationship <> nil then
        result := TranslateEnumExpr(Ord(FRelationship.UpdateMethod), SQL_RELATIONSHIPUPDATEACTION);
    niConstraintPkName:
      if (FTable <> nil) and (FTable.PrimaryKeyIndex.IFields.Count > 0) and not FTable.HasPrimaryKeyDataType then
        result := DelimitedId(FTable.PrimaryKeyIndex.IndexName);
    niConstraintPkFields:
      if FTable <> nil then
        result := BuildTableListPkFields(FTable);
    niConstraintCheckName:
      if FConstraint <> nil then
        result := DelimitedId(FConstraint.ConstraintName);
    niConstraintCheckExpr:
      if FConstraint <> nil then
        result := CheckExpression(FConstraint.Expression);
    niConstraintCheckFldName:
      if FField <> nil then
        result := DelimitedId(FField.ConstraintName);
    niConstraintCheckFldExpr:
      if FField <> nil then
        result := CheckExpression(FField.ConstraintExpr);
    niConstraintDefaultName:
      if FField <> nil then
        result := DelimitedId(FField.ConstraintDefaultName);
    niOldConstraintDefaultName:
      if FOldField <> nil then
        result := DelimitedId(FOldField.ConstraintDefaultName);
    niConstraintDefaultExpr:
      result := '';
    niConstraintNotNullName:
      if FField <> nil then
        result := DelimitedId(FField.ConstraintNotNullName);
    niConstraintNotNullExpr:
      result := '';
    niTriggerName:
      if FTrigger <> nil then
        result := DelimitedId(FTrigger.Name);
    niTriggerCode:
      if FTrigger <> nil then
        result := BuildSQL(FTrigger.ImplementationCode, true);
//    niTriggerEvent:
//      if FTrigger <> nil then
//        result := TranslateEnumExpr(Ord(FTrigger.Event), SQL_TRIGGEREVENT);
    niFieldOldName:
      result := DelimitedId(FFieldOldName);
    niIndexOldName:
      result := DelimitedId(FIndexOldName);
    niUniqueOldName:
      result := DelimitedId(FIndexOldName);
    niTableOldName:
      result := DelimitedId(FTableOldName);
    niObjectName:
      if FObject <> nil then
        result := DelimitedId(FObject.ObjectName);
    niObjectCode:
      if FObject <> nil then
        result := BuildSQL(FObject.CreateImplementation, true);
    niFieldExpression:
      if (FField <> nil) and FField.DataType.Computed then
        result := FField.DataType.BuildPhysicalExpression(FField);
    niDomainName:
      if FDomain <> nil then
        result := DelimitedId(FDomain.Name);
    niDomainType:
      if (FDomain <> nil) and not FDomain.DataType.Computed then
        result := FDomain.DataType.BuildPhysicalExpression(FDomain);
    niDomainCheckExpr:
      if FDomain <> nil then
        result := FDomain.ConstraintExpr;
    niDomainDefault:
      if FDomain <> nil then
        result := FDomain.DefaultValue;
    niDomainExpression:
      if (FDomain <> nil) and FDomain.DataType.Computed then
        result := FDomain.DataType.BuildPhysicalExpression(FDomain);
    niDomainInformation:
      if (FDomain <> nil) then
        result := QuotedStr(FDomain.Information);
    niFieldDescription:
      if FField <> nil then
        result := QuotedStr(FField.Description);
    niObjectDescription:
      if FObject <> nil then
        result := QuotedStr(FObject.Description);
    niTableDescription:
      if FTable <> nil then
        result := QuotedStr(FTable.Description);
    niTriggerDescription:
      if FTrigger <> nil then
        result := QuotedStr(FTrigger.Description);
    niTableLstRelationships:
      if FTable <> nil then
        result := BuildTableListRelationships(FTable);
  end;
end;

procedure TMacroDBStructurer.ChangeFieldType(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CHANGEFIELDTYPE], false), SQLSort_ChangeField);
end;

function TMacroDBStructurer.CheckExpression(AExpression: string): string;
var
  s: string;
begin
  s := LowerCase(StringReplace(AExpression, ' ', '', [rfReplaceAll]));
  if Pos('check(', s) = 1 then
  begin
    result := Trim(StringReplace(AExpression, 'check', '', [rfIgnoreCase]));
    Delete(result, 1, 1);
    if (result > '') and (result[length(result)] = ')') then
      Delete(result, length(result), 1);
  end
  else
    result := AExpression;
end;

procedure TMacroDBStructurer.ClearContext;
begin
  FTable := nil;
  FField := nil;
  FOldField := nil;
  FIndex := nil;
  FRelationship := nil;
  FConstraint := nil;
  FTrigger := nil;
  FIField := nil;
  FObject := nil;

  FTableOldName := '';
  FFieldOldName := '';
  FIndexOldName := '';
end;

procedure TMacroDBStructurer.CommentDomain(ADomain: TGDAODomain);
begin
  PrepareDomainContext(ADomain);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_COMMENTDOMAIN], false), SQLSort_CommentObject);
end;

procedure TMacroDBStructurer.CommentExtraObject(AObject: TGDAOObject);
var
  macroName: string;
begin
  PrepareObjectContext(AObject);
  macroName := Format('Comment%s', [GDAOCategoryMacroName[AObject.OwnerCategory.CategoryType]]);
  if FScriptExpressions.IndexOfName(macroName) >= 0 then
    GenerateSQL(BuildSQL(FScriptExpressions.Values[macroName], false), SQLSort_CommentObject);
end;

procedure TMacroDBStructurer.CommentField(AField: TGDAOField);
begin
  PrepareFieldContext(AField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_COMMENTFIELD], false), SQLSort_CommentObject);
end;

procedure TMacroDBStructurer.CommentTable(ATable: TGDAOTable);
begin
  PrepareTableContext(ATable);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_COMMENTTABLE], false), SQLSort_CommentObject);
end;

procedure TMacroDBStructurer.CommentTrigger(ATrigger: TGDAOTrigger);
begin
  PrepareTriggerContext(ATrigger);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_COMMENTTRIGGER], false), SQLSort_CommentObject);
end;

procedure TMacroDBStructurer.CreateTrigger(ATrigger: TGDAOTrigger);
begin
  PrepareTriggerContext(ATrigger);

  if FScriptExpressions.IndexOfName(SQL_CREATETRIGGER) >= 0 then
    GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATETRIGGER], true), SQLSort_CreateTrigger)
  else
    GenerateSQL(BuildSQL(FTrigger.ImplementationCode, true), SQLSort_CreateTrigger);
end;
                                         
procedure TMacroDBStructurer.RemoveTrigger(ATrigger: TGDAOTrigger);
begin
  PrepareTriggerContext(ATrigger);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVETRIGGER], false),
    SQLSort_DropTrigger);
end;

procedure TMacroDBStructurer.RenameField(AField: TGDAOField; AOldName: string);
begin
  PrepareFieldContext(AField, AOldName);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_RENAMEFIELD], false),
    SQLSort_RenameField);
end;

{procedure TMacroDBStructurer.RenameIndex(AIndex: TGDAOIndex; AOldName: string);
begin
  PrepareIndexContext(AIndex, AOldName);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_RENAMEINDEX]),
    SQLSort_RenameIndex);
end;}

procedure TMacroDBStructurer.CreateTableConstraint(AConstraint: TGDAOConstraint);
begin
  PrepareConstraintContext(AConstraint);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CREATECONSTRAINTCHECK], false),
    SQLSort_CreateTableConstraint);
end;

procedure TMacroDBStructurer.RemoveTableConstraint(AConstraint: TGDAOConstraint);
begin
  PrepareConstraintContext(AConstraint);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_REMOVECONSTRAINTCHECK], false),
    SQLSort_DropTableConstraint);
end;

procedure TMacroDBStructurer.GenerateSQL(ASQL: string; AOrder: integer);
begin
  ASQL := ASQL + SQLTerminator;
  ExecuteSQL(ASQL, AOrder);
end;

function TMacroDBStructurer.BuildIndexListFields(AIndex: TGDAOIndex; AIsUniqueKey: boolean): string;
var
  i: integer;
  sfield: string;
begin
  for i := 0 to AIndex.IFields.Count - 1 do
  begin
    FIField := AIndex.IFields[i];
    FField := FIField.Field;
    if AIsUniqueKey then
      sfield := BuildSQL(FScriptExpressions.Values[SQL_UNIQUEFIELD], false)
    else
      sfield := BuildSQL(FScriptExpressions.Values[SQL_INDEXFIELD], false);
    if sfield > '' then
    begin
      if result > '' then
        result := result + ',';
      result := result + sfield;
    end;
  end;
end;

function TMacroDBStructurer.BuildRelationshipListFields(ARelationship: TGDAORelationship; AParentFields: boolean): string;
var
  i: integer;
  sfield: string;
begin
  for i := 0 to ARelationship.KeyLinkCount - 1 do
  begin
    if AParentFields then
      FField := ARelationship.KeyLinks[i].ParentField
    else
      FField := ARelationship.KeyLinks[i].ChildField;
      
    sfield := BuildSQL(FScriptExpressions.Values[SQL_RELATIONSHIPFIELD], false);
    if sfield > '' then
    begin
      if result > '' then
        result := result + ',';
      result := result + sfield;
    end;
  end;
end;

function TMacroDBStructurer.BuildSQL(AExpression: string; IgnoreOptionals: boolean): string;
begin
  result := ParseSQLMacro(AExpression, ExpressionEvalProc, IgnoreOptionals);
end;

function TMacroDBStructurer.BuildTableListConstraints(ATable: TGDAOTable): string;
var
  i: integer;
  sconstraint: string;
begin
  result := '';
  for i := 0 to ATable.Constraints.Count - 1 do
  begin
    FConstraint := ATable.Constraints[i];
    sconstraint := BuildSQL(FScriptExpressions.Values[SQL_CONSTRAINTCHECK], false);
    if sconstraint > '' then
    begin
      if result > '' then
        result := result + ',';
      result := result + sconstraint;
    end;
  end;
end;

function TMacroDBStructurer.BuildTableListFields(ATable: TGDAOTable): string;
var
  i: integer;
  sfield: string;
begin
  result := '';
  for i := 0 to ATable.Fields.Count - 1 do
  begin
    FField := ATable.Fields[i];
    sfield := BuildSQL(FScriptExpressions.Values[SQL_TABLEFIELD], false);
    if sfield > '' then
    begin
      if result > '' then
        result := result + ',';
      result := result + sfield;
    end;
  end;
end;

function TMacroDBStructurer.BuildTableListRelationships(
  ATable: TGDAOTable): string;
var
  i: integer;
  sconstraint: string;
begin
  result := '';
  for i := 0 to ATable.OwnerDatabase.Relationships.Count - 1 do
    if ATable.OwnerDatabase.Relationships[i].ChildTable = ATable then
    begin
      FRelationship := ATable.OwnerDatabase.Relationships[i];
      sconstraint := BuildSQL(FScriptExpressions.Values[SQL_CONSTRAINTRELATIONSHIP], false);
      if sconstraint > '' then
      begin
        if result > '' then
          result := result + ',';
        result := result + sconstraint;
      end;
    end;
end;

function TMacroDBStructurer.BuildTableListPkFields(ATable: TGDAOTable): string;
var
  i: integer;
  sfield: string;
begin
  result := '';
  if not FTable.HasPrimaryKeyDataType then
    for i := 0 to ATable.PrimaryKeyIndex.IFields.Count - 1 do
    begin
      FIField := ATable.PrimaryKeyIndex.IFields[I];
      FField := ATable.PrimaryKeyIndex.IFields[i].Field;
      sfield := BuildSQL(FScriptExpressions.Values[SQL_CONSTRAINTFIELD], false);
      if sfield > '' then
      begin
        if result > '' then
          result := result + ',';
        result := result + sfield;
      end;
    end;
end;

procedure TMacroDBStructurer.ChangeDomain(ADomain: TGDAODomain);
begin
  PrepareDomainContext(ADomain);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CHANGEDOMAIN], false),
    SQLSort_ChangeDomain);
end;

procedure TMacroDBStructurer.ChangeFieldDefaultValue(AField, OldField: TGDAOField);
begin
  PrepareFieldContext(AField, '', OldField);
  GenerateSQL(BuildSQL(FScriptExpressions.Values[SQL_CHANGEFIELDDEFAULT], false),
    SQLSort_ChangeField);
end;

procedure TMacroDBStructurer.ChangeFieldExclusiveness(AField: TGDAOField);
begin
//  // removing
//  GenerateSQL(Format('ALTER TABLE %s DROP UNIQUE(%s)',[ATabela, AField.FieldName]));
//
//  // creating
//  s := AField.ExclusiveConstraintName;
//  if s > '' then
//    s := 'CONSTRAINT ' + s;
//  if Afield.Exclusive then
//    GenerateSQL(Format('ALTER TABLE %s ADD %s UNIQUE(%s)',[ATabela, s, AField.FieldName]));
end;

end.

