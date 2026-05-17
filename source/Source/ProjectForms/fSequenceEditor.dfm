object fmSequenceEditor: TfmSequenceEditor
  Left = 0
  Top = 0
  Caption = 'fmSequenceEditor'
  ClientHeight = 216
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 76
    Height = 13
    Caption = 'Sequence name'
  end
  object Label2: TLabel
    Left = 289
    Top = 9
    Width = 47
    Height = 13
    Caption = 'Start with'
  end
  object edName: TEdit
    Left = 8
    Top = 24
    Width = 271
    Height = 21
    TabOrder = 0
  end
  object edStartWith: TAdvLUEdit
    Left = 289
    Top = 24
    Width = 76
    Height = 21
    EditAlign = eaRight
    EditType = etNumeric
    EmptyTextStyle = []
    FocusColor = clWindow
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'MS Sans Serif'
    LabelFont.Style = []
    Lookup.Font.Charset = DEFAULT_CHARSET
    Lookup.Font.Color = clWindowText
    Lookup.Font.Height = -11
    Lookup.Font.Name = 'Tahoma'
    Lookup.Font.Style = []
    Lookup.Separator = ';'
    Color = clWindow
    TabOrder = 1
    Text = '0'
    Visible = True
    Version = '1.4.1.0'
    AutoHistory = False
    AutoSynchronize = False
    FileLookup = False
    LookupPersist.Enable = False
    LookupPersist.Location = plInifile
    LookupPersist.Key = 'LUEdit'
    LookupPersist.Section = 'Values'
    LookupPersist.Count = 0
    LookupPersist.MaxCount = False
    MatchCase = False
  end
end
