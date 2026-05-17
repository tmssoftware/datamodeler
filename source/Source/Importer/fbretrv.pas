unit fbretrv;

interface

uses
  SysUtils, Classes, qryretrv, uGDAO, dgConsts;

type
  TFieldDefinitionRec = record
      _DataTypeName: String;
      _Size,_Precision: integer;
  end;

  TFirebirdEdition = (fb2, fb3, ib2017);

  TFirebirdBaseRetriever = class(TDataRetriever)
  private
    function ConvertLineFeeds(S: string): string;
    function ExtractFBDefaultValue(Str: string): string;
    function ExtractFBCheckExpression(ACode: String): String;
    procedure GetSeedAndIncrement(GenName: string; var Seed, Increment: Integer);
  protected
    function CheckFirebirdVersion(Min: TFirebirdEdition): boolean;
  protected
    function GetFieldDefinition(AType, ASize, APrecision, AScale, ASubType, ASegment: integer): TFieldDefinitionRec; virtual;
    procedure GetDomains(ADictionary: TGDAODatabase); virtual;
    procedure GetTables(ADictionary: TGDAODatabase); virtual;
    procedure GetFieldList(ADictionary: TGDAODatabase); virtual;
    procedure GetPrimaryKeys(ADictionary: TGDAODatabase); virtual;
    procedure GetTriggers(ADictionary: TGDAODatabase); virtual;
    procedure GetConstraints(ADictionary: TGDAODatabase); virtual;
    procedure GetIndexes(ADictionary: TGDAODatabase); virtual;
    procedure GetRelationships(ADictionary: TGDAODatabase); virtual;
    procedure GetViews(ADictionary: TGDAODatabase); virtual;
    procedure GetProcedures(ADictionary: TGDAODatabase); virtual;
    procedure GetSequences(ADictionary: TGDAODatabase); virtual;
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
  end;

  TFirebird2DataRetriever = class(TFirebirdBaseRetriever)
  public
    function CheckDatabaseVersion: boolean; override;
  end;

  TFirebird3DataRetriever = class(TFirebirdBaseRetriever)
  public
    function CheckDatabaseVersion: boolean; override;
  end;

  TInterbase2017DataRetriever = class(TFirebirdBaseRetriever)
  public
    function CheckDatabaseVersion: boolean; override;
  end;

implementation

uses
  {$IFNDEF AURELIUS_DLL}
  dFireDacModule, FireDac.Phys.IBMeta, FireDac.Stan.Consts,
  {$ENDIF}
  uSQLModule;

function TFirebirdBaseRetriever.CheckFirebirdVersion(Min: TFirebirdEdition): boolean;
var
  fbVersion: integer;
  s: string;
  {$IFNDEF AURELIUS_DLL}
  AMod: TFireDacModule;
  Meta: IFDPhysIBConnectionMetadata;
  Brand: TFDPhysIBBrand;
  {$ENDIF}
begin
  {$IFNDEF AURELIUS_DLL}
  if Module is TFireDacModule then
  begin
    AMod := TFireDacModule(Module);
    if Supports(AMod.MetaInfo, IFDPhysIBConnectionMetadata, Meta) then
    begin
      Brand := Meta.Brand;
      Result :=
        (Brand = ibInterbase) and (AMod.MetaInfo.ServerVersion >= ivIB070000) or
        (Brand = ibFirebird) and (AMod.MetaInfo.ServerVersion >= ivFB020500);
      if Min = fb3 then
        Result := Result and (Brand = ibFirebird) and (AMod.MetaInfo.ServerVersion >= ivFB030000);
      if Min = ib2017 then
        Result := Result and (Brand = ibInterbase) and (AMod.MetaInfo.ServerVersion >= ivIB130000);
      Exit;
    end;
  end;
  {$ENDIF}

  result := true;
  try
    Module.Open( 'SELECT rdb$get_context(''SYSTEM'', ''ENGINE_VERSION'') AS Version FROM rdb$database');
    s := Module.FieldAsString('Version'); // M.N.R
    fbVersion := StrToIntDef(Copy(s, 1, Pos('.', s)-1), 0);
    if fbVersion > 0 then
      case Min of
        fb2: Result := fbVersion >= 2;
        fb3: Result := fbVersion >= 3;
      end;
  except
    // ignore possible erros when checking database version
  end;
end;

function TFirebirdBaseRetriever.ConvertLineFeeds(S: string): string;
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

function TFirebirdBaseRetriever.ExtractFBCheckExpression(ACode: String): String;
var
  s: string;
