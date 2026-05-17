unit fCompareVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, uGDAO,
  Dialogs, ActnList, StdCtrls, Math, ExtCtrls,  Buttons, ComCtrls,
  AdvEdit, AdvEdBtn, AdvFileNameEdit, uAppMetaData, fCompareDictionaries, dgConsts,
  uDBProperties, fScriptViewer, UITypes, System.Actions;

type
  TComparePage = (pgInitial, pgActionList, pgScript, pgApplyChanges);

  TfrmCompareVersion = class(TForm)
    Shader2: TPanel;
    Image2: TImage;
    Panel1: TPanel;
    pnMain: TPanel;
    lbTitle: TLabel;
    lbSubTitle: TLabel;
    Panel2: TPanel;
    pnInitial: TPanel;
    cbBase: TComboBox;
    cbTarget: TComboBox;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    ActionList1: TActionList;
    acNext: TAction;
    acCancel: TAction;
    BitBtn1: TBitBtn;
    acBack: TAction;
    lbBase: TLabel;
    lbTarget: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbBaseClick(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure acNextUpdate(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acCancelUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acBackUpdate(Sender: TObject);
    procedure acBackExecute(Sender: TObject);
  private
    FCurrentPage : TComparePage;
    FCompareForm: TfmCompareDictionaries;
    FScriptViewer: TScriptViewer;
    FBaseVersion: TVersion;
    FTargetVersion: TVersion;
    FChangesAlreadyApplied: boolean;
    FAMD: TAppMetaData;
    FBaseDictionary: TGDAODatabase;
    FTargetDictionary: TGDAODatabase;
    function GetVersionCaption(AVersion: TVersion): string;
    function GetCurVersionCaption: string;
    procedure ComboBase;
    function CompareVersions(AAMD: TAppMetaData; ABase, ATarget: TVersion): boolean;
    procedure SetBaseVersion(const Value: TVersion);
    procedure SetTargetVersion(const Value: TVersion);
    procedure SetCurrentPage(const Value: TComparePage);
    procedure SetAMD(const Value: TAppMetaData);
  public
    property AMD: TAppMetaData read FAMD write SetAMD;
  published
    property BaseVersion:   TVersion read FBaseVersion write SetBaseVersion;
    property TargetVersion: TVersion read FTargetVersion write SetTargetVersion;
    property CurrentPage : TComparePage read FCurrentPage write SetCurrentPage;
  end;

implementation

uses
  uControlUtils, uAppUtils;

{$R *.dfm}

procedure TfrmCompareVersion.ComboBase;
var
  idx, i : Integer;
begin
  cbBase.Clear;
  with FAMD.VersionControl do
  begin
    idx := -1;
    for i := 0 to Count-1 do
      if Items[i] = GetLastVersion then
      begin
        idx := i;
        cbBase.Items.AddObject(GetCurVersionCaption,Items[i])
      end
      else if FileExists(Items[i].AbsoluteFileName) then
        cbBase.Items.AddObject(GetVersionCaption(Items[i]),Items[i]);
    cbBase.ItemIndex := idx;
    cbBase.OnClick(nil);
  end;
end;

function TfrmCompareVersion.CompareVersions(AAMD: TAppMetaData; ABase, ATarget: TVersion): boolean;
begin
  if ABase.IsCurrentVersion then
    TDBProperties.CopyDictionary(AAMD.DataDictionary, FBaseDictionary)
  else
    AAMD.VersionControl.GetDictionaryFromVersion(ABase, FBaseDictionary);

  if ATarget.IsCurrentVersion then
    TDBProperties.CopyDictionary(AAMD.DataDictionary, FTargetDictionary)
  else
    AAMD.VersionControl.GetDictionaryFromVersion(ATarget, FTargetDictionary);

  result := False;
  if Assigned(FBaseDictionary) and Assigned(FTargetDictionary) then
  begin
    if FBaseDictionary.DatabaseType = FTargetDictionary.DatabaseType then
    begin
      FCompareForm.SetDictionaryCaptions(GetVersionCaption(ABase), GetVersionCaption(ATarget));
      result := FCompareForm.CompareDictionaries(AAMD, FBaseDictionary, FTargetDictionary, cmVersions);
    end
    else
      raise EGUIException.Create('Database type difference detected. Cannot compare versions!')
  end;
end;

procedure TfrmCompareVersion.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FBaseDictionary := TGDAODatabase.Create(nil);
  FTargetDictionary := TGDAODatabase.Create(nil);

  FChangesAlreadyApplied := False;

  FCompareForm := TfmCompareDictionaries.Create(Self);
  FCompareForm.Parent := pnMain;
  FCompareForm.Align := alClient;
  FCompareForm.BorderStyle := bsNone;
  FCompareForm.lbDifferences.Caption := 'Differences between versions';
  FCompareForm.Show;

  FScriptViewer := TScriptViewer.Create(nil);
  FScriptViewer.Parent := pnMain;
  FScriptViewer.Align := alClient;
  FScriptViewer.BorderStyle := bsNone;
  FScriptViewer.Show;
end;

procedure TfrmCompareVersion.cbBaseClick(Sender: TObject);
var idx, i : Integer;
    vBase : TVersion;
begin
  cbTarget.Clear;
  if cbBase.ItemIndex >= 0 then
  begin
    vBase := TVersion(cbBase.Items.Objects[cbBase.ItemIndex]);
    with FAMD.VersionControl do
    begin
      idx := 0;
      for i := 0 to Count-1 do
        if (Items[i] <> vBase) then
        begin
          if Items[i] = GetLastVersion then
          begin
            idx := cbTarget.Items.Count;
            cbTarget.Items.AddObject(GetCurVersionCaption,Items[i]);
          end
          else if FileExists(Items[i].AbsoluteFileName) then
            cbTarget.Items.AddObject(GetVersionCaption(Items[i]),Items[i]);
        end;
      cbTarget.ItemIndex := idx;
    end;
  end;
end;

function TfrmCompareVersion.GetVersionCaption(AVersion: TVersion): string;
begin
  Result := Format('Version %d (%s)', [AVersion.VersionID, FormatDateTime('dd/mm/yyyy', AVersion.DateTime)]);
end;

procedure TfrmCompareVersion.acNextExecute(Sender: TObject);
//var applyres: string;
begin
  case CurrentPage of
    pgInitial :
      begin
        // displaying the actions frame
        if CompareVersions(FAMD, TVersion(cbBase.Items.Objects[cbBase.ItemIndex]), TVersion(cbTarget.Items.Objects[cbTarget.ItemIndex])) then
        begin
          CurrentPage := pgActionList;
          FCompareForm.Focus;
        end
        else
          MessageDlg('There are no differences detected!', mtInformation, [mbOk], 0);
      end;
    pgActionList :
      begin
        FCompareForm.ApplySelectedActions(FScriptViewer);
        CurrentPage := pgScript;
      end;
    pgApplyChanges:
      begin
      end;
  end;
end;

procedure TfrmCompareVersion.acNextUpdate(Sender: TObject);
var c: string;
begin
  if CurrentPage = pgActionList then
  begin
    c := '&Generate';
  end
  else
    c := '&Next';
  if acNext.Caption <> c then
    acNext.Caption := c;

  acNext.Enabled :=
    ((CurrentPage = pgInitial) and (cbBase.ItemIndex > -1) and (cbTarget.ItemIndex > -1))
    or ((CurrentPage = pgActionList) and FCompareForm.HasSelectedActions);
end;

procedure TfrmCompareVersion.acCancelExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmCompareVersion.acCancelUpdate(Sender: TObject);
var
  c: string;
begin
  c := '&Cancel';
  if CurrentPage = pgScript then
    c := '&Close';
  if acCancel.Caption <> c then
    acCancel.Caption := c;
end;

procedure TfrmCompareVersion.FormDestroy(Sender: TObject);
begin
  FBaseDictionary.Free;
  FTargetDictionary.Free;
end;

function TfrmCompareVersion.GetCurVersionCaption: string;
begin
  with FAMD.VersionControl.GetLastVersion do
  begin
    Result := Format('Current version (%d)',[VersionID]);
  end;
end;

procedure TfrmCompareVersion.acBackUpdate(Sender: TObject);
begin
  acBack.Enabled := (not pnInitial.Visible);
end;

procedure TfrmCompareVersion.acBackExecute(Sender: TObject);
begin
  if FCurrentPage = pgApplyChanges then
    CurrentPage := pgActionList
  else
    CurrentPage := TComparePage( max(ord(FCurrentPage)-1, 0) );
end;

procedure TfrmCompareVersion.SetAMD(const Value: TAppMetaData);
begin
  FAMD := Value;

  if Assigned(FAMD) then
  begin
//    with FFrameComparador.pnScriptOptions do
//    begin
//      Visible := FAMD.DataDictionary.EnableAdvancedScriptOptions;
//      if Visible then
//        Top := MaxInt; { bottom! }
//    end;

    ComboBase;
    CurrentPage := pgInitial;

    // default: base version = last; compare to = current
    if cbBase.ItemIndex >= 0 then
    begin
      cbBase.ItemIndex := cbBase.ItemIndex - 1;
      cbBase.Onclick(nil);
    end;
  end;
end;

procedure TfrmCompareVersion.SetBaseVersion(const Value: TVersion);
begin
  FBaseVersion := Value;
  cbBase.ItemIndex := IndexOfKey(cbBase.Items, integer(Value));
  cbBase.OnClick(nil);
end;

procedure TfrmCompareVersion.SetTargetVersion(const Value: TVersion);
begin
  FTargetVersion := Value;
  cbTarget.ItemIndex := IndexOfKey(cbTarget.Items, integer(Value));
end;

procedure TfrmCompareVersion.SetCurrentPage(const Value: TComparePage);
begin
  FCurrentPage := Value;
  pnInitial.Visible := FCurrentPage = pgInitial;
  FCompareForm.Visible := FCurrentPage = pgActionList;
  FScriptViewer.Visible := FCurrentPage = pgScript;
end;

end.

