unit uTableDiagramBlock;

interface

uses
  Windows, SysUtils, Types, Graphics, Controls, uGDAO, Dialogs, atDiagram, Classes, DiagramUtils, dgConsts;

type
  TTableDisplayType = (dtAllFields, dtAllKeys, dtPrimaryKeys, dtTableName, dtAllKeysIndexes);

  TTableDiagramBlock = class(TCustomDiagramBlock)
  private
    FPrimaryBitmap : TBitmap;
    FForeignBitmap : TBitmap;
    FDisplayType: TTableDisplayType;
    FShowFieldTypes: boolean;
    FTableID: integer;
    procedure StoreTIDProp(Writer: TWriter);
    procedure LoadTIDProp(Reader: TReader);
    procedure SetDisplayType(const Value: TTableDisplayType);
    function GetLinksOnFields: boolean;
    procedure SetShowFieldTypes(const Value: boolean);
    function GetFieldType(AField: TGDAOField): string;
    procedure SetTable(const Value: TGDAOTable);
    function BuildBlock: TRectX;
    function AddTextItem(AField: TGDAOField; ARect: TRectX): TRectX;
    function GetTable: TGDAOTable;
    function GetObjectId(AObject: TCollectionItem): string;
  protected
    procedure Loaded; override;
    function GetTextCellRect(ACell: TTextCell; ARect: TRectX): TRectX; override;
    function GetLinkPoint(ALinkPoint: TLinkPoint): TPointX; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DrawBlock(AInfo: TDiagramDrawInfo; ABlockInfo: TDiagramDrawBlockInfo); override;
    procedure CenterLinkPoints;
    procedure DrawCell(AInfo: TDiagramDrawInfo; ACell: TTextCell); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateTableInfo(AResize: boolean);

    function NewLinkPoint(ABlockRef: TTableDiagramBlock; AObjRef: TGDAORelationship): TLinkPoint;
    property LinksOnFields: boolean read GetLinksOnFields;
    property Table: TGDAOTable read GetTable write SetTable;
    property TableID: integer read FTableID;
  published
    property Color default clWhite;
    property Font;
    property DisplayType: TTableDisplayType read FDisplayType write SetDisplayType default dtAllFields;
    property ShowFieldTypes: boolean read FShowFieldTypes write SetShowFieldTypes default False;
  end;

  TRelationshipDiagramLine = class(TDiagramLine)
  private
    FColor: TColor;
    FRelId: integer;
    procedure StoreRelIDProp(Writer: TWriter);
    procedure LoadRelIDProp(Reader: TReader);
    function GetRelationship: TGDAORelationship;
    procedure SetRelationship(const Value: TGDAORelationship);
    procedure SetColor(const Value: TColor);
    function GetStraightLines: boolean;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetLineArrowClass: TLineArrowClass; override;
    procedure PaintControl(AInfo: TDiagramDrawInfo); override;
    procedure CalcNewHandles(AHandles: TStretchHandles; AInfo: TCalcHandlesInfo); override;
  public
    constructor Create(AOwner: TComponent); override;

    property Relationship: TGDAORelationship read GetRelationship write SetRelationship;
    property RelID: integer read FRelId;
    property StraightLines: boolean read GetStraightLines;
  published
    property Color: TColor read FColor write SetColor default clWhite;

    property Orientation1 stored false;
    property Orientation2 stored false;
    property RequiresConnections stored false;
  end;

  TRelationshipArrow = class(TLineArrow)
  private
    FRelationshipLine: TRelationshipDiagramLine;
  public
    constructor Create(ADiagramLink: TRelationshipDiagramLine);
  protected
    procedure Draw(AInfo: TDiagramDrawInfo; AArrowInfo: TDiagramDrawArrowInfo); override;
  end;

  TDiagramNoteBlock = class(TCustomDiagramBlock)
  protected
    procedure DrawBlock(AInfo: TDiagramDrawInfo; ABlockInfo: TDiagramDrawBlockInfo); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color;
    property Font;
    property TextCells;
  end;

