unit atProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, atProgressForm;

type
    {The FormPosition property determines the position of the atProgress form. The values can be:

    fpDesigned: the atProgress form position is defined by the FormLeft and FormTop properties;
    fpScreenCenter: the atProgress form is centered on the screen}
   TProgressFormPosition = (fpDesigned, fpScreenCenter);

    {The ProgressStyle property determines the style of the atProgress form. The values can be:

    psNormal: the atProgress form is in normal style;
    psStayOnTop: the atProgress form is always visible}
   TProgressStyle = (psNormal, psStayOnTop);

  {TatprogressOption contains all the possible values of the Options property of the
  atProgress. The following table list the values of the TDBGridOptions type:

   poCancelButton : if true, shows a cancel button, so the user can cancel the process;
   poShowPercent : if true, shows the progress in percent.
  }
  TatProgressOption = (poCancelButton,poShowPercent);
  {TatprogressOptions is a set that defines the possible values of the Options property of the
  atProgress. The following table list the values of the TDBGridOptions type:

    poCancelButton : if true, shows a cancel button, so the user can cancel the process;
    poShowPercent : if true, shows the progress in percent.
  }
  TatProgressOptions = set of TatProgressOption;

  {TatProgress is a non-visual component that can be used to show progress windows. Using
  the Start and StepIt method, you can easily show progress windows to your end-user, without
  having to place a TProgress component in a form, instantiate the form, etc. Just drop a
  TatProgress component, call Start when you begin a process, call IncProgress in each step
  of your process, and call Close when process is done. Your end-user will have a callback
  of what you're doing, seeing the progress window.}
  TatProgress = class(TComponent)
  private
    FProgressCanceled: boolean;
    FProgressStyle: TProgressStyle;
    FForm: TatProgressForm;
    FCaption: string;
    FInfoMessage: string;
    FMin: integer;
    FMax: integer;
    FStep: integer;
    FPosition: integer;
    FCancelCaption: string;
    FOptions: TatProgressOptions;
    FFormLeft: integer;
    FFormTop: integer;
    FFormPosition: TProgressFormPosition;
    FOnCancel: TNotifyEvent;
    procedure SetFormCaption;
    procedure SetFormInfoMessage;
    procedure SetFormMin;
    procedure SetFormMax;
    procedure SetFormStep;
    procedure SetFormCancelCaption;
    procedure SetFormProgressPosition;
    procedure SetFormOptions;
    procedure SetFormFormPosition;
    procedure SetFormFormLeft;
    procedure SetFormFormTop;
    procedure SetFormProgressStyle;
    procedure SetCaption(Value: string);
    procedure SetInfoMessage(Value: string);
    procedure SetFormLeft(Value: integer);
    procedure SetFormTop(Value: integer);
    procedure SetFormPosition(Value: TProgressFormPosition);
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetStep(Value: integer);
    procedure SetCancelCaption(Value: string);
    procedure SetOptions(Value: TatProgressOptions);
    procedure SetVisible(Value: boolean);
    procedure SetPosition(Value: integer);
    procedure SetProgressStyle(Value: TProgressStyle);
    function GetVisible: boolean;
    procedure CreateForm;
  protected
    procedure FormDestroy(Sender: TObject);
    procedure FormCancelProgress(Sender: TObject);
  public
    {Create the component.}
    constructor Create(AOwner: TComponent); override;
    {Destroy the component. Call Free instead Destroy.}
    destructor Destroy; override;
    {Start set the initial parameters and show the progress form. Call Start to quickly start
    a progress, without have to setting properties. Start method do the following actions:
    - sets the InfoMessage, Min, Max and Step properties according to AInfoMessage, AMin, AMax and AStep parameters;
    - sets Position property to AMin;
    - sets ProgressCanceled property to false;
    - shows the progress form.}
    procedure Start(AInfoMessage: string; AMin,AMax,AStep: integer);
    {StepIt advances Position by the amount specified in the Step property. Call the StepIt method to increase the value of Position by the value of the Step property.
    If Step represents the size of one logical step in the process tracked by the atProgress, call
    Step after each logical step is completed.}
    procedure StepIt;
    {Show shows the atProgress form. Use Show to set the atProgress form’s Visible property to True.
    the Show method doesn't set ProgressCanceled to false. You have to set the property manually, if
    you want to use it to check when user cancel the progress, or call the Start method to automatically
    set it to false.}
    procedure Show;
    {Close closes the atProgress form.}
    procedure Close;
    {Read ProgressCanceled property to check if the user canceled the progress, by pressing
    the Cancel button. You have to manualy set ProgressCanceled to false before starting
    progress to check when user pressed cancel, or use the Start method, which automatically
    sets ProgressCanceled to true.
    When user press the cancel button, ProgressCanceled becomes true, but doesn't close the
    progress form.}
    property ProgressCanceled: boolean read FProgressCanceled write FProgressCanceled;
    {Visible is a Boolean value that indicates whether the atProgress form is visible. Use Visible to
    get or set whether the atProgress form is visible. If Visible is True, the atProgress form is
    visible — unless it is completely obscured by other forms. If Visible is False, the atProgress form
    is not visible. You can set Visible to True by calling the Show method.}
    property Visible: boolean read GetVisible write SetVisible;
  published
    {Use the Caption property to change the atProgress' form caption}
    property Caption: string read FCaption write SetCaption;
    {Use the InfoMessage property to change the message to be displayed in the atProgress form, while
    the process is being tracked.}
    property InfoMessage: string read FInfoMessage write SetInfoMessage;
    {Min specifies the lower limit of the range of possible positions. Use Max along with the Min property to establish the range of possible positions
    a progress bar. When the process tracked by the atProgress begins, the value of Position
    should equal Min.}
    property Min: integer read FMin write SetMin default 0;
    {Max specifies the upper limit of the range of possible positions. Use Max along with the Min property to establish the range of possible positions
    a progress bar. When the process tracked by the atProgress begins, the value of Position
    should equal Min.}
    property Max: integer read FMax write SetMax default 100;
    {Step is the amount that Position increases when the StepIt method is called. Set Step to specify
     the granularity of the atProgress. Step should reflect the size of each step in the process tracked
     by the atProgress, in the logical units used by the Max and Min properties. When a atProgress is
     started, Min and Max represent percentages, where Min is 0 (0% complete) and Max is 100 (100%
     complete). If these values are not changed, Step is the percentage of the process completed before
     the user is provided with additional visual feedback. When the StepIt method is called, the value
     of Position increases by Step.}
    property Step: integer read FStep write SetStep default 10;
    {Position is the current position of the atProgress. Read Position to determine how far the process
    tracked by the atProgress has advanced from Min toward Max. Set Position to cause the atProgress to
    display a position between Min and Max. For example, when the process tracked by the atProgress
    completes, set Position to Max so that it appears completely filled. When a atProgress is executed,
    Min and Max represent percentages, where Min is 0 (0% complete) and Max is 100 (100% complete).
    If these values are not changed, Position is the percentage of the process that has already been
    completed.}
    property Position: integer read FPosition write SetPosition default 0;
    {CancelCaption contains the caption of the cancel button, if it is being displayed. This property
    only makes sense if the Options property contains poCancelButton.}
    property CancelCaption: string read FCancelCaption write SetCancelCaption;
    {Use Options property to set how the atProgress will work. The following options are available:

    poCancelButton : if true, shows a cancel button, so the user can cancel the process;
    poShowPercent : if true, shows the progress in percent.}
    property Options: TatProgressOptions read FOptions write SetOptions default
       [poCancelButton, poShowPercent];
    {The FormLeft property determines the horizontal coordinate of the left edge of the atProgress form
    relative to the screen in pixels.}
    property FormLeft: integer read FFormLeft write SetFormLeft;
    {The FormTop property determines the vertical coordinate of the top edge of the atProgress form
    relative to the screen in pixels.}
    property FormTop: integer read FFormTop write SetFormTop;
    {The FormPosition property determines the positino of the atProgress form. The values can be:

    fpDesigned: the atProgress form position is defined by the FormLeft and FormTop properties;
    fpScreenCenter: the atProgress form is centered on the screen}
    property FormPosition: TProgressFormPosition read FFormPosition write SetFormPosition;
    {The ProgressStyle property determines the style of the atProgress form. The values can be:

    psNormal: the atProgress form is in normal style;
    psStayOnTop: the atProgress form is always visible}
    property ProgressStyle: TProgressStyle read FProgressStyle write SetProgressStyle;
    {The OnCancel event is fired when the user press cancel the progress, by pressing the
    cancel button}
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
  end;

implementation


{TatProgress}
constructor TatProgress.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FOptions:=[poCancelButton, poShowPercent];
   FMin:=0;
   FMax:=100;
   FStep:=10;
   FPosition:=0;
end;

destructor TatProgress.Destroy;
begin
   if Assigned(FForm) then FForm.Free;
   inherited;
end;

procedure TatProgress.SetCaption(Value: string);
begin
   if Value<>FCaption then FCaption := Value;
   SetFormCaption;
end;

procedure TatProgress.SetInfoMessage(Value: string);
begin
   if Value<>FInfoMessage then FInfoMessage:=Value;
   SetFormInfoMessage;
end;

procedure TatProgress.SetMin(Value: integer);
begin
   if Value<>FMin then FMin:=Value;
   SetFormMin;
end;

procedure TatProgress.SetMax(Value: integer);
begin
   if Value<>FMax then FMax:=Value;
   SetFormMax;
end;

procedure TatProgress.SetFormLeft(Value: integer);
begin
   if Value<>FFormLeft then FFormLeft:=Value;
   SetFormFormLeft;
end;

procedure TatProgress.SetFormTop(Value: integer);
begin
   if Value<>FFormTop then FFormTop:=Value;
   SetFormFormTop;
end;

procedure TatProgress.SetProgressStyle(Value: TProgressStyle);
begin
   if Value<>FProgressStyle then FProgressStyle:=Value;
   SetFormProgressStyle;
end;

procedure TatProgress.SetFormPosition(Value: TProgressFormPosition);
begin
   if Value<>FFormPosition then FFormPosition:=Value;
   SetFormFormPosition;
end;

procedure TatProgress.SetPosition(Value: integer);
begin
   if Value<>FPosition then FPosition:=Value;
   SetFormProgressPosition;
end;

procedure TatProgress.SetStep(Value: integer);
begin
   if Value<>FStep then FStep:=Value;
   SetFormStep;
end;

procedure TatProgress.SetCancelCaption(Value: string);
begin
   if Value<>FCancelCaption then FCancelCaption:=Value;
   SetFormCancelCaption;
end;

procedure TatProgress.SetOptions(Value: TatProgressOptions);
begin
   if Value<>FOptions then
   begin
      FOptions:=Value;
   end;
   SetFormOptions;
end;

procedure TatProgress.StepIt;
begin
   if Assigned(FForm) then
   begin
      FForm.StepIt;
      FPosition:=FForm.ProgressPosition;
   end;
end;

procedure TatProgress.Show;
begin
   SetVisible(true);
end;

procedure TatProgress.Close;
begin
   SetVisible(false);
end;

procedure TatProgress.SetVisible(Value: boolean);
begin
   if (Value=false) and not Assigned(FForm) then Exit;
   if not Assigned(FForm) then CreateForm;
   if Value then
   begin
      SetFormCaption;
      SetFormInfoMessage;
      SetFormMin;
      SetFormMax;
      SetFormStep;
      SetFormCancelCaption;
      SetFormFormPosition;
      SetFormProgressPosition;
      SetFormProgressStyle;
      SetFormOptions;
      if not (csDesigning in ComponentState) then
         FForm.Visible:=true;
   end else
   begin
      if not (csDesigning in ComponentState) then
         FForm.Visible:=false;
   end;
end;

function TatProgress.GetVisible: boolean;
begin
   if not Assigned(FForm) then
   begin
     result:=false;
     exit;
   end;
   result:=FForm.Visible;
end;

procedure TatProgress.SetFormCaption;
begin
   if Assigned(FForm) then FForm.Caption:=FCaption;
end;

procedure TatProgress.SetFormFormLeft;
begin
   if Assigned(FForm) then FForm.Left:=FFormLeft;
end;

procedure TatProgress.SetFormProgressStyle;
begin
   if Assigned(FForm) then
   begin
      Case FProgressStyle of
         psNormal : FForm.FormStyle:=fsNormal;
         psStayOnTop : FForm.FormStyle:=fsStayOnTop;
      end;
   end;
end;

procedure TatProgress.SetFormFormTop;
begin
   if Assigned(FForm) then FForm.Top:=FFormTop;
end;

procedure TatProgress.SetFormFormPosition;
begin
   if Assigned(FForm) then
      Case FFormPosition of
         fpScreenCenter: FForm.Position:=poScreenCenter;
         fpDesigned:
            begin
               FForm.Position:=poDesigned;
               SetFormFormLeft;
               SetFormFormTop;
            end;
      end;
end;

procedure TatProgress.SetFormProgressPosition;
begin
   if Assigned(FForm) then FForm.ProgressPosition:=FPosition;
end;

procedure TatProgress.SetFormInfoMessage;
begin
   if Assigned(FForm) then FForm.MessageLabel.Caption:=FInfoMessage;
end;

procedure TatProgress.SetFormMin;
begin
   if Assigned(FForm) then FForm.ProgressBar.Min:=FMin;
end;

procedure TatProgress.SetFormMax;
begin
   if Assigned(FForm) then FForm.ProgressBar.Max:=FMax;
end;

procedure TatProgress.SetFormStep;
begin
   if Assigned(FForm) then FForm.ProgressBar.Step:=FStep;
end;

procedure TatProgress.SetFormCancelCaption;
begin
   if Assigned(FForm) then FForm.CancelButton.Caption:=FCancelCaption;
end;

procedure TatProgress.SetFormOptions;
begin
   if Assigned(FForm) then With FForm do
   begin
      HasCancelButton:=poCancelButton in FOptions;
      ShowPercentPanel:=poShowPercent in FOptions;
   end;
end;

procedure TatProgress.CreateForm;
begin
   FForm:=TatProgressForm.Create(nil);
   FForm.OnDestroy:=FormDestroy;
   FForm.OnCancelProgress:=FormCancelProgress;
end;

procedure TatProgress.FormDestroy(Sender: TObject);
begin
   FForm:=nil;
end;

procedure TatProgress.Start(AInfoMessage: string; AMin,AMax,AStep: integer);
begin
   InfoMessage:=AInfoMessage;
   Min:=AMin;
   Max:=AMax;
   Step:=AStep;
   Position:=Min;
   FProgressCanceled:=false;
   Show;
end;

procedure TatProgress.FormCancelProgress(Sender: TObject);
begin
   if Assigned(FOnCancel) then FOnCancel(Self);
   FProgressCanceled:=true;
end;

end.
