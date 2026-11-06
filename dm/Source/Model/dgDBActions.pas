unit dgDBActions;

interface

uses
  SysUtils, Classes, DB, Dialogs, Typinfo, Windows, dgDBStructurer, uGDAO, dgConsts;

type
  TApplyRemoveRelationshipEvent = procedure(ARelationship: TGDAORelationship) of object;
  TApplyRemoveTableEvent = procedure(ATable: TGDAOTable) of object;
  TApplyRemoveObjectEvent = procedure(AObject: TGDAOObject) of object;

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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  public
    {Set by the UI while applying actions, so the relationship is removed through the
    project (tree, tabs, diagram lines). When nil the relationship is just freed}
    class var OnApplyRemove: TApplyRemoveRelationshipEvent;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  public
    {Set by the UI while applying actions, so the table is removed through the
    project (tab, tree node, diagram blocks). When nil the table is just freed}
    class var OnApplyRemove: TApplyRemoveTableEvent;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatCreateConstraintFieldDefaultAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatCreateConstraintFieldNotNullAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatRemoveConstraintFieldCheckAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatRemoveConstraintFieldDefaultAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatRemoveConstraintFieldNotNullAction = class(TatConstraintFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  public
    {Set by the UI while applying actions, so the object is removed through the
    project (tab, tree node). When nil the object is just freed}
    class var OnApplyRemove: TApplyRemoveObjectEvent;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
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
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatCommentFieldAction = class(TatCommentAction)
  private
    FField: TGDAOField;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Field: TGDAOField read FField write FField;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  {Resync only: field caption changed. SQL Server imports column comments (MS_Description)
   as field captions. No script: the caption exists only in the model}
  TatCaptionFieldAction = class(TatCommentFieldAction)
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatCommentDomainAction = class(TatCommentAction)
  private
    FDomain: TGDAODomain;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Domain: TGDAODomain read FDomain write FDomain;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatCommentTriggerAction = class(TatCommentAction)
  private
    FTrigger: TGDAOTrigger;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property Trigger: TGDAOTrigger read FTrigger write FTrigger;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

  TatCommentExtraObjectAction = class(TatCommentAction)
  private
    FExtraObject: TGDAOObject;
  protected
    function GetDescription: string; override;
  public
    procedure ExecuteDBAction(DBStructurer: TDBStructurer); override;
    property ExtraObject: TGDAOObject read FExtraObject write FExtraObject;
    procedure ApplyDBAction(ADictionary: TGDAODatabase); override;
  end;

{True when AAction concerns the table (or view-backed table / view) named ATableName:
 the table itself, its fields, primary key, indexes, constraints, triggers, the
 relationships where it is the child table (its foreign keys) and the view of that name}
function ActionRelatesToTable(AAction: TatDBAction; const ATableName: string): boolean;

{True for actions that drop a whole object (table, field, index, relationship, ...)}
function IsRemoveAction(AAction: TatDBAction): boolean;

{The relationship of ADictionary matching ARelationship: same name and same child table.
 Unnamed foreign keys (SQLite) also need the same parent table and child fields}
function MatchRelationship(ADictionary: TGDAODatabase; ARelationship: TGDAORelationship): TGDAORelationship;

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

{ ApplyDBAction helpers

  Actions reference objects of the compared dictionaries: create/change actions
  hold the "new" object (e.g. the temporary dictionary retrieved from the database),
  remove actions hold the "old" one. ApplyDBAction always resolves the target object
  in ADictionary by name, so it works whatever dictionary the action points to. }

function FindDictionaryTable(ADictionary: TGDAODatabase; ATable: TGDAOTable): TGDAOTable;
begin
  if ATable <> nil then
    result := ADictionary.TableByName(ATable.TableName)
  else
    result := nil;
end;

function FindDictionaryField(ADictionary: TGDAODatabase; AField: TGDAOField): TGDAOField;
var
  table: TGDAOTable;
begin
  result := nil;
  if (AField = nil) or (AField.OwnerTable = nil) then
    Exit;
  table := FindDictionaryTable(ADictionary, AField.OwnerTable);
  if table <> nil then
    result := table.Fields.FindbyName(AField.FieldName);
end;

function MatchRelationship(ADictionary: TGDAODatabase; ARelationship: TGDAORelationship): TGDAORelationship;

  function TableNameOf(ATable: TGDAOTable): string;
  begin
    if ATable <> nil then
      Result := ATable.TableName
    else
      Result := '';
  end;

  function ChildFieldNames(ARel: TGDAORelationship): string;
  var
    i: integer;
  begin
    Result := '';
    for i := 0 to ARel.FieldLinks.Count - 1 do
      if ARel.FieldLinks[i].ChildField <> nil then
        Result := Result + LowerCase(ARel.FieldLinks[i].ChildField.FieldName) + ',';
  end;

var
  i: integer;
  rel: TGDAORelationship;
begin
  result := nil;
  if ARelationship = nil then
    Exit;
  for i := 0 to ADictionary.Relationships.Count - 1 do
  begin
    rel := ADictionary.Relationships[i];
    if (CompareText(rel.RelationshipName, ARelationship.RelationshipName) <> 0)
      or (CompareText(TableNameOf(rel.ChildTable), TableNameOf(ARelationship.ChildTable)) <> 0) then
      Continue;
    // unnamed foreign keys (SQLite): also the parent table and the linked child fields
    if (ARelationship.RelationshipName = '')
      and ((CompareText(TableNameOf(rel.ParentTable), TableNameOf(ARelationship.ParentTable)) <> 0)
        or (ChildFieldNames(rel) <> ChildFieldNames(ARelationship))) then
      Continue;
    Exit(rel);
  end;
end;

function FindDictionaryRelationship(ADictionary: TGDAODatabase; ARelationship: TGDAORelationship): TGDAORelationship;
begin
  // name + child table: PostgreSQL allows the same foreign key name on different tables
  result := MatchRelationship(ADictionary, ARelationship);
end;

{ In the database a foreign key column exists independently of the foreign key.
  Before relationship links are removed, make sure the model keeps the child
  fields (not "generated by relationship") and their primary key membership }
procedure DetachRelationshipFields(ARelationship: TGDAORelationship);
var
  i: integer;
  child: TGDAOField;
  ifield: TGDAOIField;
begin
  for i := 0 to ARelationship.FieldLinks.Count - 1 do
  begin
    if ARelationship.FieldLinks[i].ParentField <> nil then
      ARelationship.FieldLinks[i].ParentField.GeneratedByRelationship := false;
    child := ARelationship.FieldLinks[i].ChildField;
    if child <> nil then
    begin
      child.GeneratedByRelationship := false;
      if child.OwnerTable <> nil then
      begin
        ifield := child.OwnerTable.PrimaryKeyIndex.IFields.FindByField(child);
        if ifield <> nil then
          ifield.KeyByRelationship := false;
      end;
    end;
  end;
end;

{ Changing the fields of an index used as relationship parent key deletes the
  relationship links (removed field) or auto-creates child fields (added field).
  Detach those relationships first; UpdateParentIndex re-links them afterwards }
procedure DetachIndexRelationships(ADictionary: TGDAODatabase; AIndex: TGDAOIndex);
var
  i: integer;
begin
  for i := 0 to ADictionary.Relationships.Count - 1 do
    if ADictionary.Relationships[i].ParentIndex = AIndex then
    begin
      DetachRelationshipFields(ADictionary.Relationships[i]);
      ADictionary.Relationships[i].ParentIndex := nil;
    end;
end;

{ Makes the fields of ATarget (index of ATable) equal to those of ASource, matched by
  field name, keeping the existing index field items. ASource = nil removes all fields }
procedure SyncIndexFields(ADictionary: TGDAODatabase; ATarget, ASource: TGDAOIndex; ATable: TGDAOTable);
var
  i, j, position: integer;
  field: TGDAOField;
  ifield: TGDAOIField;
begin
  DetachIndexRelationships(ADictionary, ATarget);

  for i := ATarget.IFields.Count - 1 downto 0 do
    if (ASource = nil) or (ASource.IFields.IndexOf(ATarget.IFields[i].FieldName) < 0) then
      ATarget.IFields[i].Free;

  if ASource <> nil then
  begin
    position := 0;
    for i := 0 to ASource.IFields.Count - 1 do
    begin
      field := ATable.Fields.FindbyName(ASource.IFields[i].FieldName);
      if field = nil then
        Continue;
      j := ATarget.IFields.IndexOf(field.FieldName);
      if j < 0 then
        ifield := ATarget.IFields.Add(field, ASource.IFields[i].FieldOrder)
      else
      begin
        ifield := ATarget.IFields[j];
        ifield.FieldOrder := ASource.IFields[i].FieldOrder;
      end;
      ifield.Index := position;
      Inc(position);
    end;
  end;

  ADictionary.Relationships.UpdateParentIndex;
end;

procedure AddRelationshipLinks(ATarget, ASource: TGDAORelationship);
var
  i: integer;
begin
  for i := 0 to ASource.FieldLinks.Count - 1 do
    with ATarget.FieldLinks.Add do
    begin
      ParentFieldName := ASource.FieldLinks[i].ParentFieldName;
      ChildFieldName := ASource.FieldLinks[i].ChildFieldName;
    end;
end;

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
var
  i: integer;
begin
  inherited;
  with ADictionary.AddTable(Table.TableName) do
  begin
    Assign(Self.Table);
    UpdateID;
    // Assign copied the FIDs of the source dictionary, which may collide with FIDs
    // already used in ADictionary. Give every field a fresh FID from ADictionary counters.
    for i := 0 to Fields.Count - 1 do
      Fields[i].UpdateId;
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

{ ApplyDBAction - field actions
  Changes are applied in place: the dictionary field keeps its FID (and its table its TID) }

procedure TatCreateFieldAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Field.OwnerTable);
  if (table = nil) or (table.Fields.FindbyName(Field.FieldName) <> nil) then
    Exit;
  with table.Fields.Add do
  begin
    Assign(Self.Field);
    UpdateId; // Assign copied the source FID
  end;
