unit dgDBTypes;

interface

uses
  Classes, dgConsts;

type
  TDatabaseType = class;

  TLoadScriptExpressionsProc = procedure(AList: TStrings) of object;

  TDatabaseTypes = class(TCollection)
  private
    function GetItem(i: integer): TDatabaseType;
    procedure SetItem(i: integer; const Value: TDatabaseType);
    procedure LoadDatabaseTypes;
    procedure LoadAbsoluteDBExpressions(AList: TStrings);
    //advantage disabled: procedure LoadAdvantageExpressions(AList: TStrings);
    procedure LoadNexusDB3Expressions(AList: TStrings);
    procedure LoadMySQLExpressions(AList: TStrings);
    procedure LoadOracle10gExpressions(AList: TStrings);
    procedure LoadSqlServerBaseExpressions(AList: TStrings);
    procedure LoadSqlServer2000Expressions(AList: TStrings);
    procedure LoadSqlServer2005Expressions(AList: TStrings);
    procedure LoadSqlServer2008Expressions(AList: TStrings);
    procedure LoadSqlServer2016Expressions(AList: TStrings);
    procedure LoadSqlAzureExpressions(AList: TStrings);
    procedure LoadElevateDBExpressions(AList: TStrings);
    procedure LoadSQLiteExpressions(AList: TStrings);
  public
    constructor Create;
    function Add(AID: string; AEngineType: TDBEngineType): TDatabaseType;
    function FindByID(AID: string): TDatabaseType;
    function FindByCaption(ACaption: string): TDatabaseType;
    property Items[i: integer]: TDatabaseType read GetItem write SetItem; default;
  end;

  TDatabaseType = class(TCollectionItem)
  private
    FReservedWords: TStrings;
    FDatabaseTypeID: string;
    FEngineType: TDBEngineType;
    FOnLoadScriptExpressions: TLoadScriptExpressionsProc;
    FCaption: string;
    FDataTypes: TCollection;
    FEnableConstraintNotNullName: boolean;
    FEnableConstraintDefaultName: boolean;
    FMaxIdentifierLength: integer;
    FEnableConstraintPkName: boolean;
    FEnableConstraintCheckFldName: boolean;
    FEnableIndexOrderByField: boolean;
    FEnableDomainsInDatabase: boolean;
    FEnableTableTriggers: boolean;
    FEnableRelationships: boolean;
    FEnableTableConstraints: boolean;
    FScriptObjectComments: boolean;
    FRelationshipsInTablesOnly: boolean;
    FUniqueKeyWithSpecificSyntax: boolean;
    FUseProcedureHeaders: boolean;
    FEnableNotNullInDomains: boolean;
    FEnableDefaultInDomains: boolean;
    FEnableConstraintInDomains: boolean;
    FDropConstraintsBeforeFieldDrop: Boolean;
    procedure SetDatabaseTypeID(const Value: string);
    procedure LoadDatabaseFeatures;
    procedure LoadReservedWords;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
    function MustDelimitId(AId: string): boolean;
    function IsReservedWord(AName: string): boolean;

    { generic features enabled per database (uDBProperties) }
    property EnableIndexOrderByField: boolean read FEnableIndexOrderByField write FEnableIndexOrderByField;
    property EnableConstraintPkName: boolean read FEnableConstraintPkName write FEnableConstraintPkName;
    property EnableConstraintCheckFldName: boolean read FEnableConstraintCheckFldName write FEnableConstraintCheckFldName;
    property EnableConstraintDefaultName: boolean read FEnableConstraintDefaultName write FEnableConstraintDefaultName;
    property EnableConstraintNotNullName: boolean read FEnableConstraintNotNullName write FEnableConstraintNotNullName;
    property EnableDomainsInDatabase: boolean read FEnableDomainsInDatabase write FEnableDomainsInDatabase;
    property EnableTableTriggers: boolean read FEnableTableTriggers write FEnableTableTriggers;
    property EnableTableConstraints: boolean read FEnableTableConstraints write FEnableTableConstraints;
    property EnableRelationships: boolean read FEnableRelationships write FEnableRelationships;
    property EnableNotNullInDomains: boolean read FEnableNotNullInDomains write FEnableNotNullInDomains;
    property EnableConstraintInDomains: boolean read FEnableConstraintInDomains write FEnableConstraintInDomains;
    property EnableDefaultInDomains: boolean read FEnableDefaultInDomains write FEnableDefaultInDomains;
    property MaxIdentifierLength: integer read FMaxIdentifierLength write FMaxIdentifierLength;
    property ScriptObjectComments: boolean read FScriptObjectComments write FScriptObjectComments;
    property UseProcedureHeaders: boolean read FUseProcedureHeaders write FUseProcedureHeaders;

    // If true indicates that the database doesn't support add/remove relationships unless it's declared in
    // the create table statement
    property RelationshipsInTablesOnly: boolean read FRelationshipsInTablesOnly write FRelationshipsInTablesOnly;

    // In SQL Server we must explicitly drop columns constraints before dropping a column otherwise
    // an error is raised
    property DropConstraintsBeforeFieldDrop: Boolean read FDropConstraintsBeforeFieldDrop write FDropConstraintsBeforeFieldDrop;

    // If true indicates that unique indexes and unique keys will be generate with different syntax
    // (macros in macro db structures must then be revised)
    property UniqueKeyWithSpecificSyntax: boolean read FUniqueKeyWithSpecificSyntax write FUniqueKeyWithSpecificSyntax;

    property DataTypes: TCollection read FDataTypes;
  published
    property DatabaseTypeID: string read FDatabaseTypeID write SetDatabaseTypeID;
    property EngineType: TDBEngineType read FEngineType write FEngineType;
    property Caption: string read FCaption write FCaption;
    property OnLoadScriptExpressions: TLoadScriptExpressionsProc read FOnLoadScriptExpressions write FOnLoadScriptExpressions;
  end;

  TFixedDBType =
    (fdbUnknown,
     fdbSqlServer2000,
     fdbSqlServer2005,
     fdbFirebird2,
     fdbAbsoluteDB,
     fdbSqlServer2008,
     fdbNexusDB3,
     fdbOracle10g,
     fdbMySQL51,
     fdbSqlAzure,
     fdbElevateDB,
     fdbSQLite3,
     fdbPostgreSQL9,
     fdbFirebird3,
     fdbSqlServer2016,
     fdbMySQL57,
     fdbInterbase2017,
     {$IFDEF AURELIUS_DLL}fdbSqlAnywhere,{$ENDIF}
     fdbPostgreSQL11
     //advantage disabled: fdbAdvantage
    );

const
  FixedDBTypeID: array[TFixedDBType] of string =
    ('none',
     'mssql2000',
     'mssql2005',
     'firebird2',
     'absolutedb',
     'mssql2008',
     'nexusdb3',
     'oracle10g',
     'mysql51',
     'mssqlazure',
     'elevatedb',
     'sqlite3',
     'postgresql9',
     'firebird3',
     'mssql2016',
     'mysql57',
     'interbase2017',
     {$IFDEF AURELIUS_DLL}'sqlanywhere',{$ENDIF}
     'postgresql11'
     //advantage disabled: 'advantage'
    );

  FixedDBTypeCaption: array[TFixedDBType] of string =
    ('none',
     'MS SQL Server 2000',
     'MS SQL Server 2005',
     'Firebird 2',
     'Absolute Database',
     'MS SQL Server 2008',
     'NexusDB V3',
     'Oracle 10g',
     'MySQL 5.1',
     'MS SQL Azure',
     'ElevateDB',
     'SQLite',
     'PostgreSQL 9',
     'Firebird 3',
     'MS SQL Server 2016',
     'MySQL 5.7',
     'Interbase 2017',
     {$IFDEF AURELIUS_DLL}'SQL Anywhere',{$ENDIF}
     'PostgreSQL 11'
     //advantage disabled: 'Advantage Database'
    );

function DatabaseTypes: TDatabaseTypes;

implementation

uses
  SysUtils, uDBProperties,
  dgMacroConsts,
  DatabaseTypes.Firebird,
  DatabaseTypes.PostgreSQL,
  {$IFDEF AURELIUS_DLL}DatabaseTypes.SqlAnywhere,{$ENDIF}
  uGDAO;

var
  vDatabaseTypes: TDatabaseTypes;

const
  FixedDBEngineType: array[TFixedDBType] of TDBEngineType =
    (etNone,
     etFireDac,      // sqlserver2000
     etFireDac,      // sqlserver2005
     etFireDac,      // firebird2
     etAbsoluteDB,  // absolute
     etFireDac,      // sqlserver2008
     etNexusDB,     // nexusdb
     etFireDac,      // oracle10g
     etFireDac,      // mysql5.1
     etFireDac,      // mssqlazure
     etElevateDB,   // elevatedb
     etFireDac,      // sqlite3
     etFireDac,      // postgresql
     etFireDac,      // firebird3
     etFireDac,      // sqlserver2016
     etFireDac,      // mysql57
     etFireDac,      // interbase2017
     {$IFDEF AURELIUS_DLL}etFireDac,{$ENDIF} // sqlanywhere
     etFireDac       // postgresql 11
     //advantage disabled: etAdvantage    // advantage
    );

function DatabaseTypes: TDatabaseTypes;
begin
  if vDatabaseTypes = nil then
    vDatabaseTypes := TDatabaseTypes.Create;
  result := vDatabaseTypes;
end;

{ TDatabaseTypes }

function TDatabaseTypes.Add(AID: string; AEngineType: TDBEngineType): TDatabaseType;
begin
  result := TDatabaseType(inherited Add);
  result.DatabaseTypeID := AID;
  result.EngineType := AEngineType;
end;

constructor TDatabaseTypes.Create;
begin
  inherited Create(TDatabaseType);
  LoadDatabaseTypes;
end;

function TDatabaseTypes.FindByCaption(ACaption: string): TDatabaseType;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if SameText(Items[i].Caption, ACaption) then
    begin
      result := Items[i];
      exit;
    end;
  result := nil;
end;

function TDatabaseTypes.FindByID(AID: string): TDatabaseType;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].DatabaseTypeID = AID then
    begin
      result := Items[i];
      exit;
    end;
  result := nil;
end;

function TDatabaseTypes.GetItem(i: integer): TDatabaseType;
begin
  result := TDatabaseType(inherited Items[i]);
end;

procedure TDatabaseTypes.LoadAbsoluteDBExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '[';
  AList.Values[SQL_CLOSEDELIMITEDID] := ']';
  AList.Values[SQL_DEFAULTTERMINATOR] := ';'#13#10;
  AList.Values[SQL_FIELDNULL] :=
    '"NOT NULL",""';
    { False, True }


  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY (<%ColumnDefinition%>)';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY (<%ColumnDefinition%>)';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY (<%ColumnDefinition%>)';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY (<%ColumnDefinition%>)';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    '';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    '';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    ''; //Not aplicable

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    ''; //Not aplicable

  AList.Values[SQL_CONSTRAINTPK] :=
    '{PRIMARY KEY{ <%ConstraintPkName%>} (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    '';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    '';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    ''; //Not aplicable for FB

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    ''; //Not aplicable for FB

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD (<%ConstraintPk%>)';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  ADD (<%ColumnDefinition%>)';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';



  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    '';

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    '';

  AList.Values[SQL_CREATERELATIONSHIP] :=
    '';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+                      
    '  <%ColumnDefinition%>';

  AList.Values['ColumnDefinition'] :=
    '<%FieldName%> <%FieldType%>{ <%FieldNull%>}{ DEFAULT <%FieldDefault%>}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,'#13#10+
    '  <%TableLstConstraints%>}'#13#10+
    ')';

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    '';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    '';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    '';

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    '';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    'DROP INDEX <%TableName%>.<%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%TableName%>.<%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    '';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    '';

  AList.Values[SQL_RENAMEFIELD] :=
    'ALTER TABLE <%TableName%> RENAME COLUMN <%FieldOldName%> TO <%FieldName%>';

  AList.Values[SQL_RENAMETABLE] :=
    'ALTER TABLE <%TableOldName%> RENAME TO <%TableName%>';


  AList.Values[SQL_CREATEDOMAIN] :=
    '';

  AList.Values[SQL_REMOVEDOMAIN] :=
    '';

  AList.Values[SQL_CHANGEDOMAIN] :=
    '';
end;

procedure TDatabaseTypes.LoadDatabaseTypes;
var
  fdb: TFixedDBType;
  dbtype: TDatabaseType;
begin
  Clear;
  for fdb := Succ(Low(TFixedDBType)) to High(TFixedDBType) do
  begin
    dbtype := Add(FixedDBTypeID[fdb], FixedDBEngineType[fdb]);
    dbtype.Caption := FixedDBTypeCaption[fdb];
    case fdb of
      fdbUnknown: ;
      fdbSqlServer2000:
        dbtype.OnLoadScriptExpressions := LoadSqlServer2000Expressions;
      fdbSqlServer2005:
        dbtype.OnLoadScriptExpressions := LoadSqlServer2005Expressions;
      fdbSqlServer2008:
        dbtype.OnLoadScriptExpressions := LoadSqlServer2008Expressions;
      fdbSqlServer2016:
        dbtype.OnLoadScriptExpressions := LoadSqlServer2016Expressions;
      fdbSqlAzure:
        dbtype.OnLoadScriptExpressions := LoadSqlAzureExpressions;
      fdbFirebird2:
        dbtype.OnLoadScriptExpressions := TFirebirdDatabaseType.LoadFirebird2Expressions;
      fdbFirebird3:
        dbtype.OnLoadScriptExpressions := TFirebirdDatabaseType.LoadFirebird3Expressions;
      fdbInterbase2017:
        dbtype.OnLoadScriptExpressions := TFirebirdDatabaseType.LoadInterbase2017Expressions;
      fdbAbsoluteDB:
        dbtype.OnLoadScriptExpressions := LoadAbsoluteDBExpressions;
      fdbNexusDB3:
        dbtype.OnLoadScriptExpressions := LoadNexusDB3Expressions;
      fdbMySQL51:
        dbtype.OnLoadScriptExpressions := LoadMySQLExpressions;
      fdbMySQL57:
        dbtype.OnLoadScriptExpressions := LoadMySQLExpressions;
      fdbOracle10g:
        dbtype.OnLoadScriptExpressions := LoadOracle10gExpressions;
      fdbElevateDB:
        dbtype.OnLoadScriptExpressions := LoadElevateDBExpressions;
      fdbSQLite3:
        dbtype.OnLoadScriptExpressions := LoadSQLiteExpressions;
      fdbPostgreSQL9, fdbPostgreSQL11:
        dbtype.OnLoadScriptExpressions := TPostgreSQLDatabaseType.LoadPostgreSQLExpressions;
      //advantage disabled: fdbAdvantage:
      //  dbtype.OnLoadScriptExpressions := LoadAdvantageExpressions;
      {$IFDEF AURELIUS_DLL}
      fdbSqlAnywhere:
        dbtype.OnLoadScriptExpressions := TSqlAnywhereDatabaseType.LoadSQLAnywhereExpressions;
      {$ENDIF}
    end;
    dbtype.LoadDatabaseFeatures;
  end;
