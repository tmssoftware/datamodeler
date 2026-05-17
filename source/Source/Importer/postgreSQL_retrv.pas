unit postgreSQL_retrv;
//SELECT *
//FROM information_schema.routines
//WHERE routine_SCHEMA NOT IN ('pg_catalog', 'information_schema')
//AND external_language <> 'INTERNAL'
//order by routine_name
interface

uses
  Generics.Collections, uSQLModule, SysUtils, Classes, qryretrv, uGDAO, dgConsts;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size, _Precision: integer;
  end;

  TPostgreSQLDataRetriever = class(TDataRetriever)
  private
    FTypesMap: TDictionary<string, string>;
    FSchema: string;
    function ConvertLineFeeds(S: string): string;
    function DatabaseFilter(AField: string): string;
    function GetFieldDefinition(ADataType: string; ASize, APrecision, AScale, ATimePrec: integer): TFieldDefinitionRec;
    procedure GetVersion(out Major, Minor: Integer);
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
    constructor Create(AModuleFactory: ISQLModuleFactory; ASchema: string = ''); reintroduce;
  end;

  TPostgreSQL9DataRetriever = class(TPostgreSQLDataRetriever);

  TPostgreSQL11DataRetriever = class(TPostgreSQLDataRetriever);

implementation

uses
  Types,
  {$IFNDEF AURELIUS_DLL}
  dFireDacModule, FireDac.Phys.Intf, FireDac.Stan.Consts,
  {$ENDIF}
  StrUtils;

{ TPostgreSQLDataRetriever }

function TPostgreSQLDataRetriever.CheckDatabaseVersion: boolean;
var
  Major, Minor: Integer;
begin
  GetVersion(Major, Minor);
  Result := Major >= 9;
end;

function TPostgreSQLDataRetriever.ConvertLineFeeds(S: string): string;
var
  c: integer;
