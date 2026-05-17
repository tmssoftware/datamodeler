unit DatabaseTypes.PostgreSQL;

interface

uses
  Classes, dgDBTypes, dgMacroConsts;

type
  TPostgreSQLDatabaseType = class
  public
    class procedure LoadPostgreSQLExpressions(AList: TStrings);
  end;

implementation

{ TPostgreSQLDBType }

class procedure TPostgreSQLDatabaseType.LoadPostgreSQLExpressions(AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '"';
  AList.Values[SQL_CLOSEDELIMITEDID] := '"';
  AList.Values[SQL_DEFAULTTERMINATOR] := ';'#13#10;
  AList.Values[SQL_FIELDNULL] := '"NOT NULL",""'; // False, True

  AList.Values['ColumnDefinition'] :=
    '<%FieldName%> <%FieldType%>{<%FieldExpression%>}{ <%FieldNull%>}{ DEFAULT <%FieldDefault%>}';

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldDefault")="", "DROP DEFAULT", "SET DEFAULT " + Expr("FieldDefault"))%>';

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldNull")="", "DROP NOT NULL", "SET NOT NULL")%>';

  AList.Values[SQL_CHANGEFIELDSIZE] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  TYPE <%FieldType%>';

  AList.Values[SQL_CHANGEFIELDTYPE] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  TYPE <%FieldType%>';

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
    '  ADD COLUMN <%ColumnDefinition%>';

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
    'DROP INDEX <%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%> ON <%TableName%>';

  AList.Values[SQL_RENAMEFIELD] :=
    'ALTER TABLE <%TableName%> RENAME COLUMN <%FieldOldName%> TO <%FieldName%>';

  AList.Values[SQL_RENAMETABLE] :=
    'ALTER TABLE <%TableOldName%> RENAME TO <%TableName%>';

  AList.Values['CreateSequence'] :=
    'CREATE SEQUENCE <%objectname%>{ START <%obj_sequenceseed%>}';

  AList.Values[SQL_CREATEDOMAIN] :=
    'CREATE DOMAIN <%DomainName%>'#13#10+
    '  AS {<%DomainType%>}{<%DomainExpression%>}{'#13#10+
    '  DEFAULT <%DomainDefault%>}{'#13#10+
    '  CHECK <%DomainCheckExpr%>}';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'DROP DOMAIN <%DomainName%>';

  AList.Values[SQL_CHANGEDOMAIN] :=
    '<%RemoveDomain%>;'#13#10 +
    '<%CreateDomain%>';
end;


end.
