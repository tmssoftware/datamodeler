unit uGDAO;

{ GDAO is an acronym for Generic Data Access Objects }

interface

uses
  Generics.Collections, SysUtils, Classes, Variants, Contnrs,
  LangConst, dgConsts, dgDBTypes;

const
  SProp_SequenceSeed = 'SequenceSeed';

type
  ERecursiveRelException = class(Exception);

  TGDD                        = class;
  TGDAOTable                  = class;
  TGDAOTables                 = class;
  TGDAOFields                 = class;
  TGDAOField                  = class;
  TGDAOIndexes                = class;
  TGDAOIndex                  = class;
  TGDAOIFields                = class;
  TGDAOIField                 = class;
  TGDAORelationship           = class;
  TGDAORelationships          = class;
  TGDAOConstraints            = class;
  TGDAOConstraint             = class;
  TGDAOTriggers               = class;
  TGDAOTrigger                = class;
  TGDAORelationshipFieldLinks = class;
  TGDAORelationshipFieldLink  = class;
  TGDAODataTypes              = class;
  TGDAODataType               = class;
  TGDAODomains                = class;
  TGDAODomain                 = class;
  TGDAOCategories             = class;
  TGDAOCategory               = class;
  TGDAOObjects                = class;
  TGDAOObject                 = class;

  TGDD = class(TPersistent)
  private
    FOwner             : TPersistent;
    FTables            : TGDAOTables;
    FRelationships     : TGDAORelationships;
    FDomains           : TGDAODomains;
    FCategories        : TGDAOCategories;
    FDatabaseType      : TDatabaseType;
    FNextTableID       : integer;
    FNextFieldID       : integer;
    FNextIndexID       : integer;
    FNextConstraintID  : integer;
    FNextRelationshipID: integer;
    FOnTableDestroy: TNotifyEvent;
    FOnFieldNameChanged: TNotifyEvent;
    procedure SetRelationships(const Value: TGDAORelationships);
    procedure SetCategories(const Value: TGDAOCategories);
    procedure SetTables(const Value: TGDAOTables);
    procedure SetDataTypes(const Value: TGDAODataTypes);
    procedure SetDomains(const Value: TGDAODomains);
    function GetNextIndexID: integer;
    function GetNextConstraintID: integer;
    function GetNextRelationshipID: integer;
    function GetNextTableID: integer;
    function GetNextFieldID: integer;
    function GetDatabaseTypeID: string;
    procedure SetDatabaseTypeID(const Value: string);
    function FindPrimaryKeyByName(AName: string): TGDAOIndex;
    function GetNewPrimaryKeyName: string;
    function GetDataTypes: TGDAODataTypes;
  protected
    procedure FieldDestroyed(AField: TGDAOField);
    procedure FieldNameChanged(AField: TGDAOField);
    procedure TableDestroyed(ATable: TGDAOTable);
  public
    constructor Create(AOwner:TPersistent = nil);
    destructor Destroy; override;
    procedure RecreateIds;
    procedure Loaded;
    function GetOwner: TPersistent; override;
    procedure Assign(Source: TPersistent); override; 
    function IndexOfTable( ATableName:string ):integer;
    function TableByName(ATableName:string):TGDAOTable;
    function RelationshipByName(ARelationshipName: string): TGDAORelationship; overload;
    function RelationshipByName(ARelationshipName, ATableName: string): TGDAORelationship; overload;
    function IndexExists(AIndexName: string): boolean;
    function AddTable(ATableName: string): TGDAOTable;
    function DuplicateTable(ATable: TGDAOTable; ANewName: string): TGDAOTable;

    property DatabaseType: TDatabaseType read FDatabaseType write FDatabaseType;

    {Events for notification of dictionary changes. Used mostly in user interface}
    property OnTableDestroy: TNotifyEvent read FOnTableDestroy write FOnTableDestroy;
    property OnFieldNameChanged: TNotifyEvent read FOnFieldNameChanged write FOnFieldNameChanged;
  published
    {DatabaseTypeID identified the target database. It must be the VERY FIRST property
     of the list, because several other properties (datatypes, categories) depend on
     this property to work}
    property DatabaseTypeID: string read GetDatabaseTypeID write SetDatabaseTypeID;
    property NextTableID: integer read FNextTableID write FNextTableID;
    property NextFieldID: integer read FNextFieldID write FNextFieldID;
    property NextConstraintID: integer read FNextConstraintID write FNextConstraintID;
    property NextIndexID: integer read FNextIndexID write FNextIndexID;
    property NextRelationshipID: integer read FNextRelationshipID write FNextRelationshipID;

    property DataTypes: TGDAODataTypes read GetDataTypes write SetDataTypes stored false;

    property Domains: TGDAODomains read FDomains write SetDomains;
    property Tables: TGDAOTables read FTables write SetTables;
    property Relationships: TGDAORelationships read FRelationships write SetRelationships;
    property Categories: TGDAOCategories read FCategories write SetCategories;
  end;

  TGDAODatabase = class(TGDD);

  { TGDAOContainer - used to save the instance to a binary file }
  TGDAOContainer = class(TComponent)
  private
    FDataDictionary : TGDAODatabase;
    procedure SetDataDictionary(const Value: TGDAODatabase);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
  published
    property DataDictionary: TGDAODatabase read FDataDictionary write SetDataDictionary;
  end;

  TGDAOTables = class(TCollection)
  private
    FOwnerDatabase: TGDD;
    function GetItem(i:integer):TGDAOTable;
    procedure SetItem(i: integer; const Value: TGDAOTable);
  public
    constructor Create( AOwnerDatabase:TGDD );
    function GetOwner: TPersistent; override;
    function Add: TGDAOTable; overload;
    function Add(ATableName: string): TGDAOTable; overload;
    function IndexOf(ATableName: string): integer;
    function IndexOfTid(ATID: integer): integer;
    function FindByName(ATableName: string): TGDAOTable;
    function FindByID(ATID: integer): TGDAOTable;
    function GetNewTableName: String;
    property OwnerDatabase:TGDD read FOwnerDatabase;
    property Items[i:integer]:TGDAOTable read GetItem write SetItem; default;
  end;

  TGDAOTable = class(TCollectionItem)
  private
    FTableName: string;
    FDescription: string;
    FTID: integer;
    FOidIndex: integer;
    FExclusiveRecordMask: string;
    FFields: TGDAOFields;
    FIndexes: TGDAOIndexes;
    FConstraints: TGDAOConstraints;
    FTriggers: TGDAOTriggers;
    FData: TObject;
    FPrimaryKeyIndex: TGDAOIndex;
    FTableCaption: string;
    FRestriction: TTableRestriction;
    FIsView: Boolean;
    procedure SetFields(const Value: TGDAOFields);
    procedure SetIndexes(const Value: TGDAOIndexes);
    procedure SetConstraints(const Value: TGDAOConstraints);
    procedure SetTriggers(const Value: TGDAOTriggers);
    procedure FieldDestroyed(AField: TGDAOField);
    function GetPrimaryKeyIndex: TGDAOIndex;
    procedure UpdatePrimaryKeyName;
    procedure SetPrimaryKeyIndex(const Value: TGDAOIndex);
    function GetTableCaption: string;
    procedure SetTableCaption(const Value: string);
    function StoreTableCaption: Boolean;
    function GetReadOnly: boolean;
    procedure SetReadOnly(const Value: boolean);
    function GetVisible: boolean;
    procedure SetVisible(const Value: boolean);
    function GetRestriction: TTableRestriction;
  public
    constructor Create( ACollection:TCollection ); override;
    procedure BeforeDestruction; override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
    procedure Assign(Source: TPersistent); override;
    function FieldByName(AFieldName:string):TGDAOField;
    function AddIndex( AIndexName: string; AIndexType: TIndexType): TGDAOIndex;
    procedure UpdateID;
    function OwnerDatabase:TGDD;
    function HasForeignFields: boolean;
    function HasPrimaryKey: boolean;

    // Indicates that the table contains a data type that automatically declares the table primary key
    function HasPrimaryKeyDataType: boolean;
    function TriggerByName(ATriggerName: string): TGDAOTrigger;
    property Data: TObject read FData write FData;
    property ReadOnly: boolean read GetReadOnly write SetReadOnly;
    property Visible: boolean read GetVisible write SetVisible;
    property IsView: Boolean read FIsView write FIsView;
  published
    property TableName: string read FTableName write FTableName;
    property Description: string read FDescription write FDescription;
    property TID: integer read FTID write FTID;
    property OidIndex: integer read FOidIndex write FOidIndex;
    property ExclusiveRecordMask: string read FExclusiveRecordMask write FExclusiveRecordMask;
    property Fields: TGDAOFields read FFields write SetFields;
    property Indexes:TGDAOIndexes read FIndexes write SetIndexes;
    property Constraints:TGDAOConstraints read FConstraints write SetConstraints;
    property Triggers: TGDAOTriggers read FTriggers write SetTriggers;
    property PrimaryKeyIndex: TGDAOIndex read GetPrimaryKeyIndex write SetPrimaryKeyIndex;
    property TableCaption: string read GetTableCaption write SetTableCaption stored StoreTableCaption;
    property Restriction: TTableRestriction read GetRestriction write FRestriction default trNone;
  end;

  TGDAOFields = class(TCollection)
  private
    FOwnerTable : TGDAOTable;
    function GetItem(i:integer):TGDAOField;
    procedure SetItem(i: integer; const Value: TGDAOField);
  public
    constructor Create( AOwnerTable:TGDAOTable );
    function GetOwner: TPersistent; override;
    function Add: TGDAOField; overload;
    function Add(AFieldName: string; ADataType:TGDAODataType;
      ASize, ASize2: integer; ARequired: boolean ):TGDAOField; overload;
    function IndexOf(AFieldName:string):integer;
    function IndexOfFid(AFID: integer): integer;
    function FindbyName(AFieldName: String): TGDAOField;
    function FindByID(AFID: integer): TGDAOField;
    function ValidItem(AItem:TGDAOField):boolean;
    function GetNewFieldName(ABaseName: string = ''): String;
    property OwnerTable:TGDAOTable read FOwnerTable;
    property Items[i:integer]:TGDAOField read GetItem write SetItem; default;
  end;

  TRelationshipList = class(TList)
  private
    function GetItem(i: integer): TGDAORelationship;
  public
    property Item[i: integer]: TGDAORelationship read GetItem; default;
  end;

  TGDAOField = class(TCollectionItem)
  private
    FFieldName: string;
    FSize: integer;
    FSize2: integer;
    FRequired: boolean;
    FDescription: string;
    FDefaultValue: string;
    FFID: integer;
    FConstraintExpr: string;
    FConstraintName: string;
    FDefaultValueSpecific: boolean;
    FConstraintExprSpecific : boolean;
    FRequiredSpecific: boolean;
    FSeedValue: integer;
    FIncrementValue: integer;
    FGeneratedByRelationship: boolean;
    FDomainName: string;
    FConstraintDefaultName: string;
    FConstraintNotNullName: string;
    FDataType: TGDAODataType;
    FDomain: TGDAODomain;
    FData: TObject;
    FExpression: string;
    FFieldCaption: string;
    FRestriction: TFieldRestriction;
    function GetDataType: TGDAODataType;
    procedure SetFieldName(const AName: string);
    function GetConstraintExpr: string;
    function GetDataTypeName: string;
    function GetDefaultValue: string;
    function GetDomainName: string;
    function GetIncrementValue: integer;
    function GetSeedValue: integer;
    function GetSize: integer;
    function GetSize2: integer;
    procedure SetDataTypeName(const Value: string);
    procedure SetDefaultValue(const Value: string);
    procedure SetDomainName(const AValue: string);
    procedure SetInPrimaryKey(const AValue: boolean);
    procedure SetDataType(const Value: TGDAODataType);
    function GetInPrimaryKey: boolean;
    procedure SetDomain(const Value: TGDAODomain);
    function GetFieldCaption: string;
    procedure SetFieldCaption(const Value: string);
    function StoreFieldCaption: boolean;
    function GetRestriction: TFieldRestriction;
    function GetRequired: boolean;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure UpdateId;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
    function OwnerDatabase: TGDD;
    function OwnerTable: TGDAOTable;
    function IsDefaultValueEnabled: boolean;
    function IsConstraintExprEnabled: boolean;
    function IsRequiredEnabled: boolean;

    function IsForeignKey(AParents: TRelationshipList=nil): boolean;
    function IsRelationshipParentKey: boolean;
    function IsInRelationship: boolean;
    function CompatibleForRelationship(ChildField: TGDAOField): boolean;

    function GetGridDataTypeName: string;
    procedure AssignDomainInternalFields(ADomain: TGDAODomain);
    property Domain: TGDAODomain read FDomain write SetDomain;
    property DataType: TGDAODataType read GetDataType write SetDataType;
    property Data: TObject read FData write FData;
    property InPrimaryKey : Boolean read GetInPrimaryKey write SetInPrimaryKey;
  published
    property FieldName:string read FFieldName write SetFieldName;
    property DataTypeName:String read GetDataTypeName write SetDataTypeName;
    property Size:integer read GetSize write FSize;
    property Size2:integer read GetSize2 write FSize2;
    property Description: string read FDescription write FDescription;
    property DefaultValue:string read GetDefaultValue write SetDefaultValue;
    property Required:boolean read GetRequired write FRequired;
    property FID: integer read FFID write FFID;
    property DomainName: String read GetDomainName write SetDomainName;
    property DefaultValueSpecific: Boolean read FDefaultValueSpecific write FDefaultValueSpecific;
    property RequiredSpecific: Boolean read FRequiredSpecific write FRequiredSpecific;
    property Expression: string read FExpression write FExpression;
    property ConstraintExpr : String read GetConstraintExpr write FConstraintExpr;
    property ConstraintName : String read FConstraintName write FConstraintName;
    property ConstraintExprSpecific : Boolean read FConstraintExprSpecific write FConstraintExprSpecific;
    property ConstraintDefaultName: string read FConstraintDefaultName write FConstraintDefaultName;
    property ConstraintNotNullName: string read FConstraintNotNullName write FConstraintNotNullName;
    property SeedValue : Integer read GetSeedValue write FSeedValue;
    property IncrementValue : Integer read GetIncrementValue write FIncrementValue;
    property GeneratedByRelationship: Boolean read FGeneratedByRelationship write FGeneratedByRelationship;
    property FieldCaption: string read GetFieldCaption write SetFieldCaption stored StoreFieldCaption;
    property Restriction: TFieldRestriction read GetRestriction write FRestriction default frNone;
  end;

  TGDAOIndexes = class(TCollection)
  private
    FOwnerTable : TGDAOTable;
    function GetItem(i:integer):TGDAOIndex;
    procedure SetItem(i: integer; const Value: TGDAOIndex);
  public
    constructor Create( AOwnerTable:TGDAOTable );
    function GetOwner: TPersistent; override;
    function Add: TGDAOIndex; overload;
    function Add(AName: string):TGDAOIndex; overload;
    function OwnerDatabase:TGDD;
    function FindByName(AIndexName: string): TGDAOIndex;
    function IndexOf(AIndexName:string):integer;
    function IndexOfIId(AIID: Integer): integer;
    function ValidItem(AItem:TGDAOIndex):boolean;
    function GetNewIndexName: String;
    property Items[i:integer]:TGDAOIndex read GetItem write SetItem; default;
  end;

  TGDAOIndex = class(TCollectionItem)
  private
    FIndexName  : string;
    FIndexOrder : TIndexOrder;
    FIID        : Integer;
    FIndexType  : TIndexType;
    FIFields    : TGDAOIFields;
    FData: TObject;
    FOwnerTable: TGDAOTable;
    procedure SetIFields(const Value: TGDAOIFields );
    function GetIsPrimary: boolean;
  public
    constructor Create(ACollection:TCollection);  override;
    constructor CreateFromTable(AOwnerTable: TGDAOTable);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  GetDisplayName: string; override;
    function OwnerDatabase:TGDD;
    function OwnerTable:TGDAOTable;
    function TableName:string;
    function HasField(AField: TGDAOField): boolean;
    function GetTableAvailableFieldsList: TList;
    property IsPrimary: boolean read GetIsPrimary;
    property Data: TObject read FData write FData;
  published
    property IndexName: string read FIndexName write FIndexName;
    property IndexType: TIndexType read FIndexType write FIndexType;
    property IndexOrder: TIndexOrder read FIndexOrder write FIndexOrder;
    property IID: Integer read FIID write FIID;
    property IFields: TGDAOIFields read FIFields write SetIFields;
  end;

  TGDAOIFields = class(TCollection)
  private
    FOwnerIndex : TGDAOIndex;
    function GetItem(i:integer):TGDAOIField;
    procedure SetItem(i: integer; const Value: TGDAOIField);
    function GetField(i: integer): TGDAOField;
    procedure SetField(i: integer; const Value: TGDAOField);
  public
    constructor Create( AOwnerIndex:TGDAOIndex );
    function GetOwner: TPersistent; override;
    function Add: TGDAOIField; overload;
    function Add(AFieldName: string):TGDAOIField; overload;
    function Add(AField: TGDAOField; AOrder: TIndexFieldOrder = ioAsc): TGDAOIField; overload;
    function FindByField(AField: TGDAOField): TGDAOIField;
    procedure RemoveField(AField: TGDAOField);
    function IndexOf( AFieldName:string ):integer;
    property Items[i:integer]:TGDAOIField read GetItem write SetItem; default;
    property Field[i:integer]:TGDAOField read GetField write SetField;
  end;

  TGDAOIField = class(TCollectionItem)
  private
    FFieldOrder: TIndexFieldOrder;
    FField : TGDAOField;
    FKeyByRelationship: boolean;
    function GetFieldName: string;
    procedure SetFieldName(const Value: string);
    function GetFieldIndex: integer;
    procedure SetFieldIndex(const Value: integer);
    procedure SetField(const Value: TGDAOField);
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
    function OwnerTable: TGDAOTable;
    function OwnerIndex: TGDAOIndex;
    property Field: TGDAOField read FField write SetField;
    property FieldName:string read GetFieldName write SetFieldName;
  published
    property FieldIndex:integer read GetFieldIndex write SetFieldIndex;
    property FieldOrder: TIndexFieldOrder read FFieldOrder write FFieldOrder;
    property KeyByRelationship: boolean read FKeyByRelationship write FKeyByRelationship;
  end;

  TGDAORelationshipFieldLinks = class(TCollection)
  private
    FRelationship: TGDAORelationship;
    function GetItem(i: integer): TGDAORelationshipFieldLink;
    procedure SetItem(i: integer; const Value: TGDAORelationshipFieldLink);
  public
    constructor Create(ARelationship: TGDAORelationship);
    function GetOwner: TPersistent; override;
    function Add: TGDAORelationshipFieldLink;
    function IndexOfParentField(AField: TGDAOField): integer;
    function IndexOfChildField(AField: TGDAOField): integer;
    property Items[i: integer]: TGDAORelationshipFieldLink read GetItem write SetItem; default;
  end;

  TGDAORelationshipFieldLink = class(TCollectionItem)
  private
    FParentField: TGDAOField;
    FChildField: TGDAOField;
    function GetChildField: TGDAOField;
    function GetChildFieldName: string;
    function GetParentField: TGDAOField;
    function GetParentFieldName: string;
    procedure SetChildFieldName(const Value: string);
    procedure SetParentFieldName(const Value: string);
    procedure SetChildField(const Value: TGDAOField);
    procedure SetParentField(const Value: TGDAOField);
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
    function OwnerRelationship: TGDAORelationship;
    property ParentField: TGDAOField read GetParentField write SetParentField;
    property ChildField: TGDAOField read GetChildField write SetChildField;
  published
    property ParentFieldName: string read GetParentFieldName write SetParentFieldName;
    property ChildFieldName: string read GetChildFieldName write SetChildFieldName;
  end;

  TGDAORelationships = class(TCollection)
  private
    FOwnerDatabase : TGDD;
    function GetItem(i:integer):TGDAORelationship;
    procedure SetItem(i: integer; const Value: TGDAORelationship);
  public
    constructor Create( AOwnerDatabase:TGDD );
    function GetOwner: TPersistent; override;
    function Add(ARelationshipName, AParentTableName, AChildTableName: string;
      AUpdateMethod: TUpdateMethod; ADeleteMethod: TDeleteMethod ): TGDAORelationship; overload;
    function Add: TGDAORelationship; overload;
    function ValidItem(AItem: TGDAORelationship):boolean;
    function IndexOf(ARelationshipName: string): integer;
    procedure UpdateParentIndex;
    function GetNewRelationshipName: String;
    function IndexOfRelID(AID: integer): integer;
    function FindByID(AID: integer): TGDAORelationship;
    property OwnerDatabase:TGDD read FOwnerDatabase;
    property Items[i:integer]: TGDAORelationship read GetItem write SetItem; default;
  end;

  TGDAORelationship = class(TCollectionItem)
  private
    FParentTable: TGDAOTable;
    FChildTable: TGDAOTable;
    FFieldLinks: TGDAORelationshipFieldLinks;
    FData: TObject;
    FDescription: string;
    FRelID: integer;
    FRelationshipName: string;
    FDeleteMethod: TDeleteMethod;
    FUpdateMethod: TUpdateMethod;
    FParentIndex: TGDAOIndex;
    FRelationshipType: TGDAORelationshipType;
    FAutoCreatingField: boolean;
    function GetParentTableName: string;
    function GetChildTableName: string;
    procedure SetParentTableName(const Value: string);
    procedure SetChildTableName(const Value: string);
    procedure SetChildTable(const Value: TGDAOTable);
    procedure SetParentTable(const Value: TGDAOTable);
    procedure SetFieldLinks(const Value: TGDAORelationshipFieldLinks);
    function GetIsIdentifying: boolean;
    function GetParentTableIndex: integer;
    function GetChildTableIndex: integer;
    procedure SetParentTableIndex(const Value: integer);
    procedure SetChildTableIndex(const Value: integer);
    function SuggestedName: string;
    function GetParentIndexID: integer;
    procedure SetParentIndexID(const Value: integer);
    function GetKeyLink(i: integer): TGDAORelationshipFieldLink;
    function GetKeyLinkCount: integer;
    function GetReadOnly: boolean;
    function GetVisible: boolean;
    function OneToOneUniqueIndex: TGDAOIndex;
  public
    constructor Create( ACollection:TCollection ); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  GetDisplayName: string; override;
    function OwnerDatabase:TGDD;
    function Cardinality: TGDAORelationshipCardinality;
    function AutoCreateRelationshipKey(AIndex: TGDAOIndex; TryFindField: boolean): boolean;

    {Creates a child field given the specified parent field. If ABaseName is not
     specified, the new field will be created with the same name as parent field}
    function AutoCreateChildField(AParentField: TGDAOField; ABaseName: string = ''): TGDAOField;
    property ParentTableName: string read GetParentTableName write SetParentTableName;
    property ChildTableName: string read GetChildTableName write SetChildTableName;
    property ParentTable: TGDAOTable read FParentTable write SetParentTable;
    property ChildTable: TGDAOTable read FChildTable write SetChildTable;
    property IsIdentifying: boolean read GetIsIdentifying;
    property ParentIndex: TGDAOIndex read FParentIndex write FParentIndex;
    property Data: TObject read FData write FData;
    property KeyLinkCount: integer read GetKeyLinkCount;
    property KeyLinks[i: integer]: TGDAORelationshipFieldLink read GetKeyLink;
    property ReadOnly: boolean read GetReadOnly;
    property Visible: boolean read GetVisible;
  published
    property RelationshipName: string read FRelationshipName write FRelationshipName;
    property ParentTableIndex: integer read GetParentTableIndex write SetParentTableIndex;
    property ChildTableIndex: integer read GetChildTableIndex write SetChildTableIndex;
    property UpdateMethod: TUpdateMethod read FUpdateMethod write FUpdateMethod;
    property DeleteMethod: TDeleteMethod read FDeleteMethod write FDeleteMethod;
    property Description: string read FDescription write FDescription;
    property RelID: integer read FRelID write FRelID;
    property FieldLinks: TGDAORelationshipFieldLinks read FFieldLinks write SetFieldLinks;
    property ParentIndexID: integer read GetParentIndexID write SetParentIndexID;
    property RelationshipType: TGDAORelationshipType read FRelationshipType write FRelationshipType;
  end;

  TGDAOConstraints = class(TCollection)
  private
    FOwnerTable : TGDAOTable;
    function GetItem(i:integer): TGDAOCOnstraint;
    procedure SetItem(i:integer; const Value: TGDAOCOnstraint);
  public
    constructor Create(AOwnerTable:TGDAOTable);
    function GetOwner: TPersistent; override;
    function Add:TGDAOConstraint;
    function IndexOf(AConstraintName:string):integer;
    function FindByName(AConstraintName: string): TGDAOConstraint;
    function IndexOfCID(ACID: Integer): integer;
    function AddConstraint(AName,AExpression:string):TGDAOConstraint;
    function GetNewConstraintName: String;
    property OwnerTable: TGDAOTable read FOwnerTable;
    property Items[i:integer]:TGDAOCOnstraint read GetItem write SetItem; default;
  end;

  TGDAOConstraint = class(TCollectionItem)
  private
    FConstraintName : string;
    FExpression : string;
    FCID : Integer;
    FData: TObject;
  public
    procedure Assign(Source:TPersistent); override;
    function GetDisplayName: string; override;
    function OwnerTable: TGDAOTable;
    property Data: TObject read FData write FData;
  published
    property ConstraintName:string read FConstraintName write FConstraintName;
    property Expression:string read FExpression write FExpression;
    property CID: Integer read FCID write FCID;
  end;

  TGDAOTriggers = class(TCollection)
  private
    FOwnerTable: TGDAOTable;
    function GetItem(i: integer): TGDAOTrigger;
    procedure SetItem(i: integer; const Value: TGDAOTrigger);
  public
    constructor Create(AOwnerTable: TGDAOTable);
    function GetOwner: TPersistent; override;
    function Add: TGDAOTrigger; overload;
    function Add(AName: string; AImplementation: string=''): TGDAOTrigger; overload;
    function IndexOf(AName: string): integer;
    function FindByName(AName: string): TGDAOTrigger;
    function GetNewTriggerName: String;
    property OwnerTable: TGDAOTable read FOwnerTable;
    property Items[i: integer]: TGDAOTrigger read GetItem write SetItem; default;
  end;

  TGDAOTrigger = class(TCollectionItem)
  private
    FName: string;
    FDescription: string;
    FImplementation: string;
    FData: TObject;
    function GetTableName: string;
    function GetTable: TGDAOTable;
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
    function OwnerDatabase: TGDD;
    function OwnerTable: TGDAOTable;
    property Table: TGDAOTable read GetTable;
    property TableName: string read GetTableName;
    property Data: TObject read FData write FData;
  published
    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
    property ImplementationCode: string read FImplementation write FImplementation;
  end;

  TGDAODataTypes       = class(TCollection)
  private
    FOwnerDatabase: TGDD;
    function GetItem(i: integer): TGDAODataType;
    procedure SetItem(i: integer; const Value: TGDAODataType);
  public
    constructor Create(AOwnerDatabase: TGDD);
    function Add: TGDAODataType; overload;
    function Add(AName, APhysical: String; FSizeReq, FSize2Req: Boolean;
                 ANativeDataType: TNativeDataType; ANativeSubType: TNativeSubType;
                 ACounter: Boolean = false; ASeed: Boolean = false; AIncrement: Boolean = False): TGDAODataType; overload;
    function GetOwner: TPersistent; override;
    function FindByName(AName: String): TGDAODataType;
    function FindByType(AType: TNativeDataType; ASubType: TNativeSubType=stUnknown): TGDAODataType;
    function GetDefaultDataType: TGDAODataType;
    property Items[i: integer]: TGDAODataType read GetItem write SetItem; default;
  end;

  TGDAODataType = class(TCollectionItem)
  private
    FForeignDataType: TGDAODataType;
    FName: String;
    FSizeIsRequired: Boolean;
    FNativeSubType: TNativeSubType;
    FNativeDataType: TNativeDataType;
    FSeedIsRequired: Boolean;
    FCounter: Boolean;
    FIncrementIsRequired: Boolean;
    FSize2IsRequired: Boolean;
    FPhysical: String;
    FComputed: boolean;
    FMinSize: integer;
    FCheckSize: boolean;
    FMaxSize: integer;
    FDefaultSize: integer;
    FDefaultSize2: integer;
    function GetForeignDataType: TGDAODataType;
    function GetForeignDataTypeName: string;
    procedure SetForeignDataTypeName(const AName: string);
    function CheckSizeStored: boolean;
  public
    procedure Assign(Source: TPersistent); override;
    function DefinesPrimaryKey: boolean;
    function BuildPhysicalExpression(ADomain: TGDAODomain): string; overload;
    function BuildPhysicalExpression(AField: TGDAOField): string; overload;
    procedure SetSizeSettings(ADefaultSize, ADefaultSize2: integer;
      ACheckSize: boolean; AMinSize, AMaxSize: integer);
    property ForeignDataType: TGDAODataType read GetForeignDataType write FForeignDataType;
  published
    property Name: String read FName write FName;
    property Physical: String read FPhysical write FPhysical;
    property SizeIsRequired: Boolean read FSizeIsRequired write FSizeIsRequired;
    property Size2IsRequired: Boolean read FSize2IsRequired write FSize2IsRequired;
    property Counter: Boolean read FCounter write FCounter;
    property SeedIsRequired: Boolean read FSeedIsRequired write FSeedIsRequired;
    property IncrementIsRequired: Boolean read FIncrementIsRequired write FIncrementIsRequired;
    property ForeignDataTypeName: String read GetForeignDataTypeName write SetForeignDataTypeName;
    property NativeDataType : TNativeDataType read FNativeDataType write FNativeDataType;
    property NativeSubType  : TNativeSubType read FNativeSubType write FNativeSubType;
    property Computed: boolean read FComputed write FComputed;
    property CheckSize: boolean read FCheckSize write FCheckSize;
    property MinSize: integer read FMinSize write FMinSize stored CheckSizeStored;
    property MaxSize: integer read FMaxSize write FMaxSize stored CheckSizeStored;
    property DefaultSize: integer read FDefaultSize write FDefaultSize;
    property DefaultSize2: integer read FDefaultSize2 write FDefaultSize2;
  end;

  TGDAODomains = class(TCollection)
  private
    FOwnerDatabase: TGDD;
    function GetItem(i: integer): TGDAODomain;
    procedure SetItem(i: integer; const Value: TGDAODomain);
  public
    constructor Create(AOwnerDatabase: TGDD);
    function Add: TGDAODomain;
    function FindByName(AName: String): TGDAODomain;
    function GetNewDomainName: String;
    function GetOwner: TPersistent; override;
    function IndexOf(AName: String): Integer;
    property Items[i: integer]: TGDAODomain read GetItem write SetItem; default;
  end;

  TGDAODomain = class(TCollectionItem)
  private
    FDataType: TGDAODataType;
    FInformation: String;
    FName: String;
    FDefaultValue: String;
    FSize2: Integer;
    FConstraintExpr: String;
    FSeedValue: Integer;
    FSize: Integer;
    FIncrementValue: Integer;
    FInDatabase: boolean;
    FData: TObject;
    FRequired: boolean;
    function GetDataTypeName: String;
    procedure SetDataTypeName(const Value: String);
    function OwnerDatabase: TGDD;
    procedure SetDataType(const Value: TGDAODataType);
    function GetInDatabase: boolean;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    {Returns true if the domain is being used in any field of the database}
    function IsBeingUsed: boolean;

    {Returns true if the domain is being used in any field of the database
     and the field is part of a relationship}
    function IsInRelationship: boolean;

    {Fill the list of field objects where the domain is being used}
    procedure FillUsedFields(AFieldList: TObjectList);
    
    property DataType: TGDAODataType read FDataType write SetDataType;
    property Data: TObject read FData write FData;


  published
    property Name : String read FName write FName;
    property ConstraintExpr: String read FConstraintExpr write FConstraintExpr;
    property DataTypeName: String read GetDataTypeName write SetDataTypeName;
    property Size: Integer read FSize write FSize;
    property Size2: Integer read FSize2 write FSize2;
    property DefaultValue: String read FDefaultValue write FDefaultValue;
    property Information: String read FInformation write FInformation;
    property SeedValue: Integer read FSeedValue write FSeedValue;
    property IncrementValue: Integer read FIncrementValue write FIncrementValue;
    property InDatabase: boolean read GetInDatabase write FInDatabase;
    property Required: boolean read FRequired write FRequired;
  end;

  TGDAOPropDefType = (pdtInteger, pdtString);

  TGDAOPropDef = class(TCollectionItem)
  private
    FDefaultValue: Variant;
    FPropName: string;
    FDataType: TGDAOPropDefType;
  published
  public
    property PropName: string read FPropName write FPropName;
    property DefaultValue: Variant read FDefaultValue write FDefaultValue;
    property DataType: TGDAOPropDefType read FDataType write FDataType;
  end;

  TGDAOPropDefs = class(TCollection)
  private
    function GetItem(Index: integer): TGDAOPropDef;
    function ReadProp(APropName: string; APropValues: TStrings): Variant;
    function WriteProp(APropName: string; APropValues: TStrings; AValue: Variant): Variant;
    procedure GetPropParams(APropName: string; var AType: TGDAOPropDefType; var ADefValue: Variant);
  public
    function FindProp(APropName: string): TGDAOPropDef;
    function Add(APropName: string; AType: TGDAOPropDefType; ADefValue: Variant): TGDAOPropDef; overload;
    function Add: TGDAOPropDef; overload;
    property Items[Index: integer]: TGDAOPropDef read GetItem;
  end;

  TGDAOCategories = class(TCollection)
  private
    FOwnerDatabase: TGDD;
    function GetItem(i: integer): TGDAOCategory;
    procedure SetItem(i: integer; const Value: TGDAOCategory);
  public
    constructor Create(AOwnerDatabase: TGDD);
    function Add(AType: TGDAOCategoryType; ANameS, ANameP: string; ACreate, ADrop: String): TGDAOCategory;
    function _FindByNameP(AName: String): TGDAOCategory;
    function FindByType(AType: TGDAOCategoryType): TGDAOCategory;
    function GetOwner: TPersistent; override;
    property Items[i: integer]: TGDAOCategory read GetItem write SetItem; default;
  end;

  TGDAOCategory = class(TCollectionItem)
  private
    FObjects      : TGDAOObjects;
    FDropTemplate: String;
    FCreateTemplate: String;
    FCategoryNameP: String;
    FCategoryNameS: String;
    FData: TObject;
    FCategoryType: TGDAOCategoryType;
    FPropDefs: TGDAOPropDefs;
    procedure SetObjects(const Value: TGDAOObjects);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Data: TObject read FData write FData;
    property PropDefs: TGDAOPropDefs read FPropDefs;
  published
    property CategoryNameP: String read FCategoryNameP write FCategoryNameP stored false;
    property CategoryNameS: String read FCategoryNameS write FCategoryNameS stored false;
    property CreateTemplate : String read FCreateTemplate write FCreateTemplate stored false;
    property DropTemplate : String read FDropTemplate write FDropTemplate stored false;
    property CategoryType: TGDAOCategoryType read FCategoryType write FCategoryType;
    property Objects : TGDAOObjects read FObjects write SetObjects;
  end;

  TGDAOObjects = class(TCollection)
  private
    FOwnerDatabase: TGDD;
    FOwnerCategory: TGDAOCategory;
    function GetItem(i: integer): TGDAOObject;
    procedure SetItem(i: integer; const Value: TGDAOObject);
  public
    constructor Create(AOwnerCategory: TGDAOCategory);
    function Add(AName: String): TGDAOObject;
    function FindByName(AName: String): TGDAOObject;
    function GetNewObjectName: String;
    function GetOwner: TPersistent; override;
    function IndexOf(AName: String): Integer;
    property OwnerCategory: TGDAOCategory read FOwnerCategory;
    property Items[i: integer]: TGDAOObject read GetItem write SetItem; default;
  end;

  TGDAOObject = class(TCollectionItem)
  private
    FData: TObject;
    FDescription: string;
    FDropImplementation: string;
    FCreateImplementation: string;
    FObjectName: string;
    FCustomProps: TStrings;
    FRestriction: TObjectRestriction;
    function GetDropImplementation: string;
    procedure SetCustomProps(const Value: TStrings);
    function GetReadOnly: boolean;
    function GetVisible: boolean;
    procedure SetReadOnly(const Value: boolean);
    procedure SetVisible(const Value: boolean);
    function GetRestriction: TObjectRestriction;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function ReadProp(APropName: string): variant;
    procedure WriteProp(APropName: string; AValue: Variant);
    function OwnerCategory: TGDAOCategory;
    property Data: TObject read FData write FData;
    property ReadOnly: boolean read GetReadOnly write SetReadOnly;
    property Visible: boolean read GetVisible write SetVisible;
  published
    property ObjectName: string read FObjectName write FObjectName;
    property Description: string read FDescription write FDescription;
    property CreateImplementation : string read FCreateImplementation write FCreateImplementation;
    property DropImplementation : string read GetDropImplementation write FDropImplementation stored false;
    property CustomProps: TStrings read FCustomProps write SetCustomProps;
    property Restriction: TObjectRestriction read GetRestriction write FRestriction default orNone;
  end;

