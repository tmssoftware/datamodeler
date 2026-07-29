unit Aurelius.SourceGenerator.Options.Xml;

interface

uses
  XmlDoc, XmlIntf,
  Aurelius.SourceGenerator.Options;

type
  TSourceGeneratorOptionsXmlWriter = class
  private
    FOptions: TSourceGeneratorOptions;
    FDoc: IXmlDocument;
    procedure WriteString(ANode: IXmlNode; AKey: string; AValue: string);
    procedure WriteTableMapping(AContainer: IXmlNode; ATableId: integer; AMapping: TTableMapping);
    procedure WriteFieldMapping(AContainer: IXmlNode; AFieldId: integer; AMapping: TFieldMapping);
    procedure WriteAssociationMapping(AContainer: IXmlNode; AAssociationId: integer; AMapping: TAssociationMapping);
  public
    constructor Create(AOptions: TSourceGeneratorOptions);
    destructor Destroy; override;
    function GetXml: string;
  end;

  TSourceGeneratorOptionsXmlReader = class
  private
    FDoc: IXmlDocument;
    FOptions: TSourceGeneratorOptions;
    function ReadString(ANode: IXmlNode; AKey: string; ADefaultValue: string): string;
    function ReadBoolean(ANode: IXmlNode; AKey: string; ADefaultValue: boolean): boolean;
    procedure ReadTableMapping(AContainer: IXmlNode);
    procedure ReadFieldMapping(AContainer: IXmlNode; ATableMapping: TTableMapping);
    procedure ReadAssociationMapping(AContainer: IXmlNode);
  private
    function StrToNameSource(ASource: string): TBaseNameSource;
    function StrToAssociationNameSource(ASource: string): TAssociationNameSource;
  public
    constructor Create(AOptions: TSourceGeneratorOptions);
    destructor Destroy; override;
    procedure Load(Xml: string);
  end;

function GetOptionsXml(Options: TSourceGeneratorOptions): string;
procedure LoadOptionsFromXml(Options: TSourceGeneratorOptions; AXml: string);

implementation

uses
  Variants, SysUtils, Generics.Collections;

function GetOptionsXml(Options: TSourceGeneratorOptions): string;
var
  Writer: TSourceGeneratorOptionsXmlWriter;
begin
  Writer := TSourceGeneratorOptionsXmlWriter.Create(Options);
  try
    Result := Writer.GetXml;
  finally
    Writer.Free;
  end;
end;

procedure LoadOptionsFromXml(Options: TSourceGeneratorOptions; AXml: string);
var
  Reader: TSourceGeneratorOptionsXmlReader;
begin
  Reader := TSourceGeneratorOptionsXmlReader.Create(Options);
  try
    Reader.Load(AXml);
  finally
    Reader.Free;
  end;
end;

function NameSourceToStr(ASource: TBaseNameSource): string;
begin
  case ASource of
    nsName:  result := 'name';
    nsCaption: result := 'caption';
  end;
end;

function AssociationNameSourceToStr(ASource: TAssociationNameSource): string;
begin
  case ASource of
    asParentTableName: result := 'ParentTable';
    asParentTableCaption: result := 'ParentTableCaption';
    asChildTableName: result := 'ChildTable';
    asChildTableCaption: result := 'ChildTableCaption';
    asParentFieldName: result := 'ParentField';
    asParentFieldCaption: result := 'ParentFieldCaption';
    asChildFieldName: result := 'ChildField';
    asChildFieldCaption: result := 'ChildFieldCaption';
    asCaption: result := 'caption';
  end;
end;

{ TSourceGeneratorOptionsXmlWriter }

constructor TSourceGeneratorOptionsXmlWriter.Create(
  AOptions: TSourceGeneratorOptions);
begin
  FOptions := AOptions;
  FDoc := TXMLDocument.Create(nil);
end;

destructor TSourceGeneratorOptionsXmlWriter.Destroy;
begin
  inherited;
end;

function TSourceGeneratorOptionsXmlWriter.GetXml: string;
var
  mappingsNode: IXmlNode;
  tablesNode: IXmlNode;
  tableEntry: TPair<integer, TTableMapping>;
  associationsNode: IXmlNode;
  associationEntry: TPair<integer, TAssociationMapping>;
  subNode: IXmlNode;
