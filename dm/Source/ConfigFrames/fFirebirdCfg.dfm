object frFirebirdCfg: TfrFirebirdCfg
  Left = 0
  Top = 0
  Width = 419
  Height = 315
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    419
    315)
  object Panel2: TPanel
    Left = 56
    Top = 72
    Width = 307
    Height = 206
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      307
      206)
    object lbServer: TLabel
      Left = 8
      Top = 6
      Width = 61
      Height = 13
      Caption = 'Server name'
    end
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object Label4: TLabel
      Left = 8
      Top = 92
      Width = 51
      Height = 13
      Caption = 'User name'
    end
    object Label5: TLabel
      Left = 151
      Top = 92
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label2: TLabel
      Left = 192
      Top = 6
      Width = 39
      Height = 13
      Caption = 'Protocol'
    end
    object Label1: TLabel
      Left = 8
      Top = 132
      Width = 50
      Height = 13
      Caption = 'Vendor Lib'
    end
    object Label6: TLabel
      Left = 151
      Top = 132
      Width = 38
      Height = 13
      Caption = 'Charset'
    end
    object edServer: TEdit
      Left = 8
      Top = 22
      Width = 178
      Height = 21
      TabOrder = 0
    end
    object TestConButton: TBitBtn
      Left = 176
      Top = 175
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
      TabOrder = 6
      OnClick = TestConButtonClick
    end
    object edUserName: TEdit
      Left = 8
      Top = 107
      Width = 137
      Height = 21
      Enabled = False
      TabOrder = 3
    end
    object edDatabase: TAdvFileNameEdit
      Left = 8
      Top = 65
      Width = 289
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
      Lookup.Font.Name = 'Tahoma'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Color = clWindow
      ShortCut = 0
      TabOrder = 2
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000DDD
        00000077777770DD00000F077777770D00000FF07777777000000FFF00000000
        00000FFFFFFF0DDD00000FFF00000DDD0000D000DDDDD0000000DDDDDDDDDD00
        0000DDDDD0DDD0D00000DDDDDD000DDD0000}
      ReadOnly = False
      FilterIndex = 0
      DialogOptions = []
      DialogKind = fdOpen
    end
    object cbProtocol: TComboBox
      Left = 192
      Top = 22
      Width = 105
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbProtocolChange
    end
    object edVendorLib: TEdit
      Left = 8
      Top = 148
      Width = 137
      Height = 21
      TabOrder = 4
      Text = 'fbclient.dll'
    end
    object cbCharset: TComboBox
      Left = 151
      Top = 148
      Width = 146
      Height = 21
      TabOrder = 5
      Text = 'UTF8'
      OnChange = cbProtocolChange
      Items.Strings = (
        'UTF8'
        'UNICODE_FSS'
        'NONE'
        'ASCII'
        'OCTETS'
        'ISO8859_1'
        'ISO8859_2'
        'ISO8859_3'
        'ISO8859_4'
        'ISO8859_5'
        'ISO8859_6'
        'ISO8859_7'
        'ISO8859_8'
        'ISO8859_9'
        'ISO8859_13'
        'WIN1250'
        'WIN1251'
        'WIN1252'
        'WIN1253'
        'WIN1254'
        'WIN1255'
        'WIN1256'
        'WIN1257'
        'WIN1258'
        'BIG_5'
        'KOI8R'
        'KOI8U'
        'CYRL'
        'KSC_5601'
        'SJIS_0208'
        'SJIS_0208'
        'GB_2312'
        'CP943C'
        'TIS620'
        '')
    end
  end
end
