unit sqlite_retrv;

interface

uses
  Generics.Collections, SysUtils, Classes, Variants, uSQLModule,
  qryretrv, dgConsts, uGDAO;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size,_Precision: integer;
  end;

  TSQLiteDataRetriever = class(TDataRetriever)
  private
    function GetFieldDefinition(ADatatype: String; ATypes: TGDAODataTypes): TFieldDefinitionRec;
    function ConvertLineFeeds(const S: string): string;
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
    function CheckDatabaseVersion: boolean; override;
  end;

implementation

uses
  uSQLiteParser;

function TSQLiteDataRetriever.CheckDatabaseVersion: boolean;
begin
  result := true;
end;

function TSQLiteDataRetriever.ConvertLineFeeds(const S: string): string;
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

procedure TSQLiteDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
var
  TablesCondition: string;
  ParsedTableList: TList<TSQLiteCreateTableParser>;

  function ParsedTable(ATableName: string): TSQLiteCreateTableParser;
  begin
    for Result in ParsedTableList do
      if SameText(Result.TableName, ATableName) then
        Exit;
    Result := nil;
  end;

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open(
      'SELECT tbl_name as TABLE_NAME, '+
      'sql as TABLE_SQL '+
      'FROM sqlite_master '+
      'WHERE type = ''table'' '+
      'ORDER BY tbl_name');

    while not Module.EOF do
    begin
      // do not import tables with "sqlite_" prefix
      if Copy(Lowercase(Module.FieldAsString('TABLE_NAME')), 1, Length('sqlite_')) = 'sqlite_' then
      begin
        Module.Next;
        Continue;
      end;

      ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME'));
      ParsedTableList.Add(TSQLiteCreateTableParser.Create(Trim(Module.FieldAsString('TABLE_SQL'))));
      Module.Next;
    end;
  end;

  procedure _GetFieldListForTable(ATable: TGDAOTable; ATableInfo: TSQLiteCreateTableParser);
  var
    newField: TGDAOField;
    colDef: TSQLColumnDef;
  begin
    Module.Open( Format('pragma table_info("%s")', [ATable.TableName]));
    while not Module.EOF do
    begin
      {Basic field information: name and required}
      newField := ATable.Fields.Add(
        Module.FieldAsString('name'), nil, 0, 0,
        Module.FieldAsInteger('notnull') <> 0);

      {default value}
      newField.DefaultValue := Module.FieldAsString('dflt_value');

      {Retrieve data type manually}
      with GetFieldDefinition(
        Module.FieldAsString('type'), ADictionary.DataTypes) do
      begin
        newField.DataTypeName := _DataTypeName;
        newField.Size         := _Size;
        newField.Size2        := _Precision;
      end;

      // Add to the primary key if it belongs to it
      if Module.FieldAsInteger('pk') <> 0 then
        newField.InPrimaryKey := True;

      // Add additional info for the field (check constraint for example)
      if ATableInfo <> nil then
        for colDef in ATableInfo.Columns do
          if SameText(colDef.Name, newField.FieldName) then
          begin
            // Get check constraint
            if colDef.CheckConstraint <> nil then
            begin
              newField.ConstraintName := colDef.CheckConstraint.Name;
              newField.ConstraintExpr := colDef.CheckConstraint.Expression;
            end;

            if colDef.DefaultConstraintName <> '' then
              newField.ConstraintDefaultName := colDef.DefaultConstraintName;

            // Check if data type is specific primary key/autoincrement
            if colDef.HasPrimaryKey then
              if SameText(newField.DataTypeName, 'integer') then
              begin
                newField.Size := 0;
                newField.Size2 := 0;
                if colDef.IsAutoincrement then
                  newField.DataTypeName := 'Integer (autoincrement)'
                else
                  newField.DataTypeName := 'Integer (primary key)';
              end;
          end;

      Module.Next;
    end;

    // Set primary key name
    if (ATableInfo <> nil) and (ATable.PrimaryKeyIndex <> nil) then
      ATable.PrimaryKeyIndex.IndexName := ATableInfo.PrimaryKey.Name;
  end;

  procedure _GetFieldList;
  var
    TableInfo: TSQLiteCreateTableParser;
    I: integer;
  begin
    for I := 0 to ADictionary.Tables.Count - 1 do
    begin
      TableInfo := ParsedTable(ADictionary.Tables[I].TableName);
      _GetFieldListForTable(ADictionary.Tables[I], TableInfo);
    end;
  end;

  procedure _GetPrimaryKeys;
  begin
    // Primary key is already being set in _GetFieldListFromTable but here we can retrieve the primary key name
  end;

  procedure _GetTriggers;
  var
    ATable: TGDAOTable;
    newTrigger: TGDAOTrigger;
  begin
    Module.Open(
      'SELECT name as TRIGGER_NAME, '+
      '  tbl_name as TABLE_NAME, '+
      '  sql as TRIGGER_BODY '+
      'FROM sqlite_master '+
      'WHERE type = ''trigger'' '+
      'ORDER BY tbl_name');
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
        newTrigger.ImplementationCode := ConvertLineFeeds(Trim(Module.FieldAsString('TRIGGER_BODY')));
      end;
      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    ATable: TGDAOTable;
    TableInfo: TSQLiteCreateTableParser;
    I: integer;
    constraint: TSQLCheckConstraint;
  begin
    for I := 0 to ADictionary.Tables.Count - 1 do
    begin
      ATable := ADictionary.Tables[I];
      TableInfo := ParsedTable(ATable.TableName);
      if TableInfo <> nil then
        for constraint in TableInfo.Constraints do
        begin
          ATable.Constraints.AddConstraint(
            constraint.Name,
            constraint.Expression);
        end;
    end;
  end;

  procedure _GetRelationships;

    function SameRelationship(ARel: TGDAORelationship; AForeign: TSQLForeignKey): boolean;
    var
      I: Integer;
    begin
      // if parent table is different, exit
      if not SameText(ARel.ParentTableName, AForeign.ParentTable) then Exit(false);

      // if any of the field links is different, exit
      if (ARel.FieldLinks.Count <> AForeign.ParentFields.Count) then Exit(false);
      if (ARel.FieldLinks.Count <> AForeign.ChildFields.Count) then Exit(false);

      for I := 0 to ARel.FieldLinks.Count - 1 do
      begin
        if not SameText(ARel.FieldLinks[I].ChildFieldName, AForeign.ChildFields[I]) then
          Exit(false);
        if not SameText(ARel.FieldLinks[I].ParentFieldName, AForeign.ParentFields[I]) then
          Exit(false);
      end;
      Result := true;
    end;

  var
    ARelationship: TGDAORelationship;
    ATable: TGDAOTable;
    TableInfo: TSQLiteCreateTableParser;
    I: integer;
    foreign: TSQLForeignKey;
    Seq: Integer;
    LastId: integer;
    S: string;
    link: TGDAORelationshipFieldLink;
  begin
    for I := 0 to ADictionary.Tables.Count - 1 do
    begin
      ATable := ADictionary.Tables[I];
      TableInfo := ParsedTable(ATable.TableName);

      // Retrieve the foreign keys using pragma info
      Module.Open( Format('pragma foreign_key_list("%s")', [ATable.TableName]));
      LastId := -1;
      ARelationship := nil;

      while not Module.EOF do
      begin
        // if id changed, then it's a new relationship
        if (LastId <> Module.FieldAsInteger('id')) or (ARelationship = nil) then
        begin
          LastId := Module.FieldAsInteger('id');
          ARelationship := ADictionary.Relationships.Add('', '', '', umRestrict, dmRestrict);
        end;

        ARelationship.ParentTableName := Module.FieldAsString('table');
        ARelationship.ChildTableName := ATable.TableName;
        link := ARelationship.FieldLinks.Add;
        link.ParentFieldName := Module.FieldAsString('to');
        link.ChildFieldName := Module.FieldAsString('from');
        if (Module.FieldAsString('to') = '') and (link.ParentField = nil)
          and (ARelationship.ParentTable <> nil) then
        begin
          Seq := Module.FieldAsInteger('seq');
          if Seq < ARelationship.ParentTable.PrimaryKeyIndex.IFields.Count  then
            link.ParentField := ARelationship.ParentTable.PrimaryKeyIndex.IFields.Field[Seq];
        end;

        {Set update rule}
        S := Uppercase(Trim(Module.FieldAsString('on_update')));
        if S = 'CASCADE' then
          ARelationship.UpdateMethod := umCascade
        else
        if S = 'SET NULL' then
          ARelationship.UpdateMethod := umSetNull
        else
        if S = 'SET DEFAULT' then
          ARelationship.UpdateMethod := umSetDefault
        else
        if S = 'NO ACTION' then
          ARelationship.UpdateMethod := umNoAction
        else
          ARelationship.UpdateMethod := umRestrict;

        {Set delete rule}
        S := Module.FieldAsString('on_delete');
        if S = 'CASCADE' then
          ARelationship.DeleteMethod := dmCascade
        else
        if S = 'SET NULL' then
          ARelationship.DeleteMethod := dmSetNull
        else
        if S = 'SET DEFAULT' then
          ARelationship.DeleteMethod := dmSetDefault
        else
        if S = 'NO ACTION' then
          ARelationship.DeleteMethod := dmNoAction
        else
          ARelationship.DeleteMethod := dmRestrict;


        // Now use table info just to find the name of foreign key
        if TableInfo <> nil then
        begin
          for foreign in TableInfo.ForeignKeys do
          begin
            if SameRelationship(ARelationship, foreign) and (foreign.Name <> '') then
            begin
              ARelationship.RelationshipName := foreign.Name;
            end;
          end;
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
      Module.Open(
        'SELECT name as VIEW_NAME, '+
        '  sql as VIEW_DEFINITION '+
        'FROM sqlite_master '+
        'WHERE type = ''view'' '+
        'ORDER BY name');

      while not Module.EOF do
      begin
        AView := AViews.Add(Module.FieldAsString('VIEW_NAME'));
        AView.DropImplementation := AView.OwnerCategory.DropTemplate;
        AView.CreateImplementation := Trim(Module.FieldAsString('VIEW_DEFINITION'));
        Module.Next;
      end;
    end;
  end;

  procedure _GetIndexes;
  var
    AIndex: TGDAOIndex;
    ATable: TGDAOTable;
    I: integer;
    J: Integer;
  begin
    for I := 0 to ADictionary.Tables.Count - 1 do
    begin
      ATable := ADictionary.Tables[I];
      ATable.Indexes.Clear;

      // Retrieve indexes using pragma info
      Module.Open( Format('pragma index_list("%s")', [ATable.TableName]));

      while not Module.EOF do
      begin
        AIndex := ATable.Indexes.Add(Module.FieldAsString('name'));
        if Module.FieldAsInteger('unique') <> 0 then
          AIndex.IndexType := TIndexType.itUnique
        else
          AIndex.IndexType := TIndexType.itNone;
        Module.Next;
      end;

      // Get Index fields
      for J := 0 to ATable.Indexes.Count - 1 do
      begin
        AIndex := ATable.Indexes[J];
        Module.Open( Format('pragma index_info("%s")', [AIndex.IndexName]));
        while not Module.EOF do
        begin
          AIndex.IFields.Add(Module.FieldAsString('name'));
          Module.Next;
        end;
      end;

      // Finally, remove indexes starting with sqlite_autoindex
      J := 0;
      while J < ATable.Indexes.Count do
      begin 
        AIndex := ATable.Indexes[J];
        if Lowercase(Copy(AIndex.IndexName, 1, Length('sqlite_autoindex'))) =  'sqlite_autoindex' then
          AIndex.Free
        else
          Inc(J);
      end;


    end;
  end;

