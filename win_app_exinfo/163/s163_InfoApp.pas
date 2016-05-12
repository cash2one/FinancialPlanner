unit s163_InfoApp;

interface

uses
  cef_apiobj,
  HostWnd_chromium,
  define_dealitem,
  BaseStockApp;
  
type
  T163InfoApp = class(TBaseStockApp)
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
  GlobalApp: T163InfoApp = nil;
  
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

  WM_LoadUrl = WM_CustomAppBase + 1;
  // 大单统计
  // http://quotes.money.163.com/trade/ddtj_300134.html
  
procedure T163InfoApp.CreateBrowser;
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

procedure T163InfoApp.CreateHostWindow;
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

function T163InfoApp.Initialize: Boolean;
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

procedure DoLoadEnd(ACefClient: PCefClientObject; AUrl: string);
begin
  if SameText(ACefClient.CefUrl, AUrl) then
  begin
    chromium_dom.TestTraverseChromiumDom(ACefClient, nil);
  end;
  Sleep(1000);
  PostMessage(GlobalApp.AppWindow, WM_LoadUrl, 0, 0);
end;

procedure T163InfoApp.LoadUrl;        
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

procedure T163InfoApp.LoadUrl(AStockItem: PRT_DealItem);        
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

      fCefClientObject.CefUrl := 'http://quotes.money.163.com/' + GetStockCode_163(AStockItem) + '.html#2c01';
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

procedure T163InfoApp.Run;
var
  tmpThreadHandle: THandle;
  tmpThreadId: DWORD;
begin
  inherited;      
  FillChar(fCefClientObject, SizeOf(fCefClientObject), 0);
  FillChar(fHostWindow, SizeOf(fHostWindow), 0);

  fBaseWinAppData.AppCmdWnd := CreateCommandWndA(@AppCmdWndProcA, '7C79D396-D94C-4F71-80FE-BBAC9C84CA65');
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
