unit dgConsts;

interface

uses
  Messages, SysUtils;

type
  EGUIException = class(Exception)
  end;

  TDBEngineType = (etNone, etFireDac, etAbsoluteDB, etNexusDB, etAdvantage, etElevateDB);

  TUpdateMethod = (umNone, umRestrict, umCascade, umSetNull, umSetDefault, umNoAction);
  TDeleteMethod = (dmNone, dmRestrict, dmCascade, dmSetNull, dmSetDefault, dmNoAction);

  TIndexType = ( itNone, itUnique, itUniqueKey );
  TIndexFieldOrder = ( ioAsc, ioDesc );
  TIndexOrder = (ioAscending, ioDescending);

  TGDAOFieldType = ( gfUnknown, gfAutoInc, gfInteger, gfCurrency, gfFloat, gfDateTime, gfBoolean, gfString, gfMemo, gfImage, gfBinary );

  TDefaultValue = (dvNone,dvToday,dvNow,dvLastRecord,dvPredefined,dvGlobalVar,dvSQL,dvAutoInc,dvFirstLookup);

  TGDAORelationshipType = (ryUndefined, ryIdentifying, ryNonIdentifying);

  TGDAORelationshipCardinality = (rcNone, rcOneToOne, rcOneToMany);

  TNativeDataType = ( naUnknown, naInteger, naFloat, naString, naBoolean,
                      naDateTime, naMemo, naBlob, naComputed );
  TNativeDataTypes = set of TNativeDataType;

  TNativeSubType  = (    stUnknown,
                      // naInteger
                         stInteger, stLongInt, stCounter, stSmallInt, stTinyInt, stLongCounter,
                         stSmallCounter, stTinyCounter, stTinyWord, stSmallWord, stWord, stMediumInt,
                         stMediumCounter, 
                      // naString
                         stString, stChar, stNChar, stNVarChar, stSysName, stRowID, stURowID,
                         stTinyText, stCIChar, stGeneric,
                      // naBoolean
                         stBoolean, stBit,
                      // naDateTime
                         stDateTime, stSmallDateTime, stTime, stDate, stYear, stLongDateTime,
                      // naMemo
                         stMemo, stNText, stMediumText, stLongText,
                      // naBlob
                         stBlob, stBinary, stImage, stVariant,stTimeStamp, stVarBinary, stGUID,
                         stBFile, stClob, stNClob, stRaw, stLongRaw, stLongBlob, stMediumBlob,
                         stSerial, stEnum, stSet, stTinyBlob, stXML, stJson,
                      // naFloat
                         stFloat, stDecimal, stNumericXY, stMoney, stReal, stSmallMoney,
                         stFloatCounter, stSingle, stDouble, stExtended, stFloatX,
                         stIntervalYear, stIntervalYearToMonth,
                         stIntervalMonth,
                         stIntervalDay, stIntervalDayToHour, stIntervalDayToMinute, stIntervalDayToSecond, stIntervalDayToMSecond,
                         stIntervalHour, stIntervalHourToMinute, stIntervalHourToSecond, stIntervalHourToMSecond,
                         stIntervalMinute, stIntervalMinuteToSecond, stIntervalMinuteToMSecond,
                         stIntervalSecond, stIntervalSecondToMSecond,
                         stIntervalMSecond,
                         stTimeStampLocalZone, stTimeStampTimeZone,
                      // naComputed
                         stComputed
  );

  TObjectImplementationType = (impCreate, impDrop);

  TFieldRestriction  = (frNone, frPartialReadOnly, frReadOnly);
  TObjectRestriction = (orNone, orReadOnly, orHidden);
  TTableRestriction  = (trNone, trReadOnly, trHidden);

  TStrArray = array of string;

  TCategoryAction = (caCreate, caModify, caRemove);

  TSQLMacroNativeId =
    (
     niTableName                        ,
     niTableLstFields                   ,
     niTableLstConstraints              ,
     niFieldName                        ,
     niFieldType                        ,
     niFieldNull                        ,
     niFieldDefault                     ,
     niOldFieldDefault                  ,
     niIndexType                        ,
     niIndexName                        ,
     niindexOrder                       ,
     niIndexFieldName                   ,
     niIndexFieldOrder                  ,
     niIndexLstFields                   ,
     niUniqueType                        ,
     niUniqueName                        ,
     niUniqueOrder                       ,
     niUniqueFieldName                   ,
     niUniqueFieldOrder                  ,
     niUniqueLstFields                   ,
     niRelName                          ,
     niRelChildTable                    ,
     niRelChildFields                   ,
     niRelParentTable                   ,
     niRelParentFields                  ,
     niRelDeleteAction                  ,
     niRelUpdateAction                  ,
     niConstraintPkName                 ,
     niConstraintPkFields               ,
     niConstraintCheckName              ,
     niConstraintCheckExpr              ,
     niConstraintCheckFldName           ,
     niConstraintCheckFldExpr           ,
     niConstraintDefaultName            ,
     niOldConstraintDefaultName         ,
     niConstraintDefaultExpr            ,
     niConstraintNotNullName            ,
     niConstraintNotNullExpr            ,
     niTriggerName                      ,
     niTriggerCode                      ,
     niTriggerEvent                     ,
     niFieldOldName                     ,
     niIndexOldName                     ,
     niUniqueOldName                     ,
     niTableOldName                     ,
     niObjectName                       ,
     niObjectCode                       ,
     niFieldExpression                  ,
     niDomainName                       ,
     niDomainType                       ,
     niDomainCheckExpr                  ,
     niDomainDefault                    ,
     niDomainExpression                 ,
     niDomainInformation                ,
     niFieldDescription                 ,
     niObjectDescription                ,
     niTableDescription                 ,
     niTriggerDescription               ,
     niTableLstRelationships
    );

  TGDAOCategoryType = (ctNone, ctProcedure, ctView, ctSequence, ctFunction);
  TGDAOCategoryTypes = set of TGDAOCategoryType;
