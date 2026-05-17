object fmRelationshipDialog: TfmRelationshipDialog
  Left = 0
  Top = 0
  Caption = 'Add relationship'
  ClientHeight = 439
  ClientWidth = 576
  Color = clBtnFace
  Constraints.MinHeight = 466
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 13
  inline RelationshipEditor: TfmRelationshipEditor
    Left = 0
    Top = 0
    Width = 576
    Height = 404
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 576
    ExplicitHeight = 404
    inherited Splitter1: TSplitter
      Left = 576
      Height = 353
      ExplicitLeft = 576
      ExplicitHeight = 353
    end
    inherited pnRelationship: TPanel
      Width = 576
      Height = 353
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 576
      ExplicitHeight = 353
      inherited ScrollBox1: TScrollBox
        Width = 566
        Height = 343
        ExplicitWidth = 566
        ExplicitHeight = 343
        inherited AdvPanel4: TAdvPanel
          Width = 549
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 549
          FullHeight = 68
          inherited Label1: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label3: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited edRelationName: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited eddesc: TEdit
            Width = 322
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 322
          end
        end
        inherited pnRelationKeys: TAdvPanel
          Width = 549
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 549
          FullHeight = 200
          inherited gKeys: TAdvColumnGrid
            Width = 539
            FixedColWidth = 372
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
                Width = 372
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
                Width = 163
              end>
            ExplicitWidth = 539
            ColWidths = (
              372
              163)
            RowHeights = (
              22
              21
              21
              21
              21)
          end
          inherited pnParentKey: TPanel
            Width = 539
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 539
            inherited Label2: TLabel
              StyleElements = [seFont, seClient, seBorder]
            end
            inherited cbParentKey: TComboBox
              StyleElements = [seFont, seClient, seBorder]
            end
          end
          inherited pnTipo: TPanel
            Width = 539
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 539
          end
        end
        inherited AdvPanel2: TAdvPanel
          Width = 549
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 549
          FullHeight = 68
        end
      end
    end
    inherited pnLinks: TAdvDockPanel
      Top = 353
      Width = 576
      ExplicitTop = 353
      ExplicitWidth = 576
      inherited barLinks: TAdvToolBar
        Width = 570
        ExplicitWidth = 570
      end
    end
    inherited pnBlank: TPanel
      Left = 579
      Width = 45
      Height = 353
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 579
      ExplicitWidth = 45
      ExplicitHeight = 353
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 404
    Width = 576
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      576
      35)
    object Button1: TButton
      Left = 415
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 496
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
