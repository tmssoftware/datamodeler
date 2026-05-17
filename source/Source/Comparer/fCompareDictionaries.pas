unit fCompareDictionaries;

interface

uses
  Windows, Types, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, uGDAO, dgCompare, Dialogs, ActnList, StdCtrls, Math, fSQLEditor,
  ExtCtrls, Buttons, ComCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit,
  uAppMetaData, ImgList, dgDBActions, dgDBStructurer, dgConsts, HTMLabel,
  Menus, Clipbrd, VirtualTrees, VirtualTrees.Types, clisted, uDBConnect, fScriptViewer,
  System.ImageList, System.Actions, Contnrs;

type
  TActionTableProp = (atpNone, atpField, atpIndex, atpConstraint, atpRelationship, atpTrigger);

  TCompareMode = (cmProjects, cmVersions);

  TDictionaryTreeNodeType =
    (tntNone, tntTable, tntField, tntIndex,
     tntConstraint, tntRelationship, tntTrigger, tntObject, tntDomain,
     tntComments);
  TDictionaryTreeNodeTypes = set of TDictionaryTreeNodeType;

  TNodeCompareState = (csEqual, csDifferent);

  TSelectDiffActionEvent = procedure(ActionIndex: integer; Select: boolean) of object;

  TTreeRootType = (trtNone, trtTable, trtObject, trtDomain);

  TDictionaryTreeNode = class;
  TDictionaryTreeNodes = class;

  TfmCompareDictionaries = class(TForm)
    popScript: TPopupMenu;
    Copyscripttoclipboard1: TMenuItem;
    popDiffAction: TPopupMenu;
    miDiffApply: TMenuItem;
    miDiffIgnore: TMenuItem;
    N1: TMenuItem;
    miDiffApplyAll: TMenuItem;
    miDiffIgnoreAll: TMenuItem;
    ActionList1: TActionList;
    acNext: TAction;
    acCancel: TAction;
    acBack: TAction;
    imlDictionary: TImageList;
    imlActionArrow: TImageList;
    lbDifferences: TLabel;
    pnTreeViews: TPanel;
    pnScript: TPanel;
    Splitter1: TSplitter;
    pnScriptBase: TPanel;
    box1: TScrollBox;
    htmScriptBase: THTMLabel;
    pnScriptTarget: TPanel;
    box2: TScrollBox;
    htmScriptTarget: THTMLabel;
    pnBaseDictionary: TPanel;
    pnTargetDictionary: TPanel;
    GroupBox1: TGroupBox;
    chDiffHideUnchanged: TCheckBox;
    Splitter2: TSplitter;
    cleDiffObjects: TCheckListEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbDiffAction: TComboBox;
    imlActionCheck: TImageList;
    tmCompare: TTimer;
    procedure chDiffHideUnchangedClick(Sender: TObject);
    procedure htmScriptBaseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure htmScriptTargetMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Copyscripttoclipboard1Click(Sender: TObject);
    procedure miDiffApplyClick(Sender: TObject);
    procedure miDiffApplyAllClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure tmCompareTimer(Sender: TObject);
  private
    FBaseDictionary: TGDAODatabase;
    FTargetDictionary: TGDAODatabase;
    FMode: TCompareMode;
    FSQLFilter: TSQLScriptFilter;

    FRedoingComparison: boolean;
    FCompareByIds: boolean;
    FApplicationIdle: TIdleEvent;
    FApplyAction: array of boolean;
    FBaseDictionaryTree: TVirtualStringTree;
    FBaseScript: TStrings;
    FCanApplyChanges: boolean;
    FClipScript: TStrings;
    FCurrentMetaData: TAppMetaData;
    FDictionaryTreeNodes: TDictionaryTreeNodes;
    FImageListAction: TImageList;
    FLastScriptNode: TDictionaryTreeNode;
    FListActions: TatDBActionList;
    FStructurer: TDBStructurer;
    FTargetDictionaryTree: TVirtualStringTree;
    FTargetScript: TStrings;
    FTreeChanging: boolean;
    function MouseInControl(AControl: TControl): boolean;

    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    function CreateDictionaryTree(AParent: TWinControl; ABase: boolean): TVirtualStringTree;

    function DictionaryContainsObject(ATree: TBaseVirtualTree; ANode: TDictionaryTreeNode): boolean;
    procedure DictionarySelectDiffAction(AActionIndex: integer; ASelect: boolean);
    procedure DictionaryTreeAfterCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure DictionaryTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure DictionaryTreeCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure DictionaryTreeCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure DictionaryTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure DictionaryTreeGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure DictionaryTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: UnicodeString);
    procedure DictionaryTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure DictionaryTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DictionaryTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure DictionaryTreeScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: Integer);

    function DistinctCollectionList(ACollection1, ACollection2: TCollection): TStringList;

    procedure FillDictionaryTree(ABase, ATarget: TGDAODatabase; AActions: TatDBActionList);
    procedure FillDomains(ANode: TDictionaryTreeNode; ABaseDomains, ATargetDomains: TGDAODomains);
    procedure FillObjects(ANode: TDictionaryTreeNode; ABaseObjects, ATargetObjects: TGDAOObjects);
    procedure FillTables(ANode: TDictionaryTreeNode; ABaseTables, ATargetTables: TGDAOTables);
    procedure FillTable(ANode: TDictionaryTreeNode; ABaseTable, ATargetTable: TGDAOTable);
    procedure FillTableConstraints(ANode: TDictionaryTreeNode; ABaseConstraints, ATargetConstraints: TGDAOConstraints);
    procedure FillTableFields(ANode: TDictionaryTreeNode; ABaseFields, ATargetFields: TGDAOFields);
    procedure FillTableIndexes(ANode: TDictionaryTreeNode; ABaseIndexes, ATargetIndexes: TGDAOIndexes);
    procedure FillTableRelationships(ANode: TDictionaryTreeNode; ABaseTable, ATargetTable: TGDAOTable);
    procedure FillTableTriggers(ANode: TDictionaryTreeNode; ABaseTriggers, ATargetTriggers: TGDAOTriggers);

    procedure FilterTreeNodes(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: boolean);

    function GetFilterNodeTypes: TDictionaryTreeNodeTypes;
    function GetCategoryFilter: TGDAOCategoryTypes;

    procedure InitFilterOptions;
    procedure ShowObjectScript(ANode: TDictionaryTreeNode);

    procedure TreeDiff(ADictionary: TGDAODatabase; AType: TTreeRootType; AObject, AAttribute: string;
      ATableProp: TActionTableProp; AChanged: boolean; AActionIndex: integer);
    procedure TreeDiffChange(ADictionary: TGDAODatabase; AAction: TatDBAction; AActionIndex: integer);
    procedure TreeDiffDel(ADictionary: TGDAODatabase; AAction: TatDBAction; AActionIndex: integer);
    procedure TreeDiffNew(ADictionary: TGDAODatabase; AAction: TatDBAction; AActionIndex: integer);
    procedure TreeSetDiffAction(ANode: TDictionaryTreeNode; AAction: integer);

    {Refresh both tree views visually}
    procedure UpdateDictionaryTrees;
    function RedoComparison: boolean;
    procedure ApplyTreeFilters;
    procedure UpdateSQLScriptFilter;
  public
    destructor Destroy; override;
    function IsApplyChangesSelected: boolean;
    procedure ApplySelectedActions(AScriptViewer: TScriptViewer=nil);
    function CompareDictionaries(ACurrentMetaData: TAppMetaData; ABaseDictionary, AReferenceDictionary: TGDAODatabase; AMode: TCompareMode): boolean;
    function HasSelectedActions: boolean;
    procedure Focus;
    procedure SetDictionaryCaptions(ABase, ATarget: string);
  end;

  TDictionaryTreeNodes = class(TCollection)
  private
    FOwner: TDictionaryTreeNode;
    FOnSelectDiffAction: TSelectDiffActionEvent;
    function GetItems(i: integer): TDictionaryTreeNode;
    procedure SetItems(i: integer; const Value: TDictionaryTreeNode);
    function Add(ACaption: string; AType: TDictionaryTreeNodeType; ABaseObject,
      ATargetObject: TObject; AImageIndex: integer;
      ACategoryType: TGDAOCategoryType = dgConsts.ctNone): TDictionaryTreeNode;
    procedure DoSelectDiffAction(AActionIndex: integer; ASelect: boolean);
    procedure ExchangeObjects;
    property OnSelectDiffAction: TSelectDiffActionEvent read FOnSelectDiffAction write FOnSelectDiffAction;
  public
    constructor Create(AOwner: TDictionaryTreeNode);
    property Items[i: integer]: TDictionaryTreeNode read GetItems write SetItems; default;
  end;

  TDictionaryTreeNode = class(TCollectionItem)
  private
    FCaption: string;
    FCompareState: TNodeCompareState;
    FImageIndex: integer;
    FBaseNode: PVirtualNode;
    FBaseObject: TObject;
    FTargetNode: PVirtualNode;
    FTargetObject: TObject;
    FNodeType: TDictionaryTreeNodeType;
    FCategoryType: TGDAOCategoryType;
    FParent: TDictionaryTreeNode;
    FNodes: TDictionaryTreeNodes;
    FDiffAction: integer;
    FActionIndex: array[0..4] of integer; //More than one action can be associated with the node
    procedure SetCompareState(const Value: TNodeCompareState);
    procedure SetDiffAction(const Value: integer);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure FullCompareState;
    procedure FullDiffAction;
    procedure GetParentObjects(AType: TDictionaryTreeNodeType; var ABase, ATarget: TObject);
    procedure ParentDiffAction;
    procedure SiblingDiffAction(ADiffAction: integer);
    procedure ToggleAction;
    property Caption: string read FCaption write FCaption;
    property CompareState: TNodeCompareState read FCompareState write SetCompareState;
    property ImageIndex: integer read FImageIndex write FImageIndex;
    property BaseNode: PVirtualNode read FBaseNode write FBaseNode;
    property BaseObject: TObject read FBaseObject write FBaseObject;
    property TargetNode: PVirtualNode read FTargetNode write FTargetNode;
    property TargetObject: TObject read FTargetObject write FTargetObject;
    property NodeType: TDictionaryTreeNodeType read FNodeType write FNodeType;
    property CategoryType: TGDAOCategoryType read FCategoryType write FCategoryType;
    property DiffAction: integer read FDiffAction write SetDiffAction;
    //property ActionIndex: integer read FActionIndex write FActionIndex;
    property Parent: TDictionaryTreeNode read FParent;
    property Nodes: TDictionaryTreeNodes read FNodes;
  end;