implementation

constructor TGDD.Create(AOwner:TPersistent);
begin
   inherited Create;
   FOwner := AOwner;
   { create the main instances (collections) }
   FTables  := TGDAOTables.Create(self);
   FRelationships := TGDAORelationships.Create(self);
   FDomains       := TGDAODomains.Create(Self);
   FCategories    := TGDAOCategories.Create(Self);
   // next ids
   NextTableID      := 1;
   NextFieldID      := 1;
   NextIndexID      := 1;
   NextConstraintID := 1;
   NextRelationshipID := 1;

   { default values }
   FDatabaseType := nil;
end;

destructor TGDD.Destroy;
begin
  {First clean all objects. Then destroy it. This is useful because
   when some objects are destroyed, they try to remove their reference
   from other objects. So, first we clear without destroying to avoid AV in this
   cleaning routines. Then after everything is empty, we can destroy the collections}
   FRelationships.Clear;
   FTables.Clear;
   FDomains.Clear;
   FCategories.Clear;
   
   FRelationships.Free;
   FTables.Free;
   FDomains.Free;
   FCategories.Free;
   inherited;
end;

function TGDD.DuplicateTable(ATable: TGDAOTable; ANewName: string): TGDAOTable;
begin
  Result := AddTable(ANewName);
  Result.Assign(ATable);
  Result.TableName := ANewName;
  Result.UpdateID;
