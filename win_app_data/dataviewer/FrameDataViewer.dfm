object fmeDataViewer: TfmeDataViewer
  Left = 514
  Top = 175
  Caption = #25968#25454
  ClientHeight = 335
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 547
    Height = 10
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnMain: TPanel
    Left = 0
    Top = 10
    Width = 547
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnData: TPanel
      Left = 0
      Top = 0
      Width = 547
      Height = 325
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object pnDataTop: TPanel
        Left = 0
        Top = 0
        Width = 547
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object pnlDatas: TPanel
        Left = 0
        Top = 17
        Width = 547
        Height = 308
        Align = alClient
        TabOrder = 1
        object spl1: TSplitter
          Left = 201
          Top = 1
          Height = 306
        end
        object pnlDetail: TPanel
          Left = 204
          Top = 1
          Width = 342
          Height = 306
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object pnlDetailTop: TPanel
            Left = 0
            Top = 0
            Width = 342
            Height = 28
            Align = alTop
            BevelOuter = bvNone
            object edtDetailDataSrc: TComboBox
              Left = 6
              Top = 5
              Width = 145
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              OnChange = edtDetailDataSrcChange
            end
          end
          object vtDetailDatas: TVirtualStringTree
            Left = 0
            Top = 28
            Width = 342
            Height = 278
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
            OnGetText = vtDetailDatasGetText
            Columns = <>
          end
        end
        object pnlDayData: TPanel
          Left = 1
          Top = 1
          Width = 200
          Height = 306
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object pnlDayDataTop: TPanel
            Left = 0
            Top = 0
            Width = 200
            Height = 28
            Align = alTop
            BevelOuter = bvNone
          end
          object vtDayDatas: TVirtualStringTree
            Left = 0
            Top = 28
            Width = 200
            Height = 278
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
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnChange = vtDayDatasChange
            OnGetText = vtDayDatasGetText
            Columns = <>
          end
        end
      end
    end
  end
end
