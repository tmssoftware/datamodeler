unit dgCompare;

{$I ../../dm.inc}

interface

uses
  Types, Generics.Collections, SysUtils, Classes, Windows, Dialogs, Controls, uGDAO, dgConsts, dgDBTypes, contnrs,
  {$IFDEF DATAMODELER}atProgress,{$ENDIF}
  dgDBStructurer;

type
  TDBCompare = class;
  TObjectCompareType = (ctName, ctId);

  TDBCompare = class(TPersistent)
  private
    FOldDB: TGDAODatabase;
    FNewDB: TGDAODatabase;
    FActionList: TatDBActionList;
    FCompareType: TObjectCompareType;
    FFilter: TSQLScriptFilter;
    FRemovedTables: TList<TGDAOTable>;
    FAddedTables: TList<TGDAOTable>;
    {$IFDEF DATAMODELER}
    FProg: TatProgress;
    function ProgCount: integer;
    {$ENDIF}
    procedure ActionChangeIndex(AIndex, OldIndex: TGDAOIndex);
    procedure ActionChangeDomain(ADomain, OldDomain: TGDAODomain);
    procedure ActionChangeRelationship(ARelationship, OldRelationship: TGDAORelationship);
    procedure ActionChangeTrigger(ATrigger, OldTrigger: TGDAOTrigger);
    procedure ActionChangeExtraObject(AObject, OldObject: TGDAOObject);
    procedure ActionChangeTableConstraint(AConstraint, OldConstraint: TGDAOConstraint);
    procedure ActionChangePrimaryKey(ATable, AOldTable: TGDAOTable);

    procedure ActionCreateExtraObject(AObject: TGDAOObject);
    procedure ActionCreateField(AField: TGDAOField);
    procedure ActionCreateIndex(AIndex: TGDAOIndex);
    procedure ActionCreateDomain(ADomain: TGDAODomain);
    procedure ActionCreateRelationship(ARelationship: TGDAORelationship);
    procedure ActionCreateTable(ATable: TGDAOTable);
    procedure ActionCreateTrigger(ATrigger: TGDAOTrigger);
    procedure ActionCreateTableConstraint(AConstraint: TGDAOConstraint);
    procedure ActionCreateConstraintFieldCheck(AField: TGDAOField);
    procedure ActionCreateConstraintFieldNotNull(AField: TGDAOField);
    procedure ActionCreateConstraintFieldDefault(AField: TGDAOField);
    procedure ActionCreatePrimaryKey(ATable: TGDAOTable);

    procedure ActionFieldRequired(AField: TGDAOField);
    procedure ActionFieldChangeSize(AField, AOldField: TGDAOField);
    procedure ActionFieldChangeType(AField, AOldField: TGDAOField; ADropField: boolean = false);
    procedure ActionFieldDefaultValueChange(AField, AOldField: TGDAOField);

    procedure ActionRemoveField(AField: TGDAOField);
    procedure ActionRemoveIndex(AIndex: TGDAOIndex);
    procedure ActionRemoveDomain(ADomain: TGDAODomain);
    procedure ActionRemoveRelationship(ARelationship: TGDAORelationship);
    procedure ActionRemoveTable(ATable: TGDAOTable);
    procedure ActionRemoveTrigger(ATrigger: TGDAOTrigger);
    procedure ActionRemoveExtraObject(AObject: TGDAOObject);
    procedure ActionRemoveTableConstraint(AConstraint: TGDAOConstraint);
    procedure ActionRemoveConstraintFieldCheck(AField: TGDAOField);
    procedure ActionRemoveConstraintFieldNotNull(AField: TGDAOField);
    procedure ActionRemoveConstraintFieldDefault(AField: TGDAOField);
    procedure ActionRemovePrimaryKey(ATable: TGDAOTable);

    procedure ActionRenameField(AField: TGDAOField; AOldName: string);
    procedure ActionRenameTable(ATable: TGDAOTable; AOldName: string);

    procedure CompareDomains(OldDomain, NewDomain: TGDAODomain);
    procedure CompareFields(OldField, NewField: TGDAOField);
    procedure CompareRelationships(OldRelationship,NewRelationship: TGDAORelationship);
    procedure CompareTables(OldTable, NewTable: TGDAOTable);

    procedure CheckNewDomains;
    procedure CheckRemovedDomains;
    procedure CheckNewRelationships;
    procedure CheckRemovedRelationships;
    procedure CheckTables;
    procedure CheckExtraObjects;
    procedure CheckTableConstraints(AOldTable, ANewTable: TGDAOTable);
    procedure CheckTableIndexes(AOldTable, ANewTable: TGDAOTable);
    procedure CheckTablePrimaryKeys(AOldTable, ANewTable: TGDAOTable);
    procedure CheckTableTriggers(AOldTable, ANewTable: TGDAOTable);

    procedure CheckProgressCanceled;
    procedure CheckProgressMessage(AMessage: string);
    procedure CheckProgressStep;

    procedure PerformCreateTable(ATable: TGDAOTable);
    procedure PerformRemoveTable(ATable: TGDAOTable);

    procedure RemoveRedundantRelationshipActions;

    procedure Compare(ACompareType: TObjectCompareType);
    class function CompareDatabases(OldDatabase, NewDatabase: TGDAODatabase;
      ACompareByIDs: boolean; AFilter: TSQLScriptFilter): TatDBActionList;

    property OldDB: TGDAODatabase read FOldDB write FOldDB;
    property NewDB: TGDAODatabase read FNewDB write FNewDB;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function CompareDatabases(OldDatabase, NewDatabase: TGDAODatabase;
  ACompareBYIDs: boolean; AFilter: TSQLScriptFilter): TatDBActionList;

implementation
uses
  dgDBActions;

type
  EObjectIDDoesNotExists = class(Exception);
  EFidDoesNotExists = class(EObjectIDDoesNotExists);
  ETidDoesNotExists = class(EObjectIDDoesNotExists);

function CompareDatabases(OldDatabase, NewDatabase: TGDAODatabase;
  ACompareBYIDs: boolean; AFilter: TSQLScriptFilter): TatDBActionList;
begin
  result := TDBCompare.CompareDatabases(OldDatabase, NewDatabase, ACompareBYIDs, AFilter);
end;

{ TDBCompare }

procedure TDBCompare.ActionCreateField(AField: TGDAOField);
var
  CreateFieldAction: TatCreateFieldAction;
