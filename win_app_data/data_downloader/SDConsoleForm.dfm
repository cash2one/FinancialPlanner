object frmSDConsole: TfrmSDConsole
  Left = 619
  Top = 335
  Caption = 'frmSDConsole'
  ClientHeight = 357
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 8
    Width = 54
    Height = 13
    Caption = 'Stock Code'
  end
  object btnDownload163: TButton
    Left = 8
    Top = 53
    Width = 110
    Height = 25
    Caption = 'Download 163'
    TabOrder = 0
    OnClick = btnDownload163Click
  end
  object btnDownloadSina: TButton
    Left = 8
    Top = 84
    Width = 110
    Height = 25
    Caption = 'Download Sina'
    TabOrder = 1
    OnClick = btnDownloadSinaClick
  end
  object edtStockCode: TEdit
    Left = 8
    Top = 26
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '600000'
  end
  object btnImportTDX: TButton
    Left = 124
    Top = 238
    Width = 110
    Height = 25
    Caption = 'Import TDX'
    TabOrder = 3
  end
  object btnDownload163All: TButton
    Left = 124
    Top = 53
    Width = 110
    Height = 25
    Caption = 'Download 163 All'
    TabOrder = 4
    OnClick = btnDownload163AllClick
  end
  object btnDownloadSinaAll: TButton
    Left = 124
    Top = 84
    Width = 110
    Height = 25
    Caption = 'Download Sina All'
    TabOrder = 5
    OnClick = btnDownloadSinaAllClick
  end
  object btnDownloadAll: TButton
    Left = 124
    Top = 286
    Width = 110
    Height = 25
    Caption = 'Download All'
    TabOrder = 6
    OnClick = btnDownloadAllClick
  end
  object btnDownloadXueqiu: TButton
    Left = 8
    Top = 115
    Width = 110
    Height = 25
    Caption = 'Download Xueqiu'
    TabOrder = 7
    OnClick = btnDownloadXueqiuClick
  end
  object btnDownloadXueqiuAll: TButton
    Left = 124
    Top = 115
    Width = 110
    Height = 25
    Caption = 'Download Xueqiu All'
    TabOrder = 8
    OnClick = btnDownloadXueqiuAllClick
  end
  object btnDownloadQQ: TButton
    Left = 8
    Top = 146
    Width = 110
    Height = 25
    Caption = 'Download QQ'
    TabOrder = 9
    OnClick = btnDownloadQQClick
  end
  object btnDownloadQQAll: TButton
    Left = 124
    Top = 146
    Width = 110
    Height = 25
    Caption = 'Download QQ All'
    TabOrder = 10
    OnClick = btnDownloadQQAllClick
  end
  object lbStock163: TEdit
    Left = 256
    Top = 56
    Width = 121
    Height = 19
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 11
    Text = '600000'
  end
  object lbStockSina: TEdit
    Left = 256
    Top = 87
    Width = 121
    Height = 19
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 12
    Text = '600000'
  end
  object lbStockXQ: TEdit
    Left = 256
    Top = 118
    Width = 121
    Height = 19
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 13
    Text = '600000'
  end
  object lbStockQQ: TEdit
    Left = 256
    Top = 149
    Width = 121
    Height = 19
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 14
    Text = '600000'
  end
  object btnShutDown: TButton
    Left = 240
    Top = 238
    Width = 110
    Height = 25
    Caption = 'ShutDown'
    TabOrder = 15
    OnClick = btnShutDownClick
  end
  object tmrRefreshDownloadTask: TTimer
    Enabled = False
    OnTimer = tmrRefreshDownloadTaskTimer
    Left = 80
    Top = 192
  end
end