begin
  FDoc.Active := True;
  mappingsNode := FDoc.AddChild('Mappings');
  WriteString(mappingsNode, 'ProjectFile', FOptions.ProjectFile);
  WriteString(mappingsNode, 'OutputDir', FOptions.OutputDir);
  WriteString(mappingsNode, 'MainUnitName', FOptions.MainUnitName);
  WriteString(mappingsNode, 'DictionaryName', FOptions.DictionaryName);
  WriteString(mappingsNode, 'DictionaryUnitName', FOptions.DictionaryUnitName);
  case FOptions.DefaultNonNativePascalTypeConvertion of
    nnptVariant: WriteString(mappingsNode,'DefaultNonNativePascalTypeConvertion', 'Variant');
    nnptString: WriteString(mappingsNode,'DefaultNonNativePascalTypeConvertion', 'String');
    nnptInteger: WriteString(mappingsNode,'DefaultNonNativePascalTypeConvertion', 'Integer');
  else
    // DEFAULT
    // nnptVariant:
  end;
  WriteString(mappingsNode, 'Script', FOptions.Script);
  if FOptions.OmitDictionary then
    mappingsNode.Attributes['OmitDictionary'] := 'true';
  if FOptions.NewDictionary then
    mappingsNode.Attributes['NewDictionary'] := 'true';
  if FOptions.CreateDescriptions then
    mappingsNode.Attributes['CreateDescriptions'] := 'true';
  if FOptions.RegisterEntities then
    mappingsNode.Attributes['RegisterEntities'] := 'true';
  if FOptions.NoNullable then
    mappingsNode.Attributes['NoNullable'] := 'true';
  if FOptions.DefaultAncestorClass <> '' then
    WriteString(mappingsNode, 'DefaultAncestorClass', FOptions.DefaultAncestorClass);
  if FOptions.DefaultDynPropContainer <> '' then
    WriteString(mappingsNode, 'DefaultDynPropContainer', FOptions.DefaultDynPropContainer);

  subNode := mappingsNode.AddChild('TableNaming');
  subNode.Attributes['Source'] := NameSourceToStr(FOptions.TableNameSource);
  subNode.Attributes['Format'] := FOptions.TableNameFormat;
  if FOptions.TableNameSingularize then
    subNode.Attributes['Singularize'] := 'true';
  if FOptions.TableNameCamelCase then
    subNode.Attributes['CamelCase'] := 'true';
  if FOptions.TableNameRemoveUnderline then
    subNode.Attributes['RemoveUnderline'] := 'true';

  subNode := mappingsNode.AddChild('FieldNaming');
  subNode.Attributes['Source'] := NameSourceToStr(FOptions.FieldNameSource);
  subNode.Attributes['Format'] := FOptions.FieldNameFormat;
  if FOptions.FieldNameCamelCase then
    subNode.Attributes['CamelCase'] := 'true';
  if FOptions.FieldNameRemoveUnderline then
    subNode.Attributes['RemoveUnderline'] := 'true';

  subNode := mappingsNode.AddChild('AssociationNaming');
  subNode.Attributes['Source'] := AssociationNameSourceToStr(FOptions.AssociationNameSource);
  subNode.Attributes['Format'] := FOptions.AssociationNameFormat;
  if FOptions.AssociationNameCamelCase then
    subNode.Attributes['CamelCase'] := 'true';
  if FOptions.AssociationNameRemoveUnderline then
    subNode.Attributes['RemoveUnderline'] := 'true';

  subNode := mappingsNode.AddChild('ManyValuedNaming');
  subNode.Attributes['Source'] := AssociationNameSourceToStr(FOptions.ManyValuedNameSource);
  subNode.Attributes['Format'] := FOptions.ManyValuedNameFormat;
  if FOptions.ManyValuedNameSingularize then
    subNode.Attributes['Singularize'] := 'true';
  if FOptions.ManyValuedNameCamelCase then
    subNode.Attributes['CamelCase'] := 'true';
  if FOptions.ManyValuedNameRemoveUnderline then
    subNode.Attributes['RemoveUnderline'] := 'true';

  case FOptions.DefaultAssociationFetchMode of
    fmEager: mappingsNode.Attributes['DefaultAssociationFetchMode'] := 'eager';
  else
    // DEFAULT
    // fmLazy: mappingsNode.Attributes['DefaultAssociationFetchMode'] := 'lazy';
  end;

  case FOptions.DefaultAssociationCascadeDefinition of
    cdAllButRemove: mappingsNode.Attributes['DefaultAssociationCascadeDefinition'] := 'allbutremove';
    cdAll: mappingsNode.Attributes['DefaultAssociationCascadeDefinition'] := 'all';
  else
    // DEFAULT
    // cdNone:
  end;

  case FOptions.DefaultManyValuedFetchMode of
    fmEager: mappingsNode.Attributes['DefaultManyValuedFetchMode'] := 'eager';
  else
    // DEFAULT
    // fmLazy: mappingsNode.Attributes['DefaultManyValuedFetchMode'] := 'lazy';
  end;

  case FOptions.DefaultOneToOneMapping of
    omInheritance: mappingsNode.Attributes['DefaultOneToOneMapping'] := 'inheritance';
  else
    // omAssociation: default
  end;

  case FOptions.CheckSequencesMode of
    csAlways: mappingsNode.Attributes['CheckSequencesMode'] := 'always';
    csNever: mappingsNode.Attributes['CheckSequencesMode'] := 'never';
  else
    // omAssociation: default
  end;

  tablesNode := mappingsNode.AddChild('Tables');
  for tableEntry in FOptions.Tables do
    WriteTableMapping(tablesNode, tableEntry.Key, tableEntry.Value);

  associationsNode := mappingsNode.AddChild('Associations');
  for associationEntry in FOptions.Associations do
    WriteAssociationMapping(associationsNode, associationEntry.Key, associationEntry.Value);

  Result := XmlDoc.FormatXMLData(FDoc.XML.Text);

