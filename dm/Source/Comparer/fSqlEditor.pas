unit fSqlEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdvMemo, Buttons, ExtCtrls, Menus, AdvmSQLS, AdvMemoActions, ActnList,
  System.Actions, UITypes;

type
  TLastSearchMode = (lsNone, lsFind, lsReplace);

  TfrSqlEditor = class(TFrame)
    mmSQL: TAdvMemo;
    AdvSQLMemoStyler1: TAdvSQLMemoStyler;
    ActionList1: TActionList;
    acFindText: TAction;
    acWordWrap: TAction;
    PopupMenu1: TPopupMenu;
    Findtext1: TMenuItem;
    FindNext1: TMenuItem;
    N1: TMenuItem;                            
    WordWrap1: TMenuItem;
    FindDialog1: TAdvMemoFindDialog;
    ReplaceDialog1: TAdvMemoFindReplaceDialog;
    acReplaceText: TAction;
    acSearchAgain: TAction;
    ReplaceText1: TMenuItem;
    AdvMemoCut1: TAdvMemoCut;
    AdvMemoCopy1: TAdvMemoCopy;
    AdvMemoPaste1: TAdvMemoPaste;
    AdvMemoSelectAll1: TAdvMemoSelectAll;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    N3: TMenuItem;
    SelectAll1: TMenuItem;
    procedure acWordWrapExecute(Sender: TObject);
    procedure acWordWrapUpdate(Sender: TObject);
    procedure FindDialog1FindText(Sender: TObject);
    procedure acReplaceTextExecute(Sender: TObject);
    procedure acFindTextExecute(Sender: TObject);
    procedure acSearchAgainExecute(Sender: TObject);
  private
    FLastSearch: TLastSearchMode;
  public
    procedure InitViewer;
  end;

implementation

uses
  uSQLStyler;

{$R *.DFM}

procedure TfrSqlEditor.acFindTextExecute(Sender: TObject);
begin
  FindDialog1.Execute;
end;

procedure TfrSqlEditor.acReplaceTextExecute(Sender: TObject);
begin
  ReplaceDialog1.Execute;
end;

procedure TfrSqlEditor.acSearchAgainExecute(Sender: TObject);
begin
  Case FLastSearch of
    lsFind:
      begin
        if mmSQL.FindText(FindDialog1.FindText, FindDialog1.Options) = -1 then
        begin
          if (FindDialog1.DisplayMessage) then
            MessageDlg(Format(FindDialog1.NotFoundMessage, [FindDialog1.FindText]), mtInformation, [mbOK], 0);
        end
        else
        begin
          if FindDialog1.FocusMemo and mmSQL.CanFocus then
            mmSQL.SetFocus;
        end;
      end;
    lsReplace:
      ReplaceDialog1.Execute;
  end;

end;

procedure TfrSqlEditor.acWordWrapExecute(Sender: TObject);
begin
  if mmSQL.WordWrap = wwNone then
    mmSQL.WordWrap := wwClientWidth
  else
    mmSQL.WordWrap := wwNone;
  mmSQL.RefreshMemo;
end;

procedure TfrSqlEditor.acWordWrapUpdate(Sender: TObject);
begin
  //acWordWrap.Checked := mmSQL.WordWrap = wwClientWidth;
  acWordWrap.Visible := false;
end;

procedure TfrSqlEditor.FindDialog1FindText(Sender: TObject);
begin
  FindDialog1.CloseDialog;
  FLastSearch := lsFind;
end;

procedure TfrSqlEditor.InitViewer;
begin
   ImproveSQLMemoStyler(AdvSQLMemoStyler1);
   FindDialog1.OnFindText := FindDialog1FindText;
end;

end.

