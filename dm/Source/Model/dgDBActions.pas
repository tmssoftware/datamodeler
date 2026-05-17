unit dgDBActions;

interface

uses
  SysUtils, Classes, DB, Dialogs, Typinfo, Windows, dgDBStructurer, uGDAO, dgConsts;

type
  TatChangeTableConstraintAction = class(TatDBAction)
  private                                            
    FConstraint: TGDAOConstraint;
    FOldConstraint: TGDAOConstraint;
    procedure SetConstraint(const Value: TGDAOConstraint);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Constraint: TGDAOConstraint read FConstraint write SetConstraint;
    property OldConstraint: TGDAOConstraint read FOldConstraint write FOldConstraint;
  end;

  TatChangeRelationshipAction = class(TatDBAction)
  private
    FRelationship: TGDAORelationship;
    FOldRelationship: TGDAORelationship;
    procedure SetRelationship(const Value: TGDAORelationship);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Relationship: TGDAORelationship read FRelationship write SetRelationship;
    property OldRelationship: TGDAORelationship read FOldRelationship write FOldRelationship;
  end;

  TatChangeTriggerAction = class(TatDBAction)
  private
    FTrigger: TGDAOTrigger;
    FOldTrigger: TGDAOTrigger;
    procedure SetTrigger(const Value: TGDAOTrigger);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Trigger: TGDAOTrigger read FTrigger write SetTrigger;
    property OldTrigger: TGDAOTrigger read FOldTrigger write FOldTrigger;
  end;

  TatChangeIndexAction = class(TatDBAction)
  private
    FIndex: TGDAOIndex;
    FOldIndex: TGDAOIndex;
    procedure SetTableIndex(const Value: TGDAOIndex);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property _Index: TGDAOIndex read FIndex write SetTableIndex;
    property OldIndex: TGDAOIndex read FOldIndex write FOldIndex;
  end;

  TatCreateFieldAction = class(TatDBAction)
  private
    FField: TGDAOField;
    procedure SetField(const Value: TGDAOField);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write SetField;
  end;

  TatCreateTableConstraintAction = class(TatDBAction)
  private
    FConstraint: TGDAOConstraint;
    procedure SetConstraint(const Value: TGDAOConstraint);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Constraint : TGDAOConstraint read FConstraint write SetConstraint;
  end;

  TatCreateIndexAction = class(TatDBAction)
  private
    FIndex: TGDAOIndex;
    procedure SetIndex(const Value: TGDAOIndex);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Index: TGDAOIndex read FIndex write SetIndex;
  end;

  TatCreateRelationshipAction = class(TatDBAction)
  private
    FRelationship: TGDAORelationship;
    procedure SetRelationship(const Value: TGDAORelationship);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Relationship: TGDAORelationship read FRelationship write SetRelationship;
  end;

  TatCreateTableAction = class(TatDBAction)
  private
    FTable: TGDAOTable;
    procedure SetTable(const Value: TGDAOTable);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
    property Table: TGDAOTable read FTable write SetTable;
  end;

  TatCreateTriggerAction = class(TatDBAction)
  private
    FTrigger: TGDAOTrigger;
    procedure SetTrigger(const Value: TGDAOTrigger);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Trigger: TGDAOTrigger read FTrigger write SetTrigger;
  end;

  TatFieldRequiredAction = class(TatDBAction)
  private
    FField: TGDAOField;
    procedure SetField(const Value: TGDAOField);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write SetField;
  end;

  TatFieldChangeSizeAction = class(TatDBAction)
  private
    FField: TGDAOField;
    FOldField: TGDAOField;
    procedure SetField(const Value: TGDAOField);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field : TGDAOField read FField write SetField;
    property OldField : TGDAOField read FOldField write FOldField;
  end;

  TatFieldChangeDefaultValueAction = class(TatDBAction)
  private
    FField: TGDAOField;
    FOldField: TGDAOField;
    procedure SetField(const Value: TGDAOField);
    procedure SetOldField(const Value: TGDAOField);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write SetField;
    property OldField: TGDAOField read FOldField write SetOldField;
  end;

  TatFieldChangeTypeAction = class(TatDBAction)
  private
    FField: TGDAOField;
    FDropField: boolean;
    FOldField: TGDAOField;
    procedure SetField(const Value: TGDAOField);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write SetField;
    property DropField: boolean read FDropField write FDropField;
    property OldField: TGDAOField read FOldField write FOldField;
  end;

  TatRemoveFieldAction = class(TatDBAction)
  private
    FField: TGDAOField;
    procedure SetField(const Value: TGDAOField);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write SetField;
  end;

  TatRemoveIndexAction = class(TatDBAction)
  private
    FIndex: TGDAOIndex;
    procedure SetIndex(const Value: TGDAOIndex);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
    function GetDetails: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Index: TGDAOIndex read FIndex write SetIndex;
  end;

  TatRemoveRelationshipAction = class(TatDBAction)
  private
    FRelationship: TGDAORelationship;
    procedure SetRelationship(const Value: TGDAORelationship);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Relationship: TGDAORelationship read FRelationship write SetRelationship;
  end;

  TatRemoveTableAction = class(TatDBAction)
  private
    FTable: TGDAOTable;
    procedure SetTable(const Value: TGDAOTable);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Table: TGDAOTable read FTable write SetTable;
  end;

  TatRemoveTableConstraintAction = class(TatDBAction)
  private
    FConstraint: TGDAOConstraint;
    procedure SetConstraint(const Value: TGDAOConstraint);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Constraint: TGDAOConstraint read FConstraint write SetConstraint;
  end;

  TatCreatePrimaryKeyAction = class(TatDBAction)
  private
    FTable: TGDAOTable;
    procedure SetTable(const Value: TGDAOTable);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Table: TGDAOTable read FTable write SetTable;
  end;

  TatRemovePrimaryKeyAction = class(TatDBAction)
  private
    FTable: TGDAOTable;
    procedure SetTable(const Value: TGDAOTable);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Table: TGDAOTable read FTable write SetTable;
  end;

  TatChangePrimaryKeyAction = class(TatDBAction)
  private
    FTable: TGDAOTable;
    FOldTable: TGDAOTable;
    procedure SetTable(const Value: TGDAOTable);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Table: TGDAOTable read FTable write SetTable;
    property OldTable: TGDAOTable read FOldTable write FOldTable;
  end;

  TatRemoveTriggerAction = class(TatDBAction)
  private
    FTrigger: TGDAOTrigger;
    procedure SetTrigger(const Value: TGDAOTrigger);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Trigger: TGDAOTrigger read FTrigger write SetTrigger;
  end;

  TatRenameFieldAction = class(TatDBAction)
  private
    FField: TGDAOField;
    FOldName: string;
    procedure SetField(const Value: TGDAOField);
    procedure SetOldName(const Value: string);
  protected
    function GetDetails: string; override;
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write SetField;
    property OldName: string read FOldName write SetOldName;
  end;

  TatRenameTableAction = class(TatDBAction)
  private
    FTable: TGDAOTable;
    FOldName: string;
    procedure SetOldName(const Value: string);
    procedure SetTable(const Value: TGDAOTable);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Table: TGDAOTable read FTable write SetTable;
    property OldName: string read FOldName write SetOldName;
  end;

  TatConstraintFieldAction = class(TatDBAction)
  private
    FField: TGDAOField;
  protected
    function GetCategory: TCategoryAction; override;
  public
    property Field: TGDAOField read FField write FField;
  end;

  TatCreateConstraintFieldCheckAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
  end;

  TatCreateConstraintFieldDefaultAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
  end;

  TatCreateConstraintFieldNotNullAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
  end;

  TatRemoveConstraintFieldCheckAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
  end;

  TatRemoveConstraintFieldDefaultAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
  end;

  TatRemoveConstraintFieldNotNullAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
  end;

  TatCreateExtraObjectAction = class(TatDBAction)
  private
    FExtraObject: TGDAOObject;
    FUseAlter: boolean;
    procedure SetExtraObject(const Value: TGDAOObject);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property ExtraObject: TGDAOObject read FExtraObject write SetExtraObject;
    property UseAlter: boolean read FUseAlter write FUseAlter;
  end;

  TatRemoveExtraObjectAction = class(TatDBAction)
  private
    FExtraObject: TGDAOObject;
    procedure SetExtraObject(const Value: TGDAOObject);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property ExtraObject: TGDAOObject read FExtraObject write SetExtraObject;
  end;

  TatChangeExtraObjectAction = class(TatDBAction)
  private
    FExtraObject: TGDAOObject;
    FOldExtraObject: TGDAOObject;
    FUseAlter: boolean;
    procedure SetExtraObject(const Value: TGDAOObject);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property ExtraObject: TGDAOObject read FExtraObject write SetExtraObject;
    property OldExtraObject: TGDAOObject read FOldExtraObject write FOldExtraObject;
    property UseAlter: boolean read FUseAlter write FUseAlter;
  end;

  TatChangeDomainAction = class(TatDBAction)
  private
    FDomain: TGDAODomain;
    FOldDomain: TGDAODomain;
    procedure SetDomain(const Value: TGDAODomain);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Domain: TGDAODomain read FDomain write SetDomain;
    property OldDomain: TGDAODomain read FOldDomain write FOldDomain;
  end;

  TatCreateDomainAction = class(TatDBAction)
  private
    FDomain: TGDAODomain;
    procedure SetDomain(const Value: TGDAODomain);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Domain: TGDAODomain read FDomain write SetDomain;
  end;

  TatRemoveDomainAction = class(TatDBAction)
  private
    FDomain: TGDAODomain;
    procedure SetDomain(const Value: TGDAODomain);
  protected
    function GetDescription: string; override;
    function GetCategory: TCategoryAction; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Domain: TGDAODomain read FDomain write SetDomain;
  end;

  TatCommentAction = class(TatDBAction)
  protected
    function GetCategory: TCategoryAction; override;
  end;

  TatCommentTableAction = class(TatCommentAction)
  private
    FTable: TGDAOTable;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Table: TGDAOTable read FTable write FTable;
  end;

  TatCommentFieldAction = class(TatCommentAction)
  private
    FField: TGDAOField;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write FField;
  end;

  TatCommentDomainAction = class(TatCommentAction)
  private
    FDomain: TGDAODomain;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Domain: TGDAODomain read FDomain write FDomain;
  end;

  TatCommentTriggerAction = class(TatCommentAction)
  private
    FTrigger: TGDAOTrigger;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Trigger: TGDAOTrigger read FTrigger write FTrigger;
  end;

  TatCommentExtraObjectAction = class(TatCommentAction)
  private
    FExtraObject: TGDAOObject;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property ExtraObject: TGDAOObject read FExtraObject write FExtraObject;
  end;

