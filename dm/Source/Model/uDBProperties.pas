unit uDBProperties;

interface

uses
  Classes, SysUtils, uGDAO, dgConsts, uDataTypeConversion, dgDBTypes;

type
  EConvertException = class(Exception);

  TDBProperties = class
  private
    class function InternalConvertDataType(ADataType: TGDAODataType;
      ATargetDataTypes: TGDAODataTypes;
      ANativeDataType: TNativeDataType): TGDAODataType; static;
    class function ConvertDataType(ADataType: TGDAODataType; ATargetDataTypes: TGDAODataTypes;
      ANativeDataType: TNativeDataType = naUnknown): TGDAODataType;

    class function GetMainNativeSubDataType(ANativeDataType: TNativeDataType): TNativeSubType;
    class function GetNextNativeDataType(ANativeDataType: TNativeDataType): TNativeDataType;
  public
    class procedure CopyDictionary(ASource, ATarget: TGDAODatabase);
    class procedure FillDataTypesObject(ADBType: TDatabaseType; ADataTypes: TGDAODataTypes);
    class procedure AllocObjectCategories(ADatabase: TGDAODatabase);
    class function GetFixedDatabaseType(ADBType: TDatabaseType): TFixedDBType;
    class procedure FillDatabaseTypes(AList: TStrings; AEmptyItem: string);
    class procedure LoadAll(ADatabase: TGDAODatabase);
    class procedure ConvertDataBaseType(ADatabase: TGDAODatabase; AConversionMap: TDataTypeConversionMap);
    class procedure FillDefaultConversionItems(AItems: TDataTypeConversionItems;
      Source, Target: TDatabaseType); static;
    //class procedure FillDefaultConversionMap(AMap: TDataTypeConversionMap; Source, Target: TDatabaseType);
  end;

implementation

uses
  Contnrs;

{ TDBProperties }

class procedure TDBProperties.AllocObjectCategories(ADatabase: TGDAODatabase);
var
  ValidCats: TObjectList;

  function AddNewCategory(AType: TGDAOCategoryType; ANameS, ANameP: String; ACreate, ADrop: String): TGDAOCategory;
  var
    ACat: TGDAOCategory;
  begin
    ACat := ADatabase.Categories.FindByType(AType);
    if ACat = nil then
      ACat := ADatabase.Categories.Add(AType, '', '', '', '');

    ACat.CategoryNameS := ANameS;
    ACat.CategoryNameP := ANameP;
    ACat.CreateTemplate := ACreate;
    ACat.DropTemplate := ADrop;
    ValidCats.Add(ACat);

    result := ACat;
  end;

var
  c: integer;
begin
  with ADatabase do
  begin
    ValidCats := TObjectList.Create(false);
    try
      case GetFixedDatabaseType(DatabaseType) of
        fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlAzure, fdbSqlServer2016:
          begin
            AddNewCategory(ctProcedure,
              'procedure',
              'Procedures',
              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] +'%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP PROCEDURE <%' + NativeIdName[niObjectName] +'%>');
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] +'%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] +'%>');
          end;
        fdbFirebird2, fdbFirebird3, fdbInterbase2017:
          begin
            AddNewCategory(ctProcedure,
              'procedure',
              'Procedures',
              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] +'%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP PROCEDURE <%' + NativeIdName[niObjectName] +'%>');
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] +'%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] +'%>');
            with AddNewCategory(ctSequence,
              'generator',
              'Generators',
              'CREATE GENERATOR <%' + NativeIdName[niObjectName] +'%>',
              'DROP GENERATOR <%' + NativeIdName[niObjectName] +'%>') do
            begin
              PropDefs.Clear;
              PropDefs.Add(SProp_SequenceSeed, pdtInteger, 0);
            end;
          end;
        fdbAbsoluteDB:
          begin
            //No categories for AbsoluteDB
          end;
        fdbNexusDB3:
          begin
            AddNewCategory(ctProcedure,
              'procedure',
              'Procedures',
              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] +'%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP PROCEDURE <%' + NativeIdName[niObjectName] +'%>');
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] +'%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] +'%>');
          end;
        fdbOracle10g:
          begin
            AddNewCategory(ctProcedure,
              'procedure',
              'Procedures',
              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] + '%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP PROCEDURE <%' + NativeIdName[niObjectName] + '%>');
            AddNewCategory(ctFunction,
              'function',
              'Functions',
              'CREATE FUNCTION <%' + NativeIdName[niObjectName] + '%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP FUNCTION <%' + NativeIdName[niObjectName] + '%>');
            with AddNewCategory(ctSequence,
              'sequence',
              'Sequences',
              'CREATE SEQUENCE <%' + NativeIdName[niObjectName] + '%>',
              'DROP SEQUENCE <%' + NativeIdName[niObjectName] + '%>') do
            begin
              PropDefs.Clear;
              PropDefs.Add(SProp_SequenceSeed, pdtInteger, 0);
            end;
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] + '%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] + '%>');
          end;
        fdbMySQL51, fdbMySQL57:
          begin
            AddNewCategory(ctProcedure,
              'procedure',
              'Procedures',
              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] +'%>'+#13+'AS'+#13+#13,
              'DROP PROCEDURE <%' + NativeIdName[niObjectName] +'%>');
            AddNewCategory(ctFunction,
              'function',
              'Functions',
              'CREATE FUNCTION <%' + NativeIdName[niObjectName] + '%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP FUNCTION <%' + NativeIdName[niObjectName] + '%>');
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] +'%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] +'%>');
          end;
        fdbElevateDB:
          begin
            AddNewCategory(ctProcedure,
              'procedure',
              'Procedures',
              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] +'%>'+#13+'AS'+#13+#13,
              'DROP PROCEDURE <%' + NativeIdName[niObjectName] +'%>');
            AddNewCategory(ctFunction,
              'function',
              'Functions',
              'CREATE FUNCTION <%' + NativeIdName[niObjectName] + '%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP FUNCTION <%' + NativeIdName[niObjectName] + '%>');
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] +'%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] +'%>');
          end;
        fdbSQLite3:
          begin
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] +'%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] +'%>');
          end;
        fdbPostgreSQL9, fdbPostgreSQL11:
          begin
            AddNewCategory(ctProcedure,
              'function',
              'Functions',
              'CREATE FUNCTION <%' + NativeIdName[niObjectName] + '%>' + #13#10 + 'AS' + #13#10 + #13#10,
              'DROP FUNCTION <%' + NativeIdName[niObjectName] + '%>');
            with AddNewCategory(ctSequence,
              'sequence',
              'Sequences',
              'CREATE SEQUENCE <%' + NativeIdName[niObjectName] + '%>',
              'DROP SEQUENCE <%' + NativeIdName[niObjectName] + '%>') do
            begin
              PropDefs.Clear;
              PropDefs.Add(SProp_SequenceSeed, pdtInteger, 0);
            end;
            AddNewCategory(ctView,
              'view',
              'Views',
              'CREATE VIEW <%' + NativeIdName[niObjectName] + '%> AS ',
              'DROP VIEW <%' + NativeIdName[niObjectName] + '%>');
          end;

        //advantage disabled: fdbAdvantage:
