unit Aurelius.SourceGenerator.Options;

interface

uses
  SysUtils, Classes, Generics.Collections;

type
  TOneToOneMappingMode = (omDefault, omAssociation, omInheritance);
  TOneToOneMapping = omAssociation..omInheritance;
  TBaseNameSource = (nsName, nsCaption);
  TAssociationNameSource = (
    asParentTableName, asParentTableCaption,
    asChildTableName, asChildTableCaption,
    asParentFieldName, asParentFieldCaption,
    asChildFieldName, asChildFieldCaption,
    asCaption);
  TFetchModeOptions = (fmDefault, fmLazy, fmEager);
  TFetchMode = fmLazy..fmEager;

  TCascadeDefinitionOptions = (cdDefault, cdNone, cdAllButRemove, cdAll);
  TCascadeDefinition = cdNone..cdAll;
  TCheckSequencesMode = (csAuto, csAlways, csNever);

  TFieldMapping = class
  private
    FPropertyName: string;
    FExcluded: boolean;
    FPropertyType: string;
    function GetDefaultNaming: boolean;
    function GetDefaultType: boolean;
  public
    property PropertyName: string read FPropertyName write FPropertyName;
    property Excluded: boolean read FExcluded write FExcluded;
    property DefaultNaming: boolean read GetDefaultNaming;
    property PropertyType: string read FPropertyType write FPropertyType;
    property DefaultType: boolean read GetDefaultType;
  end;

  TAssociationMapping = class
  private
    FPropertyName: string;
    FExcluded: boolean;
    FOneToOneMapping: TOneToOneMappingMode;
    FManyValuedPropertyName: string;
    FManyValuedIncluded: boolean;
    FFetchMode: TFetchModeOptions;
    FCascadeDefinition: TCascadeDefinitionOptions;
    FManyValuedFetchMode: TFetchModeOptions;
    function GetDefaultNaming: boolean;
    function GetManyValuedDefaultNaming: boolean;
  public
    constructor Create;
    property PropertyName: string read FPropertyName write FPropertyName;
    property Excluded: boolean read FExcluded write FExcluded;
    property DefaultNaming: boolean read GetDefaultNaming;
    property FetchMode: TFetchModeOptions read FFetchMode write FFetchMode;
    property CascadeDefinition: TCascadeDefinitionOptions read FCascadeDefinition write FCascadeDefinition;
    property OneToOneMapping: TOneToOneMappingMode read FOneToOneMapping write FOneToOneMapping;

    property ManyValuedPropertyName: string read FManyValuedPropertyName write FManyValuedPropertyName;
    property ManyValuedIncluded: boolean read FManyValuedIncluded write FManyValuedIncluded;
    property ManyValuedDefaultNaming: boolean read GetManyValuedDefaultNaming;
    property ManyValuedFetchMode: TFetchModeOptions read FManyValuedFetchMode write FManyValuedFetchMode;
  end;

  TTableMapping = class
  private
    FFieldMappings: TObjectDictionary<integer, TFieldMapping>;
    FEntityClassName: string;
    FExcluded: boolean;
    FDynPropContainer: string;
    FCustomContainer: boolean;
    FSequenceName: string;
    FModelNames: string;
    FClassUnitName: string;
    function GetDefaultNaming: boolean;
    function GetIgnoreSequence: boolean;
    function GetDefaultModelNaming: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property Fields: TObjectDictionary<integer, TFieldMapping> read FFieldMappings;
    property EntityClassName: string read FEntityClassName write FEntityClassName;
    property Excluded: boolean read FExcluded write FExcluded;
    property DefaultNaming: boolean read GetDefaultNaming;
    property DefaultModelNaming: boolean read GetDefaultModelNaming;
    property DynPropContainer: string read FDynPropContainer write FDynPropContainer;
    property ModelNames: string read FModelNames write FModelNames;
    property ClassUnitName: string read FClassUnitName write FClassUnitName;
    property CustomContainer: boolean read FCustomContainer write FCustomContainer;
    property SequenceName: string read FSequenceName write FSequenceName;
    property IgnoreSequence: boolean read GetIgnoreSequence;
  end;

  TSourceGeneratorOptions = class
  private
    FProjectFile: string;
    FOutputDir: string;
    FCommonBaseClass: string;
    FTableMappings: TObjectDictionary<integer, TTableMapping>;
    FAssociationMappings: TObjectDictionary<integer, TAssociationMapping>;
    FTableNameSource: TBaseNameSource;
    FTableNameFormat: string;
    FFieldNameFormat: string;
    FFieldNameSource: TBaseNameSource;
    FAssociationNameFormat: string;
    FAssociationNameSource: TAssociationNameSource;
    FManyValuedNameFormat: string;
    FManyValuedNameSource: TAssociationNameSource;
    FDefaultAssociationFetchMode: TFetchMode;
    FDefaultManyValuedFetchMode: TFetchMode;
    FDefaultAssociationCascadeDefinition: TCascadeDefinition;
    FDefaultOneToOneMapping: TOneToOneMapping;
    FDefaultAncestorClass: string;
    FMainUnitName: string;
    FOmitDictionary: boolean;
    FNewDictionary: Boolean;
    FDictionaryName: string;
    FDictionaryUnitName: string;
    FCreateDescriptions: boolean;
    FRegisterEntities: boolean;
    FTableNameSingularize: boolean;
    FManyValuedNameSingularize: boolean;
    FDefaultDynPropContainer: string;
    FCheckSequencesMode: TCheckSequencesMode;
    FTableNameRemoveUnderline: boolean;
    FTableNameCamelCase: boolean;
    FManyValuedNameRemoveUnderline: boolean;
    FManyValuedNameCamelCase: boolean;
    FFieldNameRemoveUnderline: boolean;
    FFieldNameCamelCase: boolean;
    FAssociationNameRemoveUnderline: boolean;
    FAssociationNameCamelCase: boolean;
    FNoNullable: boolean;
    FScript: string;
