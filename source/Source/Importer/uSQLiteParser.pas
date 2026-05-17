unit uSQLiteParser;

interface

uses
  Classes, Generics.Collections, SysUtils, atParser;

type
  ESQLiteParserException = class(Exception);

  TSQLCheckConstraint = class
  private
    FName: string;
    FExpression: string;
  public
    property Name: string read FName write FName;
    property Expression: string read FExpression write FExpression;
  end;

  TSQLPrimaryKey = class
  private
    FName: string;
  public
    property Name: string read FName write FName;
  end;

  TSQLForeignKey = class
  private
    FName: string;
    FChildFields: TStrings;
    FParentFields: TStrings;
    FParentTable: string;
  public 
    constructor Create;
    destructor Destroy; override;
    property Name: string read FName write FName;
    property ParentTable: string read FParentTable write FParentTable;
    property ChildFields: TStrings read FChildFields;
    property ParentFields: TStrings read FParentFields;
  end;

  TSQLColumnDef = class
  private
    FName: string;
    FCheckConstraint: TSQLCheckConstraint;
    FIsAutoincrement: boolean;
    FHasPrimaryKey: boolean;
    FDefaultConstraintName: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Name: string read FName write FName;
    property CheckConstraint: TSQLCheckConstraint read FCheckConstraint;
    property HasPrimaryKey: boolean read FHasPrimaryKey;
    property IsAutoincrement: boolean read FIsAutoincrement;
    property DefaultConstraintName: string read FDefaultConstraintName write FDefaultConstraintName;
  end;

  TSQLiteCreateTableParser = class
  private
    FParser: TatSyntaxParser;
    FParseResult: TParsingResults;
    FColumns: TList<TSQLColumnDef>;
    FConstraints: TList<TSQLCheckConstraint>;
    FPrimaryKey: TSQLPrimaryKey;
    FForeignKeys: TList<TSQLForeignKey>;
    FTableName: string;
    function AcceptNodeId(Node: TNoTerminalNode): boolean;
    procedure AfterColumnDef(Node: TNoTerminalNode);
    procedure AfterTableConstraint(Node: TNoTerminalNode);
    procedure AfterCreateTable(Node: TNoTerminalNode);
    function GetSubNode(Node: TNoTerminalNode; Ids: string): TNoTerminalNode;
    function GetSubNodes(Node: TNoTerminalNode; Ids: string): TArray<TNoTerminalNode>;
    function GetPureId(Node: TNoTerminalNode): string;
    function AcceptStringChar(Node: TNoTerminalNode; ACurrentPos: integer ):boolean;
  public
    constructor Create(ASQL: string);
    destructor Destroy; override;
    property ParseResult: TParsingResults read FParseResult;

    // This property is for internal debug only. Do not use it in a "normal" way
    property Parser: TatSyntaxParser read FParser;

    property TableName: string read FTableName;
    property Columns: TList<TSQLColumnDef> read FColumns;
    property Constraints: TList<TSQLCheckConstraint> read FConstraints;
    property ForeignKeys: TList<TSQLForeignKey> read FForeignKeys;
    property PrimaryKey: TSQLPrimaryKey read FPrimaryKey;
  end;

implementation

{uses
  fSyntaxTree;}

