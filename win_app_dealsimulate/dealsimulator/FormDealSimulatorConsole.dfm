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
    TabOrder = 0
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 547
    Height = 294
    Align = alClient
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
    object Label3: TLabel
      Left = 248
      Top = 16
      Width = 48
      Height = 13
      Caption = #20132#26131#35760#24405
    end
    object Label4: TLabel
      Left = 16
      Top = 176
      Width = 48
      Height = 13
      Caption = #24403#21069#37329#39069
    end
    object Label5: TLabel
      Left = 65
      Top = 176
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
      TabOrder = 0
      Text = '30'
    end
    object edStartDate: TEdit
      Left = 58
      Top = 94
      Width = 89
      Height = 21
      TabOrder = 1
      Text = '30'
    end
    object Memo1: TMemo
      Left = 248
      Top = 45
      Width = 273
      Height = 228
      Lines.Strings = (
        'Memo1')
      TabOrder = 2
    end
    object Button1: TButton
      Left = 72
      Top = 135
      Width = 75
      Height = 25
      Caption = #24320#22987#27169#25311
      TabOrder = 3
    end
  end
end
