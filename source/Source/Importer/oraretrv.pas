unit oraretrv;

interface

uses
  uSQLModule, SysUtils, Classes, qryretrv, uGDAO, dgConsts;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size,_Precision: integer;
  end;

  TOracleDataRetriever = class(TDataRetriever)
  private
    FCatalog: string;
    FSchema: string;
    function ConvertLineFeeds(S: string): string;
    function GetFieldDefinition(ADatatype: String; ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
    function SchemaCondition(AOwnerField: string; AOwnerFieldJoin: string=''): string;
    property Catalog: string read FCatalog write FCatalog;
  public
    constructor Create(AModuleFactory: ISQLModuleFactory; ASchema: string); reintroduce;
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

  TOracle10gDataRetriever = class(TOracleDataRetriever);

implementation

{ TOracleDataRetriever }

function TOracleDataRetriever.CheckDatabaseVersion: boolean;
var
  oraVersion: integer;
  s: string;
begin
  result := true;
  try

    Module.Open( 'SELECT Version FROM PRODUCT_COMPONENT_VERSION');
    s := Module.FieldAsString('Version'); // M.N.R.B.x
    oraVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
    if oraVersion > 0 then
      result := oraVersion >= 10; // Oracle 10g
  except
    // ignore possible erros when checking database version
  end;
end;

function TOracleDataRetriever.ConvertLineFeeds(S: string): string;
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
  if result[Length(result)] = #13 then
    result := result + #10;
end;

constructor TOracleDataRetriever.Create(AModuleFactory: ISQLModuleFactory; ASchema: string);
begin
  inherited Create(AModuleFactory);

//    FSchema := FConnection.TheParams.Values['SCHEMA']
  FSchema := ASchema;
  if FSchema = '' then
    FCatalog := 'USER'
  else
    FCatalog := 'ALL';
end;

procedure TOracleDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open( Format(
      'SELECT T.TABLE_NAME, C.COMMENTS '+
      'FROM %s_TABLES T '+
      'LEFT JOIN %s_TAB_COMMENTS C ON (T.TABLE_NAME=C.TABLE_NAME AND %s) '+
      'WHERE T.DROPPED <> ''YES'' AND NOT (T.TABLE_NAME LIKE ''%%$%%'') AND %s '+
      'ORDER BY T.TABLE_NAME',
      [Catalog, Catalog, SchemaCondition('T.OWNER', 'C.OWNER'), SchemaCondition('T.OWNER')]));
    while not Module.EOF do
    begin
      with ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME')) do
      begin
        Description := Module.FieldAsString('COMMENTS');
      end;
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    table: TGDAOTable;
    field: TGDAOField;
  begin
    Module.Open( Format(
      'SELECT C.TABLE_NAME, C.COLUMN_NAME, C.DATA_TYPE, C.CHAR_COL_DECL_LENGTH, '+
      'C.DATA_PRECISION, C.DATA_SCALE, C.NULLABLE, C.DATA_DEFAULT, '+
      'CC.COMMENTS '+
      'FROM %s_TAB_COLS C '+
      'LEFT JOIN %s_COL_COMMENTS CC ON (C.TABLE_NAME=CC.TABLE_NAME AND C.COLUMN_NAME=CC.COLUMN_NAME AND %s) '+
      'WHERE %s '+
      'ORDER BY C.TABLE_NAME, C.COLUMN_ID',
      [Catalog, Catalog, SchemaCondition('C.OWNER', 'CC.OWNER'), SchemaCondition('C.OWNER')]));
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
          Module.FieldAsString('NULLABLE') = 'N' {nullable? Y/N});

        {default value}
        field.DefaultValue := Module.FieldAsString('DATA_DEFAULT');

        with GetFieldDefinition(
          Module.FieldAsString('DATA_TYPE'),
          Module.FieldAsInteger('CHAR_COL_DECL_LENGTH'),
          Module.FieldAsInteger('DATA_PRECISION'),
          Module.FieldAsInteger('DATA_SCALE')) do
        begin
          field.DataTypeName := _DataTypeName;
          field.Size         := _Size;
          field.Size2        := _Precision;
        end;
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
      'SELECT CO.TABLE_NAME, CO.CONSTRAINT_NAME, CC.COLUMN_NAME, CC.POSITION '+
      'FROM %s_CONSTRAINTS CO ' +
      'LEFT JOIN %s_INDEXES IX ON (CO.INDEX_NAME=IX.INDEX_NAME AND CO.TABLE_NAME=IX.TABLE_NAME AND CO.OWNER=IX.TABLE_OWNER AND %s) ' +
      'INNER JOIN %s_CONS_COLUMNS CC ON (CO.CONSTRAINT_NAME=CC.CONSTRAINT_NAME AND CO.OWNER=CC.OWNER AND CO.TABLE_NAME=CC.TABLE_NAME) '+
      'WHERE CO.CONSTRAINT_TYPE=''P'' AND %s '+
      'ORDER BY CO.TABLE_NAME, CO.CONSTRAINT_NAME, CC.POSITION',
      [Catalog, Catalog, SchemaCondition('CO.OWNER', 'IX.OWNER'), Catalog, SchemaCondition('CO.OWNER')]));
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
      'SELECT TABLE_NAME, TRIGGER_NAME, DESCRIPTION, TRIGGER_BODY '+
      'FROM %s_TRIGGERS '+
      'WHERE %s '+
      'ORDER BY TABLE_NAME, TRIGGER_NAME',
      [Catalog, SchemaCondition('OWNER')]));
    table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
        table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));

      {if the table exists, then add the current trigger to table}
      if table <> nil then
      begin
        trigger := table.Triggers.Add;
        trigger.Name := Module.FieldAsString('TRIGGER_NAME');
        trigger.ImplementationCode := Format(
          'CREATE TRIGGER %s%s',
          [ConvertLineFeeds(Module.FieldAsString('DESCRIPTION')),
           ConvertLineFeeds(Module.FieldAsString('TRIGGER_BODY'))]);
      end;

      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    table: TGDAOTable;
    field: TGDAOField;
    i: Integer;
    consName, consExpr, consColumn: string;
  begin
    Module.Open( Format(
      'SELECT CO.TABLE_NAME, CO.CONSTRAINT_NAME, CO.SEARCH_CONDITION, CC.COLUMN_NAME '+
      'FROM %s_CONSTRAINTS CO '+
      'LEFT JOIN %s_CONS_COLUMNS CC ON (CO.OWNER=CC.OWNER AND CO.TABLE_NAME=CC.TABLE_NAME AND CO.CONSTRAINT_NAME=CC.CONSTRAINT_NAME) '+
      'WHERE CO.CONSTRAINT_TYPE=''C'' AND %s '+
      'ORDER BY CO.TABLE_NAME, CO.CONSTRAINT_NAME',
      [Catalog, Catalog, SchemaCondition('CO.OWNER')]));
    table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));
    while not Module.EOF do
    begin
      {Check if ATable is the same as the table of current record.
       If it's not, then update ATable. Always consider that ATable might be nil,
       because it's not necessary that we filter all the records according to the
       available tables}
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TABLE_NAME')) then
        table := ADictionary.TableByName(Module.FieldAsString('TABLE_NAME'));

      { if the table exists, then add the current constraint to table }
      if table <> nil then
      begin
        consName := Module.FieldAsString('CONSTRAINT_NAME');
        consExpr := Module.FieldAsString('SEARCH_CONDITION');
        consColumn := Module.FieldAsString('COLUMN_NAME');

        if table.Constraints.IndexOf(consName) < 0 then
        begin
          if consColumn > '' then
            field := table.FieldByName(consColumn)
          else
            field := nil;

          if field <> nil then // field level constraint
          begin
            if Pos('IS NOT NULL', consExpr) > 0 then // not null constraint
              field.ConstraintNotNullName := consName
            else // check constraint
            begin
              for i := 0 to table.Fields.Count - 1 do
                if table.Fields[i].ConstraintName = consName then
                begin
                  table.Fields[i].ConstraintName := '';
                  table.Fields[i].ConstraintExpr := '';
                  field := nil;
                  break;
                end;

              if field <> nil then
              begin
                field.ConstraintName := Module.FieldAsString('CONSTRAINT_NAME');
                field.ConstraintExpr := Module.FieldAsString('SEARCH_CONDITION');
              end;
            end;
          end;

          if field = nil then // table level constraint
          begin
            table.Constraints.AddConstraint(
              Module.FieldAsString('CONSTRAINT_NAME'),
              Module.FieldAsString('SEARCH_CONDITION'));
          end;
        end;
      end;

      Module.Next;
    end;
  end;

  procedure _GetIndexes;
  var
    index: TGDAOIndex;
    table: TGDAOTable;
    t: integer;
  begin
    for t := 0 to ADictionary.Tables.Count - 1 do
      ADictionary.Tables[t].Indexes.Clear;

    table := nil;
    index := nil;
    Module.Open( Format(
      'SELECT IX.TABLE_NAME, IX.INDEX_NAME, IC.COLUMN_NAME, IX.UNIQUENESS, IX.INDEX_TYPE, IC.DESCEND, IC.COLUMN_POSITION '+
      'FROM %s_INDEXES IX '+
      'INNER JOIN %s_IND_COLUMNS IC ON (IX.TABLE_NAME=IC.TABLE_NAME AND IX.INDEX_NAME=IC.INDEX_NAME AND %s AND %s) '+
      'WHERE %s '+
      'ORDER BY IX.TABLE_NAME, IX.INDEX_NAME, IC.COLUMN_POSITION',
      [Catalog, Catalog, SchemaCondition('IX.TABLE_OWNER', 'IC.TABLE_OWNER'), SchemaCondition('IX.OWNER', 'IC.INDEX_OWNER'), SchemaCondition('IX.OWNER')]));
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
        begin
          if (table.PrimaryKeyIndex = nil) or not SameText(table.PrimaryKeyIndex.IndexName, Module.FieldAsString('INDEX_NAME')) then
            index := table.Indexes.Add(Module.FieldAsString('INDEX_NAME'))
          else
            index := nil;
        end;

        if index <> nil then
        begin
          if Module.FieldAsString('UNIQUENESS') = 'UNIQUE' then
            index.IndexType := itUnique;
          with index.IFields.Add(Module.FieldAsString('COLUMN_NAME')) do
            if Module.FieldAsString('DESCEND') = 'DESC' then
              FieldOrder := ioDesc;
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
    Module.Open( Format(
      'SELECT C.CONSTRAINT_NAME, C.TABLE_NAME AS ChildTable, Cpar.TABLE_NAME AS ParentTable, C.DELETE_RULE, '+
      'C.R_CONSTRAINT_NAME, F.COLUMN_NAME AS ChildField, Fpar.COLUMN_NAME AS ParentField '+
      'FROM %s_CONSTRAINTS C '+
      'INNER JOIN %s_CONSTRAINTS Cpar ON (C.R_OWNER = Cpar.OWNER AND C.R_CONSTRAINT_NAME = Cpar.CONSTRAINT_NAME) '+
      'INNER JOIN %s_CONS_COLUMNS F ON (C.OWNER = F.OWNER AND C.CONSTRAINT_NAME = F.CONSTRAINT_NAME) '+
      'INNER JOIN %s_CONS_COLUMNS Fpar ON (C.R_OWNER = Fpar.OWNER AND C.R_CONSTRAINT_NAME = Fpar.CONSTRAINT_NAME) '+
      'WHERE C.CONSTRAINT_TYPE=''R'' AND (F.POSITION = Fpar.POSITION) AND %s '+
      'ORDER BY C.CONSTRAINT_NAME, F.POSITION, Fpar.POSITION',
      [Catalog, Catalog, Catalog, Catalog, SchemaCondition('C.OWNER')]));
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

      {Set delete rule}
      S := Module.FieldAsString('DELETE_RULE');
      if S = 'CASCADE' then
        relationship.DeleteMethod := dmCascade
      else if S = 'SET_NULL' then
        relationship.DeleteMethod := dmSetNull
      else if S = 'SET_DEFAULT' then
        relationship.DeleteMethod := dmSetDefault
      else
        relationship.DeleteMethod := dmRestrict;

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
        'SELECT VIEW_NAME, TEXT '+
        'FROM %s_VIEWS '+
        'WHERE %s '+
        'ORDER BY VIEW_NAME',
        [Catalog, SchemaCondition('OWNER')]));
      while not Module.EOF do
      begin
        view := views.Add(Module.FieldAsString('VIEW_NAME'));
        view.DropImplementation := view.OwnerCategory.DropTemplate;
        view.CreateImplementation := Format(
          'CREATE VIEW <%%%s%%> AS %s',
          [NativeIdName[niObjectName], ConvertLineFeeds(Module.FieldAsString('TEXT'))]);
        Module.Next;
      end;
    end;
  end;

  procedure _GetSourceObjects(ACategoryType: TGDAOCategoryType; AOraType: string);
  var
    objList: TGDAOObjects;
    objItem: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ACategoryType) <> nil then
    begin
      objList := ADictionary.Categories.FindByType(ACategoryType).Objects;
      objList.Clear;
      Module.Open( Format(
        'SELECT NAME, TEXT '+
        'FROM %s_SOURCE '+
        'WHERE TYPE=''%s'' AND %s '+
        'ORDER BY NAME, LINE',
        [Catalog, AOraType, SchemaCondition('OWNER')]));

      // table XXX_SOURCE stores each line of procedure in a record
      while not Module.EOF do
      begin
        objItem := objList.FindByName(Module.FieldAsString('NAME'));
        if objItem = nil then
        begin
          objItem := objList.Add(Module.FieldAsString('NAME'));
          objItem.CreateImplementation := 'CREATE ';
          objItem.DropImplementation := objItem.OwnerCategory.DropTemplate;
        end;

        objItem.CreateImplementation := objItem.CreateImplementation + ConvertLineFeeds(Module.FieldAsString('TEXT'));
        
        Module.Next;                                                                
      end;
    end;
  end;

  procedure _GetProcedures;
  begin
    _GetSourceObjects(ctProcedure, 'PROCEDURE');
  end;

  procedure _GetFunctions;
  begin
    _GetSourceObjects(ctFunction, 'FUNCTION');
  end;

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
        'SELECT SEQUENCE_NAME, INCREMENT_BY '+
        'FROM %s_SEQUENCES '+
        'WHERE %s '+
        'ORDER BY SEQUENCE_NAME',
        [Catalog, SchemaCondition('SEQUENCE_OWNER')]));
      while not Module.EOF do
      begin
        sequence := sequences.FindByName(Module.FieldAsString('SEQUENCE_NAME'));
        if sequence = nil then
          sequence := sequences.Add(Module.FieldAsString('SEQUENCE_NAME'));
        sequence.DropImplementation := sequence.OwnerCategory.DropTemplate;
        sequence.CreateImplementation := sequence.OwnerCategory.CreateTemplate;
        Module.Next;
      end;
    end;
  end;

