unit StockDataApp;

interface

uses
  define_stockapp,  
  define_dealItem,
  windef_msg, 
  UtilsHttp,
  win.process,
  BaseApp,
  BaseStockApp;

type
  TStockDataAppRunMode = (
    runMode_Undefine,
    runMode_Console,
    runMode_DataDownloader);

  PConsoleAppData = ^TConsoleAppData;
  TConsoleAppData = record
    Downloader_Process: TOwnedProcess;
    Download_DealItemIndex: Integer;
  end;

  PDownloaderAppData = ^TDownloaderAppData;
  TDownloaderAppData = record
    HttpClientSession: THttpClientSession;
  end;
  
  TStockDataAppData = record
    RunMode: TStockDataAppRunMode;

    ConsoleAppData: TConsoleAppData;
    DownloaderAppData: TDownloaderAppData;
  end;
  
  TStockDataApp = class(TBaseStockApp)
  protected
    fStockDataAppData: TStockDataAppData;
    function CreateAppCommandWindow: Boolean;
    
    procedure RunStart;
    procedure RunStart_Console(AConsoleApp: PConsoleAppData);
    procedure RunStart_Downloader;
    procedure Console_NotifyDownloadData(ADealItem: PRT_DealItem); overload;
    procedure Console_NotifyDownloadData; overload;
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
  Define_Price,
  db_dealitem,
  Define_DataSrc,
  StockDayData_Get_163,
  win.iobuffer,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
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
      Result := CreateAppCommandWindow;
      if not Result then
        exit;
      InitializeDBStockItem;
      Result := 0 < Self.StockItemDB.RecordCount;
    end else
    begin              
      Result := CheckSingleInstance(AppMutexName_StockDataDownloader);
      fStockDataAppData.RunMode := runMode_DataDownloader;  
      Result := CreateAppCommandWindow;
    end;
  end;
end;

procedure TStockDataApp.Finalize;
begin

end;

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
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

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
                                          
procedure TStockDataApp.Console_NotifyDownloadData(ADealItem: PRT_DealItem);
begin               
end;
                                   
procedure TStockDataApp.Console_NotifyDownloadData;    
var
  tmpDealItem: PRT_DealItem;  
begin
  if 0 > fStockDataAppData.ConsoleAppData.Download_DealItemIndex then
    exit;
  if Self.StockItemDB.RecordCount <= fStockDataAppData.ConsoleAppData.Download_DealItemIndex then
    exit;
  tmpDealItem := Self.StockItemDB.Items[fStockDataAppData.ConsoleAppData.Download_DealItemIndex];
  if 0 = tmpDealItem.EndDealDate then
  begin
    Console_NotifyDownloadData(tmpDealItem);
  end;
end;

procedure TStockDataApp.RunStart_Console(AConsoleApp: PConsoleAppData);
var
  i: integer;      
begin
  // run downloader process
  RunProcessA(@AConsoleApp.Downloader_Process, ParamStr(0));
  if (0 = AConsoleApp.Downloader_Process.Core.ProcessHandle) or
     (INVALID_HANDLE_VALUE = AConsoleApp.Downloader_Process.Core.ProcessHandle) then
    exit;                     

  for i := 0 to 100 do
  begin
    if IsWindow(AConsoleApp.Downloader_Process.AppCmdWnd) then
      Break;
    AConsoleApp.Downloader_Process.AppCmdWnd := Windows.FindWindowA(AppCmdWndClassName_StockDataDownloader, nil);
    Sleep(10);
  end;
                    
  if IsWindow(AConsoleApp.Downloader_Process.AppCmdWnd) then
  begin
    AConsoleApp.Download_DealItemIndex := 0;
    Console_NotifyDownloadData;
  end;
end;

procedure TStockDataApp.RunStart_Downloader;
begin

end;
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
                             
procedure TStockDataApp.RunStart;
begin
  case fStockDataAppData.RunMode of
    runMode_Console: RunStart_Console(@fStockDataAppData.ConsoleAppData);
    runMode_DataDownloader: RunStart_Downloader;
  end;
end;

procedure TStockDataApp.Run;
begin
  PostMessage(fBaseWinAppData.AppCmdWnd, WM_AppStart, 0, 0);
  RunAppMsgLoop;
end;

end.
