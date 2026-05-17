object frElevateDBCfg: TfrElevateDBCfg
  Left = 0
  Top = 0
  Width = 496
  Height = 401
  TabOrder = 0
  DesignSize = (
    496
    401)
  object PageControl1: TPageControl
    Left = 87
    Top = 45
    Width = 321
    Height = 327
    ActivePage = tsBasic
    Anchors = []
    TabOrder = 0
    ExplicitLeft = 106
    ExplicitTop = 58
    object tsBasic: TTabSheet
      Caption = 'Basic'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 313
        Height = 297
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        ExplicitHeight = 299
        DesignSize = (
          313
          297)
        object Label4: TLabel
          Left = 8
          Top = 129
          Width = 56
          Height = 15
          Caption = 'User name'
        end
        object Label5: TLabel
          Left = 156
          Top = 129
          Width = 50
          Height = 15
          Caption = 'Password'
        end
        object Label3: TLabel
          Left = 8
          Top = 177
          Width = 48
          Height = 15
          Caption = 'Database'
        end
        object Label7: TLabel
          Left = 8
          Top = 36
          Width = 58
          Height = 15
          Caption = 'Server type'
        end
        object pnLocal: TPanel
          Left = 8
          Top = 83
          Width = 297
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 3
          DesignSize = (
            297
            41)
          object Label6: TLabel
            Left = 0
            Top = 0
            Width = 63
            Height = 15
            Caption = 'Config path'
          end
          object edConfigPath: TAdvDirectoryEdit
            Left = 0
            Top = 15
            Width = 297
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
            BrowseDialogText = 'Select Directory'
          end
        end
        object pnRemote: TPanel
          Left = 8
          Top = 83
          Width = 297
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
          DesignSize = (
            297
            41)
          object Label1: TLabel
            Left = 0
            Top = 0
            Width = 32
            Height = 15
            Caption = 'Server'
          end
          object Label2: TLabel
            Left = 247
            Top = 0
            Width = 22
            Height = 15
            Anchors = [akTop, akRight]
            Caption = 'Port'
          end
          object edServer: TEdit
            Left = 0
            Top = 14
            Width = 241
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
          end
          object edPort: TAdvLUEdit
            Left = 247
            Top = 14
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
            Lookup.Font.Name = 'Segoe UI'
            Lookup.Font.Style = []
            Lookup.Separator = ';'
            Anchors = [akTop, akRight]
            Color = clWindow
            TabOrder = 1
            Text = '12010'
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
          end
        end
        object TestConButton: TBitBtn
          Left = 182
          Top = 224
          Width = 123
          Height = 25
          Anchors = [akTop, akRight]
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
          TabOrder = 7
          OnClick = TestConButtonClick
        end
        object edUserName: TEdit
          Left = 8
          Top = 144
          Width = 142
          Height = 21
          Enabled = False
          TabOrder = 5
        end
        object cbDatabase: TComboBox
          Left = 8
          Top = 192
          Width = 297
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 6
          OnDropDown = cbDatabaseDropDown
        end
        object rbLocal: TRadioButton
          Left = 8
          Top = 10
          Width = 75
          Height = 17
          Caption = 'Local'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbLocalClick
        end
        object rbRemote: TRadioButton
          Left = 104
          Top = 10
          Width = 75
          Height = 17
          Caption = 'Remote'
          TabOrder = 1
          OnClick = rbLocalClick
        end
        object cbServerType: TComboBox
          Left = 8
          Top = 51
          Width = 142
          Height = 23
          Style = csDropDownList
          TabOrder = 2
          Items.Strings = (
            'ANSI'
            'Unicode')
        end
        object cbAdvanced: TCheckBox
          Left = 8
          Top = 228
          Width = 168
          Height = 17
          Caption = 'Override advanced options'
          TabOrder = 8
          OnClick = cbAdvancedClick
        end
      end
    end
    object tsAdvanced: TTabSheet
      Caption = 'Advanced'
      ImageIndex = 1
      object grAdvanced: TAdvStringGrid
        Left = 0
        Top = 0
        Width = 313
        Height = 299
        Align = alClient
        ColCount = 2
        Ctl3D = True
        DrawingStyle = gdsClassic
        RowCount = 13
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnGetEditorType = grAdvancedGetEditorType
        OnGetEditorProp = grAdvancedGetEditorProp
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
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
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
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
        FixedColWidth = 130
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
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurrence'
        SearchFooter.HintFindPrev = 'Find previous occurrence'
        SearchFooter.HintHighlight = 'Highlight occurrences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SearchFooter.ResultFormat = '(%d of %d)'
        ShowDesignHelper = False
        Version = '9.2.2.0'
        ExplicitLeft = 3
        ExplicitHeight = 328
        ColWidths = (
          130
          178)
      end
    end
  end
end