end;

procedure TatRemoveFieldAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  // TGDAOField.Destroy removes the field from indexes, primary key and relationships
  if field <> nil then
    field.Free;
end;

procedure TatFieldRequiredAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
  begin
    field.Required := Self.Field.Required;
    field.RequiredSpecific := Self.Field.RequiredSpecific;
  end;
end;

procedure TatFieldChangeSizeAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
  begin
    field.Size := Self.Field.Size;
    field.Size2 := Self.Field.Size2;
  end;
end;

procedure TatFieldChangeTypeAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
  begin
    // same order as TGDAOField.Assign: data type first, domain last
    field.DataTypeName := Self.Field.DataTypeName;
    field.Size := Self.Field.Size;
    field.Size2 := Self.Field.Size2;
    field.Expression := Self.Field.Expression;
    field.SeedValue := Self.Field.SeedValue;
    field.IncrementValue := Self.Field.IncrementValue;
    field.DomainName := Self.Field.DomainName;
  end;
end;

procedure TatFieldChangeDefaultValueAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
  begin
    field.DefaultValue := Self.Field.DefaultValue;
    field.DefaultValueSpecific := Self.Field.DefaultValueSpecific;
    field.ConstraintDefaultName := Self.Field.ConstraintDefaultName;
  end;
end;

procedure TatCreateConstraintFieldCheckAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
  begin
    field.ConstraintName := Self.Field.ConstraintName;
    field.ConstraintExpr := Self.Field.ConstraintExpr;
    field.ConstraintExprSpecific := Self.Field.ConstraintExprSpecific;
  end;
end;

procedure TatRemoveConstraintFieldCheckAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
  begin
    field.ConstraintName := '';
    field.ConstraintExpr := '';
  end;
end;

procedure TatCreateConstraintFieldDefaultAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
    field.ConstraintDefaultName := Self.Field.ConstraintDefaultName;
end;

procedure TatRemoveConstraintFieldDefaultAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
    field.ConstraintDefaultName := '';
end;

procedure TatCreateConstraintFieldNotNullAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
    field.ConstraintNotNullName := Self.Field.ConstraintNotNullName;
end;

procedure TatRemoveConstraintFieldNotNullAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
    field.ConstraintNotNullName := '';
end;

procedure TatCommentFieldAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  inherited;
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
    field.Description := Self.Field.Description;
end;

{ TatCaptionFieldAction }

function TatCaptionFieldAction.GetDescription: string;
begin
  result := Format('Caption changed on field %s.%s', [Field.OwnerTable.TableName, Field.FieldName]);
end;

procedure TatCaptionFieldAction.ExecuteDBAction(DBStructurer: TDBStructurer);
begin
  // no inherited: the caption has no SQL script
end;

procedure TatCaptionFieldAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  field: TGDAOField;
begin
  // no inherited: it would copy the description
  field := FindDictionaryField(ADictionary, Self.Field);
  if field <> nil then
    field.FieldCaption := Self.Field.FieldCaption;