end;

procedure TGDD.FieldDestroyed(AField: TGDAOField);
var
  c: integer;
  idx: integer;
  ATable: TGDAOTable;
begin
  {Iterate through relationships and remove references to
   the field being destroyed}
  ATable := AField.OwnerTable;
  for c := 0 to Relationships.Count - 1 do
  begin
    if Relationships[c].ParentTable = ATable then
    begin
      idx := Relationships[c].FieldLinks.IndexOfParentField(AField);
      if idx > -1 then
        {Set the parentfield field directly, not property, because
         we just need to set the pointer. If we set the property,
         a lot of undesired calls can happen. Same for ChildField below} 
        Relationships[c].FieldLinks[idx].FParentField := nil;
    end;

    if Relationships[c].ChildTable = ATable then
    begin
      idx := Relationships[c].FieldLinks.IndexOfChildField(AField);
      if idx > -1 then
        Relationships[c].FieldLinks[idx].FChildField := nil;
    end;
  end;
end;

procedure TGDD.FieldNameChanged(AField: TGDAOField);
begin
  if Assigned(FOnFieldNameChanged) then
    FOnFieldNameChanged(AField);
end;

function TGDD.FindPrimaryKeyByName(AName: string): TGDAOIndex;
var
  c: integer;
begin
  result := nil;
  for c := 0 to Tables.Count - 1 do
  begin
    if (Tables[c].PrimaryKeyIndex <> nil) and SameText(Tables[c].PrimaryKeyIndex.IndexName, AName) then
    begin
      result := Tables[c].PrimaryKeyIndex;
      exit;
    end;
  end;
end;

procedure TGDD.Assign(Source: TPersistent);
begin
  DatabaseTypeID    := TGDD(Source).DatabaseTypeID;
  NextTableID       := TGDD(Source).NextTableID;
  NextFieldID       := TGDD(Source).NextFieldID;
  NextConstraintID  := TGDD(Source).NextConstraintID;
  NextIndexID       := TGDD(Source).NextIndexID;
  Domains           := TGDD(Source).Domains;
  Tables            := TGDD(Source).Tables;
  Relationships     := TGDD(Source).Relationships;
  Categories        := TGDD(Source).Categories;
  FNextRelationshipID := TGDD(Source).FNextRelationshipID;
  FNextTableID       := TGDD(Source).FNextTableID;
  FNextFieldID       := TGDD(Source).FNextFieldID;
  FNextIndexID       := TGDD(Source).FNextIndexID;
  FNextConstraintID  := TGDD(Source).FNextConstraintID;
end;

function TGDD.IndexOfTable( ATableName:string):integer;
begin
  result:=Tables.IndexOf(ATableName);
end;

procedure TGDD.Loaded;
var
  c: integer;
  d: integer;
  i: integer;
  ATable: TGDAOTable;
  AIndex: TGDAOIndex;
begin
  {Perform some checking to clean up the dictionary after loading}
  for c := 0 to Tables.Count - 1 do
  begin
    ATable := Tables[c];
    for d := 0 to ATable.Indexes.Count - 1 do
    begin
      AIndex := ATable.Indexes[d];
      for i := AIndex.IFields.Count - 1 downto 0 do
      begin
        if AIndex.IFields[i].Field = nil then
          AIndex.IFields[i].Free;
      end;
    end;
  end;
end;

procedure TGDD.SetRelationships(const Value: TGDAORelationships);
begin
   FRelationships.Assign(Value);
end;

procedure TGDD.SetTables(const Value: TGDAOTables);
begin
   FTables.Assign(Value);
end;

function TGDD.TableByName(ATableName: string): TGDAOTable;
begin
  result := FTables.FindByName(ATableName);
end;

procedure TGDD.TableDestroyed(ATable: TGDAOTable);
begin
  if Assigned(FOnTableDestroy) then
    FOnTableDestroy(ATable);
end;

procedure TGDD.RecreateIds;
var
  Ids: TDictionary<integer, integer>;
  Max: integer;
  I: integer;
begin
  Ids := TDictionary<integer, integer>.Create;
  try
    { tables }
    Ids.Clear;
    Max := 0;
    for I := 0 to Tables.Count - 1 do
      if Max < Tables[I].TID then
        Max := Tables[I].TID;
    Inc(Max);
    for I := 0 to Tables.Count - 1 do
    begin
      if Ids.ContainsKey(Tables[I].TID) then
      begin
        Tables[I].TID := Max;
        Inc(Max);
      end else
        Ids.Add(Tables[I].TID, 0);
    end;
  finally
    Ids.Free;
  end;
end;

function TGDD.RelationshipByName(ARelationshipName,
  ATableName: string): TGDAORelationship;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Relationships.Count - 1 do
    if SameText(Relationships[I].RelationshipName, ARelationshipName) and
      SameText(Relationships[I].ChildTableName, ATableName) then
    begin
      Exit(Relationships[I]);
    end;
end;

function TGDD.RelationshipByName(ARelationshipName: string): TGDAORelationship;
var
  iRelationship: integer;
begin
   iRelationship:=Relationships.IndexOf(ARelationshipName);
   if iRelationship>=0 then
      result:=Relationships[iRelationship]
   else
      result:=nil;
end;

function TGDD.GetOwner: TPersistent;
begin
   result:=FOwner;
end;

function TGDD.IndexExists(AIndexName: string): boolean;
var iTab, iInd: integer;
begin
   for iTab:=0 to Tables.Count-1 do
      with Tables[iTab] do
         for iInd:=0 to Indexes.Count-1 do
            if CompareText(AIndexName,Indexes[iInd].IndexName)=0 then
            begin
               result:=true;
               exit;
            end;
   result:=false;
end;

procedure TGDD.SetDatabaseTypeID(const Value: string);
begin
  FDatabaseType := DatabaseTypes.FindByID(Value);
end;

procedure TGDD.SetDataTypes(const Value: TGDAODataTypes);
begin
end;

procedure TGDD.SetDomains(const Value: TGDAODomains);
begin
  FDomains.Assign(Value);
end;

procedure TGDD.SetCategories(const Value: TGDAOCategories);
begin
   FCategories.Assign(Value);
end;

function TGDD.GetNextRelationshipID: integer;
var
  I: Integer;
begin
  result := NextRelationshipID;
  NextRelationshipID := NextRelationshipID + 1;
  for I := 0 to Relationships.Count - 1 do
    if NextRelationshipId <= Relationships[I].RelID then
      NextRelationshipId := Relationships[I].RelID + 1;
end;

function TGDD.GetNextTableID: integer;
var
  I: Integer;
begin
  result := NextTableID;
  NextTableID := NextTableID + 1;
  for I := 0 to Tables.Count - 1 do
    if NextTableId <= Tables[I].TID then
      NextTableId := Tables[I].TID + 1;
end;

function TGDD.GetDatabaseTypeID: string;
begin
  if Assigned(FDatabaseType) then
    result := FDatabaseType.DatabaseTypeID
  else
    result := '';
end;

function TGDD.GetDataTypes: TGDAODataTypes;
begin
  if FDatabaseType <> nil then
    result := TGDAODataTypes(FDatabaseType.DataTypes)
  else
    result := nil;
end;

function TGDD.GetNewPrimaryKeyName: string;
var
  i: integer;
begin
  i := 1;
  repeat
    result := Format('%s%d', [SNewPrimaryKeyName, i]);
    inc(i);
  until FindPrimaryKeyByName(result) = nil;
end;

function TGDD.GetNextConstraintID: integer;
var
  I, J: Integer;
begin
  result := NextConstraintID;
  NextConstraintID := NextConstraintID + 1;
  for I := 0 to Tables.Count - 1 do
    for J := 0 to Tables[I].Constraints.Count - 1 do
      if NextConstraintId <= Tables[I].Constraints[J].CID then
        NextConstraintId := Tables[I].Constraints[J].CID + 1;
end;

function TGDD.GetNextFieldID: integer;
var
  I, J: Integer;
begin
  result := NextFieldID;
  NextFieldID := NextFieldID + 1;
  for I := 0 to Tables.Count - 1 do
    for J := 0 to Tables[I].Fields.Count - 1 do
      if NextFieldId <= Tables[I].Fields[J].FID then
        NextFieldId := Tables[I].FIelds[J].FID + 1;
end;

function TGDD.GetNextIndexID: integer;
var
  I, J: Integer;
begin
  result := NextIndexID;
  NextIndexID := NextIndexID + 1;
  for I := 0 to Tables.Count - 1 do
    for J := 0 to Tables[I].Indexes.Count - 1 do
      if NextIndexId <= Tables[I].Indexes[J].IID then
        NextIndexId := Tables[I].Indexes[J].IID + 1;
end;

function TGDD.AddTable(ATableName: string): TGDAOTable;
begin
   result := FTables.Add(ATableName);
end;

{ TGDAOTables }

constructor TGDAOTables.Create( AOwnerDatabase:TGDD );
begin
   FOwnerDatabase:=AOwnerDatabase;
   inherited Create( TGDAOTable );
end;

function TGDAOTables.FindByID(ATID: integer): TGDAOTable;
var
  i: integer;
begin
   i := IndexOfTid(ATID);
   if i > -1 then
      result := Items[i]
   else
      result := nil;
end;

function TGDAOTables.FindByName(ATableName: string): TGDAOTable;
var
  i: integer;
begin
   i := IndexOf(ATableName);
   if i > -1 then
      result := Items[i]
   else
      result := nil;
end;

function TGDAOTables.GetItem( i:integer ):TGDAOTable;
begin
   result:=TGDAOTable( inherited Items[i] );
end;

function TGDAOTables.Add: TGDAOTable;
begin
  result := TGDAOTable(inherited Add);
  result.UpdateID;
  result.UpdatePrimaryKeyName;
end;

function TGDAOTables.Add(ATableName: string): TGDAOTable;
begin
   result := Add;
   with result do
   begin
      TableName := ATableName;
   end;
end;

procedure TGDAOTables.SetItem(i: integer; const Value: TGDAOTable);
begin
   Items[i].Assign(Value);
end;

function TGDAOTables.IndexOf(ATableName:string):integer;
begin
   for result:=0 to Count-1 do
      if CompareText(ATableName,Items[result].TableName)=0 then
         Exit;
   result:=-1;
end;

function TGDAOTables.GetOwner: TPersistent;
begin
   result:=FOwnerDatabase;
end;

