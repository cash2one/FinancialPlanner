program StockData;

uses
  Windows,
  Sysutils,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  windef_msg in '..\..\..\devwintech\v0001\windef\windef_msg.pas',
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  base.thread in '..\..\..\devwintech\v0001\rec\app_base\base.thread.pas',
  win.process in '..\..\..\devwintech\v0001\rec\win_sys\win.process.pas',
  base.run in '..\..\..\devwintech\v0001\rec\app_base\base.run.pas',
  win.thread in '..\..\..\devwintech\v0001\rec\win_sys\win.thread.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
  xlNetwork in '..\..\..\devwintech\v0000\win_net\xlNetwork.pas',
  xlTcpClient in '..\..\..\devwintech\v0000\win_netclient\xlTcpClient.pas',
  xlClientSocket in '..\..\..\devwintech\v0000\win_netclient\xlClientSocket.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Socket in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Socket.pas',
  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem_save in '..\..\dealitem\db_dealitem_save.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_stockapp in '..\..\basedefine\define_stockapp.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  StockDayData_Save in '..\..\data_stock\StockDayData_Save.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Get_163 in '..\..\data_stock\datasrc_163\StockDayData_Get_163.pas',
  StockDataApp in 'StockDataApp.pas',
  SDConsoleForm in 'SDConsoleForm.pas' {frmSDConsole},
  StockDataConsoleApp in 'StockDataConsoleApp.pas',
  define_StockDataApp in 'define_StockDataApp.pas',
  StockDataDownloaderApp in 'StockDataDownloaderApp.pas';

{$R *.res}

var
  GlobalApp: TStockDataApp = nil;
begin
  GlobalApp := TStockDataApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
