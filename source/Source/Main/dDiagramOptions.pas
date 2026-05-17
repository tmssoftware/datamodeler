unit dDiagramOptions;

interface

uses
  SysUtils, Classes, Graphics, Menus, AdvMenus, ActnList, ImgList, Controls, Types,
  fProject, uDMApp, uDiagramClass, uGDAO, System.Actions, System.ImageList;

type
  TdmDiagramOptions = class(TDataModule)
    popDiagramTable_dummy: TAdvPopupMenu;
    MenuItem6: TMenuItem;
    imlDiagram: TImageList;
    alDiagram: TActionList;
    acDiagram_Remove: TAction;
    acDiagram_TableColor: TAction;
    acDiagram_TableDisplayAllFields: TAction;
    acDiagram_TableDisplayTableName: TAction;
    acDiagram_TableDisplayAllKeys: TAction;
    acDiagram_TableDisplayPrimaryKeys: TAction;
    acDiagram_TableShowFieldTypes: TAction;
    acDiagram_TableAddRelated: TAction;
    acDiagram_BackgroundColor: TAction;
    acDiagram_RelationLinkFields: TAction;
    acDiagram_RelationStraight: TAction;
    acDiagram_RelationName: TAction;
    acDiagram_AddAllTables: TAction;
    pmDiagram: TAdvPopupMenu;
    Addalltables2: TMenuItem;
    miTableDisplay: TMenuItem;
    Allfields2: TMenuItem;
    Allkeys2: TMenuItem;
    PrimaryKeys2: TMenuItem;
    ablename2: TMenuItem;
    Showfieldtypes2: TMenuItem;
    Addrelatedtablestodiagram1: TMenuItem;
    EEEEE1: TMenuItem;
    acDiagram_EditObject: TAction;
    miEditObjectSeparator: TMenuItem;
    miTableSeparator: TMenuItem;
    Relationships2: TMenuItem;
    Displaynames2: TMenuItem;
    Linkedtofields2: TMenuItem;
    Straightlines1: TMenuItem;
    acDiagram_EditSeparator: TAction;
    acDiagram_TableDisplay: TAction;
    acDiagram_TableSeparator: TAction;
    acDiagram_RemoveSeparator: TAction;
    RemoveDelete1: TMenuItem;
    N1: TMenuItem;
    acDiagram_ShowCaptions: TAction;
    Showcaptions1: TMenuItem;
    acDiagram_SelectAll: TAction;
    Selectall1: TMenuItem;
    acDiagram_TableDisplayAllKeysIndexes: TAction;
    AllKeysandIndexes1: TMenuItem;
    acDiagram_TableCreateRelationshipParent: TAction;
    acDiagram_TableCreateRelationshipChild: TAction;
    acDiagram_CreateRelationship: TAction;
    CreateRelationship1: TMenuItem;
    AsParent1: TMenuItem;
    AsChild1: TMenuItem;
    acDiagram_RelationCaption: TAction;
    DisplayDescription1: TMenuItem;
    acDiagram_Find: TAction;
    acDiagram_Duplicate: TAction;
    acDiagram_Duplicate_Popup: TAction;
    DuplicateTable1: TMenuItem;
    acDiagram_Navigator: TAction;
    acDiagram_ZoomTo100: TAction;
    acDiagram_ZoomToFit: TAction;
    procedure acDiagram_RemoveUpdate(Sender: TObject);
    procedure acDiagram_RemoveExecute(Sender: TObject);
    procedure acDiagram_TableColorExecute(Sender: TObject);
    procedure acDiagram_TableDisplayAllFieldsUpdate(Sender: TObject);
    procedure acDiagram_TableDisplayAllFieldsExecute(Sender: TObject);
    procedure acDiagram_TableShowFieldTypesExecute(Sender: TObject);
    procedure acDiagram_TableShowFieldTypesUpdate(Sender: TObject);
    procedure acDiagram_BackgroundColorUpdate(Sender: TObject);
    procedure acDiagram_BackgroundColorExecute(Sender: TObject);
    procedure acDiagram_RelationLinkFieldsUpdate(Sender: TObject);
    procedure acDiagram_RelationLinkFieldsExecute(Sender: TObject);
    procedure acDiagram_RelationNameExecute(Sender: TObject);
    procedure acDiagram_RelationNameUpdate(Sender: TObject);
    procedure acDiagram_RelationStraightUpdate(Sender: TObject);
    procedure acDiagram_RelationStraightExecute(Sender: TObject);
    procedure acDiagram_TableAddRelatedUpdate(Sender: TObject);
    procedure acDiagram_TableAddRelatedExecute(Sender: TObject);
    procedure acDiagram_AddAllTablesExecute(Sender: TObject);
    procedure acDiagram_AddAllTablesUpdate(Sender: TObject);
    procedure acDiagram_EditObjectExecute(Sender: TObject);
    procedure acDiagram_EditObjectUpdate(Sender: TObject);
    procedure acDiagram_EditSeparatorExecute(Sender: TObject);
    procedure acDiagram_EditSeparatorUpdate(Sender: TObject);
    procedure acDiagram_TableDisplayExecute(Sender: TObject);
    procedure acDiagram_TableDisplayUpdate(Sender: TObject);
    procedure acDiagram_TableSeparatorExecute(Sender: TObject);
    procedure acDiagram_TableSeparatorUpdate(Sender: TObject);
    procedure acDiagram_ShowCaptionsExecute(Sender: TObject);
    procedure acDiagram_ShowCaptionsUpdate(Sender: TObject);
    procedure acDiagram_SelectAllExecute(Sender: TObject);
    procedure acDiagram_SelectAllUpdate(Sender: TObject);
    procedure acDiagram_CreateRelationshipExecute(Sender: TObject);
    procedure acDiagram_CreateRelationshipUpdate(Sender: TObject);
    procedure acDiagram_TableCreateRelationshipChildExecute(Sender: TObject);
    procedure acDiagram_TableCreateRelationshipChildUpdate(Sender: TObject);
    procedure acDiagram_TableCreateRelationshipParentExecute(Sender: TObject);
    procedure acDiagram_TableCreateRelationshipParentUpdate(Sender: TObject);
    procedure acDiagram_RelationCaptionUpdate(Sender: TObject);
    procedure acDiagram_RelationCaptionExecute(Sender: TObject);
    procedure acDiagram_FindUpdate(Sender: TObject);
    procedure acDiagram_FindExecute(Sender: TObject);
    procedure acDiagram_DuplicateUpdate(Sender: TObject);
    procedure acDiagram_DuplicateExecute(Sender: TObject);
    procedure acDiagram_Duplicate_PopupUpdate(Sender: TObject);
    procedure acDiagram_Duplicate_PopupExecute(Sender: TObject);
    procedure acDiagram_NavigatorUpdate(Sender: TObject);
    procedure acDiagram_NavigatorExecute(Sender: TObject);
    procedure acDiagram_ZoomTo100Update(Sender: TObject);
    procedure acDiagram_ZoomTo100Execute(Sender: TObject);
    procedure acDiagram_ZoomToFitUpdate(Sender: TObject);
    procedure acDiagram_ZoomToFitExecute(Sender: TObject);
  private
    FDMProjectForm: TDMProjectForm;
    function GetCurrentProject: TfmProject;
    function GetCurrentDiagram: TDiagramClass;
    property CurrentDiagram: TDiagramClass read GetCurrentDiagram;
    procedure CreateRelationship(AParent, AChild: TGDAOTable);
  public
    {Perform a set font name operation. Changes all selected blocks to the specified font name}
    procedure SelectObjectFontName(AName: string);
    {Retrieves the current font name by the selected blocks. If more than one block is
     selected with different font names, then retrieve the first one.
     If not block is selected, return empty string}
    function GetSelectedObjectFontName: string;

    {Same as fontname, except that getselectedobjectfontsize returns 0 if no block selected}
    procedure SelectObjectFontSize(ASize: integer);
    function GetSelectedObjectFontSize: integer;

    procedure SelectShapeColor(AColor: TColor);
    procedure SelectTextColor(AColor: TColor);
    procedure SelectOutlineColor(AColor: TColor);


    property CurrentProject: TfmProject read GetCurrentProject;
    property DMProjectForm: TDMProjectForm read FDMProjectForm write FDMProjectForm;
  end;