function TGDAOTables.IndexOfTid(ATID: integer): integer;
begin
   for result:=0 to Count-1 do
      if ATID=Items[result].TID then
         exit;
   result:=-1;
end;

function TGDAOTables.GetNewTableName: String;
var c : Integer;
begin
  c := 0;
  Result := SNewTableName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d', [SNewTableName, c]);
  end;
end;

{ TGDAOTable }

constructor TGDAOTable.Create( ACollection:TCollection );
begin
   inherited Create( ACollection );
   FRestriction := trNone;

   FFields:=TGDAOFields.Create( self );
   FIndexes:=TGDAOIndexes.Create( self );
   FConstraints:=TGDAOConstraints.Create( self );
   FTriggers:=TGDAOTriggers.Create( self );

   {Create primary key. Should never be destroyed}
   FPrimaryKeyIndex := TGDAOIndex.CreateFromTable(Self);
   FPrimaryKeyIndex.IndexName := STempPrimaryKeyName;
end;

destructor TGDAOTable.Destroy;
var r: integer;
begin
   // remove table relationships
   with OwnerDatabase.Relationships do
     for r := Count-1 downto 0 do
       if (Items[r].ParentTable = Self) or (Items[r].ChildTable = Self) then
         Delete(r);

   FFields.Free;
   FTriggers.Free;
   FConstraints.Free;
   FIndexes.Free;
   FPrimaryKeyIndex.Free;
   inherited;
end;

function TGDAOTable.OwnerDatabase:TGDD;
begin
  if Collection is TGDAOTables then
    result := TGDAOTables(Collection).FOwnerDatabase
  else
    result := nil;
end;

function TGDAOTable.FieldByName(AFieldName:string):TGDAOField;
var c: integer;
begin
   for c:=0 to FFields.Count-1 do
      if CompareText(FFields[c].FieldName,AFieldName)=0 then
      begin
         result:=FFields[c];
         Exit;
      end;
   result:=nil;
end;

procedure TGDAOTable.FieldDestroyed(AField: TGDAOField);
var
  c: integer;
  d: integer;
begin
  {Remove references to index fields}
  for c := 0 to Indexes.Count - 1 do
    for d := Indexes[c].IFields.Count - 1 downto 0 do
      if Indexes[c].IFields[d].Field = AField then
        Indexes[c].IFields[d].Free;

  {Remove references to primary key fields}
  for d := PrimaryKeyIndex.IFields.Count - 1 downto 0 do
    if PrimaryKeyIndex.IFields[d].Field = AField then
      PrimaryKeyIndex.IFields[d].Free;

  if OwnerDatabase <> nil then
    OwnerDatabase.FieldDestroyed(AField);
end;

procedure TGDAOTable.Assign(Source: TPersistent);
begin
  TableName := TGDAOTable(Source).TableName;
  Description := TGDAOTable(Source).Description;
  TID := TGDAOTable(Source).TID;
  OidIndex := TGDAOTable(Source).OidIndex;
  ExclusiveRecordMask := TGDAOTable(Source).ExclusiveRecordMask;
  Fields := TGDAOTable(Source).Fields;
  Indexes := TGDAOTable(Source).Indexes;
  Constraints := TGDAOTable(Source).Constraints;
  Triggers := TGDAOTable(Source).Triggers;
  PrimaryKeyIndex.Assign(TGDAOTable(Source).PrimaryKeyIndex);
  TableCaption := TGDAOTable(Source).TableCaption;
  Restriction := TGDAOTable(Source).Restriction;
  IsView := TGDAOTable(Source).IsView;
end;

procedure TGDAOTable.BeforeDestruction;
begin
  if OwnerDatabase <> nil then
    OwnerDatabase.TableDestroyed(Self);
  inherited;
end;

procedure TGDAOTable.SetFields(const Value: TGDAOFields);
begin
   FFields.Assign(Value);
end;

procedure TGDAOTable.SetIndexes(const Value: TGDAOIndexes);
begin
   FIndexes.Assign(Value);
end;

procedure TGDAOTable.SetPrimaryKeyIndex(const Value: TGDAOIndex);
begin
  FPrimaryKeyIndex.Assign(Value);
end;

procedure TGDAOTable.SetReadOnly(const Value: boolean);
begin
  if Restriction <> trHidden then
    if Value then
      Restriction := trReadOnly
    else
      Restriction := trNone;
end;

procedure TGDAOTable.SetConstraints(const Value: TGDAOConstraints);
begin
   FConstraints.Assign(Value);
end;

function TGDAOTable.AddIndex(AIndexName: string; AIndexType: TIndexType): TGDAOIndex;
begin
   result := Indexes.Add;
   with result do
   begin
      IndexName:=AIndexName;
      IndexType:=AIndexType;
   end;
end;

function TGDAOTable.HasForeignFields: boolean;
var i: integer;
begin
  for i := 0 to Fields.Count - 1 do
    if Fields[i].IsForeignKey then
    begin
      result := True;
      exit;
    end;
  result := False;
end;

function TGDAOTable.HasPrimaryKey: boolean;
begin
  result := (PrimaryKeyIndex <> nil) and (PrimaryKeyIndex.IFields.Count > 0);
end;

function TGDAOTable.HasPrimaryKeyDataType: boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Fields.Count - 1 do
    if (Fields[I].DataType <> nil) and Fields[I].DataType.DefinesPrimaryKey then
      Exit(true);
end;

procedure TGDAOTable.SetTableCaption(const Value: string);
begin
  FTableCaption := Value;
end;

procedure TGDAOTable.SetTriggers(const Value: TGDAOTriggers);
begin
   FTriggers.Assign(Value);
end;

procedure TGDAOTable.SetVisible(const Value: boolean);
begin
  if not Value then
    Restriction := trHidden
  else if Restriction <> trReadOnly then
    Restriction := trNone;
end;

function TGDAOTable.StoreTableCaption: Boolean;
begin
  result := (FTableCaption > '') and (FTableCaption <> FTableName);
end;

function TGDAOTable.TriggerByName(ATriggerName: string): TGDAOTrigger;
var iTrigger: integer;
begin
   iTrigger:=Triggers.IndexOf(ATriggerName);
   if iTrigger>=0 then
      result:=Triggers[iTrigger]
   else
      result:=nil;
end;

procedure TGDAOTable.UpdateID;
begin
  TID := OwnerDatabase.GetNextTableID;
end;

procedure TGDAOTable.UpdatePrimaryKeyName;
begin
  {if name is temporary, then find new name}
  if (PrimaryKeyIndex <> nil) and (PrimaryKeyIndex.IndexName = STempPrimaryKeyName) then
    PrimaryKeyIndex.IndexName := OwnerDatabase.GetNewPrimaryKeyName;
end;

function TGDAOTable.GetDisplayName: string;
begin
   if TableName = '' then
      Result := inherited GetDisplayName
   else
      result := TableName;
end;

function TGDAOTable.GetPrimaryKeyIndex: TGDAOIndex;
begin
  result := FPrimaryKeyIndex;
end;

function TGDAOTable.GetReadOnly: boolean;
begin
  result := Restriction = trReadOnly;
end;

function TGDAOTable.GetRestriction: TTableRestriction;
begin
  result := FRestriction;
end;

function TGDAOTable.GetTableCaption: string;
begin
  if FTableCaption > '' then
    result := FTableCaption
  else
    result := FTableName;
end;

function TGDAOTable.GetVisible: boolean;
begin
  result := Restriction <> trHidden;
end;

{ TGDAORelationships }

constructor TGDAORelationships.Create( AOwnerDatabase:TGDD );
begin
   FOwnerDatabase:=AOwnerDatabase;
   inherited Create( TGDAORelationship );
end;

function TGDAORelationships.FindByID(AID: integer): TGDAORelationship;
var
  i: integer;
begin
   i := IndexOfRelID(AID);
   if i > -1 then
      result := Items[i]
   else
      result := nil;
end;

function TGDAORelationships.GetItem( i:integer ):TGDAORelationship;
begin
   result:=TGDAORelationship( inherited Items[i] );
end;

function TGDAORelationships.Add: TGDAORelationship;
begin
  result := TGDAORelationship(inherited Add);
  result.RelID:=OwnerDatabase.GetNextRelationshipID;
end;

function TGDAORelationships.Add(ARelationshipName, AParentTableName, AChildTableName: string;
  AUpdateMethod:TUpdateMethod;ADeleteMethod:TDeleteMethod ) :TGDAORelationship;
begin
   result := Add;
   with result do
   begin
      RelationshipName:=ARelationshipName;
      ParentTableName:=AParentTableName;
      ChildTableName:=AChildTableName;
      UpdateMethod:=AUpdateMethod;
      DeleteMethod:=ADeleteMethod;
   end;
end;

procedure TGDAORelationships.SetItem(i: integer; const Value: TGDAORelationship);
begin
   Items[i].Assign(Value);
end;

function TGDAORelationships.ValidItem(AItem: TGDAORelationship): boolean;
var c: integer;
begin
   result:=true;
   if not Assigned(AItem) then Exit;
   for c:=0 to Count-1 do
      if Items[c]=AItem then Exit;
   result:=false;
end;

function TGDAORelationships.IndexOf(ARelationshipName: string): integer;
begin
   for result:=0 to Count-1 do
      if CompareText(ARelationshipName,Items[result].RelationshipName)=0 then
         exit;
   result:=-1;
end;

procedure TGDAORelationships.UpdateParentIndex;

  function _IsParentIndex(ARel: TGDAORelationship; AIndex: TGDAOIndex): boolean;
  var
    c: integer;
  begin
    result := ARel.FieldLinks.Count = AIndex.IFields.Count;
    if result  then
      for c := 0 to AIndex.IFields.Count - 1 do
        if ARel.FieldLinks[c].ParentField <> AIndex.IFields[c].Field then
        begin
          result := False;
          break;
        end;
  end;

var
  iRel, iIndex: integer;
begin
  // relationships whose parent key is a unique index
  for iRel := 0 to Count - 1 do
    begin
      Items[iRel].ParentIndex := nil;
      if Items[iRel].ParentTable <> nil then
      begin
        if _IsParentIndex(Items[iRel], Items[iRel].ParentTable.PrimaryKeyIndex) then
          Items[iRel].ParentIndex := Items[iRel].ParentTable.PrimaryKeyIndex
        else
          for iIndex := 0 to Items[iRel].ParentTable.Indexes.Count - 1 do
            if _IsParentIndex(Items[iRel], Items[iRel].ParentTable.Indexes[iIndex]) and
              (Items[iRel].ParentTable.Indexes[iIndex].IndexType in [itUnique, itUniqueKey]) then
            begin
              Items[iRel].ParentIndex := Items[iRel].ParentTable.Indexes[iIndex];
              break;
            end;
      end;
    end;
end;

function TGDAORelationships.GetOwner: TPersistent;
begin
   result:=FOwnerDatabase;
end;

function TGDAORelationships.GetNewRelationshipName: String;
var c : Integer;
begin
  c := 0;
  Result := SNewRelationshipName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d)', [SNewRelationshipName, c]);
  end;
end;

function TGDAORelationships.IndexOfRelID(AID: integer): integer;
begin
   for result:=0 to Count-1 do
      if AID=Items[result].RelID then
         exit;
   result:=-1;
end;

{ TGDAORelationship }

procedure TGDAORelationship.Assign(Source: TPersistent);
begin
  RelationshipName := TGDAORelationship(Source).RelationshipName;
  ParentTableIndex := TGDAORelationship(Source).ParentTableIndex;
  ChildTableIndex  := TGDAORelationship(Source).ChildTableIndex;
  UpdateMethod     := TGDAORelationship(Source).UpdateMethod;
  DeleteMethod     := TGDAORelationship(Source).DeleteMethod;
  Description      := TGDAORelationship(Source).Description;
  RelID            := TGDAORelationship(Source).RelID;
  FieldLinks       := TGDAORelationship(Source).FieldLinks;
  ParentIndexID    := TGDAORelationship(Source).ParentIndexID;
  RelationshipType := TGDAORelationship(Source).RelationshipType;
end;

constructor TGDAORelationship.Create(ACollection: TCollection);
begin
  inherited;
  FFieldLinks := TGDAORelationshipFieldLinks.Create(Self);
  UpdateMethod:=umRestrict;
  DeleteMethod:=dmRestrict;
end;

function TGDAORelationship.OneToOneUniqueIndex: TGDAOIndex;

  function _CheckUniqueIndex(AIndex: TGDAOIndex): boolean;
  var
    c: integer;
  begin
    result := false;
    if FieldLinks.Count = AIndex.IFields.Count then
    begin
      result := true;
      for c := 0 to FieldLinks.Count - 1 do
        if (AIndex.IFields[c].Field <> FieldLinks[c].ChildField)  then
        begin
          result := false;
          break;
        end;
    end;
  end;

var
  i: Integer;
begin
  if _CheckUniqueIndex(ChildTable.PrimaryKeyIndex) then
    Exit(ChildTable.PrimaryKeyIndex);
  for i := 0 to ChildTable.Indexes.Count - 1 do
    if (ChildTable.Indexes[i].IndexType in [itUnique, itUniqueKey])
      and _CheckUniqueIndex(ChildTable.Indexes[i]) then
        Exit(ChildTable.Indexes[i]);
  Result := nil;
end;

function TGDAORelationship.OwnerDatabase:TGDD;
begin
   result:=TGDAORelationships(Collection).FOwnerDatabase;
end;

function TGDAORelationship.GetChildTableName: string;
begin
   if Assigned(ChildTable) then
      result:=FChildTable.TableName
   else
      result:='';
end;

function TGDAORelationship.GetParentTableName: string;
begin
   if Assigned(ParentTable) then
      result:=ParentTable.TableName
   else
      result:='';
end;

function TGDAORelationship.GetReadOnly: boolean;
begin
  result := (ParentTable <> nil) and ParentTable.ReadOnly
    and (ChildTable <> nil) and ChildTable.ReadOnly;
end;

function TGDAORelationship.GetVisible: boolean;
begin
  result := ((ParentTable = nil) or ParentTable.Visible)
    and ((ChildTable = nil) or ChildTable.Visible);
end;

procedure TGDAORelationship.SetChildTableName(const Value: string);
begin
   ChildTable:=OwnerDatabase.TableByName(Value);
end;

procedure TGDAORelationship.SetFieldLinks(const Value: TGDAORelationshipFieldLinks);
begin
  FFieldLinks.Assign(Value);
end;

procedure TGDAORelationship.SetParentTableName(const Value: string);
begin
   ParentTable:=OwnerDatabase.TableByName(Value);
end;

function TGDAORelationship.GetChildTableIndex: integer;
begin
   if Assigned(ChildTable) then
      result:=ChildTable.Index
   else
      result:=-1;
end;

function TGDAORelationship.GetParentTableIndex: integer;
begin
   if Assigned(ParentTable) then
      result:=ParentTable.Index
   else
      result:=-1;
end;

procedure TGDAORelationship.SetChildTableIndex(const Value: integer);
begin
   if Value=-1 then
      ChildTable:=nil
   else
      ChildTable:=OwnerDatabase.Tables[Value];
end;

procedure TGDAORelationship.SetParentTableIndex(const Value: integer);
begin
   if Value=-1 then
      ParentTable:=nil
   else
      ParentTable:=OwnerDatabase.Tables[Value];
end;

destructor TGDAORelationship.Destroy;
begin
  {Don't need the code below because now on FieldLink.Destroy we're setting
  ChildField to nil which performs all needed operations}
  {for i := 0 to FieldLinks.Count - 1 do
    with FieldLinks[i] do
      if (ChildField <> nil) and ChildField.GeneratedByRelationship then
        ChildField.Free;}
  FFieldLinks.Free;
  inherited;
end;

procedure TGDAORelationship.SetChildTable(const Value: TGDAOTable);
begin
  FChildTable := Value;
  if (RelationshipName='') or (RelationshipName='???') then
    RelationshipName:=SuggestedName;
end;

procedure TGDAORelationship.SetParentTable(const Value: TGDAOTable);
begin
  FParentTable := Value;
  if (RelationshipName='') or (RelationshipName='???') then
    RelationshipName:=SuggestedName;
end;

procedure TGDAORelationship.SetParentIndexID(const Value: integer);
var
  i: integer;
begin
  if FParentTable = nil then
  begin
    FParentIndex := nil;
    Exit;
  end;

  if Value = 0 then
    FParentIndex := FParentTable.PrimaryKeyIndex
  else
  begin
    i := FParentTable.Indexes.IndexOfIId(Value);
    if i >= 0 then
      FParentIndex := FParentTable.Indexes[i]
    else
      FParentIndex := nil;
  end;