//    procedure LoadFromFile(AFileName: string);
//    procedure SaveToFile(AFileName: string);
  public
    constructor Create;
    destructor Destroy; override;

    property CommonBaseClass: string read FCommonBaseClass write FCommonBaseClass;
    property ProjectFile: string read FProjectFile write FProjectFile;
    property OutputDir: string read FOutputDir write FOutputDir;
    property Tables: TObjectDictionary<integer, TTableMapping> read FTableMappings;
    property Associations: TObjectDictionary<integer, TAssociationMapping> read FAssociationMappings;

    property DefaultAssociationFetchMode: TFetchMode read FDefaultAssociationFetchMode write FDefaultAssociationFetchMode;
    property DefaultManyValuedFetchMode: TFetchMode read FDefaultManyValuedFetchMode write FDefaultManyValuedFetchMode;
    property DefaultAssociationCascadeDefinition: TCascadeDefinition read FDefaultAssociationCascadeDefinition write FDefaultAssociationCascadeDefinition;
    property DefaultOneToOneMapping: TOneToOneMapping read FDefaultOneToOneMapping write FDefaultOneToOneMapping;
    property DefaultAncestorClass: string read FDefaultAncestorClass write FDefaultAncestorClass;
    property DefaultDynPropContainer: string read FDefaultDynPropContainer write FDefaultDynPropContainer;
    property CheckSequencesMode: TCheckSequencesMode read FCheckSequencesMode write FCheckSequencesMode;
    property MainUnitName: string read FMainUnitName write FMainUnitName;

    property TableNameSource: TBaseNameSource read FTableNameSource write FTableNameSource;
    property TableNameFormat: string read FTableNameFormat write FTableNameFormat;
    property TableNameSingularize: boolean read FTableNameSingularize write FTableNameSingularize;
    property TableNameCamelCase: boolean read FTableNameCamelCase write FTableNameCamelCase;
    property TableNameRemoveUnderline: boolean read FTableNameRemoveUnderline write FTableNameRemoveUnderline;

    property FieldNameSource: TBaseNameSource read FFieldNameSource write FFieldNameSource;
    property FieldNameFormat: string read FFieldNameFormat write FFieldNameFormat;
    property FieldNameCamelCase: boolean read FFieldNameCamelCase write FFieldNameCamelCase;
    property FieldNameRemoveUnderline: boolean read FFieldNameRemoveUnderline write FFieldNameRemoveUnderline;

    property AssociationNameSource: TAssociationNameSource read FAssociationNameSource write FAssociationNameSource;
    property AssociationNameFormat: string read FAssociationNameFormat write FAssociationNameFormat;
    property AssociationNameCamelCase: boolean read FAssociationNameCamelCase write FAssociationNameCamelCase;
    property AssociationNameRemoveUnderline: boolean read FAssociationNameRemoveUnderline write FAssociationNameRemoveUnderline;

    property ManyValuedNameSource: TAssociationNameSource read FManyValuedNameSource write FManyValuedNameSource;
    property ManyValuedNameFormat: string read FManyValuedNameFormat write FManyValuedNameFormat;
    property ManyValuedNameSingularize: boolean read FManyValuedNameSingularize write FManyValuedNameSingularize;
    property ManyValuedNameCamelCase: boolean read FManyValuedNameCamelCase write FManyValuedNameCamelCase;
    property ManyValuedNameRemoveUnderline: boolean read FManyValuedNameRemoveUnderline write FManyValuedNameRemoveUnderline;

    property OmitDictionary: boolean read FOmitDictionary write FOmitDictionary;
    property NewDictionary: boolean read FNewDictionary write FNewDictionary;
    property DictionaryName: string read FDictionaryName write FDictionaryName;
    property DictionaryUnitName: string read FDictionaryUnitName write FDictionaryUnitName;
    property CreateDescriptions: boolean read FCreateDescriptions write FCreateDescriptions;
    property RegisterEntities: boolean read FRegisterEntities write FRegisterEntities;
    property NoNullable: boolean read FNoNullable write FNoNullable;
    property Script: string read FScript write FScript;
  end;

