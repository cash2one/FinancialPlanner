object frmCtpDeal: TfrmCtpDeal
  Left = 385
  Top = 149
  ClientHeight = 427
  ClientWidth = 790
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    790
    427)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlQuery: TPanel
    Left = 8
    Top = 125
    Width = 265
    Height = 79
    TabOrder = 0
    object btnQueryMoney: TButton
      Left = 148
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Query Money'
      TabOrder = 0
    end
    object btnQueryHold: TButton
      Left = 148
      Top = 41
      Width = 75
      Height = 25
      Caption = 'Query Hold'
      TabOrder = 1
    end
    object edtHold: TEdit
      Left = 16
      Top = 43
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 2
      Text = 'IF1509'
    end
  end
  object pnlDealBuy: TPanel
    Left = 8
    Top = 216
    Width = 265
    Height = 196
    TabOrder = 1
    object lblDealItem: TLabel
      Left = 16
      Top = 10
      Width = 46
      Height = 13
      Caption = 'Deal Item'
    end
    object lbl1: TLabel
      Left = 16
      Top = 36
      Width = 23
      Height = 13
      Caption = 'Price'
    end
    object lbl2: TLabel
      Left = 16
      Top = 63
      Width = 21
      Height = 13
      Caption = 'Num'
    end
    object edtDealBuyItem: TEdit
      Left = 71
      Top = 7
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 0
      Text = 'IF1509'
    end
    object edtDealBuyPrice: TEdit
      Left = 71
      Top = 33
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 1
      Text = '4000'
    end
    object edtDealBuyNum: TEdit
      Left = 71
      Top = 60
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 2
      Text = '1'
    end
    object btnDealBuy: TButton
      Left = 148
      Top = 161
      Width = 75
      Height = 25
      Caption = 'Buy'
      TabOrder = 3
      OnClick = btnDealBuyClick
    end
    object rgDealBuyMode: TRadioGroup
      Left = 16
      Top = 81
      Width = 219
      Height = 73
      ItemIndex = 0
      Items.Strings = (
        'Open'
        'CloseToday'
        'CloseOut')
      TabOrder = 4
    end
  end
  object pnlInit: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 109
    TabOrder = 2
    object btnInitDeal: TButton
      Left = 16
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Init Deal'
      TabOrder = 0
      OnClick = btnInitDealClick
    end
    object btnConnectDeal: TButton
      Left = 117
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Connect Deal'
      TabOrder = 1
      OnClick = btnConnectDealClick
    end
    object edtAddrDeal: TComboBox
      Left = 16
      Top = 10
      Width = 226
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 2
      Text = 'tcp://180.166.65.114:41205'
    end
    object btnShutDown: TButton
      Left = 117
      Top = 70
      Width = 125
      Height = 25
      Caption = 'ShutDown Agent'
      TabOrder = 3
      OnClick = btnShutDownClick
    end
  end
  object pnlLogin: TPanel
    Left = 288
    Top = 8
    Width = 265
    Height = 161
    TabOrder = 3
    object lblAccount: TLabel
      Left = 16
      Top = 38
      Width = 39
      Height = 13
      Caption = 'Account'
    end
    object lblPassowrd: TLabel
      Left = 16
      Top = 63
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object lblBrokeId: TLabel
      Left = 16
      Top = 13
      Width = 37
      Height = 13
      Caption = 'BrokeId'
    end
    object btnLoginDeal: TButton
      Left = 16
      Top = 89
      Width = 75
      Height = 25
      Caption = 'Login Deal'
      TabOrder = 0
      OnClick = btnLoginDealClick
    end
    object edtAccount: TComboBox
      Left = 71
      Top = 35
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 1
      Text = '99686047'
    end
    object edtPassword: TEdit
      Left = 71
      Top = 60
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      PasswordChar = '*'
      TabOrder = 2
      Text = '166335'
    end
    object edtBrokeId: TComboBox
      Left = 71
      Top = 10
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 3
      Text = '8060'
    end
    object btnLogoutDeal: TButton
      Left = 116
      Top = 126
      Width = 75
      Height = 25
      Caption = 'Logout Deal'
      TabOrder = 4
      OnClick = btnLogoutDealClick
    end
    object btnConfirmSettlement: TButton
      Left = 117
      Top = 89
      Width = 75
      Height = 25
      Caption = 'Confirm Settle'
      TabOrder = 5
      OnClick = btnConfirmSettlementClick
    end
  end
  object pnlDealSale: TPanel
    Left = 288
    Top = 216
    Width = 265
    Height = 196
    TabOrder = 4
    object lbl3: TLabel
      Left = 16
      Top = 10
      Width = 46
      Height = 13
      Caption = 'Deal Item'
    end
    object lbl4: TLabel
      Left = 16
      Top = 36
      Width = 23
      Height = 13
      Caption = 'Price'
    end
    object lbl5: TLabel
      Left = 16
      Top = 63
      Width = 21
      Height = 13
      Caption = 'Num'
    end
    object edtDealSaleItem: TEdit
      Left = 71
      Top = 7
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 0
      Text = 'IF1509'
    end
    object edtDealSalePrice: TEdit
      Left = 71
      Top = 33
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 1
      Text = '4000'
    end
    object edtDealSaleNum: TEdit
      Left = 71
      Top = 60
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 2
      Text = '1'
    end
    object btnDealSale: TButton
      Left = 148
      Top = 161
      Width = 75
      Height = 25
      Caption = 'Sale'
      TabOrder = 3
      OnClick = btnDealSaleClick
    end
    object rgDealSaleMode: TRadioGroup
      Left = 16
      Top = 81
      Width = 219
      Height = 73
      ItemIndex = 0
      Items.Strings = (
        'Open'
        'CloseToday'
        'CloseOut')
      TabOrder = 4
    end
  end
  object mmo1: TMemo
    Left = 562
    Top = 8
    Width = 216
    Height = 404
    Anchors = [akLeft, akTop, akRight, akBottom]
    ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Lines.Strings = (
      'mmo1')
    TabOrder = 5
  end
end