end;

function TGDAORelationship.GetParentIndexID: integer;
begin
  if Assigned(FParentIndex) then
  begin
    if FParentIndex.IsPrimary then
      result := 0
    else
      result := FParentIndex.IID;
  end
  else
    result := -1;
end;

function TGDAORelationship.Cardinality: TGDAORelationshipCardinality;
begin
  { if child fields compound an unique key of child table, then relationship is 1-1 }
  result := rcNone;

  if (ParentTable <> nil) and (ChildTable <> nil) then
  begin
    result := rcOneToMany;

    if OneToOneUniqueIndex <> nil then
      result := rcOneToOne;
  end;
end;

function TGDAORelationship.SuggestedName: string;
var
  maxtablen: integer;
  j: integer;
  relname: string;
begin
   { builds the initial part of the identifier (master+detail table) }
   if (ParentTableName > '') and (ChildTableName > '') and (OwnerDatabase <> nil) then
   begin
      if (Length(ParentTableName) + Length(ChildTableName) + 3) <=
        OwnerDatabase.DatabaseType.MaxIdentifierLength then
        maxtablen := MaxInt
      else
      begin
        {Ensure at least 3 extra characters in relationship name besides table names}
        maxtablen := OwnerDatabase.DatabaseType.MaxIdentifierLength - 3;
        maxtablen := maxtablen div 2;
      end;

      relname := copy(ParentTableName, 1, maxtablen) + '_' + copy(ChildTableName, 1, maxtablen);
      result := relname;
      j := 0;
      while TGDAORelationships(Collection).IndexOf(result) >= 0 do
      begin
        Inc(j);
        result := Format('%s_%d', [relname, j]);
      end;
   end
   else
      result:='???';
end;

function TGDAORelationship.GetDisplayName: string;
begin
   if RelationshipName = '' then
      Result := inherited GetDisplayName
   else
      result:=RelationshipName;
end;

function TGDAORelationship.AutoCreateChildField(AParentField: TGDAOField;
  ABaseName: string = ''): TGDAOField;
var
  newFieldName: string;
begin
  result := nil;
  if (ChildTable <> nil) and (AParentField <> nil) then
  begin
    if ABaseName = '' then
      ABaseName := AParentField.FieldName;

    { child field name will be same as parent child field name.
     Call GetNewFieldName to ensure an unique name (if the field already exists
     in child table) }
    newFieldName := ChildTable.Fields.GetNewFieldName(ABaseName);

    { add Child field }
    result := ChildTable.Fields.Add(newFieldName,
      AParentField.DataType.ForeignDataType, AParentField.Size,
      AParentField.Size2, (RelationshipType = ryIdentifying) and AParentField.Required);

    result.GeneratedByRelationship := True;
  end;
end;

function TGDAORelationship.AutoCreateRelationshipKey(AIndex: TGDAOIndex; TryFindField: boolean): boolean;

  function FindChildKeyField(AParent: TGDAOField): TGDAOField;
  var
    I: Integer;
    Child: TGDAOField;
  begin
    Result := nil;
    for I := 0 to ChildTable.Fields.Count - 1 do
    begin
      Child := ChildTable.Fields[I];
      if SameText(AParent.FieldName, Child.FieldName) and
        SameText(AParent.DataTypeName, Child.DataTypeName) and
        (AParent.Size = Child.Size) and (AParent.Size2 = Child.Size2) then
      begin
        Result := Child;
        break;
      end;
    end;
  end;

var
  i: integer;
  fChild, fParent: TGDAOField;
  lFields: TList;
begin
  result := true;
  {get primary fields from master table (or from unique index)}
  lFields := TList.Create;
  try
    {Add fields of unique/parent key}
    for i := 0 to AIndex.IFields.Count - 1 do
      lFields.Add(AIndex.IFields[i].Field);

    {relationship references parent index}
    ParentIndex := AIndex;

    {parent fields => child fields}
    for i := 0 to lFields.Count - 1 do
    begin
      fParent := lFields[i];

      // Here we do an "automatic" consideration. If the relationship has only one field,
      // then try to find an existing child field in child table, with same name and type
      if TryFindField and (lFields.Count = 1) then
      begin
        fChild := FindChildKeyField(fParent);
        if fChild = nil then
          fChild := AutoCreateChildField(fParent);
      end else
        // Other wise just create the regular field
        fChild := AutoCreateChildField(fParent);

      try
        {create relationship field links}
        with FieldLinks.Add do
        begin
          ParentField := fParent;
          ChildField := fChild;
        end;
      except
        on e: ERecursiveRelException do
        begin
          result := false;
          exit;
        end
        else
          raise;
      end;
    end;

  finally
    lFields.Free;
  end;
end;

function TGDAORelationship.GetIsIdentifying: boolean;
var f, i: integer;
begin
  { relationship is identifying if Child fields are primary (or belongs
    to an exclusive index on Child table), otherwise is non-identifying }
  result := False;
  if Assigned(ChildTable) then
    for f := 0 to FieldLinks.Count - 1 do
    begin
      if (FieldLinks[f].ChildField <> nil) and FieldLinks[f].ChildField.InPrimaryKey then
      begin
        result := True;
        exit;
      end;
      for i := 0 to ChildTable.Indexes.Count - 1 do
        if (ChildTable.Indexes[i].IndexType in [itUnique, itUniqueKey]) and ChildTable.Indexes[i].HasField(FieldLinks[f].ChildField) then
        begin
          result := True;
          exit;
        end;
    end;
end;

function TGDAORelationship.GetKeyLink(i: integer): TGDAORelationshipFieldLink;
var ilink: integer;
begin
  if ParentIndex <> nil then
  begin
    ilink := FieldLinks.IndexOfParentField(ParentIndex.IFields[i].Field);
    if ilink >= 0 then
      result := FieldLinks[ilink]
    else
      result := nil;
  end
  else
    result := FieldLinks[i];
end;

function TGDAORelationship.GetKeyLinkCount: integer;
var i: integer;
begin
  if ParentIndex <> nil then
  begin
    result := ParentIndex.IFields.Count;

    // refresh relationship links with fields from parent index
    for i := FieldLinks.Count-1 downto 0 do
      if ParentIndex.IFields.FindByField(FieldLinks[i].ParentField) = nil then
        FieldLinks.Delete(i);
    for i := 0 to ParentIndex.IFields.Count - 1 do
      if FieldLinks.IndexOfParentField(ParentIndex.IFields[i].Field) < 0 then
        FieldLinks.Add.ParentFieldName := ParentIndex.IFields[i].FieldName;
  end
  else
    result := FieldLinks.Count;
end;

{ TGDAOIndexes }

constructor TGDAOIndexes.Create( AOwnerTable: TGDAOTable );
begin
   FOwnerTable:=AOwnerTable;
   inherited Create( TGDAOIndex );
end;

function TGDAOIndexes.FindByName(AIndexName: string): TGDAOIndex;
var
  i: integer;
begin
  i := IndexOf(AIndexName);
  if i >= 0 then
    result := Items[i]
  else
    result := nil;
end;

function TGDAOIndexes.GetItem(i:integer):TGDAOIndex;
begin
   result:=TGDAOIndex( inherited Items[i] );
end;

procedure TGDAOIndexes.SetItem(i: integer; const Value: TGDAOIndex);
begin
   Items[i].Assign(Value);
end;

function TGDAOIndexes.OwnerDatabase: TGDD;
begin
   result:=FOwnerTable.OwnerDatabase;
end;

function TGDAOIndexes.IndexOf(AIndexName:string): integer;
begin
   for result:=0 to Count-1 do
      if CompareText(AIndexName,Items[result].IndexName)=0 then
         Exit;
   result:=-1;
end;

