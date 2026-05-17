unit fObjectEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ImgList, ActnList, Menus, uGDAO,
  AdvMenuStylers, ComCtrls, AdvMenus, AdvMemo, AdvmSQLS, dgConsts;

type
  TGDAOObjectEvent = procedure (AObject: TGDAOObject) of object;

  IDMObjectEditor = interface
    procedure SetOnModified(AEvent: TNotifyEvent);
    procedure SetOnUpdateObjectName(AEvent: TGDAOObjectEvent);
    procedure SetSelectedObject(AObject: TGDAOObject);
  end;

  TfmObjectEditor = class(TFrame, IDMObjectEditor)
    pnObject: TPanel;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edDescription: TEdit;
    Label3: TLabel;
    mmCreateImplementation: TAdvMemo;
    Label4: TLabel;
    mmDropImplementation: TAdvMemo;
    AdvSQLMemoStyler1: TAdvSQLMemoStyler;
    procedure mmCreateImplementationChange(Sender: TObject);
    procedure mmDropImplementationChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
  private
    FOnModified: TNotifyEvent;
    FSelectedObject: TGDAOObject;
    FOnUpdateObjectName: TGDAOObjectEvent;
    FLoading: integer;
    procedure Modified;
    procedure OnObjectNameChanged(var Msg: TMessage); message WM_DM_OBJECTNAME_CHANGED;
    procedure MakeFormReadOnly;
  public
    procedure SetOnModified(AEvent: TNotifyEvent);
    procedure SetOnUpdateObjectName(AEvent: TGDAOObjectEvent);
    procedure SetSelectedObject(AObject: TGDAOObject);
  end;

implementation

uses
  uSQLStyler;

{$R *.dfm}

procedure TfmObjectEditor.edDescriptionChange(Sender: TObject);
begin
  if (FLoading = 0) then
  begin
    FSelectedObject.Description := edDescription.Text;
    Modified;
  end;
end;

procedure TfmObjectEditor.edNameChange(Sender: TObject);
begin
  if (FLoading = 0) then
  begin
    FSelectedObject.ObjectName := edName.Text;
    if Assigned(FOnUpdateObjectName) then
      FOnUpdateObjectName(FSelectedObject);
    Modified;
  end;
end;

procedure TfmObjectEditor.MakeFormReadOnly;
var
  i: integer;
begin
  for i := 0 to pnObject.ControlCount - 1 do
    if (pnObject.Controls[i] is TEdit) or (pnObject.Controls[i] is TAdvMemo) then
      pnObject.Controls[i].Enabled := False;
end;

procedure TfmObjectEditor.mmCreateImplementationChange(Sender: TObject);
begin
  if (FLoading = 0) then
  begin
    FSelectedObject.CreateImplementation := mmCreateImplementation.Lines.Text;
    Modified;
  end;
end;

procedure TfmObjectEditor.mmDropImplementationChange(Sender: TObject);
begin
  if (FLoading = 0) then
  begin
    FSelectedObject.DropImplementation := mmDropImplementation.Lines.Text;
    Modified;
  end;
end;

procedure TfmObjectEditor.Modified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

procedure TfmObjectEditor.OnObjectNameChanged(var Msg: TMessage);
begin
  if TGDAOObject(Msg.WParam) = FSelectedObject then
  begin
    Inc(FLoading);
    try
      edName.Text := FSelectedObject.ObjectName;
    finally
      Dec(FLoading);
    end;
  end;
end;

procedure TfmObjectEditor.SetOnModified(AEvent: TNotifyEvent);
begin
  FOnModified := AEvent;
end;

procedure TfmObjectEditor.SetOnUpdateObjectName(AEvent: TGDAOObjectEvent);
begin
  FOnUpdateObjectName := AEvent;
end;

procedure TfmObjectEditor.SetSelectedObject(AObject: TGDAOObject);
begin
  ImproveSQLMemoStyler(AdvSQLMemoStyler1);

  FSelectedObject := AObject;

  with FSelectedObject do
  begin
    Inc(FLoading);
    try
      edName.Text := ObjectName;
      edDescription.Text := Description;
      mmCreateImplementation.Lines.Text := CreateImplementation;
      mmDropImplementation.Lines.Text := DropImplementation;
      if ReadOnly then
        MakeFormReadOnly;
    finally
      Dec(FLoading);
    end;
  end;
end;

end.

