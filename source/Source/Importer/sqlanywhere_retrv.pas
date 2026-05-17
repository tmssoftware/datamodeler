unit sqlanywhere_retrv;

interface

uses
  SysUtils, Classes, Variants, uSQLModule, qryretrv, dgConsts, uGDAO;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size,_Size2: integer;
  end;

  TIdentifyDefinitionRec = record
    _SeedValue : Integer;
    _IncrementValue : Integer;
  end;

  TSqlAnywhereDataRetriever = class(TDataRetriever)
  private
    function GetFieldDefinition(ADatatype: String; ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
    function CheckSqlAnywhereVersion(AVersion: integer; AEdition: string=''): boolean;
    procedure GetTables(ADictionary: TGDAODatabase);
    procedure GetFieldList(ADictionary: TGDAODatabase);
    procedure GetPrimaryKeys(ADictionary: TGDAODatabase);
    procedure GetRelationships(ADictionary: TGDAODatabase);
    procedure GetIndexes(ADictionary: TGDAODatabase);
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

implementation

function TSqlAnywhereDataRetriever.CheckDatabaseVersion: boolean;
begin
  result := CheckSqlAnywhereVersion(10);
end;

function TSqlAnywhereDataRetriever.CheckSqlAnywhereVersion(
  AVersion: integer; AEdition: string): boolean;
//var
//  sqlVersion: integer;
//  s: string;
begin
  result := true;
//  try
//    Module.Open( 'SELECT SERVERPROPERTY(''ProductVersion'') AS Version, SERVERPROPERTY(''Edition'') AS Edition');
//    s := Module.FieldAsString('Version'); // M.N.R.B
//    sqlVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
//    if sqlVersion > 0 then
//      result := (sqlVersion >= AVersion) and ((AEdition = '') or SameText(AEdition, Module.FieldAsString('Edition')));
//  except
//    // ignore possible erros when checking database version
//  end;
end;

procedure TSqlAnywhereDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
begin
  {TablesCondition might have a filter for tables. Example:
   "SO.name in ('blobs', 'labels')"}
  SetMaxProgress(500);
  SetProgressPos(0);

  GetTables(ADictionary);
  SetProgressPos(100);

  GetFieldList(ADictionary);
  SetProgressPos(200);

  GetPrimaryKeys(ADictionary);
  SetProgressPos(300);

//  _GetTriggers;
//  SetProgressPos(400);

//  _GetConstraints;
//  SetProgressPos(500);

  GetIndexes(ADictionary);
  SetProgressPos(400);

  GetRelationships(ADictionary);
  SetProgressPos(500);

//  _GetViews;
//  SetProgressPos(800);

//  _GetProcedures;
//  SetProgressPos(900);

//  _UpdateDefaultConstraintNames;
//  SetProgressPos(1000);
end;

function TSqlAnywhereDataRetriever.GetFieldDefinition(ADatatype: String;
  ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
const
  vNoSizeTypes : array[0..31] of string =
    ('bigint', 'bit', 'date', 'datetime', 'float', 'image', 'integer', 'money', 'ntext',
    'real', 'smalldatetime', 'smallint', 'smallmoney', 'sql_variant', 'double',
    'date', 'long varchar', 'long binary', 'long nvarchar', 'time',
    'unsigned int', 'unsigned smallint', 'unsigned bigint',
    'sysname', 'text', 'timestamp', 'tinyint', 'uniqueidentifier', 'xml',
    'st_geometry', 'hierarchyid', 'geography');

  function NeedSize: Boolean;
  var
    I: Integer;
  begin
    for i := 0 to high(vNoSizeTypes) do
      if vNoSizeTypes[I] = ADataType then
        Exit(false);
    Result := true;
  end;

begin
  Result._DataTypeName := ADataType;
  ADataType := Trim(LowerCase(ADataType));
  if NeedSize then
  begin
    if (ADataType = 'numeric') then
    begin
      Result._Size := APrecision;
      Result._Size2 := AScale;
    end
    else
      Result._Size := ASize;
  end;
end;

procedure TSqlAnywhereDataRetriever.GetFieldList(ADictionary: TGDAODatabase);
var
  ATable: TGDAOTable;
  newField: TGDAOField;
begin
  Module.Open(
    'SELECT t.table_name as TABLE_NAME, c.column_name as COLUMN_NAME, '+
    '  d.domain_name as DATA_TYPE, c.nulls AS IS_NULLABLE, '+
    '  c.width AS CHAR_LENGTH, c.width as NUMERIC_PRECISION, '+
    '  c.scale as NUMERIC_SCALE, c."default" as DEFAULT_VALUE '+
    'FROM '+
    '  SYSTABCOL c INNER JOIN SYSTAB t ON c.table_id = t.table_id '+
    '  INNER JOIN SYSDOMAIN d ON c.domain_id = d.domain_id '+
    'WHERE '+
    '  t.table_type in (1) '+
    '    AND (user_name(t.creator) <> ''SYS'') '+
    '    AND (user_name(t.creator) <> ''rs_systabgroup'') '+
    '    AND (user_name(t.creator) <> ''dbo'') '+
    '    AND (user_name(t.creator) <> ''ml_server'') '+
    'ORDER BY t.table_name, c.column_id'
  );
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
        not SameText(Module.FieldAsString('IS_NULLABLE'), 'N')
      );

      {default value}
      newField.DefaultValue := Module.FieldAsString('DEFAULT_VALUE');

      {if data type is a domain, then just set the domain. Otherwise, retrieve
      the data type manually}
//      if
//        (Module.FieldAsBoolean('IS_DOMAIN')) and
//        (ADictionary.Domains.FindByName(Module.FieldAsString('DATA_TYPE')) <> nil) then
//      begin
//        if newField.DefaultValue <> '' then
//          newField.DefaultValueSpecific := true;
//
//        newField.DomainName := Module.FieldAsString('DATA_TYPE');
//      end else
      begin
        {Check if field is computed, otherwise retrieve regular data type
         size, precision and scale}
//        if Module.FieldAsBoolean('IS_COMPUTED') then
//        begin
//          newField.DataTypeName := 'computed';
//          newField.Expression := Module.FieldAsString('COMPUTED_EXPRESSION');
//        end
//        else
        begin
          with GetFieldDefinition(
            Module.FieldAsString('DATA_TYPE'),
            Module.FieldAsInteger('CHAR_LENGTH'),
            Module.FieldAsInteger('NUMERIC_PRECISION'),
            Module.FieldAsInteger('NUMERIC_SCALE')) do
          begin
            newField.DataTypeName := _DataTypeName;
            newField.Size         := _Size;
            newField.Size2        := _Size2;
          end;
        end;
      end;

      {identity information}
//      if Module.FieldAsBoolean('IS_IDENTITY') then
      if SameText(Module.FieldAsString('DEFAULT_VALUE'), 'autoincrement') then
      begin
        newField.DataTypeName := newField.DataTypeName + ' (identity)';
//        newField.SeedValue := Module.FieldAsInteger('IDENTITY_SEED');
//        newField.IncrementValue := Module.FieldAsInteger('IDENTITY_INCREMENT');
        newField.SeedValue := 1;
        newField.IncrementValue := 1;
      end;

      {description}
//      newField.FieldCaption := Module.FieldAsString('DESCRIPTION');
    end;
    Module.Next;
  end;
end;

procedure TSqlAnywhereDataRetriever.GetIndexes(ADictionary: TGDAODatabase);
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
    'SELECT t.table_name AS TABLE_NAME, i.index_name as INDEX_NAME, '+
    '  c.column_name AS COLUMN_NAME, ic.sequence AS ORDINAL_POSITION, '+
    '  i."unique" AS UNIQUE_TYPE, ic."order" AS INDEX_ORDER '+
    'FROM '+
    '  SYSIDX i INNER JOIN SYSTAB t ON i.table_id = t.table_id '+
    '  INNER JOIN SYSIDXCOL ic ON (i.table_id = ic.table_id) and (i.index_id = ic.index_id) '+
    '  INNER JOIN SYSTABCOL c ON (ic.table_id = c.table_id) and (ic.column_id = c.column_id) '+
    'WHERE '+
    '  t.table_type in (1) '+
    '    AND (user_name(t.creator) <> ''SYS'') '+
    '    AND (user_name(t.creator) <> ''rs_systabgroup'') '+
    '    AND (user_name(t.creator) <> ''dbo'') '+
    '    AND (user_name(t.creator) <> ''ml_server'') '+
    '  AND '+
    '  i.index_category = 3 AND i."unique" in (1, 2, 4, 5)'+
    'ORDER BY t.table_name, i.index_name, ic.sequence');
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
//          '  (i."unique" IN (1, 2, 5)) AS INDEX_ISUNIQUE '+
        if Module.FieldAsInteger('UNIQUE_TYPE') in [1, 2, 5] then