{ TGDAOIndexes.IRegistryKey }
{ the key is the table's index collection }
{ the sub-keys are each of the indexes in this collection }

function TGDAOIndexes.Add: TGDAOIndex;
begin
  result := TGDAOIndex(inherited Add);
  result.IID := TGDAOTables(TGDAOTable(GetOwner).Collection).OwnerDatabase.GetNextIndexID;
end;

function TGDAOIndexes.Add(AName:string): TGDAOIndex;
begin
  result := Add;
  result.IndexName := AName;
end;

function TGDAOIndexes.ValidItem(AItem: TGDAOIndex): boolean;
var c: integer;
begin
   result:=true;
   if not Assigned(AItem) then Exit;
   for c:=0 to Count-1 do
      if Items[c]=AItem then Exit;
   result:=false;
end;

function TGDAOIndexes.GetOwner: TPersistent;
begin
   result:=FOwnertable;
end;

function TGDAOIndexes.GetNewIndexName: String;

  function IndexExists(AName: string): boolean;
  var
    i: integer;
  begin
    result := IndexOf(AName) >= 0;
    if not result and (FOwnerTable <> nil) and (FOwnerTable.OwnerDatabase <> nil) then
    begin
      for i := 0 to FOwnerTable.OwnerDatabase.Tables.Count - 1 do
        if FOwnerTable.OwnerDatabase.Tables[i].Indexes.IndexOf(AName) >= 0 then
        begin
          result := true;
          break;
        end;
    end;
  end;

var
  c : Integer;
begin
  c := 0;
  Result := SNewIndexName; 
  while IndexExists(result) do
  begin
    inc(c);
    result := Format('%s_%d', [SNewIndexName, c]);
  end;
end;

function TGDAOIndexes.IndexOfIId(AIID: Integer): integer;
begin
   for result:=0 to Count-1 do
      if AIID=Items[result].IID then
         exit;
   result:=-1;
end;

{ TGDAOIndex }

procedure TGDAOIndex.Assign(Source: TPersistent);
begin
   IndexName  := TGDAOIndex(Source).IndexName;
   IndexType  := TGDAOIndex(Source).IndexType;
   IndexOrder := TGDAOIndex(Source).IndexOrder;
   IID        := TGDAOIndex(Source).IID;
   IFields    := TGDAOIndex(Source).IFields;
end;

constructor TGDAOIndex.Create(ACollection:TCollection);
begin
   inherited Create( ACollection );
   FIFields := TGDAOIFields.Create(self);
end;

constructor TGDAOIndex.CreateFromTable(AOwnerTable: TGDAOTable);
begin
  FOwnerTable := AOwnerTable;
  Create(nil);
end;

destructor TGDAOIndex.Destroy;
var
  r: integer;
begin
  // index destroy: update relationships
  with OwnerDatabase.Relationships do
  begin
    for r := 0 to Count-1 do
      if Items[r].ParentIndex = Self then
        Items[r].ParentIndex := nil;
  end;

  FIFields.Free;
  inherited;
end;

function TGDAOIndex.TableName: string;
begin
  if OwnerTable <> nil then
    result := OwnerTable.TableName
  else
    result := '';
end; 

function TGDAOIndex.OwnerDatabase:TGDD;
begin
  result := OwnerTable.OwnerDatabase;
end;

procedure TGDAOIndex.SetIFields(const Value: TGDAOIFields );
begin
   FIFields.Assign(Value);
end;

function TGDAOIndex.OwnerTable: TGDAOTable;
begin
  if (Collection <> nil) then
    result := TGDAOIndexes(Collection).FOwnerTable
  else
  if FOwnerTable <> nil then
    result := FOwnerTable
  else
    result := nil;
end;

function TGDAOIndex.HasField(AField: TGDAOField): boolean;
{ checks whether a field is part of the index }
var
  i: integer;
begin
  if AField <> nil then
    with IFields do
      for i := 0 to Count - 1 do
         if Field[i] = AField then
         begin
            result:=true;
            exit;
         end;
   result := false;
end;

function TGDAOIndex.GetDisplayName: string;
begin
   if IndexName = '' then
      Result := inherited GetDisplayName
   else
      result:=IndexName;
end;

function TGDAOIndex.GetIsPrimary: boolean;
begin
  result := FOwnerTable <> nil;
end;

function TGDAOIndex.GetTableAvailableFieldsList: TList;
var i : Integer;
begin
  Result := TList.Create;
  for i := 0 to OwnerTable.Fields.Count-1 do
    if IFields.IndexOf( OwnerTable.Fields.Items[i].FieldName ) < 0 then
      Result.Add( OwnerTable.Fields.Items[i] );
end;

{ TGDAOFields }

constructor TGDAOFields.Create( AOwnerTable:TGDAOTable );
begin
   inherited Create( TGDAOField );
   FOwnerTable:=AOwnerTable;
end;

function TGDAOFields.GetItem(i:integer):TGDAOField;
begin
   result:=TGDAOField( inherited Items[i] );
end;

function TGDAOFields.Add: TGDAOField;
begin
  result := TGDAOField(inherited Add);
  result.UpdateId;
end;

function TGDAOFields.Add( AFieldName:string; ADataType:TGDAODataType; ASize, ASize2:integer;ARequired:boolean ):TGDAOField;
begin
   result := Add;
   with result do
   begin
      FieldName:=AFieldName;
      Size:=ASize;
      Size2:=ASize2;
      Required:=ARequired;
      if ADataType <> nil then
      begin
        DataTypeName := ADataType.Name;
      end;
   end;
end;

procedure TGDAOFields.SetItem(i: integer; const Value: TGDAOField);
begin
   Items[i].Assign(Value);
end;

function TGDAOFields.IndexOf(AFieldName: string): integer;
begin
   for result:=0 to Count-1 do
      if CompareText(AFieldName,Items[result].FieldName)=0 then
         Exit;
   result:=-1;
end;

function TGDAOFields.ValidItem(AItem: TGDAOField): boolean;
var c: integer;
begin
   result:=true;
   if not Assigned(AItem) then Exit;
   for c:=0 to Count-1 do
      if Items[c]=AItem then Exit;
   result:=false;
end;

function TGDAOFields.GetOwner: TPersistent;
begin
   result:=FOwnerTable;
end;

function TGDAOFields.IndexOfFid(AFID: integer): integer;
begin
   for result:=0 to Count-1 do
      if AFID=Items[result].FID then
         exit;
   result:=-1;
end;

function TGDAOFields.GetNewFieldName(ABaseName: string = ''): String;
var
  c : Integer;
begin
  c := 0;
  if ABaseName = '' then                           
    ABaseName := SNewFieldName;

  result := ABaseName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d', [ABaseName, c]);
  end;
end;

function TGDAOFields.FindByID(AFID: integer): TGDAOField;
var
  i: integer;
begin
   i := IndexOfFid(AFID);
   if i > -1 then
      result := Items[i]
   else
      result := nil;
end;

function TGDAOFields.FindbyName(AFieldName: String): TGDAOField;
var i : Integer;
begin
  Result := nil;
  for i := 0 to count-1 do
    if CompareText(AFieldName, Items[i].FieldName) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

{ TGDAOField }

procedure TGDAOField.Assign(Source: TPersistent);
begin
  FieldName := TGDAOField(Source).FieldName;
  DataTypeName := TGDAOField(Source).DataTypeName;
  Size := TGDAOField(Source).Size;
  Size2 := TGDAOField(Source).Size2;
  Description := TGDAOField(Source).Description;
  DefaultValue := TGDAOField(Source).DefaultValue;
  Required := TGDAOField(Source).Required;
  FID := TGDAOField(Source).FID;
  DomainName := TGDAOField(Source).DomainName;
  DefaultValueSpecific := TGDAOField(Source).DefaultValueSpecific;
  RequiredSpecific := TGDAOField(Source).RequiredSpecific;
  Expression := TGDAOField(Source).Expression;
  ConstraintExpr := TGDAOField(Source).ConstraintExpr;
  ConstraintName := TGDAOField(Source).ConstraintName;
  ConstraintExprSpecific := TGDAOField(Source).ConstraintExprSpecific;
  ConstraintDefaultName := TGDAOField(Source).ConstraintDefaultName;
  ConstraintNotNullName := TGDAOField(Source).ConstraintNotNullName;
  SeedValue := TGDAOField(Source).SeedValue;
  IncrementValue := TGDAOField(Source).IncrementValue;
  GeneratedByRelationship := TGDAOField(Source).GeneratedByRelationship;
  FieldCaption := TGDAOField(Source).FieldCaption;
  Restriction := TGDAOField(Source).Restriction;
end;

function TGDAOField.CompatibleForRelationship(ChildField: TGDAOField): boolean;
var
  D1, D2: TGDAODataType;
begin
  Result := false;
  if ChildField <> nil then
  begin
    D1 := Self.DataType;
    D2 := ChildField.DataType;
    Result := (D1.NativeDataType = D2.NativeDataType) and
      (not D1.SizeIsRequired or (Self.Size = ChildField.Size)) and
      (not D1.Size2IsRequired or (Self.Size2 = ChildField.Size2));
  end;
end;

constructor TGDAOField.Create(ACollection: TCollection);
begin
   inherited Create(ACollection);
   FRestriction := frNone;
   FSeedValue := 0;
   FIncrementValue := 1;
//   FRequiredSpecific := True;
end;

function TGDAOField.OwnerDatabase: TGDD;
begin
  result := nil;
  if OwnerTable <> nil then
    result := OwnerTable.OwnerDatabase;
end;

function TGDAOField.OwnerTable: TGDAOTable;
begin
  result := nil;
  if (Collection <> nil) and (Collection is TGDAOFields) then
    result := TGDAOFields(Collection).FOwnerTable;
end;

destructor TGDAOField.Destroy;
begin
  if OwnerTable <> nil then
    OwnerTable.FieldDestroyed(Self);
  inherited;
end;

procedure TGDAOField.SetDataType(const Value: TGDAODataType);
begin
  if Value <> FDataType then
  begin
    FDataType := Value;

    {Apply default size values, but only if size is 0}
    if Assigned(FDataType) then
    begin
      if not FDataType.SizeIsRequired then
        Size := 0
      else
        if Size = 0 then
          Size := FDataType.DefaultSize;

      if not FDataType.Size2IsRequired then
        Size2 := 0
      else
        if Size2 = 0 then
          Size2 := FDataType.DefaultSize2;
    end;
  end;
end;

procedure TGDAOField.SetDataTypeName(const Value: String);
var
  obj: TGDAODataType;
begin
  if OwnerDatabase <> nil then
  begin
    obj := OwnerDatabase.DataTypes.FindByName(Value);
    if Assigned(obj) then
    begin
      if obj <> FDataType then
        DataType := obj;
    end
    else
      raise EGUIException.Create('Cannot find datatype: ' + Value);
  end
  else
    raise EGUIException.Create('Cannot find datatype: ' + Value);
end;

procedure TGDAOField.SetDefaultValue(const Value: string);
begin
   FDefaultValue := Value;
end;

function TGDAOField.GetDisplayName: string;
begin
   if FieldName = '' then
      Result := inherited GetDisplayName
   else
      result:=FieldName;
end;

function TGDAOField.GetDataTypeName: String;
begin
  Result := '';
  if Assigned(DataType) then
    Result := DataType.Name;
end;

function TGDAOField.GetDomainName: String;
begin
  Result := '';
  if Assigned(FDomain) then
    Result := FDomain.Name
  else
    result := FDomainName;
end;

function TGDAOField.GetFieldCaption: string;
begin
  if FFieldCaption > '' then
    result := FFieldCaption
  else
    result := FFieldName;
end;

procedure TGDAOField.SetDomain(const Value: TGDAODomain);
begin
  if FDomain <> Value then
  begin
    if Value = nil then
      AssignDomainInternalFields(FDomain);
    FDomain := Value;
  end;
end;

procedure TGDAOField.SetDomainName(const AValue: String);
begin
  if OwnerDatabase <> nil then
    Domain := OwnerDatabase.Domains.FindByName(AValue);
end;

function TGDAOField.GetDefaultValue: String;
begin
  if Assigned(FDomain) and not DefaultValueSpecific then
  begin
    if ((OwnerDatabase <> nil) and Assigned(OwnerDatabase.DatabaseType)
      and OwnerDatabase.DatabaseType.EnableDefaultInDomains) or not FDomain.InDatabase then
      Result := FDomain.DefaultValue
    else
      Result := '';
  end
  else
    Result := FDefaultValue;
end;

function TGDAOField.GetSize: Integer;
begin
  if FDomain <> nil then
    Result := FDomain.Size
  else
    result := FSize;
end;

function TGDAOField.GetSize2: Integer;
begin
  if FDomain <> nil then
    Result := FDomain.Size2
  else
    result := FSize2;
end;

function TGDAOField.GetDataType: TGDAODataType;
begin
  if FDomain <> nil then
    Result := FDomain.DataType
  else
    Result := FDataType;
end;

function TGDAOField.IsDefaultValueEnabled: Boolean;
begin
  Result := ( (not Assigned(FDomain)) or (DefaultValueSpecific) );
end;

procedure TGDAOField.AssignDomainInternalFields(ADomain: TGDAODomain);
begin
  if Assigned(ADomain) then
  begin
    FDataType := ADomain.DataType;
    FSize := ADomain.Size;
    FSize2 := ADomain.Size2;
    FSeedValue := ADomain.SeedValue;
    FIncrementValue := ADomain.IncrementValue;
    if not DefaultValueSpecific then
      FDefaultValue := ADomain.DefaultValue;
    FDefaultValueSpecific := false;
    if not RequiredSpecific then
      FRequired := ADomain.Required;
    FRequiredSpecific := False;
    if not ConstraintExprSpecific then
      FConstraintExpr := ADomain.ConstraintExpr;
    FConstraintExprSpecific := false;
  end;
end;

function TGDAOField.GetConstraintExpr: String;
begin
  if Assigned(FDomain) and not ConstraintExprSpecific then
  begin
    if ((OwnerDatabase <> nil) and Assigned(OwnerDatabase.DatabaseType)
      and OwnerDatabase.DatabaseType.EnableConstraintInDomains) or not FDomain.InDatabase then
      Result := FDomain.ConstraintExpr
    else
      Result := '';
  end
  else
    result := FConstraintExpr;
end;

function TGDAOField.IsConstraintExprEnabled: Boolean;
begin
  Result := ( (not Assigned(FDomain)) or (ConstraintExprSpecific) );
end;

function TGDAOField.IsForeignKey(AParents: TRelationshipList): boolean;
var
  i: integer;
begin
  result := False;
  if AParents <> nil then
    AParents.Clear;

  if (Collection <> nil) and (Collection is TGDAOFields) and
    (TGDAOFields(Collection).OwnerTable <> nil) and
    (TGDAOFields(Collection).OwnerTable.OwnerDatabase <> nil) and
    (TGDAOFields(Collection).OwnerTable.OwnerDatabase.Relationships <> nil) then
  with TGDAOFields(Collection).OwnerTable.OwnerDatabase.Relationships do
  begin
    for i := 0 to Count - 1 do
      if Items[i].FieldLinks.IndexOfChildField(Self) >= 0 then
      begin
        result := True;
        if AParents <> nil then
          AParents.Add(Items[i])
        else
          break;
      end;
  end;
end;

function TGDAOField.IsRelationshipParentKey: boolean;
var
  i: integer;
begin
  result := False;

  with TGDAOFields(Collection).OwnerTable.OwnerDatabase.Relationships do
  begin
    for i := 0 to Count - 1 do
      if Items[i].FieldLinks.IndexOfParentField(Self) >= 0 then
      begin
        result := True;
        break;
      end;
  end;
end;

function TGDAOField.IsRequiredEnabled: boolean;
var
  RequiredComesFromDomain: Boolean;
begin
  RequiredComesFromDomain := Assigned(FDomain) and not RequiredSpecific;
  RequiredComesFromDomain := RequiredComesFromDomain and
    (
    ((OwnerDatabase <> nil) and Assigned(OwnerDatabase.DatabaseType)
      and OwnerDatabase.DatabaseType.EnableNotNullInDomains) or not FDomain.InDatabase
    );
  Result := (not RequiredComesFromDomain and not InPrimaryKey) or RequiredSpecific;
end;

function TGDAOField.IsInRelationship: boolean;
begin
  result := IsForeignKey or IsRelationshipParentKey;
end;

procedure TGDAOField.SetFieldCaption(const Value: string);
begin
  FFieldCaption := Value;
end;

procedure TGDAOField.SetFieldName(const AName: String);
var idx, i : Integer;
begin
  if FFieldName <> AName then
  begin

    { Check if the field is parent key of a relationship. If yes, and the child field
     was generated automatically, and child field had same name of parent field,
     then rename child field }
    with OwnerDatabase.Relationships do
      for i := 0 to Count-1 do
      begin
        idx := Items[i].FieldLinks.IndexOfParentField(Self);
        if idx > -1 then
        begin
          if (Items[i].FieldLinks[idx].ChildField <> nil) and Items[i].FieldLinks[idx].ChildField.GeneratedByRelationship
           and (Items[i].FieldLinks[idx].ChildField.FieldName = FFieldName) then
            Items[i].FieldLinks[idx].ChildField.FieldName := AName;
        end;
      end;

    FFieldName := AName;

    if (OwnerTable <> nil) and (OwnerDatabase <> nil) then
      OwnerTable.OwnerDatabase.FieldNameChanged(Self);
  end;
end;

procedure TGDAOField.SetInPrimaryKey(const AValue: Boolean);
begin
  {update primary key}
  if (OwnerTable <> nil) and (OwnerTable.PrimaryKeyIndex <> nil) then
  begin
    {Add or remove the field to/from primary key}
    if AValue then
    begin
      {Add the field to primary key}
      if not OwnerTable.PrimaryKeyIndex.HasField(Self) then
        OwnerTable.PrimaryKeyIndex.IFields.Add.Field := Self;
    end
    else
    begin
      {Remove field from primary key}
      if OwnerTable.PrimaryKeyIndex.IFields.FindByField(Self) <> nil then
        OwnerTable.PrimaryKeyIndex.IFields.FindByField(Self).Free;
    end;
  end;
end;

function TGDAOField.StoreFieldCaption: Boolean;
begin
  result := (FFieldCaption > '') and (FFieldCaption <> FFieldName);
end;

procedure TGDAOField.UpdateId;
begin
  FID := OwnerDatabase.GetNextFieldID;
end;

function TGDAOField.GetIncrementValue: Integer;
begin
  if FDomain <> nil then
    Result := FDomain.IncrementValue
  else
    result := FIncrementValue;
end;

function TGDAOField.GetInPrimaryKey: Boolean;
begin
  result := (OwnerTable <> nil) and (OwnerTable.PrimaryKeyIndex <> nil) and
    (OwnerTable.PrimaryKeyIndex.HasField(Self));
end;

function TGDAOField.GetRequired: boolean;
begin
  if InPrimaryKey and not RequiredSpecific then
    Result := True
  else
  if Assigned(FDomain) and not RequiredSpecific then
  begin
    if ((OwnerDatabase <> nil) and Assigned(OwnerDatabase.DatabaseType)
      and OwnerDatabase.DatabaseType.EnableNotNullInDomains) or not FDomain.InDatabase then
      Result := FDomain.Required
    else
      Result := FRequired;
  end
  else
    Result := FRequired;
end;

function TGDAOField.GetRestriction: TFieldRestriction;
begin
  result := FRestriction;
end;

function TGDAOField.GetSeedValue: Integer;
begin
  if FDomain <> nil then
    Result := FDomain.SeedValue
  else
    result := FSeedValue;
end;

function TGDAOField.GetGridDataTypeName: string;
begin
  // result : data_type_name(size1, size2)
  if Domain <> nil then
    result := DomainName
  else
  begin
    Result := DataTypeName;
    if DataType.SizeIsRequired then
    begin
      Result := Result + Format('(%d',[Size]);
      if DataType.Size2IsRequired then
        Result := Result + Format(',%d',[Size2]);
      Result := Result +  ')';
    end;
  end;
end;

{ TGDAOIFields }

function TGDAOIFields.Add(AFieldName: string): TGDAOIField;
begin
   result := Add;
   result.FieldName := AFieldName;
end;

function TGDAOIFields.Add: TGDAOIField;
begin
  result := TGDAOIField(inherited Add);
end;

function TGDAOIFields.Add(AField: TGDAOField; AOrder: TIndexFieldOrder): TGDAOIField;
begin
   result := Add;
   with result do
   begin
    Field := AField;
    FieldOrder := AOrder;
   end;
end;

constructor TGDAOIFields.Create(AOwnerIndex: TGDAOIndex);
begin
   inherited Create( TGDAOIField );
   FOwnerIndex:=AOwnerIndex;
end;

function TGDAOIFields.FindByField(AField: TGDAOField): TGDAOIField;
var
  c: integer;
begin
  for c := 0 to Count - 1 do
    if Items[c].Field = AField then
    begin
      result := Items[c];
      exit;
    end;
  result := nil;
end;

function TGDAOIFields.GetField(i: integer): TGDAOField;
begin
   result:=TGDAOIField( inherited Items[i] ).Field;
end;

function TGDAOIFields.GetItem(i: integer): TGDAOIField;
begin
   result:=TGDAOIField( inherited Items[i] );
end;

function TGDAOIFields.GetOwner: TPersistent;
begin
   result:=FOwnerIndex;
end;

function TGDAOIFields.IndexOf(AFieldName: string): integer;
begin
   for result:=0 to Count-1 do
      if CompareText(Items[result].FieldNAme,AFieldName)=0 then
         Exit;
   result:=-1;
end;

procedure TGDAOIFields.RemoveField(AField: TGDAOField);
var
  IField: TGDAOIField;
begin
  IField := FindByField(AField);
  if IField <> nil then
    IField.Free;
end;

procedure TGDAOIFields.SetField(i: integer; const Value: TGDAOField);
begin
   TGDAOIField( inherited Items[i] ).Field:=Value;
end;

procedure TGDAOIFields.SetItem(i: integer; const Value: TGDAOIField);
begin
   TGDAOIField(inherited Items[i]).Assign( Value );
end;

{ TGDAOIField }

function TGDAOIField.GetFieldIndex: integer;
begin
   if Assigned(FField) then
      result := FField.Index
   else
      result := -1;
end;

function TGDAOIField.GetFieldName: string;
begin
   if Assigned(FField) then
      result:=FField.FieldName
   else
      result:='';
end;

procedure TGDAOIField.Assign(Source: TPersistent);
begin
  FieldIndex := TGDAOIField(Source).FieldIndex;
  FieldOrder := TGDAOIField(Source).FieldOrder;
  KeyByRelationship := TGDAOIField(Source).KeyByRelationship;
end;

destructor TGDAOIField.Destroy;
begin
  // index destroy: update relationships
  SetField(nil);

  inherited;
end;

function TGDAOIField.GetDisplayName: string;
begin
   if not Assigned(FField) then
      Result := inherited GetDisplayName
   else
      result:=FField.Fieldname;
end;

function TGDAOIField.OwnerIndex: TGDAOIndex;
begin
  result := TGDAOIFields(Collection).FOwnerIndex;
end;

function TGDAOIField.OwnerTable: TGDAOTable;
begin
   result:=TGDAOIFields(Collection).FOwnerIndex.OwnerTable;
end;

procedure TGDAOIField.SetField(const Value: TGDAOField);
var
  r: integer;
  fChild: TGDAOField;
  idx: integer;
  OldField: TGDAOField;
begin
  OldField := FField;
  FField := Value;

  if Assigned(OldField) then
  begin
    with OwnerIndex.OwnerDatabase.Relationships do
    begin
      for r := 0 to Count - 1 do
        if (Items[r].ParentTable = OwnerIndex.OwnerTable) and (Items[r].ParentIndex = OwnerIndex) then
        begin
          idx := Items[r].FieldLinks.IndexOfParentField(OldField);
          if (idx > -1) then
            Items[r].FieldLinks.Delete(idx);
        end;
    end;
  end;

  {add new assigned field}
  if Assigned(FField) then
  begin
    with OwnerIndex.OwnerDatabase.Relationships do
    begin
      for r := 0 to Count - 1 do
      begin
        if (Items[r].ParentTable = OwnerIndex.OwnerTable) and (Items[r].ParentIndex = OwnerIndex) then
        begin
          fChild := Items[r].AutoCreateChildField(FField);

          with Items[r].FieldLinks.Add do
          begin
            ParentField := Self.FField;
            ChildField := fChild;
            Index := Self.Index;
          end;
        end;
      end;
    end;
  end;
end;

procedure TGDAOIField.SetFieldIndex(const Value: integer);
begin
   {Must set the field property, not FField field}
   if Value = -1 then
      Field := nil
   else
      Field := OwnerTable.Fields[Value];
end;

procedure TGDAOIField.SetFieldName(const Value: string);
begin
   {Must set the field property, not FField field}
   Field := OwnerTable.FieldByName(Value);
end;

{ TGDAOConstraints }

constructor TGDAOConstraints.Create(AOwnerTable:TGDAOTable);
begin
   inherited Create(TGDAOConstraint);
   FOwnerTable:=AOwnerTable;
end;

function TGDAOConstraints.FindByName(AConstraintName: string): TGDAOConstraint;
var
  i: integer;
begin
  i := IndexOf(AConstraintName);
  if i >= 0 then
    result := items[i]
  else
    result := nil;
end;

function TGDAOConstraints.Add: TGDAOConstraint;
begin
  result:=TGDAOCOnstraint( inherited Add );
  result.CID := TGDAOTables(TGDAOTable(GetOwner).Collection).OwnerDatabase.GetNextConstraintID;
end;

function TGDAOConstraints.AddConstraint(AName, AExpression: string): TGDAOConstraint;
begin
   Result := Add;
   with result do
   begin
      ConstraintName := AName;
      Expression:=AExpression;
   end;
end;

function TGDAOConstraints.GetItem(i:integer): TGDAOCOnstraint;
begin
   result:=TGDAOConstraint( inherited Items[i] );
end;

procedure TGDAOConstraints.SetItem(i:integer; const Value: TGDAOCOnstraint);
begin
   Items[i].Assign(Value);
end;

function TGDAOConstraints.GetOwner: TPersistent;
begin
   result:=FOwnerTable;
end;

function TGDAOConstraints.GetNewConstraintName: String;
var c : Integer;
begin
  c := 0;
  Result := SNewConstraintName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d', [SNewConstraintName, c]);
  end;
end;

function TGDAOConstraints.IndexOf(AConstraintName: string): integer;
begin
  for Result := 0 to Count-1 do
    if CompareText(Items[Result].ConstraintName, AConstraintName) = -0 then
      exit;
  Result := -1;
end;

function TGDAOConstraints.IndexOfCID(ACID: Integer): integer;
begin
   for result:=0 to Count-1 do
      if ACID=Items[result].CID then
         exit;
   result:=-1;
end;

{ TGDAOTriggers }

function TGDAOTriggers.Add: TGDAOTrigger;
begin
   result:=TGDAOTrigger( inherited Add );
end;

constructor TGDAOTriggers.Create(AOwnerTable: TGDAOTable);
begin
   FOwnerTable:=AOwnerTable;
   inherited Create(TGDAOTrigger);
end;

function TGDAOTriggers.FindByName(AName: string): TGDAOTrigger;
var
  i: integer;
begin
  i := IndexOf(AName);
  if i >= 0 then
    result := Items[i]
  else
    result := nil;
end;

function TGDAOTriggers.GetItem(i: integer): TGDAOTrigger;
begin
   result:=TGDAOTrigger( inherited Items[i] );
end;

function TGDAOTriggers.IndexOf(AName: string): integer;
begin
   for result:=0 to Count-1 do
      if CompareText(AName,Items[result].Name)=0 then
         Exit;
   result:=-1;
end;

procedure TGDAOTriggers.SetItem(i: integer; const Value: TGDAOTrigger);
begin
   Items[i].Assign(Value);
end;

function TGDAOTriggers.Add(AName: string; AImplementation: string): TGDAOTrigger;
begin
   result:=Add;
   with result do
   begin
      Name:=AName;
      ImplementationCode:=AImplementation;
   end;
end;

function TGDAOTriggers.GetOwner: TPersistent;
begin
   result:=FOwnerTable; 
end;

function TGDAOTriggers.GetNewTriggerName: String;
var c : Integer;
begin
  c := 0;
  Result := SNewTriggerName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d', [SNewTriggerName, c]);
  end;
end;

{ TGDAOTrigger }

procedure TGDAOTrigger.Assign(Source: TPersistent);
begin                                         
   Name := TGDAOTrigger(Source).Name;
   Description := TGDAOTrigger(Source).Description;
   ImplementationCode := TGDAOTrigger(Source).ImplementationCode;
end;

constructor TGDAOTrigger.Create(ACollection: TCollection);
begin
   inherited Create(ACollection);
end;

function TGDAOTrigger.GetDisplayName: string;
begin
   if Name = '' then
      Result := inherited GetDisplayName
   else
      result := Name;
end;

function TGDAOTrigger.GetTable: TGDAOTable;
begin
   if TGDAOTriggers(Collection).OwnerTable<>nil then
      result:=TGDAOTriggers(Collection).OwnerTable
   else
      result:=nil;
end;

function TGDAOTrigger.GetTableName: string;
begin
   if TGDAOTriggers(Collection).OwnerTable<>nil then
      result := TGDAOTriggers(Collection).OwnerTable.TableName
   else
      result:='';
end;

function TGDAOTrigger.OwnerDatabase: TGDD;
begin
   result := TGDAOTriggers(Collection).OwnerTable.OwnerDatabase;
end;

function TGDAOTrigger.OwnerTable: TGDAOTable;
begin
   result:=TGDAOTriggers(Collection).FOwnerTable;
end;

{ TGDAODataTypes }

function TGDAODataTypes.Add: TGDAODataType;
begin
  Result := TGDAODataType(inherited Add);
end;

constructor TGDAODataTypes.Create(AOwnerDatabase: TGDD);
begin
  FOwnerDatabase := AOwnerDatabase;
  inherited Create(TGDAODataType);
end;

function TGDAODataTypes.GetItem(i: integer): TGDAODataType;
begin
  Result := TGDAODataType(inherited Items[i]);
end;

function TGDAODataTypes.GetOwner: TPersistent;
begin
  Result := FOwnerDatabase;
end;

function TGDAODataTypes.FindByName(AName: String): TGDAODataType;
var i : Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if CompareText(Items[i].Name, AName) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TGDAODataTypes.FindByType(AType: TNativeDataType; ASubType: TNativeSubType): TGDAODataType;
var i: integer;
begin
  result := nil;
  for i := 0 to Count - 1 do
    if (AType = Items[i].NativeDataType) and
      ((ASubType = stUnknown) or (ASubType = Items[i].NativeSubType)) then
    begin
      result := Items[i];
      break;
    end;
end;

procedure TGDAODataTypes.SetItem(i: integer; const Value: TGDAODataType);
begin
   Items[i].Assign(Value);
end;

function TGDAODataTypes.Add( AName, APhysical: String; FSizeReq, FSize2Req: Boolean;
                             ANativeDataType: TNativeDataType; ANativeSubType: TNativeSubType;
                             ACounter: Boolean = false; ASeed: Boolean = false;
                             AIncrement: Boolean = False): TGDAODataType;
begin
  Result := Add;
  with Result do
  begin
    Name := AName;
    Physical := APhysical;
    SizeIsRequired := FSizeReq;
    Size2IsRequired := FSize2Req;
    Counter := ACounter;
    SeedIsRequired := ASeed;
    IncrementIsRequired := AIncrement;
    NativeDataType := ANativeDataType;
    NativeSubType := ANativeSubType;
  end;
end;

function TGDAODataTypes.GetDefaultDataType: TGDAODataType;
var i: integer;
begin
  for i:=0 to Count-1 do
    if (Items[i].NativeDataType = naInteger) and (Items[i].NativeSubType = stInteger) then
    begin
      result := Items[i];
      exit;
    end;
  if Count > 0 then
    result := Items[0]
  else
    result := nil;
end;

{ TGDAODomains }

function TGDAODomains.Add: TGDAODomain;
begin
  Result := TGDAODomain(inherited Add);
end;

constructor TGDAODomains.Create(AOwnerDatabase: TGDD);
begin
  FOwnerDatabase := AOwnerDatabase;
  inherited Create(TGDAODomain);
end;

function TGDAODomains.FindByName(AName: String): TGDAODomain;
var i : Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if CompareText(Items[i].Name, AName) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TGDAODomains.GetItem(i: integer): TGDAODomain;
begin
  Result := TGDAODomain(inherited Items[i]);
end;

function TGDAODomains.GetNewDomainName: String;
var c : Integer;
begin
  c := 0;
  Result := SNewDomainName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d', [SNewDomainName, c]);
  end;
end;

function TGDAODomains.GetOwner: TPersistent;
begin
  Result := FOwnerDatabase;
end;

function TGDAODomains.IndexOf(AName: String): Integer;
begin
  for Result := 0 to count - 1 do
    if CompareText(Items[Result].Name, AName) = 0 then
      Exit; 

  Result := -1;
end;

procedure TGDAODomains.SetItem(i: integer; const Value: TGDAODomain);
begin
   Items[i].Assign(Value);
end;

{ TGDAODomain }

procedure TGDAODomain.Assign(Source: TPersistent);
begin
  Name           := TGDAODomain(Source).Name;
  ConstraintExpr := TGDAODomain(Source).ConstraintExpr;
  DataTypeName   := TGDAODomain(Source).DataTypeName;
  Size           := TGDAODomain(Source).Size;
  Size2          := TGDAODomain(Source).Size2;
  DefaultValue   := TGDAODomain(Source).DefaultValue;
  Information    := TGDAODomain(Source).Information;
  SeedValue      := TGDAODomain(Source).SeedValue;
  IncrementValue := TGDAODomain(Source).IncrementValue;
  InDatabase     := TGDAODomain(Source).InDatabase;
  Required       := TGDAODomain(Source).Required;
end;

constructor TGDAODomain.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FSeedValue := 0;
  FIncrementValue := 1;
end;

destructor TGDAODomain.Destroy;
var
  AFldList: TObjectList;
  c: integer;
begin
  AFldList := TObjectList.Create(false);
  try
    FillUsedFields(AFldList);
    for c := 0 to AFldList.Count - 1 do
      TGDAOField(AFldList[c]).Domain := nil;
  finally
    AFldList.Free;
  end;
  inherited;
end;

function TGDAODomain.GetDataTypeName: String;
begin
  Result := '';
  if Assigned(FDataType) then
    Result := FDatatype.Name;
end;

function TGDAODomain.GetInDatabase: boolean;
begin
  Result := FInDatabase;
  if (OwnerDatabase <> nil) and (OwnerDatabase.DatabaseType <> nil) then
    result := result and OwnerDatabase.DatabaseType.EnableDomainsInDatabase;
end;

function TGDAODomain.IsBeingUsed: boolean;
var
  AFldList: TObjectList;
begin
  AFldList := TObjectList.Create(false);
  try
    FillUsedFields(AFldList);
    result := AFldList.Count > 0;
  finally
    AFldList.Free;
  end;
end;

function TGDAODomain.IsInRelationship: boolean;
var
  AFldList: TObjectList;
  c: Integer;
begin
  result := false;
  AFldList := TObjectList.Create(false);
  try
    FillUsedFields(AFldList);
    for c := 0 to AFldList.Count - 1 do
      if TGDAOField(AFldList[c]).IsInRelationship then
      begin
        result := true;
        break;
      end;
  finally
    AFldList.Free;
  end;
end;

procedure TGDAODomain.FillUsedFields(AFieldList: TObjectList);
var
  i, j: integer;
begin
  AFieldList.Clear;
  if (OwnerDatabase <> nil) then
    for i := 0 to OwnerDatabase.Tables.Count - 1 do
      for j := 0 to OwnerDatabase.Tables[i].Fields.count - 1 do
        if OwnerDatabase.Tables[i].Fields[j].Domain = Self then
          AFieldList.Add(OwnerDatabase.Tables[i].Fields[j]);
end;

function TGDAODomain.OwnerDatabase: TGDD;
begin
  if (Collection is TGDAODomains) then
    result := TGDAODomains(Collection).FOwnerDatabase
  else
    result := nil;
end;

procedure TGDAODomain.SetDataType(const Value: TGDAODataType);
begin
  if Value <> FDataType then
  begin
    FDataType := Value;

    {Apply default size values, but only if size is 0}
    if Assigned(FDataType) then
    begin
      if not FDataType.SizeIsRequired then
        Size := 0
      else
        if Size = 0 then
          Size := FDataType.DefaultSize;

      if not FDataType.Size2IsRequired then
        Size2 := 0
      else
        if Size2 = 0 then
          Size2 := FDataType.DefaultSize2;
    end;
  end;
end;

procedure TGDAODomain.SetDataTypeName(const Value: String);
var
  obj: TGDAODataType;
begin
  if OwnerDatabase <> nil then
  begin
    obj := OwnerDatabase.DataTypes.FindByName(Value);
    if Assigned(obj) then
    begin
      if obj <> DataType then
        DataType := obj;
    end
    else
      raise EGUIException.Create('Cannot find datatype: ' + Value);
  end else
    raise EGUIException.Create('Cannot find datatype: ' + Value);
end;

{ TGDAODataType }

procedure TGDAODataType.Assign(Source: TPersistent);
begin
  Name := TGDAODataType(Source).Name;
  Physical := TGDAODataType(Source).Physical;
  SizeIsRequired := TGDAODataType(Source).SizeIsRequired;
  Size2IsRequired := TGDAODataType(Source).Size2IsRequired;
  Counter := TGDAODataType(Source).Counter;
  SeedIsRequired := TGDAODataType(Source).SeedIsRequired;
  IncrementIsRequired := TGDAODataType(Source).IncrementIsRequired;
  ForeignDataTypeName := TGDAODataType(Source).ForeignDataTypeName;
  NativeDataType := TGDAODataType(Source).NativeDataType;
  NativeSubType := TGDAODataType(Source).NativeSubType;
  Computed := TGDAODataType(Source).Computed;
  CheckSize := TGDAODataType(Source).CheckSize;
  MinSize := TGDAODataType(Source).MinSize;
  MaxSize := TGDAODataType(Source).MaxSize;
  DefaultSize := TGDAODataType(Source).DefaultSize;
  DefaultSize2 := TGDAODataType(Source).DefaultSize2;
end;

function TGDAODataType.BuildPhysicalExpression(AField: TGDAOField): String;
begin
  if AField <> nil then
  begin
    if (AField.Domain <> nil) and (AField.Domain.InDatabase) then
      result := AField.Domain.Name
    else
    if Computed then
      Result := AField.Expression
    else
    begin
      Result := Physical;
      if SizeIsRequired then
        Result := StringReplace(Result, '%s%', inttostr(AField.Size), [rfReplaceAll]);
      if Size2IsRequired then
        Result := StringReplace(Result, '%p%', inttostr(AField.Size2), [rfReplaceAll]);
      if SeedIsRequired then
        Result := StringReplace(Result, '%e%', inttostr(AField.SeedValue), [rfReplaceAll]);
      if IncrementIsRequired then
        Result := StringReplace(Result, '%i%', inttostr(AField.IncrementValue), [rfReplaceAll]);
    end;
  end else
    result := '';
end;

function TGDAODataType.BuildPhysicalExpression(ADomain: TGDAODomain): string;
begin
  if Computed then
    Result := ''
  else
  begin
    Result := Physical;
    if SizeIsRequired then
      Result := StringReplace(Result, '%s%', inttostr(ADomain.Size), [rfReplaceAll]);
    if Size2IsRequired then
      Result := StringReplace(Result, '%p%', inttostr(ADomain.Size2), [rfReplaceAll]);
    if SeedIsRequired then
      Result := StringReplace(Result, '%e%', inttostr(ADomain.SeedValue), [rfReplaceAll]);
    if IncrementIsRequired then
      Result := StringReplace(Result, '%i%', inttostr(ADomain.IncrementValue), [rfReplaceAll]);
  end;
end;

function TGDAODataType.CheckSizeStored: boolean;
begin
  result := FCheckSize;
end;

function TGDAODataType.DefinesPrimaryKey: boolean;
begin
  Result := Pos('PRIMARY KEY', Uppercase(Physical)) > 0;
end;

function TGDAODataType.GetForeignDataType: TGDAODataType;
begin
  Result := self;
  if FForeignDataType <> nil then
    Result := FForeignDataType;
end;

function TGDAODataType.GetForeignDataTypeName: String;
begin
  Result := '';
  if (FForeignDataType <> nil) and (Assigned(FForeignDataType)) then
    Result := FForeignDataType.Name;
end;

procedure TGDAODataType.SetForeignDataTypeName(const AName: String);
begin
  FForeignDataType := TGDAODataTypes(Collection).FindByName(AName);
end;

procedure TGDAODataType.SetSizeSettings(ADefaultSize, ADefaultSize2: integer;
  ACheckSize: boolean; AMinSize, AMaxSize: integer);
begin
  FDefaultSize := ADefaultSize;
  FDefaultSize2 := ADefaultSize2;
  FCheckSize := ACheckSize;
  FMinSize := AMinSize;
  FMaxSize := AMaxSize;
end;

{ TGDAOCategories }

function TGDAOCategories.Add(AType: TGDAOCategoryType; ANameS, ANameP: String;
  ACreate, ADrop: String): TGDAOCategory;
begin
  Result := TGDAOCategory(inherited Add);
  with Result do
  begin
    CategoryType := AType;
    CategoryNameP := ANameP;
    CategoryNameS := ANameS;
    CreateTemplate := ACreate;
    DropTemplate   := ADrop;
  end;
end;

constructor TGDAOCategories.Create(AOwnerDatabase: TGDD);
begin
  FOwnerDatabase := AOwnerDatabase;
  inherited Create(TGDAOCategory);
end;

function TGDAOCategories._FindByNameP(AName: String): TGDAOCategory;
var i : Integer;
begin
  Result := nil;
  for i := 0 to Count-1 do
    if CompareText(Items[i].CategoryNameP, AName) = 0 then
    begin
      Result := Items[i];
      Break;
    end;
end;

function TGDAOCategories.FindByType(AType: TGDAOCategoryType): TGDAOCategory;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if Items[i].CategoryType = AType then
    begin
      Result := Items[i];
      Break;
    end;
end;

function TGDAOCategories.GetItem(i: integer): TGDAOCategory;
begin
  Result := TGDAOCategory(inherited Items[i]);
end;

(*function TGDAOCategories.GetNewCategoryName: String;
var c : Integer;
begin
  c := 0;
  Result := SNewCategoryName;
  while IndexOf(Result) > -1 do
  begin
    inc(c);
    result := Format('%s_%d', [SNewCategoryName, c]);
  end;
end;*)

function TGDAOCategories.GetOwner: TPersistent;
begin
  Result := FOwnerDatabase;
end;

procedure TGDAOCategories.SetItem(i: integer; const Value: TGDAOCategory);
begin
   Items[i].Assign(Value);
end;

{ TGDAOCategory }

procedure TGDAOCategory.Assign(Source: TPersistent);
begin
  CategoryType := TGDAOCAtegory(Source).CategoryType;
  Objects        := TGDAOCategory(Source).Objects;
  CategoryNameS   := TGDAOCategory(Source).CategoryNameS;
  CategoryNameP   := TGDAOCategory(Source).CategoryNameP;
  CreateTemplate := TGDAOCategory(Source).CreateTemplate;
  DropTemplate   := TGDAOCategory(Source).DropTemplate;
end;

constructor TGDAOCategory.Create(Collection: TCollection);
begin
  inherited;
  FPropDefs := TGDAOPropDefs.Create(TGDAOPropDef);
  FObjects := TGDAOObjects.Create(Self);
end;

destructor TGDAOCategory.Destroy;
begin
  FPropDefs.Free;
  FObjects.Free;
  inherited;
end;

procedure TGDAOCategory.SetObjects(const Value: TGDAOObjects);
begin
   FObjects.Assign(Value);
end;

{ TGDAOObjects }

function TGDAOObjects.Add(AName: String): TGDAOObject;
begin
  Result := TGDAOObject(inherited Add);
  Result.ObjectName := AName;
end;

constructor TGDAOObjects.Create(AOwnerCategory: TGDAOCategory);
begin
  FOwnerCategory := AOwnerCategory;
  FOwnerDatabase := TGDD(TGDAOCategories(FOwnerCategory.Collection).GetOwner);
  inherited Create(TGDAOObject);
end;

function TGDAOObjects.FindByName(AName: String): TGDAOObject;
var i : Integer;
begin
  Result := nil;
  for i := 0 to Count-1 do
    if CompareText(AName, Items[i].ObjectName)=0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TGDAOObjects.GetItem(i: integer): TGDAOObject;
begin
  Result := TGDAOObject(inherited Items[i]);
end;

function TGDAOObjects.GetNewObjectName: String;
var
  c: integer;
begin
  c := 0;
  result := 'New' + OwnerCategory.CategoryNameS;
  while IndexOf(result) > -1 do
  begin
    inc(c);
    result := Format('New%s_%d', [OwnerCategory.CategoryNameS, c]);
  end;
end;

function TGDAOObjects.GetOwner: TPersistent;
begin
  Result := FOwnerDatabase;
end;

function TGDAOObjects.IndexOf(AName: String): Integer;
begin
  for Result := 0 to Count-1 do
    if CompareText(Items[Result].ObjectName, AName) = 0 then
      exit;
  Result := -1;
end;

procedure TGDAOObjects.SetItem(i: integer; const Value: TGDAOObject);
begin
   Items[i].Assign(Value);
end;

{ TGDAOObject }

procedure TGDAOObject.Assign(Source: TPersistent);
begin
  ObjectName := TGDAOObject(Source).ObjectName;
  Description := TGDAOObject(Source).Description;
  CreateImplementation := TGDAOObject(Source).CreateImplementation;
  DropImplementation := TGDAOObject(Source).DropImplementation;
  CustomProps := TGDAOObject(Source).CustomProps;
  Restriction := TGDAOObject(Source).Restriction;
end;

constructor TGDAOObject.Create(Collection: TCollection);
begin
  inherited;
  FRestriction := orNone;
  FCustomProps := TStringList.Create;
end;

destructor TGDAOObject.Destroy;
begin
  FCustomProps.Free;
  inherited;
end;

function TGDAOObject.GetDropImplementation: String;
begin
  if OwnerCategory <> nil then
    result := OwnerCategory.DropTemplate
  else
    result := '';
end;

function TGDAOObject.GetReadOnly: boolean;
begin
  result := Restriction = orReadOnly;
end;

function TGDAOObject.GetRestriction: TObjectRestriction;
begin
  result := FRestriction;
end;

function TGDAOObject.GetVisible: boolean;
begin
  result := Restriction <> orHidden;
end;

function TGDAOObject.OwnerCategory: TGDAOCategory;
begin
  result := TGDAOObjects(Collection).OwnerCategory;
end;

function TGDAOObject.ReadProp(APropName: string): variant;
begin
  if OwnerCategory <> nil then
    result := OwnerCategory.PropDefs.ReadProp(APropName, FCustomProps)
  else
    result := NULL;
end;

procedure TGDAOObject.SetCustomProps(const Value: TStrings);
begin
  FCustomProps.Assign(Value);
end;

procedure TGDAOObject.SetReadOnly(const Value: boolean);
begin
  if Restriction <> orHidden then
    if Value then
      Restriction := orReadOnly
    else
      Restriction := orNone;
end;

procedure TGDAOObject.SetVisible(const Value: boolean);
begin
  if not Value then
    Restriction := orHidden
  else if Restriction <> orReadOnly then
    Restriction := orNone;
end;

procedure TGDAOObject.WriteProp(APropName: string; AValue: Variant);
begin
  if OwnerCategory <> nil then
    OwnerCategory.PropDefs.WriteProp(APropName, FCustomProps, AValue);
end;

{ TGDAOContainer }

constructor TGDAOContainer.Create(AOwner: TComponent);
begin
  inherited;
  FDataDictionary := TGDAODatabase.Create;
end;

destructor TGDAOContainer.Destroy;
begin
  FDataDictionary.Free;
  inherited;
end;

procedure TGDAOContainer.Loaded;
begin
  inherited;
  DataDictionary.Loaded;  
end;

procedure TGDAOContainer.SetDataDictionary(const Value: TGDAODatabase);
begin
  FDataDictionary.Assign(Value);
end;

{ TGDAOConstraint }

procedure TGDAOConstraint.Assign(Source: TPersistent);
begin
  ConstraintName := TGDAOConstraint(Source).ConstraintName;
  Expression     := TGDAOConstraint(Source).Expression;
  CID            := TGDAOConstraint(Source).CID;
end;

function TGDAOConstraint.GetDisplayName: string;
begin
  if ConstraintName = '' then
    result := inherited GetDisplayName
  else
    result := ConstraintName;
end;

function TGDAOConstraint.OwnerTable: TGDAOTable;
begin
  result := TGDAOConstraints(Collection).OwnerTable;
end;

{ TGDAORelationshipFieldLink }

procedure TGDAORelationshipFieldLink.Assign(Source: TPersistent);
begin
  ParentFieldName := TGDAORelationshipFieldLink(Source).ParentFieldName;
  ChildFieldName := TGDAORelationshipFieldLink(Source).ChildFieldName;
end;

destructor TGDAORelationshipFieldLink.Destroy;
begin
  {Restore all things to normal}
  ChildField := nil;
  inherited;
end;

function TGDAORelationshipFieldLink.GetChildField: TGDAOField;
begin
  result := FChildField;
end;

function TGDAORelationshipFieldLink.GetChildFieldName: string;
begin
  if Assigned(FChildField) then
    result := FChildField.FieldName
  else
    result := '';
end;

function TGDAORelationshipFieldLink.GetDisplayName: string;
begin
  result := Format('%s x %s', [ParentFieldName, ChildFieldName]);
end;

function TGDAORelationshipFieldLink.GetParentField: TGDAOField;
begin
  result := FParentField;
end;

function TGDAORelationshipFieldLink.GetParentFieldName: string;
begin
  if Assigned(FParentField) then
    result := FParentField.FieldName
  else
    result := '';
end;

function TGDAORelationshipFieldLink.OwnerRelationship: TGDAORelationship;
begin
  result := TGDAORelationshipFieldLinks(Collection).FRelationship;
end;

procedure TGDAORelationshipFieldLink.SetChildField(const Value: TGDAOField);
var
  AIField: TGDAOIField;
begin
  if Value <> FChildField then
  begin
    if (FChildField <> nil) then
    begin
      {If field was generated by relationship, destroy it.}
      if FChildField.GeneratedByRelationship then
        FreeAndNil(FChildField)
      else
      {if inclusion of field in primary key was generated by relationship,
      then remove field from primary key}
      if FChildField.OwnerTable <> nil then
      begin
        AIField := FChildField.OwnerTable.PrimaryKeyIndex.IFields.FindByField(FChildField);
        if (AIField <> nil) and (AIField.KeyByRelationship) then
          AIField.Free;
      end;
    end;
    
    FChildField := Value;

    {if relationship is identifying, and the new field is not part of primary key,
    then set the new field as part of primary key}
    if (FChildField <> nil) and (OwnerRelationship <> nil) and
      (OwnerRelationship.RelationshipType = ryIdentifying)
      and (OwnerRelationship.ParentTable <> OwnerRelationship.ChildTable)
      and (FChildField.OwnerTable <> nil)
      and (FChildField.OwnerTable.PrimaryKeyIndex.IFields.FindByField(FChildField) = nil) then
    begin
      if OwnerRelationship.FAutoCreatingField then
        raise ERecursiveRelException.Create('Recursive relationship. Cannot create.');

      OwnerRelationship.FAutoCreatingField := true;
      try
        {First create the field, set flag KeyByRelationship, and only after this we
         can effectively add the field. This is due to recursive stuff, if an error
         occurs when the field is set, the KeyByRelationship flag is already set,
         and then this new ifield can be automaticaly destroyed when the relationship is
         destroyed}
        AIField := FChildField.OwnerTable.PrimaryKeyIndex.IFields.Add;
        AIField.KeyByRelationship := true;
        AIField.Field := FChildField;
      finally
        OwnerRelationship.FAutoCreatingField := false;
      end;
    end;
  end;
end;

procedure TGDAORelationshipFieldLink.SetChildFieldName(const Value: string);
begin
  if Value <> ChildFieldName then
  begin
    if (OwnerRelationship <> nil) and (OwnerRelationship.ChildTable <> nil) then
      ChildField := OwnerRelationship.ChildTable.FieldByName(Value)
    else
      ChildField := nil;
  end;                  
end;

procedure TGDAORelationshipFieldLink.SetParentField(const Value: TGDAOField);
begin
  if Value <> FParentField then
  begin
    if (FParentField <> nil) and FParentField.GeneratedByRelationship then
      FParentField.Free;
    FParentField := Value;
  end;
end;

procedure TGDAORelationshipFieldLink.SetParentFieldName(const Value: string);
begin
  if Value <> ParentFieldName then
  begin
    if (OwnerRelationship <> nil) and (OwnerRelationship.ParentTable <> nil) then
      ParentField := OwnerRelationship.ParentTable.FieldByName(Value)
    else
      ParentField := nil;
  end;
end;

{ TGDAORelationshipFieldLinks }

function TGDAORelationshipFieldLinks.Add: TGDAORelationshipFieldLink;
begin
  result := TGDAORelationshipFieldLink(inherited Add);
end;

constructor TGDAORelationshipFieldLinks.Create(ARelationship: TGDAORelationship);
begin
  inherited Create(TGDAORelationshipFieldLink);
  FRelationship := ARelationship;
end;

function TGDAORelationshipFieldLinks.GetItem(i: integer): TGDAORelationshipFieldLink;
begin
  result := TGDAORelationshipFieldLink(inherited Items[i]);
end;

function TGDAORelationshipFieldLinks.GetOwner: TPersistent;
begin
  result := FRelationship;
end;

function TGDAORelationshipFieldLinks.IndexOfChildField(AField: TGDAOField): integer;
begin
  for result := 0 to Count - 1 do
    if Items[result].ChildField = AField then
      exit;
  result := -1;
end;

function TGDAORelationshipFieldLinks.IndexOfParentField(AField: TGDAOField): integer;
begin
  for result := 0 to Count - 1 do
    if Items[result].ParentField = AField then
      exit;
  result := -1;
end;

procedure TGDAORelationshipFieldLinks.SetItem(i: integer; const Value: TGDAORelationshipFieldLink);
begin
  Items[i].Assign(Value);
end;

{ TRelationshipList }

function TRelationshipList.GetItem(i: integer): TGDAORelationship;
begin
  result := TGDAORelationship(Items[i]);
end;

{ TGDAOPropDefs }

function TGDAOPropDefs.Add: TGDAOPropDef;
begin
  result := TGDAOPropDef(inherited Add);
end;

function TGDAOPropDefs.FindProp(APropName: string): TGDAOPropDef;
var
  c: integer;
begin
  result := nil;
  for c := 0 to Count - 1 do
    if SameText(APropName, Items[c].PropName) then
    begin
      result := Items[c];
      break;
    end;
end;

function TGDAOPropDefs.Add(APropName: string; AType: TGDAOPropDefType; ADefValue: Variant): TGDAOPropDef;
begin
  result := Add;
  result.PropName := APropName;
  result.DataType := AType;
  result.DefaultValue := ADefValue;
end;

function TGDAOPropDefs.GetItem(Index: integer): TGDAOPropDef;
begin
  result := TGDAOPropDef(inherited Items[Index]);
end;

procedure TGDAOPropDefs.GetPropParams(APropName: string; var AType: TGDAOPropDefType; var ADefValue: Variant);
var
  AProp: TGDAOPropDef;
begin
  {Set initial type and default value}
  AType := pdtString;
  ADefValue := NULL;

  {if the object has a property specified, then find the correct type
   and default value}
  AProp := FindProp(APropName);
  if AProp <> nil then
  begin
    AType := AProp.DataType;
    ADefValue := AProp.DefaultValue;
  end;
end;

function TGDAOPropDefs.ReadProp(APropName: string; APropValues: TStrings): Variant;
var
  AType: TGDAOPropDefType;
  ADefValue: Variant;
  i: integer;
  AStrValue: string;
begin
  {Get the type and default value of the property}
  GetPropParams(APropName, AType, ADefValue);

  {Set the default value as result}
  result := ADefValue;

  {Find the property. If found, then convert it and return the final value}
  i := APropValues.IndexOfName(APropName);
  if i >= 0 then
  begin
    AStrValue := APropValues.Values[APropName];

    {now return the property value}
    case AType of
      pdtInteger:
        result := StrToIntDef(AStrValue, ADefValue);
    else
      {default pdtString}
      result := AStrValue;
    end;
  end;
end;

function TGDAOPropDefs.WriteProp(APropName: string; APropValues: TStrings; AValue: Variant): Variant;
var
  AType: TGDAOPropDefType;
  ADefValue: Variant;
  AStrValue: string;
begin
  {Get the type and default value of the property}
  GetPropParams(APropName, AType, ADefValue);

  {Set the property value}
  case AType of
    pdtInteger:
      AStrValue := IntToStr(AValue);
    else {default pdtString}
      AStrValue := VarToStr(AValue);
  end;

  APropValues.Values[APropName] := AStrValue;
end;

end.

