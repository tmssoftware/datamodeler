unit fDiagramFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lucombo, StdCtrls, AdvCombo, Buttons;

type
  TFindExecuteEvent = procedure(Sender: TObject; ASearchText: string; AForward: boolean) of object;

  TfmDiagramFind = class(TForm)
    cbSearch: TLUCombo;
    btPrevious: TSpeedButton;
    btNext: TSpeedButton;
    btClose: TSpeedButton;
    procedure btCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btNextClick(Sender: TObject);
    procedure btPreviousClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOnFindExecute: TFindExecuteEvent;
    FDiagramControl: TWinControl;
    procedure AddHistory;
    procedure FindPrevious;
    procedure FindNext;
    procedure DoFindExecute(ASearchText: string; AForward: boolean);
    function GetShowing: boolean;
    procedure SetShowing(const Value: boolean);
  public
    procedure Start;
    procedure ShowPanel;
    procedure HidePanel;
    property OnFindExecute: TFindExecuteEvent read FOnFindExecute write FOnFindExecute;
    property DiagramControl: TWinControl read FDiagramControl write FDiagramControl;
    property Showing: boolean read GetShowing write SetShowing;
  end;

implementation

uses
  uAppRegistry;

{$R *.dfm}

procedure TfmDiagramFind.AddHistory;
begin
  if (Trim(cbSearch.Text) <> '') and (cbSearch.Items.IndexOf(cbSearch.Text) = -1) then
  begin
    cbSearch.Items.Insert(0, cbSearch.Text);
    while cbSearch.Items.Count > 30 do
      cbSearch.Items.Delete(cbSearch.Items.Count - 1);
    cbSearch.SavePersist;
  end;
end;

procedure TfmDiagramFind.btCloseClick(Sender: TObject);
begin
  HidePanel;
end;

procedure TfmDiagramFind.btNextClick(Sender: TObject);
begin
  FindNext;
end;

procedure TfmDiagramFind.btPreviousClick(Sender: TObject);
begin
  FindPrevious;
end;

procedure TfmDiagramFind.DoFindExecute(ASearchText: string; AForward: boolean);
begin
  if Assigned(FOnFindExecute) then
    FOnFindExecute(Self, ASearchText, AForward);
end;

procedure TfmDiagramFind.FindNext;
begin
  AddHistory;
  DoFindExecute(cbSearch.Text, true);
end;

procedure TfmDiagramFind.FindPrevious;
begin
  AddHistory;
  DoFindExecute(cbSearch.Text, false);
end;

procedure TfmDiagramFind.FormCreate(Sender: TObject);
begin
  cbSearch.Persist.Enable := true;
  cbSearch.Persist.Storage := stRegistry;
  cbSearch.Persist.Key := DMRegistry.SettingsKey;
  cbSearch.Persist.Section := 'DiagramFindHistory';
end;

procedure TfmDiagramFind.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    HidePanel;
  if Key = VK_RETURN then
  begin
    if ssShift in Shift then
      FindPrevious
    else
      FindNext;
  end;
end;

function TfmDiagramFind.GetShowing: boolean;
begin
  Result := Self.Visible;
end;

procedure TfmDiagramFind.HidePanel;
begin
  Self.Visible := false;
  if FDiagramControl <> nil then
    if FDiagramControl.CanFocus then
      FDiagramControl.SetFocus;
end;

procedure TfmDiagramFind.SetShowing(const Value: boolean);
begin
  if Showing then
    HidePanel
  else
    ShowPanel;
end;

procedure TfmDiagramFind.ShowPanel;
begin
  Self.Visible := true;
  Self.SetFocus;
  Start;
end;

procedure TfmDiagramFind.Start;
begin
  cbSearch.SetFocus;
end;

end.
