unit myretrv;

interface

uses
  uSQLModule, SysUtils, Classes, qryretrv, uGDAO, dgConsts;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size, _Precision: integer;
  end;

  TMySQLDataRetriever = class(TDataRetriever)
  private
    FDatabase: string;
    FIs51: Boolean;
    function ConvertLineFeeds(S: string): string;
    function DatabaseFilter(AField: string): string;
    function GetFieldDefinition(ADataType: string; ASize, APrecision, AScale: integer): TFieldDefinitionRec;
  public
    constructor Create(AModuleFactory: ISQLModuleFactory; ADatabase: string); reintroduce;
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

  TMySQL51DataRetriever = class(TMySQLDataRetriever)
  public
    procedure AfterConstruction; override;
  end;

  TMySQL57DataRetriever = class(TMySQLDataRetriever)
  public
    function CheckDatabaseVersion: boolean; override;
  end;

implementation

{$IFNDEF AURELIUS_DLL}
uses
  dFireDacModule, FireDac.Phys.Intf, FireDac.Stan.Consts;
{$ENDIF}

{ TMySQLDataRetriever }

function TMySQLDataRetriever.CheckDatabaseVersion: boolean;
var
  majVersion, minVersion: integer;
  s: string;
begin
  {$IFNDEF AURELIUS_DLL}
  if Module is TFireDacModule then
  begin
    Result := TFireDacModule(Module).MetaInfo.ServerVersion >= mvMySQL050100;
    Exit;
  end;
  {$ENDIF}

  result := true;
  try
    Module.Open( 'SELECT version() AS Version');
    s := Module.FieldAsString('Version'); // M.N.R-x
    majVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
    if majVersion > 0 then
    begin
      Delete(s, 1, Pos('.', s));
      minVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
      result := (majVersion >= 5) and (minVersion >= 1); // MySQL 5.1
    end;
  except
    // ignore possible erros when checking database version
  end;
end;

function TMySQLDataRetriever.ConvertLineFeeds(S: string): string;
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

constructor TMySQLDataRetriever.Create(AModuleFactory: ISQLModuleFactory; ADatabase: string);
begin
  inherited Create(AModuleFactory);
//  FDatabase := FConnection.TheParams.Values['DATABASE']
  FDatabase := ADatabase;
end;

function TMySQLDataRetriever.DatabaseFilter(AField: string): string;
begin
  {$IFDEF AURELIUS_DLL}
  Result := Format('%s = DATABASE()', [AField]);
  {$ELSE}
  if FDatabase > '' then
    result := Format('UPPER(%s)=%s', [AField, QuotedStr(AnsiUpperCase(FDatabase))])
  else
    result := '0=0';
  {$ENDIF}
end;

