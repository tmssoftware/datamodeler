object fmUserConnectionEditor: TfmUserConnectionEditor
  Left = 317
  Top = 265
  BorderStyle = bsDialog
  Caption = 'User Connection Settings'
  ClientHeight = 267
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 407
    Height = 227
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 227
    Width = 407
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object Bevel1: TBevel
      Left = 5
      Top = 5
      Width = 397
      Height = 2
      Align = alTop
    end
    object Panel4: TPanel
      Left = 189
      Top = 7
      Width = 213
      Height = 28
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object BitBtn2: TBitBtn
        Left = 132
        Top = 3
        Width = 80
        Height = 25
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        NumGlyphs = 2
        TabOrder = 0
      end
      object BitBtn1: TBitBtn
        Left = 47
        Top = 3
        Width = 80
        Height = 25
        Caption = '&Ok'
        NumGlyphs = 2
        TabOrder = 1
        OnClick = BitBtn1Click
      end
    end
  end
end
