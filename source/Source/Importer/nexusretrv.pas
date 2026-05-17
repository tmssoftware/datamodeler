unit nexusretrv;

{$I ../../dm.inc}

{$IFDEF NEXUSDB}

interface

uses
  uSQLModule, SysUtils, Classes, Dialogs, DB, qryretrv, uGDAO, dgConsts;

type
   TFieldDefinitionRec = record
      _DataTypeName: String;
      _Size,_Precision: integer;
   end;

  TNexusDBDataRetriever = class(TDataRetriever)
  private
    function GetFieldDefinition(ADatatype: String; AUnits, ADecimals: Integer): TFieldDefinitionRec;
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
  end;

implementation

uses
  uDatasetModule, nxsdTypes, nxdb;

{ TNexusDBDataRetriever }

type
  TnxCrackMemoField = class(TnxMemoField)
  end;

  TInternalSQLModule = class(TSQLModule)
  end;

procedure TNexusDBDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);

  function GetWideStringFieldAsString(FieldName: string): string;
  var
    F: TField;
  begin
    F := TDatasetModule(Module).Dataset.FieldByName(FieldName);
    if F is TnxMemoField then
      result := WideCharToString(PWideChar(TnxMemoField(F).AsWideString))
    else
      result := F.AsString;
  end;

  procedure ConvertWideMemoFields(SQLMod: TSQLModule);
  var
    NQ: TnxQuery;
    i: integer;
    Q: TDataset;
  begin
    Q := TDatasetModule(SQLMod).Dataset;
    if Q is TnxQuery then
    begin
      NQ := TnxQuery(Q);
      for i := 0 to NQ.Fields.Count - 1 do
        if NQ.Fields[i] is TnxMemoField then
          TnxCrackMemoField(NQ.Fields[i]).mfIsWide := True;
    end;

  end;

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open(
      'SELECT TABLE_NAME, TABLE_DESCRIPTION FROM #TABLES ORDER BY TABLE_NAME');
    while not Module.EOF do
    begin
      with ADictionary.Tables.Add(Module.FieldAsString('TABLE_NAME')) do
        Description := Module.FieldAsString('TABLE_DESCRIPTION');
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    ATable: TGDAOTable;
    newField: TGDAOField;
  begin
    Module.Open(
      'select '+
      'F.TABLE_NAME as TABLE_NAME, '#13#10+
      'F.FIELD_NAME as COLUMN_NAME, '#13#10+
      'F.FIELD_TYPE_NEXUS AS DATA_TYPE, '#13#10+
      'F.FIELD_UNITS AS FIELD_UNITS, '#13#10+
      'F.FIELD_DECIMALS AS FIELD_DECIMALS, '#13#10+
      'F.FIELD_REQUIRED as IS_REQUIRED, '#13#10+
      'F.FIELD_HASDEFAULT as HAS_DEFAULT, '#13#10+
      'F.FIELD_DEFAULTVALUE COLUMN_DEFAULT, '#13#10+
      'F.FIELD_DESC AS DESCRIPTION, '#13#10+
      'T.AUTOINC_STARTING_VALUE as IDENTITY_SEED, '#13#10+
      'T.AUTOINC_INCREMENT_VALUE as IDENTITY_INCREMENT '#13#10+
      'From '#13#10+
      '  #Fields F LEFT JOIN #Tables T ON F.TABLE_INDEX = T.TABLE_INDEX '#13#10+
      'Order by T.TABLE_NAME, F.FIELD_INDEX '
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
          Module.FieldAsBoolean('IS_REQUIRED'));

        {default value}
        if Module.FieldAsBoolean('HAS_DEFAULT') then
          newField.DefaultValue := Module.FieldAsString('COLUMN_DEFAULT');

        {Check if field is computed, otherwise retrieve regular data type
         size, precision and scale}
        with GetFieldDefinition(
          Module.FieldAsString('DATA_TYPE'),
          Module.FieldAsInteger('FIELD_UNITS'),
          Module.FieldAsInteger('FIELD_DECIMALS')) do
        begin
          newField.DataTypeName := _DataTypeName;
          newField.Size         := _Size;
          newField.Size2        := _Precision;
        end;

        {identity information}
        if SameText(newField.DataTypeName, 'AUTOINC') then
        begin
          newField.SeedValue := Module.FieldAsInteger('IDENTITY_SEED');
          newField.IncrementValue := Module.FieldAsInteger('IDENTITY_INCREMENT');
        end;

        newField.Description := Module.FieldAsString('DESCRIPTION');
      end;
      Module.Next;
    end;
  end;

  procedure _GetPrimaryKeys;
  var
    ATable: TGDAOTable;
    AField: TGDAOField;
    NewIField: TGDAOIField;
  begin
    Module.Open(
      'SELECT '+
      'I.TABLE_NAME, '+
      'I.INDEX_NAME, '+
      'I.CONSTRAINT_NAME, '+
      'I.INDEX_ALLOWSDUPS, '+
      'I.INDEX_ISDEFAULT, '+
      'F.SEGMENT_FIELD as COLUMN_NAME, '+
      'F.SEGMENT_ASCENDING '+
      'FROM #INDEXES I, #INDEXFIELDS F '+
      'WHERE I.TABLE_INDEX = F.TABLE_INDEX AND I.INDEX_INDEX = F.INDEX_INDEX '+
      '  AND I.INDEX_ISDEFAULT = TRUE '+
      'ORDER BY I.TABLE_INDEX, I.INDEX_INDEX, F.SEGMENT_INDEX');
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
        NewIField := ATable.PrimaryKeyIndex.IFields.Add;
        NewIField.Field := AField;
        if Module.FieldAsBoolean('SEGMENT_ASCENDING') then
          NewIField.FieldOrder := ioAsc
        else
          NewIField.FieldOrder := ioDesc;
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
      'select '+
      'TRIGGER_TARGET as TABLE_NAME, '+
      'TRIGGER_NAME, '+
      'TRIGGER_SOURCE '+
      'from #TRIGGERS '+
      'order by TRIGGER_TARGET');
    ConvertWideMemoFields(Module);
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

        newTrigger.ImplementationCode :=
          GetWideStringFieldAsString('TRIGGER_SOURCE');
      end;
      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    ATable: TGDAOTable;
  begin
    Module.Open(
      'SELECT CHECK_CONSTRAINT_TABLE_NAME as TABLE_NAME, '+
      'CHECK_CONSTRAINT_NAME as CONSTRAINT_NAME, '+
      'CHECK_CONSTRAINT_CHECK_CLAUSE as CHECK_CLAUSE '+
      'FROM #CHECK_CONSTRAINTS '+
      'ORDER BY CHECK_CONSTRAINT_TABLE_NAME, CHECK_CONSTRAINT_NAME');
    ConvertWideMemoFields(Module);
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
          GetWideStringFieldAsString('CHECK_CLAUSE'));
      end;
      Module.Next;
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
      'SELECT '+
      'I.TABLE_NAME, '+
      'I.INDEX_NAME, '+
      'I.CONSTRAINT_NAME, '+
      'I.INDEX_ALLOWSDUPS, '+
      'I.INDEX_ISDEFAULT, '+
      'F.SEGMENT_FIELD as COLUMN_NAME, '+
      'F.SEGMENT_ASCENDING '+
      'FROM #INDEXES I, #INDEXFIELDS F '+
      'WHERE I.TABLE_INDEX = F.TABLE_INDEX AND I.INDEX_INDEX = F.INDEX_INDEX '+
      '  AND (I.INDEX_ISDEFAULT = FALSE) AND NOT (I.INDEX_NAME LIKE ''$%'') '+
      'ORDER BY I.TABLE_INDEX, I.INDEX_INDEX, F.SEGMENT_INDEX');
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
          if not Module.FieldAsBoolean('INDEX_ALLOWSDUPS') then
            AIndex.IndexType := itUnique;
          if Module.FieldAsBoolean('SEGMENT_ASCENDING') then
            AIndex.IFields.Add(Module.FieldAsString('COLUMN_NAME')).FieldOrder := ioAsc
          else
            AIndex.IFields.Add(Module.FieldAsString('COLUMN_NAME')).FieldOrder := ioDesc;
        end;
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
      'SELECT'+
      '  F.FK_CONSTRAINT_REFERENCES_TABLE_NAME as PK_TABLE_NAME, '+
      '  PK.FK_CONSTRAINT_REFERENCED_COLUMNS_NAME as PK_COLUMN_NAME, '+
      '  F.FK_CONSTRAINT_TABLE_NAME as FK_TABLE_NAME, '+
      '  FK.FK_CONSTRAINT_REFERENCING_COLUMNS_NAME as FK_COLUMN_NAME, '+
      '  F.FK_CONSTRAINT_NAME as CONSTRAINT_NAME, '+
      '  F.FK_CONSTRAINT_DELETE_RULE as DELETE_RULE, '+
      '  F.FK_CONSTRAINT_UPDATE_RULE as UPDATE_RULE '+
      'FROM '+
      '  #FOREIGNKEY_CONSTRAINTS F, #FOREIGNKEY_CONSTRAINTS_REFERENCING_COLUMNS FK, '+
      '  #FOREIGNKEY_CONSTRAINTS_REFERENCED_COLUMNS PK '+
      'WHERE '+
      '  F.FK_CONSTRAINT_NAME = FK.FK_CONSTRAINT_NAME AND '+
      '  F.FK_CONSTRAINT_TABLE_NAME = FK.FK_CONSTRAINT_TABLE_NAME AND '+
      '  F.FK_CONSTRAINT_NAME = PK.FK_CONSTRAINT_NAME AND '+
      '  F.FK_CONSTRAINT_TABLE_NAME = PK.FK_CONSTRAINT_TABLE_NAME AND '+
      '  FK.FK_CONSTRAINT_REFERENCING_COLUMNS_INDEX = PK.FK_CONSTRAINT_REFERENCED_COLUMNS_INDEX '+
      'ORDER BY '+
      '  F.FK_CONSTRAINT_TABLE_NAME, F.FK_CONSTRAINT_NAME, FK.FK_CONSTRAINT_REFERENCING_COLUMNS_INDEX');

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
        'SELECT VIEW_NAME, VIEW_SOURCE '+
        'FROM #VIEWS '+
        'ORDER BY VIEW_NAME');
      ConvertWideMemoFields(Module);
      while not Module.EOF do
      begin
        AView := AViews.Add(Module.FieldAsString('VIEW_NAME'));
        AView.DropImplementation := AView.OwnerCategory.DropTemplate;
        AView.CreateImplementation := GetWideStringFieldAsString('VIEW_SOURCE');
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
        'SELECT PROCEDURE_NAME, PROCEDURE_SOURCE '+
        'FROM #PROCEDURES '+
        'ORDER BY PROCEDURE_NAME');
      ConvertWideMemoFields(Module);
      while not Module.EOF do
      begin
        AProcedure := AProcedures.Add(Module.FieldAsString('PROCEDURE_NAME'));
        AProcedure.DropImplementation := AProcedure.OwnerCategory.DropTemplate;
        AProcedure.CreateImplementation := GetWideStringFieldAsString('PROCEDURE_SOURCE');
        Module.Next;
      end;
    end;
  end;

  procedure _GetFunctions;
  var
    AProcedure: TGDAOObject;
    AProcedures: TGDAOObjects;
  begin
    if ADictionary.Categories.FindByType(ctProcedure) <> nil then
    begin
      AProcedures := ADictionary.Categories.FindByType(ctProcedure).Objects;

      {Do not clear procedures, since we called _GetProcedures first
       and we already have some procedures in the collection}
      //AProcedures.Clear;
      Module.Open(
        'SELECT FUNCTION_NAME, FUNCTION_SOURCE '+
        'FROM #FUNCTIONS '+
        'ORDER BY FUNCTION_NAME');
      ConvertWideMemoFields(Module);
      while not Module.EOF do
      begin
        AProcedure := AProcedures.Add(Module.FieldAsString('FUNCTION_NAME'));
        AProcedure.DropImplementation := AProcedure.OwnerCategory.DropTemplate;
        AProcedure.CreateImplementation := GetWideStringFieldAsString('FUNCTION_SOURCE');
        Module.Next;
      end;
    end;
  end;