//  FDoc.XML.Text := XmlDoc.FormatXMLData(FDoc.XML.Text);
//  FDoc.Active := True;
//  FDoc.SaveToFile(AFileName);
end;

procedure TSourceGeneratorOptionsXmlWriter.WriteAssociationMapping(
  AContainer: IXmlNode; AAssociationId: integer; AMapping: TAssociationMapping);
var
  newNode: IXmlNode;
begin
  newNode := AContainer.AddChild('Association');
  newNode.Attributes['AssociationId'] := AAssociationId;
  if AMapping.PropertyName <> '' then
    newNode.Attributes['PropertyName'] := AMapping.PropertyName;
  if AMapping.Excluded then
    newNode.Attributes['Exclude'] := 'true';
  case AMapping.OneToOneMapping of
    omDefault: ;
    omAssociation: newNode.Attributes['OneToOne'] := 'association';
    omInheritance: newNode.Attributes['OneToOne'] := 'inheritance';
  end;
  case AMapping.FetchMode of
    fmDefault: ;
    fmLazy: newNode.Attributes['FetchMode'] := 'lazy';
    fmEager: newNode.Attributes['FetchMode'] := 'eager';
  end;
  case AMapping.CascadeDefinition of
    cdDefault: ;
    cdNone: newNode.Attributes['CascadeDefinition'] := 'none';
    cdAllButRemove: newNode.Attributes['CascadeDefinition'] := 'allbutremove';
    cdAll: newNode.Attributes['CascadeDefinition'] := 'all';
  end;

  if AMapping.ManyValuedPropertyName <> '' then
    newNode.Attributes['ManyValuedPropertyName'] := AMapping.ManyValuedPropertyName;
  if AMapping.ManyValuedIncluded then
    newNode.Attributes['ManyValuedInclude'] := 'true';
  case AMapping.ManyValuedFetchMode of
    fmDefault: ;
    fmLazy: newNode.Attributes['ManyValuedFetchMode'] := 'lazy';
    fmEager: newNode.Attributes['ManyValuedFetchMode'] := 'eager';
  end;


  // To avoid having a too big xml file, we will remove this node if this field mapping
  // has no relevant info to be saved, in other words, if it has only default values.
  // If the node has only the FieldId attribute then it's only default
  if (newNode.AttributeNodes.Count = 1) then
    AContainer.ChildNodes.Remove(newNode);
end;

procedure TSourceGeneratorOptionsXmlWriter.WriteFieldMapping(
  AContainer: IXmlNode; AFieldId: integer; AMapping: TFieldMapping);
var
  newNode: IXmlNode;
