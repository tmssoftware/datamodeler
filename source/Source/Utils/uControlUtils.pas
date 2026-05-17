unit uControlUtils;

interface

uses
  Windows, Graphics, Classes, Controls, SysUtils, ComCtrls, Forms, StdCtrls,
  AdvCGrid, AdvMemo, DBGrids, AdvLued;

procedure EnableControl(AControl: TWinControl; AEnabled: Boolean = true);
function IndexOfKey( Sender:TObject; AValue:variant ):integer;

implementation

procedure EnableControl(AControl: TWinControl; AEnabled: Boolean = true);
var c : TColor;
begin
  // Not sure why this is still needed, instead of just setting Color property directly
  // Old code, review this when time allows to see if it can be changed or there was some odd visual behavior
  AControl.Enabled := AEnabled;
  c := clWindow;
  if not AEnabled then
    c := clBtnFace;
  if AControl is TEdit then
    TEdit(AControl).Color := c
  else if AControl is TComboBox then
    TComboBox(AControl).Color := c
  else if AControl is TListView then
    TListView(AControl).Color := c
  else if AControl is TAdvColumnGrid then
    TAdvColumnGrid(AControl).Color := c
  else if AControl is TMemo then
    TMemo(AControl).Color := c
  else if AControl is TAdvMemo then
    TAdvMemo(AControl).BkColor := c
  else if AControl is TDBGrid then
    TDBGrid(AControl).Color := c
  else if AControl is TAdvLUEdit then
    TAdvLUEdit(AControl).Color := c;
end;

function IndexOfKey( Sender:TObject; AValue:variant ):integer;
begin
   { procura um objeto em uma coleção TStrings ou TListView,
     retornando o indíce deste objeto na coleção }
   if Sender is TStrings then
      with TStrings(Sender) do
         for result:=0 to Count-1 do
            if integer(Objects[result])=integer(AValue) then Exit else
   else
   if Sender is TListView then
      with TListView(Sender) do
         for result:=0 to Items.Count-1 do
            if integer(Items[result].Data)=integer(AValue) then Exit;
   result:=-1;
end;

end.

