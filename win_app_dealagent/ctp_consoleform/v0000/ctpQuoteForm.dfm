object frmCtpQuote: TfrmCtpQuote
  Left = 385
  Top = 149
  ClientHeight = 372
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInit: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 109
    TabOrder = 0
    object btnInitMD: TButton
      Left = 16
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Init MD'
      TabOrder = 0
      OnClick = btnInitMDClick
    end
    object btnConnectMD: TButton
      Left = 117
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Connect MD'
      TabOrder = 1
      OnClick = btnConnectMDClick
    end
    object edtAddrMD: TComboBox
      Left = 16
      Top = 10
      Width = 226
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ItemHeight = 13
      TabOrder = 2
      Text = 'tcp://180.166.65.114:41213'
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
    Height = 127
    TabOrder = 1
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
    object btnLoginMD: TButton
      Left = 16
      Top = 89
      Width = 75
      Height = 25
      Caption = 'Login MD'
      TabOrder = 0
      OnClick = btnLoginMDClick
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
    object btnLogoutMD: TButton
      Left = 117
      Top = 89
      Width = 75
      Height = 25
      Caption = 'Logout MD'
      TabOrder = 4
      OnClick = btnLogoutMDClick
    end
  end
  object pnlScribe: TPanel
    Left = 8
    Top = 123
    Width = 265
    Height = 109
    TabOrder = 2
    object lblItem: TLabel
      Left = 16
      Top = 13
      Width = 22
      Height = 13
      Caption = 'Item'
    end
    object btnSubscribe: TButton
      Left = 16
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Subscribe'
      TabOrder = 0
      OnClick = btnSubscribeClick
    end
    object edtInstItem: TEdit
      Left = 71
      Top = 10
      Width = 121
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 1
      Text = 'IF1508'
    end
    object btnUnsubscribe: TButton
      Left = 117
      Top = 38
      Width = 75
      Height = 25
      Caption = 'UnSubscribe'
      TabOrder = 2
      OnClick = btnUnsubscribeClick
    end
  end
end
