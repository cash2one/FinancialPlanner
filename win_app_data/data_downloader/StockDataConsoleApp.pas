unit StockDataConsoleApp;

interface

uses      
  Forms, Sysutils, Windows,  
  BaseApp,
  BaseForm,
  define_dealItem,
  define_stockapp,
  define_StockDataApp,
  win.process;
  
type
  PConsoleAppData = ^TConsoleAppData;
  TConsoleAppData = record
    ConsoleForm: BaseForm.TfrmBase;
    Downloader_Process: win.process.TOwnedProcess;
    Download_DealItemIndex: Integer;     
    Download_DealItemCode: Integer;
  end;

  TStockDataConsoleApp = class(BaseApp.TBaseAppAgent)
  protected                       
    fConsoleAppData: TConsoleAppData;
  public                  
    constructor Create(AHostApp: TBaseApp); override;
    destructor Destroy; override;     
    function Initialize: Boolean; override;
    procedure Run; override;
      
    function CreateAppCommandWindow: Boolean;
    function Console_GetNextDownloadDealItem(AConsoleApp: PConsoleAppData): PRT_DealItem;
    procedure Console_NotifyDownloadData(AConsoleApp: PConsoleAppData; ADealItem: PRT_DealItem); overload;
    procedure Console_NotifyDownloadData(AConsoleApp: PConsoleAppData); overload;
    function Console_CheckDownloaderProcess(AConsoleApp: PConsoleAppData): Boolean;
  end;
  
implementation

uses
  windef_msg,
  BaseStockApp,
  SDConsoleForm,
  UtilsLog;
                 
var
  G_StockDataConsoleApp: TStockDataConsoleApp = nil;
                       
function AppCommandWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  tmpStockCode: integer;
  tmpDataSrc: integer;
begin
  Result := 0;
  case AMsg of
    WM_AppStart: begin
    end;
    WM_AppRequestEnd: begin
      if nil <> GlobalBaseStockApp then
      begin
        GlobalBaseStockApp.Terminate;
      end;
    end;          
    WM_Console_Command_Download: begin
      if nil <> GlobalBaseStockApp then
      begin
        //GlobalBaseStockApp.RunStart;
        if nil <> G_StockDataConsoleApp then
        begin
          if G_StockDataConsoleApp.Console_CheckDownloaderProcess(@G_StockDataConsoleApp.fConsoleAppData) then
          begin                         
            tmpStockCode := wParam;
            tmpDataSrc := lParam;
            
            if 0 = G_StockDataConsoleApp.fConsoleAppData.Download_DealItemCode then
            begin
              G_StockDataConsoleApp.fConsoleAppData.Download_DealItemIndex := 0;
            end;
            G_StockDataConsoleApp.Console_NotifyDownloadData(@G_StockDataConsoleApp.fConsoleAppData);
          end;
        end;
      end;
      exit;
    end;
    WM_Downloader2Console_Command_DownloadResult: begin
      if 0 = lParam then
      begin
        // 下载成功
        PostMessage(AWnd, WM_Console_Command_Download, 0, 0);
      end else
      begin
        // 下载失败
        PostMessage(AWnd, WM_Console_Command_Download, 0, 0);        
      end;
      if nil <> G_StockDataConsoleApp then
        //Console_NotifyDownloadData(@fConsoleAppData, Console_GetNextDownloadDealItem(@fConsoleAppData));
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

{ TStockDataConsoleApp }

constructor TStockDataConsoleApp.Create(AHostApp: TBaseApp);
begin
  inherited;
  G_StockDataConsoleApp := Self;
end;
           
destructor TStockDataConsoleApp.Destroy;
begin
  if G_StockDataConsoleApp = Self then
  begin
    G_StockDataConsoleApp := nil;
  end;
  inherited;
end;

function TStockDataConsoleApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    Application.Initialize;  
    Result := CreateAppCommandWindow;
  end;
end;

procedure TStockDataConsoleApp.Run;
begin
  Application.CreateForm(TfrmSDConsole, fConsoleAppData.ConsoleForm);
  fConsoleAppData.ConsoleForm.Initialize(fBaseAppAgentData.HostApp);
  Application.Run;
end;

function TStockDataConsoleApp.CreateAppCommandWindow: Boolean;
var
  tmpRegWinClass: TWndClassA;  
  tmpGetWinClass: TWndClassA;
  tmpIsReged: Boolean;