implementation

uses
  uDiagramClass;

{$R tableblock.res}

function TTableDiagramBlock.BuildBlock: TRectX;
var
  ARect: TRectX;
  MeasRect: TRectX;

  procedure UpdateRects;
  begin
    {Block bottom is the same as the bottom of text previously written}
    if result.Bottom < MeasRect.Bottom then
      result.Bottom := MeasRect.Bottom;

    {Expand Right of block to the maximum right of previously written texts}
    if result.Right < MeasRect.Right then
      result.Right := MeasRect.Right;

    {next text will be positioned right below the text previously written}
    ARect.Top := MeasRect.Bottom;
  end;

  function IsInIndex(AField: TGDAOField): boolean;
  var
    c: Integer;
    d: Integer;
  begin
    Result := False;
    for c := 0 to AField.OwnerTable.Indexes.Count - 1  do
      for d := 0 to AField.OwnerTable.Indexes[c].IFields.Count - 1 do
        if AField = AField.OwnerTable.Indexes[c].IFields[d].Field then
        begin
          Result := True;
          break;
        end;
  end;

  function IncludeField(AField: TGDAOField): boolean;
  begin
//      if (DisplayType = dtAllFields)
//        or ((DisplayType = dtPrimaryKeys) and Table.Fields[c].InPrimaryKey)
//        or ((DisplayType = dtAllKeys) and (Table.Fields[c].IsForeignKey or Table.Fields[c].InPrimaryKey))
    case DisplayType of
      dtAllKeys:
        Result := AField.IsForeignKey or AField.InPrimaryKey;
      dtPrimaryKeys:
        Result := AField.InPrimaryKey;
      dtTableName:
        Result := False;
      dtAllKeysIndexes:
        Result := AField.IsForeignKey or AField.InPrimaryKey or IsInIndex(AField);
    else
      //dtAllFields:
      result := true;
    end;
  end;

var
  c: integer;
begin
  result := BoundsRect;
  result.Right := result.Left;
  result.Bottom := result.Top;

  {Set initial size for drawing items/measuring strings}
  ARect := BoundsRect;
  ARect.Right := MaxInt;
  ARect.Bottom := MaxInt;

  TextCells.Clear;
  LinkPoints.Clear;

  {Table name}
  MeasRect := AddTextItem(nil, ARect);
  UpdateRects;

  {Update left of next texts. Field texts are displayed a little bit
   shifted to the right}
  ARect.Left := ARect.Left + 18;

  if Table <> nil then
    for c := 0 to Table.Fields.Count - 1 do
    begin
      if IncludeField(Table.Fields[c]) then
      begin
        MeasRect := AddTextItem(Table.Fields[c], ARect);

        if LinksOnFields then
        begin
          LinkPoints.Add(0, ((MeasRect.Bottom + MeasRect.Top) / 2) - BoundsRect.Top, aoLeft).Obj := Table.Fields[c];
          LinkPoints.Add(100, ((MeasRect.Bottom + MeasRect.Top) / 2) - BoundsRect.Top, aoRight).Obj := Table.Fields[c];
        end;

        UpdateRects;
      end;
    end;
  result.Right := result.Right + 6;
  result.Bottom := result.Bottom + 6;
end;

procedure TTableDiagramBlock.CenterLinkPoints;
var ao: TAnchorOrientation;
    l: integer;
    _or: extended;
    slPoints: TStringList;

  function WeightLinkPoint(lp: TLinkPoint): extended;
  var rel: TGDAORelationship;
      tbref: TTableDiagramBlock;
  begin
    result := 0;
    if Assigned(lp.Obj) and (lp.Obj is TGDAORelationship) then
    begin
      rel := lp.Obj as TGDAORelationship;
      if (TDiagramClass(Diagram).FindTableBlock(rel.ParentTable) <> nil)
        and (TDiagramClass(Diagram).FindTableBlock(rel.ChildTable) <> nil) then
      begin
        if rel.ChildTable = Self.Table then
          tbref := TDiagramClass(Diagram).FindTableBlock(rel.ParentTable)
        else
          tbref := TDiagramClass(Diagram).FindTableBlock(rel.ChildTable);
        result := tbref.Left + tbref.Top;
      end;
    end;
  end;

