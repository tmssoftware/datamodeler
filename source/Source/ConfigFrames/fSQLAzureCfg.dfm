object frSQLAzureCfg: TfrSQLAzureCfg
  Left = 0
  Top = 0
  Width = 423
  Height = 296
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 423
    Height = 296
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      423
      296)
    object Panel2: TPanel
      Left = 58
      Top = 49
      Width = 307
      Height = 198
      Anchors = []
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        307
        198)
      object Label1: TLabel
        Left = 8
        Top = 6
        Width = 65
        Height = 15
        Caption = 'Server name'
      end
      object Label3: TLabel
        Left = 10
        Top = 122
        Width = 81
        Height = 15
        Caption = 'Database name'
      end
      object Label2: TLabel
        Left = 168
        Top = 25
        Width = 129
        Height = 13
        Caption = '.database.windows.net'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edServerName: TEdit
        Left = 8
        Top = 22
        Width = 156
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object cbDatabase: TComboBox
        Left = 10
        Top = 138
        Width = 289
        Height = 21
        TabOrder = 2
        OnDropDown = cbDatabaseDropDown
      end
      object TestConButton: TBitBtn
        Left = 176
        Top = 165
        Width = 123
        Height = 25
        Anchors = [akTop]
        Caption = 'Test connection'
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
          33333333333F8888883F33330000324334222222443333388F3833333388F333
          000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
          F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
          223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
          3338888300003AAAAAAA33333333333888888833333333330000333333333333
          333333333333333333FFFFFF000033333333333344444433FFFF333333888888
          00003A444333333A22222438888F333338F3333800003A2243333333A2222438
          F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
          22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
          33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
          3333333333338888883333330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        TabOrder = 3
        OnClick = TestConButtonClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 50
        Width = 289
        Height = 63
        Caption = 'Login info'
        TabOrder = 1
        object Label4: TLabel
          Left = 17
          Top = 17
          Width = 56
          Height = 15
          Caption = 'User name'
        end
        object Label5: TLabel
          Left = 147
          Top = 17
          Width = 50
          Height = 15
          Caption = 'Password'
        end
        object edUserName: TEdit
          Left = 17
          Top = 32
          Width = 121
          Height = 21
          TabOrder = 0
        end
      end
    end
  end
end