begin
  result := '';
  for c := 1 to Length(S) do
  begin
    if (S[c] = #10) and (c > 1) and (S[c - 1] <> #13) then
      result := result + #13;

    result := result + S[c];

    if (S[c] = #13) and (c < Length(S)) and (S[c + 1] <> #10) then
      result := result + #10;
  end;
  if (Length(Result) > 0) and (Result[Length(result)] = #13) then
      result := result + #10;
end;

constructor TPostgreSQLDataRetriever.Create(AModuleFactory: ISQLModuleFactory;
  ASchema: string = '');
begin
  inherited Create(AModuleFactory);
//    FSchema := FConnection.TheParams.Values['SCHEMA']
  FSchema := ASchema;
end;

procedure TPostgreSQLDataRetriever.AfterConstruction;
begin
  inherited;
  FTypesMap := TDictionary<string, string>.Create;
  FTypesMap.Add('int8', 'bigint');
  FTypesMap.Add('serial8', 'bigserial');
  FTypesMap.Add('bool', 'boolean');
  FTypesMap.Add('float8', 'double precision');
  FTypesMap.Add('int', 'integer');
  FTypesMap.Add('int4', 'integer');
  FTypesMap.Add('decimal', 'numeric');
  FTypesMap.Add('float4', 'real');
  FTypesMap.Add('int2', 'smallint');
  FTypesMap.Add('serial4', 'serial');
  FTypesMap.Add('timetz', 'time with time zone');
  FTypesMap.Add('timestamptz', 'timestamp with time zone');

  FTypesMap.Add('bpchar', 'char');
end;

function TPostgreSQLDataRetriever.DatabaseFilter(AField: string): string;
begin
  if FSchema = '' then
    Result := Format('%s NOT IN (''pg_catalog'', ''information_schema'')', [AField])
  else
    Result := Format('%s = ''%s''', [AField, FSchema]);
end;

destructor TPostgreSQLDataRetriever.Destroy;
begin
  FTypesMap.Free;
  inherited;
end;

procedure TPostgreSQLDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);

  procedure _GetDomains;
  var
    newDomain: TGDAODomain;
  begin
    Module.Open( Format(
      'SELECT D.DOMAIN_NAME, D.DATA_TYPE, D.UDT_NAME, D.CHARACTER_MAXIMUM_LENGTH, '+
      'D.NUMERIC_PRECISION, D.NUMERIC_SCALE, D.DATETIME_PRECISION, D.DOMAIN_DEFAULT, CC.CHECK_CLAUSE '+
      'FROM INFORMATION_SCHEMA.DOMAINS D '+
      '  LEFT JOIN INFORMATION_SCHEMA.DOMAIN_CONSTRAINTS DC ON ((D.DOMAIN_NAME = DC.DOMAIN_NAME) and (D.DOMAIN_SCHEMA = DC.DOMAIN_SCHEMA)) '+
      '  LEFT JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS CC ON ((CC.CONSTRAINT_NAME = DC.CONSTRAINT_NAME) AND (CC.CONSTRAINT_SCHEMA = DC.CONSTRAINT_SCHEMA)) '+
      'WHERE %s '+
      'ORDER BY D.DOMAIN_NAME',
      [DatabaseFilter('D.DOMAIN_SCHEMA')]));
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
      newDomain.ConstraintExpr := Module.FieldAsString('CHECK_CLAUSE');
      //newDomain.Required := (Module.FieldAs('DOMAIN_NULL_FLAG') = 1);

      {default value}
      newDomain.DefaultValue := Module.FieldAsString('DOMAIN_DEFAULT');

//      if SameText(Module.FieldAsString('DATA_TYPE'), 'USER-DEFINED') then
//      begin
//        newDomain.DataTypeName := 'computed';
//        newDomain.Expression := Module.FieldAsString('UDT_NAME');
//      end
//      else
//      if SameText(Module.FieldAsString('DATA_TYPE'), 'ARRAY') then
//      begin
//        newDomain.DataTypeName := 'computed';
//        newDomain.Expression := Module.FieldAsString('UDT_NAME');
//        newDomain.Expression := Copy(field.Expression, 2, MaxInt) + '[]';
//      end
//      else
      with GetFieldDefinition(
        Module.FieldAsString('UDT_NAME'),
        Module.FieldAsInteger('CHARACTER_MAXIMUM_LENGTH'),
        Module.FieldAsInteger('NUMERIC_PRECISION'),
        Module.FieldAsInteger('NUMERIC_SCALE'),
        Module.FieldAsInteger('DATETIME_PRECISION')) do
      begin
        newDomain.DataTypeName := _DataTypeName;
        newDomain.Size         := _Size;
        newDomain.Size2        := _Precision;
      end;
      Module.Next;
    end;
  end;

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open( Format(
      'SELECT TABLE_NAME '+
      'FROM INFORMATION_SCHEMA.TABLES '+
      'WHERE TABLE_TYPE=''BASE TABLE'' '+
      'AND %s '+
      'ORDER BY TABLE_NAME',
      [DatabaseFilter('TABLE_SCHEMA')]));
    while not Module.EOF do
    begin
      with ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME')) do
      begin
//        Description := Module.FieldAsString('TABLE_COMMENT');
      end;
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    table: TGDAOTable;
    field: TGDAOField;
//    extra: string;
  begin
    Module.Open( Format(
      'SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, UDT_NAME, CHARACTER_MAXIMUM_LENGTH, '+
      'NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION, IS_NULLABLE, COLUMN_DEFAULT, DOMAIN_NAME '+
      'FROM INFORMATION_SCHEMA.COLUMNS '+
      'WHERE %s '+
      'ORDER BY TABLE_NAME, ORDINAL_POSITION',
      [DatabaseFilter('TABLE_SCHEMA')]));
    table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
        table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));

      {if the table exists, then add the current field to table}
      if table <> nil then
      begin
        {Basic field information: name and required}
        field := table.Fields.Add(Module.FieldAsString('COLUMN_NAME'), nil, 0, 0,
          Module.FieldAsString('IS_NULLABLE') = 'NO' {nullable? YES/NO});

        {default value}
        field.DefaultValue := Module.FieldAsString('COLUMN_DEFAULT');
