unit Aurelius.SourceGenerator;

interface

{$IFNDEF AURELIUS_DLL}
  {$DEFINE USE_SCRIPTER}
{$ENDIF}

uses
  Generics.Collections, Generics.Defaults, System.Character,
  SysUtils, Classes, uGDAO, dgConsts, Bcl.Code.MetaClasses,
  Aurelius.Mapping.Attributes,
  Aurelius.Dictionary.Generator,
  {$IFDEF USE_SCRIPTER}
  atScript, IDEMain,
  {$ENDIF}
  Aurelius.SourceGenerator.Options;

type
  EGenInternalError = class(Exception);

  EMissingSequenceError = class(EGUIException)
  private
    FTable: TGDAOTable;
  public
    constructor Create(ATable: TGDAOTable; ASequenceName: string);
    property Table: TGDAOTable read FTable;
  end;

  TStringArray  = array of string;

  TSourceUnit = record
    Name: string;
    Source: string;  
  end;

  TEntityIdInfo = record
  public
    MemberNames: TArray<string>;
    Generator: TIdGenerator;
    SequenceName: string;
  end;

  TSourceGenerator = class
  private
    FOptions: TSourceGeneratorOptions;
    FDictionary: TGDAODatabase;
    FInheritanceParentMap: TDictionary<TGDAOTable, TGDAORelationship>;
    FIsInheritanceBase: TDictionary<TGDAOTable, boolean>;
    FCodeUnits: TList<TCodeUnit>;
    function AppendWithComma(S, S2: string): string;
    function ValidName(S: string): string;
    procedure AddUsedUnit(ACodeUnit: TCodeUnit; AUsedUnit: string); overload;
    procedure AddUsedUnit(ACodeUnit: TCodeUnit; ATable: TGDAOTable); overload;
    procedure CreateColumnAttributeArguments(AAttr: TCodeAttributeDeclaration;
      AField: TGDAOField);
    function DefineIdAttribute(AType: TCodeTypeDeclaration; AIdInfo: TEntityIdInfo):
      TArray<TCodeAttributeDeclaration>;
    function GetConstructor(AType: TCodeTypeDeclaration): TCodeMemberConstructor;
    function GetDestructor(AType: TCodeTypeDeclaration): TCodeMemberDestructor;
    function GetPrimitiveDelphiType(AField: TGDAOField): string;
    function GetChildFieldList(ARelationships: TList<TGDAORelationship>): TList<TGDAOField>;

    function GetSequenceName(ATable: TGDAOTable): string;

    procedure GenerateAssociation(ARelationship: TGDAORelationship; 
      AType: TCodeTypeDeclaration; ACodeUnit: TCodeUnit);
    procedure GenerateManyValuedAssociation(ARelationship: TGDAORelationship; 
      AType: TCodeTypeDeclaration; ACodeUnit: TCodeUnit);
    procedure GenerateField(AField: TGDAOField; AType: TCodeTypeDeclaration;
      AProcessedTables: TStrings; ACodeUnit: TCodeUnit);
    procedure GenerateTable(ATable: TGDAOTable; AProcessedTables: TStrings;
      ACodeUnit: TCodeUnit);
    procedure GenerateDynamicPropContainer(AType: TCodeTypeDeclaration; AContainerName: string);

    procedure GenerateDictionary(ACodeUnit: TCodeUnit);
    procedure GenerateDictionaryV2(ACodeUnit: TCodeUnit);
    procedure GenerateDictionaryTable(ATable: TGDAOTable; ACodeUnit: TCodeUnit; ASchemaType: TCodeTypeDeclaration);
    procedure GenerateDictionaryField(AField: TGDAOField; AType: TCodeTypeDeclaration);
    procedure GenerateDictionaryAssociation(ARelationship: TGDAORelationship; AType: TCodeTypeDeclaration);
    procedure AddDictionaryTableProperties(Entity: TDictionaryMetaEntity; Table: TGDAOTable);
    procedure AddDictionaryTableAssociations(Entity: TDictionaryMetaEntity; Table: TGDAOTable);

    function AddAttribute(AAttrs: TList<TCodeAttributeDeclaration>;
      AName: string; AArguments: array of string): TCodeAttributeDeclaration; overload;
    procedure AddDescription(AAttrs: TList<TCodeAttributeDeclaration>; ADescription: string);
    procedure AddAttribute(AAttrs: TList<TCodeAttributeDeclaration>; AName: string); overload;
    function IdentName(AName: string): string;
    function BuildAssociationName(ARelationship: TGDAORelationship; ANameSource: TAssociationNameSource;
      AFormat: string; ASingularize: boolean; ACamelCase: boolean; ARemoveUnderline: boolean): string;
    function RetrieveIdInfo(ATable: TGDAOTable): TEntityIdInfo;
    procedure ErrorFmt(Msg: string; const Args: array of const);
    procedure BuildInheritanceMap;
    function IsBlob(AType: string): boolean;
    function CodeTypeInheritanceLevel(AUnit: TCodeUnit; CodeType: TCodeTypeDeclaration): integer;
  private
    function FindCodeUnit(AUnitName: string; ACreateIfNotFound: Boolean = True): TCodeUnit;
    procedure CheckUnitCircularReferences(ACodeUnit: TCodeUnit;
      AProcessedUnits: TList<TCodeUnit>; APath: string);
    procedure FireEvent(const Name: string; Args: TObject);
  private
//    FApp: TAppMetaData;
//    FDestroyApp: Boolean;

    {$IFDEF USE_SCRIPTER}
    FScripter: TIDEScripter;
    FScript: TatScript;
    procedure ScriptError(Sender: TObject; var msg: string; row, col: integer;
      var ShowException: boolean);
    {$ENDIF}
    function GetModelNames(ATable: TGDAOTable): TArray<string>;
  public
    constructor Create(ADictionary: TGDAODatabase; AOptions: TSourceGeneratorOptions); overload;
//    constructor Create(ADGPFile: string; AOptions: TSourceGeneratorOptions); overload;
    destructor Destroy; override;
    {$IFDEF USE_SCRIPTER}
    procedure GenerateCodeUnits(AScript: TatScript);
    {$ELSE}
    procedure GenerateCodeUnits;
    {$ENDIF}
    procedure GenerateSourceFiles(AOutputDir: string); overload;
    function GenerateSourceUnits: TArray<TSourceUnit>;
    procedure CheckCircularReferences;

    function TableMapping(ATable: TGDAOTable): TTableMapping;
    function AssociationMapping(AAssociation: TGDAORelationship): TAssociationMapping;
    function FieldMapping(AField: TGDAOField): TFieldMapping;
    function ManyValuedMapping(AManyValued: TGDAORelationship): TAssociationMapping;

    function ClassName(ATable: TGDAOTable): string;
    function PropertyName(AField: TGDAOField): string;
    function InterfaceName(ATable: TGDAOTable): string;
    function PropertyType(AField: TGDAOField): string;
    function AssociationPropertyName(ARelationship: TGDAORelationship): string;
    function ManyValuedAssociationPropertyName(ARelationship: TGDAORelationship): string;
    function TableDictionaryName(ATable: TGDAOTable): string;
    function DynamicPropContainerName(ATable: TGDAOTable): string;

    function GetPrimaryRelationships(ATable: TGDAOTable): TList<TGDAORelationship>;
    function GetForeignRelationships(ATable: TGDAOTable): TList<TGDAORelationship>;
    function GetPropertyFields(ATable: TGDAOTable): TList<TGDAOField>;
    function IsAssociationRequired(ARelationship: TGDAORelationship): boolean;

    {$IFDEF USE_SCRIPTER}
    procedure PrepareScripter(Scripter: TIDEScripter);
    property Scripter: TIDEScripter read FScripter;
    {$ENDIF}
  end;

  TManyValuedAssociationGeneratedArgs = class
  private
    FProp: TCodeMemberProperty;
    FField: TCodeMemberField;
    FCodeUnit: TCodeUnit;
    FCodeType: TCodeTypeDeclaration;
    FGetter: TCodeMemberMethod;
    FAssociationAttr: TCodeAttributeDeclaration;
    FConstructorMethod: TCodeMemberConstructor;
    FDestructorMethod: TCodeMemberDestructor;
    FDBRelationship: TGDAORelationship;
  public
    constructor Create(ACodeUnit: TCodeUnit; ACodeType: TCodeTypeDeclaration;
      AProp: TCodeMemberProperty; AField: TCodeMemberField;
      AGetter: TCodeMemberMethod; AAssociationAttr: TCodeAttributeDeclaration;
      AConstructorMethod: TCodeMemberConstructor;
      ADestructorMethod: TCodeMemberDestructor;
      ADBRelationship: TGDAORelationship
    );
    property Prop: TCodeMemberProperty read FProp write FProp;
    property Field: TCodeMemberField read FField write FField;
    property CodeUnit: TCodeUnit read FCodeUnit;
    property CodeType: TCodeTypeDeclaration read FCodeType;
    property Getter: TCodeMemberMethod read FGetter;
    property AssociationAttr: TCodeAttributeDeclaration read FAssociationAttr;
    property ConstructorMethod: TCodeMemberConstructor read FConstructorMethod;
    property DestructorMethod: TCodeMemberDestructor read FDestructorMethod;
    property DBRelationship: TGDAORelationship read FDBRelationship;
  end;

  TAssociationGeneratedArgs = class
  private
    FProp: TCodeMemberProperty;
    FField: TCodeMemberField;
    FCodeUnit: TCodeUnit;
    FCodeType: TCodeTypeDeclaration;
    FGetter: TCodeMemberMethod;
    FSetter: TCodeMemberMethod;
    FAssociationAttr: TCodeAttributeDeclaration;
    FDBRelationship: TGDAORelationship;
  public
    constructor Create(ACodeUnit: TCodeUnit; ACodeType: TCodeTypeDeclaration;
      AProp: TCodeMemberProperty; AField: TCodeMemberField;
      AGetter: TCodeMemberMethod; ASetter: TCodeMemberMethod;
      AAssociationAttr: TCodeAttributeDeclaration;
      ADBRelationship: TGDAORelationship
    );
    property Prop: TCodeMemberProperty read FProp write FProp;
    property Field: TCodeMemberField read FField write FField;
    property CodeUnit: TCodeUnit read FCodeUnit;
    property CodeType: TCodeTypeDeclaration read FCodeType;
    property Getter: TCodeMemberMethod read FGetter;
    property Setter: TCodeMemberMethod read FSetter;
    property AssociationAttr: TCodeAttributeDeclaration read FAssociationAttr;
    property DBRelationship: TGDAORelationship read FDBRelationship;
  end;

  TColumnGeneratedArgs = class
  private
    FProp: TCodeMemberProperty;
    FField: TCodeMemberField;
    FCodeUnit: TCodeUnit;
    FCodeType: TCodeTypeDeclaration;
    FColumnAttr: TCodeAttributeDeclaration;
    FDBField: TGDAOField;
  public
    constructor Create(ACodeUnit: TCodeUnit; ACodeType: TCodeTypeDeclaration;
      AProp: TCodeMemberProperty; AField: TCodeMemberField;
      AColumnAttr: TCodeAttributeDeclaration;
      ADBField: TGDAOField
    );
    property Prop: TCodeMemberProperty read FProp write FProp;
    property Field: TCodeMemberField read FField write FField;
    property CodeUnit: TCodeUnit read FCodeUnit;
    property CodeType: TCodeTypeDeclaration read FCodeType;
    property ColumnAttr: TCodeAttributeDeclaration read FColumnAttr;
    property DBField: TGDAOField read FDBField;
  end;

  TClassGeneratedArgs = class
  private
    FCodeUnit: TCodeUnit;
    FCodeType: TCodeTypeDeclaration;
    FDBTable: TGDAOTable;
    FSequenceAttr: TCodeAttributeDeclaration;
    FIdAttrs: TArray<TCodeAttributeDeclaration>;
    FTableAttr: TCodeAttributeDeclaration;
  public
    constructor Create(ACodeUnit: TCodeUnit; ACodeType: TCodeTypeDeclaration;
      ADBTable: TGDAOTable; ATableAttr: TCodeAttributeDeclaration;
      AIdAttrs: TArray<TCodeAttributeDeclaration>; ASequenceAttr: TCodeAttributeDeclaration);
    property CodeUnit: TCodeUnit read FCodeUnit;
    property CodeType: TCodeTypeDeclaration read FCodeType;
    property DBTable: TGDAOTable read FDBTable;
    property TableAttr: TCodeAttributeDeclaration read FTableAttr;