end;

{ ApplyDBAction - table level actions: primary key, indexes, constraints, triggers, comments }

procedure TatCreatePrimaryKeyAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Table);
  if table <> nil then
  begin
    SyncIndexFields(ADictionary, table.PrimaryKeyIndex, Self.Table.PrimaryKeyIndex, table);
    table.PrimaryKeyIndex.IndexName := Self.Table.PrimaryKeyIndex.IndexName;
  end;
end;

procedure TatChangePrimaryKeyAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Table);
  if table <> nil then
  begin
    SyncIndexFields(ADictionary, table.PrimaryKeyIndex, Self.Table.PrimaryKeyIndex, table);
    table.PrimaryKeyIndex.IndexName := Self.Table.PrimaryKeyIndex.IndexName;
  end;
end;

procedure TatRemovePrimaryKeyAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Table);
  if table <> nil then
    SyncIndexFields(ADictionary, table.PrimaryKeyIndex, nil, table);
end;

procedure TatCreateIndexAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  index: TGDAOIndex;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Index.OwnerTable);
  if (table = nil) or (table.Indexes.FindByName(Self.Index.IndexName) <> nil) then
    Exit;
  index := table.AddIndex(Self.Index.IndexName, Self.Index.IndexType);
  index.IndexOrder := Self.Index.IndexOrder;
  SyncIndexFields(ADictionary, index, Self.Index, table);
end;

procedure TatChangeIndexAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  index: TGDAOIndex;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self._Index.OwnerTable);
  if table = nil then
    Exit;
  index := table.Indexes.FindByName(Self._Index.IndexName);
  if index <> nil then
  begin
    index.IndexType := Self._Index.IndexType;
    index.IndexOrder := Self._Index.IndexOrder;
    SyncIndexFields(ADictionary, index, Self._Index, table);
  end;
end;

procedure TatRemoveIndexAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  index: TGDAOIndex;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Index.OwnerTable);
  if table = nil then
    Exit;
  index := table.Indexes.FindByName(Self.Index.IndexName);
  if index <> nil then
  begin
    DetachIndexRelationships(ADictionary, index);
    index.Free;
    ADictionary.Relationships.UpdateParentIndex;
  end;
end;

procedure TatCreateTableConstraintAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Constraint.OwnerTable);
  if (table <> nil) and (table.Constraints.FindByName(Self.Constraint.ConstraintName) = nil) then
    table.Constraints.AddConstraint(Self.Constraint.ConstraintName, Self.Constraint.Expression);
end;

procedure TatChangeTableConstraintAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  constraint: TGDAOConstraint;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Constraint.OwnerTable);
  if table = nil then
    Exit;
  constraint := table.Constraints.FindByName(Self.Constraint.ConstraintName);
  if constraint <> nil then
    constraint.Expression := Self.Constraint.Expression;
end;

procedure TatRemoveTableConstraintAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  constraint: TGDAOConstraint;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Constraint.OwnerTable);
  if table = nil then
    Exit;
  constraint := table.Constraints.FindByName(Self.Constraint.ConstraintName);
  if constraint <> nil then
    constraint.Free;
end;

procedure TatCreateTriggerAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Trigger.OwnerTable);
  if (table <> nil) and (table.TriggerByName(Self.Trigger.Name) = nil) then
    table.Triggers.Add.Assign(Self.Trigger);
end;

procedure TatChangeTriggerAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  trigger: TGDAOTrigger;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Trigger.OwnerTable);
  if table = nil then
    Exit;
  trigger := table.TriggerByName(Self.Trigger.Name);
  if trigger <> nil then
    trigger.ImplementationCode := Self.Trigger.ImplementationCode;
end;

procedure TatRemoveTriggerAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  trigger: TGDAOTrigger;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Trigger.OwnerTable);
  if table = nil then
    Exit;
  trigger := table.TriggerByName(Self.Trigger.Name);
  if trigger <> nil then
    trigger.Free;
end;

procedure TatCommentTableAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Table);
  if table <> nil then
    table.Description := Self.Table.Description;
end;

procedure TatCommentTriggerAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
  trigger: TGDAOTrigger;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Trigger.OwnerTable);
  if table = nil then
    Exit;
  trigger := table.TriggerByName(Self.Trigger.Name);
  if trigger <> nil then
    trigger.Description := Self.Trigger.Description;