//        field.Description := Module.FieldAsString('COLUMN_COMMENT');

        if Module.FieldAsString('DOMAIN_NAME') <> '' then
        begin
          field.DomainName := Module.FieldAsString('DOMAIN_NAME');
          if field.Domain = nil then
            raise EGUIException.CreateFmt('Could not find domain "%s"', [Module.FieldAsString('DOMAIN_NAME')] );
        end
        else
        if SameText(Module.FieldAsString('DATA_TYPE'), 'USER-DEFINED') then
        begin
          field.DataTypeName := 'computed';
          field.Expression := Module.FieldAsString('UDT_NAME');
        end
        else
        if SameText(Module.FieldAsString('DATA_TYPE'), 'ARRAY') then
        begin
          field.DataTypeName := 'computed';
          field.Expression := Module.FieldAsString('UDT_NAME');
          field.Expression := Copy(field.Expression, 2, MaxInt) + '[]';
        end
        else
        with GetFieldDefinition(
          Module.FieldAsString('UDT_NAME'),
          Module.FieldAsInteger('CHARACTER_MAXIMUM_LENGTH'),
          Module.FieldAsInteger('NUMERIC_PRECISION'),
          Module.FieldAsInteger('NUMERIC_SCALE'),
          Module.FieldAsInteger('DATETIME_PRECISION')) do
        begin
//          if ADictionary.DataTypes.FindByName(_DataTypeName) <> nil then
//          begin
            field.DataTypeName := _DataTypeName;
            field.Size         := _Size;
            field.Size2        := _Precision;
//          end
//          else
//          begin
//            field.DataTypeName := 'computed';
//            field.Expression := Module.FieldAsString('UDT_NAME');
//          end;
        end;