implementation

uses
  uTableDiagramBlock;

{$R *.dfm}

procedure TdmDiagramOptions.acDiagram_AddAllTablesExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
    CurrentDiagram.AddAllTables;
end;

procedure TdmDiagramOptions.acDiagram_AddAllTablesUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrentDiagram <> nil;
end;

procedure TdmDiagramOptions.acDiagram_BackgroundColorExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
    CurrentDiagram.ChangeDiagramColor;
end;

procedure TdmDiagramOptions.acDiagram_BackgroundColorUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrentDiagram <> nil;
end;

procedure TdmDiagramOptions.acDiagram_CreateRelationshipExecute(
  Sender: TObject);
begin
//
end;

procedure TdmDiagramOptions.acDiagram_CreateRelationshipUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil)
    and (CurrentDiagram.SelectedBlockCount = 1)
    and (CurrentProject <> nil);
end;

procedure TdmDiagramOptions.acDiagram_DuplicateExecute(Sender: TObject);
var
  NewTable: TGDAOTable;
  NewBlock: TTableDiagramBlock;
begin
  if (CurrentDiagram <> nil) and (CurrentDiagram.FirstSelectedTable <> nil) and
    (CurrentProject <> nil) then
  begin
    NewTable := CurrentProject.DuplicateTableDialog(CurrentDiagram.FirstSelectedTable.Table);
    if NewTable <> nil then
    begin
      NewBlock := CurrentDiagram.DuplicateTableBlock(CurrentDiagram.FirstSelectedTable, NewTable);
      if NewBlock <> nil then
      begin
        CurrentDiagram.UnselectAll;
        NewBlock.MakeVisible;
        NewBlock.Selected := True;
        CurrentDiagram.RefreshDisplay;
      end;
    end;
  end;