begin
  { keep link points centered on each face }
  slPoints := TStringList.Create;
  try
    for ao := aoUp to aoRight do
    begin
      slPoints.Clear;
      { sort link points by left+top of referenced tables, ascending }
      for l:=0 to LinkPoints.Count-1 do
        if LinkPoints[l].Orientation = ao then
          slPoints.AddObject(FormatFloat('000000', WeightLinkPoint(LinkPoints[l])), LinkPoints[l]);
      if slPoints.Count > 0 then
      begin
        slPoints.Sort;
        _or := 100 / slPoints.Count;
        if ao in [aoDown, aoUp] then { adjust to width }
        begin
          for l:=0 to slPoints.Count-1 do
            TLinkPoint(slPoints.Objects[l]).OrX := (l * _or) + (_or / 2);
        end
        else { adjust to height }
        begin
          for l:=0 to slPoints.Count-1 do
            TLinkPoint(slPoints.Objects[l]).OrY := (l * _or) + (_or / 2);
        end;
      end;
    end;
  finally
    slPoints.Free;
  end;
end;

constructor TTableDiagramBlock.Create(AOwner: TComponent);
begin
  inherited;
  FTableID := -1;
  ClipText := true;
  Restrictions := [crNoRotation];
  //Shape := bsNoShape;
  Shape := bsRectangle;
  Shadow.Visible := true;
  Shadow.HOffset := 5;
  Shadow.VOffset := 5;

  Alignment := taLeftJustify;
  LinkPointStyle := ptNone;
  Color := clWhite;
  MinHeight := 18;
  MinWidth := MinHeight;

  FDisplayType := dtAllFields;
  FShowFieldTypes := False;

  FPrimaryBitmap := TBitmap.Create;
  FPrimaryBitmap.Transparent := True;
  FForeignBitmap := TBitmap.Create;
  FForeignBitmap.Transparent := True;

  // loading icons
  FPrimaryBitmap.LoadFromResourceName(hInstance, 'PRIMARYKEY');
  FForeignBitmap.LoadFromResourceName(hInstance, 'FOREIGNKEY');
end;

procedure TTableDiagramBlock.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('TID', LoadTIDProp, StoreTIDProp, true);
end;

destructor TTableDiagramBlock.Destroy;
begin
  FPrimaryBitmap.Free;
  FForeignBitmap.Free;
  inherited;
end;

procedure TTableDiagramBlock.DrawBlock(AInfo: TDiagramDrawInfo; ABlockInfo: TDiagramDrawBlockInfo);
begin
  inherited;
end;

procedure TTableDiagramBlock.DrawCell(AInfo: TDiagramDrawInfo; ACell: TTextCell);
var
  AField: TGDAOField;
  ImgRect: TRectX;
  Img: TBitmap;
  P1: TPointX;
  P2: TPointX;
begin
  inherited;

  if (ACell.Obj <> nil) and (ACell.Obj is TGDAOField) then
  begin
    AField := TGDAOField(ACell.Obj);

    if AField.InPrimaryKey then
      Img := FPrimaryBitmap
    else
    if AField.IsForeignKey then
      Img := FForeignBitmap
    else
      Img := nil;

    if Img <> nil then
    begin
      ImgRect.TopLeft := Dot(Self.Left + 1, ACell.DiagramRect.Top);
      ImgRect.BottomRight := Dot(ImgRect.Left + Img.Width, ImgRect.Top + Img.Height);
      P1 := Diagram.ClientToCanvas(ImgRect.TopLeft);
      P2 := Diagram.ClientToCanvas(ImgRect.BottomRight);
      ImgRect := Square(P1.X, P1.Y, P2.X, P2.Y);

      //PrintBitmap(ACanvas, ImgRect, Img);
      AInfo.Canvas.StretchDraw(ToRect(ImgRect), Img);
    end;
 end;