const
  SQLiteGrammar =
    '<create-table>: CREATE [{TEMP|TEMPORARY}] TABLE [IF NOT EXISTS] [<database-name>.] <table-name> "(" <column-def>[( , <column-def>)]  [( [,] <table-constraint>)] ")" [;] '      + #13#10 +
    '<column-def>:<column-name> [<type>] [(<column-constraint> )]'                                                                                                             + #13#10 +
    '<type>:<type-name>[{"(" <size>[ , <precision>] ")"|"[" <size>[ , <precision>] "]"}]'                                                                                                                          + #13#10 +
    '<column-constraint>:[CONSTRAINT <constraint-name> ]{<primary-key-clause>|<null>|<not-null>|<unique-clause>|<check-clause>|<default>|<collate>|<foreign-key-clause>}'             + #13#10 +
    '<primary-key-clause>:PRIMARY KEY[ {ASC|DESC}][ <conflict-clause>][ AUTOINCREMENT]'                                                                                        + #13#10 +
    '<not-null>:NOT NULL[ <conflict-clause>]'                                                                                                                                  + #13#10 +
    '<null>:NULL[ <conflict-clause>]'                                                                                                                                  + #13#10 +
    '<unique-clause>:UNIQUE[ <conflict-clause>]'                                                                                                                               + #13#10 +
    '<default>:DEFAULT {<literal>|"(" <expr> ")"|<id>}'                                                                                                                             + #13#10 +
    '<collate>:COLLATE <collation-name>'                                                                                                                                       + #13#10 +
    '<table-constraint>:[CONSTRAINT <constraint-name> ]{<primary-key>|<unique>|<check-clause>|<foreign-key>}[ CONSTRAINT <constraint-name>]'                                   + #13#10 +
    '<primary-key>:PRIMARY KEY "(" <indexed-column>[( , <indexed-column>)] ")"[ <conflict-clause>]'                                                                            + #13#10 +
    '<unique>:UNIQUE "(" <indexed-column>[( , <indexed-column>)] ")"[ <conflict-clause>]'                                                                                      + #13#10 +
    '<check-clause>:CHECK "(" <expr> ")"'                                                                                                                                      + #13#10 +
    '<foreign-key>:FOREIGN KEY "(" <column-name>[( , <column-name>)] ")" <foreign-key-clause>'                                                                                 + #13#10 +
    '<foreign-key-clause>:REFERENCES <foreign-table>[ "(" <column-name>[( , <column-name>)] ")"][ <foreign-sufix>]'                                                             + #13#10 +
    '<foreign-sufix>:<foreign-sufix-clause>[( <foreign-sufix-clause>)]'                                                                                                      + #13#10 +
    '<foreign-sufix-clause>:{<foreign-on>|<foreign-match>|<foreign-deferrable>}'                                                                                               + #13#10 +
    '<foreign-on>:ON {DELETE|UPDATE} {SET NULL|SET DEFAULT|CASCADE|RESTRICT|NO ACTION}'                                                                                        + #13#10 +
    '<foreign-match>:MATCH <name>'                                                                                                                                             + #13#10 +
    '<foreign-deferrable>:[NOT ]DEFERRABLE[ INITIALLY {DEFERRED|IMMEDIATE}]'                                                                                                   + #13#10 +
    '<foreign-table>:<name>'                                                                                                                                                   + #13#10 +
    '<type-name>:(<name> )'                                                                                                                                                    + #13#10 +
    '<size>:<integer>'                                                                                                                                                         + #13#10 +
    '<precision>:<integer>'                                                                                                                                                    + #13#10 +
    '<indexed-column>:<name>[ COLLATE <collation-name>][ {ASC|DESC}]'                                                                                                          + #13#10 +
    '<collation-name>:<name>'                                                                                                                                                  + #13#10 +
    '<constraint-name>:<optional-name>'                                                                                                                                                 + #13#10 +
    '<column-name>:<name>'                                                                                                                                                     + #13#10 +
    '<database-name>:<name>'                                                                                                                                                   + #13#10 +
    '<table-name>:<name>'                                                                                                                                                      + #13#10 +
    '<name>:<id>'                                                                                                                                                              + #13#10 +
    '<optional-name>:{<id>|<empty-id>}'                                                                                                                                           + #13#10 +
    '<empty-id>:"[" "]"'                                                                                                                                                       + #13#10 +
    '<id>:{<delimited-id>|<pure-id>}'                                                                                                                                          + #13#10 +
    '<delimited-id>:{"["<spaced-id>"]"|&0<spaced-id>&0|&1<spaced-id>&1|&2<spaced-id>&2}'                                                                                                                                           + #13#10 +
    '<spaced-id>:{@|#|_|" "|"-"|"#"|"&"|"("|")"|"."}[({@|#|_|" "|"-"|"#"|"&"|"("|")"|"."})]'                                                                                                                                               + #13#10 +
    '<pure-id>:{@|_}[({@|#|_})]'                                                                                                                                               + #13#10 +
    '<integer>:(#)'                                                                                                                                                            + #13#10 +
    '<data_val>:<id><arg_list>'                                                                                                                                                + #13#10 +
    '<arg_list>:[ "(" [<expr> [(, <expr> )]]")"]'                                                                                                                              + #13#10 +
    '<expr>:{<castexpr>|<matchexpr>|<betweenexpr>|<inexpr>|<caseexpr>|<expr2>|<unaryexpr>}[( <operator> {<castexpr>|<matchexpr>|<betweenexpr>|<inexpr>|<caseexpr>|<expr2>|<unaryexpr>})]'                                                                               + #13#10 +
    '<castexpr>:CAST "(" <expr2> "AS" <type-name> ")"'                                                                                                                          + #13#10 +
    '<matchexpr>:<expr2>[ NOT] {LINE|GLOB|REGEXP|MATCH} <expr2>[ ESCAPE <expr2>]'                                                                                                 + #13#10 +
    '<betweenexpr>:<expr2>[ NOT] BETWEEN <expr> AND <expr2>'                                                                                                                     + #13#10 +
    '<inexpr>:<expr2>[ NOT] IN "(" <expr> [(, <expr> )]")"'                                                                                                                      + #13#10 +
    '<caseexpr>:CASE[ <expr2>] (WHEN <expr2> THEN <expr2> )[ELSE <expr2> ]END'                                                                                                   + #13#10 +
    '<unaryexpr>:<expr2> {ISNULL|NOTNULL|NOT NULL}'                                                                                                                              + #13#10 +
    '<expr2>:{[<unary>]{<data_val>|"(" <expr2> ")"}|<hex>|<literal>}[( <operator> {[<unary>]{<data_val>|"(" <expr2> ")"}|<hex>|<literal>})]'                                      + #13#10 +
    '<operator>:{"^"|*|/|and~|+|-|or~|"<>"|">="|"<="|"="|">"|"<"|div~|mod~|xor~|shl~|shr~|"is not"~|is~|in~}'                                                                                + #13#10 +
    '<unary>:{not~ |-|+}'                                                                                                                                                      + #13#10 +
    '<real>:[{-|+}](#)[<frac>][<exp>]'                                                                                                                                         + #13#10 +
    '<hex>:"$"({#|a|b|c|d|e|f})'                                                                                                                                               + #13#10 +
    '<frac>:.(#)'                                                                                                                                                              + #13#10 +
    '<exp>:e[{-|+}](#)'                                                                                                                                                        + #13#10 +
    '<string>:{$|&0(&)&0}'                                                                                                                                                             + #13#10 +
    '<literal>:{<real>|<string>|NULL|CURRENT_TIMESTAMP|CURRENT_DATE|CURRENT_TIME|TRUE|FALSE}'                                                                                             + #13#10 +
    '<conflict-clause>:ON CONFLICT {ROLLBACK|ABORT|FAIL|IGNORE|REPLACE}';

