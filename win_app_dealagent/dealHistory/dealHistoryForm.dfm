object frmDealHistory: TfrmDealHistory
  Left = 757
  Top = 211
  Caption = 'frmDealHistory'
  ClientHeight = 382
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 477
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 360
    Width = 477
    Height = 22
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 477
    Height = 319
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnlDeal: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 319
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      Padding.Left = 1
      Padding.Top = 1
      Padding.Right = 1
      Padding.Bottom = 1
      ParentCtl3D = False
      TabOrder = 0
      object vtDeal: TVirtualStringTree
        Left = 1
        Top = 1
        Width = 181
        Height = 315
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        TabOrder = 0
        Columns = <>
      end
    end
  end
end