begin
  s := LowerCase(StringReplace(ACode, ' ', '', [rfReplaceAll]));
  if Pos('check(', s) = 1 then
  begin
    result := Trim(StringReplace(ACode, 'check', '', [rfIgnoreCase]));
    Delete(result, 1, 1);
    if (result > '') and (result[length(result)] = ')') then
      Delete(result, length(result), 1);
  end
  else
    result := ACode;

  {remove line characters}
  result := StringReplace(result, #13, '', [rfReplaceAll]);
  result := StringReplace(result, #10, '', [rfReplaceAll]);
end;

function TFirebirdBaseRetriever.ExtractFBDefaultValue(Str: string): string;
begin
  result := trim(Str);
  if Pos('DEFAULT', Uppercase(Str)) = 1 then
    result := Trim(Copy(Str, Length('DEFAULT') + 1, MaxInt));
end;

procedure TFirebirdBaseRetriever.GetConstraints(ADictionary: TGDAODatabase);
var
  ATable: TGDAOTable;
begin
  Module.Open(
    'select '#13#10+
    'A.RDB$RELATION_NAME as TABLE_NAME, '#13#10+
    'A.RDB$CONSTRAINT_NAME as CONSTRAINT_NAME, '#13#10+
    'C.RDB$TRIGGER_SOURCE as CHECK_CLAUSE '#13#10+
    'from RDB$RELATION_CONSTRAINTS A, RDB$CHECK_CONSTRAINTS B, RDB$TRIGGERS C '#13#10+
    'where (A.RDB$CONSTRAINT_TYPE = ''CHECK'') and '#13#10+
    '(A.RDB$CONSTRAINT_NAME = B.RDB$CONSTRAINT_NAME) and '#13#10+
    '(B.RDB$TRIGGER_NAME = C.RDB$TRIGGER_NAME) and '#13#10+
    '(C.RDB$TRIGGER_TYPE = 1) '#13#10+
    'order by A.RDB$RELATION_NAME, A.RDB$CONSTRAINT_NAME');
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
        ExtractFBCheckExpression(Module.FieldAsString('CHECK_CLAUSE')));
    end;
    Module.Next;
  end;
end;

procedure TFirebirdBaseRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
begin
  SetMaxProgress(1100);
  SetProgressPos(0);

  GetDomains(ADictionary);
  SetProgressPos(100);

  GetTables(ADictionary);
  SetProgressPos(200);

  GetFieldList(ADictionary);
  SetProgressPos(300);

  GetPrimaryKeys(ADictionary);
  SetProgressPos(400);

  GetTriggers(ADictionary);
  SetProgressPos(500);

  GetConstraints(ADictionary);
  SetProgressPos(600);

  GetIndexes(ADictionary);
  SetProgressPos(700);

  GetRelationships(ADictionary);
  SetProgressPos(800);

  GetViews(ADictionary);
  SetProgressPos(900);

  GetProcedures(ADictionary);
  SetProgressPos(1000);

  GetSequences(ADictionary);
  SetProgressPos(1100);
end;

procedure TFirebirdBaseRetriever.GetDomains(ADictionary: TGDAODatabase);
var
  newDomain: TGDAODomain;
begin
  ADictionary.Domains.Clear;
  Module.Open(
    'select '#13#10+
    'RDB$FIELD_NAME as DOMAIN_NAME, '#13#10+
    'COALESCE(RDB$CHARACTER_LENGTH, RDB$FIELD_LENGTH) as FIELD_LENGTH, '#13#10+
    'RDB$FIELD_SCALE as FIELD_SCALE, '#13#10+
    'RDB$FIELD_TYPE as DATA_TYPE, '#13#10+
    'RDB$NULL_FLAG as DOMAIN_NULL_FLAG, '#13#10+
    'RDB$FIELD_SUB_TYPE as FIELD_SUBTYPE, '#13#10+
    'RDB$SEGMENT_LENGTH as SEGMENT_LENGTH, '#13#10+
    'RDB$DEFAULT_SOURCE as DOMAIN_DEFAULT, '#13#10+
    'RDB$COLLATION_ID, '#13#10+
    'RDB$CHARACTER_SET_ID, '#13#10+
    'RDB$DIMENSIONS, '#13#10+
    'RDB$VALIDATION_SOURCE as DOMAIN_CHECK, '#13#10+
    'RDB$SYSTEM_FLAG, '#13#10+
    'RDB$COMPUTED_SOURCE as COMPUTED_SOURCE, '#13#10+
    'RDB$CHARACTER_LENGTH as FIELD_CHAR_LENGTH, '#13#10+
    'RDB$DESCRIPTION as DESCRIPTION, '#13#10+
    'RDB$FIELD_PRECISION as FIELD_PRECISION '#13#10+
    'from RDB$FIELDS '#13#10+
    'where ((RDB$SYSTEM_FLAG = 0) OR (RDB$SYSTEM_FLAG IS NULL)) '#13#10+
    '  and not (RDB$FIELD_NAME LIKE ''RDB$%'') '#13#10+
    'order by RDB$FIELD_NAME');

  while not Module.EOF do
  begin
    {Basic field information: name and required}
    newDomain := ADictionary.Domains.Add;
    newDomain.Name := Module.FieldAsString('DOMAIN_NAME');
    newDomain.Information := Module.FieldAsString('DESCRIPTION');
//      newDomain.Required := Module.FieldAsBoolean('DOMAIN_NULL_FLAG');
    newDomain.InDatabase := true;

    {init default datatype and size values}
    newDomain.DataType := nil;
    newDomain.Size := 0;
    newDomain.Size2 := 0;
    newDomain.Required := Module.FieldAsInteger('DOMAIN_NULL_FLAG') = 1;

    {default value}
    newDomain.DefaultValue := ExtractFBDefaultValue(Module.FieldAsString('DOMAIN_DEFAULT'));
    newDomain.ConstraintExpr := ExtractFBCheckExpression(Module.FieldAsString('DOMAIN_CHECK'));

    {Check if field is computed, otherwise retrieve regular data type
     size, precision and scale}
    if Module.FieldAsString('COMPUTED_SOURCE') <> '' then
    begin
      newDomain.DataTypeName := 'computed';
      //newDomain.Expression := Module.FieldAs('COMPUTED_SOURCE');
    end
    else
    begin
      with GetFieldDefinition(
        Module.FieldAsInteger('DATA_TYPE'),
        Module.FieldAsInteger('FIELD_LENGTH'),
        Module.FieldAsInteger('FIELD_PRECISION'),
        Module.FieldAsInteger('FIELD_SCALE'),
        Module.FieldAsInteger('FIELD_SUBTYPE'),
        Module.FieldAsInteger('SEGMENT_LENGTH')) do
      begin
        newDomain.DataTypeName := _DataTypeName;
        newDomain.Size         := _Size;
        newDomain.Size2        := _Precision;
      end;
    end;
    Module.Next;
  end;
end;

function TFirebirdBaseRetriever.GetFieldDefinition(AType, ASize, APrecision,
  AScale, ASubType, ASegment: integer): TFieldDefinitionRec;

  procedure SetIntSubType;
  begin
    with result do
      case ASubType of
        1 : begin
              _DataTypeName := 'Numeric';
              _Size         := APrecision;
              _Precision    := abs(AScale);
            end;
        2 : begin
              _DataTypeName := 'Decimal';
              _Size         := APrecision;
              _Precision    := abs(AScale);
            end;
      end;
  end;

  procedure SetBlobSubType;
  begin
    with result do
      case ASubType of
        1 : begin
              _DataTypeName := 'Blob text';
            end;
      end;
  end;

const
  fb__blob = 261;
  fb__cstring = 40;
  fb__char = 14;
  fb__dfloat = 11;
  fb__double = 27;
  fb__float = 10;
  fb__int64 = 16;
  fb__integer = 8;
  fb__quad = 9;
  fb__smallint = 7;
  fb__date = 12;
  fb__time = 13;
  fb__timestamp = 35;
  fb__varchar = 37;
  fb__boolean = 23;
  ib__boolean = 17;
begin
   with Result do
   begin
      _DataTypeName := '___unknown____';
      _Size      := 0;
      _Precision := 0;
      case AType of
        fb__blob,
        fb__cstring,
        fb__dfloat,
        fb__quad:
          begin
            _DataTypeName := 'Blob';
            _Size := ASegment;
            SetBlobSubType;
          end;

        fb__char:
          begin
            _DataTypeName := 'Char';
            _Size         := ASize;
          end;

        fb__double:
          begin
            _DataTypeName := 'Double precision';
          end;

        fb__float:
          _DataTypeName := 'Float';

        fb__date:
          _DataTypeName := 'Date';

        fb__time:
          _DataTypeName := 'Time';

        fb__timestamp:
          _DataTypeName := 'Timestamp';

        fb__varchar:
          begin
            _DataTypeName := 'Varchar';
            _Size         := ASize;
          end;

        fb__smallint:
          begin
            _DataTypeName := 'Smallint';
            SetIntSubType;
          end;

        fb__integer:
          begin
            _DataTypeName := 'Integer';
            SetIntSubType;
          end;

        fb__int64:
          begin
            _DataTypeName := 'Bigint';
            SetIntSubType;
          end;

        fb__boolean, ib__boolean:
          _DataTypeName := 'Boolean';
      end;
  end;
end;

procedure TFirebirdBaseRetriever.GetFieldList(ADictionary: TGDAODatabase);
var
  ATable: TGDAOTable;
  newField: TGDAOField;
  IdentityCondition: string;
  Seed, Increment: Integer;
begin
  if Self is TFirebird3DataRetriever then
    IdentityCondition :=
      'f.RDB$IDENTITY_TYPE as IDENTITY_TYPE, '#13#10+
      'f.RDB$GENERATOR_NAME as GENERATOR_NAME, '#13#10
  else
    IdentityCondition :=
      'CAST(NULL AS INTEGER) as IDENTITY_TYPE, '#13#10+
      'CAST(NULL AS VARCHAR(50)) as GENERATOR_NAME, '#13#10;

  Module.Open(
    'select '+
    'f.rdb$relation_name as TABLE_NAME, '#13#10+
    'f.rdb$field_name as COLUMN_NAME, '#13#10+
    'f.rdb$null_flag as NULL_FLAG, '#13#10+
    'f.rdb$default_source as COLUMN_DEFAULT, '#13#10+
    'fs.rdb$null_flag as DOMAIN_NULL_FLAG, '#13#10+
    'fs.rdb$field_name as DOMAIN_NAME, '#13#10+
    'fs.rdb$field_type as DATA_TYPE, '#13#10+
    'COALESCE(fs.RDB$CHARACTER_LENGTH, fs.RDB$FIELD_LENGTH) as FIELD_LENGTH, '#13#10+
    'fs.rdb$field_scale as FIELD_SCALE, '#13#10+
    'fs.rdb$field_precision as FIELD_PRECISION, '#13#10+
    'fs.rdb$field_sub_type as FIELD_SUBTYPE, '#13#10+
    'fs.rdb$segment_length as SEGMENT_LENGTH, '#13#10+
    'fs.rdb$default_source as DOMAIN_DEFAULT, '#13#10+
    'fs.rdb$character_length as FIELD_CHAR_LENGTH, '#13#10+
    'fs.rdb$computed_source as COMPUTED_SOURCE, '#13#10+
    'fs.rdb$dimensions, '#13#10+
    'd.rdb$dimension, d.rdb$lower_bound, d.rdb$upper_bound, fs.rdb$character_set_id, '#13#10+
    'f.rdb$field_source, '#13#10+
    'f.rdb$collation_id, cr.rdb$character_set_name, co.rdb$collation_name, '#13#10+
    'f.rdb$field_position, '#13#10+
    'f.rdb$description as DESCRIPTION, '#13#10+
    IdentityCondition +
    'fs.rdb$collation_id '#13#10+
    'from rdb$relation_fields f '#13#10+
    'left join rdb$fields fs on fs.rdb$field_name = f.rdb$field_source '#13#10+
    'left join rdb$field_dimensions d on d.rdb$field_name = fs.rdb$field_name '#13#10+
    'left join rdb$character_sets cr on fs.rdb$character_set_id = cr.rdb$character_set_id '#13#10+
    'left join rdb$collations co on ((f.rdb$collation_id = co.rdb$collation_id) and '#13#10+
    '(fs.rdb$character_set_id = co.rdb$character_set_id)) '#13#10+
    'order by f.rdb$relation_name, f.rdb$field_position, d.rdb$dimension');

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
        Module.FieldAsInteger('NULL_FLAG') = 1 {null_flag = 1 means field required});
      newField.Description := Module.FieldAsString('DESCRIPTION');

      {default value}
      newField.DefaultValue := ExtractFBDefaultValue(Module.FieldAsString('COLUMN_DEFAULT'));

      {if data type is a domain, then just set the domain. Otherwise, retrieve
       the data type manually}
       if ADictionary.Domains.FindByName(Module.FieldAsString('DOMAIN_NAME')) <> nil then
       begin
         if newField.DefaultValue <> '' then
           newField.DefaultValueSpecific := true;

         newField.DomainName := Module.FieldAsString('DOMAIN_NAME');
         if Assigned(newField.Domain) and (newField.Domain.Required <> newField.Required) then
           newField.RequiredSpecific := true;
       end else
       begin
         {Check if field is computed, otherwise retrieve regular data type
          size, precision and scale}
         if Module.FieldAsString('COMPUTED_SOURCE') <> '' then
         begin
           newField.DataTypeName := 'computed';
           newField.Expression := Module.FieldAsString('COMPUTED_SOURCE');
         end
         else
         begin
           with GetFieldDefinition(
             Module.FieldAsInteger('DATA_TYPE'),
             Module.FieldAsInteger('FIELD_LENGTH'),
             Module.FieldAsInteger('FIELD_PRECISION'),
             Module.FieldAsInteger('FIELD_SCALE'),
             Module.FieldAsInteger('FIELD_SUBTYPE'),
             Module.FieldAsInteger('SEGMENT_LENGTH')) do
           begin
             newField.DataTypeName := _DataTypeName;
             newField.Size         := _Size;
             newField.Size2        := _Precision;
           end;

           // Check if field is identity
           if Module.FieldAsInteger('IDENTITY_TYPE') = 1 then
           begin
             newField.DataTypeName := newField.DataTypeName + ' (Identity)';
             GetSeedAndIncrement(Module.FieldAsString('GENERATOR_NAME'), Seed, Increment);
             newField.SeedValue := Seed;
             newField.IncrementValue := Increment;
           end;
         end;
       end;
    end;
    Module.Next;
  end;
