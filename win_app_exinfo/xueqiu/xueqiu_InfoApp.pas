unit xueqiu_InfoApp;

interface

uses
  cef_apiobj,
  HostWnd_chromium,
  define_dealitem,
  BaseStockApp;
  
type
  TXueQiuInfoApp = class(TBaseStockApp)
  protected      
    fCefClientObject: cef_apiobj.TCefClientObject;
    fStockIndex: integer;
    fHostWindow: HostWnd_chromium.THostWndChromium;   
    procedure LoadUrl(AStockItem: PRT_DealItem); overload;
    procedure LoadUrl; overload;
    procedure CreateBrowser;
    procedure CreateHostWindow;
  public
    function Initialize: Boolean; override;
    procedure Run; override;    
  end;
         
var
  GlobalApp: TXueQiuInfoApp = nil;
  
implementation

uses
  Windows,
  Sysutils,
  chromium_dom,
  windef_msg,
  win.wnd,
  define_datasrc,
  cef_type,
  cef_app,
  cef_api,
  cef_utils,
  cef_apilib;
  
const
  Url_StockHome = 'https://xueqiu.com/S/'; // https://xueqiu.com/S/SZ300134
  // 股本结构
  Url_StockStruct = 'https://xueqiu.com/S/SZ300134/GBJG';

  WM_LoadUrl = WM_CustomAppBase + 1;
  
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
  fHostWindow.BaseWnd.Style := WS_POPUP or WS_OVERLAPPEDWINDOW;
  fHostWindow.BaseWnd.ExStyle := WS_EX_APPWINDOW //WS_EX_TOOLWINDOW
    //or WS_EX_TOPMOST
    ;
  CreateHostWndChromium(@fHostWindow);
end;

function TXueQiuInfoApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    Self.InitializeDBStockItem();
    if 1 > fBaseStockAppData.StockItemDB.RecordCount then
    begin
      Result := false;
      fStockIndex := 0;
    end;
  end;
end;

(*//
每股收益：0.70
市盈率LYR/TTM：6.70/6.35
总股本：196.53亿
每股净资产：17.48
市净率TTM：0.99
流通股本：186.53亿
每股股息：0.757
市销率TTM：2.20
//*)

procedure DoLoadEnd(ACefClient: PCefClientObject; AUrl: string);
var
  tmpDealItem: PRT_DealItem;
begin
  if SameText(ACefClient.CefUrl, AUrl) then
  begin
    tmpDealItem := ACefClient.ExParam;
    if nil <> tmpDealItem then
    begin
      chromium_dom.TestTraverseChromiumDom(ACefClient, nil);
    end;
  end;
  Sleep(1000);
  PostMessage(GlobalApp.AppWindow, WM_LoadUrl, 0, 0);
end;

procedure TXueQiuInfoApp.LoadUrl;
var
  tmpDealItem: PRT_DealItem;
begin
  if nil = fBaseStockAppData.StockItemDB then
    exit;
  if fStockIndex < 0 then
    fStockIndex := 0;
  if fStockIndex >= fBaseStockAppData.StockItemDB.RecordCount then
    exit;
  tmpDealItem := fBaseStockAppData.StockItemDB.Items[fStockIndex];
  fStockIndex := fStockIndex + 1;
  if 0 = tmpDealItem.EndDealDate then
  begin
    LoadUrl(tmpDealItem);
  end else
  begin
    PostMessage(GlobalApp.AppWindow, WM_LoadUrl, 0, 0);
  end;
end;

procedure TXueQiuInfoApp.LoadUrl(AStockItem: PRT_DealItem);        
var
  tmpMainFrame: PCefFrame;
  tmpUrl: cef_type.TCefString;
begin
  if nil <> fCefClientObject.CefBrowser then
  begin
    tmpMainFrame := fCefClientObject.CefBrowser.get_main_frame(fCefClientObject.CefBrowser);
    if nil <> tmpMainFrame then
    begin
      fCefClientObject.ExParam := AStockItem;
      fCefClientObject.CefOnLoadEnd := DoLoadEnd;

      fCefClientObject.CefUrl := 'https://xueqiu.com/S/' + GetStockCode_Sina(AStockItem);
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
        PostMessage(AWnd, WM_LoadUrl, 0, 0);
      end;
    end;
    WM_LoadUrl: begin
      GlobalApp.LoadUrl();
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

function AppStartDelayRunProc(AParam: Pointer): HResult; stdcall;
begin
  Result := 0;
  Sleep(1 * 200);             
  if nil <> GlobalApp then
  begin
    PostMessage(GlobalApp.fBaseWinAppData.AppCmdWnd, windef_msg.WM_AppStart, 0, 0);
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

  fBaseWinAppData.AppCmdWnd := CreateCommandWndA(@AppCmdWndProcA, 'F2488C22-131B-407F-840C-7F7EF6E8C8F4');
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
