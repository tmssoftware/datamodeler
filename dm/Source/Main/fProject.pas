unit fProject;

interface

uses
  Variants, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Menus, Buttons, ImgList, fConfig, ActnList, AdvMenus, 
  uStrings, uAppMetaData, DB, uDialogs, DiagramNavigator, UITypes,
  fImportWizard, fNewProject, fManageVersions,
  Grids, DBGrids, LangConst, AdvToolBtn, BaseGrid, AdvMemo,
  uGDAO, uGDAODiagrams, fGenerateScript, fDomains, AdvMenuStylers, fTableElements,
  uProjectExplorer, jpeg, fDatabaseConvert, DiagramExtra, atDiagram, uTableDiagramBlock,
  uDiagramClass, uGDAODragObject, dgConsts, fRelationshipEditor, fObjectEditor,
  uProjectCheck, AdvOfficePager, AdvNavBar,
  AdvOfficePagerStylers, AdvSplitter, System.ImageList, System.Actions;

type
  TProjectElement = (plTable, plField, plIndex, plRelationship, plTrigger, plConstraint, plObject);

  TTreeElementarNodes = (elDictionary, elTables, elRelationships, elDiagrams);

  TfmProject = class(TForm)
    popTables: TAdvPopupMenu;
    ActionList1: TActionList;
    imgObjects: TImageList;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    miAddTableDiagram: TMenuItem;
    acTable_AddDiagram: TAction;
    acAddDiagram: TAction;
    acAddRelation: TAction;
    Removeselectedrelationship1: TMenuItem;
    acAddObject: TAction;
    acDeleteTreeItem: TAction;
    N3: TMenuItem;
    pnCheck: TPanel;
    lvCheck: TListView;
    spBottom: TAdvSplitter;
    popCheck: TPopupMenu;
    Clearmessages1: TMenuItem;
    Savemessages1: TMenuItem;
    dlgSaveMessages: TSaveDialog;
    N1: TMenuItem;
    miGotoObject: TMenuItem;
    pcTabs: TAdvOfficePager;
    spMiddle: TAdvSplitter;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    LeftBevel: TShape;
    Shape1: TShape;
    Shape2: TShape;
    PanelAll: TPanel;
    imgPanel: TImageList;
    imgPanelSmall: TImageList;
    acRenameTreeItem: TAction;
    Rename1: TMenuItem;
    acAddTreeItem: TAction;
    miAddTreeItem: TMenuItem;
    miOpenTreeItem: TMenuItem;
    acOpenTreeItem: TAction;
    popTabs: TAdvPopupMenu;
    miCloseTab: TMenuItem;
    miCloseAllTabExcept: TMenuItem;
    acTable_FindInDiagram: TAction;
    Addobject1: TMenuItem;
    acTable_Duplicate: TAction;
    DuplicateTable1: TMenuItem;
    acSelectAllTreeItems: TAction;
    acUnselectAllTreeItems: TAction;
    N4: TMenuItem;
    miSelectAllTreeItems: TMenuItem;
    miUnselectAllTreeItems: TMenuItem;
    Panel1: TPanel;
    pnTree: TAdvNavBar;
    NavigatorPanel: TPanel;
    NavigatorSplitter: TAdvSplitter;
    procedure miGotoObjectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Addtable1Click(Sender: TObject);
    procedure AdvToolButton1Click(Sender: TObject);
    procedure AdvToolButton1MouseEnter(Sender: TObject);
    procedure AdvToolButton1MouseLeave(Sender: TObject);
    procedure acAddDiagramExecute(Sender: TObject);

    procedure acTable_AddDiagramExecute(Sender: TObject);
    procedure acAddRelationExecute(Sender: TObject);
    procedure acDeleteTreeItemExecute(Sender: TObject);
    procedure Clearmessages1Click(Sender: TObject);
    procedure Savemessages1Click(Sender: TObject);
    procedure lvCheckDblClick(Sender: TObject);
    procedure pcTabsChange(Sender: TObject);
    procedure pcTabsChanging(Sender: TObject; FromPage,
      ToPage: Integer; var AllowChange: Boolean);
    procedure pcTabsClosePage(Sender: TObject; PageIndex: Integer;
      var Allow: Boolean);
    procedure pcTabsClosedPage(Sender: TObject; PageIndex: Integer);
    procedure acTable_AddDiagramUpdate(Sender: TObject);
    procedure acDeleteTreeItemUpdate(Sender: TObject);
    procedure pcTabsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acRenameTreeItemExecute(Sender: TObject);
    procedure acRenameTreeItemUpdate(Sender: TObject);
    procedure acAddRelationUpdate(Sender: TObject);
    procedure acAddTreeItemUpdate(Sender: TObject);
    procedure acAddTreeItemExecute(Sender: TObject);
    procedure acOpenTreeItemUpdate(Sender: TObject);
    procedure acOpenTreeItemExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miCloseTabClick(Sender: TObject);
    procedure miCloseAllTabExceptClick(Sender: TObject);
    procedure acTable_FindInDiagramExecute(Sender: TObject);
    procedure acTable_FindInDiagramUpdate(Sender: TObject);
    procedure acTable_DuplicateUpdate(Sender: TObject);
    procedure acTable_DuplicateExecute(Sender: TObject);
    procedure acSelectAllTreeItemsExecute(Sender: TObject);
    procedure acSelectAllTreeItemsUpdate(Sender: TObject);
    procedure acUnselectAllTreeItemsExecute(Sender: TObject);
    procedure acUnselectAllTreeItemsUpdate(Sender: TObject);
  private
    FElementarPanel: array[TTreeElementarNodes] of TAdvNavBarPanel;
    FElementarTree: array[TTreeElementarNodes] of TTreeView;

    FAllowTreeEdit: boolean;
    FUpdatingSelectedItem: integer;
    FModified: boolean;
    FExplorer: TProjectExplorer;
    FCreating: boolean;
    FMetaData: TAppMetaData;
    FCheckReport: TCheckReport;
    FContextTab: integer;
    FNavigator: TDiagramNavigator;
    FMustShowNavigator: boolean;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMRefreshOpenedDiagrams(var Msg: TMessage); message WM_DM_REFRESHOPENEDDIAGRAMS;
    procedure WMSelectElement(var Msg: TMessage); message WM_DM_SELECTELEMENT;
    procedure WMCloseExplorerItems(var Msg: TMessage); message WM_DM_CLOSEEXPLORERITEMS;
    procedure WMDiagramPopupMenu(var Msg: TMessage); message WM_DM_DIAGRAMPOPUPMENU;
    procedure WMRemoveDeleteFromDiagram(var Msg: TMessage); message WM_DM_REMOVEDELETEFROMDIAGRAM;

    procedure DictionaryTableDestroy(Sender: TObject);
    procedure DictionaryFieldNameChanged(Sender: TObject);

    procedure PanelTreeDblClick(Sender: TObject);
    procedure PanelTreeStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure PanelTreeEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure PanelTreeEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure PanelTreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PanelTreeCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
    procedure PanelTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PanelTreeChange(Sender: TObject; Node: TTreeNode);
    procedure PanelTreeCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);

    procedure RenameSelectedElement;

    procedure CheckCloseButton;
    procedure ReloadTreeView;
    procedure OnShowExplorerPage(Sender: TObject);
    procedure FreeExplorerItems;
    procedure SelectElement(AElement: TObject; AOpenIfClosed: boolean);
    procedure CloseElement(AElement: TObject);
    procedure MetaDataModified(Sender: TObject);
    procedure MetaDataPerformMessage(var Msg: TMsg; var Handled: Boolean);
    procedure AddTablesToTreeView(ASelObj: TObject=nil);
    procedure AddRelationshipsToTreeView(ASelObj: TObject=nil);
    procedure AddDiagramsToTreeView(ASelObj: TObject=nil);
    procedure AddObjectsToTreeView(ACategory: TGDAOCategory; ASelObj: TObject=nil);
    procedure DiagramAddNewTable(ADiagram: TDiagramClass; ABlock: TTableDiagramBlock);
    procedure DiagramAddNewRelationship(ADiagram: TDiagramClass; ALine: TCustomDiagramLine;
      ASourceBlock, ATargetBlock: TTableDiagramBlock; AType: TGDAORelationshipType);
    procedure SetupTableFrame(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
    procedure SetupRelationshipFrame(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
    procedure SetupObjectFrame(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
    procedure SetupDiagramTab(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
    procedure SendMessageToOpenedFrames(AElementType: TExplorerElement; AMessage: Cardinal; wParam: Integer = 0; lParam : Integer = 0);
    //procedure PostMessageToOpenedFrames(AMessage: Cardinal; wParam: Integer = 0; lParam : Integer = 0);
    procedure SendMessageToActiveFrame(AMessage: Cardinal; wParam: Integer = 0; lParam : Integer = 0);
    procedure RefreshOpenedDiagrams(ARelationshipRefresh: TGDAORelationship=nil);
    procedure TableLinkClick(ALinkType: TDesignLinkType; AObject: TObject);
    procedure DiagramEditRelationship(ADiagram: TDiagramClass; ARelationship: TGDAORelationship);
    procedure DiagramEditTable(ADiagram: TDiagramClass; ATable: TGDAOTable);
    procedure RemoveNodeReference(AObj: TObject);
    function GetCurrentTableFrame: TfmTableElements;
    function GetCurrentRelationshipFrame: TfmRelationshipEditor;
    function GetCurrentDiagramFrame: TDiagramClass;
    procedure TreeViewEndUpdate(ATree: TTreeView; ANode: TTreeNode);
    function GetSelectedElement: TObject;
    procedure DeleteRelationship(ARel: TGDAORelationship);
    procedure DeleteTable(ATable: TGDAOTable);
    procedure CloseExplorerPage(idx: integer; ADestroyPage: boolean = true);
    procedure CheckReportListCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure GotoReportItemObject(AItem: TCheckReportItem);
    function ElementarPanelHint(ACaption: string): string;
    function ImportDD: Boolean;
    function ConfigureNew: boolean;

    function GetObjectImageIndex(ACat: TGDAOCategory): integer;

    procedure RefreshTableName(ATable: TGDAOTable);
    procedure RefreshRelationshipName(ARelationship: TGDAORelationship);
    procedure RefreshObjectName(AObject: TGDAOObject);
    function FindElementTreeNode(AElement: TObject): TTreeNode;

    function FindElementTreeView(AElement: TObject): TTreeView;
    function FocusedTreeView: TTreeView;
    function CreatePanelTreeView(APanel: TAdvNavBarPanel; const AFilterText: string): TTreeView;

    {Filter box above each explorer panel tree}
    function TreeFilterEdit(ATree: TTreeView): TEdit;
    function TreeFilterMatch(ATree: TTreeView; const AName: string): boolean;
    procedure RefreshFilteredTree(ATree: TTreeView);
    procedure PanelFilterChange(Sender: TObject);
    procedure PanelFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    {Multi-selection in the explorer panel trees}
    procedure GetSelectedElements(ATree: TTreeView; AList: TList);
    procedure SelectTreeElements(ATree: TTreeView; AList: TList);
    function NextUnselectedElement(ATree: TTreeView): TObject;
    function ElementName(AElement: TObject): string;
    function ElementReadOnly(AElement: TObject): boolean;
    procedure OpenSelectedElements(ATree: TTreeView);

    procedure DeleteSelectedDiagramObjects;
    procedure DeleteSelectedElement;

    {If the tab for the table ATable is opened, then perform a full update of the tab
     (reload everything)}
    procedure RefreshTableTab(ATable: TGDAOTable);

    procedure RestoreVisualSettings;
    procedure SaveVisualSettings;
    procedure UpdateNavigator;
    procedure SetMustShowNavigator(const Value: boolean);

    property CurrentTableFrame: TfmTableElements read GetCurrentTableFrame;
    property CurrentRelationshipFrame: TfmRelationshipEditor read GetCurrentRelationshipFrame;
  protected
    procedure SetParent(AParent: TWinControl); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DoSave(AFileName: string);
    function Open(AFileName:string): boolean;

    procedure RemoveDeleteFromDiagram;

    procedure SetDictionaryNotificationEvents;
    procedure AddAllTablesToDiagram;
    procedure AddDDItem(AType: TProjectElement; ACategory: TGDAOCategory=nil);
    procedure NewRelationshipDialog(DefaultParent, DefaultChild: TGDAOTable);
    function DuplicateTableDialog(ATable: TGDAOTable): TGDAOTable;
    procedure ShowNavigator;
    procedure HideNavigator;

    procedure InsertDiagramTable;
    procedure InsertDiagramRelationship(AType: TGDAORelationshipType);
    procedure InsertDiagramNote;
    function ElementDescription(AElement: TObject): string;
    function ElementarTreeDescription(ATreeView: TTreeView): string;
    function NewDlg(AImportDD: Boolean = false) : boolean;
    function ShowManageVersionsDlg: boolean;
    procedure CheckIntegrity;
    function ShowConvertDatabaseDlg: Boolean;
    procedure DomainsDialog(DomainToSelect: TGDAODomain = nil);
    procedure AureliusExport;
    procedure ShowGenerateScriptDialog;
    procedure HideExplorerPanel;
    procedure ShowExplorerPanel(AFocus: boolean);
    function IsExplorerPanelVisible: boolean;
    function Configure:boolean;
    procedure HideMessagesPanel;
    procedure ShowMessagesPanel(AFocus: boolean);
    function IsMessagesPanelVisible: boolean;
    procedure SetModified(Sender:TObject=nil);
    property CurrentDiagramFrame: TDiagramClass read GetCurrentDiagramFrame;
    property MetaData: TAppMetaData read FMetaData;
    property SelectedElement: TObject read GetSelectedElement;
    property Modified: boolean read FModified;
    property MustShowNavigator: boolean read FMustShowNavigator write SetMustShowNavigator;
  end;

implementation

uses
  CommCtrl, uDBProperties, fNewRelation, fRelationshipDialog, fDuplicateTable,
  fSequenceEditor, TaskDialog, UAppRegistry, StrUtils,
  Aurelius.ExportForm;

const
  //IMAGETREE_DATADICTIONARY = 0;
  IMAGEOBJECT_TABLE = 0;
  IMAGEOBJECT_DIAGRAM = 1;
  IMAGEOBJECT_RELATIONSHIP = 2;
  IMAGEOBJECT_OBJECT = 3;


  IMAGEPANEL_TABLES = 0;
  IMAGEPANEL_DIAGRAMS = 1;
  IMAGEPANEL_RELATIONSHIPS = 2;
  IMAGEPANEL_OBJECT = 3;
  IMAGEPANEL_PROCEDURE = 4;
  IMAGEPANEL_VIEW = 5;
  IMAGEPANEL_SEQUENCE= 6;


{$R *.DFM}

procedure TfmProject.AddDDItem(AType: TProjectElement; ACategory: TGDAOCategory);
var s: string;
    element: TObject;
begin
  case AType of
    plTable:
      begin
        s := FMetadata.DataDictionary.Tables.GetNewTableName;
        element := FMetaData.DataDictionary.AddTable(s);
        SetModified(Self);
        AddTablesToTreeView(element);
        SelectElement(element, true);
        // new table, select the name for editing
        SendMessageToActiveFrame(WM_DM_NEW_TABLE);
      end;
    plRelationship:
      begin
        NewRelationshipDialog(nil, nil);
      end;
    plObject:
      if Assigned(ACategory) then
      begin
        s := ACategory.Objects.GetNewObjectName;
        element := ACategory.Objects.Add(s);
        SetModified(Self);
        TGDAOObject(element).CreateImplementation := ACategory.CreateTemplate;
        TGDAOObject(element).DropImplementation := ACategory.DropTemplate;
        AddObjectsToTreeView(ACategory, element);
        SelectElement(element, true);
      end;
  end;
end;

procedure TfmProject.CheckReportListCompare(Sender: TObject; Item1, Item2: TListItem;
    Data: Integer; var Compare: Integer);
begin
  Compare := Ord(TCheckReportItem(Item1.Data).ItemType) - Ord(TCheckReportItem(Item2.Data).ItemType)
end;

procedure TfmProject.CheckCloseButton;
begin
//  pcTabs.ButtonSettings.CloseButton := pcTabs.AdvPageCount > 0;
//  pcTabs.CloseOnTab := True;
end;

procedure TfmProject.CheckIntegrity;
var
  i: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    if ProjectChecker.CheckDataDictionary(FMetaData.DataDictionary, FCheckReport) then
    begin
      lvCheck.Items.Clear;
      MessageDlg(SProjectInformationValid, mtInformation, [mbOK], 0);
      HideMessagesPanel;
    end
    else
    begin
      lvCheck.Items.BeginUpdate;
      try                            
        lvCheck.Items.Clear;
        for i := 0 to FCheckReport.Count - 1 do
          with lvCheck.Items.Add do
          begin
            Caption := Format('[%s] %s', [CheckReportItemTypeName[FCheckReport[i].ItemType], FCheckReport[i].Caption]);
            Data := FCheckReport[i];
          end;

        {sort items putting hints and warnings before errors, then select last item}
        lvCheck.OnCompare := CheckReportListCompare;
        lvCheck.AlphaSort;
        lvCheck.OnCompare := nil;
        if lvCheck.Items.Count > 0 then
        begin
          lvCheck.Selected := lvCheck.Items[lvCheck.Items.Count  -1];
          lvCheck.Selected.MakeVisible(false);
        end;
      finally
        lvCheck.Items.EndUpdate;
      end;
      ShowMessagesPanel(true);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TfmProject.Configure: boolean;
begin
  with TfmConfig.Create(nil) do
  try
      ProjectName    := FMetaData.PrjName;
      Author         := FMetaData.PrjAuthor;
      Description    := FMetaData.PrjDescription;
      VersionPath    := FMetaData.VersionControlPath;

      { allow configuration changes }
      result:=(ShowModal=mrOk);

      { save settings if confirmed }
      if result then
      begin
         FMetaData.PrjName               := ProjectName;
         FMetaData.PrjAuthor             := Author;
         FMetaData.PrjDescription        := Description;
         FMetaData.VersionControlPath    := VersionPath;
         SetModified(self);
      end;
  finally
    free;
  end;
end;

function TfmProject.ConfigureNew: boolean;
begin
  with TfmNewProject.Create(nil) do
  try
      { initialize new project form }
      DBType := FMetaData.DataDictionary.DatabaseType;

      { allow configuration changes }
      result := (ShowModal = mrOk);

      { save settings if confirmed }
      if result then
      begin
         { update project information based on the new settings }
         FMetaData.DataDictionary.DatabaseType := DBType;
         TDBProperties.LoadAll(FMetaData.DataDictionary);
      end;
  finally
    free;
  end;
end;

constructor TfmProject.Create(AOwner: TComponent);
begin
  inherited;
  FNavigator := TDiagramNavigator.Create(Self);
  FNavigator.Parent := NavigatorPanel;
  FNavigator.Align := alClient;
  FNavigator.Color := clWhite;
  FNavigator.EnableZoom := true;
  FMetaData := TAppMetaData.Create(nil);
  SetDictionaryNotificationEvents;
  FMustShowNavigator := DMRegistry.ShowNavigator;
end;

function TfmProject.CreatePanelTreeView(APanel: TAdvNavBarPanel; const AFilterText: string): TTreeView;
begin
  result := TTreeView.Create(APanel);
  result.Name := 'tv' + APanel.Caption;
  result.Parent := APanel;
  result.Align := alClient;
  result.BorderStyle := bsNone;
  result.HideSelection := false;
  result.ShowLines := false;
  result.ShowRoot := false;
  result.RowSelect := true;
  result.HotTrack := true;
  result.MultiSelect := true;
  result.MultiSelectStyle := [msControlSelect, msShiftSelect];
  result.Images := imgObjects;
  //result.DragMode := dmAutomatic;

  {Assign the events}
  result.OnDblClick := PanelTreeDblClick;
  result.OnStartDrag := PanelTreeStartDrag;
  result.OnEditing := PanelTreeEditing;
  result.OnEdited := PanelTreeEdited;
  result.OnDragOver := PanelTreeDragOver;
  result.OnCompare := PanelTreeCompare;
  result.OnMouseDown := PanelTreeMouseDown;
  result.OnKeyDown := PanelTreeKeyDown;
  result.OnChange := PanelTreeChange;
  result.OnCustomDrawItem := PanelTreeCustomDrawItem;

  {Increase tree view item height}
  SendMessage(result.Handle, TVM_SETITEMHEIGHT, 24, 0);

  {Filter box on top of the tree. Created after the tree, so the tree stays
   Controls[0] of the panel (FocusedTreeView relies on that)}
  with TEdit.Create(APanel) do
  begin
    Parent := APanel;
    Align := alTop;
    AlignWithMargins := true;
    Margins.SetBounds(2, 2, 2, 2);
    TextHint := 'Filter';
    Text := AFilterText;
    OnChange := PanelFilterChange;
    OnKeyDown := PanelFilterKeyDown;
  end;
end;

function TfmProject.TreeFilterEdit(ATree: TTreeView): TEdit;
var
  i: integer;
begin
  result := nil;
  if (ATree <> nil) and (ATree.Parent <> nil) then
    for i := 0 to ATree.Parent.ControlCount - 1 do
      if ATree.Parent.Controls[i] is TEdit then
      begin
        result := TEdit(ATree.Parent.Controls[i]);
        break;
      end;
end;

function TfmProject.TreeFilterMatch(ATree: TTreeView; const AName: string): boolean;
var
  AEdit: TEdit;
begin
  AEdit := TreeFilterEdit(ATree);
  result := (AEdit = nil) or (Trim(AEdit.Text) = '') or ContainsText(AName, Trim(AEdit.Text));
end;

procedure TfmProject.RefreshFilteredTree(ATree: TTreeView);
var
  i: integer;
  ASelObj: TObject;
  AList: TList;
begin
  AList := TList.Create;
  try
    {Keep the selected items selected if they still match the filter}
    GetSelectedElements(ATree, AList);
    for i := AList.Count - 1 downto 0 do
      if not TreeFilterMatch(ATree, ElementName(TObject(AList[i]))) then
        AList.Delete(i);
    ASelObj := nil;
    if (ATree.Selected <> nil) and (AList.IndexOf(ATree.Selected.Data) >= 0) then
      ASelObj := TObject(ATree.Selected.Data)
    else if AList.Count > 0 then
      ASelObj := TObject(AList[0]);

    if ATree = FElementarTree[elTables] then
      AddTablesToTreeView(ASelObj)
    else if ATree = FElementarTree[elRelationships] then
      AddRelationshipsToTreeView(ASelObj)
    else if ATree = FElementarTree[elDiagrams] then
      AddDiagramsToTreeView(ASelObj)
    else
      with FMetaData.DataDictionary do
        for i := 0 to Categories.Count - 1 do
          if ATree = Categories[i].Data then
          begin
            AddObjectsToTreeView(Categories[i], ASelObj);
            break;
          end;

    if AList.Count > 1 then
    begin
      {The primary selected item first, it stays the focused one}
      AList.Delete(AList.IndexOf(ASelObj));
      AList.Insert(0, ASelObj);
      SelectTreeElements(ATree, AList);
    end;
  finally
    AList.Free;
  end;
end;

procedure TfmProject.GetSelectedElements(ATree: TTreeView; AList: TList);
var
  i: integer;

  procedure AddNode(ANode: TTreeNode);
  begin
    if (integer(ANode.Data) > DATA_OBJECT) and not (TObject(ANode.Data) is TGDAOCategory) and
      (AList.IndexOf(ANode.Data) < 0) then
      AList.Add(ANode.Data);
  end;

begin
  if ATree = nil then
    Exit;
  for i := 0 to integer(ATree.SelectionCount) - 1 do
    AddNode(ATree.Selections[i]);
  if (AList.Count = 0) and (ATree.Selected <> nil) then
    AddNode(ATree.Selected);
end;

procedure TfmProject.SelectTreeElements(ATree: TTreeView; AList: TList);
var
  ANodes: TList;
  i: integer;
  ANode: TTreeNode;
begin
  {AList holds elements; the first one becomes the primary selected node}
  ANodes := TList.Create;
  try
    for i := 0 to AList.Count - 1 do
    begin
      ANode := ATree.Items.GetFirstNode;
      while (ANode <> nil) and (ANode.Data <> AList[i]) do
        ANode := ANode.GetNext;
      if ANode <> nil then
        ANodes.Add(ANode);
    end;
    if ANodes.Count > 0 then
    begin
      Inc(FUpdatingSelectedItem);
      try
        ATree.Select(ANodes);
      finally
        Dec(FUpdatingSelectedItem);
      end;
    end;
  finally
    ANodes.Free;
  end;
end;

function TfmProject.NextUnselectedElement(ATree: TTreeView): TObject;
var
  ANode, ABefore, AAfter: TTreeNode;
  ASeenSelected: boolean;
begin
  {The element to select after the selected ones are deleted: the first unselected
   node after the last selected one, else the last unselected node before them}
  ABefore := nil;
  AAfter := nil;
  ASeenSelected := false;
  ANode := ATree.Items.GetFirstNode;
  while ANode <> nil do
  begin
    if ANode.Selected then
    begin
      ASeenSelected := true;
      AAfter := nil;
    end
    else if not ASeenSelected then
      ABefore := ANode
    else if AAfter = nil then
      AAfter := ANode;
    ANode := ANode.GetNext;
  end;

  if AAfter <> nil then
    result := TObject(AAfter.Data)
  else if ABefore <> nil then
    result := TObject(ABefore.Data)
  else
    result := nil;
end;

function TfmProject.ElementName(AElement: TObject): string;
begin
  if AElement is TGDAOTable then
    result := TGDAOTable(AElement).TableName
  else if AElement is TGDAORelationship then
    result := TGDAORelationship(AElement).RelationshipName
  else if AElement is TGDAOObject then
    result := TGDAOObject(AElement).ObjectName
  else if AElement is TGDAODiagram then
    result := TGDAODiagram(AElement).DiagramName
  else
    result := '';
end;

function TfmProject.ElementReadOnly(AElement: TObject): boolean;
begin
  if AElement is TGDAOTable then
    result := TGDAOTable(AElement).ReadOnly
  else if AElement is TGDAORelationship then
    result := TGDAORelationship(AElement).ReadOnly
  else if AElement is TGDAOObject then
    result := TGDAOObject(AElement).ReadOnly
  else
    result := false;
end;

procedure TfmProject.OpenSelectedElements(ATree: TTreeView);
var
  AList: TList;
  i: integer;
begin
  AList := TList.Create;
  try
    GetSelectedElements(ATree, AList);
    for i := 0 to AList.Count - 1 do
      SelectElement(TObject(AList[i]), true);
  finally
    AList.Free;
  end;
end;

procedure TfmProject.PanelFilterChange(Sender: TObject);
var
  i: integer;
  AParent: TWinControl;
begin
  AParent := TEdit(Sender).Parent;
  for i := 0 to AParent.ControlCount - 1 do
    if AParent.Controls[i] is TTreeView then
    begin
      RefreshFilteredTree(TTreeView(AParent.Controls[i]));
      break;
    end;
end;

procedure TfmProject.PanelFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ATree: TTreeView;
begin
  case Key of
    VK_ESCAPE:
      begin
        TEdit(Sender).Clear;
        Key := 0;
      end;
    VK_DOWN, VK_RETURN:
      begin
        ATree := nil;
        if (TEdit(Sender).Parent.ControlCount > 0) and (TEdit(Sender).Parent.Controls[0] is TTreeView) then
          ATree := TTreeView(TEdit(Sender).Parent.Controls[0]);
        if (ATree <> nil) and (ATree.Items.Count > 0) then
        begin
          if ATree.Selected = nil then
            ATree.Selected := ATree.Items[0];
          ATree.SetFocus;
          Key := 0;
        end;
      end;
  end;
end;

procedure TfmProject.DeleteSelectedElement;
const
  MaxListedNames = 10;
var
  tv: TTreeView;
  AList: TList;
  category: TGDAOCategory;
  AObj: TObject;
  selObj: TObject;
  i, ReadOnlyCount: integer;
  AMsg: string;
begin
  tv := FocusedTreeView;
  if (tv = nil) or (tv.Selected = nil) then
    Exit;

  AList := TList.Create;
  try
    GetSelectedElements(tv, AList);

    {Read only objects cannot be removed from project}
    ReadOnlyCount := 0;
    for i := AList.Count - 1 downto 0 do
      if ElementReadOnly(TObject(AList[i])) then
      begin
        AList.Delete(i);
        Inc(ReadOnlyCount);
      end;
    if AList.Count = 0 then
    begin
      if ReadOnlyCount > 0 then
        MessageDlg('Selected object is read only and cannot be removed from project.', mtError, [mbOk], 0);
      Exit;
    end;

    if AList.Count = 1 then
      AMsg := Format(SConfirmItemExclusion, [ElementName(TObject(AList[0]))])
    else
    begin
      AMsg := Format('Are you sure you want to delete the %d selected items?', [AList.Count]) + sLineBreak;
      for i := 0 to AList.Count - 1 do
        if i < MaxListedNames then
          AMsg := AMsg + sLineBreak + ElementName(TObject(AList[i]));
      if AList.Count > MaxListedNames then
        AMsg := AMsg + sLineBreak + Format('... and %d more', [AList.Count - MaxListedNames]);
    end;
    if ReadOnlyCount > 0 then
      AMsg := AMsg + sLineBreak + sLineBreak +
        Format('%d read only item(s) will not be removed.', [ReadOnlyCount]);

    if DialogMsg(AMsg, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

    selObj := NextUnselectedElement(tv);
    category := nil;
    for i := 0 to AList.Count - 1 do
    begin
      AObj := TObject(AList[i]);
      if AObj is TGDAODiagram then
      begin
        CloseExplorerPage(FExplorer.FindByElement(AObj));
        RemoveNodeReference(AObj);
        AObj.Free;
      end
      else if AObj is TGDAOObject then
      begin
        CloseElement(AObj);
        category := TGDAOObject(AObj).OwnerCategory;
        RemoveNodeReference(AObj);
        AObj.Free;
      end
      else if AObj is TGDAORelationship then
        DeleteRelationship(TGDAORelationship(AObj))
      else if AObj is TGDAOTable then
        DeleteTable(TGDAOTable(AObj));
    end;
    SetModified(nil);

    {Each tree holds one kind of element, so refresh only that tree}
    if tv = FElementarTree[elDiagrams] then
      AddDiagramsToTreeView(selObj)
    else if tv = FElementarTree[elTables] then
    begin
      AddTablesToTreeView(selObj);
      AddRelationshipsToTreeView;
      RefreshOpenedDiagrams;
    end
    else if tv = FElementarTree[elRelationships] then
    begin
      AddRelationshipsToTreeView(selObj);
      RefreshOpenedDiagrams;
    end
    else if category <> nil then
      AddObjectsToTreeView(category, selObj);
  finally
    AList.Free;
  end;
end;

procedure TfmProject.DomainsDialog(DomainToSelect: TGDAODomain = nil);
var
  DomainsForm: TfmDomains;
begin
  DomainsForm := TfmDomains.Create(nil);
  try
    DomainsForm.Metadata := Self.MetaData;
    DomainsForm.ShowDialog(DomainToSelect);
    if DomainsForm.Modified then
    begin
      SetModified(self);

      // updating opened tabs
      SendMessageToOpenedFrames(exTable, WM_DM_REFRESH_DOMAINS);
    end;
  finally
    DomainsForm.Free;
  end;
end;

function TfmProject.ElementarPanelHint(ACaption: string): string;
begin
  result := ACaption;
  if result > '' then
  begin
    result := result + ' (Ctrl+Shift+' + result[1] + ')';
  end;
end;

function TfmProject.ElementarTreeDescription(ATreeView: TTreeView): string;
var
  tv: TTreeView;
  i: integer;
begin
  result := '';
  tv := FocusedTreeView;
  if tv <> nil then
  begin
    if tv = FElementarTree[elTables] then
      result := 'table'
    else if tv = FElementarTree[elRelationships] then
      result := 'relationship'
    else if tv = FElementarTree[elDiagrams] then
      result := 'diagram'
    else
    begin
      with FMetaData.DataDictionary do
        for i := 0 to Categories.Count - 1 do
          if tv = Categories[i].Data then
          begin
            result := Categories[i].CategoryNameS;
            break;
          end;
    end;
  end;
end;

function TfmProject.ElementDescription(AElement: TObject): string;
begin
  result := '';
  if Assigned(AElement) then
  begin
    if AElement is TGDAOTable then
      result := 'table'
    else if AElement is TGDAORelationship then
      result := 'relationship'
    else if AElement is TGDAOObject then
      result := TGDAOObject(AElement).OwnerCategory.CategoryNameS
    else if AElement is TGDAODiagram then
      result := 'diagram';
  end;
end;

procedure TfmProject.DiagramEditRelationship(ADiagram: TDiagramClass; ARelationship: TGDAORelationship);
begin
  SelectElement(ARelationship, true);
  CurrentRelationshipFrame.ShowLink(dltDiagram, ADiagram);
end;

procedure TfmProject.DiagramEditTable(ADiagram: TDiagramClass; ATable: TGDAOTable);
begin
  SelectElement(ATable, true);
  CurrentTableFrame.ShowLink(dltDiagram, ADiagram);
end;

procedure TfmProject.DictionaryFieldNameChanged(Sender: TObject);
begin
end;

procedure TfmProject.DictionaryTableDestroy(Sender: TObject);
begin
end;

function TfmProject.FindElementTreeView(AElement: TObject): TTreeView;
var
  cat: TGDAOCategory;
begin
  result := nil;
  if AElement is TGDAOTable then
    result := FElementarTree[elTables]
  else
  if AElement is TGDAORelationship then
    result := FElementarTree[elRelationships]
  else
  if AElement is TGDAODiagram then
    result := FElementarTree[elDiagrams]
  else
  if AElement is TGDAOObject then
  begin
    cat := TGDAOObject(AElement).OwnerCategory;
    if (cat <> nil) and (cat.Data is TTreeView) then
      result := TTreeView(cat.Data);
  end;
end;

function TfmProject.FindElementTreeNode(AElement: TObject): TTreeNode;
var
  i: integer;
  ATree: TTreeView;
begin
  if AElement <> nil then
  begin
    ATree := FindElementTreeView(AElement);
    if ATree <> nil then
      for i := 0 to ATree.Items.count-1 do
        if (integer(ATree.Items[i].Data) > DATA_OBJECT) and (ATree.Items[i].Data = AElement) then
        begin
          result := ATree.Items[i];
          exit;
        end;
  end;
  result := nil;
end;

function TfmProject.ImportDD: Boolean;
begin
  with TfmImportWizard.Create(nil) do
  try
    result := Execute(FMetaData);
    if result then
      SetModified(self);
  finally
    Free;
  end;
end;

procedure TfmProject.MetaDataModified(Sender: TObject);
begin
  SetModified(Sender);
end;

procedure TfmProject.MetaDataPerformMessage(var Msg: TMsg;
  var Handled: Boolean);
begin
  Perform(Msg.Message, Msg.wParam, Msg.lParam);
end;

procedure TfmProject.miCloseAllTabExceptClick(Sender: TObject);
var
  i: integer;
begin
  if FContextTab >= 0 then
    for i := pcTabs.AdvPageCount-1 downto 0 do
      if i <> FContextTab then
        CloseExplorerPage(i);
end;

procedure TfmProject.miCloseTabClick(Sender: TObject);
begin
  if FContextTab >= 0 then
    CloseExplorerPage(FContextTab);
end;

procedure TfmProject.miGotoObjectClick(Sender: TObject);
begin
  if Assigned(lvCheck.Selected) and Assigned(lvCheck.Selected.Data) then
    GotoReportItemObject(TCheckReportItem(lvCheck.Selected.Data));
end;

function TfmProject.NewDlg(AImportDD: Boolean): boolean;
begin
  if AImportDD then
    Result := ImportDD
  else
    Result := ConfigureNew;

  if Result then
  begin
    FMetaData.DiagramObj.Diagrams.Add.DiagramName := 'Main Diagram';

    ReloadTreeView;
    FMetaData.AddFirstVersion;

    if AImportDD then
    begin
      SetModified(self);
    end;

    {let's open the main diagram by default. We can consider not
     doing this later, let's see what users say}
    SelectElement(FMetaData.DiagramObj.Diagrams[0], true);
    pnTree.ActivePanel := FElementarPanel[elTables];
  end;
end;

procedure TfmProject.NewRelationshipDialog(DefaultParent,
  DefaultChild: TGDAOTable);
begin
  with TfmNewRelation.Create(nil) do
  try
    DataDictionary := FMetaData.DataDictionary;
    if DefaultParent <> nil then
      ParentTable := DefaultParent;
    if DefaultChild <> nil then
      ChildTable := DefaultChild;
    if ShowModal = mrOk then
    begin
      AddRelationshipsToTreeView(Relationship);

      {Only opens the newly created relationship if we're not
       displaying a diagram tab}
      if CurrentDiagramFrame = nil then
        SelectElement(Relationship, true);
      RefreshOpenedDiagrams(Relationship);
      SetModified(Self);
    end;
  finally
    Free;
  end;
end;

function TfmProject.Open(AFileName: string): boolean;
begin
  if FMetaData <> nil then
  begin
    FMetaData.Free;
    FMetaData := nil;
  end;

  FMetaData := TAppMetaData.LoadFromFile(AFileName);
  SetDictionaryNotificationEvents;

  if FMetaData.Modified then
  begin
    ShowMessage(SProjectUpdatedMustBeSaved);
    SetModified(self);
  end;

  ReloadTreeView;
  result := true;
end;

procedure TfmProject.DoSave(AFileName: string);
begin
  { save the project }
  FMetaData.SaveToFile(AFileName);
  FModified := false;
end;

function TfmProject.DuplicateTableDialog(ATable: TGDAOTable): TGDAOTable;
var
  DupForm: TfmDuplicateTable;
begin
  Result := nil;
  DupForm := TfmDuplicateTable.Create(nil);
  try
    DupForm.SetInfo(FMetaData.DataDictionary, ATable);
    if DupForm.ShowModal = mrOk then
    begin
      Result := DupForm.NewTable;
      AddTablesToTreeView(Result);
      {Only opens the newly created table if we're not
       displaying a diagram tab}
      if CurrentDiagramFrame = nil then
      begin
        SelectElement(Result, true);
        SendMessageToActiveFrame(WM_DM_NEW_TABLE);
      end;
      SetModified(Self);
    end;
  finally
    DupForm.Free;
  end;
end;

procedure TfmProject.Savemessages1Click(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  if dlgSaveMessages.Execute then
  begin
    sl := TStringList.Create;
    try
      for i := 0 to lvCheck.Items.Count - 1 do
        sl.Add(lvCheck.Items[i].Caption);
      sl.SaveToFile(dlgSaveMessages.FileName);
    finally
      sl.Free;
    end;
  end;
end;

procedure TfmProject.SaveVisualSettings;
begin
  DMRegistry.ProjectExplorerWidth := pnTree.Width;
  DMRegistry.MessagesPanelHeight := pnCheck.Height;
end;

procedure TfmProject.SetDictionaryNotificationEvents;
begin
  FMetaData.OnModify := MetaDataModified;
  FMetaData.OnPerformMessage := MetaDataPerformMessage;
  //FMetaData.DataDictionary.OnFieldDestroy := DictionaryFieldDestroy;
  FMetaData.DataDictionary.OnTableDestroy := DictionaryTableDestroy;
  FMetaData.DataDictionary.OnFieldNameChanged := DictionaryFieldNameChanged;
end;

procedure TfmProject.SetModified(Sender: TObject);
begin
  FModified:=true;
end;

procedure TfmProject.SetMustShowNavigator(const Value: boolean);
begin
  FMustShowNavigator := Value;
  DMRegistry.ShowNavigator := Value;
  UpdateNavigator;
end;

procedure TfmProject.UpdateNavigator;
begin
  NavigatorPanel.Visible := (CurrentDiagramFrame <> nil) and FMustShowNavigator;
  NavigatorSplitter.Top := 0;
  NavigatorSplitter.Visible := NavigatorPanel.Visible;
  if NavigatorPanel.Visible then
  begin
    FNavigator.Diagram := CurrentDiagramFrame;
  end else
  begin
    FNavigator.Diagram := nil;
  end;
end;

procedure TfmProject.SetParent(AParent: TWinControl);
begin
  inherited;
  {if parent changes, recreate the treeview. If we don't, nodes will
   be in a random order and reference to nodes (FElementarNode, for example)
   will become invalid}
  if not (csDestroying in ComponentState) then
    ReloadTreeView;
end;

function TfmProject.ShowConvertDatabaseDlg: Boolean;
var
  ConvForm: TfmDatabaseConvert;
begin
  Result := False;
  ConvForm := TfmDatabaseConvert.Create(nil);
  try
    ConvForm.AMD := Self.MetaData;

    // closing tabs

    if ConvForm.ShowModal = mrOk then
    begin
      Result := true;
      SetModified(nil);

      {The items must been already closed by the form. We keep the code below
      just to be sure...}
      FreeExplorerItems;
      ReloadTreeView;
    end;
  finally
    ConvForm.Free;
  end;
end;

procedure TfmProject.ShowExplorerPanel(AFocus: boolean);
begin
  pnTree.Show;
  spMiddle.Show;
  spMiddle.Left := pnTree.Left + pnTree.Width + 1;
  if AFocus then
  begin
    if (pnTree.ActivePanel <> nil) and (pnTree.ActivePanel.ControlCount > 0)
      and (pnTree.ActivePanel.Controls[0] is TWinControl) then
      TWinControl(pnTree.ActivePanel.Controls[0]).SetFocus;
  end;
end;

procedure TfmProject.ShowGenerateScriptDialog;
begin
  with TfmGenerateScript.Create(nil) do
  try
    MetaData := Self.FMetaData;
    ShowModal;
  finally
    free;
  end;
end;

function TfmProject.ShowManageVersionsDlg: boolean;
var formVersions: TfrmManageVersions;
begin
  result := False;
  formVersions := TfrmManageVersions.Create(nil);
  try
    formVersions.AMD := MetaData;
    formVersions.ShowModal;
    if formVersions.Modified then
    begin
      result := True;
      SetModified(nil);

      {The items must been already closed by the form. We keep the code below
      just to be sure...}
      FreeExplorerItems;
      TDBProperties.AllocObjectCategories(Self.MetaData.DataDictionary);
      ReloadTreeView;
    end;
  finally
    formVersions.Free;
  end;
end;

procedure TfmProject.ShowMessagesPanel(AFocus: boolean);
begin
  pnCheck.Show;
  spBottom.Show;
  spBottom.Top := pnCheck.Top - 1;
  if AFocus then
    lvCheck.SetFocus;
end;

procedure TfmProject.ShowNavigator;
begin
  FMustShowNavigator := true;
  UpdateNavigator;
end;

function TfmProject.FocusedTreeView: TTreeView;
var
  c: integer;
begin
  result := nil;
  for c := 0 to pnTree.PanelCount - 1 do
    if (pnTree.Panels[c].ControlCount > 0) and (pnTree.Panels[c].Controls[0] is TTreeView)
      and (TTreeView(pnTree.Panels[c].Controls[0]).Focused) and
      (pnTree.Panels[c] = pnTree.ActivePanel) then
    begin
      result := TTreeView(pnTree.Panels[c].Controls[0]);
      break;
    end;
end;

procedure TfmProject.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveVisualSettings;
end;

procedure TfmProject.FormCreate(Sender: TObject);
begin
  ParentColor := true;

  FExplorer := TProjectExplorer.Create;
  FCheckReport := TCheckReport.Create;

  pnTree.PanelOrder := poTopToBottom;
end;

procedure TfmProject.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: integer;
begin
  if ssCtrl in Shift then
  begin
    if ssShift in Shift then
    begin
      for i := 0 to pnTree.PanelCount-1 do
        if Pos(Chr(Key), pnTree.Panels[i].Caption) = 1 then
        begin
          pnTree.ActivePanel := pnTree.Panels[i];
          break;
        end;
    end
    else if Key = Ord('W') then
    begin
      if pcTabs.ActivePage <> nil then
        pcTabs.CloseActivePage;
    end;
  end;
end;

procedure TfmProject.FormShow(Sender: TObject);
begin
  RestoreVisualSettings;
end;

procedure TfmProject.PanelTreeDblClick(Sender: TObject);
var
  ATreeView: TTreeView;
begin
  ATreeView := TTreeView(Sender);
  if ATreeView.Selected <> nil then
  begin
    if (integer(ATreeView.Selected.Data) > DATA_OBJECT) and not (TObject(ATreeView.Selected.Data) is TGDAOCategory) then
      SelectElement( TObject(ATreeView.Selected.Data), true);
  end;
end;

procedure TfmProject.SelectElement(AElement: TObject; AOpenIfClosed: boolean);
var
  AFrame: TWinControl;
  ATab: TAdvOfficePage;
  idx : Integer;

begin
  idx := FExplorer.FindByElement(AElement);
  if idx >= 0 then
    pcTabs.ActivePage := FExplorer.Items[idx].Page
  else
  if AOpenIfClosed then
  begin
    FCreating := true;

    // creating page
    ATab := TAdvOfficePage.Create(nil);

    // properties
    if AElement is TGDAOTable then
    begin
      ATab.Caption := TGDAOTable(AElement).TableName;
    end
    else if AElement is TGDAORelationship then
    begin
      ATab.Caption := TGDAORelationship(AElement).RelationshipName;
    end
    else if AElement is TGDAOObject then
    begin
      ATab.Caption := TGDAOObject(AElement).ObjectName;
    end
    else if AElement is TGDAODiagram then
    begin
      ATab.Caption := TGDAODiagram(AElement).DiagramName;
    end;

    ATab.ShowClose      := true;

    //ATab.Color          := clWhite;
    ATab.AdvOfficePager := pcTabs;
    // events
    ATab.OnShow := OnShowExplorerPage;

    AFrame := nil;
    if AElement is TGDAOTable then
      SetupTableFrame(ATab, AFrame, AElement)
    else if AElement is TGDAORelationship then
      SetupRelationshipFrame(ATab, AFrame, AElement)
    else if AElement is TGDAOObject then
      SetupObjectFrame(ATab, AFrame, AElement)
    else if AElement is TGDAODiagram then
      SetupDiagramTab(ATab, AFrame, AElement);

    // registering new explorer element
    FExplorer.Add(AElement, AFrame, ATab);

    // selecting
    pcTabs.ActivePage := ATab;
    FCreating := false;
  end;
end;

procedure TfmProject.FreeExplorerItems;
var
  i: Integer;
begin
  for i := FExplorer.Count - 1 downto 0 do
    CloseExplorerPage(i);
  FExplorer.Clear;
end;

procedure TfmProject.CloseExplorerPage(idx: integer; ADestroyPage: boolean = true);
var
  newidx: integer;
begin
  if (idx >= 0) and (idx < FExplorer.Count) then
  begin
    if FExplorer.Items[idx].Element is TGDAODiagram then
       TGDAODiagram(FExplorer.Items[idx].Element).CloseDiagramPage
    else
    if FExplorer.Items[idx].FrameCtrl <> nil then
      FExplorer.Items[idx].FrameCtrl.Free;

    if ADestroyPage then                       
    begin
      if pcTabs.ActivePageIndex = idx then
      begin
        {The page will be destroyed, select the next page to be selected}
        newidx := idx + 1;
        if newidx >= pcTabs.AdvPageCount then
          newidx := idx - 1;
        if (newidx >= 0) and (newidx < pcTabs.AdvPageCount) then
          pcTabs.ActivePageIndex := newidx;
      end;

      FExplorer.Items[idx].Page.Free;
      pcTabsChange(pcTabs);
      CheckCloseButton;
    end;

    FExplorer.Delete(idx);
  end;
end;

procedure TfmProject.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Visible then
    Realign;
end;

procedure TfmProject.DeleteTable(ATable: TGDAOTable);
var
  c: integer;
  i: integer;
  ABlock: TTableDiagramBlock;
  ATableID: integer;
begin
  {Delete all relationships related to the table}
  c := 0;
  with FMetaData.DataDictionary.Relationships do
    while c < Count do
      if (Items[c].ParentTable = ATable) or (Items[c].ChildTable = ATable) then
        DeleteRelationship(Items[c])
      else
        inc(c);

  // closing
  CloseElement(ATable);
  // deleting
  RemoveNodeReference(ATable);

  ATableID := ATable.TID;
  ATable.Free;
  SetModified(nil);

  {remove reference to table from existing opened diagrams}
  for c := 0 to FMetaData.DiagramObj.Diagrams.Count - 1 do
  begin
    ABlock := FMetaData.DiagramObj.Diagrams[c].DiagramControl.FindTableBlockID(ATableID);

    if ABlock <> nil then
    begin
      {Remove all lines attached to the block}
      for i := 0 to ABlock.LinkPoints.Count - 1 do
        while ABlock.LinkPoints[i].AnchoredCount > 0 do
           ABlock.LinkPoints[i].Anchoreds[0].DControl.Free;

      ABlock.Free;
    end;
  end;
end;

destructor TfmProject.Destroy;
begin
  FreeExplorerItems;
  FExplorer.Free;
  FCheckReport.Free;

  if Assigned(FMetadata) then
    FreeAndNil(FMetadata);
  inherited;
end;

procedure TfmProject.acDeleteTreeItemExecute(Sender: TObject);
begin
  DeleteSelectedElement;
end;

procedure TfmProject.acDeleteTreeItemUpdate(Sender: TObject);
begin
  acDeleteTreeItem.Enabled := (FocusedTreeView <> nil) and (FocusedTreeView.Selected <> nil);
end;

procedure TfmProject.acOpenTreeItemExecute(Sender: TObject);
begin
  OpenSelectedElements(FocusedTreeView);
end;

procedure TfmProject.acOpenTreeItemUpdate(Sender: TObject);
begin
  acOpenTreeItem.Enabled := (FocusedTreeView <> nil) and (FocusedTreeView.Selected <> nil) and (integer(FocusedTreeView.Selected.Data) > DATA_OBJECT);
  acOpenTreeItem.Caption := 'Open ' + ElementarTreeDescription(FocusedTreeView);
end;

procedure TfmProject.acRenameTreeItemExecute(Sender: TObject);
begin
  RenameSelectedElement;
end;

procedure TfmProject.acSelectAllTreeItemsExecute(Sender: TObject);
var
  tv: TTreeView;
  AList: TList;
  ANode: TTreeNode;
begin
  {Selects every item listed in the panel (only the items matching its filter)}
  tv := FocusedTreeView;
  if tv = nil then
    Exit;
  AList := TList.Create;
  try
    {The current item stays the primary selected one}
    if (tv.Selected <> nil) and (integer(tv.Selected.Data) > DATA_OBJECT) then
      AList.Add(tv.Selected.Data);
    ANode := tv.Items.GetFirstNode;
    while ANode <> nil do
    begin
      if (integer(ANode.Data) > DATA_OBJECT) and (AList.IndexOf(ANode.Data) < 0) then
        AList.Add(ANode.Data);
      ANode := ANode.GetNext;
    end;
    SelectTreeElements(tv, AList);
  finally
    AList.Free;
  end;
end;

procedure TfmProject.acSelectAllTreeItemsUpdate(Sender: TObject);
begin
  acSelectAllTreeItems.Enabled := (FocusedTreeView <> nil) and (FocusedTreeView.Items.Count > 0);
end;

procedure TfmProject.acUnselectAllTreeItemsExecute(Sender: TObject);
begin
  if FocusedTreeView <> nil then
  begin
    Inc(FUpdatingSelectedItem);
    try
      FocusedTreeView.ClearSelection(false);
    finally
      Dec(FUpdatingSelectedItem);
    end;
  end;
end;

procedure TfmProject.acUnselectAllTreeItemsUpdate(Sender: TObject);
begin
  acUnselectAllTreeItems.Enabled := (FocusedTreeView <> nil) and
    ((FocusedTreeView.Selected <> nil) or (FocusedTreeView.SelectionCount > 0));
end;

procedure TfmProject.acRenameTreeItemUpdate(Sender: TObject);
begin
  acRenameTreeItem.Enabled := (FocusedTreeView <> nil) and (FocusedTreeView.Selected <> nil) and
    (FocusedTreeView.SelectionCount <= 1);
end;

procedure TfmProject.Addtable1Click(Sender: TObject);
begin
  AddDDItem(plTable);
end;

procedure TfmProject.pcTabsChange(Sender: TObject);
var
  tn: TTreeNode;
  tv: TTreeView;
  idx: integer;
begin
  if FUpdatingSelectedItem = 0 then
  begin
    idx := FExplorer.FindByPage(pcTabs.ActivePage);
    if idx >= 0 then
    begin
      tv := FindElementTreeView(FExplorer.Items[idx].Element);
      tn := FindElementTreeNode(FExplorer.Items[idx].Element);
      {A node that is already selected is left alone, so a multi-selection is kept}
      if (tv <> nil) and (tn <> nil) and not tn.Selected then
      begin
        Inc(FUpdatingSelectedItem);
        try
          tv.Selected := tn;
        finally
          Dec(FUpdatingSelectedItem);
        end;
      end;
    end;
    UpdateNavigator;
  end;
end;

procedure TfmProject.pcTabsChanging(Sender: TObject; FromPage,
  ToPage: Integer; var AllowChange: Boolean);
begin
  if GetCurrentTableFrame <> nil then
    GetCurrentTableFrame.pnLinks.Hide;
  if GetCurrentRelationshipFrame <> nil then
    GetCurrentRelationshipFrame.pnLinks.Hide;
end;

procedure TfmProject.pcTabsClosedPage(Sender: TObject; PageIndex: Integer);
var
  newidx: integer;
begin
  CheckCloseButton;

  {The page will be destroyed, select the next page to be selected}
  newidx := PageIndex;
  if newidx >= pcTabs.AdvPageCount then
    newidx := Pageindex - 1;
  if (newidx >= 0) and (newidx < pcTabs.AdvPageCount) then
    pcTabs.ActivePageIndex := newidx;
end;

procedure TfmProject.pcTabsClosePage(Sender: TObject; PageIndex: Integer;
  var Allow: Boolean);
var
  idx : Integer;
begin
  idx := FExplorer.FindByPage(pcTabs.AdvPages[PageIndex]);
  if idx > -1 then
  begin
    {Close explorer page but do not destroy it, because when this event is called,
     it means that close click button was pressed, so AdvPageControl will
     destroy the page itself}
    CloseExplorerPage(idx, false);
  end;
end;

type
  THackOfficePager = class(TAdvOfficePager)
  end;

procedure TfmProject.pcTabsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FContextTab := THackOfficePager(pcTabs).PTOnTab(X, Y);
  if (FContextTab >= 0) and (Button in [mbMiddle, mbRight]) then
  begin
    if Button = mbMiddle then
      CloseExplorerPage(FContextTab)
    else
      popTabs.Popup(pcTabs.ClientOrigin.X + X, pcTabs.ClientOrigin.Y + Y);
      
    {Call abort to avoid TAdvOfficePager to select the newly clicked tab.
     OfficePage should be fixed to not select tabs when middle mouse button
     is clicked.}
    Abort;
  end;
end;

procedure TfmProject.AdvToolButton1Click(Sender: TObject);
begin
  AddDDItem(plTable);
end;

procedure TfmProject.RefreshObjectName(AObject: TGDAOObject);
var
  i: integer;
  tn: TTreeNode;
begin
  // object page title
  i := FExplorer.FindByElement(AObject);
  if i > -1 then
    FExplorer.Items[i].Page.Caption := AObject.ObjectName;
  // tree
  tn := FindElementTreeNode(AObject);
  if Assigned(tn) then
  begin
    tn.Text := AObject.ObjectName;
    tn.TreeView.AlphaSort;
  end;
end;

procedure TfmProject.RefreshOpenedDiagrams(ARelationshipRefresh: TGDAORelationship);
var
  i: integer;
begin
  for i := 0 to FExplorer.Count-1 do
    if FExplorer.Items[i].Element is TGDAODiagram then
      with TGDAODiagram(FExplorer.Items[i].Element).DiagramControl do
      begin
        {if ARelationshipRefresh <> nil then
          CheckRelationships;}
        RefreshDisplay;
      end;
end;

procedure TfmProject.RefreshRelationshipName(ARelationship: TGDAORelationship);
var
  i: integer;
  tn: TTreeNode;
begin
  // relationship page title
  i := FExplorer.FindByElement(ARelationship);
  if i > -1 then
    FExplorer.Items[i].Page.Caption := ARelationship.RelationshipName;
  // tree
  tn := FindElementTreeNode(ARelationship);
  if Assigned(tn) then
  begin
    tn.Text := ARelationship.RelationshipName;
    tn.TreeView.AlphaSort;
  end;
end;

procedure TfmProject.RefreshTableName(ATable: TGDAOTable);
var
  i: integer;
  tn: TTreeNode;
begin
  // table page title
  i := FExplorer.FindByElement(ATable);
  if i > -1 then
    FExplorer.Items[i].Page.Caption := ATable.TableName;
  // tree
  tn := FindElementTreeNode(ATable);
  if Assigned(tn) then
  begin
    tn.Text := ATable.TableName;
    tn.TreeView.AlphaSort;
  end;
end;

procedure TfmProject.RefreshTableTab(ATable: TGDAOTable);
var
  idx: integer;
begin
  idx := FExplorer.FindByElement(ATable);
  if idx >= 0 then
  begin
    if FExplorer[idx].FrameCtrl is TfmTableElements then
      TfmTableElements(FExplorer[idx].FrameCtrl).RefreshFullFrameInformation;
  end;
end;

procedure TfmProject.AdvToolButton1MouseEnter(Sender: TObject);
begin
  TAdvToolButton(Sender).Font.Style := [fsUnderLine];
end;

procedure TfmProject.AdvToolButton1MouseLeave(Sender: TObject);
begin
  TAdvToolButton(Sender).Font.Style := [];
end;

procedure TfmProject.AureliusExport;
var
  ExportForm: TfmAureliusExport;
begin
  ExportForm := TfmAureliusExport.Create(nil);
  try
    if ExportForm.ShowDialog(Self.MetaData) then
      SetModified(self);
  finally
    ExportForm.Free;
  end;
end;

procedure TfmProject.OnShowExplorerPage(Sender: TObject);
var p : TProjectOpenedItem;
begin
  pcTabs.ButtonSettings.CloseButton := pcTabs.AdvPageCount > 0;
  if FCreating then exit;
  if FExplorer.FindByPage(TAdvOfficePage(Sender)) > -1 then
  begin
    p := FExplorer.Items[ FExplorer.FindByPage(TAdvOfficePage(Sender)) ];
    if p.FrameCtrl is TfmTableElements then
      TfmTableElements(p.FrameCtrl).RefreshFullFrameInformation
    else
    if p.Element is TGDAODiagram then
      TGDAODiagram(p.Element).DiagramControl.RefreshDisplay
    else
    if p.FrameCtrl is TfmRelationshipEditor then
      TfmRelationshipEditor(p.FrameCtrl).RefreshFullFrameInformation;
  end;
end;

procedure TfmProject.CloseElement(AElement: TObject);
begin
  CloseExplorerPage(FExplorer.FindByElement(AElement));
end;

procedure TfmProject.ReloadTreeView;
var
  i: Integer;
  APanelIndex: integer;
  ANewPanel: TAdvNavBarPanel;
  ATree: TTreeView;
  AOldActive: string;
  AFilters: TStringList;
  AFilterEdit: TEdit;
begin
  {Keep the filter text of each panel, by panel caption}
  AFilters := TStringList.Create;
  try
  AFilters.NameValueSeparator := #1;
  for i := 0 to pnTree.PanelCount - 1 do
    if (pnTree.Panels[i].ControlCount > 0) and (pnTree.Panels[i].Controls[0] is TTreeView) then
    begin
      AFilterEdit := TreeFilterEdit(TTreeView(pnTree.Panels[i].Controls[0]));
      if AFilterEdit <> nil then
        AFilters.Values[pnTree.Panels[i].Caption] := AFilterEdit.Text;
    end;

  FElementarTree[elDictionary] := nil;
  FElementarTree[elTables] := nil;
  FElementarTree[elRelationships] := nil;
  FElementarTree[elDiagrams] := nil;

  if pnTree.ActivePanel <> nil then
    AOldActive := pnTree.ActivePanel.Caption
  else
    AOldActive := '';

  while pnTree.PanelCount > 0 do
    pnTree.RemovePanel(0);

  {Diagrams panel}
  FElementarPanel[elDiagrams] := pnTree.AddPanel;
  with FElementarPanel[elDiagrams] do
  begin
    Caption := 'Diagrams';
    ImageIndex := IMAGEPANEL_DIAGRAMS;
    CaptionHint := ElementarPanelHint(Caption);
  end;
  FElementarTree[elDiagrams] := CreatePanelTreeView(FElementarPanel[elDiagrams],
    AFilters.Values[FElementarPanel[elDiagrams].Caption]);

  {Tables panel}
  FElementarPanel[elTables] := pnTree.AddPanel;
  with FElementarPanel[elTables] do
  begin
    Caption := 'Tables';
    ImageIndex := IMAGEPANEL_TABLES;
    CaptionHint := ElementarPanelHint(Caption);
  end;
  FElementarTree[elTables] := CreatePanelTreeView(FElementarPanel[elTables],
    AFilters.Values[FElementarPanel[elTables].Caption]);

  {Relationships panel}
  if FMetaData.DataDictionary.DatabaseType.EnableRelationships then
  begin
    FElementarPanel[elRelationships] := pnTree.AddPanel;
    with FElementarPanel[elRelationships] do
    begin
      Caption := 'Relationships';
      ImageIndex := IMAGEPANEL_RELATIONSHIPS;
      CaptionHint := ElementarPanelHint(Caption);
    end;
    FElementarTree[elRelationships] := CreatePanelTreeView(FElementarPanel[elRelationships],
      AFilters.Values[FElementarPanel[elRelationships].Caption]);
  end;

  {Objects panel}
  with FMetaData.DataDictionary do
    for i := 0 to Categories.Count - 1 do
    begin
      ANewPanel := pnTree.AddPanel;
      with ANewPanel do
      begin
        Caption := Categories[i].CategoryNameP;
        ImageIndex := GetObjectImageIndex(Categories[i]);
        CaptionHint := ElementarPanelHint(Caption);
      end;
      ATree := CreatePanelTreeView(ANewPanel, AFilters.Values[ANewPanel.Caption]);
      Categories[i].Data := ATree;
    end;

  {Now add dynamic items}
  AddTablesToTreeView;
  AddRelationshipsToTreeView;
  AddDiagramsToTreeView;
  for i := 0 to FMetaData.DataDictionary.Categories.Count - 1 do
    AddObjectsToTreeView(FMetaData.DataDictionary.Categories[i]);

  APanelIndex := -1;
  if AOldActive <> '' then
    for I := 0 to pnTree.PanelCount - 1 do
      if SameText(pnTree.Panels[i].Caption, AOldActive) then
      begin
        APanelIndex := I;
        break;
      end;

  if APanelIndex = -1 then
    APanelIndex := 1; //Select tables panel 

  {Use ActiveTabIndex, not ActivePanel, because ActivePanel is buggy. It doesn't make
  the previous selected panel unvisible, making two panels visible (so the panel
  can receive tab stops)}
  pnTree.ActiveTabIndex := APanelIndex;
  pnTree.SplitterPosition := MaxInt;
  finally
    AFilters.Free;
  end;
end;

procedure TfmProject.RemoveDeleteFromDiagram;
var
  td:  TAdvTaskDialog;
  CanRemoveGraphically: boolean;
  CanDeleteFromProject: boolean;
begin
  if (CurrentDiagramFrame <> nil) and (CurrentDiagramFrame.SelectedCount > 0) then
  begin
    {Only gives option to delete from project if there are tables or relationships
     selected}
    CanDeleteFromProject := (CurrentDiagramFrame.FirstSelectedTable <> nil) or
      (CurrentDiagramFrame.FirstSelectedRelationship <> nil);

    {if there are only relationships selected, then there is no option
    to remove graphically}
    CanRemoveGraphically := (CurrentDiagramFrame.SelectedLinkCount <>
      CurrentDiagramFrame.SelectedCount);

    {Show a dialog to choose between removing graphical elements only, or actual
     objects from project}
    td := TAdvTaskDialog.Create(Application);
    try
      td.Title := 'Confirmation';
      td.Instruction := 'Are you sure you want delete/remove the selected objects?';
      td.Content := 'Please choose the removal option. ';
      if CanDeleteFromProject then
        td.Content := td.Content + 'If you choose "delete objects from project", '+
        'tables and relationships will be permanently deleted from the project.';
      td.Icon := tiWarning;
      td.CommonButtons := [cbYes, cbNo];
      td.DefaultButton := 2;
      td.Options := td.Options + [doAllowDialogCancel];
      td.RadioButtons.Clear;
      if CanRemoveGraphically then
        td.RadioButtons.Add('&Remove graphical element only');
      if CanDeleteFromProject then
        td.RadioButtons.Add('&Delete objects from project');
      if td.Execute = mrYes then
      begin
        case td.RadioButtonResult of
          200:
            if CanRemoveGraphically then
              CurrentDiagramFrame.RemoveSelectedObjects
            else
              {if "remove graphically option" is not present, then the value
               of "Delete obejcts from project" will be 200}
              DeleteSelectedDiagramObjects;
          201:
            DeleteSelectedDiagramObjects;
        end;
      end;
    finally
      td.Free;
    end;
  end;
end;

procedure TfmProject.RemoveNodeReference(AObj: TObject);
var
  ANode: TTreeNode;
begin
  ANode := FindElementTreeNode(AObj);
  if ANode <> nil then
    ANode.Data := nil;
end;

procedure TfmProject.RenameSelectedElement;
begin
  if (FocusedTreeView <> nil) and not (FocusedTreeView.IsEditing) and (FocusedTreeView.Selected <> nil) and
    (FocusedTreeView.SelectionCount <= 1) then
  begin
    FAllowTreeEdit := true;
    FocusedTreeView.Selected.EditText;
  end;
end;

procedure TfmProject.RestoreVisualSettings;
var
  i: integer;
begin
  i := DMRegistry.ProjectExplorerWidth;
  if i > 0 then
    pnTree.Width := i;
  i := DMRegistry.MessagesPanelHeight;
  if i > 0 then
    pnCheck.Height := i;
end;

procedure TfmProject.AddTablesToTreeView(ASelObj: TObject);
var
  i: Integer;
  tv: TTreeView;
  tn, tnsel: TTreeNode;
  table: TGDAOTable;
  AShowObj: TObject;
begin
  tv := FElementarTree[elTables];

  {An object passed explicitly is shown even if it does not match the filter}
  AShowObj := ASelObj;

  {if no selection object is specified, then set the currently selected object
   as the object to be selected}
  if (ASelObj = nil) and (tv.Selected <> nil) then
    ASelObj := tv.Selected.Data;

  tnsel := nil;
  tv.Items.BeginUpdate;
  try
    tv.Items.Clear;

    for i := 0 to FMetaData.DataDictionary.Tables.Count-1 do
    begin
      table := FMetaData.DataDictionary.Tables[i];
      if table.Visible and ((table = AShowObj) or TreeFilterMatch(tv, table.TableName)) then
      begin
        tn := tv.Items.Add(nil, table.TableName);
        with tn do
        begin
          ImageIndex := IMAGEOBJECT_TABLE;
          SelectedIndex := IMAGEOBJECT_TABLE;
          Data := table;
          if Data = ASelObj then
            tnsel := tn;
        end;
      end;
    end;
  finally
    tv.AlphaSort;
    TreeViewEndUpdate(tv, tnsel);
  end;
end;

procedure TfmProject.acAddDiagramExecute(Sender: TObject);
var
  element: TObject;
  dname: string;
begin
  dname := FMetaData.DiagramObj.Diagrams.GetNewDiagramName;
  element := FMetaData.DiagramObj.Diagrams.Add;
  TGDAODiagram(element).DiagramName := dname;
  AddDiagramsToTreeView(element);
  SelectElement(element, true);
  SetModified(self);
end;

procedure TfmProject.AddDiagramsToTreeView(ASelObj: TObject);
var
  i: Integer;
  tv: TTreeView;
  tn, tnsel: TTreeNode;
begin
  tnsel := nil;
  tv := FElementarTree[elDiagrams];
  tv.Items.BeginUpdate;
  try
    tv.Items.Clear;

    for i := 0 to FMetaData.DiagramObj.Diagrams.Count-1 do
    if (FMetaData.DiagramObj.Diagrams.Items[i] = ASelObj) or
      TreeFilterMatch(tv, FMetaData.DiagramObj.Diagrams.Items[i].DiagramName) then
    begin
      tn := tv.Items.Add(nil, FMetaData.DiagramObj.Diagrams.Items[i].DiagramName);
      with tn do
      begin
        ImageIndex := IMAGEOBJECT_DIAGRAM;
        SelectedIndex := IMAGEOBJECT_DIAGRAM;
        Data := FMetaData.DiagramObj.Diagrams.Items[i];
        if Data = ASelObj then
          tnsel := tn;
      end;
    end;
  finally
    tv.AlphaSort;
    TreeViewEndUpdate(tv, tnsel);
  end;
end;

procedure TfmProject.AddObjectsToTreeView(ACategory: TGDAOCategory; ASelObj: TObject);
var
  i: Integer;
  tv: TTreeView;
  tn, tnsel: TTreeNode;
  obj: TGDAOObject;
begin
  tnsel := nil;
  tv := TTreeView(ACategory.Data);
  tv.Items.BeginUpdate;
  try
    tv.Items.Clear;

    for i := 0 to ACategory.Objects.Count - 1 do
    begin
      obj := ACategory.Objects[i];
      if obj.Visible and ((obj = ASelObj) or TreeFilterMatch(tv, obj.ObjectName)) then
      begin
        tn := tv.Items.Add(nil, obj.ObjectName);
        with tn do
        begin
          ImageIndex := GetObjectImageIndex(ACategory);
          SelectedIndex := ImageIndex;
          Data := obj;
          if Data = ASelObj then
            tnsel := tn;
        end;
      end;
    end;
  finally
    tv.AlphaSort;
    TreeViewEndUpdate(tv, tnsel);
  end;
end;

procedure TfmProject.AddRelationshipsToTreeView(ASelObj: TObject);
var
  tv: TTreeView;
  i: Integer;
  tn, tnsel: TTreeNode;
  rel: TGDAORelationship;
begin
  tnsel := nil;
  tv := FElementarTree[elRelationships];
  if tv <> nil then
  begin
    tv.Items.BeginUpdate;
    try
      tv.Items.Clear;

      for i := 0 to FMetaData.DataDictionary.Relationships.Count-1 do
      begin
        rel := FMetaData.DataDictionary.Relationships[i];
        if rel.Visible and ((rel = ASelObj) or TreeFilterMatch(tv, rel.RelationshipName)) then
        begin
          tn := tv.Items.Add(nil, rel.RelationshipName);
          with tn do
          begin
            ImageIndex := IMAGEOBJECT_RELATIONSHIP;
            SelectedIndex := IMAGEOBJECT_RELATIONSHIP;
            Data := rel;
            if Data = ASelObj then
              tnsel := tn;
          end;
        end;
      end;
    finally
      tv.AlphaSort;
      TreeViewEndUpdate(tv, tnsel);
    end;
  end;
end;

procedure TfmProject.SetupTableFrame(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
begin
  // icon
  ATab.ImageIndex := IMAGEOBJECT_TABLE;

  // creating table element frame
  AFrame := TfmTableElements.Create(self);
  TfmTableElements(AFrame).Name := 'frm'+inttostr(integer(TGDAOTable(AElement)));
  TfmTableElements(AFrame).Parent := ATab;
  TfmTableElements(AFrame).Align := alClient;
  TfmTableElements(AFrame).MetaData := FMetaData;
  TfmTableElements(AFrame).SelectedTable := TGDAOTable(AElement);
  TfmTableElements(AFrame).OnModification := SetModified;
  TfmTableElements(AFrame).OnLinkClick := TableLinkClick;
  TfmTableElements(AFrame).OnUpdateTableName := RefreshTableName;
  TfmTableElements(AFrame).pnLinks.Hide;
  TfmTableElements(AFrame).InitVisualElements;
end;

procedure TfmProject.SetupDiagramTab(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
begin
  // icon
  ATab.ImageIndex := IMAGEOBJECT_DIAGRAM;

  // setting diagram component
  AFrame := TGDAODiagram(AElement).DiagramControl;
  AElement := TGDAODiagram(AElement);
  begin
    TGDAODiagram(AElement).DiagramControl.Name := 'frm'+inttostr(integer(AElement));
    TGDAODiagram(AElement).OpenDiagramPage(ATab);
    TGDAODiagram(AElement).DiagramControl.OnModified := MetaDataModified;
    TGDAODiagram(AElement).DiagramControl.OnEditRelationship := DiagramEditRelationship;
    TGDAODiagram(AElement).DiagramControl.OnEditTable := DiagramEditTable;
  end;
end;

procedure TfmProject.SetupObjectFrame(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
var
  AEditor: IDMObjectEditor;
  AObj: TGDAOObject;
  AFrameControl: TWinControl;
begin
  AObj := TGDAOObject(AElement);
  ATab.ImageIndex := GetObjectImageIndex(AObj.OwnerCategory);

  {Create the editor for the specified object}
  case AObj.OwnerCategory.CategoryType of
    ctSequence:
      begin
        AFrameControl := TfmSequenceEditor.Create(Self);
        AEditor := TfmSequenceEditor(AFrameControl);
      end
  else
    {default editor}
    AFrameControl := TfmObjectEditor.Create(Self);
    AEditor := TfmObjectEditor(AFrameControl);
  end;

  {merge the editor form/frame in the tab}
  AFrameControl.Name := Format('frm%d', [integer(AObj)]);
  AFrameControl.Parent := ATab;
  AFrameControl.Align := alClient;
  if AFrameControl is TForm then
  begin
    TForm(AFrameControl).BorderStyle := bsNone;
    TForm(AFrameControl).BorderIcons := [];
    TForm(AFrameControl).Visible := true;
  end;

  {return the created control}
  AFrame := AFrameControl;

  {prepare the editor}
  AEditor.SetSelectedObject(AObj);
  AEditor.SetOnModified(SetModified);
  AEditor.SetOnUpdateObjectName(RefreshObjectName);
end;

procedure TfmProject.SetupRelationshipFrame(ATab: TAdvOfficePage; var AFrame: TWinControl; AElement: TObject);
begin
  ATab.ImageIndex := IMAGEOBJECT_RELATIONSHIP;

  AFrame := TfmRelationshipEditor.Create(Self);
  TfmRelationshipEditor(AFrame).Name := Format('frm%d', [integer(TGDAORelationship(AElement))]);
  TfmRelationshipEditor(AFrame).Parent := ATab;
  TfmRelationshipEditor(AFrame).Align := alClient;
  //TfmRelationshipEditor(AFrame).MetaData := FMetaData;
  TfmRelationshipEditor(AFrame).SelectedRelationship := TGDAORelationship(AElement);
  TfmRelationshipEditor(AFrame).OnModified := SetModified;
  TfmRelationshipEditor(AFrame).OnLinkClick := TableLinkClick;
  TfmRelationshipEditor(AFrame).OnUpdateRelationshipName := RefreshRelationshipName;
  TfmRelationshipEditor(AFrame).pnLinks.Hide;
end;

procedure TfmProject.PanelTreeStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  tv: TTreeView;
begin
  tv := FocusedTreeView;
  if (tv <> nil) and (tv = FElementarTree[elTables]) and (tv.Selected <> nil) and (integer(tv.Selected.Data) > DATA_OBJECT) and (TObject(tv.Selected.Data) is TGDAOTable) then
  begin
    DragObject := TGDAODragObject.Create(tv);
    TGDAODragObject(DragObject).GDAOObject := TGDAOTable(tv.Selected.Data);
  end
  else
  begin
    DragObject := nil;
  end;
end;

procedure TfmProject.PanelTreeEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if (integer(Node.Data) > DATA_OBJECT) and not (TObject(TTreeView(Sender).Selected.Data) is TGDAOCategory) then
  begin
    AllowEdit := FAllowTreeEdit;
  end
  else
    AllowEdit := false;
  FAllowTreeEdit := false;
end;

procedure TfmProject.PanelTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F2:
      RenameSelectedElement;
    VK_RETURN:
      OpenSelectedElements(TTreeView(Sender));
  end;
end;

procedure TfmProject.PanelTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  N: TTreeNode;
begin
  {Select item even when mouse right button is clicked. Just for better user interface.
   We cannot rely on property RightClickSelect - it doesn't work very well.
   Right click on an item that is already selected keeps the multi-selection, so
   the popup menu acts on all selected items. Left click selection (Ctrl/Shift)
   is handled by the tree view itself}
  N := TTreeView(Sender).GetNodeAt(X, Y);
  if (N <> nil) and (Button = mbRight) and not N.Selected then
    TTreeView(Sender).Select(N, []);

  if (TTreeView(Sender).Selected <> nil) and (TObject((TTreeView(Sender).Selected.Data)) is TGDAOTable) then
    TTreeView(Sender).BeginDrag(false, 5);
end;

procedure TfmProject.PanelTreeEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
var
  idx : Integer;
begin
  if s > '' then
  begin
    // updating the object name
    if TObject(Node.Data) is TGDAOTable then
    begin
      if TGDAOTable(Node.Data).TableName <> s then
        SetModified(Self);
      TGDAOTable(Node.Data).TableName := s;
    end
    else if TObject(Node.Data) is TGDAORelationship then
    begin
      if TGDAORelationship(Node.Data).RelationshipName <> s then
        SetModified(Self);
      TGDAORelationship(Node.Data).RelationshipName := s;
    end
    else if TObject(Node.Data) is TGDAOObject then
    begin
      if TGDAOObject(Node.Data).ObjectName <> s then
        SetModified(Self);
      TGDAOObject(Node.Data).ObjectName := s;
    end
    else if TObject(Node.Data) is TGDAODiagram then
    begin
      if TGDAODiagram(Node.Data).DiagramName <> s then
        SetModified(Self);
      TGDAODiagram(Node.Data).DiagramName := s;
    end;

    // updating opened tab
    idx := FExplorer.FindByElement(TObject(Node.Data));
    if idx > -1 then
    begin
      // there is an opened tab
      FExplorer.Items[idx].Page.Caption := s;
      // message
      SendMessage(FExplorer.Items[idx].FrameCtrl.Handle, WM_DM_OBJECTNAME_CHANGED, integer(FExplorer.Items[idx].Element), 0 );
    end;

    Node.Text := S;
    Node.TreeView.AlphaSort;
  end else
    AddTablesToTreeView;
end;

procedure TfmProject.SendMessageToOpenedFrames(AElementType: TExplorerElement; AMessage: Cardinal; wParam: Integer; lParam : Integer);
var i : Integer;
begin
  for i := 0 to FExplorer.Count - 1 do
    if (FExplorer.Items[i].ElementType = AElementType) or (AElementType = exNone) then
      SendMessage(FExplorer.Items[i].FrameCtrl.Handle, AMessage, wParam, lParam);
end;

procedure TfmProject.PanelTreeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := false;
end;

procedure TfmProject.PanelTreeChange(Sender: TObject; Node: TTreeNode);
var
  tv: TTreeView;
begin
  tv := TTreeView(Sender);

  {Auto select the page, if page is opened}
  if (FUpdatingSelectedItem = 0) and (tv.Selected <> nil) then
  begin
    if tv.Selected.Data <> nil then
    begin
      {Only select object automatically if a diagram is not opened in the screen.
       This is needed because user might want to drag the table to the diagram}
      if CurrentDiagramFrame = nil then
        SelectElement(TObject(tv.Selected.Data), false);
    end;
  end;
end;

procedure TfmProject.PanelTreeCompare(Sender: TObject; Node1,
  Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
  Compare := CompareText(Node1.Text, Node2.Text);
end;

procedure TfmProject.PanelTreeCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  {Just visual stuff to make the tree view with a Access 2007-like appearance}
  if cdsSelected in State then
  begin
    if cdsHot in State then
      Sender.Canvas.Brush.Color := $3FABFF
    else
      Sender.Canvas.Brush.Color := $0069BDFF;

    Sender.Canvas.Font.Color := Self.Font.Color;
    if Sender.Focused then
      Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold]
    else
    begin
      Sender.Canvas.Brush.Color := $00DEDEDE;
    end;
  end else
  if cdsHot in State then
    Sender.Canvas.Brush.Color := $00A2E7FF;
end;

procedure TfmProject.SendMessageToActiveFrame(AMessage: Cardinal; wParam, lParam: Integer);
var idx : Integer;
begin
  idx := FExplorer.FindByPage(pcTabs.ActivePage);
  if idx > -1 then
    SendMessage(FExplorer.Items[idx].FrameCtrl.Handle, AMessage, wParam, lParam);
end;

function TfmProject.GetCurrentTableFrame: TfmTableElements;
begin
  if Assigned(pcTabs.ActivePage) and (pcTabs.ActivePage.ControlCount > 0) and (pcTabs.ActivePage.Controls[0] is TfmTableElements) then
    result := pcTabs.ActivePage.Controls[0] as TfmTableElements
  else
    result := nil;
end;

function TfmProject.GetObjectImageIndex(ACat: TGDAOCategory): integer;
begin
  result := IMAGEPANEL_OBJECT;
  if ACat <> nil then
    case ACat.CategoryType of
      ctProcedure:
        result := IMAGEPANEL_PROCEDURE;
      ctView:
        result := IMAGEPANEL_VIEW;
      ctSequence: 
        result := IMAGEPANEL_SEQUENCE;
    end;
end;

function TfmProject.GetSelectedElement: TObject;
var
  tv: TTreeView;
begin
  tv := FocusedTreeView;
  if (tv <> nil) and Assigned(tv.Selected) and (integer(tv.Selected.Data) > DATA_OBJECT) and not (TObject(tv.Selected.Data) is TGDAOCategory) then
    result := TObject(tv.Selected.Data)
  else
    result := nil;
end;

procedure TfmProject.HideExplorerPanel;
begin
  pnTree.Hide;
  spMiddle.Hide;
end;

procedure TfmProject.HideMessagesPanel;
begin
  pnCheck.Hide;
  spBottom.Hide;
end;

procedure TfmProject.HideNavigator;
begin
  FMustShowNavigator := false;
  UpdateNavigator;
end;

procedure TfmProject.acTable_AddDiagramUpdate(Sender: TObject);
var
  tv: TTreeView;
begin
  tv := FocusedTreeView;
	acTable_AddDiagram.Enabled :=
    (tv <> nil) and (tv = FElementarTree[elTables]) and
    (tv.Selected <> nil) and (integer(tv.Selected.Data) > DATA_OBJECT) and
	  (TObject(tv.Selected.Data) is TGDAOTable) and Assigned(CurrentDiagramFrame);
  if (tv <> nil) and (tv.SelectionCount > 1) then
    acTable_AddDiagram.Caption := 'Add selected tables to diagram'
  else
    acTable_AddDiagram.Caption := 'Add selected table to diagram';
end;

procedure TfmProject.acTable_DuplicateExecute(Sender: TObject);
var
  table: TGDAOTable;
  tv: TTreeView;
begin
  tv := FElementarTree[elTables];
  if tv.Selected <> nil then
  begin
    table := TGDAOTable(tv.Selected.Data);
    DuplicateTableDialog(table);
  end;
end;

procedure TfmProject.acTable_DuplicateUpdate(Sender: TObject);
var
  tv: TTreeView;
begin
  tv := FocusedTreeView;
	TAction(Sender).Enabled :=
    (tv <> nil) and (tv = FElementarTree[elTables]) and
    (tv.Selected <> nil) and (integer(tv.Selected.Data) > DATA_OBJECT) and
	  (TObject(tv.Selected.Data) is TGDAOTable) and (tv.SelectionCount <= 1);
end;

procedure TfmProject.acTable_FindInDiagramExecute(Sender: TObject);
var
  table: TGDAOTable;
  diagram: TDiagramClass;
  tableBlock: TTableDiagramBlock;
  tv: TTreeView;
begin
  tv := FElementarTree[elTables];
  if tv.Selected <> nil then
  begin
    table := TGDAOTable(tv.Selected.Data);
    diagram := CurrentDiagramFrame;
    tableBlock := diagram.FindTableBlock(table);
    if tableBlock <> nil then
    begin
      tableBlock.MakeVisible;
      diagram.UnselectAll;
      tableBlock.Selected := true;
    end
    else
      ShowMessage('Table ' + table.TableName + ' not found in diagram.')
  end;
end;

procedure TfmProject.acTable_FindInDiagramUpdate(Sender: TObject);
var
  tv: TTreeView;
begin
  tv := FocusedTreeView;
	TAction(Sender).Enabled :=
    (tv <> nil) and (tv = FElementarTree[elTables]) and
    (tv.Selected <> nil) and (integer(tv.Selected.Data) > DATA_OBJECT) and
	  (TObject(tv.Selected.Data) is TGDAOTable) and Assigned(CurrentDiagramFrame) and
    (tv.SelectionCount <= 1);
end;

procedure TfmProject.acTable_AddDiagramExecute(Sender: TObject);
var
  table: TGDAOTable;
  diagram: TDiagramClass;
  AList: TList;
  i: integer;
  AlreadyIn: string;
begin
  diagram := CurrentDiagramFrame;
  if diagram = nil then
    Exit;
  AList := TList.Create;
  try
    GetSelectedElements(FElementarTree[elTables], AList);
    AlreadyIn := '';
    for i := 0 to AList.Count - 1 do
      if TObject(AList[i]) is TGDAOTable then
      begin
        table := TGDAOTable(AList[i]);
        if diagram.FindTableBlock(table) = nil then
          diagram.AddTableBlock(table)
        else
        begin
          if AlreadyIn <> '' then
            AlreadyIn := AlreadyIn + ', ';
          AlreadyIn := AlreadyIn + table.TableName;
        end;
      end;
    if AlreadyIn <> '' then
      if AList.Count = 1 then
        ShowMessage('Table ' + AlreadyIn + ' already in diagram.')
      else
        ShowMessage('Tables already in diagram: ' + AlreadyIn + '.');
  finally
    AList.Free;
  end;
end;

procedure TfmProject.acAddRelationExecute(Sender: TObject);
begin
  AddDDItem(plRelationship);
end;

procedure TfmProject.acAddRelationUpdate(Sender: TObject);
begin
  acAddRelation.Visible := FMetaData.DataDictionary.DatabaseType.EnableRelationships;
end;

procedure TfmProject.acAddTreeItemExecute(Sender: TObject);
var
  tv: TTreeView;
  i: integer;
begin
  tv := FocusedTreeView;
  if tv <> nil then
  begin
    if tv = FElementarTree[elTables] then
      AddDDItem(plTable)
    else if tv = FElementarTree[elRelationships] then
      AddDDItem(plRelationship)
    else if tv = FElementarTree[elDiagrams] then
      acAddDiagram.Execute
    else
    begin
      with FMetaData.DataDictionary do
      begin
        for i := 0 to Categories.Count - 1 do
          if tv = Categories[i].Data then
          begin
            AddDDItem(plObject, Categories[i]);
            break;
          end;
      end;
    end;
  end;
end;

procedure TfmProject.acAddTreeItemUpdate(Sender: TObject);
begin
  acAddTreeItem.Enabled := FocusedTreeView <> nil;
  acAddTreeItem.Caption := 'New ' + ElementarTreeDescription(FocusedTreeView);
end;

procedure TfmProject.DeleteRelationship(ARel: TGDAORelationship);
var
  c, d: integer;
  DiagramRel: TCustomDiagramLine;
  T1, T2: TGDAOTable;
  ARelID: integer;
begin
  CloseElement(ARel);
  T1 := ARel.ParentTable;
  T2 := ARel.ChildTable;

  RemoveNodeReference(ARel);
  ARelID := ARel.RelID;
  ARel.Free;
  RefreshTableTab(T1);
  RefreshTableTab(T2);

  SetModified(nil);

  {remove reference to relationship from existing diagrams}
  for c := 0 to FMetaData.DiagramObj.Diagrams.Count - 1 do
    for d := FMetaData.DiagramObj.Diagrams[c].DiagramControl.LinkCount - 1 downto 0 do
    begin
      DiagramRel := FMetaData.DiagramObj.Diagrams[c].DiagramControl.Links[d];
      if (DiagramRel is TRelationshipDiagramLine)
        and (TRelationshipDiagramLine(DiagramRel).RelID = ARelID) then
      begin
        DiagramRel.Free;
      end;
    end;
end;

procedure TfmProject.DeleteSelectedDiagramObjects;
begin
  // remove objects from data dictionary through diagram
  with CurrentDiagramFrame do
  begin
    while SelectedCount > 0 do
    begin
      if Selecteds[0] is TRelationshipDiagramLine then // relationships
      begin
        if TRelationshipDiagramLine(Selecteds[0]).Relationship <> nil then
          DeleteRelationship(TRelationshipDiagramLine(Selecteds[0]).Relationship)
        else
          Selecteds[0].Free;
      end
      else if Selecteds[0] is TTableDiagramBlock then // tables
      begin
        if TTablediagramBlock(Selecteds[0]).Table <> nil then
          DeleteTable(TTablediagramBlock(Selecteds[0]).Table)
        else
          Selecteds[0].Free;
      end
      else
        Selecteds[0].Free;
    end;
  end;

  AddTablesToTreeView;
  AddRelationshipsToTreeView;
  RefreshOpenedDiagrams;
end;

procedure TfmProject.TableLinkClick(ALinkType: TDesignLinkType; AObject: TObject);
begin
  case ALinkType of
    dltTable: SelectElement(AObject, true);
    dltDiagram: SelectElement(TDiagramClass(AObject).GDAODiagram, true);
  end;
end;

procedure TfmProject.TreeViewEndUpdate(ATree: TTreeView; ANode: TTreeNode);
begin
  ATree.Items.EndUpdate;
  if Assigned(ANode) then
  begin
    ANode.Selected := True;
    ANode.MakeVisible;
  end;
end;

procedure TfmProject.WMCloseExplorerItems(var Msg: TMessage);
begin
  FreeExplorerItems;
end;

procedure TfmProject.WMRemoveDeleteFromDiagram(var Msg: TMessage);
begin
  RemoveDeleteFromDiagram;
end;

procedure TfmProject.WMDiagramPopupMenu(var Msg: TMessage);
begin
  if Parent <> nil then
    SendMessage(Parent.Handle, WM_DM_DIAGRAMPOPUPMENU, 0, 0);
end;

procedure TfmProject.WMRefreshOpenedDiagrams(var Msg: TMessage);
begin
  RefreshOpenedDiagrams(TGDAORelationship(Msg.WParam));
end;

procedure TfmProject.WMSelectElement(var Msg: TMessage);
begin
  SelectElement(TObject(Msg.wParam), true);
end;

function TfmProject.GetCurrentDiagramFrame: TDiagramClass;
var
  idx: integer;
begin
  result := nil;
  if Assigned(pcTabs.ActivePage) then
  begin
     idx := FExplorer.FindByPage(pcTabs.ActivePage);
     if (idx >= 0) and (FExplorer[idx].Element is TGDAODiagram) then
       result := TGDAODiagram(FExplorer[idx].Element).DiagramControl;
  end;
end;

function TfmProject.GetCurrentRelationshipFrame: TfmRelationshipEditor;
begin
  if Assigned(pcTabs.ActivePage) and (pcTabs.ActivePage.ControlCount > 0) and (pcTabs.ActivePage.Controls[0] is TfmRelationshipEditor) then
    result := pcTabs.ActivePage.Controls[0] as TfmRelationshipEditor
  else
    result := nil;
end;

procedure TfmProject.DiagramAddNewTable(ADiagram: TDiagramClass; ABlock: TTableDiagramBlock);
var s: string;
    tb: TGDAOTable;
begin
  { new table inserted on the diagram }
  s := FMetaData.DataDictionary.Tables.GetNewTableName;
  tb := FMetaData.DataDictionary.AddTable(s);
  AddTablesToTreeView(tb);
  ABlock.Table := tb;
  SelectElement(tb, true);
  CurrentTableFrame.ShowLink(dltDiagram, ADiagram);
end;

procedure TfmProject.InsertDiagramTable;
begin
  if Assigned(CurrentDiagramFrame) then
  begin
    CurrentDiagramFrame.OnAddNewTable := DiagramAddNewTable;
    CurrentDiagramFrame.InsertTable;
  end;
end;

function TfmProject.IsExplorerPanelVisible: boolean;
begin
  result := pnTree.Visible;
end;

function TfmProject.IsMessagesPanelVisible: boolean;
begin
  result := pnCheck.Visible;
end;

procedure TfmProject.lvCheckDblClick(Sender: TObject);
begin
  miGotoObjectClick(Sender);
end;

procedure TfmProject.GotoReportItemObject(AItem: TCheckReportItem);
var
  obj: TObject;
begin
  {Check if object is a Table} 
  if AItem.ObjectClass = TGDAOTable then
  begin
    obj := FMetaData.DataDictionary.TableByName(AItem.ObjectName);
    if obj <> nil then
      SelectElement(obj, true);
  end
  else
  {Relationship}
  if AItem.ObjectClass = TGDAORelationship then
  begin
    obj := FMetaData.DataDictionary.RelationshipByName(AItem.ObjectName);
    if obj <> nil then
      SelectElement(obj, true);
  end
  else
  {Item of table (field, index, constraint, trigger)}
  if (AItem.ObjectClass = TGDAOField) or (AItem.ObjectClass = TGDAOIndex)
    or (AItem.ObjectClass = TGDAOConstraint) or (AItem.ObjectClass = TGDAOTrigger) then
  begin
    obj := FMetaData.DataDictionary.TableByName(AItem.ParentObjectName);
    if obj <> nil then
    begin
      SelectElement(obj, true);

      if AItem.ObjectClass = TGDAOField then
        obj := TGDAOTable(obj).FieldByName(AItem.ObjectName)
      else if AItem.ObjectClass = TGDAOConstraint then
        obj := TGDAOTable(obj).Constraints.FindByName(AItem.ObjectName)
      else if AItem.ObjectClass = TGDAOIndex then
        obj := TGDAOTable(obj).Indexes.FindByName(AItem.ObjectName)
      else if AItem.ObjectClass = TGDAOTrigger then
        obj := TGDAOTable(obj).TriggerByName(AItem.ObjectName)
      else
        obj := nil;


      if (obj <> nil) and (CurrentTableFrame <> nil) then
        CurrentTableFrame.ShowTableElement(obj);
    end;
  end
  else
  {Generic object (procedure, view, generator, etc.)}
  if (AItem.ObjectClass = TGDAOObject) then
  begin
    obj := FMetaData.DataDictionary.Categories.FindByType(TGDAOCategoryType(StrToInt(AItem.ParentObjectName)));
    if obj <> nil then
    begin
      obj := TGDAOCategory(obj).Objects.FindByName(AItem.ObjectName);
      if obj <> nil then
        SelectElement(obj, true);
    end;
  end
  else
  {Domain}
  if (AItem.ObjectClass = TGDAODomain) then
  begin
    obj := FMetaData.DataDictionary.Domains.FindByName(AItem.ObjectName);
    if obj <> nil then
    begin
      DomainsDialog(TGDAODomain(obj));
    end;
  end;

end;

procedure TfmProject.InsertDiagramRelationship(AType: TGDAORelationshipType);
begin
  if Assigned(CurrentDiagramFrame) then
  begin
    CurrentDiagramFrame.OnAddNewRelationship := DiagramAddNewRelationship;
    CurrentDiagramFrame.InsertRelationship(AType);
  end;
end;

procedure TfmProject.DiagramAddNewRelationship(ADiagram: TDiagramClass; ALine: TCustomDiagramLine;
  ASourceBlock, ATargetBlock: TTableDiagramBlock; AType: TGDAORelationshipType);
var
  newrel: TGDAORelationship;

  function NewRelationship(AType: TGDAORelationshipType; ADatabase: TGDD; AChildTable, AParentTable: TGDAOTable): boolean;
  var
    recursemsg: boolean;
  begin
    newrel := ADatabase.Relationships.Add;
    newrel.ParentTable := AParentTable;
    newrel.ChildTable := AChildTable;
    newrel.RelationshipType := AType;
    result := newrel.AutoCreateRelationshipKey(AParentTable.PrimaryKeyIndex, true {GlobalDMApp.AutoFieldInRelationship});
    recursemsg := not result;
    result := result and ShowRelationshipDialog(newrel);
    if not result then
    begin
      newrel.Free;
      newrel := nil;
    end;

    if recursemsg then
      ShowMessage('Recursive relationship. Cannot create.');
  end;

var
  ok: boolean;

begin
  if (AType <> ryUndefined) and Assigned(ASourceBlock) and Assigned(ATargetBlock) then
  begin
    case AType of
      ryIdentifying, ryNonIdentifying:
        ok := NewRelationship(AType, ASourceBlock.Table.OwnerDatabase, ATargetBlock.Table, ASourceBlock.Table);
      else
        ok := False;
    end;

    if ok then
    begin
      AddRelationshipsToTreeView(newrel);
      //SelectElement(newrel, true);
    end
    else
      ALine.Visible := False;

    {Post a message to refresh opened diagrams. We cannot call RefreshOpenedDiagrams
     method directly here. This is because if we do, the line inserted might be destroyed
     when refreshing the diagrams or any other destroying issues might occur.
     So, we first leave this event and then the message will be handled accordingly
     when application goes to idle state}
    PostMessage(Self.Handle, WM_DM_REFRESHOPENEDDIAGRAMS, integer(newrel), 0);
  end
  else
    ALine.Visible := False;
end;

procedure TfmProject.InsertDiagramNote;
begin
  if Assigned(CurrentDiagramFrame) then
    CurrentDiagramFrame.InsertNote;
end;

procedure TfmProject.AddAllTablesToDiagram;
begin
  if Assigned(CurrentDiagramFrame) then
    CurrentDiagramFrame.AddAllTables;
end;

procedure TfmProject.Clearmessages1Click(Sender: TObject);
begin
  lvCheck.Items.BeginUpdate;
  try
    lvCheck.Items.Clear;
  finally
    lvCheck.Items.EndUpdate;
  end;
end;

end.