end;

procedure TFirebirdBaseRetriever.GetIndexes(ADictionary: TGDAODatabase);
var
  AIndex: TGDAOIndex;
  ATable: TGDAOTable;
  t: integer;
begin
  for t := 0 to ADictionary.Tables.Count - 1 do
    ADictionary.Tables[t].Indexes.Clear;

  {Get unique constraints (indexes that are unique keys)}
  ATable := nil;
  AIndex := nil;
  Module.Open(
    'select '+
    'rc.rdb$constraint_name as INDEX_NAME, '#13#10+
    'rc.rdb$relation_name as TABLE_NAME, '#13#10+
    'i.rdb$field_name as FIELD_NAME, '#13#10+
//      'rc.rdb$index_name, '#13#10+
    'idx.rdb$index_type as INDEX_TYPE'#13#10+
    'from rdb$relation_constraints rc, rdb$index_segments i, rdb$indices idx '#13#10+
    'where (i.rdb$index_name = rc.rdb$index_name) and '#13#10+
    '(idx.rdb$index_name = rc.rdb$index_name) and '#13#10+
    '(rc.rdb$constraint_type = ''UNIQUE'') '#13#10+
    'order by rc.rdb$relation_name, rc.rdb$constraint_name, i.rdb$field_position');
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
        AIndex.IndexOrder :=
          TIndexOrder(Module.FieldAsInteger('INDEX_TYPE'));
      end;

      if AIndex <> nil then
      begin
        AIndex.IndexType := itUniqueKey;
        AIndex.IFields.Add(Module.FieldAsString('FIELD_NAME'));
      end;
    end;
    Module.Next;
  end;


  {Get indexes (exclusive and no-exclusive)}
  ATable := nil;
  AIndex := nil;
  Module.Open(
    'select i.rdb$index_name as INDEX_NAME, '#13#10+
    'i.rdb$relation_name as TABLE_NAME, '#13#10+
    'i.rdb$unique_flag as UNIQUE_FLAG, '#13#10+
    'i.rdb$index_inactive, '#13#10+
    'i.rdb$index_type as INDEX_TYPE, '#13#10+
    'isg.rdb$field_name as FIELD_NAME, '#13#10+
    'isg.rdb$field_position, '#13#10+
    'i.rdb$statistics, '#13#10+
    'i.rdb$expression_source, '#13#10+
    'c.RDB$CONSTRAINT_TYPE, '#13#10+
    'c.RDB$CONSTRAINT_NAME, '#13#10+
    'i.RDB$DESCRIPTION as DESCRIPTION '#13#10+
    'from rdb$indices i '#13#10+
    'LEFT JOIN rdb$index_segments isg ON (isg.rdb$index_name = i.rdb$index_name) '#13#10+
    'LEFT JOIN rdb$relation_constraints c ON (i.rdb$index_name = c.rdb$index_name) '#13#10+
    'where ((rdb$system_flag is null) or (rdb$system_flag = 0)) and '#13#10+
    'c.rdb$constraint_name is null '#13#10+
    'order by i.rdb$relation_name, i.rdb$index_name, isg.rdb$field_position');
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
        AIndex.IndexOrder := TIndexOrder(Module.FieldAsInteger('INDEX_TYPE'));
      end;

      if AIndex <> nil then
      begin
        if Module.FieldAsInteger('UNIQUE_FLAG') = 1 then
          AIndex.IndexType := itUnique;
        AIndex.IFields.Add(Module.FieldAsString('FIELD_NAME'))
      end;
    end;
    Module.Next;
  end;
