unit atProgressForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TatProgressForm = class(TForm)
    Panel1: TPanel;
    MessageLabel: TLabel;
    CancelButton: TButton;
    ProgressBar: TProgressBar;
    PercentPanel: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FOnCancelProgress: TNotifyEvent;
    procedure SetPercentual;
    procedure SetHasCancelButton(Value: boolean);
    procedure SetShowPercentPanel(Value: boolean);
    function GetHasCancelButton: boolean;
    function GetShowPercentPanel: boolean;
    procedure SetProgressPosition(Value: integer);
    function GetProgressPosition: integer;
  public
    { Public declarations }
    procedure StepIt;
    property HasCancelButton: boolean read GetHasCancelButton write SetHasCancelButton;
    property ShowPercentPanel: boolean read GetShowPercentPanel write SetShowPercentPanel;
    property OnCancelProgress: TNotifyEvent read FOnCancelProgress write FOnCancelProgress;
    property ProgressPosition: integer read GetProgressPosition write SetProgressPosition;
  end;

implementation

{$R *.DFM}

procedure TatProgressForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action:=caFree;
end;

procedure TatProgressForm.SetPercentual;
Var V: double;
begin
   if (ProgressBar.Max=0) or (ProgressBar.Position>=ProgressBar.Max) then
      V:=100
   else
      V:=100*ProgressBar.Position/ProgressBar.Max;
   PercentPanel.caption:=FormatFloat('#0.0',V)+'%';
   Application.ProcessMessages;
end;

procedure TatProgressForm.SetHasCancelButton(Value: boolean);
begin
  if Value then
  begin
     CancelButton.Visible:=true;
     self.Height := 80;
  end else
  begin
     CancelButton.Visible:=false;
     self.Height := 50;
  end;
  Application.ProcessMessages;
end;

function TatProgressForm.GetHasCancelButton: boolean;
begin
   result:=CancelButton.visible;
end;

procedure TatProgressForm.SetShowPercentPanel(Value: boolean);
begin
   if Value<>PercentPanel.visible then
   begin
      if Value then
      begin
         ProgressBar.Width:=ProgressBar.Width-PercentPanel.Width-3;
         PercentPanel.visible:=true;
      end else
      begin
         ProgressBar.Width:=ProgressBar.Width+PercentPanel.Width+3;
         PercentPanel.visible:=false;
      end;
      Application.ProcessMessages;
   end;
end;

function TatProgressForm.GetShowPercentPanel: boolean;
begin
   result:=PercentPanel.visible;
end;

procedure TatProgressForm.CancelButtonClick(Sender: TObject);
begin
   if Assigned(FOnCancelProgress) then FOnCancelProgress(Self);
end;

function TatProgressForm.GetProgressPosition: integer;
begin
   result:=ProgressBar.Position;
end;

procedure TatProgressForm.SetProgressPosition(Value: integer);
begin
   if Value<>ProgressBar.Position then
   begin
      ProgressBar.Position:=Value;
      SetPercentual;
   end;
end;

procedure TatProgressForm.StepIt;
begin
   ProgressBar.StepIt;
   SetPercentual;
end;

procedure TatProgressForm.FormShow(Sender: TObject);
begin
   SetPercentual;
end;

end.