implementation

uses
  Diff, HashUnit, uStrings, dgMacroDBStructurer;
  
{$R *.dfm}

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    DNode: TDictionaryTreeNode;
  end;

  PFilterRec = ^TFilterRec;
  TFilterRec = record
    HideUnchanged: boolean;
    NodeTypes: TDictionaryTreeNodeTypes;
    CategoryFilter: TGDAOCategoryTypes;
  end;

const
  COLUMN_DICTIONARY      = 0;
  COLUMN_DIFF            = 1;

  NODETEXT_TABLES        = 'Tables';
  NODETEXT_FIELDS        = 'Fields';
  NODETEXT_INDEXES       = 'Indexes';
  NODETEXT_CONSTRAINTS   = 'Constraints';
  NODETEXT_RELATIONSHIPS = 'Relationships';
  NODETEXT_TRIGGERS      = 'Triggers';
  NODETEXT_DOMAINS       = 'Domains';
  NODETEXT_NOTEXISTS     = '(not exists)';

  NODEIMAGE_FOLDER       = 1;
  NODEIMAGE_TABLE        = 2;
  NODEIMAGE_FIELD        = 3;
  NODEIMAGE_INDEX        = 4;
  NODEIMAGE_CONSTRAINT   = 5;
  NODEIMAGE_RELATIONSHIP = 6;
  NODEIMAGE_TRIGGER      = 7;
  NODEIMAGE_OBJECT       = 8;
  NODEIMAGE_PROCEDURE    = 9;
  NODEIMAGE_VIEW         = 10;
  NODEIMAGE_GENERATOR    = 11;
  NODEIMAGE_DOMAIN       = 12;

  DIFFACTION_DIFF        = 0;
  DIFFACTION_APPLYTARGET = 1;

  KindColor: array[TChangeKind] of string = ('#FFFFFF', '#FFAAAA', '#AAAAFF', '#AAFFAA');
  
{ TfrCompareDictionaries }

procedure TfmCompareDictionaries.AppEventsIdle(Sender: TObject; var Done: Boolean);
begin
  if MouseInControl(pnScriptBase) then
  begin
    box2.VertScrollBar.Position := box1.VertScrollBar.Position;
    box2.HorzScrollBar.Position := box1.HorzScrollBar.Position;
  end
  else
  if MouseInControl(pnScriptTarget) then
  begin
    box1.VertScrollBar.Position := box2.VertScrollBar.Position;
    box1.HorzScrollBar.Position := box2.HorzScrollBar.Position;
  end;

  if Assigned(FApplicationIdle) then
    FApplicationIdle(Sender, Done);
end;

procedure TfmCompareDictionaries.ApplySelectedActions(AScriptViewer: TScriptViewer);
var
  script: boolean;
  listApply: TatDBActionList;
  slScript: TStringList;
  i: integer;
  applySQL: TApplySQLEvent;
begin
  listApply := TatDBActionList.Create(false);
  slScript := TStringList.Create;
  try
    for i := 0 to FListActions.Count - 1 do
      if FApplyAction[i] then
        listApply.Add(FListActions.Items[i]);

    script := not IsApplyChangesSelected;

    if script then
    begin
      applySQL := nil;
      FStructurer.GenerateScriptSQL(listApply, slScript);
      if Assigned(AScriptViewer) then
        AScriptViewer.SetScript(slScript.Text, nil, applySQL)
      else
        TScriptViewer.ShowSql(slScript.Text, nil, applySQL);
    end
    else
    begin
      for i := 0 to listApply.Count - 1 do
        TatDBAction(listApply.Items[i]).ApplyDBAction(FCurrentMetaData.DataDictionary);
      FCurrentMetaData.OnModify(FCurrentMetaData);
      if Assigned(Owner) then
        TForm(Owner).Close;
    end;

  finally
    listApply.Free;
    slScript.Free;
  end;
end;

procedure TfmCompareDictionaries.ApplyTreeFilters;
var
  filter: PFilterRec;
begin
  FTreeChanging := True;
  FBaseDictionaryTree.BeginUpdate;
  FTargetDictionaryTree.BeginUpdate;
  New(filter);
  try
    filter.HideUnchanged := chDiffHideUnchanged.Checked;
    filter.NodeTypes := GetFilterNodeTypes;
    filter.CategoryFilter := GetCategoryFilter;

    FBaseDictionaryTree.IterateSubTree(nil, FilterTreeNodes, filter, [], True);
    FTargetDictionaryTree.IterateSubTree(nil, FilterTreeNodes, filter, [], True);

    ShowObjectScript(FLastScriptNode);
  finally
    Dispose(filter);
    FBaseDictionaryTree.EndUpdate;
    FTargetDictionaryTree.EndUpdate;
    FTreeChanging := False;
  end;
end;

procedure TfmCompareDictionaries.chDiffHideUnchangedClick(Sender: TObject);
begin
  tmCompare.Enabled := false;
  tmCompare.Enabled := true;
end;

function TfmCompareDictionaries.CompareDictionaries(ACurrentMetaData: TAppMetaData; ABaseDictionary,
  AReferenceDictionary: TGDAODatabase; AMode: TCompareMode): boolean;
begin
  if FCurrentMetaData <> ACurrentMetaData then
  begin
    FCurrentMetaData := ACurrentMetaData;
    FCanApplyChanges := AMode = cmProjects;
    InitFilterOptions;
  end;

  case AMode of
    cmProjects: FImageListAction := imlActionArrow;
    cmVersions: FImageListAction := imlActionCheck;
  end;
  popDiffAction.Images := FImageListAction;

  if not Assigned(FStructurer) then
    FStructurer := TDBStructurer.Create(FCurrentMetaData.DataDictionary.DatabaseType);

  FCompareByIds := AMode = cmVersions;

  FBaseDictionary := ABaseDictionary;
  FTargetDictionary := AReferenceDictionary;
  FMode := AMode;

  result := RedoComparison;
end;

function TfmCompareDictionaries.RedoComparison: boolean;
var
  i: integer;
begin
  FRedoingComparison := true;
  try
    UpdateSQLScriptFilter;

    if Assigned(FListActions) then
      FreeAndNil(FListActions);
    FListActions := CompareDatabases(FBaseDictionary, FTargetDictionary, FCompareByIds, FSQLFilter);

    SetLength(FApplyAction, 0);
    SetLength(FApplyAction, FListActions.Count);
    for i := Low(FApplyAction) to High(FApplyAction) do
      FApplyAction[i] := True;

    result := FListActions.Count > 0;

    //if result then
    begin
      { collection of objects (merged dictionaries) }
      FillDictionaryTree(FTargetDictionary, FBaseDictionary, FListActions);

      if FMode = cmVersions then
        FDictionaryTreeNodes.ExchangeObjects;

      UpdateDictionaryTrees;
      for i := 0 to FDictionaryTreeNodes.Count - 1 do
        TreeSetDiffAction(FDictionaryTreeNodes[i], DIFFACTION_APPLYTARGET);

      //reapply actions (all FApplyAction set to true). Maybe not needed
    end;
    ApplyTreeFilters;
  finally
    FRedoingComparison := false;
  end;
end;

procedure TfmCompareDictionaries.Copyscripttoclipboard1Click(Sender: TObject);
begin
  if Assigned(FClipScript) then
    Clipboard.AsText := FClipScript.Text;
end;

function TfmCompareDictionaries.CreateDictionaryTree(AParent: TWinControl; ABase: boolean): TVirtualStringTree;
begin
  result := TVirtualStringTree.Create(Self);
  with result do
  begin
    Parent := AParent;
    Align := alClient;
    BevelEdges := [];
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Color := clCream;
    Colors.BorderColor := clWindowText;
    Colors.HotColor := clBlack;
    Colors.UnfocusedSelectionColor := clHighlight;
    Colors.UnfocusedSelectionBorderColor := clHighlight;
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -11;
    Font.Name := 'Verdana';
    Font.Style := [];
    Header.AutoSizeIndex := 0;
    Header.Background := clBtnHighlight;
    Header.Font.Charset := DEFAULT_CHARSET;
    Header.Font.Color := clWindowText;
    Header.Font.Height := -11;
    Header.Font.Name := 'Verdana';
    Header.Font.Style := [fsBold];
    Header.Height := 21;
    Header.Options := [hoAutoResize, hoColumnResize, hoDrag, hoVisible];
    Header.Style := hsPlates;
    Images := imlDictionary;
    StateImages := imlDictionary;
    IncrementalSearch := isVisibleOnly;
    ParentFont := False;
    TreeOptions.SelectionOptions := [toFullRowSelect];
    with Header.Columns.Add do
    begin
      Position := 0;
      Width := (pnTreeViews.Width div 2) - 25;
    end;

    OnChange := DictionaryTreeChange;
    OnCollapsed := DictionaryTreeCollapsed;
    OnCompareNodes := DictionaryTreeCompareNodes;
    OnExpanded := DictionaryTreeCollapsed;
    OnGetText := DictionaryTreeGetText;
    OnGetImageIndex := DictionaryTreeGetImageIndex;
    OnInitNode := DictionaryTreeInitNode;
    OnScroll := DictionaryTreeScroll;
    OnPaintText := DictionaryTreePaintText;

    if ABase then
    begin
      ScrollBarOptions.ScrollBars := ssHorizontal;
      OnAfterCellPaint := DictionaryTreeAfterCellPaint;
      OnMouseDown := DictionaryTreeMouseDown;
      OnGetPopupMenu := DictionaryTreeGetPopupMenu;
      with Header.Columns.Add do
      begin
        Alignment := taCenter;
        Position := 1;
        Style := vsOwnerDraw;
        Text := 'Diff';
        Width := 50;
        Options := Options - [coResizable];
      end;
    end;
  end;
end;

destructor TfmCompareDictionaries.Destroy;
begin
  if Assigned(FListActions) then
    FreeAndNil(FListActions);
  inherited;
end;

function TfmCompareDictionaries.DictionaryContainsObject(ATree: TBaseVirtualTree; ANode: TDictionaryTreeNode): boolean;
begin
  result := ((ATree = FBaseDictionaryTree) and Assigned(ANode.BaseObject))
    or ((ATree = FTargetDictionaryTree) and Assigned(ANode.TargetObject));
end;