end;

procedure TFirebirdBaseRetriever.GetPrimaryKeys(ADictionary: TGDAODatabase);
var
  ATable: TGDAOTable;
  AField: TGDAOField;
begin
  Module.Open(
    'select rc.rdb$constraint_name as CONSTRAINT_NAME, '#13#10+
    'rc.rdb$relation_name as TABLE_NAME, '#13#10+
    'i.rdb$field_name as COLUMN_NAME, '#13#10+
    'i.rdb$field_position as ORDINAL_POSITION, '#13#10+
    'rc.rdb$index_name, '#13#10+
    'idx.rdb$index_type '#13#10+
    'from rdb$relation_constraints rc, rdb$index_segments i, rdb$indices idx '#13#10+
    'where (i.rdb$index_name = rc.rdb$index_name) and '#13#10+
    '(idx.rdb$index_name = rc.rdb$index_name) and '#13#10+
    '(rc.rdb$constraint_type = ''PRIMARY KEY'') '#13#10+
    'order by rc.rdb$relation_name, rc.rdb$constraint_name, i.rdb$field_position');
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

procedure TFirebirdBaseRetriever.GetProcedures(ADictionary: TGDAODatabase);
var
  AProcedure: TGDAOObject;
  AProcedures: TGDAOObjects;
  c: integer;

  ATempField: TGDAOField;
  ATempType: TGDAODataType;
  ATempFieldRec: TFieldDefinitionRec;
  AParamStr: string;
  AInputs: string;
  AOutputs: string;