end;

procedure TdmDiagramOptions.acDiagram_DuplicateUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil)
    and (CurrentDiagram.SelectedBlockCount = 1)
    and (CurrentProject <> nil);
end;

procedure TdmDiagramOptions.acDiagram_Duplicate_PopupExecute(Sender: TObject);
begin
  acDiagram_DuplicateExecute(Sender);
end;

procedure TdmDiagramOptions.acDiagram_Duplicate_PopupUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil)
    and (CurrentDiagram.SelectedBlockCount = 1)
    and (CurrentProject <> nil);
  TAction(Sender).Visible := TAction(Sender).Enabled;
end;

procedure TdmDiagramOptions.acDiagram_EditObjectExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
    CurrentDiagram.EditObject(CurrentDiagram.Selecteds[0]);
end;

procedure TdmDiagramOptions.acDiagram_EditObjectUpdate(Sender: TObject);
begin
  acDiagram_EditObject.Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.SelectedCount = 1);
  acDiagram_EditObject.Visible := acDiagram_EditObject.Enabled;
end;

procedure TdmDiagramOptions.acDiagram_EditSeparatorExecute(Sender: TObject);
begin
// Do not remove this line
end;

procedure TdmDiagramOptions.acDiagram_EditSeparatorUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := (CurrentDiagram <> nil)
    and (CurrentDiagram.SelectedCount = 1);
end;

procedure TdmDiagramOptions.acDiagram_FindExecute(Sender: TObject);
begin
  if (CurrentDiagram <> nil) and (CurrentDiagram.SearchPanel <> nil) then
    CurrentDiagram.SearchPanel.Showing := not CurrentDiagram.SearchPanel.Showing;
end;

procedure TdmDiagramOptions.acDiagram_FindUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil) and (CurrentDiagram.SearchPanel <> nil);
  TAction(Sender).Checked := TAction(Sender).Enabled and CurrentDiagram.SearchPanel.Showing;
end;

procedure TdmDiagramOptions.acDiagram_NavigatorExecute(Sender: TObject);
begin
  if (CurrentDiagram <> nil) and (CurrentProject <> nil) then
    CurrentProject.MustShowNavigator := not CurrentProject.MustShowNavigator;
end;

procedure TdmDiagramOptions.acDiagram_NavigatorUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil) and (CurrentProject <> nil);
  TAction(Sender).Checked := TAction(Sender).Enabled and CurrentProject.MustShowNavigator;