const
  txt_ChangeProcedure   = 'Stored procedure %s change';
  txt_ChangeDomain      = 'Domain %s change';
  txt_ChangeRelationship    = 'Relationship %s (%s -> %s) change';
  txt_ChangeTrigger     = 'Trigger %s change in table %s';
  txt_ChangeIndex       = 'Index %s change in table %s';
  txt_ChangePrimaryKey  = 'Primary key change in table %s';
  txt_ChangeView        = 'View %s change';
  txt_CreateField       = 'New field %s in table %s';
  txt_CreateIndex       = 'New index %s in table %s';
  txt_CreateProcedure   = 'New procedure %s';
  txt_CreateDomain    = 'New domain %s';
  txt_CreateRelationship    = 'New relationship %s between %s and %s';
  txt_CreateSequence    = 'New sequence generator %s';
  txt_CreateTable       = 'New table %s';
  txt_CreateTableConstraint = 'New constraint "%s" in table %s';
  txt_ChangeTableConstraint = 'Constraint "%s" change in table %s (new: %s; old: %s)';
  txt_CreateTrigger     = 'New trigger %s in table %s';
  txt_CreatePrimaryKey  = 'Primary key added to table %s';
  txt_CreateView        = 'New view %s';
  txt_DeleteRecord      = 'Record deleted from table %s';
  txt_FieldChangeSize   = 'Field "%s" size change in table %s (new: %s; old: %s)';
  txt_FieldChangeType   = 'Field "%s" type change in table %s (new: %s; old: %s)';
  txt_FieldDefaultValueChange = 'Field "%s.%s" defaut value changed (new: %s; old: %s)';
  txt_FieldRequired     = 'Field %s %srequired in table %s';
  txt_InsertRecord      = 'Record inserted into table %s';
  txt_RemoveField       = 'Drop field %s in table %s';
  txt_RemoveIndex       = 'Drop index %s in table %s';
  txt_RemoveTableConstraint = 'Drop constraint "%s" in table %s';
  txt_RemoveProcedure   = 'Drop procedure %s';
  txt_RemoveDomain    = 'Drop domain %s';
  txt_RemoveRelationship    = 'Drop relationship %s in table %s';
  txt_RemoveSequence    = 'Drop sequence generator %s';
  txt_RemoveTable       = 'Drop table %s';
  txt_RemoveTrigger     = 'Drop trigger %s in table %s';
  txt_RemovePrimaryKey  = 'Primary key removed from table %s';
  txt_RemoveView        = 'Drop view %s';
  txt_RenameField       = 'Field "%s" name change in table %s';
  txt_RenameIndex       = 'Index "%s" name changed to "%s" in table %s';
  txt_RenameTable       = 'Table "%s" name change to %s';
  txt_UpdateRecord      = 'Record changed on table %s';
  msg_FieldSizeError    = 'Could not change field %s size, in %s ';
  msg_FieldTypeError    = 'Could not change field %s type, em %s ';
  DEF_DICTABLENAME      = 'Table';
  DEF_FIELDLISTNAME     = 'Fields';
  txt_CreateConstraintFieldCheckAction = 'Check constraint created on field %s (table %s)';
  txt_CreateConstraintFieldDefaultAction = 'Default value constraint created on field %s (table %s)';
  txt_CreateConstraintFieldNotNullAction = 'Not null constraint created on field %s (table %s)';
  txt_RemoveConstraintFieldCheckAction = 'Check constraint removed from field %s (table %s)';
  txt_RemoveConstraintFieldDefaultAction = 'Default value constraint removed from field %s (table %s)';
  txt_RemoveConstraintFieldNotNullAction = 'Not null constraint removed from field %s (table %s)';

