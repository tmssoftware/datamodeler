unit dgBase;

interface

uses
  Classes, DB, dgConsts;

type
  TBaseGDAODiagram = class(TCollectionItem)
  private
    FDiagramName   : String;
    FDiagramString : string;
  protected
    function GetDiagramString: String; virtual;
    procedure SetDiagramString(const Value: String); virtual;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property DiagramName   : String read FDiagramName write FDiagramName;
    property DiagramString : String read GetDiagramString write SetDiagramString;
  end;

  TBaseVersionControl = class(TCollection)
  end;

  TBaseVersion = class(TCollectionItem)
  private
    FVersionID   : Integer;
    FFileName    : String;
    FAuthor      : String;
    FInformation : String;
    FDateTime    : TDateTime;
    FCloseDate: TDateTime;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property VersionID   : Integer read FVersionID write FVersionID;
    property DateTime    : TDateTime read FDateTime write FDateTime;
    property CloseDate: TDateTime read FCloseDate write FCloseDate;
    property FileName    : string read FFileName write FFileName;
    property Information : string read FInformation write FInformation;
  end;

  TBaseAppMetaData = class(TComponent)
  private
    FPrjName: string;
    FPrjAuthor: string;
    FPrjDescription: string;
    FVersionControlPath: string;
    FUserOptions: TStringList;
    FPrjDBName: string;
    procedure SetUserOptions(const Value: TStringList);
  protected
    function GetPrjDBName: string; virtual;
    procedure SetPrjDBName(const Value: string); virtual;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  published
    property PrjName            : string read FPrjName write FPrjName;
    property PrjAuthor          : string read FPrjAuthor write FPrjAuthor;
    property PrjDescription     : string read FPrjDescription write FPrjDescription;
    property VersionControlPath : string read FVersionControlPath write FVersionControlPath;
    property UserOptions: TStringList read FUserOptions write SetUserOptions;
  end;

implementation

{ TBaseVersion }

procedure TBaseVersion.Assign(Source: TPersistent);
begin
  VersionID := TBaseVersion(Source).VersionID;
  DateTime := TBaseVersion(Source).DateTime;
  FileName := TBaseVersion(Source).FileName;
  FAuthor := TBaseVersion(Source).FAuthor;
  Information := TBaseVersion(Source).Information;
  CloseDate := TBaseVersion(Source).CloseDate;
end;

{ TBaseAppMetaData }

constructor TBaseAppMetaData.Create(Owner: TComponent);
begin
  inherited;
  FUserOptions := TStringList.Create;
end;

destructor TBaseAppMetaData.Destroy;
begin
  FUserOptions.Free;
  inherited;
end;

function TBaseAppMetaData.GetPrjDBName: string;
begin
  result := FPrjDBName;
end;

procedure TBaseAppMetaData.SetPrjDBName(const Value: string);
begin
  FPrjDBName := Value;
end;

procedure TBaseAppMetaData.SetUserOptions(const Value: TStringList);
begin
  FUserOptions.Assign(Value);
end;

{ TBaseGDAODiagram }

procedure TBaseGDAODiagram.Assign(Source: TPersistent);
begin
  DiagramName := TBaseGDAODiagram(Source).DiagramName;
  DiagramString := TBaseGDAODiagram(Source).DiagramString;
end;

function TBaseGDAODiagram.GetDiagramString: String;
begin
  result := FDiagramString;
end;

procedure TBaseGDAODiagram.SetDiagramString(const Value: String);
begin
  FDiagramString := Value;
end;

end.

