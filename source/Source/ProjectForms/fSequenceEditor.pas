unit fSequenceEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvEdit, advlued,
  uGDAO, fObjectEditor;

type
  TfmSequenceEditor = class(TForm, IDMObjectEditor)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edStartWith: TAdvLUEdit;
    procedure FormCreate(Sender: TObject);
  private
    FOnModified: TNotifyEvent;
    FSelectedObject: TGDAOObject;
    FOnUpdateObjectName: TGDAOObjectEvent;
    FLoading: integer;
    function SelectedObject: TGDAOObject;
    procedure Modified;
    procedure LoadProperty(Sender: TObject);
    procedure SaveTheProperty(Sender: TObject);
    procedure LoadSequenceProperties;
    procedure MakeFormReadOnly;
    function EnableObjectControl(AControl: TWinControl): boolean;
  public
    procedure SetOnModified(AEvent: TNotifyEvent);
    procedure SetOnUpdateObjectName(AEvent: TGDAOObjectEvent);
    procedure SetSelectedObject(AObject: TGDAOObject);
  end;

implementation

uses
  uControlUtils;

{$R *.dfm}

{ TfmSequenceEditor }

function TfmSequenceEditor.EnableObjectControl(AControl: TWinControl): boolean;
begin
  result := SelectedObject <> nil;
  EnableControl(AControl, result);
  if result and SelectedObject.ReadOnly then
    AControl.Enabled := False;
end;

procedure TfmSequenceEditor.FormCreate(Sender: TObject);
begin
  ParentColor := true;
  edName.OnChange := SaveTheProperty;
  edStartWith.OnChange := SaveTheProperty;
end;

procedure TfmSequenceEditor.LoadProperty(Sender: TObject);
begin
  Inc(FLoading);
  try
    if (Sender = edName) then
    begin
      if EnableObjectControl(edName) then
        edName.Text := SelectedObject.ObjectName
      else
        edName.Clear;
    end
    else
    if (Sender = edStartWith) then
    begin
      if EnableObjectControl(edStartWith) then
      begin
        if StrToIntDef(edStartWith.Text, 0) <> SelectedObject.ReadProp(SProp_SequenceSeed) then
          edStartWith.Text := IntToStr(SelectedObject.ReadProp(SProp_SequenceSeed));
      end
      else
        edStartWith.Clear;
    end;
  finally
    Dec(FLoading);
  end;
end;

procedure TfmSequenceEditor.LoadSequenceProperties;
begin
  LoadProperty(edName);
  LoadProperty(edStartWith);
end;

procedure TfmSequenceEditor.MakeFormReadOnly;
var
  i: integer;
begin
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TEdit then
      Controls[i].Enabled := False;
end;

procedure TfmSequenceEditor.Modified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

procedure TfmSequenceEditor.SaveTheProperty(Sender: TObject);
begin
  if FLoading = 0 then
  begin
    if (Sender = edName) and (SelectedObject <> nil) then
    begin
      if SelectedObject.ObjectName <> edName.Text then
        Modified;
      SelectedObject.ObjectName := edName.Text;
      if Assigned(FOnUpdateObjectName) then
        FOnUpdateObjectName(SelectedObject);
    end
    else
    if (Sender = edStartWith) then
    begin
      if (SelectedObject <> nil) and
        (SelectedObject.ReadProp(SProp_SequenceSeed) <> StrToIntDef(edStartWith.Text, 0)) then
      begin
        SelectedObject.WriteProp(SProp_SequenceSeed, StrToIntDef(edStartWith.Text, 0));
        Modified;
      end;
    end;
    LoadProperty(Sender);
  end;
end;

function TfmSequenceEditor.SelectedObject: TGDAOObject;
begin
  result := FSelectedObject;
end;

procedure TfmSequenceEditor.SetOnModified(AEvent: TNotifyEvent);
begin
  FOnModified := AEvent;
end;

procedure TfmSequenceEditor.SetOnUpdateObjectName(AEvent: TGDAOObjectEvent);
begin
  FOnUpdateObjectName := AEvent;
end;

procedure TfmSequenceEditor.SetSelectedObject(AObject: TGDAOObject);
begin
  FSelectedObject := AObject;
  LoadSequenceProperties;
  if FSelectedObject.ReadOnly then
    MakeFormReadOnly;
end;

end.

