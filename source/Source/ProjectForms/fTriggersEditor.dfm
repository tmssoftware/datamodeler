object frTriggersEditor: TfrTriggersEditor
  Left = 0
  Top = 0
  Width = 722
  Height = 671
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 722
    Height = 671
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 230
      Top = 0
      Width = 2
      Height = 671
      Beveled = True
      ResizeStyle = rsUpdate
      ExplicitLeft = 164
      ExplicitHeight = 393
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 230
      Height = 671
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 5
      Color = clWhite
      TabOrder = 0
      object lvTriggers: TListView
        Left = 5
        Top = 5
        Width = 198
        Height = 661
        Align = alClient
        Columns = <
          item
            AutoSize = True
          end>
        HideSelection = False
        RowSelect = True
        PopupMenu = popTriggers
        ShowColumnHeaders = False
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvTriggersChange
        OnEdited = lvTriggersEdited
        OnEditing = lvTriggersEditing
        OnKeyDown = lvTriggersKeyDown
      end
      object Panel13: TPanel
        Left = 203
        Top = 5
        Width = 22
        Height = 661
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        DesignSize = (
          22
          661)
        object Bevel4: TBevel
          Left = 254
          Top = 598
          Width = 23
          Height = 2
          Anchors = [akLeft, akBottom]
          ExplicitTop = 308
        end
        object btAddTrigger: TAdvToolButton
          Left = 0
          Top = 0
          Width = 23
          Height = 22
          Hint = 'Add constraint'
          AutoThemeAdapt = False
          Color = clWhite
          ColorDown = 14210002
          ColorHot = 13289415
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4A4A4FFFFFFFFFFFFFFFFFFFFFFFF
            010101A4FFFFFFFFFFFFFFFFFFFFFFFF010101A4FFFFFFFFFFFFFFFFFFFFA4A4
            010101A4A4A4A4FFFFFFFFFFFF010101010101010101A4FFFFFFFFFFFF010101
            010101010101A4FFFFFFFFFFFF010101010101010101FFFFFFFFFFFFFFFFFFFF
            010101FFFFFFFFFFFFFFFFFFFFFFFFFF010101FFFFFFFFFFFFFFFFFFFFFFFFFF
            010101FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          GlyphDisabled.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A6000020400000206000002080000020A0000020C0000020E000004000000040
            20000040400000406000004080000040A0000040C0000040E000006000000060
            20000060400000606000006080000060A0000060C0000060E000008000000080
            20000080400000806000008080000080A0000080C0000080E00000A0000000A0
            200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
            200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
            200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
            20004000400040006000400080004000A0004000C0004000E000402000004020
            20004020400040206000402080004020A0004020C0004020E000404000004040
            20004040400040406000404080004040A0004040C0004040E000406000004060
            20004060400040606000406080004060A0004060C0004060E000408000004080
            20004080400040806000408080004080A0004080C0004080E00040A0000040A0
            200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
            200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
            200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
            20008000400080006000800080008000A0008000C0008000E000802000008020
            20008020400080206000802080008020A0008020C0008020E000804000008040
            20008040400080406000804080008040A0008040C0008040E000806000008060
            20008060400080606000806080008060A0008060C0008060E000808000008080
            20008080400080806000808080008080A0008080C0008080E00080A0000080A0
            200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
            200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
            200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
            2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
            2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
            2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
            2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
            2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
            2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
            2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF070707FFFFFFFFFFFFFFFFFFFFFFFF
            A4A4A407FFFFFFFFFFFFFFFFFFFFFFFFA4A4A407FFFFFFFFFFFFFFFFFFFF0707
            A4A4A407070707FFFFFFFFFFFFA4A4A4A4A4A4A4A4A407FFFFFFFFFFFFA4A4A4
            A4A4A4A4A4A407FFFFFFFFFFFFA4A4A4A4A4A4A4A4A4FFFFFFFFFFFFFFFFFFFF
            A4A4A4FFFFFFFFFFFFFFFFFFFFFFFFFFA4A4A4FFFFFFFFFFFFFFFFFFFFFFFFFF
            A4A4A4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          ImageIndex = 0
          ParentShowHint = False
          Shaded = False
          ShowCaption = False
          ShowHint = True
          OnClick = miAddTriggerClick
          Version = '1.7.2.1'
          TMSStyle = 0
        end
        object btDeleteTrigger: TAdvToolButton
          Left = 0
          Top = 23
          Width = 23
          Height = 22
          AutoThemeAdapt = False
          Color = clWhite
          ColorDown = 14210002
          ColorHot = 13289415
          Glyph.Data = {
            E6000000424DE60000000000000076000000280000000C0000000E0000000100
            0400000000007000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            0000F88FFFFFFFFF0000F188FFFFF88F0000F1188FFFF18F0000F8118FFF81FF
            0000FF1188F118FF0000FF8118811FFF0000FFF11111FFFF0000FFF81118FFFF
            0000F88111188FFF0000F111F81188FF0000FFFFFF81188F0000FFFFFFFF11FF
            0000FFFFFFFFFFFF0000}
          GlyphDisabled.Data = {
            2E020000424D2E0200000000000036000000280000000C0000000E0000000100
            180000000000F801000000000000000000000000000000000000DFDFDFDFDFDF
            DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF
            DFBEBEBEBEBEBEDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF
            DFDFDFDFDF747474BEBEBEBEBEBEDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFBEBEBE
            BEBEBEDFDFDFDFDFDF747474747474BEBEBEBEBEBEDFDFDFDFDFDFDFDFDFDFDF
            DF747474BEBEBEDFDFDFDFDFDFBEBEBE747474747474BEBEBEDFDFDFDFDFDFDF
            DFDFBEBEBE747474DFDFDFDFDFDFDFDFDFDFDFDF747474747474BEBEBEBEBEBE
            DFDFDF747474747474BEBEBEDFDFDFDFDFDFDFDFDFDFDFDFBEBEBE7474747474
            74BEBEBEBEBEBE747474747474DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF74
            7474747474747474747474747474DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF
            DFDFDFBEBEBE747474747474747474BEBEBEDFDFDFDFDFDFDFDFDFDFDFDFDFDF
            DFBEBEBEBEBEBE747474747474747474747474BEBEBEBEBEBEDFDFDFDFDFDFDF
            DFDFDFDFDF747474747474747474DFDFDFBEBEBE747474747474BEBEBEBEBEBE
            DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFBEBEBE7474747474
            74BEBEBEBEBEBEDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF
            DFDF747474747474DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF
            DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF}
          ImageIndex = 0
          ParentShowHint = False
          Shaded = False
          ShowCaption = False
          ShowHint = True
          OnClick = btDeleteTriggerClick
          Version = '1.7.2.1'
          TMSStyle = 0
        end
      end
    end
    object Panel3: TPanel
      Left = 232
      Top = 0
      Width = 490
      Height = 671
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      Color = clWhite
      TabOrder = 1
      object ScrollBox1: TScrollBox
        Left = 5
        Top = 5
        Width = 480
        Height = 661
        HorzScrollBar.Style = ssFlat
        VertScrollBar.Style = ssFlat
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object AdvPanel6: TAdvPanel
          Left = 0
          Top = 0
          Width = 480
          Height = 71
          Align = alTop
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          UseDockManager = True
          Version = '2.7.0.2'
          BorderColor = clBlack
          Caption.ButtonPosition = cbpLeft
          Caption.Color = clHighlight
          Caption.ColorTo = clNone
          Caption.CloseColor = clHighlight
          Caption.Flat = True
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clHighlightText
          Caption.Font.Height = -11
          Caption.Font.Name = 'MS Sans Serif'
          Caption.Font.Style = []
          Caption.Indent = 0
          Caption.MinMaxButton = True
          Caption.ShadeLight = 255
          Caption.ShadeType = stXPCaption
          Caption.Text = 'Trigger properties'
          Caption.TopIndent = 2
          Caption.Visible = True
          CollapsColor = clBtnFace
          CollapsDelay = 0
          DoubleBuffered = True
          StatusBar.Font.Charset = DEFAULT_CHARSET
          StatusBar.Font.Color = clWindowText
          StatusBar.Font.Height = -11
          StatusBar.Font.Name = 'Tahoma'
          StatusBar.Font.Style = []
          Text = ''
          DesignSize = (
            480
            71)
          FullHeight = 68
          object Label3: TLabel
            Tag = 1
            Left = 5
            Top = 25
            Width = 62
            Height = 13
            Caption = 'Trigger name'
            FocusControl = edTriggerName
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label5: TLabel
            Tag = 1
            Left = 131
            Top = 25
            Width = 140
            Height = 13
            AutoSize = False
            Caption = 'Description'
            FocusControl = edDescription
          end
          object edTriggerName: TEdit
            Left = 5
            Top = 40
            Width = 119
            Height = 21
            TabOrder = 0
            OnChange = edTriggerNameChange
          end
          object edDescription: TEdit
            Left = 131
            Top = 40
            Width = 345
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            OnChange = edDescriptionChange
          end
        end
        object AdvPanel2: TAdvPanel
          Left = 0
          Top = 71
          Width = 480
          Height = 20
          Align = alTop
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          UseDockManager = True
          Visible = False
          Version = '2.7.0.2'
          BorderColor = clBlack
          Caption.ButtonPosition = cbpLeft
          Caption.Color = clHighlight
          Caption.ColorTo = clNone
          Caption.CloseColor = clHighlight
          Caption.Flat = True
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clHighlightText
          Caption.Font.Height = -11
          Caption.Font.Name = 'MS Sans Serif'
          Caption.Font.Style = []
          Caption.Indent = 0
          Caption.MinMaxButton = True
          Caption.ShadeLight = 255
          Caption.ShadeType = stXPCaption
          Caption.Text = 'Trigger event'
          Caption.TopIndent = 2
          Caption.Visible = True
          CollapsColor = clBtnFace
          CollapsDelay = 0
          DoubleBuffered = True
          StatusBar.Font.Charset = DEFAULT_CHARSET
          StatusBar.Font.Color = clWindowText
          StatusBar.Font.Height = -11
          StatusBar.Font.Name = 'Tahoma'
          StatusBar.Font.Style = []
          Text = ''
          DesignSize = (
            480
            20)
          FullHeight = 20
          object rgTriggerType: TRadioGroup
            Left = 5
            Top = 22
            Width = 468
            Height = 73
            Anchors = [akLeft, akTop, akRight]
            Columns = 2
            Items.Strings = (
              'Before insert'
              'Before update'
              'Before delete'
              'After insert'
              'After update'
              'After delete')
            TabOrder = 0
          end
        end
        object AdvPanel1: TAdvPanel
          Left = 0
          Top = 91
          Width = 480
          Height = 570
          Align = alClient
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          UseDockManager = True
          Version = '2.7.0.2'
          BorderColor = clBlack
          BorderWidth = 5
          Caption.ButtonPosition = cbpLeft
          Caption.Color = clHighlight
          Caption.ColorTo = clNone
          Caption.CloseColor = clHighlight
          Caption.Flat = True
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clHighlightText
          Caption.Font.Height = -11
          Caption.Font.Name = 'MS Sans Serif'
          Caption.Font.Style = []
          Caption.Indent = 0
          Caption.MinMaxButton = True
          Caption.ShadeLight = 255
          Caption.ShadeType = stXPCaption
          Caption.Text = 'Implementation'
          Caption.TopIndent = 2
          Caption.Visible = True
          CollapsColor = clBtnFace
          CollapsDelay = 0
          DoubleBuffered = True
          StatusBar.Font.Charset = DEFAULT_CHARSET
          StatusBar.Font.Color = clWindowText
          StatusBar.Font.Height = -11
          StatusBar.Font.Name = 'Tahoma'
          StatusBar.Font.Style = []
          Text = ''
          FullHeight = 300
          object Label4: TLabel
            Tag = 4
            Left = 5
            Top = 26
            Width = 31
            Height = 13
            AutoSize = False
            Caption = 'O&rder'
            FocusControl = edOrder
            Visible = False
          end
          object Label7: TLabel
            Tag = 5
            Left = 56
            Top = 26
            Width = 260
            Height = 13
            AutoSize = False
            Caption = 'Condition'
            Visible = False
          end
          object edOrder: TEdit
            Left = 5
            Top = 42
            Width = 46
            Height = 21
            MaxLength = 5
            TabOrder = 1
            Visible = False
            OnKeyPress = edOrderKeyPress
          end
          object chEachRow: TCheckBox
            Left = 5
            Top = 59
            Width = 220
            Height = 17
            Caption = '&For each row'
            TabOrder = 2
            Visible = False
          end
          object mmImplementation: TAdvMemo
            Left = 5
            Top = 23
            Width = 470
            Height = 542
            Cursor = crIBeam
            ActiveLineSettings.ShowActiveLine = False
            ActiveLineSettings.ShowActiveLineIndicator = False
            Align = alClient
            AutoCompletion.Font.Charset = DEFAULT_CHARSET
            AutoCompletion.Font.Color = clWindowText
            AutoCompletion.Font.Height = -11
            AutoCompletion.Font.Name = 'Tahoma'
            AutoCompletion.Font.Style = []
            AutoCompletion.StartToken = '(.'
            AutoCorrect.Active = True
            AutoHintParameterPosition = hpBelowCode
            BookmarkGlyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              0800000000000001000000000000000000000001000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A6000020400000206000002080000020A0000020C0000020E000004000000040
              20000040400000406000004080000040A0000040C0000040E000006000000060
              20000060400000606000006080000060A0000060C0000060E000008000000080
              20000080400000806000008080000080A0000080C0000080E00000A0000000A0
              200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
              200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
              200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
              20004000400040006000400080004000A0004000C0004000E000402000004020
              20004020400040206000402080004020A0004020C0004020E000404000004040
              20004040400040406000404080004040A0004040C0004040E000406000004060
              20004060400040606000406080004060A0004060C0004060E000408000004080
              20004080400040806000408080004080A0004080C0004080E00040A0000040A0
              200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
              200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
              200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
              20008000400080006000800080008000A0008000C0008000E000802000008020
              20008020400080206000802080008020A0008020C0008020E000804000008040
              20008040400080406000804080008040A0008040C0008040E000806000008060
              20008060400080606000806080008060A0008060C0008060E000808000008080
              20008080400080806000808080008080A0008080C0008080E00080A0000080A0
              200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
              200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
              200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
              2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
              2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
              2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
              2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
              2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
              2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
              2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFD25252525
              2525252525252525FDFDFD2E25FFFFFFFFFFFFFFFFFFFF25FDFDFD2525252525
              2525252525252525FDFD9A9AB7B7B7B7B7B7B7B7B7B72525FDFDFD25B7B7B7B7
              B7B7B7B7B7B72525FDFD9A9AB7B7B7B7B7B7B7B7B7B72525FDFDFD25BFB7BFBF
              B7B7B7B7B7B72525FDFD9A9ABFBFBFB7BFBFB7B7B7B72525FDFDFD25BFBFBFBF
              BFB7BFBFB7B72525FDFD9A9ABFBFBFB7BFBFBFB7BFB72525FDFDFD25BFBFBFBF
              BFBFBFBFBFB72525FDFD9A9ABFBFBFBFBFB7BFBFB7B72525FDFDFD25BFBFBFBF
              BFBFBFBFBFB72525FDFD9A9ABFBFBFBFBFBFBFBFBFB725FDFDFDFD2525252525
              25252525252525FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD}
            BorderStyle = bsSingle
            ClipboardFormats = [cfText]
            CodeFolding.Enabled = False
            CodeFolding.LineColor = clGray
            Ctl3D = False
            DelErase = True
            EnhancedHomeKey = False
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -13
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            HiddenCaret = False
            Lines.Strings = (
              '')
            MarkerList.UseDefaultMarkerImageIndex = False
            MarkerList.DefaultMarkerImageIndex = -1
            MarkerList.ImageTransparentColor = 33554432
            OleDropTarget = []
            PrintOptions.MarginLeft = 0
            PrintOptions.MarginRight = 0
            PrintOptions.MarginTop = 0
            PrintOptions.MarginBottom = 0
            PrintOptions.PageNr = False
            PrintOptions.PrintLineNumbers = False
            RightMarginColor = 14869218
            ScrollHint = False
            SelColor = clWhite
            SelBkColor = clNavy
            ShowRightMargin = True
            SmartTabs = False
            SyntaxStyles = AdvSQLMemoStyler1
            TabOrder = 0
            TabStop = True
            TrimTrailingSpaces = False
            UILanguage.ScrollHint = 'Row'
            UILanguage.Undo = 'Undo'
            UILanguage.Redo = 'Redo'
            UILanguage.Copy = 'Copy'
            UILanguage.Cut = 'Cut'
            UILanguage.Paste = 'Paste'
            UILanguage.Delete = 'Delete'
            UILanguage.SelectAll = 'Select All'
            UrlStyle.TextColor = clBlue
            UrlStyle.BkColor = clWhite
            UrlStyle.Style = [fsUnderline]
            UseStyler = True
            Version = '3.9.3.1'
            WordWrap = wwNone
            OnChange = mmImplementationChange
          end
        end
      end
    end
  end
  object popTriggers: TAdvPopupMenu
    MenuStyler = AdvMenuOfficeStyler1
    Version = '2.7.1.19'
    UIStyle = tsCustom
    Left = 20
    Top = 339
    object miAddTrigger: TMenuItem
      Caption = 'Add trigger'
      ImageIndex = 0
      ShortCut = 16455
      OnClick = miAddTriggerClick
    end
    object miDeleteTrigger: TMenuItem
      Caption = 'Remove selected trigger'
      ImageIndex = 3
      OnClick = miDeleteTriggerClick
    end
  end
  object AdvMenuOfficeStyler1: TAdvMenuOfficeStyler
    AntiAlias = aaNone
    AutoThemeAdapt = False
    Style = osOffice2016White
    Background.Position = bpCenter
    Background.Color = clWhite
    Background.ColorTo = clWhite
    ButtonAppearance.DownColor = 14925219
    ButtonAppearance.DownColorTo = 14925219
    ButtonAppearance.HoverColor = 15917525
    ButtonAppearance.HoverColorTo = 15917525
    ButtonAppearance.DownBorderColor = 14925219
    ButtonAppearance.HoverBorderColor = 15917525
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    IconBar.Color = clWhite
    IconBar.ColorTo = clWhite
    IconBar.CheckColor = 15914434
    IconBar.CheckBorder = 15914434
    IconBar.RadioColor = 15917525
    IconBar.RadioBorder = 15917525
    IconBar.SeparatorColor = 13948116
    SelectedItem.Color = 14925219
    SelectedItem.ColorTo = 14925219
    SelectedItem.BorderColor = 14925219
    SelectedItem.Font.Charset = ANSI_CHARSET
    SelectedItem.Font.Color = clWindowText
    SelectedItem.Font.Height = -11
    SelectedItem.Font.Name = 'Tahoma'
    SelectedItem.Font.Style = []
    SelectedItem.NotesFont.Charset = ANSI_CHARSET
    SelectedItem.NotesFont.Color = clWindowText
    SelectedItem.NotesFont.Height = -8
    SelectedItem.NotesFont.Name = 'Tahoma'
    SelectedItem.NotesFont.Style = []
    SelectedItem.CheckColor = 15914434
    SelectedItem.CheckBorder = 15914434
    SelectedItem.RadioColor = 15914434
    SelectedItem.RadioBorder = 15914434
    RootItem.Color = clWhite
    RootItem.ColorTo = clWhite
    RootItem.GradientDirection = gdVertical
    RootItem.Font.Charset = ANSI_CHARSET
    RootItem.Font.Color = 5263440
    RootItem.Font.Height = -11
    RootItem.Font.Name = 'Tahoma'
    RootItem.Font.Style = []
    RootItem.SelectedColor = 14925219
    RootItem.SelectedColorTo = 14925219
    RootItem.SelectedBorderColor = 14925219
    RootItem.HoverColor = 15917525
    RootItem.HoverColorTo = 15917525
    RootItem.HoverBorderColor = 15917525
    RootItem.HoverTextColor = 5263440
    Glyphs.SubMenu.Data = {
      5A000000424D5A000000000000003E0000002800000004000000070000000100
      0100000000001C0000000000000000000000020000000200000000000000FFFF
      FF0070000000300000001000000000000000100000003000000070000000}
    Glyphs.Check.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000F8FF0000F07F0000F23F
      0000F71F0000FF8F0000FFCF0000FFEF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    Glyphs.Radio.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F81F0000F81F
      0000F81F0000F81F0000FC3F0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    SideBar.Font.Charset = DEFAULT_CHARSET
    SideBar.Font.Color = clWhite
    SideBar.Font.Height = -19
    SideBar.Font.Name = 'Tahoma'
    SideBar.Font.Style = [fsBold, fsItalic]
    SideBar.Image.Position = bpCenter
    SideBar.Background.Position = bpCenter
    SideBar.SplitterColorTo = clBlack
    Separator.Color = 13948116
    Separator.ColorTo = 13948116
    Separator.GradientType = gtBoth
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NotesFont.Charset = ANSI_CHARSET
    NotesFont.Color = clGray
    NotesFont.Height = -8
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    MenuBorderColor = 13948116
    Left = 89
    Top = 341
  end
  object AdvSQLMemoStyler1: TAdvSQLMemoStyler
    AutoCompletion.Strings = (
      'SELECT'
      'WHERE')
    HintParameter.TextColor = clBlack
    HintParameter.BkColor = clInfoBk
    HintParameter.HintCharStart = '('
    HintParameter.HintCharEnd = ')'
    HintParameter.HintCharDelimiter = ';'
    HintParameter.HintClassDelimiter = '.'
    HintParameter.HintCharWriteDelimiter = ','
    LineComment = #39
    MultiCommentLeft = '{'
    MultiCommentRight = '}'
    CommentStyle.TextColor = clNavy
    CommentStyle.BkColor = clWhite
    CommentStyle.Style = [fsItalic]
    NumberStyle.TextColor = clFuchsia
    NumberStyle.BkColor = clWhite
    NumberStyle.Style = [fsBold]
    AllStyles = <
      item
        KeyWords.Strings = (
          'and'
          'begin'
          'begin'
          'break'
          'by'
          'close'
          'continue'
          'create'
          'deallocate'
          'declare'
          'delete'
          'delete'
          'do'
          'else'
          'end'
          'end'
          'exec'
          'fetch'
          'for'
          'from'
          'group'
          'having'
          'if'
          'inner'
          'insert'
          'join'
          'left'
          'like'
          'not'
          'on'
          'open'
          'or'
          'order'
          'outer'
          'proc'
          'procedure'
          'repeat'
          'return'
          'right'
          'rollback'
          'select'
          'set'
          'to'
          'trans'
          'transaction'
          'until'
          'update'
          'values'
          'where'
          'while'
          'while')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWhite
        StyleType = stKeyword
        BracketStart = #0
        BracketEnd = #0
        Info = 'SQL Standard Default'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWhite
        StyleType = stBracket
        BracketStart = '"'
        BracketEnd = '"'
        Info = 'Double Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWhite
        StyleType = stSymbol
        BracketStart = #0
        BracketEnd = #0
        Symbols = ' ,;:.(){}[]=-*/^%<>#'#13#10
        Info = 'Symbols Delimiters'
      end>
    Description = 'SQL'
    Filter = 'SQL Files (*.sql)|*.sql'
    DefaultExtension = '.sql'
    StylerName = 'SQL'
    Extensions = 'sql'
    Left = 344
    Top = 184
  end
end
