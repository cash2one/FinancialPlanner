inherited frmBdzxAnalysis: TfrmBdzxAnalysis
  Caption = 'frmBdzxAnalysis'
  ClientHeight = 104
  ClientWidth = 375
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 35
    Width = 39
    Height = 13
    Caption = 'data src'
  end
  object lbl2: TLabel
    Left = 8
    Top = 61
    Width = 51
    Height = 13
    Caption = 'stock code'
  end
  object btnComputeBDZX: TButton
    Left = 232
    Top = 56
    Width = 123
    Height = 25
    Caption = 'Compute BDZX'
    TabOrder = 0
    OnClick = btnComputeBDZXClick
  end
  object edtstock: TEdit
    Left = 64
    Top = 59
    Width = 150
    Height = 19
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    Text = '600000'
  end
  object edtdatasrc: TComboBox
    Left = 64
    Top = 32
    Width = 150
    Height = 21
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 2
  end
end