end;

procedure TdmDiagramOptions.acDiagram_RelationCaptionExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
  begin
    CurrentDiagram.DisplayRelationshipCaptions := not CurrentDiagram.DisplayRelationshipCaptions;
    CurrentDiagram.RefreshDisplay;
    CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.acDiagram_RelationCaptionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil);
  TAction(Sender).Checked := (CurrentDiagram <> nil) and CurrentDiagram.DisplayRelationshipCaptions;
end;

procedure TdmDiagramOptions.acDiagram_RelationLinkFieldsExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
  begin
    CurrentDiagram.LinkRelationshipsToFields := not CurrentDiagram.LinkRelationshipsToFields;
    CurrentDiagram.RefreshDisplay;
    CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.acDiagram_RelationLinkFieldsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil);
  TAction(Sender).Checked := (CurrentDiagram <> nil) and CurrentDiagram.LinkRelationshipsToFields;
end;

procedure TdmDiagramOptions.acDiagram_RelationNameExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
  begin
    CurrentDiagram.DisplayRelationshipNames := not CurrentDiagram.DisplayRelationshipNames;
    CurrentDiagram.RefreshDisplay;
    CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.acDiagram_RelationNameUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil);
  TAction(Sender).Checked := (CurrentDiagram <> nil) and CurrentDiagram.DisplayRelationshipNames;
end;

procedure TdmDiagramOptions.acDiagram_RelationStraightExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
  begin
    CurrentDiagram.StraightRelationshipLines := not CurrentDiagram.StraightRelationshipLines;
    CurrentDiagram.RefreshDisplay;
    CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.acDiagram_RelationStraightUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil);
  TAction(Sender).Checked := (CurrentDiagram <> nil) and CurrentDiagram.StraightRelationshipLines;
end;

procedure TdmDiagramOptions.acDiagram_RemoveExecute(Sender: TObject);
begin
  if CurrentProject <> nil then
    CurrentProject.RemoveDeleteFromDiagram;
end;

procedure TdmDiagramOptions.acDiagram_RemoveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.SelectedCount > 0);
  TAction(Sender).Visible := TAction(Sender).Enabled;
end;

procedure TdmDiagramOptions.acDiagram_SelectAllExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
    CurrentDiagram.SelectAll;
end;

procedure TdmDiagramOptions.acDiagram_SelectAllUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrentDiagram <> nil;
end;

procedure TdmDiagramOptions.acDiagram_ShowCaptionsExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
  begin
    CurrentDiagram.ShowCaptions := not CurrentDiagram.ShowCaptions;
    CurrentDiagram.RefreshDisplay;
    CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.acDiagram_ShowCaptionsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrentDiagram <> nil;
  TAction(Sender).Checked := (CurrentDiagram <> nil) and CurrentDiagram.ShowCaptions;
end;

procedure TdmDiagramOptions.acDiagram_TableAddRelatedExecute(Sender: TObject);
var
  rel: TGDAORelationship;
  tbrel: TGDAOTable;
  dictionary: TGDD;
  r: integer;
begin
  if CurrentDiagram <> nil then
  begin
    if (CurrentDiagram.FirstSelectedTable <> nil) and
      (CurrentDiagram.FirstSelectedTable.Table <> nil) then
    begin
      dictionary := CurrentDiagram.FirstSelectedTable.Table.OwnerDatabase;
      for r := 0 to dictionary.Relationships.Count-1 do
      begin
        rel := dictionary.Relationships[r];
        if rel.ParentTable = CurrentDiagram.FirstSelectedTable.Table then
          tbrel := rel.ChildTable
        else if rel.ChildTable = CurrentDiagram.FirstSelectedTable.Table then
          tbrel := rel.ParentTable
        else
          tbrel := nil;
        if Assigned(tbrel) and (CurrentDiagram.FindTableBlock(tbrel) = nil) and tbrel.Visible then
          CurrentDiagram.AddTableBlock(tbrel);
      end;
    end;
  end;
end;

procedure TdmDiagramOptions.acDiagram_TableAddRelatedUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil);
  TAction(Sender).Visible := TAction(Sender).Enabled;
end;

