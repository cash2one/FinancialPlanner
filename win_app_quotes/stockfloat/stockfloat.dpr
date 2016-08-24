program stockfloat;

uses
  Windows,
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  windef_msg in '..\..\..\devwintech\v0001\windef\windef_msg.pas',
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  base.thread in '..\..\..\devwintech\v0001\rec\app_base\base.thread.pas',
  Base.Run in '..\..\..\devwintech\v0001\rec\app_base\Base.Run.pas',
  win.thread in '..\..\..\devwintech\v0001\rec\win_sys\win.thread.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  ui.color in '..\..\..\devwintech\v0000\uibase\ui.color.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
  uiwin.memdc in '..\..\..\devwintech\v0000\win_ui\uiwin.memdc.pas',
  uiwin.gdi in '..\..\..\devwintech\v0000\win_ui\uiwin.gdi.pas',
  uiwin.color in '..\..\..\devwintech\v0000\win_ui\uiwin.color.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Socket in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Socket.pas',
  xlNetwork in '..\..\..\devwintech\v0000\win_net\xlNetwork.pas',  
  xlClientSocket in '..\..\..\devwintech\v0000\win_netclient\xlClientSocket.pas',
  xlTcpClient in '..\..\..\devwintech\v0000\win_netclient\xlTcpClient.pas',
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