{ TSQliteParser }

function TSQLiteCreateTableParser.AcceptNodeId(Node: TNoTerminalNode): boolean;
const
  reserved: array[0..91] of string = (
//    'ABORT',
//    'ACTION',
//    'ADD',
//    'AFTER',
//    'ALL',
    'ALTER',
//    'ANALYZE',
    'AND',
    'AS',
    'ASC',
//    'ATTACH',
    'AUTOINCREMENT',
    'BEFORE',
    'BEGIN',
    'BETWEEN',
    'BY',
    'CASCADE',
    'CASE',
    'CAST',
    'CHECK',
    'COLLATE',
    'COLUMN',
    'COMMIT',
    'CONFLICT',
    'CONSTRAINT',
    'CREATE',
//    'CROSS',
    'CURRENT_DATE',
    'CURRENT_TIME',
    'CURRENT_TIMESTAMP',
//    'DATABASE',
    'DEFAULT',
    'DEFERRABLE',
    'DEFERRED',
    'DELETE',
    'DESC',
    'DETACH',
    'DISTINCT',
    'DROP',
    'EACH',
    'ELSE',
    'END',
    'ESCAPE',
    'EXCEPT',
    'EXCLUSIVE',
    'EXISTS',
//    'EXPLAIN',
    'FAIL',
    'FOR',
    'FOREIGN',
    'FROM',
//    'FULL',
    'GLOB',
    'GROUP',
    'HAVING',
    'IF',
    'IGNORE',
    'IMMEDIATE',
    'IN',
    'INDEX',
    'INDEXED',
    'INITIALLY',
    'INNER',
    'INSERT',
    'INSTEAD',
    'INTERSECT',
    'INTO',
    'IS',
    'ISNULL',
    'JOIN',
//    'KEY',
//    'LEFT',
    'LIKE',
//    'LIMIT',
    'MATCH',
//    'NATURAL',
    'NO',
    'NOT',
    'NOTNULL',
    'NULL',
    'OF',
//    'OFFSET',
    'ON',
    'OR',
//    'ORDER',
//    'OUTER',
//    'PLAN',
//    'PRAGMA',
    'PRIMARY',
//    'QUERY',
    'RAISE',
    'REFERENCES',
//    'REGEXP',
    'REINDEX',
//    'RELEASE',
    'RENAME',
    'REPLACE',
    'RESTRICT',
//    'RIGHT',
    'ROLLBACK',
//    'ROW',
//    'SAVEPOINT',
    'SELECT',
    'SET',
    'TABLE',
    'TEMP',
    'TEMPORARY',
    'THEN',
    'TO',
//    'TRANSACTION',
    'TRIGGER',
    'UNION',
    'UNIQUE',
    'UPDATE',
    'USING',
//    'VACUUM',
    'VALUES',
    'VIEW',
//    'VIRTUAL',
    'WHEN',
    'WHERE'
);
var
  id: string;
  i: Integer;