implementation

const
  txt_CreateObject      = 'New %s "%s"';
  txt_RemoveObject      = 'Drop %s "%s"';
  txt_ChangeObject      = '%s "%s" change';


{ TatCreateFieldAction }

procedure TatCreateFieldAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateField(Field);
end;

function TatCreateFieldAction.GetCategory: TCategoryAction;
begin
   result:=caCreate;
end;

function TatCreateFieldAction.GetDescription: string;
begin
  result:=Format(txt_CreateField,[Field.FieldName, Field.OwnerTable.TableName]);
end;

function TatCreateFieldAction.GetDetails: string;
begin
   result := Format('Field %s: type %s',
      [ Field.FieldName,
        Field.GetGridDataTypeName]);
   if Field.Required then
      result:=result+', required';
   if Field.DefaultValue > '' then
      result:=result+' - default value: '+Field.DefaultValue;
end;

procedure TatCreateFieldAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

{ TatCreateIndexAction }

function TatCreateIndexAction.GetDetails: string;
var iops: string;
begin
  if Index.IndexType = itUnique then
    iops := 'Exclusive'
  else
  if Index.IndexType = itUniqueKey then
    iops := 'Unique Key';
  result:=Format('Index "%s" %s', [Index.IndexName, iops]);
end;

procedure TatCreateIndexAction.SetIndex(const Value: TGDAOIndex);
begin
  FIndex := Value;