end;

function TTableDiagramBlock.GetFieldType(AField: TGDAOField): string;
begin
  result := AField.GetGridDataTypeName;
end;

function TTableDiagramBlock.GetLinkPoint(ALinkPoint: TLinkPoint): TPointX;
begin
  result := inherited GetLinkPoint(ALinkPoint);

  {if linkpoint is related to a field, then use absolute vertical position}
  if not (csDestroying in ComponentState) and (ALinkPoint <> nil) then
    if (ALinkPoint.obj <> nil) and (ALinkPoint.Obj is TGDAOField) then
      result.Y := BoundsRect.Top + ALinkPoint.OrY;
end;

function TTableDiagramBlock.GetLinksOnFields: boolean;
begin
  result := TDiagramClass(Diagram).LinkRelationshipsToFields and (DisplayType in [dtAllFields, dtAllKeys, dtAllKeysIndexes]);
end;

function TTableDiagramBlock.GetObjectId(AObject: TCollectionItem): string;
begin
  if AObject is TGDAOTable then
  begin
    if TDiagramClass(Diagram).ShowCaptions then
      result := TGDAOTable(AObject).TableCaption
    else
      result := TGDAOTable(AObject).TableName;
  end
  else if AObject is TGDAOField then
  begin
    if TDiagramClass(Diagram).ShowCaptions then
      result := TGDAOField(AObject).FieldCaption
    else
      result := TGDAOField(AObject).FieldName;
  end
  else
    result := AObject.DisplayName;
end;

function TTableDiagramBlock.GetTable: TGDAOTable;
begin
  result := nil;
  if (Diagram is TDiagramClass) and (TDiagramClass(Diagram).GDD <> nil) then
    result := TDiagramClass(Diagram).GDD.Tables.FindByID(FTableID);
end;

function TTableDiagramBlock.GetTextCellRect(ACell: TTextCell; ARect: TRectX): TRectX;
begin
  result := Square(
    Left + ARect.Left, Top + ARect.Top,
    Right, Top + ARect.Bottom);
end;

procedure TTableDiagramBlock.Loaded;
begin
  inherited;
  SelColor := Color;
end;

procedure TTableDiagramBlock.LoadTIDProp(Reader: TReader);
begin
  FTableID := Reader.ReadInteger;
end;

function TTableDiagramBlock.NewLinkPoint(ABlockRef: TTableDiagramBlock; AObjRef: TGDAORelationship): TLinkPoint;
var l: integer;
begin
  { create a link point (or find by a reference object) }
  result := nil;
  for l := 0 to LinkPoints.Count-1 do
    if LinkPoints[l].Obj = AObjRef then
    begin
      result := LinkPoints[l];
      break;
    end;
  if not Assigned(result) then
  begin
    result := LinkPoints.Add;
    result.Obj := AObjRef;
  end;

  { bottom, top, right or left }
  result.OrX := 0;
  result.OrY := 0;
  if (Top + Height) < ABlockRef.Top then
    result.OrY := 100
  else if (Left + Width) < ABlockRef.Left then
    result.OrX := 100;
  if (Top + Height) < ABlockRef.Top then
    result.Orientation := aoDown
  else if Top > (ABlockRef.Top + ABlockRef.Height) then
    result.Orientation := aoUp
  else if (Left + Width) < ABlockRef.Left then
    result.Orientation := aoRight
  else
    result.Orientation := aoLeft;

  CenterLinkPoints;
end;

procedure TTableDiagramBlock.SetDisplayType(const Value: TTableDisplayType);
begin
  { auto resize box when display type changed }
  FDisplayType := Value;
  UpdateTableInfo((Value <> FDisplayType) and not (csLoading in ComponentState));
end;

procedure TTableDiagramBlock.SetShowFieldTypes(const Value: boolean);
begin
  if Value <> FShowFieldTypes then
  begin
    FShowFieldTypes := Value;
    UpdateTableInfo(not (csLoading in ComponentState));
  end;