implementation

uses
  Variants;

{ TSourceGeneratorOptions }

constructor TSourceGeneratorOptions.Create;
begin
  FTableMappings := TObjectDictionary<integer, TTableMapping>.Create([doOwnsValues]);
  FAssociationMappings := TObjectDictionary<integer, TAssociationMapping>.Create([doOwnsValues]);
  FTableNameSource := nsCaption;
  FTableNameFormat := 'T%s';
  FTableNameSingularize := false;
  FFieldNameSource := nsCaption;
  FFieldNameFormat := '%s';
  FAssociationNameSource := asChildFieldCaption;
  FAssociationNameFormat := '%s';
  FManyValuedNameSource := asChildTableCaption;
  FManyValuedNameFormat := '%sList';
  FManyValuedNameSingularize := false;
  FDefaultAssociationFetchMode := fmLazy;
  FDefaultManyValuedFetchMode := fmLazy;
  FDefaultAssociationCascadeDefinition := cdAllButRemove;
  FDefaultOneToOneMapping := omAssociation;
  FCheckSequencesMode := csAuto;
  FMainUnitName := 'UnitName';
  FOmitDictionary := false;
  FNewDictionary := false;
  FCreateDescriptions := false;
  FRegisterEntities := True;
  FDictionaryName := 'Dic';
  FDictionaryUnitName := '';
  FScript := '';
end;

destructor TSourceGeneratorOptions.Destroy;
begin
  FTableMappings.Free;
  FAssociationMappings.Free;
  inherited;
end;

//procedure TSourceGeneratorOptions.LoadFromFile(AFileName: string);
//var
//  SL: TStringList;
//begin
//  SL := TStringList.Create;
//  try
//    SL.LoadFromFile(AFileName);
//    LoadFromXml(SL.Text);
//  finally
//    SL.Free;
//  end;
//end;

//procedure TSourceGeneratorOptions.SaveToFile(AFileName: string);
//var
//  SL: TStringList;
//begin
//  SL := TStringList.Create;
//  try
//    SL.Text := GetXml;
//    SL.SaveToFile(AFileName);
//  finally
//    SL.Free;
//  end;
//end;

{ TTableMapping }

constructor TTableMapping.Create;
begin
  FFieldMappings := TObjectDictionary<integer, TFieldMapping>.Create([doOwnsValues]);
end;

destructor TTableMapping.Destroy;
begin
  FFieldMappings.Free;
  inherited;
end;

function TTableMapping.GetDefaultModelNaming: boolean;
begin
  Result := ModelNames = '';
end;

function TTableMapping.GetDefaultNaming: boolean;
begin
  Result := EntityClassName = '';
end;

function TTableMapping.GetIgnoreSequence: boolean;
begin
  Result := SameText(SequenceName, '(none)');
end;

{ TAssociationMapping }

constructor TAssociationMapping.Create;
begin
  FOneToOneMapping := omDefault;
  FFetchMode := fmDefault;
  FManyValuedFetchMode := fmDefault;
  FCascadeDefinition := cdDefault;
end;

function TAssociationMapping.GetDefaultNaming: boolean;
begin
  Result := PropertyName = '';
end;

function TAssociationMapping.GetManyValuedDefaultNaming: boolean;
begin
  Result := ManyValuedPropertyName = '';
end;

{ TFieldMapping }

function TFieldMapping.GetDefaultNaming: boolean;
begin
  Result := PropertyName = '';
end;

function TFieldMapping.GetDefaultType: boolean;
begin
  Result := PropertyType = '';
end;

end.
