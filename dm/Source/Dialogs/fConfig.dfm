object fmConfig: TfmConfig
  Left = 260
  Top = 223
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 277
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 473
    Height = 237
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object pcPages: TPageControl
      Left = 5
      Top = 5
      Width = 463
      Height = 227
      ActivePage = tsInformation
      Align = alClient
      TabOrder = 0
      object tsInformation: TTabSheet
        Caption = 'Information'
        ImageIndex = 1
        object atPanel1: TPanel
          Left = 0
          Top = 0
          Width = 455
          Height = 199
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            455
            199)
          object Label1: TLabel
            Left = 5
            Top = 5
            Width = 132
            Height = 13
            AutoSize = False
            Caption = 'Project name'
            FocusControl = edProjectNAme
          end
          object Label2: TLabel
            Left = 195
            Top = 5
            Width = 212
            Height = 13
            AutoSize = False
            Caption = 'Author'
            FocusControl = edAuthor
          end
          object Label3: TLabel
            Left = 5
            Top = 45
            Width = 282
            Height = 13
            AutoSize = False
            Caption = 'Description'
            FocusControl = mDescription
          end
          object edProjectNAme: TEdit
            Left = 5
            Top = 19
            Width = 185
            Height = 21
            TabOrder = 0
          end
          object edAuthor: TEdit
            Left = 195
            Top = 19
            Width = 255
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
          end
          object mDescription: TMemo
            Left = 5
            Top = 59
            Width = 445
            Height = 133
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 2
          end
        end
      end
      object tsVersionControl: TTabSheet
        Caption = 'Version control'
        ImageIndex = 3
        DesignSize = (
          455
          199)
        object GroupBox1: TGroupBox
          Left = 10
          Top = 8
          Width = 432
          Height = 58
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Working directory '
          TabOrder = 0
          DesignSize = (
            432
            58)
          object edVersionPath: TAdvDirectoryEdit
            Left = 16
            Top = 21
            Width = 400
            Height = 21
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
            Lookup.Font.Name = 'MS Sans Serif'
            Lookup.Font.Style = []
            Lookup.Separator = ';'
            Anchors = [akLeft, akTop, akRight]
            Color = clWindow
            ShortCut = 0
            TabOrder = 0
            Text = ''
            Visible = True
            Version = '1.7.2.2'
            ButtonStyle = bsButton
            ButtonWidth = 18
            Flat = False
            Etched = False
            Glyph.Data = {
              CE000000424DCE0000000000000076000000280000000C0000000B0000000100
              0400000000005800000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
              00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
              00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
              0000FF0BBB00000F0000FFF000FFFFFF0000}
            ReadOnly = False
            BrowseDialogText = 'Select Directory'
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 237
    Width = 473
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    object Panel4: TPanel
      Left = 255
      Top = 5
      Width = 213
      Height = 30
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
