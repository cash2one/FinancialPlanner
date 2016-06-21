unit StockDataApp;

interface

uses
  define_stockapp,  
  define_dealItem,
  define_StockDataApp,

  BaseApp,
  BaseStockApp,
  StockDataDownloaderApp,
  StockDataConsoleApp;

type
  TStockDataAppData = record
    RunMode: TStockDataAppRunMode;
    AppAgent: TBaseAppAgent;
    //ConsoleAppData: TConsoleAppData;
    //DownloaderAppData: TDownloaderAppData;
  end;
  
  TStockDataApp = class(TBaseStockApp)
  protected
    fStockDataAppData: TStockDataAppData;
    //function CreateAppCommandWindow: Boolean;
    
    //procedure RunStart;
    //procedure RunStart_Console(AConsoleApp: PConsoleAppData);
    //procedure RunStart_Downloader;      
    //function Console_GetNextDownloadDealItem(AConsoleApp: PConsoleAppData): PRT_DealItem;
    //procedure Console_NotifyDownloadData(AConsoleApp: PConsoleAppData; ADealItem: PRT_DealItem); overload;
    //procedure Console_NotifyDownloadData(AConsoleApp: PConsoleAppData); overload;
    //procedure Console_Notify_DownloadOK(AStockCode: integer);
    //function Console_CheckDownloaderProcess(AConsoleApp: PConsoleAppData): Boolean;

    //procedure Downloader_Download(ADownloaderApp: PDownloaderAppData; AStockCode: integer); overload;
    //procedure Downloader_Download(AStockCode: integer); overload;
    //function Downloader_CheckConsoleProcess(ADownloaderApp: PDownloaderAppData): Boolean;
  public
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;   
    function Initialize: Boolean; override;
    procedure Finalize; override;
  end;

implementation

uses
  Windows,
  Sysutils,
  Classes,
  db_dealitem,
  UtilsLog,
  DB_dealItem_Load,
  DB_dealItem_Save;

{ TStockDataApp }

constructor TStockDataApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fStockDataAppData, SizeOf(fStockDataAppData), 0);
end;

function TStockDataApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    Result := CheckSingleInstance(AppMutexName_StockDataDownloader_Console);
    if Result then
    begin
      fStockDataAppData.RunMode := runMode_Console;  
      fStockDataAppData.AppAgent := TStockDataConsoleApp.Create(Self);
      Result := fStockDataAppData.AppAgent.Initialize; 
      if not Result then
        exit;
      InitializeDBStockItem;
      Result := 0 < Self.StockItemDB.RecordCount;
      if Result then
      begin                        
      end;
    end else
    begin              
      Result := CheckSingleInstance(AppMutexName_StockDataDownloader);
      if Result then
      begin      
        fStockDataAppData.RunMode := runMode_DataDownloader; 
        fStockDataAppData.AppAgent := TStockDataDownloaderApp.Create(Self);
        Result := fStockDataAppData.AppAgent.Initialize;
        (*//
        UtilsLog.CloseLogFiles;
        UtilsLog.G_LogFile.FileName := ChangeFileExt(ParamStr(0), '.down.log');
        UtilsLog.SDLog('StockDataApp.pas', 'init mode downloader');
        Result := CreateAppCommandWindow;
        if not Result then
          exit;
        //*)
        if not Result then
          exit;
        InitializeDBStockItem;   
        Result := 0 < Self.StockItemDB.RecordCount;
      end;
    end;
  end;
end;

procedure TStockDataApp.Finalize;
begin
  if nil <> fStockDataAppData.AppAgent then
  begin
    fStockDataAppData.AppAgent.Finalize;
    FreeAndNil(fStockDataAppData.AppAgent);
  end;
end;
            
(*//
function AppCommandWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case AMsg of
    WM_AppStart: begin
      if nil <> GlobalBaseStockApp then
      begin
        TStockDataApp(GlobalBaseStockApp).RunStart;
      end;
      exit;
    end;
    WM_AppRequestEnd: begin    
      TStockDataApp(GlobalBaseStockApp).Terminate;
    end;
    WM_Downloader2Console_Command_DownloadOK: begin    
      TStockDataApp(GlobalBaseStockApp).Console_Notify_DownloadOK(wParam);
    end;
    WM_Console2Downloader_Command_Download: begin
      PostMessage(AWnd, WM_Downloader_Command_Download, wParam, 0)
    end;
    WM_Downloader_Command_Download: begin
      TStockDataApp(GlobalBaseStockApp).Downloader_Download(wParam);
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;
//*)
(*//
function TStockDataApp.CreateAppCommandWindow: Boolean;
var
  tmpRegWinClass: TWndClassA;  
  tmpGetWinClass: TWndClassA;
  tmpIsReged: Boolean;
begin
  Result := false;          
  if runMode_Undefine = fStockDataAppData.RunMode then
    exit;
  FillChar(tmpRegWinClass, SizeOf(tmpRegWinClass), 0);
  tmpRegWinClass.hInstance := HInstance;
  tmpRegWinClass.lpfnWndProc := @AppCommandWndProcA;
  if runMode_Console = fStockDataAppData.RunMode then
  begin
    tmpRegWinClass.lpszClassName := AppCmdWndClassName_StockDataDownloader_Console;
  end;
  if runMode_DataDownloader = fStockDataAppData.RunMode then
  begin
    tmpRegWinClass.lpszClassName := AppCmdWndClassName_StockDataDownloader;
  end;
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
  fBaseWinAppData.AppCmdWnd := CreateWindowExA(
    WS_EX_TOOLWINDOW
    //or WS_EX_APPWINDOW
    //or WS_EX_TOPMOST
    ,
    tmpRegWinClass.lpszClassName,
    '', WS_POPUP {+ 0},
    0, 0, 0, 0,
    HWND_MESSAGE, 0, HInstance, nil);
  Result := Windows.IsWindow(fBaseWinAppData.AppCmdWnd);
end;
//*)
(*//                                        
procedure TStockDataApp.Console_NotifyDownloadData(AConsoleApp: PConsoleAppData; ADealItem: PRT_DealItem);
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
                                   
function TStockDataApp.Console_GetNextDownloadDealItem(AConsoleApp: PConsoleAppData): PRT_DealItem;
var
  tmpDealItem: PRT_DealItem;
begin
  Result := nil;
  if 1 > Self.StockItemDB.RecordCount then
    exit;
  if 0 > fStockDataAppData.ConsoleAppData.Download_DealItemIndex then
    fStockDataAppData.ConsoleAppData.Download_DealItemIndex := 0;
  if Self.StockItemDB.RecordCount <= fStockDataAppData.ConsoleAppData.Download_DealItemIndex then
    exit;
  if 0 = fStockDataAppData.ConsoleAppData.Download_DealItemCode then
  begin
    Result := Self.StockItemDB.Items[fStockDataAppData.ConsoleAppData.Download_DealItemIndex];
  end else
  begin
    tmpDealItem := Self.StockItemDB.Items[fStockDataAppData.ConsoleAppData.Download_DealItemIndex];
    if fStockDataAppData.ConsoleAppData.Download_DealItemCode = tmpDealItem.iCode then
    begin
      while nil = Result do
      begin
        Inc(fStockDataAppData.ConsoleAppData.Download_DealItemIndex);
        if Self.StockItemDB.RecordCount > fStockDataAppData.ConsoleAppData.Download_DealItemIndex then
        begin
          tmpDealItem := Self.StockItemDB.Items[fStockDataAppData.ConsoleAppData.Download_DealItemIndex];
          if 0 = tmpDealItem.EndDealDate then
          begin
            Result := tmpDealItem;
          end;
        end else
        begin
          tmpDealItem := nil;
          Break;
        end;
      end;
    end;
  end;
  if nil <> Result then
  begin
    fStockDataAppData.ConsoleAppData.Download_DealItemCode := Result.iCode;
  end;
end;

procedure TStockDataApp.Console_NotifyDownloadData(AConsoleApp: PConsoleAppData);
begin
  Console_NotifyDownloadData(AConsoleApp, Console_GetNextDownloadDealItem(AConsoleApp));
end;

procedure TStockDataApp.Console_Notify_DownloadOK(AStockCode: integer);
var
  tmpConsoleApp: PConsoleAppData;
begin
  tmpConsoleApp := @fStockDataAppData.ConsoleAppData;                
  Console_NotifyDownloadData(tmpConsoleApp, Console_GetNextDownloadDealItem(tmpConsoleApp));
end;

function TStockDataApp.Console_CheckDownloaderProcess(AConsoleApp: PConsoleAppData): Boolean;
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
//*)   
(*//
procedure TStockDataApp.RunStart_Console(AConsoleApp: PConsoleAppData);
begin
  // run downloader process
  //if Console_CheckDownloaderProcess(AConsoleApp) then
  begin
    AConsoleApp.Download_DealItemIndex := 0;
    //Console_NotifyDownloadData(AConsoleApp);
  end;      
end;  
//*)  
(*//
procedure TStockDataApp.Downloader_Download(ADownloaderApp: PDownloaderAppData; AStockCode: integer);
var
  tmpStockItem: PRT_DealItem;
begin
  tmpStockItem := Self.StockItemDB.FindItem(IntToStr(AStockCode));
  if nil <> tmpStockItem then
  begin
    GetStockDataDay_163(Self, tmpStockItem, False, @ADownloaderApp.HttpClientSession);
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
                       
function TStockDataApp.Downloader_CheckConsoleProcess(ADownloaderApp: PDownloaderAppData): Boolean;
begin
  Result := IsWindow(ADownloaderApp.Console_Process.Core.AppCmdWnd);
  if not Result then
  begin      
    ADownloaderApp.Console_Process.Core.AppCmdWnd := Windows.FindWindowA(AppCmdWndClassName_StockDataDownloader_Console, nil);    
    Result := IsWindow(ADownloaderApp.Console_Process.Core.AppCmdWnd);
  end;
end;

procedure TStockDataApp.Downloader_Download(AStockCode: integer);
begin
  Downloader_Download(@fStockDataAppData.DownloaderAppData, AStockCode);
end;
//*)   
(*//
procedure TStockDataApp.RunStart_Downloader;
begin

end; 
//*)  
(*//
        if 0 = tmpDealItem.FirstDealDate then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
        tmpDealItem.IsDataChange := 0;
        if GetStockDataDay_163(Self, tmpDealItem, false, @tmpHttpClientSession) then
        begin
          Sleep(2000);
        end;                                      
        if 0 <> tmpDealItem.IsDataChange then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
      end;
    end;     
    if tmpIsNeedSaveStockItemDB then
    begin
      SaveDBStockItem(Self, Self.StockItemDB);
    end;
//*)
     
(*//                        
procedure TStockDataApp.RunStart;
begin
  case fStockDataAppData.RunMode of
    //runMode_Console: RunStart_Console(@fStockDataAppData.ConsoleAppData);
    runMode_DataDownloader: RunStart_Downloader;
  end;
end;
//*)  

procedure TStockDataApp.Run;
begin                  
  if runMode_Console = fStockDataAppData.RunMode then
  begin
    //Application.CreateForm(TfrmSDConsole, fStockDataAppData.ConsoleAppData.ConsoleForm);
    //Application.Run;
    fStockDataAppData.AppAgent.Run;
  end;
  if runMode_DataDownloader = fStockDataAppData.RunMode then
  begin                           
    //PostMessage(fBaseWinAppData.AppCmdWnd, WM_AppStart, 0, 0);
    //RunAppMsgLoop;
    fStockDataAppData.AppAgent.Run;
  end;
end;

end.
