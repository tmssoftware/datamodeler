unit fUserConnections;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls,  ImgList, ComCtrls,
  ActnList, dgConsts, dgDBTypes, UITypes, System.ImageList,
  System.Actions;

type
  TfmUserConnections = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    tvTree: TTreeView;
    ActionList1: TActionList;
    acRemove: TAction;
    acEdit: TAction;
    ImageList1: TImageList;
    acAdd: TAction;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure acRemoveUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acRemoveExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure tvTreeDblClick(Sender: TObject);
    procedure tvTreeEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure tvTreeEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acAddExecute(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure LoadConnectionsTree;
  end;

implementation

uses
  uConnectionsFile, fImportWizard, uSystemClass, uDBProperties, uAppUtils;

{$R *.dfm}

procedure TfmUserConnections.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  LoadConnectionsTree;
end;

procedure TfmUserConnections.LoadConnectionsTree;
var i,j : Integer;
    p : TTreeNode;
begin
  tvTree.Items.Clear;
  tvTree.Items.BeginUpdate;
  try
    for i := 0 to DatabaseTypes.Count-1 do
    begin
      p := tvTree.Items.Add(nil, DatabaseTypes[i].DisplayName);
      p.Data := DatabaseTypes[i];
      p.ImageIndex := 0;
      p.SelectedIndex := 0;
      with SystemConfig.UserConnections.List do
      begin
        for j := 0 to Count-1 do
          if Items[j].ConnDBType = DatabaseTypes[i] then
            with tvTRee.Items.AddChild(p, Items[j].Name) do
            begin
              Data := Items[j];
              ImageIndex := 1;
              SelectedIndex := 1;
            end;
      end;
    end;
  finally
    tvTree.Items.EndUpdate;
  end;
end;

procedure TfmUserConnections.acRemoveUpdate(Sender: TObject);
begin
  acRemove.Enabled := (tvTree.Selected <> nil) and (tvTree.Selected.Level > 0);
end;

procedure TfmUserConnections.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TfmUserConnections.acEditUpdate(Sender: TObject);
begin
  acEdit.Enabled := (tvTree.Selected <> nil) and (tvTRee.Selected.Level > 0);
end;

procedure TfmUserConnections.acRemoveExecute(Sender: TObject);
begin
  if MessageDlg('Remove selected connection setting?', mtConfirmation, [mbYes, mbNo],0)=mrYes then
  begin
    SystemConfig.UserConnections.List.Delete( TConnectionSetting(tvTree.Selected.Data).Index );
    tvTree.Selected.Free;
    //LoadConnectionsTree;
  end;
end;

procedure TfmUserConnections.acEditExecute(Sender: TObject);
begin
  TConnectionSetting(tvTree.Selected.Data).EditSettingDlg;
end;

procedure TfmUserConnections.tvTreeDblClick(Sender: TObject);
begin
  if acEdit.Enabled then
    acEdit.Execute;
end;

procedure TfmUserConnections.tvTreeEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := ( Node.Level > 0 );
end;

procedure TfmUserConnections.tvTreeEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  if s > '' then
  begin
    TConnectionSetting(Node.Data).Name := s;
  end;
end;

procedure TfmUserConnections.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SystemConfig.SaveUserConnectionsFile;
end;

procedure TfmUserConnections.acAddExecute(Sender: TObject);

  function GetSelectedDBType: TDatabaseType;
  begin
    result := nil;
    if tvTree.Selected <> nil then
    begin
      if tvTree.Selected.Level = 0 then
        result := TDatabaseType(tvTree.Selected.Data)
      else
      if tvTree.Selected.Level = 1 then
        result := TDatabaseType(tvTree.Selected.Parent.Data);
    end;
  end;

begin
  with TfmImportWizard.Create(nil) do
  try
    if ExecuteAddConnection(GetSelectedDBType) then
      LoadConnectionsTree;
  finally
    Free;
  end;
end;

end.