begin
  // If it's delimited-id, accepts everything
  if Node.ParentNode.NoTerminal.IdS = 'delimited-id' then
    Exit(true);

  result := true;
  id := Uppercase(Node.InputToken);
  for i := Low(reserved) to High(reserved) do
    if id = reserved[i] then
    begin
      result := false;
      break;
    end;
end;

function TSQLiteCreateTableParser.AcceptStringChar(Node: TNoTerminalNode;
  ACurrentPos: integer): boolean;
begin
  Result := FParser.Input[ACurrentPos] <> '"';
end;

procedure TSQLiteCreateTableParser.AfterColumnDef(Node: TNoTerminalNode);
var
  Col: TSQLColumnDef;
  SubNode: TNoTerminalNode;
  CheckNode: TNoTerminalNode;
  DefaultNode: TNoTerminalNode;

  ForeignNode: TNoTerminalNode;
  ForeignFieldNode: TNoTerminalNode;
  Foreign: TSQLForeignKey;
  PrimaryNode: TNoTerminalNode;
begin
  Col := TSQLColumnDef.Create;
  FColumns.Add(Col);
  Col.Name := GetPureId(GetSubNode(Node, 'column-name'));
  for SubNode in GetSubNodes(Node, 'column-constraint') do
  begin
    // Check constraint
    CheckNode := GetSubNode(SubNode, 'check-clause');
    if (CheckNode <> nil) and (Col.FCheckConstraint = nil) then
    begin
      Col.FCheckConstraint := TSQLCheckConstraint.Create;
      if GetSubNode(SubNode, 'constraint-name') <> nil then
        Col.FCheckConstraint.Name := GetPureId(GetSubNode(SubNode, 'constraint-name'));
      Col.FCheckConstraint.Expression := GetSubNode(CheckNode, 'expr').InputToken;
    end;

    // foreign key constraint
    ForeignNode := GetSubNode(SubNode, 'foreign-key-clause');
    if ForeignNode <> nil then
    begin
      Foreign := TSQLForeignKey.Create;
      Self.ForeignKeys.Add(Foreign);
      if GetSubNode(SubNode, 'constraint-name') <> nil then
        Foreign.Name := GetPureId(GetSubNode(SubNode, 'constraint-name'));

      Foreign.ChildFields.Add(Col.Name);
      for ForeignFieldNode in GetSubNodes(ForeignNode, 'column-name') do
        Foreign.ParentFields.Add(GetPureId(ForeignFieldNode));
      Foreign.ParentTable := GetPureId(GetSubNode(ForeignNode, 'foreign-table'));
    end;

    // if has primary key clause, change data type
    PrimaryNode := GetSubNode(SubNode, 'primary-key-clause');
    if PrimaryNode <> nil then
    begin
      Col.FHasPrimaryKey := true;
      if Pos('AUTOINCREMENT', Uppercase(PrimaryNode.InputToken)) > 0 then
        Col.FIsAutoincrement := true;
    end;

    // Default constraint
    DefaultNode := GetSubNode(SubNode, 'default');
    if (DefaultNode <> nil) then
    begin
      if GetSubNode(SubNode, 'constraint-name') <> nil then
        Col.DefaultConstraintName := GetPureId(GetSubNode(SubNode, 'constraint-name'));
    end;
  end;