begin
  if FFilter.MustInclude(AField) then
  begin
    CreateFieldAction := TatCreateFieldAction.Create(FActionList);
    CreateFieldAction.Field := AField;

    if FFilter. MustIncludeComments and (AField.Description > '') then
      TatCommentFieldAction.Create(FActionList).Field := AField;
  end;
end;

procedure TDBCompare.ActionCreateIndex(AIndex: TGDAOIndex);
var
  CreateIndexAction: TatCreateIndexAction;
begin
  if FFilter.MustInclude(AIndex) then
  begin
    CreateIndexAction := TatCreateIndexAction.Create(FActionList);
    CreateIndexAction.Index := AIndex;
  end;
end;

procedure TDBCompare.ActionCreatePrimaryKey(ATable: TGDAOTable);
begin
  if FFilter.MustIncludePrimaryKey(ATable) then
    TatCreatePrimaryKeyAction.Create(FActionList).Table := ATable;
end;

procedure TDBCompare.ActionCreateRelationship(ARelationship: TGDAORelationship);
var
  CreateRelationshipAction: TatCreateRelationshipAction;
begin
  if FFilter.MustInclude(ARelationship) then
  begin
    CreateRelationshipAction := TatCreateRelationshipAction.Create(FActionList);
    CreateRelationshipAction.Relationship := ARelationship;
  end;
end;

procedure TDBCompare.ActionCreateTable(ATable: TGDAOTable);
var
  CreateTableAction: TatCreateTableAction;
  i: integer;
begin
  if FFilter.MustInclude(ATable) then
  begin
    CreateTableAction := TatCreateTableAction.Create(FActionList);
    CreateTableAction.Table := ATable;

    if FFilter.MustIncludeComments then
    begin
      if ATable.Description > '' then
        TatCommentTableAction.Create(FActionList).Table := ATable;
      for i := 0 to ATable.Fields.Count-1 do
        if ATable.Fields[i].Description > '' then
          TatCommentFieldAction.Create(FActionList).Field := ATable.Fields[i];
    end;
  end;
end;

procedure TDBCompare.ActionFieldChangeSize(AField, AOldField: TGDAOField);
var
  FieldChangeSizeAction: TatFieldChangeSizeAction;
begin
  if FFilter.MustInclude(AField) then
  begin
    FieldChangeSizeAction := TatFieldChangeSizeAction.Create(FActionList);
    FieldChangeSizeAction.Field := AField;
    FieldChangeSizeAction.OldField := AOldField;
  end;
end;

procedure TDBCompare.ActionFieldChangeType(AField, AOldField: TGDAOField; ADropField: boolean = false);
var
  FieldChangeTypeAction: TatFieldChangeTypeAction;
begin
  if FFilter.MustInclude(AField) then
  begin
    FieldChangeTypeAction := TatFieldChangeTypeAction.Create(FActionList);
    FieldChangeTypeAction.Field := AField;
    FieldChangeTypeAction.DropField := ADropField;
    FieldChangeTypeAction.OldField := AOldField;
  end;
end;

procedure TDBCompare.ActionFieldRequired(AField: TGDAOField);
var
  FieldRequiredAction: TatFieldRequiredAction;
begin
  if FFilter.MustInclude(AField) then
  begin
    FieldRequiredAction := TatFieldRequiredAction.Create(FActionList);
    FieldRequiredAction.Field := AField;
  end;
end;

procedure TDBCompare.ActionRemoveField(AField: TGDAOField);
var
  RemoveFieldAction: TatRemoveFieldAction;
begin
  if FFilter.MustInclude(AField) then
  begin
    if NewDB.DatabaseType.DropConstraintsBeforeFieldDrop then
    begin
      if AField.ConstraintName <> '' then
        ActionRemoveConstraintFieldCheck(AField);
      if AField.ConstraintNotNullName <> '' then
        ActionRemoveConstraintFieldNotNull(AField);
      if AField.ConstraintDefaultName <> '' then
        ActionRemoveConstraintFieldDefault(AField);
    end;

    RemoveFieldAction := TatRemoveFieldAction.Create(FActionList);
    RemoveFieldAction.Field := AField;
  end;
end;

procedure TDBCompare.ActionRemoveIndex(AIndex: TGDAOIndex);
var
  RemoveIndexAction: TatRemoveIndexAction;
begin
  if FFilter.MustInclude(AIndex) then
  begin
    RemoveIndexAction := TatRemoveIndexAction.Create(FActionList);
    RemoveIndexAction.Index := AIndex;
  end;
end;

procedure TDBCompare.ActionRemovePrimaryKey(ATable: TGDAOTable);
begin
  if FFilter.MustIncludePrimaryKey(ATable) then
    TatRemovePrimaryKeyAction.Create(FActionList).Table := ATable;
end;

procedure TDBCompare.ActionRemoveRelationship(ARelationship: TGDAORelationship);
var
  RemoveRelationshipAction: TatRemoveRelationshipAction;
begin
  if FFilter.MustInclude(ARelationship) then
  begin
    RemoveRelationshipAction := TatRemoveRelationshipAction.Create(FActionList);
    RemoveRelationshipAction.Relationship := ARelationship;
  end;
end;

procedure TDBCompare.ActionRemoveTable(ATable: TGDAOTable);
var
  RemoveTableAction: TatRemoveTableAction;
begin
  if FFilter.MustInclude(ATable) then
  begin
    RemoveTableAction:=TatRemoveTableAction.Create(FActionList);
    RemoveTableAction.Table := ATable;
  end;
end;

procedure TDBCompare.Compare(ACompareType: TObjectCompareType);
begin
   FCompareType := ACompareType;

   {$IFDEF DATAMODELER}
   FProg := TatProgress.Create(nil);
   FProg.Caption := 'Progress';
   FProg.Options := [];
   FProg.FormPosition := fpScreenCenter;
   FProg.Start('Analyzing data dictionary', 0, ProgCount, 1);
   {$ENDIF}
   try
      if FActionList <> nil then
        FActionList.Clear;
      if assigned(OldDB) and assigned(NewDB) then
      begin
         { removed relationships }
         CheckRemovedRelationships;

         CheckNewDomains;

         { tables }
         CheckTables;

         { extra objects }
         CheckExtraObjects;

         CheckRemovedDomains;

         { new relationships }
         CheckNewRelationships;

         if NewDB.DatabaseType.RelationshipsInTablesOnly then
           RemoveRedundantRelationshipActions;
      end;
      {$IFDEF DATAMODELER}
      FProg.InfoMessage:='Comparison finished';
      FProg.Position:=FProg.Max;
      {$ENDIF}
   finally
      {$IFDEF DATAMODELER}
      FProg.Free;
      {$ENDIF}
   end;
