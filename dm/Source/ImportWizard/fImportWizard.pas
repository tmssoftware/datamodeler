unit fImportWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, uDBConnect, uAppMetaData, Mask,
  LangConst, fImportProgress, uConfigFrameManager, ActnList, jpeg,
  fImportSave, fImportPassword, dgConsts, dgDBTypes, UITypes,
  System.Actions;

type
  TImportStep = (paStart, paConfiguration, paPassword, paProgress, paFinal);
  
  TfmImportWizard = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    btNext: TBitBtn;
    BitBtn1: TBitBtn;
    ActionList1: TActionList;
    acNext: TAction;
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    acBack: TAction;
    Shader1: TPanel;
    Image1: TImage;
    pnMain: TPanel;
    pnInitial: TPanel;
    lbTit1: TLabel;
    lbWiz1: TLabel;
    lbdbType: TLabel;
    lbConnection: TLabel;
    rNew: TRadioButton;
    rExisting: TRadioButton;
    cbDbType: TComboBox;
    cbConnection: TComboBox;
    acCancel: TAction;
    procedure FormShow(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acBackUpdate(Sender: TObject);
    procedure rExistingClick(Sender: TObject);
    procedure acNextUpdate(Sender: TObject);
    procedure acBackExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acCancelUpdate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FMetaData      : TAppMetaData;
    FStep         : TImportStep;
    FConfigFrame   : TConfigFrameManager;
    FProgressFrame : TfrImportProgress;
    FSaveFrame     : TfrImportSave;
    FPasswordFrame : TfrImportPassword;
    FImportOk      : Boolean;
    FAddConnection : Boolean;
    FDefaultDBType: TDatabaseType;
    procedure DoImportar;
    procedure LoadUserConnectionsCombo;
    procedure SaveCurrentUserConnection;
    procedure ShowPasswordFrame(AShowSaveCheckBox: Boolean);
    function GetSelectedConnectionString(ASaving: Boolean = false): String;
    function NewConnectionName: string;
    function GetSelectedDBType: TDatabaseType;
  public
    function Execute(AMetaData:TAppMetaData):boolean;
    function ExecuteAddConnection(DefaultDBType: TDatabaseType):boolean;
  end;

implementation

uses
  uConnectionsFile,
  uSystemClass, uDBProperties,
  uAppRegistry, uControlUtils;

{$R *.DFM}

function TfmImportWizard.Execute(AMetaData: TAppMetaData): boolean;
var r : Integer;
begin
  FMetaData := AMetaData;
  r := ShowModal;

  Result      := FImportOK;
  if Result then
  begin
    if (r = mrOk) and rNew.Checked and FSaveFrame.cbSave.checked then
      SaveCurrentUserConnection;
  end;
end;

function TfmImportWizard.ExecuteAddConnection(DefaultDBType: TDatabaseType): boolean;
begin
  FAddConnection := True;

  {Change controls visibility}
  Caption := 'Database connection';
  lbTit1.Caption := 'New database connection';
  lbWiz1.Caption := 'This wizard will help you to create a new database connection. Please choose database type:';
  rExisting.Hide;
  lbConnection.Hide;
  cbConnection.Hide;
  rNew.Checked := True;
  ActiveControl := cbDBType;
  FSaveFrame.cbSave.Checked := true;
  FSaveFrame.cbSave.Visible := false;

  FDefaultDBType := DefaultDBType;

  result := ShowModal = mrOk;
  if result then
  begin
    if rNew.Checked and FSaveFrame.cbSave.checked then
      SaveCurrentUserConnection;
  end;
end;

procedure TfmImportWizard.FormShow(Sender: TObject);
var
  c: integer;
begin
  TDBProperties.FillDatabaseTypes(cbDBType.Items, '(choose database connection)');
  cbDBType.ItemIndex := 0;
  cbDBType.ItemIndex := 0;
  if FDefaultDBType <> nil then
    for c := 0 to cbDBType.Items.Count - 1 do
      if cbDBType.Items.Objects[c] = FDefaultDBType then
      begin
        cbDBType.ItemIndex := c;
      end;
  FStep := paStart;
  rExistingClick(nil);
end;

procedure TfmImportWizard.acNextExecute(Sender: TObject);
var i: integer;
begin
  case FStep of
    paStart :
      begin
        pnInitial.Visible := false;
        // allocating selected dbtype configuration frame
        if rNew.Checked then
        begin
          if FConfigFrame.CurrentDBType <> TDatabaseType(cbDBType.Items.Objects[cbDBType.ItemIndex]) then
            FConfigFrame.AllocDBFrame(
              TDatabaseType(cbDBType.Items.Objects[cbDBType.ItemIndex]), '');
          FConfigFrame.SetFrameParent(pnMain);
          for i:=0 to FConfigFrame.Frame.ComponentCount-1 do
            if (FConfigFrame.Frame.Components[i] is TWinControl) and (FConfigFrame.Frame.Components[i].Tag = 1) then
            begin
              if TWinControl(FConfigFrame.Frame.Components[i]).CanFocus then
                Self.ActiveControl := FConfigFrame.Frame.Components[i] as TWinControl;
              break;
            end;
        end;

        // incrementing the step - depends on the option
        if rExisting.Checked then
        begin
          DMRegistry.LastUsedConnection := cbConnection.Items[cbConnection.ItemIndex];
          if TConnectionSetting(cbConnection.Items.Objects[cbConnection.ItemIndex]).PasswordIsRequired then
          begin
            // existing connection settings and the user password is required
            ShowPasswordFrame(false);
          end
          else
          begin
            // existing connection and password is not required
            DoImportar;
          end;
        end
        else
          FStep := paConfiguration;
      end;
    paConfiguration :
      begin
        FConfigFrame.CheckSettings;
        if not FConfigFrame.PasswordIsRequired then
          DoImportar
        else
          ShowPasswordFrame(true);
      end;
    paPassword  :    DoImportar;
    paProgress :
        begin
          if rNew.Checked then
          begin
            FStep := paFinal;
            FConfigFrame.SetFrameParent(nil);
            FSaveFrame.edName.Text := NewConnectionName;
            FSaveFrame.Parent := pnMain;
            if FSaveFrame.edName.CanFocus then
              Self.ActiveControl := FSaveFrame.edName;
          end{
          else
            modalResult := mrOk}
        end;
    paFinal :
        begin
          ModalResult := mrOk;
        end;
  end;
end;

procedure TfmImportWizard.acNextUpdate(Sender: TObject);
begin
  case FStep of
    paStart:       acNext.Enabled :=( (rExisting.Checked) and (cbConnection.ItemIndex > -1) ) or ( (rNew.Checked) and (cbDBType.ItemIndex > 0) );
    paConfiguration: acNext.Enabled := true;
    //paProgress:     acNext.Enabled := FImportOk;
    paProgress:     acNext.Enabled := FImportOk and rNew.Checked;
    //paFinal:         acNext.Enabled := ((not FSaveFrame.cbSave.Checked) or (FSaveFrame.edName.Text>'') );
    paFinal:         acNext.Enabled := ((FSaveFrame.cbSave.Checked) and (FSaveFrame.edName.Text>''));
  end;
  case FStep of
    paStart              : acNext.Caption := '&Next >';
    paProgress            :
      if FImportOk then
        acNext.Caption := '&Next >'
      else
        acNext.Caption := 'Wait...';
    paConfiguration        :
      if FAddConnection then
        acNext.Caption := '&Next >'
      else
        acNext.Caption := '&Import';
    paFinal: acNext.Caption := '&Ok';
  end;

end;

procedure TfmImportWizard.acCancelExecute(Sender: TObject);
begin
  if (FStep = paProgress) and not rNew.Checked then
    ModalResult := mrOk
  else
    ModalResult := mrCancel;
end;

procedure TfmImportWizard.acCancelUpdate(Sender: TObject);
begin
  case FStep of
    paProgress:
      begin
        acCancel.Enabled := FImportOk and not rNew.Checked;
        acCancel.Caption := '&Finish';
      end;
    paFinal:
      begin
        if FSaveFrame.cbSave.Checked then
          acCancel.Caption := '&Cancel'
        else
          acCancel.Caption := '&Finish';
        acCancel.Enabled := true;
      end;
  else
    acCancel.Enabled := true;
    acCancel.Caption := '&Cancel';
  end;
end;


procedure TfmImportWizard.FormCreate(Sender: TObject);
begin
    FAddConnection := False;
    FConfigFrame   := TConfigFrameManager.Create;
    FSaveFrame     := TfrImportSave.Create(nil);
    FProgressFrame := TfrImportProgress.Create(nil);
    FPasswordFrame := TfrImportPassword.Create(nil);
    FProgressFrame.Align := alClient;
    FPasswordFrame.Align := alClient;
    FSaveFrame.Align := alClient;
    FImportOk := false;
    LoadUserConnectionsCombo;
end;

procedure TfmImportWizard.FormDestroy(Sender: TObject);
begin
  FConfigFrame.Free;
  FProgressFrame.Free;
  FSaveFrame.Free;
  FPasswordFrame.Free;
end;

procedure TfmImportWizard.acBackUpdate(Sender: TObject);
begin
  acBack.Enabled := (FStep in [paPassword, paConfiguration]);
end;

procedure TfmImportWizard.rExistingClick(Sender: TObject);
begin
  // existing
  lbConnection.Enabled := rExisting.Checked;
  EnableControl(cbConnection, rExisting.Checked);
  // new
  lbDBType.Enabled := rNew.Checked;
  EnableControl(cbDBType, rNew.Checked);
  if rExisting.Checked and cbConnection.CanFocus then
    cbConnection.SetFocus
  else if cbDBType.CanFocus and Visible then
    cbDBType.SetFocus;
end;

procedure TfmImportWizard.DoImportar;
var
  DBConnection: TDBConnection;
  step: string;
begin
  if FAddConnection then
  begin
    FStep := paFinal;
    FConfigFrame.SetFrameParent(nil);
    FSaveFrame.edName.Text := NewConnectionName;
    FSaveFrame.Parent := pnMain;
    if FSaveFrame.edName.CanFocus then
      Self.ActiveControl := FSaveFrame.edName;
    acNext.Update;
    acBack.Update;
    acCancel.Update;
    exit;
  end;

  FImportOk := false;

  // FMetadata should never be nil at this point
  if FMetadata = nil then raise Exception.Create('Metadata not specified in the importer form');

  Screen.Cursor := crHourGlass;
  try
    try
      // setting the target database type
      FMetadata.DataDictionary.DatabaseType := GetSelectedDBType;
      TDBProperties.LoadAll(FMetaData.DataDictionary);

      step := 'connecting to database server';
      DBConnection := CreateAndConnectDBConnection(GetSelectedDBType, GetSelectedConnectionString);
      try
        // progress frame
        FConfigFrame.SetFrameParent(nil);
        FProgressFrame.Parent := pnMain;
        FStep := paProgress;
        acNext.Update;
        acBack.Update;
        acCancel.Update;

        // check database version
        step := 'checking database version';
        if not DBConnection.DataRetriever.CheckDatabaseVersion and (MessageDlg(Format(SDatabaseVersionWarning,
          [GetSelectedDBType.Caption]), mtWarning, [mbYes, mbNo], 0) <> mrYes)
        then
          Abort;

        // retrieving
        step := 'retrieving metadata';

        FProgressFrame.pbProgress.Step := 1;
        FProgressFrame.pbProgress.Position := 0;
        FProgressFrame.pbProgress.Max := 1000;

        DBConnection.DataRetriever.OnProgress := procedure(Percentage: double)
          var
            APos: Integer;
          begin
            {workaround vista problem which makes the progress bar to go slowly to the next position.
             With the workaround below, the progress bar will go quickly.}
            APos := Round(Percentage * 1000);
            FProgressFrame.pbProgress.Position := APos;
            FProgressFrame.pbProgress.Position := APos - 1;
            FProgressFrame.pbProgress.Position := APos;
            Application.ProcessMessages;
          end;
        DBConnection.DataRetriever.RetrieveDictionary(FMetaData.DataDictionary);

        // clear existing diagrams
        FMetaData.DiagramObj.Diagrams.Clear;
        FImportOk := true;
      finally
        DBConnection.Free;
      end;
    except
      FStep := paStart;
      FConfigFrame.SetFrameParent(nil);
      FProgressFrame.Parent := nil;
      pnInitial.Visible := true;
      raise;
    end;
  finally
    Screen.Cursor := crDefault;
    FProgressFrame.EndProgress;
  end;
end;

procedure TfmImportWizard.acBackExecute(Sender: TObject);
begin
  case FStep of
    paConfiguration :
      begin
        FStep := paStart;
        FConfigFrame.SetFrameParent(nil);
        //FConfigFrame.DestroyFrame;
        pnInitial.Visible := true;
      end;
    paPassword :
      begin
        FPasswordFrame.Parent := nil;
        if rNew.Checked then
        begin
          FConfigFrame.SetFrameParent(pnMain);
          FStep := paConfiguration;
        end else
        begin
          FStep := paStart;
          pnInitial.Visible := true;
        end;
      end;
  end;
end;

procedure TfmImportWizard.LoadUserConnectionsCombo;
var i : Integer;
begin
  cbConnection.Clear;
  with SystemConfig.UserConnections.List do
  begin
    for i := 0 to Count-1 do
      cbConnection.Items.AddObject(Items[i].Name, Items[i]);
  end;
  rExisting.Enabled := cbConnection.Items.Count > 0;
  cbConnection.ItemIndex := cbConnection.Items.IndexOf(DMRegistry.LastUsedConnection);
  if not rExisting.Enabled then
    rNew.Checked := true
  else
    if cbConnection.ItemIndex = -1 then
      cbConnection.ItemIndex := 0;
end;

procedure TfmImportWizard.SaveCurrentUserConnection;
var s : TStrings;
begin
  s := TStringList.Create;
  try
    s.Text := GetSelectedConnectionString(true);
    if (FConfigFrame.PasswordIsRequired) and (not FPasswordFrame.cbSavePassword.Checked) and
       (s.IndexOfName(vConnectionStr_PasswordValue)>-1) then
       s.Values[vConnectionStr_PasswordValue] := ' ';

    with SystemConfig.UserConnections.List.Add do
    begin
      Name       := FSaveFrame.edName.Text;
      Settings   := s.Text;
      ConnDBType := FConfigFrame.CurrentDBType;
    end;
    SystemConfig.SaveUserConnectionsFile;
  finally
    s.Free;
  end;
end;

function TfmImportWizard.GetSelectedDBType: TDatabaseType;
begin
  if rExisting.Checked then
    Result := TConnectionSetting(cbConnection.Items.Objects[cbConnection.ItemIndex]).ConnDBType
  else
    Result := TDatabaseType(cbDbType.Items.Objects[cbDbType.ItemIndex]);
end;

function TfmImportWizard.GetSelectedConnectionString(ASaving: Boolean): String;
var s : TStrings;
    ANeedPass: Boolean;
begin
  s := TStringList.Create;
  try
    if rNew.Checked then
    begin
      s.Text    := FConfigFrame.GetConnectionString;
      ANeedPass := FConfigFrame.PasswordIsRequired;
    end
    else
    begin
      s.Text    := TConnectionSetting(cbConnection.Items.Objects[cbConnection.ItemIndex]).Settings;
      ANeedPass := TConnectionSetting(cbConnection.Items.Objects[cbConnection.ItemIndex]).PasswordIsRequired;
    end;
    if ANeedPass then
    begin
      s.Values[vConnectionStr_UserNameValue] := FPasswordFrame.edUserName.Text;
      s.Values[vConnectionStr_PasswordValue] := FPasswordFrame.edPassword.Text;
    end;
    Result := s.Text;
  finally
    s.Free;
  end;
end;

procedure TfmImportWizard.ShowPasswordFrame(AShowSaveCheckBox: Boolean);
begin
  FStep := paPassword;
  FPasswordFrame.Parent := pnMain;
  FPasswordFrame.cbSavePassword.Visible := AShowSaveCheckBox;
end;

function TfmImportWizard.NewConnectionName: string;
var i: integer;
begin
  i := 0;
  repeat
    inc(i);
    result := Format('%s Connection %d', [FConfigFrame.CurrentDBType.DisplayName, i]);
  until SystemConfig.UserConnections.List.IndexOf(result) < 0;
end;

procedure TfmImportWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) and (Shift=[]) and btNext.Enabled then
    btNext.Click;
end;

end.

