program stockfloat;

uses
  Windows,
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  BaseFile in '..\..\..\devwintech\v0000\app_base\BaseFile.pas',
  BaseRun in '..\..\..\devwintech\v0000\app_base\BaseRun.pas',
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BaseThread in '..\..\..\devwintech\v0000\app_base\BaseThread.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  ui.color in '..\..\..\devwintech\v0000\uibase\ui.color.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  Define_Message in '..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
  xlTcpClient in '..\..\..\devwintech\v0000\win_net\xlTcpClient.pas',
  xlClientSocket in '..\..\..\devwintech\v0000\win_net\xlClientSocket.pas',
  xlNetwork in '..\..\..\devwintech\v0000\win_net\xlNetwork.pas',
  win.thread in '..\..\..\devwintech\v0000\win_system\win.thread.pas',  
  uiwin.memdc in '..\..\..\devwintech\v0000\win_ui\uiwin.memdc.pas',
  uiwin.gdi in '..\..\..\devwintech\v0000\win_ui\uiwin.gdi.pas',
  uiwin.color in '..\..\..\devwintech\v0000\win_ui\uiwin.color.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Indy in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Indy.pas',
  UtilsHttp_Socket in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Socket.pas',
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