end;

procedure TTableDiagramBlock.SetTable(const Value: TGDAOTable);
begin
  if Value <> nil then
    FTableID := Value.TID
  else
    FTableID := -1;
  UpdateTableInfo(not (csLoading in ComponentState));
end;

procedure TTableDiagramBlock.StoreTIDProp(Writer: TWriter);
begin
  Writer.WriteInteger(FTableID);
end;

procedure TTableDiagramBlock.UpdateTableInfo(AResize: boolean);
var
  ACanvas: TControlCanvas;
begin
  if Table <> nil then
  begin
    Restrictions := Restrictions + [crNoResize];

    {allows resize only when relationships are linked to fields on table box.
     DISABLE resizing}
    {if LinksOnFields then
      Restrictions := Restrictions + [crNoResize]
    else
      Restrictions := Restrictions - [crNoResize];}

    if AResize then
    begin
      ACanvas := TControlCanvas.Create;
      try
        ACanvas.Control := Diagram;
        Drawer.Canvas := ACanvas;
        BoundsRect := BuildBlock;
      finally
        ACanvas.Free;
      end;
    end;
  end;
end;

function TTableDiagramBlock.AddTextItem(AField: TGDAOField; ARect: TRectX): TRectX;
var
  AFont: TFont;
  AText: string;
  AAlign: TAlignment;
  AWidth, AHeight: double;
  ASaveFont: TFont;
  TC: TTextCell;
