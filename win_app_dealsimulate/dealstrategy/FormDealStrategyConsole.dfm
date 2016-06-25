object frmDataViewer: TfrmDataViewer
  Left = 514
  Top = 175
  Caption = #25968#25454
  ClientHeight = 335
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 547
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object cbbDataSrc: TComboBox
      Left = 56
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = '163'
      OnChange = cbbDataSrcChange
      Items.Strings = (
        '163'
        'Sina'
        'SinaW')
    end
  end
  object pnMain: TPanel
    Left = 0
    Top = 41
    Width = 547
    Height = 294
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object split1: TSplitter
      Left = 185
      Top = 0
      Height = 294
    end
    object pnStocks: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 294
      Align = alLeft
      TabOrder = 0
      object vtStocks: TVirtualStringTree
        Left = 1
        Top = 1
        Width = 183
        Height = 292
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        TabOrder = 0
        Columns = <>
      end
    end
    object pnData: TPanel
      Left = 188
      Top = 0
      Width = 359
      Height = 294
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object ts1: TTabSet
        Left = 0
        Top = 273
        Width = 359
        Height = 21
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
    end
  end
end
