program xueqiu_info;

uses
  Windows,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',    
  cef_apilib in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib.pas',               
  cef_apilib_requesthandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_requesthandler.pas',
  cef_apilib_domvisitor in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_domvisitor.pas',
  cef_apilib_loadhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_loadhandler.pas',
  cef_apilib_contentfilter in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_contentfilter.pas',
  cef_apilib_displayhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_displayhandler.pas',
  cef_apilib_focushandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_focushandler.pas',
  cef_apilib_findhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_findhandler.pas',
  cef_apilib_keyboardhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_keyboardhandler.pas',
  cef_apilib_printhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_printhandler.pas',
  cef_apilib_permissionhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_permissionhandler.pas',
  cef_apilib_menuhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_menuhandler.pas',
  cef_apilib_draghandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_draghandler.pas',
  cef_apilib_zoomhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_zoomhandler.pas',
  cef_apilib_renderhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_renderhandler.pas',
  cef_apilib_geolocationhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_geolocationhandler.pas',
  cef_apilib_resbundlehandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_resbundlehandler.pas',
  cef_apilib_proxyhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_proxyhandler.pas',
  cef_apilib_jsv8 in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_jsv8.pas',
  cef_apilib_readhandler in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_readhandler.pas',
  cef_apilib_streamreader in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_streamreader.pas',
  cef_apilib_lifespan in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_lifespan.pas',
  cef_api in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_api.pas',
  cef_type in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_type.pas',
  cef_app in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_app.pas',
  cef_utils in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_utils.pas',
  cef_apiobj in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apiobj.pas',
  cef_apilib_init in '..\..\..\devwintech\v0000\ex_chromium\v0001\cef_apilib_init.pas',
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseFile in '..\..\..\devwintech\v0000\app_base\BaseFile.pas',
  BaseRun in '..\..\..\devwintech\v0000\app_base\BaseRun.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseThread in '..\..\..\devwintech\v0000\app_base\BaseThread.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  BaseWinHook in '..\..\..\devwintech\v0000\win_base\BaseWinHook.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  Define_Message in '..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  win.thread in '..\..\..\devwintech\v0000\win_system\win.thread.pas',
  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  HostWnd_chromium in 'HostWnd_chromium.pas',
  chromium_dom in 'chromium_dom.pas',
  chromium_script in 'chromium_script.pas',
  xueqiu_InfoApp in 'xueqiu_InfoApp.pas';

{$R *.res}

{ TChromiumTestApp }

//  tmpAnsi: AnsiString;
//  tmpOutputAnsi: AnsiString;
//  tmpDecodeAnsi: AnsiString;
//  tmpLength: integer;
begin
//  tmpLength := SizeOf(TByteX);
//  if 1 > tmpLength then
//    exit;

//  tmpANsi := 'good 123456';
//  //tmpOutputAnsi := DesEncrypt(tmpANsi, 'cool');
//  //tmpDecodeAnsi := DesDecrypt(tmpOutputAnsi, 'cool');
//  
//  if tmpOutputAnsi <> tmpDecodeAnsi then
//    exit;
//  
////  if Base64_EncodeTable[3] = 'A' then
////    exit;
//  if '' = tmpANsi then
//    exit;
  RunApp(TXueQiuInfoApp, '', TBaseApp(GlobalApp));
end.
