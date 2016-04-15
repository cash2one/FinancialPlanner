program xueqiu_info;

uses
  Windows,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  cef_apilib in '..\..\..\devwintech\v0000\ex_chromium\cef_apilib.pas',
  cef_api in '..\..\..\devwintech\v0000\ex_chromium\cef_api.pas',
  cef_type in '..\..\..\devwintech\v0000\ex_chromium\cef_type.pas',
  cef_app in '..\..\..\devwintech\v0000\ex_chromium\cef_app.pas',
  cef_utils in '..\..\..\devwintech\v0000\ex_chromium\cef_utils.pas',
  cef_apiobj in '..\..\..\devwintech\v0000\ex_chromium\cef_apiobj.pas',
  cef_apilib_init in '..\..\..\devwintech\v0000\ex_chromium\cef_apilib_init.pas',
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
