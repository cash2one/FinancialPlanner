object Form1: TForm1
  Left = 249
  Top = 268
  Caption = 'Form1'
  ClientHeight = 394
  ClientWidth = 602
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnParseHtml: TButton
    Left = 391
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Parse Html'
    TabOrder = 0
    OnClick = btnParseHtmlClick
  end
  object mmo1: TMemo
    Left = 8
    Top = 8
    Width = 377
    Height = 378
    Ctl3D = False
    Lines.Strings = (
      'mmo1')
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object mmo2: TMemo
    Left = 391
    Top = 8
    Width = 209
    Height = 113
    Lines.Strings = (
      'mmo2')
    TabOrder = 2
  end
  object btnClear: TButton
    Left = 391
    Top = 158
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 3
    OnClick = btnClearClick
  end
end