begin
  if ADictionary.Categories.FindByType(ctProcedure) <> nil then
  begin
    {Add all procedures (only names)}
    AProcedures := ADictionary.Categories.FindByType(ctProcedure).Objects;
    AProcedures.Clear;
    Module.Open(
      'select '#13#10+
      'RDB$PROCEDURE_NAME as PROCEDURE_NAME, '#13#10+
      'RDB$DESCRIPTION as DESCRIPTION '#13#10+
      'from RDB$PROCEDURES '#13#10+
      'where RDB$SYSTEM_FLAG is null or RDB$SYSTEM_FLAG=0 '#13#10+
      'order by RDB$PROCEDURE_NAME');
    while not Module.EOF do
    begin
      AProcedure := AProcedures.Add(Module.FieldAsString('PROCEDURE_NAME'));
      AProcedure.Description := Module.FieldAsString('DESCRIPTION');
      AProcedure.DropImplementation := AProcedure.OwnerCategory.DropTemplate;
      Module.Next;
    end;

    ATempField := TGDAOField.Create(nil);
    try
      {Now get the source code for the procedures}
      for c := 0 to AProcedures.Count - 1 do
      begin
        AProcedure := AProcedures[c];
        AInputs := '';
        AOutputs := '';
        Module.Open( Format(
          'select '#13#10+
          'pr.rdb$procedure_source as PROCEDURE_SOURCE, '#13#10+
          'pp.rdb$parameter_name as PARAM_NAME, '#13#10+
          'pp.rdb$parameter_type as PARAM_TYPE, '#13#10+
          'fs.rdb$field_type as FIELD_TYPE, '#13#10+
          'COALESCE(fs.RDB$CHARACTER_LENGTH, fs.RDB$FIELD_LENGTH) as FIELD_SIZE, '#13#10+
          'fs.rdb$field_scale as FIELD_SCALE, '#13#10+
          'fs.rdb$field_sub_type as FIELD_SUBTYPE, '#13#10+
          'fs.rdb$segment_length as FIELD_SEGMENTSIZE, '#13#10+
          'fs.rdb$character_length, '#13#10+
          'fs.rdb$field_precision as FIELD_PRECISION '#13#10+
          'from rdb$procedures pr '#13#10+
          'left join rdb$procedure_parameters pp on pp.rdb$procedure_name = pr.rdb$procedure_name '#13#10+
          'left join rdb$fields fs on fs.rdb$field_name = pp.rdb$field_source '#13#10+
          'where pr.rdb$procedure_name = ''%s'' '#13#10+
          'order by pp.rdb$parameter_type, pp.rdb$parameter_number',
          [AProcedure.ObjectName]));
        while not Module.EOF do
        begin
          ATempFieldRec := GetFieldDefinition(
            Module.FieldAsInteger('FIELD_TYPE'),
            Module.FieldAsInteger('FIELD_SIZE'),
            Module.FieldAsInteger('FIELD_PRECISION'),
            Module.FieldAsInteger('FIELD_SCALE'),
            Module.FieldAsInteger('FIELD_SUBTYPE'),
            Module.FieldAsInteger('FIELD_SEGMENTSIZE'));
          ATempType := ADictionary.DataTypes.FindByName(ATempFieldRec._DataTypeName);
          if ATempType <> nil then
          begin
            ATempField.Size := ATempFieldRec._Size;
            ATempField.Size2 := ATempFieldRec._Precision;

            {build the param name + param type}
            AParamStr := Format('%s %s', [
              Module.FieldAsString('PARAM_NAME'),
              ATempType.BuildPhysicalExpression(ATempField)
              ]);

            if Module.FieldAsInteger('PARAM_TYPE') = 1 then //output
            begin
              if AOutputs <> '' then
                AOutputs := AOutputs + ', '#13#10;
              AOutputs := AOutputs + '  ' + AParamStr;
            end else
            begin
              if AInputs <> '' then
                AInputs := AInputs + ', '#13#10;
              AInputs := AInputs + '  ' + AParamStr;
            end;
          end;

          Module.Next;
        end;

        if AInputs <> '' then
          AInputs := '('#13#10 + AInputs + ')';
        if AOutputs <> '' then
          AOutputs := #13#10'RETURNS ('#13#10 + AOutputs + ')';

        AProcedure.CreateImplementation := ConvertLineFeeds(Format(
          'CREATE PROCEDURE <%%%s%%> %s %s '#13#10+
          'AS '#13#10+
          '%s',
          [NativeIdName[niObjectName],
           AInputs,
           AOutputs,
           Module.FieldAsString('PROCEDURE_SOURCE')
          ]));
      end;
    finally
      ATempField.Free;
    end;
  end;