begin
//  DefineSchema;

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

  _GetSequences; 
  SetProgressPos(1000);
end;

function TOracleDataRetriever.GetFieldDefinition(ADatatype: String; ASize, APrecision, AScale: Integer): TFieldDefinitionRec;
const
  vSizeTypes: array[0..5] of string =
    ('char', 'nchar', 'nvarchar2', 'raw', 'urowid', 'varchar2');
  vPrecisionTypes: array[0..3] of string =
    ('decimal', 'number', 'numeric', 'float');

  function FindType(atypes: array of string): boolean;
  var
    i: integer;
  begin
    for i := Low(atypes) to high(atypes) do
      if SameText(ADatatype, atypes[i]) then
      begin
        result := True;
        exit;
      end;
    result := False;
  end;

begin
  result._DataTypeName := ADatatype;
  result._Size := 0;
  result._Precision := 0;
  if FindType(vSizeTypes) then
    result._Size := ASize
  else if FindType(vPrecisionTypes) then
  begin
    if (APrecision = 0) and (AScale = 0) then
      result._DataTypeName := result._DataTypeName + ' (floating point)'
    else
    begin
      result._Size := APrecision;
      result._Precision := AScale;
    end;
  end
  else if Pos('INTERVAL ', ADatatype) = 1 then
  begin
    if Pos('TO SECOND', ADatatype) > 0 then
      result._DataTypeName := 'Interval day to second'
    else if Pos('TO MONTH', ADatatype) > 0 then
      result._DataTypeName := 'Interval year to month';
    result._Size := APrecision;
    result._Precision := AScale;
  end
  else if Pos('TIMESTAMP', ADatatype) = 1 then
  begin
    if Pos('LOCAL', Uppercase(ADatatype)) > 0 then
      result._DataTypeName := 'Timestamp with local time zone'
    else if Pos('TIME ZONE', Uppercase(ADatatype)) > 0 then
      result._DataTypeName := 'Timestamp with time zone'
    else
      result._DataTypeName := 'Timestamp';
    result._Size := AScale;
  end;
end;

function TOracleDataRetriever.SchemaCondition(AOwnerField, AOwnerFieldJoin: string): string;
begin
  if FSchema > '' then
  begin
    if AOwnerFieldJoin = '' then
      result := Format('%s=%s', [AOwnerField, QuotedStr(AnsiUpperCase(FSchema))])
    else
      result := Format('%s=%s', [AOwnerField, AOwnerFieldJoin]);
  end
  else
    result := '0=0';
end;

end.