procedure TdmDiagramOptions.acDiagram_TableColorExecute(Sender: TObject);
begin
  if CurrentDiagram <> nil then
    CurrentDiagram.ChangeBlocksColor;
end;

procedure TdmDiagramOptions.acDiagram_TableCreateRelationshipChildExecute(
  Sender: TObject);
begin
  if (CurrentDiagram <> nil) and (CurrentDiagram.FirstSelectedTable <> nil) then
    CreateRelationship(nil, CurrentDiagram.FirstSelectedTable.Table);
end;

procedure TdmDiagramOptions.acDiagram_TableCreateRelationshipChildUpdate(
  Sender: TObject);
begin
  TAction(Sender).Visible := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil)
    and (CurrentDiagram.SelectedBlockCount = 1)
    and (CurrentProject <> nil);
end;

procedure TdmDiagramOptions.acDiagram_TableCreateRelationshipParentExecute(
  Sender: TObject);
begin
  if (CurrentDiagram <> nil) and (CurrentDiagram.FirstSelectedTable <> nil) then
    CreateRelationship(CurrentDiagram.FirstSelectedTable.Table, nil);
end;

procedure TdmDiagramOptions.acDiagram_TableCreateRelationshipParentUpdate(
  Sender: TObject);
begin
  TAction(Sender).Visible := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil)
    and (CurrentDiagram.SelectedBlockCount = 1)
    and (Currentproject <> nil);
end;

procedure TdmDiagramOptions.acDiagram_TableDisplayAllFieldsExecute(Sender: TObject);
var
  c: Integer;
begin
  if CurrentDiagram <> nil then
  begin
    for c := 0 to CurrentDiagram.SelectedCount - 1 do
      if CurrentDiagram.Selecteds[c] is TTableDiagramBlock then
        TTableDiagramBlock(CurrentDiagram.Selecteds[c]).DisplayType :=
          TTableDisplayType(TAction(Sender).Tag);
    CurrentDiagram.RefreshDisplay;
  end;
end;

procedure TdmDiagramOptions.acDiagram_TableDisplayAllFieldsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil);
  TAction(Sender).Visible := TAction(Sender).Enabled;
  TAction(Sender).Checked :=
    (CurrentDiagram <> nil) and (CurrentDiagram.FirstSelectedTable <> nil) and
    (TAction(Sender).Tag = ord(CurrentDiagram.FirstSelectedTable.DisplayType));
end;

procedure TdmDiagramOptions.acDiagram_TableDisplayExecute(Sender: TObject);
begin
  // Do not remove this line
end;

procedure TdmDiagramOptions.acDiagram_TableDisplayUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil);
end;

procedure TdmDiagramOptions.acDiagram_TableSeparatorExecute(Sender: TObject);
begin
  // Do not remove this line
end;

procedure TdmDiagramOptions.acDiagram_TableSeparatorUpdate(Sender: TObject);
begin
  TAction(Sender).Visible := (CurrentDiagram <> nil) and
    (CurrentDiagram.FirstSelectedTable <> nil);
end;

procedure TdmDiagramOptions.acDiagram_TableShowFieldTypesExecute(Sender: TObject);
var
  c: integer;
begin
  if CurrentDiagram <> nil then
  begin
    TAction(Sender).Checked := not TAction(Sender).Checked;
    for c := 0 to CurrentDiagram.SelectedCount - 1 do
      if CurrentDiagram.Selecteds[c] is TTableDiagramBlock then
        TTableDiagramBlock(CurrentDiagram.Selecteds[c]).ShowFieldTypes := TAction(Sender).Checked;
    CurrentDiagram.RefreshDisplay;
  end;
end;

procedure TdmDiagramOptions.acDiagram_TableShowFieldTypesUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil);
  TAction(Sender).Checked := (CurrentDiagram <> nil)
    and (CurrentDiagram.FirstSelectedTable <> nil)
    and CurrentDiagram.FirstSelectedTable.ShowFieldTypes;

  TAction(Sender).Visible := TAction(Sender).Enabled;
end;

procedure TdmDiagramOptions.acDiagram_ZoomTo100Execute(Sender: TObject);
begin
  if (CurrentDiagram <> nil) then
    CurrentDiagram.Zoom := 100;
end;

