object frSQLiteCfg: TfrSQLiteCfg
  Left = 0
  Top = 0
  Width = 343
  Height = 169
  TabOrder = 0
  DesignSize = (
    343
    169)
  object Panel1: TPanel
    Left = 8
    Top = 33
    Width = 327
    Height = 104
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      327
      104)
    object pnPath: TPanel
      Left = 0
      Top = 0
      Width = 327
      Height = 44
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        327
        44)
      object Label5: TLabel
        Left = 5
        Top = 5
        Width = 70
        Height = 15
        Caption = 'Database file:'
      end
      object edDatabase: TAdvFileNameEdit
        Left = 5
        Top = 22
        Width = 320
        Height = 21
        EmptyTextStyle = []
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
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
        Filter = 
          'Database files (*.db, *.db3, *.sqlite)|*.db;*.db3;*.sqlite|All F' +
          'iles (*.*)|*.*'
        FilterIndex = 0
        DialogOptions = [ofPathMustExist]
        DialogKind = fdOpen
      end
    end
    object TestConButton: TBitBtn
      Left = 202
      Top = 75
      Width = 123
      Height = 25
      Anchors = [akRight, akBottom]
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
      TabOrder = 1
      OnClick = TestConButtonClick
    end
    object cbCreateFile: TCheckBox
      Left = 5
      Top = 49
      Width = 316
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Create file if it does not exist'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
end
