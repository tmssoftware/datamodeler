unit fCompareProjects;

interface

uses
  Windows, Types, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, uGDAO, Dialogs, ActnList, StdCtrls, Math, ExtCtrls,
  Buttons, ComCtrls, AdvEdit, AdvEdBtn, AdvFileNameEdit, uAppMetaData,
  ImgList, Menus, fCompareDictionaries, fScriptViewer, UITypes, System.Actions;

type
  TComparePage = (pgInitial, pgActionList, pgScript, pgApplyChanges);

  TfrmCompareProjects = class(TForm)
    Shader2: TPanel;
    Image2: TImage;
    Panel1: TPanel;
    pnMain: TPanel;
    Panel2: TPanel;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    ActionList1: TActionList;
    acNext: TAction;
    acCancel: TAction;
    BitBtn1: TBitBtn;
    acBack: TAction;
    pcCompareProjects: TPageControl;
    tsInitial: TTabSheet;
    pnInitial: TPanel;
    lbTitle: TLabel;
    lbSubTitle: TLabel;
    lbBase: TLabel;
    edPath: TAdvFileNameEdit;
    tsResults: TTabSheet;
    tsScript: TTabSheet;
    lbNothingToApply: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure acNextUpdate(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acCancelUpdate(Sender: TObject);
    procedure acBackUpdate(Sender: TObject);
    procedure acBackExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FBaseAMD: TAppMetaData;
    FCurrentMetaData: TAppMetaData;
    FCompareForm: TfmCompareDictionaries;
    FScriptViewer: TScriptViewer;
    FReferencePath: string;
    FResync: boolean;
    {Current wizard page, used by the action handlers instead of TTabSheet.Visible.
     Always change pages through SetPage, never pcCompareProjects.ActivePage directly}
    FPage: TTabSheet;
    procedure SetPage(APage: TTabSheet);
    function CompareProjects(ABaseDictionary, AReferenceDictionary: TGDAODatabase): boolean;
    function CompareToProject(AReferencePath: string): boolean;
    {Resync: true when nothing on the results page is set to be applied}
    function NothingToApply: boolean;
    {Resync: asks the user to confirm the removals set to be applied (no undo).
     True when there are none or the user confirmed}
    function ConfirmRemovals: boolean;
    {Resync: warns about the relationships that applying will skip (their table is not
     in the project nor set to be created). True when there are none or the user continues}
    function ConfirmSkippedRelationships: boolean;
  public
    procedure DoCompareProjects(AMetaData: TAppMetaData; AReferencePath: string='');

    {DB Resync preview: compares the project with ADatabaseDictionary (retrieved from
     the live database), restricted to the table/view AScopeTableName when not empty.
     Returns true when changes were applied to the project}
    function DoResync(AMetaData: TAppMetaData; ADatabaseDictionary: TGDAODatabase;
      const AConnectionName, AScopeTableName: string): boolean;
  end;

implementation

uses
  dgConsts, uAppUtils, dgDBActions;

{$R *.dfm}

procedure TfrmCompareProjects.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FReferencePath := '';
  SetPage(tsInitial);
  // the Next button is disabled in the dfm: an action notifies its clients only when
  // a property changes, so start from False for the first Enabled := True to reach it
  acNext.Enabled := false;

  FCompareForm := TfmCompareDictionaries.Create(Self);
  FCompareForm.Parent := tsResults;
  FCompareForm.Align := alClient;
  FCompareForm.BorderStyle := bsNone;
  FCompareForm.lbDifferences.Caption := 'Differences between projects';
  FCompareForm.Show;

  FScriptViewer := TScriptViewer.Create(Self);
  FScriptViewer.Parent := tsScript;
  FScriptViewer.Align := alClient;
  FScriptViewer.BorderStyle := bsNone;
  FScriptViewer.Show;
end;                      

procedure TfrmCompareProjects.FormDestroy(Sender: TObject);
begin
  if Assigned(FBaseAMD) then
    FreeAndNil(FBaseAMD);
end;

procedure TfrmCompareProjects.acNextExecute(Sender: TObject);
begin
  if FPage = tsInitial then
  begin
    if CompareToProject(edPath.FileName) then
    begin
      SetPage(tsResults);
      FCompareForm.Focus;
    end
    else
      MessageDlg('There are no differences detected!', mtInformation, [mbOk], 0);
  end
  else if FPage = tsResults then
  begin
    if not (ConfirmSkippedRelationships and ConfirmRemovals) then
      Exit;
    FCompareForm.ApplySelectedActions(FScriptViewer);
    SetPage(tsScript);
  end;
end;

procedure TfrmCompareProjects.acNextUpdate(Sender: TObject);
var
  c: string;
begin
  if FPage = tsResults then
  begin
    if FCompareForm.IsApplyChangesSelected then
      c := '&Apply'
    else
      c := '&Generate';
  end
  else
    c := '&Next';
  if acNext.Caption <> c then
    acNext.Caption := c;

  acNext.Enabled :=
    ((FPage.PageIndex < pcCompareProjects.PageCount-1) and ((edPath.FileName > '') or FResync))
    and ((FPage <> tsResults) or FCompareForm.HasSelectedActions);

  lbNothingToApply.Visible := NothingToApply;
end;

function TfrmCompareProjects.NothingToApply: boolean;
begin
  result := FResync and (FPage = tsResults) and not FCompareForm.HasSelectedActions;
end;

function TfrmCompareProjects.ConfirmSkippedRelationships: boolean;
const
  // the dialog stays small: the tree shows the full list
  MaxNames = 5;
var
  list: TStringList;
  i: integer;
  names: string;
begin
  result := true;
  if not (FResync and FCompareForm.IsApplyChangesSelected) then
    Exit;

  list := TStringList.Create;
  try
    FCompareForm.GetSkippedRelationships(list);
    if list.Count = 0 then
      Exit;

    names := '';
    for i := 0 to Min(list.Count, MaxNames) - 1 do
      names := names + sLineBreak + '  ' + list[i];
    if list.Count > MaxNames then
      names := names + sLineBreak + Format('  ... and %d more', [list.Count - MaxNames]);

    result := MessageDlg(Format(
      '%d relationship(s) will not be applied, because their table is not in the project ' +
      'and is not set to be created:%s%s' +
      'Set the table to Apply to include them. Continue without them?',
      [list.Count, names, sLineBreak + sLineBreak]),
      mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes;
  finally
    list.Free;
  end;
end;

function TfrmCompareProjects.ConfirmRemovals: boolean;
const
  // the dialog stays small: counts plus a few table names (the tree shows the full list)
  MaxTableNames = 5;
var
  list: TStringList;
  tables, fields, i: integer;
  names: string;
begin
  result := true;
  if not (FResync and FCompareForm.IsApplyChangesSelected) then
    Exit;

  list := TStringList.Create;
  try
    FCompareForm.GetSelectedRemoveActions(list);
    if list.Count = 0 then
      Exit;

    tables := 0;
    fields := 0;
    names := '';
    for i := 0 to list.Count - 1 do
      if list.Objects[i] is TatRemoveTableAction then
      begin
        Inc(tables);
        if tables <= MaxTableNames then
        begin
          if names > '' then
            names := names + ', ';
          names := names + TatRemoveTableAction(list.Objects[i]).Table.TableName;
        end;
      end
      else if list.Objects[i] is TatRemoveFieldAction then
        Inc(fields);
    if tables > MaxTableNames then
      names := names + Format(' and %d more', [tables - MaxTableNames]);
    if names > '' then
      names := Format(' (%s)', [names]);

    result := MessageDlg(Format(
      'Objects removed from the project: %d table(s)%s, %d field(s), %d other object(s).%s' +
      'This cannot be undone. Continue?',
      [tables, names, fields, list.Count - tables - fields, sLineBreak + sLineBreak]),
      mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes;
  finally
    list.Free;
  end;
end;

function TfrmCompareProjects.CompareProjects(ABaseDictionary, AReferenceDictionary: TGDAODatabase): boolean;
begin
  if ABaseDictionary.DatabaseType <> AReferenceDictionary.DatabaseType then
  begin
    raise EGUIException.Create('Database type difference detected. Cannot compare projects!');
    result := False;
  end
  else
  begin
    result := FCompareForm.CompareDictionaries(FCurrentMetaData, ABaseDictionary, AReferenceDictionary, cmProjects);
  end;
end;

function TfrmCompareProjects.CompareToProject(AReferencePath: string): boolean;
var
  sbase, starget: string;
begin
  if FileExists(AReferencePath) then
  begin
    if Assigned(FBaseAMD) then
      FreeAndNil(FBaseAMD);
    FBaseAMD := TAppMetaData.LoadFromFile(AReferencePath);

    sbase := ExtractFileName(AReferencePath);
    if FBaseAMD.PrjName > '' then
      sbase := Format('%s (%s)', [FBaseAMD.PrjName, sbase]);

    starget := ExtractFileName(ChangeFileExt(FCurrentMetadata.FileName, DMProjectExtension));
    if FCurrentMetaData.PrjName > '' then
      starget := Format('%s (%s)', [FCurrentMetaData.PrjName, starget]);

    FCompareForm.SetDictionaryCaptions(sbase, starget);

    result := CompareProjects(FCurrentMetaData.DataDictionary, FBaseAMD.DataDictionary);
  end
  else
    raise EGUIException.CreateFmt('File "%s" not found.', [AReferencePath]);
end;

procedure TfrmCompareProjects.acCancelExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmCompareProjects.acCancelUpdate(Sender: TObject);
var
  c: string;
begin
  c := '&Cancel';
  if (FPage.PageIndex = pcCompareProjects.PageCount-1) or NothingToApply then
    c := '&Close';
  if acCancel.Caption <> c then
    acCancel.Caption := c;
end;

procedure TfrmCompareProjects.acBackUpdate(Sender: TObject);
var
  page: integer;
begin
  page := FPage.PageIndex;
  if (FReferencePath > '') or FResync then
    Dec(page);
  acBack.Enabled := page > 0;
end;

procedure TfrmCompareProjects.acBackExecute(Sender: TObject);
begin
  SetPage(pcCompareProjects.Pages[FPage.PageIndex - 1]);
end;

procedure TfrmCompareProjects.SetPage(APage: TTabSheet);
begin
  FPage := APage;
  pcCompareProjects.ActivePage := APage;
end;

procedure TfrmCompareProjects.DoCompareProjects(AMetaData: TAppMetaData; AReferencePath: string);
begin
  FCurrentMetaData := AMetaData;
  FReferencePath := AReferencePath;

  if FReferencePath > '' then
  begin
    if CompareToProject(FReferencePath) then
    begin
      SetPage(tsResults);
      ShowModal;
    end
    else
      MessageDlg('There are no differences detected between editing and current database model.', mtInformation, [mbOk], 0);
  end
  else
    ShowModal;
end;

function TfrmCompareProjects.DoResync(AMetaData: TAppMetaData; ADatabaseDictionary: TGDAODatabase;
  const AConnectionName, AScopeTableName: string): boolean;
var
  sproject, sdatabase: string;
begin
  result := false;
  FCurrentMetaData := AMetaData;
  FResync := true;

  Caption := 'Resync structure from database';
  FCompareForm.lbDifferences.Caption := 'Differences between project and database';
  FCompareForm.ScopeTableName := AScopeTableName;

  sproject := ExtractFileName(ChangeFileExt(FCurrentMetadata.FileName, DMProjectExtension));
  if FCurrentMetaData.PrjName > '' then
    sproject := Format('%s (%s)', [FCurrentMetaData.PrjName, sproject]);
  sdatabase := Format('Database (%s)', [AConnectionName]);
  // same convention as CompareToProject: reference first, current project second
  FCompareForm.SetDictionaryCaptions(sdatabase, sproject);

  if FCompareForm.CompareDictionaries(FCurrentMetaData, FCurrentMetaData.DataDictionary,
    ADatabaseDictionary, cmResync) then
  begin
    SetPage(tsResults);
    ShowModal;
    result := FCompareForm.Applied;
  end
  else
    MessageDlg('The project is in sync with the database: no differences detected.', mtInformation, [mbOk], 0);
end;

end.