procedure TMySQLDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open( Format(
      'SELECT TABLE_NAME, TABLE_COMMENT '+
      'FROM INFORMATION_SCHEMA.TABLES '+
      'WHERE TABLE_TYPE=''BASE TABLE'' '+
      'AND %s '+
      'ORDER BY TABLE_NAME',
      [DatabaseFilter('TABLE_SCHEMA')]));
    while not Module.EOF do
    begin
      with ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME')) do
      begin
        Description := Module.FieldAsString('TABLE_COMMENT');
      end;
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    table: TGDAOTable;
    field: TGDAOField;
    extra: string;
  begin
    Module.Open( Format(
      'SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, '+
      'NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE, COLUMN_DEFAULT, '+
      'EXTRA, COLUMN_COMMENT, COLUMN_TYPE '+
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
        field.Description := Module.FieldAsString('COLUMN_COMMENT');

        with GetFieldDefinition(
          Module.FieldAsString('DATA_TYPE'),
          Module.FieldAsInteger('CHARACTER_MAXIMUM_LENGTH'),
          Module.FieldAsInteger('NUMERIC_PRECISION'),
          Module.FieldAsInteger('NUMERIC_SCALE')) do
        begin
          if ADictionary.DataTypes.FindByName(_DataTypeName) <> nil then
          begin
            field.DataTypeName := _DataTypeName;
            field.Size         := _Size;
            field.Size2        := _Precision;
          end
          else
          begin
            if Module.FieldAsString('COLUMN_TYPE').StartsWith('enum') then
            field.DataTypeName := 'varchar' else
              field.DataTypeName := 'computed';
            field.Expression := Module.FieldAsString('COLUMN_TYPE');
          end;
        end;

        extra := Module.FieldAsString('EXTRA');
        if extra = 'auto_increment' then
        begin
          if ADictionary.DataTypes.FindByName(field.DataTypeName + ' (autoincrement)') <> nil then
            field.DataTypeName := field.DataTypeName + ' (autoincrement)';
        end
        else if extra > '' then
          field.ConstraintExpr := extra;

        if (field.DefaultValue > '') and (field.DataType.Computed or (field.DataType.NativeDataType = naString)) then
          field.DefaultValue := '''' + field.DefaultValue + '''';
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
      'SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE '+
      'FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS '+
      'WHERE CONSTRAINT_TYPE=''CHECK'' '+
      'AND %s '+
      'ORDER BY TABLE_NAME, CONSTRAINT_NAME',
      [DatabaseFilter('CONSTRAINT_SCHEMA')]));
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
            Module.FieldAsString('CONSTRAINT_TYPE'));
      end;

      Module.Next;
    end;
  end;

  procedure _GetIndexes;
  var
    t: integer;
    index: TGDAOIndex;
    table: TGDAOTable;
  begin
    for t := 0 to ADictionary.Tables.Count - 1 do
      ADictionary.Tables[t].Indexes.Clear;

    table := nil;
    index := nil;
    Module.Open( Format(
      'SELECT S.TABLE_NAME, S.INDEX_NAME, S.COLUMN_NAME, S.NON_UNIQUE, S.SEQ_IN_INDEX '+
      'FROM INFORMATION_SCHEMA.STATISTICS S, INFORMATION_SCHEMA.COLUMNS C '+
      'WHERE S.INDEX_NAME<>''PRIMARY'' AND S.TABLE_NAME=C.TABLE_NAME '+
      'AND S.COLUMN_NAME=C.COLUMN_NAME AND C.COLUMN_KEY IN (''MUL'', ''UNI'') '+
      'AND %s AND %s '+
      'ORDER BY S.TABLE_NAME, S.INDEX_NAME, S.SEQ_IN_INDEX',
      [DatabaseFilter('S.INDEX_SCHEMA'),
       DatabaseFilter('C.TABLE_SCHEMA')]));
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
      begin
        table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
        index := nil;
      end;

      if table <> nil then
      begin
        if (index = nil) or not SameText(index.IndexName, Module.FieldAsString('INDEX_NAME')) then
          index := table.Indexes.Add(Module.FieldAsString('INDEX_NAME'));

        if index <> nil then
        begin
          if Module.FieldAsInteger('NON_UNIQUE') = 0 then
            index.IndexType := itUnique;
          index.IFields.Add(Module.FieldAsString('COLUMN_NAME'));
        end;
      end;
      Module.Next;
    end;
  end;

  procedure _GetRelationships;
  var
    relationship: TGDAORelationship;
    S: string;
  begin
    Module.Open(
      'SELECT R.CONSTRAINT_NAME, R.TABLE_NAME AS ChildTable, R.REFERENCED_TABLE_NAME AS ParentTable, R.DELETE_RULE, '+
      'R.UPDATE_RULE, R.UNIQUE_CONSTRAINT_NAME, KC.COLUMN_NAME AS ChildField, KC.REFERENCED_COLUMN_NAME AS ParentField '+
      'FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE KC, INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R '+
      'WHERE R.CONSTRAINT_NAME=KC.CONSTRAINT_NAME AND R.TABLE_NAME=KC.TABLE_NAME '+
      'AND KC.CONSTRAINT_SCHEMA = DATABASE() AND R.CONSTRAINT_SCHEMA = DATABASE() '+
      'ORDER BY R.CONSTRAINT_NAME, KC.POSITION_IN_UNIQUE_CONSTRAINT');
    while not Module.EOF do
    begin
      relationship := ADictionary.RelationshipByName(Module.FieldAsString('CONSTRAINT_NAME'));
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
      if S = 'CASCADE' then
        relationship.DeleteMethod := dmCascade
      else if S = 'SET NULL' then
        relationship.DeleteMethod := dmSetNull
      else if S = 'SET DEFAULT' then
        relationship.DeleteMethod := dmSetDefault
      else if S = 'NO ACTION' then
        relationship.DeleteMethod := dmNoAction
      else
        relationship.DeleteMethod := dmRestrict;

      S := Module.FieldAsString('UPDATE_RULE');
      if S = 'CASCADE' then
        relationship.UpdateMethod := umCascade
      else if S = 'SET NULL' then
        relationship.UpdateMethod := umSetNull
      else if S = 'SET DEFAULT' then
        relationship.UpdateMethod := umSetDefault
      else if S = 'NO ACTION' then
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

  function BuildParamList(AType, ObjName: string): string;
  var
    Module: TSQLModule;
  begin
    Result := '';
    Module := ModuleFactory.NewSQLModule;
    try
      Module.Open( Format(
        'SELECT PARAMETER_MODE, PARAMETER_NAME, DTD_IDENTIFIER ' +
        'FROM INFORMATION_SCHEMA.PARAMETERS ' +
        'WHERE SPECIFIC_NAME = ''%s'' ' +
        'AND ROUTINE_TYPE = ''%s'' ' +
        'AND %s ' +
        'AND ORDINAL_POSITION > 0 ' +
        'ORDER BY ORDINAL_POSITION',
        [ObjName, AType, DatabaseFilter('SPECIFIC_SCHEMA')]));

      while not Module.EOF do
      begin
        if Result <> '' then
          Result := Result + ', ';
        if Module.FieldAsString('PARAMETER_MODE') <> 'IN' then
          Result := Result + Module.FieldAsString('PARAMETER_MODE') + ' ';
        Result := Result + Format('%s %s',
          [Module.FieldAsString('PARAMETER_NAME'),
           Module.FieldAsString('DTD_IDENTIFIER')]);

        Module.Next;
      end;
    finally
      Module.Free;
    end;
  end;

  procedure _GetSourceObjects57(ACategoryType: TGDAOCategoryType; AType: string);
  var
    objList: TGDAOObjects;
    objItem: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ACategoryType) <> nil then
    begin
      objList := ADictionary.Categories.FindByType(ACategoryType).Objects;
      objList.Clear;
      Module.Open( Format(
        'SELECT R.ROUTINE_NAME, R.ROUTINE_DEFINITION, R.ROUTINE_COMMENT, R.SQL_DATA_ACCESS, '+
        'R.DTD_IDENTIFIER, R.IS_DETERMINISTIC '+
        'FROM INFORMATION_SCHEMA.ROUTINES R '+
        'WHERE ROUTINE_TYPE=''%s'' '+
        'AND %s '+
        'ORDER BY ROUTINE_NAME',
        [AType, DatabaseFilter('ROUTINE_SCHEMA')]));

      while not Module.EOF do
      begin
        objItem := objList.FindByName(Module.FieldAsString('ROUTINE_NAME'));
        if objItem = nil then
        begin
          objItem := objList.Add(Module.FieldAsString('ROUTINE_NAME'));
          objItem.Description := Module.FieldAsString('ROUTINE_COMMENT');
          objItem.CreateImplementation := Format(
            'CREATE %s <%%%s%%> (%s)',
            [AType,
             NativeIdName[niObjectName],
             BuildParamList(AType, objItem.ObjectName)]);
          if Module.FieldAsString('DTD_IDENTIFIER') > '' then
            objItem.CreateImplementation := objItem.CreateImplementation + ' RETURNS ' + Module.FieldAsString('DTD_IDENTIFIER');
          if Module.FieldAsString('IS_DETERMINISTIC') = 'YES' then
            objItem.CreateImplementation := objItem.CreateImplementation + #13#10'DETERMINISTIC';
          if Module.FieldAsString('SQL_DATA_ACCESS') > '' then
            objItem.CreateImplementation := objItem.CreateImplementation + #13#10 + Module.FieldAsString('SQL_DATA_ACCESS');
          objItem.CreateImplementation := objItem.CreateImplementation + #13#10 + ConvertLineFeeds(Module.FieldAsString('ROUTINE_DEFINITION'));
          objItem.DropImplementation := objItem.OwnerCategory.DropTemplate;
        end;

        Module.Next;
      end;
    end;
  end;

  procedure _GetSourceObjects51(ACategoryType: TGDAOCategoryType; AType: string);
  var
    objList: TGDAOObjects;
    objItem: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ACategoryType) <> nil then
    begin
      objList := ADictionary.Categories.FindByType(ACategoryType).Objects;
      objList.Clear;
      Module.Open( Format(
        'SELECT R.ROUTINE_NAME, R.ROUTINE_DEFINITION, R.ROUTINE_COMMENT, R.SQL_DATA_ACCESS, '+
        'R.DTD_IDENTIFIER, R.IS_DETERMINISTIC, P.param_list '+
        'FROM INFORMATION_SCHEMA.ROUTINES R, mysql.proc P '+
        'WHERE ROUTINE_TYPE=''%s'' AND R.ROUTINE_NAME=P.name '+
        'AND R.ROUTINE_SCHEMA=P.db AND R.ROUTINE_TYPE=P.type '+
        'AND %s '+
        'ORDER BY ROUTINE_NAME',
        [AType, DatabaseFilter('ROUTINE_SCHEMA')]));

      while not Module.EOF do
      begin
        objItem := objList.FindByName(Module.FieldAsString('ROUTINE_NAME'));
        if objItem = nil then
        begin
          objItem := objList.Add(Module.FieldAsString('ROUTINE_NAME'));
          objItem.Description := Module.FieldAsString('ROUTINE_COMMENT');
          objItem.CreateImplementation := Format(
            'CREATE %s <%%%s%%> (%s)',
            [AType,
             NativeIdName[niObjectName],
             Module.FieldAsString('param_list')]);
          if Module.FieldAsString('DTD_IDENTIFIER') > '' then
            objItem.CreateImplementation := objItem.CreateImplementation + ' RETURNS ' + Module.FieldAsString('DTD_IDENTIFIER');
          if Module.FieldAsString('IS_DETERMINISTIC') = 'YES' then
            objItem.CreateImplementation := objItem.CreateImplementation + #13#10'DETERMINISTIC';
          if Module.FieldAsString('SQL_DATA_ACCESS') > '' then
            objItem.CreateImplementation := objItem.CreateImplementation + #13#10 + Module.FieldAsString('SQL_DATA_ACCESS');
          objItem.CreateImplementation := objItem.CreateImplementation + #13#10 + ConvertLineFeeds(Module.FieldAsString('ROUTINE_DEFINITION'));
          objItem.DropImplementation := objItem.OwnerCategory.DropTemplate;
        end;

        Module.Next;
      end;
    end;
  end;

  procedure _GetSourceObjects(ACategoryType: TGDAOCategoryType; AType: string);
  begin
    if FIs51 then
      _GetSourceObjects51(ACategoryType, AType)
    else
      _GetSourceObjects57(ACategoryType, AType);
  end;

  procedure _GetProcedures;
  begin
    _GetSourceObjects(ctProcedure, 'PROCEDURE');
  end;

  procedure _GetFunctions;
  begin
    _GetSourceObjects(ctFunction, 'FUNCTION');
  end;

