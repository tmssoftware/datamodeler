unit fScriptViewer;

interface

uses                   
  Types, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fSqlEditor, Db, uAppMetaData, Menus, Buttons,
  ExtCtrls, LangConst, ActnList, ImgList, StdCtrls, System.Actions,
  System.ImageList, UITypes;

type
  TApplySQLEvent = procedure(ASQLScript: string; ALogStrings: TStrings; var ADone: boolean) of object;

  TScriptViewer = class(TForm)
    frSqlEditor1: TfrSqlEditor;
    pnBottom: TPanel;
    btApply: TBitBtn;
    btSaveAs: TBitBtn;
    btClose: TBitBtn;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    alScriptSQL: TActionList;
    acSave: TAction;
    acApply: TAction;
    acClose: TAction;
    mmExecLog: TMemo;
    spExecLog: TSplitter;
    lbTop: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acCloseExecute(Sender: TObject);
    procedure acApplyExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acApplyUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mmExecLogChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMetaData: TAppMetaData;
    FOnApplySQL: TApplySQLEvent;
    FApplyDone: boolean;
  public
    class procedure ShowSql(AScript: string; AMetaData: TAppMetaData=nil; AOnApplySQL: TApplySQLEvent=nil);
    procedure SetScript(AScript: string; AMetaData: TAppMetaData=nil; AOnApplySQL: TApplySQLEvent=nil);
    property OnApplySQL: TApplySQLEvent read FOnApplySQL write FOnApplySQL;
  end;

implementation

uses
  uGDAO, AdvMemo, ShellApi, uAppUtils;

{$R *.DFM}

procedure TScriptViewer.SetScript(AScript: string; AMetaData: TAppMetaData; AOnApplySQL: TApplySQLEvent);
begin
  frSQLEditor1.InitViewer;
  frSQLEditor1.mmSQL.Lines.Text := AScript;
  OnApplySQL := AOnApplySQL;
  FMetaData := AMetaData;
end;

class procedure TScriptViewer.ShowSql(AScript: string; AMetaData: TAppMetaData; AOnApplySQL: TApplySQLEvent);
var
  viewer: TScriptViewer;
begin
  viewer := TScriptViewer.Create(nil);
  try
    viewer.SetScript(AScript, AMetaData, AOnApplySQL);
    viewer.ShowModal;
  finally
    viewer.Free;
  end;
end;

procedure TScriptViewer.acApplyExecute(Sender: TObject);
begin
  if Assigned(FOnApplySQL) then
  begin
    mmExecLog.Visible := True;
    spExecLog.Visible := True;

    FOnApplySQL(frSQLEditor1.mmSQL.Lines.Text, mmExecLog.Lines, FApplyDone);
  end;
end;

procedure TScriptViewer.acApplyUpdate(Sender: TObject);
begin
  acApply.Visible := Assigned(FOnApplySQL) and (frSQLEditor1.mmSQL.Lines.Count > 0);
  acApply.Enabled := not FApplyDone;
end;

procedure TScriptViewer.acCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TScriptViewer.acSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    frSQLEditor1.mmSQL.Lines.SaveToFile(SaveDialog1.FileName);
    if MessageDlg(Format('File "%s" saved. Do you want to open it?', [SaveDialog1.FileName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
      ShellExecute(0, 'open', PChar(SaveDialog1.FileName), nil, nil, SW_NORMAL);
  end;
end;

procedure TScriptViewer.acSaveUpdate(Sender: TObject);
begin
  acSave.Enabled := frSQLEditor1.mmSQL.Lines.Count > 0;
end;

procedure TScriptViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Parent = nil then
    Action := caFree;
end;

procedure TScriptViewer.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FApplyDone := False;
end;

procedure TScriptViewer.FormShow(Sender: TObject);
begin
  lbTop.Visible := Parent <> nil;
  btClose.Visible := Parent = nil;
  if not btClose.Visible then
  begin
    btApply.Left := btSaveAs.Left;
    btSaveAs.Left := btClose.Left;
  end;
end;

procedure TScriptViewer.mmExecLogChange(Sender: TObject);
begin
  mmExecLog.CaretPos := Point(0, mmExecLog.Lines.Count-1);
  SendMessage(mmExecLog.Handle, EM_SCROLLCARET, 0, 0);
end;

end.