end;

procedure TFirebirdBaseRetriever.GetRelationships(ADictionary: TGDAODatabase);
var
  ARelationship: TGDAORelationship;
  S: string;
begin
  Module.Open(
    'select '#13#10+
    'C.RDB$RELATION_NAME as PK_TABLE_NAME, '#13#10+
    'A.RDB$RELATION_NAME as FK_TABLE_NAME, '#13#10+
    'D.RDB$FIELD_NAME as PK_COLUMN_NAME, '#13#10+
    'E.RDB$FIELD_NAME as FK_COLUMN_NAME, '#13#10+
    'A.RDB$CONSTRAINT_NAME as CONSTRAINT_NAME, '#13#10+
    'B.RDB$UPDATE_RULE as UPDATE_RULE, '#13#10+
    'B.RDB$DELETE_RULE as DELETE_RULE, '#13#10+
    'A.RDB$INDEX_NAME, '#13#10+
    'I.RDB$INDEX_TYPE '#13#10+
    'from RDB$REF_CONSTRAINTS B, RDB$RELATION_CONSTRAINTS A, RDB$RELATION_CONSTRAINTS C, '#13#10+
    'RDB$INDEX_SEGMENTS D, RDB$INDEX_SEGMENTS E, RDB$INDICES I '#13#10+
    'where (A.RDB$CONSTRAINT_TYPE = ''FOREIGN KEY'') and '#13#10+
    '(A.RDB$CONSTRAINT_NAME = B.RDB$CONSTRAINT_NAME) and '#13#10+
    '(B.RDB$CONST_NAME_UQ=C.RDB$CONSTRAINT_NAME) and '#13#10+
    '(C.RDB$INDEX_NAME=D.RDB$INDEX_NAME) and '#13#10+
    '(A.RDB$INDEX_NAME=E.RDB$INDEX_NAME) and '#13#10+
    '(A.RDB$INDEX_NAME=I.RDB$INDEX_NAME) and '#13#10+
    '(D.RDB$FIELD_POSITION = E.RDB$FIELD_POSITION) '#13#10+
    'order by A.RDB$RELATION_NAME, A.RDB$CONSTRAINT_NAME,  '#13#10+
    'D.RDB$FIELD_POSITION, E.RDB$FIELD_POSITION');
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
    if S = 'SET NULL' then
      ARelationship.UpdateMethod := umSetNull
    else
    if S = 'SET DEFAULT' then
      ARelationship.UpdateMethod := umSetDefault
    else
      ARelationship.UpdateMethod := umRestrict;

    {Set delete rule}
    S := Module.FieldAsString('DELETE_RULE');
    if S = 'CASCADE' then
      ARelationship.DeleteMethod := dmCascade
    else
    if S = 'SET NULL' then
      ARelationship.DeleteMethod := dmSetNull
    else
    if S = 'SET DEFAULT' then
      ARelationship.DeleteMethod := dmSetDefault
    else
      ARelationship.DeleteMethod := dmRestrict;

    Module.Next;
  end;
