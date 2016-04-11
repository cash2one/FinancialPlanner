object frmStockDic: TfrmStockDic
  Left = 470
  Top = 156
  Caption = 'frmStockDic'
  ClientHeight = 364
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 300
    Top = 41
    Height = 282
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 323
    Width = 520
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnSaveDic: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save Dic'
      TabOrder = 0
      OnClick = btnSaveDicClick
    end
    object btnOpen: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 1
      OnClick = btnOpenClick
    end
    object btnClear: TButton
      Left = 64
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 2
      OnClick = btnClearClick
    end
    object btnSaveIni: TButton
      Left = 369
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save Ini'
      TabOrder = 3
      OnClick = btnSaveIniClick
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 41
    Width = 300
    Height = 282
    Align = alLeft
    TabOrder = 2
  end
  object pnlRight: TPanel
    Left = 303
    Top = 41
    Width = 217
    Height = 282
    Align = alClient
    TabOrder = 3
    object mmo1: TMemo
      Left = 1
      Top = 1
      Width = 215
      Height = 280
      Align = alClient
      Lines.Strings = (
        'mmo1')
      TabOrder = 0
    end
  end
end
