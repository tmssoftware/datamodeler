unit fTriggersEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, uGDAO, LangConst, UITypes,
  uListviewcleaner, AdvMemo, ImgList, Menus, AdvMenus, ActnList,
  AdvMenuStylers, AdvPanel, dgConsts, AdvmSQLS, AdvToolBtn, dgDBTypes;

type
  TfrTriggersEditor = class(TFrame)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    lvTriggers: TListView;
    Panel3: TPanel;
    popTriggers: TAdvPopupMenu;
    miAddTrigger: TMenuItem;
    miDeleteTrigger: TMenuItem;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    ScrollBox1: TScrollBox;
    AdvPanel6: TAdvPanel;
    Label3: TLabel;
    Label5: TLabel;
    edTriggerName: TEdit;
    edDescription: TEdit;
    AdvPanel2: TAdvPanel;
    rgTriggerType: TRadioGroup;
    AdvPanel1: TAdvPanel;
    Label4: TLabel;
    Label7: TLabel;
    mmImplementation: TAdvMemo;
    edOrder: TEdit;
    chEachRow: TCheckBox;
    AdvSQLMemoStyler1: TAdvSQLMemoStyler;
    Panel13: TPanel;
    Bevel4: TBevel;
    btAddTrigger: TAdvToolButton;
    btDeleteTrigger: TAdvToolButton;
    procedure lvTriggersChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure lvTriggersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edDescriptionChange(Sender: TObject);
    procedure mmImplementationChange(Sender: TObject);
    procedure lvTriggersEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure edOrderKeyPress(Sender: TObject; var Key: Char);
    procedure miAddTriggerClick(Sender: TObject);
    procedure edTriggerNameChange(Sender: TObject);
    procedure btDeleteTriggerClick(Sender: TObject);
    procedure miDeleteTriggerClick(Sender: TObject);
    procedure lvTriggersEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
  private
    FIsNewObject : Boolean;
    FInserting: boolean;
    FTriggerChanging: boolean;
    FTriggers: TGDAOTriggers;
    FEditingTrigger: TGDAOTrigger;
    FUpdateList: boolean;
    FChangeEvent: TNotifyEvent;
    FListing: boolean;
    FFixedDBType: TFixedDBType;
    function CanEdit: boolean;
    procedure NewTrigger(AName: string);
    procedure Modified;
    procedure ClearControls;
    procedure EnableControls(AEnabled: Boolean = true);
  public
    procedure InitiateAction; override;
    constructor Create(AOwner: TComponent); override;
    procedure ListTriggers(ATriggers: TGDAOTriggers; ChangeEvent: TNotifyEvent);
    procedure ClearTriggers;
    procedure DisableForm;
    procedure DeleteTrigger;
    procedure AddTrigger;
    property UpdateList: boolean read FUpdateList write FUpdateList;
    property FixedDBType: TFixedDBType read FFixedDBType write FFixedDBType;
  end;

implementation

uses
  uControlUtils, uSQLStyler;

{$R *.DFM}

procedure TfrTriggersEditor.lvTriggersChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
   if FListing or lvTriggers.IsEditing then exit;

   //Modified;
   FTriggerChanging:=true;
   if {(Change=ctState) and }assigned(lvTriggers.Selected) and
      (lvTriggers.Selected=Item) and assigned(Item.Data) then
   begin
      { enabling controls }
      EnableControls;

      FEditingTrigger := TGDAOTrigger(Item.Data);
      // trigger data
      with FEditingTrigger do
      begin                                
        edTriggerName.Text          := Name;
        edDescription.Text          := Description;
        mmImplementation.Lines.Text := FEditingTrigger.ImplementationCode;
      end;
   end
   else
   begin
      ClearControls;
      if not FInserting then
         FEditingTrigger:=nil;

      { disabling controls }
      EnableControls(false);
   end;
  FTriggerChanging:=false;
  if FIsNewObject then
    edTriggerName.Setfocus;
  FIsNewObject := false;
end;

procedure TfrTriggersEditor.lvTriggersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   FInserting:=false;
   with lvTriggers do
      if not IsEditing and Enabled then
         case Key of
            VK_F2: { edit }
               if assigned(Selected) and (Shift=[]) then
               begin
                  Selected.MakeVisible(false);
                  Selected.EditCaption;
               end;
            VK_F3, VK_INSERT: { insert }
               if Shift=[] then
               begin
                  AddTrigger;
               end;
            VK_F4, VK_DELETE: { delete }
               if assigned(Selected) and (Shift=[]) then
                DeleteTrigger;
         end;
end;

procedure TfrTriggersEditor.edDescriptionChange(Sender: TObject);
begin
   if CanEdit then
   begin
      FEditingTrigger.Description:=edDescription.Text;
      Modified;
   end;
end;

procedure TfrTriggersEditor.miDeleteTriggerClick(Sender: TObject);
begin
  DeleteTrigger;
end;

procedure TfrTriggersEditor.mmImplementationChange(Sender: TObject);
begin
   if CanEdit then
   begin
      FEditingTrigger.ImplementationCode:=mmImplementation.Lines.Text;
      Modified;
   end;
end;

procedure TfrTriggersEditor.lvTriggersEdited(Sender: TObject; Item: TListItem; var S: String);
begin
   if not assigned(Item.Data) then { end of insertion }
   begin
      FListing:=false;
      if s<>'' then
         NewTrigger(s)
      else
      begin
         lvTriggers.Items.Delete(Item.Index);
         ListViewCleaner.ListViewItemDeleted(Item);
      end;
   end
   else { end of edit }
   begin
      if s<>'' then
         TGDAOTrigger(Item.Data).Name:=s
      else
         s:=Item.Caption;
   end;
   Modified;
