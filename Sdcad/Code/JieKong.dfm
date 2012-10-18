object JieKongForm: TJieKongForm
  Left = 259
  Top = 139
  BorderStyle = bsDialog
  Caption = #20511#38075#23380#21015#34920
  ClientHeight = 413
  ClientWidth = 711
  Color = clBtnFace
  Constraints.MinHeight = 50
  Constraints.MinWidth = 130
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 5
    Top = 9
    Width = 252
    Height = 393
    Color = 15198183
    TabOrder = 0
    object Label2: TLabel
      Left = 25
      Top = 18
      Width = 48
      Height = 12
      Caption = #24037#31243#21015#34920
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object sgProject: TStringGrid
      Left = 9
      Top = 42
      Width = 240
      Height = 345
      ColCount = 2
      Ctl3D = False
      FixedColor = 15198183
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentCtl3D = False
      TabOrder = 0
      OnSelectCell = sgProjectSelectCell
      RowHeights = (
        24
        24)
    end
  end
  object Panel2: TPanel
    Left = 264
    Top = 9
    Width = 441
    Height = 393
    Color = 15198183
    TabOrder = 1
    object lblAllDrills: TLabel
      Left = 32
      Top = 17
      Width = 96
      Height = 12
      Caption = #24037#31243#25152#26377#38075#23380#21015#34920
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 295
      Top = 17
      Width = 60
      Height = 12
      Caption = #20511#38075#23380#21015#34920
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object sgJieDrills: TStringGrid
      Left = 295
      Top = 41
      Width = 140
      Height = 345
      ColCount = 3
      Ctl3D = False
      FixedColor = 15198183
      FixedCols = 2
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goEditing]
      ParentCtl3D = False
      TabOrder = 0
    end
    object btnAdd: TButton
      Left = 213
      Top = 187
      Width = 68
      Height = 25
      Caption = #21333#23380#20511#20837'  >'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btn_cancel: TBitBtn
      Left = 213
      Top = 271
      Width = 68
      Height = 25
      Hint = #36820#22238
      Cancel = True
      Caption = #36820#22238
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDD0000777777777777777DDDD7000077777777777777FDFD7700007777
        777777777F3F37770000444444077777FFF4444D0000DDDDD450777F3FF4DDDD
        0000DDDDD45507FFFFF4DDDD0000DDDDD45550FFFFF4DDDD0000DDD0045550FF
        FFF4DDDD0000DDD0A05550FFFFF4DDDD00000000EA0550FFFEF4DDDD00000EAE
        AEA050FFFFF4DDDD00000AEAEAEA00FEFEF4DDDD00000EAEAEA050FFFFF4DDDD
        00000000EA0550FEFEF4DDDD0000DDD0A05550EFEFE4DDDD0000DDD0045550FE
        FEF4DDDD0000DDDDD45550EFEFE4DDDD0000DDDDD44444444444DDDD0000DDDD
        DDDDDDDDDDDDDDDD0000}
    end
    object btnShouGong: TButton
      Left = 213
      Top = 143
      Width = 68
      Height = 25
      Caption = #25163#24037#36755#20837
      TabOrder = 3
      Visible = False
      OnClick = btnShouGongClick
    end
    object btnAddAll: TButton
      Left = 213
      Top = 229
      Width = 68
      Height = 25
      Caption = #20840#37096#20511#20837'>>>'
      TabOrder = 4
      OnClick = btnAddAllClick
    end
    object sgAllDrills: TcxGrid
      Left = 16
      Top = 42
      Width = 185
      Height = 343
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      DragOpening = False
      LookAndFeel.NativeStyle = True
      object sgAllDrillsTableView1: TcxGridTableView
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Appending = True
        OptionsView.GroupByBox = False
        object sgAllDrillsTableView1Column0: TcxGridColumn
          Caption = #38075#23380#32534#21495
          PropertiesClassName = 'TcxLabelProperties'
          HeaderAlignmentHorz = taCenter
          MinWidth = 150
          Options.Editing = False
          Options.Filtering = False
          Options.FilteringFilteredItemsList = False
          Options.FilteringMRUItemsList = False
          Options.FilteringPopup = False
          Options.FilteringPopupMultiSelect = False
          Options.Focusing = False
          Options.IgnoreTimeForFiltering = False
          Options.IncSearch = False
          Options.ShowEditButtons = isebNever
          Options.GroupFooters = False
          Options.Grouping = False
          Options.HorzSizing = False
          Options.Moving = False
          Options.Sorting = False
          Width = 150
        end
        object cxgrdclmnRowLinecxgrd1TableView1ColumnYuanShi: TcxGridColumn
          Caption = #25130#23380
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.ReadOnly = False
          Width = 120
        end
      end
      object sgAllDrillsBandedTableView1: TcxGridBandedTableView
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Bands = <
          item
            Caption = 'sss'
          end>
        object sgAllDrillsBandedTableView1Column1: TcxGridBandedColumn
          Caption = 'ddd'
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
      end
      object cxgrdlvlGrid1Level1: TcxGridLevel
        Caption = 'ssdd'
        GridView = sgAllDrillsTableView1
      end
    end
    object btnCheckAll: TButton
      Left = 213
      Top = 41
      Width = 68
      Height = 25
      Caption = #20840#37096#25130#23380
      TabOrder = 6
      OnClick = btnCheckAllClick
    end
    object btnCheckNone: TButton
      Left = 213
      Top = 81
      Width = 68
      Height = 25
      Caption = #20840#37096#19981#25130
      TabOrder = 7
      OnClick = btnCheckNoneClick
    end
  end
end