end;

procedure TFirebirdBaseRetriever.GetSeedAndIncrement(GenName: string; var Seed,
  Increment: Integer);
var
  Query: TSQLModule;
begin
  Seed := 0;
  Increment := 1;
  Query := ModuleFactory.NewSQLModule;
  try
    Query.Open(Format(
      'select RDB$INITIAL_VALUE as GEN_SEED, ' +
      'RDB$GENERATOR_INCREMENT as GEN_INCREMENT ' +
      'from RDB$GENERATORS ' +
      'where RDB$GENERATOR_NAME = ''%s'' ',
      [GenName]));
    if not Query.EOF then
    begin
      Seed := Query.FieldAsInteger('GEN_SEED');
      Increment := Query.FieldAsInteger('GEN_INCREMENT');
    end
  finally
    Query.Free;
  end;
end;

procedure TFirebirdBaseRetriever.GetSequences(ADictionary: TGDAODatabase);
var
  ASequence: TGDAOObject;
  ASequences: TGDAOObjects;
begin
  if ADictionary.Categories.FindByType(ctSequence) <> nil then
  begin
    ASequences := ADictionary.Categories.FindByType(ctSequence).Objects;
    ASequences.Clear;
    Module.Open(
      'select RDB$GENERATOR_NAME AS SEQUENCE_NAME '#13#10 +
//        'RDB$DESCRIPTION AS DESCRIPTION '#13#10+ // do not use descriptions for now, it causes error sometimes
      'from RDB$GENERATORS '#13#10 +
      'where (RDB$SYSTEM_FLAG is NULL) or (RDB$SYSTEM_FLAG <> 1) '#13#10+
      'order by RDB$GENERATOR_NAME ');
    while not Module.EOF do
    begin
      ASequence := ASequences.FindByName(Module.FieldAsString('SEQUENCE_NAME'));
      if ASequence = nil then
        ASequence := ASequences.Add(Module.FieldAsString('SEQUENCE_NAME'));

//        ASequence.Description := Module.FieldAsString('DESCRIPTION');
      ASequence.DropImplementation := ASequence.OwnerCategory.DropTemplate;
      ASequence.CreateImplementation := ASequence.OwnerCategory.CreateTemplate;
      Module.Next;
    end;
  end;
end;