begin
  Result := false;          
  FillChar(tmpRegWinClass, SizeOf(tmpRegWinClass), 0);
  tmpRegWinClass.hInstance := HInstance;
  tmpRegWinClass.lpfnWndProc := @AppCommandWndProcA;
  tmpRegWinClass.lpszClassName := AppCmdWndClassName_StockDataDownloader_Console;
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
        
procedure TStockDataConsoleApp.Console_NotifyDownloadData(AConsoleApp: PConsoleAppData; ADealItem: PRT_DealItem);
begin
  if nil = ADealItem then
  begin   
    PostMessage(AConsoleApp.Downloader_Process.Core.AppCmdWnd, WM_AppRequestEnd, 0, 0);
    exit;
  end;
  if Console_CheckDownloaderProcess(AConsoleApp) then
  begin
    PostMessage(AConsoleApp.Downloader_Process.Core.AppCmdWnd, WM_Console2Downloader_Command_Download, ADealItem.iCode, 0);
  end;
end;
               
function TStockDataConsoleApp.Console_GetNextDownloadDealItem(AConsoleApp: PConsoleAppData): PRT_DealItem;
var
  tmpDealItem: PRT_DealItem;
begin
  Result := nil;
  if 1 > TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.RecordCount then
    exit;
  if 0 > AConsoleApp.Download_DealItemIndex then
    AConsoleApp.Download_DealItemIndex := 0;
  if TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.RecordCount <= AConsoleApp.Download_DealItemIndex then
    exit;
  if 0 = AConsoleApp.Download_DealItemCode then
  begin
    Result := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[AConsoleApp.Download_DealItemIndex];
  end else
  begin
    tmpDealItem := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[AConsoleApp.Download_DealItemIndex];
    if AConsoleApp.Download_DealItemCode = tmpDealItem.iCode then
    begin
      while nil = Result do
      begin
        Inc(fConsoleAppData.Download_DealItemIndex);
        if TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.RecordCount > AConsoleApp.Download_DealItemIndex then
        begin
          tmpDealItem := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[AConsoleApp.Download_DealItemIndex];
          if 0 = tmpDealItem.EndDealDate then
          begin
            Result := tmpDealItem;
          end;
        end else
        begin
          Break;
        end;
      end;
    end;
  end;
  if nil <> Result then
  begin
    fConsoleAppData.Download_DealItemCode := Result.iCode;
  end;
end;

procedure TStockDataConsoleApp.Console_NotifyDownloadData(AConsoleApp: PConsoleAppData);
begin
  Console_NotifyDownloadData(AConsoleApp, Console_GetNextDownloadDealItem(AConsoleApp));
end;

function TStockDataConsoleApp.Console_CheckDownloaderProcess(AConsoleApp: PConsoleAppData): Boolean;
var
  i: integer;
  tmpRetCode: DWORD;
begin
  Result := IsWindow(AConsoleApp.Downloader_Process.Core.AppCmdWnd);
  if not Result then
  begin
    if 0 <> AConsoleApp.Downloader_Process.Core.ProcessHandle then
    begin
      if Windows.GetExitCodeProcess(AConsoleApp.Downloader_Process.Core.ProcessHandle, tmpRetCode) then
      begin
        if Windows.STILL_ACTIVE <> tmpRetCode then
          AConsoleApp.Downloader_Process.Core.ProcessId := 0;
      end;
    end else
    begin
      AConsoleApp.Downloader_Process.Core.ProcessId := 0;
    end;
    if 0 = AConsoleApp.Downloader_Process.Core.ProcessId then
      RunProcessA(@AConsoleApp.Downloader_Process, ParamStr(0));
    if (0 = AConsoleApp.Downloader_Process.Core.ProcessHandle) or
       (INVALID_HANDLE_VALUE = AConsoleApp.Downloader_Process.Core.ProcessHandle) then
      exit;

    for i := 0 to 100 do
    begin
      if IsWindow(AConsoleApp.Downloader_Process.Core.AppCmdWnd) then
        Break;
      AConsoleApp.Downloader_Process.Core.AppCmdWnd := Windows.FindWindowA(AppCmdWndClassName_StockDataDownloader, nil);
      Sleep(10);
    end;
  end;            
  Result := IsWindow(AConsoleApp.Downloader_Process.Core.AppCmdWnd);
end;
       
end.