end;

procedure TatCreateIndexAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateIndex(Index);
end;

function TatCreateIndexAction.GetCategory: TCategoryAction;
begin
   result:=caCreate;
end;

function TatCreateIndexAction.GetDescription: string;
begin
   result:=Format(txt_CreateIndex,[Index.IndexName, Index.OwnerTable.TableName]);
end;

{ TatCreateRelationshipAction }

procedure TatCreateRelationshipAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
    DBStructurer.CreateRelationship(Relationship);
end;

function TatCreateRelationshipAction.GetCategory: TCategoryAction;
begin
   result:=caCreate;
end;

function TatCreateRelationshipAction.GetDescription: string;
begin
   result:=Format(txt_CreateRelationship, [Relationship.RelationshipName, Relationship.ChildTableName, Relationship.ParentTableName]);
end;

function TatCreateRelationshipAction.GetDetails: string;
begin
   result := Format('Relationship %s: %s => %s',
      [ Relationship.RelationshipName,
        Relationship.ChildTableName,
        Relationship.ParentTableName ]);
end;

procedure TatCreateRelationshipAction.SetRelationship(const Value: TGDAORelationship);
begin
  FRelationship := Value;
end;

{ TatCreateTableAction }

procedure TatCreateTableAction.ApplyDBAction(ADictionary: TGDAODatabase);
begin
  inherited;
  with ADictionary.AddTable(Table.TableName) do
  begin
    Assign(Self.Table);
    UpdateID;
  end;
end;

procedure TatCreateTableAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
    DBStructurer.CreateTable(Table);
end;

function TatCreateTableAction.GetCategory: TCategoryAction;
begin
   result:=caCreate;
end;

function TatCreateTableAction.GetDescription: string;
begin
   result:=Format(txt_CreateTable, [Table.TableName]);
end;

function TatCreateTableAction.GetDetails: string;
var i: integer;
begin
   with Table do
   begin
      result := 'Fields of table '+TableName+': ';
      for i:=0 to Fields.Count-1 do
         result:=result+Fields[i].FieldName+',';
      if result[length(result)]=',' then
         delete(result,length(result),1);
   end;
end;

procedure TatCreateTableAction.SetTable(const Value: TGDAOTable);
begin
  FTable := Value;
end;

{ TatRemoveFieldAction }

procedure TatRemoveFieldAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveField(Field);
end;

function TatRemoveFieldAction.GetCategory: TCategoryAction;
begin
   result:=caRemove;
end;

function TatRemoveFieldAction.GetDescription: string;
begin
   result:=Format(txt_RemoveField, [Field.FieldName, Field.OwnerTable.TableName]);
end;

procedure TatRemoveFieldAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

{ TatRemoveIndexAction }

procedure TatRemoveIndexAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveIndex(Index);
end;

function TatRemoveIndexAction.GetCategory: TCategoryAction;
begin
   result:=caRemove;
end;

function TatRemoveIndexAction.GetDescription: string;
begin
   result:=Format(txt_RemoveIndex, [Index.IndexName, Index.OwnerTable.TableName]);
end;

function TatRemoveIndexAction.GetDetails: string;
begin
   result:=inherited GetDetails;
end;

procedure TatRemoveIndexAction.SetIndex(const Value: TGDAOIndex);
begin
  FIndex := Value;
end;

{ TatRemoveRelationshipAction }

procedure TatRemoveRelationshipAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveRelationship(Relationship);
end;

function TatRemoveRelationshipAction.GetCategory: TCategoryAction;
begin
   result:=caRemove;
