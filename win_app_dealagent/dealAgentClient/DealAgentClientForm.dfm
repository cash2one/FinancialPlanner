object frmDealAgentClient: TfrmDealAgentClient
  Left = 329
  Top = 173
  Caption = 'frmDealAgentClient'
  ClientHeight = 293
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtIp: TEdit
    Left = 32
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object edtPort: TEdit
    Left = 159
    Top = 24
    Width = 50
    Height = 21
    TabOrder = 1
    Text = '7785'
  end
  object btnConnect: TButton
    Left = 224
    Top = 22
    Width = 100
    Height = 25
    Caption = 'Connect'
    TabOrder = 2
    OnClick = btnConnectClick
  end
  object mmo1: TMemo
    Left = 32
    Top = 96
    Width = 177
    Height = 185
    Lines.Strings = (
      'mmo1')
    TabOrder = 3
  end
  object btnSend: TButton
    Left = 224
    Top = 53
    Width = 100
    Height = 25
    Caption = 'Send'
    TabOrder = 4
    OnClick = btnSendClick
  end
  object edtSendData: TEdit
    Left = 32
    Top = 55
    Width = 177
    Height = 21
    TabOrder = 5
    Text = 'abcd'
  end
  object mmo2: TMemo
    Left = 224
    Top = 96
    Width = 177
    Height = 185
    Lines.Strings = (
      'mmo1')
    TabOrder = 6
  end
  object btnDisconnect: TButton
    Left = 330
    Top = 22
    Width = 100
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 7
    OnClick = btnConnectClick
  end
end
