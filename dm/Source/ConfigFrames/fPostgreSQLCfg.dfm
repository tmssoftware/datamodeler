object frPostgreSQLCfg: TfrPostgreSQLCfg
  Left = 0
  Top = 0
  Width = 329
  Height = 260
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    329
    260)
  object Panel2: TPanel
    Left = 4
    Top = 3
    Width = 322
    Height = 254
    Anchors = []
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      322
      254)
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 32
      Height = 13
      Caption = 'Server'
    end
    object Label4: TLabel
      Left = 8
      Top = 52
      Width = 51
      Height = 13
      Caption = 'User name'
    end
    object Label5: TLabel
      Left = 151
      Top = 52
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label3: TLabel
      Left = 8
      Top = 100
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object Label2: TLabel
      Left = 262
      Top = 6
      Width = 20
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Port'
      ExplicitLeft = 247
    end
    object Label6: TLabel
      Left = 8
      Top = 144
      Width = 37
      Height = 13
      Caption = 'Schema'
    end
    object edServer: TEdit
      Left = 8
      Top = 22
      Width = 248
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 233
    end
    object TestConButton: TBitBtn
      Left = 185
      Top = 192
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
      TabOrder = 4
      OnClick = TestConButtonClick
      ExplicitLeft = 174
    end
    object edUserName: TEdit
      Left = 8
      Top = 67
      Width = 137
      Height = 21
      Enabled = False
      TabOrder = 2
    end
    object cbDatabase: TComboBox
      Left = 8
      Top = 115
      Width = 304
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnDropDown = cbDatabaseDropDown
    end
    object edPort: TAdvLUEdit
      Left = 262
      Top = 22
      Width = 50
      Height = 21
      EditType = etNumeric
      EmptyTextStyle = []
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Tahoma'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Anchors = [akTop, akRight]
      Color = clWindow
      TabOrder = 1
      Text = '3306'
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
      ExplicitLeft = 247
    end
    object cbSchema: TComboBox
      Left = 8
      Top = 159
      Width = 304
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 5
      Text = '(all)'
      OnDropDown = cbSchemaDropDown
      Items.Strings = (
        '(all)')
      ExplicitWidth = 289
    end
  end
end