begin
  newNode := AContainer.AddChild('Field');
  newNode.Attributes['FieldId'] := AFieldId;

  if AMapping.PropertyName <> '' then
    newNode.Attributes['PropertyName'] := AMapping.PropertyName;
  if AMapping.Excluded then
    newNode.Attributes['Exclude'] := 'true';
  if AMapping.PropertyType <> '' then
    newNode.Attributes['PropertyType'] := AMapping.PropertyType;

  // To avoid having a too big xml file, we will remove this node if this field mapping
  // has no relevant info to be saved, in other words, if it has only default values.
  // If the node has only the FieldId attribute then it's only default
  if (newNode.AttributeNodes.Count = 1) then
    AContainer.ChildNodes.Remove(newNode);
end;

procedure TSourceGeneratorOptionsXmlWriter.WriteString(ANode: IXmlNode; AKey,
  AValue: string);
var
  NewNode: IXmlNode;
begin
  NewNode := ANode.AddChild(AKey);
  NewNode.Text := AValue;
end;

procedure TSourceGeneratorOptionsXmlWriter.WriteTableMapping(
  AContainer: IXmlNode; ATableId: integer; AMapping: TTableMapping);
var
  newNode: IXmlNode;
  fieldEntry: TPair<integer, TFieldMapping>;
  fieldsNode: IXmlNode;
begin
  newNode := AContainer.AddChild('Table');
  newNode.Attributes['TableId'] := ATableId;
  if AMapping.EntityClassName <> '' then
    newNode.Attributes['ClassName'] := AMapping.EntityClassName;
  if AMapping.CustomContainer then
    newNode.Attributes['DynPropContainer'] := AMapping.DynPropContainer;
  if AMapping.ModelNames <> '' then
    newNode.Attributes['ModelNames'] := AMapping.ModelNames;
  if AMapping.ClassUnitName <> '' then
    newNode.Attributes['ClassUnitName'] := AMapping.ClassUnitName;
  if AMapping.SequenceName <> '' then
    newNode.Attributes['Sequence'] := AMapping.SequenceName;

  if AMapping.Excluded then
    newNode.Attributes['Exclude'] := 'true';

  fieldsNode := newNode.AddChild('Fields');
  for fieldEntry in AMapping.Fields do
    WriteFieldMapping(fieldsNode, fieldEntry.Key, fieldEntry.Value);
  // if no fields are inserted, then remove the "Fields" container
  if fieldsNode.ChildNodes.Count = 0 then
    newNode.ChildNodes.Remove(fieldsNode);

  // To avoid having a too big xml file, we will remove this node if this table mapping
  // has no relevant info to be saved, in other words, if it has only default values
  // If the node has only the TableId attribute, and no fields in it, then it's only default
  if (newNode.AttributeNodes.Count = 1) and (fieldsNode.ChildNodes.Count = 0) then
    AContainer.ChildNodes.Remove(newNode);
end;

{ TSourceGeneratorOptions.TXmlReader }

constructor TSourceGeneratorOptionsXmlReader.Create(
  AOptions: TSourceGeneratorOptions);
begin
  FOptions := AOptions;
  FDoc := TXmlDocument.Create(nil);
end;

destructor TSourceGeneratorOptionsXmlReader.Destroy;
begin
  inherited;
end;

procedure TSourceGeneratorOptionsXmlReader.Load(Xml: string);
var
  mappingsNode: IXmlNode;
  tablesNode: IXmlNode;
  associationsNode: IXmlNode;
  subNode: IXmlNode;
  c: Integer;