end;

function TatRemoveRelationshipAction.GetDescription: string;
begin
   result:=Format(txt_RemoveRelationship, [Relationship.RelationshipName, Relationship.ChildTableName]);
end;

procedure TatRemoveRelationshipAction.SetRelationship(const Value: TGDAORelationship);
begin
  FRelationship := Value;
end;

{ TatRemoveTableAction }

procedure TatRemoveTableAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveTable(Table);
end;

function TatRemoveTableAction.GetCategory: TCategoryAction;
begin
   result:=caRemove;
end;

function TatRemoveTableAction.GetDescription: string;
begin
  result:=Format(txt_RemoveTable, [Table.TableName]);
end;

procedure TatRemoveTableAction.SetTable(const Value: TGDAOTable);
begin
  FTable := Value;
end;

{ TatFieldRequiredAction }

procedure TatFieldRequiredAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.ChangeFieldRequired(Field);
end;

function TatFieldRequiredAction.GetCategory: TCategoryAction;
begin
   result:=caModify;
end;

function TatFieldRequiredAction.GetDescription: string;
var sn: string;
begin
  if Field.Required then sn:=''
  else sn:='not ';
  result:=Format(txt_FieldRequired,[Field.FieldName, sn, Field.OwnerTable.TableName]);
end;

procedure TatFieldRequiredAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

{ TatFieldChangeSizeAction }

procedure TatFieldChangeSizeAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.ChangeFieldSize(Field);
end;

function TatFieldChangeSizeAction.GetCategory: TCategoryAction;
begin
   result:=caModify;
end;

function TatFieldChangeSizeAction.GetDescription: string;
begin
  result:=Format(txt_FieldChangeSize, [Field.FieldName, Field.OwnerTable.TableName,
    IntToStr(Field.Size), IntToStr(OldField.Size)]);
end;

function TatFieldChangeSizeAction.GetDetails: string;
begin
//   result := Format('Change of size of field %s from %d to %d',
//      [FieldName,OldSize,NewSize]);
end;

procedure TatFieldChangeSizeAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

{ TatFieldChangeTypeAction }

procedure TatFieldChangeTypeAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  if DropField then
  begin
    DBStructurer.RemoveField(Field);
    DBStructurer.CreateField(Field);
  end
  else
    DBStructurer.ChangeFieldType(Field);
end;

function TatFieldChangeTypeAction.GetCategory: TCategoryAction;
begin
  result:=caModify;
end;

function TatFieldChangeTypeAction.GetDescription: string;
begin
  result:=Format(txt_FieldChangeType,
    [Field.FieldName, Field.OwnerTable.TableName,
     Field.GetGridDataTypeName, OldField.GetGridDataTypeName]);
end;

function TatFieldChangeTypeAction.GetDetails: string;
begin
{   result:=Format('New type of field %s: %s (%s)',
      [FieldName,
       GetEnumName(TypeInfo(TFieldType),ord(ArrayGDAOFieldType[DataType])),
       PhysicalDataType])}
end;

procedure TatFieldChangeTypeAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

{ TatRenameTableAction }

procedure TatRenameTableAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RenameTable(Table, OldName);
end;

function TatRenameTableAction.GetCategory: TCategoryAction;
begin
   result:=caModify;
end;

function TatRenameTableAction.GetDescription: string;
begin
   result:=Format(txt_RenameTable, [OldName, Table.TableName]);
end;

procedure TatRenameTableAction.SetOldName(const Value: string);
begin
  FOldName := Value;
end;

procedure TatRenameTableAction.SetTable(const Value: TGDAOTable);
begin
  FTable := Value;
end;

{ TatRemoveTriggerAction }

procedure TatRemoveTriggerAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveTrigger(Trigger);
end;

function TatRemoveTriggerAction.GetCategory: TCategoryAction;
begin
   result:=caRemove;
end;

function TatRemoveTriggerAction.GetDescription: string;
begin
   result:=Format(txt_RemoveTrigger, [Trigger.Name, Trigger.OwnerTable.TableName]);
end;

procedure TatRemoveTriggerAction.SetTrigger(const Value: TGDAOTrigger);
begin
  FTrigger := Value;
end;

{ TatCreateTriggerAction }

procedure TatCreateTriggerAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateTrigger(Trigger);
end;

function TatCreateTriggerAction.GetCategory: TCategoryAction;
begin
   result:=caCreate;
end;

function TatCreateTriggerAction.GetDescription: string;
begin
  result:=Format(txt_CreateTrigger,[Trigger.Name, Trigger.OwnerTable.TableName]);
end;

procedure TatCreateTriggerAction.SetTrigger(const Value: TGDAOTrigger);
begin
  FTrigger := Value;
end;

{ TatRenameFieldAction }

procedure TatRenameFieldAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RenameField(Field, OldName);
end;