//        if Module.FieldAsInteger('INDEX_ISUNIQUE') <> 0 then
          AIndex.IndexType := itUnique;


//        AIndex.IFields.Add(Module.FieldAsString('COLUMN_NAME')).FieldOrder :=
//          TIndexFieldOrder(Module.FieldAsInteger('INDEX_ISDESC'));
      end;
    end;

    Module.Next;
  end;
end;

procedure TSqlAnywhereDataRetriever.GetPrimaryKeys(ADictionary: TGDAODatabase);
var
  ATable: TGDAOTable;
  AField: TGDAOField;
begin
  Module.Open(
    'SELECT t.table_name AS TABLE_NAME, i.index_name as CONSTRAINT_NAME, '+
    '  c.column_name AS COLUMN_NAME, ic.sequence AS ORDINAL_POSITION, '+
    '  i."unique" AS UNIQUE_TYPE, ic."order" AS INDEX_ORDER '+
    'FROM '+
    '  SYSIDX i INNER JOIN SYSTAB t ON i.table_id = t.table_id '+
    '  INNER JOIN SYSIDXCOL ic ON (i.table_id = ic.table_id) and (i.index_id = ic.index_id) '+
    '  INNER JOIN SYSTABCOL c ON (ic.table_id = c.table_id) and (ic.column_id = c.column_id) '+
    'WHERE '+
    '  t.table_type in (1) '+
    '    AND (user_name(t.creator) <> ''SYS'') '+
    '    AND (user_name(t.creator) <> ''rs_systabgroup'') '+
    '    AND (user_name(t.creator) <> ''dbo'') '+
    '    AND (user_name(t.creator) <> ''ml_server'') '+
    '  AND '+
    '  i.index_category = 1 '+
    'ORDER BY t.table_name, i.index_name, ic.sequence');
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