end;

class function TDBCompare.CompareDatabases(OldDatabase, NewDatabase: TGDAODatabase;
  ACompareByIDs: boolean; AFilter: TSQLScriptFilter): TatDBActionList;
var
  DBCompare: TDBCompare;

begin
   result := TatDBActionList.Create(true);
   try
     DBCompare := TDBCompare.Create;
     with DBCompare do
     try
        if AFilter <> nil then
          FFilter.Assign(AFilter);
        OldDB := OldDatabase;
        NewDB := NewDatabase;
        FActionList := result;
        if ACompareByIds then
          Compare(ctId)
        else
          Compare(ctName);
     finally
        Free;
     end;
   except
     result.Free;
     raise;
   end;
end;

procedure TDBCompare.CompareDomains(OldDomain, NewDomain: TGDAODomain);
var
  AModified: boolean;
begin
  AModified := false;

  { renamed domain. Remember to compare by id if we ever implement
    domain renaming }
  if CompareText(OldDomain.Name, NewDomain.Name) <> 0 then
    AModified := true;

  { field type }
  if OldDomain.DataTypeName <> NewDomain.DataTypeName then
    AModified := true;

  if (OldDomain.Size <> NewDomain.Size) or (OldDomain.Size2 <> NewDomain.Size2) then
    AModified := true;

  if (OldDomain.Required <> NewDomain.Required) then
    AModified := true;

  { default value / constraint changed }
  if OldDomain.DefaultValue <> NewDomain.DefaultValue then
    AModified := true;

  if OldDomain.ConstraintExpr <> NewDomain.ConstraintExpr then
    AModified := true;

  if (OldDomain.SeedValue <> NewDomain.SeedValue) or (OldDomain.IncrementValue <> OldDomain.IncrementValue) then
    AModified := true;

  if AModified then
    ActionChangeDomain(NewDomain, OldDomain);

  if FFilter.MustIncludeComments and FFilter.MustInclude(NewDomain) and (OldDomain.Information <> NewDomain.Information) then
    TatCommentDomainAction.Create(FActionList).Domain := NewDomain;
end;

procedure TDBCompare.CompareFields(OldField, NewField: TGDAOField);
var
  AChangeTypeDropping: boolean;
  AChangeType: boolean;
  AChangeSize: boolean;
begin
  AChangeTypeDropping := false;
  AChangeType := false;
  AChangeSize := false;

  { renamed field }
  if CompareText(OldField.FieldName, NewField.FieldName) <> 0 then
     ActionRenameField(NewField, OldField.FieldName);

  { required / not null constraint changed }
  if OldField.Required <> NewField.Required then
    ActionFieldRequired(NewField);
  if OldField.ConstraintNotNullName <> NewField.ConstraintNotNullName then
  begin
    if OldField.ConstraintNotNullName > '' then
      ActionRemoveConstraintFieldNotNull(OldField);
    if OldField.ConstraintNotNullName > '' then
      ActionCreateConstraintFieldNotNull(NewField);
  end;

  { check for domains in database }
  if OldField.DomainName <> NewField.DomainName then
  begin
    if ((OldField.Domain <> nil) and OldField.Domain.InDatabase)
      or
       ((NewField.Domain <> nil) and NewField.Domain.InDatabase) then
      AChangeType := true;
  end;

  { field type }
  if (OldField.DataType.Computed <> NewField.DataType.Computed) or
    ((OldField.Expression <> NewField.Expression) and NewField.DataType.Computed) then
    AChangeTypeDropping := true
  else
  if (OldField.DataTypeName <> NewField.DataTypeName) then
    AChangeType := true
  else if OldField.Size <> NewField.Size then
    AChangeSize := true;

  {Seed/increment}
  if (OldField.SeedValue <> NewField.SeedValue) or (OldField.IncrementValue <> NewField.IncrementValue) then
    AChangeTypeDropping := true;

  if AChangeTypeDropping then
    ActionFieldChangeType(NewField, OldField, true)
  else
  if AChangeType then
    ActionFieldChangeType(NewField, OldField, false)
  else
  if AChangeSize then
    ActionFieldChangeSize(NewField, OldField);

  { default value / constraint changed }
  if OldField.DefaultValue <> NewField.DefaultValue then
  begin
    ActionFieldDefaultValueChange(NewField, OldField);
  end else
    // Only sql server has constraint names. and if default field value was changed,
    // then we don't need to again destroy and recreate the constraints, that's why
    // this code is in the "else" statement.
    if OldField.ConstraintDefaultName <> NewField.ConstraintDefaultName then
    begin
      if OldField.ConstraintDefaultName > '' then
        ActionRemoveConstraintFieldDefault(OldField);
      if NewField.ConstraintDefaultName > '' then
        ActionCreateConstraintFieldDefault(NewField);
    end;

  { check constraint changed }
  if (OldField.ConstraintName <> NewField.ConstraintName) or (OldField.ConstraintExpr <> NewField.ConstraintExpr) then
  begin
    if (OldField.ConstraintName > '') or (OldField.ConstraintExpr > '') then
      ActionRemoveConstraintFieldCheck(OldField);
    if (NewField.ConstraintName > '') or (NewField.ConstraintExpr > '') then
      ActionCreateConstraintFieldCheck(NewField);
  end;

  if FFilter.MustIncludeComments and FFilter.MustInclude(NewField) and (OldField.Description <> NewField.Description) then
    TatCommentFieldAction.Create(FActionList).Field := NewField;
end;

procedure TDBCompare.CompareTables(OldTable, NewTable: TGDAOTable);

   function EqualArrays(Array1, Array2: TStrArray): boolean;
   var i: integer;
   begin
      result:=length(Array1)=length(Array2);
      if result then
         for i:=low(Array1) to high(Array2) do
         begin
            result:=Array1[i]=Array2[i];
            if not result then exit;
         end;
   end;

var
  i: integer;