//        if (field.DefaultValue > '') and (field.DataType.Computed or (field.DataType.NativeDataType = naString)) then
//          field.DefaultValue := '''' + field.DefaultValue + '''';
      end;
      
      Module.Next;
    end;
  end;

  procedure _GetPrimaryKeys;
  var
    table: TGDAOTable;
    field: TGDAOField;
  begin
    Module.Open( Format(
      'SELECT C.TABLE_NAME, C.CONSTRAINT_NAME, K.COLUMN_NAME, K.ORDINAL_POSITION '+
      'FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS C, INFORMATION_SCHEMA.KEY_COLUMN_USAGE K '+
      'WHERE C.CONSTRAINT_TYPE=''PRIMARY KEY'' '+
      'AND C.TABLE_NAME=K.TABLE_NAME AND C.CONSTRAINT_NAME=K.CONSTRAINT_NAME '+
      'AND %s AND %s '+
      'ORDER BY C.TABLE_NAME, C.CONSTRAINT_NAME, K.ORDINAL_POSITION',
      [DatabaseFilter('C.CONSTRAINT_SCHEMA'),
       DatabaseFilter('K.CONSTRAINT_SCHEMA')]));
    table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
        table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));

      if table <> nil then
        field := table.FieldByName(Module.FieldAsString('COLUMN_NAME'))
      else
        field := nil;

      if (table <> nil) and (field <> nil) then
      begin
        table.PrimaryKeyIndex.IndexName := Module.FieldAsString('CONSTRAINT_NAME');
        table.PrimaryKeyIndex.IFields.Add.Field := field;
      end;

      Module.Next;
    end;
  end;

  procedure _GetTriggers;
  var
    table: TGDAOTable;
    trigger: TGDAOTrigger;
  begin
    Module.Open( Format(
      'SELECT EVENT_OBJECT_TABLE, TRIGGER_NAME, EVENT_MANIPULATION, '+
      'ACTION_ORDER, ACTION_CONDITION, ACTION_STATEMENT, ACTION_ORIENTATION, '+
      'ACTION_TIMING '+
      'FROM INFORMATION_SCHEMA.TRIGGERS '+
      'WHERE %s '+
      'ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME',
      [DatabaseFilter('TRIGGER_SCHEMA')]));
    table := ADictionary.TableByName(Module.FieldAsString('EVENT_OBJECT_TABLE'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('EVENT_OBJECT_TABLE')) then
        table := ADictionary.TableByName(Module.FieldAsString('EVENT_OBJECT_TABLE'));

      {if the table exists, then add the current trigger to table}
      if table <> nil then
      begin
        trigger := table.Triggers.Add;
        trigger.Name := Module.FieldAsString('TRIGGER_NAME');
        trigger.ImplementationCode := Format(
          'CREATE TRIGGER %s %s %s ON %s ',
          [Module.FieldAsString('TRIGGER_NAME'),
           Module.FieldAsString('ACTION_TIMING'),
           Module.FieldAsString('EVENT_MANIPULATION'),
           Module.FieldAsString('EVENT_OBJECT_TABLE')]);
        if Module.FieldAsString('ACTION_ORIENTATION') = 'ROW' then
          trigger.ImplementationCode := trigger.ImplementationCode + 'FOR EACH ROW ';
        trigger.ImplementationCode := trigger.ImplementationCode +
          ConvertLineFeeds(Module.FieldAsString('ACTION_STATEMENT'));
      end;

      Module.Next;
    end;                                                 
  end;

  procedure _GetConstraints;
  var
    table: TGDAOTable;
  begin
    Module.Open( Format(
      'SELECT C.TABLE_NAME, C.CONSTRAINT_NAME, CC.CHECK_CLAUSE '+
      'FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS C '+
      '  INNER JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS CC ON ((C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME) and (C.CONSTRAINT_SCHEMA = CC.CONSTRAINT_SCHEMA)) '+
      '  INNER JOIN information_schema.constraint_column_usage CU ON ((C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME) and (C.CONSTRAINT_SCHEMA = CU.CONSTRAINT_SCHEMA)) '+
      'WHERE CONSTRAINT_TYPE=''CHECK'' '+
      'AND %s '+
      'ORDER BY C.TABLE_NAME, C.CONSTRAINT_NAME',
      [DatabaseFilter('C.CONSTRAINT_SCHEMA')]));
    table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
        table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));

      if table <> nil then
      begin
        if table.Constraints.IndexOf(Module.FieldAsString('CONSTRAINT_NAME')) < 0 then
          table.Constraints.AddConstraint(
            Module.FieldAsString('CONSTRAINT_NAME'),
            Module.FieldAsString('CHECK_CLAUSE'));
      end;

      Module.Next;
    end;
  end;

  procedure _GetIndexes;
  var
    t: integer;
    index: TGDAOIndex;
    table: TGDAOTable;
    tabname: string;
    Pos: TDictionary<integer, integer>;
    Keys: TStringDynArray;
    I: integer;
  begin
    Pos := TDictionary<integer, integer>.Create;
    try
      for t := 0 to ADictionary.Tables.Count - 1 do
        ADictionary.Tables[t].Indexes.Clear;

      table := nil;
      index := nil;
      Module.Open(Format(
        'select                                 ' +
        '    n.nspname as schema_name,          ' +
        '    t.relname as table_name,           ' +
        '    i.relname as index_name,           ' +
        '    array_to_string(ix.indkey, '','') as index_order,  ' +
        '    a.attname as column_name,          ' +
        '    a.attnum as column_index           ' +
        'from                                   ' +
        '    pg_class t,                        ' +
        '    pg_class i,                        ' +
        '    pg_index ix,                       ' +
        '    pg_attribute a,                    ' +
        '    pg_namespace n                     ' +
        'where                                  ' +
        '    t.oid = ix.indrelid                ' +
        '    and i.oid = ix.indexrelid          ' +
        '    and a.attrelid = t.oid             ' +
        '    and t.relnamespace = n.oid         ' +
        '    and a.attnum = ANY(ix.indkey)      ' +
        '    and t.relkind = ''r''                ' +
        '    and ix.indisunique <> ''t''          ' +
        '    and ix.indisprimary <> ''t''         ' +
        '    and %s                             '  +
        'order by                               ' +
        '    t.relname,                         ' +
        '    i.relname, index_order                          ',
        [DatabaseFilter('n.nspname')]));
      while not Module.EOF do
      begin
        if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
        begin
          tabName := Module.FieldAsString('TABLE_NAME');
          table := ADictionary.TableByName(tabname);
          index := nil;
        end;

        if table <> nil then
        begin
          if (index = nil) or not SameText(index.IndexName, Module.FieldAsString('INDEX_NAME')) then
          begin
            index := table.Indexes.Add(Module.FieldAsString('INDEX_NAME'));
            Pos.Clear;
            Keys := SplitString(Module.FieldAsString('INDEX_ORDER'), ',');
            for I := 0 to Length(Keys) - 1 do
              Pos.Add(StrToInt(Keys[I]), I);
          end;

          if index <> nil then
          begin