const
  AllCategoryTypes = [ctProcedure..ctSequence];

type
  TDesignLinkType = (dltTable, dltDiagram);

  TDesignLinkClickEvent = procedure (ALinkType: TDesignLinkType; AObject: TObject) of object;

const
  NativeIdName: array[TSQLMacroNativeId] of string =
    (
     'TableName',
     'TableLstFields',
     'TableLstConstraints',
     'FieldName',
     'FieldType',
     'FieldNull',
     'FieldDefault',
     'OldFieldDefault',             
     'IndexType',
     'IndexName',
     'IndexOrder',
     'IndexFieldName',
     'IndexFieldOrder',
     'IndexLstFields',
     'UniqueType',
     'UniqueName',
     'UniqueOrder',
     'UniqueFieldName',
     'UniqueFieldOrder',
     'UniqueLstFields',
     'RelName',
     'RelChildTable',
     'RelChildFields',
     'RelParentTable',
     'RelParentFields',
     'RelDeleteAction',
     'RelUpdateAction',
     'ConstraintPkName',
     'ConstraintPkFields',
     'ConstraintCheckName',
     'ConstraintCheckExpr',
     'ConstraintCheckFldName',
     'ConstraintCheckFldExpr',
     'ConstraintDefaultName',
     'OldConstraintDefaultName',
     'ConstraintDefaultExpr',
     'ConstraintNotNullName',
     'ConstraintNotNullExpr',
     'TriggerName',
     'TriggerCode',
     'TriggerEvent',
     'FieldOldName',
     'IndexOldName',
     'UniqueOldName',
     'TableOldName',
     'ObjectName',
     'ObjectCode',
     'FieldExpression',
     'DomainName',
     'DomainType',
     'DomainCheckExpr',
     'DomainDefault',
     'DomainExpresssion',
     'DomainInformation',
     'FieldDescription',
     'ObjectDescription',
     'TableDescription',
     'TriggerDescription',
     'TableLstRelationships'
     );

  GDAOCategoryMacroName: array[TGDAOCategoryType] of string =
    ('Object', 'Procedure', 'View', 'Sequence', 'Function');

  vConnectionStr_PasswordValue  = 'PASSWORD';
  vConnectionStr_UserNameValue  = 'USER NAME';

  DATA_OBJECT = 999;
  TARGETINTERNALVERSION = 17;

  {Data Modeler windows messages}
  WM_DM_REFRESH_DOMAINS        = WM_APP + 1;
  WM_DM_OBJECTNAME_CHANGED        = WM_APP + 2;
  WM_DM_NEW_TABLE              = WM_APP + 3;
  WM_DM_PROJECTCHANGED         = WM_APP + 5;
  WM_DM_PROJECTSAVED           = WM_APP + 6;
  WM_DM_REFRESHOPENEDDIAGRAMS  = WM_APP + 7;

  WM_DM_FIELDDELETED           = WM_APP + 8;
  WM_DM_SELECTELEMENT          = WM_APP + 9; //wParam = Element (TObject)
  WM_DM_CLOSEEXPLORERITEMS     = WM_APP + 10;

  WM_DM_DIAGRAMPOPUPMENU       = WM_APP + 11;
  WM_DM_REMOVEDELETEFROMDIAGRAM = WM_APP + 12;
  WM_DM_DIAGRAMPAGESETUPDLG    = WM_APP + 13;

  WM_DM_CLOSE_ALL = WM_APP + 14;
  DMProjectExtension = '.dgp';

  SIndexTypeNone = 'Non exclusive';
  SIndexTypeExclusive = 'Exclusive';
  SIndexTypeUniqueKey = 'Unique Key';
  SIndexFieldOrderAsc = 'Asc';
  SIndexFieldOrderDesc = 'Desc';
  SIndexOrderAsc = 'Ascending';
  SIndexOrderDesc = 'Descending';

  IndexTypesStr: array[TIndexType] of string = (
    {itNone}             SIndexTypeNone,
    {itUnique}           SIndexTypeExclusive,
    {itUniqueKey}        SIndexTypeUniqueKey);
  IndexFieldOrdersStr: array[TIndexFieldOrder] of string = (
    {ioAsc}              SIndexFieldOrderAsc,
    {ioDesc}             SIndexFieldOrderDesc );
  IndexOrdersStr: array[TIndexOrder] of string = (
    {ioAscending}        SIndexOrderAsc,
    {ioDescending}       SIndexOrderDesc );

implementation

end.