end;

procedure TSQLiteCreateTableParser.AfterCreateTable(Node: TNoTerminalNode);
begin
  if GetSubNode(Node, 'table-name') <> nil then
    FTableName := GetPureId(GetSubNode(Node, 'table-name'));
end;

procedure TSQLiteCreateTableParser.AfterTableConstraint(Node: TNoTerminalNode);
var
  CheckNode: TNoTerminalNode;
  Check: TSQLCheckConstraint;
  PrimaryNode: TNoTerminalNode;
  ForeignNode: TNoTerminalNode;
  ForeignClauseNode: TNoTerminalNode;
  ForeignFieldNode: TNoTerminalNode;
  Foreign: TSQLForeignKey;
begin
  // check constraint
  CheckNode := GetSubNode(Node, 'check-clause');
  if CheckNode <> nil then
  begin
    Check := TSQLCheckConstraint.Create;
    Self.Constraints.Add(Check);
    if GetSubNode(Node, 'constraint-name') <> nil then
      Check.Name := GetPureId(GetSubNode(Node, 'constraint-name'));
    Check.Expression := GetSubNode(CheckNode, 'expr').InputToken;
  end;

  // primary key constraint
  PrimaryNode := GetSubNode(Node, 'primary-key');
  if PrimaryNode <> nil then
  begin
    if GetSubNode(Node, 'constraint-name') <> nil then
      Self.PrimaryKey.Name := GetPureId(GetSubNode(Node, 'constraint-name'));
  end;

  // foreign key constraint
  ForeignNode := GetSubNode(Node, 'foreign-key');
  if ForeignNode <> nil then
  begin
    Foreign := TSQLForeignKey.Create;
    Self.ForeignKeys.Add(Foreign);
    if GetSubNode(Node, 'constraint-name') <> nil then
      Foreign.Name := GetPureId(GetSubNode(Node, 'constraint-name'));
    for ForeignFieldNode in GetSubNodes(ForeignNode, 'column-name') do
      Foreign.ChildFields.Add(GetPureId(ForeignFieldNode));
    ForeignClauseNode := GetSubNode(ForeignNode, 'foreign-key-clause');
    if ForeignClauseNode <> nil then
    begin
       Foreign.ParentTable := GetPureId(GetSubNode(ForeignClauseNode, 'foreign-table'));
       for ForeignFieldNode in GetSubNodes(ForeignClauseNode, 'column-name') do
         Foreign.ParentFields.Add(GetPureId(ForeignFieldNode));
    end;    
  end;