//    property IdAttr: TCodeAttributeDeclaration read FIdAttr;
    property SequenceAttr: TCodeAttributeDeclaration read FSequenceAttr;
  end;

  TUnitGeneratedArgs = class
  private
    FCodeUnit: TCodeUnit;
  public
    constructor Create(ACodeUnit: TCodeUnit);
    property CodeUnit: TCodeUnit read FCodeUnit;
  end;

const
  ColumnGeneratedEventName = 'OnColumnGenerated';
  ManyValuedAssociationGeneratedEventName = 'OnManyValuedAssociationGenerated';
  AssociationGeneratedEventName = 'OnAssociationGenerated';
  ClassGeneratedEventName = 'OnClassGenerated';
  UnitGeneratedEventName = 'OnUnitGenerated';

implementation

uses
  DXInflector, Bcl.Code.DelphiGenerator;

function CamelCase(const S: string): string;
var
  Source, Dest: PChar;
  Index, Len: Integer;
begin
  Result := '';
  if S <> '' then
  begin
    Result := LowerCase(S);

    Len := Length(S);
    Source := PChar(S);
    Dest := PChar(Result);
    Inc(Dest);

    for Index := 2 to Len do
    begin
      if (Source^ = '_') and not (Dest^ = '_') then
        Dest^ := UpCase(Dest^);
      Inc(Dest);
      Inc(Source);
    end;
    Result[1] := UpCase(Result[1]);
  end;
end;

function RemoveUnderline(const S: string): string;
begin
  Result := StringReplace(S, '_', '', [rfReplaceAll]);
end;

{ TSourceGenerator }

function TSourceGenerator.AddAttribute(
  AAttrs: TList<TCodeAttributeDeclaration>; AName: string;
  AArguments: array of string): TCodeAttributeDeclaration;
var
  attribute: TCodeAttributeDeclaration;
  i: integer;
begin
  attribute := TCodeAttributeDeclaration.Create(AName);
  for i := Low(AArguments) to High(AArguments) do
    attribute.Arguments.Add(TCodeAttributeArgument.Create(AArguments[i]));
  AAttrs.Add(attribute);
  Result := attribute;
end;

procedure TSourceGenerator.AddAttribute(
  AAttrs: TList<TCodeAttributeDeclaration>; AName: string);
begin
  AddAttribute(AAttrs, AName, []);
end;

procedure TSourceGenerator.AddDescription(
  AAttrs: TList<TCodeAttributeDeclaration>; ADescription: string);
var
  I: Integer;
