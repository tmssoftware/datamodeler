unit uDialogs;

interface

uses Forms, SysUtils, Classes, Dialogs,
     Messages, Windows, Controls;

function ExecuteSaveDialog(const ATitle,ADefaultExt,AFilter:string; var AFileName:string):boolean;
function ExecuteOpenDialog(const ATitle,ADefaultExt,AFilter:string; var AFileName:string):boolean;
function DialogMsg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;

implementation

function ExecuteSaveDialog(const ATitle, ADefaultExt, AFilter: string;
  var AFileName:string): boolean;
var
  dialog: TSaveDialog;
begin
   dialog := TSaveDialog.Create(Application);
   with dialog do
   try
      Title := ATitle;
      InitialDir := ExtractFilePath(AFileName);
      FileName := ExtractFileName(AFileName);
      DefaultExt := ADefaultExt;
      Filter := AFilter;
      Options := Options + [ofOverwritePrompt];
      if Execute then
      begin
        AFileName := FileName;
        result := true;
      end
      else
         result:=false;
   finally
      Free;
   end;
end;

function ExecuteOpenDialog(const ATitle,ADefaultExt,AFilter:string; var AFileName:string):boolean;
var dialog:TOpenDialog;
begin
   dialog:=TOpenDialog.Create(Application);
   with dialog do
   try
      Title:=ATitle;
      FileName:=AFileName;
      DefaultExt:=ADefaultExt;
      Filter:=AFilter;
      if Execute then
      begin
         AFileName:=FileName;
         result:=true;
      end
      else
         result:=false;
   finally
      Free;
   end;
end;

function DialogMsg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
var flags: integer;
begin
   flags:=0;
   if Buttons=[mbAbort,mbRetry,mbIgnore] then flags:=MB_ABORTRETRYIGNORE else
   if Buttons=[mbOk] then flags:=MB_OK else
   if Buttons=[mbOk,mbCancel] then flags:=MB_OKCANCEL else
   if Buttons=[mbRetry,mbCancel] then flags:=MB_RETRYCANCEL else
   if Buttons=[mbYes,mbNo] then flags:=MB_YESNO else
   if Buttons=[mbYes,mbNo,mbCancel] then flags:=MB_YESNOCANCEL;
   Case DlgType of
      mtInformation: flags:=flags+MB_ICONINFORMATION;
      mtConfirmation: flags:=flags+MB_ICONQUESTION;
      mtError: flags:=flags+MB_ICONERROR;
      mtWarning: flags:=flags+MB_ICONWARNING;
      //não implementado:
      //MB_ICONEXCLAMATION,
      //MB_ICONSTOP,
      //MB_ICONHAND
   end;
   case Application.MessageBox(PChar(Msg),PChar(Application.Title),flags) of
      IDOK: result:=mrOk;
      IDCANCEL: result:=mrCancel;
      IDABORT: result:=mrAbort;
      IDRETRY: result:=mrRetry;
      IDIGNORE: result:=mrIgnore;
      IDYES: result:=mrYes;
      IDNO: result:=mrNo;
   else
      result:=0;
   end;
end;

end.
