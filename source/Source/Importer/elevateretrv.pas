unit elevateretrv;

interface

uses
  uSQLModule, SysUtils, Classes, Dialogs, DB, qryretrv, uGDAO, dgConsts;

type
  TFieldDefinitionRec = record
    _DataTypeName: String;
    _Size, _Precision: integer;
  end;

  TElevateDBDataRetriever = class(TDataRetriever)
  private
    function GetFieldDefinition(AType: string; ALength, APrecision, AScale: integer): TFieldDefinitionRec;
  public
    procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
  end;

implementation

{ TElevateDBDataRetriever }

procedure TElevateDBDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);

  procedure _GetTables;
  begin
    ADictionary.Tables.Clear;
    Module.Open(
      'SELECT Name, Description '+
      'FROM Information.Tables '+
      'ORDER BY Name');
    while not Module.EOF do
    begin
      with ADictionary.Tables.Add(Module.FieldAsString('Name')) do
      begin
        Description := Module.FieldAsString('Description');
      end;
      Module.Next;
    end;
  end;

  procedure _GetFieldList;
  var
    table: TGDAOTable;
    field: TGDAOField;
  begin
    Module.Open(
      'SELECT TableName, Name, Description, Type, "Length", Precision, Scale, Nullable, '+
      'Generated, GeneratedWhen, GenerateExpr, Identity, IdentitySeed, IdentityIncrement, '+
      'Computed, ComputeExpr, DefaultExpr '+
      'FROM Information.TableColumns '+
      'ORDER BY TableName, OrdinalPos');
    table := nil;
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TableName')) then
        table := ADictionary.TableByName(Module.FieldAsString('TableName'));

      if table <> nil then
      begin
        // basic field information: name and required
        field := table.Fields.Add(Module.FieldAsString('Name'), nil, 0, 0,
          not Module.FieldAsBoolean('Nullable'));

        // field description and default value
        field.Description := Module.FieldAsString('Description');
        field.DefaultValue := Trim(Module.FieldAsString('DefaultExpr'));
        field.Expression := '';

        // field data type
        with GetFieldDefinition(
          Module.FieldAsString('Type'),
          Module.FieldAsInteger('Length'),
          Module.FieldAsInteger('Precision'),
          Module.FieldAsInteger('Scale')) do
        begin
          if ADictionary.DataTypes.FindByName(_DataTypeName) <> nil then
            field.DataTypeName := _DataTypeName
          else
            raise EGuiException.CreateFmt('Unknown datatype (%s) for field %s on table %s.',
              [_DataTypeName, field.FieldName, table.TableName]);
          field.Size := _Size;
          field.Size2 := _Precision;
        end;

        // computed/generated fields
        if Module.FieldAsBoolean('Generated') then
        begin
          if Module.FieldAsBoolean('Identity') then
          begin
            if SameText(Module.FieldAsString('GeneratedWhen'), 'Always') then
              field.DataTypeName := 'Identity (always)'
            else
              field.DataTypeName := 'Identity (default)';
            field.SeedValue := Module.FieldAsInteger('IdentitySeed');
            field.IncrementValue := Module.FieldAsInteger('IdentityIncrement');
          end
          else
            field.Expression := Format('%s GENERATED ALWAYS AS %s',
              [field.DataType.BuildPhysicalExpression(field), Trim(Module.FieldAsString('GenerateExpr'))]);
        end;
        if Module.FieldAsBoolean('Computed') then
          field.Expression := Format('%s COMPUTED ALWAYS AS %s',
            [field.DataType.BuildPhysicalExpression(field), Trim(Module.FieldAsString('ComputeExpr'))]);
        if field.Expression > '' then
          field.DataTypeName := 'Computed';
      end;

      Module.Next;
    end;
  end;

  procedure _GetPrimaryKeys;
  var
    table: TGDAOTable;
    field: TGDAOField;
  begin
    Module.Open(
      'SELECT I.TableName, I.Name, I.Description, C.ColumnName, C.Descending '+
      'FROM Information.Indexes I, Information.IndexColumns C '+
      'WHERE I.TableName=C.TableName '+
      'AND I.Name=C.IndexName '+
      'AND I.Type=''Primary Key'' '+
      'ORDER BY I.TableName, I.Name, C.OrdinalPos');
    table := nil;
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TableName')) then
        table := ADictionary.TableByName(Module.FieldAsString('TableName'));

      if table <> nil then
        field := table.FieldByName(Module.FieldAsString('ColumnName'))
      else
        field := nil;

      if (table <> nil) and (field <> nil) then
      begin
        table.PrimaryKeyIndex.IndexName := Module.FieldAsString('Name');
        with table.PrimaryKeyIndex.IFields.Add(field) do
        begin
          if Module.FieldAsBoolean('Descending') then
            FieldOrder := ioDesc;
        end;
      end;

      Module.Next;
    end;
  end;

  procedure _GetTriggers;
  var
    table: TGDAOTable;
    trigger: TGDAOTrigger;
    triggerCondition, triggerBody: string;
  begin
    Module.Open(
      'SELECT TableName, Name, Description, ActionTime, ActionType, Condition, Definition '+
      'FROM Information.Triggers '+
      'ORDER BY TableName, OrdinalPos');
    table := nil;
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TableName')) then
        table := ADictionary.TableByName(Module.FieldAsString('TableName'));

      if table <> nil then
      begin
        trigger := table.Triggers.Add;
        trigger.Name := Module.FieldAsString('Name');
        trigger.Description := Module.FieldAsString('Description');

        if Module.FieldAsString('Condition') > '' then
          triggerCondition := Format('WHEN %s'#13#10, [Trim(Module.FieldAsString('Condition'))])
        else
          triggerCondition := '';
        triggerBody := Trim(Module.FieldAsString('Definition'));
        Delete(triggerBody, 1, Pos('BEGIN', UpperCase(triggerBody))-1);

        trigger.ImplementationCode := Format(
          'CREATE TRIGGER "%s" %s %s ON "%s"'#13#10'%s%s',
          [trigger.Name,
           Module.FieldAsString('ActionTime'),
           Module.FieldAsString('ActionType'),
           trigger.TableName,
           triggerCondition,
           Trim(triggerBody)]);
      end;

      Module.Next;
    end;
  end;

  procedure _GetConstraints;
  var
    table: TGDAOTable;
  begin
    Module.Open(
      'SELECT Name, TableName, Description, CheckExpr '+
      'FROM Information.Constraints '+
      'WHERE EnforcingIndex IS NULL '+
      'ORDER BY TableName, Name');
    while not Module.EOF do
    begin
      if Module.FieldAsString('CheckExpr') > '' then
      begin
        table := ADictionary.TableByName(Module.FieldAsString('TableName'));
        if table <> nil then
          table.Constraints.AddConstraint(Module.FieldAsString('Name'), Trim(Module.FieldAsString('CheckExpr')));
      end;
      Module.Next;
    end;
  end;

  procedure _GetIndexes;
  var
    table: TGDAOTable;
    index: TGDAOIndex;
  begin
    Module.Open(
      'SELECT I.TableName, I.Name, I.Description, I.Type, C.ColumnName, C.Descending '+
      'FROM Information.Indexes I, Information.IndexColumns C '+
      'WHERE I.TableName=C.TableName '+
      'AND I.Name=C.IndexName '+
      'AND I.Type<>''Primary Key'' AND I.Type<>''Foreign Key'' '+
      'ORDER BY I.TableName, I.Name, C.OrdinalPos');
    table := nil;
    index := nil;
    while not Module.EOF do
    begin
      if (table = nil) or not SameText(table.TableName, Module.FieldAsString('TableName')) then
      begin
        table := ADictionary.TableByName(Module.FieldAsString('TableName'));
        index := nil;
      end;

      if table <> nil then
      begin
        if (index = nil) or not SameText(index.IndexName, Module.FieldAsString('Name')) then
        begin
          if (table.PrimaryKeyIndex = nil) or not SameText(table.PrimaryKeyIndex.IndexName, Module.FieldAsString('Name')) then
            index := table.Indexes.Add(Module.FieldAsString('Name'))
          else
            index := nil;
        end;

        if index <> nil then
        begin
          if SameText(Module.FieldAsString('Type'), 'Unique') then
            index.IndexType := itUnique;
          with index.IFields.Add(Module.FieldAsString('ColumnName')) do
            if Module.FieldAsBoolean('Descending') then
              FieldOrder := ioDesc;
        end;
      end;

      Module.Next;
    end;
  end;

  procedure _GetRelationships;
  var
    relationship: TGDAORelationship;
  begin
    Module.Open(
      'SELECT C.TableName, C.Name, C.Description, C.TargetTable, C.UpdateAction, C.DeleteAction, '+
      'CC.ColumnName AS ChildField, CP.ColumnName AS ParentField '+
      'FROM Information.Constraints C, Information.ConstraintColumns CC, Information.ConstraintColumns CP '+
      'WHERE C.Type=''Foreign Key'' '+
      'AND C.TableName=CC.TableName AND C.Name=CC.ConstraintName '+
      'AND C.TargetTable=CP.TableName AND C.TargetTableConstraint=CP.ConstraintName '+
      'AND CC.OrdinalPos = CP.OrdinalPos '+
      'ORDER BY C.TableName, C.Name, CC.OrdinalPos, CP.OrdinalPos');
    while not Module.EOF do
    begin
      relationship := ADictionary.RelationshipByName(Module.FieldAsString('Name'),
        Module.FieldAsString('TableName'));
      if relationship = nil then
        relationship := ADictionary.Relationships.Add(Module.FieldAsString('Name'),
          '', '', umCascade, dmCascade);

      relationship.ParentTableName := Module.FieldAsString('TargetTable');
      relationship.ChildTableName := Module.FieldAsString('TableName');

      with relationship.FieldLinks.Add do
      begin
        ParentFieldName := Module.FieldAsString('ParentField');
        ChildFieldName := Module.FieldAsString('ChildField');
      end;

      if SameText(Module.FieldAsString('UpdateAction'), 'Restrict')
        or SameText(Module.FieldAsString('UpdateAction'), 'No Action') then
        relationship.UpdateMethod := umRestrict;
      if SameText(Module.FieldAsString('DeleteAction'), 'Restrict')
        or SameText(Module.FieldAsString('DeleteAction'), 'No Action') then
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
      Module.Open(
        'SELECT Name, Description, Definition '+
        'FROM Information.Views '+
        'ORDER BY Name');
      while not Module.EOF do
      begin
        view := views.Add(Module.FieldAsString('Name'));
        view.CreateImplementation := Format(
          'CREATE VIEW <%%%s%%> AS'#13#10'  %s',
          [NativeIdName[niObjectName], Trim(Module.FieldAsString('Definition'))]);
        view.Description := Trim(Module.FieldAsString('Description'));
        view.DropImplementation := view.OwnerCategory.DropTemplate;
        Module.Next;
      end;
    end;
  end;

  procedure _GetProcedures;
  var
    procs: TGDAOObjects;
    proc: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ctProcedure) <> nil then
    begin
      procs := ADictionary.Categories.FindByType(ctProcedure).Objects;
      procs.Clear;
      Module.Open(
        'SELECT Name, Description, Definition '+
        'FROM Information.Procedures '+
        'ORDER BY Name');
      while not Module.EOF do
      begin
        proc := procs.Add(Module.FieldAsString('Name'));
        proc.CreateImplementation := Format(
          'CREATE %s',
          [Trim(Module.FieldAsString('Definition'))]);
        proc.Description := Trim(Module.FieldAsString('Description'));
        proc.DropImplementation := proc.OwnerCategory.DropTemplate;
        Module.Next
      end;
    end;
  end;

  procedure _GetFunctions;
  var
    funcs: TGDAOObjects;
    func: TGDAOObject;
  begin
    if ADictionary.Categories.FindByType(ctFunction) <> nil then
    begin
      funcs := ADictionary.Categories.FindByType(ctFunction).Objects;
      funcs.Clear;
      Module.Open(
        'SELECT Name, Description, Definition '+
        'FROM Information.Functions '+
        'ORDER BY Name');
      while not Module.EOF do
      begin
        func := funcs.Add(Module.FieldAsString('Name'));
        func.CreateImplementation := Format(
          'CREATE %s',
          [Trim(Module.FieldAsString('Definition'))]);
        func.Description := Trim(Module.FieldAsString('Description'));
        func.DropImplementation := func.OwnerCategory.DropTemplate;
        Module.Next
      end;
    end;
  end;

begin
  inherited;
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

function TElevateDBDataRetriever.GetFieldDefinition(AType: string; ALength,
  APrecision, AScale: integer): TFieldDefinitionRec;
begin
  result._DataTypeName := AType;
  AType := LowerCase(AType);

  if (AType = 'byte') or (AType = 'char') or (AType = 'varbyte') or (AType = 'varchar') then
    result._Size := ALength
  else if (AType = 'decimal') or (AType = 'numeric') then
  begin
    result._Size := APrecision;
    result._Precision := AScale;
  end;
end;

end.

