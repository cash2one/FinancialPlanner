object frmZSHelper: TfrmZSHelper
  Left = 385
  Top = 149
  ClientHeight = 369
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pb1: TPaintBox
    Left = 8
    Top = 8
    Width = 105
    Height = 48
  end
  object btnbuy: TButton
    Left = 256
    Top = 178
    Width = 100
    Height = 25
    Caption = 'buy'
    TabOrder = 0
    OnClick = btnbuyClick
  end
  object mmo1: TMemo
    Left = 8
    Top = 62
    Width = 232
    Height = 296
    Lines.Strings = (
      'mmo1')
    TabOrder = 1
  end
  object edtLeft: TEdit
    Left = 119
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '564'
  end
  object edtTop: TEdit
    Left = 119
    Top = 35
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '341'
  end
  object btnMain: TButton
    Left = 256
    Top = 39
    Width = 100
    Height = 25
    Caption = 'Main Window'
    TabOrder = 4
    OnClick = btnMainClick
  end
  object btnlaunch: TButton
    Left = 256
    Top = 8
    Width = 100
    Height = 25
    Caption = 'launch'
    TabOrder = 5
    OnClick = btnlaunchClick
  end
  object edStock: TEdit
    Left = 256
    Top = 70
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '002494'
  end
  object edPrice: TEdit
    Left = 256
    Top = 97
    Width = 121
    Height = 21
    TabOrder = 7
    Text = '25.76'
  end
  object btnConfirmDeal: TButton
    Left = 256
    Top = 224
    Width = 100
    Height = 25
    Caption = 'ConfirmDeal'
    TabOrder = 8
    OnClick = btnConfirmDealClick
  end
  object edMoney: TEdit
    Left = 256
    Top = 124
    Width = 121
    Height = 21
    TabOrder = 9
    Text = '4000'
  end
  object btnConfirmPwd: TButton
    Left = 256
    Top = 255
    Width = 100
    Height = 25
    Caption = 'ConfirmPassword'
    TabOrder = 10
    OnClick = btnConfirmPwdClick
  end
  object btnUnlock: TButton
    Left = 256
    Top = 286
    Width = 100
    Height = 25
    Caption = 'Unlock'
    TabOrder = 11
    OnClick = btnUnlockClick
  end
  object btnCheckMoney: TButton
    Left = 256
    Top = 317
    Width = 100
    Height = 25
    Caption = 'Check Money'
    TabOrder = 12
    OnClick = btnCheckMoneyClick
  end
  object edNum: TEdit
    Left = 256
    Top = 151
    Width = 121
    Height = 21
    TabOrder = 13
    Text = '100'
  end
  object btnSale: TButton
    Left = 370
    Top = 178
    Width = 100
    Height = 25
    Caption = 'Sale'
    TabOrder = 14
    OnClick = btnSaleClick
  end
  object btnCheckDealPanelSize: TButton
    Left = 370
    Top = 286
    Width = 100
    Height = 25
    Caption = 'Check Deal Panel'
    TabOrder = 15
    OnClick = btnCheckDealPanelSizeClick
  end
end
