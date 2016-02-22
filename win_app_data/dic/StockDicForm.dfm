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
    Left = 185
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
    object btnSave: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 282
    Align = alLeft
    TabOrder = 2
  end
  object pnlRight: TPanel
    Left = 188
    Top = 41
    Width = 332
    Height = 282
    Align = alClient
    TabOrder = 3
    object mmo1: TMemo
      Left = 1
      Top = 1
      Width = 330
      Height = 280
      Align = alClient
      Lines.Strings = (
        'mmo1')
      TabOrder = 0
    end
  end
end
