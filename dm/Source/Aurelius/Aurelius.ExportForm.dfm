object fmAureliusExport: TfmAureliusExport
  Left = 0
  Top = 0
  Caption = 'Export to TMS Aurelius Classes'
  ClientHeight = 545
  ClientWidth = 726
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    726
    545)
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 45
    Width = 84
    Height = 13
    Caption = 'Output directory:'
  end
  object edOutputDir: TAdvDirectoryEdit
    Left = 8
    Top = 59
    Width = 710
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
    Anchors = [akLeft, akTop, akRight]
    Color = clWindow
    ShortCut = 0
    TabOrder = 0
    Text = ''
    Visible = True
    OnChange = SaveProperty
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
    ExplicitWidth = 708
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 89
    Width = 710
    Height = 420
    ActivePage = tsGeneral
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    OnChange = PageControl1Change
    ExplicitWidth = 708
    ExplicitHeight = 412
    object tsGeneral: TTabSheet
      Caption = 'General Settings'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 0
        Top = 32
        Width = 293
        Height = 84
        Caption = 'Class Naming'
        TabOrder = 1
        object cbTableNameSource: TAdvComboBox
          Left = 10
          Top = 35
          Width = 145
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Table Name'
            'Table Caption')
          LabelCaption = 'Use name from:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 0
          OnChange = SaveProperty
        end
        object edTableNameFormat: TAdvEdit
          Left = 161
          Top = 35
          Width = 81
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Format Mask:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object cbTableNameSingularize: TCheckBox
          Left = 211
          Top = 60
          Width = 73
          Height = 17
          Caption = 'Singularize'
          TabOrder = 2
          OnClick = SaveProperty
        end
        object cbTableNameCamelCase: TCheckBox
          Left = 10
          Top = 60
          Width = 87
          Height = 17
          Caption = 'Camel Case'
          TabOrder = 3
          OnClick = SaveProperty
        end
        object cbTableNameRemoveUnderline: TCheckBox
          Left = 95
          Top = 60
          Width = 109
          Height = 17
          Caption = 'Remove underline'
          TabOrder = 4
          OnClick = SaveProperty
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 209
        Width = 293
        Height = 85
        Caption = 'Association Naming'
        TabOrder = 5
        object cbAssociationNameSource: TAdvComboBox
          Left = 10
          Top = 35
          Width = 145
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Parent Table Name'
            'Parent Table Caption'
            'Child Table Name'
            'Child Table Caption'
            'Parent Field Name'
            'Parent Field Caption'
            'Child Field Name'
            'Child Field Caption'
            'Relationship Caption')
          LabelCaption = 'Use name from:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 0
          OnChange = SaveProperty
        end
        object edAssociationNameFormat: TAdvEdit
          Left = 163
          Top = 35
          Width = 81
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Format Mask:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object cbAssociationNameCamelCase: TCheckBox
          Left = 10
          Top = 60
          Width = 87
          Height = 17
          Caption = 'Camel Case'
          TabOrder = 2
          OnClick = SaveProperty
        end
        object cbAssociationNameRemoveUnderline: TCheckBox
          Left = 95
          Top = 60
          Width = 109
          Height = 17
          Caption = 'Remove underline'
          TabOrder = 3
          OnClick = SaveProperty
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 118
        Width = 293
        Height = 87
        Caption = 'Property Naming'
        TabOrder = 4
        object cbFieldNameSource: TAdvComboBox
          Left = 10
          Top = 35
          Width = 145
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Field Name'
            'Field Caption')
          LabelCaption = 'Use name from:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 0
          OnChange = SaveProperty
        end
        object edFieldNameFormat: TAdvEdit
          Left = 163
          Top = 35
          Width = 81
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Format Mask:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object cbFieldNameCamelCase: TCheckBox
          Left = 10
          Top = 60
          Width = 87
          Height = 17
          Caption = 'Camel Case'
          TabOrder = 2
          OnClick = SaveProperty
        end
        object cbFieldNameRemoveUnderline: TCheckBox
          Left = 95
          Top = 60
          Width = 109
          Height = 17
          Caption = 'Remove underline'
          TabOrder = 3
          OnClick = SaveProperty
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 300
        Width = 293
        Height = 81
        Caption = 'Many Valued Association Naming'
        TabOrder = 6
        object cbManyValuedNameSource: TAdvComboBox
          Left = 10
          Top = 35
          Width = 145
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Parent Table Name'
            'Parent Table Caption'
            'Child Table Name'
            'Child Table Caption'
            'Parent Field Name'
            'Parent Field Caption'
            'Child Field Name'
            'Child Field Caption'
            'Relationship Caption')
          LabelCaption = 'Use name from:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 0
          OnChange = SaveProperty
        end
        object edManyValuedNameFormat: TAdvEdit
          Left = 163
          Top = 35
          Width = 81
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Format Mask:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object cbManyValuedNameSingularize: TCheckBox
          Left = 211
          Top = 60
          Width = 73
          Height = 17
          Caption = 'Singularize'
          TabOrder = 2
          OnClick = SaveProperty
        end
        object cbManyValuedNameCamelCase: TCheckBox
          Left = 10
          Top = 60
          Width = 87
          Height = 17
          Caption = 'Camel Case'
          TabOrder = 3
          OnClick = SaveProperty
        end
        object cbManyValuedNameRemoveUnderline: TCheckBox
          Left = 95
          Top = 60
          Width = 109
          Height = 17
          Caption = 'Remove underline'
          TabOrder = 4
          OnClick = SaveProperty
        end
      end
      object GroupBox5: TGroupBox
        Left = 299
        Top = 140
        Width = 390
        Height = 239
        Caption = 'Defaults'
        TabOrder = 7
        object cbDefaultOneToOneMapping: TAdvComboBox
          Left = 9
          Top = 124
          Width = 175
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Association'
            'Inheritance')
          LabelCaption = 'Map One-To-One Relationships As:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 4
          OnChange = SaveProperty
        end
        object cbDefaultAssociationFetchMode: TAdvComboBox
          Left = 9
          Top = 35
          Width = 175
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Lazy'
            'Eager')
          LabelCaption = 'Association Fetch Mode:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 0
          OnChange = SaveProperty
        end
        object cbDefaultManyValuedFetchMode: TAdvComboBox
          Left = 9
          Top = 79
          Width = 175
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Lazy'
            'Eager')
          LabelCaption = 'Many-Valued Association Fetch Mode:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 2
          OnChange = SaveProperty
        end
        object edDefaultAncestorClass: TAdvEdit
          Left = 201
          Top = 79
          Width = 160
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Ancestor Class:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          TabOrder = 3
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object edDefaultDynPropContainer: TAdvEdit
          Left = 201
          Top = 124
          Width = 160
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Dynamic Props Container Name:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          TabOrder = 5
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object cbCheckSequences: TAdvComboBox
          Left = 9
          Top = 168
          Width = 175
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'If supported by database'
            'Always'
            'Never')
          LabelCaption = 'Check for Missing Sequences:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 6
          OnChange = SaveProperty
        end
        object cbDefaultAssociationCascade: TAdvComboBox
          Left = 201
          Top = 35
          Width = 160
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'None'
            'All but Remove'
            'All')
          LabelCaption = 'Association Cascade Type:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 1
          OnChange = SaveProperty
        end
        object cbDefaultNonNativePascalTypeConvertion: TAdvComboBox
          Left = 201
          Top = 168
          Width = 160
          Height = 21
          Color = clWindow
          Version = '2.0.0.9'
          Visible = True
          ButtonWidth = 21
          DisabledBorder = False
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          Items.Strings = (
            'Variant'
            'String'
            'Integer')
          LabelCaption = 'Non Native Pascal type Convertion'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 7
          OnChange = SaveProperty
        end
      end
      object edMainUnitName: TAdvEdit
        Left = 79
        Top = 5
        Width = 146
        Height = 21
        EmptyTextStyle = []
        DisabledBorder = False
        DisabledColor = clWindow
        LabelCaption = 'Unit Name:'
        LabelPosition = lpLeftCenterLeft
        LabelMargin = 70
        LabelAlwaysEnabled = True
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
        Text = ''
        Visible = True
        OnChange = SaveProperty
        Version = '4.0.6.5'
      end
      object GroupBox6: TGroupBox
        Left = 300
        Top = 32
        Width = 206
        Height = 102
        Caption = 'Dictionary'
        TabOrder = 2
        object edDictionaryName: TAdvEdit
          Left = 9
          Top = 35
          Width = 90
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Global Var Name:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object edDictionaryUnitName: TAdvEdit
          Left = 109
          Top = 35
          Width = 88
          Height = 21
          EmptyTextStyle = []
          DisabledBorder = False
          DisabledColor = clWindow
          LabelCaption = 'Unit Name:'
          LabelPosition = lpTopLeft
          LabelAlwaysEnabled = True
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
          Text = ''
          Visible = True
          OnChange = SaveProperty
          Version = '4.0.6.5'
        end
        object cbLegacyDictionary: TCheckBox
          Left = 9
          Top = 60
          Width = 184
          Height = 17
          Caption = 'Legacy dictionary'
          TabOrder = 2
          OnClick = SaveProperty
        end
      end
      object GroupBox7: TGroupBox
        Left = 512
        Top = 32
        Width = 178
        Height = 102
        Caption = 'Options'
        TabOrder = 3
        object cbGenerateDictionary: TCheckBox
          Left = 13
          Top = 18
          Width = 144
          Height = 17
          Caption = 'Generate Dictionary'
          TabOrder = 0
          OnClick = SaveProperty
        end
        object cbCreateDescriptions: TCheckBox
          Left = 13
          Top = 36
          Width = 144
          Height = 17
          Caption = 'Create Descriptions'
          TabOrder = 1
          OnClick = SaveProperty
        end
        object cbRegisterEntities: TCheckBox
          Left = 13
          Top = 55
          Width = 144
          Height = 17
          Caption = 'Register Entities'
          TabOrder = 2
          OnClick = SaveProperty
        end
        object cbNoNullable: TCheckBox
          Left = 13
          Top = 74
          Width = 144
          Height = 17
          Caption = 'Don'#39't use Nullable<T>'
          TabOrder = 3
          OnClick = SaveProperty
        end
      end
    end
    object tsMappings: TTabSheet
      Caption = 'Mappings'
      DesignSize = (
        702
        392)
      object grTables: TAdvColumnGrid
        Left = 3
        Top = 3
        Width = 200
        Height = 385
        Anchors = [akLeft, akTop, akBottom]
        ColCount = 2
        DrawingStyle = gdsClassic
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        PopupMenu = pmMappings
        TabOrder = 0
        OnClick = grTablesClick
        OnKeyDown = grTablesKeyDown
        OnCheckBoxChange = grTablesCheckBoxChange
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          ''
          '')
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
        FixedColWidth = 24
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
        ScrollWidth = 21
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
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
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
            Width = 24
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
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
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
            Width = 172
          end>
        ExplicitHeight = 309
        ColWidths = (
          24
          172)
        RowHeights = (
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22)
      end
      object PageControl2: TPageControl
        Left = 208
        Top = 48
        Width = 491
        Height = 340
        ActivePage = tsAdvanced
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 3
        object tsFields: TTabSheet
          Caption = 'Fields'
          DesignSize = (
            483
            312)
          object grFields: TAdvColumnGrid
            Left = 1
            Top = 2
            Width = 153
            Height = 307
            Anchors = [akLeft, akTop, akBottom]
            ColCount = 2
            DrawingStyle = gdsClassic
            FixedCols = 0
            FixedRows = 0
            TabOrder = 0
            OnClick = grFieldsClick
            OnKeyDown = grFieldsKeyDown
            OnCheckBoxChange = grFieldsCheckBoxChange
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            ColumnHeaders.Strings = (
              '')
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
            FixedColWidth = 24
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
            ScrollWidth = 21
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
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
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
                Width = 24
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
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
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
                Width = 125
              end>
            ExplicitHeight = 341
            ColWidths = (
              24
              125)
            RowHeights = (
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22)
          end
          object edFieldName: TAdvEdit
            Left = 160
            Top = 18
            Width = 162
            Height = 21
            EmptyTextStyle = []
            DisabledBorder = False
            DisabledColor = clWindow
            LabelCaption = 'Property Name:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
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
            Text = ''
            Visible = True
            OnChange = SaveMappingsProperty
            Version = '4.0.6.5'
          end
          object chFieldNameDefault: TCheckBox
            Left = 328
            Top = 20
            Width = 145
            Height = 17
            Caption = 'Default'
            TabOrder = 2
            OnClick = SaveMappingsProperty
          end
          object cbFieldType: TAdvComboBox
            Left = 160
            Top = 60
            Width = 162
            Height = 21
            Color = clWindow
            Version = '2.0.0.9'
            Visible = True
            ButtonWidth = 21
            DisabledBorder = False
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            LabelCaption = 'Property Type:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            TabOrder = 3
            OnChange = SaveMappingsProperty
          end
          object chFieldTypeDefault: TCheckBox
            Left = 326
            Top = 62
            Width = 145
            Height = 17
            Caption = 'Default'
            TabOrder = 4
            OnClick = SaveMappingsProperty
          end
        end
        object tsAssociations: TTabSheet
          Caption = 'Associations'
          ImageIndex = 1
          DesignSize = (
            483
            312)
          object grAssociations: TAdvColumnGrid
            Left = 1
            Top = 2
            Width = 216
            Height = 306
            Anchors = [akLeft, akTop, akBottom]
            ColCount = 2
            DrawingStyle = gdsClassic
            FixedCols = 0
            FixedRows = 0
            TabOrder = 0
            OnClick = grAssociationsClick
            OnKeyDown = grAssociationsKeyDown
            OnCheckBoxChange = grAssociationsCheckBoxChange
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            ColumnHeaders.Strings = (
              '')
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
            FixedColWidth = 24
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
            ScrollWidth = 21
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
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
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
                Width = 24
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
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
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
                Width = 188
              end>
            ExplicitHeight = 230
            ColWidths = (
              24
              188)
            RowHeights = (
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22)
          end
          object chAssociationNameDefault: TCheckBox
            Left = 359
            Top = 20
            Width = 77
            Height = 17
            Caption = 'Default'
            TabOrder = 2
            OnClick = SaveMappingsProperty
          end
          object edAssociationName: TAdvEdit
            Left = 223
            Top = 18
            Width = 130
            Height = 21
            EmptyTextStyle = []
            DisabledBorder = False
            DisabledColor = clWindow
            LabelCaption = 'Association Property Name:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
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
            Text = ''
            Visible = True
            OnChange = SaveMappingsProperty
            Version = '4.0.6.5'
          end
          object cbOneToOneMapping: TAdvComboBox
            Left = 223
            Top = 144
            Width = 130
            Height = 21
            Color = clWindow
            Version = '2.0.0.9'
            Visible = True
            ButtonWidth = 21
            DisabledBorder = False
            Style = csDropDownList
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            Items.Strings = (
              '(Default)'
              'Association'
              'Inheritance')
            LabelCaption = 'Map this association as:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            TabOrder = 5
            OnChange = SaveMappingsProperty
          end
          object cbAssociationFetchMode: TAdvComboBox
            Left = 223
            Top = 59
            Width = 130
            Height = 21
            Color = clWindow
            Version = '2.0.0.9'
            Visible = True
            ButtonWidth = 21
            DisabledBorder = False
            Style = csDropDownList
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            Items.Strings = (
              '(Default)'
              'Lazy'
              'Eager')
            LabelCaption = 'Fetch Mode:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            TabOrder = 3
            OnChange = SaveMappingsProperty
          end
          object cbAssociationCascade: TAdvComboBox
            Left = 223
            Top = 101
            Width = 130
            Height = 21
            Color = clWindow
            Version = '2.0.0.9'
            Visible = True
            ButtonWidth = 21
            DisabledBorder = False
            Style = csDropDownList
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            Items.Strings = (
              '(Default)'
              'None'
              'All but Remove'
              'All')
            LabelCaption = 'Cascade:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            TabOrder = 4
            OnChange = SaveMappingsProperty
          end
        end
        object tsManyValued: TTabSheet
          Caption = 'Many-Valued Associations'
          ImageIndex = 2
          DesignSize = (
            483
            312)
          object grManyValued: TAdvColumnGrid
            Left = 1
            Top = 2
            Width = 216
            Height = 307
            Anchors = [akLeft, akTop, akBottom]
            ColCount = 2
            DrawingStyle = gdsClassic
            FixedCols = 0
            FixedRows = 0
            TabOrder = 0
            OnClick = grManyValuedClick
            OnKeyDown = grManyValuedKeyDown
            OnCheckBoxChange = grManyValuedCheckBoxChange
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            ColumnHeaders.Strings = (
              '')
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
            FixedColWidth = 24
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
            ScrollWidth = 21
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
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
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
                Width = 24
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
                Editor = edNormal
                FilterCaseSensitive = False
                Fixed = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
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
                Width = 188
              end>
            ExplicitHeight = 370
            ColWidths = (
              24
              188)
            RowHeights = (
              22
              22
              22
              22
              22
              22
              22
              22
              22
              22)
          end
          object chManyValuedNameDefault: TCheckBox
            Left = 351
            Top = 20
            Width = 130
            Height = 17
            Caption = 'Default'
            TabOrder = 2
            OnClick = SaveMappingsProperty
          end
          object edManyValuedName: TAdvEdit
            Left = 223
            Top = 18
            Width = 122
            Height = 21
            EmptyTextStyle = []
            DisabledBorder = False
            DisabledColor = clWindow
            LabelCaption = 'List Property Name:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
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
            Text = ''
            Visible = True
            OnChange = SaveMappingsProperty
            Version = '4.0.6.5'
          end
          object cbManyValuedFetchMode: TAdvComboBox
            Left = 223
            Top = 59
            Width = 122
            Height = 21
            Color = clWindow
            Version = '2.0.0.9'
            Visible = True
            ButtonWidth = 21
            DisabledBorder = False
            Style = csDropDownList
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            Items.Strings = (
              '(Default)'
              'Lazy'
              'Eager')
            LabelCaption = 'Fetch Mode:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            TabOrder = 3
            OnChange = SaveMappingsProperty
          end
        end
        object tsAdvanced: TTabSheet
          Caption = 'Advanced'
          ImageIndex = 3
          object edDynPropContainer: TAdvEdit
            Left = 5
            Top = 66
            Width = 234
            Height = 21
            EmptyTextStyle = []
            DisabledBorder = False
            DisabledColor = clWindow
            LabelCaption = 'Dynamic Props Container Name:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
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
            Text = ''
            Visible = True
            OnChange = SaveMappingsProperty
            Version = '4.0.6.5'
          end
          object chDynPropContainerDefault: TCheckBox
            Left = 245
            Top = 68
            Width = 73
            Height = 17
            Caption = 'Default'
            TabOrder = 2
            OnClick = SaveMappingsProperty
          end
          object cbSequence: TAdvComboBox
            Left = 5
            Top = 20
            Width = 292
            Height = 21
            Color = clWindow
            Version = '2.0.0.9'
            Visible = True
            ButtonWidth = 21
            DisabledBorder = False
            EmptyTextStyle = []
            DropWidth = 0
            Enabled = True
            ItemIndex = -1
            LabelCaption = 'Sequence/Generator for Id:'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            TabOrder = 0
            OnChange = SaveMappingsProperty
          end
          object edModelNames: TAdvEdit
            Left = 5
            Top = 110
            Width = 234
            Height = 21
            EmptyTextStyle = []
            DisabledBorder = False
            DisabledColor = clWindow
            LabelCaption = 'Models (Comma Separated):'
            LabelPosition = lpTopLeft
            LabelAlwaysEnabled = True
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
            TabOrder = 3
            Text = ''
            Visible = True
            OnChange = SaveMappingsProperty
            Version = '4.0.6.5'
          end
        end
      end
      object edTableName: TAdvEdit
        Left = 208
        Top = 21
        Width = 162
        Height = 21
        EmptyTextStyle = []
        DisabledBorder = False
        DisabledColor = clWindow
        LabelCaption = 'Class Name:'
        LabelPosition = lpTopLeft
        LabelAlwaysEnabled = True
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
        Text = ''
        Visible = True
        OnChange = SaveMappingsProperty
        Version = '4.0.6.5'
      end
      object chTableNameDefault: TCheckBox
        Left = 376
        Top = 23
        Width = 73
        Height = 17
        Caption = 'Default'
        TabOrder = 2
        OnClick = SaveMappingsProperty
      end
      object edClassUnitName: TAdvEdit
        Left = 440
        Top = 21
        Width = 153
        Height = 21
        EmptyTextStyle = []
        DisabledBorder = False
        DisabledColor = clWindow
        LabelCaption = 'Unit Name:'
        LabelPosition = lpTopLeft
        LabelAlwaysEnabled = True
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
        TabOrder = 4
        Text = ''
        Visible = True
        OnChange = SaveMappingsProperty
        Version = '4.0.6.5'
      end
    end
    object tsScript: TTabSheet
      Caption = 'Script'
      ImageIndex = 3
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 702
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Button1: TButton
          Left = 0
          Top = 3
          Width = 121
          Height = 25
          Caption = 'Declare Events'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 127
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Debug'
          TabOrder = 1
          OnClick = Button2Click
        end
      end
      object mmScript: TIDEMemo
        Left = 0
        Top = 33
        Width = 702
        Height = 359
        Cursor = crIBeam
        ActiveLineSettings.ShowActiveLine = False
        ActiveLineSettings.ShowActiveLineIndicator = False
        ActiveLineSettings.ActiveLineColor = 10066380
        ActiveLineSettings.ActiveLineTextColor = clBlack
        Align = alClient
        AutoCompletion.Font.Charset = DEFAULT_CHARSET
        AutoCompletion.Font.Color = clWindowText
        AutoCompletion.Font.Height = -11
        AutoCompletion.Font.Name = 'Tahoma'
        AutoCompletion.Font.Style = []
        AutoCompletion.StartToken = '(.'
        AutoCorrect.Active = True
        AutoHintParameterPosition = hpBelowCode
        BkColor = clWindow
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
        BreakpointColor = 16762823
        BreakpointTextColor = clBlack
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
        Gutter.GutterColorTo = clBtnFace
        Gutter.LineNumberTextColor = clWindowText
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'COURIER NEW'
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
        SelColor = clHighlightText
        SelBkColor = clHighlight
        ShowRightMargin = True
        SmartTabs = False
        SyntaxStyles = ScrPascalMemoStyler1
        TabOrder = 1
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
        Version = '3.9.2.0'
        WordWrap = wwNone
        OnChange = SaveProperty
      end
    end
    object tsPreview: TTabSheet
      Caption = 'Preview'
      ImageIndex = 2
      object pcSourceUnits: TPageControl
        Left = 0
        Top = 0
        Width = 702
        Height = 392
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object BitBtn2: TBitBtn
    Left = 638
    Top = 515
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    NumGlyphs = 2
    TabOrder = 4
    ExplicitLeft = 636
    ExplicitTop = 507
  end
  object btOk: TBitBtn
    Left = 552
    Top = 515
    Width = 80
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    NumGlyphs = 2
    TabOrder = 3
    OnClick = btOkClick
    ExplicitLeft = 550
    ExplicitTop = 507
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 5
    ExplicitWidth = 724
    object Shape1: TShape
      Left = 0
      Top = 37
      Width = 726
      Height = 1
      Align = alBottom
      Pen.Color = clGray
      ExplicitWidth = 582
    end
    object Shader1: TPanel
      Left = 0
      Top = 0
      Width = 726
      Height = 37
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 724
      object Image1: TImage
        Left = 2
        Top = 3
        Width = 32
        Height = 32
        AutoSize = True
        Picture.Data = {
          07544269746D617036080000424D360800000000000036040000280000002000
          0000200000000100080000000000000400000000000000000000000100000001
          000000000000000080000080000000808000800000008000800080800000C0C0
          C000C0DCC000F0CAA600CCFFFF0099FFFF0066FFFF0033FFFF00FFCCFF00CCCC
          FF0099CCFF0066CCFF0033CCFF0000CCFF00FF99FF00CC99FF009999FF006699
          FF003399FF000099FF00FF66FF00CC66FF009966FF006666FF003366FF000066
          FF00FF33FF00CC33FF009933FF006633FF003333FF000033FF00CC00FF009900
          FF006600FF003300FF00FFFFCC00CCFFCC0099FFCC0066FFCC0066FFCC0033FF
          CC0000FFCC00FFCCCC00CCCCCC0099CCCC0066CCCC0033CCCC0000CCCC00FF99
          CC00CC99CC009999CC006699CC003399CC000099CC00FF66CC00CC66CC009966
          CC006666CC003366CC000066CC00FF33CC00CC33CC009933CC006633CC003333
          CC000033CC00FF00CC00CC00CC009900CC006600CC003300CC000000CC00FFFF
          9900CCFF990099FF990066FF990033FF990000FF9900FFCC9900CCCC990099CC
          990066CC990033CC990000CC9900FF999900CC99990099999900669999003399
          990000999900FF669900CC66990099669900666699003366990000669900FF33
          9900CC33990099339900663399003333990000339900FF009900CC0099009900
          9900660099003300990000009900FFFF6600CCFF660099FF660066FF660033FF
          660000FF6600FFCC6600CCCC660099CC660066CC660033CC660000CC6600FF99
          6600CC99660099996600669966003399660000996600FF666600CC6666009966
          6600666666003366660000666600FF336600CC33660099336600663366003333
          660000336600FF006600CC00660099006600660066003300660000006600FFFF
          3300CCFF330099FF330066FF330033FF330000FF3300FFCC3300CCCC330099CC
          330066CC330033CC330000CC3300FF993300CC99330099993300669933003399
          330000993300FF663300CC66330099663300666633003366330000663300FF33
          3300CC33330099333300663333003333330000333300FF003300CC0033009900
          3300660033003300330000003300CCFF000099FF000066FF000033FF0000FFCC
          0000CCCC000099CC000066CC000033CC000000CC0000FF990000CC9900009999
          0000669900003399000000990000FF660000CC66000099660000666600000066
          000033660000FF330000CC33000099330000663300003333000000330000CC00
          00009900000066000000330000000000DD000000BB000000AA00000088000000
          770000005500000044000000220000DD000000BB000000AA0000008800000077
          0000005500000044000000220000DDDDDD005555550077777700777777004444
          4400222222001111110077000000550000004400000022000000F0FBFF00A4A0
          A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF0000FFFFFFFFFFFFFF000000FFFFFFFF00000000000000FFFFFFFF
          FFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFF0000FFFF
          FFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFF00FF
          FFFFFF00FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFF0000FFFFFFFFFFFFFFFF00
          FFFFFF00FFFFFFFFFFFFFFFF0000FFFF0000000000FFFF0000FFFFFFFFFFFF00
          FFFFFF00FFFFFFFFFFFF0000FFFF0000DEDE96DEDE0000FFFF00FFFFFFFFFF00
          FFFFFF00FFFFFFFFFF00FFFFFF00DEDE7272727272DEDE00FFFF00FFFFFFFF00
          FFFFFF00FFFFFFFF00FFFFFFFF0096724EDDDDDDDEDEDE00FFFFFF00FFFFFF00
          FFFFFFFF00FFFF00FFFFFFFF00DE72DDDD4E4EDDDD72DEDE00FFFFFF00FFFF00
          FFFFFFFF00FF00FFFFFFFFFF00DEDDDB4E4EDB4EDDDDDE9600FFFFFF00FF00FF
          FFFFFFFFFF0000FFFFFFFFFF00DE4EDBDBF9DB4E4E72DEDE00FFFFFFFF0000FF
          FFFFFFFFFF0000FFFFFFFFFF00DEDBDBFFDBF94EDDDD729600FFFFFFFF00FFFF
          FFFFFFFFFF00FF00FFFFFFFF00DEDBDBF9DBDBDBDDDDDE9600FFFFFF00FF00FF
          FFFFFFFF00FFFFFF00FFFFFFFF00DEDBF9DBDB4EDD72DE00FFFFFF00FFFF00FF
          FFFFFFFF00FFFFFFFF00FFFFFF00DE724EDB4EDD96DEDE00FFFF00FFFFFF00FF
          FFFFFFFF00FFFFFFFFFF00FFFFFF0000DE72DE96DE0000FFFF00FFFFFFFF00FF
          FFFFFFFF00FFFFFFFFFFFF0000FFFFFF0000000000FFFFFF00FFFFFFFFFF00FF
          FFFFFFFF00FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFF0000FFFFFFFFFF00FFFF
          FFFFFFFFFF00FFFFFFFFFFFFFFFFFF0000FFFFFF0000FFFFFFFFFFFFFF00FFFF
          FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFF0000FFFFFF
          FFFFFFFFFFFF0000FFFFFFFFFFFFFF000000FFFF00000000000000FFFFFFFFFF
          FFFFFFFFFFFFFFFF00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF}
        Transparent = True
      end
    end
  end
  object btSaveWithoutGenerating: TBitBtn
    Left = 8
    Top = 515
    Width = 137
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Save without Generating'
    NumGlyphs = 2
    TabOrder = 2
    OnClick = btSaveWithoutGeneratingClick
    ExplicitTop = 507
  end
  object FolderDialog1: TFolderDialog
    Options = [fdoNewDialogStyle]
    DialogX = 0
    DialogY = 0
    Version = '1.1.4.1'
    Left = 440
    Top = 64
  end
  object pmMappings: TPopupMenu
    Left = 365
    Top = 65
    object mnSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = mnSelectAllClick
    end
    object mnUnselectAll: TMenuItem
      Caption = 'Unselect All'
      OnClick = mnUnselectAllClick
    end
    object mnSelectIfPresent: TMenuItem
      Caption = 'Select if present in diagram'
    end
    object mnUnselectIfPresent: TMenuItem
      Caption = 'Unselect if present in diagram'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ModelNames1: TMenuItem
      Caption = 'Model Names'
      object mnUpdateFromDiagrams: TMenuItem
        Caption = 'Update from diagrams'
        OnClick = mnUpdateFromDiagramsClick
      end
      object mnUpdateFromDiagramDefault: TMenuItem
        Caption = 'Update from diagrams (include Default)'
        OnClick = mnUpdateFromDiagramDefaultClick
      end
      object ClearAll1: TMenuItem
        Caption = 'Clear All'
        OnClick = ClearAll1Click
      end
    end
  end
  object IDEEngine1: TIDEEngine
    Memo = mmScript
    Options.AutoHideTabControl = True
    FileExtPascalUnit = '.psc'
    FileExtForm = '.sfm'
    FileExtBasicUnit = '.bsc'
    AutoStyler = True
    ProjectExt = '.ssproj'
    Left = 528
    Top = 96
  end
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 24
  end
  object ScrPascalMemoStyler1: TScrPascalMemoStyler
    AutoBlockEnd = True
    BlockStart = 'begin,try,case,class,record,interface'
    BlockEnd = 'end'
    LineComment = '//'
    MultiCommentLeft = '{'
    MultiCommentRight = '}'
    CommentStyle.TextColor = clNavy
    CommentStyle.BkColor = clNone
    CommentStyle.Style = [fsItalic]
    NumberStyle.TextColor = clFuchsia
    NumberStyle.BkColor = clNone
    NumberStyle.Style = [fsBold]
    HighlightStyle.TextColor = clWhite
    HighlightStyle.BkColor = clRed
    HighlightStyle.Style = [fsBold]
    AllStyles = <
      item
        KeyWords.Strings = (
          'unit'
          'interface'
          'implementation'
          'uses'
          'const'
          'program'
          'private'
          'public'
          'published'
          'protected'
          'property'
          'function'
          'finalise'
          'initialise'
          'var'
          'begin'
          'with'
          'end'
          'for'
          'to'
          'do'
          'not'
          'if'
          'then'
          'else'
          'type'
          'while'
          'repeat'
          'until'
          'break'
          'continue'
          'virtual'
          'override'
          'default'
          'class'
          'stored'
          'inherited'
          'procedure'
          'constructor'
          'destructor'
          'finally'
          'raise'
          'string'
          'try'
          'except'
          'stdcall'
          'cdecl'
          'pascal'
          'nil'
          'case'
          'reintroduce'
          'packed'
          'record'
          'message'
          'in'
          'is'
          'shl'
          'shr'
          'mod'
          'div'
          'xor'
          'or'
          'and'
          'of'
          'set'
          'downto'
          'exports'
          'library'
          'as'
          'asm'
          'dynamic'
          'object'
          'threadvar'
          'file'
          'abstract'
          'overload'
          'assembler'
          'absolute'
          'automated'
          'external'
          'register'
          'dispinterface'
          'resourcestring'
          'near'
          'far'
          'label'
          'out'
          'safecall'
          'dispid'
          'array'
          'inline'
          'forward'
          'platform'
          'deprecated')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        BGColor = clNone
        StyleType = stKeyword
        BracketStart = #0
        BracketEnd = #0
        Info = 'Pascal Standard Default'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clNone
        StyleType = stBracket
        BracketStart = #39
        BracketEnd = #39
        Info = 'Simple Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clNone
        StyleType = stBracket
        BracketStart = '"'
        BracketEnd = '"'
        Info = 'Double Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clNone
        StyleType = stSymbol
        BracketStart = #0
        BracketEnd = #0
        Symbols = ' ,;:.(){}[]=+-*/^%<>#'#13#10
        Info = 'Symbols Delimiters'
      end
      item
        CommentLeft = '(*'
        CommentRight = '*)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsItalic]
        BGColor = clNone
        StyleType = stComment
        BracketStart = #0
        BracketEnd = #0
        Info = 'Multi line comment'
      end>
    AutoCompletion.Strings = (
      'ShowMessage'
      'MessageDlg')
    HintParameter.TextColor = clBlack
    HintParameter.BkColor = clInfoBk
    HintParameter.HintCharStart = '('
    HintParameter.HintCharEnd = ')'
    HintParameter.HintCharDelimiter = ';'
    HintParameter.HintClassDelimiter = '.'
    HintParameter.HintCharWriteDelimiter = ','
    HintParameter.Parameters.Strings = (
      'ShowMessage(const Msg: string);'
      
        'MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMs' +
        'gDlgButtons; HelpCtx: Longint): Integer);')
    HexIdentifier = '$'
    Description = 'Pascal'
    Filter = 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc'
    DefaultExtension = '.pas'
    StylerName = 'Pascal'
    Extensions = 'pas;dpr;dpk;inc'
    RegionDefinitions = <
      item
        Identifier = 'procedure'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'procedure'
        RegionEnd = 'forward'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'constructor'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'destructor'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'interface'
        RegionStart = 'interface'
        RegionType = rtOpen
        ShowComments = False
      end
      item
        Identifier = 'unit'
        RegionStart = 'unit'
        RegionType = rtFile
        ShowComments = False
      end
      item
        Identifier = 'implementation'
        RegionStart = 'implementation'
        RegionType = rtOpen
        ShowComments = False
      end
      item
        Identifier = 'case'
        RegionStart = 'case'
        RegionEnd = 'end'
        RegionType = rtIgnore
        ShowComments = False
      end
      item
        Identifier = 'try'
        RegionStart = 'try'
        RegionEnd = 'end'
        RegionType = rtIgnore
        ShowComments = False
      end
      item
        Identifier = 'function'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = '{$region'
        RegionStart = '{$region'
        RegionEnd = '{$endregion'
        RegionType = rtClosed
        ShowComments = False
      end>
    Left = 624
    Top = 96
  end
  object ScrMemoFindDialog1: TScrMemoFindDialog
    NotFoundMessage = 'Finished searching the document. The search item was not found.'
    AdvMemo = mmScript
    Options = [frDown]
    Left = 524
    Top = 57
  end
  object ActionList1: TActionList
    Left = 576
    Top = 96
    object acMemoFind: TAction
      Caption = 'Find'
      ShortCut = 16454
      OnExecute = acMemoFindExecute
      OnUpdate = memoActionUpdate
    end
  end
end
