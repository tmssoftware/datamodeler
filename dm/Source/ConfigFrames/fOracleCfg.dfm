object frOracleCfg: TfrOracleCfg
  Left = 0
  Top = 0
  Width = 427
  Height = 304
  TabOrder = 0
  DesignSize = (
    427
    304)
  object Panel2: TPanel
    Left = 60
    Top = 64
    Width = 307
    Height = 177
    Anchors = []
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      307
      177)
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 287
      Height = 15
      Caption = 'Net service name (pick from the list or enter manually)'
    end
    object Label4: TLabel
      Left = 8
      Top = 52
      Width = 56
      Height = 15
      Caption = 'User name'
    end
    object Label5: TLabel
      Left = 151
      Top = 52
      Width = 50
      Height = 15
      Caption = 'Password'
    end
    object Label3: TLabel
      Left = 8
      Top = 100
      Width = 42
      Height = 15
      Caption = 'Schema'
    end
    object cbService: TComboBox
      Left = 8
      Top = 22
      Width = 289
      Height = 23
      TabOrder = 0
      OnDropDown = cbServiceDropDown
    end
    object TestConButton: TBitBtn
      Left = 174
      Top = 146
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
    object edUserName: TEdit
      Left = 8
      Top = 67
      Width = 137
      Height = 23
      Enabled = False
      TabOrder = 1
    end
    object cbSchema: TComboBox
      Left = 8
      Top = 115
      Width = 289
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = '(user schema)'
      OnDropDown = cbSchemaDropDown
      Items.Strings = (
        '(user schema)')
    end
  end
end
