program stockAmountRate;

uses
  Windows,
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickList_double in '..\..\..\devwintech\comps\list\QuickList_double.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  BaseWinThread in '..\..\..\devwintech\v0000\win_base\BaseWinThread.pas',
  Define_Message in '..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  UIBaseWinMemDC in '..\..\..\devwintech\v0000\win_base\UIBaseWinMemDC.pas',
  UIWinColor in '..\..\..\devwintech\v0000\win_base\UIWinColor.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseFile in '..\..\..\devwintech\v0000\win_base\BaseFile.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\win_base\BaseDataSet.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  BaseWinApp in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseApp\BaseWinApp.pas',
  HttpUtils in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseNet\HttpUtils.pas',
  Http_Indy in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseNet\Http_Indy.pas',
  StockInstantDataAccess in '..\..\data_stock\StockInstantDataAccess.pas',
  StockInstantData_Get_Sina in '..\..\data_stock\datasrc_sina\StockInstantData_Get_Sina.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',

  define_stock_quotes_instant in '..\..\basedefine\define_stock_quotes_instant.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',

  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  AmountRateWinApp in 'AmountRateWinApp.pas',
  AmountRateWindow in 'AmountRateWindow.pas';

{$R *.res}

begin
  GlobalApp := TAmountRateApp.Create('');
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