end;

{ ApplyDBAction - relationships }

procedure TatCreateRelationshipAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  relationship: TGDAORelationship;
begin
  inherited;
  if (FindDictionaryRelationship(ADictionary, Self.Relationship) <> nil)
    or (ADictionary.TableByName(Self.Relationship.ParentTableName) = nil)
    or (ADictionary.TableByName(Self.Relationship.ChildTableName) = nil) then
    Exit;
  relationship := ADictionary.Relationships.Add(Self.Relationship.RelationshipName,
    Self.Relationship.ParentTableName, Self.Relationship.ChildTableName,
    Self.Relationship.UpdateMethod, Self.Relationship.DeleteMethod);
  relationship.Description := Self.Relationship.Description;
  AddRelationshipLinks(relationship, Self.Relationship);
  ADictionary.Relationships.UpdateParentIndex;
end;

procedure TatChangeRelationshipAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  relationship: TGDAORelationship;
begin
  inherited;
  relationship := FindDictionaryRelationship(ADictionary, Self.Relationship);
  if (relationship = nil)
    or (ADictionary.TableByName(Self.Relationship.ParentTableName) = nil)
    or (ADictionary.TableByName(Self.Relationship.ChildTableName) = nil) then
    Exit;
  DetachRelationshipFields(relationship);
  relationship.FieldLinks.Clear;
  relationship.ParentTableName := Self.Relationship.ParentTableName;
  relationship.ChildTableName := Self.Relationship.ChildTableName;
  relationship.UpdateMethod := Self.Relationship.UpdateMethod;
  relationship.DeleteMethod := Self.Relationship.DeleteMethod;
  AddRelationshipLinks(relationship, Self.Relationship);
  ADictionary.Relationships.UpdateParentIndex;
end;

procedure TatRemoveRelationshipAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  relationship: TGDAORelationship;
begin
  inherited;
  relationship := FindDictionaryRelationship(ADictionary, Self.Relationship);
  if relationship = nil then
    Exit;
  DetachRelationshipFields(relationship);
  if Assigned(OnApplyRemove) then
    OnApplyRemove(relationship)
  else
    relationship.Free;
end;

{ ApplyDBAction - tables }

{ Removes ATable from ADictionary. Its relationships are removed with it (TGDAOTable
  destructor); detach them first so foreign key fields of the other tables are kept }
procedure RemoveDictionaryTable(ADictionary: TGDAODatabase; ATable: TGDAOTable);
var
  i: integer;
begin
  for i := 0 to ADictionary.Relationships.Count - 1 do
    if (ADictionary.Relationships[i].ParentTable = ATable)
      or (ADictionary.Relationships[i].ChildTable = ATable) then
      DetachRelationshipFields(ADictionary.Relationships[i]);
  if Assigned(TatRemoveTableAction.OnApplyRemove) then
    TatRemoveTableAction.OnApplyRemove(ATable)
  else
    ATable.Free;
end;

procedure TatRemoveTableAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  table: TGDAOTable;
begin
  inherited;
  table := FindDictionaryTable(ADictionary, Self.Table);
  if table <> nil then
    RemoveDictionaryTable(ADictionary, table);
end;

{ ApplyDBAction - domains }

procedure TatCreateDomainAction.ApplyDBAction(ADictionary: TGDAODatabase);
begin
  inherited;
  if ADictionary.Domains.FindByName(Self.Domain.Name) = nil then
    ADictionary.Domains.Add.Assign(Self.Domain);
end;

procedure TatChangeDomainAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  domain: TGDAODomain;
begin
  inherited;
  domain := ADictionary.Domains.FindByName(Self.Domain.Name);
  if domain <> nil then
  begin
    // only what CompareDomains compares, in TGDAODomain.Assign order: not Assign, which
    // would also copy the description (not read by every retriever) and InDatabase
    domain.ConstraintExpr := Self.Domain.ConstraintExpr;
    domain.DataTypeName := Self.Domain.DataTypeName;
    domain.Size := Self.Domain.Size;
    domain.Size2 := Self.Domain.Size2;
    domain.DefaultValue := Self.Domain.DefaultValue;
    domain.SeedValue := Self.Domain.SeedValue;
    domain.IncrementValue := Self.Domain.IncrementValue;
    domain.Required := Self.Domain.Required;
  end;