procedure TfmCompareDictionaries.DictionarySelectDiffAction(AActionIndex: integer; ASelect: boolean);
begin
  FApplyAction[AActionIndex] := ASelect;
end;

procedure TfmCompareDictionaries.DictionaryTreeAfterCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  ndata: PNodeRec;
begin
  if Column = COLUMN_DIFF then
  begin
    ndata := Sender.GetNodeData(Node);
    if Assigned(ndata) and (ndata.DNode.CompareState = csDifferent) then
      FImageListAction.Draw(TargetCanvas, CenterPoint(CellRect).X - 8, CenterPoint(CellRect).Y - 8, ndata.DNode.DiffAction);
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ndata: PNodeRec;
  mirrorTree: TVirtualStringTree;
  mirrorNode: PVirtualNode;
begin
  if not FTreeChanging and Assigned(Node) then
  begin
    FTreeChanging := True;
    try
      ndata := Sender.GetNodeData(Node);

      if Sender = FBaseDictionaryTree then
      begin
        mirrorTree := FTargetDictionaryTree;
        mirrorNode := ndata.DNode.TargetNode;
      end
      else
      begin
        mirrorTree := FBaseDictionaryTree;
        mirrorNode := ndata.DNode.BaseNode;
      end;

      if Assigned(mirrorNode) then
      begin
        mirrorTree.Selected[mirrorNode] := True;
        mirrorTree.FocusedNode := mirrorNode;
      end;

      ShowObjectScript(ndata.DNode);
    finally
      FTreeChanging := False;
    end;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ndata: PNodeRec;
  mirrorTree: TVirtualStringTree;
  mirrorNode: PVirtualNode;
begin
  if not FTreeChanging then
  begin
    FTreeChanging := True;
    try
      ndata := Sender.GetNodeData(Node);

      if Sender = FBaseDictionaryTree then
      begin
        mirrorTree := FTargetDictionaryTree;
        mirrorNode := ndata.DNode.TargetNode;
      end
      else
      begin
        mirrorTree := FBaseDictionaryTree;
        mirrorNode := ndata.DNode.BaseNode;
      end;

      if Assigned(mirrorNode) then
        mirrorTree.ToggleNode(mirrorNode);

    finally
      FTreeChanging := False;
    end;

    {Now if the selected node was collapsed, then we must reselect
     the collapsed node. We do this after setting FTreeChanging to false,
     so it will behave exactly like a user selection with mouse click}
    with FBaseDictionaryTree do
      if HasAsParent(GetFirstSelected, Node) then
      begin
        Selected[Node] := True;
        FocusedNode := Node;
      end;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  ndata1, ndata2: PNodeRec;
begin
  ndata1 := Sender.GetNodeData(Node1);
  ndata2 := Sender.GetNodeData(Node2);
  if Assigned(ndata1) and Assigned(ndata2) then
    Result := AnsiCompareText(ndata1.DNode.Caption, ndata2.DNode.Caption);
end;

procedure TfmCompareDictionaries.DictionaryTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  ndata: PNodeRec;
begin
  if (Column = COLUMN_DICTIONARY) and not (Kind in [ikState]) then
  begin
    ndata := Sender.GetNodeData(Node);
    if Assigned(ndata) then
      ImageIndex := ndata.DNode.ImageIndex;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  ndata: PNodeRec;
begin
  if Column = COLUMN_DIFF then
  begin
    ndata := Sender.GetNodeData(Node);
    if Assigned(ndata) and (ndata.DNode.CompareState = csDifferent) then
    begin
      miDiffApply.Checked := ndata.DNode.DiffAction = DIFFACTION_APPLYTARGET;
      miDiffIgnore.Checked := ndata.DNode.DiffAction = DIFFACTION_DIFF;
      popDiffAction.Tag := integer(ndata.DNode);
      PopupMenu := popDiffAction;
    end;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: UnicodeString);
var
  ndata: PNodeRec;
begin
  CellText := '';
  if Column = COLUMN_DICTIONARY then
  begin
    ndata := Sender.GetNodeData(Node);
    if Assigned(ndata) then
      if DictionaryContainsObject(Sender, ndata.DNode) or (ndata.DNode.ImageIndex = NODEIMAGE_FOLDER) then
      begin
        CellText := ndata.DNode.Caption;

        {Custom field and table name}
        if Sender = FBaseDictionaryTree then
        begin
          if (ndata.DNode.BaseObject is TGDAOTable) and (ndata.DNode.NodeType = tntTable) then
            CellText := TGDAOTable(ndata.DNode.BaseObject).TableName
          else
          if (ndata.DNode.BaseObject is TGDAOField) and (ndata.DNode.NodeType = tntField) then
            CellText := TGDAOField(ndata.DNode.BaseObject).FieldName;
        end else
        begin
          if (ndata.DNode.TargetObject is TGDAOTable) and (ndata.DNode.NodeType = tntTable) then
            CellText := TGDAOTable(ndata.DNode.TargetObject).TableName
          else
          if (ndata.DNode.TargetObject is TGDAOField) and (ndata.DNode.NodeType = tntField) then
            CellText := TGDAOField(ndata.DNode.TargetObject).FieldName;
        end;
      end
      else
        Celltext := NODETEXT_NOTEXISTS;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  ndata, parentData: PNodeRec;
  showItem: boolean;
begin
  ndata := Sender.GetNodeData(Node);

  if Assigned(ParentNode) then // sub nodes
  begin
    parentData := Sender.GetNodeData(ParentNode);

    if Assigned(parentData) then
    begin
      ndata.DNode := parentData.DNode.Nodes[Node.Index];
      Sender.ChildCount[Node] := TDictionaryTreeNode(ndata.DNode).Nodes.Count;
    end;
  end
  else // root nodes
  begin
    ndata.DNode := FDictionaryTreeNodes[Node.Index];
    Sender.ChildCount[Node] := TDictionaryTreeNode(ndata.DNode).Nodes.Count;
  end;

  if Sender = FBaseDictionaryTree then
    ndata.DNode.BaseNode := Node
  else
    ndata.DNode.TargetNode := Node;

  { hide folder nodes without children }
  showItem := (ndata.DNode.ImageIndex <> NODEIMAGE_FOLDER) or (Sender.ChildCount[Node] > 0);

  Sender.IsVisible[Node] := showItem;

  { expand root nodes }
  if showItem then
  begin
    FTreeChanging := True;
    try
      Sender.Expanded[Node] := not Assigned(ParentNode);
    finally
      FTreeChanging := False;
    end;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tree: TVirtualStringTree;
  hitInfo: THitInfo;
  ndata: PNodeRec;
begin
  if Button = mbLeft then
  begin
    tree := TVirtualStringTree(Sender);
    tree.GetHitTestInfoAt(X, Y, True, hitInfo);
    if hitInfo.HitColumn = COLUMN_DIFF then
    begin
      ndata := tree.GetNodeData(hitInfo.HitNode);
      if Assigned(ndata) and (ndata.DNode.CompareState = csDifferent) then
      begin
        ndata.DNode.ToggleAction;
        tree.Invalidate;
      end;
    end;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var ndata: PNodeRec;

  function CheckAction(dn: TDictionaryTreeNode): boolean;
  begin
    result := Assigned(dn) and ((dn.FActionIndex[0] >= 0) or CheckAction(dn.Parent));
  end;

begin
  ndata := Sender.GetNodeData(Node);
  if Assigned(ndata) then
  begin
    if (ndata.DNode.CompareState = csEqual) or not DictionaryContainsObject(Sender, ndata.DNode) then
      TargetCanvas.Font.Color := clGray
    else if CheckAction(ndata.DNode) or ((ndata.DNode.CompareState = csDifferent) and not Sender.Expanded[Node]) then
      TargetCanvas.Font.Style := [fsBold];

    {Always white when selected}
    if Sender.Selected[Node] then
      TargetCanvas.Font.Color := clWhite;
  end;
end;

procedure TfmCompareDictionaries.DictionaryTreeScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: Integer);
var mirrorTree: TVirtualStringTree;
begin
  if not FTreeChanging then
  begin
    FTreeChanging := True;
    try
      if Sender = FBaseDictionaryTree then
        mirrorTree := FTargetDictionaryTree
      else
        mirrorTree := FBaseDictionaryTree;

      Sender.Update;
      mirrorTree.OffsetY := Sender.OffsetY;
      mirrorTree.Update;
    finally
      FTreeChanging := False;
    end;
  end;
end;

function TfmCompareDictionaries.DistinctCollectionList(ACollection1, ACollection2: TCollection): TStringList;
var
  i: integer;
begin
  result := TStringList.Create;
  if Assigned(ACollection1) then
    for i := 0 to ACollection1.Count - 1 do
      result.Add(ACollection1.Items[i].DisplayName);
  if Assigned(ACollection2) then
    for i := 0 to ACollection2.Count - 1 do
      if result.IndexOf(ACollection2.Items[i].DisplayName) < 0 then
        result.Add(ACollection2.Items[i].DisplayName);
end;

type
  TMyDBAction = class(TatDBAction);
  TMyMacroDBStructurer = class(TMacroDBStructurer);

procedure TfmCompareDictionaries.FillDictionaryTree(ABase, ATarget: TGDAODatabase; AActions: TatDBActionList);
var
  i, j: integer;
  node: TDictionaryTreeNode;
  action: TatDBAction;