begin
  AFont := TFont.Create;
  ASaveFont := TFont.Create;
  try
    AFont.Assign(Self.Font);

    {field nil means that we're writing table name}
    if AField = nil then
    begin
      {set table font}
      AFont.Color := clWhite;
      AFont.Style := [fsBold];
      AAlign := taCenter;
      if Table <> nil then
        AText := GetObjectId(Table);
    end
    else
    begin
      AFont.Color := clBlack;
      if AField.Required then
        AFont.Style := [fsBold]
      else
        AFont.Style := [];
      AAlign := taLeftJustify;
      AText := GetObjectId(AField);
      if ShowFieldTypes then
        AText := Format('%s: %s', [AText, GetFieldType(AField)]);
    end;

    ASaveFont.Assign(Drawer.Canvas.Font);
    try
      Drawer.Canvas.Font.Assign(AFont);
      AWidth := Drawer.Canvas.TextWidth(AText);
      AHeight := Drawer.Canvas.TextHeight(AText) + 5;
    finally
      Drawer.Canvas.Font.Assign(ASaveFont);
    end;
    result := Square(ARect.Left, ARect.Top, ARect.Left + AWidth, ARect.Top + AHeight);

    TC := TextCells.Add;
    TC.Font := AFont;
    TC.Left := ARect.Left - Self.BoundsRect.Left;
    TC.Top := ARect.Top - Self.BoundsRect.Top;
    TC.Height := AHeight;
    TC.Width := 100; //Dummy value, will not be used
    TC.Text := AText;
    TC.Clip := false; //Let text be clipped by ClipText property
    TC.WordWrap := false;
    TC.Alignment := AAlign;
    TC.VertAlign := vaCenter;
    TC.Visible := true;
    TC.Obj := AField;

    {Set properties of table text cell}
    if AField = nil then
    begin
      TC.CellFrame.Color := clGray;
      TC.CellFrame.Brush.Style := bsClear;
      TC.CellFrame.Pen := Self.Pen;
      TC.CellFrame.Transparent := false;
      TC.CellFrame.Visible := true;
    end;
  finally
    AFont.Free;
    ASaveFont.Free;
  end;
end;

{ TRelationshipDiagramLine }

procedure TRelationshipDiagramLine.CalcNewHandles(AHandles: TStretchHandles;
  AInfo: TCalcHandlesInfo);
begin
  if AHandles.Count > 1 then
  begin
    if (SourceLinkPoint <> nil) and (SourceLinkPoint.AnchorLink <> nil) then
      case SourceLinkPoint.AnchorLink.Orientation of
        aoUp:
          AInfo.P1.Y := SourceLinkPoint.AnchorLink.DiagramPoint.Y - 18;
        aoDown:
          AInfo.P1.Y := SourceLinkPoint.AnchorLink.DiagramPoint.Y + 18;
        aoLeft:
          AInfo.P1.X := SourceLinkPoint.AnchorLink.DiagramPoint.X - 18;
        aoRight:
          AInfo.P1.X := SourceLinkPoint.AnchorLink.DiagramPoint.X + 18;
      end;
    if (TargetLinkPoint <> nil) and (TargetLinkPoint.AnchorLink <> nil) then
      case TargetLinkPoint.AnchorLink.Orientation of
        aoUp:
          AInfo.P2.Y := TargetLinkPoint.AnchorLink.DiagramPoint.Y - 18;
        aoDown:
          AInfo.P2.Y := TargetLinkPoint.AnchorLink.DiagramPoint.Y + 18;
        aoLeft:
          AInfo.P2.X := TargetLinkPoint.AnchorLink.DiagramPoint.X - 18;
        aoRight:
          AInfo.P2.X := TargetLinkPoint.AnchorLink.DiagramPoint.X + 18;
      end;
  end;
  inherited;
end;

constructor TRelationshipDiagramLine.Create(AOwner: TComponent);
begin
  inherited;
  TextCellsMode := tmSpecific;
  Restrictions := Restrictions + [crNoResize];
  FRelID := -1;
  RequiresConnections := true;
  Color := clBlack;
  TRelationshipArrow(SourceArrow).FRelationshipLine := Self;
  TRelationshipArrow(TargetArrow).FRelationshipLine := Self;
end;

procedure TRelationshipDiagramLine.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('RelID', LoadRelIDProp, StoreRelIDProp, true);
end;

function TRelationshipDiagramLine.GetLineArrowClass: TLineArrowClass;
begin
  result := TRelationshipArrow;
end;

function TRelationshipDiagramLine.GetRelationship: TGDAORelationship;
begin
  result := nil;
  if (Diagram is TDiagramClass) and (TDiagramClass(Diagram).GDD <> nil) then
    result := TDiagramClass(Diagram).GDD.Relationships.FindByID(FRelID);
end;

function TRelationshipDiagramLine.GetStraightLines: boolean;
begin
  result := Assigned(Diagram) and TDiagramClass(Diagram).StraightRelationshipLines;
end;

procedure TRelationshipDiagramLine.LoadRelIDProp(Reader: TReader);
begin
  FRelID := Reader.ReadInteger;
end;

procedure TRelationshipDiagramLine.PaintControl(AInfo: TDiagramDrawInfo);
var
  S: string;
begin
  CurPen.Color := Color;
  if Assigned(Relationship) then
  begin
    if Relationship.IsIdentifying then
      CurPen.Style := psSolid
    else
      CurPen.Style := psDot;


    S := '';
    if TDiagramClass(Diagram).DisplayRelationshipNames then
      S := Relationship.RelationshipName;
    if TDiagramClass(Diagram).DisplayRelationshipCaptions then
    begin
      if S <> '' then
        S := S + #13#10;
      S := S + Relationship.Description;
    end;
    CenterTextCell.Text := S;

    if StraightLines then
      LineStyle := lsLine
    else
      LineStyle := lsSideLine;

    CenterTextCell.CellFrame.Color := Diagram.Color;
    CenterTextCell.CellFrame.Transparent := false;
    CenterTextCell.CellFrame.Visible := true;
    CenterTextCell.CellFrame.AutoFrame := true;
    CenterTextCell.CellFrame.Pen.Style := psClear;

    if Relationship.KeyLinkCount = 0 then
      CurPen.Color := clRed;
  end
  else
  begin
    CurPen.Style := psDot;
    CurPen.Color := clRed;
  end;

  inherited;
end;

procedure TRelationshipDiagramLine.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TRelationshipDiagramLine.SetRelationship(const Value: TGDAORelationship);
begin
  //RequiresConnections := True;
  if Value <> nil then
    FRelID := Value.RelID
  else
    FRelID := -1;
end;

procedure TRelationshipDiagramLine.StoreRelIDProp(Writer: TWriter);
begin
  if Relationship <> nil then
    Writer.WriteInteger(Relationship.RelID)
  else
    Writer.WriteInteger(-1);
end;

{ TRelationshipArrow }

constructor TRelationshipArrow.Create(ADiagramLink: TRelationshipDiagramLine);
begin
  inherited Create(ADiagramLink);
  FRelationshipLine := ADiagramLink;
end;

procedure TRelationshipArrow.Draw(AInfo: TDiagramDrawInfo; AArrowInfo: TDiagramDrawArrowInfo);
//var
//  _ZoomRatio: double;

  function _Zoomed(AValue: double): double;
  begin
    result := AValue; exit;
//    result := AValue * _ZoomRatio;
  end;

  function ToCanvas(X, Y: double): TPoint;
  begin
    result := RoundPoint(DiagramLine.Diagram.ClientToCanvas(Dot(X, Y)));
  end;

var
  multx, multy: number;
  LP: TPointX;
  ALink: TLinkPoint;
  P1, P2, P3, P4, P5, P6: TPoint;
begin
  inherited;

  {Just test for the pointers to avoid AV}
  if (FRelationshipLine <> nil) and
    (FRelationshipLine.SourceLinkPoint.AnchorLink <> nil) and
    (FRelationshipLine.TargetLinkPoint.AnchorLink <> nil) and
    (FRelationshipLine.Relationship <> nil) then
  begin
    if Self = FRelationshipLine.SourceArrow then
      ALink := FRelationshipLine.SourceLinkPoint.AnchorLink
    else
      ALink := FRelationshipLine.TargetLinkPoint.AnchorLink;

    LP := DrawTo;
    case ALink.Orientation of
      aoUp:
        begin
          multy := 1;
          multx := 1;
          LP.Y := LP.Y + 18;
        end;
      aoDown:
        begin
          multy := -1;
          multx := 1;
          LP.Y := LP.Y - 18;
        end;
      aoLeft:
        begin
          multx := 1;
          multy := 1;
          LP.X := LP.X + 18;
        end;
      aoRight:
        begin
          multx := -1;
          multy := 1;
          LP.X := LP.X - 18;
        end;
    else
      multx := 1;
      multy := 1;
    end;

    {_ZoomRatio :=
      (DiagramLine.Diagram.ClientToCanvas(Point(100, 100)).X -
      DiagramLine.Diagram.ClientToCanvas(Point(0, 0)).X) / 100;}

    if (Self = FRelationshipLine.SourceArrow) and (FRelationshipLine.Relationship.Cardinality = rcOneToMany) then
    begin
      { custom arrow pointing to detail table of one-to-many relationship }
      if ALink.Orientation in [aoLeft, aoRight] then
      begin
        P1 := ToCanvas(LP.X - multx * _Zoomed(14), LP.Y);
        P2 := ToCanvas(LP.X, LP.Y - _Zoomed(6));
        P3 := ToCanvas(LP.X, LP.Y);
        P4 := ToCanvas(LP.X, LP.Y + _Zoomed(6));
        P5 := ToCanvas(LP.X - multx * _Zoomed(18), LP.Y - _Zoomed(4));
        P6 := ToCanvas(LP.X - multx * _Zoomed(11), LP.Y + _Zoomed(4));

        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P2.X, P2.Y);
        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P3.X, P3.Y);
        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P4.X, P4.Y);
        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.Brush.Color := clWhite;
        AInfo.Canvas.Pen.Style := psSolid;
        AInfo.Canvas.Ellipse(P5.X, P5.Y, P6.X, P6.Y);
      end
      else
      begin
        P1 := ToCanvas(LP.X, LP.Y - multy * _Zoomed(14));
        P2 := ToCanvas(LP.X - _Zoomed(6), LP.Y);
        P3 := ToCanvas(LP.X, LP.Y);
        P4 := ToCanvas(LP.X + _Zoomed(6), LP.Y);
        P5 := ToCanvas(LP.X - _Zoomed(4), LP.Y - multy * _Zoomed(18));
        P6 := ToCanvas(LP.X + _Zoomed(4), LP.Y - multy * _Zoomed(11));

        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P2.X, P2.Y);
        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P3.X, P3.Y);
        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P4.X, P4.Y);
        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.Brush.Color := clWhite;
        AInfo.Canvas.Pen.Style := psSolid;
        AInfo.Canvas.Ellipse(P5.X, P5.Y, P6.X, P6.Y);
      end;
    end
    else
    begin
      { custom 'one' arrow }
      if ALink.Orientation in [aoLeft, aoRight] then
      begin
        P1 := ToCanvas(LP.X - multx * _Zoomed(17), LP.Y - _Zoomed(7));
        P2 := ToCanvas(LP.X - multx * _Zoomed(17), LP.Y + _Zoomed(7));
        P3 := ToCanvas(LP.X, LP.Y);
        P4 := ToCanvas(LP.X - multx * _Zoomed(17), LP.Y);

        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P2.X, P2.Y);
        AInfo.Canvas.MoveTo(P3.X, P3.Y);
        AInfo.Canvas.LineTo(P4.X, P4.Y);
      end
      else
      begin
        P1 := ToCanvas(LP.X - _Zoomed(7), LP.Y - multy * _Zoomed(17));
        P2 := ToCanvas(LP.X + _Zoomed(7), LP.Y - multy * _Zoomed(17));
        P3 := ToCanvas(LP.X, LP.Y);
        P4 := ToCanvas(LP.X, LP.Y - multy * _Zoomed(17));

        AInfo.Canvas.MoveTo(P1.X, P1.Y);
        AInfo.Canvas.LineTo(P2.X, P2.Y);
        AInfo.Canvas.MoveTo(P3.X, P3.Y);
        AInfo.Canvas.LineTo(P4.X, P4.Y);
      end;
    end;
  end;
