unit uGDAODiagrams;

interface

uses
  Classes, Messages, Forms, Graphics, Controls, ComCtrls, Menus, ExtCtrls,
  Dialogs, SysUtils, dgBase, uGDAO, uDiagramClass, uGDAODragObject,
  uTableDiagramBlock, dgConsts, fDiagramFind;

type
  TGDAODiagramsObject = class;
  TGDAODiagrams       = class;
  TGDAODiagram        = class;

  TGDAODiagramsObject = class(TPersistent)
  private
    FGDD      : TGDD;
    FDiagrams : TGDAODiagrams;
    procedure SetGDD(const AGDD: TGDD);
    procedure SetDiagrams(const Value: TGDAODiagrams);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property GDD: TGDD read FGDD write SetGDD;
  published
    property Diagrams: TGDAODiagrams read FDiagrams write SetDiagrams;
  end;

  TGDAODiagrams       = class(TCollection)
  private
    FGDD : TGDD;
    FObject: TGDAODiagramsObject;
    function GetItem(i: integer): TGDAODiagram;
  public
    constructor Create(AObject: TGDAODiagramsObject);
    function Add: TGDAODiagram;
    property GDD: TGDD read FGDD write FGDD;
    function IndexOf(AName: string): integer;
    function GetNewDiagramName: string;
    property Items[i: integer] : TGDAODiagram read GetItem; default;
  end;

  TGDAODiagram = class(TBaseGDAODiagram)
  private
    FContainer: TForm;
    FDiagram: TDiagramClass;
    FSearchPanel: TfmDiagramFind;
    procedure OnDiagramDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure OnDiagramDragDrop(Sender, Source: TObject; X, Y: Integer);
  protected
    function GetDiagramString: String; override;
    procedure SetDiagramString(const AString: String); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure CloseDiagramPage;
    procedure OpenDiagramPage(AParent: TWinControl);
    property DiagramControl: TDiagramClass read FDiagram;
  end;

implementation
uses
  atDiagram;

const
  SCustomDiagramOwnerName = '__Diagram__';

{ TGDAODiagrams }

function TGDAODiagrams.Add: TGDAODiagram;
begin
  Result := TGDAODiagram(inherited Add);
end;

constructor TGDAODiagrams.Create(AObject: TGDAODiagramsObject);
begin
  inherited Create(TGDAODiagram);
  FObject := AObject;
end;

function TGDAODiagrams.GetItem(i: integer): TGDAODiagram;
begin
  Result := TGDAODiagram(inherited Items[i]);
end;

function TGDAODiagrams.GetNewDiagramName: string;
const
  DNAME = 'Diagram';
var
  i: integer;
begin
  i := 0;
  repeat
    inc(i);
    result := Format('%s%d', [DNAME, i]);
  until IndexOf(result) < 0;
end;

function TGDAODiagrams.IndexOf(AName: string): integer;
begin
  for result := 0 to Count - 1 do
    if SameText(AName, Items[result].DiagramName) then
      exit;
  result := -1; 
end;

{ TGDAODiagramsObject }

procedure TGDAODiagramsObject.Assign(Source: TPersistent);
begin
  if Source is TGDAODiagramsObject then
    Diagrams := TGDAODiagramsObject(Source).Diagrams
  else
    inherited;
end;

constructor TGDAODiagramsObject.Create;
begin
  inherited;
  FDiagrams := TGDAODiagrams.Create(Self);
end;

destructor TGDAODiagramsObject.Destroy;
begin
  FDiagrams.Free;
  inherited;
end;

procedure TGDAODiagramsObject.SetDiagrams(const Value: TGDAODiagrams);
begin
  FDiagrams.Assign(Value);
end;

procedure TGDAODiagramsObject.SetGDD(const AGDD: TGDD);
begin
  FGDD := AGDD;
  FDiagrams.GDD := AGDD;
end;

{ TGDAODiagram }

constructor TGDAODiagram.Create(Collection: TCollection);
begin
  inherited;
  FContainer := TForm.Create(nil);
  FContainer.BorderStyle := bsNone;
  FContainer.BorderIcons := [];
  FContainer.Caption := '';
  FContainer.Align := alClient;

  FSearchPanel := TfmDiagramFind.Create(FContainer);
  FSearchPanel.Visible := false;
  FSearchPanel.Parent := FContainer;
  FSearchPanel.Align := alBottom;

  FDiagram := TDiagramClass.Create(FContainer);
  FDiagram.Parent := FContainer;
  FDiagram.GDAODiagram := Self;
  with FDiagram do
  begin
    GDD := TGDAODiagrams(Collection).GDD;

    {visual properties}
    Align := alClient;
    Color := clWhite;
    BorderStyle := bsNone;

    {behavior}
    OnDragDrop := OnDiagramDragDrop;
    OnDragOver := OnDiagramDragOver;
  end;
  FDiagram.SearchPanel := FSearchPanel;
end;

{ TGDAODiagram }

function TGDAODiagram.GetDiagramString: String;
var
  BS: TStringStream;
  oldName: string;
begin
  BS := TStringStream.Create('');
  try
    oldName := FDiagram.Owner.Name;
    FDiagram.Owner.Name := SCustomDiagramOwnerName;
    FDiagram.SaveToStream(BS, true);

    FDiagram.Owner.Name := oldName;
    BS.Position := 0;
    result := BS.ReadString(MaxInt);
  finally
    BS.Free;
  end;
end;

procedure TGDAODiagram.OnDiagramDragDrop(Sender, Source: TObject; X, Y: Integer);
var table: TGDAOTable;
begin
  table := TGDAOTable(TGDAODragObject(Source).GDAOObject);
  if table <> nil then
  begin
    if FDiagram.FindTableBlock(table) = nil then
      FDiagram.AddTableBlock(table, X, Y)
    else
      ShowMessage('Table ' + table.TableName + ' already in diagram.');
  end;
end;

procedure TGDAODiagram.OnDiagramDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender <> nil) and (Source <> nil) and (Source is TGDAODragObject);
end;

procedure TGDAODiagram.SetDiagramString(const AString: String);
var
  BS: TStringStream;
  oldName: string;
begin
  if FDiagram <> nil then
  begin
    if Trim(AString) = '' then
    begin
      FDiagram.Clear;
      Exit;
    end;

    BS := TStringStream.Create(AString);
    try
      BS.Position := 0;
      oldName := FDiagram.Owner.Name;
      FDiagram.Owner.Name := SCustomDiagramOwnerName;
      FDiagram.LoadFromStream(BS, true);
      FDiagram.Owner.Name := oldName;
    finally
      BS.Free;
    end;
  end;
end;

procedure TGDAODiagram.CloseDiagramPage;
begin
  {If you change this procedure, watch for uDiagramClass.TDiagramClass.GetOwnerProject!!!}
  FContainer.Visible := false;
  FContainer.Parent := nil;
end;

procedure TGDAODiagram.OpenDiagramPage(AParent: TWinControl);
begin
  {If you change this procedure, watch for uDiagramClass.TDiagramClass.GetOwnerProject!!!}
  FContainer.Parent := AParent;
  FContainer.Visible := true;
  FDiagram.RefreshDisplay;
end;                           

destructor TGDAODiagram.Destroy;
begin
  if FSearchPanel <> nil then
    FSearchPanel.Parent := nil;
  if FDiagram <> nil then
    FDiagram.Parent := nil;
  FContainer.Free;
  FContainer := nil;
  FDiagram := nil;
  FSearchPanel := nil;
  inherited;
end;

end.

