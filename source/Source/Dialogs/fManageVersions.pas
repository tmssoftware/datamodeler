unit fManageVersions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls,  ActnList, Menus,
  AdvMenus, AdvMenuStylers, ImgList, uAppMetaData, UITypes,
  System.Actions, System.ImageList;

type
  TfrmManageVersions = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    ImageList1: TImageList;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    ActionList1: TActionList;
    acdetails: TAction;
    Panel5: TPanel;
    lvVersions: TListView;
    BitBtn2: TBitBtn;
    btView: TButton;
    btRemove: TButton;
    acremove: TAction;
    btRollback: TButton;
    acRestore: TAction;
    procedure acdetailsUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvVersionsDblClick(Sender: TObject);
    procedure acdetailsExecute(Sender: TObject);
    procedure acremoveUpdate(Sender: TObject);
    procedure acremoveExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acRestoreUpdate(Sender: TObject);
    procedure acRestoreExecute(Sender: TObject);
  private
    FAMD: TAppMetaData;
    FModified: boolean;
    procedure ListVersions;
  public
    property AMD: TAppMetaData read FAMD write FAMD;
    property Modified: boolean read FModified;
  end;

implementation

uses
  fVersionDetails, uAppUtils;

{$R *.dfm}

procedure TfrmManageVersions.acdetailsUpdate(Sender: TObject);
begin
  acdetails.enabled := lvVersions.Selected <> nil;
end;

procedure TfrmManageVersions.acremoveExecute(Sender: TObject);
var
  remove: boolean;
begin
  remove := False;
  if TVersion(lvVersions.Selected.Data) = FAMD.VersionControl.GetLastVersion then
  begin
    MessageDlg('Cannot remove current version.', mtError, [mbOk], 0);
  end
  else
  begin
    if MessageDlg('Are you sure you want to delete selected version? This operation cannot be undone!', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      remove := True;
  end;

  if remove then
  begin
    FAMD.VersionControl.RemoveVersion(TVersion(lvVersions.Selected.Data));
    FModified := True;
    ListVersions;
  end;
end;

procedure TfrmManageVersions.acremoveUpdate(Sender: TObject);
begin
  acremove.enabled := (lvVersions.Selected <> nil) and
    (TVersion(lvVersions.Selected.Data) <> FAMD.VersionControl.GetLastVersion);
end;

procedure TfrmManageVersions.acRestoreExecute(Sender: TObject);
begin
  if MessageDlg('Restoring a version will overwrite current dictionary data in your project. '+
    'This operation cannot be undone! Are you sure you want to restore?', mtConfirmation,
    [mbYes, mbNo],0) <> mrYes then
    exit;

  FAMD.VersionControl.RestoreVersion(TVersion(lvVersions.Selected.Data));
  FModified := True;
  ListVersions;
  ModalResult := mrOk;
end;

procedure TfrmManageVersions.acRestoreUpdate(Sender: TObject);
begin
  acRestore.enabled := (lvVersions.Selected <> nil) and
    (TVersion(lvVersions.Selected.Data) <> FAMD.VersionControl.GetLastVersion);
end;

procedure TfrmManageVersions.ListVersions;
var i : Integer;
begin
  lvVersions.Items.BeginUpdate;
  try
    lvVersions.Items.Clear;
    with FAMD.VersionControl do
    begin
      for i := 0 to count-1 do
        with lvVersions.Items.Add do
        begin
          Data    := Items[i];
          Caption := inttostr(Items[i].VersionID);
          SubItems.Add(FormatDateTime('dd/mm/yyyy hh:nn', Items[i].DateTime));
          SubItems.Add(Items[i].AbsoluteFileName);

          if Items[i] = GetLastVersion then
            ImageIndex := 2
          else
            ImageIndex := 1;
        end;
    end;

  finally
    lvVersions.Items.EndUpdate;
  end;
end;

procedure TfrmManageVersions.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FModified := False;
end;

procedure TfrmManageVersions.FormShow(Sender: TObject);
begin
  ListVersions;
end;

procedure TfrmManageVersions.lvVersionsDblClick(Sender: TObject);
begin
  if acdetails.enabled then
    acdetails.Execute;
end;

procedure TfrmManageVersions.acdetailsExecute(Sender: TObject);
var
  Version: TVersion;
begin
  Version := TVersion(lvVersions.Selected.Data);
  with TfrmVersionDetails.Create(nil) do
  try
    SetVersion(Version);
    if ShowModal = mrOk then
      FModified := True;
  finally
    free;
  end;
end;

end.