begin
  try
    { renamed table }
    if CompareText(OldTable.TableName, NewTable.TableName) <> 0 then
       ActionRenameTable(NewTable, OldTable.TableName);

    { check table fields }
    if FCompareType = ctId then { compare by internal identifier }
    begin
      for i:=0 to OldTable.Fields.Count-1 do
      begin
        if (OldTable.Fields[i].Fid=0) then
          raise EFidDoesNotExists.Create(Format('Field %s of table %s has not an internal identifier on last closed version. '+
            'Use field identifier to update AMD.',[OldTable.Fields[i].FieldName,OldTable.TableName]));

        if NewTable.Fields.IndexOfFid(OldTable.Fields[i].Fid) < 0 then
          ActionRemoveField(OldTable.Fields[i]) // removed field
        else // compare fields
          CompareFields(
            OldTable.Fields[i],
            NewTable.Fields[NewTable.Fields.IndexOfFid(OldTable.Fields[i].Fid)]);
      end;

      // new fields
      for i:=0 to NewTable.Fields.Count-1 do
      begin
        if (NewTable.Fields[i].Fid=0) then
          raise EFidDoesNotExists.Create(Format('Field %s of table %s has not an internal identifier on current version. '+
            'Use field identifier to update AMD.',[NewTable.Fields[i].FieldName,NewTable.TableName]));

        if OldTable.Fields.IndexOfFid(NewTable.Fields[i].Fid) < 0 then
          ActionCreateField(NewTable.Fields[i]);
      end;
    end
    else { compare by name }
    begin
      for i:=0 to OldTable.Fields.Count-1 do
        if NewTable.Fields.IndexOf(OldTable.Fields[i].FieldName) < 0 then
           ActionRemoveField(OldTable.Fields[i]) // removed field
        else // compare fields
           CompareFields(
             OldTable.Fields[i],
             NewTable.Fields[NewTable.Fields.IndexOf(OldTable.Fields[i].FieldName)]);

      // new fields
      for i := 0 to NewTable.Fields.Count - 1 do
        if OldTable.Fields.IndexOf(NewTable.Fields[i].FieldName) < 0 then
          ActionCreateField(NewTable.Fields[i]);
    end;

    if FFilter.MustIncludeComments and FFilter.MustInclude(NewTable) and (OldTable.Description <> NewTable.Description) then
      TatCommentTableAction.Create(FActionList).Table := NewTable;

    { check other table objects}
    CheckTablePrimaryKeys(OldTable, NewTable);
    CheckTableIndexes(OldTable, NewTable);
    CheckTableConstraints(OldTable, NewTable);
    CheckTableTriggers(OldTable, NewTable);
  except
    on e: exception do
      raise EGUIException.CreateFmt('Error comparing tables "%s": %s',
        [OldTable.TableName, e.Message]);
  end;
end;

constructor TDBCompare.Create;
begin
  FRemovedTables := TList<TGDAOTable>.Create;
  FAddedTables := TList<TGDAOTable>.Create;

  //Doesn't matter here. Will be overriden
  //FCompareType := ctName;
  FFilter := TSQLScriptFilter.Create;
end;

destructor TDBCompare.Destroy;
begin
  FAddedTables.Free;
  FRemovedTables.Free;
  FFilter.Free;
  inherited;
end;

procedure TDBCompare.PerformCreateTable(ATable: TGDAOTable);
var
  c: integer;
begin
  ActionCreateTable(ATable);

  {do not create table constraints because they're already created
   in Create Table command}

  {for c := 0 to ATable.Constraints.Count - 1 do
    ActionCreateTableConstraint(ATable.Constraints[c]);}
  for c := 0 to ATable.Indexes.Count - 1 do
    ActionCreateIndex(ATable.Indexes[c]);
  for c := 0 to ATable.Triggers.Count - 1 do
    ActionCreateTrigger(ATable.Triggers[c]);

  FAddedTables.Add(ATable);
end;

procedure TDBCompare.PerformRemoveTable(ATable: TGDAOTable);
var
  c: integer;
begin
  for c := 0 to ATable.Triggers.Count - 1 do
    ActionRemoveTrigger(ATable.Triggers[c]);
  for c := 0 to ATable.Indexes.Count - 1 do
    ActionRemoveIndex(ATable.Indexes[c]);

//  for c := 0 to ATable.Constraints.Count - 1 do
//    ActionRemoveTableConstraint(ATable.Constraints[c]);

  ActionRemoveTable(ATable);

  FRemovedTables.Add(ATable);
end;

{$IFDEF DATAMODELER}
function TDBCompare.ProgCount: integer;
begin
   result := 0;
   Inc(result, OldDB.Tables.Count + NewDB.Tables.Count);
   Inc(result, OldDB.Relationships.Count + NewDB.Relationships.Count);
   Inc(result, OldDB.Domains.Count + NewDB.Domains.Count);
   Inc(result, OldDB.Tables.Count + NewDB.Tables.Count);
end;
procedure TDBCompare.RemoveRedundantRelationshipActions;
var
  i: integer;
  A: TatDBAction;
begin
  i := 0;
  while i < FActionList.Count do
  begin
    A := TatDBAction(FActionList[i]);
    if A is TatCreateRelationshipAction then
    begin
      // Check if the table where the relationship belongs was also created (new table).
      // If that's the case, remove the action for creating relationship, because it's already being created in Create Table action
      // Comparing instances here works because added table and added relationship both belong to newdb dictionary - same instances
      if FAddedTables.IndexOf(TatCreateRelationshipAction(A).Relationship.ChildTable) >= 0 then
        FActionList.Remove(A)
      else
        inc(i);
    end
    else
    if A is TatRemoveRelationshipAction then
    begin
      // Check if the table where the relationship belongs was also removed (dropped table).
      // If that's the case, remove the action for destroying relationship, because it's already being removed in Remove Table action
      // Comparing instances here works because added table and added relationship both belong to olddb dictionary - same instances
      if FRemovedTables.IndexOf(TatRemoveRelationshipAction(A).Relationship.ChildTable) >= 0 then
        FActionList.Remove(A)
      else
        inc(i);
    end
    else
      inc(i);
  end;
end;

{$ENDIF}

procedure TDBCompare.CheckNewDomains;
var
  iDomain: integer;
  s: string;
