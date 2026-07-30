object frSQLServer2000Cfg: TfrSQLServer2000Cfg
  Left = 0
  Top = 0
  Width = 542
  Height = 375
  TabOrder = 0
  DesignSize = (
    542
    375)
  object PageControl1: TPageControl
    Left = 111
    Top = 14
    Width = 321
    Height = 347
    ActivePage = TabSheet1
    Anchors = []
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Basic'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 313
        Height = 317
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          313
          317)
        object Panel2: TPanel
          Left = 1
          Top = 33
          Width = 307
          Height = 240
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            307
            240)
          object Label1: TLabel
            Left = 8
            Top = 6
            Width = 261
            Height = 15
            Caption = 'Server name (pick from the list or enter manually)'
          end
          object Label3: TLabel
            Left = 10
            Top = 163
            Width = 81
            Height = 15
            Caption = 'Database name'
          end
          object cboServers: TComboBox
            Left = 8
            Top = 22
            Width = 289
            Height = 23
            TabOrder = 0
            OnClick = cboServersClick
            OnDropDown = cboServersDropDown
          end
          object GroupBox1: TGroupBox
            Left = 8
            Top = 50
            Width = 289
            Height = 107
            Caption = 'Login info'
            TabOrder = 1
            object Label4: TLabel
              Left = 24
              Top = 62
              Width = 56
              Height = 15
              Caption = 'User name'
            end
            object Label5: TLabel
              Left = 154
              Top = 62
              Width = 50
              Height = 15
              Caption = 'Password'
            end
            object rbIntegratedSecurity: TRadioButton
              Left = 8
              Top = 20
              Width = 181
              Height = 17
              Caption = 'Use Windows integrated security'
              Checked = True
              TabOrder = 0
              TabStop = True
              OnClick = rbIntegratedSecurityClick
            end
            object rbLoginInfo: TRadioButton
              Left = 8
              Top = 41
              Width = 237
              Height = 17
              Caption = 'Use a specific user name and password'
              TabOrder = 1
              OnClick = rbLoginInfoClick
            end
            object edUserName: TEdit
              Left = 24
              Top = 76
              Width = 121
              Height = 23
              Enabled = False
              TabOrder = 2
            end
          end
          object cboDatabases: TComboBox
            Left = 8
            Top = 163
            Width = 289
            Height = 23
            TabOrder = 2
            OnDropDown = cboDatabasesDropDown
          end
          object TestConButton: TBitBtn
            Left = 176
            Top = 206
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
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Advanced'
      ImageIndex = 1
      DesignSize = (
        313
        317)
      object Label2: TLabel
        Left = 6
        Top = 8
        Width = 66
        Height = 15
        Caption = 'ODBC Driver'
      end
      object Label6: TLabel
        Left = 6
        Top = 56
        Width = 122
        Height = 15
        Caption = 'Extra ODBC parameters'
        FocusControl = edOdbcAdvanced
      end
      object cbODBCDriver: TComboBox
        Left = 6
        Top = 24
        Width = 299
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnDropDown = cbODBCDriverDropDown
      end
      object edOdbcAdvanced: TEdit
        Left = 6
        Top = 72
        Width = 299
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
    end
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 256
    Top = 176
  end
end
