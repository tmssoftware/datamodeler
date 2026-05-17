unit uProjectExplorer;

interface

uses
  Classes, Controls, ComCtrls, Forms, uGDAO, uGDAODiagrams, AdvOfficePager;

type
  TExplorerElement = (exNone, exTable, exRelationship, exDiagram);


  TProjectOpenedItem = class(TCollectionItem)
  private
    FElement     : TObject;
    FFrameCtrl       : TWinControl;
    FPage        : TAdvOfficePage;
    function GetElementType: TExplorerElement;
  public
    property ElementType : TExplorerElement read GetElementType;
    property Element     : TObject read FElement write FElement;
    property FrameCtrl      : TWinControl read FFrameCtrl write FFrameCtrl;
    property Page        : TAdvOfficePage read FPage write FPage;
  end;

  TProjectExplorer = class(TCollection)
  private
    function GetItem(i: integer): TProjectOpenedItem;
    procedure SetItem(i: integer; const Value: TProjectOpenedItem);
  public
    constructor Create;
    function FindByPage(APage: TAdvOfficePage): Integer;
    function FindByElement(AElement: TObject): Integer;
    function Add(AElement: TObject; AFrameCtrl: TWinControl; APage: TAdvOfficePage): TProjectOpenedItem;
    property Items[i: integer]: TProjectOpenedItem read GetItem write SetItem; default;
  end;

implementation

{ TProjectExplorer }

function TProjectExplorer.Add(AElement: TObject; AFrameCtrl: TWinControl; APage: TAdvOfficePage): TProjectOpenedItem;
begin
  Result := TProjectOpenedItem(inherited Add);
  with Result do
  begin
    Element := AElement;
    Page    := APage;
    FrameCtrl   := AFrameCtrl;
  end;
end;

function TProjectExplorer.FindByPage(APage: TAdvOfficePage): Integer;
begin
  for Result := 0 to Count-1 do
    if Items[Result].Page = APage then
      Exit;
  Result := -1;
end;

constructor TProjectExplorer.Create;
begin
  inherited Create(TProjectOpenedItem);
end;

function TProjectExplorer.GetItem(i: integer): TProjectOpenedItem;
begin
  Result := TProjectOpenedItem(inherited Items[i]);
end;

procedure TProjectExplorer.SetItem(i: integer; const Value: TProjectOpenedItem);
begin
   Items[i].Assign(Value);
end;

function TProjectExplorer.FindByElement(AElement: TObject): Integer;
begin
  for Result := 0 to Count-1 do
    if Items[Result].Element = AElement then
      Exit;
  Result := -1;
end;

{ TProjectOpenedItem }

function TProjectOpenedItem.GetElementType: TExplorerElement;
begin
  if FElement is TGDAOTable then
    result := exTable
  else if FElement is TGDAORelationship then
    result := exRelationship
  else if FElement is TGDAODiagram then
    result := exDiagram
  else
    result := exNone;
end;

end.