end;

procedure TfrTriggersEditor.lvTriggersEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;

procedure TfrTriggersEditor.edOrderKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(key, ['0'..'9',#8]) then
    key := #0;
end;

function TfrTriggersEditor.CanEdit: boolean;
begin
   result:=(not FTriggerChanging) and assigned(lvTriggers.Selected) and
      (not FListing) and assigned(lvTriggers.Selected.Data);
end;

procedure TfrTriggersEditor.NewTrigger(AName: string);
begin
   { creates the object for the new trigger }
   lvTriggers.Selected.Data:=FTriggers.Add;
   FEditingTrigger:=TGDAOTrigger(lvTriggers.Selected.Data);
   FEditingTrigger.Name:=AName;
   case FFixedDBType of
     fdbFirebird2, fdbFirebird3, fdbInterbase2017:
       FEditingTrigger.ImplementationCode := Format(
         'CREATE OR ALTER TRIGGER <%%%s%%> FOR <%%%s%%> ',
         [NativeIdName[niTriggerName], NativeIdName[niTableName]]);
   else
     FEditingTrigger.ImplementationCode := Format(
       'CREATE TRIGGER <%%%s%%> FOR <%%%s%%> ',
       [NativeIdName[niTriggerName], NativeIdName[niTableName]]);
   end;
   FInserting:=true;
end;

procedure TfrTriggersEditor.ListTriggers(ATriggers: TGDAOTriggers;
   ChangeEvent: TNotifyEvent);
var
  iTrigger: integer;
begin
   ImproveSQLMemoStyler(AdvSQLMemoStyler1);
   if FUpdateList then
   begin
      EnableControl(lvTriggers);

      FChangeEvent:=ChangeEvent;
      FTriggers:=ATriggers;
      if not assigned(FTriggers) then
         raise EGUIException.Create(SMissingTriggerCollection);
      { lists the triggers }
      FTriggerChanging:=true;
      FListing:=true;
      ClearTriggers;
      for iTrigger:=0 to FTriggers.Count-1 do
         with lvTriggers.Items.Add do
         begin
            Caption:=FTriggers[iTrigger].Name;
            Data:=FTriggers[iTrigger];
         end;
      FTriggerChanging:=false;
      FListing:=false;
      if lvTriggers.Items.Count>0 then
         lvTriggers.Items[0].Selected:=true;
      EnableControls(lvTriggers.Items.Count>0);
      //lvTriggers.SetFocus;
      FInserting:=false;
      FUpdateList:=false;
   end;
end;

constructor TfrTriggersEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csActionClient];
  FUpdateList:=true;
end;

procedure TfrTriggersEditor.Modified;
begin
   if assigned(FChangeEvent) then
      FChangeEvent(self);
end;

procedure TfrTriggersEditor.ClearTriggers;
begin
   lvTriggers.Items.Clear;
   ClearControls;
end;

procedure TfrTriggersEditor.ClearControls;
begin
   edDescription.Clear;
   edTriggerName.Clear;
   rgTriggerType.ItemIndex:=-1;
   edOrder.Clear;
   chEachRow.Checked:=false;
   mmImplementation.Clear;
end;

procedure TfrTriggersEditor.DisableForm;
begin
  EnableControl(lvTriggers, false);
  ClearTriggers;
  EnableControls(false);
end;

procedure TfrTriggersEditor.edTriggerNameChange(Sender: TObject);
begin
  if CanEdit then
  begin
    FEditingTrigger.Name         := edTriggerName.Text;
    FListing := true;
    lvTriggers.Selected.Caption  := edTriggerName.Text;
    FListing := false;
    Modified;
  end;
end;

procedure TfrTriggersEditor.EnableControls(AEnabled: Boolean);
begin
  EnableControl(edTriggerName, AEnabled);
  EnableControl(edDescription, AEnabled);
  EnableControl(rgTriggerType, AEnabled);
  EnableControl(edOrder, AEnabled);
  EnableControl(chEachRow, AEnabled);
  EnableControl(mmImplementation, AEnabled);
end;

procedure TfrTriggersEditor.InitiateAction;
var
  enable: boolean;
begin
  inherited;
  enable := Assigned(lvTriggers.Selected) and not FTriggers.OwnerTable.ReadOnly;
  miDeleteTrigger.Enabled := enable;
  btDeleteTrigger.Enabled := enable;
end;

procedure TfrTriggersEditor.AddTrigger;
var
  s: string;
begin
  with lvTriggers do
  begin
    FListing := true;
    Selected:=Items.Add;
    Selected.MakeVisible(false);
    s := FTriggers.GetNewTriggerName;
    NewTrigger(s);
    Modified;
    FListing := false;
    FIsNewObject := true;
    Selected.Caption := s;
  end;
end;

procedure TfrTriggersEditor.btDeleteTriggerClick(Sender: TObject);
begin
  DeleteTrigger;
end;

procedure TfrTriggersEditor.miAddTriggerClick(Sender: TObject);
begin
  AddTrigger;
end;

procedure TfrTriggersEditor.DeleteTrigger;
begin
  with lvTriggers do
  begin
    Selected.MakeVisible(false);
    if MessageDlg(Format(SConfirmTriggerDeletion,[Selected.Caption]),mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      Selected.Data:=nil;
      FTriggers.Delete(FTriggers.IndexOf(Selected.Caption));
      Items.Delete(Selected.Index);
      Modified;
    end;
  end;
end;

end.