begin
  FDoc.LoadFromXML(Xml);
  FDoc.Active := True;
  mappingsNode := FDoc.ChildNodes.FindNode('Mappings');
  if mappingsNode = nil then
    Exit;
  FOptions.ProjectFile := ReadString(mappingsNode, 'ProjectFile', '');
  FOptions.OutputDir := ReadString(mappingsNode, 'OutputDir', '');
  FOptions.MainUnitName := ReadString(mappingsNode, 'MainUnitName', 'UnitName');
  FOptions.DictionaryName := ReadString(mappingsNode, 'DictionaryName', 'Dic');
  if LowerCase(ReadString(mappingsNode, 'DefaultNonNativePascalTypeConvertion', '')) = 'string' then
    FOptions.DefaultNonNativePascalTypeConvertion := nnptString
  else
  if LowerCase(ReadString(mappingsNode, 'DefaultNonNativePascalTypeConvertion', '')) = 'integer' then
    FOptions.DefaultNonNativePascalTypeConvertion := nnptInteger
  else
    FOptions.DefaultNonNativePascalTypeConvertion := nnptVariant;
  FOptions.DictionaryUnitName := ReadString(mappingsNode, 'DictionaryUnitName', '');
  FOptions.Script := ReadString(mappingsNode, 'Script', '');
  FOptions.DefaultAncestorClass := ReadString(mappingsNode, 'DefaultAncestorClass', '');
  FOptions.DefaultDynPropContainer := ReadString(mappingsNode, 'DefaultDynPropContainer', '');

  FOptions.OmitDictionary := ReadBoolean(mappingsNode, 'OmitDictionary', False);
  FOptions.NewDictionary := ReadBoolean(mappingsNode, 'NewDictionary', False);
  FOptions.CreateDescriptions := ReadBoolean(mappingsNode, 'CreateDescriptions', False);
  FOptions.RegisterEntities := ReadBoolean(mappingsNode, 'RegisterEntities', False);
  FOptions.NoNullable := ReadBoolean(mappingsNode, 'NoNullable', False);

  subNode := mappingsNode.ChildNodes.FindNode('TableNaming');
  FOptions.TableNameSource := StrToNameSource(ReadString(subNode, 'Source', NameSourceToStr(FOptions.TableNameSource)));
  FOptions.TableNameFormat := ReadString(subNode, 'Format', FOptions.TableNameFormat);
  FOptions.TableNameSingularize := ReadBoolean(subNode, 'Singularize', False);
  FOptions.TableNameCamelCase := ReadBoolean(subNode, 'CamelCase', False);
  FOptions.TableNameRemoveUnderline := ReadBoolean(subNode, 'RemoveUnderline', False);

  subNode := mappingsNode.ChildNodes.FindNode('FieldNaming');
  FOptions.FieldNameSource := StrToNameSource(ReadString(subNode, 'Source', NameSourceToStr(FOptions.FieldNameSource)));
  FOptions.FieldNameFormat := ReadString(subNode, 'Format', FOptions.FieldNameFormat);
  FOptions.FieldNameCamelCase := ReadBoolean(subNode, 'CamelCase', False);
  FOptions.FieldNameRemoveUnderline := ReadBoolean(subNode, 'RemoveUnderline', False);

  subNode := mappingsNode.ChildNodes.FindNode('AssociationNaming');
  FOptions.AssociationNameSource := StrToAssociationNameSource(ReadString(subNode, 'Source', AssociationNameSourceToStr(FOptions.AssociationNameSource)));
  FOptions.AssociationNameFormat := ReadString(subNode, 'Format', FOptions.AssociationNameFormat);
  FOptions.AssociationNameCamelCase := ReadBoolean(subNode, 'CamelCase', False);
  FOptions.AssociationNameRemoveUnderline := ReadBoolean(subNode, 'RemoveUnderline', False);

  subNode := mappingsNode.ChildNodes.FindNode('ManyValuedNaming');
  FOptions.ManyValuedNameSource := StrToAssociationNameSource(ReadString(subNode, 'Source', AssociationNameSourceToStr(FOptions.ManyValuedNameSource)));
  FOptions.ManyValuedNameFormat := ReadString(subNode, 'Format', FOptions.ManyValuedNameFormat);
  FOptions.ManyValuedNameSingularize := ReadBoolean(subNode, 'Singularize', False);
  FOptions.ManyValuedNameCamelCase := ReadBoolean(subNode, 'CamelCase', False);
  FOptions.ManyValuedNameRemoveUnderline := ReadBoolean(subNode, 'RemoveUnderline', False);

  if LowerCase(ReadString(mappingsNode, 'DefaultAssociationFetchMode', '')) = 'eager' then
    FOptions.DefaultAssociationFetchMode := fmEager
  else
    FOptions.DefaultAssociationFetchMode := fmLazy;

  if LowerCase(ReadString(mappingsNode, 'DefaultAssociationCascadeDefinition', '')) = 'allbutremove' then
    FOptions.DefaultAssociationCascadeDefinition := cdAllButRemove
  else
  if LowerCase(ReadString(mappingsNode, 'DefaultAssociationCascadeDefinition', '')) = 'all' then
    FOptions.DefaultAssociationCascadeDefinition := cdAll
  else
    FOptions.DefaultAssociationCascadeDefinition := cdNone;

  if LowerCase(ReadString(mappingsNode, 'DefaultManyValuedFetchMode', '')) = 'eager' then
    FOptions.DefaultManyValuedFetchMode := fmEager
  else
    FOptions.DefaultManyValuedFetchMode := fmLazy;

  if LowerCase(ReadString(mappingsNode, 'DefaultOneToOneMapping', '')) = 'inheritance' then
    FOptions.DefaultOneToOneMapping := omInheritance
  else
    FOptions.DefaultOneToOneMapping := omAssociation;

  if LowerCase(ReadString(mappingsNode, 'CheckSequencesMode', '')) = 'always' then
    FOptions.CheckSequencesMode := csAlways
  else
  if LowerCase(ReadString(mappingsNode, 'CheckSequencesMode', '')) = 'never' then
    FOptions.CheckSequencesMode := csNever
  else
    FOptions.CheckSequencesMode := csAuto;

  tablesNode := mappingsNode.ChildNodes.FindNode('Tables');
  if tablesNode <> nil then
    for c := 0 to tablesNode.ChildNodes.Count - 1 do
      if SameText(tablesNode.ChildNodes[c].LocalName, 'Table') then
        ReadTableMapping(tablesNode.ChildNodes[c]);

  associationsNode := mappingsNode.ChildNodes.FindNode('Associations');
  if associationsNode <> nil then
    for c := 0 to associationsNode.ChildNodes.Count - 1 do
      if SameText(associationsNode.ChildNodes[c].LocalName, 'Association') then
        ReadAssociationMapping(associationsNode.ChildNodes[c]);