begin
  ParsedTableList := TObjectList<TSQLiteCreateTableParser>.Create;
  try
    {TablesCondition might have a filter for tables. Example:
     "SO.name in ('blobs', 'labels')"}
    TablesCondition := '0=0';
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

    _GetRelationships;
    SetProgressPos(600);

    _GetIndexes;
    SetProgressPos(700);

    _GetViews;
    SetProgressPos(800);

    SetProgressPos(1000);
  finally
    ParsedTableList.Free;
  end;
end;

function TSQLiteDataRetriever.GetFieldDefinition(ADatatype: String; ATypes: TGDAODataTypes): TFieldDefinitionRec;
var
  DName: string;
  DSufix: string;
  DSize: integer;
  DPrecision: integer;
  err, p: integer;
  DType: TGDAODataType;
  SizeSpecified: boolean;
begin
  // First parse the data type description, splitting parts of name, size and precision
  // data types could be "Name", "Name(Size)" or "Name(Size, Precision)"
  // (brackets are also allowed: "Name[Size]"
  ADatatype := Trim(ADatatype);
  DSize := 0;
  DPrecision := 0;
  p := Pos('(', ADatatype);
  if p = 0 then
    p := Pos('[', ADatatype);
  if p = 0 then
  begin
    DName := ADatatype;
    SizeSpecified := false;
  end
  else
  begin
    SizeSpecified := true;
    DName := Copy(ADatatype, 1, p - 1);
    DSufix := Copy(ADatatype, p + 1, MaxInt);
    p := Pos(',', DSufix);
    if p = 0 then
      Val(DSufix, DSize, err)
    else
    begin
      // Get Size and Precision if format is XXX,YYY
      // Note that for precision we need to remove the last character, because it's a closing parenthesis
      Val(Copy(DSufix, 1, p - 1), DSize, err);
      Val(Copy(DSufix, p + 1, Length(DSufix) - 1), DPrecision, err);
    end;
  end;

  // in SQLite, "TEXT" is a regular string field, not a blob. Let's change it
  if SameText(DName, 'TEXT') then
    DName := 'VARCHAR';

  // Find the data type based on name
  DType := ATypes.FindByName(DName);

  // if data type not found, then try using the same rules as SQLite uses:
  if DType = nil then
  begin
    DName := Uppercase(DName);
    if Pos('INT', DName) > 0 then
      DName := 'Integer'
    else
    if (Pos('CLOB', DName) > 0) then
      DName := 'Text'
    else
    if (Pos('CHAR', DName) > 0) or (Pos('TEXT', DName) > 0) then
    begin
      DName := 'Varchar'
    end
    else
    if Pos('BLOB', DName) > 0 then
      DName := 'Blob'
    else
    if (Pos('REAL', DName) > 0) or (Pos('FLOA', DName) > 0) or (Pos('DOUB', DName) > 0) then
      DName := 'Double precision'
    else
      DName := 'Generic';
  end;

  // now find the data type based on name
  DType := ATypes.FindByName(DName);
  Assert(DType <> nil, Format('Could not retrieve SQLite data type "%s"', [DName]));

  Result._DataTypeName := DName;
  Result._Size := DSize;
  Result._Precision := DPrecision;
  if DType.SizeIsRequired then
  begin
    { default sizes }
    if not SizeSpecified then
    begin
      case DType.NativeDataType of
        naString: Result._Size := 50;
        naFloat: Result._Size := 10;
      end;
    end;
  end else
    Result._Size := 0;
  if not DType.Size2IsRequired then
    Result._Precision := 0;
end;

end.