begin
  CheckProgressMessage('Checking new domains');
  for iDomain := 0 to NewDB.Domains.Count - 1 do
  begin
    CheckProgressCanceled;

    {Compare only domains kept in database. Logical domains
     must be ignored because they will be "compared" in fields}
    if NewDB.Domains[iDomain].InDatabase then
    begin
      s := NewDB.Domains[iDomain].Name;
      if OldDB.Domains.FindByName(s) = nil then
        ActionCreateDomain(NewDB.Domains[iDomain]) // new domain
      else // compare domains
        CompareDomains(OldDB.Domains.FindByName(s), NewDB.Domains[iDomain]);
    end;
    CheckProgressStep;
  end;
end;

procedure TDBCompare.CheckNewRelationships;
var
  iRel: integer;
  s: string;
begin
  CheckProgressMessage('Checking new relationships');
  for iRel:=0 to NewDB.Relationships.Count-1 do
  begin
    CheckProgressCanceled;
    if (NewDB.Relationships[iRel].ParentTable <> nil) and (NewDB.Relationships[iRel].ChildTable <> nil) then
    begin
      s := NewDB.Relationships[iRel].RelationshipName;
      if OldDB.Relationships.IndexOf(s) < 0 then
        ActionCreateRelationship(NewDB.Relationships[iRel]) // new relationship
      else // compare relationships
        CompareRelationships(OldDB.RelationshipByName(s), NewDB.Relationships[iRel]);
    end;
    CheckProgressStep;
  end;
end;

procedure TDBCompare.CheckRemovedDomains;
var
  iDomain: integer;
begin
  CheckProgressMessage('Checking removed domains');
  for iDomain := 0 to OldDB.Domains.Count - 1 do
  begin
    CheckProgressCanceled;
    if OldDB.Domains[iDomain].InDatabase then
    begin
      if NewDB.Domains.FindByName(OldDB.Domains[iDomain].Name) = nil then
        ActionRemoveDomain(OldDB.Domains[iDomain]); // removed domains
    end;
    CheckProgressStep;
  end;
end;

procedure TDBCompare.CheckRemovedRelationships;
var iRel: integer;
begin
  CheckProgressMessage('Checking removed relationships');
  for iRel:=0 to OldDB.Relationships.Count-1 do
  begin
    CheckProgressCanceled;
    if NewDB.Relationships.IndexOf(OldDB.Relationships[iRel].RelationshipName) < 0 then
      ActionRemoveRelationship(OldDB.Relationships[iRel]); // removed relationship
    CheckProgressStep;
  end;
end;

procedure TDBCompare.CheckTables;
var
  iTable: integer;
begin
  CheckProgressMessage('Comparing tables');

  if FCompareType = ctId then { compare by internal identifier }
  begin
    for iTable := 0 to OldDB.Tables.Count - 1 do
    begin
      CheckProgressCanceled;
      if NewDB.Tables.IndexOfTid(OldDB.Tables[iTable].TID) < 0 then
        PerformRemoveTable(OldDB.Tables[iTable]);
      CheckProgressStep;
    end;

    // new tables
    for iTable:=0 to NewDB.Tables.Count-1 do
    begin
      CheckProgressCanceled;
      if OldDB.Tables.IndexOfTid(NewDB.Tables[iTable].TID) < 0 then
      begin
        PerformCreateTable(NewDB.Tables[iTable]);
      end
      else // compare tables
        CompareTables(
          OldDB.Tables[OldDB.Tables.IndexOfTid(NewDB.Tables[iTable].TID)],
          NewDB.Tables[iTable]);
      CheckProgressStep;
    end;

  end
  else { compare by name }
  begin
    for iTable:=0 to OldDB.Tables.Count-1 do
    begin
      CheckProgressCanceled;
      if NewDB.IndexOfTable(OldDB.Tables[iTable].TableName) < 0 then
        PerformRemoveTable(OldDB.Tables[iTable]);
      CheckProgressStep;
    end;

    // new tables
    for iTable:=0 to NewDB.Tables.Count-1 do
    begin
      CheckProgressCanceled;
      if OldDB.IndexOfTable(NewDB.Tables[iTable].TableName) < 0 then
      begin
        PerformCreateTable(NewDB.Tables[iTable]);
      end else
      begin
        CompareTables(
          OldDB.Tables[OldDB.IndexOfTable(NewDB.Tables[iTable].TableName)],
          NewDB.Tables[iTable]);
      end;
      CheckProgressStep;
    end;
  end;
end;

procedure TDBCompare.CheckTableTriggers(AOldTable, ANewTable: TGDAOTable);

  function EqualTriggers(OldTrigger, NewTrigger: TGDAOTrigger): boolean;
  begin
    result :=
      SameText(OldTrigger.ImplementationCode, NewTrigger.ImplementationCode);
  end;

var
  c: integer;
  AActualTrigger: TGDAOTrigger;
  APreviousTrigger: TGDAOTrigger;
begin
  {Check removed Triggers}
  for c := 0 to AOldTable.Triggers.Count - 1 do
    if ANewTable.Triggers.FindByName(AOldTable.Triggers[c].Name) = nil then
      ActionRemoveTrigger(AOldTable.Triggers[c]);

  {Check new Triggers}
  for c := 0 to ANewTable.Triggers.Count - 1 do
    if AOldTable.Triggers.FindByName(ANewTable.Triggers[c].Name) = nil then
      ActionCreateTrigger(ANewTable.Triggers[c]);

  {Compare existing Triggers}
  for c := 0 to ANewTable.Triggers.Count - 1 do
  begin
    AActualTrigger := ANewTable.Triggers[c];
    APreviousTrigger := AOldTable.Triggers.FindByName(AActualTrigger.Name);
    if (AActualTrigger <> nil) and (APreviousTrigger <> nil) then
    begin
      if not EqualTriggers(AActualTrigger, APreviousTrigger) then
        ActionChangeTrigger(AActualTrigger, APreviousTrigger);

      if FFilter.MustIncludeComments and FFilter.MustInclude(AActualTrigger) and
        (APreviousTrigger.Description <> AActualTrigger.Description)
      then
        TatCommentTriggerAction.Create(FActionList).Trigger := AActualTrigger;
    end;
  end;
end;

procedure TDBCompare.CheckExtraObjects;
var
  i, idx, j: integer;
  cat : TGDAOCategory;
