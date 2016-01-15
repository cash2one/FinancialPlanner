object frmAnalysisUpsDowns: TfrmAnalysisUpsDowns
  Left = 514
  Top = 175
  Caption = #25968#25454
  ClientHeight = 335
  ClientWidth = 567
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
    Width = 567
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnMain: TPanel
    Left = 0
    Top = 41
    Width = 567
    Height = 294
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object split1: TSplitter
      Left = 310
      Top = 0
      Height = 294
      Align = alRight
    end
    object pnStocks: TPanel
      Left = 0
      Top = 0
      Width = 310
      Height = 294
      Align = alClient
      TabOrder = 0
      object vtStocks: TVirtualStringTree
        Left = 1
        Top = 1
        Width = 308
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
        OnClick = vtStocksClick
        OnGetText = vtStocksGetText
        Columns = <>
      end
    end
    object pnData: TPanel
      Left = 313
      Top = 0
      Width = 254
      Height = 294
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object lbl1: TLabel
        Left = 16
        Top = 127
        Width = 201
        Height = 17
        AutoSize = False
        Caption = 'lbl1'
      end
      object btnComputeUpsDowns: TButton
        Left = 16
        Top = 150
        Width = 145
        Height = 25
        Caption = 'Compute Ups Downs'
        TabOrder = 0
        OnClick = btnComputeUpsDownsClick
      end
      object mmo1: TMemo
        Left = 16
        Top = 0
        Width = 217
        Height = 115
        Lines.Strings = (
          'mmo1')
        TabOrder = 1
      end
    end
  end
end