begin
  { recursive collection to manipulate nodes on treeviews }
  if Assigned(FDictionaryTreeNodes) then
  begin
    FDictionaryTreeNodes.Free;
    FDictionaryTreeNodes := nil;
  end;

  FDictionaryTreeNodes := TDictionaryTreeNodes.Create(nil);
  FDictionaryTreeNodes.OnSelectDiffAction := DictionarySelectDiffAction;

  { clear references to nodes in dictionary objects }
  for i := 0 to ABase.Tables.Count - 1 do
    ABase.Tables[i].Data := nil;
  for i := 0 to ATarget.Tables.Count - 1 do
    ATarget.Tables[i].Data := nil;
  for i := 0 to ABase.Categories.Count - 1 do
    for j := 0 to ABase.Categories[i].Objects.Count - 1 do
      ABase.Categories[i].Objects[j].Data := nil;
  for i := 0 to ATarget.Categories.Count - 1 do
    for j := 0 to ATarget.Categories[i].Objects.Count - 1 do
      ATarget.Categories[i].Objects[j].Data := nil;
  for i := 0 to ABase.Domains.Count - 1 do
    ABase.Domains[i].Data := nil;

  { root node: tables }
  node := FDictionaryTreeNodes.Add(NODETEXT_TABLES, tntTable,
    ABase.Tables, ATarget.Tables, NODEIMAGE_FOLDER);
  FillTables(node, ABase.Tables, ATarget.Tables);

  { root node: domains }
  node := FDictionaryTreeNodes.Add(NODETEXT_DOMAINS, tntDomain,
    ABase.Domains, ATarget.Domains, NODEIMAGE_FOLDER);
  FillDomains(node, ABase.Domains, ATarget.Domains);

  { root nodes: generic objects }
  if ABase.Categories.Count = ATarget.Categories.Count then
    for i := 0 to ABase.Categories.Count - 1 do
    begin
      node := FDictionaryTreeNodes.Add(
        ABase.Categories[i].CategoryNameP,
        tntObject,
        ABase.Categories[i].Objects, ATarget.Categories[i].Objects,
        NODEIMAGE_FOLDER,
        ABase.Categories[i].CategoryType);
      FillObjects(node, ABase.Categories[i].Objects, ATarget.Categories[i].Objects);
    end;

  { actions: differencetes between dictionaries }
  for i := 0 to AActions.Count - 1 do
  begin
    action := TatDBAction(AActions.Items[i]);
    try
      case action.Category of
        caCreate: TreeDiffNew(ABase, action, i);
        caModify: TreeDiffChange(ABase, action, i);
        caRemove: TreeDiffDel(ATarget, action, i);
      end;
    except
      on e: Exception do
        raise EGUIException.CreateFmt('Error at action #%d (%s): %s.', [i, action.classname, e.Message]);
    end;
  end;
end;

procedure TfmCompareDictionaries.FillObjects(ANode: TDictionaryTreeNode; ABaseObjects, ATargetObjects: TGDAOObjects);

  function GetObjectImageIndex(ACatType: TGDAOCategoryType): integer;
  begin
    case ACatType of
      ctProcedure:
        result := NODEIMAGE_PROCEDURE;
      ctView:
        result := NODEIMAGE_VIEW;
      ctSequence:
        result := NODEIMAGE_GENERATOR;
    else
      result := NODEIMAGE_OBJECT;
    end;

  end;

var
  o: integer;
  slObjects: TStringList;
  node: TDictionaryTreeNode;
  baseObject, targetObject: TGDAOObject;
begin
  slObjects := TStringList.Create;
  try
    slObjects.Sorted := True;
    for o := 0 to ABaseObjects.Count - 1 do
      slObjects.Add(ABaseObjects[o].ObjectName);
    for o := 0 to ATargetObjects.Count - 1 do
      if slObjects.IndexOf(ATargetObjects[o].ObjectName) < 0 then
        slObjects.Add(ATargetObjects[o].ObjectName);

    for o := 0 to slObjects.Count - 1 do
    begin
      baseObject := ABaseObjects.FindByName(slObjects[o]);
      targetObject := ATargetObjects.FindByName(slObjects[o]);

      node := ANode.Nodes.Add(slObjects[o], tntObject, baseObject, targetObject,
        GetObjectImageIndex(ABaseObjects.OwnerCategory.CategoryType),
        ABaseObjects.OwnerCategory.CategoryType);
      if Assigned(baseObject) then
        baseObject.Data := node;
      if Assigned(targetObject) then
        targetObject.Data := node;
    end;
  finally
    slObjects.Free;
  end;
end;

procedure TfmCompareDictionaries.FillDomains(ANode: TDictionaryTreeNode; ABaseDomains, ATargetDomains: TGDAODomains);
var
  o: integer;
  slDomains: TStringList;
  node: TDictionaryTreeNode;
  baseDomain, targetDomain: TGDAODomain;
begin
  slDomains := TStringList.Create;
  try
    slDomains.Sorted := True;
    for o := 0 to ABaseDomains.Count - 1 do
      if ABaseDomains[o].InDatabase then
        slDomains.Add(ABaseDomains[o].Name);
    for o := 0 to ATargetDomains.Count - 1 do
      if ATargetDomains[o].InDatabase then
        if slDomains.IndexOf(ATargetDomains[o].Name) < 0 then
          slDomains.Add(ATargetDomains[o].Name);

    for o := 0 to slDomains.Count - 1 do
    begin
      baseDomain := ABaseDomains.FindByName(slDomains[o]);
      targetDomain := ATargetDomains.FindByName(slDomains[o]);

      node := ANode.Nodes.Add(slDomains[o], tntDomain, baseDomain,
        targetDomain, NODEIMAGE_DOMAIN);
      if Assigned(baseDomain) then
        baseDomain.Data := node;
      if Assigned(targetDomain) then
        targetDomain.Data := node;
    end;
  finally
    slDomains.Free;
  end;
end;

procedure TfmCompareDictionaries.FillTable(ANode: TDictionaryTreeNode; ABaseTable, ATargetTable: TGDAOTable);
var
  baseFields, targetFields: TGDAOFields;
  baseIndexes, targetIndexes: TGDAOIndexes;
  baseConstraints, targetConstraints: TGDAOConstraints;
  baseTriggers, targetTriggers: TGDAOTriggers;
begin
  if Assigned(ABaseTable) then
  begin
    baseFields := ABaseTable.Fields;
    baseIndexes := ABaseTable.Indexes;
    baseConstraints := ABaseTable.Constraints;
    baseTriggers := ABaseTable.Triggers;
  end
  else
  begin
    baseFields := nil;
    baseIndexes := nil;
    baseConstraints := nil;
    baseTriggers := nil;
  end;

  if Assigned(ATargetTable) then
  begin
    targetFields := ATargetTable.Fields;
    targetIndexes := ATargetTable.Indexes;
    targetConstraints := ATargetTable.Constraints;
    targetTriggers := ATargetTable.Triggers;
  end
  else
  begin
    targetFields := nil;
    targetIndexes := nil;
    targetConstraints := nil;
    targetTriggers := nil;
  end;

  // fields
  if Assigned(baseFields) and (baseFields.Count > 0) or Assigned(targetFields) and (targetFields.Count > 0) then
    FillTableFields(
      ANode.Nodes.Add(NODETEXT_FIELDS, tntField, baseFields, targetFields, NODEIMAGE_FOLDER),
      baseFields, targetFields);

  // indexes
  if Assigned(baseIndexes) and (baseIndexes.Count > 0) or Assigned(targetIndexes) and (targetIndexes.Count > 0) then
    FillTableIndexes(
      ANode.Nodes.Add(NODETEXT_INDEXES, tntIndex, baseIndexes, targetIndexes, NODEIMAGE_FOLDER),
      baseIndexes, targetIndexes);

  // constraints
  if Assigned(baseConstraints) and (baseConstraints.Count > 0) or Assigned(targetConstraints) and (targetConstraints.Count > 0) then
    FillTableConstraints(
      ANode.Nodes.Add(NODETEXT_CONSTRAINTS, tntConstraint, baseConstraints, targetConstraints, NODEIMAGE_FOLDER),
      baseConstraints, targetConstraints);

  // relationships
  if Assigned(ABaseTable) and ABaseTable.HasForeignFields or Assigned(ATargetTable) and ATargetTable.HasForeignFields then
    FillTableRelationships(
      ANode.Nodes.Add(NODETEXT_RELATIONSHIPS, tntRelationship, ABaseTable, ATargetTable, NODEIMAGE_FOLDER),
      ABaseTable, ATargetTable);

  // triggers
  if Assigned(baseTriggers) and (baseTriggers.Count > 0) or Assigned(targetTriggers) and (targetTriggers.Count > 0) then
    FillTableTriggers(
      ANode.Nodes.Add(NODETEXT_TRIGGERS, tntTrigger, baseTriggers, targetTriggers, NODEIMAGE_FOLDER),
      baseTriggers, targetTriggers)
end;

procedure TfmCompareDictionaries.FillTableConstraints(ANode: TDictionaryTreeNode; ABaseConstraints, ATargetConstraints: TGDAOConstraints);
var
  c: Integer;
  slConstraints: TStringList;
  node: TDictionaryTreeNode;
  baseConstraint, targetConstraint: TGDAOConstraint;
begin
  slConstraints := DistinctCollectionList(ABaseConstraints, ATargetConstraints);
  try
    for c := 0 to slConstraints.Count - 1 do
    begin
      if Assigned(ABaseConstraints) and (ABaseConstraints.IndexOf(slConstraints[c]) >= 0) then
        baseConstraint := ABaseConstraints[ABaseConstraints.IndexOf(slConstraints[c])]
      else
        baseConstraint := nil;
      if Assigned(ATargetConstraints) and (ATargetConstraints.IndexOf(slConstraints[c]) >= 0) then
        targetConstraint := ATargetConstraints[ATargetConstraints.IndexOf(slConstraints[c])]
      else
        targetConstraint := nil;

      node := ANode.Nodes.Add(slConstraints[c], tntConstraint, baseConstraint, targetConstraint, NODEIMAGE_CONSTRAINT);

      if Assigned(baseConstraint) then
        baseConstraint.Data := node;
      if Assigned(targetConstraint) then
        targetConstraint.Data := node;
    end;
  finally
    slConstraints.Free;
  end;
end;

procedure TfmCompareDictionaries.FillTableFields(ANode: TDictionaryTreeNode; ABaseFields, ATargetFields: TGDAOFields);
var
  f: integer;
  slFields: TStringList;
  node: TDictionaryTreeNode;
  baseField, targetField: TGDAOField;