begin
  { removed and modified extra objects }
  for i := 0 to OldDB.Categories.Count - 1 do
  begin
    cat := NewDB.Categories.FindByType(OldDB.Categories.Items[i].CategoryType);

    for j := 0 to OldDB.Categories.Items[i].Objects.Count-1 do
    begin
      if cat = nil then // removed category
         ActionRemoveExtraObject(OldDB.Categories.Items[i].Objects.Items[j])
      else
      begin
        idx := cat.Objects.IndexOf(OldDB.Categories.Items[i].Objects.Items[j].ObjectName);
        if idx >= 0 then
        begin
          // compare objects
          if not (
            SameText(Trim(OldDB.Categories.Items[i].Objects.Items[j].CreateImplementation),
              Trim(cat.Objects.Items[idx].CreateImplementation))
            and
            SameText(OldDB.Categories.Items[i].Objects.Items[j].CustomProps.Text,
              cat.Objects.Items[idx].CustomProps.Text)
             ) then
            ActionChangeExtraObject(cat.Objects.Items[idx], OldDB.Categories.Items[i].Objects.Items[j]);

           if FFilter.MustIncludeComments and FFilter.MustInclude(cat.Objects.Items[idx])
             and (cat.Objects.Items[idx].Description <> OldDB.Categories.Items[i].Objects.Items[j].Description)
           then
             TatCommentExtraObjectAction.Create(FActionList).ExtraObject := cat.Objects.Items[idx];
        end
        else // removed object
          ActionRemoveExtraObject(OldDB.Categories.Items[i].Objects.Items[j]);
      end;
    end;
  end;

  { new extra objects }
  for i := 0 to NewDB.Categories.Count-1 do
  begin
    cat := OldDB.Categories.FindByType(NewDB.Categories.Items[i].CategoryType);
    for j := 0 to NewDB.Categories.Items[i].Objects.Count-1 do
    begin
      if cat = nil then // new category
        ActionCreateExtraObject(NewDB.Categories.Items[i].Objects.Items[j])
      else
      begin
        if cat.Objects.IndexOf(NewDB.Categories.Items[i].Objects.Items[j].ObjectName) = -1 then    // object does not exist in the old version, create it
          ActionCreateExtraObject(NewDB.Categories.Items[i].Objects.Items[j]); // new object
      end;
    end;
  end;
end;

procedure TDBCompare.ActionRemoveTrigger(ATrigger: TGDAOTrigger);
var
  RemoveTriggerAction: TatRemoveTriggerAction;
begin
  if FFilter.MustInclude(ATrigger) then
  begin
    RemoveTriggerAction := TatRemoveTriggerAction.Create(FActionList);
    RemoveTriggerAction.Trigger := ATrigger;
  end;
end;

procedure TDBCompare.ActionCreateTrigger(ATrigger: TGDAOTrigger);
var
  CreateTriggerAction: TatCreateTriggerAction;
begin
  if FFilter.MustInclude(ATrigger) then
  begin
    CreateTriggerAction := TatCreateTriggerAction.Create(FActionList);
    CreateTriggerAction.Trigger := ATrigger;

    if FFilter.MustIncludeComments and (ATrigger.Description > '') then
      TatCommentTriggerAction.Create(FActionList).Trigger := ATrigger;
  end;
end;

procedure TDBCompare.CompareRelationships(OldRelationship, NewRelationship: TGDAORelationship);

    function DiffRelationshipFieldLinks(new, old: TGDAORelationship): boolean;
    var i: integer;
    begin
      result := False;
      if old.KeyLinkCount = new.KeyLinkCount then
      begin
        for i := 0 to old.KeyLinkCount - 1 do
        begin
          if not (SameText(new.KeyLinks[i].ParentFieldName, old.KeyLinks[i].ParentFieldName)
             and SameText(new.KeyLinks[i].ChildFieldName, old.KeyLinks[i].ChildFieldName))
          then
            result := True;
          if result then
            exit;
        end;
      end
      else
        result := True;
    end;

var
  difTable, difLink: boolean;

begin
  with NewRelationship do
  begin
    { check relationship tables }
    difTable := (CompareText(OldRelationship.ParentTableName, ParentTableName) <> 0) or (CompareText(OldRelationship.ChildTableName, ChildTableName) <> 0);

    { check relationship field links }
    difLink := DiffRelationshipFieldLinks(NewRelationship, OldRelationship);

    if difTable or difLink or (CompareText(OldRelationship.RelationshipName,RelationshipName) <> 0)
      or (OldRelationship.DeleteMethod <> DeleteMethod) or (OldRelationship.UpdateMethod <> UpdateMethod)
    then
      ActionChangeRelationship(NewRelationship, OldRelationship);
  end;
end;

procedure TDBCompare.ActionChangeIndex(AIndex, OldIndex: TGDAOIndex);
var
  ChangeIndexAction: TatChangeIndexAction;
begin
  if FFilter.MustInclude(AIndex) then
  begin
    ChangeIndexAction := TatChangeIndexAction.Create(FActionList);
    ChangeIndexAction._Index := AIndex;
    ChangeIndexAction.OldIndex := OldIndex;
  end;
end;

procedure TDBCompare.ActionChangePrimaryKey(ATable, AOldTable: TGDAOTable);
var
  ChangePrimaryKeyAction: TatChangePrimaryKeyAction;
begin
  if FFilter.MustIncludePrimaryKey(ATable) then
  begin
    ChangePrimaryKeyAction := TatChangePrimaryKeyAction.Create(FActionList);
    ChangePrimaryKeyAction.Table := ATable;
    ChangePrimaryKeyAction.OldTable := AOldTable;
  end;
end;

procedure TDBCompare.ActionChangeRelationship(ARelationship, OldRelationship: TGDAORelationship);
var
  ChangeRelationshipAction: TatChangeRelationshipAction;
begin
  if FFilter.MustInclude(ARelationship) then
  begin
    ChangeRelationshipAction := TatChangeRelationshipAction.Create(FActionList);
    ChangeRelationshipAction.Relationship := ARelationship;
    ChangeRelationshipAction.OldRelationship := OldRelationship;
  end;
end;

procedure TDBCompare.ActionChangeTrigger(ATrigger, OldTrigger: TGDAOTrigger);
var
  ChangeTriggerAction: TatChangeTriggerAction;
begin
  if FFilter.MustInclude(ATrigger) then
  begin
    ChangeTriggerAction := TatChangeTriggerAction.Create(FActionList);
    ChangeTriggerAction.Trigger := ATrigger;
    ChangeTriggerAction.OldTrigger := OldTrigger;
  end;
