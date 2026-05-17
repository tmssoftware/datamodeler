unit sqretrv;

interface

uses
  SysUtils, Classes, Variants, uSQLModule, qryretrv, dgConsts, uGDAO;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size,_Precision: integer;
  end;

  TIdentifyDefinitionRec = record
    _SeedValue : Integer;
    _IncrementValue : Integer;
  end;

  TSqlServerDataRetriever = class(TDataRetriever)
  protected
    function CheckSqlServerVersion(AVersion: integer; AEdition: string=''): boolean;
  end;

  TSqlServer2000DataRetriever = class(TSqlServerDataRetriever)
  private
    function GetFieldDefinition(ADatatype: String; ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

  TSqlServer2005DataRetriever = class(TSqlServerDataRetriever)
  private
    function GetFieldDefinition(ADatatype: String; ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

  TSqlServer2008DataRetriever = class(TSqlServerDataRetriever)
  private
    FExtendedProperties: boolean;
    function GetFieldDefinition(ADatatype: String; ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
  public
    procedure AfterConstruction; override;
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

  TSqlServer2016DataRetriever = class(TSqlServer2008DataRetriever)
  public
    function CheckDatabaseVersion: boolean; override;
  end;

  TSqlAzureDataRetriever = class(TSqlServer2008DataRetriever)
  public
    procedure AfterConstruction; override;
    function CheckDatabaseVersion: boolean; override;
  end;

implementation

function TSqlServer2008DataRetriever.CheckDatabaseVersion: boolean;
begin
  result := CheckSqlServerVersion(10);
end;

procedure TSqlServer2008DataRetriever.AfterConstruction;
begin
  inherited;
  FExtendedProperties := true;
end;

procedure TSqlServer2008DataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
var
  TablesCondition: string;

  procedure _GetDomains;
  var
    newDomain: TGDAODomain;
    extField, extJoin: string;
  begin
    ADictionary.Domains.Clear;
    if FExtendedProperties then
    begin
      extField :=
        '(CASE SQL_VARIANT_PROPERTY(e.value,''BaseType'') '#13#10+
        '  WHEN ''nvarchar'' THEN CONVERT(nvarchar(4000), e.value) ELSE CONVERT(varchar(8000), e.value) END)';
      extJoin :=
        'LEFT JOIN sys.extended_properties e ON e.class=6 and e.major_id=d.user_type_id and e.minor_id=0 and e.name=''MS_Description''';
    end
    else
    begin
      extField := '''''';
      extJoin := '';
    end;

    Module.Open(
      'select '#13#10+
      '  d.name as DOMAIN_NAME, '#13#10+
      '  SCHEMA_NAME(d.schema_id) as user_name, '#13#10+
      '  d2.name as DATA_TYPE, '#13#10+
      '  d.max_length as CHAR_LENGTH, '#13#10+
      '  convert(int,OdbcPrec(d.system_type_id,d.max_length,d.precision)) as NUMERIC_PRECISION, '#13#10+
      '  d.scale as NUMERIC_SCALE, '#13#10+
      '  d.is_nullable as nulls, '#13#10+
      '  d.collation_name as collation, '#13#10+
      '  sod.name as default_name, '#13#10+
      '  SCHEMA_NAME(sod.schema_id) as default_schema, '#13#10+
      '  sor.name as rule_name, '#13#10+
      '  SCHEMA_NAME(sor.schema_id) as rule_schema, '#13#10+
      extField + ' as description '#13#10+
      'from sys.types d LEFT JOIN sys.objects sod ON sod.type=''D'' and sod.object_id=d.default_object_id '#13#10+
      '                 LEFT JOIN sys.objects sor ON sor.type=''R'' and sor.object_id=d.rule_object_id '#13#10+
      extJoin + ', '#13#10+
      'sys.types d2 '#13#10+
      'where d.is_user_defined=1 and d.is_assembly_type=0 '#13#10+
      'and d.system_type_id=d2.user_type_id '#13#10+
      'order by SCHEMA_NAME(d.schema_id), d.name');
    while not Module.EOF do
    begin
      {Basic field information: name and required}
      newDomain := ADictionary.Domains.Add;
      newDomain.Name := Module.FieldAsString('DOMAIN_NAME');
      newDomain.InDatabase := true;

      {init default datatype and size values}
      newDomain.DataType := nil;
      newDomain.Size := 0;
      newDomain.Size2 := 0;
      //newDomain.Required := (Module.FieldAs('DOMAIN_NULL_FLAG') = 1);

      {default value}
      //newDomain.DefaultValue := ExtractFBDefaultValue(Module.FieldAs('DOMAIN_DEFAULT').AsString);
      //newDomain.ConstraintExpr := ExtractFBCheckExpression(Module.FieldAs('DOMAIN_CHECK').AsString);

      {In SQL Server, domains are not computed}
      if false {Module.FieldAs('COMPUTED_SOURCE').AsString <> ''} then
      begin
        newDomain.DataTypeName := 'computed';
        //newDomain.Expression := Module.FieldAs('COMPUTED_SOURCE').AsString;
      end
      else
      begin
        with GetFieldDefinition(
          Module.FieldAsString('DATA_TYPE'),
          Module.FieldAsInteger('CHAR_LENGTH'),
          Module.FieldAsInteger('NUMERIC_PRECISION'),
          Module.FieldAsInteger('NUMERIC_SCALE')) do
        begin
          newDomain.DataTypeName := _DataTypeName;
          newDomain.Size         := _Size;
          newDomain.Size2        := _Precision;
        end;
      end;
      Module.Next;
    end;
  end;

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;

    if FExtendedProperties then
      Module.Open(
        'SELECT t.name as TABLE_NAME '+
        'FROM sys.tables t '+
        'LEFT OUTER JOIN sys.extended_properties ep '+
        '  ON t.object_id = ep.major_id '+
        '     AND ep.class_desc = ''OBJECT_OR_COLUMN'' '+
        '     AND ep.name = ''microsoft_database_tools_support'' '+
        'WHERE '+
        '  t.is_ms_shipped = 0 AND ep.major_id IS NULL '+
        'ORDER BY t.name')
    else
      Module.Open(
        'SELECT t.name as TABLE_NAME '+
        'FROM sys.tables t '+
        'WHERE t.is_ms_shipped = 0 '+
        'ORDER BY t.name');
    while not Module.EOF do
    begin
      ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME'));
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    ATable: TGDAOTable;
    newField: TGDAOField;
    extField, extJoin: string;
  begin
    if FExtendedProperties then
    begin
      extField :=
        '(CASE SQL_VARIANT_PROPERTY(e.value,''BaseType'') '#13#10+
        '  WHEN ''nvarchar'' THEN CONVERT(nvarchar(4000), e.value) ELSE CONVERT(varchar(8000), e.value) END)';
      extJoin :=
        'LEFT JOIN sys.extended_properties e ON e.class=1 and e.major_id=c.object_id and e.minor_id=c.column_id and e.name=''MS_Description'''
    end
    else
    begin
      extField := '''''';
      extJoin := '';
    end;

    Module.Open( Format(
      'select t.name as TABLE_NAME, '#13#10+
      'SCHEMA_NAME(t.schema_id) as TABLE_OWNER, '#13#10+
      'c.name as COLUMN_NAME, '#13#10+
      'c.user_type_id, '#13#10+
      'd.name as DATA_TYPE, '#13#10+
      'schema_name(d.schema_id) as type_schema, '#13#10+
      'd.is_user_defined as IS_DOMAIN, '#13#10+
      'c.max_length as CHAR_LENGTH, '#13#10+
      'convert(int,OdbcPrec(c.system_type_id,c.max_length,c.precision)) as NUMERIC_PRECISION, '#13#10+
      'c.scale as NUMERIC_SCALE, '#13#10+
      'c.collation_name as collation, '#13#10+
      'c.is_nullable as IS_NULLABLE, '#13#10+
      'c.is_ansi_padded, '#13#10+
      'c.is_rowguidcol, '#13#10+
      'c.is_identity as IS_IDENTITY, '#13#10+
      'c.is_computed AS IS_COMPUTED, '#13#10+
      'c.is_filestream, '#13#10+
      'c.is_replicated, '#13#10+
      'c.is_xml_document, '#13#10+
      'c.xml_collection_id, '#13#10+
      'SCHEMA_NAME(x.schema_id) as xml_schema, '#13#10+
      'x.name as xml_schema_coll_name, '#13#10+
      'sod.name as default_name, '#13#10+
      'SCHEMA_NAME(sod.schema_id) as default_schema, '#13#10+
      'def.name as default_col_name, '#13#10+
      'def.definition as COLUMN_DEFAULT, '#13#10+
      'def.is_system_named, '#13#10+
      'sor.name as rule_name, '#13#10+
      'SCHEMA_NAME(sor.schema_id) as rule_schema, '#13#10+
      'cc.definition as COMPUTED_EXPRESSION, '#13#10+
      'cc.is_persisted, '#13#10+
      'cc.uses_database_collation, '#13#10+
      extField + ' as description, '#13#10+
      'd.is_assembly_type, '#13#10+
      'convert(int, id.seed_value) as IDENTITY_SEED, '#13#10+
      'convert(int, id.increment_value) as IDENTITY_INCREMENT, '#13#10+
      'id.is_not_for_replication as IDENTITY_NOT_REPL '#13#10+
      'from sys.columns c LEFT JOIN sys.computed_columns cc ON c.object_id=cc.object_id and c.column_id=cc.column_id '#13#10+
      '        LEFT JOIN sys.xml_schema_collections x ON c.xml_collection_id=x.xml_collection_id '#13#10+
      extJoin + #13#10+
      '        LEFT JOIN sys.objects sod ON sod.type=''D'' and sod.object_id=c.default_object_id and sod.parent_object_id=0 '#13#10+
      '        LEFT JOIN sys.default_constraints def ON def.object_id=c.default_object_id and def.parent_column_id=c.column_id '#13#10+
      '        LEFT JOIN sys.objects sor ON sor.type=''R'' and sor.object_id=c.rule_object_id and sor.parent_object_id=0 '#13#10+
      '        LEFT JOIN sys.identity_columns id ON id.object_id=c.object_id and id.column_id=c.column_id, '#13#10+
      'sys.types d, sys.tables t '#13#10+
      'where c.user_type_id=d.user_type_id and c.object_id=t.object_id '#13#10+
      'order by SCHEMA_NAME(t.schema_id), t.name, c.column_id'
      ,
      [TablesCondition]));
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        {Basic field information: name and required}
        newField := ATable.Fields.Add(
          Module.FieldAsString('COLUMN_NAME'), nil, 0, 0,
          not Module.FieldAsBoolean('IS_NULLABLE'));

        {default value}
        newField.DefaultValue := Module.FieldAsString('COLUMN_DEFAULT');

        {if data type is a domain, then just set the domain. Otherwise, retrieve
        the data type manually}
        if
          (Module.FieldAsBoolean('IS_DOMAIN')) and
          (ADictionary.Domains.FindByName(Module.FieldAsString('DATA_TYPE')) <> nil) then
        begin
          if newField.DefaultValue <> '' then
            newField.DefaultValueSpecific := true;

          newField.DomainName := Module.FieldAsString('DATA_TYPE');
        end else
        begin
          {Check if field is computed, otherwise retrieve regular data type
           size, precision and scale}
          if Module.FieldAsBoolean('IS_COMPUTED') then
          begin
            newField.DataTypeName := 'computed';
            newField.Expression := Module.FieldAsString('COMPUTED_EXPRESSION');
          end
          else
          begin
            with GetFieldDefinition(
              Module.FieldAsString('DATA_TYPE'),
              Module.FieldAsInteger('CHAR_LENGTH'),
              Module.FieldAsInteger('NUMERIC_PRECISION'),
              Module.FieldAsInteger('NUMERIC_SCALE')) do
            begin
              newField.DataTypeName := _DataTypeName;
              newField.Size         := _Size;
              newField.Size2        := _Precision;
            end;
          end;
        end;

        {identity information}
        if Module.FieldAsBoolean('IS_IDENTITY') then
        begin
          newField.DataTypeName := newField.DataTypeName + ' (identity)';
          newField.SeedValue := Module.FieldAsInteger('IDENTITY_SEED');
          newField.IncrementValue := Module.FieldAsInteger('IDENTITY_INCREMENT');
        end;

        {description}
        newField.FieldCaption := Module.FieldAsString('DESCRIPTION');
      end;
      Module.Next;
    end;
  end;

  procedure _GetPrimaryKeys;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
  begin
    Module.Open( 'SELECT kcu.TABLE_NAME, kcu.CONSTRAINT_NAME, kcu.COLUMN_NAME, kcu.ORDINAL_POSITION '+
      'FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc '+
      'INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu '+
      'ON kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA '+
      'AND kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME '+
      'AND kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA '+
      'AND kcu.TABLE_NAME = tc.TABLE_NAME '+
      'WHERE tc.CONSTRAINT_TYPE = ''PRIMARY KEY'' '+
      //' OR tc.CONSTRAINT_TYPE = ''UNIQUE'' '+
      'ORDER BY kcu.TABLE_NAME, tc.CONSTRAINT_TYPE, kcu.CONSTRAINT_NAME, kcu.ORDINAL_POSITION');
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      AField := nil;
      if ATable <> nil then
        AField := ATable.FieldByName(Module.FieldAsString('COLUMN_NAME'));

      if (ATable <> nil) and (AField <> nil) then
      begin
        ATable.PrimaryKeyIndex.IndexName := Module.FieldAsString('CONSTRAINT_NAME');
        ATable.PrimaryKeyIndex.IFields.Add.Field := AField;
      end;

      Module.Next;
    end;
  end;

  procedure _GetTriggers;
  var
    ATable: TGDAOTable;
    newTrigger: TGDAOTrigger;
  begin
    if FExtendedProperties then
      Module.Open(
        'SELECT s2.name as TABLE_NAME, s1.name as TRIGGER_NAME, c.text as TRIGGER_BODY '+
        'FROM sysobjects s1 '+
        'LEFT JOIN sysobjects s2 on s1.parent_obj=s2.id '+
        'LEFT JOIN syscomments c on s1.id=c.id '+
        'where s1.xtype = ''TR'' '+
        'order by s2.id')
    else
      Module.Open(
        'SELECT tb.name as TABLE_NAME, tr.name as TRIGGER_NAME, sm.definition as TRIGGER_BODY '+
        'FROM sys.triggers tr '+
        'LEFT JOIN sysobjects tb on tr.parent_id=tb.id '+
        'LEFT JOIN sys.sql_modules sm on tr.object_id=sm.object_id '+
        'order by tb.id');
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        newTrigger := ATable.Triggers.Add;
        newTrigger.Name := Module.FieldAsString('TRIGGER_NAME');
        newTrigger.ImplementationCode := Trim(Module.FieldAsString('TRIGGER_BODY'));
      end;
      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    ATable: TGDAOTable;
  begin
    Module.Open(
      'SELECT TC.TABLE_NAME, CC.CONSTRAINT_NAME, CC.CHECK_CLAUSE '+
      'FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS CC '+
      'INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC '+
      'ON CC.CONSTRAINT_NAME = TC.CONSTRAINT_NAME '+
      'ORDER BY TC.TABLE_NAME, CC.CONSTRAINT_NAME');

    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        ATable.Constraints.AddConstraint(
          Module.FieldAsString('CONSTRAINT_NAME'),
          Module.FieldAsString('CHECK_CLAUSE'));
      end;
      Module.Next;
    end;
  end;

  procedure _GetRelationships;
  var
    ARelationship: TGDAORelationship;
    S: string;
  begin
    Module.Open(
      'SELECT '+
      '  O1.name AS PK_TABLE_NAME, '+
      '   C1.name AS PK_COLUMN_NAME, '+
      '   O2.name AS FK_TABLE_NAME, '+
      '   C2.name AS FK_COLUMN_NAME, '+
      '   F.name AS CONSTRAINT_NAME, '+
      '   F.delete_referential_action_desc AS DELETE_RULE, '+
      '   F.update_referential_action_desc AS UPDATE_RULE '+
      ' FROM   sys.all_objects O1, '+
      '   sys.all_objects O2, '+
      '   sys.all_columns C1, '+
      '   sys.all_columns C2, '+
      '   sys.foreign_keys F '+
      '   INNER JOIN sys.foreign_key_columns K '+
      '     ON (K.constraint_object_id = F.object_id) '+
      ' WHERE  O1.object_id = F.referenced_object_id '+
      '   AND O2.object_id = F.parent_object_id '+
      '   AND C1.object_id = F.referenced_object_id '+
      '   AND C2.object_id = F.parent_object_id '+
      '   AND C1.column_id = K.referenced_column_id '+
      '   AND C2.column_id = K.parent_column_id '+
      '   AND K.constraint_object_id = F.object_id '+
      ' ORDER BY F.name, K.constraint_column_id');
    while not Module.EOF do
    begin
      ARelationship := ADictionary.RelationshipByName(Module.FieldAsString('CONSTRAINT_NAME'));
      if ARelationship = nil then
        ARelationship := ADictionary.Relationships.Add(Module.FieldAsString('CONSTRAINT_NAME'),
          '', '', umRestrict, dmRestrict);

      ARelationship.ParentTableName := Module.FieldAsString('PK_TABLE_NAME');
      ARelationship.ChildTableName := Module.FieldAsString('FK_TABLE_NAME');
      with ARelationship.FieldLinks.Add do
      begin
        ParentFieldName := Module.FieldAsString('PK_COLUMN_NAME');
        ChildFieldName := Module.FieldAsString('FK_COLUMN_NAME');
      end;

      {Set update rule}
      S := Module.FieldAsString('UPDATE_RULE');
      if S = 'CASCADE' then
        ARelationship.UpdateMethod := umCascade
      else
      if S = 'SET_NULL' then
        ARelationship.UpdateMethod := umSetNull
      else
      if S = 'SET_DEFAULT' then
        ARelationship.UpdateMethod := umSetDefault
      else
        ARelationship.UpdateMethod := umRestrict;

      {Set delete rule}
      S := Module.FieldAsString('DELETE_RULE');
      if S = 'CASCADE' then
        ARelationship.DeleteMethod := dmCascade
      else
      if S = 'SET_NULL' then
        ARelationship.DeleteMethod := dmSetNull
      else
      if S = 'SET_DEFAULT' then
        ARelationship.DeleteMethod := dmSetDefault
      else
        ARelationship.DeleteMethod := dmRestrict;

      Module.Next;
    end;
  end;

  procedure _GetViews;
  var
    AView: TGDAOObject;
    AViews: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctView) <> nil then
    begin
      AViews := ADictionary.Categories.FindByType(ctView).Objects;
      AViews.Clear;
      Module.Open(
//        'SELECT TABLE_NAME, VIEW_DEFINITION '+
//        'FROM INFORMATION_SCHEMA.VIEWS '+
//        'ORDER BY TABLE_NAME'

        'SELECT ' +
        ' name  AS TABLE_NAME, ' +
        ' OBJECT_DEFINITION(object_id)  AS VIEW_DEFINITION ' +
        'FROM ' +
        ' sys.views ' +
        'ORDER BY name'
      );



      while not Module.EOF do
      begin
        AView := AViews.Add(Module.FieldAsString('TABLE_NAME'));
        AView.DropImplementation := AView.OwnerCategory.DropTemplate;
        AView.CreateImplementation := Trim(Module.FieldAsString('VIEW_DEFINITION'));
        Module.Next;
      end;
    end;
  end;

  procedure _GetProcedures;
  var
    AProcedure: TGDAOObject;
    AProcedures: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctProcedure) <> nil then
    begin
      AProcedures := ADictionary.Categories.FindByType(ctProcedure).Objects;
      AProcedures.Clear;
      if FExtendedProperties then
        Module.Open(
          'select p.name as ROUTINE_NAME, OBJECT_DEFINITION(p.object_id) as ROUTINE_IMPLEMENTATION '+
          'from sys.procedures p '+
          '      LEFT OUTER JOIN sys.extended_properties ep '+
          '  ON p.object_id = ep.major_id '+
          '     AND ep.class_desc = ''OBJECT_OR_COLUMN'' '+
          '     AND ep.name = ''microsoft_database_tools_support'' '+
          'where (p.type=''P'' or p.type=''X'' or p.type=''RF'') '+
          '  AND ep.major_id IS NULL '+
          'order by p.object_id')
      else
        Module.Open(
          'select p.name as ROUTINE_NAME, OBJECT_DEFINITION(p.object_id) as ROUTINE_IMPLEMENTATION '+
          'from sys.procedures p '+
          'where (p.type=''P'' or p.type=''X'' or p.type=''RF'') '+
          'order by p.object_id');
      while not Module.EOF do
      begin
        AProcedure := AProcedures.Add(Module.FieldAsString('ROUTINE_NAME'));
        AProcedure.DropImplementation := AProcedure.OwnerCategory.DropTemplate;
        AProcedure.CreateImplementation := Trim(Module.FieldAsString('ROUTINE_IMPLEMENTATION'));
        Module.Next;
      end;
    end;
  end;

  procedure _GetIndexes;
  var
    AIndex: TGDAOIndex;
    ATable: TGDAOTable;
    t: integer;
  begin
    for t := 0 to ADictionary.Tables.Count - 1 do
      ADictionary.Tables[t].Indexes.Clear;

    ATable := nil;
    AIndex := nil;
    if FExtendedProperties then
      Module.Open(
        'SELECT t.name as TABLE_NAME, i.name as INDEX_NAME, f.name as COLUMN_NAME, '+
        'INDEXKEY_PROPERTY( t.id, i.indid, ik.keyno, ''IsDescending'') as INDEX_ISDESC, '+
        'INDEXPROPERTY(i.id, i.name, ''IsUnique'') as INDEX_ISUNIQUE '+
        'FROM ((sysindexes i inner join sysobjects t ON i.id = t.id) '+
        'INNER JOIN sysindexkeys ik ON i.indid = ik.indid) '+
        'INNER JOIN syscolumns f ON ik.colid = f.colid '+
        'WHERE t.xType = ''U'' AND f.id = t.id AND ik.id = t.id AND '+
        '(i.status & 2048 = 0) AND ((i.status = 0) or (i.status & 2 = 2) or (i.status & 4096 = 4096)) '+
        'ORDER BY t.name, i.name, ik.keyno')
    else
      Module.Open(
        'SELECT t.name as TABLE_NAME, i.name as INDEX_NAME, f.name as COLUMN_NAME, '+
        'convert(int, ik.is_descending_key) as INDEX_ISDESC, '+
        'convert(int, i.is_unique) as INDEX_ISUNIQUE '+
        'FROM ((sys.indexes i inner join sysobjects t ON i.object_id = t.id) '+
        'INNER JOIN sys.index_columns ik ON i.index_id = ik.index_id) '+
        'INNER JOIN syscolumns f ON ik.column_id = f.colid '+
        'WHERE t.xType = ''U'' AND i.is_primary_key = 0 AND f.id = t.id AND ik.object_id = t.id '+
        'ORDER BY t.name, i.name, ik.key_ordinal');
    while not Module.Eof do
    begin
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
        AIndex := nil;
      end;

      if (ATable <> nil) then
      begin
        if (AIndex = nil) or
          not SameText(AIndex.IndexName, Module.FieldAsString('INDEX_NAME')) then
        begin
          AIndex := ATable.Indexes.Add(Module.FieldAsString('INDEX_NAME'));
        end;

        if AIndex <> nil then
        begin
          if Module.FieldAsInteger('INDEX_ISUNIQUE') <> 0 then
            AIndex.IndexType := itUnique;
          AIndex.IFields.Add(Module.FieldAsString('COLUMN_NAME')).FieldOrder :=
            TIndexFieldOrder(Module.FieldAsInteger('INDEX_ISDESC'));
        end;
      end;
      
      Module.Next;
    end;
  end;

  procedure _UpdateDefaultConstraintNames;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
  begin
    if FExtendedProperties then
      Module.Open(
        'SELECT st.name as TABLE_NAME, sf.name as COLUMN_NAME, sd.name AS CONSTRAINT_NAME '+
        'FROM sysconstraints sc '+
        'INNER JOIN sysobjects sd ON sc.constid = sd.id '+
        'INNER JOIN sysobjects st ON sc.id = st.id '+
        'INNER JOIN syscolumns sf ON (sc.colid = sf.colid) and (sc.id = sf.id) '+
        'WHERE sd.xtype = ''D'' '+
        'ORDER BY st.name, sf.name')
    else
      Module.Open(
        'SELECT st.name as TABLE_NAME, sf.name as COLUMN_NAME, sd.name AS CONSTRAINT_NAME '+
        'FROM sys.default_constraints sc '+
        'INNER JOIN sysobjects sd ON sc.object_id = sd.id '+
        'INNER JOIN sysobjects st ON sc.parent_object_id = st.id '+
        'INNER JOIN syscolumns sf ON (sc.parent_column_id = sf.colid) and (sc.parent_object_id = sf.id) '+
        'ORDER BY st.name, sf.name');
    while not Module.EOF do
    begin
      ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      if ATable <> nil then
      begin
        AField := ATable.FieldByName(Module.FieldAsString('COLUMN_NAME'));
        if AField <> nil then
        begin
          if AField.DefaultValue <> '' then
            AField.ConstraintDefaultName := Module.FieldAsString('CONSTRAINT_NAME');
        end;
      end;
      Module.Next;
    end;
  end;

begin
  {TablesCondition might have a filter for tables. Example:
   "SO.name in ('blobs', 'labels')"}
  TablesCondition := '0=0';
  SetMaxProgress(1000);
  SetProgressPos(0);

  _GetDomains;
  SetProgressPos(50);

  _GetTables;
  SetProgressPos(100);

  _GetFieldList;
  SetProgressPos(200);

  _GetPrimaryKeys;
  SetProgressPos(300);

  _GetTriggers;
  SetProgressPos(400);

  _GetConstraints;
  SetProgressPos(500);

  _GetIndexes;
  SetProgressPos(600);

  _GetRelationships;
  SetProgressPos(700);

  _GetViews;
  SetProgressPos(800);

  _GetProcedures;
  SetProgressPos(900);

  _UpdateDefaultConstraintNames;
  SetProgressPos(1000);
end;

function TSqlServer2008DataRetriever.GetFieldDefinition(ADatatype: String;
  ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
const vNoSizeTypes : array[0..22] of string =
            ('bigint', 'bit', 'date', 'datetime', 'float', 'image', 'int', 'money', 'ntext',
            'real', 'smalldatetime', 'smallint', 'smallmoney', 'sql_variant',
            'sysname', 'text', 'timestamp', 'tinyint', 'uniqueidentifier', 'xml',
            'geometry', 'hierarchyid', 'geography');

  function IsNoSizeDataType: Boolean;
  var i : Integer;
  begin
    Result := false;
    for i := 0 to high(vNoSizeTypes) do
      if vNoSizeTypes[i] = AdataType then
      begin
        Result := true;
        break;
      end;
  end;

begin
  with Result do
  begin
    _DataTypeName := ADataType;
    _Size         := 0;
    _Precision    := 0;
  end;
  ADatatype := lowercase(ADataType);
  if not IsNoSizeDataType then
  begin
    if (ASize = -1) and (
      (ADatatype = 'nvarchar') or
      (ADatatype = 'varbinary') or
      (ADatatype = 'varchar')
      ) then
    begin
      result._DataTypeName := result._DataTypeName + '(MAX)';
    end
    else
    if (ADataType='decimal') or (ADataType='numeric') or
       (ADataType='nchar') or (ADataType='nvarchar') then
    begin
      with Result do
      begin
        _Size      := APrecision;
        _Precision := AScale;
      end;
    end else
    if (ADataType = 'datetime2') or (ADataType = 'datetimeoffset') or
       (ADataType = 'time') then
    begin
      Result._Size := AScale;
    end else
      Result._Size := ASize;
  end;
end;

{ TSqlServerDataRetriever }

function TSqlServer2005DataRetriever.CheckDatabaseVersion: boolean;
begin
  result := CheckSqlServerVersion(9);
end;

procedure TSqlServer2005DataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
var
  TablesCondition: string;

  procedure _GetDomains;
  var
    newDomain: TGDAODomain;
  begin
    ADictionary.Domains.Clear;
    Module.Open(
     'select '#13#10+
      '  d.name as DOMAIN_NAME, '#13#10+
      '  SCHEMA_NAME(d.schema_id) as user_name, '#13#10+
      '  d2.name as DATA_TYPE, '#13#10+
      '  d.max_length as CHAR_LENGTH, '#13#10+
      '  convert(int,OdbcPrec(d.system_type_id,d.max_length,d.precision)) as NUMERIC_PRECISION, '#13#10+
      '  d.scale as NUMERIC_SCALE, '#13#10+
      '  d.is_nullable as nulls, '#13#10+
      '  d.collation_name as collation, '#13#10+
      '  sod.name as default_name, '#13#10+
      '  SCHEMA_NAME(sod.schema_id) as default_schema, '#13#10+
      '  sor.name as rule_name, '#13#10+
      '  SCHEMA_NAME(sor.schema_id) as rule_schema, '#13#10+
      '(CASE SQL_VARIANT_PROPERTY(e.value,''BaseType'') '#13#10+
      '    WHEN ''nvarchar'' THEN CONVERT(nvarchar(4000), e.value) ELSE CONVERT(varchar(8000), e.value) END) as description '#13#10+
      'from sys.types d LEFT JOIN sys.objects sod ON sod.type=''D'' and sod.object_id=d.default_object_id '#13#10+
      '                 LEFT JOIN sys.objects sor ON sor.type=''R'' and sor.object_id=d.rule_object_id '#13#10+
      '                 LEFT JOIN sys.extended_properties e ON e.class=6 and e.major_id=d.user_type_id and e.minor_id=0 and e.name=''MS_Description'', '#13#10+
      'sys.types d2 '#13#10+
      'where d.is_user_defined=1 and d.is_assembly_type=0 '#13#10+
      'and d.system_type_id=d2.user_type_id '#13#10+
      'order by SCHEMA_NAME(d.schema_id), d.name');
    while not Module.EOF do
    begin
      {Basic field information: name and required}
      newDomain := ADictionary.Domains.Add;
      newDomain.Name := Module.FieldAsString('DOMAIN_NAME');
      newDomain.InDatabase := true;

      {init default datatype and size values}
      newDomain.DataType := nil;
      newDomain.Size := 0;
      newDomain.Size2 := 0;
      //newDomain.Required := (Module.FieldAs('DOMAIN_NULL_FLAG') = 1);

      {default value}
      //newDomain.DefaultValue := ExtractFBDefaultValue(Module.FieldAs('DOMAIN_DEFAULT'));
      //newDomain.ConstraintExpr := ExtractFBCheckExpression(Module.FieldAs('DOMAIN_CHECK'));

      {In SQL Server, domains are not computed}
      if false {Module.FieldAs('COMPUTED_SOURCE') <> ''} then
      begin
        newDomain.DataTypeName := 'computed';
        //newDomain.Expression := Module.FieldAs('COMPUTED_SOURCE');
      end
      else
      begin
        with GetFieldDefinition(
          Module.FieldAsString('DATA_TYPE'),
          Module.FieldAsInteger('CHAR_LENGTH'),
          Module.FieldAsInteger('NUMERIC_PRECISION'),
          Module.FieldAsInteger('NUMERIC_SCALE')) do
        begin
          newDomain.DataTypeName := _DataTypeName;
          newDomain.Size         := _Size;
          newDomain.Size2        := _Precision;
        end;
      end;
      Module.Next;
    end;
  end;

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open(
      'SELECT t.name as TABLE_NAME '+
      'FROM sys.tables t '+
      'LEFT OUTER JOIN sys.extended_properties ep '+
      '  ON t.object_id = ep.major_id '+
      '     AND ep.class_desc = ''OBJECT_OR_COLUMN'' '+
      '     AND ep.name = ''microsoft_database_tools_support'' '+
      'WHERE '+
      '  t.is_ms_shipped = 0 AND ep.major_id IS NULL '+
      'ORDER BY t.name');
    while not Module.EOF do
    begin
      ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME'));
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    ATable: TGDAOTable;
    newField: TGDAOField;
  begin
    Module.Open( Format(
      'select t.name as TABLE_NAME, '#13#10+
      'SCHEMA_NAME(t.schema_id) as TABLE_OWNER, '#13#10+
      'c.name as COLUMN_NAME, '#13#10+
      'c.user_type_id, '#13#10+
      'd.name as DATA_TYPE, '#13#10+
      'schema_name(d.schema_id) as type_schema, '#13#10+
      'd.is_user_defined as IS_DOMAIN, '#13#10+
      'c.max_length as CHAR_LENGTH, '#13#10+
      'convert(int,OdbcPrec(c.system_type_id,c.max_length,c.precision)) as NUMERIC_PRECISION, '#13#10+
      'c.scale as NUMERIC_SCALE, '#13#10+
      'c.collation_name as collation, '#13#10+
      'c.is_nullable as IS_NULLABLE, '#13#10+
      'c.is_ansi_padded, '#13#10+
      'c.is_rowguidcol, '#13#10+
      'c.is_identity as IS_IDENTITY, '#13#10+
      'c.is_computed AS IS_COMPUTED, '#13#10+
      'c.is_filestream, '#13#10+
      'c.is_replicated, '#13#10+
      'c.is_xml_document, '#13#10+
      'c.xml_collection_id, '#13#10+
      'SCHEMA_NAME(x.schema_id) as xml_schema, '#13#10+
      'x.name as xml_schema_coll_name, '#13#10+
      'sod.name as default_name, '#13#10+
      'SCHEMA_NAME(sod.schema_id) as default_schema, '#13#10+
      'def.name as default_col_name, '#13#10+
      'def.definition as COLUMN_DEFAULT, '#13#10+
      'def.is_system_named, '#13#10+
      'sor.name as rule_name, '#13#10+
      'SCHEMA_NAME(sor.schema_id) as rule_schema, '#13#10+
      'cc.definition as COMPUTED_EXPRESSION, '#13#10+
      'cc.is_persisted, '#13#10+
      'cc.uses_database_collation, '#13#10+
      '(CASE SQL_VARIANT_PROPERTY(e.value,''BaseType'') '#13#10+
      '    WHEN ''nvarchar'' THEN CONVERT(nvarchar(4000), e.value) ELSE CONVERT(varchar(8000), e.value) END) as description, '#13#10+
      'd.is_assembly_type, '#13#10+
      'convert(int, id.seed_value) as IDENTITY_SEED, '#13#10+
      'convert(int, id.increment_value) as IDENTITY_INCREMENT, '#13#10+
      'id.is_not_for_replication as IDENTITY_NOT_REPL '#13#10+
      'from sys.columns c LEFT JOIN sys.computed_columns cc ON c.object_id=cc.object_id and c.column_id=cc.column_id '#13#10+
      '        LEFT JOIN sys.xml_schema_collections x ON c.xml_collection_id=x.xml_collection_id '#13#10+
      '        LEFT JOIN sys.extended_properties e ON e.class=1 and e.major_id=c.object_id and e.minor_id=c.column_id and e.name=''MS_Description'' '#13#10+
      '        LEFT JOIN sys.objects sod ON sod.type=''D'' and sod.object_id=c.default_object_id and sod.parent_object_id=0 '#13#10+
      '        LEFT JOIN sys.default_constraints def ON def.object_id=c.default_object_id and def.parent_column_id=c.column_id '#13#10+
      '        LEFT JOIN sys.objects sor ON sor.type=''R'' and sor.object_id=c.rule_object_id and sor.parent_object_id=0 '#13#10+
      '        LEFT JOIN sys.identity_columns id ON id.object_id=c.object_id and id.column_id=c.column_id, '#13#10+
      'sys.types d, sys.tables t '#13#10+
      'where c.user_type_id=d.user_type_id and c.object_id=t.object_id '#13#10+
      'order by SCHEMA_NAME(t.schema_id), t.name, c.column_id'
      ,
      [TablesCondition]));
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        {Basic field information: name and required}
        newField := ATable.Fields.Add(
          Module.FieldAsString('COLUMN_NAME'), nil, 0, 0,
          not Module.FieldAsBoolean('IS_NULLABLE'));

        {default value}
        newField.DefaultValue := Module.FieldAsString('COLUMN_DEFAULT');

        {if data type is a domain, then just set the domain. Otherwise, retrieve
        the data type manually}
        if
          (Module.FieldAsBoolean('IS_DOMAIN')) and
          (ADictionary.Domains.FindByName(Module.FieldAsString('DATA_TYPE')) <> nil) then
        begin
          if newField.DefaultValue <> '' then
            newField.DefaultValueSpecific := true;

          newField.DomainName := Module.FieldAsString('DATA_TYPE');
        end else
        begin
          {Check if field is computed, otherwise retrieve regular data type
           size, precision and scale}
          if Module.FieldAsBoolean('IS_COMPUTED') then
          begin
            newField.DataTypeName := 'computed';
            newField.Expression := Module.FieldAsString('COMPUTED_EXPRESSION');
          end
          else
          begin
            with GetFieldDefinition(
              Module.FieldAsString('DATA_TYPE'),
              Module.FieldAsInteger('CHAR_LENGTH'),
              Module.FieldAsInteger('NUMERIC_PRECISION'),
              Module.FieldAsInteger('NUMERIC_SCALE')) do
            begin
              newField.DataTypeName := _DataTypeName;
              newField.Size         := _Size;
              newField.Size2        := _Precision;
            end;
          end;
        end;

       {identity information}
       if Module.FieldAsBoolean('IS_IDENTITY') then
       begin
         newField.DataTypeName := newField.DataTypeName + ' (identity)';
         newField.SeedValue := Module.FieldAsInteger('IDENTITY_SEED');
         newField.IncrementValue := Module.FieldAsInteger('IDENTITY_INCREMENT');
       end;

      end;
      Module.Next;
    end;
  end;

  procedure _GetPrimaryKeys;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
  begin
    Module.Open( 'SELECT kcu.TABLE_NAME, kcu.CONSTRAINT_NAME, kcu.COLUMN_NAME, kcu.ORDINAL_POSITION '+
      'FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc '+
      'INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu '+
      'ON kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA '+
      'AND kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME '+
      'AND kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA '+
      'AND kcu.TABLE_NAME = tc.TABLE_NAME '+
      'WHERE tc.CONSTRAINT_TYPE = ''PRIMARY KEY'' '+
      //' OR tc.CONSTRAINT_TYPE = ''UNIQUE'' '+
      'ORDER BY kcu.TABLE_NAME, tc.CONSTRAINT_TYPE, kcu.CONSTRAINT_NAME, kcu.ORDINAL_POSITION');
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      AField := nil;
      if ATable <> nil then
        AField := ATable.FieldByName(Module.FieldAsString('COLUMN_NAME'));

      if (ATable <> nil) and (AField <> nil) then
      begin
        ATable.PrimaryKeyIndex.IndexName := Module.FieldAsString('CONSTRAINT_NAME');
        ATable.PrimaryKeyIndex.IFields.Add.Field := AField;
      end;

      Module.Next;
    end;
  end;

  procedure _GetTriggers;
  var
    ATable: TGDAOTable;
    newTrigger: TGDAOTrigger;
  begin
    Module.Open(
      'SELECT s2.name as TABLE_NAME, s1.name as TRIGGER_NAME, c.text as TRIGGER_BODY '+
      'FROM sysobjects s1 '+
      'LEFT JOIN sysobjects s2 on s1.parent_obj=s2.id '+
      'LEFT JOIN syscomments c on s1.id=c.id '+
      'where s1.xtype = ''TR'' '+
      'order by s2.name');
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        newTrigger := ATable.Triggers.Add;
        newTrigger.Name := Module.FieldAsString('TRIGGER_NAME');
        newTrigger.ImplementationCode := Module.FieldAsString('TRIGGER_BODY');
      end;
      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    ATable: TGDAOTable;
  begin
    Module.Open(
      'SELECT TC.TABLE_NAME, CC.CONSTRAINT_NAME, CC.CHECK_CLAUSE '+
      'FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS CC '+
      'INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC '+
      'ON CC.CONSTRAINT_NAME = TC.CONSTRAINT_NAME '+
      'ORDER BY TC.TABLE_NAME, CC.CONSTRAINT_NAME');

    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        ATable.Constraints.AddConstraint(
          Module.FieldAsString('CONSTRAINT_NAME'),
          Module.FieldAsString('CHECK_CLAUSE'));
      end;
      Module.Next;
    end;
  end;

  procedure _GetRelationships;
  var
    ARelationship: TGDAORelationship;
    S: string;
  begin
    Module.Open(
      'SELECT '+
      '  O1.name AS PK_TABLE_NAME, '+
      '   C1.name AS PK_COLUMN_NAME, '+
      '   O2.name AS FK_TABLE_NAME, '+
      '   C2.name AS FK_COLUMN_NAME, '+
      '   F.name AS CONSTRAINT_NAME, '+
      '   F.delete_referential_action_desc AS DELETE_RULE, '+
      '   F.update_referential_action_desc AS UPDATE_RULE '+
      ' FROM   sys.all_objects O1, '+
      '   sys.all_objects O2, '+
      '   sys.all_columns C1, '+
      '   sys.all_columns C2, '+
      '   sys.foreign_keys F '+
      '   INNER JOIN sys.foreign_key_columns K '+
      '     ON (K.constraint_object_id = F.object_id) '+
      ' WHERE  O1.object_id = F.referenced_object_id '+
      '   AND O2.object_id = F.parent_object_id '+
      '   AND C1.object_id = F.referenced_object_id '+
      '   AND C2.object_id = F.parent_object_id '+
      '   AND C1.column_id = K.referenced_column_id '+
      '   AND C2.column_id = K.parent_column_id '+
      '   AND K.constraint_object_id = F.object_id '+
      ' ORDER BY F.name, K.constraint_column_id');
    while not Module.EOF do
    begin
      ARelationship := ADictionary.RelationshipByName(Module.FieldAsString('CONSTRAINT_NAME'));
      if ARelationship = nil then
        ARelationship := ADictionary.Relationships.Add(Module.FieldAsString('CONSTRAINT_NAME'),
          '', '', umRestrict, dmRestrict);

      ARelationship.ParentTableName := Module.FieldAsString('PK_TABLE_NAME');
      ARelationship.ChildTableName := Module.FieldAsString('FK_TABLE_NAME');
      with ARelationship.FieldLinks.Add do
      begin
        ParentFieldName := Module.FieldAsString('PK_COLUMN_NAME');
        ChildFieldName := Module.FieldAsString('FK_COLUMN_NAME');
      end;

      {Set update rule}
      S := Module.FieldAsString('UPDATE_RULE');
      if S = 'CASCADE' then
        ARelationship.UpdateMethod := umCascade
      else
      if S = 'SET_NULL' then
        ARelationship.UpdateMethod := umSetNull
      else
      if S = 'SET_DEFAULT' then
        ARelationship.UpdateMethod := umSetDefault
      else
        ARelationship.UpdateMethod := umRestrict;

      {Set delete rule}
      S := Module.FieldAsString('DELETE_RULE');
      if S = 'CASCADE' then
        ARelationship.DeleteMethod := dmCascade
      else
      if S = 'SET_NULL' then
        ARelationship.DeleteMethod := dmSetNull
      else
      if S = 'SET_DEFAULT' then
        ARelationship.DeleteMethod := dmSetDefault
      else
        ARelationship.DeleteMethod := dmRestrict;

      Module.Next;
    end;
  end;

  procedure _GetViews;
  var
    AView: TGDAOObject;
    AViews: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctView) <> nil then
    begin
      AViews := ADictionary.Categories.FindByType(ctView).Objects;
      AViews.Clear;
      Module.Open( 'SELECT TABLE_NAME, VIEW_DEFINITION '+
        'FROM INFORMATION_SCHEMA.VIEWS '+
        'ORDER BY TABLE_NAME');
      while not Module.EOF do
      begin
        AView := AViews.Add(Module.FieldAsString('TABLE_NAME'));
        AView.DropImplementation := AView.OwnerCategory.DropTemplate;
        AView.CreateImplementation := Module.FieldAsString('VIEW_DEFINITION');
        Module.Next;
      end;
    end;
  end;

  procedure _GetProcedures;
  var
    AProcedure: TGDAOObject;
    AProcedures: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctProcedure) <> nil then
    begin
      AProcedures := ADictionary.Categories.FindByType(ctProcedure).Objects;
      AProcedures.Clear;
      Module.Open(
        'select p.name as ROUTINE_NAME, OBJECT_DEFINITION(p.object_id) as ROUTINE_IMPLEMENTATION '+
        'from sys.procedures p '+
        '      LEFT OUTER JOIN sys.extended_properties ep '+
        '  ON p.object_id = ep.major_id '+
        '     AND ep.class_desc = ''OBJECT_OR_COLUMN'' '+
        '     AND ep.name = ''microsoft_database_tools_support'' '+
        'where (p.type=''P'' or p.type=''X'' or p.type=''RF'') '+
        '  AND ep.major_id IS NULL '+
        'order by p.name');
      while not Module.EOF do
      begin
        AProcedure := AProcedures.Add(Module.FieldAsString('ROUTINE_NAME'));
        AProcedure.DropImplementation := AProcedure.OwnerCategory.DropTemplate;
        AProcedure.CreateImplementation := Module.FieldAsString('ROUTINE_IMPLEMENTATION');
        Module.Next;
      end;
    end;
  end;

  procedure _GetIndexes;
  var
    AIndex: TGDAOIndex;
    ATable: TGDAOTable;
    t: integer;
  begin
    for t := 0 to ADictionary.Tables.Count - 1 do
      ADictionary.Tables[t].Indexes.Clear;

    ATable := nil;
    AIndex := nil;
    Module.Open(
      'SELECT t.name as TABLE_NAME, i.name as INDEX_NAME, f.name as COLUMN_NAME, '+
      'INDEXKEY_PROPERTY( t.id, i.indid, ik.keyno, ''IsDescending'') as INDEX_ISDESC, '+
      'INDEXPROPERTY(i.id, i.name, ''IsUnique'') as INDEX_ISUNIQUE '+
      'FROM ((sysindexes i inner join sysobjects t ON i.id = t.id) '+
      'INNER JOIN sysindexkeys ik ON i.indid = ik.indid) '+
      'INNER JOIN syscolumns f ON ik.colid = f.colid '+
      'WHERE t.xType = ''U'' AND f.id = t.id AND ik.id = t.id AND '+
      '(i.status & 2048 = 0) AND ((i.status = 0) or (i.status & 2 = 2) or (i.status & 4096 = 4096)) '+
      'ORDER BY t.name, i.name, ik.keyno');
    while not Module.Eof do
    begin
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
        AIndex := nil;
      end;

      if (ATable <> nil) then
      begin
        if (AIndex = nil) or
          not SameText(AIndex.IndexName, Module.FieldAsString('INDEX_NAME')) then
        begin
          AIndex := ATable.Indexes.Add(Module.FieldAsString('INDEX_NAME'));
        end;

        if AIndex <> nil then
        begin
          if Module.FieldAsInteger('INDEX_ISUNIQUE') <> 0 then
            AIndex.IndexType := itUnique;
          AIndex.IFields.Add(Module.FieldAsString('COLUMN_NAME')).FieldOrder :=
            TIndexFieldOrder(Module.FieldAsInteger('INDEX_ISDESC'));
        end;
      end;
      
      Module.Next;
    end;
  end;

  procedure _UpdateDefaultConstraintNames;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
  begin
    Module.Open(
      'SELECT st.name as TABLE_NAME, sf.name as COLUMN_NAME, sd.name AS CONSTRAINT_NAME '+
      'FROM sysconstraints sc '+
      'INNER JOIN sysobjects sd ON sc.constid = sd.id '+
      'INNER JOIN sysobjects st ON sc.id = st.id '+
      'INNER JOIN syscolumns sf ON (sc.colid = sf.colid) and (sc.id = sf.id) '+
      'WHERE sd.xtype = ''D'' '+
      'ORDER BY st.name, sf.name');
    while not Module.EOF do
    begin
      ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      if ATable <> nil then
      begin
        AField := ATable.FieldByName(Module.FieldAsString('COLUMN_NAME'));
        if AField <> nil then
        begin
          if AField.DefaultValue <> '' then
            AField.ConstraintDefaultName := Module.FieldAsString('CONSTRAINT_NAME');
        end;
      end;
      Module.Next;
    end;
  end;