begin
  slFields := TStringList.Create;
  try
    slFields.Sorted := True;
    if ABaseFields <> nil then
      for f := 0 to ABaseFields.Count - 1 do
        slFields.AddObject(ABaseFields[f].FieldName, TObject(ABaseFields[f].FID));

    {Add the Fields that doesn't exist in base Fields. Comparison can be by name or id}
    if ATargetFields <> nil then
      for f := 0 to ATargetFields.Count - 1 do
        if FCompareByIds then
        begin
          if slFields.IndexOfObject(TObject(ATargetFields[f].FID)) < 0 then
            slFields.AddObject(ATargetFields[f].FieldName, TObject(ATargetFields[f].FID));
        end else
        begin
          if slFields.IndexOf(ATargetFields[f].FieldName) < 0 then
            slFields.AddObject(ATargetFields[f].FieldName, TObject(ATargetFields[f].FID));
        end;

    for f := 0 to slFields.Count - 1 do
    begin
      baseField := nil;
      targetField := nil;

      if Assigned(ABaseFields) then
      begin
        if FCompareByIds then
          baseField := ABaseFields.FindByID(integer(slFields.Objects[f]))
        else
          baseField := ABaseFields.FindbyName(slFields[f]);
      end;
      if Assigned(ATargetFields) then
      begin
        if FCompareByIds then
          targetField := ATargetFields.FindByID(integer(slFields.Objects[f]))
        else
          targetField := ATargetFields.FindByName(slFields[f]);
      end;

      node := ANode.Nodes.Add(slFields[f], tntField, baseField, targetField, NODEIMAGE_FIELD);

      if Assigned(baseField) then
        baseField.Data := node;
      if Assigned(targetField) then
        targetField.Data := node;
    end;
  finally
    slFields.Free;
  end;
end;

procedure TfmCompareDictionaries.FillTableIndexes(ANode: TDictionaryTreeNode; ABaseIndexes, ATargetIndexes: TGDAOIndexes);
var
  i: Integer;
  slIndexes: TStringList;
  node: TDictionaryTreeNode;
  baseIndex, targetIndex: TGDAOIndex;
begin
  slIndexes := DistinctCollectionList(ABaseIndexes, ATargetIndexes);
  try
    for i := 0 to slIndexes.Count - 1 do
    begin
      if Assigned(ABaseIndexes) and (ABaseIndexes.IndexOf(slIndexes[i]) >= 0) then
        baseIndex := ABaseIndexes[ABaseIndexes.IndexOf(slIndexes[i])]
      else
        baseIndex := nil;
      if Assigned(ATargetIndexes) and (ATargetIndexes.IndexOf(slIndexes[i]) >= 0) then
        targetIndex := ATargetIndexes[ATargetIndexes.IndexOf(slIndexes[i])]
      else
        targetIndex := nil;

      node := ANode.Nodes.Add(slIndexes[i], tntIndex, baseIndex, targetIndex, NODEIMAGE_INDEX);

      if Assigned(baseIndex) then
        baseIndex.Data := node;
      if Assigned(targetIndex) then
        targetIndex.Data := node;
    end;
  finally
    slIndexes.Free;
  end;
end;

procedure TfmCompareDictionaries.FillTableRelationships(ANode: TDictionaryTreeNode; ABaseTable, ATargetTable: TGDAOTable);
var
  r: integer;
  slRelationships: TStringList;
  node: TDictionaryTreeNode;
  baseRelationship, targetRelationship: TGDAORelationship;
begin
  slRelationships := TStringList.Create;
  try
    if Assigned(ABaseTable) then
      with ABaseTable.OwnerDatabase do
        for r := 0 to Relationships.Count - 1 do
          if Relationships[r].ChildTable = ABaseTable then
            slRelationships.Add(Relationships[r].RelationshipName);

    if Assigned(ATargetTable) then
      with ATargetTable.OwnerDatabase do
        for r := 0 to Relationships.Count - 1 do
          if (Relationships[r].ChildTable = ATargetTable) and (slRelationships.IndexOf(Relationships[r].RelationshipName) < 0) then
            slRelationships.Add(Relationships[r].RelationshipName);

    for r := 0 to slRelationships.Count - 1 do
    begin
      if Assigned(ABaseTable) then
        baseRelationship := ABaseTable.OwnerDatabase.RelationshipByName(slRelationships[r])
      else
        baseRelationship := nil;
      if Assigned(ATargetTable) then
        targetRelationship := ATargetTable.OwnerDatabase.RelationshipByName(slRelationships[r])
      else
        targetRelationship := nil;

      node := ANode.Nodes.Add(slRelationships[r], tntRelationship, baseRelationship, targetRelationship, NODEIMAGE_RELATIONSHIP);

      if Assigned(baseRelationship) then
        baseRelationship.Data := node;
      if Assigned(targetRelationship) then
        targetRelationship.Data := node;
    end;
  finally
    slRelationships.Free;
  end;
end;

procedure TfmCompareDictionaries.FillTables(ANode: TDictionaryTreeNode; ABaseTables, ATargetTables: TGDAOTables);
var
  t: integer;
  slTables: TStringList;
  node: TDictionaryTreeNode;
  baseTable, targetTable: TGDAOTable;
begin
  slTables := TStringList.Create;
  try
    slTables.Sorted := True;
    for t := 0 to ABaseTables.Count - 1 do
      slTables.AddObject(ABaseTables[t].TableName, TObject(ABaseTables[t].TID));

    {Add the tables that doesn't exist in base tables. Comparison can be by name or id}
    for t := 0 to ATargetTables.Count - 1 do
      if FCompareByIds then
      begin
        if slTables.IndexOfObject(TObject(ATargetTables[t].TID)) < 0 then
          slTables.AddObject(ATargetTables[t].TableName, TObject(ATargetTables[t].TID));
      end else
      begin
        if slTables.IndexOf(ATargetTables[t].TableName) < 0 then
          slTables.AddObject(ATargetTables[t].TableName, TObject(ATargetTables[t].TID));
      end;

    for t := 0 to slTables.Count - 1 do
    begin
      if FCompareByIds then
      begin
        baseTable := ABaseTables.FindByID(integer(slTables.Objects[t]));
        targetTable := ATargetTables.FindByID(integer(slTables.Objects[t]));
      end else
      begin
        baseTable := ABaseTables.FindByName(slTables[t]);
        targetTable := ATargetTables.FindByName(slTables[t]);
      end;

      node := ANode.Nodes.Add(slTables[t], tntTable, baseTable, targetTable, NODEIMAGE_TABLE);
      if Assigned(baseTable) then
        baseTable.Data := node;
      if Assigned(targetTable) then
        targetTable.Data := node;

      FillTable(node, baseTable, targetTable);
    end;
  finally
    slTables.Free;
  end;
end;

procedure TfmCompareDictionaries.FillTableTriggers(ANode: TDictionaryTreeNode; ABaseTriggers, ATargetTriggers: TGDAOTriggers);
var
  t: Integer;
  slTriggers: TStringList;
  node: TDictionaryTreeNode;
  baseTrigger, targetTrigger: TGDAOTrigger;
begin
  slTriggers := DistinctCollectionList(ABaseTriggers, ATargetTriggers);
  try
    for t := 0 to slTriggers.Count - 1 do
    begin
      if Assigned(ABaseTriggers) and (ABaseTriggers.IndexOf(slTriggers[t]) >= 0) then
        baseTrigger := ABaseTriggers[ABaseTriggers.IndexOf(slTriggers[t])]
      else
        baseTrigger := nil;
      if Assigned(ATargetTriggers) and (ATargetTriggers.IndexOf(slTriggers[t]) >= 0) then
        targetTrigger := ATargetTriggers[ATargetTriggers.IndexOf(slTriggers[t])]
      else
        targetTrigger := nil;

      node := ANode.Nodes.Add(slTriggers[t], tntTrigger, baseTrigger, targetTrigger, NODEIMAGE_TRIGGER);
      if Assigned(baseTrigger) then
        baseTrigger.Data := node;
      if Assigned(targetTrigger) then
        targetTrigger.Data := node;
    end;
  finally
    slTriggers.Free;
  end;
end;

procedure TfmCompareDictionaries.FilterTreeNodes(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: boolean);
var
  ndata: PNodeRec;
begin
  ndata := Sender.GetNodeData(Node);
  if Assigned(ndata) then
    Sender.IsVisible[Node] :=
      ((ndata.DNode.ImageIndex <> NODEIMAGE_FOLDER) or (Sender.ChildCount[Node] > 0))
      and ((ndata.DNode.CompareState = csDifferent) or not PFilterRec(Data).HideUnchanged)
      {and (ndata.DNode.NodeType in PFilterRec(Data).NodeTypes)
      and (
        (ndata.DNode.NodeType <> tntObject) or
        (ndata.DNode.CategoryType in PFilterRec(Data).CategoryFilter)
        )};
end;

procedure TfmCompareDictionaries.Focus;
begin
  if Assigned(FBaseDictionaryTree) and FBaseDictionaryTree.CanFocus then
    FBaseDictionaryTree.SetFocus;
end;

procedure TfmCompareDictionaries.FormCreate(Sender: TObject);
begin
  FSQLFilter := TSQLScriptFilter.Create;

  FApplicationIdle := Application.OnIdle;
  Application.OnIdle := AppEventsIdle;

  FBaseScript := TStringList.Create;
  FTargetScript := TStringList.Create;

  FBaseDictionaryTree := CreateDictionaryTree(pnBaseDictionary, True);
  FTargetDictionaryTree := CreateDictionaryTree(pnTargetDictionary, False);

  FImageListAction := imlActionArrow;
end;

procedure TfmCompareDictionaries.FormDestroy(Sender: TObject);
begin
  Application.OnIdle := FApplicationIdle;

  FBaseScript.Free;
  FTargetScript.Free;
    
  if Assigned(FStructurer) then
    FreeAndNil(FStructurer);
  if Assigned(FDictionaryTreeNodes) then
    FreeAndNil(FDictionaryTreeNodes);

  FSQLFilter.Free;
end;

procedure TfmCompareDictionaries.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if MouseInControl(pnScriptBase) then
  begin
    box1.VertScrollBar.Position :=
      box1.VertScrollBar.Position -
      (WheelDelta div WHEEL_DELTA) * box1.VertScrollBar.Increment * 3;
    Handled := true;
  end
  else
  if MouseInControl(pnScriptTarget) then
  begin
    box2.VertScrollBar.Position :=
      box2.VertScrollBar.Position -
      (WheelDelta div WHEEL_DELTA) * box2.VertScrollBar.Increment * 3;
    Handled := true;
  end;
end;

procedure TfmCompareDictionaries.FormResize(Sender: TObject);
begin
  pnBaseDictionary.Width := (pnTreeViews.Width div 2) + 25;
  pnScriptBase.Width := pnScript.Width div 2;
end;

function TfmCompareDictionaries.GetFilterNodeTypes: TDictionaryTreeNodeTypes;
var
  i: integer;
begin
  result := [];
  for i := 0 to cleDiffObjects.Items.Count - 1 do
    if cleDiffObjects.Checked[i] then
      result := result + [TDictionaryTreeNodeType(cleDiffObjects.Items.Objects[i])];

  result := result + [tntField];
end;

function TfmCompareDictionaries.GetCategoryFilter: TGDAOCategoryTypes;
var
  i: integer;
begin
  result := [];
  for i := 0 to cleDiffObjects.Items.Count - 1 do
    if cleDiffObjects.Checked[i] and (TDictionaryTreeNodeType(cleDiffObjects.Items.Objects[i]) = tntObject) then
      result := result +
        [FCurrentMetaData.DataDictionary.Categories._FindByNameP(
          cleDiffObjects.Items[i]).CategoryType];
end;

function TfmCompareDictionaries.HasSelectedActions: boolean;
var
  i: integer;
begin
  for i := Low(FApplyAction) to High(FApplyAction) do
    if FApplyAction[i] then
    begin
      result := True;
      exit;
    end;
  result := False;
end;

procedure TfmCompareDictionaries.htmScriptBaseMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FClipScript := FBaseScript;
end;

procedure TfmCompareDictionaries.htmScriptTargetMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FClipScript := FTargetScript;
end;

procedure TfmCompareDictionaries.InitFilterOptions;
var i: integer;
begin
  with cleDiffObjects do
  begin
    Items.Clear;
    Items.AddObject(NODETEXT_TABLES, Pointer(tntTable));
    //Items.AddObject(NODETEXT_FIELDS, Pointer(tntField));
    Items.AddObject(NODETEXT_INDEXES, Pointer(tntIndex));
    //Items.AddObject(NODETEXT_CONSTRAINTS, Pointer(tntConstraint));
    Items.AddObject(NODETEXT_RELATIONSHIPS, Pointer(tntRelationship));
    Items.AddObject(NODETEXT_TRIGGERS, Pointer(tntTrigger));
    Items.AddObject(NODETEXT_DOMAINS, Pointer(tntDomain));
    for i := 0 to FCurrentMetaData.DataDictionary.Categories.Count - 1 do
      Items.AddObject(FCurrentMetaData.DataDictionary.Categories[i].CategoryNameP, Pointer(tntObject));
    if FCurrentMetaData.DataDictionary.DatabaseType.ScriptObjectComments then
      Items.AddObject('Object comments', Pointer(tntComments));
    for i := 0 to Items.Count - 1 do
      Checked[i] := True;
  end;

  with cbDiffAction do
  begin
    Items.Clear;

    Items.Add('Generate database script');

    {if FCanApplyChanges then
      Items.Add('Apply changes to project');}
    ItemIndex := 0;
  end;
end;

function TfmCompareDictionaries.IsApplyChangesSelected: boolean;
begin
  result := (FCanApplyChanges) and (cbDiffAction.ItemIndex = 1);
end;

procedure TfmCompareDictionaries.miDiffApplyAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to FDictionaryTreeNodes.Count - 1 do
    TreeSetDiffAction(FDictionaryTreeNodes[i], TMenuItem(Sender).Tag);
  FBaseDictionaryTree.Invalidate;
end;

procedure TfmCompareDictionaries.miDiffApplyClick(Sender: TObject);
begin
  if TDictionaryTreeNode(popDiffAction.Tag).DiffAction <> TMenuItem(Sender).Tag then
  begin
    TDictionaryTreeNode(popDiffAction.Tag).ToggleAction;
    FBaseDictionaryTree.Invalidate;
  end;
end;

function TfmCompareDictionaries.MouseInControl(AControl: TControl): boolean;
begin
  result := PtInRect(
    Rect(
      AControl.ClientOrigin.X,
      AControl.ClientOrigin.Y,
      AControl.ClientOrigin.X + AControl.ClientWidth,
      AControl.ClientOrigin.Y + AControl.ClientHeight),
    Mouse.CursorPos)
end;

procedure TfmCompareDictionaries.SetDictionaryCaptions(ABase, ATarget: string);
begin
  FBaseDictionaryTree.Header.Columns[COLUMN_DICTIONARY].Text := ABase;
  FTargetDictionaryTree.Header.Columns[COLUMN_DICTIONARY].Text := ATarget;
end;

procedure TfmCompareDictionaries.ShowObjectScript(ANode: TDictionaryTreeNode);
var
  objBase, objTarget: TObject;
  s, s1, s2: string;
  i: Integer;
  diff: TDiff;
  lastKind: TChangeKind;
  hash1, hash2: TList;

  procedure ScriptTable(ATable: TGDAOTable; AScript: TStrings);
  var
    i: integer;
    filter: TDictionaryTreeNodeTypes;
  begin
    if Assigned(FStructurer) then
    begin
      filter := GetFilterNodeTypes;
      FStructurer.SQLScript.Clear;

      if FSQLFilter.MustInclude(ATable) then
      begin
        FStructurer.CreateTable(ATable);
        if FSQLFilter.MustIncludeComments then
        begin
          if ATable.Description > '' then
            FStructurer.CommentTable(ATable);
          for i := 0 to ATable.Fields.Count-1 do
            if ATable.Fields[i].Description > '' then
              FStructurer.CommentField(ATable.Fields[i]);
        end;
      end;
        
      for i := 0 to ATable.Indexes.Count - 1 do
        if FSQLFilter.MustInclude(ATable.Indexes[i]) then
          FStructurer.CreateIndex(ATable.Indexes[i]);

      {Do not create constraints manually, because the create table
       command already creates table and fields constraints}
      {if tntConstraint in filter then
        for i := 0 to ATable.Constraints.Count - 1 do
          FStructurer.CreateTableConstraint(ATable.Constraints[i]);}

      if not ATable.OwnerDatabase.DatabaseType.RelationshipsInTablesOnly then
        for i := 0 to ATable.OwnerDatabase.Relationships.Count - 1 do
          if FSQLFilter.MustInclude(ATable.OwnerDatabase.Relationships[i]) then
            if ATable.OwnerDatabase.Relationships[i].ChildTable = ATable then
              FStructurer.CreateRelationship(ATable.OwnerDatabase.Relationships[i]);
            
      for i := 0 to ATable.Triggers.Count - 1 do
        if FSQLFilter.MustInclude(ATable.Triggers[i]) then
        begin
          FStructurer.CreateTrigger(ATable.Triggers[i]);
          if FSQLFilter.MustIncludeComments and (ATable.Triggers[i].Description > '') then
            FStructurer.CommentTrigger(ATable.Triggers[i]);
        end;

      AScript.Text := FStructurer.SQLScript.Text;
    end;
  end;

  procedure ScriptObject(AObject: TGDAOObject; AScript: TStrings);
  begin
    if Assigned(FStructurer) then
    begin
      FStructurer.SQLScript.Clear;
      if FSQLFilter.MustInclude(AObject) then
      begin
        FStructurer.CreateExtraObject(AObject, false);
        if FSQLFilter.MustIncludeComments and (AObject.Description > '') then
          FStructurer.CommentExtraObject(AObject);
      end;
      AScript.Text := FStructurer.SQLScript.Text;
    end;
  end;

  procedure ScriptDomain(ADomain: TGDAODomain; AScript: TStrings);
  begin
    if Assigned(FStructurer) then
    begin
      FStructurer.SQLScript.Clear;
      if FSQLFilter.MustInclude(ADomain) then
      begin
        FStructurer.CreateDomain(ADomain);
        if FSQLFilter.MustIncludeComments and (ADomain.Information > '') then
          FStructurer.CommentDomain(ADomain);
      end;
      AScript.Text := FStructurer.SQLScript.Text;
    end;
  end;

begin
  htmScriptBase.HTMLText.Clear;
  htmScriptTarget.HTMLText.Clear;
  FLastScriptNode := ANode;

  if Assigned(ANode) and (ANode.NodeType <> tntNone) then
  begin
    FBaseScript.Clear;
    FTargetScript.Clear;
    diff := TDiff.Create(Self);
    hash1 := TList.Create;
    hash2 := TList.Create;
    try
      // script
      case ANode.NodeType of
        tntTable, tntField, tntIndex, tntConstraint, tntRelationship, tntTrigger:
          begin
            { script table }
            ANode.GetParentObjects(tntTable, objBase, objTarget);
            if Assigned(objBase) and (objBase is TGDAOTable) then
              ScriptTable(TGDAOTable(objBase), FBaseScript);
            if Assigned(objTarget) and (objTarget is TGDAOTable) then
              ScriptTable(TGDAOTable(objTarget), FTargetScript);
          end;
        tntObject:
          begin
            { script object }
            ANode.GetParentObjects(tntObject, objBase, objTarget);
            if Assigned(objBase) and (objBase is TGDAOObject) then
              ScriptObject(TGDAOObject(objBase), FBaseScript);
            if Assigned(objTarget) and (objTarget is TGDAOObject) then
              ScriptObject(TGDAOObject(objTarget), FTargetScript);
          end;
        tntDomain:
          begin
            { script Domain }
            ANode.GetParentObjects(tntDomain, objBase, objTarget);
            if Assigned(objBase) and (objBase is TGDAODomain) then
              ScriptDomain(TGDAODomain(objBase), FBaseScript);
            if Assigned(objTarget) and (objTarget is TGDAODomain) then
              ScriptDomain(TGDAODomain(objTarget), FTargetScript);
          end;
      end;

      // diff
      if (FBaseScript.Count > 0) and (FTargetScript.Count > 0) then
      begin
        hash1.Capacity := FBaseScript.Count;
        for i := 0 to FBaseScript.Count - 1 do
          hash1.Add(HashLine(FBaseScript[i], True, False));
        hash2.Capacity := FTargetScript.Count;
        for i := 0 to FTargetScript.Count - 1 do
          hash2.Add(HashLine(FTargetScript[i], True, False));

        diff.Execute(PInteger(hash1.list), PInteger(hash2.list), hash1.Count, hash2.Count);

        htmScriptBase.HTMLText.Add('<font bgcolor="#FFFFFF">');
        htmScriptTarget.HTMLText.AddStrings(htmScriptBase.HTMLText);
        lastKind := ckNone;

        for i := 0 to Diff.Count -1 do
          with Diff.Compares[i] do
          begin
            if Kind <> lastKind then
            begin
              s := '</font><font bgcolor="' + KindColor[Kind] + '">';
              htmScriptBase.HTMLText.Add(s);
              htmScriptTarget.HTMLText.Add(s);
            end;

            if (oldIndex1 >= 0) and (oldIndex1 < FBaseScript.Count) then
              s1 := FBaseScript[oldIndex1]
            else
              s1 := '';
            if (oldIndex2 >= 0) and (oldIndex2 < FTargetScript.Count) then
              s2 := FTargetScript[oldIndex2]
            else
              s2 := '';

            if Kind <> ckAdd then
              htmScriptBase.HTMLText.Add(s1)
            else
              htmScriptBase.HTMLText.Add(#9 + Replicate(' ', Length(s2)));

            if Kind <> ckDelete then
              htmScriptTarget.HTMLText.Add(s2)
            else
              htmScriptTarget.HTMLText.Add(#9 + Replicate(' ', Length(s1)));

            htmScriptBase.HTMLText.Add('<br>');
            htmScriptTarget.HTMLText.Add('<br>');
            lastKind := Kind;
          end;

        htmScriptBase.HTMLText.Add('</font>');
        htmScriptTarget.HTMLText.Add('</font>');
      end
      else if FBaseScript.Count > 0 then
        htmScriptBase.HTMLText.Text := StringReplace(FBaseScript.Text, #13#10, '<br>', [rfReplaceAll])
      else if FTargetScript.Count > 0 then
        htmScriptTarget.HTMLText.Text := StringReplace(FTargetScript.Text, #13#10, '<br>', [rfReplaceAll]);

    finally
      diff.Free;
      hash1.Free;
      hash2.Free;
    end;
  end;
end;

procedure TfmCompareDictionaries.tmCompareTimer(Sender: TObject);
begin
  tmCompare.Enabled := false;
  if not FRedoingComparison then
    RedoComparison
  else
    tmCompare.Enabled := true;
end;

procedure TfmCompareDictionaries.TreeDiff(ADictionary: TGDAODatabase; AType: TTreeRootType; AObject, AAttribute: string;
  ATableProp: TActionTableProp; AChanged: boolean; AActionIndex: integer);
var
  table: TGDAOTable;
  field: TGDAOField;
  relationship: TGDAORelationship;
  trigger: TGDAOTrigger;
  category: TGDAOCategory;
  dobject: TGDAOObject;
  domain: TGDAODomain;
  dnode: TObject;
  i: integer;
begin
  dnode := nil;

  case AType of
    trtTable: { table attribute change }
      begin
        table := ADictionary.TableByName(AObject);
        if Assigned(table) then
        begin
          dnode := table.Data;

          if ATableProp <> atpNone then
          begin
            dnode := nil;

            case ATableProp of
              atpField:
                begin
                  field := table.FieldByName(AAttribute);
                  if Assigned(field) then
                    dnode := field.Data;
                end;
              atpIndex:
                begin
                  i := table.Indexes.IndexOf(AAttribute);
                  if i >= 0 then
                    dnode := table.Indexes[i].Data;
                end;
              atpConstraint:
                begin
                  i := table.Constraints.IndexOf(AAttribute);
                  if i >= 0 then
                    dnode := table.Constraints[i].Data;
                end;
              atpRelationship:
                begin
                  relationship := ADictionary.RelationshipByName(AAttribute);
                  if Assigned(relationship) then
                    dnode := relationship.Data;
                end;
              atpTrigger:
                begin
                  trigger := table.TriggerByName(AAttribute);
                  if Assigned(trigger) then
                    dnode := trigger.Data;
                end;
            end;
          end;
        end;
      end;

    trtObject: { generic object change }
      begin
        category := ADictionary.Categories.FindByType(TGDAOCategoryType(StrToInt(AObject)));
        dobject := category.Objects.FindByName(AAttribute);
        dnode := dobject.Data;
      end;

    trtDomain: { generic domain change }
      begin
        Domain := ADictionary.Domains.FindByName(AObject);
        dnode := Domain.Data;
      end;
  end;

  if Assigned(dnode) then
    with TDictionaryTreeNode(dnode) do
    begin
      CompareState := csDifferent;

      i := 0;
      while (i <= 4) and (FActionIndex[i] >= 0) do
        inc(i);
      FActionIndex[i] := AActionIndex;
      if not AChanged then
        FullCompareState;
    end;
end;

procedure TfmCompareDictionaries.TreeDiffChange(ADictionary: TGDAODatabase; AAction: TatDBAction; AActionIndex: integer);
var
  objName, attrName: string;
  rtype: TTreeRootType;
  tableProp: TActionTableProp;
begin
  objName := '';
  attrName := '';
  rtype := trtTable;
  tableProp := atpNone;

  if AAction is TatChangeTableConstraintAction then
  begin
    objName := TatChangeTableConstraintAction(AAction).Constraint.OwnerTable.TableName;
    attrName := TatChangeTableConstraintAction(AAction).Constraint.ConstraintName;
    tableProp := atpConstraint;
  end
  else if AAction is TatChangeRelationshipAction then
  begin
    objName := TatChangeRelationshipAction(AAction).Relationship.ChildTableName;
    attrName := TatChangeRelationshipAction(AAction).Relationship.RelationshipName;
    tableProp := atpRelationship;
  end
  else if AAction is TatChangeIndexAction then
  begin
    objName := TatChangeIndexAction(AAction)._Index.OwnerTable.TableName;
    attrName := TatChangeIndexAction(AAction)._Index.IndexName;
    tableProp := atpIndex;
  end
  else if AAction is TatChangeTriggerAction then
  begin
    objName := TatChangeTriggerAction(AAction).Trigger.OwnerTable.TableName;
    attrName := TatChangeTriggerAction(AAction).Trigger.Name;
    tableProp := atpTrigger;
  end
  else if AAction is TatFieldRequiredAction then
  begin
    objName := TatFieldRequiredAction(AAction).Field.OwnerTable.TableName;
    attrName := TatFieldRequiredAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatFieldChangeSizeAction then
  begin
    objName := TatFieldChangeSizeAction(AAction).Field.OwnerTable.TableName;
    attrName := TatFieldChangeSizeAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatFieldChangeDefaultValueAction then
  begin
    objName := TatFieldChangeDefaultValueAction(AAction).Field.OwnerTable.TableName;
    attrName := TatFieldChangeDefaultValueAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatFieldChangeTypeAction then
  begin
    objName := TatFieldChangeTypeAction(AAction).Field.OwnerTable.TableName;
    attrName := TatFieldChangeTypeAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatRenameTableAction then
    objName := TatRenameTableAction(AAction).Table.TableName
  else if AAction is TatChangeExtraObjectAction then
  begin
    objName := IntToStr(Ord(TatChangeExtraObjectAction(AAction).ExtraObject.OwnerCategory.CategoryType));
    attrName := TatChangeExtraObjectAction(AAction).ExtraObject.ObjectName;
    rtype := trtObject;
  end
  else if AAction is TatRenameFieldAction then
  begin
    objName := TatRenameFieldAction(AAction).Field.OwnerTable.TableName;
    attrName := TatRenameFieldAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatChangePrimaryKeyAction then
    objName := TatChangePrimaryKeyAction(AAction).Table.TableName
  else if AAction is TatChangeDomainAction then
  begin
    objName := TatChangeDomainAction(AAction).Domain.Name;
    rtype := trtDomain;
  end
  else if AAction is TatCommentTableAction then
    objName := TatCommentTableAction(AAction).Table.TableName
  else if AAction is TatCommentFieldAction then
  begin
    objName := TatCommentFieldAction(AAction).Field.OwnerTable.TableName;
    attrName := TatCommentFieldAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatCommentDomainAction then
  begin
    objName := TatCommentDomainAction(AAction).Domain.Name;
    rtype := trtDomain;
  end
  else if AAction is TatCommentTriggerAction then
  begin
    objName := TatCommentTriggerAction(AAction).Trigger.OwnerTable.TableName;
    attrName := TatCommentTriggerAction(AAction).Trigger.Name;
    tableProp := atpTrigger;
  end
  else if AAction is TatCommentExtraObjectAction then
  begin
    objName := IntToStr(Ord(TatCommentExtraObjectAction(AAction).ExtraObject.OwnerCategory.CategoryType));
    attrName := TatCommentExtraObjectAction(AAction).ExtraObject.ObjectName;
    rtype := trtObject;
  end;

  TreeDiff(ADictionary, rtype, objName, attrName, tableProp, True, AActionIndex);
end;

procedure TfmCompareDictionaries.TreeDiffDel(ADictionary: TGDAODatabase; AAction: TatDBAction; AActionIndex: integer);
var
  objName, attrName: string;
  rtype: TTreeRootType;
  tableProp: TActionTableProp;
begin
  objName := '';
  attrName := '';
  rtype := trtTable;
  tableProp := atpNone;

  if AAction is TatRemoveFieldAction then
  begin
    objName := TatRemoveFieldAction(AAction).Field.OwnerTable.TableName;
    attrName := TatRemoveFieldAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatRemoveExtraObjectAction then
  begin
    objName := IntToStr(Ord(TatRemoveExtraObjectAction(AAction).ExtraObject.OwnerCategory.CategoryType));
    attrName := TatRemoveExtraObjectAction(AAction).ExtraObject.ObjectName;
    rtype := trtObject;
  end
  else if AAction is TatRemoveTableAction then
    objName := TatRemoveTableAction(AAction).Table.TableName
  else if AAction is TatRemoveTriggerAction then
  begin
    objName := TatRemoveTriggerAction(AAction).Trigger.OwnerTable.TableName;
    attrName := TatRemoveTriggerAction(AAction).Trigger.Name;
    tableProp := atpTrigger;
  end
  else if AAction is TatRemoveTableConstraintAction then
  begin
    objName := TatRemoveTableConstraintAction(AAction).Constraint.OwnerTable.TableName;
    attrName := TatRemoveTableConstraintAction(AAction).Constraint.ConstraintName;
    tableProp := atpConstraint;
  end
  else if AAction is TatRemoveRelationshipAction then
  begin
    objName := TatRemoveRelationshipAction(AAction).Relationship.ChildTableName;
    attrName := TatRemoveRelationshipAction(AAction).Relationship.RelationshipName;
    tableProp := atpRelationship;
  end
  else if AAction is TatRemoveIndexAction then
  begin
    objName := TatRemoveIndexAction(AAction).Index.OwnerTable.TableName;
    attrName := TatRemoveIndexAction(AAction).Index.IndexName;
    tableProp := atpIndex;
  end
  else if AAction is TatRemovePrimaryKeyAction then
    objName := TatRemovePrimaryKeyAction(AAction).Table.TableName
  else if AAction is TatRemoveDomainAction then
  begin
    objName := TatRemoveDomainAction(AAction).Domain.Name;
    rtype := trtDomain;
  end;

  TreeDiff(ADictionary, rtype, objName, attrName, tableProp, False, AActionIndex);
end;

procedure TfmCompareDictionaries.TreeDiffNew(ADictionary: TGDAODatabase; AAction: TatDBAction; AActionIndex: integer);
var
  objName, attrName: string;
  rtype: TTreeRootType;
  tableProp: TActionTableProp;
begin
  objName := '';
  attrName := '';
  rtype := trtTable;
  tableProp := atpNone;

  if AAction is TatCreateFieldAction then
  begin
    objName := TatCreateFieldAction(AAction).Field.OwnerTable.TableName;
    attrName := TatCreateFieldAction(AAction).Field.FieldName;
    tableProp := atpField;
  end
  else if AAction is TatCreateTableConstraintAction then
  begin
    objName := TatCreateTableConstraintAction(AAction).Constraint.OwnerTable.TableName;
    attrName := TatCreateTableConstraintAction(AAction).Constraint.ConstraintName;
    tableProp := atpConstraint;
  end
  else if AAction is TatCreateIndexAction then
  begin
    objName := TatCreateIndexAction(AAction).Index.OwnerTable.TableName;
    attrName := TatCreateIndexAction(AAction).Index.IndexName;
    tableProp := atpIndex;
  end
  else if AAction is TatCreateRelationshipAction then
  begin
    objName := TatCreateRelationshipAction(AAction).Relationship.ChildTableName;
    attrName := TatCreateRelationshipAction(AAction).Relationship.RelationshipName;
    tableProp := atpRelationship;
  end
  else if AAction is TatCreateTriggerAction then
  begin
    objName := TatCreateTriggerAction(AAction).Trigger.OwnerTable.TableName;
    attrName := TatCreateTriggerAction(AAction).Trigger.Name;
    tableProp := atpTrigger;
  end
  else if AAction is TatCreateExtraObjectAction then
  begin
    objName := IntToStr(Ord(TatCreateExtraObjectAction(AAction).ExtraObject.OwnerCategory.CategoryType));
    attrName := TatCreateExtraObjectAction(AAction).ExtraObject.ObjectName;
    rtype := trtObject;
  end
  else if AAction is TatCreateTableAction then
    objName := TatCreateTableAction(AAction).Table.TableName
  else if AAction is TatCreatePrimaryKeyAction then
    objName := TatCreatePrimaryKeyAction(AAction).Table.TableName
  else if AAction is TatCreateDomainAction then
  begin
    objName := TatCreateDomainAction(AAction).Domain.Name;
    rtype := trtDomain;
  end;

  TreeDiff(ADictionary, rtype, objName, attrName, tableProp, False, AActionIndex);
end;

procedure TfmCompareDictionaries.TreeSetDiffAction(ANode: TDictionaryTreeNode; AAction: integer);
var i: integer;
begin
  if ANode.CompareState = csDifferent then
  begin
    ANode.DiffAction := AAction;
    for i := 0 to ANode.Nodes.Count - 1 do
      TreeSetDiffAction(ANode.Nodes[i], AAction);
  end;
end;

procedure TfmCompareDictionaries.UpdateDictionaryTrees;
begin
  FTreeChanging := True;
  FBaseDictionaryTree.BeginUpdate;
  FTargetDictionaryTree.BeginUpdate;
  try
    FBaseDictionaryTree.Clear;
    FTargetDictionaryTree.Clear;

    FBaseDictionaryTree.NodeDataSize := SizeOf(TNodeRec);
    FBaseDictionaryTree.RootNodeCount := FDictionaryTreeNodes.Count;

    FTargetDictionaryTree.NodeDataSize := SizeOf(TNodeRec);
    FTargetDictionaryTree.RootNodeCount := FDictionaryTreeNodes.Count;
  finally
    FBaseDictionaryTree.EndUpdate;
    FTargetDictionaryTree.EndUpdate;
    FTreeChanging := False;
  end;
end;

procedure TfmCompareDictionaries.UpdateSQLScriptFilter;
var
  AItem: TSQLScriptFilterItem;
  i: integer;
begin
  FSQLFilter.Items := SQLScriptAllFilterItems;
  if not FCurrentMetaData.DataDictionary.DatabaseType.ScriptObjectComments then
    FSQLFilter.Items := FSQLFilter.Items - [fiComments];

  for i := 0 to cleDiffObjects.Items.Count - 1 do
  begin
    case TDictionaryTreeNodeType(cleDiffObjects.Items.Objects[i]) of
      tntTable:
        AItem := fiTable;
      {tntField:
        AItem := fiTable;}
      tntIndex:
        AItem := fiIndex;
      {tntConstraint:
        AItem := fiConstraint;}
      tntRelationship:
        AItem := fiRelationship;
      tntTrigger:
        AItem := fiTrigger;
      tntObject:
        AItem := fiObject;
      tntDomain:
        AItem := fiDomain;
      tntComments:
        AItem := fiComments;
    else
      AItem := fiNone;
    end;
    if not cleDiffObjects.Checked[i] then
      FSQLFilter.Items := FSQLFilter.Items - [AItem];
  end;

  FSQLFilter.Items := FSQLFilter.Items + [fiObject];
  FSQLFilter.Categories := GetCategoryFilter;
end;

{ TDictionaryTreeNodes }

function TDictionaryTreeNodes.Add(ACaption: string; AType: TDictionaryTreeNodeType;
  ABaseObject, ATargetObject: TObject; AImageIndex: integer;
  ACategoryType: TGDAOCategoryType = dgConsts.ctNone): TDictionaryTreeNode;
begin
  result := TDictionaryTreeNode(inherited Add);
  with result do
  begin
    Caption := ACaption;
    NodeType := AType;
    BaseObject := ABaseObject;
    TargetObject := ATargetObject;
    ImageIndex := AImageIndex;
    CategoryType := ACategoryType;
  end;
end;

constructor TDictionaryTreeNodes.Create(AOwner: TDictionaryTreeNode);
begin
  inherited Create(TDictionaryTreeNode);
  FOwner := AOwner;
end;

procedure TDictionaryTreeNodes.DoSelectDiffAction(AActionIndex: integer; ASelect: boolean);
begin
  if Assigned(FOwner) then
    TDictionaryTreeNodes(FOwner.Collection).DoSelectDiffAction(AActionIndex, ASelect)
  else
    if Assigned(FOnSelectDiffAction) then
      FOnSelectDiffAction(AActionIndex, ASelect);
end;

procedure TDictionaryTreeNodes.ExchangeObjects;
var i: integer;
    aux: TObject;
begin
  for i := 0 to Count - 1 do
  begin
    aux := Items[i].BaseObject;
    Items[i].BaseObject := Items[i].TargetObject;
    Items[i].TargetObject := aux;
    Items[i].Nodes.ExchangeObjects;
  end;
end;

function TDictionaryTreeNodes.GetItems(i: integer): TDictionaryTreeNode;
begin
  result := TDictionaryTreeNode(inherited Items[i]);
end;

procedure TDictionaryTreeNodes.SetItems(i: integer; const Value: TDictionaryTreeNode);
begin
  Items[i].Assign(Value);
end;

{ TDictionaryTreeNode }

constructor TDictionaryTreeNode.Create(ACollection: TCollection);
var
  i: integer;
begin
  inherited;
  for i := 0 to 4 do
    FActionIndex[i] := -1;
  FParent := TDictionaryTreeNodes(ACollection).FOwner;
  FNodes := TDictionaryTreeNodes.Create(Self);    
end;

destructor TDictionaryTreeNode.Destroy;
begin
  FNodes.Free;
  inherited;
end;

procedure TDictionaryTreeNode.FullCompareState;
var i: integer;
begin
  { propagates compare state to children }
  for i := 0 to Nodes.Count - 1 do
  begin
    Nodes[i].FCompareState := Self.CompareState;
    Nodes[i].FullCompareState;
  end;
end;

procedure TDictionaryTreeNode.FullDiffAction;
var i: integer;
begin
  { propagates diff action to children }
  for i := 0 to Nodes.Count - 1 do
    if Nodes[i].CompareState = Self.CompareState then
    begin
      Nodes[i].DiffAction := Self.DiffAction;
      Nodes[i].FullDiffAction;
    end;
end;

procedure TDictionaryTreeNode.GetParentObjects(AType: TDictionaryTreeNodeType; var ABase, ATarget: TObject);
begin
  if NodeType = AType then
  begin
    ABase := BaseObject;
    ATarget := TargetObject;
  end
  else if Assigned(Parent) then
    Parent.GetParentObjects(AType, ABase, ATarget)
  else
  begin
    ABase := nil;
    ATarget := nil;
  end;
end;

procedure TDictionaryTreeNode.ParentDiffAction;
var i: integer;
begin
  if Assigned(Parent) and (Parent.CompareState = Self.CompareState) then
  begin
    for i := 0 to Parent.Nodes.Count - 1 do
      if (Parent.Nodes[i].CompareState = Self.CompareState)
        and (Parent.Nodes[i].DiffAction <> Self.DiffAction)
        and (Self.DiffAction <> DIFFACTION_DIFF)
      then
        exit;
    Parent.DiffAction := Self.DiffAction;
    Parent.ParentDiffAction;
  end;
end;

procedure TDictionaryTreeNode.SetCompareState(const Value: TNodeCompareState);
begin
  { recursive }
  FCompareState := Value;
  if Assigned(Parent) then
    Parent.CompareState := FCompareState;
end;

procedure TDictionaryTreeNode.SetDiffAction(const Value: integer);
var
  i: integer;
begin
  FDiffAction := Value;
  for i := 0 to 4 do
    if FActionIndex[i] >= 0 then
      TDictionaryTreeNodes(Collection).DoSelectDiffAction(FActionIndex[i], FDiffAction = DIFFACTION_APPLYTARGET);
end;

procedure TDictionaryTreeNode.SiblingDiffAction(ADiffAction: integer);
begin
  if Assigned(Parent) then
  begin
    if Parent.FActionIndex[0] >= 0 then
    begin
      DiffAction := ADiffAction;
      FullDiffAction;
      ParentDiffAction;
    end
    else
      Parent.SiblingDiffAction(ADiffAction);
  end;
end;

procedure TDictionaryTreeNode.ToggleAction;
begin
  case FDiffAction of
    DIFFACTION_DIFF:
      DiffAction := DIFFACTION_APPLYTARGET;
    DIFFACTION_APPLYTARGET:
      DiffAction := DIFFACTION_DIFF;
  end;
  FullDiffAction;
  ParentDiffAction;
  if FActionIndex[0] < 0 then
    SiblingDiffAction(DiffAction);
end;

end.