//            if Module.FieldAsInteger('NON_UNIQUE') = 0 then
//              index.IndexType := itUnique;
            I := Pos[Module.FieldAsInteger('COLUMN_INDEX')];
            if I > index.IFields.Count then
              I := index.IFields.Count;
            index.IFields.Add(Module.FieldAsString('COLUMN_NAME')).Index := I;
          end;
        end;
        Module.Next;
      end;
    finally
      Pos.Free;
    end;
  end;

  procedure _GetRelationships;
  var
    relationship: TGDAORelationship;
    S: string;
  begin
    // https://stackoverflow.com/a/25925751
    // https://www.postgresql.org/message-id/200811072134.44750.andreak%40officenet.no
    Module.Open(Format(
       'SELECT constraint_name, ps.relname as childtable, source_attr.attname AS childfield,                              '+
       '     pn.nspname as constraint_schema,                                                                                         '+
       '     pt.relname as parenttable, target_attr.attname AS parentfield,                                               '+
       '     update_rule, delete_rule, i as ordinal_position                                                                          '+
       ' FROM pg_attribute target_attr, pg_attribute source_attr,                                                                     '+
       '   (SELECT source_table, target_table, source_constraints[i] source_constraints, target_constraints[i] AS target_constraints, '+
       '      namespace_oid, constraint_name, i, update_rule, delete_rule                                                             '+
       '    FROM                                                                                                                      '+
       '      (SELECT conrelid as source_table, confrelid AS target_table, conkey AS source_constraints,                              '+
       '        connamespace as namespace_oid,                                                                                        '+
       '        confkey AS target_constraints, conname as constraint_name,                                                            '+
       '        confupdtype as update_rule, confdeltype delete_rule,                                                                  '+
       '        generate_series(1, array_upper(conkey, 1)) AS i                                                                       '+
       '       FROM pg_constraint                                                                                                     '+
       '       WHERE contype = ''f''                                                                                                    '+
       '      ) query1                                                                                                                '+
       '   ) query2                                                                                                                   '+
       '   JOIN pg_namespace pn ON pn.oid = namespace_oid                                                                             '+
       '   JOIN pg_class ps on ps.oid = source_table                                                                                  '+
       '   JOIN pg_class pt on pt.oid = target_table                                                                                  '+
       ' WHERE target_attr.attnum = target_constraints AND target_attr.attrelid = target_table AND                                    '+
       '       source_attr.attnum = source_constraints AND source_attr.attrelid = source_table                                        '+
       '       AND %s                                                                                                                 '+
       ' ORDER BY                                                                                                                     '+
       '    constraint_name, childtable, ordinal_position',
        [DatabaseFilter('pn.nspname')]));
    while not Module.EOF do
    begin
      relationship := ADictionary.RelationshipByName(
        Module.FieldAsString('CONSTRAINT_NAME'), Module.FieldAsString('ChildTable'));
      if relationship = nil then
        relationship := ADictionary.Relationships.Add(Module.FieldAsString('CONSTRAINT_NAME'),
          '', '', umRestrict, dmRestrict);

      relationship.ParentTableName := Module.FieldAsString('ParentTable');
      relationship.ChildTableName := Module.FieldAsString('ChildTable');
      with relationship.FieldLinks.Add do
      begin
        ParentFieldName := Module.FieldAsString('ParentField');
        ChildFieldName := Module.FieldAsString('ChildField');
      end;

      S := Module.FieldAsString('DELETE_RULE');
      if S = 'c' then
        relationship.DeleteMethod := dmCascade
      else if S = 'n' then
        relationship.DeleteMethod := dmSetNull
      else if S = 'd' then
        relationship.DeleteMethod := dmSetDefault
      else if S = 'a' then
        relationship.DeleteMethod := dmNoAction
      else
        relationship.DeleteMethod := dmRestrict;

      S := Module.FieldAsString('UPDATE_RULE');
      if S = 'c' then
        relationship.UpdateMethod := umCascade
      else if S = 'n' then
        relationship.UpdateMethod := umSetNull
      else if S = 'd' then
        relationship.UpdateMethod := umSetDefault
      else if S = 'a' then
        relationship.UpdateMethod := umNoAction
      else
        relationship.UpdateMethod := umRestrict;

      Module.Next;
    end;
  end;

  procedure _GetViews;
  var
    views: TGDAOObjects;
    view: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ctView) <> nil then
    begin
      views := ADictionary.Categories.FindByType(ctView).Objects;
      views.Clear;
      Module.Open( Format(
        'SELECT TABLE_NAME, VIEW_DEFINITION '+
        'FROM INFORMATION_SCHEMA.VIEWS '+
        'WHERE %s '+
        'ORDER BY TABLE_NAME',
        [DatabaseFilter('TABLE_SCHEMA')]));
      while not Module.EOF do
      begin
        view := views.Add(Module.FieldAsString('TABLE_NAME'));
        view.DropImplementation := view.OwnerCategory.DropTemplate;
        view.CreateImplementation := Format(
          'CREATE VIEW <%%%s%%> AS %s',
          [NativeIdName[niObjectName], ConvertLineFeeds(Module.FieldAsString('VIEW_DEFINITION'))]);
        Module.Next;
      end;
    end;
  end;

  procedure _GetSourceObjects(ACategoryType: TGDAOCategoryType);
  var
    objList: TGDAOObjects;
    objItem: TGDAOObject;
    FunctionCondition: string;
    Major, Minor: Integer;
  begin
    if ADictionary.Categories.FindByType(ACategoryType) <> nil then
    begin
      GetVersion(Major, Minor);
      if Major >= 11 then
        FunctionCondition :=
          'FROM   (SELECT oid, proname, pronamespace FROM pg_proc p WHERE p.prokind <> ''a'') p '
      else
        FunctionCondition :=
          'FROM   (SELECT oid, * FROM pg_proc p WHERE NOT p.proisagg) p ';

      objList := ADictionary.Categories.FindByType(ACategoryType).Objects;
      objList.Clear;
      Module.Open( Format(
        'SELECT n.nspname AS schema_name ' +
        '      ,p.proname AS ROUTINE_NAME ' +
        '      ,pg_get_functiondef(p.oid) AS ROUTINE_DEFINITION ' +
        FunctionCondition +
        'JOIN   pg_namespace n ON n.oid = p.pronamespace ' +
        'WHERE %s',
        [DatabaseFilter('n.nspname')]));
      while not Module.EOF do
      begin
        objItem := objList.FindByName(Module.FieldAsString('ROUTINE_NAME'));
        if objItem = nil then
        begin
          objItem := objList.Add(Module.FieldAsString('ROUTINE_NAME'));
          objItem.CreateImplementation := Module.FieldAsString('ROUTINE_DEFINITION');
          objItem.CreateImplementation := StringReplace(objItem.CreateImplementation, #10, #13#10, [rfReplaceAll]);

          objItem.DropImplementation := objItem.OwnerCategory.DropTemplate;
        end;
        Module.Next;
      end;
    end;
  end;

  procedure _GetProcedures;
  begin
    _GetSourceObjects(ctProcedure);
  end;

//  procedure _GetFunctions;
//  begin
//    _GetSourceObjects(ctFunction, 'FUNCTION');
//  end;

  procedure _GetSequences;
  var
    sequences: TGDAOObjects;
    sequence: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ctSequence) <> nil then
    begin
      sequences := ADictionary.Categories.FindByType(ctSequence).Objects;
      sequences.Clear;
      Module.Open( Format(
        'SELECT SEQUENCE_NAME, INCREMENT, START_VALUE '+
        'FROM INFORMATION_SCHEMA.SEQUENCES '+
        'WHERE %s '+
        'ORDER BY SEQUENCE_NAME',
        [DatabaseFilter('SEQUENCE_SCHEMA')]));
      while not Module.EOF do
      begin
        sequence := sequences.FindByName(Module.FieldAsString('SEQUENCE_NAME'));
        if sequence = nil then
          sequence := sequences.Add(Module.FieldAsString('SEQUENCE_NAME'));
        sequence.DropImplementation := sequence.OwnerCategory.DropTemplate;
        sequence.CreateImplementation := sequence.OwnerCategory.CreateTemplate;
        sequence.WriteProp(SProp_SequenceSeed, Module.FieldAsInteger('START_VALUE'));
        Module.Next;
      end;
    end;
  end;