end;

procedure TSourceGeneratorOptionsXmlReader.ReadAssociationMapping(
  AContainer: IXmlNode);
var
  associationMapping: TAssociationMapping;
  associationId: integer;
  oneToOne: string;
begin
  if not AContainer.HasAttribute('AssociationId') then Exit;
  associationid := AContainer.Attributes['AssociationId'];
  associationMapping := TAssociationMapping.Create;
  FOptions.Associations.AddOrSetValue(associationId, associationMapping);

  associationMapping.PropertyName := ReadString(AContainer, 'PropertyName', '');
  associationMapping.Excluded := ReadBoolean(AContainer, 'Exclude', False);

  oneToOne := LowerCase(ReadString(AContainer, 'OneToOne', ''));
  if oneToOne = 'association' then
    associationMapping.OneToOneMapping := omAssociation
  else
  if oneToOne = 'inheritance' then
    associationMapping.OneToOneMapping := omInheritance
  else
    associationMapping.OneToOneMapping := omDefault;

  if LowerCase(ReadString(AContainer, 'FetchMode', '')) = 'eager' then
    associationMapping.FetchMode := fmEager
  else
  if LowerCase(ReadString(AContainer, 'FetchMode', '')) = 'lazy' then
    associationMapping.FetchMode := fmLazy
  else
    associationMapping.FetchMode := fmDefault;

  if LowerCase(ReadString(AContainer, 'CascadeDefinition', '')) = 'allbutremove' then
    associationMapping.CascadeDefinition := cdAllButRemove
  else
  if LowerCase(ReadString(AContainer, 'CascadeDefinition', '')) = 'all' then
    associationMapping.CascadeDefinition := cdAll
  else
  if LowerCase(ReadString(AContainer, 'CascadeDefinition', '')) = 'none' then
    associationMapping.CascadeDefinition := cdNone
  else
    associationMapping.CascadeDefinition := cdDefault;

  associationMapping.ManyValuedPropertyName := ReadString(AContainer, 'ManyValuedPropertyName', '');
  associationMapping.ManyValuedIncluded := ReadBoolean(AContainer, 'ManyValuedInclude', False);
  if LowerCase(ReadString(AContainer, 'ManyValuedFetchMode', '')) = 'eager' then
    associationMapping.ManyValuedFetchMode := fmEager
  else
  if LowerCase(ReadString(AContainer, 'ManyValuedFetchMode', '')) = 'lazy' then
    associationMapping.ManyValuedFetchMode := fmLazy
  else
    associationMapping.ManyValuedFetchMode := fmDefault;
end;

function TSourceGeneratorOptionsXmlReader.ReadBoolean(ANode: IXmlNode;
  AKey: string; ADefaultValue: boolean): boolean;
var
  S: string;
