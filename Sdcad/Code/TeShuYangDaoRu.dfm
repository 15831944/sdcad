object TeShuYangDaoRuForm: TTeShuYangDaoRuForm
  Left = 192
  Top = 130
  AutoScroll = False
  Caption = #22303#24037#35797#39564#25968#25454#23548#20837'('#29305#27530#26679')'
  ClientHeight = 446
  ClientWidth = 920
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlAll: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 446
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlAll'
    TabOrder = 0
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 920
      Height = 97
      Align = alTop
      BevelOuter = bvNone
      Color = 15198183
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 16
        Width = 128
        Height = 15
        Caption = #22303#24037#35797#39564#25968#25454#25991#20214':'
        Color = 15198183
        Font.Charset = GB2312_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object btnLoad: TBitBtn
        Left = 141
        Top = 42
        Width = 60
        Height = 41
        Hint = #36716#23548
        Caption = #36716#23548
        Enabled = False
        TabOrder = 0
        OnClick = btnLoadClick
        Glyph.Data = {
          B6050000424DB605000000000000360400002800000015000000100000000100
          08000000000080010000C40E0000C40E00000001000000000000000000008080
          8000000080000080800000800000808000008000000080008000408080004040
          0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
          FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
          80008000FF004080FF00C0DCC000F0CAA600A4AEAC00D7DFDF00ACC7C600E6EF
          F600C6DFE800849A5A000050FF00BF9B6200F6CBA400A56D00000080FF005A55
          630084718400849A940084828400A5AEAD00E7EFF700ADBE8C00848200003855
          0300ADAA8C005A699300849EAD00B5CEE700AEC7F000BDDBEF00D7DBE8009CC4
          E800BDDFE700DFDFE600B6D7E600BDCFDE00D7D7D700BED8D600CFCFD600BDC7
          D600F7FAFF00BDDFFF00B6D6FF00C6EBFE00CEEFFD00B6CCF700CFE2EF00C7DF
          EE00B6C8E700C7D7E6009FBECB00506E6600BFF0F0004F6F6000BEE4E100E3FB
          FB00E3846000BFE0DF00E3FBFD00E3FBFC00E3FBFA0096D3960080985F009FBF
          C0009FB8B000C1B7B800B0D8EF00D6F6FA009FBECA00A0C0C0007F6F7F005F68
          8F008098A000B0CFE0000000330000006600000099000000CC00002400000024
          330000246600002499000024CC000024FF000049000000493300004966000049
          99000049CC000049FF00006D0000006D3300006D6600006D9900006DCC00006D
          FF00009200000092330000926600009299000092CC000092FF0000B6000000B6
          330000B6660000B6990000B6CC0000B6FF0000DB000000DB330000DB660000DB
          990000DBCC0000DBFF0000FF330000FF660000FF990000FFCC00400000004000
          330040006600400099004000CC004000FF004024000040243300402466004024
          99004024CC004024FF00404900004049330040496600404999004049CC004049
          FF00406D0000406D3300406D6600406D9900406DCC00406DFF00409200004092
          330040926600409299004092CC004092FF0040B6000040B6330040B6660040B6
          990040B6CC0040B6FF0040DB000040DB330040DB660040DB990040DBCC0040DB
          FF0040FF000040FF330040FF660040FF990040FFCC0040FFFF00800033008000
          6600800099008000CC00802400008024330080246600802499008024CC008024
          FF00804900008049330080496600804999008049CC008049FF00806D0000806D
          3300806D6600806D9900806DCC00806DFF008092000080923300809266008092
          99008092CC008092FF0080B6000080B6330080B6660080B6990080B6CC0080B6
          FF0080DB000080DB330080DB660080DB990080DBCC0080DBFF0080FF330080FF
          660080FF990080FFCC00BF000000BF003300BF006600BF009900BF00CC00BF00
          FF00BF240000BF243300BF246600BF249900BF24CC00BF24FF00BF490000BF49
          3300BF496600BF499900BF49CC00BF49FF00BF6D0000BF6D33000F0F0F0F0F0F
          0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000000F0F0F0F0F0F0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F0F0000000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00
          00000F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0000000F0F0F0F0F0F
          0F0F0F001000000F0F0F0F0F0F0F0F0000000F0F0F0F0F0F0F0F0F0010101000
          000F0F0F0F0F0F0000000F0F0F00000000000000101010101000000F0F0F0F00
          00000F0F0F001010101010101010101010101000000F0F0000000F0F0F000000
          00000000101010101000000F0F0F0F0000000F0F0F0F0F0F0F0F0F0010101000
          000F0F0F0F0F0F0000000F0F0F0F0F0F0F0F0F001000000F0F0F0F0F0F0F0F00
          00000F0F0F0F0F0F0F0F0F00000F0F0F0F0F0F0F0F0F0F0000000F0F0F0F0F0F
          0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000000F0F0F0F0F0F0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F0F0000000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00
          00000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F000000}
        Layout = blGlyphTop
        Spacing = 3
      end
      object btnCancel: TBitBtn
        Left = 225
        Top = 42
        Width = 60
        Height = 41
        Hint = #36820#22238
        Caption = #36820#22238
        TabOrder = 1
        OnClick = btnCancelClick
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
        Layout = blGlyphTop
        Spacing = 3
      end
      object edtFileName: TEdit
        Left = 137
        Top = 14
        Width = 473
        Height = 21
        ImeName = #26085#26412#35486' (MS-IME2000)'
        TabOrder = 2
      end
      object btnFileOpen: TBitBtn
        Left = 610
        Top = 13
        Width = 32
        Height = 24
        Hint = #25171#24320#22806#37096#35797#39564#25968#25454#25991#20214
        TabOrder = 3
        OnClick = btnFileOpenClick
        Glyph.Data = {
          D6010000424DD601000000000000560000002800000018000000100000000100
          08000000000080010000400B0000400B00000800000000000000C0C0C00099FF
          FF0000FFFF000099CC0099663300000000000000000000000000000000000000
          0000050500000000000000000000000000000000000000000005020505050000
          0000000000000000000000000000000404050205030105050000000000000000
          0000000000040404040502020503010305050000000000000000000404040404
          0405020205010301030105050000000000000404040404040405020202050103
          0103010305050000000000000404040404050202020503010301030103010500
          0000000000000404040502020202050301030103010301050000000000000000
          0005020202020501030103010301030500000000000000000005020202020205
          0503010301030103050000000000000000050303020202020205050103010301
          0500000000000000000503030303020202020205050301030105000000000000
          0000050503030505020202020205050103050000000000000000000005050000
          0505020202020505050000000000000000000000000000000000050502020500
          0000000000000000000000000000000000000000050500000000}
        Layout = blGlyphTop
        Spacing = 1
      end
    end
    object pnlCen: TPanel
      Left = 0
      Top = 97
      Width = 920
      Height = 349
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 0
        Width = 4
        Height = 349
      end
      object sgResult: TStringGrid
        Left = 4
        Top = 0
        Width = 916
        Height = 349
        Align = alClient
        Ctl3D = False
        FixedColor = 15198183
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
        ParentCtl3D = False
        TabOrder = 0
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.XLS|*.XLS|*.*|*.*'
    Left = 241
    Top = 281
  end
end