end;                                    

function MemoToString( s:string ):string;
var c: integer;
begin
   for c:=1 to length(s) do if s[c]<#32 then s[c]:=#32;
   result:=s;
end;

procedure TDBCompare.ActionRenameField(AField: TGDAOField; AOldName: string);
var
  RenameFieldAction: TatRenameFieldAction;
begin
  if FFilter.MustInclude(AField) then
  begin
    RenameFieldAction:=TatRenameFieldAction.Create(FActionList);
    RenameFieldAction.Field := AField;
    RenameFieldAction.OldName := AOldName;
  end;
end;

procedure TDBCompare.ActionRenametable(ATable: TGDAOTable; AOldName: string);
var
  RenameTableAction: TatRenameTableAction;
begin
  if FFilter.MustInclude(ATable) then
  begin
    RenameTableAction:=TatRenameTableAction.Create(FActionList);
    RenameTableAction.Table := ATable;
    RenameTableAction.OldName := AOldName;
  end;
end;

procedure TDBCompare.ActionRemoveConstraintFieldCheck(AField: TGDAOField);
var
  action: TatRemoveConstraintFieldCheckAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    action := TatRemoveConstraintFieldCheckAction.Create(FActionList);
    action.Field := AField;
  end;
end;

procedure TDBCompare.ActionRemoveConstraintFieldDefault(AField: TGDAOField);
var
  action: TatRemoveConstraintFieldDefaultAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    action := TatRemoveConstraintFieldDefaultAction.Create(FActionList);
    action.Field := AField;
  end;
end;

procedure TDBCompare.ActionRemoveConstraintFieldNotNull(AField: TGDAOField);
var
  action: TatRemoveConstraintFieldNotNullAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    action := TatRemoveConstraintFieldNotNullAction.Create(FActionList);
    action.Field := AField;
  end;
end;

procedure TDBCompare.ActionRemoveDomain(ADomain: TGDAODomain);
var
  RemoveDomainAction: TatRemoveDomainAction;
begin
  if FFilter.MustInclude(ADomain) then
  begin
    RemoveDomainAction := TatRemoveDomainAction.Create(FActionList);
    RemoveDomainAction.Domain := ADomain;
  end;
end;

procedure TDBCompare.ActionRemoveExtraObject(AObject: TGDAOObject);
var
  RemoveObjectAction: TatRemoveExtraObjectAction;
begin
  if FFilter.MustInclude(AObject) then
  begin
    RemoveObjectAction := TatRemoveExtraObjectAction.Create(FActionList);
    RemoveObjectAction.ExtraObject := AObject;
  end;
end;

procedure TDBCompare.ActionChangeDomain(ADomain, OldDomain: TGDAODomain);
var
  ChangeDomainAction: TatChangeDomainAction;
begin
  if FFilter.MustInclude(ADomain) then
  begin
    ChangeDomainAction := TatChangeDomainAction.Create(FActionList);
    ChangeDomainAction.Domain := ADomain;
    ChangeDomainAction.OldDomain := OldDomain;
  end;
end;

procedure TDBCompare.ActionChangeExtraObject(AObject, OldObject: TGDAOObject);
var
  ChangeObjectAction: TatChangeExtraObjectAction;
begin
  if FFilter.MustInclude(AObject) then
  begin
    ChangeObjectAction := TatChangeExtraObjectAction.Create(FActionList);
    ChangeObjectAction.ExtraObject := AObject;
    ChangeObjectAction.OldExtraObject := OldObject;
    ChangeObjectAction.UseAlter := FNewDB.DatabaseType.UseProcedureHeaders
      and (AObject.OwnerCategory.CategoryType = TGDAOCategoryType.ctProcedure);
  end;
end;

procedure TDBCompare.ActionCreateConstraintFieldCheck(AField: TGDAOField);
var
  action: TatCreateConstraintFieldCheckAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    action := TatCreateConstraintFieldCheckAction.Create(FActionList);
    action.Field := AField;
  end;
end;

procedure TDBCompare.ActionCreateConstraintFieldDefault(AField: TGDAOField);
var
  action: TatCreateConstraintFieldDefaultAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    action := TatCreateConstraintFieldDefaultAction.Create(FActionList);
    action.Field := AField;
  end;
end;

procedure TDBCompare.ActionCreateConstraintFieldNotNull(AField: TGDAOField);
var
  action: TatCreateConstraintFieldNotNullAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    action := TatCreateConstraintFieldNotNullAction.Create(FActionList);
    action.Field := AField;
  end;
end;

procedure TDBCompare.ActionCreateDomain(ADomain: TGDAODomain);
var
  CreateDomainAction: TatCreateDomainAction;
begin
  if FFilter.MustInclude(ADomain) then
  begin
    CreateDomainAction := TatCreateDomainAction.Create(FActionList);
    CreateDomainAction.Domain := ADomain;

    if FFilter.MustIncludeComments and (ADomain.Information > '') then
      TatCommentDomainAction.Create(FActionList).Domain := ADomain;
  end;
end;

procedure TDBCompare.ActionCreateExtraObject(AObject: TGDAOObject);
var
  CreateObjectAction: TatCreateExtraObjectAction;
begin
  if FFilter.MustInclude(AObject) then
  begin
    CreateObjectAction := TatCreateExtraObjectAction.Create(FActionList);
    CreateObjectAction.ExtraObject := AObject;
    CreateObjectAction.UseAlter := FNewDB.DatabaseType.UseProcedureHeaders
      and (AObject.OwnerCategory.CategoryType = TGDAOCategoryType.ctProcedure);

    if FFilter.MustIncludeComments and (AObject.Description > '') then
      TatCommentExtraObjectAction.Create(FActionList).ExtraObject := AObject;
  end;
end;

procedure TDBCompare.CheckTableConstraints(AOldTable, ANewTable: TGDAOTable);

  function EqualConstraints(C1, C2: TGDAOConstraint): boolean;
  begin
    result := (C1.Expression = C2.Expression);
  end;

var
  c: integer;
  AActualConstraint: TGDAOConstraint;
  APreviousConstraint: TGDAOConstraint;
