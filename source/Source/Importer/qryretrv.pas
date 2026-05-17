unit qryretrv;

interface

uses
  SysUtils, Classes, uGDAO, uSQLModule;

type
  TProgressEvent = reference to procedure(Percentage: double);

  TDataRetriever = class
  private
    FModuleFactory: ISQLModuleFactory;
    FMemoSize: integer;
    FModule: TSQLModule;
    FOnProgress: TProgressEvent;
    FMax: Integer;
    FRetrieveViewAsTables: Boolean;
  protected
    procedure SetMaxProgress(AMax: Integer);
    procedure SetProgressPos(APos: integer);
    procedure GetDataDictionary(ADictionary: TGDAODatabase); virtual; abstract;
    property ModuleFactory: ISQLModuleFactory read FModuleFactory;
    property Module: TSQLModule read FModule;
  public
    constructor Create(AModuleFactory: ISQLModuleFactory); virtual;
    destructor Destroy; override;
    function CheckDatabaseVersion: boolean; virtual;
    procedure RetrieveDictionary(ADictionary: TGDAODatabase);
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property RetrieveViewAsTables: Boolean read FRetrieveViewAsTables write FRetrieveViewAsTables;
  end;

implementation

{TDataRetriever}

destructor TDataRetriever.Destroy;
begin
  FModule.Free;
  inherited;
end;

function TDataRetriever.CheckDatabaseVersion: boolean;
begin
  result := true;
end;

constructor TDataRetriever.Create(AModuleFactory: ISQLModuleFactory);
begin
   FModuleFactory := AModuleFactory;
   FModule := FModuleFactory.NewSQLModule;

   { campos do tipo texto com tamanho maior ou igual ao valor da constante abaixo
     são considerados memo em alguns descendentes }
   FMemoSize:=2000;
   FMax := 100;
end;

procedure TDataRetriever.RetrieveDictionary(ADictionary: TGDAODatabase);
begin
  GetDataDictionary(ADictionary);
  ADictionary.Relationships.UpdateParentIndex;
end;

procedure TDataRetriever.SetMaxProgress(AMax: Integer);
begin
  FMax := AMax;
  if Assigned(FOnProgress) then
    FOnProgress(0);
end;

procedure TDataRetriever.SetProgressPos(APos: integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(APos / FMax);
end;

end.