function TatRenameFieldAction.GetCategory: TCategoryAction;
begin
   result:=caModify;
end;

function TatRenameFieldAction.GetDescription: string;
begin
   result:=Format(txt_RenameField, [Field.FieldName, Field.OwnerTable.TableName]);
end;

function TatRenameFieldAction.GetDetails: string;
begin
   result:='';
end;

procedure TatRenameFieldAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

procedure TatRenameFieldAction.SetOldName(const Value: string);
begin
  FOldName := Value;
end;

{ TatCreateExtraObject }

procedure TatCreateExtraObjectAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateExtraObject(ExtraObject, UseAlter);
end;

function TatCreateExtraObjectAction.GetCategory: TCategoryAction;
begin
   Result := caCreate;
end;

function TatCreateExtraObjectAction.GetDescription: string;
begin
   Result := Format(txt_CreateObject,
     [ExtraObject.OwnerCategory.CategoryNameS, ExtraObject.ObjectName]);
end;

procedure TatCreateExtraObjectAction.SetExtraObject(const Value: TGDAOObject);
begin
  FExtraObject := Value;
end;

{ TatRemoveExtraObject }

procedure TatRemoveExtraObjectAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
    DBStructurer.RemoveExtraObject(ExtraObject);
end;

function TatRemoveExtraObjectAction.GetCategory: TCategoryAction;
begin
   Result := caRemove;
end;

function TatRemoveExtraObjectAction.GetDescription: string;
begin
   Result := Format(txt_RemoveObject,
     [ExtraObject.OwnerCategory.CategoryNameS, ExtraObject.ObjectName]);
end;

procedure TatRemoveExtraObjectAction.SetExtraObject(const Value: TGDAOObject);
begin
  FExtraObject := Value;
end;

{ TatChangeExtraObject }

procedure TatChangeExtraObjectAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveExtraObject(OldExtraObject);
  DBStructurer.CreateExtraObject(ExtraObject, UseAlter);
end;

function TatChangeExtraObjectAction.GetCategory: TCategoryAction;
begin
   Result := caModify;
end;

function TatChangeExtraObjectAction.GetDescription: string;
begin
   Result := Format(txt_ChangeObject,
     [ExtraObject.OwnerCategory.CategoryNameS, ExtraObject.ObjectName]);
end;

procedure TatChangeExtraObjectAction.SetExtraObject(const Value: TGDAOObject);
begin
  FExtraObject := Value;
end;

{ TatRemoveTableConstraintAction }

procedure TatRemoveTableConstraintAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveTableConstraint(Constraint);
end;

function TatRemoveTableConstraintAction.GetCategory: TCategoryAction;
begin
  Result := caRemove;
end;

function TatRemoveTableConstraintAction.GetDescription: string;
begin
  result := Format(txt_RemoveTableConstraint, [Constraint.ConstraintName, Constraint.OwnerTable.TableName]);
end;

procedure TatRemoveTableConstraintAction.SetConstraint(const Value: TGDAOConstraint);
begin
  FConstraint := Value;
end;

{ TatCreateTableConstraintAction }

procedure TatCreateTableConstraintAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateTableConstraint(Constraint);
end;

function TatCreateTableConstraintAction.GetCategory: TCategoryAction;
begin
  Result := caCreate;
end;

function TatCreateTableConstraintAction.GetDescription: string;
begin
  result := format(txt_CreateTableConstraint, [Constraint.ConstraintName, Constraint.OwnerTable.TableName]);
end;

function TatCreateTableConstraintAction.GetDetails: string;
begin
  Result := Format('Expression: %s', [Constraint.Expression]); 
end;

procedure TatCreateTableConstraintAction.SetConstraint(const Value: TGDAOConstraint);
begin
  FConstraint := Value;
end;

{ TatFieldChangeDefaultValueAction }

procedure TatFieldChangeDefaultValueAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.ChangeFieldDefaultValue(Field, OldField);
end;

function TatFieldChangeDefaultValueAction.GetCategory: TCategoryAction;
begin
  Result := caModify;
end;

function TatFieldChangeDefaultValueAction.GetDescription: string;
begin
  Result := Format(txt_FieldDefaultValueChange, [
    Field.OwnerTable.TableName, Field.FieldName,
    Field.DefaultValue, OldField.DefaultValue]);
end;

function TatFieldChangeDefaultValueAction.GetDetails: string;
begin
  Result := Format('Default value changed to "%s"',[Field.DefaultValue]);
end;

procedure TatFieldChangeDefaultValueAction.SetField(const Value: TGDAOField);
begin
  FField := Value;
end;

procedure TatFieldChangeDefaultValueAction.SetOldField(const Value: TGDAOField);
begin
  FOldField := Value;
end;

{ TatChangeTableConstraintAction }

procedure TatChangeTableConstraintAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DbStructurer.RemoveTableConstraint(OldConstraint);
  DbStructurer.CreateTableConstraint(Constraint);
