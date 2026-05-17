object fmEnvironmentSettings: TfmEnvironmentSettings
  Left = 282
  Top = 214
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = 'Data Modeler Options'
  ClientHeight = 172
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 132
    Width = 334
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object btOk: TBitBtn
      Left = 162
      Top = 9
      Width = 80
      Height = 25
      Caption = '&Ok'
      Default = True
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btOkClick
    end
    object BitBtn2: TBitBtn
      Left = 248
      Top = 9
      Width = 80
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 334
    Height = 132
    ActivePage = tsDisplay
    Align = alClient
    TabOrder = 0
    object tsDisplay: TTabSheet
      Caption = 'Display'
      object Label1: TLabel
        Left = 9
        Top = 9
        Width = 149
        Height = 13
        Caption = 'Show measurements in units of:'
      end
      object cbMeasUnit: TComboBox
        Left = 178
        Top = 6
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
    end
  end
end
