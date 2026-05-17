object fmEditConversionMap: TfmEditConversionMap
  Left = 0
  Top = 0
  Caption = 'Data Type Conversion Map'
  ClientHeight = 433
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    483
    433)
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 44
    Width = 81
    Height = 13
    Caption = 'Source database'
  end
  object Label2: TLabel
    Left = 242
    Top = 44
    Width = 80
    Height = 13
    Caption = 'Target database'
  end
  object Label3: TLabel
    Left = 8
    Top = 85
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label4: TLabel
    Left = 8
    Top = 126
    Width = 77
    Height = 13
    Caption = 'Conversion map'
  end
  object grMap: TAdvColumnGrid
    Left = 8
    Top = 141
    Width = 467
    Height = 253
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultRowHeight = 19
    DrawingStyle = gdsClassic
    RowCount = 5
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goTabs]
    ParentFont = False
    TabOrder = 0
    OnGetEditText = grMapGetEditText
    OnSetEditText = grMapSetEditText
    OnGetDisplText = grMapGetDisplText
    OnCanEditCell = grMapCanEditCell
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    CellNode.TreeColor = clSilver
    ColumnHeaders.Strings = (
      'Source type'
      'Target type'
      'Size/Length'
      'Precision')
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
    FixedColWidth = 156
    FixedRowHeight = 19
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = []
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
        Header = 'Source type'
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
        Width = 156
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
        Header = 'Target type'
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
        Width = 155
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
        Header = 'Size/Length'
        HeaderAlignment = taCenter
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
        Width = 76
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
        Header = 'Precision'
        HeaderAlignment = taCenter
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
        Width = 76
      end>
    ExplicitWidth = 465
    ExplicitHeight = 271
    ColWidths = (
      156
      155
      76
      76)
    RowHeights = (
      19
      19
      19
      19
      19)
  end
  object cbSourceDB: TComboBox
    Left = 8
    Top = 58
    Width = 226
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 1
    OnChange = DBComboChange
  end
  object cbTargetDB: TComboBox
    Left = 242
    Top = 58
    Width = 231
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 2
    OnChange = DBComboChange
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 483
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 3
    object Shape1: TShape
      Left = 0
      Top = 37
      Width = 483
      Height = 1
      Align = alBottom
      Pen.Color = clGray
      ExplicitWidth = 396
    end
    object Shader1: TPanel
      Left = 0
      Top = 0
      Width = 483
      Height = 37
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Image1: TImage
        Left = 2
        Top = 3
        Width = 32
        Height = 32
        AutoSize = True
        Picture.Data = {
          07544269746D6170360C0000424D360C00000000000036000000280000002000
          0000200000000100180000000000000C00000000000000000000000000000000
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE9ECEEBEBEC1F9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFD0D5D7497391E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFB2B6BF007CCBBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF97A4B10093EF717B83E7E7E7FAFAFAE2E2E2A8ABAFEEEEEEFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          EAEAEAA9A3A3536F7A008FEE18638D7951436269690866A61B76B1CACACAFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9D9696966622
          BF7513D98C234F7982008AE70080D21D526B006FBC028ADE0091EE65412FABAB
          ABF3F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F59E7C52EDB569E9AE65
          F3C073FFCA774081A2008BE60080D20072BF158DE2129CFA0093F857625BA866
          0E856748D7D7D7FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1E1E1B9721DDF7C15E3B472FFFFFF
          FFFFFEFFFFF22682B9088BE50180D827A1F153C9FF1EA1FF0095F92A78A9CBAC
          8FB889478D5410BCBCBCFBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5CA750EE5892AED8F35E59D53E09D53
          E5A35BF7BE750877BC0486E54DC0FFA2FDFF3CB5FA28A8FF019AFB0080D9C0B0
          A1FFF9F8BA9663915004BCBCBCFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFCFCFCC27A20EA8B2AEE9238F79A42FF9E47FFA44E
          FFAB55FFB24A0063BE65CEFAA8FFFF56CAEA008AF332ADFF0C9FFF0091F96E5F
          46DDB37DF3E8D1BEA1738F5411C4C4C4F2F2F2FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFA98B6DEF8C23F19336FB9B40FEA249FFA851FFAE58
          FFB35EFFB3560590E372E8FF9DAA91FFB155008BFB2AABFF1FA5FE009AFF386B
          89D98239E89346DB8F44735E3E18618CB9B9B9FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFE2E2E2F08912F09032FB993DFEA146FFA84EFFAE56FFB45D
          FFB962E7B56C7EB0B6FFB85AFFCE71FFAE460084DA1CA5FF30AFFF009BFF007F
          D3D2762CCF8341205C7D0070C70095F36A6B6DF2F2F2FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFAE8B66F49029F79637FE9F42FFA64AFFAD52FFB35AFFB95F
          FFBE67FFC269FFCD6EE2AD59E5B460D380182C85B20CA1FF3AB2FF0BA0FF0092
          F6415E6A006AB90080D71694EE0096F4225E81C7C7C7FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFE17E08F49132FE9B3CFFA345FFAA4EFFB154FFB75DFFBD64
          FFC269FFCC74EAB259B6761DB87F28E99728769BA20099FF3DB4FF18A4FF0094
          F30076C50E8FE729A1FC2DA7FF0193F10087D9909090F8F8F8FFFFFFFFFFFFFF
          FFFFFFFFFFD1D1D1F88F1BF89534FE9F3FFFA648FFAD50FFB458FFBA5FFFC066
          FFC86DE7B35ABD7D1EE59C34F5C377FFB75ABBA4730093FF35B0FF2BABFF0492
          EF2199F535AFFF3CB4FF36AEFF1098F50090E9466578E2E2E2FFFFFFFFFFFFFF
          FFFFFFFFFFB8A697F99125FC9937FFA242FFA94AFFAE50FFB659FFBC60FFC267
          FFCA70E9A948ECC990FAD09CFAB562FDB968FCB35E008AFA2BABFF33B0FF27A1
          FD3BB8FF46C2FF3DB2FF3AAFFF229FF9008EE70772B8BCBCBCFDFDFDFFFFFFFF
          FFFFFFFFFFA98E77FB9429FE9C3AFFA445FFAB4AFFB152FFB658FFBE61FFC268
          FFC96EFFD77CD29034FFFBD4FDB969FDBF73FFC4630089DD1BA2FF3AB2FF42C0
          FF7FEAFF2CADFE3DB1FF38ACFF32A7FE098FE7008AE1717B82F1F1F1FFFFFFFF
          FFFFFFFFFFB7926EFC952AFFA040FFA649FFAB4CFFB253FFB858FFBE61FFC468
          FFCA6EFFD579CC8C3EFFDD99FFC179FFC47CFFC9734095BF0194FF64D5FFA6FF
          FF6CE1FF0594FB3EB0FF38ABFF38A7FF1B95EC0088DE276D9ACFCFCFFFFFFFFF
          FFFFFFFFFFAB917AFF962AFFA74CFFAD4FFFAD4DFFB151FFB859FFBE60FFC468
          FFCB6EF3C269DDA357FFDB98FFC279FFC47CFFC979769BA339BFFF8AFDFF6BAB
          B235718A029AFF3CACFF37A8FE37A5FB2A9AF10486DA0081D2999999F7F7F7FF
          FFFFFFFFFFBBA99EFF9527FFB25CFFB75FFFB052FFB251FFB656FFBD5DFFC366
          FFCA6EF0BB62ECCC99FFFFFFFFFEE8FEFADFFFFDD5ACC4BD58CFFFCBCCC3FFCD
          9394A39A008FF434A6FF37A6FD35A2F7339EF1128ADE0082D4446D88DBDBDBFF
          FFFFFFFFFFE3E0DCFF8F14FFBC6EFFCA7BFFB75FFFB153FFB554FFBA5CFFC163
          FFC76AFECC6EE6B46ADAA55EE1AB60E1A95EDBA55AF0B964D9984CFFF6D5FFD1
          8DC4BCAE0085EA2EA0F838A3F9329EF3349CEE2290E1007FCF0072BCB8B8B8FA
          FAFAFFFFFFFFFFFFFA8B0CFFBC6EFFEEAAFFCA7AFFB658FFB454FFB858FFBE5E
          FFC266FFC86CFFCE70FFD275FFD477FFD579FFDB7DDBAC64E2AE6FFED193FFD5
          9DFFD797007BDF259BF238A0F4319BED3199EA2C93E2077ECC0077C6627582EB
          EBEBFFFFFFFFFFFFB79273FFA743FFFFD2FFF3ACFFC570FFB558FFB655FFBA5A
          FFC05FFFC466FFC86CFFCB70FFCD72FFCE74F9C96FD4A56EFBD095FFDCA8FFD9
          A4FFDF9A007FCE1A92EA389EF03098EA2E94E42F94E542A1F158B5FF3C89BEF7
          F7F7FFFFFFFFFFFFF1F1F1FF9106FFEAB0FFFFF2FFEDA0FFC068FFB757FFB757
          FFBB5BFFBE5FFFC365FFC569FFC76CFFCE6DCEA066F4C488FFE0ADFFDEABFFDD
          AAFFE3A6328DBF0B8AE2359AEA2E94E22E95E442A2F271C7FF49A4E8EAEAEAFF
          FFFFFFFFFFFFFFFFFFFFFFB79882FFA737FFFFF9FFFFECFFE697FFBF68FFB759
          FFB756FFBA5BFFBC5FFFBE62FFC464DEA85EE5B27AFFE9C4FFECCBFDDDA8FFDC
          AAFFE5AC67A0B70081DB3194E32E95E446A4F372C8FF4A9DD8F4F4F4FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFDE8630FFBC60FFFFFFFFFFDDFFE091FFC068
          FFB75AFFB757FFB958FFBA5AF3B35ACD9E68F5D9B3F1DAB8F4ECDEFFFFFFFEE1
          B4FFD39599ACA7007AD52A90DE4BA6F572CBFF4E99CDFBFBFBFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFA8D1AFFB75AFFFFD6FFFFC4FFDA8C
          FFBF68FFB759FFB455FFB454FAB257F9B058E6A252F0A34AF2A043E0B477FFFF
          FFFFDFB2BF9B6E0074D044A1ED71CBFF5C97C0FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCDE8730FF9F2EFFCD84FFDB93
          FFC978FFB860FFB154FFAE4FFFAD4BFFAB4CFFAA49FFA546FFA040F8932FE3AE
          70FFD9ADC580370073CF76CFFF6996B4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB69782FF9304FF9D32
          FFA64AFFAA4EFFA747FFA344FFA240FFA03FFF9E3BFE9936F79028F1860AE97E
          00A88D70E2E2E21798F37B9CB4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1B79273
          F88C0DFF8E0EFF951CFF9823FF9524FF941EFB8E12F68A05DB7A07AB8A67E3E3
          E3FFFFFFFFFFFFCEDEE9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFE8E6E3C3B4A5B09B83B59977AD9880BEAF9FD8D6D5FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF}
        Transparent = True
        OnDblClick = Image1DblClick
      end
    end
  end
  object edName: TEdit
    Left = 8
    Top = 99
    Width = 465
    Height = 21
    TabOrder = 4
    OnChange = edNameChange
  end
  object btCancel: TButton
    Left = 400
    Top = 400
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 5
    OnClick = btCancelClick
  end
  object btOk: TButton
    Left = 319
    Top = 400
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    TabOrder = 6
    OnClick = btOkClick
  end
end