end;

function TatChangeTableConstraintAction.GetCategory: TCategoryAction;
begin
  Result := caModify;
end;

function TatChangeTableConstraintAction.GetDescription: string;
begin
  result := Format(txt_ChangeTableConstraint, [
    Constraint.ConstraintName, Constraint.OwnerTable.TableName,
    Constraint.Expression, OldConstraint.Expression]);
end;

function TatChangeTableConstraintAction.GetDetails: string;
begin
  Result := '';
end;

procedure TatChangeTableConstraintAction.SetConstraint(const Value: TGDAOConstraint);
begin
  FConstraint := Value;
end;

{ TatChangeRelationshipAction }

procedure TatChangeRelationshipAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveRelationship(OldRelationship);
  DBStructurer.CreateRelationship(Relationship);
end;

function TatChangeRelationshipAction.GetCategory: TCategoryAction;
begin
  result := caModify;
end;

function TatChangeRelationshipAction.GetDescription: string;
begin
  result:=Format(txt_ChangeRelationship, [Relationship.RelationshipName, Relationship.ChildTableName, Relationship.ParentTableName]);
end;

function TatChangeRelationshipAction.GetDetails: string;
begin
   result := Format('Relationship %s: %s => %s',
      [ Relationship.RelationshipName,
        Relationship.ChildTableName,
        Relationship.ParentTableName ]);
end;

procedure TatChangeRelationshipAction.SetRelationship(const Value: TGDAORelationship);
begin
  FRelationship := Value;
end;

{ TatChangeTriggerAction }

procedure TatChangeTriggerAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveTrigger(OldTrigger);
  DBStructurer.CreateTrigger(Trigger);
end;

function TatChangeTriggerAction.GetCategory: TCategoryAction;
begin
  result:=caModify;
end;

function TatChangeTriggerAction.GetDescription: string;
begin
  result:=Format(txt_ChangeTrigger,[Trigger.Name,Trigger.OwnerTable.TableName]);
end;

procedure TatChangeTriggerAction.SetTrigger(const Value: TGDAOTrigger);
begin
  FTrigger := Value;
end;

{ TatConstraintFieldAction }

function TatConstraintFieldAction.GetCategory: TCategoryAction;
begin
  result := caCreate;
end;

{ TatCreateConstraintFieldNotNullAction }

procedure TatCreateConstraintFieldNotNullAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateConstraintFieldNotNull(Field);
end;

function TatCreateConstraintFieldNotNullAction.GetDescription: string;
begin
  result:=Format(txt_CreateConstraintFieldNotNullAction, [Field.FieldName, Field.OwnerTable.TableName]);
end;

{ TatCreateConstraintFieldDefaultAction }

procedure TatCreateConstraintFieldDefaultAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateConstraintFieldDefault(Field);
end;

function TatCreateConstraintFieldDefaultAction.GetDescription: string;
begin
  result:=Format(txt_CreateConstraintFieldDefaultAction, [Field.FieldName, Field.OwnerTable.TableName]);
end;

{ TatCreateConstraintFieldCheckAction }

procedure TatCreateConstraintFieldCheckAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateConstraintFieldCheck(Field);
end;

function TatCreateConstraintFieldCheckAction.GetDescription: string;
begin
  result:=Format(txt_CreateConstraintFieldCheckAction, [Field.FieldName, Field.OwnerTable.TableName]);
end;

{ TatRemoveConstraintFieldCheckAction }

procedure TatRemoveConstraintFieldCheckAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveConstraintFieldCheck(Field);
end;

function TatRemoveConstraintFieldCheckAction.GetDescription: string;
begin
  result:=Format(txt_RemoveConstraintFieldCheckAction, [Field.FieldName, Field.OwnerTable.TableName]);
end;

{ TatRemoveConstraintFieldDefaultAction }

procedure TatRemoveConstraintFieldDefaultAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveConstraintFieldDefault(Field);
end;

function TatRemoveConstraintFieldDefaultAction.GetDescription: string;
begin
  result:=Format(txt_RemoveConstraintFieldDefaultAction, [Field.FieldName, Field.OwnerTable.TableName]);
end;

{ TatRemoveConstraintFieldNotNullAction }

procedure TatRemoveConstraintFieldNotNullAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveConstraintFieldNotNull(Field);
end;

function TatRemoveConstraintFieldNotNullAction.GetDescription: string;
begin
  result:=Format(txt_RemoveConstraintFieldNotNullAction, [Field.FieldName, Field.OwnerTable.TableName]);
end;

{ TatChangeIndexAction }

procedure TatChangeIndexAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveIndex(FOldIndex);
  DBStructurer.CreateIndex(FIndex);
end;

function TatChangeIndexAction.GetCategory: TCategoryAction;
begin
  result:=caModify;
end;