procedure TSqlAnywhereDataRetriever.GetRelationships(
  ADictionary: TGDAODatabase);
var
  ARelationship: TGDAORelationship;
  S: string;
begin
  Module.Open(
    'SELECT pt.table_name AS PK_TABLE_NAME, pc.column_name AS PK_COLUMN_NAME, '+
    '  ft.table_name AS FK_TABLE_NAME, fc.column_name AS FK_COLUMN_NAME, '+
    '  fi.index_name as CONSTRAINT_NAME, fic.sequence as ORDINAL_POSITION, '+
    '  tgd.referential_action as DELETE_RULE, '+
    '  tgu.referential_action as UPDATE_RULE '+
    'FROM '+
    '  SYSFKEY f '+
    '  INNER JOIN SYSTAB ft ON f.foreign_table_id = ft.table_id '+
    '  INNER JOIN SYSTAB pt ON f.primary_table_id = pt.table_id '+
    '  INNER JOIN SYSIDX fi ON (f.foreign_table_id = fi.table_id) and (f.foreign_index_id = fi.index_id) '+
    '  INNER JOIN SYSIDXCOL fic ON (fi.table_id = fic.table_id) and (fi.index_id = fic.index_id) '+
    '  INNER JOIN SYSTABCOL fc ON (fic.table_id = fc.table_id) and (fic.column_id = fc.column_id) '+
    '  INNER JOIN SYSTABCOL pc ON (f.primary_table_id = pc.table_id) and (fic.primary_column_id = pc.column_id) '+
    '  LEFT JOIN SYSTRIGGER tgd ON (f.foreign_table_id = tgd.foreign_table_id) and (f.foreign_index_id = tgd.foreign_key_id) and (tgd.trigger_time = ''A'') and (tgd.event = ''D'') '+
    '  LEFT JOIN SYSTRIGGER tgu ON (f.foreign_table_id = tgu.foreign_table_id) and (f.foreign_index_id = tgu.foreign_key_id) and (tgu.trigger_time = ''A'') and (tgu.event = ''U'') '+
    'WHERE '+
    '  ft.table_type in (1) '+
    '    AND (user_name(ft.creator) <> ''SYS'') '+
    '    AND (user_name(ft.creator) <> ''rs_systabgroup'') '+
    '    AND (user_name(ft.creator) <> ''dbo'') '+
    '    AND (user_name(ft.creator) <> ''ml_server'') '+
    'ORDER BY ft.table_name, fi.index_name, fic.sequence'
  );
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
    if S = 'C' then
      ARelationship.UpdateMethod := umCascade
    else
    if S = 'N' then
      ARelationship.UpdateMethod := umSetNull
    else
    if S = 'D' then
      ARelationship.UpdateMethod := umSetDefault
    else
      ARelationship.UpdateMethod := umRestrict;

    {Set delete rule}
    S := Module.FieldAsString('DELETE_RULE');
    if S = 'C' then
      ARelationship.DeleteMethod := dmCascade
    else
    if S = 'N' then
      ARelationship.DeleteMethod := dmSetNull
    else
    if S = 'D' then
      ARelationship.DeleteMethod := dmSetDefault
    else
      ARelationship.DeleteMethod := dmRestrict;

    Module.Next;
  end;
end;

procedure TSqlAnywhereDataRetriever.GetTables(ADictionary: TGDAODatabase);
begin
  ADictionary.Tables.Clear;

  Module.Open(
    'SELECT TABLE_NAME '+
    'FROM SYSTAB '+
    'WHERE (table_type in (1)) '+
    '  AND (user_name(creator) <> ''SYS'') '+
    '  AND (user_name(creator) <> ''rs_systabgroup'') '+
    '  AND (user_name(creator) <> ''dbo'') '+
    '  AND (user_name(creator) <> ''ml_server'') '+
    'ORDER BY TABLE_NAME'
  );
  while not Module.EOF do
  begin
    ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME'));
    Module.Next;
  end;
end;

end.



