unit fNewProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList, dgConsts, dgDBTypes,
  System.Actions;

type
  TfmNewProject = class(TForm)
    Panel3: TPanel;
    Shape1: TShape;
    Shader1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    btOk: TBitBtn;
    ActionList1: TActionList;
    acOkNewProject: TAction;
    Label17: TLabel;
    cbDBType: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure acOkNewProjectUpdate(Sender: TObject);
    procedure acOkNewProjectExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDBType : TDatabaseType;
  public
    property DBType: TDatabaseType read FDBType write FDBType;
  end;

implementation

uses
  uDBProperties, uAppUtils;

{$R *.dfm}

procedure TfmNewProject.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmNewProject.FormShow(Sender: TObject);
begin
   TDBProperties.FillDatabaseTypes(cbDBType.Items, '(choose target database)');
   cbDBType.ItemIndex := 0;
end;

procedure TfmNewProject.acOkNewProjectUpdate(Sender: TObject);
begin
  acOkNewProject.Enabled := (cbDBType.ItemIndex > 0);
end;

procedure TfmNewProject.acOkNewProjectExecute(Sender: TObject);
begin
  FDBType  := TDatabaseType(cbDBType.items.Objects[cbDBType.ItemIndex]);
  ModalResult := mrOk;
end;

end.

