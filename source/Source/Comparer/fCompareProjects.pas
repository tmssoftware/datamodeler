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
    function CompareProjects(ABaseDictionary, AReferenceDictionary: TGDAODatabase): boolean;
    function CompareToProject(AReferencePath: string): boolean;
  public
    procedure DoCompareProjects(AMetaData: TAppMetaData; AReferencePath: string='');
  end;

implementation

uses
  dgConsts, uAppUtils;

{$R *.dfm}

procedure TfrmCompareProjects.FormCreate(Sender: TObject);
begin
  CreateFormSize(Self);
  FReferencePath := '';
  pcCompareProjects.ActivePage := tsInitial;

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
  if tsInitial.Visible then
  begin                                    
    if CompareToProject(edPath.FileName) then
    begin
      pcCompareProjects.ActivePage := tsResults;
      FCompareForm.Focus;
    end
    else
      MessageDlg('There are no differences detected!', mtInformation, [mbOk], 0);
  end
  else if tsResults.Visible then
  begin
    FCompareForm.ApplySelectedActions(FScriptViewer);
    pcCompareProjects.ActivePage := tsScript;
  end;
end;

procedure TfrmCompareProjects.acNextUpdate(Sender: TObject);
var
  c: string;
begin
  if tsResults.Visible then
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
    ((pcCompareProjects.ActivePageIndex < pcCompareProjects.PageCount-1) and (edPath.FileName > ''))
    and (not tsResults.Visible or FCompareForm.HasSelectedActions);
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
  if (pcCompareProjects.ActivePageIndex = pcCompareProjects.PageCount-1) then
    c := '&Close';
  if acCancel.Caption <> c then
    acCancel.Caption := c;
end;

procedure TfrmCompareProjects.acBackUpdate(Sender: TObject);
var
  page: integer;
begin
  page := pcCompareProjects.ActivePageIndex;
  if FReferencePath > '' then
    Dec(page);
  acBack.Enabled := page > 0;
end;

procedure TfrmCompareProjects.acBackExecute(Sender: TObject);
begin
  pcCompareProjects.ActivePageIndex := pcCompareProjects.ActivePageIndex - 1;
end;

procedure TfrmCompareProjects.DoCompareProjects(AMetaData: TAppMetaData; AReferencePath: string);
begin
  FCurrentMetaData := AMetaData;
  FReferencePath := AReferencePath;

  if FReferencePath > '' then
  begin
    if CompareToProject(FReferencePath) then
    begin
      pcCompareProjects.ActivePage := tsResults;
      ShowModal;
    end
    else
      MessageDlg('There are no differences detected between editing and current database model.', mtInformation, [mbOk], 0);
  end
  else
    ShowModal;
end;

end.