begin
  {Check removed constraints}
  for c := 0 to AOldTable.Constraints.Count - 1 do
    if ANewTable.Constraints.FindByName(AOldTable.Constraints[c].ConstraintName) = nil then
      ActionRemoveTableConstraint(AOldTable.Constraints[c]);

  {Check new constraints}
  for c := 0 to ANewTable.Constraints.Count - 1 do
    if AOldTable.Constraints.FindByName(ANewTable.Constraints[c].ConstraintName) = nil then
      ActionCreateTableConstraint(ANewTable.Constraints[c]);

  {Compare existing constraints}
  for c := 0 to ANewTable.Constraints.Count - 1 do
  begin
    AActualConstraint := ANewTable.Constraints[c];
    APreviousConstraint := AOldTable.Constraints.FindByName(AActualConstraint.ConstraintName);
    if (AActualConstraint <> nil) and (APreviousConstraint <> nil) and
      not EqualConstraints(AActualConstraint, APreviousConstraint) then
    begin
      ActionChangeTableConstraint(AActualConstraint, APreviousConstraint);
    end;
  end;
end;

procedure TDBCompare.CheckTableIndexes(AOldTable, ANewTable: TGDAOTable);

  function EqualIndexes(Index1, Index2: TGDAOIndex): boolean;
  var
    i: integer;
  begin
    result := (Index1.IndexType = Index2.IndexType) and
              (Index1.IndexOrder = Index2.IndexOrder) and
              (Index1.IFields.Count = Index2.IFields.Count);
    if result then
       for i:=0 to Index1.IFields.Count-1 do
       begin
          result:=
            SameText(Index1.IFields.Field[i].FieldName,Index2.IFields.Field[i].FieldName)
            and
            (Index1.IFields[i].FieldOrder = Index2.IFields[i].FieldOrder);
          if not result then break;
       end;
  end;

var
  c: integer;
  AActualIndex: TGDAOIndex;
  APreviousIndex: TGDAOIndex;
begin
  {Check removed Indexes}
  for c := 0 to AOldTable.Indexes.Count - 1 do
    if ANewTable.Indexes.FindByName(AOldTable.Indexes[c].IndexName) = nil then
      ActionRemoveIndex(AOldTable.Indexes[c]);

  {Check new Indexes}
  for c := 0 to ANewTable.Indexes.Count - 1 do
    if AOldTable.Indexes.FindByName(ANewTable.Indexes[c].IndexName) = nil then
      ActionCreateIndex(ANewTable.Indexes[c]);

  {Compare existing Indexes}
  for c := 0 to ANewTable.Indexes.Count - 1 do
  begin
    AActualIndex := ANewTable.Indexes[c];
    APreviousIndex := AOldTable.Indexes.FindByName(AActualIndex.IndexName);
    if (AActualIndex <> nil) and (APreviousIndex <> nil) and
      not EqualIndexes(AActualIndex, APreviousIndex) then
    begin
      ActionChangeIndex(AActualIndex, APreviousIndex);
    end;
  end;
end;

procedure TDBCompare.CheckTablePrimaryKeys(AOldTable, ANewTable: TGDAOTable);
var
  slOld, slNew: TStringList;
  i: integer;
begin
  slOld := TStringList.Create;
  slNew := TStringList.Create;
  try
    for i := 0 to AOldTable.PrimaryKeyIndex.IFields.Count - 1 do
      slOld.Add(Lowercase(AOldTable.PrimaryKeyIndex.IFields[i].Field.FieldName));
    for i := 0 to ANewTable.PrimaryKeyIndex.IFields.Count - 1 do
      slNew.Add(Lowercase(ANewTable.PrimaryKeyIndex.IFields[i].Field.FieldName));

    if (slOld.Count > 0) or (slNew.Count > 0) then
    begin
      if slOld.Count = 0 then
        ActionCreatePrimaryKey(ANewTable)
      else
      if slNew.Count = 0 then
        ActionRemovePrimaryKey(AOldTable)
      else
      if (slOld.Text <> slNew.Text) or not SameText(AOldTable.PrimaryKeyIndex.IndexName, ANewTable.PrimaryKeyIndex.IndexName) then
        ActionChangePrimaryKey(ANewTable, AOldTable);
    end;
  finally
    slOld.Free;
    slNew.Free;
  end;
end;

procedure TDBCompare.ActionCreateTableConstraint(AConstraint: TGDAOConstraint);
var
  rAction: TatCreateTableConstraintAction;
begin
  if FFilter.MustInclude(AConstraint) then
  begin
    rAction := TatCreateTableConstraintAction.Create(FActionList);
    rAction.Constraint := AConstraint;
  end;
end;

procedure TDBCompare.ActionRemoveTableConstraint(AConstraint: TGDAOConstraint);
var
  rAction: TatRemoveTableConstraintAction;
begin
  if FFilter.MustInclude(AConstraint) then
  begin
    rAction := TatRemoveTableConstraintAction.Create(FActionList);
    rAction.Constraint := AConstraint;
  end;
end;

procedure TDBCompare.ActionFieldDefaultValueChange(AField, AOldField: TGDAOField);
var
  FieldDefaultValueAction: TatFieldChangeDefaultValueAction;
begin
  if FFilter.MustIncludeConstraint(AField) then
  begin
    FieldDefaultValueAction:=TatFieldChangeDefaultValueAction.Create(FActionList);
    FieldDefaultValueAction.Field := AField;
    FieldDefaultValueAction.OldField := AOldField;
  end;
end;

procedure TDBCompare.ActionChangeTableConstraint(AConstraint, OldConstraint: TGDAOConstraint);
var
  cChange : TatChangeTableConstraintAction;
begin
  if FFilter.MustInclude(AConstraint) then
  begin
    cChange := TatChangeTableConstraintAction.Create(FActionList);
    cChange.Constraint := AConstraint;
    cChange.OldConstraint := OldConstraint;
  end;
end;

procedure TDBCompare.CheckProgressCanceled;
begin
  {$IFDEF DATAMODELER}
  if FProg.ProgressCanceled then Abort;
  {$ENDIF}
end;

procedure TDBCompare.CheckProgressMessage(AMessage: string);
begin
  {$IFDEF DATAMODELER}
  FProg.InfoMessage:=AMessage;
  {$ENDIF}
end;

procedure TDBCompare.CheckProgressStep;
begin
  {$IFDEF DATAMODELER}
  FProg.StepIt;
  {$ENDIF}
end;

end.

