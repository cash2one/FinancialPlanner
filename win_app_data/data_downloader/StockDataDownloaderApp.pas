unit StockDataDownloaderApp;

interface

uses           
  Sysutils, Windows,   
  UtilsHttp,
  BaseApp,
  define_dealItem,
  define_stockapp,
  define_StockDataApp,
  win.process;

type
  PDownloaderAppData = ^TDownloaderAppData;
  TDownloaderAppData = record
    Console_Process: TExProcess;
    HttpClientSession: THttpClientSession;
  end;
               
  TStockDataDownloaderApp = class(BaseApp.TBaseAppAgent)
  protected         
    fDownloaderAppData: TDownloaderAppData;
  public               
    constructor Create(AHostApp: TBaseApp); override;
    destructor Destroy; override;    
    function Initialize: Boolean; override;  
    function CreateAppCommandWindow: Boolean;
    procedure Downloader_Download(ADownloaderApp: PDownloaderAppData; AStockCode: integer); overload;
    procedure Downloader_Download(AStockCode: integer); overload;
    function Downloader_CheckConsoleProcess(ADownloaderApp: PDownloaderAppData): Boolean;
  end;
  
implementation
            
uses
  windef_msg,
  BaseStockApp, 
  StockDayData_Get_163,
  UtilsLog;

var
  G_StockDataDownloaderApp: TStockDataDownloaderApp = nil;

function AppCommandWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case AMsg of
    WM_AppStart: begin
      if nil <> GlobalBaseStockApp then
      begin
        //GlobalBaseStockApp.RunStart;
      end;
      exit;
    end;
    WM_AppRequestEnd: begin    
      GlobalBaseStockApp.Terminate;
    end;
    WM_Console2Downloader_Command_Download: begin
      PostMessage(AWnd, WM_Downloader_Command_Download, wParam, 0)
    end;
    WM_Downloader_Command_Download: begin
      if nil <> G_StockDataDownloaderApp then
      begin
        G_StockDataDownloaderApp.Downloader_Download(wParam);
      end;
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;
               
constructor TStockDataDownloaderApp.Create(AHostApp: TBaseApp);
begin
  inherited;
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
    UtilsLog.G_LogFile.FileName := ChangeFileExt(ParamStr(0), '.down.log');
    UtilsLog.SDLog('StockDataDownloaderApp.pas', 'init mode downloader');
    Result := CreateAppCommandWindow;
  end;
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
        
procedure TStockDataDownloaderApp.Downloader_Download(ADownloaderApp: PDownloaderAppData; AStockCode: integer);
var
  tmpStockItem: PRT_DealItem;
begin
  tmpStockItem := TBaseStockApp(Self.fBaseAppAgentData.HostApp).StockItemDB.FindItem(IntToStr(AStockCode));
  if nil <> tmpStockItem then
  begin
    GetStockDataDay_163(fBaseAppAgentData.HostApp, tmpStockItem, False, @ADownloaderApp.HttpClientSession);
    SDLog('', 'Downloader_Download:' + IntToStr(AStockCode));
    if Downloader_CheckConsoleProcess(ADownloaderApp) then
    begin
      SDLog('', 'Downloader_Downloaded:' + IntToStr(AStockCode));
      PostMessage(ADownloaderApp.Console_Process.Core.AppCmdWnd, WM_Downloader2Console_Command_DownloadOK, AStockCode, 0);
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

procedure TStockDataDownloaderApp.Downloader_Download(AStockCode: integer);
begin
  Downloader_Download(@fDownloaderAppData, AStockCode);
end;

end.