begin
  ADescription := StringReplace(ADescription, #13#10, '''#13#10''', [rfReplaceAll]);
  ADescription := StringReplace(ADescription, #13, '''#13''', [rfReplaceAll]);
  ADescription := StringReplace(ADescription, #10, '''#10''', [rfReplaceAll]);
  ADescription := StringReplace(ADescription, '''', '''''', [rfReplaceAll]);
  for I := Length(ADescription) div 250 downto 1 do
    Insert(''' + ''', ADescription, I * 250);
  if FOptions.CreateDescriptions then
    AddAttribute(AAttrs, 'Description', [Format('''%s''', [ADescription])]);
end;

procedure TSourceGenerator.AddDictionaryTableAssociations(
  Entity: TDictionaryMetaEntity; Table: TGDAOTable);
var
  d: Integer;
  foreignRelationships: TList<TGDAORelationship>;
  inheritanceRel: TGDAORelationship;
  association: TDictionaryMetaAssociation;
  primaryRelationships: TList<TGDAORelationship>;
begin
  FInheritanceParentMap.TryGetValue(Table, inheritanceRel);
  if inheritanceRel <> nil then
    AddDictionaryTableAssociations(Entity, inheritanceRel.ParentTable);

  foreignRelationships := GetForeignRelationships(Table);
  try
    // Create an association for each foreign relationship
    // Do not include association if it's the inheritance association
    for d := 0 to foreignRelationships.Count - 1 do
      if (not AssociationMapping(foreignRelationships[d]).Excluded)
        and (foreignRelationships[d] <> inheritanceRel) then
        begin
          association := TDictionaryMetaAssociation.Create(
            AssociationPropertyName(foreignRelationships[d]),
            ClassName(foreignRelationships[d].ParentTable)
          );
          entity.Associations.Add(association);
        end;
  finally
    foreignRelationships.Free;
  end;

  // Get the list of primary relationships (where this table is parent)
  primaryRelationships := GetPrimaryRelationships(Table);
  try
    // Create an association for each primary relationship
    for d := 0 to primaryRelationships.Count - 1 do
      if AssociationMapping(primaryRelationships[d]).ManyValuedIncluded then
      begin
        association := TDictionaryMetaAssociation.Create(
          ManyValuedAssociationPropertyName(primaryRelationships[d]),
          ClassName(primaryRelationships[d].ChildTable)
        );
        entity.Associations.Add(association);
      end;
  finally
    primaryRelationships.Free;
  end;
end;

procedure TSourceGenerator.AddDictionaryTableProperties(
  Entity: TDictionaryMetaEntity; Table: TGDAOTable);
var
  d: Integer;
  propFields: TList<TGDAOField>;
  prop: TDictionaryMetaProperty;
  inheritanceRel: TGDAORelationship;
begin
  FInheritanceParentMap.TryGetValue(Table, inheritanceRel);
  if inheritanceRel <> nil then
    AddDictionaryTableProperties(Entity, inheritanceRel.ParentTable);

  propFields := GetPropertyFields(Table);
  try
    for d := 0 to propFields.Count - 1 do
      if not FieldMapping(propFields[d]).Excluded then
      begin
        prop := TDictionaryMetaProperty.Create(PropertyName(propFields[d]));
        entity.Props.Add(prop);
      end;
  finally
    propFields.Free;
  end;
end;

procedure TSourceGenerator.AddUsedUnit(ACodeUnit: TCodeUnit;
  ATable: TGDAOTable);
var
  mapping: TTableMapping;
  usedUnit: string;
begin
  mapping := TableMapping(ATable);
  if Assigned(mapping) and not mapping.Excluded then
  begin
    usedUnit := FindCodeUnit(mapping.ClassUnitName).Name;
    if not SameText(ACodeUnit.Name, usedUnit) then
      AddUsedUnit(ACodeUnit, usedUnit);  
  end;
end;

procedure TSourceGenerator.AddUsedUnit(ACodeUnit: TCodeUnit; AUsedUnit: string);
var
  usedUnit: TCodeUsedUnit;
begin
  for usedUnit in ACodeUnit.InterfaceUnits do
    if SameText(usedUnit.UsedUnit, AUsedUnit) then
      Exit;
  for usedUnit in ACodeUnit.ImplementationUnits do
    if SameText(usedUnit.UsedUnit, AUsedUnit) then
      Exit;
  ACodeUnit.InterfaceUnits.Add(TCodeUsedUnit.Create(AUsedUnit));
end;

function TSourceGenerator.AppendWithComma(S, S2: string): string;
begin
  if S <> '' then
    S := S + ', ';
  S := S + S2;
  result := S;
end;

function TSourceGenerator.AssociationMapping(
  AAssociation: TGDAORelationship): TAssociationMapping;
begin
  if AAssociation = nil then
    Exit(nil);

  if not FOptions.Associations.ContainsKey(AAssociation.RelID) then
    FOptions.Associations.Add(AAssociation.RelID, TAssociationMapping.Create);
  Result := FOptions.Associations[AAssociation.RelID];
end;

function TSourceGenerator.AssociationPropertyName(ARelationship: TGDAORelationship): string;
var
  mapping: TAssociationMapping;
begin
  if FOptions.Associations.TryGetValue(ARelationship.RelID, mapping) and not mapping.DefaultNaming then
    Exit(mapping.PropertyName);

  Result := BuildAssociationName(ARelationship, FOptions.AssociationNameSource, FOptions.AssociationNameFormat, false,
    FOptions.AssociationNameCamelCase, FOptions.AssociationNameRemoveUnderline);
end;

function TSourceGenerator.BuildAssociationName(ARelationship: TGDAORelationship;
  ANameSource: TAssociationNameSource; AFormat: string; ASingularize: boolean;
  ACamelCase: boolean; ARemoveUnderline: boolean): string;
var
  baseName: string;
begin
  case ANameSource of
    asParentTableName: baseName := ARelationship.ParentTableName;
    asParentTableCaption: baseName := ARelationship.ParentTable.TableCaption;
    asChildTableName: baseName := ARelationship.ChildTableName;
    asChildTableCaption: baseName := ARelationship.ChildTable.TableCaption;
    asParentFieldName:
      if (ARelationship.FieldLinks.Count > 0) and (ARelationship.FieldLinks[0].ParentField <> nil) then
        baseName := ARelationship.FieldLinks[0].ParentField.FieldName
      else
        ErrorFmt('Relationship "%s" has no linked fields', [ARelationship.RelationshipName]);
    asParentFieldCaption:
      if (ARelationship.FieldLinks.Count > 0) and (ARelationship.FieldLinks[0].ParentField <> nil) then
        baseName := ARelationship.FieldLinks[0].ParentField.FieldCaption
      else
        ErrorFmt('Relationship "%s" has no linked fields', [ARelationship.RelationshipName]);
    asChildFieldName:
      if (ARelationship.FieldLinks.Count > 0) and (ARelationship.FieldLinks[0].ChildField <> nil) then
        baseName := ARelationship.FieldLinks[0].ChildField.FieldName
      else
        ErrorFmt('Relationship "%s" has no linked fields', [ARelationship.RelationshipName]);
    asChildFieldCaption:
      if (ARelationship.FieldLinks.Count > 0) and (ARelationship.FieldLinks[0].ChildField <> nil) then
        baseName := ARelationship.FieldLinks[0].ChildField.FieldCaption
      else
        ErrorFmt('Relationship "%s" has no linked fields', [ARelationship.RelationshipName]);
    asCaption:
      if ARelationship.Description <> '' then
        baseName := ARelationship.Description
      else
        ErrorFmt('Relationship "%s" has no caption', [ARelationship.RelationshipName]);
  end;

  if ASingularize then
    baseName := TDXInflector.Singularize(baseName);
  if ACamelCase then
    baseName := CamelCase(baseName);
  if ARemoveUnderline then
    baseName := RemoveUnderline(baseName);

  result := Format(AFormat, [baseName]);
  result := IdentName(result);
  result := ValidName(result);
end;

procedure TSourceGenerator.BuildInheritanceMap;
var
  rel, rel2: TGDAORelationship;
  hierarchyBase: TGDAOTable;
  c: Integer;
begin
  // add all descendant/ancestor relation in a dictionary
  for c := 0 to FDictionary.Relationships.Count - 1 do
  begin
    rel := FDictionary.Relationships[c];
    if (rel.Cardinality = rcOneToOne) then
    begin
      if (AssociationMapping(rel).OneToOneMapping = omInheritance) or
        ((AssociationMapping(rel).OneToOneMapping = omDefault) and (FOptions.DefaultOneToOneMapping = omInheritance)) then
        FInheritanceParentMap.AddOrSetValue(rel.ChildTable, rel);
    end;
  end;

  // now find all the inheritance base. this is needed when there are multi-level inheritance,
  // we need to add [Inheritance] attribute only in the base of hierarchy.
  for rel in FInheritanceParentMap.Values do
  begin
    hierarchyBase := rel.ParentTable;
    while FInheritanceParentMap.TryGetValue(hierarchyBase, rel2) do
      hierarchyBase := rel2.ParentTable;
    FIsInheritanceBase.AddOrSetValue(hierarchyBase, true);
  end;
end;

procedure TSourceGenerator.CheckCircularReferences;
var
  codeUnit: TCodeUnit;
  processedUnits: TList<TCodeUnit>;
begin
  processedUnits := TList<TCodeUnit>.Create;
  try
    for codeUnit in FCodeUnits do
    begin
      processedUnits.Clear;
      CheckUnitCircularReferences(codeUnit, processedUnits, '');
    end;
  finally
    processedUnits.Free;
  end;
end;

procedure TSourceGenerator.CheckUnitCircularReferences(ACodeUnit: TCodeUnit;
  AProcessedUnits: TList<TCodeUnit>; APath: string);
var
  unitInUsesClause: TCodeUsedUnit;
begin
  if ACodeUnit = nil then Exit;
  if APath <> '' then
    APath := APath + '->';
  APath := APath + ACodeUnit.Name;

  
  if AProcessedUnits.Contains(ACodeUnit) then
    raise EGUIException.CreateFmt('Circular unit reference: %s', [APath]);
  AProcessedUnits.Add(ACodeUnit);

  for unitInUsesClause in ACodeUnit.InterfaceUnits do
    CheckUnitCircularReferences(FindCodeUnit(unitInUsesClause.UsedUnit, False), AProcessedUnits, APath);
end;

function TSourceGenerator.ClassName(ATable: TGDAOTable): string;
var
  mapping: TTableMapping;
  baseName: string;
begin
  if FOptions.Tables.TryGetValue(ATable.TID, mapping) and not mapping.DefaultNaming then
    Exit(mapping.EntityClassName);

  // default namings
  case FOptions.TableNameSource of
    nsName: baseName := ATable.TableName;
    nsCaption:
      if ATable.TableCaption <> '' then
        baseName := ATable.TableCaption
      else
        ErrorFmt('Table "%s" has no caption', [ATable.TableName]);
  end;

  if FOptions.TableNameSingularize then
    baseName := TDXInflector.Singularize(baseName);
  if FOptions.TableNameCamelCase then
    baseName := CamelCase(baseName);
  if FOptions.TableNameRemoveUnderline then
    baseName := RemoveUnderline(baseName);

  result := Format(FOptions.TableNameFormat, [baseName]);
  result := IdentName(result);
  result := ValidName(result);
end;

function TSourceGenerator.CodeTypeInheritanceLevel(AUnit: TCodeUnit; CodeType: TCodeTypeDeclaration): integer;
begin
  Result := 0;
  while CodeType.BaseType.BaseType <> '' do
  begin
    CodeType := AUnit.FindType(CodeType.BaseType.BaseType);
    if (CodeType = nil) then Exit;
    Inc(Result);
  end;
end;

constructor TSourceGenerator.Create(ADictionary: TGDAODatabase; AOptions: TSourceGeneratorOptions);
begin
  FOptions := AOptions;
  FDictionary := ADictionary;
  FInheritanceParentMap := TDictionary<TGDAOTable, TGDAORelationship>.Create;
  FIsInheritanceBase := TDictionary<TGDAOTable, boolean>.Create;
  FCodeUnits := TObjectList<TCodeUnit>.Create;

  {$IFDEF USE_SCRIPTER}
  FScripter := TIDEScripter.Create(nil);
  FScripter.OnRuntimeError := ScriptError;
  FScripter.OnCompileError := ScriptError;
  PrepareScripter(FScripter);
  {$ENDIF}
end;

//constructor TSourceGenerator.Create(ADGPFile: string;
//  AOptions: TSourceGeneratorOptions);
//begin
//  FApp := TAppMetaData.LoadFromFile(ADGPFile);
//  FDestroyApp := True;
//  Create(FApp.DataDictionary, AOptions);
//end;

procedure TSourceGenerator.CreateColumnAttributeArguments(
  AAttr: TCodeAttributeDeclaration; AField: TGDAOField);
var
  columnProps: string;
  readOnly: boolean;
  lazy: boolean;
begin
  columnProps := '';
  readOnly := AField.DataType.Counter or AField.DataType.Computed;
  lazy := IsBlob(PropertyType(AField));
  if AField.Required then
    columnProps := AppendWithComma(columnProps, 'TColumnProp.Required');
  if readOnly then
    columnProps := AppendWithComma(columnProps, 'TColumnProp.NoInsert');
  if readOnly then
    columnProps := AppendWithComma(columnProps, 'TColumnProp.NoUpdate');
  if lazy then
    columnProps := AppendWithComma(columnProps, 'TColumnProp.Lazy');


  AAttr.Arguments.Add(TCodeAttributeArgument.Create(
    Format('''%s''', [AField.FieldName])));
  AAttr.Arguments.Add(TCodeAttributeArgument.Create(
    Format('[%s]', [columnProps])));
  AAttr.Arguments.Add(TCodeAttributeArgument.Create(IntToStr(AField.Size)));
  AAttr.Arguments.Add(TCodeAttributeArgument.Create(IntToStr(AField.Size2)));

  // Remove default values
  if not AField.DataType.Size2IsRequired then
  begin
    AAttr.Arguments.Remove(AAttr.Arguments.Last);
    if not AField.DataType.SizeIsRequired then
    begin
      AAttr.Arguments.Remove(AAttr.Arguments.Last);

      // Code below commented - do not remove the columnProps argument
      // because the JoinColumn attribute also uses this method to fill its arguments,
      // and there is no overload for JoinColumn.Create the accepts to omit Column Properties parameter
      //if columnProps = '' then
      //  AAttr.Arguments.Remove(AAttr.Arguments.Last);
    end;
  end;
end;

function TSourceGenerator.DefineIdAttribute(AType: TCodeTypeDeclaration; AIdInfo: TEntityIdInfo):
  TArray<TCodeAttributeDeclaration>;
var
  generatorStr: string;
  memberName: string;
begin
  case AIdInfo.Generator of
    TIdGenerator.IdentityOrSequence: generatorStr := 'TIdGenerator.IdentityOrSequence';
    TIdGenerator.Guid: generatorStr := 'TIdGenerator.Guid';
    TIdGenerator.Uuid38: generatorStr := 'TIdGenerator.Uuid38';
    TIdGenerator.Uuid36: generatorStr := 'TIdGenerator.Uuid36';
    TIdGenerator.Uuid32: generatorStr := 'TIdGenerator.Uuid32';
  else
    // idNone
    generatorStr := 'TIdGenerator.None';
  end;
  if Length(AIdInfo.MemberNames) > 1 then
    generatorStr := 'TIdGenerator.None';

  Result := [];
  for memberName in AIdInfo.MemberNames do
  begin
    Result := Result + [
      AddAttribute(AType.CustomAttributes, 'Id',
        [Format('''%s''', [memberName]),
         generatorStr])
    ];
  end;
end;

destructor TSourceGenerator.Destroy;
begin
//  if FDestroyApp then
//    FApp.Free;
  FInheritanceParentMap.Free;
  FIsInheritanceBase.Free;
  FCodeUnits.Free;
  {$IFDEF USE_SCRIPTER}
  FScripter.Free;
  {$ENDIF}
  inherited;
end;

function TSourceGenerator.DynamicPropContainerName(
  ATable: TGDAOTable): string;
var
  mapping: TTableMapping;
begin
  if FOptions.Tables.TryGetValue(ATable.TID, mapping) and mapping.CustomContainer then
    Exit(mapping.DynPropContainer);
  Result := FOptions.DefaultDynPropContainer;
end;

function TSourceGenerator.GetModelNames(ATable: TGDAOTable): TArray<string>;
var
  mapping: TTableMapping;
  List: TStringList;
  I: Integer;
begin
  List := TStringList.Create;
  try
    if FOptions.Tables.TryGetValue(ATable.TID, mapping) then
      List.CommaText := mapping.ModelNames;

    SetLength(Result, List.Count);
    for I := 0 to List.Count - 1 do
      Result[I] := List[I];
  finally
    List.Free;
  end;
end;

procedure TSourceGenerator.ErrorFmt(Msg: string; const Args: array of const);
begin
  raise EGenInternalError.CreateFmt(Msg, Args);
end;

function TSourceGenerator.FieldMapping(AField: TGDAOField): TFieldMapping;
var
  mapping: TTableMapping;
begin
  if AField = nil then
    Exit(nil);
  mapping := TableMapping(AField.OwnerTable);

  if not mapping.Fields.ContainsKey(AField.FID) then
    mapping.Fields.Add(AField.FID, TFieldMapping.Create);
  Result := mapping.Fields[AField.FID];
end;

function TSourceGenerator.FindCodeUnit(AUnitName: string; ACreateIfNotFound: Boolean = True): TCodeUnit;
var
  I: Integer;
begin
  if AUnitName = '' then
    AUnitName := FOptions.MainUnitName;
    
  for I := 0 to FCodeUnits.Count - 1 do
    if SameText(AUnitName, FCodeUnits[I].Name) then
      Exit(FCodeUnits[I]);

  if ACreateIfNotFound then
  begin
    Result := TCodeUnit.Create;
    FCodeUnits.Add(Result);
    Result.Name := AUnitName;
    AddUsedUnit(Result, 'SysUtils');
    AddUsedUnit(Result, 'Generics.Collections');
    AddUsedUnit(Result, 'Aurelius.Mapping.Attributes');
    AddUsedUnit(Result, 'Aurelius.Types.Blob');
    AddUsedUnit(Result, 'Aurelius.Types.DynamicProperties');
    AddUsedUnit(Result, 'Aurelius.Types.Nullable');
    AddUsedUnit(Result, 'Aurelius.Types.Proxy');
  end
  else
    Result := nil;
end;

procedure TSourceGenerator.FireEvent(const Name: string; Args: TObject);
begin
  try
    {$IFDEF USE_SCRIPTER}
    if FScript.ScriptInfo.RoutineByName(Name) <> nil then
      FScript.VirtualMachine.ExecuteSubRoutine(Name, [Args]);
    {$ENDIF}
  finally
    Args.Free;
  end;
end;

function TSourceGenerator.RetrieveIdInfo(ATable: TGDAOTable): TEntityIdInfo;

  function FindBestRelationship(Rels: TRelationshipList): TGDAORelationship;
  var
    Rel: TGDAORelationship;
    RelOk: Boolean;
    RelIndex: Integer;
    I: Integer;
  begin
    if Rels.Count = 0 then Exit(nil);
    if Rels.Count = 1 then Exit(Rels[0]);

    Result := nil;
    // iterate through list to find best relationship
    for RelIndex := 0 to Rels.Count - 1 do
    begin
      Rel := Rels[RelIndex];
      RelOk := True;
      // Check if all detail fields or relationship belongs to id
      for I := 0 to Rel.FieldLinks.Count - 1 do
        if ATable.PrimaryKeyIndex.IFields.FindByField(Rel.FieldLinks[I].ChildField) = nil then
        begin
          RelOk := False;
          break;
        end;

      // if all fields of relationship are present in the id of the table, then it's a candidate
      // in this case we will get the relationship with higher number of fields
      if RelOk then
        if (Result = nil) or (Rel.FieldLinks.Count > Result.FieldLinks.Count) then
          Result := Rel;
    end;
  end;

var
  field: TGDAOField;
  c: Integer;
  fieldCount: integer;
  realCount: integer;
  Rels: TRelationshipList;
  UsedRels: TList<TGDAORelationship>;
  BestRel: TGDAORelationship;
begin
  Result.SequenceName := '';
  Rels := TRelationshipList.Create;
  UsedRels := TList<TGDAORelationship>.Create;
  try
    if ATable.HasPrimaryKey then
    begin
      fieldCount := ATable.PrimaryKeyIndex.IFields.Count;

      SetLength(Result.MemberNames, fieldCount);
      realCount := 0;
      for c := 0 to fieldCount - 1 do
      begin
        field := ATable.PrimaryKeyIndex.IFields[c].Field;

        if field.IsForeignKey(Rels) then
        begin
          BestRel := FindBestRelationship(Rels);
          Assert(BestRel <> nil, Format('Cannot create id for field %s.%s - ambiguous parent relationship',
            [ATable.TableName, field.FieldName]));
          if UsedRels.IndexOf(BestRel) = -1 then
          begin
            UsedRels.Add(BestRel);
            Result.MemberNames[realCount] := 'F' + AssociationPropertyName(BestRel);
            inc(realCount);
          end;
        end else
        begin
          Result.MemberNames[realCount] := 'F' + PropertyName(field);
          inc(realCount);
        end;
      end;
      setLength(Result.MemberNames, realCount);

      if fieldCount = 1 then
      begin
        // Single id, check if we shuold use identity or sequence
        field := ATable.PrimaryKeyIndex.IFields[0].Field;
        if field.DataType.Counter then
          Result.Generator := TIdGenerator.IdentityOrSequence
        else
        begin
          case field.DataType.NativeDataType of
            naInteger, naFloat:
              begin
                Result.SequenceName := GetSequenceName(ATable);
                if Result.SequenceName <> '' then
                  Result.Generator := TIdGenerator.IdentityOrSequence
                else
                  Result.Generator := TIdGenerator.None;
              end;
            naString, naBoolean, naDateTime:
              Result.Generator := TIdGenerator.None;

      //      naUnknown:
      //      naMemo: ;
            naBlob:
              if field.DataType.NativeSubType = stGuid then
                Result.Generator := TIdGenerator.Guid
              else
                ErrorFmt('Cannot retrieve Id for table "%s". Unsupported data type for Id field "%s"',
                  [ATable.TableName, field.FieldName]);
      //      naComputed: ;
          else
            ErrorFmt('Cannot retrieve Id for table "%s". Unsupported data type for Id field "%s"',
              [ATable.TableName, field.FieldName]);
          end;
        end;
      end else
      begin
        // Composite id
        Result.Generator := TIdGenerator.None;
      end;
      Exit(Result);
    end else
    begin
      // Check if there is an identity/counter field and define it as the Id
      for c := 0 to ATable.Fields.Count - 1 do
      begin
        field := ATable.Fields[c];
        if field.DataType.Counter then
        begin
          SetLength(Result.MemberNames, 1);
          Result.MemberNames[0] := 'F' + PropertyName(field);
          Result.Generator := TIdGenerator.IdentityOrSequence;
          Exit(Result);
        end;
      end;

      // Check if there is a guid field and define it as the Id
      for c := 0 to ATable.Fields.Count - 1 do
      begin
        field := ATable.Fields[c];
        if field.DataType.NativeSubType = stGuid then
        begin
          SetLength(Result.MemberNames, 1);
          Result.MemberNames[0] := 'F' + PropertyName(field);
          Result.Generator := TIdGenerator.Guid;
          Exit(Result);
        end;
      end;
    end;
    if not ATable.IsView then
      ErrorFmt('Table "%s" has no primary key. Cannot retrieve Id', [ATable.TableName]);
  finally
    Rels.Free;
    UsedRels.Free;
  end;
end;

{$IFDEF USE_SCRIPTER}
procedure TSourceGenerator.ScriptError(Sender: TObject; var msg: string; row,
  col: integer; var ShowException: boolean);
begin
  msg := 'Error when compiling/executing the customization Script: '#13#10 + msg;
end;
{$ENDIF}

function TSourceGenerator.GetSequenceName(ATable: TGDAOTable): string;
var
  mapping: TTableMapping;
  sequence: TGDAOObject;
begin
  mapping := TableMapping(ATable);
  if (mapping = nil) or mapping.IgnoreSequence then
    Exit('');

  if FDictionary.Categories.FindByType(ctSequence) <> nil then
  begin
    // Database support sequences
    // Check if sequence exists
    sequence := FDictionary.Categories.FindByType(ctSequence).Objects.FindByName(mapping.SequenceName);

    if sequence <> nil then
      Result := mapping.SequenceName
    else
      case FOptions.CheckSequencesMode of
        csAuto, csAlways:
          raise EMissingSequenceError.Create(ATable, mapping.SequenceName);
      else
        //csNever
        Result := '';
      end;
  end
  else
  begin
    if mapping.SequenceName <> '' then
      Result := mapping.SequenceName
    else
      case FOptions.CheckSequencesMode of
        csAlways:
          raise EMissingSequenceError.Create(ATable, mapping.SequenceName);
      else
        //csNever, csAuto
        Result := '';
      end;
  end;
end;

procedure TSourceGenerator.GenerateAssociation(ARelationship: TGDAORelationship;
  AType: TCodeTypeDeclaration; ACodeUnit: TCodeUnit);

  function HasRequiredChildFields(ARelationship: TGDAORelationship): boolean;
  var
    c: Integer;
  begin
    result := false;
    for c := 0 to ARelationship.FieldLinks.Count - 1 do
      if (ARelationship.FieldLinks[c].ChildField <> nil) and ARelationship.FieldLinks[c].ChildField.Required then
        Exit(true);
  end;

var
  prop: TCodeMemberProperty;
  field: TCodeMemberField;
  getter: TCodeMemberMethod;
  setter: TCodeMemberMethod;
  propName: string;
  propType: string;
  fieldType: string;
  associationAttr: TCodeAttributeDeclaration;
  joinAttr: TCodeAttributeDeclaration;
  c: Integer;
  columnProps: string;
  assocProps: string;
  readOnly: boolean;
  childField: TGDAOField;
  isLazy: boolean;
  mapping: TAssociationMapping;
  cascadeDefinition: TCascadeDefinition;
  cascadeString: string;
begin
  propName := AssociationPropertyName(ARelationship);
  if ARelationship.ParentTable = nil then
    raise EGUIException.CreateFmt('Relationship %s has no parent table', [ARelationship.RelationshipName]);
  propType := ClassName(ARelationship.ParentTable);
  AddUsedUnit(ACodeUnit, ARelationship.ParentTable);

  mapping := AssociationMapping(ARelationship);
  isLazy := (mapping.FetchMode = fmLazy) or ((mapping.FetchMode = fmDefault) and (FOptions.DefaultAssociationFetchMode = fmLazy));

  if isLazy then
    fieldType := Format('Proxy<%s>', [propType])
  else
    fieldType := Format('%s', [propType]);

  // Create private Field
  field := TCodeMemberField.Create;
  AType.Members.Add(field);
  field.Name := 'F' + propName;
  field.FieldType.BaseType := fieldType;
  field.Visibility := mvPrivate;

  prop := TCodeMemberProperty.Create;
  AType.Members.Add(prop);
  prop.Name := propName;
  prop.PropertyType.BaseType := propType;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.HasSetter := true;

  // Create the getter
  if IsLazy then
  begin
    getter := TCodeMemberMethod.Create;
    AType.Members.Add(getter);
    getter.Name := 'Get' + propName;
    getter.ReturnType.BaseType := propType;
    getter.Statements.Add(TCodeSnippetStatement.Create(
      Format('result := %s.Value;', [field.Name])));
    prop.ReadMember := getter.Name;
  end
  else
  begin
    getter := nil;
    prop.ReadMember := field.Name;
  end;

  // Create the setter
  if IsLazy then
  begin
    setter := TCodeMemberMethod.Create;
    AType.Members.Add(setter);
    setter.Name := 'Set' + propName;
    setter.Parameters.Add(TCodeParameterDeclaration.Create(
      'Value', propType, pmConst));
    setter.Statements.Add(TCodeSnippetStatement.Create(
      Format('%s.Value := Value;', [field.Name])));
    prop.WriteMember := setter.Name;
  end else
  begin
    setter := nil;
    prop.WriteMember := field.Name;
  end;


  // Create attribute
  associationAttr := TCodeAttributeDeclaration.Create;
  field.CustomAttributes.Insert(0, associationAttr);
  associationAttr.Name := 'Association';

  assocProps := '';
  if isLazy then
    assocProps := AppendWithComma(assocProps, 'TAssociationProp.Lazy');
  if HasRequiredChildFields(ARelationship) then
    assocProps := AppendWithComma(assocProps, 'TAssociationProp.Required');
  associationAttr.Arguments.Add(TCodeAttributeArgument.Create(
    Format('[%s]', [assocProps])));

  if mapping.CascadeDefinition = cdDefault then
    cascadeDefinition := FOptions.DefaultAssociationCascadeDefinition
  else
    cascadeDefinition := mapping.CascadeDefinition;
  case cascadeDefinition of
    cdAllButRemove: cascadeString := 'CascadeTypeAll - [TCascadeType.Remove]';
    cdAll: cascadeString := 'CascadeTypeAll';
  else
    // default, cdNode:
    cascadeString := '[]';
  end;
  associationAttr.Arguments.Add(TCodeAttributeArgument.Create(cascadeString));

  for c := 0 to ARelationship.FieldLinks.Count - 1 do
  begin
    childField := ARelationship.FieldLinks[c].ChildField;
    if childField = nil then Continue;
    if ARelationship.FieldLinks[c].ParentField = nil then Continue;

    joinAttr := TCodeAttributeDeclaration.Create;
    field.CustomAttributes.Add(joinAttr);
    joinAttr.Name := 'JoinColumn';
    columnProps := '';
    readOnly := childField.DataType.Counter or childField.DataType.Computed;
    if childField.Required then
      columnProps := AppendWithComma(columnProps, 'TColumnProp.Required');
    if readOnly then
      columnProps := AppendWithComma(columnProps, 'TColumnProp.NoInsert');
    if readOnly then
      columnProps := AppendWithComma(columnProps, 'TColumnProp.NoUpdate');

    joinAttr.Arguments.Add(TCodeAttributeArgument.Create(
      Format('''%s''', [childField.FieldName])));
    joinAttr.Arguments.Add(TCodeAttributeArgument.Create(
      Format('[%s]', [columnProps])));
    joinAttr.Arguments.Add(TCodeAttributeArgument.Create(
      '''' + ARelationship.FieldLinks[c].ParentField.FieldName + ''''));
  end;

  // Create description
  AddDescription(field.CustomAttributes, ARelationship.Description);

  FireEvent(
    AssociationGeneratedEventName,
    TAssociationGeneratedArgs.Create(
      ACodeUnit, AType, prop, field, getter, setter,
      associationAttr, ARelationship
    )
  );
end;

{$IFDEF USE_SCRIPTER}
procedure TSourceGenerator.GenerateCodeUnits(AScript: TatScript);
{$ELSE}
procedure TSourceGenerator.GenerateCodeUnits;
{$ENDIF}
var
  c: integer;
  processedTables: TStringList;
  codeUnit: TCodeUnit;
  dicUnit: TCodeUnit;
  mapping: TTableMapping;
begin
  {$IFDEF USE_SCRIPTER}
  FScript := AScript;
  if not FScript.Compiled then
    FScript.Compile;
  {$ENDIF}
  try
    BuildInheritanceMap;
    FCodeUnits.Clear;
    processedTables := TStringList.Create;
    try
      // Create main unit just to make it first in the list. This call is not necessary unless for ordering
      FindCodeUnit(FOptions.MainUnitName);

      // Generate table in their units
      for c := 0 to FDictionary.Tables.Count - 1 do
      begin
        mapping := TableMapping(FDictionary.Tables[c]);
        if not mapping.Excluded then
          GenerateTable(FDictionary.Tables[c], processedTables, FindCodeUnit(mapping.ClassUnitName));
      end;

      for codeUnit in FCodeUnits do
      begin
        // sort types by type inheritance order
        codeUnit._Types.Sort(TComparer<TCodeTypeDeclaration>.Construct(
          function(const Left, Right: TCodeTypeDeclaration): Integer
          var
            Lev1, Lev2: integer;
          begin
            Lev1 := CodeTypeInheritanceLevel(codeUnit, Left);
            Lev2 := CodeTypeInheritanceLevel(codeUnit, Right);
            if Lev1 = Lev2 then
              Result := CompareText(Left.Name, Right.Name)
            else
              Result := Lev1 - Lev2;
          end
        ));

        // Fire event for generated code unit
        FireEvent(
          UnitGeneratedEventName,
          TUnitGeneratedArgs.Create(codeUnit)
        );
      end;

      // dictionary
      if not FOptions.OmitDictionary then
      begin
        if (FOptions.DictionaryUnitName <> '') and not SameText(FOptions.DictionaryUnitName, FOptions.MainUnitName) then
        begin
          // Use a different unit for dictionary
          dicUnit := TCodeUnit.Create;
          FCodeUnits.Add(dicUnit);
          dicUnit.Name := FOptions.DictionaryUnitName;
        end else
          // Same unit as main unit
          dicUnit := FindCodeUnit('');

        if FOptions.NewDictionary then
          GenerateDictionaryV2(dicUnit)
        else
          GenerateDictionary(dicUnit);
      end;
    finally
      processedTables.Free;
    end;
  finally
    {$IFDEF USE_SCRIPTER}
    FScript := nil;
    {$ENDIF}
  end;
end;

procedure TSourceGenerator.GenerateDictionary(ACodeUnit: TCodeUnit);
var
  c: Integer;
  schemaType: TCodeTypeDeclaration;
  dicFunction: TCodeMemberMethod;
  dicVar: TCodeMemberField;
begin
  AddUsedUnit(ACodeUnit, 'Aurelius.Criteria.Dictionary');
  schemaType := TCodeTypeDeclaration.Create;
  ACodeUnit._Types.Add(schemaType);
  schemaType.Name := Format('T%sDictionary', [FOptions.DictionaryName]);

  for c := 0 to FDictionary.Tables.Count - 1 do
    if not TableMapping(FDictionary.Tables[c]).Excluded then
      GenerateDictionaryTable(FDictionary.Tables[c], ACodeUnit, schemaType);

  // Create the global function and var that will retrieve the dictionary instance
  dicFunction := TCodeMemberMethod.Create;
  dicVar := TCodeMemberField.Create;
  ACodeUnit.Functions.Add(dicFunction);
  ACodeUnit.Variables.Add(dicVar);

  dicVar.Name := Format('__%s', [FOptions.DictionaryName]);
  dicVar.FieldType.BaseType := schemaType.Name;
  dicVar.Visibility := mvPrivate;

  dicFunction.Name := FOptions.DictionaryName;
  dicFunction.Visibility := mvPublic;
  dicFunction.ReturnType.BaseType := schemaType.Name;
  dicFunction.Statements.Add(TCodeSnippetStatement.Create(
    Format('if %s = nil then %s := %s.Create;',
      [dicVar.Name, dicVar.Name, schemaType.Name]
      )));
  dicFunction.Statements.Add(TCodeSnippetStatement.Create(
    Format('result := %s', [dicVar.Name]
      )));

  ACodeUnit.FinalizationStatements.Add(TCodeSnippetStatement.Create(
    Format('if %s <> nil then %s.Free', [dicVar.Name, dicVar.Name]
      )));
end;

procedure TSourceGenerator.GenerateDictionaryAssociation(
  ARelationship: TGDAORelationship; AType: TCodeTypeDeclaration);
const
  DictionaryAssociationTypeName = 'TDictionaryAssociation';
var
  propName: string;
  constructorMethod: TCodeMemberConstructor;
  prop: TCodeMemberProperty;
  field: TCodeMemberField;
begin
  propName := AssociationPropertyName(ARelationship);
  constructorMethod := GetConstructor(AType);

  // Create private Field
  field := TCodeMemberField.Create;
  AType.Members.Add(field);
  field.Name := 'F' + propName;
  field.FieldType.BaseType := DictionaryAssociationTypeName;
  field.Visibility := mvPrivate;

  // Create public Property
  prop := TCodeMemberProperty.Create;
  AType.Members.Add(prop);
  prop.Name := propName;
  prop.PropertyType.BaseType := DictionaryAssociationTypeName;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.ReadMember := field.Name;

  // Create the record in class constructor
  constructorMethod.Statements.Add(TCodeSnippetStatement.Create(
    Format('%s := %s.Create(''%s'');', [field.Name, DictionaryAssociationTypeName, propName])));

end;

procedure TSourceGenerator.GenerateDictionaryField(AField: TGDAOField; AType: TCodeTypeDeclaration);
const
  DictionaryAttributeTypeName = 'TDictionaryAttribute';
var
  propName: string;
  constructorMethod: TCodeMemberConstructor;
  prop: TCodeMemberProperty;
  field: TCodeMemberField;
begin
  propName := PropertyName(AField);
  constructorMethod := GetConstructor(AType);

  // Create private Field
  field := TCodeMemberField.Create;
  AType.Members.Add(field);
  field.Name := 'F' + propName;
  field.FieldType.BaseType := DictionaryAttributeTypeName;
  field.Visibility := mvPrivate;

  // Create public Property
  prop := TCodeMemberProperty.Create;
  AType.Members.Add(prop);
  prop.Name := propName;
  prop.PropertyType.BaseType := DictionaryAttributeTypeName;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.ReadMember := field.Name;

  // Create the record in class constructor
  constructorMethod.Statements.Add(TCodeSnippetStatement.Create(
    Format('%s := %s.Create(''%s'');', [field.Name, DictionaryAttributeTypeName, propName])));
end;

procedure TSourceGenerator.GenerateDictionaryTable(ATable: TGDAOTable;
  ACodeUnit: TCodeUnit; ASchemaType: TCodeTypeDeclaration);
var
  d: Integer;
  codeType: TCodeTypeDeclaration;
  foreignRelationships: TList<TGDAORelationship>;
  inheritanceRel: TGDAORelationship;
  delphiType: string;
  propFields: TList<TGDAOField>;
  propName: string;
  destructorMethod: TCodeMemberDestructor;
  field: TCodeMemberField;
  prop: TCodeMemberProperty;
  getter: TCodeMemberMethod;
begin
  // Create a class related to the dictionary table
  delphiType := Format('%sTableDictionary', [ClassName(ATable)]);

  codeType := TCodeTypeDeclaration.Create;
  ACodeUnit._Types.Add(codeType);
  codeType.Name := delphiType;
  codeType.BaseType.BaseType := '';
  codeType.IsClass := true;
  codeType.Visibility := mvPublic;

  // Get the list of fields that are not part of associations
  propFields := GetPropertyFields(ATable);
  try
    for d := 0 to propFields.Count - 1 do
      if not FieldMapping(propFields[d]).Excluded then
        GenerateDictionaryField(propFields[d], codeType);
  finally
    propFields.Free;
  end;

  FInheritanceParentMap.TryGetValue(ATable, inheritanceRel);
  foreignRelationships := GetForeignRelationships(ATable);
  try
    // Create an association for each foreign relationship
    // Do not include association if it's the inheritance association
    for d := 0 to foreignRelationships.Count - 1 do
      if (not AssociationMapping(foreignRelationships[d]).Excluded)
        and (foreignRelationships[d] <> inheritanceRel) then
          GenerateDictionaryAssociation(foreignRelationships[d], codeType);
  finally
    foreignRelationships.Free;
  end;

  // Create a property in the schema type with same name as table
  propName := TableDictionaryName(ATable);
  destructorMethod := GetDestructor(ASchemaType);

  // Create private Field
  field := TCodeMemberField.Create;
  ASchemaType.Members.Add(field);
  field.Name := 'F' + propName;
  field.FieldType.BaseType := delphiType;
  field.Visibility := mvPrivate;

  // Create the getter
  getter := TCodeMemberMethod.Create;
  ASchemaType.Members.Add(getter);
  getter.Name := 'Get' + propName;
  getter.ReturnType.BaseType := delphiType;
  getter.Statements.Add(TCodeSnippetStatement.Create(
    Format('if %s = nil then %s := %s.Create;',
      [field.Name, field.Name, delphiType])));
  getter.Statements.Add(TCodeSnippetStatement.Create(
    Format('result := %s;', [field.Name])));

  // Create public Property
  prop := TCodeMemberProperty.Create;
  ASchemaType.Members.Add(prop);
  prop.Name := propName;
  prop.PropertyType.BaseType := delphiType;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.ReadMember := getter.Name;

  // Create the record in class destructor
  destructorMethod.Statements.Insert(0, TCodeSnippetStatement.Create(
    Format('if %s <> nil then %s.Free;', [field.Name, field.Name])));
end;

procedure TSourceGenerator.GenerateDictionaryV2(ACodeUnit: TCodeUnit);
var
  c: Integer;
  Generator: TCustomDictionaryGenerator;
  entity: TDictionaryMetaEntity;
begin
  Generator := TCustomDictionaryGenerator.Create;
  try
    Generator.GlobalVarName := FOptions.DictionaryName;
    for c := 0 to FDictionary.Tables.Count - 1 do
      if not TableMapping(FDictionary.Tables[c]).Excluded then
      begin
        entity := TDictionaryMetaEntity.Create;
        Generator.Entities.Add(entity);
        entity.EntityClassName := ClassName(FDictionary.Tables[c]);

        // Add properties
        AddDictionaryTableProperties(entity, FDictionary.Tables[c]);

        // Add associations
        AddDictionaryTableAssociations(entity, FDictionary.Tables[c]);
      end;

    Generator.Generate(ACodeUnit);
  finally
    Generator.Free;
  end;

end;

procedure TSourceGenerator.GenerateDynamicPropContainer(
  AType: TCodeTypeDeclaration; AContainerName: string);
var
  prop: TCodeMemberProperty;
  field: TCodeMemberField;
  propName: string;
  propType: string;
  fieldType: string;
  constructorMethod: TCodeMemberConstructor;
  destructorMethod: TCodeMemberDestructor;
begin
  propName := AContainerName;
  propType := 'TDynamicProperties';
  fieldType := propType;

  constructorMethod := GetConstructor(AType);
  destructorMethod := GetDestructor(AType);

  // Create private Field
  field := TCodeMemberField.Create;
  AType.Members.Add(field);
  field.Name := 'F' + propName;
  field.FieldType.BaseType := fieldType;
  field.Visibility := mvPrivate;

  // Create public Property
  prop := TCodeMemberProperty.Create;
  AType.Members.Add(prop);
  prop.Name := propName;
  prop.PropertyType.BaseType := propType;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.ReadMember := field.Name;
  prop.HasSetter := false;
  prop.WriteMember := '';

  // Add statements to constructor and destructor
  constructorMethod.Statements.Add(TCodeSnippetStatement.Create(
    Format('%s := %s.Create;', [field.Name, propType])));
  destructorMethod.Statements.Insert(0, TCodeSnippetStatement.Create(
    Format('%s.Free;', [field.Name])));
end;

procedure TSourceGenerator.GenerateField(AField: TGDAOField;
  AType: TCodeTypeDeclaration; AProcessedTables: TStrings; ACodeUnit: TCodeUnit);
var
  prop: TCodeMemberProperty;
  propName: string;
  field: TCodeMemberField;
  delphiType: string;
  attr: TCodeAttributeDeclaration;
begin
  propName := PropertyName(AField);

  field := TCodeMemberField.Create;
  AType.Members.Add(field);
  prop := TCodeMemberProperty.Create;
  AType.Members.Add(prop);
  attr := TCodeAttributeDeclaration.Create;
  // Add the attribute to field
  field.CustomAttributes.Add(attr);

  delphiType := PropertyType(AField);

  // Create private Field
  field.Name := 'F' + propName;
  field.FieldType.BaseType := delphiType;
  field.Visibility := mvPrivate;

  // Create public Property
  prop.Name := propName;
  prop.PropertyType.BaseType := delphiType;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.ReadMember := field.Name;

  // Careful when changing the code below. There are other parts of code that use the same logic. Search for it!
  prop.HasSetter := not AField.DataType.Computed;
  if prop.HasSetter then
    prop.WriteMember := field.Name;

  // Create attribute
  attr.Name := 'Column';
  CreateColumnAttributeArguments(attr, AField);

  // Create description
  AddDescription(field.CustomAttributes, AField.Description);

  // Add DBTypeMemo
  if AField.DataType.NativeDataType = naMemo then
  begin
    if AField.DataType.NativeSubType = stNText then
      AddAttribute(field.CustomAttributes, 'DBTypeWideMemo')
    else
      AddAttribute(field.CustomAttributes, 'DBTypeMemo');
  end;


  // Add type members
  field.UserData := AField;
  prop.UserData := AField;

  FireEvent(
    ColumnGeneratedEventName,
    TColumnGeneratedArgs.Create(
      ACodeUnit, AType, prop, field, attr, AField)
  );
end;

procedure TSourceGenerator.GenerateManyValuedAssociation(
  ARelationship: TGDAORelationship; AType: TCodeTypeDeclaration; ACodeUnit: TCodeUnit);

  function HasRequiredChildFields(ARelationship: TGDAORelationship): boolean;
  var
    c: Integer;
  begin
    result := false;
    for c := 0 to ARelationship.FieldLinks.Count - 1 do
      if (ARelationship.FieldLinks[c].ChildField <> nil) and ARelationship.FieldLinks[c].ChildField.Required then
        Exit(true);
  end;

var
  prop: TCodeMemberProperty;
  field: TCodeMemberField;
  propName: string;
  propType: string;
  fieldType: string;
  associationAttr: TCodeAttributeDeclaration;
  cascadeOptions: string;
  constructorMethod: TCodeMemberConstructor;
  destructorMethod: TCodeMemberDestructor;
  isLazy: boolean;
  mapping: TAssociationMapping;
  getter: TCodeMemberMethod;
  assocProps: string;
begin
  mapping := AssociationMapping(ARelationship);
  isLazy := (mapping.ManyValuedFetchMode = fmLazy) or
    ((mapping.ManyValuedFetchMode = fmDefault) and (FOptions.DefaultManyValuedFetchMode = fmLazy));

  propName := ManyValuedAssociationPropertyName(ARelationship);
  if ARelationship.ChildTable = nil then
    raise EGUIException.CreateFmt('Relationship %s has no parent table', [ARelationship.RelationshipName]);
  propType := ClassName(ARelationship.ChildTable);
  propType := Format('TList<%s>', [propType]);
  AddUsedUnit(ACodeUnit, ARelationship.ChildTable);

  if isLazy then
    fieldType := Format('Proxy<%s>', [propType])
  else
    fieldType := Format('%s', [propType]);

  constructorMethod := GetConstructor(AType);
  destructorMethod := GetDestructor(AType);

  // Create private Field
  field := TCodeMemberField.Create;
  AType.Members.Add(field);
  field.Name := 'F' + propName;
  field.FieldType.BaseType := fieldType;
  field.Visibility := mvPrivate;

  // Create public Property
  prop := TCodeMemberProperty.Create;
  AType.Members.Add(prop);
  prop.Name := propName;
  prop.PropertyType.BaseType := propType;
  prop.Visibility := mvPublic;
  prop.HasGetter := true;
  prop.HasSetter := false;
  prop.WriteMember := '';

  // Create the getter
  if IsLazy then
  begin
    getter := TCodeMemberMethod.Create;
    AType.Members.Add(getter);
    getter.Name := 'Get' + propName;
    getter.ReturnType.BaseType := propType;
    getter.Statements.Add(TCodeSnippetStatement.Create(
      Format('result := %s.Value;', [field.Name])));
    prop.ReadMember := getter.Name
  end
  else
  begin
    prop.ReadMember := field.Name;
    getter := nil;
  end;

  // Add statements to constructor and destructor
  if isLazy then
  begin
    constructorMethod.Statements.Add(TCodeSnippetStatement.Create(
      Format('%s.SetInitialValue(%s.Create);', [field.Name, propType])));
    destructorMethod.Statements.Insert(0, TCodeSnippetStatement.Create(
      Format('%s.DestroyValue;', [field.Name])));
  end else
  begin
    constructorMethod.Statements.Add(TCodeSnippetStatement.Create(
      Format('%s := %s.Create;', [field.Name, propType])));
    destructorMethod.Statements.Insert(0, TCodeSnippetStatement.Create(
      Format('%s.Free;', [field.Name])));
  end;

  // Create attribute
  associationAttr := TCodeAttributeDeclaration.Create;
  field.CustomAttributes.Insert(0, associationAttr);
  associationAttr.Name := 'ManyValuedAssociation';

  assocProps := '';
  if isLazy then
    assocProps := AppendWithComma(assocProps, 'TAssociationProp.Lazy');
  if HasRequiredChildFields(ARelationship) then
    assocProps := AppendWithComma(assocProps, 'TAssociationProp.Required');
  associationAttr.Arguments.Add(TCodeAttributeArgument.Create(
    Format('[%s]', [assocProps])));


  cascadeOptions := 'TCascadeType.SaveUpdate, TCascadeType.Merge';
  if ARelationship.DeleteMethod = dmCascade then
    cascadeOptions := AppendWithComma(cascadeOptions, 'TCascadeType.Remove');
  associationAttr.Arguments.Add(TCodeAttributeArgument.Create(
    Format('[%s]', [cascadeOptions])));

  // MappedBy
  associationAttr.Arguments.Add(TCodeAttributeArgument.Create(
    '''' +
    'F' + AssociationPropertyName(ARelationship)
    + ''''
    ));

  FireEvent(
    ManyValuedAssociationGeneratedEventName,
    TManyValuedAssociationGeneratedArgs.Create(
      ACodeUnit, AType, prop, field, getter,
      associationAttr, constructorMethod, destructorMethod, ARelationship
    )
  );
end;

procedure TSourceGenerator.GenerateSourceFiles(AOutputDir: string);
var
  sourceUnit: TSourceUnit;
  sourceUnits: TArray<TSourceUnit>;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    try
      sourceUnits := GenerateSourceUnits;
      ForceDirectories(AOutputDir);
      for sourceUnit in sourceUnits do
      begin
        sl.Text := sourceUnit.Source;
        sl.SaveToFile(Format('%s\%s.pas',
          [ExcludeTrailingPathDelimiter(AOutputDir),
           sourceUnit.Name
          ]));
      end;
    except
      on E: Exception do
        raise EGUIException.Create('Error when creating Aurelius files.'#13#10 + E.Message);
    end;
  finally
    sl.Free;
  end;
end;

function TSourceGenerator.GenerateSourceUnits: TArray<TSourceUnit>;
var
  gen: TDelphiCodeGenerator;
  I: Integer;
begin
  {$IFDEF USE_SCRIPTER}
  FScript := FScripter.CurrentScript;
  FScript.SourceCode.Text := FOptions.Script;
  GenerateCodeUnits(FScript);
  {$ELSE}
  GenerateCodeUnits;
  {$ENDIF}

  gen := TDelphiCodeGenerator.Create;
  try
    try
      gen.LineBeforeComplexMembers := true;
      SetLength(Result, FCodeUnits.Count);
      for I := 0 to FCodeUnits.Count - 1 do
      begin
        Result[I].Name := FCodeUnits[I].Name;
        Result[I].Source := gen.GenerateCodeFromUnit(FCodeUnits[I]);
      end;
    except
      on E: Exception do
        raise EGUIException.Create('Error when creating Aurelius files.'#13#10 + E.Message);
    end;
  finally
    gen.Free;
  end;
end;

procedure TSourceGenerator.GenerateTable(ATable: TGDAOTable;
  AProcessedTables: TStrings; ACodeUnit: TCodeUnit);
var
  codeType: TCodeTypeDeclaration;
  c: Integer;
  foreignRelationships: TList<TGDAORelationship>;
  propFields: TList<TGDAOField>;
  primaryRelationships: TList<TGDAORelationship>;
  uniqueFields: string;
  entityId: TEntityIdInfo;
  d: Integer;
  inheritanceRel: TGDAORelationship;
  I: Integer;
  modelName: string;
  tableAttr: TCodeAttributeDeclaration;
  idAttrs: TArray<TCodeAttributeDeclaration>;
  sequenceAttr: TCodeAttributeDeclaration;
begin
  if AProcessedTables.IndexOf(ATable.TableName) >= 0 then
    Exit;
  AProcessedTables.Add(ATable.TableName);

  // Create a class related to the table
  codeType := TCodeTypeDeclaration.Create;
  ACodeUnit._Types.Add(codeType);

  codeType.Name := ClassName(ATable);
  sequenceAttr := nil;
  idAttrs := [];

  FInheritanceParentMap.TryGetValue(ATable, inheritanceRel);
  // Check if this table/class inherits from another class
  if inheritanceRel <> nil then
  begin
    codeType.BaseType.BaseType := ClassName(inheritanceRel.ParentTable);
    AddUsedUnit(ACodeUnit, inheritanceRel.ParentTable);
  end
  else
    codeType.BaseType.BaseType := FOptions.DefaultAncestorClass;

  codeType.IsClass := true;
  codeType.Visibility := mvPublic;

  // Create basic attributes
  AddAttribute(codeType.CustomAttributes, 'Entity');
  tableAttr := AddAttribute(codeType.CustomAttributes, 'Table', [Format('''%s''', [ATable.TableName])]);

  // Add model attributes
  for modelName in GetModelNames(ATable) do
    AddAttribute(codeType.CustomAttributes, 'Model', [Format('''%s''', [modelName])]);

  // Create description
  AddDescription(codeType.CustomAttributes, ATable.Description);

  // Check if this table/class is the base class for a class hierarchy (has inheritance)
  if FIsInheritanceBase.ContainsKey(ATable) then
    AddAttribute(codeType.CustomAttributes, 'Inheritance', ['TInheritanceStrategy.JoinedTables']);

  // Create UniqueKey attributes for each unique key in the table
  for c := 0 to ATable.Indexes.Count - 1 do
    if (ATable.Indexes[c].IndexType in [itUnique, itUniqueKey]) then
    begin
      uniqueFields := '';
      for d := 0 to ATable.Indexes[c].IFields.Count - 1 do
        uniqueFields := AppendWithComma(uniqueFields, ATable.Indexes[c].IFields[d].FieldName);
      AddAttribute(codeType.CustomAttributes, 'UniqueKey',
        ['''' + uniqueFields + '''']);
    end;

  // Get the list of fields that are not part of associations
  propFields := GetPropertyFields(ATable);
  try
    // Create properties and fields for each gdaofield that are not part of an association
    for c := 0 to propFields.Count - 1 do
      if not FieldMapping(propFields[c]).Excluded then
        GenerateField(propFields[c], codeType, AProcessedTables, ACodeUnit);
  finally
    propFields.Free;
  end;

  // Generate dynamic property container, if existing.
  if DynamicPropContainerName(ATable) <> '' then
    GenerateDynamicPropContainer(codeType, DynamicPropContainerName(ATable));

  // Get the list of foreign relationships (where this table is child)
  foreignRelationships := GetForeignRelationships(ATable);
  try
    // Create an association for each foreign relationship
    // Do not include association if it's the inheritance association
    for c := 0 to foreignRelationships.Count - 1 do
      if (not AssociationMapping(foreignRelationships[c]).Excluded)
        and (foreignRelationships[c] <> inheritanceRel) then
          GenerateAssociation(foreignRelationships[c], codeType, ACodeUnit);
  finally
    foreignRelationships.Free;
  end;

  // Get the list of primary relationships (where this table is parent)
  primaryRelationships := GetPrimaryRelationships(ATable);
  try
    // Create an association for each primary relationship
    for c := 0 to primaryRelationships.Count - 1 do
      if AssociationMapping(primaryRelationships[c]).ManyValuedIncluded then
        GenerateManyValuedAssociation(primaryRelationships[c], codeType, ACodeUnit);
//        // For now generate only delete cascade relationships
//        if primaryRelationships[c].DeleteMethod = dmCascade then
//          GenerateManyValuedAssociation(primaryRelationships[c], codeType);
  finally
    primaryRelationships.Free;
  end;

  // Define the entity/class identifier. First check if it's an inherited class or not
  if inheritanceRel <> nil then
  begin
//      if inheritanceRel.FieldLinks.Count <> 1 then
//        ErrorFmt('Could not create PrimaryJoin attribute for table "%s" using relationship "%s". Composite keys are not supported',
//          [ATable.TableName, inheritanceRel.RelationshipName]);
    for I := 0 to inheritanceRel.FieldLinks.Count - 1 do
      AddAttribute(codeType.CustomAttributes, 'PrimaryJoinColumn',
        [Format('''%s''', [inheritanceRel.FieldLinks[I].ChildFieldName])]);
  end
  else
  begin
    // If not inherited, then just define the Id for the table
    entityId := RetrieveIdInfo(ATable);

    // Indicates if it has a sequence associated with an autoincrement field
    if entityId.SequenceName <> '' then
      sequenceAttr := AddAttribute(codeType.CustomAttributes, 'Sequence',
        ['''' + entityId.SequenceName + '''']);

    idAttrs := DefineIdAttribute(codeType, entityId);
  end;

  // Register entity
  if FOptions.RegisterEntities then
    ACodeUnit.InitializationStatements.Add(TCodeSnippetStatement.Create(Format('RegisterEntity(%s);', [codeType.Name])));

  FireEvent(
    ClassGeneratedEventName,
    TClassGeneratedArgs.Create(ACodeUnit, codeType, ATable, tableAttr, idAttrs, sequenceAttr)
  );
end;

function TSourceGenerator.GetChildFieldList(
  ARelationships: TList<TGDAORelationship>): TList<TGDAOField>;
var
  relationship: TGDAORelationship;
  i: Integer;
begin
  result := TList<TGDAOField>.Create;
  try
    for relationship in ARelationships do
      for i := 0 to relationship.FieldLinks.Count - 1 do
        if result.IndexOf(relationship.FieldLinks[i].ChildField) = -1 then
          result.Add(relationship.FieldLinks[i].ChildField);
  except
    result.Free;
    raise;
  end;
end;

function TSourceGenerator.GetConstructor(
  AType: TCodeTypeDeclaration): TCodeMemberConstructor;
var
  member: TCodeTypeMember;
begin
  for member in AType.Members do
    if (member is TCodeMemberConstructor) and (SameText(member.Name, 'Create')) then
      Exit(TCodeMemberConstructor(member));

  result := TCodeMemberConstructor.Create;
  result.Name := 'Create';
  result.Visibility := mvPublic;
  AType.Members.Add(result);
  result.Statements.Add(TCodeSnippetStatement.Create('inherited;'));
end;

function TSourceGenerator.GetDestructor(
  AType: TCodeTypeDeclaration): TCodeMemberDestructor;
var
  member: TCodeTypeMember;
begin
  for member in AType.Members do
    if (member is TCodeMemberDestructor) and (SameText(member.Name, 'Destroy')) then
      Exit(TCodeMemberDestructor(member));

  result := TCodeMemberDestructor.Create;
  result.Name := 'Destroy';
  result.Visibility := mvPublic;
  result.Directives := [mdOverride];
  result.Statements.Add(TCodeSnippetStatement.Create('inherited;'));
  AType.Members.Add(result);
end;

function TSourceGenerator.GetForeignRelationships(ATable: TGDAOTable): TList<TGDAORelationship>;
var
  c: Integer;
begin
  result := TList<TGDAORelationship>.Create;
  try
    for c := 0 to FDictionary.Relationships.Count - 1 do
      if FDictionary.Relationships[c].ChildTable = ATable then
        result.Add(FDictionary.Relationships[c]);
  except
    result.Free;
    raise;
  end;
end;

function TSourceGenerator.GetPrimaryRelationships(
  ATable: TGDAOTable): TList<TGDAORelationship>;
var
  c: Integer;
begin
  result := TList<TGDAORelationship>.Create;
  try
    for c := 0 to FDictionary.Relationships.Count - 1 do
      if FDictionary.Relationships[c].ParentTable = ATable then
        result.Add(FDictionary.Relationships[c]);
  except
    result.Free;
    raise;
  end;
end;

function TSourceGenerator.GetPrimitiveDelphiType(AField: TGDAOField): string;
begin
  case AField.DataType.NativeDataType of
    naInteger:
      case AField.DataType.NativeSubType of
        stLongInt, stLongCounter:
          result := 'Int64';
      else
        result := 'Integer';
      end;
    naFloat:
      result := 'Double';
    naString:
      result := 'string';
    naBoolean:
      result := 'Boolean';
    naDateTime:
      result := 'TDateTime';
    naMemo:
      result := 'TBlob';
    naBlob:
      begin
        if AField.DataType.NativeSubType = stGUID then
          result := 'TGuid'
        else
          result := 'TBlob';
      end;
    naComputed:
      result := 'Variant';
  else
    //naUnknown: ;
    ErrorFmt('Delphi type not defined for database native type %s',
      [IntToStr(Ord(AField.DataType.NativeDataType))]);
  end;
end;

function TSourceGenerator.GetPropertyFields(
  ATable: TGDAOTable): TList<TGDAOField>;
var
  foreignFields: TList<TGDAOField>;
  c: Integer;
  foreignRelationships: TList<TGDAORelationship>;
begin
  Result := TList<TGDAOField>.Create;
  foreignRelationships := GetForeignRelationships(ATable);
  foreignFields := GetChildFieldList(foreignRelationships);
  try
    // Create properties and fields for each gdaofield that are not part of an association
    for c := 0 to ATable.Fields.Count - 1 do
      if foreignFields.IndexOf(ATable.Fields[c]) = -1 then
        Result.Add(ATable.Fields[c]);
  finally
    foreignRelationships.Free;
    foreignFields.Free;
  end;
end;

function TSourceGenerator.IdentName(AName: string): string;

  function Alpha(C: Char): Boolean; inline;
  begin
    Result := C.IsLetter or (C = '_');
  end;

  function AlphaNumeric(C: Char): Boolean; inline;
  begin
    Result := C.IsLetterOrDigit or (C = '_');
  end;

var
  src: integer;
  dst: integer;
  Len: integer;
begin
  src := 1;
  dst := 1;
  Len := Length(AName);
  SetLength(result, Len + 1);
  if (Len > 0) and not Alpha(AName[1]) then
  begin
    result[dst] := '_';
    inc(dst);
  end;

  while src <= Len do
  begin
    if AlphaNumeric(AName[src]) then
    begin
      result[dst] := AName[src];
      inc(dst);
    end;
    inc(src);
  end;
  SetLength(result, dst - 1);
  Assert(IsValidIdent(result), result);
end;

function TSourceGenerator.InterfaceName(ATable: TGDAOTable): string;
begin
  Result := ClassName(ATable);
  if (Length(Result) > 0) and (Result[1] = 'T') then
    Result := 'I' + Copy(Result, 2);
end;

function TSourceGenerator.IsAssociationRequired(
  ARelationship: TGDAORelationship): boolean;
var
  c: integer;
begin
  for c := 0 to ARelationship.FieldLinks.Count - 1 do
    if (ARelationship.FieldLinks[c].ChildField <> nil) and ARelationship.FieldLinks[c].ChildField.Required then
      Exit(true);
  Exit(false);
end;

function TSourceGenerator.IsBlob(AType: string): boolean;
begin
  Result := SameText(AType, 'TBLOB');
end;

function TSourceGenerator.ManyValuedAssociationPropertyName(
  ARelationship: TGDAORelationship): string;
var
  mapping: TAssociationMapping;
begin
  if FOptions.Associations.TryGetValue(ARelationship.RelID, mapping) and not mapping.ManyValuedDefaultNaming then
    Exit(mapping.ManyValuedPropertyName);

  Result := BuildAssociationName(ARelationship, FOptions.ManyValuedNameSource, FOptions.ManyValuedNameFormat,
    FOptions.ManyValuedNameSingularize, FOptions.ManyValuedNameCamelCase, FOptions.ManyValuedNameRemoveUnderline);
end;

function TSourceGenerator.ManyValuedMapping(
  AManyValued: TGDAORelationship): TAssociationMapping;
begin
  if AManyValued = nil then
    Exit(nil);

  if not FOptions.Associations.ContainsKey(AManyValued.RelID) then
    FOptions.Associations.Add(AManyValued.RelID, TAssociationMapping.Create);
  Result := FOptions.Associations[AManyValued.RelID];
end;

{$IFDEF USE_SCRIPTER}
procedure TSourceGenerator.PrepareScripter(Scripter: TIDEScripter);
begin
  Scripter.DefineClassByRTTI(TCodeStatements, TRedefineOption.roNone, True);

  Scripter.DefineClassByRTTI(TCodeTypeReference, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeExpression, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeSnippetExpression, TRedefineOption.roNone, True);
  Scripter.AddEnumeration(TypeInfo(TCodeParameterModifier));
  Scripter.DefineClassByRTTI(TCodeParameterDeclaration, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeStatement, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeSnippetStatement, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeUsedUnit, TRedefineOption.roNone, True);
  Scripter.AddEnumeration(TypeInfo(TMemberVisibility));
  Scripter.DefineClassByRTTI(TCodeComment, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeAttributeArgument, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeAttributeDeclaration, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeTypeMember, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeMemberField, TRedefineOption.roNone, True);
  Scripter.AddEnumeration(TypeInfo(TCodeMethodDirective));
  Scripter.DefineClassByRTTI(TCodeMemberMethod, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeMemberConstructor, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeMemberDestructor, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeMemberProperty, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeTypeDeclaration, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TCodeUnit, TRedefineOption.roNone, True);

  Scripter.DefineClassByRTTI(TManyValuedAssociationGeneratedArgs);
  Scripter.DefineClassByRTTI(TColumnGeneratedArgs);
  Scripter.DefineClassByRTTI(TAssociationGeneratedArgs);
  Scripter.DefineClassByRTTI(TClassGeneratedArgs);
  Scripter.DefineClassByRTTI(TUnitGeneratedArgs);

  Scripter.DefineClassByRTTI(TGDAORelationship, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAORelationshipFieldLinks, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAORelationshipFieldLink, TRedefineOption.roNone, True);

  Scripter.DefineClassByRTTI(TGDAOTable, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOFields, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOField, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOIndexes, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOIndex, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOConstraints, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOConstraint, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOIFields, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOIField, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOTriggers, TRedefineOption.roNone, True);
  Scripter.DefineClassByRTTI(TGDAOTrigger, TRedefineOption.roNone, True);

  //  Scripter.DefineClassByRTTI(TColumnArgs);
end;
{$ENDIF}

function TSourceGenerator.PropertyName(AField: TGDAOField): string;
var
  mapping: TFieldMapping;
  tableMapping: TTableMapping;
  baseName: string;
begin
  if FOptions.Tables.TryGetValue(AField.OwnerTable.TID, tableMapping) and
    tableMapping.Fields.TryGetValue(AField.FID, mapping) and not mapping.DefaultNaming then
    Exit(mapping.PropertyName);

  // default namings
  case FOptions.FieldNameSource of
    nsName: baseName := AField.FieldName;
    nsCaption:
      if AField.FieldCaption <> '' then
        baseName := AField.FieldCaption
      else
        ErrorFmt('Field "%s" has no caption', [AField.FieldName]);
  end;

  if FOptions.FieldNameCamelCase then
    baseName := CamelCase(baseName);
  if FOptions.FieldNameRemoveUnderline then
    basename := RemoveUnderline(baseName);

  result := Format(FOptions.FieldNameFormat, [baseName]);
  result := IdentName(result);
  result := ValidName(result);
end;

function TSourceGenerator.PropertyType(AField: TGDAOField): string;
var
  mapping: TFieldMapping;
  tableMapping: TTableMapping;
begin
  if FOptions.Tables.TryGetValue(AField.OwnerTable.TID, tableMapping) and
    tableMapping.Fields.TryGetValue(AField.FID, mapping) and not mapping.DefaultType then
    Exit(mapping.PropertyType);

  // Get the regular type
  result := GetPrimitiveDelphiType(AField);
  if (not AField.Required) and not IsBlob(result) and not FOptions.NoNullable then
    result := Format('Nullable<%s>', [result]);
end;

function TSourceGenerator.TableDictionaryName(ATable: TGDAOTable): string;
begin
  Result := ClassName(ATable);
  if (Length(Result) > 1) and (Result[1] = 'T') then
    Result := Copy(Result, 2, MaxInt);
end;

function TSourceGenerator.TableMapping(ATable: TGDAOTable): TTableMapping;
begin
  if ATable = nil then
    Exit(nil);

  if not FOptions.Tables.ContainsKey(ATable.TID) then
    FOptions.Tables.Add(ATable.TID, TTableMapping.Create);
  Result := FOptions.Tables[ATable.TID];
end;

function TSourceGenerator.ValidName(S: string): string;
const
  reservedWords: array[0..71] of string =
    (
    'and', 'end', 'interface', 'raise', 'uses', 'array', 'except', 'is', 'record', 'var', 'as', 'exports',
    'label', 'repeat', 'while', 'asm', 'file', 'library', 'resourcestring', 'with', 'begin', 'finalization',
    'mod', 'set', 'xor', 'case', 'finally', 'nil', 'shl', 'class', 'for', 'not', 'shr', 'const', 'function',
    'object', 'string', 'constructor', 'goto', 'of', 'then', 'destructor', 'if', 'or', 'threadvar',
    'dispinterface', 'implementation', 'out', 'to', 'div', 'in', 'packed', 'try', 'do', 'inherited', 'procedure',
    'type', 'downto', 'initialization', 'program', 'unit', 'else', 'inline', 'property', 'until', 'private',
    'protected', 'public', 'published', 'automated', 'at', 'on'
    );
var
  c: Integer;
begin
  for c := Low(reservedWords) to High(reservedWords) do
    if SameText(S, reservedWords[c]) then
      Exit(S + '_');
  result := S;
end;

{ EMissingSequenceError }

constructor EMissingSequenceError.Create(ATable: TGDAOTable; ASequenceName: string);
begin
  FTable := ATable;
  if ASequenceName = '' then
    inherited CreateFmt('Missing sequence for table "%s".', [ATable.TableName])
  else
    inherited CreateFmt('Sequence "%s" for table "%s" not found.', [ASequenceName, ATable.TableName]);
end;

{ TManyValuedAssociationArgs }

constructor TManyValuedAssociationGeneratedArgs.Create(ACodeUnit: TCodeUnit;
  ACodeType: TCodeTypeDeclaration; AProp: TCodeMemberProperty;
  AField: TCodeMemberField; AGetter: TCodeMemberMethod;
  AAssociationAttr: TCodeAttributeDeclaration;
  AConstructorMethod: TCodeMemberConstructor;
  ADestructorMethod: TCodeMemberDestructor;
  ADBRelationship: TGDAORelationship);
begin
  FCodeUnit := ACodeUnit;
  FCodeType := ACodeType;
  FProp := AProp;
  FField := AField;
  FGetter := AGetter;
  FAssociationAttr := AAssociationAttr;
  FConstructorMethod := AConstructorMethod;
  FDestructorMethod := ADestructorMethod;
  FDBRelationship := ADBRelationship;
end;

{ TColumnGeneratedArgs }

constructor TColumnGeneratedArgs.Create(ACodeUnit: TCodeUnit;
  ACodeType: TCodeTypeDeclaration; AProp: TCodeMemberProperty;
  AField: TCodeMemberField; AColumnAttr: TCodeAttributeDeclaration;
  ADBField: TGDAOField);
begin
  FCodeUnit := ACodeUnit;
  FCodeType := ACodeType;
  FProp := AProp;
  FField := AField;
  FColumnAttr := AColumnAttr;
  FDBField := ADBField;
end;

{ TAssociationGeneratedArgs }

constructor TAssociationGeneratedArgs.Create(ACodeUnit: TCodeUnit;
  ACodeType: TCodeTypeDeclaration; AProp: TCodeMemberProperty;
  AField: TCodeMemberField; AGetter, ASetter: TCodeMemberMethod;
  AAssociationAttr: TCodeAttributeDeclaration;
  ADBRelationship: TGDAORelationship);
begin
  FCodeUnit := ACodeUnit;
  FCodeType := ACodeType;
  FProp := AProp;
  FField := AField;
  FGetter := AGetter;
  FSetter := ASetter;
  FAssociationAttr := AAssociationAttr;
  FDBRelationship := ADBRelationship;
end;

{ TClassGeneratedArgs }

constructor TClassGeneratedArgs.Create(ACodeUnit: TCodeUnit;
  ACodeType: TCodeTypeDeclaration; ADBTable: TGDAOTable;
  ATableAttr: TCodeAttributeDeclaration; AIdAttrs: TArray<TCodeAttributeDeclaration>;
  ASequenceAttr: TCodeAttributeDeclaration);
begin
  FCodeUnit := ACodeUnit;
  FCodeType := ACodeType;
  FDBTable := ADBTable;
  FTableAttr := ATableAttr;
  FIdAttrs := AIdAttrs;
  FSequenceAttr := ASequenceAttr;
end;

{ TUnitGeneratedArgs }

constructor TUnitGeneratedArgs.Create(ACodeUnit: TCodeUnit);
begin
  FCodeUnit := ACodeUnit;
end;

end.
