unit fUserConnectionEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  uConnectionsFile, StdCtrls, Buttons, ExtCtrls, uAppUtils,
  uConfigFrameManager;

type
  TfmUserConnectionEditor = class(TForm)
    pnMain: TPanel;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    FConfigFrame   : TConfigFrameManager;
    FSetting       : TConnectionSetting;
    procedure SetSetting(const ASetting: TConnectionSetting);
  public
    function GetConnectionstring: String;
    property SelectedSetting: TConnectionSetting read FSetting write SetSetting;
  end;

implementation

{$R *.dfm}

procedure TfmUserConnectionEditor.FormCreate(Sender: TObject);
begin
//  CreateFormSize(Self);
  FConfigFrame := TConfigFrameManager.Create;
end;

procedure TfmUserConnectionEditor.FormDestroy(Sender: TObject);
begin
  FConfigFrame.Free;
end;

procedure TfmUserConnectionEditor.SetSetting(const ASetting: TConnectionSetting);
var
  AWidth, AHeight: integer;
begin
  FSetting := ASetting;
  FConfigFrame.AllocDBFrame(ASetting.ConnDBType, ASetting.Settings);
  FConfigFrame.GetRecommendedSize(AWidth, AHeight);
  if AWidth <> 0 then
    Self.ClientWidth := AWidth;
  if AHeight <> 0 then
    Self.ClientHeight := AHeight + Panel2.Height + 15;
  FConfigFrame.SetFrameParent(pnMain);
  Caption := Format('Connection: %s', [ASetting.Name]);
end;

procedure TfmUserConnectionEditor.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

function TfmUserConnectionEditor.GetConnectionstring: String;
begin
  Result := FConfigFrame.GetConnectionString;
end;

end.
