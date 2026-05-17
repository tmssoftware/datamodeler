unit fConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, uGDAO, Mask, LangConst, UITypes,  AdvMemo, ImgList, AdvEdit, AdvEdBtn, AdvDirectoryEdit, dgConsts;

type
  TConfigPage = (cpNone,cpPrototype,cpDatabase,cpAppRegistry,cpReplication);

  TfmConfig = class(TForm)
    Panel1: TPanel;
    pcPages: TPageControl;
    tsInformation: TTabSheet;
    Panel2: TPanel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    atPanel1: TPanel;
    Label1: TLabel;
    edProjectNAme: TEdit;
    Label2: TLabel;
    edAuthor: TEdit;
    Label3: TLabel;
    mDescription: TMemo;
    tsVersionControl: TTabSheet;
    GroupBox1: TGroupBox;
    edVersionPath: TAdvDirectoryEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDBName          : string;  // AppRegistry database name

    FProjectName     : String;
    FAuthor          : String;
    FDescription     : String;
    // version control
    FRelativePath    : Boolean;
    FVersionPath     : String;

  public
    property DBName          : string read FDBName write FDBName;
    property ProjectName     : String read FProjectName write FProjectName;
    property Author          : String read FAuthor write FAuthor;
    property Description     : String read FDescription write FDescription;

    property RelativePath    : Boolean read FRelativePath write FRelativePath;
    property VersionPath     : String read FVersionPath write FVersionPath;
  end;

implementation

uses
  uAppUtils;

{$R *.DFM}

procedure TfmConfig.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
end;

procedure TfmConfig.FormShow(Sender: TObject);
begin
  pcPages.ActivePageIndex := 0;
  // information sheet
  edProjectName.Text        := FProjectName;
  edAuthor.Text             := FAuthor;
  mDescription.Text         := FDescription;

  // version control sheet
  edVersionPath.Text        := FVersionPath;
end;

procedure TfmConfig.BitBtn1Click(Sender: TObject);

   procedure Erro(AControl:TWinControl;msg:string);
   var tab:TWinControl;                                            
   begin
      { tenta encontrar o tabsheet do controle }
      tab:=AControl.Parent;
      while Assigned(tab) and not (tab is TTabSheet) do tab:=tab.Parent;
      if msg>'' then
         raise EGUIException.Create(msg)
      else
         Abort;
   end;

   function ObtemLegendaDoControle(AControl:TWinControl):string;
   var c: integer;
   begin
      for c:=0 to ComponentCount-1 do
         if (Components[c] is TLabel) then
            with TLabel(Components[c]) do
               if FocusControl=AControl then
               begin
                  result:=Caption;
                  Exit;
               end;
      result:='';
   end;

   procedure ValidaDiretorio(AControl:TWinControl;ARequired:boolean);
   var dir: string;
   begin
      dir:=TEdit(AControl).Text;
      if (ARequired and (dir='')) then Erro(AControl,Format(SNotInformed,[ObtemLegendaDoControle(AControl.Parent.Parent)]));
      if (dir='') or SysUtils.DirectoryExists(dir) then
         Exit
      else
         if MessageDlg(Format(SMissingDirectoryCreateNow,[dir]),mtConfirmation,[mbYes,mbNo],0)=mrYes then
            SysUtils.ForceDirectories(dir)
         else
            Erro(AControl,'');
   end;

begin
  // information sheet
  FProjectName          := edProjectName.Text;
  FAuthor               := edAuthor.Text;
  FDescription          := mDescription.Text;

  FVersionPath           := edVersionPath.Text;

  ModalResult := mrOk;
end;

end.

