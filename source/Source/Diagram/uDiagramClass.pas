unit uDiagramClass;

interface

uses
  SysUtils, Classes, Messages, Controls, ExtCtrls, Graphics, Types, Dialogs, Menus, atDiagram,
  uGDAO, dgBase, uTableDiagramBlock, Forms, Windows, dgConsts, fDiagramFind;

type
  TDiagramClass = class;

  TDiagramAddNewTableEvent = procedure(ADiagramClass: TDiagramClass; ABlock: TTableDiagramBlock) of object;

  TDiagramAddNewRelationshipEvent = procedure(ADiagramClass: TDiagramClass; ALine: TCustomDiagramLine;
    ASourceBlock, ATargetBlock: TTableDiagramBlock; AType: TGDAORelationshipType) of object;

  TDiagramRelationshipEvent = procedure(ADiagramClass: TDiagramClass; ARelationship: TGDAORelationship) of object;

  TDiagramTableEvent = procedure(ADiagramClass: TDiagramClass; ATable: TGDAOTable) of object;

  TDiagramClass = class(TatDiagram)
  private
    FGDD : TGDD;
    FOnAddNewTable: TDiagramAddNewTableEvent;
    FOnAddNewRelationship: TDiagramAddNewRelationshipEvent;
    FInsertingRelationship: TGDAORelationshipType;
    FLinkRelationshipsToFields: boolean;
    FDisplayRelationshipNames: boolean;
    FShowCaptions: boolean;
    FStraightRelationshipLines: boolean;
    FOnEditTable: TDiagramTableEvent;
    FOnEditRelationship: TDiagramRelationshipEvent;
    FRefreshingDiagram: integer;
    FGDAODiagram: TBaseGDAODiagram;
    FPopupMenuDisplayed: boolean;
    FSearchPanel: TfmDiagramFind;
    FDisplayRelationshipCaptions: boolean;
