object fmTableElements: TfmTableElements
  Left = 0
  Top = 0
  Width = 711
  Height = 648
  TabOrder = 0
  OnResize = FrameResize
  object Splitter1: TSplitter
    Left = 700
    Top = 0
    Height = 597
    ExplicitLeft = 352
    ExplicitTop = 272
    ExplicitHeight = 100
  end
  object pnTableElements: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 597
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 5
    FullRepaint = False
    ParentColor = True
    TabOrder = 0
    object pcTable: TPageControl
      Left = 5
      Top = 36
      Width = 690
      Height = 556
      ActivePage = tsCamposTabela
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MultiLine = True
      ParentFont = False
      TabHeight = 20
      TabOrder = 1
      OnChange = pcTableChange
      object tsCamposTabela: TTabSheet
        Caption = 'Fields'
        object PanelFields: TPanel
          Left = 0
          Top = 0
          Width = 682
          Height = 526
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 3
          Color = clWhite
          FullRepaint = False
          ParentBackground = False
          TabOrder = 0
          object Splitter9: TSplitter
            Left = 303
            Top = 3
            Height = 520
            ResizeStyle = rsUpdate
            ExplicitLeft = 300
            ExplicitTop = 0
            ExplicitHeight = 509
          end
          object pnListFields: TPanel
            Left = 3
            Top = 3
            Width = 300
            Height = 520
            Align = alLeft
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 0
            object gCampos: TAdvColumnGrid
              Left = 0
              Top = 0
              Width = 278
              Height = 520
              Align = alClient
              ColCount = 2
              Ctl3D = True
              DefaultRowHeight = 21
              DrawingStyle = gdsClassic
              FixedCols = 0
              RowCount = 5
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing]
              ParentCtl3D = False
              ParentFont = False
              PopupMenu = popFields
              TabOrder = 0
              OnClick = gCamposClick
              OnGetCellColor = gCamposGetCellColor
              OnGetCellBorder = gCamposGetCellBorder
              ActiveCellFont.Charset = DEFAULT_CHARSET
              ActiveCellFont.Color = clWindowText
              ActiveCellFont.Height = -11
              ActiveCellFont.Name = 'Tahoma'
              ActiveCellFont.Style = [fsBold]
              CellNode.TreeColor = clSilver
              ColumnHeaders.Strings = (
                'Field name'
                'Datatype')
              ColumnSize.Stretch = True
              ColumnSize.StretchColumn = 1
              ControlLook.FixedGradientHoverFrom = clGray
              ControlLook.FixedGradientHoverTo = clWhite
              ControlLook.FixedGradientDownFrom = clGray
              ControlLook.FixedGradientDownTo = clSilver
              ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
              ControlLook.DropDownHeader.Font.Color = clWindowText
              ControlLook.DropDownHeader.Font.Height = -11
              ControlLook.DropDownHeader.Font.Name = 'Tahoma'
              ControlLook.DropDownHeader.Font.Style = []
              ControlLook.DropDownHeader.Visible = True
              ControlLook.DropDownHeader.Buttons = <>
              ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
              ControlLook.DropDownFooter.Font.Color = clWindowText
              ControlLook.DropDownFooter.Font.Height = -11
              ControlLook.DropDownFooter.Font.Name = 'Tahoma'
              ControlLook.DropDownFooter.Font.Style = []
              ControlLook.DropDownFooter.Visible = True
              ControlLook.DropDownFooter.Buttons = <>
              ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
              ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
              ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
              ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
              ControlLook.ToggleSwitch.CaptionFont.Height = -12
              ControlLook.ToggleSwitch.CaptionFont.Name = 'Segoe UI'
              ControlLook.ToggleSwitch.CaptionFont.Style = []
              ControlLook.ToggleSwitch.Shadow = False
              Filter = <>
              FilterDropDown.Font.Charset = DEFAULT_CHARSET
              FilterDropDown.Font.Color = clWindowText
              FilterDropDown.Font.Height = -11
              FilterDropDown.Font.Name = 'MS Sans Serif'
              FilterDropDown.Font.Style = []
              FilterDropDown.Height = 200
              FilterDropDown.Width = 200
              FilterDropDownClear = '(All)'
              FilterEdit.TypeNames.Strings = (
                'Starts with'
                'Ends with'
                'Contains'
                'Not contains'
                'Equal'
                'Not equal'
                'Larger than'
                'Smaller than'
                'Clear')
              FixedColWidth = 147
              FixedRowHeight = 22
              FixedFont.Charset = DEFAULT_CHARSET
              FixedFont.Color = clWindowText
              FixedFont.Height = -11
              FixedFont.Name = 'Tahoma'
              FixedFont.Style = [fsBold]
              FloatFormat = '%.2f'
              GridImages = ImageList2
              HoverButtons.Buttons = <>
              HTMLSettings.ImageFolder = 'images'
              HTMLSettings.ImageBaseName = 'img'
              Look = glListView
              PrintSettings.DateFormat = 'dd/mm/yyyy'
              PrintSettings.Font.Charset = DEFAULT_CHARSET
              PrintSettings.Font.Color = clWindowText
              PrintSettings.Font.Height = -11
              PrintSettings.Font.Name = 'MS Sans Serif'
              PrintSettings.Font.Style = []
              PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
              PrintSettings.FixedFont.Color = clWindowText
              PrintSettings.FixedFont.Height = -11
              PrintSettings.FixedFont.Name = 'MS Sans Serif'
              PrintSettings.FixedFont.Style = []
              PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
              PrintSettings.HeaderFont.Color = clWindowText
              PrintSettings.HeaderFont.Height = -11
              PrintSettings.HeaderFont.Name = 'MS Sans Serif'
              PrintSettings.HeaderFont.Style = []
              PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
              PrintSettings.FooterFont.Color = clWindowText
              PrintSettings.FooterFont.Height = -11
              PrintSettings.FooterFont.Name = 'MS Sans Serif'
              PrintSettings.FooterFont.Style = []
              PrintSettings.PageNumSep = '/'
              ScrollWidth = 16
              SearchFooter.Color = clBtnFace
              SearchFooter.FindNextCaption = 'Find &next'
              SearchFooter.FindPrevCaption = 'Find &previous'
              SearchFooter.Font.Charset = DEFAULT_CHARSET
              SearchFooter.Font.Color = clWindowText
              SearchFooter.Font.Height = -11
              SearchFooter.Font.Name = 'Tahoma'
              SearchFooter.Font.Style = []
              SearchFooter.HighLightCaption = 'Highlight'
              SearchFooter.HintClose = 'Close'
              SearchFooter.HintFindNext = 'Find next occurence'
              SearchFooter.HintFindPrev = 'Find previous occurence'
              SearchFooter.HintHighlight = 'Highlight occurences'
              SearchFooter.MatchCaseCaption = 'Match case'
              SearchFooter.ResultFormat = '(%d of %d)'
              SelectionColor = clHighlight
              SelectionTextColor = clHighlightText
              Version = '3.2.1.2'
              WordWrap = False
              Columns = <
                item
                  AutoMinSize = 0
                  AutoMaxSize = 0
                  Alignment = taLeftJustify
                  Borders = []
                  BorderPen.Color = clSilver
                  ButtonHeight = 18
                  CheckFalse = 'N'
                  CheckTrue = 'Y'
                  Color = clWindow
                  ColumnPopupType = cpFixedCellsRClick
                  DropDownCount = 8
                  EditLength = 0
                  Editor = edNone
                  FilterCaseSensitive = False
                  Fixed = False
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  Header = 'Field name'
                  HeaderAlignment = taLeftJustify
                  HeaderFont.Charset = DEFAULT_CHARSET
                  HeaderFont.Color = clWindowText
                  HeaderFont.Height = -11
                  HeaderFont.Name = 'Tahoma'
                  HeaderFont.Style = []
                  MinSize = 0
                  MaxSize = 0
                  Password = False
                  PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                  PrintColor = clWhite
                  PrintFont.Charset = DEFAULT_CHARSET
                  PrintFont.Color = clWindowText
                  PrintFont.Height = -11
                  PrintFont.Name = 'Tahoma'
                  PrintFont.Style = []
                  ReadOnly = False
                  ShowBands = False
                  SortStyle = ssAutomatic
                  SpinMax = 0
                  SpinMin = 0
                  SpinStep = 1
                  Tag = 0
                  Width = 147
                end
                item
                  AutoMinSize = 0
                  AutoMaxSize = 0
                  Alignment = taLeftJustify
                  Borders = []
                  BorderPen.Color = clSilver
                  ButtonHeight = 18
                  CheckFalse = 'N'
                  CheckTrue = 'Y'
                  Color = clWindow
                  ColumnPopupType = cpFixedCellsRClick
                  DropDownCount = 8
                  EditLength = 0
                  Editor = edNone
                  FilterCaseSensitive = False
                  Fixed = False
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  Header = 'Datatype'
                  HeaderAlignment = taLeftJustify
                  HeaderFont.Charset = DEFAULT_CHARSET
                  HeaderFont.Color = clWindowText
                  HeaderFont.Height = -11
                  HeaderFont.Name = 'Tahoma'
                  HeaderFont.Style = []
                  MinSize = 0
                  MaxSize = 0
                  Password = False
                  PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                  PrintColor = clWhite
                  PrintFont.Charset = DEFAULT_CHARSET
                  PrintFont.Color = clWindowText
                  PrintFont.Height = -11
                  PrintFont.Name = 'Tahoma'
                  PrintFont.Style = []
                  ReadOnly = False
                  ShowBands = False
                  SortStyle = ssAutomatic
                  SpinMax = 0
                  SpinMin = 0
                  SpinStep = 1
                  Tag = 0
                  Width = 127
                end>
              ExplicitTop = 6
              ColWidths = (
                147
                127)
            end
            object Panel2: TPanel
              Left = 278
              Top = 0
              Width = 22
              Height = 520
              Align = alRight
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              DesignSize = (
                22
                520)
              object AdvToolButton1: TAdvToolButton
                Left = 0
                Top = 23
                Width = 23
                Height = 22
                Action = acField_remove
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
                ImageIndex = 2
                ParentShowHint = False
                Shaded = False
                ShowCaption = False
                ShowHint = True
                Version = '1.7.2.1'
                TMSStyle = 0
              end
              object Bevel1: TBevel
                Left = 254
                Top = -283
                Width = 23
                Height = 2
                Anchors = [akLeft, akBottom]
                ExplicitTop = 194
              end
              object AdvToolButton2: TAdvToolButton
                Left = 0
                Top = 45
                Width = 23
                Height = 22
                Action = acMoveUp
                AutoThemeAdapt = False
                Color = clWhite
                ColorDown = 14210002
                ColorHot = 13289415
                Glyph.Data = {
                  F6000000424DF60000000000000076000000280000000F000000100000000100
                  04000000000080000000CE0E0000D80E00001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                  7770777777777777777077777777777777707788778888777770791879111187
                  7770799779999118777077777777911877707777777791187770777777779118
                  7770777777779118777077777777911888707777779111111770777777791111
                  7770777777779117777077777777797777707777777777777770}
                GlyphDisabled.Data = {
                  F6000000424DF60000000000000076000000280000000F000000100000000100
                  0400000000008000000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                  7770777777777777777077777777777777707777777777777770788778888877
                  7770788778888887777077777777888777707777777788877770777777778887
                  7770777777778887777077777777888777707777778888888770777777788888
                  7770777777778887777077777777787777707777777777777770}
                ImageIndex = 4
                ParentShowHint = False
                Shaded = False
                ShowCaption = False
                ShowHint = True
                Version = '1.7.2.1'
                TMSStyle = 0
              end
              object AdvToolButton3: TAdvToolButton
                Left = 0
                Top = 67
                Width = 23
                Height = 22
                Action = acMoveDown
                AutoThemeAdapt = False
                Color = clWhite
                ColorDown = 14210002
                ColorHot = 13289415
                Glyph.Data = {
                  F6000000424DF60000000000000076000000280000000F000000100000000100
                  04000000000080000000CE0E0000D80E00001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                  7770777777777977777077777777911777707777777911117770777777911111
                  1770777777779118887077777777911877707777777791187770777777779118
                  7770777777779118777079977999911877707918791111877770778877888877
                  7770777777777777777077777777777777707777777777777770}
                GlyphDisabled.Data = {
                  F6000000424DF60000000000000076000000280000000F000000100000000100
                  0400000000008000000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                  7770777777777877777077777777888777707777777888887770777777888888
                  8770777777778887777077777777888777707777777788877770777777778887
                  7770777777778887777078877888888777707887788888777770777777777777
                  7770777777777777777077777777777777707777777777777770}
                ImageIndex = 5
                ParentShowHint = False
                Shaded = False
                ShowCaption = False
                ShowHint = True
                Version = '1.7.2.1'
                TMSStyle = 0
              end
              object btNewField: TAdvToolButton
                Left = 0
                Top = 1
                Width = 23
                Height = 22
                Hint = 'Add field'
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
                OnClick = miAddFieldClick
                Version = '1.7.2.1'
                TMSStyle = 0
              end
            end
          end
          object pcFieldDetails: TPageControl
            Left = 306
            Top = 3
            Width = 373
            Height = 520
            ActivePage = tsFieldMain
            Align = alClient
            Constraints.MinWidth = 300
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            MultiLine = True
            ParentFont = False
            TabHeight = 20
            TabOrder = 1
            object tsFieldMain: TTabSheet
              Caption = 'Properties'
              object FieldPanel: TPanel
                Left = 0
                Top = 0
                Width = 365
                Height = 490
                Align = alClient
                BevelOuter = bvNone
                BorderWidth = 5
                Color = clWhite
                Constraints.MinWidth = 325
                ParentBackground = False
                TabOrder = 0
                object ScrollBox1: TScrollBox
                  Left = 5
                  Top = 5
                  Width = 355
                  Height = 480
                  HorzScrollBar.Style = ssFlat
                  VertScrollBar.Style = ssFlat
                  Align = alClient
                  BorderStyle = bsNone
                  ParentBackground = True
                  TabOrder = 0
                  object AdvPanel2: TPanel
                    Left = 0
                    Top = 0
                    Width = 355
                    Height = 165
                    Align = alTop
                    BevelOuter = bvNone
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentBackground = False
                    ParentColor = True
                    ParentFont = False
                    TabOrder = 0
                    DesignSize = (
                      355
                      165)
                    object Label11: TLabel
                      Left = 0
                      Top = 0
                      Width = 51
                      Height = 13
                      Caption = 'F&ield name'
                      FocusControl = edFieldName
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -11
                      Font.Name = 'MS Sans Serif'
                      Font.Style = []
                      ParentFont = False
                    end
                    object Label6: TLabel
                      Left = 0
                      Top = 80
                      Width = 76
                      Height = 13
                      AutoSize = False
                      Caption = '&Logic type'
                    end
                    object lbTipoFisico: TLabel
                      Left = 0
                      Top = 120
                      Width = 63
                      Height = 13
                      Caption = 'Physical type'
                      FocusControl = edTipoFisico
                    end
                    object Label7: TLabel
                      Left = 0
                      Top = 40
                      Width = 35
                      Height = 13
                      Caption = 'Do&main'
                      FocusControl = cbDomain
                    end
                    object Label8: TLabel
                      Left = 241
                      Top = 80
                      Width = 19
                      Height = 13
                      Anchors = [akTop, akRight]
                      Caption = '&Size'
                      ExplicitLeft = 235
                    end
                    object Label4: TLabel
                      Left = 301
                      Top = 80
                      Width = 42
                      Height = 13
                      Anchors = [akTop, akRight]
                      Caption = 'Precision'
                      ExplicitLeft = 295
                    end
                    object lbComputedExpr: TLabel
                      Left = 0
                      Top = 120
                      Width = 77
                      Height = 13
                      Caption = 'Field expression'
                      FocusControl = edComputedExpr
                      Visible = False
                    end
                    object Label13: TLabel
                      Left = 170
                      Top = 0
                      Width = 36
                      Height = 13
                      Caption = 'C&aption'
                      FocusControl = edFieldCaption
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -11
                      Font.Name = 'MS Sans Serif'
                      Font.Style = []
                      ParentFont = False
                    end
                    object edComputedExpr: TEdit
                      Left = 0
                      Top = 135
                      Width = 351
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 8
                      Visible = False
                      OnChange = GravaPropriedade
                    end
                    object edTipoFisico: TEdit
                      Left = 0
                      Top = 135
                      Width = 351
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      Color = clBtnFace
                      Enabled = False
                      TabOrder = 7
                      OnChange = GravaPropriedade
                    end
                    object edFieldName: TEdit
                      Left = 0
                      Top = 15
                      Width = 160
                      Height = 21
                      TabOrder = 0
                      OnChange = GravaPropriedade
                    end
                    object cbDomain: TComboBox
                      Left = 0
                      Top = 55
                      Width = 231
                      Height = 21
                      Style = csDropDownList
                      Anchors = [akLeft, akTop, akRight]
                      DropDownCount = 12
                      TabOrder = 2
                      OnChange = cbDomainChange
                    end
                    object chPrimaryKey: TCheckBox
                      Left = 241
                      Top = 58
                      Width = 89
                      Height = 15
                      Anchors = [akTop, akRight]
                      Caption = 'Primary &key'
                      TabOrder = 3
                      OnClick = GravaPropriedade
                    end
                    object edTamanhoCampo: TAdvLUEdit
                      Left = 241
                      Top = 95
                      Width = 50
                      Height = 21
                      EditAlign = eaRight
                      EditType = etNumeric
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
                      Lookup.Font.Name = 'Tahoma'
                      Lookup.Font.Style = []
                      Lookup.Separator = ';'
                      Anchors = [akTop, akRight]
                      Color = clWindow
                      TabOrder = 5
                      Text = '0'
                      Visible = True
                      OnChange = GravaPropriedade
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
                    end
                    object edPrecision: TAdvLUEdit
                      Left = 301
                      Top = 95
                      Width = 50
                      Height = 21
                      EditAlign = eaRight
                      EditType = etNumeric
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
                      Lookup.Font.Name = 'Tahoma'
                      Lookup.Font.Style = []
                      Lookup.Separator = ';'
                      Anchors = [akTop, akRight]
                      Color = clWindow
                      TabOrder = 6
                      Text = '0'
                      Visible = True
                      OnChange = GravaPropriedade
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
                    end
                    object cbTipoCampo: TComboBox
                      Left = 0
                      Top = 95
                      Width = 231
                      Height = 21
                      Style = csDropDownList
                      Anchors = [akLeft, akTop, akRight]
                      DropDownCount = 12
                      Sorted = True
                      TabOrder = 4
                      OnChange = GravaPropriedade
                    end
                    object edFieldCaption: TEdit
                      Left = 170
                      Top = 15
                      Width = 181
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 1
                      OnChange = GravaPropriedade
                    end
                  end
                  object gbFieldCheckConstraint: TPanel
                    Left = 0
                    Top = 233
                    Width = 355
                    Height = 75
                    Align = alTop
                    BevelOuter = bvNone
                    FullRepaint = False
                    ParentBackground = False
                    ParentColor = True
                    TabOrder = 2
                    DesignSize = (
                      355
                      75)
                    object Label14: TLabel
                      Left = 25
                      Top = 23
                      Width = 58
                      Height = 13
                      Caption = 'Check expr.'
                      FocusControl = edFieldCExpr
                    end
                    object lbFieldCName: TLabel
                      Left = 25
                      Top = 47
                      Width = 79
                      Height = 13
                      Caption = 'Constraint name'
                      FocusControl = edFieldCName
                    end
                    object Label2: TLabel
                      Left = 0
                      Top = 0
                      Width = 80
                      Height = 13
                      Caption = 'Check constraint'
                    end
                    object Bevel5: TBevel
                      Left = 92
                      Top = 6
                      Width = 249
                      Height = 2
                      Anchors = [akLeft, akTop, akRight]
                      ExplicitWidth = 327
                    end
                    object edFieldCExpr: TEdit
                      Left = 113
                      Top = 19
                      Width = 142
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 0
                      OnChange = GravaPropriedade
                    end
                    object edFieldCName: TEdit
                      Left = 113
                      Top = 43
                      Width = 142
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 2
                      OnChange = GravaPropriedade
                    end
                    object chSpecificConstraint: TCheckBox
                      Left = 268
                      Top = 22
                      Width = 61
                      Height = 16
                      Anchors = [akTop, akRight]
                      Caption = 'Specific'
                      TabOrder = 1
                      OnClick = chSpecificConstraintClick
                    end
                  end
                  object gbDefaultConstraint: TPanel
                    Left = 0
                    Top = 308
                    Width = 355
                    Height = 68
                    Align = alTop
                    BevelOuter = bvNone
                    FullRepaint = False
                    ParentBackground = False
                    ParentColor = True
                    TabOrder = 3
                    DesignSize = (
                      355
                      68)
                    object Label62: TLabel
                      Left = 25
                      Top = 20
                      Width = 64
                      Height = 13
                      Caption = 'Default value'
                    end
                    object lbFieldDefaultConstraint: TLabel
                      Left = 25
                      Top = 43
                      Width = 79
                      Height = 13
                      Caption = 'Constraint name'
                      FocusControl = edFieldDefaultConstraint
                    end
                    object Label3: TLabel
                      Left = 0
                      Top = 0
                      Width = 64
                      Height = 13
                      Caption = 'Default value'
                    end
                    object Bevel6: TBevel
                      Left = 79
                      Top = 5
                      Width = 263
                      Height = 2
                      Anchors = [akLeft, akTop, akRight]
                      ExplicitWidth = 341
                    end
                    object edFieldDefaultValue: TEdit
                      Left = 113
                      Top = 16
                      Width = 142
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 0
                      OnChange = GravaPropriedade
                    end
                    object edFieldDefaultConstraint: TEdit
                      Left = 113
                      Top = 40
                      Width = 142
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 2
                      OnChange = GravaPropriedade
                    end
                    object chSpecificDefaultValue: TCheckBox
                      Left = 267
                      Top = 19
                      Width = 57
                      Height = 16
                      Anchors = [akTop, akRight]
                      Caption = 'Specific'
                      TabOrder = 1
                      OnClick = chSpecificDefaultValueClick
                    end
                  end
                  object gbNotNullConstraint: TPanel
                    Left = 0
                    Top = 165
                    Width = 355
                    Height = 68
                    Align = alTop
                    BevelOuter = bvNone
                    ParentBackground = False
                    ParentColor = True
                    TabOrder = 1
                    DesignSize = (
                      355
                      68)
                    object lbFieldNotNullConstraint: TLabel
                      Left = 25
                      Top = 46
                      Width = 79
                      Height = 13
                      Caption = 'Constraint name'
                      FocusControl = edFieldNotNullConstraint
                    end
                    object Label1: TLabel
                      Left = 0
                      Top = 0
                      Width = 87
                      Height = 13
                      Caption = 'Not null constraint'
                    end
                    object Bevel4: TBevel
                      Left = 105
                      Top = 5
                      Width = 237
                      Height = 2
                      Anchors = [akLeft, akTop, akRight]
                      ExplicitWidth = 315
                    end
                    object chFieldNotNull: TCheckBox
                      Left = 25
                      Top = 20
                      Width = 72
                      Height = 16
                      Caption = '&Not null'
                      TabOrder = 0
                      OnClick = GravaPropriedade
                    end
                    object edFieldNotNullConstraint: TEdit
                      Left = 113
                      Top = 41
                      Width = 133
                      Height = 21
                      Anchors = [akLeft, akTop, akRight]
                      TabOrder = 1
                      OnChange = GravaPropriedade
                    end
                    object chSpecificRequired: TCheckBox
                      Left = 267
                      Top = 20
                      Width = 61
                      Height = 16
                      Anchors = [akTop, akRight]
                      Caption = 'Specific'
                      TabOrder = 2
                      OnClick = chSpecificRequiredClick
                    end
                  end
                  object pnAutoIncrement: TPanel
                    Left = 0
                    Top = 376
                    Width = 355
                    Height = 63
                    Align = alTop
                    BevelOuter = bvNone
                    FullRepaint = False
                    ParentBackground = False
                    ParentColor = True
                    TabOrder = 4
                    Visible = False
                    DesignSize = (
                      355
                      63)
                    object Label16: TLabel
                      Left = 25
                      Top = 18
                      Width = 88
                      Height = 13
                      Caption = 'Seed (initial value)'
                    end
                    object Label17: TLabel
                      Left = 145
                      Top = 18
                      Width = 49
                      Height = 13
                      Caption = 'Increment'
                    end
                    object Label5: TLabel
                      Left = 0
                      Top = 0
                      Width = 38
                      Height = 13
                      Caption = 'Identity'
                    end
                    object Bevel7: TBevel
                      Left = 50
                      Top = 5
                      Width = 292
                      Height = 2
                      Anchors = [akLeft, akTop, akRight]
                      ExplicitWidth = 370
                    end
                    object edSeed: TAdvLUEdit
                      Left = 25
                      Top = 33
                      Width = 112
                      Height = 21
                      EditAlign = eaRight
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
                      Color = clWindow
                      TabOrder = 0
                      Text = '0'
                      Visible = True
                      OnChange = GravaPropriedade
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
                    end
                    object edIncrement: TAdvLUEdit
                      Left = 145
                      Top = 33
                      Width = 89
                      Height = 21
                      EditAlign = eaRight
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
                      Color = clWindow
                      TabOrder = 1
                      Text = '0'
                      Visible = True
                      OnChange = GravaPropriedade
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
                    end
                  end
                end
              end
            end
            object tsFieldDescription: TTabSheet
              BorderWidth = 5
              Caption = 'Description'
              ImageIndex = 1
              object mFieldComments: TMemo
                Left = 0
                Top = 0
                Width = 355
                Height = 480
                Align = alClient
                TabOrder = 0
                OnChange = GravaPropriedade
              end
            end
          end
        end
      end
      object tsIndicesTabela: TTabSheet
        Caption = 'Indexes'
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 682
          Height = 526
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          FullRepaint = False
          ParentBackground = False
          TabOrder = 0
          ExplicitHeight = 564
          object Splitter3: TSplitter
            Left = 230
            Top = 0
            Width = 2
            Height = 526
            Beveled = True
            ResizeStyle = rsUpdate
            ExplicitHeight = 510
          end
          object Panel8: TPanel
            Left = 0
            Top = 0
            Width = 230
            Height = 526
            Align = alLeft
            BevelOuter = bvNone
            BorderWidth = 3
            Color = clWhite
            TabOrder = 0
            object lvIndices: TListView
              Left = 3
              Top = 3
              Width = 202
              Height = 520
              Align = alClient
              Columns = <
                item
                  AutoSize = True
                end>
              DragMode = dmAutomatic
              HideSelection = False
              RowSelect = True
              PopupMenu = popIndexes
              ShowColumnHeaders = False
              SmallImages = ImageList2
              TabOrder = 0
              ViewStyle = vsReport
              OnChange = lvIndicesChange
              OnEdited = lvIndicesEdited
            end
            object Panel4: TPanel
              Left = 205
              Top = 3
              Width = 22
              Height = 520
              Align = alRight
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              DesignSize = (
                22
                520)
              object AdvToolButton5: TAdvToolButton
                Left = 0
                Top = 21
                Width = 23
                Height = 22
                Action = acIndex_RemoveIndex
                AutoThemeAdapt = False
                Color = clWhite
                ColorDown = 14210002
                ColorHot = 13289415
                Glyph.Data = {
                  2E020000424D2E0200000000000036000000280000000C0000000E0000000100
                  180000000000F801000000000000000000000000000000000000FFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFF00007BBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD
                  BDBDBDFFFFFFFFFFFF00007B00007BBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFF
                  FF00007BBDBDBDFFFFFFFFFFFFBDBDBD00007B00007BBDBDBDFFFFFFFFFFFFFF
                  FFFFBDBDBD00007BFFFFFFFFFFFFFFFFFFFFFFFF00007B00007BBDBDBDBDBDBD
                  FFFFFF00007B00007BBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD00007B0000
                  7BBDBDBDBDBDBD00007B00007BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                  007B00007B00007B00007B00007BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFBDBDBD00007B00007B00007BBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFBDBDBDBDBDBD00007B00007B00007B00007BBDBDBDBDBDBDFFFFFFFFFFFFFF
                  FFFFFFFFFF00007B00007B00007BFFFFFFBDBDBD00007B00007BBDBDBDBDBDBD
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD00007B0000
                  7BBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFF00007B00007BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                  FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
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
                ImageIndex = 2
                Shaded = False
                ShowCaption = False
                Version = '1.7.2.1'
                TMSStyle = 0
              end
              object Bevel2: TBevel
                Left = 254
                Top = 337
                Width = 23
                Height = 2
                Anchors = [akLeft, akBottom]
                ExplicitTop = 308
              end
              object btNewIndex: TAdvToolButton
                Left = 0
                Top = 0
                Width = 23
                Height = 22
                Hint = 'Add index'
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
                OnClick = miAddIndexClick
                Version = '1.7.2.1'
                TMSStyle = 0
              end
            end
          end
          object atPanel2: TPanel
            Left = 232
            Top = 0
            Width = 450
            Height = 526
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 5
            Color = clWhite
            TabOrder = 1
            ExplicitHeight = 564
            object ScrollBox2: TScrollBox
              Left = 5
              Top = 5
              Width = 440
              Height = 516
              HorzScrollBar.Style = ssFlat
              VertScrollBar.Style = ssFlat
              Align = alClient
              BevelOuter = bvNone
              BorderStyle = bsNone
              TabOrder = 0
              ExplicitHeight = 554
              object AdvPanel5: TAdvPanel
                Left = 0
                Top = 74
                Width = 440
                Height = 282
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
                Caption.Text = 'Index fields'
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
                  440
                  282)
                FullHeight = 357
                object Panel9: TPanel
                  Left = 7
                  Top = 28
                  Width = 423
                  Height = 242
                  Anchors = [akLeft, akTop, akRight, akBottom]
                  BevelOuter = bvNone
                  TabOrder = 0
                  object Panel10: TPanel
                    Left = 0
                    Top = 206
                    Width = 423
                    Height = 36
                    Align = alBottom
                    BevelOuter = bvNone
                    Color = clWhite
                    TabOrder = 0
                    DesignSize = (
                      423
                      36)
                    object Button1: TButton
                      Left = 183
                      Top = 6
                      Width = 103
                      Height = 25
                      Action = acIndex_AddField
                      Anchors = [akTop, akRight]
                      Caption = '&Add field to index'
                      TabOrder = 0
                    end
                    object Button2: TButton
                      Left = 290
                      Top = 6
                      Width = 133
                      Height = 25
                      Action = acIndex_RemoveField
                      Anchors = [akTop, akRight]
                      Caption = '&Remove field from index'
                      TabOrder = 1
                    end
                  end
                  object gCamposIndice: TAdvColumnGrid
                    Left = 0
                    Top = 0
                    Width = 423
                    Height = 206
                    Align = alClient
                    ColCount = 2
                    Ctl3D = True
                    DefaultRowHeight = 21
                    DrawingStyle = gdsClassic
                    FixedCols = 0
                    RowCount = 2
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -11
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    GridLineWidth = 0
                    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing]
                    ParentCtl3D = False
                    ParentFont = False
                    PopupMenu = popIndexFields
                    TabOrder = 1
                    OnGetEditText = gCamposIndiceGetEditText
                    OnKeyDown = gCamposIndiceKeyDown
                    OnSetEditText = gCamposIndiceSetEditText
                    ActiveCellFont.Charset = DEFAULT_CHARSET
                    ActiveCellFont.Color = clWindowText
                    ActiveCellFont.Height = -11
                    ActiveCellFont.Name = 'Tahoma'
                    ActiveCellFont.Style = [fsBold]
                    CellNode.TreeColor = clSilver
                    ColumnHeaders.Strings = (
                      'Index fields (name)'
                      'Order')
                    ColumnSize.Stretch = True
                    ColumnSize.StretchColumn = 0
                    ControlLook.FixedGradientHoverFrom = clGray
                    ControlLook.FixedGradientHoverTo = clWhite
                    ControlLook.FixedGradientDownFrom = clGray
                    ControlLook.FixedGradientDownTo = clSilver
                    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
                    ControlLook.DropDownHeader.Font.Color = clWindowText
                    ControlLook.DropDownHeader.Font.Height = -11
                    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
                    ControlLook.DropDownHeader.Font.Style = []
                    ControlLook.DropDownHeader.Visible = True
                    ControlLook.DropDownHeader.Buttons = <>
                    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
                    ControlLook.DropDownFooter.Font.Color = clWindowText
                    ControlLook.DropDownFooter.Font.Height = -11
                    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
                    ControlLook.DropDownFooter.Font.Style = []
                    ControlLook.DropDownFooter.Visible = True
                    ControlLook.DropDownFooter.Buttons = <>
                    ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
                    ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
                    ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
                    ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
                    ControlLook.ToggleSwitch.CaptionFont.Height = -12
                    ControlLook.ToggleSwitch.CaptionFont.Name = 'Segoe UI'
                    ControlLook.ToggleSwitch.CaptionFont.Style = []
                    ControlLook.ToggleSwitch.Shadow = False
                    Filter = <>
                    FilterDropDown.Font.Charset = DEFAULT_CHARSET
                    FilterDropDown.Font.Color = clWindowText
                    FilterDropDown.Font.Height = -11
                    FilterDropDown.Font.Name = 'MS Sans Serif'
                    FilterDropDown.Font.Style = []
                    FilterDropDown.Height = 200
                    FilterDropDown.Width = 200
                    FilterDropDownClear = '(All)'
                    FilterEdit.TypeNames.Strings = (
                      'Starts with'
                      'Ends with'
                      'Contains'
                      'Not contains'
                      'Equal'
                      'Not equal'
                      'Larger than'
                      'Smaller than'
                      'Clear')
                    FixedColWidth = 302
                    FixedRowHeight = 22
                    FixedFont.Charset = DEFAULT_CHARSET
                    FixedFont.Color = clWindowText
                    FixedFont.Height = -11
                    FixedFont.Name = 'Tahoma'
                    FixedFont.Style = [fsBold]
                    FloatFormat = '%.2f'
                    HoverButtons.Buttons = <>
                    HTMLSettings.ImageFolder = 'images'
                    HTMLSettings.ImageBaseName = 'img'
                    Look = glListView
                    PrintSettings.DateFormat = 'dd/mm/yyyy'
                    PrintSettings.Font.Charset = DEFAULT_CHARSET
                    PrintSettings.Font.Color = clWindowText
                    PrintSettings.Font.Height = -11
                    PrintSettings.Font.Name = 'MS Sans Serif'
                    PrintSettings.Font.Style = []
                    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
                    PrintSettings.FixedFont.Color = clWindowText
                    PrintSettings.FixedFont.Height = -11
                    PrintSettings.FixedFont.Name = 'MS Sans Serif'
                    PrintSettings.FixedFont.Style = []
                    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
                    PrintSettings.HeaderFont.Color = clWindowText
                    PrintSettings.HeaderFont.Height = -11
                    PrintSettings.HeaderFont.Name = 'MS Sans Serif'
                    PrintSettings.HeaderFont.Style = []
                    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
                    PrintSettings.FooterFont.Color = clWindowText
                    PrintSettings.FooterFont.Height = -11
                    PrintSettings.FooterFont.Name = 'MS Sans Serif'
                    PrintSettings.FooterFont.Style = []
                    PrintSettings.PageNumSep = '/'
                    ScrollWidth = 16
                    SearchFooter.Color = clBtnFace
                    SearchFooter.FindNextCaption = 'Find &next'
                    SearchFooter.FindPrevCaption = 'Find &previous'
                    SearchFooter.Font.Charset = DEFAULT_CHARSET
                    SearchFooter.Font.Color = clWindowText
                    SearchFooter.Font.Height = -11
                    SearchFooter.Font.Name = 'Tahoma'
                    SearchFooter.Font.Style = []
                    SearchFooter.HighLightCaption = 'Highlight'
                    SearchFooter.HintClose = 'Close'
                    SearchFooter.HintFindNext = 'Find next occurence'
                    SearchFooter.HintFindPrev = 'Find previous occurence'
                    SearchFooter.HintHighlight = 'Highlight occurences'
                    SearchFooter.MatchCaseCaption = 'Match case'
                    SearchFooter.ResultFormat = '(%d of %d)'
                    SelectionColor = clHighlight
                    SelectionTextColor = clHighlightText
                    Version = '3.2.1.2'
                    Columns = <
                      item
                        AutoMinSize = 0
                        AutoMaxSize = 0
                        Alignment = taLeftJustify
                        Borders = []
                        BorderPen.Color = clSilver
                        ButtonHeight = 18
                        CheckFalse = 'N'
                        CheckTrue = 'Y'
                        Color = clWindow
                        ColumnPopupType = cpFixedCellsRClick
                        ComboItems.Strings = (
                          'a'
                          'b'
                          'c'
                          'd'
                          'e')
                        DropDownCount = 8
                        EditLength = 0
                        Editor = edComboList
                        FilterCaseSensitive = False
                        Fixed = False
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clWindowText
                        Font.Height = -11
                        Font.Name = 'Tahoma'
                        Font.Style = []
                        Header = 'Index fields (name)'
                        HeaderAlignment = taLeftJustify
                        HeaderFont.Charset = DEFAULT_CHARSET
                        HeaderFont.Color = clWindowText
                        HeaderFont.Height = -11
                        HeaderFont.Name = 'Tahoma'
                        HeaderFont.Style = []
                        MinSize = 0
                        MaxSize = 0
                        Password = False
                        PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                        PrintColor = clWhite
                        PrintFont.Charset = DEFAULT_CHARSET
                        PrintFont.Color = clWindowText
                        PrintFont.Height = -11
                        PrintFont.Name = 'Tahoma'
                        PrintFont.Style = []
                        ReadOnly = False
                        ShowBands = False
                        SortStyle = ssAutomatic
                        SpinMax = 0
                        SpinMin = 0
                        SpinStep = 1
                        Tag = 0
                        Width = 302
                      end
                      item
                        AutoMinSize = 0
                        AutoMaxSize = 0
                        Alignment = taLeftJustify
                        Borders = []
                        BorderPen.Color = clSilver
                        ButtonHeight = 18
                        CheckFalse = 'N'
                        CheckTrue = 'Y'
                        Color = clWindow
                        ColumnPopupType = cpFixedCellsRClick
                        ComboItems.Strings = (
                          'Asc'
                          'Desc')
                        DropDownCount = 8
                        EditLength = 0
                        Editor = edComboList
                        FilterCaseSensitive = False
                        Fixed = False
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clWindowText
                        Font.Height = -11
                        Font.Name = 'Tahoma'
                        Font.Style = []
                        Header = 'Order'
                        HeaderAlignment = taLeftJustify
                        HeaderFont.Charset = DEFAULT_CHARSET
                        HeaderFont.Color = clWindowText
                        HeaderFont.Height = -11
                        HeaderFont.Name = 'Tahoma'
                        HeaderFont.Style = []
                        MinSize = 0
                        MaxSize = 0
                        Password = False
                        PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
                        PrintColor = clWhite
                        PrintFont.Charset = DEFAULT_CHARSET
                        PrintFont.Color = clWindowText
                        PrintFont.Height = -11
                        PrintFont.Name = 'Tahoma'
                        PrintFont.Style = []
                        ReadOnly = False
                        ShowBands = False
                        SortStyle = ssAutomatic
                        SpinMax = 0
                        SpinMin = 0
                        SpinStep = 1
                        Tag = 0
                        Width = 117
                      end>
                    ExplicitWidth = 543
                    ColWidths = (
                      302
                      117)
                  end
                end
              end
              object AdvPanel4: TAdvPanel
                Left = 0
                Top = 0
                Width = 440
                Height = 74
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
                Caption.Text = 'Index properties'
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
                  440
                  74)
                FullHeight = 68
                object Label12: TLabel
                  Left = 3
                  Top = 25
                  Width = 115
                  Height = 13
                  AutoSize = False
                  Caption = 'Index name'
                  FocusControl = edIndexName
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object lbTipoIndice: TLabel
                  Left = 215
                  Top = 25
                  Width = 120
                  Height = 13
                  AutoSize = False
                  Caption = 'Index type'
                  FocusControl = cbTipoIndice
                end
                object lbIndexOrder: TLabel
                  Left = 321
                  Top = 25
                  Width = 110
                  Height = 13
                  Anchors = [akTop, akRight]
                  AutoSize = False
                  Caption = 'Order'
                  FocusControl = cbIndexOrder
                  ExplicitLeft = 389
                end
                object edIndexName: TEdit
                  Left = 3
                  Top = 40
                  Width = 200
                  Height = 21
                  TabOrder = 0
                  OnChange = GravaPropriedade
                end
                object cbTipoIndice: TComboBox
                  Left = 215
                  Top = 40
                  Width = 94
                  Height = 21
                  Style = csDropDownList
                  Anchors = [akLeft, akTop, akRight]
                  TabOrder = 1
                  OnChange = GravaPropriedade
                end
                object cbIndexOrder: TComboBox
                  Left = 321
                  Top = 40
                  Width = 109
                  Height = 21
                  Style = csDropDownList
                  Anchors = [akTop, akRight]
                  TabOrder = 2
                  OnChange = GravaPropriedade
                end
              end
            end
          end
        end
      end
      object tsTableConstraints: TTabSheet
        Caption = 'Check constraints'
        object Splitter14: TSplitter
          Left = 230
          Top = 0
          Width = 2
          Height = 526
          Beveled = True
          ResizeStyle = rsUpdate
          ExplicitLeft = 300
          ExplicitHeight = 510
        end
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 230
          Height = 526
          Align = alLeft
          BevelOuter = bvNone
          BorderWidth = 3
          Caption = 'Panel2'
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object lvConstraints: TListView
            Left = 3
            Top = 3
            Width = 202
            Height = 520
            Align = alClient
            Columns = <
              item
                AutoSize = True
              end>
            HideSelection = False
            RowSelect = True
            PopupMenu = popConstraints
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnChange = lvConstraintsChange
            OnEdited = lvConstraintsEdited
          end
          object Panel12: TPanel
            Left = 205
            Top = 3
            Width = 22
            Height = 520
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            DesignSize = (
              22
              520)
            object AdvToolButton6: TAdvToolButton
              Left = 0
              Top = 22
              Width = 23
              Height = 22
              Action = acRemoveConstraint
              AutoThemeAdapt = False
              Color = clWhite
              ColorDown = 14210002
              ColorHot = 13289415
              Glyph.Data = {
                2E020000424D2E0200000000000036000000280000000C0000000E0000000100
                180000000000F801000000000000000000000000000000000000FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFF00007BBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD
                BDBDBDFFFFFFFFFFFF00007B00007BBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFF
                FF00007BBDBDBDFFFFFFFFFFFFBDBDBD00007B00007BBDBDBDFFFFFFFFFFFFFF
                FFFFBDBDBD00007BFFFFFFFFFFFFFFFFFFFFFFFF00007B00007BBDBDBDBDBDBD
                FFFFFF00007B00007BBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD00007B0000
                7BBDBDBDBDBDBD00007B00007BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                007B00007B00007B00007B00007BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFBDBDBD00007B00007B00007BBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFBDBDBDBDBDBD00007B00007B00007B00007BBDBDBDBDBDBDFFFFFFFFFFFFFF
                FFFFFFFFFF00007B00007B00007BFFFFFFBDBDBD00007B00007BBDBDBDBDBDBD
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBDBDBD00007B0000
                7BBDBDBDBDBDBDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFF00007B00007BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
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
              Shaded = False
              ShowCaption = False
              Version = '1.7.2.1'
              TMSStyle = 0
            end
            object Bevel3: TBevel
              Left = 254
              Top = 337
              Width = 23
              Height = 2
              Anchors = [akLeft, akBottom]
              ExplicitTop = 308
            end
            object btNewConstraint: TAdvToolButton
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
              OnClick = miAddConstraintClick
              Version = '1.7.2.1'
              TMSStyle = 0
            end
          end
        end
        object atPanel16: TPanel
          Left = 232
          Top = 0
          Width = 450
          Height = 526
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          ExplicitHeight = 564
          object Label74: TLabel
            Left = 5
            Top = 85
            Width = 269
            Height = 0
            AutoSize = False
            Caption = 'Valor padr'#227'o na inclus'#227'o'
          end
          object AdvPanel6: TAdvPanel
            Left = 5
            Top = 5
            Width = 440
            Height = 118
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
            Caption.Text = 'Constraint properties'
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
              440
              118)
            FullHeight = 68
            object Label65: TLabel
              Left = 8
              Top = 26
              Width = 79
              Height = 13
              Caption = 'Constraint name'
              FocusControl = edConstraintName
            end
            object Label66: TLabel
              Left = 8
              Top = 70
              Width = 52
              Height = 13
              Caption = 'Expression'
              FocusControl = edExpression
            end
            object edConstraintName: TEdit
              Left = 8
              Top = 40
              Width = 374
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              OnExit = GravaPropriedade
            end
            object edExpression: TEdit
              Left = 8
              Top = 84
              Width = 374
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnChange = GravaPropriedade
            end
          end
        end
      end
      object tsGatilhos: TTabSheet
        Caption = 'Triggers'
        inline frTriggersEditor: TfrTriggersEditor
          Left = 0
          Top = 0
          Width = 682
          Height = 526
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 682
          ExplicitHeight = 526
          inherited Panel1: TPanel
            Width = 682
            Height = 526
            Color = clWhite
            ParentBackground = False
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 682
            ExplicitHeight = 564
            inherited Splitter1: TSplitter
              Height = 526
              ExplicitHeight = 510
            end
            inherited Panel2: TPanel
              Height = 526
              StyleElements = [seFont, seClient, seBorder]
              ExplicitHeight = 526
              inherited lvTriggers: TListView
                Height = 516
                ExplicitHeight = 516
              end
              inherited Panel13: TPanel
                Height = 516
                StyleElements = [seFont, seClient, seBorder]
                ExplicitHeight = 516
                inherited Bevel4: TBevel
                  Top = 453
                  ExplicitTop = 436
                end
                inherited btAddTrigger: TAdvToolButton
                  TMSStyle = 0
                end
                inherited btDeleteTrigger: TAdvToolButton
                  OnClick = frTriggersEditorbtDeleteTriggerClick
                  TMSStyle = 0
                end
              end
            end
            inherited Panel3: TPanel
              Width = 450
              Height = 526
              StyleElements = [seFont, seClient, seBorder]
              ExplicitWidth = 450
              ExplicitHeight = 564
              inherited ScrollBox1: TScrollBox
                Width = 440
                Height = 516
                ExplicitWidth = 440
                ExplicitHeight = 554
                inherited AdvPanel6: TAdvPanel
                  Width = 440
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitWidth = 440
                  FullHeight = 68
                  inherited Label3: TLabel
                    StyleElements = [seFont, seClient, seBorder]
                  end
                  inherited Label5: TLabel
                    StyleElements = [seFont, seClient, seBorder]
                  end
                  inherited edTriggerName: TEdit
                    StyleElements = [seFont, seClient, seBorder]
                  end
                  inherited edDescription: TEdit
                    Width = 421
                    StyleElements = [seFont, seClient, seBorder]
                    ExplicitWidth = 421
                  end
                end
                inherited AdvPanel2: TAdvPanel
                  Width = 440
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitWidth = 440
                  FullHeight = 68
                  inherited rgTriggerType: TRadioGroup
                    Width = 544
                    ExplicitWidth = 544
                  end
                end
                inherited AdvPanel1: TAdvPanel
                  Width = 440
                  Height = 425
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitWidth = 440
                  ExplicitHeight = 463
                  FullHeight = 68
                  inherited Label4: TLabel
                    StyleElements = [seFont, seClient, seBorder]
                  end
                  inherited Label7: TLabel
                    StyleElements = [seFont, seClient, seBorder]
                  end
                  inherited edOrder: TEdit
                    StyleElements = [seFont, seClient, seBorder]
                  end
                  inherited mmImplementation: TAdvMemo
                    Width = 430
                    Height = 397
                    ExplicitWidth = 430
                    ExplicitHeight = 435
                  end
                end
              end
            end
          end
          inherited popTriggers: TAdvPopupMenu
            Top = 315
          end
        end
      end
      object AdvTabSheet7: TTabSheet
        BorderWidth = 5
        Caption = 'Description'
        object mTableComments: TMemo
          Left = 0
          Top = 0
          Width = 672
          Height = 516
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          OnChange = GravaPropriedade
        end
      end
    end
    object pnTableMain: TPanel
      Left = 5
      Top = 5
      Width = 690
      Height = 31
      Align = alTop
      BevelOuter = bvNone
      Ctl3D = True
      FullRepaint = False
      ParentColor = True
      ParentCtl3D = False
      TabOrder = 0
      DesignSize = (
        690
        31)
      object Label10: TLabel
        Left = 2
        Top = 5
        Width = 56
        Height = 13
        Caption = 'Table &name'
        FocusControl = edTableName
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 257
        Top = 5
        Width = 36
        Height = 13
        Caption = '&Caption'
        FocusControl = edTableCaption
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object edTableName: TEdit
        Left = 64
        Top = 2
        Width = 175
        Height = 23
        TabOrder = 0
        OnChange = GravaPropriedade
      end
      object edTableCaption: TEdit
        Left = 299
        Top = 4
        Width = 387
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = GravaPropriedade
      end
    end
  end
  object pnLinks: TAdvDockPanel
    Left = 0
    Top = 597
    Width = 711
    Height = 51
    Align = daBottom
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarOfficeStyler1
    UseRunTimeHeight = False
    Version = '6.8.6.2'
    Visible = False
    object barLinks: TAdvToolBar
      Left = 3
      Top = 1
      Width = 705
      Height = 36
      AllowFloating = True
      Caption = ''
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Sans Serif'
      CaptionFont.Style = [fsBold]
      CompactImageIndex = -1
      ShowRightHandle = False
      ShowClose = False
      ShowOptionIndicator = False
      FullSize = True
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBarOfficeStyler1
      ParentOptionPicture = True
      ShowHint = False
      ToolBarIndex = -1
      object btLinkDiagram: TAdvToolBarButton
        Left = 9
        Top = 2
        Width = 125
        Height = 32
        AutoSize = False
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = [fsBold]
        Caption = 'Back to diagram'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0000008000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00000080000000FF0000008000FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
          80000000FF000000FF000000FF0000008000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000080000000
          FF000000FF000000FF000000FF000000FF0000008000FF00FF00FF00FF00FF00
          FF00FF00FF0000000000000000000000000000000000808080000000FF000000
          FF000000FF000000FF000000FF000000FF000000FF0000008000FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00808080000000
          FF000000FF000000FF000000FF000000FF0000008000FF00FF00FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008080
          80000000FF000000FF000000FF0000008000FF00FF00FF00FF00FF00FF00FF00
          FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00808080000000FF0000008000FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF0080808000FF00FF00FF00FF00FF00FF00FF00FF00808080000080
          8000008080000080800000808000008080000080800000808000FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF008080800000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000FF00FF00FF00
          FF00000000000000000000000000FF00FF00FF00FF00FF00FF008080800000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF008080800000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000FF00FF00FF00
          FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF008080800000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000000000000000
          00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF008080800000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000808000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008080
          80008080800080808000808080008080800080808000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        GlyphDisabled.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000B5B5B500B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500B5B5B50075757500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500757575008A8A8A0075757500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5007575
          75008A8A8A008A8A8A008A8A8A0075757500B5B5B500B5B5B500B5B5B500B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500757575008A8A
          8A008A8A8A008A8A8A008A8A8A008A8A8A0075757500B5B5B500B5B5B500B5B5
          B500B5B5B50060606000606060006060600060606000A0A0A0008A8A8A008A8A
          8A008A8A8A008A8A8A008A8A8A008A8A8A008A8A8A0075757500B5B5B500B5B5
          B500B5B5B50060606000B5B5B500B5B5B500B5B5B500B5B5B500A0A0A0008A8A
          8A008A8A8A008A8A8A008A8A8A008A8A8A0075757500B5B5B500B5B5B500B5B5
          B500B5B5B50060606000B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500A0A0
          A0008A8A8A008A8A8A008A8A8A0075757500B5B5B500B5B5B500B5B5B500B5B5
          B500606060006060600060606000B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500A0A0A0008A8A8A0075757500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500B5B5B50060606000B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
          B500B5B5B500A0A0A000B5B5B500B5B5B500B5B5B500B5B5B500A0A0A0008A8A
          8A008A8A8A008A8A8A008A8A8A008A8A8A008A8A8A008A8A8A00B5B5B500B5B5
          B500B5B5B50060606000B5B5B500B5B5B500B5B5B500B5B5B500A0A0A000B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5008A8A8A00B5B5B500B5B5
          B500606060006060600060606000B5B5B500B5B5B500B5B5B500A0A0A000B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5008A8A8A00B5B5B500B5B5
          B500B5B5B50060606000B5B5B500B5B5B500B5B5B500B5B5B500A0A0A000B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5008A8A8A00B5B5B500B5B5
          B500B5B5B50060606000B5B5B500B5B5B500B5B5B500B5B5B500A0A0A000B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5008A8A8A00606060006060
          60006060600060606000B5B5B500B5B5B500B5B5B500B5B5B500A0A0A000B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B5008A8A8A00B5B5B500B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500A0A0
          A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000B5B5B500B5B5B500B5B5
          B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500}
        ParentFont = False
        Position = daBottom
        ShowCaption = True
        Version = '6.8.6.2'
        OnClick = btLinkDiagramClick
      end
      object btLinkTable: TAdvToolBarButton
        Left = 134
        Top = 2
        Width = 125
        Height = 32
        AutoSize = False
        Appearance.CaptionFont.Charset = DEFAULT_CHARSET
        Appearance.CaptionFont.Color = clWindowText
        Appearance.CaptionFont.Height = -11
        Appearance.CaptionFont.Name = 'MS Sans Serif'
        Appearance.CaptionFont.Style = []
        Caption = 'Go to table'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Position = daBottom
        ShowCaption = True
        Version = '6.8.6.2'
        Visible = False
        OnClick = btLinkTableClick
      end
    end
  end
  object pnBlank: TPanel
    Left = 703
    Top = 0
    Width = 8
    Height = 597
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
  end
  object ImageList1: TImageList
    Left = 70
    Top = 362
    Bitmap = {
      494C01010F001100040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000FFFF0000FFFF000000000000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007B7B00007B
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B00000000000000000000FFFF00000000000000000000FF
      FF000000000000FFFF00000000000000000000FFFF00000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00007B7B0000000000000000000000000000000000007B7B00007B
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B000000000000000000000000000000000000FFFF000000
      00000000000000FFFF000000000000FFFF000000000000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00007B7B0000FFFF0000000000000000000000000000000000007B7B00007B
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B0000000000000000000000000000FFFF00000000000000
      00000000000000FFFF0000000000000000000000000000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000007B
      7B0000FFFF000000000000000000000000000000000000000000007B7B00007B
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B00000000000000000000FFFF00000000000000000000FF
      FF000000000000FFFF0000000000000000000000000000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00007B7B0000FF
      FF00000000000000000000000000000000000000000000000000007B7B00007B
      7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B
      7B00007B7B00007B7B0000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000FFFF0000FFFF0000FFFF00000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      00000000000000000000000000000000000000000000007B7B0000FFFF000000
      0000000000000000000000000000000000000000000000000000007B7B00007B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000007B7B00007B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B000000000000FFFF0000FF
      FF0000FFFF00000000000000000000FFFF00007B7B0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B0000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00007B7B0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B0000000000000000000000000000000000000000000000
      00000000000000FF0000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B0000000000000000000000000000000000000000000000
      0000000000000000000000FF0000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000000000007B7B0000FFFF0000FFFF00000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000007B7B0000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF0000000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B0000FFFF000000
      000000000000007B7B0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF00000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00007B7B00007B7B0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B0000FFFF0000FFFF0000FFFF0000FFFF00000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007B7B00007B
      7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B
      7B00007B7B00007B7B00007B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF00007B7B00007B7B0000FFFF0000FFFF0000FFFF00007B7B00007B
      7B0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF00007B7B7B000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00007B7B7B0000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF000000000000FFFF0000000000FFFFFF000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF00000000000000FF00007B7B7B00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF000000000000FFFF0000000000000000007B7B
      00000000000000FFFF00000000000000000000000000000000007B7B7B000000
      000000000000FFFF0000FFFF0000FFFF0000000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000FF00007B7B7B000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00000000000000000000FFFF00000000007B7B00000000
      00000000000000FFFF000000000000000000000000007B7B7B00000000007B7B
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF00000000000000FF00000000000000FF00007B7B
      7B0000000000000000000000000000000000000000007B7B7B000000000000FF
      FF0000000000000000007B7B00000000000000FFFF0000000000000000007B7B
      00000000000000FFFF00000000007B7B7B007B7B7B0000000000FFFFFF00FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000FF00000000000000FF
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00000000000000000000FFFF00FFFFFF0000FFFF00000000000000
      000000FFFF00FFFFFF0000FFFF000000000000000000FFFFFF007B7B0000FFFF
      0000FFFF0000FFFF00007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF00000000000000FF00000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B00007B7B0000FFFF
      0000FFFF0000FFFF00007B7B7B00FFFFFF00FFFFFF00FFFFFF007B7B7B000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B
      7B00007B7B0000FFFF0000FFFF0000000000000000007B7B0000FFFFFF00FFFF
      0000FFFF0000FFFF00007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00007B0000007B0000007B0000007B0000007B0000007B000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF00000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00007B7B00007B7B00000000000000000000000000007B7B00007B
      7B0000FFFF0000000000000000000000000000000000FFFFFF007B7B00007B7B
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000007B7B7B000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00007B7B0000000000007B7B0000FFFF000000
      0000000000000000000000000000000000007B7B7B00000000007B7B00007B7B
      0000FFFFFF00FFFF0000FFFF0000FFFF0000000000007B7B7B00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B0000000000FFFF
      FF007B7B00007B7B000000000000000000007B7B7B0000000000000000000000
      000000000000000000007B7B7B0000000000000000007B0000007B0000007B00
      00007B0000007B0000007B000000000000000000000000000000000000000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00BDBD
      BD0000000000BDBDBD00FFFFFF00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000007B7B000000000000FF
      FF000000000000FFFF00007B7B007B7B7B00000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B0000007B0000007B0000007B00
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF007B0000007B0000007B0000007B0000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B000000000000000000007B7B00FFFFFF000000
      000000FFFF0000000000007B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      0000FF0000007B000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF007B7B7B000000000000000000007B7B00FFFFFF0000FF
      FF000000000000FFFF00007B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00BDBDBD0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      00007B000000FF0000007B00000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF0000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00FF00000000000000BDBDBD000000FF000000
      7B0000FFFF00BDBDBD007B7B7B000000000000000000007B7B00FFFFFF000000
      000000FFFF0000000000007B7B007B7B7B000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00007B7B00000000007B7B7B00BDBDBD000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      0000FF0000007B000000FF00000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD00FF0000000000000000FFFF000000FF000000
      7B00BDBDBD0000FFFF007B7B7B000000000000000000007B7B00000000000000
      00000000000000000000000000007B7B7B00000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      00007B000000FF0000007B00000000000000FFFFFF00FFFF0000FFFFFF00FFFF
      00007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF0000FFFF00BDBD
      BD00000000007B7B7B0000000000BDBDBD007B7B7B0000000000000000000000
      000000FFFF00BDBDBD007B7B7B00000000000000000000000000007B7B00007B
      7B00007B7B00007B7B00007B7B0000000000000000007B0000007B0000007B00
      00007B0000007B0000007B0000007B7B7B000000000000000000000000000000
      00000000000000FFFF0000FFFF00007B7B0000000000000000007B7B7B000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      0000FF0000007B000000FF00000000000000FFFF0000FFFFFF00FFFF0000FFFF
      FF007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF00BDBDBD0000FF
      FF00BDBDBD007B7B7B00BDBDBD00FFFFFF00FFFFFF0000000000BDBDBD007B7B
      7B000000000000FFFF007B7B7B000000000000000000007B7B00007B7B00007B
      7B00007B7B00007B7B00007B7B00007B7B0000000000FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF007B0000007B7B7B000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000007B7B
      7B0000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      00007B000000FF0000007B00000000000000FFFFFF00FFFF0000FFFFFF00FFFF
      00007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF0000FFFF00BDBD
      BD007B7B7B00BDBDBD007B7B7B007B7B7B0000000000BDBDBD00FFFFFF007B7B
      7B0000000000BDBDBD007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000FFFFFF007B7B
      7B0000000000FFFFFF007B0000007B7B7B000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF00000000000000
      0000BDBDBD00000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      0000FF0000007B000000FF00000000000000FFFF0000FFFFFF00FFFF0000FFFF
      FF007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF007B7B7B007B7B
      7B000000000000FFFF007B7B7B00000000007B000000FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF007B0000007B7B7B000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF000000000000000000BDBD
      BD0000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD007B00
      00007B0000007B0000007B0000007B0000007B0000007B0000007B0000007B00
      00007B000000BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF0000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF00BDBDBD007B7B7B00000000007B000000FFFFFF00000000007B7B
      7B00FFFFFF0000000000FFFFFF007B7B7B00FFFFFF0000000000FFFFFF007B7B
      7B00FFFFFF00000000007B0000007B7B7B000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF00000000000000
      0000BDBDBD00000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00000000007B000000FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF007B0000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000000000BDBDBD000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD007B7B7B00BDBDBD0000FFFF00BDBD
      BD00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00000000007B00000000000000FFFFFF007B7B
      7B00FFFFFF0000000000FFFFFF007B7B7B00FFFFFF0000000000FFFFFF007B7B
      7B0000000000FFFFFF007B0000007B7B7B000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF000000000000000000BDBDBD0000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD0000000000007B0000007B0000007B0000007B000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00000000007B7B7B00BDBDBD0000FF
      FF0000FFFF00BDBDBD0000FFFF00BDBDBD007B7B7B0000000000000000000000
      0000000000000000000000000000000000007B0000007B0000007B0000007B00
      00007B0000007B0000007B0000007B0000007B0000007B0000007B0000007B00
      00007B0000007B0000007B0000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD0000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000007B00000000000000FFFFFF007B00
      000000000000FFFFFF00000000007B00000000000000FFFFFF00000000007B00
      000000000000FFFFFF007B0000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B0000007B0000007B0000007B00
      00007B0000007B0000007B0000007B0000007B0000007B0000007B0000007B00
      00007B0000007B0000007B000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF007B7B7B007B7B7B00FFFF
      FF007B7B7B007B7B7B00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000007B7B00007B
      7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B000000000000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF0000000000007B
      7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B0000000000BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B
      7B00007B7B000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B000000000000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF0000000000007B7B00007B7B00007B7B00007B7B00007B7B00007B7B00007B
      7B00007B7B00007B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00000000007B7B7B0000000000BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF007B7B7B007B7B7B00FFFF
      FF007B7B7B007B7B7B00FFFFFF00000000007B7B7B000000000000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000007B7B7B00FFFF
      FF007B7B7B000000000000000000000000007B7B7B0000000000BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B000000000000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00BDBDBD0000FFFF00BDBD
      BD0000FFFF00BDBDBD0000FFFF00BDBDBD007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00BDBDBD0000FF
      FF00BDBDBD0000FFFF00BDBDBD007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFCE500000FFFFC00194A10000
      FFE3803169470000FFC18031D8870000FFC18031B1870000FF0380014A270000
      FF0780019C6F0000840F8001FFFF0000001F8FF1FDFF0000003F8FF1F8FF0000
      007F8FF1FC7F0000003F8FF1FA3F0000003F8FF1FD7F0000803F8FF5FAFF0000
      C03F8001FDFF0000E07FFFFFFBFF00008000EDB6EDB6FFFF8000EAAAEAAAF9FF
      8000EAAAEAAAF8FFC001EDB6EDB6FC7FC001FFFFFFFFFA3FC011F07FFFFFFD1F
      C021C03FE01FFA8FC211801FE55FFD478420001FE29FFAAF800000190559FD5F
      800000102010FABF800000190019FD7FC00100192019FAFFF007003900F9FDFF
      FC1F806100E1FBFFFF7FC1FF00FFFFFFFFC8FFFF803FFFFFFFEB8000283FFFFF
      03800000147FFFFF00800000087FC3FF00000000147FC0FF000000000000E03F
      000000000000F01F000000000000F80F000000008048F807000000000000F00F
      000000002444F807000000000000FE03000000014448FF810000807F0000FFE3
      0000C0FF4AA8FFFF0000FFFF0001FFFFFFFFFFFFFFFFFFC7FFFFC007FFFFF701
      8001C007001F03010001C007000F02004001C007000776004001C00700037E00
      4001C0070001FF014001C007000000014001C007001F00C74001C007001F00FF
      4001C007001F00FF7FF9C00F8FF100FF0003C01FFFF900FF80FFC03FFF7500FF
      C1FFFFFFFF8F01FFFFFFFFFFFFFF03FF00000000000000000000000000000000
      000000000000}
  end
  object ImageList2: TImageList
    Left = 110
    Top = 374
    Bitmap = {
      494C010118001A00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000007000000001002000000000000070
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B0000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00000000000000000072BAEA007200
      0000FFEABA000000000000000000BAEAFF0000007200EABA7200EAFFFF000072
      BA0000000000EABA720000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      00000000000000000000000000007B7B7B00000000000000000072BAEA007200
      0000FFEABA000000000000000000BAEAFF0000007200D4BA72000072BA007200
      0000FFEABA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000000000000000
      0000BDBDBD000000000000000000FF0000000000000000000000BDBDBD000000
      00000000000000000000000000007B7B7B00000000000000000072BAEA000000
      00000000000000000000BA720000BAEAEA00000072000000000072000000FFEA
      BA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000000000000000
      000000000000FF00000000000000FF00000000000000FF000000000000000000
      00000000000000000000000000007B7B7B00000000000000000072BAEA007200
      0000FFEABA000000000000000000BAEAFF000000720000000000000000009B00
      0000FFFFD4000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      00000000000000000000000000007B7B7B00000000000000000072BAEA000000
      0000000000000000000000000000BABA9B0000007200EABA7200D4FFFF000000
      9B0000000000FFD49B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B000000000000000000BDBD
      BD00FF000000FF000000FF00000000000000FF000000FF000000FF000000BDBD
      BD000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000BDBD
      BD00000000000000000000000000000000007B7B7B0000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD007B7B7B00BDBD
      BD00FF0000000000000000000000000000007B7B7B0000000000000000000000
      000000000000FF00000000000000FF00000000000000FF000000000000000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00BDBD
      BD000000000000000000000000000000000000000000BDBDBD00FF000000BDBD
      BD00FF00000000000000FF000000000000007B7B7B0000000000000000000000
      0000BDBDBD000000000000000000FF0000000000000000000000BDBDBD000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      000000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD007B7B7B00FF00
      0000FF000000FF00000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FF000000FF000000FF00
      000000000000FF000000FF000000FF0000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000007B7B7B0000000000BDBDBD00BDBD
      BD00BDBDBD007B7B7B0000000000BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B00000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000FF00000000000000FF000000000000007B7B7B0000000000000000000000
      000000000000BDBDBD0000000000000000000000000000000000000000000000
      000000000000BDBDBD00000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00BDBDBD007B7B
      7B00BDBDBD007B7B7B00BDBDBD007B7B7B00BDBDBD007B7B7B00BDBDBD007B7B
      7B00BDBDBD007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00BDBDBD007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000000000000000000000000000BDBDBD00000000000000
      0000000000007B7B7B000000000000000000000000007B7B7B00000000000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      000000007B0000007B0000007B0000007B0000007B0000007B0000007B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B000000000000000000000000007B7B7B0000000000FF00
      0000FF000000000000000000000000FFFF0000FFFF0000000000000000000000
      FF000000FF0000007B00000000000000000000000000000000007B0000000000
      7B0000007B0000007B0000007B0000007B0000007B0000007B0000007B000000
      7B00007B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF000000FF000000
      FF00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B007B7B7B000000000000000000BDBDBD0000000000FF00
      0000FF0000007B0000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B000000000000000000000000007B0000007B0000000000
      7B000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      7B00007B7B00007B7B0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B0000000000000000007B7B7B0000000000FF00
      0000FF0000007B0000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B0000000000000000007B0000007B000000FF0000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000FFFF00007B7B00007B7B00000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00FFFFFF007B7B7B000000000000000000BDBDBD0000000000FF00
      0000FF0000007B0000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B0000000000000000007B000000FF000000FF000000FF00
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000FF
      FF0000FFFF0000FFFF00007B7B00007B7B000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD007B7B7B000000000000000000000000000000000000000000000000000000
      00007B7B7B00BDBDBD00FFFFFF0000000000000000007B7B7B0000000000FF00
      0000FF0000007B0000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B000000000000000000FF000000FF000000FF000000FF00
      0000FF0000000000FF000000FF000000FF000000FF000000FF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00007B7B000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000BDBDBD0000000000FF00
      0000FF000000FF0000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF0000000000FF000000FF000000FF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00007B7B000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF007B0000007B0000007B000000BDBDBD000000
      000000000000000000000000000000000000000000007B7B7B00BDBDBD000000
      000000000000000000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF00FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000BDBDBD007B7B7B000000
      000000000000000000000000000000FFFF0000FFFF00007B7B00000000000000
      FF000000FF0000007B000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000FF0000FF00FF00FF00FF00FF00FF00FF00
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF007B0000007B0000007B000000BDBD
      BD0000000000000000000000000000000000000000007B7B7B00BDBDBD000000
      000000000000000000000000000000FFFF0000FFFF00007B7B00000000000000
      00000000FF000000FF00000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000FF000000FF0000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000BDBDBD007B7B7B000000
      000000000000000000000000000000FFFF0000FFFF00007B7B00000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF00000000FF000000FF000000FF000000FF0000FF00FF00FF00FF00FF00
      FF00FF00FF000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000FFFFFF00FFFFFF00BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000000FF000000FF000000FF000000FF0000FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD00000000000000
      0000007B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B0000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000BDBDBD00BDBDBD00BDBD
      BD00007B7B0000FFFF000000000000FFFF0000000000000000007B7B7B007B7B
      7B00000000007B7B7B007B7B7B007B7B7B00000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      0000007B7B000000000000FFFF00007B7B00007B7B0000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B0000000000BDBDBD00BDBDBD00BDBDBD0000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      000000000000007B7B00007B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B0000000000BDBDBD00000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B0000000000BDBDBD00BDBDBD00BDBDBD007B7B7B00000000007B0000007B00
      00007B000000000000007B0000007B0000007B0000007B0000007B0000007B00
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      000000000000000000000000000000000000007B7B0000000000000000000000
      0000000000000000000000000000000000007B7B7B00000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000007B7B
      7B0000000000BDBDBD000000000000000000BDBDBD00BDBDBD007B7B7B000000
      0000FFFF000000000000FFFF000000000000FFFF000000000000000000007B7B
      7B0000000000BDBDBD0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD00007B7B0000FFFF000000000000FF
      FF0000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B0000000000BDBDBD00000000000000000000000000000000007B7B7B00FFFF
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000000000007B7B
      7B0000000000BDBDBD0000000000000000007B7B7B00000000007B0000007B00
      000000000000000000007B0000007B0000007B000000000000007B0000007B00
      00007B00000000000000000000007B7B7B0000000000BDBDBD00000000000000
      000000000000BDBDBD000000000000000000007B7B000000000000FFFF00007B
      7B00007B7B000000000000000000000000007B7B7B00000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000007B7B
      7B0000000000BDBDBD00BDBDBD00BDBDBD0000000000000000007B7B7B000000
      0000FFFF000000000000FFFF000000000000FFFF000000000000000000007B7B
      7B0000000000BDBDBD0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      000000000000BDBDBD00000000000000000000000000007B7B00007B7B000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B0000000000BDBDBD00000000000000000000000000000000007B7B7B00FFFF
      0000FF000000FF000000FF000000FF000000FF000000FFFF0000000000007B7B
      7B0000000000BDBDBD00BDBDBD00BDBDBD007B7B7B00000000007B0000007B00
      00007B000000000000007B0000007B0000007B0000007B0000007B0000007B00
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      0000007B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000007B7B
      7B0000000000BDBDBD000000000000000000BDBDBD00BDBDBD007B7B7B000000
      0000FFFF000000000000FFFF000000000000FFFF000000000000000000007B7B
      7B0000000000BDBDBD0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000BDBDBD00BDBDBD00BDBD
      BD00007B7B0000FFFF000000000000FFFF0000000000000000007B7B7B007B7B
      7B00000000007B7B7B007B7B7B007B7B7B007B7B7B000000000000FFFF000000
      000000FFFF000000000000FFFF000000000000FFFF0000000000000000007B7B
      7B0000000000BDBDBD00000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000007B7B
      7B0000000000BDBDBD0000000000000000007B7B7B00000000007B0000007B00
      000000000000000000007B0000007B000000000000007B0000007B0000007B00
      00007B00000000000000000000007B7B7B0000000000BDBDBD00000000000000
      0000007B7B000000000000FFFF00007B7B00007B7B0000000000000000000000
      0000000000000000000000000000000000007B7B7B0000FFFF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000FFFF00000000007B7B
      7B00BDBDBD00BDBDBD00BDBDBD00BDBDBD0000000000000000007B7B7B000000
      000000FF00000000000000FF00000000000000FF000000000000000000007B7B
      7B0000000000BDBDBD0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000BDBDBD00000000000000
      000000000000007B7B00007B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B000000000000FFFF000000
      000000FFFF000000000000FFFF000000000000FFFF0000000000000000007B7B
      7B000000000000000000000000000000000000000000000000007B7B7B0000FF
      0000000000000000000000000000000000000000000000FF0000000000007B7B
      7B00BDBDBD00BDBDBD00BDBDBD00BDBDBD007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B00007B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      000000FF00000000000000FF00000000000000FF000000000000000000007B7B
      7B00000000000000000000000000000000007B7B7B0000000000BDBDBD00BDBD
      BD00BDBDBD007B7B7B0000000000BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B00000000007B7B7B00007B7B0000FFFF000000000000FF
      FF0000000000000000007B7B7B007B7B7B00000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      000000000000BDBDBD0000000000000000000000000000000000000000000000
      000000000000BDBDBD00000000007B7B7B00007B7B000000000000FFFF00007B
      7B00007B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B000000000000000000007B7B00007B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000BDBDBD000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000007B00000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD007B7B7B00BDBDBD00BDBDBD00007B7B00BDBDBD00BDBDBD0000000000BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      0000000000007B7B00007B7B0000000000007B7B00007B7B00007B7B00007B7B
      0000BDBDBD0000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000000000007B0000007B0000007B0000007B0000BDBDBD00000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000007B7B
      7B0000000000BDBDBD00BDBDBD0000FFFF00BDBDBD00BDBDBD00BDBDBD000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      0000000000007B7B00007B7B0000000000007B7B00007B7B0000000000007B7B
      00007B7B000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000007B000000000000007B0000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000007B7B
      7B00000000000000000000FFFF00BDBDBD0000FFFF00BDBDBD00BDBDBD000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      00007B7B00007B7B00007B7B0000000000007B7B00007B7B0000000000007B7B
      00007B7B000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000007B000000000000007B0000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000007B7B
      7B0000FFFF00000000000000000000000000007B7B00BDBDBD00007B7B000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      0000BDBDBD007B7B00007B7B0000000000007B7B00007B7B0000000000007B7B
      00007B7B000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000000000BDBDBD00007B0000007B0000007B0000BDBDBD00000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000007B7B
      7B00000000000000000000FFFF00000000000000000000FFFF00BDBDBD000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      0000000000007B7B00007B7B0000000000007B7B00007B7B00007B7B00007B7B
      0000BDBDBD0000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000000000007B000000000000007B00000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000BDBDBD000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      0000000000007B7B00007B7B0000000000007B7B00007B7B0000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000000000BDBDBD00007B0000007B0000007B0000007B0000000000000000
      00000000000000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD007B7B7B00000000000000000000FFFF0000000000BDBDBD0000000000BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00000000007B7B00007B7B
      0000BDBDBD007B7B00007B7B0000000000007B7B00007B7B0000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000007B00000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000BDBDBD007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00BDBDBD000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000007B7B
      00007B7B00007B7B000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD007B7B7B000000000000000000000000000000
      00007B7B7B0000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B00BDBDBD00000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000007B0000007B0000007B0000007B0000007B000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000007B0000000000000000000000000000007B0000007B0000007B00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B0000000000BDBDBD00007B
      0000007B0000BDBDBD00000000007B7B7B0000000000007B0000007B0000007B
      00000000000000000000BDBDBD00000000007B7B7B0000000000BDBDBD007B00
      00007B000000BDBDBD00000000007B000000000000007B0000007B0000007B00
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      00007B0000007B000000000000007B0000007B00000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000007B000000000000000000000000000000000000000000000000000000
      7B000000000000000000BDBDBD00000000007B7B7B0000000000007B00000000
      000000000000007B0000000000007B7B7B000000000000000000007B00000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B0000000000
      0000000000007B000000000000000000000000000000000000007B0000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000007B0000007B0000007B0000007B00000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      000000007B000000000000000000000000000000000000000000000000000000
      7B000000000000000000BDBDBD00000000007B7B7B0000000000007B00000000
      000000000000007B0000000000007B7B7B000000000000000000007B00000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B0000000000
      0000000000007B000000000000000000000000000000000000007B0000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      00000000000000000000000000007B0000007B00000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      00000000000000007B00000000000000000000007B0000007B0000007B00BDBD
      BD000000000000000000BDBDBD00000000007B7B7B0000000000007B00000000
      000000000000007B0000000000007B7B7B000000000000000000007B00000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B0000000000
      0000000000007B000000000000000000000000000000000000007B0000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000007B0000007B0000007B000000BDBDBD0000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B000000000000000000BDBD
      BD00000000000000000000007B000000000000007B0000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000007B00000000
      000000000000007B0000000000007B7B7B0000000000007B0000007B00000000
      00000000000000000000BDBDBD00000000007B7B7B00000000007B0000000000
      0000000000007B0000000000000000000000000000007B0000007B0000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      7B0000007B0000007B0000007B000000000000007B0000007B0000007B000000
      7B000000000000000000BDBDBD00000000007B7B7B0000000000BDBDBD00007B
      0000007B0000BDBDBD00000000007B7B7B000000000000000000007B00000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000BDBDBD007B00
      00007B000000BDBDBD00000000000000000000000000000000007B0000000000
      00000000000000000000BDBDBD00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B0000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD0000007B00BDBDBD00BDBDBD000000
      000000000000000000000000000000000000BDBDBD00BDBDBD00000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      000000FF000000FF000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD00000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD0000007B0000007B00BDBDBD00BDBD
      BD000000000000000000000000000000000000007B00BDBDBD00000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD0000000000BDBDBD00BDBDBD000000
      000000FF000000FF000000000000BDBDBD00BDBDBD00BDBDBD00BDBDBD000000
      000000000000BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000007B0000007B00BDBD
      BD00000000000000000000000000BDBDBD0000007B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000FF000000FF000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000000000000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD000000000000007B0000007B00BDBD
      BD00BDBDBD000000000000007B0000007B00BDBDBD0000000000000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000000000BDBDBD000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000000000BDBDBD00000000000000
      0000000000000000000000000000BDBDBD0000000000BDBDBD0000007B000000
      7B00BDBDBD00BDBDBD0000007B0000007B000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000000000BDBDBD000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000000000BDBDBD00BDBDBD000000
      0000000000000000000000000000BDBDBD00000000000000000000007B000000
      7B0000007B0000007B0000007B00000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD007B0000007B0000007B0000007B00
      0000000000007B0000007B0000007B0000007B0000007B0000007B0000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000BDBDBD00BDBD
      BD00000000000000000000000000BDBDBD000000000000000000BDBDBD000000
      7B0000007B0000007B00BDBDBD00000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD007B0000007B0000007B0000007B00
      0000000000007B0000007B0000007B0000007B0000007B0000007B0000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000FF000000FF000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000BDBDBD00BDBD
      BD00000000000000000000000000BDBDBD00BDBDBD00BDBDBD0000007B000000
      7B0000007B0000007B00BDBDBD00BDBDBD000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      000000FF000000FF000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000007B0000007B00000000000000
      0000000000000000000000000000BDBDBD0000007B0000007B0000007B000000
      0000BDBDBD0000007B0000007B00BDBDBD00BDBDBD0000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000007B0000007B00BDBDBD00BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B0000007B0000007B0000007B0000007B0000007B0000007B0000007B00
      00007B0000007B0000007B000000BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000007B0000007B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B0000007B0000007B0000007B0000007B0000007B0000007B0000007B00
      00007B0000007B0000007B000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000700000000100010000000000800300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFE00F8000FFFFFFFF
      C00F0000C603FFFFDFCF7EFCC607FFFFD04F76DCC00FFFFFDFCF7ABCC607FFFF
      D04F7C7CC003FFFFDFCF610CFFFFFFFFC00F7C7CFF8FFFFFC0077ABCF507FFFF
      CF8576DCE007FFFFC0037EFCC007FFFFC0080000E007FFFFFFE34200FF07FFFF
      FFD57BF8FF8FFFFFFFF70001FFFFFFFFFFFF8003FFFFFFFF80070001FFFFFFFF
      00030000F01FFFFF00010000C007FEFF000000018003FC7F000000010001FC3F
      800000010000FC7FC00000010000FC3FE00100010000FC7FF80F00010001F83F
      FC070C010001F01FFC070C018003F01FFE030C11C007F01FFE038C1FF01FF83F
      FFFFCE1FFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFB07FFFFFE00F80008248
      800FC00F0000B47F0008DFCF7FFCB9FF7FCBD048440CBF07404B154B7FFCB824
      7FCBC00B4C44BB474048D54B7FFCBB9F7FCBC008440CB07F000B154B7FFC8248
      554BC00B4C84B47F0000D54B7FFCB9FF554FC000000007FF001FD54F42002480
      FFFFC01F7BF847FFFFFFFFFF00019FFFFFF8FFF8FFF8FFF8E0F0E0F0E0F0E0F0
      00040004000400043F0C3F0C3F0C3F0C7FFC701C7FFC7FFC7EFC600C49047FFC
      783C680C49247FFC7EBC6C0C41247FFC7EBC600C41247FFC783C6D0C49047FFC
      7AFC6F8C493C7FFC783C668C413C7FFC7EF0701063F07FF07FF57FF57FF57FF5
      7FF37FF37FF37FF30007000700070007FFF8FFF8FFF8FFF8E0F0E0F0E0F0E0F0
      00040004000400043F0C3F0C3F0C3F0C7FFC7FFC7FFC7FFC7FFC7FFC7DFC7FFC
      783C770C428C428C727C77EC5ADC5BDC787C77EC5ADC5BDC7E7C7B0C5ADC5BDC
      787C6D7C5A9C5B9C7FFC610C42DC43DC7FF07FF07F707FF07FF57FF57FF57FF5
      7FF37FF37FF37FF30007000700070007FFFFFFFFFFFFFFFF800FFFFFFFFFFFFF
      000FFFFFFFFFFFFF7FCFF0F85FFF3FFF554FE0F0FFF81F387FC0E0F1A9F00F30
      50008018F8F10E7177DC00105878847855540010F83080F077DC0010F810C1F0
      00140030FC00C1F0001CE0F0FC0000F0F554E0F1FE101070F7FCE1FFFE31F831
      F000FFFFFFFFFE7FF001FFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object iActions: TImageList
    Left = 73
    Top = 325
    Bitmap = {
      494C010106000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000080008080
      8000000000000000FF0000008000000080000000800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000FF000000FF000000FF000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080008080
      800080808000808080000000000000000000000000000000FF000000FF000000
      0000000000000000FF000000FF000000FF000000FF0000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000080000000800000008000000080000000
      800000008000000000000000000000000000000000000000FF00000080008080
      8000000000000000FF0000008000000080000000800000008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000800000008000000080000000
      8000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000008000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000003B000000300000004A0000007A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A6A6A600A6A6A600A6A6A6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000002C0000003B000000680000008200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A6A6A6004C4CA5004C4CA50000000000000000000000000000000000BDBD
      BD00BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000002D00000060000000A20000008D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C4C
      A5004C4CA5000000000000000000000000000000000000000000000000004C4C
      A5004C4CAC004C4CAB0000000000000000000000000000000000000000000000
      7B00BDBDBD00BDBDBD000000000000000000000000000000000000000000BDBD
      BD00BDBDBD000000000000000000000000000000000000000000000000000000
      000000000000000000000000280000006A000000AF0000008800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C4C
      ED004C4CC9004C4CA500000000000000000000000000000000004C4CA5004C4C
      B2004C4CB1000000000000000000000000000000000000000000000000000000
      7B0000007B00BDBDBD00BDBDBD00000000000000000000000000000000000000
      7B00BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000001800000050000000890000006D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004C4CED004C4CC9004C4CA50000000000000000004C4CA5004C4CB8004C4C
      B70000000000000000000000000000000000000000000000000000000000BDBD
      BD0000007B0000007B00BDBDBD00000000000000000000000000BDBDBD000000
      7B00000000000000000000000000000000000000000000003C00000024000000
      1F0000001B000000130000001800000047000000730000005F0000004A000000
      3700000037000000520000007F00000000000000000000002800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000020000002E00000000000000000000000000000000000000
      0000000000004C4CED004C4CC9004C4CA5004C4CA5004C4CBF004C4CBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000007B0000007B00BDBDBD00BDBDBD000000000000007B0000007B00BDBD
      BD00000000000000000000000000000000000000000000003C00000041000000
      5C00000064000000510000004C00000086000000B50000009900000091000000
      8B0000008D000000900000009800000000000000000000004A00000041000000
      4400000046000000470000004700000047000000470000004700000047000000
      4700000048000000480000005300000000000000000000000000000000000000
      000000000000000000004C4CED004C4CC9004C4CC6004C4CC300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD0000007B0000007B00BDBDBD00BDBDBD0000007B0000007B000000
      0000000000000000000000000000000000000000000000005F0000007F000000
      B6000000C30000009F00000089000000C6000000F6000000D6000000DF000000
      EA000000E7000000CF000000BB00000000000000000000008C000000B3000000
      E9000000FB000000FC000000FC000000FC000000FC000000FC000000FC000000
      FC000000ED000000BA0000009400000000000000000000000000000000000000
      0000000000004C4CC9004C4CA5004C4CCC004C4CC9004C4CA5004C4CA5000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000007B0000007B0000007B0000007B0000007B00000000000000
      000000000000000000000000000000000000000000000000910000009A000000
      A30000009E0000008600000079000000AF000000DC000000BF000000BD000000
      BA000000BB000000C7000000D40000000000000000000000C3000000D2000000
      DB000000DD000000DD000000DD000000DD000000DD000000DD000000DD000000
      DD000000DD000000D6000000CA00000000000000000000000000000000000000
      00004C4CC9004C4CA5004C4CD2004C4CCF004C4CED004C4CC9004C4CA5004C4C
      A500000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000007B0000007B0000007B00BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000064000000A7000000E0000000B800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C4C
      A5004C4CA5004C4CD9004C4CD50000000000000000004C4CED004C4CC9004C4C
      A5004C4CA500000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD0000007B0000007B0000007B0000007B00BDBDBD00BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000004E0000009E000000E4000000AE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004C4CA5004C4C
      A5004C4CE0004C4CDB00000000000000000000000000000000004C4CED004C4C
      C9004C4CA5004C4CA50000000000000000000000000000000000000000000000
      7B0000007B0000007B0000000000BDBDBD0000007B0000007B00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000004D000000A2000000E4000000AE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4CA5004C4CA5004C4C
      E6004C4CE1000000000000000000000000000000000000000000000000004C4C
      ED004C4CC9004C4CA500A6A6A600000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD0000007B0000007B00BDBD
      BD00BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000006A000000A7000000D5000000C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4CA5004C4CED004C4C
      E600000000000000000000000000000000000000000000000000000000000000
      00004C4CED004C4CED00A6A6A600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000007B000000
      7B00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000097000000AD000000C7000000D500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A6A6A6004C4CED000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFBF00000000
      FFFFFF1F00000000CC3FFE0F00000000881FFC0700000000980FFF0300000000
      FF0FFF0F00000000FF0FFF0F00000000FF0FFF0F00000000FF0FFF0F00000000
      FF03980F00000000FC07881F00000000FE0FCC3F00000000FF1FFFFF00000000
      FFBFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFC3FFFFFFFF8FFFF
      FC3FFFFFFFF1E7FFFC3FFFFFE7E3E3E7FC3FFFFFE3C7E1E7FC3FFFFFF18FE1CF
      80018001F81FF08F80018001FC3FF01F80018001F81FF83F80018001F00FF83F
      FC3FFFFFE187E01FFC3FFFFFC3C3E20FFC3FFFFF87E1FF07FC3FFFFF8FF1FFCF
      FC3FFFFF9FFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Images = iActions
    Left = 137
    Top = 325
    object acIndex_AddField: TAction
      Category = 'Index'
      Caption = 'Add field to index'
      ImageIndex = 0
      OnExecute = acIndex_AddFieldExecute
      OnUpdate = acIndex_AddFieldUpdate
    end
    object acIndex_RemoveField: TAction
      Category = 'Index'
      Caption = 'Remove field from index'
      ImageIndex = 1
      OnExecute = acIndex_RemoveFieldExecute
      OnUpdate = acIndex_RemoveFieldUpdate
    end
    object acTable_Remove: TAction
      Category = 'Table'
      Caption = 'Remove selected table'
      ImageIndex = 2
    end
    object acField_remove: TAction
      Category = 'Field'
      Hint = 'Remove selected field'
      ImageIndex = 2
      OnExecute = acField_removeExecute
      OnUpdate = acField_removeUpdate
    end
    object acIndex_RemoveIndex: TAction
      Category = 'Index'
      ImageIndex = 2
      OnExecute = acIndex_RemoveIndexExecute
      OnUpdate = acIndex_RemoveIndexUpdate
    end
    object acRemoveConstraint: TAction
      Category = 'Constraint'
      OnExecute = acRemoveConstraintExecute
      OnUpdate = acRemoveConstraintUpdate
    end
    object acField_duplicate: TAction
      Category = 'Field'
      Caption = 'Duplicate field'
      OnExecute = acField_duplicateExecute
      OnUpdate = acField_duplicateUpdate
    end
    object acMoveUp: TAction
      Category = 'Field buttons'
      Hint = 'Move selected field up'
      ImageIndex = 4
      OnExecute = acMoveUpExecute
      OnUpdate = acMoveUpUpdate
    end
    object acMoveDown: TAction
      Category = 'Field buttons'
      Hint = 'Move selected field down'
      ImageIndex = 5
      OnExecute = acMoveDownExecute
      OnUpdate = acMoveDownUpdate
    end
    object acCopyListField: TAction
      Category = 'Field buttons'
      Caption = 'List of fields'
      OnExecute = acCopyListFieldExecute
      OnUpdate = acCopyListFieldUpdate
    end
    object acCopyListField_Insert: TAction
      Category = 'Field buttons'
      Caption = 'INSERT command'
      OnExecute = acCopyListField_InsertExecute
      OnUpdate = acCopyListField_InsertUpdate
    end
    object acCopyListField_Update: TAction
      Category = 'Field buttons'
      Caption = 'UPDATE command'
      OnExecute = acCopyListField_UpdateExecute
      OnUpdate = acCopyListField_UpdateUpdate
    end
  end
  object popFields: TAdvPopupMenu
    MenuStyler = AdvMenuOfficeStyler1
    Version = '2.7.1.19'
    UIStyle = tsCustom
    Left = 76
    Top = 251
    object miAddField: TMenuItem
      Caption = 'Add field'
      ImageIndex = 0
      ShortCut = 16454
      OnClick = miAddFieldClick
    end
    object miRemoveField: TMenuItem
      Action = acField_remove
      Caption = 'Remove selected field'
    end
    object miFindField: TMenuItem
      Caption = 'Find field...'
      ShortCut = 24646
      OnClick = miFindFieldClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miCopyField: TMenuItem
      Action = acField_duplicate
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miMoveFieldUp: TMenuItem
      Action = acMoveUp
      Caption = 'Move selected field up'
    end
    object miMoveFieldDown: TMenuItem
      Action = acMoveDown
      Caption = 'Move selected field down'
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Copyfieldlisttoclipboard2: TMenuItem
      Caption = 'Copy field list to clipboard'
      object Copyfieldlisttoclipboard1: TMenuItem
        Action = acCopyListField
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object INSERTcommand1: TMenuItem
        Action = acCopyListField_Insert
      end
      object UPDATEcommand1: TMenuItem
        Action = acCopyListField_Update
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object acViewRelationship: TMenuItem
      Caption = 'Open relationship'
      OnClick = acViewRelationshipClick
    end
  end
  object popIndexes: TAdvPopupMenu
    MenuStyler = AdvMenuOfficeStyler1
    Version = '2.7.1.19'
    UIStyle = tsCustom
    Left = 108
    Top = 251
    object miAddIndex: TMenuItem
      Caption = 'Add index'
      ImageIndex = 0
      ShortCut = 16457
      OnClick = miAddIndexClick
    end
    object MenuItem4: TMenuItem
      Action = acIndex_RemoveIndex
      Caption = 'Remove selected index'
    end
  end
  object popIndexFields: TAdvPopupMenu
    MenuStyler = AdvMenuOfficeStyler1
    Version = '2.7.1.19'
    UIStyle = tsCustom
    Left = 108
    Top = 283
    object MenuItem5: TMenuItem
      Action = acIndex_AddField
    end
    object MenuItem6: TMenuItem
      Action = acIndex_RemoveField
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
    ButtonAppearance.CaptionFont.Name = 'Tahoma'
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
    Left = 33
    Top = 365
  end
  object popConstraints: TAdvPopupMenu
    MenuStyler = AdvMenuOfficeStyler1
    Version = '2.7.1.19'
    UIStyle = tsCustom
    Left = 140
    Top = 251
    object miAddConstraint: TMenuItem
      Caption = 'Add constraint'
      ImageIndex = 0
      ShortCut = 16449
      OnClick = miAddConstraintClick
    end
    object MenuItem8: TMenuItem
      Action = acRemoveConstraint
      Caption = 'Remove selected constraint'
    end
  end
  object AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler
    AppColor.AppButtonColor = 13005312
    AppColor.AppButtonHoverColor = 16755772
    AppColor.TextColor = clWhite
    AppColor.HoverColor = 16246477
    AppColor.HoverTextColor = clBlack
    AppColor.HoverBorderColor = 15187578
    AppColor.SelectedColor = 15187578
    AppColor.SelectedTextColor = clBlack
    AppColor.SelectedBorderColor = 15187578
    Style = bsOffice2016White
    BorderColor = 13948116
    BorderColorHot = 14074033
    ButtonAppearance.Color = 16643823
    ButtonAppearance.ColorTo = 15784647
    ButtonAppearance.ColorChecked = 7131391
    ButtonAppearance.ColorCheckedTo = 7131391
    ButtonAppearance.ColorDown = 7131391
    ButtonAppearance.ColorDownTo = 8122111
    ButtonAppearance.ColorHot = 9102333
    ButtonAppearance.ColorHotTo = 14285309
    ButtonAppearance.BorderDownColor = clNone
    ButtonAppearance.BorderHotColor = clNone
    ButtonAppearance.BorderCheckedColor = 3181250
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = 16181724
    CaptionAppearance.CaptionColorTo = 16181724
    CaptionAppearance.CaptionTextColor = 5978398
    CaptionAppearance.CaptionBorderColor = 16181724
    CaptionAppearance.CaptionColorHot = 16117737
    CaptionAppearance.CaptionColorHotTo = 16117737
    CaptionAppearance.CaptionTextColorHot = 5978398
    CaptionAppearance.CaptionBorderColorHot = 16117737
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = clWhite
    Color.ColorTo = clWhite
    Color.Direction = gdVertical
    Color.Mirror.Color = 16775925
    Color.Mirror.ColorTo = 16445413
    Color.Mirror.ColorMirror = 16445413
    Color.Mirror.ColorMirrorTo = 16181724
    ColorHot.Color = 16248291
    ColorHot.ColorTo = 16643823
    ColorHot.Direction = gdVertical
    ColorHot.Mirror.Color = 16775925
    ColorHot.Mirror.ColorTo = 16445413
    ColorHot.Mirror.ColorMirror = 16445413
    ColorHot.Mirror.ColorMirrorTo = 16117737
    CompactGlowButtonAppearance.BorderColor = 13087391
    CompactGlowButtonAppearance.BorderColorHot = 5819121
    CompactGlowButtonAppearance.BorderColorDown = 3181250
    CompactGlowButtonAppearance.BorderColorChecked = 3181250
    CompactGlowButtonAppearance.Color = 16643823
    CompactGlowButtonAppearance.ColorTo = 15784647
    CompactGlowButtonAppearance.ColorChecked = 14285309
    CompactGlowButtonAppearance.ColorCheckedTo = 7131391
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 7131391
    CompactGlowButtonAppearance.ColorDownTo = 8122111
    CompactGlowButtonAppearance.ColorHot = 9102333
    CompactGlowButtonAppearance.ColorHotTo = 14285309
    CompactGlowButtonAppearance.ColorMirror = 15784647
    CompactGlowButtonAppearance.ColorMirrorTo = 15784647
    CompactGlowButtonAppearance.ColorMirrorHot = 14285309
    CompactGlowButtonAppearance.ColorMirrorHotTo = 9102333
    CompactGlowButtonAppearance.ColorMirrorDown = 8122111
    CompactGlowButtonAppearance.ColorMirrorDownTo = 7131391
    CompactGlowButtonAppearance.ColorMirrorChecked = 7131391
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 7131391
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = clWhite
    DockColor.ColorTo = clWhite
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    FloatingWindowBorderColor = 14074033
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    GlowButtonAppearance.BorderColor = 13948116
    GlowButtonAppearance.BorderColorHot = 15917525
    GlowButtonAppearance.BorderColorDown = 14925219
    GlowButtonAppearance.BorderColorChecked = 15914434
    GlowButtonAppearance.Color = clWhite
    GlowButtonAppearance.ColorTo = clNone
    GlowButtonAppearance.ColorChecked = 15914434
    GlowButtonAppearance.ColorCheckedTo = clNone
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 14925219
    GlowButtonAppearance.ColorDownTo = clNone
    GlowButtonAppearance.ColorHot = 15917525
    GlowButtonAppearance.ColorHotTo = clNone
    GlowButtonAppearance.ColorMirror = clWhite
    GlowButtonAppearance.ColorMirrorTo = clNone
    GlowButtonAppearance.ColorMirrorHot = 15917525
    GlowButtonAppearance.ColorMirrorHotTo = clNone
    GlowButtonAppearance.ColorMirrorDown = 14925219
    GlowButtonAppearance.ColorMirrorDownTo = clNone
    GlowButtonAppearance.ColorMirrorChecked = 15914434
    GlowButtonAppearance.ColorMirrorCheckedTo = clNone
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GlowButtonAppearance.TextColorChecked = 5263440
    GlowButtonAppearance.TextColorDown = 5263440
    GlowButtonAppearance.TextColorHot = 5263440
    GroupAppearance.Background = clInfoBk
    GroupAppearance.BorderColor = 1340927
    GroupAppearance.Color = 4636927
    GroupAppearance.ColorTo = 4636927
    GroupAppearance.ColorMirror = 4636927
    GroupAppearance.ColorMirrorTo = 4636927
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Segoe UI'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggVertical
    GroupAppearance.GradientMirror = ggVertical
    GroupAppearance.TextColor = clWhite
    GroupAppearance.CaptionAppearance.CaptionColor = 16181724
    GroupAppearance.CaptionAppearance.CaptionColorTo = 16181724
    GroupAppearance.CaptionAppearance.CaptionTextColor = 5978398
    GroupAppearance.CaptionAppearance.CaptionBorderColor = 16181724
    GroupAppearance.CaptionAppearance.CaptionColorHot = 16117737
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 16117737
    GroupAppearance.CaptionAppearance.CaptionTextColorHot = 5978398
    GroupAppearance.CaptionAppearance.CaptionBorderColorHot = 16117737
    GroupAppearance.PageAppearance.BorderColor = 13087391
    GroupAppearance.PageAppearance.Color = 16775925
    GroupAppearance.PageAppearance.ColorTo = 16445413
    GroupAppearance.PageAppearance.ColorMirror = 16445413
    GroupAppearance.PageAppearance.ColorMirrorTo = 16181724
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.PageAppearance.ShadowColor = 15126975
    GroupAppearance.PageAppearance.HighLightColor = 13416873
    GroupAppearance.TabAppearance.BorderColor = 13087391
    GroupAppearance.TabAppearance.BorderColorHot = 1340927
    GroupAppearance.TabAppearance.BorderColorSelected = 1340927
    GroupAppearance.TabAppearance.BorderColorSelectedHot = 1340927
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 16775925
    GroupAppearance.TabAppearance.ColorSelectedTo = 16775925
    GroupAppearance.TabAppearance.ColorDisabled = 15921906
    GroupAppearance.TabAppearance.ColorDisabledTo = 15921906
    GroupAppearance.TabAppearance.ColorHot = 16446701
    GroupAppearance.TabAppearance.ColorHotTo = 16710903
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 16710906
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 16710906
    GroupAppearance.TabAppearance.ColorMirrorSelected = 16775925
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 16775925
    GroupAppearance.TabAppearance.ColorMirrorDisabled = 15921906
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = 15921906
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggVertical
    GroupAppearance.TabAppearance.GradientMirror = ggVertical
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = 5978398
    GroupAppearance.TabAppearance.TextColorHot = 5978398
    GroupAppearance.TabAppearance.TextColorSelected = 5978398
    GroupAppearance.TabAppearance.TextColorDisabled = clGray
    GroupAppearance.TabAppearance.ShadowColor = 13087391
    GroupAppearance.TabAppearance.HighLightColor = 16775871
    GroupAppearance.TabAppearance.HighLightColorHot = 16643823
    GroupAppearance.TabAppearance.HighLightColorSelected = 13087391
    GroupAppearance.TabAppearance.HighLightColorSelectedHot = 15784647
    GroupAppearance.TabAppearance.HighLightColorDown = 16181209
    GroupAppearance.ToolBarAppearance.BorderColor = 13087391
    GroupAppearance.ToolBarAppearance.BorderColorHot = clHighlight
    GroupAppearance.ToolBarAppearance.Color.Color = 16775925
    GroupAppearance.ToolBarAppearance.Color.ColorTo = 16181724
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 16775925
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 16117737
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = 13087391
    PageAppearance.Color = 16775925
    PageAppearance.ColorTo = 16445413
    PageAppearance.ColorMirror = 16445413
    PageAppearance.ColorMirrorTo = 16181724
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PageAppearance.ShadowColor = 15126975
    PageAppearance.HighLightColor = 13416873
    PagerCaption.BorderColor = 13087391
    PagerCaption.Color = 16775925
    PagerCaption.ColorTo = 15389631
    PagerCaption.ColorMirror = 15389631
    PagerCaption.ColorMirrorTo = 15389631
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = clGray
    PagerCaption.TextColorExtended = clBlue
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -13
    PagerCaption.Font.Name = 'Segoe UI'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = 13087391
    QATAppearance.Color = 16643823
    QATAppearance.ColorTo = 15784647
    QATAppearance.FullSizeBorderColor = 13087391
    QATAppearance.FullSizeColor = 16643823
    QATAppearance.FullSizeColorTo = 15784647
    RightHandleColor = clWhite
    RightHandleColorTo = clWhite
    RightHandleColorHot = 15917525
    RightHandleColorHotTo = 15917525
    RightHandleColorDown = 14925219
    RightHandleColorDownTo = 14925219
    TabAppearance.BorderColor = 13087391
    TabAppearance.BorderColorHot = 12236209
    TabAppearance.BorderColorSelected = 14404024
    TabAppearance.BorderColorSelectedHot = 14404024
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 16775925
    TabAppearance.ColorSelectedTo = 16775925
    TabAppearance.ColorDisabled = 15921906
    TabAppearance.ColorDisabledTo = 15921906
    TabAppearance.ColorHot = 16446701
    TabAppearance.ColorHotTo = 16710903
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 16710906
    TabAppearance.ColorMirrorHotTo = 16710906
    TabAppearance.ColorMirrorSelected = 16775925
    TabAppearance.ColorMirrorSelectedTo = 16775925
    TabAppearance.ColorMirrorDisabled = 15921906
    TabAppearance.ColorMirrorDisabledTo = 15921906
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Segoe UI'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggVertical
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = 5978398
    TabAppearance.TextColorHot = 5978398
    TabAppearance.TextColorSelected = 5978398
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.ShadowColor = 13087391
    TabAppearance.HighLightColor = 16775871
    TabAppearance.HighLightColorHot = 16643823
    TabAppearance.HighLightColorSelected = 13087391
    TabAppearance.HighLightColorSelectedHot = 15784647
    TabAppearance.HighLightColorDown = 16181209
    TabAppearance.BackGround.Color = 16446701
    TabAppearance.BackGround.ColorTo = 16710906
    TabAppearance.BackGround.Direction = gdHorizontal
    Left = 384
    Top = 528
  end
end