begin
//  DefineDatabase;

  SetMaxProgress(1000);
  SetProgressPos(0);

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

  _GetFunctions;
  SetProgressPos(950);

  //_GetSequences;
  SetProgressPos(1000);
end;

function TMySQLDataRetriever.GetFieldDefinition(ADataType: string; ASize, APrecision, AScale: integer): TFieldDefinitionRec;
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
  if ADataType =  'double' then
  begin
    Result._DataTypeName := 'double precision';
    Exit;
  end;
  if ADataType =  'float' then
  begin
    Result._DataTypeName := 'float';
    Result._Size := 23;
    Exit;
  end;

  with Result do
  begin
    _DataTypeName := ADataType;
    _Size         := 0;
    _Precision    := 0;
  end;

  if not IsNoSizeDataType then
  begin
    if (ADataType='binary') or (ADataType='char') or (ADataType='varbinary') or (ADataType='varchar') then
      result._Size := ASize
    else
    begin
      result._Size := APrecision;
      result._Precision := AScale;
    end;
  end;
end;

{ TMySQL57DataRetriever }

function TMySQL57DataRetriever.CheckDatabaseVersion: boolean;
var
  majVersion, minVersion: integer;
  s: string;
begin
  {$IFNDEF AURELIUS_DLL}
  if Module is TFireDacModule then
  begin
    Result := TFireDacModule(Module).MetaInfo.ServerVersion >= mvMySQL050700;
    Exit;
  end;
  {$ENDIF}

  result := true;
  try
    Module.Open( 'SELECT version() AS Version');
    s := Module.FieldAsString('Version'); // M.N.R-x
    majVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
    if majVersion > 0 then
    begin
      Delete(s, 1, Pos('.', s));
      minVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
      result := (majVersion >= 5) and (minVersion >= 7); // MySQL 5.7
    end;
  except
    // ignore possible erros when checking database version
  end;
end;

{ TMySQL51DataRetriever }

procedure TMySQL51DataRetriever.AfterConstruction;
begin
  inherited;
  FIs51 := True;
end;

end.