procedure TdmDiagramOptions.acDiagram_ZoomTo100Update(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil);
end;

procedure TdmDiagramOptions.acDiagram_ZoomToFitExecute(Sender: TObject);
begin
  if (CurrentDiagram <> nil) then
    CurrentDiagram.ZoomMoveToFit(20);
end;

procedure TdmDiagramOptions.acDiagram_ZoomToFitUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (CurrentDiagram <> nil);
end;

procedure TdmDiagramOptions.CreateRelationship(AParent, AChild: TGDAOTable);
begin
  if (CurrentProject <> nil) then
    CurrentProject.NewRelationshipDialog(AParent, AChild);
end;

function TdmDiagramOptions.GetCurrentDiagram: TDiagramClass;
begin
  if (CurrentProject <> nil) then
    result := CurrentProject.CurrentDiagramFrame
  else
    result := nil;
end;

function TdmDiagramOptions.GetCurrentProject: TfmProject;
begin
  if FDMProjectForm <> nil then
    result := FDMProjectForm.Project
  else
    result := nil;
end;

function TdmDiagramOptions.GetSelectedObjectFontName: string;
begin
  result := '';
  if (CurrentDiagram <> nil) and (CurrentDiagram.SelectedCount > 0) then
  begin
    result := CurrentDiagram.Selecteds[0].Font.Name;
  end;
end;

function TdmDiagramOptions.GetSelectedObjectFontSize: integer;
begin
  result := 0;
  if (CurrentDiagram <> nil) and (CurrentDiagram.SelectedCount > 0) then
  begin
    result := CurrentDiagram.Selecteds[0].Font.Size;
  end;
end;

procedure TdmDiagramOptions.SelectShapeColor(AColor: TColor);
var
  c: integer;
  AModified: boolean;
begin
  if (CurrentDiagram <> nil) then
  begin
    AModified := false;
    for c := 0 to CurrentDiagram.BlockCount - 1 do
      if CurrentDiagram.Blocks[c].Selected then
      begin
        CurrentDiagram.Blocks[c].Color := AColor;
        CurrentDiagram.Blocks[c].SelColor := AColor;
        AModified := true;
      end;
    if AModified then
      CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.SelectTextColor(AColor: TColor);
var
  c: integer;
  AModified: boolean;
begin
  if (CurrentDiagram <> nil) then
  begin
    AModified := false;
    for c := 0 to CurrentDiagram.BlockCount - 1 do
      if CurrentDiagram.Blocks[c].Selected then
      begin
        CurrentDiagram.Blocks[c].Font.Color := AColor;
        AModified := true;
      end;
    if AModified then
      CurrentDiagram.Modified;
  end;
end;

procedure TdmDiagramOptions.SelectObjectFontName(AName: string);
var
  c: integer;
begin
  if (CurrentDiagram <> nil) then
  begin
    for c := 0 to CurrentDiagram.SelectedCount - 1 do
      CurrentDiagram.Selecteds[c].Font.Name := AName;
    if CurrentDiagram.SelectedCount > 0 then
      CurrentDiagram.Modified;
    CurrentDiagram.RefreshDisplay;
  end;
end;

procedure TdmDiagramOptions.SelectObjectFontSize(ASize: integer);
var
  c: integer;
begin
  if (CurrentDiagram <> nil) then
  begin
    for c := 0 to CurrentDiagram.SelectedCount - 1 do
      CurrentDiagram.Selecteds[c].Font.Size := ASize;
    if CurrentDiagram.SelectedCount > 0 then
      CurrentDiagram.Modified;
    CurrentDiagram.RefreshDisplay;
  end;
end;

procedure TdmDiagramOptions.SelectOutlineColor(AColor: TColor);
var
  c: integer;
  AModified: boolean;
begin
  if (CurrentDiagram <> nil) then
  begin
    AModified := false;
    for c := 0 to CurrentDiagram.BlockCount - 1 do
      if CurrentDiagram.Blocks[c].Selected then
      begin
        CurrentDiagram.Blocks[c].Pen.Color := AColor;
        AModified := true;
      end;
    if AModified then
    begin
      CurrentDiagram.Modified;
      CurrentDiagram.RefreshDisplay;
    end;
  end;
end;

end.

