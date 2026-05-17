unit fGenerateScript;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uAppMetaData, Dialogs, StdCtrls, Buttons, ExtCtrls,  ImgList, ComCtrls,
  CheckLst, Menus, AdvMenus, ActnList, AdvEdit, AdvEdBtn, AdvFileNameEdit,
  fScriptViewer, AdvMenuStylers, Grids, BaseGrid, AdvGrid, AdvCGrid, DB, UITypes,
  dgConsts, uGDAO, dgDBStructurer, dgCompare, dgDBActions,
  System.Actions, System.ImageList;

type
  TfmGenerateScript = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    btClose: TBitBtn;                                                      
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tsProcess: TTabSheet;
    Panel7: TPanel;
    mLog: TMemo;
    popTables: TAdvPopupMenu;
    Selectall1: TMenuItem;
    Invertselection1: TMenuItem;
    ImageList1: TImageList;
    ActionList1: TActionList;
    acSelectAllTables: TAction;
    acGenerate: TAction;
    sdFile: TSaveDialog;
    TabSheet2: TTabSheet;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    edFile: TAdvEditBtn;
    rShow: TRadioButton;
    rSave: TRadioButton;
    Label1: TLabel;
    lbTables: TCheckListBox;
    Unselectall1: TMenuItem;
    tvOptions: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure acSelectAllTablesUpdate(Sender: TObject);
    procedure acSelectAllTablesExecute(Sender: TObject);
    procedure Invertselection1Click(Sender: TObject);
    procedure acGenerateExecute(Sender: TObject);
    procedure acGenerateUpdate(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure rShowClick(Sender: TObject);
    procedure edFileClickBtn(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Unselectall1Click(Sender: TObject);
    procedure tvOptionsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvOptionsEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
  private
    FMetaData: TAppMetaData;
    FStructurer: TDBStructurer;
    FFilter: TSQLScriptFilter;

    {Options node}
    FTablesNode: TTreeNode;
    FIndexesNode: TTreeNode;
    FTriggersNode: TTreeNode;
    FRelNode: TTreeNode;
    FDomainNode: TTreeNode;
    FCommentsNode: TTreeNode;
    FProcessing: boolean;
    procedure LoadOptionsTree;
    procedure UpdateTableList;
    function SomeTableSelected: Boolean;
    procedure StartProcess;
    procedure Log(AStr: String);

    procedure LoadProjectOptions;
    procedure SaveProjectOptions;
    procedure BuildSQLScriptFilter;
  public
    property MetaData : TAppMetaData read FMetaData write FMetaData;
  end;

implementation

uses
  uAppUtils;

{$R *.dfm}

procedure TfmGenerateScript.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FFilter := TSQLScriptFilter.Create;
end;

procedure TfmGenerateScript.FormDestroy(Sender: TObject);
begin
  if Assigned(FStructurer) then
    FreeAndNil(FStructurer);
  FFilter.Free;
end;

procedure TfmGenerateScript.FormShow(Sender: TObject);
begin
  UpdateTableList;
  LoadOptionsTree;

  {load project options after loading tree}
  LoadProjectOptions;

  if FStructurer = nil then
    FStructurer := TDBStructurer.Create(FMetaData.DataDictionary.DatabaseType);
  PageControl1.ActivePage := TabSheet1;

  tvOptions.FullExpand;
end;

procedure TfmGenerateScript.Unselectall1Click(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to lbTables.Items.Count-1 do
    lbTables.Checked[i] := false;
end;

procedure TfmGenerateScript.UpdateTableList;
var
  i : Integer;
begin
  with FMetaData.DataDictionary.Tables do
  begin
    for i := 0 to Count - 1 do
    begin
      lbTables.Items.AddObject(Items[i].TableName, TObject(Items[i]));
      lbTables.Checked[i] := true;
    end;
    lbTables.Sorted := True;
  end;
end;

procedure TfmGenerateScript.acSelectAllTablesUpdate(Sender: TObject);
var
  i : Integer;
  ASome: Boolean;
begin
  ASome := false;
  for i := 0 to lbTables.Items.Count - 1 do
    if not lbTables.Checked[i] then
    begin
      ASome := true;
      break;
    end;

  // setting the action state
  acSelectAllTables.Enabled := ASome;
end;

procedure TfmGenerateScript.acSelectAllTablesExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lbTables.Items.Count-1 do
    lbTables.Checked[i] := true;
end;

procedure TfmGenerateScript.Invertselection1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lbTables.Items.Count-1 do
    lbTables.Checked[i] := not lbTables.Checked[i];
end;

function TfmGenerateScript.SomeTableSelected: Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to lbTables.Items.Count - 1 do
    if lbTables.Checked[i] then
    begin
      Result := true;
      break;
    end;
end;

procedure TfmGenerateScript.acGenerateExecute(Sender: TObject);
begin
  if rSave.Checked and FileExists(edFile.Text) then
    if MessageDlg(
      Format('File "%s" already exists. Overwrite?', [ExtractFileName(edFile.Text)]), mtWarning,
      [mbYes, mbNo], 0) <> mrYes then
      Exit;  

  tsProcess.TabVisible := true;
  PageControl1.ActivePage := tsProcess;

  StartProcess;
  SaveProjectOptions;
end;

procedure TfmGenerateScript.acGenerateUpdate(Sender: TObject);
begin
  acGenerate.Enabled :=
    SomeTableSelected and not FProcessing and
    ((Trim(edFile.Text) > '') or not rSave.Checked);
end;

procedure TfmGenerateScript.btCloseClick(Sender: TObject);
begin
  Modalresult := mrCancel;
end;

procedure TfmGenerateScript.rShowClick(Sender: TObject);
begin
  edFile.Enabled := rSave.Checked;
end;

procedure TfmGenerateScript.edFileClickBtn(Sender: TObject);
begin
  if sdFile.Execute then
    edfile.Text := sdFile.FileName;
end;

procedure TfmGenerateScript.StartProcess;
var
  slScript: TStringList;
begin
  FProcessing := true;
  try
    {Avoid the possibility of double click in Generate Process button}
    acGenerateUpdate(nil);

    Log('Starting the script generation process...');
    //Log('Checking the project integrity...');

    Log('Creating script...');

    BuildSQLScriptFilter;

    slScript := TStringList.Create;
    try
      FStructurer.GenerateScriptSQLDataDictionary(FMetaData.DataDictionary, slScript, FFilter);

      if rShow.Checked then
        TScriptViewer.ShowSql(slScript.Text)
      else
      begin
        ForceDirectories(ExtractFilePath(edFile.Text));
        slScript.SaveToFile(edFile.Text);
      end;
    finally
      slScript.Free;
    end;

    Log('Process completed');
    btClose.SetFocus;
  finally
    FProcessing := false;
  end;
end;

procedure TfmGenerateScript.tvOptionsEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;

procedure TfmGenerateScript.tvOptionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HT: THitTests;
  Node: TTreeNode;
begin
  HT := tvOptions.GetHitTestInfoAt(X, Y);
  Node := tvOptions.GetNodeAt(X, Y);
  if (Node <> nil) and (htOnIcon in HT) then
  begin
    Node.ImageIndex := 1 - Node.ImageIndex;
    Node.SelectedIndex := Node.ImageIndex;
  end;
end;

procedure TfmGenerateScript.Log(AStr: String);
begin
  mLog.Lines.Add( Format('%s - %s', [FormatDateTime('hh:nn:ss', time), AStr]) );
end;

procedure TfmGenerateScript.BuildSQLScriptFilter;
var
  i: integer;
begin
  {Update the list of objects}
  if FTablesNode.ImageIndex <> 0 then
    FFilter.Items := FFilter.Items + [fiTable]
  else
    FFilter.Items := FFilter.Items - [fiTable];

  if FIndexesNode.ImageIndex <> 0 then
    FFilter.Items := FFilter.Items + [fiIndex]
  else
    FFilter.Items := FFilter.Items - [fiIndex];

  if FRelNode.ImageIndex <> 0 then
    FFilter.Items := FFilter.Items + [fiRelationship]
  else
    FFilter.Items := FFilter.Items - [fiRelationship];

  if FDomainNode.ImageIndex <> 0 then
    FFilter.Items := FFilter.Items + [fiDomain]
  else
    FFilter.Items := FFilter.Items - [fiDomain];

  if FTriggersNode.ImageIndex <> 0 then
    FFilter.Items := FFilter.Items + [fiTrigger]
  else
    FFilter.Items := FFilter.Items - [fiTrigger];

  if (FCommentsNode <> nil) and (FCommentsNode.ImageIndex <> 0) then
    FFilter.Items := FFilter.Items + [fiComments]
  else
    FFilter.Items := FFilter.Items - [fiComments];

  {Update the list of categories}
  FFilter.Items := FFilter.Items + [fiObject];
  FFilter.Categories := [];
  for i := 0 to tvOptions.Items.Count - 1 do
    if (integer(tvOptions.Items[i].Data) > 0) and (tvOptions.Items[i].ImageIndex <> 0) then
      FFilter.Categories := FFilter.Categories + [TGDAOCategoryType(integer(tvOptions.Items[i].Data))];

  {Update the list of tables}
  FFilter.ExcludedTables.Clear;
  for i := 0 to lbTables.Items.Count-1 do
    if not lbTables.Checked[i] then
      FFilter.ExcludedTables.Add(lbTables.Items[i]);
end;

procedure TfmGenerateScript.LoadOptionsTree;
var
  c: integer;
begin
  FTablesNode := tvOptions.Items.Add(nil, 'Tables');
  FIndexesNode := tvOptions.Items.AddChild(FTablesNode, 'Indexes');
  FTriggersNode := tvOptions.Items.AddChild(FTablesNode, 'Triggers');
  FRelNode := tvOptions.Items.Add(nil, 'Relationships');
  FDomainNode := tvOptions.Items.Add(nil, 'Domains');

  {check all items}
  FTablesNode.ImageIndex := 1;
  FIndexesNode.ImageIndex := 1;
  FTriggersNode.ImageIndex := 1;
  FRelNode.ImageIndex := 1;
  FDomainNode.ImageIndex := 1;

  for c := 0 to MetaData.DataDictionary.Categories.Count - 1 do
    with tvOptions.Items.Add(nil, MetaData.DataDictionary.Categories[c].CategoryNameP) do
    begin
      ImageIndex := 1; //checked
      Data := Pointer(Ord(MetaData.DataDictionary.Categories[c].CategoryType));
    end;

  if MetaData.DataDictionary.DatabaseType.ScriptObjectComments then
  begin
    FCommentsNode := tvOptions.Items.Add(nil, 'Object comments');
    FCommentsNode.ImageIndex := 1;
  end;

  {Set selected index equal to image index}
  for c := 0 to tvOptions.Items.Count - 1 do
    tvOptions.Items[c].SelectedIndex := tvOptions.Items[c].ImageIndex;
end;

procedure TfmGenerateScript.LoadProjectOptions;
var i: integer;

  function oget(key: string): string;
  begin
    result := FMetaData.UserOptions.Values[Self.Name + '_' + key];
  end;

begin
  { remember last options to generate database script }
  edFile.Text := oget('File');
  rShow.Checked := edFile.Text='';
  rSave.Checked := not rShow.Checked;
  for i := 0 to tvOptions.Items.Count - 1 do
    tvOptions.Items[i].ImageIndex := StrToIntDef(oget(tvOptions.Items[i].Text), 1);
  for i := 0 to lbTables.Items.Count - 1 do
    lbTables.Checked[i] := oget('tab_' + lbTables.Items[i]) <> 'false';
end;

procedure TfmGenerateScript.SaveProjectOptions;
var
  i: integer;
  changed: boolean;

  procedure oset(key, val: string; del: boolean=False);
  var
    i: integer;
  begin
    with FMetaData.UserOptions do
      if del then
      begin
        i := IndexOfName(Self.Name + '_' + key);
        if i >= 0 then
        begin
          Delete(i);
          changed := true;
        end;
      end
      else
      begin
        if Values[Self.Name + '_' + key] <> val then
        begin
          Values[Self.Name + '_' + key] := val;
          changed := true;
        end;
      end;
  end;

begin
  changed := false;
  oset('File', edFile.Text, rShow.Checked);
  for i := 0 to tvOptions.Items.Count - 1 do
    oset(tvOptions.Items[i].Text, IntToStr(tvOptions.Items[i].ImageIndex));
  for i := 0 to lbTables.Count - 1 do
    oset('tab_' + lbTables.Items[i], 'false', lbTables.Checked[i]);
  if changed then
    FMetaData.DesignTimeChange(Self);
end;

end.

