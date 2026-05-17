unit fRelationshipDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fRelationshipEditor, StdCtrls, ExtCtrls, uGDAO, uAppUtils, UITypes;

type
  TfmRelationshipDialog = class(TForm)
    RelationshipEditor: TfmRelationshipEditor;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowRelationshipDialog(ARelationship: TGDAORelationship): boolean;

implementation

{$R *.dfm}

function ShowRelationshipDialog(ARelationship: TGDAORelationship): boolean;
begin
  with TfmRelationshipDialog.Create(Application) do
  try
    RelationshipEditor.Inserting := True;
    RelationshipEditor.SelectedRelationship := ARelationship;
    if ARelationship.ReadOnly then
    begin
      MessageDlg('You cannot create a relationship between two read only tables.', mtWarning, [mbOk], 0);
      result := False;
    end
    else
      result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TfmRelationshipDialog.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmRelationshipDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

end.

