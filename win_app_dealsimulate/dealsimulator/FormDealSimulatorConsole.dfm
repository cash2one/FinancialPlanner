object frmDealSimulation: TfrmDealSimulation
  Left = 204
  Top = 130
  Caption = #25968#25454
  ClientHeight = 436
  ClientWidth = 723
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
    Width = 723
    Height = 41
    Align = alTop
    BevelOuter = bvNone
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 723
    Height = 395
    Align = alClient
    TabOrder = 1
    object edLogs: TMemo
      Left = 207
      Top = 207
      Width = 190
      Height = 170
      Lines.Strings = (
        'Logs')
    end
    object pnlConsole: TPanel
      Left = 11
      Top = 10
      Width = 190
      Height = 191
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 131
        Height = 13
        Caption = #21333#27169#25311#24080#21495#36215#22987#37329#39069' ('#19975')'
      end
      object Label2: TLabel
        Left = 16
        Top = 72
        Width = 72
        Height = 13
        Caption = #36215#22987#27169#25311#26102#38388
      end
      object Label4: TLabel
        Left = 11
        Top = 157
        Width = 48
        Height = 13
        Caption = #24403#21069#36164#20135
      end
      object Label5: TLabel
        Left = 65
        Top = 157
        Width = 82
        Height = 13
        AutoSize = False
        BiDiMode = bdRightToLeft
        Caption = '300000.00'
        ParentBiDiMode = False
      end
      object edStartMoney: TEdit
        Left = 58
        Top = 45
        Width = 89
        Height = 21
        Text = '30'
      end
      object btnStart: TButton
        Left = 72
        Top = 121
        Width = 75
        Height = 25
        Caption = #24320#22987#27169#25311
      end
      object dateStart: TDateTimePicker
        Left = 58
        Top = 94
        Width = 89
        Height = 21
        BevelInner = bvNone
        BevelOuter = bvNone
        Date = 42547.770178703700000000
        Time = 42547.770178703700000000
      end
    end
    object pnlDealCmd: TPanel
      Left = 11
      Top = 207
      Width = 190
      Height = 169
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      ParentCtl3D = False
      object Label6: TLabel
        Left = 16
        Top = 42
        Width = 26
        Height = 13
        Caption = 'Stock'
      end
      object Label7: TLabel
        Left = 16
        Top = 67
        Width = 23
        Height = 13
        Caption = 'Price'
      end
      object Label8: TLabel
        Left = 16
        Top = 92
        Width = 21
        Height = 13
        Caption = 'Num'
      end
      object edStock: TEdit
        Left = 58
        Top = 40
        Width = 89
        Height = 19
        BevelInner = bvNone
        Text = '600000'
      end
      object edPrice: TEdit
        Left = 58
        Top = 65
        Width = 89
        Height = 19
        BevelInner = bvNone
        Text = '0.00'
      end
      object edNum: TEdit
        Left = 58
        Top = 90
        Width = 89
        Height = 19
        BevelInner = bvNone
        Text = '1000'
      end
      object btnBuy: TButton
        Left = 16
        Top = 128
        Width = 57
        Height = 25
        Caption = #20080#20837
      end
      object btnSale: TButton
        Left = 90
        Top = 128
        Width = 57
        Height = 25
        Caption = #21334#20986
      end
      object dateDeal: TDateTimePicker
        Left = 58
        Top = 13
        Width = 89
        Height = 21
        BevelInner = bvNone
        BevelOuter = bvNone
        Date = 42547.770178703700000000
        Time = 42547.770178703700000000
      end
    end
    object pnlDealHistory: TPanel
      Left = 403
      Top = 10
      Width = 286
      Height = 367
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 3
      DesignSize = (
        284
        365)
      object Label3: TLabel
        Left = 16
        Top = 16
        Width = 48
        Height = 13
        Caption = #20132#26131#35760#24405
      end
      object vtDealHistory: TVirtualStringTree
        Left = 3
        Top = 39
        Width = 277
        Height = 321
        Anchors = [akLeft, akTop, akRight, akBottom]
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
    object pnlHolds: TPanel
      Left = 207
      Top = 10
      Width = 190
      Height = 191
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      ParentCtl3D = False
      DesignSize = (
        188
        189)
      object Label9: TLabel
        Left = 16
        Top = 16
        Width = 48
        Height = 13
        Caption = #24403#21069#25345#20179
      end
      object vtHoldsNow: TVirtualStringTree
        Left = 3
        Top = 39
        Width = 181
        Height = 145
        Anchors = [akLeft, akTop, akRight, akBottom]
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
  end
end
