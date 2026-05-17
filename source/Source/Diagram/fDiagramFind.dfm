object fmDiagramFind: TfmDiagramFind
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'fmDiagramFind'
  ClientHeight = 35
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 13
  object btPrevious: TSpeedButton
    Left = 286
    Top = 5
    Width = 62
    Height = 21
    Caption = 'Previous'
    Flat = True
    OnClick = btPreviousClick
  end
  object btNext: TSpeedButton
    Left = 354
    Top = 5
    Width = 53
    Height = 21
    Caption = 'Next'
    Flat = True
    OnClick = btNextClick
  end
  object btClose: TSpeedButton
    Left = 5
    Top = 5
    Width = 21
    Height = 21
    Flat = True
    Glyph.Data = {
      32010000424D3201000000000000360000002800000009000000090000000100
      180000000000FC00000000000000000000000000000000000000DEEFEF427B84
      427B84DEEFEFDEEFEFDEEFEF427B84427B84DEEFEF00427B84FFFFFFFFFFFF42
      7B84DEEFEF427B84FFFFFFFFFFFF427B8400427B84FFFFFFFFFFFFFFFFFF427B
      84FFFFFFFFFFFFFFFFFF427B8400DEEFEF427B84FFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF427B84DEEFEF00DEEFEFDEEFEF427B84FFFFFFFFFFFFFFFFFF427B84DE
      EFEFDEEFEF00DEEFEF427B84FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF427B84DEEF
      EF00427B84FFFFFFFFFFFFFFFFFF427B84FFFFFFFFFFFFFFFFFF427B8400427B
      84FFFFFFFFFFFF427B84DEEFEF427B84FFFFFFFFFFFF427B8400DEEFEF427B84
      427B84DEEFEFDEEFEFDEEFEF427B84427B84DEEFEF00}
    OnClick = btCloseClick
  end
  object cbSearch: TLUCombo
    Left = 28
    Top = 5
    Width = 252
    Height = 21
    Color = clWindow
    Version = '2.3.1.6'
    Visible = True
    ButtonWidth = 17
    EmptyTextStyle = []
    Ctl3D = True
    DropWidth = 0
    Enabled = True
    ItemIndex = -1
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    ParentCtl3D = False
    ReturnIsTab = False
    TabOrder = 0
    AutoHistory = False
    AutoHistoryLimit = 0
    AutoHistoryDirection = ahdFirst
    AutoSynchronize = False
    FileLookup = False
    Persist.Enable = False
    Persist.Storage = stInifile
    Persist.Count = 0
    Persist.MaxCount = False
    ModifiedColor = clHighlight
    ShowModified = False
  end
end
