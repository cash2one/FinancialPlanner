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
  object btnbuy: TButton
    Left = 256
    Top = 266
    Width = 100
    Height = 25
    Caption = 'buy'
    TabOrder = 0
    OnClick = btnbuyClick
  end
  object mmo1: TMemo
    Left = 8
    Top = 8
    Width = 232
    Height = 296
    Lines.Strings = (
      'mmo1')
    TabOrder = 1
  end
  object btnlaunch: TButton
    Left = 256
    Top = 8
    Width = 100
    Height = 25
    Caption = 'launch'
    TabOrder = 2
    OnClick = btnlaunchClick
  end
  object edStock: TEdit
    Left = 256
    Top = 158
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '002494'
  end
  object edPrice: TEdit
    Left = 256
    Top = 185
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '25.76'
  end
  object edMoney: TEdit
    Left = 256
    Top = 212
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '4000'
  end
  object edNum: TEdit
    Left = 256
    Top = 239
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '100'
  end
  object btnSale: TButton
    Left = 379
    Top = 266
    Width = 100
    Height = 25
    Caption = 'Sale'
    TabOrder = 7
    OnClick = btnSaleClick
  end
  object btnUnlock: TButton
    Left = 379
    Top = 105
    Width = 100
    Height = 25
    Caption = 'Unlock'
    TabOrder = 8
    OnClick = btnUnlockClick
  end
  object btnLogin: TButton
    Left = 256
    Top = 105
    Width = 100
    Height = 25
    Caption = 'Login'
    TabOrder = 9
    OnClick = btnLoginClick
  end
  object edtUserId: TEdit
    Left = 256
    Top = 46
    Width = 121
    Height = 21
    TabOrder = 10
    Text = '39008990'
  end
  object edtPassword: TEdit
    Left = 256
    Top = 73
    Width = 121
    Height = 21
    TabOrder = 11
  end
end