//          begin
//            AddNewCategory(ctProcedure,
//              'procedure',
//              'Procedures',
//              'CREATE PROCEDURE <%' + NativeIdName[niObjectName] + '%>()'#13#10'BEGIN'#13#10'  '#13#10'END',
//              'DROP PROCEDURE <%' + NativeIdName[niObjectName] + '%>');
//            AddNewCategory(ctFunction,
//              'function',
//              'Functions',
//              'CREATE FUNCTION <%' + NativeIdName[niObjectName] + '%>()'#13#10'BEGIN'#13#10'  '#13#10'END',
//              'DROP FUNCTION <%' + NativeIdName[niObjectName] + '%>');
//            AddNewCategory(ctView,
//              'view',
//              'Views',
//              'CREATE VIEW <%' + NativeIdName[niObjectName] + '%> AS ',
//              'DROP VIEW <%' + NativeIdName[niObjectName] + '%>');
//          end;
      end;

      {Clear invalid categories}
      c := 0;
      while c < Categories.Count do
        if ValidCats.IndexOf(Categories[c]) = -1 then
          Categories[c].Free
        else
          inc(c);
    finally
       ValidCats.Free;
    end;
  end;
end;

class procedure TDBProperties.ConvertDataBaseType(ADatabase: TGDAODatabase; AConversionMap: TDataTypeConversionMap);
var
  ATargetGDD : TGDAODatabase;
  i,j : Integer;
  c : TDataTypeConversionItem;
begin
  ATargetGDD := TGDAODatabase.Create;
  try
    CopyDictionary(ADatabase, ATargetGDD);
    ATargetGDD.DatabaseType := AConversionMap.TargetDBType;
    LoadAll(ATargetGDD);

    // translating fields datatypes
    for i := 0 to ATargetGDD.Tables.count-1 do
      for j := 0 to ATargetGDD.Tables.Items[i].Fields.Count-1 do
      begin
        // getting the datatype conversion map
        c := AConversionMap.GetConvertedDataType(ADatabase.Tables.Items[i].Fields.Items[j].DataTypeName);
        if c = nil then
          raise EGUIException.Create(Format(
            'Cannot convert data type "%s". Data type not defined in conversion map.',
            [ADatabase.Tables.Items[i].Fields.Items[j].DataTypeName]));

        with ATargetGDD.Tables.Items[i].Fields.Items[j] do
        begin
          DataTypeName := c.TargetDataType;
          if c.Size > 0 then
            Size := c.Size;
          if c.Size2 > 0 then
            Size2 := c.Size2;
          if DataType.SeedIsRequired then
          begin
            if ADatabase.Tables.Items[i].Fields.Items[j].DataType.SeedIsRequired then
            begin
              SeedValue := ADatabase.Tables.Items[i].Fields.Items[j].SeedValue;
              IncrementValue := ADatabase.Tables.Items[i].Fields.Items[j].IncrementValue;
            end
            else
            begin
              SeedValue := 0;
              IncrementValue := 1;
            end;
          end;
        end;
      end;
                                 
    // translating domains datatypes
    for i := 0 to ATargetGDD.Domains.Count - 1 do
    begin
      c := AConversionMap.GetConvertedDataType(ADatabase.Domains.Items[i].DataTypeName);
      if c = nil then
        raise EGUIException.Create(Format(
          'Cannot convert data type "%s". Data type not defined in conversion map.',
          [ADatabase.Domains.Items[i].DataTypeName]));

      ATargetGDD.Domains.Items[i].DataTypeName := c.TargetDataType;
    end;

    CopyDictionary(ATargetGDD, ADatabase);
  finally
    ATargetGDD.Free;
  end;
end;

class function TDBProperties.InternalConvertDataType(ADataType: TGDAODataType; ATargetDataTypes: TGDAODataTypes;
  ANativeDataType: TNativeDataType): TGDAODataType;
var
  i, icSameType : Integer;
  lastType : TGDAODataType;
  mainSubNative : TNativeSubType;
  testType : TNativeDataType;
begin
  Result := nil;
  // counting same native types
  lastType := nil;
  icSameType := 0;
  testType := ADataType.NativeDataType;
  if ANativeDataType <> naUnknown then
    testType := ANativeDataType;

  for i := 0 to ATargetDataTypes.Count-1 do
    if ATargetDataTypes.Items[i].NativeDataType = testType then
    begin
      lastType := ATargetDataTypes.Items[i];
      inc(icSameType);
    end;
  if icSameType = 1 then
    Result := lastType
  else
  begin
    // more than 1 native datatype match - looking for subdatatype match
    for i := 0 to ATargetDataTypes.Count-1 do
      if (ATargetDataTypes.Items[i].NativeDataType = testType) and
         (ATargetDataTypes.Items[i].NativeSubType = ADataType.NativeSubType) then
      begin
        Result := ATargetDataTypes.Items[i];
        break;
      end;
  end;
  if Result = nil then
  begin
    // no sub native datatype match, getting the main native datatype
    mainSubNative := GetMainNativeSubDataType(testType);
    for i := 0 to ATargetDataTypes.Count-1 do
      if (ATargetDataTypes.Items[i].NativeDataType = testType) and
         (ATargetDataTypes.Items[i].NativeSubType = mainSubNative) then
      begin
        Result := ATargetDataTypes.Items[i];
        break;
      end;
  end;
end;

class function TDBProperties.ConvertDataType(ADataType: TGDAODataType; ATargetDataTypes: TGDAODataTypes;
  ANativeDataType: TNativeDataType): TGDAODataType;
var
  testType : TNativeDataType;
begin
  Result := InternalConvertDataType(ADataType, ATargetDataTypes, ANativeDataType);
  testType := ADataType.NativeDataType;
  if ANativeDataType <> naUnknown then
    testType := ANativeDataType;
  if Result = nil then
    Result := InternalConvertDataType(ADataType, ATargetDataTypes, GetNextNativeDataType(testType));
end;

class procedure TDBProperties.CopyDictionary(ASource, ATarget: TGDAODatabase);
begin
  ATarget.Assign(ASource);
  LoadAll(ATarget);
end;

class procedure TDBProperties.FillDatabaseTypes(AList: TStrings; AEmptyItem: string);
var
  i: integer;
begin
  AList.BeginUpdate;
  try
    AList.Clear;
    for i := 0 to DatabaseTypes.Count - 1 do
      AList.AddObject(DatabaseTypes[i].DisplayName, DatabaseTypes[i]);
    if AEmptyItem <> '' then
      AList.AddObject(AEmptyItem, nil);
  finally
    AList.EndUpdate;
  end;
end;