function TatChangeIndexAction.GetDescription: string;
begin
  result := Format(txt_ChangeIndex,
    [FIndex.IndexName, FIndex.OwnerTable.TableName]);
end;

procedure TatChangeIndexAction.SetTableIndex(const Value: TGDAOIndex);
begin
  FIndex := Value;
end;

{ TatCreatePrimaryKeyAction }

procedure TatCreatePrimaryKeyAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreatePrimaryKey(Table);
end;

function TatCreatePrimaryKeyAction.GetCategory: TCategoryAction;
begin
  result := caCreate;
end;

function TatCreatePrimaryKeyAction.GetDescription: string;
begin
  result := Format(txt_CreatePrimaryKey, [FTable.TableName]);
end;

procedure TatCreatePrimaryKeyAction.SetTable(const Value: TGDAOTable);
begin
  FTable := Value;
end;

{ TatRemovePrimaryKeyAction }

procedure TatRemovePrimaryKeyAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemovePrimaryKey(Table);
end;

function TatRemovePrimaryKeyAction.GetCategory: TCategoryAction;
begin
  result := caRemove;
end;

function TatRemovePrimaryKeyAction.GetDescription: string;
begin
  result := Format(txt_RemovePrimaryKey, [FTable.TableName]);
end;

procedure TatRemovePrimaryKeyAction.SetTable(const Value: TGDAOTable);
begin
  FTable := Value;
end;

{ TatChangePrimaryKeyAction }

procedure TatChangePrimaryKeyAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemovePrimaryKey(OldTable);
  DBStructurer.CreatePrimaryKey(Table);
end;

function TatChangePrimaryKeyAction.GetCategory: TCategoryAction;
begin
  result := caModify;
end;

function TatChangePrimaryKeyAction.GetDescription: string;
begin
  result := Format(txt_ChangePrimaryKey, [FTable.TableName]);
end;

procedure TatChangePrimaryKeyAction.SetTable(const Value: TGDAOTable);
begin
  FTable := Value;
end;

{ TatChangeDomainAction }

procedure TatChangeDomainAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.ChangeDomain(Domain);
end;

function TatChangeDomainAction.GetCategory: TCategoryAction;
begin
  result := caModify;
end;

function TatChangeDomainAction.GetDescription: string;
begin
  result := Format(txt_ChangeDomain, [Domain.Name]);
end;

procedure TatChangeDomainAction.SetDomain(const Value: TGDAODomain);
begin
  FDomain := Value;
end;

{ TatCreateDomainAction }

procedure TatCreateDomainAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CreateDomain(Domain);
end;

function TatCreateDomainAction.GetCategory: TCategoryAction;
begin
   result := caCreate;
end;

function TatCreateDomainAction.GetDescription: string;
begin
  result := Format(txt_CreateDomain, [Domain.Name]);
end;

procedure TatCreateDomainAction.SetDomain(const Value: TGDAODomain);
begin
  FDomain := Value;
end;

{ TatRemoveDomainAction }

procedure TatRemoveDomainAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.RemoveDomain(Domain);
end;

function TatRemoveDomainAction.GetCategory: TCategoryAction;
begin
  result := caRemove;
end;

function TatRemoveDomainAction.GetDescription: string;
begin
  result := Format(txt_RemoveDomain, [Domain.Name]);
end;

procedure TatRemoveDomainAction.SetDomain(const Value: TGDAODomain);
begin
  FDomain := Value;
end;

{ TatCommentTableAction }

procedure TatCommentTableAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CommentTable(Table);
end;

function TatCommentTableAction.GetDescription: string;
begin
  result := Format('Comment changed on table %s', [Table.TableName]);
end;

{ TatCommentAction }

function TatCommentAction.GetCategory: TCategoryAction;
begin
  result := caModify;
end;

{ TatCommentFieldAction }

procedure TatCommentFieldAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CommentField(Field);
end;

function TatCommentFieldAction.GetDescription: string;
begin
  result := Format('Comment changed on field %s.%s', [Field.OwnerTable.TableName, Field.FieldName]);
end;

{ TatCommentDomainAction }

procedure TatCommentDomainAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CommentDomain(Domain);
end;

function TatCommentDomainAction.GetDescription: string;
begin
  result := Format('Comment changed on domain %s', [Domain.Name]);
end;

{ TatCommentTriggerAction }

procedure TatCommentTriggerAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CommentTrigger(Trigger);
end;

function TatCommentTriggerAction.GetDescription: string;
begin
  result := Format('Comment changed on trigger %s', [Trigger.Name]);
end;

{ TatCommentExtraObjectAction }

procedure TatCommentExtraObjectAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  inherited;
  DBStructurer.CommentExtraObject(ExtraObject);
end;

function TatCommentExtraObjectAction.GetDescription: string;
begin
  result := Format('Comment changed on %s %s', [ExtraObject.OwnerCategory.CategoryNameS, ExtraObject.ObjectName]);
end;

end.

