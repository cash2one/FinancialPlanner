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
  chromium_script in 'chromium_script.pas';

{$R *.res}

type
  TXueQiuInfoApp = class(TBaseWinApp)
  protected      
    fCefClientObject: TCefClientObject;
    fHostWindow: THostWndChromium; 
    procedure CreateBrowser;
    procedure CreateHostWindow;
  public
    procedure Run; override;    
  end;
  
{ TChromiumTestApp }

const
  Url_StockHome = 'https://xueqiu.com/S/'; // https://xueqiu.com/S/SZ300134
  // 股本结构
  Url_StockStruct = 'https://xueqiu.com/S/SZ300134/GBJG';

  //https://xueqiu.com/S/SZ300134/ZYGD // 主要股东
  //https://xueqiu.com/S/SZ300134/LTGD // 流通股东
  //https://xueqiu.com/S/SZ300134/GDHS // 股东户数
  //https://xueqiu.com/S/SZ300134/XSGDMD // 限售股东
  //https://xueqiu.com/S/SZ300134/LHB // 龙虎榜数据

  // 交易明细
  // http://stockhtm.finance.qq.com/sstock/quotpage/q/300134.htm#detail
  // 分价表
  // http://stockhtm.finance.qq.com/sstock/quotpage/q/300134.htm#price
  // 大单统计
  // http://quotes.money.163.com/trade/ddtj_300134.html
  // 基金持股
  // http://stock.jrj.com.cn/share,300134,jjcg.shtml

  
procedure TXueQiuInfoApp.CreateBrowser;
begin
  if CefApp.CefLibrary.LibHandle = 0 then
  begin
    CefApp.CefLibrary.CefCoreSettings.multi_threaded_message_loop := False;
    CefApp.CefLibrary.CefCoreSettings.multi_threaded_message_loop := True;
    InitCefLib(@CefApp.CefLibrary, @CefApp.CefAppObject);
    if CefApp.CefLibrary.LibHandle <> 0 then
    begin
      fCefClientObject.HostWindow := fHostWindow.BaseWnd.UIWndHandle;
      fCefClientObject.CefIsCreateWindow := true;
      fCefClientObject.Rect.Left := 0;
      fCefClientObject.Rect.Top := 0; 
      fCefClientObject.Width := fHostWindow.BaseWnd.ClientRect.Right; //Self.Width - pnlRight.Width - 4 * 2;
      fCefClientObject.Height := fHostWindow.BaseWnd.ClientRect.Bottom; //Self.Height - pnlTop.Height - 4 * 2;
      fCefClientObject.CefUrl := 'https://xueqiu.com/S/SZ300134';      
      fCefClientObject.Rect.Right := fCefClientObject.Rect.Left + fCefClientObject.Width;
      fCefClientObject.Rect.Bottom := fCefClientObject.Rect.Top + fCefClientObject.Height;
      CreateBrowserCore(@fCefClientObject, @CefApp.CefLibrary, fHostWindow.BaseWnd.UIWndHandle);//Self.WindowHandle);
    end;
  end;
end;

procedure TXueQiuInfoApp.CreateHostWindow;
begin                                          
  fHostWindow.BaseWnd.WindowRect.Top := 30;
  fHostWindow.BaseWnd.WindowRect.Left := 50;

  fHostWindow.BaseWnd.ClientRect.Right := 800;
  fHostWindow.BaseWnd.ClientRect.Bottom := 600;
  fHostWindow.BaseWnd.Style := WS_POPUP;
  fHostWindow.BaseWnd.ExStyle := WS_EX_TOPMOST;  
  CreateHostWndChromium(@fHostWindow);
end;

procedure TXueQiuInfoApp.Run;
begin
  inherited;      
  FillChar(fCefClientObject, SizeOf(fCefClientObject), 0);
  FillChar(fHostWindow, SizeOf(fHostWindow), 0);

  CreateHostWindow;
  if IsWindow(fHostWindow.BaseWnd.UIWndHandle) then
  begin
    ShowWindow(fHostWindow.BaseWnd.UIWndHandle, SW_SHOW);
    CreateBrowser;
    RunAppMsgLoop;
  end;
end;

var
  GlobalApp: TXueQiuInfoApp;
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