end;

constructor TSQLiteCreateTableParser.Create(ASQL: string);

  function NoTerm(Name: string): TNoTerminal;
  begin
    Result := FParser.NoTerminals[FParser.NoTerminals.IndexOf(Name)];
  end;

begin
  FPrimaryKey := TSQLPrimaryKey.Create;
  FForeignKeys := TObjectList<TSQLForeignKey>.Create;
  FColumns := TObjectList<TSQLColumnDef>.Create;
  FConstraints := TObjectList<TSQLCheckConstraint>.Create;
  FParser := TatSyntaxParser.Create(nil);
  FParser.AllowUnicodeIds := True;
  FParser.Grammar.Text := SQLiteGrammar;
  FParser.Strings.Text := ASQL;
  NoTerm('pure-id').OnAcceptNode := AcceptNodeId;
  NoTerm('column-def').AssignNodeScanningEvents(nil, AfterColumnDef);
  NoTerm('table-constraint').AssignNodeScanningEvents(nil, AfterTableConstraint);
  NoTerm('create-table').AssignNodeScanningEvents(nil, AfterCreateTable);
  NoTerm('string').OnAcceptCharacter := AcceptStringChar;
  FParser.CustomLexemes[0] := '"';
  FParser.CustomLexemes[1] := '''';
  FParser.CustomLexemes[2] := '`';
  FParser.Comments.Add('--',#13).PriorDelims := ' :,)'#13#10;
  FParser.Comments.Add('/*', '*/');

  FParseResult := FParser.CheckLanguage;
  if FParseResult.Result = srCorrect then
    FParser.ScanSyntaxTree
  else
  begin
//    ShowSyntaxTree(FParser);
    raise ESQLiteParserException.Create('Error parsing SQLite Create Table Statement'#13#10 +
     'Error at position: ' + IntToStr(FParseResult.MaxInputPos) + #13#10 +
     Copy(ASQL, FParseResult.MaxInputPos - 1, 50) + #13#10 + '---' + #13#10 +
     ASQL);
  end;

end;

destructor TSQLiteCreateTableParser.Destroy;
begin
  FForeignKeys.Free;
  FPrimaryKey.Free;
  FConstraints.Free;
  FColumns.Free;
  FParser.Free;
  inherited;
end;

function TSQLiteCreateTableParser.GetPureId(Node: TNoTerminalNode): string;
begin
  while Node.Nodes.Count > 0 do
    Node := Node.Nodes[0];
  Result := Node.InputToken;
  if SameText(Node.NoTerminal.IdS, 'empty-id') then
    Result := '';
end;

function TSQLiteCreateTableParser.GetSubNode(Node: TNoTerminalNode;
  Ids: string): TNoTerminalNode;
begin
  Result := Node.Nodes.FindByNoTerminalName(Ids);
end;

function TSQLiteCreateTableParser.GetSubNodes(Node: TNoTerminalNode;
  Ids: string): TArray<TNoTerminalNode>;
var
  i: integer;
  c: integer;
begin
  result := nil;
  SetLength(Result, 0);
  { localiza o índice do não-terminal }
  i:=Node.NoTerminal.NoTerminals.IndexOf(Ids);
  if (i>-1) then
  begin
    for c := 0 to Node.Nodes.Count - 1 do
      if Node.Nodes[c].NoTerminalIndex = i then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(result) - 1] := Node.Nodes[c];
      end;
  end;
end;

{ TSQLColumnDef }

constructor TSQLColumnDef.Create;
begin
end;

destructor TSQLColumnDef.Destroy;
begin
  if FCheckConstraint <> nil then
    FCheckConstraint.Free;

  inherited;
end;

{ TSQLForeignKey }

constructor TSQLForeignKey.Create;
begin
  FChildFields := TStringList.Create;
  FParentFields := TStringList.Create;
end;

destructor TSQLForeignKey.Destroy;
begin
  FChildFields.Free;
  FParentFields.Free;
  inherited;
end;

end.