end;

procedure TatRemoveDomainAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  domain: TGDAODomain;
begin
  inherited;
  domain := ADictionary.Domains.FindByName(Self.Domain.Name);
  // TGDAODomain.Destroy clears the domain from the fields using it
  if domain <> nil then
    domain.Free;
end;

procedure TatCommentDomainAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  domain: TGDAODomain;
begin
  inherited;
  domain := ADictionary.Domains.FindByName(Self.Domain.Name);
  if domain <> nil then
    domain.Information := Self.Domain.Information;
end;

{ ApplyDBAction - extra objects (views, procedures, sequences, functions) }

function FindDictionaryObject(ADictionary: TGDAODatabase; AObject: TGDAOObject): TGDAOObject;
var
  category: TGDAOCategory;
begin
  result := nil;
  if (AObject = nil) or (AObject.OwnerCategory = nil) then
    Exit;
  category := ADictionary.Categories.FindByType(AObject.OwnerCategory.CategoryType);
  if category <> nil then
    result := category.Objects.FindByName(AObject.ObjectName);
end;

procedure TatCreateExtraObjectAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  category: TGDAOCategory;
begin
  inherited;
  if (ExtraObject.OwnerCategory = nil) or (FindDictionaryObject(ADictionary, ExtraObject) <> nil) then
    Exit;
  category := ADictionary.Categories.FindByType(ExtraObject.OwnerCategory.CategoryType);
  if category <> nil then
    category.Objects.Add(ExtraObject.ObjectName).Assign(ExtraObject);
end;

procedure TatChangeExtraObjectAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  extraObject: TGDAOObject;
begin
  inherited;
  extraObject := FindDictionaryObject(ADictionary, Self.ExtraObject);
  if extraObject <> nil then
  begin
    extraObject.CreateImplementation := Self.ExtraObject.CreateImplementation;
    extraObject.DropImplementation := Self.ExtraObject.DropImplementation;
    // as in the comparison: most retrievers do not read the properties (e.g. sequence
    // seed), an empty database side must not wipe those of the model
    if Trim(Self.ExtraObject.CustomProps.Text) <> '' then
      extraObject.CustomProps := Self.ExtraObject.CustomProps;
  end;
end;

procedure TatRemoveExtraObjectAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  extraObject: TGDAOObject;
begin
  inherited;
  extraObject := FindDictionaryObject(ADictionary, Self.ExtraObject);
  if extraObject = nil then
    Exit;
  if Assigned(OnApplyRemove) then
    OnApplyRemove(extraObject)
  else
    extraObject.Free;
end;

{ Action scope helpers }

function ActionRelatesToTable(AAction: TatDBAction; const ATableName: string): boolean;

  function IsTable(ATable: TGDAOTable): boolean;
  begin
    result := (ATable <> nil) and SameText(ATable.TableName, ATableName);
  end;

  function IsFieldOf(AField: TGDAOField): boolean;
  begin
    result := (AField <> nil) and IsTable(AField.OwnerTable);
  end;

  function IsView(AObject: TGDAOObject): boolean;
  begin
    result := (AObject <> nil) and (AObject.OwnerCategory <> nil)
      and (AObject.OwnerCategory.CategoryType = ctView)
      and SameText(AObject.ObjectName, ATableName);
  end;