begin
  SetMaxProgress(1200);
  SetProgressPos(0);

  _GetDomains;
  SetProgressPos(100);

  _GetTables;
  SetProgressPos(200);

  _GetFieldList;
  SetProgressPos(300);

  _GetPrimaryKeys;
  SetProgressPos(400);

  _GetTriggers;
  SetProgressPos(500);

  _GetConstraints;
  SetProgressPos(600);

  _GetIndexes;
  SetProgressPos(700);

  _GetRelationships;
  SetProgressPos(800);

  _GetViews;
  SetProgressPos(900);

  _GetProcedures;
  SetProgressPos(1000);

//  _GetFunctions;
//  SetProgressPos(1100);

  _GetSequences;
  SetProgressPos(1200);
end;

function TPostgreSQLDataRetriever.GetFieldDefinition(ADataType: string; ASize, APrecision, AScale, ATimePrec: integer): TFieldDefinitionRec;
const
  vNoSizeTypes : array[0..20] of string =
     ( 'bigint', 'bit', 'blob', 'date',  'datetime', 'double precision', 'int', 'longblob',
       'longtext', 'mediumblob', 'mediumint', 'mediumtext', 'real', 'smallint', 'text', 'time',
       'timestamp', 'tinyblob', 'tinyint', 'tinytext', 'year' );

  function IsNoSizeDataType: Boolean;
  var
    i: integer;
  begin
    result := false;
    for i := 0 to high(vNoSizeTypes) do
      if vNoSizeTypes[i] = ADataType then
      begin
        result := true;
        break;
      end;
  end;