begin
  {TablesCondition might have a filter for tables. Example:
   "SO.name in ('blobs', 'labels')"}
  TablesCondition := '0=0';
  SetMaxProgress(1000);
  SetProgressPos(0);

  _GetDomains;
  SetProgressPos(50);

  _GetTables;
  SetProgressPos(100);

  _GetFieldList;
  SetProgressPos(200);

  _GetPrimaryKeys;
  SetProgressPos(300);

  _GetTriggers;
  SetProgressPos(400);

  _GetConstraints;
  SetProgressPos(500);

  _GetIndexes;
  SetProgressPos(600);

  _GetRelationships;
  SetProgressPos(700);

  _GetViews;
  SetProgressPos(800);

  _GetProcedures;
  SetProgressPos(900);

  _UpdateDefaultConstraintNames;
  SetProgressPos(1000);
end;

function TSqlServer2005DataRetriever.GetFieldDefinition(ADatatype: String;
  ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
const vNoSizeTypes : array[0..18] of string =
            ('bigint', 'bit', 'datetime', 'float', 'image', 'int', 'money', 'ntext',
            'real', 'smalldatetime', 'smallint', 'smallmoney', 'sql_variant',
            'sysname', 'text', 'timestamp', 'tinyint', 'uniqueidentifier', 'xml');

  function IsNoSizeDataType: Boolean;
  var i : Integer;
  begin
    Result := false;
    for i := 0 to high(vNoSizeTypes) do
      if vNoSizeTypes[i] = AdataType then
      begin
        Result := true;
        break;
      end;
  end;

begin
  with Result do
  begin
    _DataTypeName := ADataType;
    _Size         := 0;
    _Precision    := 0;
  end;
  ADatatype := lowercase(ADataType);
  if not IsNoSizeDataType then
  begin
    if (ASize = -1) and (
      (ADatatype = 'nvarchar') or
      (ADatatype = 'varbinary') or
      (ADatatype = 'varchar')
      ) then
    begin
      result._DataTypeName := result._DataTypeName + '(MAX)';
    end
    else
    if (ADataType='decimal') or (ADataType='numeric') or
       (ADataType='nchar') or (ADataType='nvarchar') then
    begin
      with Result do
      begin
        _Size      := APrecision;
        _Precision := AScale;
      end;
    end else
    begin
      Result._Size := ASize;
    end;
  end;
end;

{ TSqlServerDataRetriever }

function TSqlServerDataRetriever.CheckSqlServerVersion(AVersion: integer; AEdition: string): boolean;
var
  sqlVersion: integer;
  s: string;
begin
  result := true;
  try
    Module.Open( 'SELECT SERVERPROPERTY(''ProductVersion'') AS Version, SERVERPROPERTY(''Edition'') AS Edition');
    s := Module.FieldAsString('Version'); // M.N.R.B
    sqlVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
    if sqlVersion > 0 then
      result := (sqlVersion >= AVersion) and ((AEdition = '') or SameText(AEdition, Module.FieldAsString('Edition')));
  except
    // ignore possible erros when checking database version
  end;
end;

{TSQLServer2000DataRetriever}

function TSqlServer2000DataRetriever.CheckDatabaseVersion: boolean;
begin
  result := CheckSqlServerVersion(8);
end;

procedure TSqlServer2000DataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
var
  TablesCondition: string;

  procedure _GetDomains;
  var
    newDomain: TGDAODomain;
  begin
    ADictionary.Domains.Clear;
    Module.Open(
      'select '+
      '  t.name as DOMAIN_NAME, '+
      '  t2.name as DATA_TYPE, '+
      '  t.length as FIELD_SIZE, ' +
      '  t.prec as NUMERIC_PRECISION, ' +
      '  t.scale as NUMERIC_SCALE, '+
      '  t.allownulls as IS_NULLABLE, ' +
      '  u.name as USER_NAME '+
      'from '+
      '  systypes t LEFT JOIN sysobjects sod LEFT JOIN sysusers ud ' +
      '  ON sod.uid = ud.uid ON sod.type = ''D'' and sod.id = t.tdefault ' +
      '  LEFT JOIN sysobjects sor LEFT JOIN sysusers ur ' +
      '  ON sor.uid = ur.uid ON sor.type=''R'' and sor.id = t.domain, ' +
      '  systypes t2, sysusers u ' +
      'where '+
      '  t.xtype = t2.xusertype and t.xusertype > 255 ' +
      '  and t.name <> (''sysname'') ' +
      '  and t2.xusertype <= 255 and u.uid=t.uid ' +
      '  order by u.name, t.name');
    while not Module.EOF do
    begin
      {Basic field information: name and required}
      newDomain := ADictionary.Domains.Add;
      newDomain.Name := Module.FieldAsString('DOMAIN_NAME');
      newDomain.InDatabase := true;

      {init default datatype and size values}
      newDomain.DataType := nil;
      newDomain.Size := 0;
      newDomain.Size2 := 0;
      //newDomain.Required := (Module.FieldAs('DOMAIN_NULL_FLAG') = 1);

      {default value}
      //newDomain.DefaultValue := ExtractFBDefaultValue(Module.FieldAs('DOMAIN_DEFAULT'));
      //newDomain.ConstraintExpr := ExtractFBCheckExpression(Module.FieldAs('DOMAIN_CHECK'));

      {In SQL Server, domains are not computed}
      if false {Module.FieldAs('COMPUTED_SOURCE') <> ''} then
      begin
        newDomain.DataTypeName := 'computed';
        //newDomain.Expression := Module.FieldAs('COMPUTED_SOURCE');
      end
      else
      begin
        with GetFieldDefinition(
          Module.FieldAsString('DATA_TYPE'),
          Module.FieldAsInteger('FIELD_SIZE'),
          Module.FieldAsInteger('NUMERIC_PRECISION'),
          Module.FieldAsInteger('NUMERIC_SCALE')) do
        begin
          newDomain.DataTypeName := _DataTypeName;
          newDomain.Size         := _Size;
          newDomain.Size2        := _Precision;
        end;
      end;
      Module.Next;
    end;
  end;

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open(
      'SELECT o.name as TABLE_NAME '+
      'FROM sysobjects o '+
      'WHERE xtype=''U'' and o.name <> ''dtproperties'''+
      'ORDER BY o.name');
    while not Module.EOF do
    begin
      ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME'));
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    ATable: TGDAOTable;
    newField: TGDAOField;
  begin
    Module.Open( Format(
      'SELECT '+
      '  SO.name AS TABLE_NAME, '+
      '  SC.name AS COLUMN_NAME, '+
      '  SC.isnullable AS IS_NULLABLE, '+
      '  SC.colorder AS ORDINAL_POSITION, '+
      '  SMD.text AS COLUMN_DEFAULT, '+
      '  ST.name AS DATA_TYPE, '+
      '  SC.length AS FIELD_SIZE, '+
      '  convert(int, OdbcPrec(SC.xtype, SC.length, SC.xprec)) AS NUMERIC_PRECISION, '+

      '  ST.xusertype AS USER_TYPE, '+
      '  SC.xscale AS NUMERIC_SCALE, '+
      '  SC.domain AS CDOMAIN, '+
      '  SC.collation AS COLUMN_COLLATION, '+

      '  ColumnProperty(SO.id, SC.Name, ''IsIdentity'') AS IS_IDENTITY, '+
      '  IDENT_INCR(Object_Name(SO.id)) AS IDENTITY_INCREMENT, '+
      '  IDENT_SEED(Object_Name(SO.id)) AS IDENTITY_SEED, '+
      '  SC.iscomputed AS IS_COMPUTED, '+
      '  SMC.text as COMPUTED_EXPRESSION '+
      'FROM '+
      'sysobjects SO '+
      'INNER JOIN syscolumns SC ON SO.id = SC.id '+
      'INNER JOIN systypes ST ON SC.xusertype = ST.xusertype '+
      'LEFT JOIN syscomments SMD ON SC.cdefault = SMD.id '+
      'LEFT JOIN syscomments SMC ON (SC.id = SMC.id) and (SC.colid = SMC.number) and (SMC.colid = 1) '+
      'WHERE (SO.xtype = ''U'') and '+
      '(ST.name <> ''sysname'') '+
      'ORDER BY SO.name, SC.colorder'
      ,
      [TablesCondition]));
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        {Basic field information: name and required}
        newField := ATable.Fields.Add(
          Module.FieldAsString('COLUMN_NAME'), nil, 0, 0,
          Module.FieldAsInteger('IS_NULLABLE') = 0);

        {default value}
        newField.DefaultValue := Module.FieldAsString('COLUMN_DEFAULT');

        {Check if it's a domain}
        if
          (Module.FieldAsInteger('USER_TYPE') > 256) and
          (ADictionary.Domains.FindByName(Module.FieldAsString('DATA_TYPE')) <> nil) then
        begin
          if newField.DefaultValue <> '' then
            newField.DefaultValueSpecific := true;

          newField.DomainName := Module.FieldAsString('DATA_TYPE');
        end else
        begin
          {Check if field is computed, otherwise retrieve regular data type
           size, precision and scale}
          if Module.FieldAsInteger('IS_COMPUTED') <> 0 then
          begin
            newField.DataTypeName := 'computed';
            newField.Expression := Module.FieldAsString('COMPUTED_EXPRESSION');
          end
          else
          begin
            with GetFieldDefinition(
              Module.FieldAsString('DATA_TYPE'),
              Module.FieldAsInteger('FIELD_SIZE'),
              Module.FieldAsInteger('NUMERIC_PRECISION'),
              Module.FieldAsInteger('NUMERIC_SCALE')) do
            begin
              newField.DataTypeName := _DataTypeName;
              newField.Size         := _Size;
              newField.Size2        := _Precision;
            end;
          end;
        end;

       {identity information}
       if Module.FieldAsInteger('IS_IDENTITY') <> 0 then
       begin
         newField.DataTypeName := newField.DataTypeName + ' (identity)';
         newField.SeedValue := Module.FieldAsInteger('IDENTITY_SEED');
         newField.IncrementValue := Module.FieldAsInteger('IDENTITY_INCREMENT');
       end;

      end;
      Module.Next;
    end;
  end;

  procedure _GetPrimaryKeys;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
  begin
    Module.Open( 'SELECT kcu.TABLE_NAME, kcu.CONSTRAINT_NAME, kcu.COLUMN_NAME, kcu.ORDINAL_POSITION '+
      'FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tc '+
      'INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as kcu '+
      'ON kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA '+
      'AND kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME '+
      'AND kcu.TABLE_SCHEMA = tc.TABLE_SCHEMA '+
      'AND kcu.TABLE_NAME = tc.TABLE_NAME '+
      'WHERE tc.CONSTRAINT_TYPE = ''PRIMARY KEY'' '+
      //' OR tc.CONSTRAINT_TYPE = ''UNIQUE'' '+
      'ORDER BY kcu.TABLE_NAME, tc.CONSTRAINT_TYPE, kcu.CONSTRAINT_NAME, kcu.ORDINAL_POSITION');
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      AField := nil;
      if ATable <> nil then
        AField := ATable.FieldByName(Module.FieldAsString('COLUMN_NAME'));

      if (ATable <> nil) and (AField <> nil) then
      begin
        ATable.PrimaryKeyIndex.IndexName := Module.FieldAsString('CONSTRAINT_NAME');
        ATable.PrimaryKeyIndex.IFields.Add(AField);
      end;

      Module.Next;
    end;
  end;

  procedure _GetTriggers;
  var
    ATable: TGDAOTable;
    newTrigger: TGDAOTrigger;
  begin
    Module.Open(
      'SELECT s2.name as TABLE_NAME, s1.name as TRIGGER_NAME, c.text as TRIGGER_BODY '+
      'FROM sysobjects s1 '+
      'LEFT JOIN sysobjects s2 on s1.parent_obj=s2.id '+
      'LEFT JOIN syscomments c on s1.id=c.id '+
      'where s1.xtype = ''TR'' '+
      'order by s2.name');
    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        newTrigger := ATable.Triggers.Add;
        newTrigger.Name := Module.FieldAsString('TRIGGER_NAME');
        newTrigger.ImplementationCode := Module.FieldAsString('TRIGGER_BODY');
      end;
      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    ATable: TGDAOTable;
  begin
    Module.Open(
      'SELECT TC.TABLE_NAME, CC.CONSTRAINT_NAME, CC.CHECK_CLAUSE '+
      'FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS CC '+
      'INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC '+
      'ON CC.CONSTRAINT_NAME = TC.CONSTRAINT_NAME '+
      'ORDER BY TC.TABLE_NAME, CC.CONSTRAINT_NAME');

    ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      end;

      {if the table exists, then add the current field to table}
      if ATable <> nil then
      begin
        ATable.Constraints.AddConstraint(
          Module.FieldAsString('CONSTRAINT_NAME'),
          Module.FieldAsString('CHECK_CLAUSE'));
      end;
      Module.Next;
    end;
  end;

  procedure _GetRelationships;
  var
    ARelationship: TGDAORelationship;
    c: integer;
  begin
    for c := 0 to ADictionary.Tables.Count - 1 do
    begin
      Module.Open( Format('sp_fkeys ''%s''', [
        StringReplace(ADictionary.Tables[c].TableName, '''', '''''', [rfReplaceAll])]));
      while not Module.EOF do
      begin
        ARelationship := ADictionary.RelationshipByName(Module.FieldAsString('FK_NAME'));
        if ARelationship = nil then
          ARelationship := ADictionary.Relationships.Add(Module.FieldAsString('FK_NAME'),
            '', '', umRestrict, dmRestrict);
        ARelationship.ParentTableName := Module.FieldAsString('PKTABLE_NAME');
        ARelationship.ChildTableName := Module.FieldAsString('FKTABLE_NAME');
        with ARelationship.FieldLinks.Add do
        begin
          ParentFieldName := Module.FieldAsString('PKCOLUMN_NAME');
          ChildFieldName := Module.FieldAsString('FKCOLUMN_NAME');
        end;

        case Module.FieldAsInteger('UPDATE_RULE') of
          0: ARelationship.UpdateMethod := umCascade;
          1: ARelationship.UpdateMethod := umRestrict;
          2: ARelationship.UpdateMethod := umSetNull;
          3: ARelationship.UpdateMethod := umSetDefault;
        end;

        case Module.FieldAsInteger('DELETE_RULE') of
          0: ARelationship.DeleteMethod := dmCascade;
          1: ARelationship.DeleteMethod := dmRestrict;
          2: ARelationship.DeleteMethod := dmSetNull;
          3: ARelationship.DeleteMethod := dmSetDefault;
        end;
        Module.Next;
      end;
    end;
  end;

  procedure _GetViews;
  var
    AView: TGDAOObject;
    AViews: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctView) <> nil then
    begin
      AViews := ADictionary.Categories.FindByType(ctView).Objects;
      AViews.Clear;
      Module.Open( 'SELECT TABLE_NAME, VIEW_DEFINITION '+
        'FROM INFORMATION_SCHEMA.VIEWS '+
        'ORDER BY TABLE_NAME');
      while not Module.EOF do
      begin
        AView := AViews.Add(Module.FieldAsString('TABLE_NAME'));
        AView.DropImplementation := AView.OwnerCategory.DropTemplate;
        AView.CreateImplementation := Module.FieldAsString('VIEW_DEFINITION');
        Module.Next;
      end;
    end;
  end;

  procedure _GetProcedures;
  var
    AProcedure: TGDAOObject;
    AProcedures: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctProcedure) <> nil then
    begin
      AProcedures := ADictionary.Categories.FindByType(ctProcedure).Objects;
      AProcedures.Clear;
      Module.Open(
        'select so.name as ROUTINE_NAME, t.text as ROUTINE_IMPLEMENTATION '+
        'from sysobjects so, syscomments t '+
        'where (so.type = ''P'' or so.type = ''X'' or so.type = ''RF'') '+
        'and so.id = t.id and (so.category & 0x2)!=2 '+
        'order by so.name');
      while not Module.EOF do
      begin
        AProcedure := AProcedures.FindByName(Module.FieldAsString('ROUTINE_NAME'));
        if AProcedure = nil then
          AProcedure := AProcedures.Add(Module.FieldAsString('ROUTINE_NAME'));
        AProcedure.DropImplementation := AProcedure.OwnerCategory.DropTemplate;
        AProcedure.CreateImplementation := Module.FieldAsString('ROUTINE_IMPLEMENTATION');
        Module.Next;
      end;
    end;
  end;

  procedure _GetIndexes;
  var
    AIndex: TGDAOIndex;
    ATable: TGDAOTable;
    t: integer;
  begin
    for t := 0 to ADictionary.Tables.Count - 1 do
      ADictionary.Tables[t].Indexes.Clear;

    ATable := nil;
    AIndex := nil;
    Module.Open(
      'SELECT t.name as TABLE_NAME, i.name as INDEX_NAME, f.name as COLUMN_NAME, '+
      'INDEXKEY_PROPERTY( t.id, i.indid, ik.keyno, ''IsDescending'') as INDEX_ISDESC, '+
      'INDEXPROPERTY(i.id, i.name, ''IsUnique'') as INDEX_ISUNIQUE '+
      'FROM ((sysindexes i inner join sysobjects t ON i.id = t.id) '+
      'INNER JOIN sysindexkeys ik ON i.indid = ik.indid) '+
      'INNER JOIN syscolumns f ON ik.colid = f.colid '+
      'WHERE t.xType = ''U'' AND f.id = t.id AND ik.id = t.id AND '+
      '(i.status & 0x800) != 0x800 and '+
      '(i.status & 0x1000) != 0x1000 '+
      'and indexproperty(t.id, i.name,''IsStatistics'') = 0 '+
      'ORDER BY t.name, i.name, ik.keyno');
    while not Module.Eof do
    begin
      if (ATable = nil) or
        not SameText(ATable.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
        AIndex := nil;
      end;

      if (ATable <> nil) then
      begin
        if (AIndex = nil) or
          not SameText(AIndex.IndexName, Module.FieldAsString('INDEX_NAME')) then
        begin
          AIndex := ATable.Indexes.Add(Module.FieldAsString('INDEX_NAME'));
        end;

        if AIndex <> nil then
        begin
          if Module.FieldAsInteger('INDEX_ISUNIQUE') <> 0 then
            AIndex.IndexType := itUnique;
          AIndex.IFields.Add(Module.FieldAsString('COLUMN_NAME')).FieldOrder :=
            TIndexFieldOrder(Module.FieldAsInteger('INDEX_ISDESC'));
        end;
      end;
      
      Module.Next;
    end;
  end;

  procedure _UpdateDefaultConstraintNames;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
  begin
    Module.Open(
      'SELECT st.name as TABLE_NAME, sf.name as COLUMN_NAME, sd.name AS CONSTRAINT_NAME '+
      'FROM sysconstraints sc '+
      'INNER JOIN sysobjects sd ON sc.constid = sd.id '+
      'INNER JOIN sysobjects st ON sc.id = st.id '+
      'INNER JOIN syscolumns sf ON (sc.colid = sf.colid) and (sc.id = sf.id) '+
      'WHERE sd.xtype = ''D'' '+
      'ORDER BY st.name, sf.name');
    while not Module.EOF do
    begin
      ATable := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
      if ATable <> nil then
      begin
        AField := ATable.FieldByName(Module.FieldAsString('COLUMN_NAME'));
        if AField <> nil then
        begin
          if AField.DefaultValue <> '' then
            AField.ConstraintDefaultName := Module.FieldAsString('CONSTRAINT_NAME');
        end;
      end;
      Module.Next;
    end;
  end;

begin
  {TablesCondition might have a filter for tables. Example:
   "SO.name in ('blobs', 'labels')"}
  TablesCondition := '0=0';
  SetMaxProgress(1000);
  SetProgressPos(0);

  _GetDomains;
  SetProgressPos(50);

  _GetTables;
  SetProgressPos(100);

  _GetFieldList;
  SetProgressPos(200);

  _GetPrimaryKeys;
  SetProgressPos(300);

  _GetTriggers;
  SetProgressPos(400);

  _GetConstraints;
  SetProgressPos(500);

  _GetIndexes;
  SetProgressPos(600);

  _GetRelationships;
  SetProgressPos(700);

  _GetViews;
  SetProgressPos(800);

  _GetProcedures;
  SetProgressPos(900);

  _UpdateDefaultConstraintNames;
  SetProgressPos(1000);
end;

function TSqlServer2000DataRetriever.GetFieldDefinition(ADatatype: String;
  ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
const vNoSizeTypes : array[0..18] of string =
            ('bigint', 'bit', 'datetime', 'float', 'image', 'int', 'money', 'ntext',
            'real', 'smalldatetime', 'smallint', 'smallmoney', 'sql_variant',
            'sysname', 'text', 'timestamp', 'tinyint', 'uniqueidentifier', 'xml');

  function IsNoSizeDataType: Boolean;
  var i : Integer;
  begin
    Result := false;
    for i := 0 to high(vNoSizeTypes) do
      if vNoSizeTypes[i] = AdataType then
      begin
        Result := true;
        break;
      end;
  end;

begin
  with Result do
  begin
    _DataTypeName := ADataType;
    _Size         := 0;
    _Precision    := 0;
  end;
  ADatatype := lowercase(ADataType);
  if not IsNoSizeDataType then
  begin
    if (ADataType = 'decimal') or (ADataType = 'numeric')
      or (ADataType = 'nchar') or (ADataType = 'nvarchar') then
    begin
      with Result do
      begin
        _Size      := APrecision;
        _Precision := AScale;
      end;
    end else                                         
    begin
      Result._Size := ASize;
    end;
  end;
end;

{ TSqlAzureDataRetriever }

function TSqlAzureDataRetriever.CheckDatabaseVersion: boolean;
begin
  result := CheckSqlServerVersion(10, 'SQL Azure');
end;

procedure TSqlAzureDataRetriever.AfterConstruction;
begin
  inherited;
  FExtendedProperties := false;
end;

{ TSqlServer2016DataRetriever }

function TSqlServer2016DataRetriever.CheckDatabaseVersion: boolean;
begin
  result := CheckSqlServerVersion(13);
end;

end.

