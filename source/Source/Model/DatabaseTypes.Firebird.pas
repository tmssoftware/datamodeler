unit DatabaseTypes.Firebird;

interface

uses
  Classes, dgDBTypes, dgMacroConsts;

type
  TFirebirdDatabaseType = class
  public
    class procedure LoadFirebirdBaseExpressions(AList: TStrings);
    class procedure LoadFirebird2Expressions(AList: TStrings);
    class procedure LoadFirebird3Expressions(AList: TStrings);
    class procedure LoadInterbase2017Expressions(AList: TStrings);
  end;

implementation

{ TFirebirdDBType }

class procedure TFirebirdDatabaseType.LoadFirebird2Expressions(AList: TStrings);
begin
  LoadFirebirdBaseExpressions(AList);

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'UPDATE RDB$RELATION_FIELDS '#13#10+
    '  SET RDB$NULL_FLAG = <%=IIF(Expr("FieldNull")="", "NULL", "1")%> '#13#10+
    '  WHERE (UPPER(RDB$FIELD_NAME) = UPPER(''<%FieldName%>'')) AND '#13#10+
    '  (UPPER(RDB$RELATION_NAME) = UPPER(''<%TableName%>''))';
end;

class procedure TFirebirdDatabaseType.LoadFirebird3Expressions(AList: TStrings);
begin
  LoadFirebirdBaseExpressions(AList);

  AList.Values[SQL_CHANGEFIELDREQUIRED] :=
    'ALTER TABLE <%TableName%> ALTER <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldNull")="", "DROP NOT NULL", "SET NOT NULL")%>';
end;

class procedure TFirebirdDatabaseType.LoadFirebirdBaseExpressions(
  AList: TStrings);