class procedure TDBProperties.FillDataTypesObject(ADBType: TDatabaseType; ADataTypes: TGDAODataTypes);
begin
  with ADataTypes do
  begin
    Clear;
    case GetFixedDatabaseType(ADBType) of
      fdbFirebird2, fdbFirebird3, fdbInterbase2017:
        begin
          Add('Bigint', 'BIGINT', false, false, naInteger, stLongInt);
          Add('Blob', 'BLOB SUB_TYPE %p% SEGMENT SIZE %s%', true, true, naBlob, stBlob ).SetSizeSettings(80, 0, true, 1, 32767);
          Add('Blob text', 'BLOB SUB_TYPE TEXT SEGMENT SIZE %s%', true, false, naMemo, stMemo ).SetSizeSettings(80, 0, true, 1, 32767);
          Add('Char', 'CHAR(%s%)', true, false, naString, stChar).SetSizeSettings(10, 0, true, 1, 32765);
          Add('Computed', '', false, false, naComputed, stComputed).Computed := true;
          Add('Date', 'DATE', false, false, naDateTime, stDateTime );
          Add('Decimal', 'DECIMAL(%s%,%p%)', true, true, naFloat, stDecimal).SetSizeSettings(10, 3, true, 0, 18);
          Add('Double precision', 'DOUBLE PRECISION', false, false, naFloat, stDouble );
          Add('Float', 'FLOAT', false,  false,  naFloat, stFloat );
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          Add('Numeric', 'NUMERIC(%s%,%p%)', true, true, naFloat, stNumericXY ).SetSizeSettings(10, 3, true, 0, 18);;
          Add('Smallint', 'SMALLINT', false, false,  naInteger, stSmallInt );
          Add('Time', 'TIME', false, false, naDateTime, stTime );
          Add('Timestamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp );
          Add('Varchar', 'VARCHAR(%s%)', true, false, naString, stString ).SetSizeSettings(50, 0, true, 1, 32765);

          Add('NChar', 'NCHAR(%s%)', true, false, naString, stNChar ).SetSizeSettings(10, 0, true, 1, 32765);
          Add('NChar Varying', 'NCHAR VARYING(%s%)', true, false, naString, stNVarChar ).SetSizeSettings(50, 0, true, 1, 32765);

          if GetFixedDatabaseType(ADBType) in [fdbFirebird3] then
          begin
            Add('Boolean', 'BOOLEAN', false, false, naBoolean, stBoolean);
            Add('Integer (Identity)', 'INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH %e%)', false, false,
              naInteger, stCounter, true, true, true).ForeignDataTypeName := 'Integer';
            Add('Bigint (Identity)', 'BIGINT GENERATED BY DEFAULT AS IDENTITY (START WITH %e%)', false, false,
              naInteger, stLongCounter, true, true, true).ForeignDataTypeName := 'Bigint';
            with Add('Numeric (Identity)', 'NUMERIC(%s%,0) GENERATED BY DEFAULT AS IDENTITY (START WITH %e%)', true, false,
              naFloat, stFloatCounter, true, true, true) do
            begin
              SetSizeSettings(10, 0, true, 0, 18);
              ForeignDataTypeName := 'Numeric';
            end;
          end;
          if GetFixedDatabaseType(ADBType) in [fdbInterbase2017] then
            Add('Boolean', 'BOOLEAN', false, false, naBoolean, stBoolean);
        end;
      fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlAzure, fdbSqlServer2016:
        begin
          Add('Bigint', 'BIGINT', false, false, naInteger, stLongint );
          with Add('Bigint (identity)', 'BIGINT IDENTITY(%e%,%i%)', false, false, naInteger, stLongCounter, true, true, true) do
            ForeignDataTypeName := 'Bigint';

          Add('Binary', 'BINARY(%s%)', true, false, naBlob, stBinary).SetSizeSettings(50, 0, true, 1, 8000);
          Add('Bit', 'BIT', false, false, naBoolean, stBoolean);
          Add('Char', 'CHAR(%s%)', true, false, naString, stChar).SetSizeSettings(10, 0, true, 1, 8000);
          Add('Computed', '', false, false, naComputed, stComputed).Computed := true;
          Add('Datetime', 'DATETIME', false, false, naDateTime, stDateTime);
          Add('Decimal', 'DECIMAL(%s%,%p%)', true, true, naFloat, stDecimal).SetSizeSettings(18, 0, true, 1, 38);
          with Add('Decimal (identity)', 'DECIMAL(%s%,%p%) IDENTITY(%e%,%i%)', true, true, naFloat, stCounter, true, true, true) do
          begin
            ForeignDataTypeName := 'Decimal';
            SetSizeSettings(18, 0, true, 1, 38)
          end;

          //Add('Empty', '', false, false, naUnknown, stUnknown );
          Add('Float', 'FLOAT', false, false, naFloat, stFloat);
          Add('Image', 'IMAGE', false, false, naBlob, stBlob);
          Add('Int', 'INTEGER', false, false, naInteger, stInteger);
          with Add('Int (identity)', 'INTEGER IDENTITY(%e%,%i%)', false, false, naInteger, stCounter, true, true, true) do
            ForeignDataTypeName := 'Int';
          Add('Money', 'MONEY', false, false, naFloat, stMoney);
          Add('NChar', 'NCHAR(%s%)', true, false, naString, stNChar).SetSizeSettings(10, 0, true, 1, 4000);
          Add('NText', 'NTEXT', false, false, naMemo, stNText);
          Add('Numeric', 'NUMERIC(%s%,%p%)', true, true, naFloat, stNumericXY).SetSizeSettings(18, 0, true, 1, 38);
          with Add('Numeric (identity)', 'NUMERIC(%s%,%p%) IDENTITY(%e%,%i%)', true, true, naFloat, stFloatCounter, true, true, true ) do
          begin
            ForeignDataTypeName := 'Numeric';
            SetSizeSettings(18, 0, true, 1, 38)
          end;

          Add('NVarChar', 'NVARCHAR(%s%)', true, false, naString, stNVarChar).SetSizeSettings(50, 0, true, 1, 4000);
          Add('Real', 'REAL', false, false, naFloat, stReal);
          Add('SmallDateTime', 'SMALLDATETIME', false, false, naDateTime, stSmallDateTime);
          Add('SmallInt', 'SMALLINT', false, false, naInteger, stSmallInt);
          with Add('SmallInt (identity)', 'SMALLINT IDENTITY(%e%,%i%)', false, false, naInteger, stSmallCounter, true, true, true) do
            ForeignDataTypeName := 'SmallInt';

          Add('SmallMoney', 'SMALLMONEY', false, false, naFloat, stSmallMoney);
          Add('Sql_Variant', 'SQL_VARIANT', false, false, naBlob, stVariant );
          Add('SysName', 'sysname', false, false, naString, stSysName );
          Add('Text', 'TEXT' , false, false, naMemo, stMemo);
          Add('TimeStamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp);
          Add('TinyInt', 'TINYINT', false, false, naInteger, stTinyInt);
          with Add('TinyInt (identity)', 'TINYINT IDENTITY(%e%,%i%)', false, false, naInteger, stTinyCounter, true, true, true) do
            ForeignDataTypeName := 'TinyInt';

          Add('UniqueIdentifier', 'UNIQUEIDENTIFIER', false, false, naBlob, stGUID);
          Add('VarBinary', 'VARBINARY(%s%)', true, false, naBlob, stVarBinary).SetSizeSettings(50, 0, true, 1, 8000);
          Add('VarChar', 'VARCHAR(%s%)', true, false, naString, stString).SetSizeSettings(50, 0, true, 1, 8000);
          // CASE STUDIO reference - MS SQL SERVER 2000
          if GetFixedDatabaseType(ADBType) in [fdbSqlServer2005, fdbSqlServer2008, fdbSqlServer2016, fdbSqlAzure] then
          begin
            Add('NVarChar(MAX)', 'NVARCHAR(MAX)', false, false, naMemo, stNText);
            Add('VarBinary(MAX)', 'VARBINARY(MAX)', false, false, naBlob, stVarBinary);
            Add('VarChar(MAX)', 'VARCHAR(MAX)', false, false, naMemo, stMemo);
            Add('XML', 'XML', False, False, naBlob, stXML);
          end;

          if GetFixedDatabaseType(ADBType) in [fdbSqlServer2008, fdbSqlServer2016, fdbSqlAzure] then
          begin
            Add('Date', 'DATE', false, false, naDateTime, stDate);
            Add('Datetime2', 'DATETIME2(%s%)', true, false, naDateTime, stLongDateTime).SetSizeSettings(7, 0, true, 0, 7);
            Add('Datetimeoffset', 'DATETIMEOFFSET(%s%)', true, false, naDateTime, stLongDateTime).SetSizeSettings(7, 0, true, 0, 7);
            Add('Geography', 'GEOGRAPHY', false, false, naBlob, stRaw);
            Add('Geometry', 'GEOMETRY', false, false, naBlob, stRaw);
            Add('Hierarchyid', 'HIERARCHYID', false, false, naBlob, stRaw);
            Add('Time', 'TIME(%s%)', true, false, naDateTime, stTime).SetSizeSettings(7, 0, true, 0, 7);
          end;
        end;
      fdbAbsoluteDB:
        begin
          Add('Blob', 'BLOB', false, false, naBlob, stBlob);
          Add('Byte', 'BYTE', false, false, naInteger, stTinyWord);
          Add('Bytes', 'BYTES(%s%)', true, false, naBlob, stVarBinary).SetSizeSettings(50, 0, true, 1, 65500);
          Add('Cardinal', 'CARDINAL', false, false, naInteger, stSmallInt);
          Add('Char', 'CHAR(%s%)', true, false, naString, stChar).SetSizeSettings(50, 0, true, 1, 65500);
          Add('Currency', 'CURRENCY', false, false, naFloat, stMoney);
          Add('Date', 'DATE', false, false, naDateTime, stDate);
          Add('Datetime', 'DATETIME', false, false, naDateTime, stDateTime);
          Add('Extended', 'EXTENDED', false, false, naFloat, stExtended);
          Add('Float', 'FLOAT', false, false, naFloat, stFloat);
          Add('FormattedMemo', 'FORMATTEDMEMO' , false, false, naMemo, stMemo);
          Add('Graphic', 'GRAPHIC' , false, false, naBlob, stBlob);
          Add('Guid', 'GUID' , false, false, naBlob, stGuid);
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          Add('LargeInt', 'LARGEINT', false, false, naInteger, stLongInt);
          Add('Logical', 'LOGICAL', false, false, naBoolean, stBoolean);
          Add('Memo', 'MEMO' , false, false, naMemo, stMemo);
          Add('Single', 'SINGLE', false, false, naFloat, stSingle);
          Add('SmallInt', 'SMALLINT', false, false, naInteger, stSmallInt);
          Add('String', 'STRING(%s%)', true, false, naString, stString).SetSizeSettings(50, 0, true, 1, 65500);
          Add('Time', 'TIME', false, false, naDateTime, stTime);
          Add('TimeStamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp);
          Add('Varbytes', 'VARBYTES', false, false, naBlob, stBlob);
          Add('WideMemo', 'WIDEMEMO', false, false, naMemo, stNText);
          Add('WideChar', 'WIDECHAR(%s%)', true, false, naString, stNChar).SetSizeSettings(50, 0, true, 1, 65500);
          Add('WideString', 'WIDESTRING(%s%)', true, false, naString, stNVarChar).SetSizeSettings(50, 0, true, 1, 65500);
          Add('Word', 'WORD', false, false, naInteger, stSmallWord);
          Add('Autoinc', 'AUTOINC(INTEGER, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stCounter, true, true, true)
            .ForeignDataTypeName := 'Integer';
          Add('AutoincShortInt', 'AUTOINC(SHORTINT, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stSmallCounter, true, true, true)
            .ForeignDataTypeName := 'SmallInt';
          Add('AutoincSmallInt', 'AUTOINC(SMALLINT, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stSmallCounter, true, true, true)
            .ForeignDataTypeName := 'SmallInt';
          Add('AutoincInteger', 'AUTOINC(INTEGER, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stCounter, true, true, true)
            .ForeignDataTypeName := 'Integer';
          Add('AutoincLargeInt', 'AUTOINC(LARGEINT, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stLongCounter, true, true, true)
            .ForeignDataTypeName := 'LargeInt';
          Add('AutoincByte', 'AUTOINC(BYTE, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stTinyCounter, true, true, true)
            .ForeignDataTypeName := 'Byte';
          Add('AutoincWord', 'AUTOINC(WORD, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stSmallCounter, true, true, true)
            .ForeignDataTypeName := 'Word';
          Add('AutoincCardinal', 'AUTOINC(CARDINAL, INITIALVALUE %e%, INCREMENT %i%)', false, false, naInteger, stSmallCounter, true, true, true)
            .ForeignDataTypeName := 'Cardinal';
        end;
      fdbNexusDB3:
        begin
          Add('Bigint', 'BIGINT', false, false, naInteger, stLongInt);
          Add('Blob', 'BLOB', false, false, naBlob, stBlob);
          Add('Boolean', 'BOOLEAN', false, false, naBoolean, stBoolean);
          Add('Byte', 'BYTE', false, false, naInteger, stTinyWord);
          Add('Bytearray', 'BYTEARRAY(%s%)', true, false, naBlob, stVarBinary).SetSizeSettings(50, 0, true, 1, 65536);
          Add('Clob', 'CLOB' , false, false, naMemo, stMemo);
          Add('Date', 'DATE', false, false, naDateTime, stDate);
          Add('Dword', 'DWORD', false, false, naInteger, stWord);
          Add('Extended', 'EXTENDED', false, false, naFloat, stExtended);
          Add('Float', 'FLOAT(%s%)', true, false, naFloat, stFloat).SetSizeSettings(18, 0, true, 0, 18);
          Add('Guid', 'GUID' , false, false, naBlob, stGuid);
          Add('Image', 'IMAGE', false, false, naBlob, stImage);
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          Add('Autoinc', 'AUTOINC(%e%, %i%)', false, false, naInteger, stCounter, true, true, true)
            .ForeignDataTypeName := 'Integer';
          Add('Money', 'MONEY', false, false, naFloat, stMoney);
          Add('Nclob', 'NCLOB', false, false, naMemo, stNText);
          Add('Nsinglechar', 'NSINGLECHAR', false, false, naString, stNChar);
          Add('Numeric', 'NUMERIC(%s%,%p%)', true, true, naFloat, stNumericXY).SetSizeSettings(20, 4, true, 1, 38);
          Add('Nvarchar', 'NVARCHAR(%s%)', true, false, naString, stNVarChar).SetSizeSettings(50, 0, true, 1, 32767);
          Add('Real', 'REAL', false, false, naFloat, stDouble);
          Add('Recrev', 'RECREV' , false, false, naBlob, stRaw);
          Add('Shortint', 'SHORTINT', false, false, naInteger, stTinyInt);
          Add('Shortstring', 'SHORTSTRING(%s%)', true, false, naString, stTinyText).SetSizeSettings(50, 0, true, 1, 255);
          Add('Singlechar', 'SINGLECHAR', false, false, naString, stChar);
          Add('Smallint', 'SMALLINT', false, false, naInteger, stSmallInt);
          Add('Time', 'TIME', false, false, naDateTime, stTime);
          Add('Timestamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp);
          Add('Varchar', 'VARCHAR(%s%)', true, false, naString, stString).SetSizeSettings(50, 0, true, 1, 8192);
          Add('Word', 'WORD', false, false, naInteger, stSmallWord);
        end;
      fdbOracle10g:
        begin
          // Oracle built-in datatypes
          Add('Bfile', 'BFILE', false, false, naBlob, stBFile);
          Add('Binary_Double', 'BINARY_DOUBLE', False, False, naFloat, stDouble);
          Add('Binary_Float', 'BINARY_FLOAT', False, False, naFloat, stFloat);
          Add('Blob', 'BLOB', false, false, naBlob, stBlob);
          Add('Char', 'CHAR(%s%)', true, false, naString, stChar);
          Add('Clob', 'CLOB', false, false, naMemo, stMemo);
          Add('Date', 'DATE', false, false, naDateTime, stDateTime);
          Add('Interval day to second', 'INTERVAL DAY (%s%) TO SECOND (%p%)', true, true, naFloat, stIntervalDay);
          Add('Interval year to month', 'INTERVAL YEAR(%s%) TO MONTH', true, false, naFloat, stIntervalYear);
          Add('Long', 'LONG', false, false, naInteger, stLongInt);
          Add('Long raw', 'LONG RAW', false, false, naBlob, stLongRaw);
          Add('NChar', 'NCHAR(%s%)', true, false, naString, stNChar);
          Add('NClob', 'NCLOB', false, false, naMemo, stNText);
          Add('Number', 'NUMBER(%s%, %p%)', true, true, naFloat, stNumericXY);
          Add('Number (floating point)', 'NUMBER', false, false, naFloat, stFloat);
          Add('NVarchar2', 'NVARCHAR2(%s%)', true, false, naString, stNVarChar);
          Add('Raw', 'RAW(%s%)', true, false, naBlob, stRaw);
          Add('Rowid', 'ROWID', false, false, naString, stRowID);
          Add('Timestamp', 'TIMESTAMP(%s%)', true, false, naDateTime, stTimeStamp);
          Add('Timestamp with local time zone', 'TIMESTAMP(%s%) WITH LOCAL TIME ZONE', true, false, naDateTime, stTimeStampLocalZone);
          Add('Timestamp with time zone', 'TIMESTAMP(%s%) WITH TIME ZONE', true, false, naDateTime, stTimeStampTimeZone);
          Add('Urowid', 'UROWID(%s%)', true, false, naString, stURowID);
          Add('Varchar2', 'VARCHAR2(%s%)', true, false, naString, stString);
          Add('XMLType', 'XMLType', False, False, naBlob, stXML);

          // ANSI datatypes
          Add('Float', 'FLOAT(%s)', true, false, naFloat, stFloatX);
          Add('Double precision', 'DOUBLE PRECISION', false, false, naFloat, stDouble);
          Add('Numeric', 'NUMERIC(%s%, %p%)', true, true, naFloat, stNumericXY);
          Add('Decimal', 'DECIMAL(%s%, %p%)', true, true, naFloat, stDecimal);
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          Add('Smallint', 'SMALLINT', false, false, naInteger, stSmallint);
          Add('Real', 'REAL', false, false, naFloat, stReal);
        end;
      fdbMySQL51, fdbMySQL57:
        begin
          Add('BigInt', 'BIGINT', False, False, naInteger, stLongInt);
          Add('BigInt (autoincrement)', 'BIGINT AUTO_INCREMENT', False, False, naInteger, stLongCounter, True).ForeignDataTypeName := 'BigInt';
          Add('Int', 'INT', False, False, naInteger, stInteger);
          Add('Int (autoincrement)', 'INT AUTO_INCREMENT', False, False, naInteger, stCounter, True).ForeignDataTypeName := 'Int';
          Add('MediumInt', 'MEDIUMINT', False, False, naInteger, stMediumInt);
          Add('MediumInt (autoincrement)', 'MEDIUMINT AUTO_INCREMENT', False, False, naInteger, stMediumCounter, True).ForeignDataTypeName := 'MediumImt';
          Add('SmallInt', 'SMALLINT', False, False, naInteger, stSmallInt);
          Add('SmallInt (autoincrement)', 'SMALLINT AUTO_INCREMENT', False, False, naInteger, stSmallCounter, True).ForeignDataTypeName := 'SmallInt';
          Add('TinyInt', 'TINYINT', False, False, naInteger, stTinyInt);
          Add('TinyInt (autoincrement)', 'TINYINT AUTO_INCREMENT', False, False, naInteger, stTinyCounter, True).ForeignDataTypeName := 'TinyInt';

          Add('Bit', 'BIT', False, False, naInteger, stBit);
          Add('Decimal', 'DECIMAL(%s%,%p%)', True, True, naFloat, stDecimal).SetSizeSettings(10, 0, true, 1, 65);
          Add('Double precision', 'DOUBLE PRECISION', False, False, naFloat, stDouble);
          Add('Float', 'FLOAT(%s%)', True, False, naFloat, stFloat).SetSizeSettings(23, 0, true, 0, 53);
          Add('Numeric', 'NUMERIC(%s%,%p%)', True, True, naFloat, stNumericXY).SetSizeSettings(10, 0, true, 1, 65);
          Add('Real', 'REAL', False, False, naFloat, stReal);

          Add('Date', 'DATE', False, False, naDateTime, stDate);
          Add('DateTime', 'DATETIME', False, False, naDateTime, stDateTime);
          Add('Time', 'TIME', False, False, naDateTime, stTime);
          Add('TimeStamp', 'TIMESTAMP', False, False, naDateTime, stTimeStamp);
          Add('Year', 'YEAR', False, False, naDateTime, stYear);

          Add('Binary', 'BINARY(%s%)', True, False, naBlob, stBinary).SetSizeSettings(10, 0, true, 0, 255);
          Add('Blob', 'BLOB', False, False, naBlob, stBlob);
          Add('Char', 'CHAR(%s%)', True, False, naString, stChar).SetSizeSettings(10, 0, true, 0, 255);
          Add('LongBlob', 'LONGBLOB', False, False, naBlob, stLongBlob);
          Add('LongText', 'LONGTEXT', False, False, naMemo, stLongText);
          Add('MediumBlob', 'MEDIUMBLOB', False, False, naBlob, stMediumBlob);
          Add('MediumText', 'MEDIUMTEXT', False, False, naMemo, stMediumText);
          Add('Text', 'TEXT', False, False, naMemo, stMemo);
          Add('TinyBlob', 'TINYBLOB', False, False, naBlob, stTinyBlob);
          Add('TinyText', 'TINYTEXT', False, False, naMemo, stTinyText);
          Add('VarBinary', 'VARBINARY(%s%)', True, False, naBlob, stVarBinary).SetSizeSettings(50, 0, true, 0, 65535);
          Add('VarChar', 'VARCHAR(%s%)', True, False, naString, stString).SetSizeSettings(50, 0, true, 0, 65535);
          Add('Computed', '', false, false, naComputed, stComputed).Computed := true;
        end;
      fdbElevateDB:
        begin
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          Add('SmallInt', 'SMALLINT', false, false, naInteger, stSmallInt);
          Add('BigInt', 'BIGINT', false, false, naInteger, stLongInt);
          Add('Numeric', 'NUMERIC(%s%,%p%)', true, true, naFloat, stNumericXY);
          Add('Decimal', 'DECIMAL(%s%,%p%)', true, true, naFloat, stDecimal);
          Add('Double precision', 'DOUBLE PRECISION', false, false, naFloat, stDouble);
          Add('Float', 'FLOAT', false, false, naFloat, stFloat);

          Add('Char', 'CHAR(%s%)', true, false, naString, stChar).SetSizeSettings(50, 0, true, 0, 1024);
          Add('VarChar', 'VARCHAR(%s%)', true, false, naString, stString).SetSizeSettings(50, 0, true, 0, 1024);
          Add('Guid', 'GUID', false, false, naBlob, stGUID);
          Add('Clob', 'CLOB', false, false, naBlob, stClob);
          Add('Byte', 'BYTE(%s%)', true, false, naBlob, stBinary).SetSizeSettings(50, 0, true, 0, 1024);
          Add('VarByte', 'VARBYTE(%s%)', true, false, naBlob, stVarBinary).SetSizeSettings(50, 0, true, 0, 1024);
          Add('Blob', 'BLOB', false, false, naBlob, stBlob);

          Add('Date', 'DATE', false, false, naDateTime, stDate);
          Add('Time', 'TIME', false, false, naDateTime, stTime);
          Add('TimeStamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp);

          Add('Boolean', 'BOOLEAN', false, false, naBoolean, stBoolean);

          Add('Interval year', 'INTERVAL YEAR', false, false, naFloat, stIntervalYear);
          Add('Interval year to month', 'INTERVAL YEAR TO MONTH', false, false, naFloat, stIntervalYearToMonth);
          Add('Interval month', 'INTERVAL MONTH', false, false, naFloat, stIntervalMonth);
          Add('Interval day', 'INTERVAL DAY', false, false, naFloat, stIntervalDay);
          Add('Interval day to hour', 'INTERVAL DAY TO HOUR', false, false, naFloat, stIntervalDayToHour);
          Add('Interval day to minute', 'INTERVAL DAY TO MINUTE', false, false, naFloat, stIntervalDayToMinute);
          Add('Interval day to msecond', 'INTERVAL DAY TO MSECOND', false, false, naFloat, stIntervalDayToMSecond);
          Add('Interval day to second', 'INTERVAL DAY TO SECOND', false, false, naFloat, stIntervalDayToSecond);
          Add('Interval hour', 'INTERVAL HOUR', false, false, naFloat, stIntervalHour);
          Add('Interval hour to minute', 'INTERVAL HOUR TO MINUTE', false, false, naFloat, stIntervalHourToMinute);
          Add('Interval hour to msecond', 'INTERVAL HOUR TO MSECOND', false, false, naFloat, stIntervalHourToMSecond);
          Add('Interval hour to second', 'INTERVAL HOUR TO SECOND', false, false, naFloat, stIntervalHourToSecond);
          Add('Interval minute', 'INTERVAL MINUTE', false, false, naFloat, stIntervalMinute);
          Add('Interval minute to msecond', 'INTERVAL MINUTE TO MSECOND', false, false, naFloat, stIntervalMinuteToMSecond);
          Add('Interval minute to second', 'INTERVAL MINUTE TO SECOND', false, false, naFloat, stIntervalMinuteToSecond);
          Add('Interval second', 'INTERVAL SECOND', false, false, naFloat, stIntervalSecond);
          Add('Interval second to msecond', 'INTERVAL SECOND TO MSECOND', false, false, naFloat, stIntervalSecondToMSecond);
          Add('Interval msecond', 'INTERVAL MSECOND', false, false, naFloat, stIntervalMSecond);

          Add('Computed', '', false, false, naComputed, stComputed).Computed := true;
          Add('Identity (always)', 'INTEGER GENERATED ALWAYS AS IDENTITY (START WITH %e%, INCREMENT BY %i%)', false, false,
            naInteger, stCounter, true, true, true).ForeignDataTypeName := 'Integer';
          Add('Identity (default)', 'INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH %e%, INCREMENT BY %i%)', false, false,
            naInteger, stCounter, true, true, true).ForeignDataTypeName := 'Integer';
        end;
      fdbSQLite3:
        begin
          Add('Bigint', 'BIGINT', false, false, naInteger, stLongint);
          Add('Bit', 'BIT', false, false, naBoolean, stBoolean);
          Add('Blob', 'BLOB', False, False, naBlob, stBlob);
          Add('Char', 'CHAR(%s%)', true, false, naString, stChar).SetSizeSettings(10, 0, true, 1, 8000);
          Add('Date', 'DATE', false, false, naDateTime, stDate );
          Add('Datetime', 'DATETIME', false, false, naDateTime, stDateTime);
          Add('Decimal', 'DECIMAL(%s%,%p%)', true, true, naFloat, stDecimal).SetSizeSettings(10, 0, true, 1, 38);
          Add('Double precision', 'DOUBLE PRECISION', false, false, naFloat, stDouble);
          Add('Float', 'FLOAT', false, false, naFloat, stFloat);
          Add('Generic', '', false, false, naString, stGeneric);
          Add('Guid', 'GUID' , false, false, naBlob, stGuid);
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          Add('Integer (primary key)', 'INTEGER PRIMARY KEY', False, False, naInteger, stRowID, True).ForeignDataTypeName := 'Integer';
          Add('Integer (autoincrement)', 'INTEGER PRIMARY KEY AUTOINCREMENT', False, False, naInteger, stCounter, True).ForeignDataTypeName := 'Integer';
          Add('Numeric', 'NUMERIC(%s%,%p%)', true, true, naFloat, stNumericXY).SetSizeSettings(10, 0, true, 1, 38);
          Add('Real', 'REAL', false, false, naFloat, stReal);
          Add('SmallInt', 'SMALLINT', false, false, naInteger, stSmallInt);
          Add('Text', 'TEXT' , false, false, naMemo, stMemo);
          Add('Time', 'TIME', false, false, naDateTime, stTime);
          Add('VarChar', 'VARCHAR(%s%)', true, false, naString, stString).SetSizeSettings(50, 0, true, 1, 8000);
        end;

      fdbPostgreSQL9, fdbPostgreSQL11:
        begin
          Add('BigInt', 'BIGINT', False, False, naInteger, stLongInt);
//          Add('BigSerial', 'BIGSERIAL', False, False, naInteger, stLongCounter, True).ForeignDataTypeName := 'BigInt';
          Add('Bit', 'BIT(%s%)', True, False, naBlob, stBit).SetSizeSettings(50, 0, true, 0, 1073741824);
          Add('Varbit', 'VARBIT(%s%)', True, False, naBlob, stBit).SetSizeSettings(50, 0, true, 0, 1073741824);
          Add('Boolean', 'BOOLEAN', false, false, naBoolean, stBoolean);
          Add('Box', 'BOX', false, false, naBlob, stRaw);
          Add('Bytea', 'BYTEA', False, False, naBlob, stBlob);
          Add('Char', 'CHAR(%s%)', True, False, naString, stChar).SetSizeSettings(10, 0, true, 0, 1073741824);
          Add('VarChar', 'VARCHAR(%s%)', True, False, naString, stString).SetSizeSettings(50, 0, true, 0, 1073741824);
          Add('Cidr', 'CIDR', false, false, naBlob, stRaw);
          Add('Circle', 'CIRCLE', false, false, naBlob, stRaw);
          Add('Date', 'DATE', False, False, naDateTime, stDate);
          Add('Double precision', 'DOUBLE PRECISION', False, False, naFloat, stDouble);
          Add('Inet', 'INET', false, false, naBlob, stRaw);
          Add('Integer', 'INTEGER', False, False, naInteger, stInteger);

          Add('Interval', 'INTERVAL', true, false, naFloat, stIntervalYear);

          Add('Json', 'JSON', false, false, naMemo, stJson);
          Add('Jsonb', 'JSONB', false, false, naBlob, stJson);
          Add('Line', 'LINE', false, false, naBlob, stRaw);
          Add('LSeg', 'LSEG', false, false, naBlob, stRaw);
          Add('Macaddr', 'MACADDR', false, false, naBlob, stRaw);
          Add('Money', 'MONEY', false, false, naFloat, stMoney);
          Add('Numeric', 'NUMERIC(%s%,%p%)', True, True, naFloat, stNumericXY).SetSizeSettings(10, 0, true, 1, 65);
          Add('Oid', 'OID', false, false, naInteger, stRowID);
//          Add('Decimal', 'DECIMAL(%s%,%p%)', True, True, naFloat, stDecimal).SetSizeSettings(10, 0, true, 1, 65);
          Add('Path', 'PATH', false, false, naBlob, stRaw);
          Add('Point', 'POINT', false, false, naBlob, stRaw);
          Add('Polygon', 'POLYGON', false, false, naBlob, stRaw);
          Add('Real', 'REAL', False, False, naFloat, stFloat);
          Add('SmallInt', 'SMALLINT', False, False, naInteger, stSmallInt);
//          Add('SmallSerial', 'SMALLSERIAL', False, False, naInteger, stSmallCounter, True).ForeignDataTypeName := 'SmallInt';
//          Add('Serial', 'SERIAL', False, False, naInteger, stCounter, True).ForeignDataTypeName := 'Integer';
          Add('Text', 'TEXT', False, False, naMemo, stMemo);

//          Add('Timestamp', 'TIMESTAMP(%s%)', true, false, naFloat, stTimeStamp).DefaultSize := 6;
//          Add('Timestamp with time zone', 'TIMESTAMP(%s%) WITH TIME ZONE', true, false, naFloat, stTimeStampTimeZone).DefaultSize := 6;
//          Add('Time', 'TIME', False, False, naDateTime, stTime).DefaultSize := 6;
//          Add('Time with time zone', 'TIME WITH TIME ZONE', False, False, naDateTime, stTime).DefaultSize := 6;

          Add('Timestamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp);
          Add('Timestamp with time zone', 'TIMESTAMP WITH TIME ZONE', false, false, naDateTime, stTimeStampTimeZone);
          Add('Time', 'TIME', False, False, naDateTime, stTime);
          Add('Time with time zone', 'TIME WITH TIME ZONE', False, False, naDateTime, stTime);

          Add('TSQuery', 'TSQUERY', false, false, naBlob, stRaw);
          Add('TSVector', 'TSVECTOR', false, false, naBlob, stRaw);
          Add('Txid_snapshot', 'Txid_snapshot', false, false, naBlob, stRaw);
          Add('Uuid', 'UUID', false, false, naBlob, stGUID);
          Add('XML', 'XML', False, False, naBlob, stXML);
          Add('Computed', '', false, false, naComputed, stComputed).Computed := true;

          Add('daterange', 'daterange', false, false, naBlob, stRaw);
          Add('int4range', 'int4range', false, false, naBlob, stRaw);
          Add('int8range', 'int8range', false, false, naBlob, stRaw);
          Add('numrange', 'numrange', false, false, naBlob, stRaw);
          Add('tsrange', 'tsrange', false, false, naBlob, stRaw);
          Add('tstzrange', 'tstzrange', false, false, naBlob, stRaw);
        end;

      {$IFDEF AURELIUS_DLL}
      fdbSqlAnywhere:
        begin
          Add('Bigint', 'BIGINT', false, false, naInteger, stLongint );
          with Add('Bigint (identity)', 'BIGINT IDENTITY(%e%,%i%)', false, false, naInteger, stLongCounter, true, true, true) do
            ForeignDataTypeName := 'Bigint';

          Add('Binary', 'BINARY(%s%)', true, false, naBlob, stBinary).SetSizeSettings(50, 0, true, 1, 8000);
          Add('Bit', 'BIT', false, false, naBoolean, stBoolean);
          Add('Char', 'CHAR(%s%)', true, false, naString, stChar).SetSizeSettings(10, 0, true, 1, 8000);
          Add('Computed', '', false, false, naComputed, stComputed).Computed := true;
          Add('Datetime', 'DATETIME', false, false, naDateTime, stDateTime);
          Add('Decimal', 'DECIMAL(%s%,%p%)', true, true, naFloat, stDecimal).SetSizeSettings(18, 0, true, 1, 38);
          with Add('Decimal (identity)', 'DECIMAL(%s%,%p%) IDENTITY(%e%,%i%)', true, true, naFloat, stCounter, true, true, true) do
          begin
            ForeignDataTypeName := 'Decimal';
            SetSizeSettings(18, 0, true, 1, 38)
          end;

          //Add('Empty', '', false, false, naUnknown, stUnknown );
          Add('Double', 'DOUBLE', false, false, naFloat, stDouble);
          Add('Float', 'FLOAT', false, false, naFloat, stFloat);
          Add('Image', 'IMAGE', false, false, naBlob, stBlob);
          Add('Integer', 'INTEGER', false, false, naInteger, stInteger);
          with Add('Integer (identity)', 'INTEGER IDENTITY(%e%,%i%)', false, false, naInteger, stCounter, true, true, true) do
            ForeignDataTypeName := 'Int';
          Add('Money', 'MONEY', false, false, naFloat, stMoney);
          Add('NChar', 'NCHAR(%s%)', true, false, naString, stNChar).SetSizeSettings(10, 0, true, 1, 4000);
          Add('NText', 'NTEXT', false, false, naMemo, stNText);
          Add('Numeric', 'NUMERIC(%s%,%p%)', true, true, naFloat, stNumericXY).SetSizeSettings(18, 0, true, 1, 38);
          with Add('Numeric (identity)', 'NUMERIC(%s%,%p%) IDENTITY(%e%,%i%)', true, true, naFloat, stFloatCounter, true, true, true ) do
          begin
            ForeignDataTypeName := 'Numeric';
            SetSizeSettings(18, 0, true, 1, 38)
          end;

          Add('NVarChar', 'NVARCHAR(%s%)', true, false, naString, stNVarChar).SetSizeSettings(50, 0, true, 1, 4000);
          Add('Real', 'REAL', false, false, naFloat, stReal);
          Add('SmallDateTime', 'SMALLDATETIME', false, false, naDateTime, stSmallDateTime);
          Add('SmallInt', 'SMALLINT', false, false, naInteger, stSmallInt);
          with Add('SmallInt (identity)', 'SMALLINT IDENTITY(%e%,%i%)', false, false, naInteger, stSmallCounter, true, true, true) do
            ForeignDataTypeName := 'SmallInt';

          Add('SmallMoney', 'SMALLMONEY', false, false, naFloat, stSmallMoney);
//          Add('Sql_Variant', 'SQL_VARIANT', false, false, naBlob, stVariant );
//          Add('SysName', 'sysname', false, false, naString, stSysName );
          Add('Text', 'TEXT' , false, false, naMemo, stMemo);
          Add('TimeStamp', 'TIMESTAMP', false, false, naDateTime, stTimeStamp);
          Add('TinyInt', 'TINYINT', false, false, naInteger, stTinyInt);
          with Add('TinyInt (identity)', 'TINYINT IDENTITY(%e%,%i%)', false, false, naInteger, stTinyCounter, true, true, true) do
            ForeignDataTypeName := 'TinyInt';

          Add('UniqueIdentifier', 'UNIQUEIDENTIFIER', false, false, naBlob, stGUID);
          Add('VarBinary', 'VARBINARY(%s%)', true, false, naBlob, stVarBinary).SetSizeSettings(50, 0, true, 1, 8000);
          Add('VarChar', 'VARCHAR(%s%)', true, false, naString, stString).SetSizeSettings(50, 0, true, 1, 8000);

          Add('Long NVarchar', 'LONG NVARCHAR', false, false, naMemo, stNText);
          Add('Long Binary', 'LONG BINARY', false, false, naBlob, stVarBinary);
          Add('Long Varchar', 'LONG VARCHAR', false, false, naMemo, stMemo);
          Add('XML', 'XML', False, False, naBlob, stXML);

          Add('Date', 'DATE', false, false, naDateTime, stDate);
          Add('Datetime', 'DATETIME', false, false, naDateTime, stLongDateTime);
          Add('Datetimeoffset', 'DATETIMEOFFSET', false, false, naDateTime, stLongDateTime);
          Add('Time', 'TIME', false, false, naDateTime, stTime);
          Add('Timestamp', 'TIMESTAMP', false, false, naDateTime, stLongDateTime);

          Add('ST_Geometry', 'ST_GEOMETRY', false, false, naBlob, stRaw);
        end;
      {$ENDIF}

      //advantage disabled: fdbAdvantage:
//        begin
//          Add('AutoInc', 'AutoInc', false, false, naInteger, stCounter, true, true);
//          Add('Binary', 'Blob', false, false, naBlob, stBinary);
//          Add('Character', 'Char(%s%)', true, false, naString, stChar);
//          Add('CICharacter', 'CIChar(%s%)', true, false, naString, stCIChar);
//          Add('CompactDate', 'Compactdate', false, false, naDateTime, stSmallDateTime);
//          Add('CurDouble', 'CurDouble', false, false, naFloat, stSmallMoney);
//          Add('Date', 'Date', false, false, naDateTime, stDate);
//          Add('Double', 'Double(%s%)', true, false, naFloat, stDouble);
//          Add('Image', 'Blob', false, false, naBlob, stImage);
//          Add('Integer', 'Integer', false, false, naInteger, stInteger);
//          Add('Logical', 'Logical', false, false, naBoolean, stBoolean);
//          Add('LongLong', 'LongLong', false, false, naInteger, stLongInt);
//          Add('Memo', 'Memo', false, false, naMemo, stMemo);
//          Add('ModTime', 'ModTime', false, false, naDateTime, stLongDateTime);
//          Add('Money', 'Money', false, false, naFloat, stMoney);
//          Add('NChar', 'NChar(%s%)', true, false, naString, stNChar);
//          Add('NMemo', 'NMemo', false, false, naMemo, stNText);
//          Add('Numeric', 'Numeric(%s%,%p%)', true, true, naFloat, stNumericXY);
//          Add('NVarChar', 'NVarChar(%s%)', true, false, naString, stNVarChar);
//          Add('Raw', 'Raw(%s%)', true, false, naBlob, stRaw);
//          Add('RowVersion', 'RowVersion', false, false, naInteger, stRowID);
//          Add('ShortInt', 'Short', false, false, naInteger, stSmallInt);
//          Add('Time', 'Time', false, false, naDateTime, stTime);
//          Add('TimeStamp', 'TimeStamp', false, false, naDateTime, stTimeStamp);
//          Add('VarBinaryFox', 'VarBinaryFox(%s%)', true, false, naBlob, stVarBinary);
//          Add('VarChar', 'VarChar(%s%)', true, false, naString, stString);
//          Add('VarCharFox', 'VarChar(%s%)', true, false, naString, stString);
//        end;
    end;
  end;
end;

class procedure TDBProperties.FillDefaultConversionItems(
  AItems: TDataTypeConversionItems; Source, Target: TDatabaseType);
var
  c: integer;
  AMapItem: TDataTypeConversionItem;
  ASrcTypes, ADstTypes: TGDAODataTypes;
  ATargetType: TGDAODataType;
begin
  ASrcTypes := TGDAODataTypes.Create(nil);
  ADstTypes := TGDAODataTypes.Create(nil);
  try
    FillDataTypesObject(Source, ASrcTypes);
    FillDataTypesObject(Target, ADstTypes);
    AItems.Clear;
    for c := 0 to ASrcTypes.Count - 1 do
    begin
      AMapItem := AItems.Add;
      AMapItem.OriginalDataType := ASrcTypes[c].Name;
      ATargetType := ConvertDataType(ASrcTypes[c], ADstTypes);
      if ATargetType <> nil then
        AMapItem.TargetDataType := ATargetType.Name
      else
        AMapItem.TargetDataType := '';
    end;
  finally
    ASrcTypes.Free;
    ADstTypes.Free;
  end;
end;

{class procedure TDBProperties.FillDefaultConversionMap(
  AMap: TDataTypeConversionMap; Source, Target: TDatabaseType);
begin
    AMap.OriginalDBType := Source;
    AMap.TargetDBType := Target;

end;}

class function TDBProperties.GetFixedDatabaseType(ADBType: TDatabaseType): TFixedDBType;
begin
  if Assigned(ADBType) then
    for result := Low(TFixedDBType) to High(TFixedDBType) do
      if FixedDBTypeID[result] = ADBType.DatabaseTypeID then
        exit;
  result := fdbUnknown;
end;

class function TDBProperties.GetMainNativeSubDataType(ANativeDataType: TNativeDataType): TNativeSubType;
begin
  case ANativeDataType of
    naInteger:  Result := stInteger;
    naFloat:    Result := stFloat;
    naString:   Result := stString;
    naBoolean:  Result := stBoolean;
    naDateTime: Result := stDateTime;
    naMemo:     Result := stMemo;
    naBlob:     Result := stBlob;
    else        Result := stUnknown;
  end;
end;

class function TDBProperties.GetNextNativeDataType(ANativeDataType: TNativeDataType): TNativeDataType;
begin
  case ANativeDataType of
    naInteger   : Result := naString;
    naFloat     : Result := naString;
    naString    : Result := naBoolean;
    naBoolean   : Result := naBlob;
    naDateTime  : Result := naFloat;
    naMemo      : Result := naString;
    naBlob      : Result := naMemo;
    else          Result := naUnknown;
  end;
end;

class procedure TDBProperties.LoadAll(ADatabase: TGDAODatabase);
begin
  AllocObjectCategories(ADatabase);
end;

end.


