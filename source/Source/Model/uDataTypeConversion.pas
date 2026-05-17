unit uDataTypeConversion;

interface

uses
  SysUtils, Classes, dgConsts, dgDBTypes;

type
  TDataTypeConversionItems = class;
  TDataTypeConversionItem    = class;

  TDataTypeConversionMap = class(TComponent)
  private
    FOriginalDBType : TDatabaseType;
    FTargetDBType   : TDatabaseType;
    FConversionItems  : TDataTypeConversionItems;
    FConversionName: string;
    FFileName: string;
    FSystem: boolean;
    procedure SetConversionItems(const Value: TDataTypeConversionItems);
    function GetOriginalDBTypeID: string;
    procedure SetOriginalDBTypeID(const Value: string);
    function GetTargetDBTypeID: string;
    procedure SetTargetDBTypeID(const Value: string);
  public
    constructor Create(AOwner:TComponent = nil); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetConvertedDataType(AOriginalDataTypeName: String): TDataTypeConversionItem;
    property OriginalDBType : TDatabaseType read FOriginalDBType write FOriginalDBType;
    property TargetDBType   : TDatabaseType read FTargetDBType write FTargetDBType;
    property FileName: string read FFileName write FFileName;
    property System: boolean read FSystem write FSystem;
  published
    property ConversionName: string read FConversionName write FConversionName;
    property OriginalDBTypeID: string read GetOriginalDBTypeID write SetOriginalDBTypeID;
    property TargetDBTypeID: string read GetTargetDBTypeID write SetTargetDBTypeID;
    property ConversionItems : TDataTypeConversionItems read FConversionItems write SetConversionItems;
  end;

  TDataTypeConversionItems = class(TCollection)
  private
    function GetItem(i: integer): TDataTypeConversionItem;
    procedure SetItem(i: integer; const Value: TDataTypeConversionItem);
  public
    constructor Create;
    function GetConvertedDataType(AOriginalDataTypeName: String): TDataTypeConversionItem;
    function Add: TDataTypeConversionItem;
    property Items[i: integer]: TDataTypeConversionItem read GetItem write SetItem; default;
  end;

  TDataTypeConversionItem    = class(TCollectionItem)
  private
    FOriginalDataType : String;
    FTargetDataType   : String;
    FSize             : Integer;
    FSize2        : Integer;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property OriginalDataType : String read FOriginalDataType write FOriginalDataType;
    property TargetDataType   : String read FTargetDataType write FTargetDataType;
    property Size             : Integer read FSize write FSize;
    property Size2            : Integer read FSize2 write FSize2;
  end;

implementation

{ TDataTypeConversion }

procedure TDataTypeConversionMap.Assign(Source: TPersistent);
begin
  FileName := TDataTypeConversionMap(Source).FileName;
  System := TDataTypeConversionMap(Source).System;
  ConversionName := TDataTypeConversionMap(Source).ConversionName;
  ConversionItems := TDataTypeConversionMap(Source).ConversionItems;
  OriginalDBTypeID := TDataTypeConversionMap(Source).OriginalDBTypeID;
  TargetDBTypeID := TDataTypeConversionMap(Source).TargetDBTypeID;
end;

constructor TDataTypeConversionMap.Create(AOwner: TComponent);
begin
  inherited;
  FConversionItems := TDataTypeConversionItems.Create;
end;

destructor TDataTypeConversionMap.Destroy;
begin
  FConversionItems.Free;
  inherited;
end;

function TDataTypeConversionMap.GetConvertedDataType(
  AOriginalDataTypeName: String): TDataTypeConversionItem;
begin
  result := ConversionItems.GetConvertedDataType(AOriginalDataTypeName);
end;

function TDataTypeConversionMap.GetOriginalDBTypeID: string;
begin
  if Assigned(FOriginalDBType) then
    result := FOriginalDBType.DatabaseTypeID
  else
    result := '';
end;

function TDataTypeConversionMap.GetTargetDBTypeID: string;
begin
  if Assigned(FTargetDBType) then
    result := FTargetDBType.DatabaseTypeID
  else
    result := '';
end;

{ TDataTypeConversionItem }

procedure TDataTypeConversionItem.Assign(Source: TPersistent);
begin
  OriginalDataType := TDataTypeConversionItem(Source).OriginalDataType;
  TargetDataType := TDataTypeConversionItem(Source).TargetDataType;
  Size := TDataTypeConversionItem(Source).Size;
  Size2 := TDataTypeConversionItem(Source).Size2;
end;

{ TDataTypeConversionItems }

function TDataTypeConversionItems.Add: TDataTypeConversionItem;
begin
  Result := TDataTypeConversionItem(inherited Add);
end;

constructor TDataTypeConversionItems.Create;
begin
  inherited Create(TDataTypeConversionItem);
end;

function TDataTypeConversionItems.GetConvertedDataType(AOriginalDataTypeName: String): TDataTypeConversionItem;
var i : Integer;
begin
  Result := nil;
  for i := 0 to Count-1 do
    if CompareText(Items[i].OriginalDataType, AOriginalDataTypeName) = 0 then
    begin
      Result := Items[i];
      break;
    end;
end;

function TDataTypeConversionItems.GetItem(i: integer): TDataTypeConversionItem;
begin
  Result := TDataTypeConversionItem(inherited Items[i]);
end;

procedure TDataTypeConversionItems.SetItem(i: integer; const Value: TDataTypeConversionItem);
begin
   Items[i].Assign(Value);
end;

procedure TDataTypeConversionMap.SetConversionItems(const Value: TDataTypeConversionItems);
begin
  FConversionItems.Assign(Value);
end;

procedure TDataTypeConversionMap.SetOriginalDBTypeID(const Value: string);
begin
  FOriginalDBType := DatabaseTypes.FindByID(Value);
end;

procedure TDataTypeConversionMap.SetTargetDBTypeID(const Value: string);
begin
  FTargetDBType := DatabaseTypes.FindByID(Value);
end;

end.

