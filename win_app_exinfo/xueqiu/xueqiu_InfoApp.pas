unit xueqiu_InfoApp;

interface

uses
  cef_apiobj,
  HostWnd_chromium,
  BaseStockApp;
  
type
  TXueQiuInfoApp = class(TBaseStockApp)
  protected      
    fCefClientObject: cef_apiobj.TCefClientObject;
    fHostWindow: HostWnd_chromium.THostWndChromium;   
    procedure LoadUrl;
    procedure CreateBrowser;
    procedure CreateHostWindow;
  public
    procedure Run; override;    
  end;
         
var
  GlobalApp: TXueQiuInfoApp = nil;
  
implementation

uses
  Windows,
  Sysutils,
  chromium_dom,
  Define_Message,
  cef_type,
  cef_app,
  cef_api,
  cef_utils,
  cef_apilib;
  
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
    cef_app.CefApp.CefLibrary.CefCoreSettings.multi_threaded_message_loop := False;
    CefApp.CefLibrary.CefCoreSettings.multi_threaded_message_loop := True;
    cef_apilib.InitCefLib(@CefApp.CefLibrary, @CefApp.CefAppObject);
    if CefApp.CefLibrary.LibHandle <> 0 then
    begin
      fCefClientObject.HostWindow := fHostWindow.BaseWnd.UIWndHandle;
      fCefClientObject.CefIsCreateWindow := true;
      fCefClientObject.Rect.Left := 0;
      fCefClientObject.Rect.Top := 0; 
      fCefClientObject.Width := fHostWindow.BaseWnd.ClientRect.Right; //Self.Width - pnlRight.Width - 4 * 2;
      fCefClientObject.Height := fHostWindow.BaseWnd.ClientRect.Bottom; //Self.Height - pnlTop.Height - 4 * 2;
      fCefClientObject.CefUrl := 'about:blank';      
      fCefClientObject.Rect.Right := fCefClientObject.Rect.Left + fCefClientObject.Width;
      fCefClientObject.Rect.Bottom := fCefClientObject.Rect.Top + fCefClientObject.Height;
      cef_utils.CreateBrowserCore(@fCefClientObject, @CefApp.CefLibrary, fHostWindow.BaseWnd.UIWndHandle);//Self.WindowHandle);
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
  fHostWindow.BaseWnd.ExStyle := WS_EX_TOOLWINDOW
    //or WS_EX_TOPMOST
    ;
  CreateHostWndChromium(@fHostWindow);
end;

procedure DoLoadEnd(ACefClient: PCefClientObject; AUrl: string);
begin
  if SameText(ACefClient.CefUrl, AUrl) then
  begin
    chromium_dom.TestTraverseChromiumDom(ACefClient, nil);
  end;
end;

procedure TXueQiuInfoApp.LoadUrl;        
var
  tmpMainFrame: PCefFrame;
  tmpUrl: cef_type.TCefString;
begin
  if nil <> fCefClientObject.CefBrowser then
  begin
    tmpMainFrame := fCefClientObject.CefBrowser.get_main_frame(fCefClientObject.CefBrowser);
    if nil <> tmpMainFrame then
    begin
      fCefClientObject.CefOnLoadEnd := DoLoadEnd;

      fCefClientObject.CefUrl := 'https://xueqiu.com/S/SZ300134';
      tmpUrl := CefString(fCefClientObject.CefUrl);
      
      tmpMainFrame.load_url(tmpMainFrame, @tmpUrl);
    end;
  end;
end;

function AppCmdWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
begin
  case AMsg of
    WM_AppStart: begin
      if nil <> GlobalApp then
      begin
        GlobalApp.LoadUrl;
      end;
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

function CreateAppCmdWnd(AWndClassName: AnsiString): HWND;
var  
  tmpRegWndClass: TWndClassA;
begin
  Result := 0;       
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);

  tmpRegWndClass.style := 0;//CS_VREDRAW;
  
  tmpRegWndClass.lpszClassName := PAnsiChar(AWndClassName);
  tmpRegWndClass.lpfnWndProc := @AppCmdWndProcA;
  if 0 = Windows.RegisterClassA(tmpRegWndClass) then
    exit;

  Result := Windows.CreateWindowExA(
    0, //AUIWnd.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    0, //AUIWnd.Style {+ 0},
    0, //AUIWnd.WindowRect.Left,
    0, //AUIWnd.WindowRect.Top,
    0, //AUIWnd.ClientRect.Right,
    0, //AUIWnd.ClientRect.Bottom,
    HWND_MESSAGE, // wndParent
    0, // menu
    HInstance, nil);
  if IsWindow(Result) then
  begin
    Windows.SetParent(Result, HWND_MESSAGE);
  end;
end;

function AppStartDelayRunProc(AParam: Pointer): HResult; stdcall;
begin
  Result := 0;
  Sleep(1 * 200);             
  if nil <> GlobalApp then
  begin
    PostMessage(GlobalApp.fBaseWinAppData.AppCmdWnd, Define_Message.WM_AppStart, 0, 0);
  end;
  Windows.ExitThread(Result);
end;

procedure TXueQiuInfoApp.Run;
var
  tmpThreadHandle: THandle;
  tmpThreadId: DWORD;
begin
  inherited;      
  FillChar(fCefClientObject, SizeOf(fCefClientObject), 0);
  FillChar(fHostWindow, SizeOf(fHostWindow), 0);

  fBaseWinAppData.AppCmdWnd := CreateAppCmdWnd('F2488C22-131B-407F-840C-7F7EF6E8C8F4');
  if IsWindow(fBaseWinAppData.AppCmdWnd) then
  begin
    CreateHostWindow;
    if IsWindow(fHostWindow.BaseWnd.UIWndHandle) then
    begin
      ShowWindow(fHostWindow.BaseWnd.UIWndHandle, SW_SHOW);
      CreateBrowser;
      tmpThreadHandle := Windows.CreateThread(nil, //lpThreadAttributes: Pointer;
                           0, //dwStackSize: DWORD;
                           @AppStartDelayRunProc, //lpStartAddress: TFNThreadStartRoutine;
                           nil, //lpParameter: Pointer;
                           CREATE_SUSPENDED, // dwCreationFlags: DWORD;
                           tmpThreadId //var lpThreadId: DWORD);
                           );
      ResumeThread(tmpThreadHandle);
      RunAppMsgLoop;
    end;
  end;
end;

end.