end;

{ TDiagramNoteBlock }

constructor TDiagramNoteBlock.Create(AOwner: TComponent);
begin
  inherited;
  Restrictions := [crNoRotation];
  Shape := bsRectangle;
  Alignment := taCenter;
  LinkPointStyle := ptNone;
  Color := clInfoBk;
  MinHeight := 15;
  MinWidth := MinHeight;
  ClipText := true;
end;

procedure TDiagramNoteBlock.DrawBlock(AInfo: TDiagramDrawInfo; ABlockInfo: TDiagramDrawBlockInfo);
var
  R: TRect;
begin
  Drawer.Canvas := AInfo.Canvas;
  //Drawer.CurRect := ARect;
  Drawer.Angle := Angle;
  with Drawer, Canvas do
  begin
    Brush.Color := Diagram.Color;
    R := ToRect(ABlockInfo.Rect);
    FillRect(R);
    Brush.Color := Self.Color;
    Pen := Self.Pen;
    MoveTo(R.Left, R.Top);
    LineTo(R.Left, R.Bottom);
    LineTo(R.Right, R.Bottom);
    LineTo(R.Right, R.Top+10);
    LineTo(R.Right-10, R.Top);
    LineTo(R.Left, R.Top);
    MoveTo(R.Right-10, R.Top);
    LineTo(R.Right-10, R.Top+10);
    LineTo(R.Right, R.Top+10);
    Brush.Color := Self.Color;
    FillRect(Rect(R.Left+1, R.Top+1, R.Right-10, R.Bottom));
    FillRect(Rect(R.Right-10, R.Top+11, R.Right, R.Bottom));
  end;
end;

initialization
  RegisterClasses([TTableDiagramBlock, TRelationshipDiagramLine, TDiagramNoteBlock]);

end.
