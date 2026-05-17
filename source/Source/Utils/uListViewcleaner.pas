unit uListViewCleaner;

interface

uses
  SysUtils, ComCtrls, Classes;

type
  TListViewCleaner = class
  private
    FItems : TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddListViewItem(AItem: TListItem);
    procedure ListViewItemDeleted(AItem: TListItem);
    procedure Execute;
  end;

function ListViewCleaner: TListViewCleaner;

implementation

{ TListViewCleaner }

var
  vListViewCleaner: TListViewCleaner;

function ListViewCleaner: TListViewCleaner;
begin
  if not Assigned(vListViewCleaner) then
    vListViewCleaner := TListViewCleaner.Create;
  result := vListViewCleaner;
end;

procedure TListViewCleaner.AddListViewItem(AItem: TListItem);
begin
  FItems.Add(AItem);
end;

constructor TListViewCleaner.Create;
begin
    FItems := TList.Create;
end;

destructor TListViewCleaner.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TListViewCleaner.Execute;
var i : Integer;
begin
  i := 0;
  while i <= FItems.Count-1 do
  begin
    if (not TListItem(FItems[i]).ListView.IsEditing) then
    begin
      if TListItem(FItems[i]).Caption = '' then
        TListItem(FItems[i]).Delete;
      FItems.Delete(i);
      i := 0;
    end
    else
      inc(i);
  end;
end;

procedure TListViewCleaner.ListViewItemDeleted(AItem: TListItem);
var i : Integer;
begin
  for i := 0 to fItems.Count-1 do
    if TListItem(FItems[i]) = AItem then
    begin
      FItems.Delete(i);
      break;
    end;
end;

initialization

finalization
  if Assigned(vListViewCleaner) then
    FreeAndNil(vListViewCleaner);

end.