begin
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
  SetProgressPos(1000);
end;

function TNexusDBDataRetriever.GetFieldDefinition(ADatatype: String; AUnits,
  ADecimals: Integer): TFieldDefinitionRec;
type
  _TMapType = (mtNexus, mtDM);
const
  _MapTypes: array[TnxFieldType, _TMapType] of string = (
  ('nxtBoolean'      , 'Boolean'),
  ('nxtChar'         , 'Singlechar'),
  ('nxtWideChar'     , 'Nsinglechar'),
  ('nxtByte'         , 'Byte'),
  ('nxtWord16'       , 'Word'),
  ('nxtWord32'       , 'Dword'),
  ('nxtInt8'         , 'Shortint'),
  ('nxtInt16'        , 'Smallint'),
  ('nxtInt32'        , 'Integer'),
  ('nxtInt64'        , 'Bigint'),
  ('nxtAutoInc'      , 'Autoinc'),
  ('nxtSingle'       , 'Float'),
  ('nxtDouble'       , 'Real'),
  ('nxtExtended'     , 'Extended'),
  ('nxtCurrency'     , 'Money'),
  ('nxtDate'         , 'Date'),
  ('nxtTime'         , 'Time'),
  ('nxtDateTime'     , 'Timestamp'),
  ('nxtInterval'     , ''), // can't be represented directly
  ('nxtBLOB'         , 'Blob'),
  ('nxtBLOBMemo'     , 'Clob'),
  ('nxtBLOBGraphic'  , 'Image'),
  ('nxtByteArray'    , 'Bytearray'),
  ('nxtShortString'  , 'Shortstring'),
  ('nxtNullString'   , 'Varchar'),
  ('nxtWideString'   , 'Nvarchar'),
  ('nxtRecRev'       , 'Recrev'),
  ('nxtGUID'         , 'Guid'),
  ('nxtBCD'          , 'Numeric'),
  ('nxtBLOBWideMemo' , 'Nclob'),
  ('nxtFmtBCD'       , 'Numeric')
{$IFNDEF NEXUSDB_NEW}
  ,('nxtRefNr'       , 'Bigint')
{$ENDIF}
  );

  _NxSizeTypes: array[0..3] of string = ('Bytearray', 'Shortstring', 'Varchar', 'Nvarchar');
  _NxSizePrecisionTypes: array[0..0] of string = ('Numeric');
  _NxPrecisionTypes: array[0..0] of string = ('Float');

  function TypeInSet(AType: string; ATypes: array of string): boolean;
  var
    c: integer;
  begin
    result := false;
    for c := Low(ATypes) to High(ATypes) do
      if SameText(AType, ATypes[c]) then
      begin
        result := true;
        break;
      end;
  end;

var
  c: TnxFieldType;
  //ntype: TnxFieldType;
begin
  result._DataTypeName := '';
  for c := Low(TnxFieldType) to High(TnxFieldType) do
    if SameText(ADatatype, _MapTypes[c, mtNexus]) then
    begin
      //ntype := c;
      result._DataTypeName := _MapTypes[c, mtDM];
      break;
    end;

  if result._DataTypeName = '' then
    raise EGUIException.Create(Format('Field type "%s" not supported in NexusDB reverse engineering.',
      [ADatatype]));

  result._Size := 0;
  result._Precision := 0;

  {Check if field needs size}
  if TypeInSet(result._DataTypeName, _NxSizeTypes) then
  begin
    result._Size := AUnits;
  end
  else
  if TypeInSet(result._DataTypeName, _NxSizePrecisionTypes) then
  begin
    result._Size := AUnits;
    result._Precision := ADecimals;
  end
  else
  if TypeInSet(result._DataTypeName, _NxPrecisionTypes) then
  begin
    result._Size := ADecimals;
  end;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

