object fmRelationshipEditor: TfmRelationshipEditor
  Left = 0
  Top = 0
  Width = 700
  Height = 471
  TabOrder = 0
  OnResize = FrameResize
  object Splitter1: TSplitter
    Left = 700
    Top = 0
    Height = 420
    ExplicitLeft = 697
    ExplicitTop = -139
    ExplicitHeight = 597
  end
  object pnRelationship: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 420
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 5
    Color = clWhite
    Constraints.MinWidth = 300
    TabOrder = 0
    object ScrollBox1: TScrollBox
      Left = 5
      Top = 5
      Width = 690
      Height = 410
      HorzScrollBar.Style = ssFlat
      VertScrollBar.Style = ssFlat
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      object AdvPanel4: TAdvPanel
        Left = 0
        Top = 0
        Width = 690
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
        Caption.Text = 'Relationship properties'
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
          690
          74)
        FullHeight = 68
        object Label1: TLabel
          Left = 5
          Top = 27
          Width = 100
          Height = 13
          AutoSize = False
          Caption = 'Relationship name'
          FocusControl = edRelationName
        end
        object Label3: TLabel
          Tag = 1
          Left = 217
          Top = 27
          Width = 247
          Height = 13
          AutoSize = False
          Caption = 'Description'
          FocusControl = eddesc
        end
        object edRelationName: TEdit
          Left = 5
          Top = 41
          Width = 200
          Height = 21
          TabOrder = 0
          OnChange = edRelationNameChange
        end
        object eddesc: TEdit
          Left = 217
          Top = 41
          Width = 463
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = eddescChange
        end
      end
      object pnRelationKeys: TAdvPanel
        Left = 0
        Top = 74
        Width = 690
        Height = 200
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
        Caption.Text = 'Relationship keys'
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
        FullHeight = 200
        object gKeys: TAdvColumnGrid
          Left = 5
          Top = 53
          Width = 680
          Height = 115
          Align = alClient
          ColCount = 2
          DefaultColWidth = 130
          DefaultRowHeight = 21
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
          ParentFont = False
          TabOrder = 1
          GridLineColor = 15527152
          GridFixedLineColor = 13947601
          OnCanEditCell = gKeysCanEditCell
          OnComboChange = gKeysComboChange
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ActiveCellColor = 16575452
          ActiveCellColorTo = 16571329
          CellNode.TreeColor = clSilver
          ColumnHeaders.Strings = (
            'Parent table'
            'Detail table')
          ColumnSize.Stretch = True
          ColumnSize.StretchColumn = 1
          ControlLook.FixedGradientMirrorFrom = 16049884
          ControlLook.FixedGradientMirrorTo = 16247261
          ControlLook.FixedGradientHoverFrom = 16710648
          ControlLook.FixedGradientHoverTo = 16446189
          ControlLook.FixedGradientHoverMirrorFrom = 16049367
          ControlLook.FixedGradientHoverMirrorTo = 15258305
          ControlLook.FixedGradientDownFrom = 15853789
          ControlLook.FixedGradientDownTo = 15852760
          ControlLook.FixedGradientDownMirrorFrom = 15522767
          ControlLook.FixedGradientDownMirrorTo = 15588559
          ControlLook.FixedGradientDownBorder = 14007466
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
          FixedColWidth = 340
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clBlack
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          HoverButtons.Buttons = <>
          HTMLSettings.ImageFolder = 'images'
          HTMLSettings.ImageBaseName = 'img'
          Look = glWin7
          Navigation.EditSelectAll = False
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
          SearchFooter.Color = 16645370
          SearchFooter.ColorTo = 16247261
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
          SortSettings.HeaderColor = 16579058
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          UIStyle = tsWindows7
          VAlignment = vtaCenter
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
              Header = 'Parent table'
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
              ReadOnly = True
              ShowBands = False
              SortStyle = ssAutomatic
              SpinMax = 0
              SpinMin = 0
              SpinStep = 1
              Tag = 0
              Width = 340
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
              Editor = edComboList
              FilterCaseSensitive = False
              Fixed = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Header = 'Detail table'
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
              Width = 336
            end>
          ExplicitTop = 52
          ExplicitWidth = 745
          ExplicitHeight = 113
          ColWidths = (
            340
            336)
        end
        object pnParentKey: TPanel
          Left = 5
          Top = 23
          Width = 680
          Height = 30
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label2: TLabel
            Left = 2
            Top = 3
            Width = 56
            Height = 13
            Caption = 'Parent key:'
          end
          object cbParentKey: TComboBox
            Left = 64
            Top = 0
            Width = 250
            Height = 21
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbParentKeyChange
            OnDrawItem = cbParentKeyDrawItem
          end
        end
        object pnTipo: TPanel
          Tag = 20
          Left = 5
          Top = 168
          Width = 680
          Height = 27
          Align = alBottom
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Color = clWhite
          TabOrder = 2
          Visible = False
        end
      end
      object AdvPanel2: TAdvPanel
        Left = 0
        Top = 274
        Width = 690
        Height = 135
        Align = alTop
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
        Caption.Text = 'Relationship options'
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
        FullHeight = 68
        object rgMetodoExclusao: TRadioGroup
          Tag = 20
          Left = 5
          Top = 25
          Width = 140
          Height = 107
          Caption = 'On parent delete'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Items.Strings = (
            'Restrict'
            'Cascade'
            'Set null'
            'Set default'
            'No action')
          ParentFont = False
          TabOrder = 0
          OnClick = rgMetodoExclusaoClick
        end
        object rgMetodoAlteracao: TRadioGroup
          Tag = 5
          Left = 160
          Top = 25
          Width = 140
          Height = 107
          Caption = 'On parent update'
          Items.Strings = (
            'Restrict'
            'Cascade'
            'Set null'
            'Set default'
            'No action')
          TabOrder = 1
          OnClick = rgMetodoAlteracaoClick
        end
      end
    end
  end
  object pnLinks: TAdvDockPanel
    Left = 0
    Top = 420
    Width = 700
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
      Width = 694
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
    Width = 0
    Height = 420
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
  end
  object dsChave: TDataSource
    Left = 172
    Top = 272
  end
  object ImageList1: TImageList
    Left = 136
    Top = 272
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A6A6A600A6A6A600A6A6A6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A6A6A6004C4CA5004C4CA500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C4C
      A5004C4CA5000000000000000000000000000000000000000000000000004C4C
      A5004C4CAC004C4CAB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C4C
      ED004C4CC9004C4CA500000000000000000000000000000000004C4CA5004C4C
      B2004C4CB1000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004C4CED004C4CC9004C4CA50000000000000000004C4CA5004C4CB8004C4C
      B700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000002800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000020000002E00000000000000000000000000000000000000
      0000000000004C4CED004C4CC9004C4CA5004C4CA5004C4CBF004C4CBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000004A00000041000000
      4400000046000000470000004700000047000000470000004700000047000000
      4700000048000000480000005300000000000000000000000000000000000000
      000000000000000000004C4CED004C4CC9004C4CC6004C4CC300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008C000000B3000000
      E9000000FB000000FC000000FC000000FC000000FC000000FC000000FC000000
      FC000000ED000000BA0000009400000000000000000000000000000000000000
      0000000000004C4CC9004C4CA5004C4CCC004C4CC9004C4CA5004C4CA5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000C3000000D2000000
      DB000000DD000000DD000000DD000000DD000000DD000000DD000000DD000000
      DD000000DD000000D6000000CA00000000000000000000000000000000000000
      00004C4CC9004C4CA5004C4CD2004C4CCF004C4CED004C4CC9004C4CA5004C4C
      A500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004C4C
      A5004C4CA5004C4CD9004C4CD50000000000000000004C4CED004C4CC9004C4C
      A5004C4CA5000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004C4CA5004C4C
      A5004C4CE0004C4CDB00000000000000000000000000000000004C4CED004C4C
      C9004C4CA5004C4CA50000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4CA5004C4CA5004C4C
      E6004C4CE1000000000000000000000000000000000000000000000000004C4C
      ED004C4CC9004C4CA500A6A6A600000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4CA5004C4CED004C4C
      E600000000000000000000000000000000000000000000000000000000000000
      00004C4CED004C4CED00A6A6A600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000200080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000060000000
      400080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800000003F0040404000FFFFFF000000000000000000000000000000
      0000000000000000000000003B000000300000004A0000007A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B0000007B0000007B000000FFFFFF00FFFFFF00000000000000
      6000000080000000400080808000FFFFFF00FFFFFF00FFFFFF00808080000000
      200000007F0040406F00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000002C0000003B000000680000008200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B00000000FFFF007B000000FFFFFF00FFFFFF00FFFFFF000000
      000000006000000080000000800000004000808080000000200000007F000000
      DF0040406F00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000002D00000060000000A20000008D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B000000
      0000000000007B0000007B0000007B000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000006000000040000000200000007F000000DF000000FF004040
      6F00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000280000006A000000AF0000008800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B0000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000200000007F000000DF000000FF000000FF0000005F004040
      570000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000001800000050000000890000006D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00808080000000
      200000007F000000DF000000FF000000FF000000FF0000005F00000080000000
      8000000060004040570000000000FFFFFF000000000000003C00000024000000
      1F0000001B000000130000001800000047000000730000005F0000004A000000
      3700000037000000520000007F00000000007B0000007B0000007B0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B0000007B0000007B0000007B0000007B0000007B0000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000007B0000007B0000007B000000808080000000400000007F000000
      DF000000FF000000FF000000FF000000FF0000005F0000008000000080000000
      800000008000000080000000600040406F000000000000003C00000041000000
      5C00000064000000510000004C00000086000000B50000009900000091000000
      8B0000008D000000900000009800000000007B00000000FFFF007B0000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B00000000FFFF007B0000007B00000000FFFF007B0000007B7B
      7B00000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B00000000FFFF007B000000000000006F6F6F007F7FBF003F3F
      FF000000FF000000FF000000FF0000005F000000800000008000000080000000
      8000000080000000BF0000007F00000000000000000000005F0000007F000000
      B6000000C30000009F00000089000000C6000000F6000000D6000000DF000000
      EA000000E7000000CF000000BB00000000007B0000007B0000007B0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B0000007B0000007B0000007B0000007B0000007B0000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000007B0000007B0000007B000000FFFFFF00FFFFFF00000000006F6F
      6F007F7FBF007F7FFF0000005F00000080000000800000008000000080000000
      BF0000007F0080808000FFFFFF00FFFFFF00000000000000910000009A000000
      A30000009E0000008600000079000000AF000000DC000000BF000000BD000000
      BA000000BB000000C7000000D400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000020000000800000008000000080000000BF0000007F004040
      4000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000064000000A7000000E0000000B800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B0000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004040570000008000000080000000BF0000007F003F3F3F000000FF000000
      BF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000004E0000009E000000E4000000AE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B000000
      0000000000007B0000007B0000007B000000FFFFFF00FFFFFF00FFFFFF004040
      5700000080000000BF0000007F0080808000FFFFFF00808080007F7F7F007F7F
      FF000000BF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000004D000000A2000000E4000000AE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B00000000FFFF007B000000FFFFFF00FFFFFF00404057000000
      BF0000007F0080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      80007F7F7F007F7FBF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000006A000000A7000000D5000000C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B0000007B0000007B000000FFFFFF0040406F0000007F008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00808080003F3F3F00000000000000000000000000000000000000
      00000000000000000000000097000000AD000000C7000000D500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFF8FFFF0000
      FFFFFFF1FFFF0000FFFFE7E3FEFF0000FFFFE3C7FC7F0000FFFFF18FFC3F0000
      8001F81FFC7F00008001FC3FFC3F00008001F81FFC7F00008001F00FF83F0000
      FFFFE187F01F0000FFFFC3C3F01F0000FFFF87E1F01F0000FFFF8FF1F83F0000
      FFFF9FFFFFFF0000FFFFFFFFFFFF0000FFFFFFFF8000FFFFFFFFFFFF4000FC3F
      FFFFFFF82000FC3FFFFFFFE01000FC3FFFFFFF980800FC3FFFFFFE7F0008FC3F
      FFFFF9FF000280011FF817F80000800100000800800180011FF817F820008001
      FFFFF9FF0800FC3FFFFFFE7F0008FC3FFFFFFF980004FC3FFFFFFFE00002FC3F
      FFFFFFF80001FC3FFFFFFFFF8001FFFF00000000000000000000000000000000
      000000000000}
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
    Left = 209
    Top = 269
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
    Left = 432
    Top = 376
  end
end