begin
  S := LowerCase(ReadString(ANode, AKey, 'default'));
  if (S = 'default') then
    Exit(ADefaultValue);
  if (S = 'false') or (S = '0') or (S = 'no') then
    Exit(false);
  if (S = 'true') or (S = '1') or (S = 'yes') then
    Exit(true);
  raise Exception.Create(Format('Invalid boolean value "%s" for node "%s"', [S, AKey]));
end;

procedure TSourceGeneratorOptionsXmlReader.ReadFieldMapping(
  AContainer: IXmlNode; ATableMapping: TTableMapping);
var
  fieldMapping: TFieldMapping;
  fieldId: integer;
begin
  if not AContainer.HasAttribute('FieldId') then Exit;
  fieldId := AContainer.Attributes['FieldId'];
  fieldMapping := TFieldMapping.Create;
  ATableMapping.Fields.AddOrSetValue(fieldId, fieldMapping);

  fieldMapping.PropertyName := ReadString(AContainer, 'PropertyName', '');
  fieldMapping.Excluded := ReadBoolean(AContainer, 'Exclude', False);
  fieldMapping.PropertyType := ReadString(AContainer, 'PropertyType', '');
end;

function TSourceGeneratorOptionsXmlReader.ReadString(ANode: IXmlNode; AKey,
  ADefaultValue: string): string;
var
  SectionNode: IXmlNode;
begin
  if ANode = nil then
    Exit(ADefaultValue);

  if ANode.HasAttribute(AKey) then
    Exit(VarToStr(ANode.Attributes[AKey]));
  SectionNode := ANode.ChildNodes.FindNode(AKey);
  if SectionNode <> nil then
    Exit(SectionNode.Text);
  Exit(ADefaultValue);
end;

procedure TSourceGeneratorOptionsXmlReader.ReadTableMapping(
  AContainer: IXmlNode);
var
  fieldsNode: IXmlNode;
  c: Integer;
  tableMapping: TTableMapping;
  tableId: integer;
begin
  if not AContainer.HasAttribute('TableId') then Exit;
  tableid := AContainer.Attributes['TableId'];
  tableMapping := TTableMapping.Create;
  FOptions.Tables.AddOrSetValue(tableId, tableMapping);

  tableMapping.EntityClassName := ReadString(AContainer, 'ClassName', '');
  tableMapping.SequenceName := ReadString(AContainer, 'Sequence', '');
  tableMapping.DynPropContainer := ReadString(AContainer, 'DynPropContainer', '---dummy---');
  tableMapping.CustomContainer := tableMapping.DynPropContainer <> '---dummy---';
  if not tableMapping.CustomContainer then
    tableMapping.DynPropContainer := '';
  tableMapping.ModelNames := ReadString(AContainer, 'ModelNames', '');
  tableMapping.ClassUnitName := ReadString(AContainer, 'ClassUnitName', '');

  tableMapping.Excluded := ReadBoolean(AContainer, 'Exclude', False);

  fieldsNode := AContainer.ChildNodes.FindNode('Fields');
  if fieldsNode <> nil then
    for c := 0 to fieldsNode.ChildNodes.Count - 1 do
      if SameText(fieldsNode.ChildNodes[c].LocalName, 'Field') then
        ReadFieldMapping(fieldsNode.ChildNodes[c], tableMapping);
end;

function TSourceGeneratorOptionsXmlReader.StrToAssociationNameSource(
  ASource: string): TAssociationNameSource;
begin
  ASource := LowerCase(ASource);
  if ASource = 'parenttable' then
    Result := asParentTableName
  else
  if ASource = 'parenttablecaption' then
    Result := asParentTableCaption
  else
  if ASource = 'childtable' then
    Result := asChildTableName
  else
  if ASource = 'childtablecaption' then
    Result := asChildTableCaption
  else
  if ASource = 'parentfield' then
    Result := asParentFieldName
  else
  if ASource = 'parentfieldcaption' then
    Result := asParentFieldCaption
  else
  if ASource = 'childfield' then
    Result := asChildFieldName
  else
  if ASource = 'childfieldcaption' then
    Result := asChildFieldCaption
  else
    Result := asCaption;
end;

function TSourceGeneratorOptionsXmlReader.StrToNameSource(
  ASource: string): TBaseNameSource;
begin
  ASource := LowerCase(ASource);
  if ASource = 'caption' then
    Result := nsCaption
  else
    Result := nsName;
end;

end.