//    FNavigator: TDiagramNavigator;
    procedure DiagramAfterMove(Sender: TObject);
    procedure DiagramControlDblClick(Sender: TObject; ADControl: TDiagramControl);
    procedure DiagramInsertBlock(Sender: TObject; ABlock: TCustomDiagramBlock);
    procedure DiagramInsertLink(Sender: TObject; ALink: TCustomDiagramLine);
    procedure SetLinkRelationshipsToFields(const Value: boolean);
    procedure SetDisplayRelationshipNames(const Value: boolean);
    procedure SetShowCaptions(const Value: boolean);
    procedure SetStraightRelationshipLines(const Value: boolean);
    procedure AutoPositionBlock(ABlock: TTableDiagramBlock);
    procedure CheckRelationships;
    procedure CheckRelationshipLinkPoints;
    function ProjectFormHandle: HWND;
    procedure ShowPopupMenu;
    procedure DiagramControlMouseUp(Sender: TObject; ADControl: TDiagramControl;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetDefaultProperties;
    procedure SetSearchPanel(const Value: TfmDiagramFind);
    procedure SetDisplayRelationshipCaptions(const Value: boolean);
    procedure CopyTableAppearance(Old, New: TTableDiagramBlock);
//    function GetNavigatorVisible: boolean;
//    procedure SetNavigatorVisible(const Value: boolean);
  protected
    function GetMeasUnit: TDiagramMeasUnit; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function FindLinkPoint(ABlock: TTableDiagramBlock; AField: TGDAOField; ALeft: boolean): TLinkPoint;
    procedure Loaded; override;
    procedure FindExecute(Sender: TObject; ASearchText: string; AForward: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Modified; override;
    function AddTableBlock(ATable: TGDAOTable; X: integer=-1; Y: integer=-1): TTableDiagramBlock;
    procedure AddAllTables;
    procedure ChangeBlocksColor;
    procedure ChangeRelationshipsColor;
    procedure ChangeDiagramColor;
    procedure ChangeNotesColor;
    procedure ChangeNotesFont;
    procedure ChangeNoteText;
    procedure EditObject(ADControl: TDiagramControl);
    procedure EditRelationship(ARelationship: TGDAORelationship);
    procedure EditTable(ATable: TGDAOTable);
    function FindTableBlock(ATable: TGDAOTable): TTableDiagramBlock;
    function FindTableBlockID(ATableID: integer): TTableDiagramBlock;
    function FindRelationship(ARelationship: TGDAORelationship): boolean;
    procedure InsertNote;
    procedure InsertTable;
    procedure InsertRelationship(AType: TGDAORelationshipType);
    procedure RefreshDisplay;
    procedure RecalculateTablesSize;
    function DuplicateTableBlock(ABlock: TTableDiagramBlock; ANewTable: TGDAOTable): TTableDiagramBlock;

    {Remove all selected objects from diagrma, without destroying the dictionary objects
     associated with it. So, the table block is removed from diagram, but TGDAOTable is not.
     This method doesn't perform any dialog for confirmation}
    procedure RemoveSelectedObjects;
    procedure UnlinkRelationships;
    procedure ExportImage;
    function FirstSelectedBlock: TCustomDiagramBlock;
    function FirstSelectedTable: TTableDiagramBlock;
    function FirstSelectedRelationship: TRelationshipDiagramLine;
    property GDD: TGDD read FGDD write FGDD;

    {property used only for reference (to know which is the "parent" TGDAODiagram object}
    property GDAODiagram: TBaseGDAODiagram read FGDAODiagram write FGDAODiagram;

    property SearchPanel: TfmDiagramFind read FSearchPanel write SetSearchPanel;

    property OnAddNewTable: TDiagramAddNewTableEvent read FOnAddNewTable write FOnAddNewTable;
    property OnAddNewRelationship: TDiagramAddNewRelationshipEvent read FOnAddNewRelationship write FOnAddNewRelationship;
    property OnEditRelationship: TDiagramRelationshipEvent read FOnEditRelationship write FOnEditRelationship;
    property OnEditTable: TDiagramTableEvent read FOnEditTable write FOnEditTable;
  published
    property DisplayRelationshipNames: boolean read FDisplayRelationshipNames write SetDisplayRelationshipNames;
    property DisplayRelationshipCaptions: boolean read FDisplayRelationshipCaptions write SetDisplayRelationshipCaptions stored false;
    property LinkRelationshipsToFields: boolean read FLinkRelationshipsToFields write SetLinkRelationshipsToFields;
    property ShowCaptions: boolean read FShowCaptions write SetShowCaptions;
    property StraightRelationshipLines: boolean read FStraightRelationshipLines write SetStraightRelationshipLines;
//    property NavigatorVisible: boolean read GetNavigatorVisible write SetNavigatorVisible;
    property ShowLinkPoints stored false;
    property HandlesStyle stored false;
    property DragStyle stored false;
    property PageLines stored false;
    property WheelZoom stored false;
    property WheelZoomIncrement stored false;
    property WheelZoomMax stored false;
    property WheelZoomMin stored false;
    property MeasUnit stored false;
    property AutoPage stored false;
  end;

implementation

uses
  uGDAODiagrams, DateUtils, DiagramUtils, uAppRegistry, DgrClasses;

{$R cursors.res}

const
  crDiagramTable              = 1;
  crDiagramRelationshipID     = 2;
  crDiagramRelationshipNonID  = 3;
  crDiagramRelationshipMN     = 4;
  crDiagramRelationshipSelf   = 5;
  crDiagramNote               = 6;

{ TDiagramClass }

procedure TDiagramClass.AddAllTables;
var
  tbl: TGDAOTable;
  i: Integer;
begin
  for i := 0 to GDD.Tables.Count - 1 do
  begin
    tbl := GDD.Tables[i];
    if (FindTableBlock(tbl) = nil) and tbl.Visible then
      AddTableBlock(tbl);
  end;
end;

function TDiagramClass.AddTableBlock(ATable: TGDAOTable; X, Y: integer): TTableDiagramBlock;
var
  D: TDot;
begin
  result := FindTableBlock(ATable);
  if result = nil then
  begin
    result := TTableDiagramBlock.Create(Self);
    result.Diagram := Self;
    result.Table := ATable;
  end;

  if (X = -1) or (Y = -1) then
    AutoPositionBlock(result)
  else
  begin
    D := Dot(X, Y);
    D := CanvasToClient(D);
    result.Left := D.X;
    result.Top := D.Y;
  end;

  CheckRelationships;
end;

procedure TDiagramClass.AutoPositionBlock(ABlock: TTableDiagramBlock);
var
  X, Y: integer;

  function BlockOverlapping: boolean;
  var
    i: integer;
  begin
    result := false;
    for i := 0 to BlockCount - 1 do
      if RectsTouch(Blocks[i].BoundsRect,
        Square(X, Y, X + ABlock.Width, Y + ABlock.Height)) then
      begin
        result := true;
        break;
      end;
  end;

const
  delta = 30;
begin
  X := 5;
  Y := 5;
  while BlockOverlapping do
  begin
    X := X + delta;
    if X + ABlock.Width > Self.ClientWidth then
    begin
      X := 5;
      Y := Y + delta;
    end;
  end;
  ABlock.Left := X;
  ABlock.Top := Y;
end;

procedure TDiagramClass.ChangeBlocksColor;
var i: integer;
begin
  with TColorDialog.Create(nil) do
  try
    if SelectedBlockCount > 0 then
      Color := TCustomDiagramBlock(Selecteds[0]).Color;
    if Execute then
    begin
      for i:=0 to SelectedCount-1 do
        if Selecteds[i] is TTableDiagramBlock then
          TTableDiagramBlock(Selecteds[i]).Color := Color;
      Modified;
    end;
  finally
    Free;
  end;
end;

procedure TDiagramClass.ChangeDiagramColor;
begin
  with TColorDialog.Create(nil) do
  try
    if Execute then
    begin
      Self.Color := Color;
      Modified;
    end;
  finally
    Free;
  end;
end;

procedure TDiagramClass.ChangeNotesColor;
var i: integer;
begin
  with TColorDialog.Create(nil) do
  try
    if SelectedBlockCount > 0 then
      Color := TCustomDiagramBlock(Selecteds[0]).Color;
    if Execute then
    begin
      for i:=0 to SelectedCount-1 do
        if Selecteds[i] is TDiagramNoteBlock then
          TDiagramNoteBlock(Selecteds[i]).Color := Color;
      Modified;
    end;
  finally
    Free;
  end;
end;

procedure TDiagramClass.ChangeNotesFont;
var i: integer;
begin
  with TFontDialog.Create(nil) do
  try
    if SelectedBlockCount > 0 then
      Font := TCustomDiagramBlock(Selecteds[0]).Font;
    if Execute then
    begin
      for i:=0 to SelectedCount-1 do
        if Selecteds[i] is TDiagramNoteBlock then
          TDiagramNoteBlock(Selecteds[i]).Font := Font;
      Modified;
    end;
  finally
    Free;
  end;
end;

procedure TDiagramClass.ChangeNoteText;
begin
  if (SelectedBlockCount > 0) and (Selecteds[0] is TDiagramNoteBlock) then
    TDiagramNoteBlock(Selecteds[0]).EditText;
end;

procedure TDiagramClass.ChangeRelationshipsColor;
var i: integer;
begin
  with TColorDialog.Create(nil) do
  try
    if SelectedLinkCount > 0 then
      Color := TRelationshipDiagramLine(Selecteds[0]).Color;
    if Execute then
    begin
      for i:=0 to SelectedCount-1 do
        if Selecteds[i] is TRelationshipDiagramLine then
          TRelationshipDiagramLine(Selecteds[i]).Color := Color;
      Modified;
    end;
  finally
    Free;
  end;
end;

procedure TDiagramClass.CheckRelationshipLinkPoints;
var r: integer;
    relationship: TGDAORelationship;
    dtable, mtable: TTableDiagramBlock;
    drelationship: TRelationshipDiagramLine;
    lTables: TList;
begin
  lTables := TList.Create;
  try
    for r := LinkCount-1 downto 0 do
      if Links[r] is TRelationshipDiagramLine then
      begin
        drelationship := Links[r] as TRelationshipDiagramLine;
        relationship := drelationship.Relationship;
        if not Assigned(relationship) or (relationship.Index < 0) or (FGDD.Relationships.IndexOfRelID(relationship.RelID) < 0) then { relationship not found: remove link }
          Links[r].Free
        else
        begin
          dtable := FindTableBlock(relationship.ChildTable);
          mtable := FindTableBlock(relationship.ParentTable);
          if not (Assigned(dtable) and Assigned(mtable) and relationship.Visible) then { table not found or hidden: remove link }
            Links[r].Free
          else
          begin                                       
            if dtable.LinksOnFields and (relationship.KeyLinkCount > 0) then { link point already exists at field position }
              Links[r].SourceLinkPoint.AnchorLink := FindLinkPoint(dtable, relationship.KeyLinks[0].ChildField, dtable.Left > (mtable.Left + mtable.Width))
            else { create new link point at some place }
            begin
              Links[r].SourceLinkPoint.AnchorLink := dtable.NewLinkPoint(mtable, relationship);
              if lTables.IndexOf(dtable) < 0 then
                lTables.Add(dtable);
            end;
            if mtable.LinksOnFields and (relationship.KeyLinkCount > 0) then { link point already exists at field position }
            begin
              if Assigned(Links[r].SourceLinkPoint.AnchorLink) then
                Links[r].TargetLinkPoint.AnchorLink := FindLinkPoint(mtable, relationship.KeyLinks[0].ParentField, Links[r].SourceLinkPoint.AnchorLink.DiagramPoint.X < mtable.Left);
            end
            else { create new link point at some place }
            begin
              Links[r].TargetLinkPoint.AnchorLink := mtable.NewLinkPoint(dtable, relationship);
              if lTables.IndexOf(mtable) < 0 then
                lTables.Add(mtable);
            end;
          end;
        end;
      end
      else
        Links[r].Free; { remove temporary links }

    { center link points on changed tables using a little of pog }
    for r:=0 to lTables.Count-1 do
      with TTableDiagramBlock(lTables[r]) do
      begin
        Left := Left+1;
        Left := Left-1;
      end;
  finally
    lTables.Free;
  end;
end;

procedure TDiagramClass.CheckRelationships;
var
  r: integer;
  rel: TGDAORelationship;
begin
  { remove invisible lines in the diagram. If line is invisible it was made this way
  in fProject unit, in AddNewrelatinoship event, because the line can't be destroyed
  but made visible due to issues with diagram. So, if the line is invisible, it means
  it must be destroyed }
  r := 0;
  while r < LinkCount do
  begin
    if not Links[r].Visible then
      Links[r].Free
    else
      inc(r);
  end;

  { add remaining relationships }
  for r := 0 to FGDD.Relationships.Count - 1 do
  begin
    rel := FGDD.Relationships[r];
    if not Self.FindRelationship(rel)
      and (Self.FindTableBlock(rel.ParentTable) <> nil)
      and (Self.FindTableBlock(rel.ChildTable) <> nil)
      and rel.Visible then
    begin
      with TRelationshipDiagramLine.Create(Self) do
      begin
        Diagram := Self;
        Relationship := rel;
        TargetArrow.Shape := asNone;
      end;
    end;
  end;

  CheckRelationshipLinkPoints;
end;

procedure TDiagramClass.CopyTableAppearance(Old, New: TTableDiagramBlock);
begin
  New.DisplayType := Old.DisplayType;
  New.ShowFieldTypes := Old.ShowFieldTypes;
  New.Color := Old.Color;
  New.SelColor := Old.Color;
  New.Font.Assign(Old.Font);
  New.UpdateTableInfo(true);
end;

constructor TDiagramClass.Create(AOwner: TComponent);
begin
  inherited;
//  FNavigator := TDiagramNavigator.Create(Self);
//  FNavigator.Visible := false;
//  FNavigator.Diagram := Self;
  FixedSideLines := true;
  FInsertingRelationship := ryUndefined;
  FLinkRelationshipsToFields := False;
  FDisplayRelationshipNames := False;
  FDisplayRelationshipCaptions := False;
  FShowCaptions := False;
  FStraightRelationshipLines := True;

  GraphicLib := dglGDI;
  HandlesStyle := hsVisio;
  DragStyle := dsShape;

  OnAfterMove := DiagramAfterMove;
  OnDControlMouseUp := DiagramControlMouseUp;
  OnDControlDblClick := DiagramControlDblClick;
  OnInsertBlock := DiagramInsertBlock;
  OnInsertLink := DiagramInsertLink;
  SetDefaultProperties;
end;

destructor TDiagramClass.Destroy;
begin
//  FNavigator.Parent := nil;
  inherited;
end;

procedure TDiagramClass.DiagramAfterMove(Sender: TObject);
begin
  CheckRelationshipLinkPoints;
end;

procedure TDiagramClass.DiagramControlDblClick(Sender: TObject; ADControl: TDiagramControl);
begin
  EditObject(ADControl);
end;

procedure TDiagramClass.DiagramControlMouseUp(Sender: TObject;
  ADControl: TDiagramControl; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Button=mbRight then
  begin
    ShowPopupMenu;
  end;
end;

procedure TDiagramClass.DiagramInsertBlock(Sender: TObject; ABlock: TCustomDiagramBlock);
begin
  Cursor := crDefault;
  if ABlock is TTableDiagramBlock then
  begin
    ABlock.Restrictions := ABlock.Restrictions + [crNoResize];
    if Assigned(FOnAddNewTable) then
    begin
      FOnAddNewTable(Self, ABlock as TTableDiagramBlock);
      FOnAddNewTable := nil; { one time only }
    end;
  end
  else
    ABlock.EditText;
end;

procedure TDiagramClass.DiagramInsertLink(Sender: TObject; ALink: TCustomDiagramLine);
var oksrc, oktrg, ok: boolean;
    srcCtrl, trgCtrl: TDiagramControl;
begin
  if (FInsertingRelationship <> ryUndefined) and (ALink is TDiagramLine) then
  begin
    Cursor := crDefault;
    { there's a table box at source and target link points }
    srcCtrl := DControlAtPos(ALink.SourceLinkPoint.DiagramPoint);
    trgCtrl := DControlAtPos(ALink.TargetLinkPoint.DiagramPoint);
    oksrc := Assigned(srcCtrl) and (srcCtrl is TTableDiagramBlock);
    oktrg := Assigned(trgCtrl) and (trgCtrl is TTableDiagramBlock);
    ok := oksrc and oktrg;
    if Assigned(FOnAddNewRelationship) then
    begin
      if ok then
      begin
        FOnAddNewRelationship(Self, ALink, srcCtrl as TTableDiagramBlock,
          trgCtrl as TTableDiagramBlock, FInsertingRelationship);
        if oksrc then
          TTableDiagramBlock(srcCtrl).UpdateTableInfo(true);
        if oktrg then
          TTableDiagramBlock(trgCtrl).UpdateTableInfo(true);
      end
      else
      begin
        FOnAddNewRelationship(Self, ALink, nil, nil, FInsertingRelationship);
      end;
      FOnAddNewRelationship := nil; { one time only }
    end;
    FInsertingRelationship := ryUndefined;
  end;
end;

function TDiagramClass.DuplicateTableBlock(ABlock: TTableDiagramBlock;
  ANewTable: TGDAOTable): TTableDiagramBlock;
var
  NewBlock: TTableDiagramBlock;
begin
  NewBlock := FindTableBlock(ANewTable);
  if NewBlock = nil then
    NewBlock := AddTableBlock(ANewTable);
  NewBlock.Left := ABlock.Left + 50;
  NewBlock.Top := ABlock.Top + 50;

  CopyTableAppearance(ABlock, NewBlock);
  Result := NewBlock;
 end;

procedure TDiagramClass.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    PostMessage(ProjectFormHandle, WM_DM_REMOVEDELETEFROMDIAGRAM, 0, 0);
    Key := 0;
  end;
  if (ssCtrl in Shift) and (Key = Ord('F')) then
  begin
    if SearchPanel <> nil then
    begin
      SearchPanel.ShowPanel;
      Key := 0;
    end;
  end;
  if Key = VK_ESCAPE then
  begin
    if (SearchPanel <> nil) and (SearchPanel.Visible) then
      SearchPanel.HidePanel;
    // Do not set Key=0 because escape might be useful in other tasks
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TDiagramClass.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FPopupMenuDisplayed := false;
  inherited;
  if (Button = mbRight) and not FPopupMenuDisplayed then
    ShowPopupMenu;
  FPopupMenuDisplayed := false;
end;

procedure TDiagramClass.EditObject(ADControl: TDiagramControl);
begin
  if ADControl is TTableDiagramBlock then
  begin
    EditTable(TTableDiagramBlock(ADControl).Table);
  end
  else
  if ADControl is TRelationshipDiagramLine then
  begin
    EditRelationship(TRelationshipDiagramLine(ADControl).Relationship);
  end
  else
  if ADControl is TDiagramNoteBlock then
  begin
    ChangeNoteText;
  end;
end;

procedure TDiagramClass.EditRelationship(ARelationship: TGDAORelationship);
begin
  if ARelationship <> nil then
  begin
    if Assigned(FOnEditRelationship) then
      FOnEditRelationship(Self, ARelationship);
  end;
end;

procedure TDiagramClass.EditTable(ATable: TGDAOTable);
begin
  if ATable <> nil then
  begin
    if Assigned(FOnEditTable) then
      FOnEditTable(Self, ATable);
  end;
end;

procedure TDiagramClass.ExportImage;
begin
  with TSaveDialog.Create(nil) do
  try
    DefaultExt := '.png';
    Filter := 'PNG Image file (*.png)|*.png|Bitmap file (*.bmp)|*.bmp';
    Title := 'Export diagram to image...';
    if Execute then
    begin
      ExportToFile(FileName);
      ShowMessage('Diagram successfully exported to "' + FileName + '"');
    end;
  finally
    Free;
  end;
end;

procedure TDiagramClass.FindExecute(Sender: TObject; ASearchText: string;
  AForward: boolean);
var
  Start: integer;
  I: Integer;
  Found: TTableDiagramBlock;
  Current: TGDAOTable;
begin
  if BlockCount = 0 then Exit;

  if AForward then
    Start := BlockCount - 1
  else
    Start := 0;

  // Find Start index to search for. Start from beginning, otherwise start from first selected table
  for I := 0 to BlockCount - 1 do
    if (Blocks[I] is TTableDiagramBlock) and Blocks[I].Selected then
    begin
      Start := I;
      Break;
    end;

  I := Start;
  Found := nil;
  repeat
    // Update current search
    if AForward then
      Inc(I)
    else
      Dec(I);
    if I < 0 then
      I := BlockCount - 1;
    if I >= BlockCount then
      I := 0;

    if (Blocks[I] is TTableDiagramBlock) and (TTableDiagramBlock(Blocks[I]).Table <> nil) then
    begin
      Current := TTableDiagramBlock(Blocks[I]).Table;
      if Pos(Uppercase(ASearchText), Uppercase(Current.TableName)) <> 0 then
      begin
        Found := TTableDiagramBlock(Blocks[I]);
        break;
      end;
    end;
  until (I = Start) or (Found <> nil);

  if Found <> nil then
  begin
    UnselectAll;
    Found.MakeVisible;
    Found.Selected := True;
  end else
    ShowMessage(Format('No table name found with search string "%s"', [ASearchText]));
end;

function TDiagramClass.FindLinkPoint(ABlock: TTableDiagramBlock; AField: TGDAOField; ALeft: boolean): TLinkPoint;
var i: integer;
begin
  for i:=0 to ABlock.LinkPoints.Count-1 do
    if Assigned(ABlock.LinkPoints[i].Obj) and (ABlock.LinkPoints[i].Obj = AField) and (ALeft xor (ABlock.LinkPoints[i].OrX <> 0)) then
    begin
      result := ABlock.LinkPoints[i];
      exit;
    end;
  result := nil;
end;

function TDiagramClass.FindRelationship(ARelationship: TGDAORelationship): boolean;
var
  r: integer;
begin
  for r:=0 to LinkCount-1 do
    if Links[r] is TRelationshipDiagramLine then
    begin
      if TRelationshipDiagramLine(Links[r]).Relationship = ARelationship then
      begin
        result := True;
        exit;
      end;
    end;
  result := False;
end;

function TDiagramClass.FindTableBlock(ATable: TGDAOTable): TTableDiagramBlock;
var
  i: integer;
begin
  for i := 0 to BlockCount - 1 do if Blocks[i] is TTableDiagramBlock then
    if TTableDiagramBlock(Blocks[i]).Table = ATable then
    begin
      result := TTableDiagramBlock(Blocks[i]);
      exit;
    end;
  result := nil;
end;

function TDiagramClass.FindTableBlockID(ATableID: integer): TTableDiagramBlock;
var
  i: integer;
begin
  for i := 0 to BlockCount - 1 do if Blocks[i] is TTableDiagramBlock then
    if TTableDiagramBlock(Blocks[i]).TableID = ATableID then
    begin
      result := TTableDiagramBlock(Blocks[i]);
      exit;
    end;
  result := nil;
end;

function TDiagramClass.FirstSelectedBlock: TCustomDiagramBlock;
var
  c: integer;
begin
  result := nil;
  for c := 0 to SelectedCount - 1 do
    if Selecteds[c] is TCustomDiagramBlock then
    begin
      result := TCustomDiagramBlock(Selecteds[c]);
      exit;
    end;
end;

function TDiagramClass.FirstSelectedRelationship: TRelationshipDiagramLine;
var
  c: Integer;
begin
  result := nil;
  for c := 0 to SelectedCount - 1 do
    if Selecteds[c] is TRelationshipDiagramLine then
    begin
      result := TRelationshipDiagramLine(Selecteds[c]);
      exit;
    end;
end;

function TDiagramClass.FirstSelectedTable: TTableDiagramBlock;
var
  c: Integer;
begin
  result := nil;
  for c := 0 to SelectedCount - 1 do
    if Selecteds[c] is TTableDiagramBlock then
    begin
      result := TTableDiagramBlock(Selecteds[c]);
      exit;
    end;
end;

function TDiagramClass.GetMeasUnit: TDiagramMeasUnit;
begin
  case DMRegistry.MeasurementUnit of
    dmuMilimeter:
      result := duMili;
    dmuInch:
      result := duInch;
  else
    //default dmuCentimeter
    result := duCenti;
  end;
end;

//function TDiagramClass.GetNavigatorVisible: boolean;
//begin
//  Result := (FNavigator <> nil) and (FNavigator.Parent = Self) and FNavigator.Visible;
//end;

procedure TDiagramClass.InsertNote;
begin
  Cursor := crDiagramNote;
  StartInsertingControl(TDiagramNoteBlock);
end;

procedure TDiagramClass.InsertRelationship(AType: TGDAORelationshipType);
begin
  case AType of
    ryIdentifying: Cursor := crDiagramRelationshipID;
    ryNonIdentifying: Cursor := crDiagramRelationshipNonID;
  else
    Cursor := crCross;
  end;
  FInsertingRelationship := AType;
  StartInsertingControl(TDiagramLine);
end;

procedure TDiagramClass.InsertTable;
begin
  Cursor := crDiagramTable;
  StartInsertingControl(TTableDiagramBlock);
end;

procedure TDiagramClass.Loaded;
begin
  inherited;
  SetDefaultProperties;
end;

procedure TDiagramClass.Modified;
begin
  if FRefreshingDiagram = 0 then
    inherited;
end;

function TDiagramClass.ProjectFormHandle: HWND;
var
  AControl: TWinControl;
begin
  {Owner should be FContainer}
  AControl := nil;
  if (Owner <> nil) and (Owner is TWinControl) then
    AControl := TWinControl(Owner);

  result := 0;
  if AControl <> nil then
  begin
    repeat
      if SameText(AControl.ClassName, 'TfmProject') then
      begin
        result := AControl.Handle;
        exit;
      end;
      AControl := AControl.Parent;
    until (AControl = nil);
  end;
end;

procedure TDiagramClass.RecalculateTablesSize;
var i: integer;
begin
  for i:=0 to SelectedCount-1 do
    if Selecteds[i] is TTableDiagramBlock then
      with TTableDiagramBlock(Selecteds[i]) do
      begin
        UpdateTableInfo(true);
      end;
end;

procedure TDiagramClass.RefreshDisplay;
var
  i: integer;
  tblock: TTableDiagramBlock;
  rline: TRelationshipDiagramLine;
begin
  Inc(FRefreshingDiagram);
  try
    UnlinkRelationships;
    for i := 0 to BlockCount - 1 do
      if Blocks[i] is TTableDiagramBlock then
      begin
        tblock := TTableDiagramBlock(Blocks[i]);
        if tblock.Table <> nil then
        begin
          tblock.Visible := tblock.Table.Visible;
          tblock.UpdateTableInfo(True);
        end;
      end;
    for i := 0 to LinkCount - 1 do
      if Links[i] is TRelationshipDiagramLine then
      begin
        rline := TRelationshipDiagramLine(Links[i]);
        if rline.Relationship <> nil then
          rline.Visible := rline.Relationship.Visible
      end;

    CheckRelationships;
    //CheckRelationshipLinkPoints;
  finally
    Dec(FRefreshingDiagram);
  end;
end;

procedure TDiagramClass.RemoveSelectedObjects;
var
  c: integer;
begin
  {Do not remove relationships. Let them to be removed automatically}
  c := 0;
  while c < SelectedCount do
  begin
    if Selecteds[c] is TRelationshipDiagramLine then
      Selecteds[c].Selected := false
    else
      inc(c);
  end;
  DeleteSelecteds;
  RefreshDisplay;
end;

procedure TDiagramClass.SetDefaultProperties;
begin
  {Be careful when setting this properties, because it can be called when
   diagram is copied/pasted to/from clipboard}
  DragStyle := dsShape;
  HandlesStyle := hsVisio;
  MouseWheelMode := mwVertical;
  WheelZoom := true;
  PageLines.Visible := true;
  AutoPage := true;
end;

procedure TDiagramClass.SetDisplayRelationshipCaptions(const Value: boolean);
begin
  FDisplayRelationshipCaptions := Value;
end;

procedure TDiagramClass.SetDisplayRelationshipNames(const Value: boolean);
begin
  FDisplayRelationshipNames := Value;
end;

procedure TDiagramClass.SetLinkRelationshipsToFields(const Value: boolean);
begin
  FLinkRelationshipsToFields := Value;
end;

//procedure TDiagramClass.SetNavigatorVisible(const Value: boolean);
//begin
//  if FNavigator = nil then Exit;
//  if Value <> NavigatorVisible then
//  begin
//    if Value then
//    begin
//      FNavigator.Parent := Self;
//      FNavigator.Left := 10;
//      FNavigator.Top := 10;
//      FNavigator.Width := 150;
//      FNavigator.Height := 150;
//      FNavigator.BlockShape := nbsOriginal;
//      FNavigator.PaintLines := false;
//      FNavigator.EnableZoom := true;
//      FNavigator.Visible := true;
//    end else
//    begin
//      FNavigator.Parent := nil;
//      FNavigator.Visible := false;
//    end;
//  end;
//end;

procedure TDiagramClass.SetSearchPanel(const Value: TfmDiagramFind);
begin
  FSearchPanel := Value;
  FSearchPanel.OnFindExecute := FindExecute;
  FSearchPanel.DiagramControl := Self;
end;

procedure TDiagramClass.SetShowCaptions(const Value: boolean);
begin
  FShowCaptions := Value;
end;

procedure TDiagramClass.SetStraightRelationshipLines(const Value: boolean);
begin
  FStraightRelationshipLines := Value;
end;

procedure TDiagramClass.ShowPopupMenu;
begin
  PostMessage(ProjectFormHandle, WM_DM_DIAGRAMPOPUPMENU, 0, 0);
  FPopupMenuDisplayed := true;
end;

procedure TDiagramClass.UnlinkRelationships;
var
  r: integer;
begin
  for r := 0 to LinkCount-1 do
    if Links[r] is TRelationshipDiagramLine then
    begin
      Links[r].SourceLinkPoint.AnchorLink := nil;
      Links[r].TargetLinkPoint.AnchorLink := nil;
    end;
end;

initialization
  Screen.Cursors[crDiagramTable] := LoadCursor(HInstance, 'CRTABLE');
  Screen.Cursors[crDiagramRelationshipID] := LoadCursor(HInstance, 'CRRELATIONSHIPID');
  Screen.Cursors[crDiagramRelationshipNonID] := LoadCursor(HInstance, 'CRRELATIONSHIPNONID');
  Screen.Cursors[crDiagramRelationshipMN] := LoadCursor(HInstance, 'CRRELATIONSHIPMN');
  Screen.Cursors[crDiagramRelationshipSelf] := LoadCursor(HInstance, 'CRRELATIONSHIPSELF');
  Screen.Cursors[crDiagramNote] := LoadCursor(HInstance, 'CRNOTE');

end.