end;

procedure TDatabaseTypes.LoadElevateDBExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '"';
  AList.Values[SQL_CLOSEDELIMITEDID] := '"';
  AList.Values[SQL_DEFAULTTERMINATOR] := #13#10'!'#13#10;

  AList.Values[SQL_FIELDNULL] := '"NOT NULL",""'; // False, True

  AList.Values['ColumnDefinition'] :=
    '<%FieldType%>{<%FieldExpression%>}{ DEFAULT <%FieldDefault%>}{ <%FieldNull%>}';

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldDefault")="", "DROP DEFAULT", "SET DEFAULT " + Expr("FieldDefault"))%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%> AS'#13#10+
    '  <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%> AS'#13#10+
    '  <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%> AS'#13#10+
    '  <%ColumnDefinition%>';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    'CONSTRAINT <%ConstraintCheckName%> CHECK (<%ConstraintCheckExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    'CONSTRAINT <%ConstraintCheckFldName%> CHECK (<%ConstraintCheckFldExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    '';

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    '';

  AList.Values[SQL_CONSTRAINTPK] :=
    '{{CONSTRAINT <%ConstraintPkName%> }PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    '';

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    '';

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintPk%>';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  ADD <%FieldName%> <%ColumnDefinition%>';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELDORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_CREATEINDEX] :=
    '<%=IIF(Expr("IndexType")="", "CREATE INDEX " + Expr("IndexName") + " ON " + Expr("TableName"), '+
    '"ALTER TABLE " + Expr("TableName") + " ADD CONSTRAINT " + Expr("IndexName") + " UNIQUE")%>'#13#10+
    '  (<%IndexLstFields%>)';

  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',RESTRICT,,,RESTRICT,RESTRICT';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',RESTRICT,,,RESTRICT,RESTRICT';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, dmNoAction }

  AList.Values[SQL_CREATERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '  FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '  REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '  ON DELETE <%RelDeleteAction%>}{'#13#10+
    '  ON UPDATE <%=IIF(Expr("RelDeleteAction")="", Expr("RelUpdateAction"), "")%>}';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> <%FieldType%>{<%FieldExpression%>}{ DEFAULT <%FieldDefault%>}{ <%FieldNull%>}{ <%ConstraintCheckFldExpr%>}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,'#13#10+
    '  <%TableLstConstraints%>}'#13#10+
    ')';

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckFldName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    '';

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    '';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    '';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%IndexName%> FROM <%TableName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%> FROM <%TableName%>';

  AList.Values[SQL_RENAMEFIELD] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  RENAME COLUMN <%FieldOldName%> TO <%FieldName%>';

  AList.Values[SQL_RENAMETABLE] :=
    'RENAME TABLE <%TableOldName%> TO <%TableName%>';

  AList.Values[SQL_CREATEDOMAIN] :=
    'Domains not supported.';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'Domains not supported';

  AList.Values[SQL_CHANGEDOMAIN] :=
    'Domains not supported';
end;

procedure TDatabaseTypes.LoadNexusDB3Expressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '"';
  AList.Values[SQL_CLOSEDELIMITEDID] := '"';
  AList.Values[SQL_DEFAULTTERMINATOR] := ';'#13#10;
  AList.Values[SQL_FIELDNULL] := '"NOT NULL",""'; { False, True }

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldDefault")="", "DROP DEFAULT", "SET DEFAULT " + Expr("FieldDefault"))%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldNull")="", "DROP", "ADD")%> CONSTRAINT NOT NULL';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'Changing field size not supported. Field: "<%TableName%>"."<%FieldName%>".'#13#10+
    '  New field type: <%FieldType%>.';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'Changing field type not supported. Field: "<%TableName%>"."<%FieldName%>".'#13#10+
    '  New field type: <%FieldType%>.';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    'CONSTRAINT <%ConstraintCheckName%> CHECK (<%ConstraintCheckExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    'CONSTRAINT <%ConstraintCheckFldName%> CHECK (<%ConstraintCheckFldExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    'Default constraint name not supported. Name: <%ConstraintDefaultName%>';

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    'Not null constraint name not supported. Name: <%ConstraintNotNullName%>';

  AList.Values[SQL_CONSTRAINTPK] :=
    '{{CONSTRAINT <%ConstraintPkName%> }PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldDefault%>';

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldNotNull%>';

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintPk%>';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> ADD <%FieldName%>'#13#10+
    '  <%FieldType%>{'#13#10+
    '  DEFAULT <%FieldDefault%>} <%FieldNull%> {'#13#10+
    '  DESCRIPTION <%FieldDescription%>}';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';

  AList.Values[SQL_CREATERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '  FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '  REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '  ON DELETE <%RelDeleteAction%>}{'#13#10+
    '  ON UPDATE <%RelUpdateAction%>}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> {'#13#10+
    '  DESCRIPTION <%TableDescription%>'#13#10'} '+
    ' (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,'#13#10+
    '  <%TableLstConstraints%>}'#13#10+
    ')';

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',,CASCADE,"SET NULL","SET DEFAULT",';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',,CASCADE,"SET NULL","SET DEFAULT",';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, umNoAction }

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckFldName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintDefaultName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintNotNullName%>';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%TableName%>.<%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%>';

  AList.Values[SQL_RENAMEFIELD] :=
    'Renaming field from "<%TableName%>.<%FieldOldName%>" to "<%FieldName%>" not supported.';

  AList.Values[SQL_RENAMETABLE] :=
    'Renaming table from "<%TableOldName%>" to "<%TableName%>" not supported.';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> {<%FieldType%>}{'#13#10+
    '    CONSTRAINT <%ConstraintDefaultName%>}{ DEFAULT <%FieldDefault%>}{ <%FieldNull%>}{'#13#10+
    '    {CONSTRAINT <%ConstraintCheckFldName%> }CHECK (<%ConstraintCheckFldExpr%>)}';


  AList.Values[SQL_CREATEDOMAIN] :=
    'Domains creation not supported.';
//    'CREATE TYPE <%DomainName%> '#13#10+
//    '  FROM <%DomainType%>';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'Domains not supported.';
//    'DROP TYPE <%DomainName%>';

  AList.Values[SQL_CHANGEDOMAIN] :=
    'Domains not supported.';
//    '<%RemoveDomain%>;'#13#10 +
//    '<%CreateDomain%>';
end;

procedure TDatabaseTypes.LoadMySQLExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '`';
  AList.Values[SQL_CLOSEDELIMITEDID] := '`';
  AList.Values[SQL_DEFAULTTERMINATOR] := ';'#13#10;
  AList.Values[SQL_FIELDNULL] := '"NOT NULL",""'; // False, True

  AList.Values['ColumnDefinition'] :=
    '<%FieldName%> <%FieldType%>{<%FieldExpression%>}{ <%FieldNull%>}{ DEFAULT <%FieldDefault%>}';

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    'CONSTRAINT <%ConstraintCheckName%> CHECK (<%ConstraintCheckExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    'CONSTRAINT <%ConstraintCheckFldName%> CHECK (<%ConstraintCheckFldExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    'CONSTRAINT <%ConstraintNotNullName%> <%FieldNull%>';

  AList.Values[SQL_CONSTRAINTPK] :=
    '{PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldNotNull%>';

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintPk%>';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  ADD <%ColumnDefinition%>';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';

  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',RESTRICT,CASCADE,"SET NULL","SET DEFAULT","NO ACTION"';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',RESTRICT,CASCADE,"SET NULL","SET DEFAULT","NO ACTION"';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, umNoAction }

  AList.Values[SQL_CREATERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '  FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '  REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '  ON DELETE <%RelDeleteAction%>}{'#13#10+
    '  ON UPDATE <%RelUpdateAction%>}';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> {<%FieldType%>}{<%FieldExpression%>}{ <%FieldNull%>}{ DEFAULT <%FieldDefault%>}{ <%ConstraintCheckFldExpr%>}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,'#13#10+
    '  <%TableLstConstraints%>}'#13#10+
    ')';

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckFldName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintNotNullName%>';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%IndexName%> ON <%TableName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP FOREIGN KEY <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%>';
                                  
  AList.Values[SQL_RENAMEFIELD] :=
    'Renaming field from "<%TableName%>.<%FieldOldName%>" to "<%FieldName%>" not supported.';

  AList.Values[SQL_RENAMETABLE] :=
    'Renaming table from "<%TableOldName%>" to "<%TableName%>" not supported.';

  AList.Values[SQL_CREATEDOMAIN] :=
    'Domains not supported.';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'Domains not supported';

  AList.Values[SQL_CHANGEDOMAIN] :=
    'Domains not supported';
end;

procedure TDatabaseTypes.LoadOracle10gExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '"';
  AList.Values[SQL_CLOSEDELIMITEDID] := '"';
  AList.Values[SQL_DEFAULTTERMINATOR] := #13#10'/'#13#10;
  AList.Values[SQL_FIELDNULL] := '"NOT NULL",""'; // False, True

  AList.Values['ColumnDefinition'] :=
    '<%FieldName%> <%FieldType%>{ DEFAULT <%FieldDefault%>}{ <%FieldNull%>}';

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    'CONSTRAINT <%ConstraintCheckName%> CHECK (<%ConstraintCheckExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    'CONSTRAINT <%ConstraintCheckFldName%> CHECK (<%ConstraintCheckFldExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    'CONSTRAINT <%ConstraintNotNullName%> <%FieldNull%>';

  AList.Values[SQL_CONSTRAINTPK] :=
    '{{CONSTRAINT <%ConstraintPkName%> }PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldNotNull%>';

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintPk%>';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  ADD <%ColumnDefinition%>';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';

  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',,CASCADE,"SET NULL",,';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',,,,,';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, umNoAction }

  AList.Values[SQL_CREATERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '  FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '  REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '  ON DELETE <%RelDeleteAction%>}';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> {<%FieldType%>}{ DEFAULT <%FieldDefault%>}{{ CONSTRAINT <%ConstraintNotNullName%>} <%FieldNull%>}{'#13#10+
    '    {CONSTRAINT <%ConstraintCheckFldName%> }CHECK (<%ConstraintCheckFldExpr%>)}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,'#13#10+
    '  <%TableLstConstraints%>}'#13#10+
    ')';

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckFldName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintNotNullName%>';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%>';
    
  AList.Values[SQL_RENAMEFIELD] :=
    'ALTER TABLE <%TableName%> RENAME COLUMN <%FieldOldName%> TO <%FieldName%>';

  AList.Values[SQL_RENAMETABLE] :=
    'ALTER TABLE <%TableOldName%> RENAME TO <%TableName%>';

  AList.Values['CreateSequence'] :=
    'CREATE SEQUENCE <%objectname%>';

  AList.Values[SQL_CREATEDOMAIN] :=
    'Domains not supported.';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'Domains not supported';

  AList.Values[SQL_CHANGEDOMAIN] :=
    'Domains not supported';
end;

procedure TDatabaseTypes.LoadSqlAzureExpressions(AList: TStrings);
begin
  LoadSQLServerBaseExpressions(AList);
end;

procedure TDatabaseTypes.LoadSQLiteExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '[';
  AList.Values[SQL_CLOSEDELIMITEDID] := ']';
  AList.Values[SQL_DEFAULTTERMINATOR] := ';'#13#10;
  AList.Values[SQL_FIELDNULL] := '"NOT NULL","NULL"'; // False, True

  AList.Values['ColumnDefinition'] :=
    '<%FieldName%> <%FieldType%>{<%FieldExpression%>}{ <%ConstraintFldNotNull%>}{ <%ConstraintFldDefault%>}';

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    '*** Default value changed in table <%TableName%> '#13#10 +
    '*** New definition: <%ColumnDefinition%> '#13#10 +
    '*** SQLite does not support changing default value of fields';
//    ALTER TABLE <%TableName%> '#13#10+
//    '  MODIFY <%ColumnDefinition%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    '*** Null/Not null changed in table <%TableName%> '#13#10 +
    '*** New definition: <%ColumnDefinition%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    '*** Field size changed in table <%TableName%> '#13#10 +
    '*** New definition: <%ColumnDefinition%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    '*** Field type changed in table <%TableName%> '#13#10 +
    '*** New definition: <%ColumnDefinition%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    #13#10 + '  {CONSTRAINT <%ConstraintCheckName%> }CHECK (<%ConstraintCheckExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    '{{CONSTRAINT <%ConstraintCheckFldName%> }CHECK (<%ConstraintCheckFldExpr%>)}';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    '{{CONSTRAINT <%ConstraintDefaultName%> }DEFAULT <%FieldDefault%>}';

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    '{{CONSTRAINT <%ConstraintNotNullName%> }<%FieldNull%>}';

  AList.Values[SQL_CONSTRAINTPK] :=
    '{{CONSTRAINT <%ConstraintPkName%> }PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    '*** Table check constraint added to table <%TableName%> '#13#10 +
    '*** definition: <%ConstraintCheck%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    '*** Field check constraint added to table <%TableName%> '#13#10 +
    '*** definition: <%ConstraintFldCheck%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    '*** Not null constraint added to table <%TableName%> '#13#10 +
    '*** definition: <%ConstraintFldNotNull%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    '*** Primary key constraint added to table <%TableName%> '#13#10 +
    '*** definition: <%ConstraintPk%> '#13#10 +
    '*** SQLite does not support such modification, do it manually';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> '#13#10+
    '  ADD <%ColumnDefinition%>';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';

  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    '"NO ACTION",RESTRICT,CASCADE,"SET NULL","SET DEFAULT","NO ACTION"';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    '"NO ACTION",RESTRICT,CASCADE,"SET NULL","SET DEFAULT","NO ACTION"';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, umNoAction }

  AList.Values[SQL_CREATERELATIONSHIP] :=
    '*** Foreign key constraint added to table <%TableName%> '#13#10 +
    '*** SQLite does not support such modification, do it manually'#13#10 +
    '*** definition: '#13#10+
    '*** ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '***   FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '***   REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '***   ON DELETE <%RelDeleteAction%>}{'#13#10+
    '***   ON UPDATE <%RelUpdateAction%>}';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> {<%FieldType%>}{<%FieldExpression%>}{ <%ConstraintFldNotNull%>}{ <%ConstraintFldDefault%>}{ <%constraintfldcheck%>}';

  AList.Values[SQL_CONSTRAINTRELATIONSHIP] :=
    #13#10 +
    '  {CONSTRAINT <%RelName%> }FOREIGN KEY (<%RelChildFields%>)' +
    ' REFERENCES <%RelParentTable%> (<%RelParentFields%>){' +
    ' ON DELETE <%RelDeleteAction%>}{' +
    ' ON UPDATE <%RelUpdateAction%>}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,<%TableLstConstraints%>}{,<%TableLstRelationships%>}'#13#10+
    ')';

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    '*** Constraint removed. '#13#10 +
    '*** SQLite does not support such modification, do it manually. '#13#10 +
    '*** ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    '*** Constraint removed. '#13#10 +
    '*** SQLite does not support such modification, do it manually. '#13#10 +
    '*** ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckFldName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    ''; // N/A

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    '*** Constraint removed. '#13#10 +
    '*** SQLite does not support such modification, do it manually. '#13#10 +
    '*** ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintNotNullName%>';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    '*** Constraint removed. '#13#10 +
    '*** SQLite does not support such modification, do it manually. '#13#10 +
    '*** ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    '*** Field removed. '#13#10 +
    '*** SQLite does not support such modification, do it manually. '#13#10 +
    '*** ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    '*** Foreign key removed. '#13#10 +
    '*** SQLite does not support such modification, do it manually. '#13#10 +
    '*** ALTER TABLE <%TableName%> DROP FOREIGN KEY <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%>';

  AList.Values[SQL_RENAMEFIELD] :=
    'Renaming field from "<%TableName%>.<%FieldOldName%>" to "<%FieldName%>" not supported.';

  AList.Values[SQL_RENAMETABLE] :=
    'ALTER TABLE <%TableOldName%> RENAME TO <%TableName%>';

  AList.Values[SQL_CREATEDOMAIN] :=
    'Domains not supported.';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'Domains not supported';

  AList.Values[SQL_CHANGEDOMAIN] :=
    'Domains not supported';
end;

procedure TDatabaseTypes.LoadSqlServer2000Expressions(AList: TStrings);
begin
  LoadSQLServerBaseExpressions(AList);

  {The base expressions are based on sql server 2005. Change some expressions
   to be specific to sql 2000}
  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',,CASCADE,,,,';

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',,CASCADE,,,,';
end;

procedure TDatabaseTypes.LoadSqlServer2005Expressions(AList: TStrings);
begin
  LoadSQLServerBaseExpressions(AList);
end;

procedure TDatabaseTypes.LoadSqlServer2008Expressions(AList: TStrings);
begin
  LoadSQLServerBaseExpressions(AList);
end;

procedure TDatabaseTypes.LoadSqlServer2016Expressions(AList: TStrings);
begin
  LoadSQLServerBaseExpressions(AList);
end;

procedure TDatabaseTypes.LoadSqlServerBaseExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '[';
  AList.Values[SQL_CLOSEDELIMITEDID] := ']';
  AList.Values[SQL_DEFAULTTERMINATOR] := #13#10'GO'#13#10;

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    '<%=IIF(Expr("OldConstraintDefaultName")="", "", '+
    '"ALTER TABLE " + Expr("TableName") + " DROP CONSTRAINT " + Expr("OldConstraintDefaultName") + " " + Expr("DefaultTerminator") '+
    ')%>'+
    '<%CreateConstraintFldDefault%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%FieldType%> <%FieldNullCheck%>';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%FieldType%> <%FieldNullCheck%>';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%FieldType%> <%FieldNullCheck%>';

  AList.Values[SQL_CONSTRAINTCHECK] :=
    'CONSTRAINT <%ConstraintCheckName%> CHECK (<%ConstraintCheckExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDCHECK] :=
    'CONSTRAINT <%ConstraintCheckFldName%> CHECK (<%ConstraintCheckFldExpr%>)';

  AList.Values[SQL_CONSTRAINTFLDDEFAULT] :=
    'CONSTRAINT <%ConstraintDefaultName%> DEFAULT <%FieldDefault%> FOR <%FieldName%>';

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    'CONSTRAINT <%ConstraintNotNullName%> <%FieldNullCheck%>';

  AList.Values[SQL_CONSTRAINTPK] :=
    '{{CONSTRAINT <%ConstraintPkName%> }PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldDefault%>';

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldNotNull%>';

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintPk%>';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> ADD <%FieldName%>'#13#10+
    '  {<%FieldType%>}{AS <%FieldExpression%>} <%FieldNullCheck%>{'#13#10+
    '  {CONSTRAINT <%ConstraintDefaultName%> }DEFAULT <%FieldDefault%>}';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';

  AList.Values[SQL_CREATERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '  FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '  REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '  ON DELETE <%RelDeleteAction%>}{'#13#10+
    '  ON UPDATE <%RelUpdateAction%>}';

  AList.Values[SQL_CREATETABLE] :=
    'CREATE TABLE <%TableName%> (<%TableLstFields%>{,'#13#10+
    '  <%ConstraintPk%>}{,'#13#10+
    '  <%TableLstConstraints%>}'#13#10+
    ')';

  AList.Values[SQL_FIELDNULL] :=   
    '"NOT NULL","NULL"';
    { False, True }

  // FieldNullCheck returns an empty string when field has no physical
  // type expression (like in computed columns), since SQL Server does
  // not allow NULL/NOT NULL constraints for these field types.
  AList.Values['FieldNullCheck'] :=
    '<%=IIF(Expr("FieldType")="", "", Expr("FieldNull"))%>';

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>{ <%IndexFieldOrder%>}';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',,CASCADE,"SET NULL","SET DEFAULT",';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',,CASCADE,"SET NULL","SET DEFAULT",';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, umNoAction }

  AList.Values[SQL_REMOVECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintCheckFldName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDDEFAULT] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintDefaultName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintNotNullName%>';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP COLUMN <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%TableName%>.<%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%>';

  AList.Values[SQL_RENAMEFIELD] :=
    'EXEC sp_rename ''<%TableName%>.<%FieldOldName%>'','''+
    '<%=Copy(Expr("FieldName"), 2, Length(Expr("FieldName")) - 2)%>'+
    ''',''COLUMN''';

  AList.Values[SQL_RENAMETABLE] :=
    'EXEC sp_rename ''<%TableOldName%>'','''+
    '<%=Copy(Expr("TableName"), 2, Length(Expr("TableName")) - 2)%>'+
    '''';

  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> {<%FieldType%>}{AS <%FieldExpression%>}{ <%FieldNullCheck%>}{'#13#10+
    '    CONSTRAINT <%ConstraintDefaultName%>}{ DEFAULT <%FieldDefault%>}{'#13#10+
    '    {CONSTRAINT <%ConstraintCheckFldName%> }CHECK (<%ConstraintCheckFldExpr%>)}';

  AList.Values[SQL_CREATEDOMAIN] :=
    'CREATE TYPE <%DomainName%> '#13#10+
    '  FROM <%DomainType%>';
    (*#13#10+
    '  DEFAULT <%DomainDefault%>}{'#13#10+
    '  CHECK <%DomainCheckExpr%>}';}*)

  AList.Values[SQL_REMOVEDOMAIN] :=
    'DROP TYPE <%DomainName%>';

  AList.Values[SQL_CHANGEDOMAIN] :=
    '<%RemoveDomain%>;'#13#10 +
    '<%CreateDomain%>';
end;

procedure TDatabaseTypes.SetItem(i: integer; const Value: TDatabaseType);
begin
  Items[i].Assign(Value);
end;

{ TDatabaseType }

constructor TDatabaseType.Create(Collection: TCollection);
begin
  inherited;
  FReservedWords := TStringList.Create;
  FDataTypes := TGDAODataTypes.Create(nil);
  FEnableRelationships := true;
  FEnableTableTriggers := true;
  FEnableTableConstraints := true;
  FScriptObjectComments := false;
  FUniqueKeyWithSpecificSyntax := false;
end;

destructor TDatabaseType.Destroy;
begin
  FReservedWords.Free;
  FDataTypes.Free;
  inherited;
end;

function TDatabaseType.GetDisplayName: string;
begin
  result := FCaption;
end;

function TDatabaseType.IsReservedWord(AName: string): boolean;
begin
  result := (FReservedWords.IndexOf(AName) >= 0);
end;

procedure TDatabaseType.LoadDatabaseFeatures;
begin
  LoadReservedWords;
  case TDBProperties.GetFixedDatabaseType(Self) of
    fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlAzure, fdbSqlServer2016:
      begin
        EnableIndexOrderByField := True;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := True;
        EnableConstraintDefaultName := True;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := True;
        MaxIdentifierLength := 128;
        DropConstraintsBeforeFieldDrop := True;
      end;
    fdbFirebird2, fdbFirebird3, fdbInterbase2017:
      begin
        EnableIndexOrderByField := False;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := True;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := True;
        ScriptObjectComments := True;
        UseProcedureHeaders := True;
        MaxIdentifierLength := 31;
        UniqueKeyWithSpecificSyntax := true;
        EnableNotNullInDomains := true;
        EnableConstraintInDomains := true;
        EnableDefaultInDomains := true;
      end;
    fdbAbsoluteDB:
      begin
        EnableIndexOrderByField := True;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := False;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := False;
        MaxIdentifierLength := 255;
        EnableTableTriggers := false;
        EnableRelationships := false;
        EnableTableConstraints := false;
      end;
    fdbNexusDB3:
      begin
        EnableIndexOrderByField := True;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := True;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := False;
        MaxIdentifierLength := 128;
        EnableTableTriggers := True;
        EnableRelationships := True;
        EnableTableConstraints := True;
      end;
    fdbOracle10g:
      begin
        EnableIndexOrderByField := True;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := True;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := True;
        EnableDomainsInDatabase := False;
        MaxIdentifierLength := 30;
      end;
    fdbMySQL51, fdbMySQL57:
      begin
        EnableIndexOrderByField := False;
        EnableConstraintPkName := False;
        EnableConstraintCheckFldName := False;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := False;
        EnableTableConstraints := False;
        MaxIdentifierLength := 64;
      end;
    fdbElevateDB:
      begin
        EnableIndexOrderByField := true;
        EnableConstraintPkName := false;
        EnableConstraintCheckFldName := false;
        EnableConstraintDefaultName := false;
        EnableConstraintNotNullName := false;
        EnableDomainsInDatabase := false;
        EnableTableConstraints := true;
        MaxIdentifierLength := 40;
      end;
    fdbSQLite3:
      begin
        EnableIndexOrderByField := true;
        EnableConstraintPkName := true;
        EnableConstraintCheckFldName := true;
        EnableConstraintDefaultName := true;
        EnableConstraintNotNullName := false;
        EnableDomainsInDatabase := false;

        ScriptObjectComments := False;
        MaxIdentifierLength := 255; // Actually it's unlimited

        EnableTableTriggers := true;
        EnableRelationships := true;
        EnableTableConstraints := true;

        RelationshipsInTablesOnly := true;
      end;

    fdbPostgreSQL9, fdbPostgreSQL11:
      begin
        EnableIndexOrderByField := True;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := True;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := True;
        EnableTableConstraints := True;
        MaxIdentifierLength := 63;
      end;

    {$IFDEF AURELIUS_DLL}
    fdbSqlAnywhere:
      begin
        EnableIndexOrderByField := True;
        EnableConstraintPkName := True;
        EnableConstraintCheckFldName := True;
        EnableConstraintDefaultName := False;
        EnableConstraintNotNullName := False;
        EnableDomainsInDatabase := True;
        EnableTableConstraints := True;
        MaxIdentifierLength := 127;
      end;
    {$ENDIF}

    //advantage disabled: fdbAdvantage:
    //  begin
    //    EnableGenerateSqlScript := True;
    //    //advantage
    //  end;
  end;
end;

procedure TDatabaseType.LoadReservedWords;
var
  AList: TStrings;
begin
  AList := FReservedWords;

  AList.Clear;
  case TDBProperties.GetFixedDatabaseType(Self) of
    fdbSqlServer2000:
      begin
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('AUTHORIZATION');
        AList.Add('BACKUP');
        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BREAK');
        AList.Add('BROWSE');
        AList.Add('BULK');
        AList.Add('BY');
        AList.Add('CASCADE');
        AList.Add('CASE');
        AList.Add('CHECK');
        AList.Add('CHECKPOINT');
        AList.Add('CLOSE');
        AList.Add('CLUSTERED');
        AList.Add('COALESCE');
        AList.Add('COLLATE');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('COMPUTE');
        AList.Add('CONSTRAINT');
        AList.Add('CONTAINS');
        AList.Add('CONTAINSTABLE');
        AList.Add('CONTINUE');
        AList.Add('CONVERT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');
        AList.Add('CURSOR');
        AList.Add('DATABASE');
        AList.Add('DBCC');
        AList.Add('DEALLOCATE');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DELETE');
        AList.Add('DENY');
        AList.Add('DESC');
        AList.Add('DISK');
        AList.Add('DISTINCT');
        AList.Add('DISTRIBUTED');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('DUMMY');
        AList.Add('DUMP');
        AList.Add('ELSE');
        AList.Add('END');
        AList.Add('ERRLVL');
        AList.Add('ESCAPE');
        AList.Add('EXEC');
        AList.Add('EXECUTE');
        AList.Add('EXCEPT');
        AList.Add('EXISTS');
        AList.Add('EXIT');
        AList.Add('FETCH');
        AList.Add('FILE');
        AList.Add('FILLFACTOR');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FREETEXT');
        AList.Add('FREETEXTTABLE');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('FUNCTION');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('HOLDLOCK');
        AList.Add('IDENTITY');
        AList.Add('IDENTITYCOL');
        AList.Add('IDENTITY_INSERT');
        AList.Add('IF');
        AList.Add('IN');
        AList.Add('INDEX');
        AList.Add('INNER');
        AList.Add('INSERT');
        AList.Add('INTERSECT');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('KILL');
        AList.Add('LEFT');
        AList.Add('LIKE');
        AList.Add('LINENO');
        AList.Add('LOAD');
        AList.Add('NATIONAL');
        AList.Add('NOCHECK');
        AList.Add('NONCLUSTERED');
        AList.Add('NOT');
        AList.Add('NULL');
        AList.Add('NULLIF');
        AList.Add('OF');
        AList.Add('OFF');
        AList.Add('OFFSETS');
        AList.Add('ON');
        AList.Add('OPEN');
        AList.Add('OPENDATASOURCE');
        AList.Add('OPENQUERY');
        AList.Add('OPENROWSET');
        AList.Add('OPENXML');
        AList.Add('OPTION');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUTER');
        AList.Add('OVER');
        AList.Add('PERCENT');
        AList.Add('PLAN');
        AList.Add('PRECISION');
        AList.Add('PRIMARY');
        AList.Add('PRINT');
        AList.Add('PROC');
        AList.Add('PROCEDURE');
        AList.Add('PUBLIC');
        AList.Add('RAISERROR');
        AList.Add('READ');
        AList.Add('READTEXT');
        AList.Add('RECONFIGURE');
        AList.Add('REFERENCES');
        AList.Add('REPLICATION');
        AList.Add('RESTORE');
        AList.Add('RESTRICT');
        AList.Add('RETURN');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('ROLLBACK');
        AList.Add('ROWCOUNT');
        AList.Add('ROWGUIDCOL');
        AList.Add('RULE');
        AList.Add('SAVE');
        AList.Add('SCHEMA');
        AList.Add('SELECT');
        AList.Add('SESSION_USER');
        AList.Add('SET');
        AList.Add('SETUSER');
        AList.Add('SHUTDOWN');
        AList.Add('SOME');
        AList.Add('STATISTICS');
        AList.Add('SYSTEM_USER');
        AList.Add('TABLE');
        AList.Add('TEXTSIZE');
        AList.Add('THEN');
        AList.Add('TO');
        AList.Add('TOP');
        AList.Add('TRAN');
        AList.Add('TRANSACTION');
        AList.Add('TRIGGER');
        AList.Add('TRUNCATE');
        AList.Add('TSEQUAL');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UPDATE');
        AList.Add('UPDATETEXT');
        AList.Add('USE');
        AList.Add('USER');
        AList.Add('VALUES');
        AList.Add('VARYING');
        AList.Add('VIEW');
        AList.Add('WAITFOR');
        AList.Add('WHEN');
        AList.Add('WHERE');
        AList.Add('WHILE');
        AList.Add('WITH');
        AList.Add('WRITETEXT');
      end;
    fdbSqlServer2005, fdbSqlServer2008, fdbSqlAzure, fdbSqlServer2016:
      begin
        AList.Add('ABS');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('ASSEMBLY');
        AList.Add('ASSERT');
        AList.Add('ATAN');
        AList.Add('ATAN2');
        AList.Add('ATN2');
        AList.Add('ATOMIC');
        AList.Add('AUTHORIZATION');
        AList.Add('AUTOINC');
        AList.Add('AVG');

        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BIGINT');
        AList.Add('BINARY');
        AList.Add('BLOB');
        AList.Add('BOOL');
        AList.Add('BOOLEAN');
        AList.Add('BOTH');
        AList.Add('BROUND');
        AList.Add('BY');
        AList.Add('BYTE');
        AList.Add('BYTEARRAY');

        AList.Add('CALL');
        AList.Add('CALLED');
        AList.Add('CASE');
        AList.Add('CAST');
        AList.Add('CATCH');
        AList.Add('CEIL');
        AList.Add('CEILING');
        AList.Add('CHAR');
        AList.Add('CHAR_LENGTH');
        AList.Add('CHARACTER');
        AList.Add('CHARACTER_LENGTH');
        AList.Add('CHECK');
        AList.Add('CHR');
        AList.Add('CLOB');
        AList.Add('COALESCE');
        AList.Add('COLLATE');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('CONSTRAINT');
        AList.Add('COS');
        AList.Add('COUNT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');

        AList.Add('DATE');
        AList.Add('DATETIME');
        AList.Add('DAY');
        AList.Add('DEC');
        AList.Add('DECIMAL');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DELETE');
        AList.Add('DELETING');
        AList.Add('DETERMINISTIC');
        AList.Add('DISTINCT');
        AList.Add('DO');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('DWORD');

        AList.Add('EACH');
        AList.Add('ELSE');
        AList.Add('ELSEIF');
        AList.Add('EMPTY');
        AList.Add('END');
        AList.Add('EQUIVALENT');
        AList.Add('ERROR_MESSAGE');
        AList.Add('EXCEPT');
        AList.Add('EXISTS');
        AList.Add('EXP');
        AList.Add('EXTENDED');
        AList.Add('EXTERNAL');
        AList.Add('EXTRACT');

        AList.Add('FALSE');
        AList.Add('FLOAT');
        AList.Add('FLOOR');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('FUNCTION');

        AList.Add('GLOBAL');
        AList.Add('GROUP');
        AList.Add('GUID');

        AList.Add('HAVING');
        AList.Add('HOUR');

        AList.Add('IDENTITY');
        AList.Add('IF');
        AList.Add('IGNORE');
        AList.Add('IMAGE');
        AList.Add('IN');
        AList.Add('INDEX');
        AList.Add('INNER');
        AList.Add('INOUT');
        AList.Add('INSERT');
        AList.Add('INSERTING');
        AList.Add('INT');
        AList.Add('INTEGER');
        AList.Add('INTERSECT');
        AList.Add('INTERVAL');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ITERATE');

        AList.Add('JOIN');

        AList.Add('KEY');

        AList.Add('LANGUAGE');
        AList.Add('LARGE');
        AList.Add('LARGEINT');
        AList.Add('LAST');
        AList.Add('LASTAUTOINC');
        AList.Add('LEADING');
        AList.Add('LEAVE');
        AList.Add('LEFT');
        AList.Add('LIKE');
        AList.Add('LIST');
        AList.Add('LN');
        AList.Add('LOCAL');
        AList.Add('LOCALE');
        AList.Add('LOCALTIME');
        AList.Add('LOCALTIMESTAMP');
        AList.Add('LOWER');

        AList.Add('MATCH');
        AList.Add('MAX');
        AList.Add('MED');
        AList.Add('MIN');
        AList.Add('MINUTE');
        AList.Add('MOD');
        AList.Add('MODIFIES');
        AList.Add('MONEY');
        AList.Add('MONTH');

        AList.Add('NATIONAL');
        AList.Add('NATURAL');
        AList.Add('NCHAR');
        AList.Add('NCLOB');
        AList.Add('NEW');
        AList.Add('NEWGUID');
        AList.Add('NO');
        AList.Add('NOT');
        AList.Add('NSINGLECHAR');
        AList.Add('NULL');
        AList.Add('NULLIF');
        AList.Add('NULLSTRING');
        AList.Add('NUMERIC');
        AList.Add('NVARCHAR');

        AList.Add('OCTET_LENGTH');
        AList.Add('ODD');
        AList.Add('OF');
        AList.Add('OLD');
        AList.Add('ON');
        AList.Add('OR');
        AList.Add('ORD');
        AList.Add('ORDER');
        AList.Add('OUT');
        AList.Add('OUTER');

        AList.Add('PASSWORDS');
        AList.Add('PI');
        AList.Add('POSITION');
        AList.Add('POWER');
        AList.Add('PRECISION');
        AList.Add('PRIMARY');
        AList.Add('PROCEDURE');

        AList.Add('RAND');
        AList.Add('READS');
        AList.Add('REAL');
        AList.Add('RECREV');
        AList.Add('REFERENCES');
        AList.Add('REFERENCING');
        AList.Add('REPEAT');
        AList.Add('RETURN');
        AList.Add('RETURNS');
        AList.Add('RIGHT');
        AList.Add('ROLLBACK');
        AList.Add('ROUND');
        AList.Add('ROW');
        AList.Add('ROWSAFFECTED');
        AList.Add('ROWSREAD');

        AList.Add('SECOND');
        AList.Add('SELECT');
        AList.Add('SESSION_USER');
        AList.Add('SET');
        AList.Add('SHORTINT');
        AList.Add('SHORTSTRING');
        AList.Add('SIGNAL');
        AList.Add('SIN');
        AList.Add('SINGLECHAR');
        AList.Add('SMALLINT');
        AList.Add('SOME');
        AList.Add('SQL');
        AList.Add('SQRT');
        AList.Add('START');
        AList.Add('STD');
        AList.Add('SUBSTRING');
        AList.Add('SUM');
        AList.Add('SYSTEM_ROW#');

        AList.Add('TABLE');
        AList.Add('TEXT');
        AList.Add('THEN');
        AList.Add('TIME');
        AList.Add('TIMESTAMP');
        AList.Add('TINYINT');
        AList.Add('TO');
        AList.Add('TOSTRING');
        AList.Add('TOSTRINGLEN');
        AList.Add('TRAILING');
        AList.Add('TRIGGER');
        AList.Add('TRIM');
        AList.Add('TRUE');
        AList.Add('TRY');

        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UNKNOWN');
        AList.Add('UNTIL');
        AList.Add('UPDATE');
        AList.Add('UPDATING');
        AList.Add('UPPER');
        AList.Add('USAGE');
        AList.Add('USER');
        AList.Add('USING');

        AList.Add('VALUES');
        AList.Add('VARCHAR');
        AList.Add('VARYING');

        AList.Add('WHEN');
        AList.Add('WHERE');
        AList.Add('WHILE');
        AList.Add('WITH');
        AList.Add('WORD');

        AList.Add('YEAR');
      end;
    fdbFirebird2, fdbFirebird3, fdbInterbase2017:
      begin
        {Interbase keywords}
        AList.Add('ACTION');
        AList.Add('ACTIVE');
        AList.Add('ADD');
        AList.Add('ADMIN');
        AList.Add('AFTER');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('ASCENDING');
        AList.Add('AT');
        AList.Add('AUTO');
        AList.Add('AUTODDL');
        AList.Add('AVG');
        AList.Add('BASED');
        AList.Add('BASENAME');
        AList.Add('BASE_NAME');
        AList.Add('BEFORE');
        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BLOB');
        AList.Add('BLOBEDIT');
        AList.Add('BUFFER');
        AList.Add('BY');
        AList.Add('CACHE');
        AList.Add('CASCADE');
        AList.Add('CAST');
        AList.Add('CHAR');
        AList.Add('CHARACTER');
        AList.Add('CHARACTER_LENGTH');
        AList.Add('CHAR_LENGTH');
        AList.Add('CHECK');
        AList.Add('CHECK_POINT_LEN');
        AList.Add('CHECK_POINT_LENGTH');
        AList.Add('COLLATE');
        AList.Add('COLLATION');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('COMMITTED');
        AList.Add('COMPILETIME');
        AList.Add('COMPUTED');
        AList.Add('CLOSE');
        AList.Add('CONDITIONAL');
        AList.Add('CONNECT');
        AList.Add('CONSTRAINT');
        AList.Add('CONTAINING');
        AList.Add('CONTINUE');
        AList.Add('COUNT');
        AList.Add('CREATE');
        AList.Add('CSTRING');
        AList.Add('CURRENT');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURSOR');
        AList.Add('DATABASE');
        AList.Add('DATE');
        AList.Add('DAY');
        AList.Add('DB_KEY');
        AList.Add('DEBUG');
        AList.Add('DEC');
        AList.Add('DECIMAL');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DESCENDING');
        AList.Add('DESCRIBE');
        AList.Add('DESCRIPTOR');
        AList.Add('DISCONNECT');
        AList.Add('DISPLAY');
        AList.Add('DISTINCT');
        AList.Add('DO');
        AList.Add('DOMAIN');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('ECHO');
        AList.Add('EDIT');
        AList.Add('ELSE');
        AList.Add('END');
        AList.Add('ENTRY_POINT');
        AList.Add('ESCAPE');
        AList.Add('EVENT');
        AList.Add('EXCEPTION');
        AList.Add('EXECUTE');
        AList.Add('EXISTS');
        AList.Add('EXIT');
        AList.Add('EXTERN');
        AList.Add('EXTERNAL');
        AList.Add('EXTRACT');
        AList.Add('FETCH');
        AList.Add('FILE');
        AList.Add('FILTER');
        AList.Add('FLOAT');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FOUND');
        AList.Add('FREE_IT');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('FUNCTION');
        AList.Add('GDSCODE');
        AList.Add('GENERATOR');
        AList.Add('GEN_ID');
        AList.Add('GLOBAL');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('GROUP_COMMIT_WAIT');
        AList.Add('GROUP_COMMIT_');
        AList.Add('WAIT_TIME');
        AList.Add('HAVING');
        AList.Add('HELP');
        AList.Add('HOUR');
        AList.Add('IF');
        AList.Add('IMMEDIATE');
        AList.Add('IN');
        AList.Add('INACTIVE');
        AList.Add('INDEX');
        AList.Add('INDICATOR');
        AList.Add('INIT');
        AList.Add('INNER');
        AList.Add('INPUT');
        AList.Add('INPUT_TYPE');
        AList.Add('INSERT');
        AList.Add('INT');
        AList.Add('INTEGER');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ISOLATION');
        AList.Add('ISQL');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('LC_MESSAGES');
        AList.Add('LC_TYPE');
        AList.Add('LEFT');
        AList.Add('LENGTH');
        AList.Add('LEV');
        AList.Add('LEVEL');
        AList.Add('LIKE');
        AList.Add('LOGFILE');
        AList.Add('LOG_BUFFER_SIZE');
        AList.Add('LOG_BUF_SIZE');
        AList.Add('LONG');
        AList.Add('MAX');
        AList.Add('MAXIMUM');
        AList.Add('MAXIMUM_SEGMENT');
        AList.Add('MAX_SEGMENT');
        AList.Add('MERGE');
        AList.Add('MESSAGE');
        AList.Add('MIN');
        AList.Add('MINIMUM');
        AList.Add('MINUTE');
        AList.Add('MODULE_NAME');
        AList.Add('MONTH');
        AList.Add('NAMES');
        AList.Add('NATIONAL');
        AList.Add('NATURAL');
        AList.Add('NCHAR');
        AList.Add('NO');
        AList.Add('NOAUTO');
        AList.Add('NOT');
        AList.Add('NULL');
        AList.Add('NUMERIC');
        AList.Add('NUM_LOG_BUFS');
        AList.Add('NUM_LOG_BUFFERS');
        AList.Add('OCTET_LENGTH');
        AList.Add('OF');
        AList.Add('ON');
        AList.Add('ONLY');
        AList.Add('OPEN');
        AList.Add('OPTION');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUTER');
        AList.Add('OUTPUT');
        AList.Add('OUTPUT_TYPE');
        AList.Add('OVERFLOW');
        AList.Add('PAGE');
        AList.Add('PAGELENGTH');
        AList.Add('PAGES');
        AList.Add('PAGE_SIZE');
        AList.Add('PARAMETER');
        AList.Add('PASSWORD');
        AList.Add('PLAN');
        AList.Add('POSITION');
        AList.Add('POST_EVENT');
        AList.Add('PRECISION');
        AList.Add('PREPARE');
        AList.Add('PROCEDURE');
        AList.Add('PROTECTED');
        AList.Add('PRIMARY');
        AList.Add('PRIVILEGES');
        AList.Add('PUBLIC');
        AList.Add('QUIT');
        AList.Add('RAW_PARTITIONS');
        AList.Add('RDB$DB_KEY');
        AList.Add('READ');
        AList.Add('REAL');
        AList.Add('RECORD_VERSION');
        AList.Add('REFERENCES');
        AList.Add('RELEASE');
        AList.Add('RESERV');
        AList.Add('RESERVING');
        AList.Add('RESTRICT');
        AList.Add('RETAIN');
        AList.Add('RETURN');
        AList.Add('RETURNING_VALUES');
        AList.Add('RETURNS');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('ROLE');
        AList.Add('ROLLBACK');
        AList.Add('RUNTIME');
        AList.Add('SCHEMA');
        AList.Add('SECOND');
        AList.Add('SEGMENT');
        AList.Add('SELECT');
        AList.Add('SET');
        AList.Add('SHADOW');
        AList.Add('SHARED');
        AList.Add('SHELL');
        AList.Add('SHOW');
        AList.Add('SINGULAR');
        AList.Add('SIZE');
        AList.Add('SMALLINT');
        AList.Add('SNAPSHOT');
        AList.Add('SOME');
        AList.Add('SORT');
        AList.Add('SQLCODE');
        AList.Add('SQLERROR');
        AList.Add('SQLWARNING');
        AList.Add('STABILITY');
        AList.Add('STARTING');
        AList.Add('STARTS');
        AList.Add('STATEMENT');
        AList.Add('STATIC');
        AList.Add('STATISTICS');
        AList.Add('SUB_TYPE');
        AList.Add('SUM');
        AList.Add('SUSPEND');
        AList.Add('TABLE');
        AList.Add('TERMINATOR');
        AList.Add('THEN');
        AList.Add('TIME');
        AList.Add('TIMESTAMP');
        AList.Add('TO');
        AList.Add('TRANSACTION');
        AList.Add('TRANSLATE');
        AList.Add('TRANSLATION');
        AList.Add('TRIGGER');
        AList.Add('TRIM');
        AList.Add('TYPE');
        AList.Add('UNCOMMITTED');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UPDATE');
        AList.Add('UPPER');
        AList.Add('USER');
        AList.Add('USING');
        AList.Add('VALUE');
        AList.Add('VALUES');
        AList.Add('VARCHAR');
        AList.Add('VARIABLE');
        AList.Add('VARYING');
        AList.Add('VERSION');
        AList.Add('VIEW');
        AList.Add('WAIT');
        AList.Add('WEEKDAY');
        AList.Add('WHEN');
        AList.Add('WHENEVER');
        AList.Add('WHERE');
        AList.Add('WHILE');
        AList.Add('WITH');
        AList.Add('WORK');
        AList.Add('WRITE');
        AList.Add('YEAR');
        AList.Add('YEARDAY');


        {Keywords added in Firebird 2}
        AList.Add('BIGINT');
        AList.Add('BIT_LENGTH');
        AList.Add('BOTH');
        AList.Add('CASE');
        AList.Add('CHAR_LENGTH');
        AList.Add('CHARACTER_LENGTH');
        AList.Add('CLOSE');
        AList.Add('CROSS');
        AList.Add('CURRENT_CONNECTION');
        AList.Add('CURRENT_ROLE');
        AList.Add('CURRENT_TRANSACTION');
        AList.Add('CURRENT_USER');
        AList.Add('FETCH');
        AList.Add('LEADING');
        AList.Add('LOWER');
        AList.Add('OCTET_LENGTH');
        AList.Add('OPEN');
        AList.Add('RECREATE');
        AList.Add('RELEASE');
        AList.Add('ROW_COUNT');
        AList.Add('ROWS');
        AList.Add('SAVEPOINT');
        AList.Add('TRAILING');
        AList.Add('TRIM');
        AList.Add('USING');

        {Keywords removed in Firebird 2}
        AList.Delete(AList.IndexOf('ACTION'));
        AList.Delete(AList.IndexOf('CASCADE'));
        AList.Delete(AList.IndexOf('FREE_IT'));
        AList.Delete(AList.IndexOf('RESTRICT'));
        AList.Delete(AList.IndexOf('ROLE'));
        AList.Delete(AList.IndexOf('TYPE'));
        AList.Delete(AList.IndexOf('WEEKDAY'));
        AList.Delete(AList.IndexOf('YEARDAY'));

        {Keywords added in Firebird 3}
        if TDBProperties.GetFixedDatabaseType(Self) in [fdbFirebird3, fdbInterbase2017] then
        begin
          AList.Add('BOOLEAN');
          AList.Add('CORR');
          AList.Add('DELETING');
          AList.Add('DETERMINISTIC');
          AList.Add('FALSE');
          AList.Add('INSERTING');
          AList.Add('OFFSET');
          AList.Add('OVER');
          AList.Add('RETURN');
          AList.Add('ROW');
          AList.Add('SCROLL');
          AList.Add('TRUE');
          AList.Add('UNKNOWN');
          AList.Add('UPDATING');
        end;
      end;
    fdbAbsoluteDB:
      begin
        {AbsoluteDB keywords}
        AList.Add('ACTION');
        AList.Add('ABS');
        AList.Add('ABSOLUTE');
        AList.Add('ACOS');
        AList.Add('ACTION');
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALLOCATE');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('ARE');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('ASIN');
        AList.Add('ASSERTION');
        AList.Add('AT');
        AList.Add('ATAN');
        AList.Add('AUTHORIZATION');
        AList.Add('AUTOINC');
        AList.Add('AUTOINDEXES');
        AList.Add('AVG');
        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BIT');
        AList.Add('BIT_LENGTH');
        AList.Add('BLOBBLOCKSIZE');
        AList.Add('BLOBCOMPRESSIONALGORITHM');
        AList.Add('BLOBCOMPRESSIONMODE');
        AList.Add('BOTH');
        AList.Add('BY');
        AList.Add('CASCADE');
        AList.Add('CASCADED');
        AList.Add('CASE');
        AList.Add('CAST');
        AList.Add('CATALOG');
        AList.Add('CEIL');
        AList.Add('CHAR');
        AList.Add('CHAR_LENGTH');
        AList.Add('CHARACTER');
        AList.Add('CHARACTER_LENGTH');
        AList.Add('CHECK');
        AList.Add('CLOSE');
        AList.Add('COALESCE');
        AList.Add('COLLATE');
        AList.Add('COLLATION');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('CONNECT');
        AList.Add('CONNECTION');
        AList.Add('CONSTRAINT');
        AList.Add('CONSTRAINTS');
        AList.Add('CONTINUE');
        AList.Add('CONVERT');
        AList.Add('CORRESPONDING');
        AList.Add('COS');
        AList.Add('COUNT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');
        AList.Add('CURSOR');
        AList.Add('CYCLED');
        AList.Add('DATE');
        AList.Add('DAY');
        AList.Add('DEALLOCATE');
        AList.Add('DEC');
        AList.Add('DECIMAL');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DEFERRABLE');
        AList.Add('DEFERRED');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DESCRIBE');
        AList.Add('DESCRIPTOR');
        AList.Add('DIAGNOSTICS');
        AList.Add('DISCONNECT');
        AList.Add('DISTINCT');
        AList.Add('DOMAIN');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('ELSE');
        AList.Add('END');
        AList.Add('END-EXEC');
        AList.Add('ESCAPE');
        AList.Add('EXCEPT');
        AList.Add('EXCEPTION');
        AList.Add('EXEC');
        AList.Add('EXECUTE');
        AList.Add('EXISTS');
        AList.Add('EXP');
        AList.Add('EXTERNAL');
        AList.Add('EXTRACT');
        AList.Add('FALSE');
        AList.Add('FETCH');
        AList.Add('FIRST');
        AList.Add('FLOAT');
        AList.Add('FLOOR');
        AList.Add('FLUSH');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FOUND');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('GET');
        AList.Add('GLOBAL');
        AList.Add('GO');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('HOUR');
        AList.Add('IDENTITY');
        AList.Add('IF');
        AList.Add('IMMEDIATE');
        AList.Add('IN');
        AList.Add('INCREMENT');
        AList.Add('INDEX');
        AList.Add('INDICATOR');
        AList.Add('INITIALLY');
        AList.Add('INITIALVALUE');
        AList.Add('INNER');
        AList.Add('INPUT');
        AList.Add('INSENSITIVE');
        AList.Add('INSERT');
        AList.Add('INT');
        AList.Add('INTEGER');
        AList.Add('INTERSECT');
        AList.Add('INTERVAL');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ISOLATION');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('LANGUAGE');
        AList.Add('LAST');
        AList.Add('LASTAUTOINC');
        AList.Add('LASTVALUE');
        AList.Add('LEADING');
        AList.Add('LEFT');
        AList.Add('LENGTH');
        AList.Add('LEVEL');
        AList.Add('LIKE');
        AList.Add('LOCAL');
        AList.Add('LOG');
        AList.Add('LOWER');
        AList.Add('LTRIM');
        AList.Add('MATCH');
        AList.Add('MAX');
        AList.Add('MAXVALUE');
        AList.Add('MEMORY');
        AList.Add('MIMETOBIN');
        AList.Add('MIN');
        AList.Add('MINUS');
        AList.Add('MINUTE');
        AList.Add('MINVALUE');
        AList.Add('MODIFY');
        AList.Add('MODULE');
        AList.Add('MONTH');
        AList.Add('NAMES');
        AList.Add('NATIONAL');
        AList.Add('NATURAL');
        AList.Add('NCHAR');
        AList.Add('NEW');
        AList.Add('NEXT');
        AList.Add('NO');
        AList.Add('NOAUTOINDEXES');
        AList.Add('NOCASE');
        AList.Add('NOCYCLED');
        AList.Add('NOMAXVALUE');
        AList.Add('NOMINVALUE');
        AList.Add('NOT');
        AList.Add('NOW');
        AList.Add('NULL');
        AList.Add('NULLIF');
        AList.Add('NUMERIC');
        AList.Add('OCTET_LENGTH');
        AList.Add('OF');
        AList.Add('ON');
        AList.Add('ONLY');
        AList.Add('OPEN');
        AList.Add('OPTION');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUTER');
        AList.Add('OUTPUT');
        AList.Add('OVERLAPS');
        AList.Add('PAD');
        AList.Add('PARTIAL');
        AList.Add('PASSWORD');
        AList.Add('POS');
        AList.Add('POSITION');
        AList.Add('POWER');
        AList.Add('PRECISION');
        AList.Add('PREPARE');
        AList.Add('PRESERVE');
        AList.Add('PRIMARY');
        AList.Add('PRIOR');
        AList.Add('PRIVILEGES');
        AList.Add('PROCEDURE');
        AList.Add('PUBLIC');
        AList.Add('RAND');
        AList.Add('READ');
        AList.Add('REAL');
        AList.Add('REFERENCES');
        AList.Add('RELATIVE');
        AList.Add('RENAME');
        AList.Add('RESTRICT');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('ROLLBACK');
        AList.Add('ROUND');
        AList.Add('ROWNUM');
        AList.Add('ROWS');
        AList.Add('RTRIM');
        AList.Add('SCHEMA');
        AList.Add('SCROLL');
        AList.Add('SECOND');
        AList.Add('SECTION');
        AList.Add('SELECT');
        AList.Add('SESSION');
        AList.Add('SESSION_USER');
        AList.Add('SET');
        AList.Add('SIGN');
        AList.Add('SIN');
        AList.Add('SIZE');
        AList.Add('SMALLINT');
        AList.Add('SOME');
        AList.Add('SPACE');
        AList.Add('SQL');
        AList.Add('SQLCODE');
        AList.Add('SQLERROR');
        AList.Add('SQLSTATE');
        AList.Add('SQR');
        AList.Add('SQRT');
        AList.Add('START');
        AList.Add('SUBSTRING');
        AList.Add('SUM');
        AList.Add('SYSDATE');
        AList.Add('SYSTEM_USER');
        AList.Add('TABLE');
        AList.Add('TEMPORARY');
        AList.Add('THEN');
        AList.Add('TIME');
        AList.Add('TIMESTAMP');
        AList.Add('TIMEZONE_HOUR');
        AList.Add('TIMEZONE_MINUTE');
        AList.Add('TO');
        AList.Add('TODATE');
        AList.Add('TOP');
        AList.Add('TOSTRING');
        AList.Add('TRAILING');
        AList.Add('TRANSACTION');
        AList.Add('TRANSLATE');
        AList.Add('TRANSLATION');
        AList.Add('TRIM');
        AList.Add('TRUE');
        AList.Add('TRUNCATE');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UNKNOWN');
        AList.Add('UPDATE');
        AList.Add('UPPER');
        AList.Add('USAGE');
        AList.Add('USER');
        AList.Add('USING');
        AList.Add('VALUE');
        AList.Add('VALUES');
        AList.Add('VARCHAR');
        AList.Add('VARYING');
        AList.Add('VIEW');
        AList.Add('WHEN');
        AList.Add('WHENEVER');
        AList.Add('WHERE');
        AList.Add('WITH');
        AList.Add('WORK');
        AList.Add('WRITE');
        AList.Add('YEAR');
        AList.Add('ZONE');
      end;
    fdbNexusDB3:
      begin
        {NexusDB keywords}
        AList.Add('ACTION');
        AList.Add('ABS');
        AList.Add('ABSOLUTE');
        AList.Add('ACOS');
        AList.Add('ACTION');
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALLOCATE');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('ARE');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('ASIN');
        AList.Add('ASSERTION');
        AList.Add('AT');
        AList.Add('ATAN');
        AList.Add('AUTHORIZATION');
        AList.Add('AUTOINC');
        AList.Add('AUTOINDEXES');
        AList.Add('AVG');
        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BIT');
        AList.Add('BIT_LENGTH');
        AList.Add('BLOBBLOCKSIZE');
        AList.Add('BLOBCOMPRESSIONALGORITHM');
        AList.Add('BLOBCOMPRESSIONMODE');
        AList.Add('BOTH');
        AList.Add('BY');
        AList.Add('CASCADE');
        AList.Add('CASCADED');
        AList.Add('CASE');
        AList.Add('CAST');
        AList.Add('CATALOG');
        AList.Add('CEIL');
        AList.Add('CHAR');
        AList.Add('CHAR_LENGTH');
        AList.Add('CHARACTER');
        AList.Add('CHARACTER_LENGTH');
        AList.Add('CHECK');
        AList.Add('CLOSE');
        AList.Add('COALESCE');
        AList.Add('COLLATE');
        AList.Add('COLLATION');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('CONNECT');
        AList.Add('CONNECTION');
        AList.Add('CONSTRAINT');
        AList.Add('CONSTRAINTS');
        AList.Add('CONTINUE');
        AList.Add('CONVERT');
        AList.Add('CORRESPONDING');
        AList.Add('COS');
        AList.Add('COUNT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');
        AList.Add('CURSOR');
        AList.Add('CYCLED');
        AList.Add('DATE');
        AList.Add('DAY');
        AList.Add('DEALLOCATE');
        AList.Add('DEC');
        AList.Add('DECIMAL');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DEFERRABLE');
        AList.Add('DEFERRED');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DESCRIBE');
        AList.Add('DESCRIPTOR');
        AList.Add('DIAGNOSTICS');
        AList.Add('DISCONNECT');
        AList.Add('DISTINCT');
        AList.Add('DOMAIN');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('ELSE');
        AList.Add('END');
        AList.Add('END-EXEC');
        AList.Add('ESCAPE');
        AList.Add('EXCEPT');
        AList.Add('EXCEPTION');
        AList.Add('EXEC');
        AList.Add('EXECUTE');
        AList.Add('EXISTS');
        AList.Add('EXP');
        AList.Add('EXTERNAL');
        AList.Add('EXTRACT');
        AList.Add('FALSE');
        AList.Add('FETCH');
        AList.Add('FIRST');
        AList.Add('FLOAT');
        AList.Add('FLOOR');
        AList.Add('FLUSH');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FOUND');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('GET');
        AList.Add('GLOBAL');
        AList.Add('GO');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('HOUR');
        AList.Add('IDENTITY');
        AList.Add('IF');
        AList.Add('IMMEDIATE');
        AList.Add('IN');
        AList.Add('INCREMENT');
        AList.Add('INDEX');
        AList.Add('INDICATOR');
        AList.Add('INITIALLY');
        AList.Add('INITIALVALUE');
        AList.Add('INNER');
        AList.Add('INPUT');
        AList.Add('INSENSITIVE');
        AList.Add('INSERT');
        AList.Add('INT');
        AList.Add('INTEGER');
        AList.Add('INTERSECT');
        AList.Add('INTERVAL');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ISOLATION');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('LANGUAGE');
        AList.Add('LAST');
        AList.Add('LASTAUTOINC');
        AList.Add('LASTVALUE');
        AList.Add('LEADING');
        AList.Add('LEFT');
        AList.Add('LENGTH');
        AList.Add('LEVEL');
        AList.Add('LIKE');
        AList.Add('LOCAL');
        AList.Add('LOG');
        AList.Add('LOWER');
        AList.Add('LTRIM');
        AList.Add('MATCH');
        AList.Add('MAX');
        AList.Add('MAXVALUE');
        AList.Add('MEMORY');
        AList.Add('MIMETOBIN');
        AList.Add('MIN');
        AList.Add('MINUS');
        AList.Add('MINUTE');
        AList.Add('MINVALUE');
        AList.Add('MODIFY');
        AList.Add('MODULE');
        AList.Add('MONTH');
        AList.Add('NAMES');
        AList.Add('NATIONAL');
        AList.Add('NATURAL');
        AList.Add('NCHAR');
        AList.Add('NEW');
        AList.Add('NEXT');
        AList.Add('NO');
        AList.Add('NOAUTOINDEXES');
        AList.Add('NOCASE');
        AList.Add('NOCYCLED');
        AList.Add('NOMAXVALUE');
        AList.Add('NOMINVALUE');
        AList.Add('NOT');
        AList.Add('NOW');
        AList.Add('NULL');
        AList.Add('NULLIF');
        AList.Add('NUMERIC');
        AList.Add('OCTET_LENGTH');
        AList.Add('OF');
        AList.Add('ON');
        AList.Add('ONLY');
        AList.Add('OPEN');
        AList.Add('OPTION');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUTER');
        AList.Add('OUTPUT');
        AList.Add('OVERLAPS');
        AList.Add('PAD');
        AList.Add('PARTIAL');
        AList.Add('PASSWORD');
        AList.Add('POS');
        AList.Add('POSITION');
        AList.Add('POWER');
        AList.Add('PRECISION');
        AList.Add('PREPARE');
        AList.Add('PRESERVE');
        AList.Add('PRIMARY');
        AList.Add('PRIOR');
        AList.Add('PRIVILEGES');
        AList.Add('PROCEDURE');
        AList.Add('PUBLIC');
        AList.Add('RAND');
        AList.Add('READ');
        AList.Add('REAL');
        AList.Add('REFERENCES');
        AList.Add('RELATIVE');
        AList.Add('RENAME');
        AList.Add('RESTRICT');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('ROLLBACK');
        AList.Add('ROUND');
        AList.Add('ROWNUM');
        AList.Add('ROWS');
        AList.Add('RTRIM');
        AList.Add('SCHEMA');
        AList.Add('SCROLL');
        AList.Add('SECOND');
        AList.Add('SECTION');
        AList.Add('SELECT');
        AList.Add('SESSION');
        AList.Add('SESSION_USER');
        AList.Add('SET');
        AList.Add('SIGN');
        AList.Add('SIN');
        AList.Add('SIZE');
        AList.Add('SMALLINT');
        AList.Add('SOME');
        AList.Add('SPACE');
        AList.Add('SQL');
        AList.Add('SQLCODE');
        AList.Add('SQLERROR');
        AList.Add('SQLSTATE');
        AList.Add('SQR');
        AList.Add('SQRT');
        AList.Add('START');
        AList.Add('SUBSTRING');
        AList.Add('SUM');
        AList.Add('SYSDATE');
        AList.Add('SYSTEM_USER');
        AList.Add('TABLE');
        AList.Add('TEMPORARY');
        AList.Add('THEN');
        AList.Add('TIME');
        AList.Add('TIMESTAMP');
        AList.Add('TIMEZONE_HOUR');
        AList.Add('TIMEZONE_MINUTE');
        AList.Add('TO');
        AList.Add('TODATE');
        AList.Add('TOP');
        AList.Add('TOSTRING');
        AList.Add('TRAILING');
        AList.Add('TRANSACTION');
        AList.Add('TRANSLATE');
        AList.Add('TRANSLATION');
        AList.Add('TRIM');
        AList.Add('TRUE');
        AList.Add('TRUNCATE');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UNKNOWN');
        AList.Add('UPDATE');
        AList.Add('UPPER');
        AList.Add('USAGE');
        AList.Add('USER');
        AList.Add('USING');
        AList.Add('VALUE');
        AList.Add('VALUES');
        AList.Add('VARCHAR');
        AList.Add('VARYING');
        AList.Add('VIEW');
        AList.Add('WHEN');
        AList.Add('WHENEVER');
        AList.Add('WHERE');
        AList.Add('WITH');
        AList.Add('WORK');
        AList.Add('WRITE');
        AList.Add('YEAR');
        AList.Add('ZONE');
      end;
    fdbOracle10g:
      begin
        AList.Add('ACCESS');
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('AUDIT');
        AList.Add('BETWEEN');
        AList.Add('BY');
        AList.Add('CHAR');
        AList.Add('CHECK');
        AList.Add('CLUSTER');
        AList.Add('COLUMN');
        AList.Add('COMMENT');
        AList.Add('COMPRESS');
        AList.Add('CONNECT');
        AList.Add('CREATE');
        AList.Add('CURRENT');
        AList.Add('DATE');
        AList.Add('DECIMAL');
        AList.Add('DEFAULT');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DISTINCT');
        AList.Add('DROP');
        AList.Add('ELSE');
        AList.Add('EXCLUSIVE');
        AList.Add('EXISTS');
        AList.Add('FILE');
        AList.Add('FLOAT');
        AList.Add('FOR');
        AList.Add('FROM');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('IDENTIFIED');
        AList.Add('IMMEDIATE');
        AList.Add('IN');
        AList.Add('INCREMENT');
        AList.Add('INDEX');
        AList.Add('INITIAL');
        AList.Add('INSERT');
        AList.Add('INTEGER');
        AList.Add('INTERSECT');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('LEVEL');
        AList.Add('LIKE');
        AList.Add('LOCK');
        AList.Add('LONG');
        AList.Add('MAXEXTENTS');
        AList.Add('MINUS');
        AList.Add('MLSLABEL');
        AList.Add('MODE');
        AList.Add('MODIFY');
        AList.Add('NOAUDIT');
        AList.Add('NOCOMPRESS');
        AList.Add('NOT');
        AList.Add('NOWAIT');
        AList.Add('NULL');
        AList.Add('NUMBER');
        AList.Add('OF');
        AList.Add('OFFLINE');
        AList.Add('ON');
        AList.Add('ONLINE');
        AList.Add('OPTION');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('PCTFREE');
        AList.Add('PRIOR');
        AList.Add('PRIVILEGES');
        AList.Add('PUBLIC');
        AList.Add('RAW');
        AList.Add('RENAME');
        AList.Add('RESOURCE');
        AList.Add('REVOKE');
        AList.Add('ROW');
        AList.Add('ROWID');
        AList.Add('ROWNUM');
        AList.Add('ROWS');
        AList.Add('SELECT');
        AList.Add('SESSION');
        AList.Add('SET');
        AList.Add('SHARE');
        AList.Add('SIZE');
        AList.Add('SMALLINT');
        AList.Add('START');
        AList.Add('SUCCESSFUL');
        AList.Add('SYNONYM');
        AList.Add('SYSDATE');
        AList.Add('TABLE');
        AList.Add('THEN');
        AList.Add('TO');
        AList.Add('TRIGGER');
        AList.Add('UID');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UPDATE');
        AList.Add('USER');
        AList.Add('VALIDATE');
        AList.Add('VALUES');
        AList.Add('VARCHAR');
        AList.Add('VARCHAR2');
        AList.Add('VIEW');
        AList.Add('WHENEVER');
        AList.Add('WHERE');
        AList.Add('WITH');
      end;
    fdbMySQL51, fdbMySQL57:
      begin
        AList.Add('ACCESSIBLE');
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('ANALYZE');
        AList.Add('AND');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('ASENSITIVE');
        AList.Add('BEFORE');
        AList.Add('BETWEEN');
        AList.Add('BIGINT');
        AList.Add('BINARY');
        AList.Add('BLOB');
        AList.Add('BOTH');
        AList.Add('BY');
        AList.Add('CALL');
        AList.Add('CASCADE');
        AList.Add('CASE');
        AList.Add('CHANGE');
        AList.Add('CHAR');
        AList.Add('CHARACTER');
        AList.Add('CHECK');
        AList.Add('COLLATE');
        AList.Add('COLUMN');
        AList.Add('CONDITION');
        AList.Add('CONNECTION');
        AList.Add('CONSTRAINT');
        AList.Add('CONTINUE');
        AList.Add('CONVERT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');
        AList.Add('CURSOR');
        AList.Add('DATABASE');
        AList.Add('DATABASES');
        AList.Add('DAY_HOUR');
        AList.Add('DAY_MICROSECOND');
        AList.Add('DAY_MINUTE');
        AList.Add('DAY_SECOND');
        AList.Add('DEC');
        AList.Add('DECIMAL');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DELAYED');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DESCRIBE');
        AList.Add('DETERMINISTIC');
        AList.Add('DISTINCT');
        AList.Add('DISTINCTROW');
        AList.Add('DIV');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('DUAL');
        AList.Add('EACH');
        AList.Add('ELSE');
        AList.Add('ELSEIF');
        AList.Add('ENCLOSED');
        AList.Add('ESCAPED');
        AList.Add('EXISTS');
        AList.Add('EXIT');
        AList.Add('EXPLAIN');
        AList.Add('FALSE');
        AList.Add('FETCH');
        AList.Add('FLOAT');
        AList.Add('FLOAT4');
        AList.Add('FLOAT8');
        AList.Add('FOR');
        AList.Add('FORCE');
        AList.Add('FOREIGN');
        AList.Add('FROM');
        AList.Add('FULLTEXT');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('HIGH_PRIORITY');
        AList.Add('HOUR_MICROSECOND');
        AList.Add('HOUR_MINUTE');
        AList.Add('HOUR_SECOND');
        AList.Add('IF');
        AList.Add('IGNORE');
        AList.Add('IN');
        AList.Add('INDEX');
        AList.Add('INFILE');
        AList.Add('INNER');
        AList.Add('INOUT');
        AList.Add('INSENSITIVE');
        AList.Add('INSERT');
        AList.Add('INT');
        AList.Add('INT1');
        AList.Add('INT2');
        AList.Add('INT3');
        AList.Add('INT4');
        AList.Add('INT8');
        AList.Add('INTEGER');
        AList.Add('INTERVAL');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ITERATE');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('KEYS');
        AList.Add('KILL');
        AList.Add('LABEL');
        AList.Add('LEADING');
        AList.Add('LEAVE');
        AList.Add('LEFT');
        AList.Add('LIKE');
        AList.Add('LIMIT');
        AList.Add('LINEAR');
        AList.Add('LINES');
        AList.Add('LOAD');
        AList.Add('LOCALTIME');
        AList.Add('LOCALTIMESTAMP');
        AList.Add('LOCK');
        AList.Add('LONG');
        AList.Add('LONGBLOB');
        AList.Add('LONGTEXT');
        AList.Add('LOOP');
        AList.Add('LOW_PRIORITY');
        AList.Add('MASTER_SSL_VERIFY_SERVER_CERT');
        AList.Add('MATCH');
        AList.Add('MEDIUMBLOB');
        AList.Add('MEDIUMINT');
        AList.Add('MEDIUMTEXT');
        AList.Add('MIDDLEINT');
        AList.Add('MINUTE_MICROSECOND');
        AList.Add('MINUTE_SECOND');
        AList.Add('MOD');
        AList.Add('MODIFIES');
        AList.Add('NATURAL');
        AList.Add('NOT');
        AList.Add('NO_WRITE_TO_BINLOG');
        AList.Add('NULL');
        AList.Add('NUMERIC');
        AList.Add('ON');
        AList.Add('OPTIMIZE');
        AList.Add('OPTION');
        AList.Add('OPTIONALLY');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUT');
        AList.Add('OUTER');
        AList.Add('OUTFILE');
        AList.Add('PRECISION');
        AList.Add('PRIMARY');
        AList.Add('PROCEDURE');
        AList.Add('PURGE');
        AList.Add('RANGE');
        AList.Add('READ');
        AList.Add('READS');
        AList.Add('READ_ONLY');
        AList.Add('READ_WRITE');
        AList.Add('REAL');
        AList.Add('REFERENCES');
        AList.Add('REGEXP');
        AList.Add('RELEASE');
        AList.Add('RENAME');
        AList.Add('REPEAT');
        AList.Add('REPLACE');
        AList.Add('REQUIRE');
        AList.Add('RESTRICT');
        AList.Add('RETURN');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('RLIKE');
        AList.Add('SCHEMA');
        AList.Add('SCHEMAS');
        AList.Add('SECOND_MICROSECOND');
        AList.Add('SELECT');
        AList.Add('SENSITIVE');
        AList.Add('SEPARATOR');
        AList.Add('SET');
        AList.Add('SHOW');
        AList.Add('SMALLINT');
        AList.Add('SPATIAL');
        AList.Add('SPECIFIC');
        AList.Add('SQL');
        AList.Add('SQLEXCEPTION');
        AList.Add('SQLSTATE');
        AList.Add('SQLWARNING');
        AList.Add('SQL_BIG_RESULT');
        AList.Add('SQL_CALC_FOUND_ROWS');
        AList.Add('SQL_SMALL_RESULT');
        AList.Add('SSL');
        AList.Add('STARTING');
        AList.Add('STRAIGHT_JOIN');
        AList.Add('TABLE');
        AList.Add('TERMINATED');
        AList.Add('THEN');
        AList.Add('TINYBLOB');
        AList.Add('TINYINT');
        AList.Add('TINYTEXT');
        AList.Add('TO');
        AList.Add('TRAILING');
        AList.Add('TRIGGER');
        AList.Add('TRUE');
        AList.Add('UNDO');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UNLOCK');
        AList.Add('UNSIGNED');
        AList.Add('UPDATE');
        AList.Add('UPGRADE');
        AList.Add('USAGE');
        AList.Add('USE');
        AList.Add('USING');
        AList.Add('UTC_DATE');
        AList.Add('UTC_TIME');
        AList.Add('UTC_TIMESTAMP');
        AList.Add('VALUES');
        AList.Add('VARBINARY');
        AList.Add('VARCHAR');
        AList.Add('VARCHARACTER');
        AList.Add('VARYING');
        AList.Add('WHEN');
        AList.Add('WHERE');
        AList.Add('WHILE');
        AList.Add('WITH');
        AList.Add('WRITE');
        AList.Add('XOR');
        AList.Add('YEAR_MONTH');
        AList.Add('ZEROFILL');
      end;
    fdbElevateDB:
      begin
      end;
    fdbSQLite3:
      begin
        AList.Add('ABORT');
        AList.Add('ACTION');
        AList.Add('ADD');
        AList.Add('AFTER');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('ANALYZE');
        AList.Add('AND');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('ATTACH');
        AList.Add('AUTOINCREMENT');
        AList.Add('BEFORE');
        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BY');
        AList.Add('CASCADE');
        AList.Add('CASE');
        AList.Add('CAST');
        AList.Add('CHECK');
        AList.Add('COLLATE');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('CONFLICT');
        AList.Add('CONSTRAINT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('DATABASE');
        AList.Add('DEFAULT');
        AList.Add('DEFERRABLE');
        AList.Add('DEFERRED');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DETACH');
        AList.Add('DISTINCT');
        AList.Add('DROP');
        AList.Add('EACH');
        AList.Add('ELSE');
        AList.Add('END');
        AList.Add('ESCAPE');
        AList.Add('EXCEPT');
        AList.Add('EXCLUSIVE');
        AList.Add('EXISTS');
        AList.Add('EXPLAIN');
        AList.Add('FAIL');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('GLOB');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('IF');
        AList.Add('IGNORE');
        AList.Add('IMMEDIATE');
        AList.Add('IN');
        AList.Add('INDEX');
        AList.Add('INDEXED');
        AList.Add('INITIALLY');
        AList.Add('INNER');
        AList.Add('INSERT');
        AList.Add('INSTEAD');
        AList.Add('INTERSECT');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ISNULL');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('LEFT');
        AList.Add('LIKE');
        AList.Add('LIMIT');
        AList.Add('MATCH');
        AList.Add('NATURAL');
        AList.Add('NO');
        AList.Add('NOT');
        AList.Add('NOTNULL');
        AList.Add('NULL');
        AList.Add('OF');
        AList.Add('OFFSET');
        AList.Add('ON');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUTER');
        AList.Add('PLAN');
        AList.Add('PRAGMA');
        AList.Add('PRIMARY');
        AList.Add('QUERY');
        AList.Add('RAISE');
        AList.Add('REFERENCES');
        AList.Add('REGEXP');
        AList.Add('REINDEX');
        AList.Add('RELEASE');
        AList.Add('RENAME');
        AList.Add('REPLACE');
        AList.Add('RESTRICT');
        AList.Add('RIGHT');
        AList.Add('ROLLBACK');
        AList.Add('ROW');
        AList.Add('SAVEPOINT');
        AList.Add('SELECT');
        AList.Add('SET');
        AList.Add('TABLE');
        AList.Add('TEMP');
        AList.Add('TEMPORARY');
        AList.Add('THEN');
        AList.Add('TO');
        AList.Add('TRANSACTION');
        AList.Add('TRIGGER');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UPDATE');
        AList.Add('USING');
        AList.Add('VACUUM');
        AList.Add('VALUES');
        AList.Add('VIEW');
        AList.Add('VIRTUAL');
        AList.Add('WHEN');
        AList.Add('WHERE');
      end;
    fdbPostgreSQL9, fdbPostgreSQL11:
      begin
        AList.Add('ACCESSIBLE');
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('ANALYZE');
        AList.Add('AND');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('ASENSITIVE');
        AList.Add('BEFORE');
        AList.Add('BETWEEN');
        AList.Add('BIGINT');
        AList.Add('BINARY');
        AList.Add('BLOB');
        AList.Add('BOTH');
        AList.Add('BY');
        AList.Add('CALL');
        AList.Add('CASCADE');
        AList.Add('CASE');
        AList.Add('CHANGE');
        AList.Add('CHAR');
        AList.Add('CHARACTER');
        AList.Add('CHECK');
        AList.Add('COLLATE');
        AList.Add('COLUMN');
        AList.Add('CONDITION');
        AList.Add('CONNECTION');
        AList.Add('CONSTRAINT');
        AList.Add('CONTINUE');
        AList.Add('CONVERT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');
        AList.Add('CURSOR');
        AList.Add('DATABASE');
        AList.Add('DATABASES');
        AList.Add('DAY_HOUR');
        AList.Add('DAY_MICROSECOND');
        AList.Add('DAY_MINUTE');
        AList.Add('DAY_SECOND');
        AList.Add('DEC');
        AList.Add('DECIMAL');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DELAYED');
        AList.Add('DELETE');
        AList.Add('DESC');
        AList.Add('DESCRIBE');
        AList.Add('DETERMINISTIC');
        AList.Add('DISTINCT');
        AList.Add('DISTINCTROW');
        AList.Add('DIV');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('DUAL');
        AList.Add('EACH');
        AList.Add('ELSE');
        AList.Add('ELSEIF');
        AList.Add('ENCLOSED');
        AList.Add('ESCAPED');
        AList.Add('EXISTS');
        AList.Add('EXIT');
        AList.Add('EXPLAIN');
        AList.Add('FALSE');
        AList.Add('FETCH');
        AList.Add('FLOAT');
        AList.Add('FLOAT4');
        AList.Add('FLOAT8');
        AList.Add('FOR');
        AList.Add('FORCE');
        AList.Add('FOREIGN');
        AList.Add('FROM');
        AList.Add('FULLTEXT');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('HIGH_PRIORITY');
        AList.Add('HOUR_MICROSECOND');
        AList.Add('HOUR_MINUTE');
        AList.Add('HOUR_SECOND');
        AList.Add('IF');
        AList.Add('IGNORE');
        AList.Add('IN');
        AList.Add('INDEX');
        AList.Add('INFILE');
        AList.Add('INNER');
        AList.Add('INOUT');
        AList.Add('INSENSITIVE');
        AList.Add('INSERT');
        AList.Add('INT');
        AList.Add('INT1');
        AList.Add('INT2');
        AList.Add('INT3');
        AList.Add('INT4');
        AList.Add('INT8');
        AList.Add('INTEGER');
        AList.Add('INTERVAL');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('ITERATE');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('KEYS');
        AList.Add('KILL');
        AList.Add('LABEL');
        AList.Add('LEADING');
        AList.Add('LEAVE');
        AList.Add('LEFT');
        AList.Add('LIKE');
        AList.Add('LIMIT');
        AList.Add('LINEAR');
        AList.Add('LINES');
        AList.Add('LOAD');
        AList.Add('LOCALTIME');
        AList.Add('LOCALTIMESTAMP');
        AList.Add('LOCK');
        AList.Add('LONG');
        AList.Add('LONGBLOB');
        AList.Add('LONGTEXT');
        AList.Add('LOOP');
        AList.Add('LOW_PRIORITY');
        AList.Add('MASTER_SSL_VERIFY_SERVER_CERT');
        AList.Add('MATCH');
        AList.Add('MEDIUMBLOB');
        AList.Add('MEDIUMINT');
        AList.Add('MEDIUMTEXT');
        AList.Add('MIDDLEINT');
        AList.Add('MINUTE_MICROSECOND');
        AList.Add('MINUTE_SECOND');
        AList.Add('MOD');
        AList.Add('MODIFIES');
        AList.Add('NATURAL');
        AList.Add('NOT');
        AList.Add('NO_WRITE_TO_BINLOG');
        AList.Add('NULL');
        AList.Add('NUMERIC');
        AList.Add('ON');
        AList.Add('OPTIMIZE');
        AList.Add('OPTION');
        AList.Add('OPTIONALLY');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUT');
        AList.Add('OUTER');
        AList.Add('OUTFILE');
        AList.Add('PRECISION');
        AList.Add('PRIMARY');
        AList.Add('PROCEDURE');
        AList.Add('PURGE');
        AList.Add('RANGE');
        AList.Add('READ');
        AList.Add('READS');
        AList.Add('READ_ONLY');
        AList.Add('READ_WRITE');
        AList.Add('REAL');
        AList.Add('REFERENCES');
        AList.Add('REGEXP');
        AList.Add('RELEASE');
        AList.Add('RENAME');
        AList.Add('REPEAT');
        AList.Add('REPLACE');
        AList.Add('REQUIRE');
        AList.Add('RESTRICT');
        AList.Add('RETURN');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('RLIKE');
        AList.Add('SCHEMA');
        AList.Add('SCHEMAS');
        AList.Add('SECOND_MICROSECOND');
        AList.Add('SELECT');
        AList.Add('SENSITIVE');
        AList.Add('SEPARATOR');
        AList.Add('SET');
        AList.Add('SHOW');
        AList.Add('SMALLINT');
        AList.Add('SPATIAL');
        AList.Add('SPECIFIC');
        AList.Add('SQL');
        AList.Add('SQLEXCEPTION');
        AList.Add('SQLSTATE');
        AList.Add('SQLWARNING');
        AList.Add('SQL_BIG_RESULT');
        AList.Add('SQL_CALC_FOUND_ROWS');
        AList.Add('SQL_SMALL_RESULT');
        AList.Add('SSL');
        AList.Add('STARTING');
        AList.Add('STRAIGHT_JOIN');
        AList.Add('TABLE');
        AList.Add('TERMINATED');
        AList.Add('THEN');
        AList.Add('TINYBLOB');
        AList.Add('TINYINT');
        AList.Add('TINYTEXT');
        AList.Add('TO');
        AList.Add('TRAILING');
        AList.Add('TRIGGER');
        AList.Add('TRUE');
        AList.Add('UNDO');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UNLOCK');
        AList.Add('UNSIGNED');
        AList.Add('UPDATE');
        AList.Add('UPGRADE');
        AList.Add('USAGE');
        AList.Add('USE');
        AList.Add('USING');
        AList.Add('UTC_DATE');
        AList.Add('UTC_TIME');
        AList.Add('UTC_TIMESTAMP');
        AList.Add('VALUES');
        AList.Add('VARBINARY');
        AList.Add('VARCHAR');
        AList.Add('VARCHARACTER');
        AList.Add('VARYING');
        AList.Add('WHEN');
        AList.Add('WHERE');
        AList.Add('WHILE');
        AList.Add('WITH');
        AList.Add('WRITE');
        AList.Add('XOR');
        AList.Add('YEAR_MONTH');
        AList.Add('ZEROFILL');
      end;
    {$IFDEF AURELIUS_DLL}
    fdbSqlAnywhere:
      begin
        AList.Add('ADD');
        AList.Add('ALL');
        AList.Add('ALTER');
        AList.Add('AND');
        AList.Add('ANY');
        AList.Add('AS');
        AList.Add('ASC');
        AList.Add('AUTHORIZATION');
        AList.Add('BACKUP');
        AList.Add('BEGIN');
        AList.Add('BETWEEN');
        AList.Add('BREAK');
        AList.Add('BROWSE');
        AList.Add('BULK');
        AList.Add('BY');
        AList.Add('CASCADE');
        AList.Add('CASE');
        AList.Add('CHECK');
        AList.Add('CHECKPOINT');
        AList.Add('CLOSE');
        AList.Add('CLUSTERED');
        AList.Add('COALESCE');
        AList.Add('COLLATE');
        AList.Add('COLUMN');
        AList.Add('COMMIT');
        AList.Add('COMPUTE');
        AList.Add('CONSTRAINT');
        AList.Add('CONTAINS');
        AList.Add('CONTAINSTABLE');
        AList.Add('CONTINUE');
        AList.Add('CONVERT');
        AList.Add('CREATE');
        AList.Add('CROSS');
        AList.Add('CURRENT');
        AList.Add('CURRENT_DATE');
        AList.Add('CURRENT_TIME');
        AList.Add('CURRENT_TIMESTAMP');
        AList.Add('CURRENT_USER');
        AList.Add('CURSOR');
        AList.Add('DATABASE');
        AList.Add('DBCC');
        AList.Add('DEALLOCATE');
        AList.Add('DECLARE');
        AList.Add('DEFAULT');
        AList.Add('DELETE');
        AList.Add('DENY');
        AList.Add('DESC');
        AList.Add('DISK');
        AList.Add('DISTINCT');
        AList.Add('DISTRIBUTED');
        AList.Add('DOUBLE');
        AList.Add('DROP');
        AList.Add('DUMMY');
        AList.Add('DUMP');
        AList.Add('ELSE');
        AList.Add('END');
        AList.Add('ERRLVL');
        AList.Add('ESCAPE');
        AList.Add('EXEC');
        AList.Add('EXECUTE');
        AList.Add('EXCEPT');
        AList.Add('EXISTS');
        AList.Add('EXIT');
        AList.Add('FETCH');
        AList.Add('FILE');
        AList.Add('FILLFACTOR');
        AList.Add('FOR');
        AList.Add('FOREIGN');
        AList.Add('FREETEXT');
        AList.Add('FREETEXTTABLE');
        AList.Add('FROM');
        AList.Add('FULL');
        AList.Add('FUNCTION');
        AList.Add('GOTO');
        AList.Add('GRANT');
        AList.Add('GROUP');
        AList.Add('HAVING');
        AList.Add('HOLDLOCK');
        AList.Add('IDENTITY');
        AList.Add('IDENTITYCOL');
        AList.Add('IDENTITY_INSERT');
        AList.Add('IF');
        AList.Add('IN');
        AList.Add('INDEX');
        AList.Add('INNER');
        AList.Add('INSERT');
        AList.Add('INTERSECT');
        AList.Add('INTO');
        AList.Add('IS');
        AList.Add('JOIN');
        AList.Add('KEY');
        AList.Add('KILL');
        AList.Add('LEFT');
        AList.Add('LIKE');
        AList.Add('LINENO');
        AList.Add('LOAD');
        AList.Add('NATIONAL');
        AList.Add('NOCHECK');
        AList.Add('NONCLUSTERED');
        AList.Add('NOT');
        AList.Add('NULL');
        AList.Add('NULLIF');
        AList.Add('OF');
        AList.Add('OFF');
        AList.Add('OFFSETS');
        AList.Add('ON');
        AList.Add('OPEN');
        AList.Add('OPENDATASOURCE');
        AList.Add('OPENQUERY');
        AList.Add('OPENROWSET');
        AList.Add('OPENXML');
        AList.Add('OPTION');
        AList.Add('OR');
        AList.Add('ORDER');
        AList.Add('OUTER');
        AList.Add('OVER');
        AList.Add('PERCENT');
        AList.Add('PLAN');
        AList.Add('PRECISION');
        AList.Add('PRIMARY');
        AList.Add('PRINT');
        AList.Add('PROC');
        AList.Add('PROCEDURE');
        AList.Add('PUBLIC');
        AList.Add('RAISERROR');
        AList.Add('READ');
        AList.Add('READTEXT');
        AList.Add('RECONFIGURE');
        AList.Add('REFERENCES');
        AList.Add('REPLICATION');
        AList.Add('RESTORE');
        AList.Add('RESTRICT');
        AList.Add('RETURN');
        AList.Add('REVOKE');
        AList.Add('RIGHT');
        AList.Add('ROLLBACK');
        AList.Add('ROWCOUNT');
        AList.Add('ROWGUIDCOL');
        AList.Add('RULE');
        AList.Add('SAVE');
        AList.Add('SCHEMA');
        AList.Add('SELECT');
        AList.Add('SESSION_USER');
        AList.Add('SET');
        AList.Add('SETUSER');
        AList.Add('SHUTDOWN');
        AList.Add('SOME');
        AList.Add('STATISTICS');
        AList.Add('SYSTEM_USER');
        AList.Add('TABLE');
        AList.Add('TEXTSIZE');
        AList.Add('THEN');
        AList.Add('TO');
        AList.Add('TOP');
        AList.Add('TRAN');
        AList.Add('TRANSACTION');
        AList.Add('TRIGGER');
        AList.Add('TRUNCATE');
        AList.Add('TSEQUAL');
        AList.Add('UNION');
        AList.Add('UNIQUE');
        AList.Add('UPDATE');
        AList.Add('UPDATETEXT');
        AList.Add('USE');
        AList.Add('USER');
        AList.Add('VALUES');
        AList.Add('VARYING');
        AList.Add('VIEW');
        AList.Add('WAITFOR');
        AList.Add('WHEN');
        AList.Add('WHERE');
        AList.Add('WHILE');
        AList.Add('WITH');
        AList.Add('WRITETEXT');
      end;
    {$ENDIF}


    //advantage disabled: fdbAdvantage:
//      begin
//        AList.Add('ADD');
//        AList.Add('ALL');
//        AList.Add('ALTER');
//        AList.Add('AND');
//        AList.Add('ANY');
//        AList.Add('AS');
//        AList.Add('ASC');
//        AList.Add('AT');
//        AList.Add('AVG');
//        AList.Add('BEGIN');
//        AList.Add('BETWEEN');
//        AList.Add('BY');
//        AList.Add('CASE');
//        AList.Add('CLOSE');
//        AList.Add('COLUMN');
//        AList.Add('COMMIT');
//        AList.Add('CONSTRAINT');
//        AList.Add('COUNT');
//        AList.Add('CREATE');
//        AList.Add('CURSOR');
//        AList.Add('DECLARE');
//        AList.Add('DEFAULT');
//        AList.Add('DELETE');
//        AList.Add('DESC');
//        AList.Add('DISTINCT');
//        AList.Add('DROP');
//        AList.Add('ELSE');
//        AList.Add('END');
//        AList.Add('ESCAPE');
//        AList.Add('EXECUTE');
//        AList.Add('EXISTS');
//        AList.Add('FALSE');
//        AList.Add('FETCH');
//        AList.Add('FOR');
//        AList.Add('FROM');
//        AList.Add('FUNCTION');
//        AList.Add('FULL');
//        AList.Add('GRANT');
//        AList.Add('GROUP');
//        AList.Add('HAVING');
//        AList.Add('IN');
//        AList.Add('INDEX');
//        AList.Add('INNER');
//        AList.Add('INSERT');
//        AList.Add('INTO');
//        AList.Add('IS');
//        AList.Add('JOIN');
//        AList.Add('KEY');
//        AList.Add('LEFT');
//        AList.Add('LIKE');
//        AList.Add('MAX');
//        AList.Add('MERGE');
//        AList.Add('MIN');
//        AList.Add('NOT');
//        AList.Add('NULL');
//        AList.Add('OF');
//        AList.Add('ON');
//        AList.Add('OPEN');
//        AList.Add('OR');
//        AList.Add('ORDER');
//        AList.Add('OUTER');
//        AList.Add('OUTPUT');
//        AList.Add('PRIMARY');
//        AList.Add('PROCEDURE');
//        AList.Add('REVOKE');
//        AList.Add('RETURN');
//        AList.Add('RETURNS');
//        AList.Add('RIGHT');
//        AList.Add('ROLLBACK');
//        AList.Add('SAVEPOINT');
//        AList.Add('SELECT');
//        AList.Add('SET');
//        AList.Add('SQL');
//        AList.Add('SUM');
//        AList.Add('TABLE');
//        AList.Add('THEN');
//        AList.Add('TO');
//        AList.Add('TRANSACTION');
//        AList.Add('TRIGGER');
//        AList.Add('TRUE');
//        AList.Add('UNION');
//        AList.Add('UNIQUE');
//        AList.Add('UPDATE');
//        AList.Add('USER');
//        AList.Add('USING');
//        AList.Add('VALUES');
//        AList.Add('VARCHAR');
//        AList.Add('VIEW');
//        AList.Add('WHEN');
//        AList.Add('WHERE');
//        AList.Add('WORK');
//      end;
  end;
end;

function TDatabaseType.MustDelimitId(AId: string): boolean;
const
  Alpha = ['A'..'Z', 'a'..'z'];
  AlphaUnderscore = Alpha + ['_'];
  AlphaNumeric = Alpha + ['0'..'9'];
  AlphaNumericUnderscore = AlphaUnderscore + ['0'..'9'];

  function IsValidDBIdent(Ident: string; AValidStart, AValidRemaining: TSysCharSet): boolean;
  var
    I: Integer;
  begin
    Result := False;
    if (Length(Ident) = 0) or not CharInSet(Ident[1], AValidStart) then Exit;
    for I := 2 to Length(Ident) do
      if not CharInSet(Ident[I], AValidRemaining) then
        Exit;
    Result := True;
  end;


begin
  case TDBProperties.GetFixedDatabaseType(Self) of
    fdbSqlServer2000, fdbSqlServer2005, fdbSqlServer2008, fdbSqlAzure, fdbSqlServer2016:
      result := true;
    fdbFirebird2, fdbFirebird3, fdbInterbase2017:
      result := not IsValidDBIdent(AId, Alpha, AlphaNumericUnderscore + ['$']) or IsReservedWord(AId);
    fdbAbsoluteDB:
      result := not IsValidIdent(AId) or IsReservedWord(AId);
    fdbNexusDB3:
      result := not IsValidIdent(AId) or IsReservedWord(AId);
    fdbOracle10g:
      result := true;
    fdbMySQL51, fdbMySQL57:
      result := not IsValidIdent(AId) or IsReservedWord(AId);
    fdbElevateDB:
      result := true;
    fdbSQLite3:
      result := not IsValidIdent(AId) or IsReservedWord(AId);
    //advantage disabled: fdbAdvantage:
    //  result := not IsValidIdent(AId) or IsReservedWord(AId);
    fdbPostgreSQL9, fdbPostgreSQL11:
      result := not IsValidIdent(AId) or IsReservedWord(AId);
    {$IFDEF AURELIUS_DLL}
    fdbSqlAnywhere:
      result := not IsValidIdent(AId) or IsReservedWord(AId);
    {$ENDIF}
  else
    result := false;
  end;
end;

procedure TDatabaseType.SetDatabaseTypeID(const Value: string);
begin
  if FDatabaseTypeID <> Value then
  begin
    FDatabaseTypeID := Value;
    TDBProperties.FillDataTypesObject(Self, TGDAODataTypes(FDataTypes));
  end;
end;

initialization

finalization
  if vDatabaseTypes <> nil then
    vDatabaseTypes.Free;

end.

