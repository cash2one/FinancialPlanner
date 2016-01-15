program stockfloat;

uses
  Windows,
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseFile in '..\..\..\devwintech\v0000\win_base\BaseFile.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  Define_Message in '..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  BaseWinThread in '..\..\..\devwintech\v0000\win_base\BaseWinThread.pas',
  UIBaseWinMemDC in '..\..\..\devwintech\v0000\win_base\UIBaseWinMemDC.pas',
  UIWinColor in '..\..\..\devwintech\v0000\win_base\UIWinColor.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\win_base\BaseDataSet.pas',

  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',

  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Indy in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Indy.pas',

  DealTime in '..\..\base\DealTime.pas',

  define_price in '..\..\basedefine\define_price.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_stock_quotes_instant in '..\..\basedefine\define_stock_quotes_instant.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',

  StockInstantDataAccess in '..\..\data_stock\StockInstantDataAccess.pas',  
  StockInstantData_Get_Sina in '..\..\data_stock\datasrc_sina\StockInstantData_Get_Sina.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',

  BaseFloatWindow in 'BaseFloatWindow.pas',
  floatwinapp in 'floatwinapp.pas',
  floatwindow in 'floatwindow.pas';

{$R *.res}

begin
  GlobalApp := TStockFloatApp.Create('FloatStockQuote');
  try
    if GlobalApp.Initialize then
    begin
      GlobalApp.Run;
    end;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
