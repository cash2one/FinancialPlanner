unit StockDataDownloaderApp;

interface

uses           
  Sysutils, Windows,   
  UtilsHttp,
  BaseApp,          
  define_price,
  define_dealItem,
  define_stockapp,
  define_StockDataApp,
  win.iobuffer,
  win.process;

type
  PDownloaderAppData = ^TDownloaderAppData;
  TDownloaderAppData = record
    Console_Process: TExProcess;
    HttpClientSession: THttpClientSession;
    HttpData: win.iobuffer.PIOBuffer;
  end;
               
  TStockDataDownloaderApp = class(BaseApp.TBaseAppAgent)
  protected         
    fDownloaderAppData: TDownloaderAppData;
  public               
    constructor Create(AHostApp: TBaseApp); override;
    destructor Destroy; override;    
    function Initialize: Boolean; override;
    procedure Run; override;  
    function CreateAppCommandWindow: Boolean;
    procedure Downloader_Download(ADownloaderApp: PDownloaderAppData; AStockCode, ADataSrc: integer); overload;
    procedure Downloader_Download(AStockCode, ADataSrc: integer); overload;
    function Downloader_CheckConsoleProcess(ADownloaderApp: PDownloaderAppData): Boolean;
  end;
  
implementation
            
uses
  windef_msg,
  BaseWinApp,
  BaseStockApp,
  define_datasrc,
  StockDayData_Get_163,
  StockDayData_Get_Sina,
  UtilsLog;

var
  G_StockDataDownloaderApp: TStockDataDownloaderApp = nil;

function AppCommandWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case AMsg of
    WM_AppStart: begin
      exit;
    end;
    WM_AppRequestEnd: begin    
      GlobalBaseStockApp.Terminate;
    end;
    WM_Console2Downloader_Command_Download: begin
      PostMessage(AWnd, WM_Downloader_Command_Download, wParam, lParam)
    end;
    WM_Downloader_Command_Download: begin
      if nil <> G_StockDataDownloaderApp then
      begin
        G_StockDataDownloaderApp.Downloader_Download(wParam, lParam);
      end;
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;
               
constructor TStockDataDownloaderApp.Create(AHostApp: TBaseApp);
begin
  inherited;
  FillChar(fDownloaderAppData, SizeOf(fDownloaderAppData), 0);
  G_StockDataDownloaderApp := Self;
end;

destructor TStockDataDownloaderApp.Destroy;
begin
  if G_StockDataDownloaderApp = Self then
  begin
    G_StockDataDownloaderApp := nil;
  end;
  inherited;
end;
                  
function TStockDataDownloaderApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    UtilsLog.CloseLogFiles;
    UtilsLog.G_LogFile.FileName := ChangeFileExt(ParamStr(0), '.down.' + IntToStr(Windows.GetCurrentProcessId) + '.log');
    UtilsLog.SDLog('StockDataDownloaderApp.pas', 'init mode downloader');
    Result := CreateAppCommandWindow;
  end;
end;

procedure TStockDataDownloaderApp.Run;
begin
  PostMessage(TBaseWinApp(fBaseAppAgentData.HostApp).AppWindow, WM_AppStart, 0, 0);
  TBaseWinApp(fBaseAppAgentData.HostApp).RunAppMsgLoop;
end;

function TStockDataDownloaderApp.CreateAppCommandWindow: Boolean;
var
  tmpRegWinClass: TWndClassA;  
  tmpGetWinClass: TWndClassA;
  tmpIsReged: Boolean;
begin
  Result := false;          
  FillChar(tmpRegWinClass, SizeOf(tmpRegWinClass), 0);
  tmpRegWinClass.hInstance := HInstance;
  tmpRegWinClass.lpfnWndProc := @AppCommandWndProcA;
  tmpRegWinClass.lpszClassName := AppCmdWndClassName_StockDataDownloader;
  tmpIsReged := GetClassInfoA(HInstance, tmpRegWinClass.lpszClassName, tmpGetWinClass);
  if tmpIsReged then
  begin
    if (tmpGetWinClass.lpfnWndProc <> tmpRegWinClass.lpfnWndProc) then
    begin                           
      UnregisterClassA(tmpRegWinClass.lpszClassName, HInstance);
      tmpIsReged := false;
    end;
  end;
  if not tmpIsReged then
  begin
    if 0 = RegisterClassA(tmpRegWinClass) then
      exit;
  end;
  TBaseStockApp(fBaseAppAgentData.HostApp).AppWindow := CreateWindowExA(
    WS_EX_TOOLWINDOW
    //or WS_EX_APPWINDOW
    //or WS_EX_TOPMOST
    ,
    tmpRegWinClass.lpszClassName,
    '', WS_POPUP {+ 0},
    0, 0, 0, 0,
    HWND_MESSAGE, 0, HInstance, nil);
  Result := Windows.IsWindow(TBaseStockApp(fBaseAppAgentData.HostApp).AppWindow);
end;
        
procedure TStockDataDownloaderApp.Downloader_Download(ADownloaderApp: PDownloaderAppData; AStockCode, ADataSrc: integer);
var
  tmpStockItem: PRT_DealItem;
begin
  tmpStockItem := TBaseStockApp(Self.fBaseAppAgentData.HostApp).StockItemDB.FindItem(IntToStr(AStockCode));
  if nil <> tmpStockItem then
  begin
    if DataSrc_163 = ADataSrc then
    begin
      GetStockDataDay_163(fBaseAppAgentData.HostApp, tmpStockItem, @ADownloaderApp.HttpClientSession, fDownloaderAppData.HttpData);
      SDLog('', 'Downloader_Download 163:' + IntToStr(AStockCode));
    end;                  
    if DataSrc_Sina = ADataSrc then
    begin
      if nil = fDownloaderAppData.HttpData then
      begin
        fDownloaderAppData.HttpData := CheckOutIOBuffer(SizeMode_512k);
      end;
      GetStockDataDay_Sina(fBaseAppAgentData.HostApp, tmpStockItem, weightBackward, @ADownloaderApp.HttpClientSession, fDownloaderAppData.HttpData);
      //SDLog('', 'Downloader_Download Sina:' + IntToStr(AStockCode));
    end;
    if Downloader_CheckConsoleProcess(ADownloaderApp) then
    begin
      SDLog('', 'Downloader_Downloaded:' + IntToStr(AStockCode));
      PostMessage(ADownloaderApp.Console_Process.Core.AppCmdWnd, WM_Downloader2Console_Command_DownloadResult, Windows.GetCurrentProcessId, 0);
    end else
    begin
      // 
      PostMessage(ADownloaderApp.Console_Process.Core.AppCmdWnd, WM_Downloader2Console_Command_DownloadResult, Windows.GetCurrentProcessId, 1001);
    end;
  end else
  begin
    SDLog('', 'Downloader_Download can not find stock:' + IntToStr(AStockCode));
  end;
end;
                       
function TStockDataDownloaderApp.Downloader_CheckConsoleProcess(ADownloaderApp: PDownloaderAppData): Boolean;
begin
  Result := IsWindow(ADownloaderApp.Console_Process.Core.AppCmdWnd);
  if not Result then
  begin      
    ADownloaderApp.Console_Process.Core.AppCmdWnd := Windows.FindWindowA(AppCmdWndClassName_StockDataDownloader_Console, nil);    
    Result := IsWindow(ADownloaderApp.Console_Process.Core.AppCmdWnd);
  end;
end;

procedure TStockDataDownloaderApp.Downloader_Download(AStockCode, ADataSrc: integer);
begin
  Downloader_Download(@fDownloaderAppData, AStockCode, ADataSrc);
end;

end.
