object frmSDRepair: TfrmSDRepair
  Left = 196
  Top = 95
  Caption = 'frmSDRepair'
  ClientHeight = 461
  ClientWidth = 854
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
    Width = 854
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    object btnCheckFirstDate: TButton
      Left = 16
      Top = 10
      Width = 120
      Height = 25
      Caption = 'Check First Date'
      OnClick = btnCheckFirstDateClick
    end
    object btnFindError: TButton
      Left = 142
      Top = 10
      Width = 120
      Height = 25
      Caption = 'Find Error'
      TabOrder = 1
      OnClick = btnFindErrorClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 456
    Width = 854
    Height = 5
    Align = alBottom
    BevelOuter = bvNone
  end
  object pnlMain: TPanel
    Align = alClient
    BevelOuter = bvNone
    object pnlStocks: TPanel
      Left = 0
      Top = 0
      Width = 185
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      Padding.Left = 1
      Padding.Top = 1
      Padding.Right = 1
      Padding.Bottom = 1
      ParentCtl3D = False
      object vtStocks: TVirtualStringTree
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
        Columns = <>
      end
    end
    object vtDayData: TVirtualStringTree
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      ParentCtl3D = False
      Columns = <>
    end
    object mmoLogs: TMemo
      Width = 185
      Align = alRight
      BevelInner = bvNone
      Ctl3D = False
      ParentCtl3D = False
    end
  end
end