begin
  // table
  if AAction is TatCreateTableAction then result := IsTable(TatCreateTableAction(AAction).Table)
  else if AAction is TatRemoveTableAction then result := IsTable(TatRemoveTableAction(AAction).Table)
  else if AAction is TatRenameTableAction then result := IsTable(TatRenameTableAction(AAction).Table)
  else if AAction is TatCommentTableAction then result := IsTable(TatCommentTableAction(AAction).Table)
  // fields
  else if AAction is TatCreateFieldAction then result := IsFieldOf(TatCreateFieldAction(AAction).Field)
  else if AAction is TatRemoveFieldAction then result := IsFieldOf(TatRemoveFieldAction(AAction).Field)
  else if AAction is TatRenameFieldAction then result := IsFieldOf(TatRenameFieldAction(AAction).Field)
  else if AAction is TatFieldRequiredAction then result := IsFieldOf(TatFieldRequiredAction(AAction).Field)
  else if AAction is TatFieldChangeSizeAction then result := IsFieldOf(TatFieldChangeSizeAction(AAction).Field)
  else if AAction is TatFieldChangeTypeAction then result := IsFieldOf(TatFieldChangeTypeAction(AAction).Field)
  else if AAction is TatFieldChangeDefaultValueAction then result := IsFieldOf(TatFieldChangeDefaultValueAction(AAction).Field)
  else if AAction is TatConstraintFieldAction then result := IsFieldOf(TatConstraintFieldAction(AAction).Field)
  else if AAction is TatCommentFieldAction then result := IsFieldOf(TatCommentFieldAction(AAction).Field)
  // primary key, indexes, constraints, triggers
  else if AAction is TatCreatePrimaryKeyAction then result := IsTable(TatCreatePrimaryKeyAction(AAction).Table)
  else if AAction is TatRemovePrimaryKeyAction then result := IsTable(TatRemovePrimaryKeyAction(AAction).Table)
  else if AAction is TatChangePrimaryKeyAction then result := IsTable(TatChangePrimaryKeyAction(AAction).Table)
  else if AAction is TatCreateIndexAction then result := IsTable(TatCreateIndexAction(AAction).Index.OwnerTable)
  else if AAction is TatRemoveIndexAction then result := IsTable(TatRemoveIndexAction(AAction).Index.OwnerTable)
  else if AAction is TatChangeIndexAction then result := IsTable(TatChangeIndexAction(AAction)._Index.OwnerTable)
  else if AAction is TatCreateTableConstraintAction then result := IsTable(TatCreateTableConstraintAction(AAction).Constraint.OwnerTable)
  else if AAction is TatRemoveTableConstraintAction then result := IsTable(TatRemoveTableConstraintAction(AAction).Constraint.OwnerTable)
  else if AAction is TatChangeTableConstraintAction then result := IsTable(TatChangeTableConstraintAction(AAction).Constraint.OwnerTable)
  else if AAction is TatCreateTriggerAction then result := IsTable(TatCreateTriggerAction(AAction).Trigger.OwnerTable)
  else if AAction is TatRemoveTriggerAction then result := IsTable(TatRemoveTriggerAction(AAction).Trigger.OwnerTable)
  else if AAction is TatChangeTriggerAction then result := IsTable(TatChangeTriggerAction(AAction).Trigger.OwnerTable)
  else if AAction is TatCommentTriggerAction then result := IsTable(TatCommentTriggerAction(AAction).Trigger.OwnerTable)
  // foreign keys of the table
  else if AAction is TatCreateRelationshipAction then result := SameText(TatCreateRelationshipAction(AAction).Relationship.ChildTableName, ATableName)
  else if AAction is TatRemoveRelationshipAction then result := SameText(TatRemoveRelationshipAction(AAction).Relationship.ChildTableName, ATableName)
  else if AAction is TatChangeRelationshipAction then result := SameText(TatChangeRelationshipAction(AAction).Relationship.ChildTableName, ATableName)
  // view
  else if AAction is TatCreateExtraObjectAction then result := IsView(TatCreateExtraObjectAction(AAction).ExtraObject)
  else if AAction is TatRemoveExtraObjectAction then result := IsView(TatRemoveExtraObjectAction(AAction).ExtraObject)
  else if AAction is TatChangeExtraObjectAction then result := IsView(TatChangeExtraObjectAction(AAction).ExtraObject)
  else if AAction is TatCommentExtraObjectAction then result := IsView(TatCommentExtraObjectAction(AAction).ExtraObject)
  else
    result := false;
end;

function IsRemoveAction(AAction: TatDBAction): boolean;
begin
  result := (AAction is TatRemoveTableAction) or (AAction is TatRemoveFieldAction)
    or (AAction is TatRemovePrimaryKeyAction) or (AAction is TatRemoveIndexAction)
    or (AAction is TatRemoveTableConstraintAction) or (AAction is TatRemoveTriggerAction)
    or (AAction is TatRemoveRelationshipAction) or (AAction is TatRemoveExtraObjectAction)
    or (AAction is TatRemoveDomainAction);
end;

procedure TatCommentExtraObjectAction.ApplyDBAction(ADictionary: TGDAODatabase);
var
  extraObject: TGDAOObject;
begin
  inherited;
  extraObject := FindDictionaryObject(ADictionary, Self.ExtraObject);
  if extraObject <> nil then
    extraObject.Description := Self.ExtraObject.Description;
end;

end.