begin
  // Defaults
  with Result do
  begin
    _Size         := 0;
    _Precision    := 0;
  end;

  ADataType := Trim(LowerCase(ADataType));
  if FTypesMap.ContainsKey(ADataType) then
    ADataType := FTypesMap[ADataType];

  with Result do
  begin
    _DataTypeName := ADataType;
    _Size         := 0;
    _Precision    := 0;
  end;

  if (ADataType = 'bit')
    or (ADataType = 'varbit')
    or (ADataType = 'char')
    or (ADataType = 'varchar') then
  begin
    result._Size := ASize;
  end
  else
  if (ADataType = 'numeric') then
  begin
    result._Size := APrecision;
    result._Precision := AScale;
  end
//  else
//  if (Copy(ADataType, 1, Length('time')) = 'time')
//    or (Copy(ADataType, 1, Length('interval')) = 'interval') then
//  begin
//    result._Size := ATimePrec;
//  end;
end;

procedure TPostgreSQLDataRetriever.GetVersion(out Major, Minor: Integer);
var
  s: string;
begin
  try
    Module.Open('select version()');
    s := Module.FieldAsString('Version'); // ""PostgreSQL 9.1.2, compiled by Visual C++ build 1500, 32-bit""
    Delete(S, 1, Pos(' ', s));
    Major := StrToIntDef(Copy(s, 1, Pos('.', s) - 1), 0);
    if Major > 0 then
    begin
      Delete(s, 1, Pos('.', s));
      Minor := StrToIntDef(Copy(s, 1, Pos('.', s) - 1), 0);
    end;
  except
    Major := 9;
  end;
end;

end.

