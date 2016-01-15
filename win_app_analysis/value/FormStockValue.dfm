object frmStockValue: TfrmStockValue
  Left = 422
  Top = 194
  Caption = 'frmStockValue'
  ClientHeight = 410
  ClientWidth = 613
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 613
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlmain: TPanel
    Left = 0
    Top = 41
    Width = 613
    Height = 328
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlmainleft: TPanel
      Left = 0
      Top = 0
      Width = 409
      Height = 328
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object vtstock: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 409
        Height = 328
        Align = alClient
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        TabOrder = 0
        OnGetText = vtstockGetText
        Columns = <>
      end
    end
    object btnRefreshData: TButton
      Left = 496
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Refresh Value'
      TabOrder = 1
      OnClick = btnRefreshDataClick
    end
    object mmo1: TMemo
      Left = 424
      Top = 96
      Width = 177
      Height = 169
      Lines.Strings = (
        'mmo1')
      TabOrder = 2
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 369
    Width = 613
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
  end
end