procedure TFirebirdBaseRetriever.GetTables(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  ViewFilter: string;
begin
  if RetrieveViewAsTables then
    ViewFilter := ''
  else
    ViewFilter := 'RDB$VIEW_BLR IS NULL AND ';

  ADictionary.Tables.Clear;
  Module.Open(
    'SELECT RDB$RELATION_NAME AS TABLE_NAME, RDB$DESCRIPTION AS DESCRIPTION, '+
    '  RDB$VIEW_BLR as VIEW_BLR '+
    'FROM RDB$RELATIONS '+
    'WHERE ' +
    ViewFilter +
    '(RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL) '+
    'ORDER BY RDB$RELATION_NAME');
  while not Module.EOF do
  begin
    table := ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME'));
    table.Description := Module.FieldAsString('DESCRIPTION');
    table.IsView := Module.FieldAsString('VIEW_BLR') <> '';
    Module.Next;
  end;
end;

procedure TFirebirdBaseRetriever.GetTriggers(ADictionary: TGDAODatabase);
type
  TFBTriggerEvent = (teBefore, teAfter);
  TFBTriggerOperation = (toNone, toInsert, toUpdate, toDelete);
const
  _TA_Inactive: array[boolean] of string = ('ACTIVE', 'INACTIVE');
  _TA_Event: array[TFBTriggerEvent] of string = ('BEFORE', 'AFTER');
  _TA_Operation: array[TFBTriggerOperation] of string = ('', 'INSERT', 'UPDATE', 'DELETE');
var
  ATable: TGDAOTable;
  newTrigger: TGDAOTrigger;

  AInactive: boolean;
  AEvent: TFBTriggerEvent;
  ATypeFlag: integer;
  AOperation: TFBTriggerOperation;
  AOperationStr: string;
  APosition: integer;
  i: integer;
begin
  Module.Open(
    'select '#13#10+
    'T.RDB$TRIGGER_NAME as TRIGGER_NAME, '#13#10+
    'T.RDB$RELATION_NAME as TABLE_NAME, '#13#10+
    'T.RDB$TRIGGER_SEQUENCE as TRIGGER_SEQUENCE, '#13#10+
    'T.RDB$TRIGGER_TYPE as TRIGGER_TYPE, '#13#10+
    'T.RDB$TRIGGER_INACTIVE as TRIGGER_INACTIVE, '#13#10+
    'T.RDB$DESCRIPTION as DESCRIPTION, '#13#10+
    'T.RDB$TRIGGER_SOURCE as TRIGGER_BODY '#13#10+
    'from RDB$TRIGGERS T '#13#10+
    'left join RDB$CHECK_CONSTRAINTS C ON C.RDB$TRIGGER_NAME = T.RDB$TRIGGER_NAME '#13#10+
    'where ((T.RDB$SYSTEM_FLAG = 0) or (T.RDB$SYSTEM_FLAG is null)) '#13#10+
    'and (C.RDB$TRIGGER_NAME is NULL) '#13#10+
    'order by T.RDB$RELATION_NAME, T.RDB$TRIGGER_NAME');

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
      newTrigger.Name := Module.FieldAsString('TRIGGER_NAME');;
      newTrigger.Description := Module.FieldAsString('DESCRIPTION');

      {Get trigger parameters}
      AInactive := Module.FieldAsInteger('TRIGGER_INACTIVE') = 1;
      APosition := Module.FieldAsInteger('TRIGGER_SEQUENCE');
      ATypeFlag := Module.FieldAsInteger('TRIGGER_TYPE') + 1;
      AOperationStr := '';
      if (ATypeFlag and 1) = 1 then
        AEvent := teAfter
      else
        AEvent := teBefore;
      ATypeFlag := ATypeFlag shr 1;
      for i := 1 to 3 do
      begin
        case ATypeFlag and 3 of
          1: AOperation := toInsert;
          2: AOperation := toUpdate;
          3: AOperation := toDelete;
        else
          AOperation := toNone;
        end;
        if AOperation <> toNone then
        begin
          if AOperationStr <> '' then
            AOperationStr := AOperationStr + ' OR ';
          AOperationStr := AOperationStr + _TA_Operation[AOperation];
        end;
        ATypeFlag := ATypeFlag shr 2;
      end;
      {just in case, force an operation - this code shuold not be needed
       because at least a single operation shuold be present in the trigger type}
      if AOperationStr = '' then
        AOperationStr := _TA_Operation[toInsert];

      {Now build implementation code}
      newTrigger.ImplementationCode :=
        ConvertLineFeeds(
          Format(
            'CREATE OR ALTER TRIGGER <%%%s%%> FOR <%%%s%%> '#13#10+
            '%s %s %s POSITION %d '#13#10+
            '%s',
            [NativeIdName[niTriggerName],
             NativeIdName[niTableName],
             _TA_Inactive[AInactive],
             _TA_Event[AEvent],
             AOperationStr,
             APosition,
             Module.FieldAsString('TRIGGER_BODY')]));
    end;
    Module.Next;
  end;
end;

procedure TFirebirdBaseRetriever.GetViews(ADictionary: TGDAODatabase);
var
  AView: TGDAOObject;
  AViews: TGDAOObjects;
  AFields: string;
begin
  if ADictionary.Categories.FindByType(ctView) <> nil then
  begin
    AViews := ADictionary.Categories.FindByType(ctView).Objects;
    AViews.Clear;
    Module.Open(
      'SELECT '#13#10+
      'R.RDB$RELATION_NAME as VIEW_NAME, '#13#10+
      'R.RDB$DESCRIPTION as DESCRIPTION, '#13#10+
      'R.RDB$VIEW_SOURCE as VIEW_DEFINITION, '#13#10+
      'F.RDB$FIELD_NAME as VIEW_COLUMN '#13#10+
      'FROM RDB$RELATIONS R, RDB$RELATION_FIELDS F '#13#10+
      'WHERE R.RDB$RELATION_NAME = F.RDB$RELATION_NAME AND '#13#10+
      '(RDB$VIEW_BLR IS NOT NULL) '#13#10+
      'ORDER BY R.RDB$RELATION_NAME, F.RDB$FIELD_POSITION');
    AFields := '';
    while not Module.EOF do
    begin
      AView := AViews.FindByName(Module.FieldAsString('VIEW_NAME'));
      if AView = nil then
      begin
        AView := AViews.Add(Module.FieldAsString('VIEW_NAME'));
        AView.Description := Module.FieldAsString('DESCRIPTION');
        AFields := '';
      end;

      if AFields > '' then
        AFields := AFields + ', '#13#10;
      AFields := AFields + '   ' + Module.FieldAsString('VIEW_COLUMN');

      AView.DropImplementation := AView.OwnerCategory.DropTemplate;
      AView.CreateImplementation := ConvertLineFeeds(Format(
        'CREATE VIEW <%%%s%%>('#13#10+
        '%s) '#13#10+
        'AS '+
        '%s',
        [NativeIdName[niObjectName],
         AFields,
         Module.FieldAsString('VIEW_DEFINITION')]
        ));
      Module.Next;
    end;
  end;
end;

{ TFirebird2DataRetriever }

function TFirebird2DataRetriever.CheckDatabaseVersion: boolean;
begin
  Result := CheckFirebirdVersion(TFirebirdEdition.fb2);
end;

{ TFirebird3DataRetriever }

function TFirebird3DataRetriever.CheckDatabaseVersion: boolean;
begin
  Result := CheckFirebirdVersion(TFirebirdEdition.fb3);
end;

{ TInterbase2017DataRetriever }

function TInterbase2017DataRetriever.CheckDatabaseVersion: boolean;
begin
  Result := CheckFirebirdVersion(TFirebirdEdition.ib2017);
end;

end.