begin
  AList.Values[SQL_OPENDELIMITEDID] := '"';
  AList.Values[SQL_CLOSEDELIMITEDID] := '"';
  AList.Values[SQL_DEFAULTTERMINATOR] := ';'#13#10;
  AList.Values[SQL_FIELDNULL] :=
    '"NOT NULL",""';
    { False, True }

  AList.Values[SQL_CHANGEFIELDDEFAULT] :=
    'ALTER TABLE <%TableName%> ALTER COLUMN <%FieldName%>'#13#10+
    '  <%=IIF(Expr("FieldDefault")="", "DROP DEFAULT", "SET DEFAULT " + Expr("FieldDefault"))%>';

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
    'CONSTRAINT <%ConstraintDefaultName%> DEFAULT <%FieldDefault%>'; //Not aplicable

  AList.Values[SQL_CONSTRAINTFLDNOTNULL] :=
    'CONSTRAINT <%ConstraintNotNullName%> <%FieldNull%>'; //Not aplicable

  AList.Values[SQL_CONSTRAINTPK] :=
    '{{CONSTRAINT <%ConstraintPkName%> }PRIMARY KEY (<%ConstraintPkFields%>)}';

  AList.Values[SQL_CREATECONSTRAINTCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDCHECK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldCheck%>';

  AList.Values[SQL_CREATECONSTRAINTFLDDEFAULT] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldDefault%>'; //Not aplicable for FB

  AList.Values[SQL_CREATECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintFldNotNull%>'; //Not aplicable for FB

  AList.Values[SQL_CREATECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> ADD <%ConstraintPk%>';

  AList.Values[SQL_CONSTRAINTFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEFIELD] :=
    'ALTER TABLE <%TableName%> ADD <%FieldName%>'#13#10+
    '  {<%FieldType%>}{ COMPUTED BY (<%FieldExpression%>)}{ DEFAULT <%FieldDefault%>}{ <%FieldNull%>}';

  AList.Values[SQL_INDEXTYPE] :=
    ',UNIQUE,UNIQUE';
    { itNone, itUnique, itUniqueKey }

  AList.Values[SQL_INDEXORDER] :=
    ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELDORDER] := ',DESC';
    { ioAsc, ioDesc }

  AList.Values[SQL_INDEXFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEINDEX] :=
    'CREATE{ <%IndexType%>}{ <%IndexOrder%>} INDEX <%IndexName%> ON <%TableName%>'#13#10+
    '  (<%IndexLstFields%>)';



  AList.Values[SQL_RELATIONSHIPFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_RELATIONSHIPDELETEACTION] :=
    ',,CASCADE,"SET NULL","SET DEFAULT",';
    { dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction }

  AList.Values[SQL_RELATIONSHIPUPDATEACTION] :=
    ',,CASCADE,"SET NULL","SET DEFAULT",';
    { umNone, umRestrict, umCascade, umSetNull, umSetDefault, dmNoAction }

  AList.Values[SQL_CREATERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%RelName%>'#13#10+
    '  FOREIGN KEY (<%RelChildFields%>)'#13#10+
    '  REFERENCES <%RelParentTable%> (<%RelParentFields%>){'#13#10+
    '  ON DELETE <%RelDeleteAction%>}{'#13#10+
    '  ON UPDATE <%RelUpdateAction%>}';



  AList.Values[SQL_TABLEFIELD] :=
    #13#10+
    '  <%FieldName%> {<%FieldType%>}{COMPUTED BY <%FieldExpression%>}{ DEFAULT <%FieldDefault%>}{ <%FieldNull%>}{'#13#10+
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
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintDefaultName%>';

  AList.Values[SQL_REMOVECONSTRAINTFLDNOTNULL] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintNotNullName%>';

  AList.Values[SQL_REMOVECONSTRAINTPK] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%ConstraintPkName%>';

  AList.Values[SQL_REMOVEFIELD] :=
    'ALTER TABLE <%TableName%> DROP <%FieldName%>';

  AList.Values[SQL_REMOVEINDEX] :=
    'DROP INDEX <%IndexName%>';

  AList.Values[SQL_REMOVERELATIONSHIP] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%RelName%>';

  AList.Values[SQL_REMOVETABLE] :=
    'DROP TABLE <%TableName%>';

  AList.Values[SQL_REMOVETRIGGER] :=
    'DROP TRIGGER <%TriggerName%>';

  AList.Values[SQL_RENAMEFIELD] :=
    'ALTER TABLE <%TableName%> ALTER <%FieldOldName%> TO <%FieldName%>';

  AList.Values[SQL_RENAMETABLE] :=
    'Trying to rename "<%TableOldName%>" "<%TableName%>" is not possible.'#13#10+
    '  Firebird does not support renaming of tables.';

  AList.Values['CreateProcedure'] :=
    'SET TERM ^ ;'#13#10#13#10 +
    '<%objectcode%>^'#13#10#13#10 +
    'SET TERM ; ^ --';

  AList.Values['CreateTrigger'] :=
    'SET TERM ^ ;'#13#10#13#10 +
    '<%triggercode%>^'#13#10#13#10 +
    'SET TERM ; ^ --';

  AList.Values['CreateSequence'] :=
    'CREATE GENERATOR <%objectname%>;'#13#10 +
    'SET GENERATOR <%objectname%> TO <%obj_sequenceseed%>';


  AList.Values[SQL_CREATEDOMAIN] :=
    'CREATE DOMAIN <%DomainName%>'#13#10+
    '  AS {<%DomainType%>}{COMPUTED BY (<%DomainExpression%>)}{'#13#10+
    '  DEFAULT <%DomainDefault%>}{'#13#10+
    '  CHECK (<%DomainCheckExpr%>)}';

  AList.Values[SQL_REMOVEDOMAIN] :=
    'DROP DOMAIN <%DomainName%>';

  AList.Values[SQL_CHANGEDOMAIN] :=
    '<%RemoveDomain%>;'#13#10 +
    '<%CreateDomain%>';

  AList.Values[SQL_COMMENTDOMAIN] :=
    'COMMENT ON DOMAIN <%DomainName%> IS <%DomainInformation%>';
  AList.Values[SQL_COMMENTFIELD] :=
    'COMMENT ON COLUMN <%TableName%>.<%FieldName%> IS <%FieldDescription%>';
  AList.Values[SQL_COMMENTPROCEDURE] :=
    'COMMENT ON PROCEDURE <%ObjectName%> IS <%ObjectDescription%>';
  AList.Values[SQL_COMMENTSEQUENCE] :=
    'COMMENT ON SEQUENCE <%ObjectName%> IS <%ObjectDescription%>';
  AList.Values[SQL_COMMENTTABLE] :=
    'COMMENT ON TABLE <%TableName%> IS <%TableDescription%>';
  AList.Values[SQL_COMMENTTRIGGER] :=
    'COMMENT ON TRIGGER <%TriggerName%> IS <%TriggerDescription%>';
  AList.Values[SQL_COMMENTVIEW] :=
    'COMMENT ON VIEW <%ObjectName%> IS <%ObjectDescription%>';


  {$REGION 'Unique Constraint'}
//  AList.Values[SQL_UNIQUETYPE] :=
//    ',UNIQUE';
//    { itNone, itUnique }

//  AList.Values[SQL_UNIQUEORDER] :=
//    ',DESC';
//    { ioAsc, ioDesc }

//  AList.Values[SQL_UNIQUEFIELDORDER] := ',DESC';
//    { ioAsc, ioDesc }

  AList.Values[SQL_UNIQUEFIELD] :=
    '<%FieldName%>';

  AList.Values[SQL_CREATEUNIQUE] :=
    'ALTER TABLE <%TableName%> ADD CONSTRAINT <%UniqueName%> UNIQUE (<%UniqueLstFields%>)';

  AList.Values[SQL_REMOVEUNIQUE] :=
    'ALTER TABLE <%TableName%> DROP CONSTRAINT <%UniqueName%>';
  {$ENDREGION}

end;


class procedure TFirebirdDatabaseType.LoadInterbase2017Expressions(
  AList: TStrings);
begin
  LoadFirebird3Expressions(AList);
end;

end.
