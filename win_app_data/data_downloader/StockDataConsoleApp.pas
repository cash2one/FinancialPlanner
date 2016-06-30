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
  PDownloadTask = ^TDownloadTask;
  TDownloadTask = record     
    DownloadProcess: POwnedProcess;
    TaskDataSrc: integer;
    TaskDealItemCode: integer;

    DealItemIndex: Integer;     
    DealItemCode: Integer;
    DealItem: PRT_DealItem;
  end;
  
  PConsoleAppData = ^TConsoleAppData;
  TConsoleAppData = record
    ConsoleForm: BaseForm.TfrmBase;
    //RequestDownloadTask: TDownloadTask;
  end;

  TStockDataConsoleApp = class(BaseApp.TBaseAppAgent)
  protected                       
    fConsoleAppData: TConsoleAppData;
  public                  
    constructor Create(AHostApp: TBaseApp); override;
    destructor Destroy; override;     
    function Initialize: Boolean; override;
    procedure Run; override;

    function GetDownloadTask(ATaskDataSrc, ATaskDealItemCode: integer): PDownloadTask;
    function NewDownloadTask(ATaskDataSrc, ATaskDealItemCode: integer): PDownloadTask;    
    function CheckOutDownloadTask(ATaskDataSrc, ATaskDealItemCode: integer): PDownloadTask;
    
    function CreateAppCommandWindow: Boolean;
    function Console_GetNextDownloadDealItem(ADownloadTask: PDownloadTask): PRT_DealItem;
    procedure Console_NotifyDownloadData(ADownloadTask: PDownloadTask);
    function Console_CheckDownloaderProcess(ADownloadTask: PDownloadTask): Boolean;
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
  tmpDownloadTask: PDownloadTask;
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
          tmpDataSrc := lParam;
          tmpStockCode := wParam;
          tmpDownloadTask := G_StockDataConsoleApp.GetDownloadTask(tmpDataSrc, tmpStockCode);
          if nil = tmpDownloadTask then
          begin
            tmpDownloadTask := G_StockDataConsoleApp.NewDownloadTask(tmpDataSrc, tmpStockCode);
            
            if G_StockDataConsoleApp.Console_CheckDownloaderProcess(tmpDownloadTask) then
            begin
              if 0 = tmpDownloadTask.DealItemCode then
              begin
                tmpDownloadTask.DealItemIndex := 0;
              end;
              G_StockDataConsoleApp.Console_NotifyDownloadData(tmpDownloadTask);
            end;
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

function TStockDataConsoleApp.GetDownloadTask(ATaskDataSrc, ATaskDealItemCode: integer): PDownloadTask;
begin
  Result := nil;
end;

function TStockDataConsoleApp.NewDownloadTask(ATaskDataSrc, ATaskDealItemCode: integer): PDownloadTask;
begin
  Result := nil;
  if nil <> Result then
  begin
    Result.TaskDataSrc := ATaskDataSrc;
    Result.TaskDealItemCode := ATaskDealItemCode;
  end;
end;

function TStockDataConsoleApp.CheckOutDownloadTask(ATaskDataSrc, ATaskDealItemCode: integer): PDownloadTask;
begin
  Result := GetDownloadTask(ATaskDataSrc, ATaskDealItemCode);
  if nil = Result then
    Result := NewDownloadTask(ATaskDataSrc, ATaskDealItemCode);
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
                                 
procedure TStockDataConsoleApp.Console_NotifyDownloadData(ADownloadTask: PDownloadTask);
begin
  if nil = ADownloadTask then
    exit;
  if nil = ADownloadTask.DealItem then
    ADownloadTask.DealItem := Console_GetNextDownloadDealItem(ADownloadTask);
  if nil = ADownloadTask.DealItem then
  begin   
    PostMessage(ADownloadTask.DownloadProcess.Core.AppCmdWnd, WM_AppRequestEnd, 0, 0);
    exit;
  end;
  if Console_CheckDownloaderProcess(ADownloadTask) then
  begin
    PostMessage(ADownloadTask.DownloadProcess.Core.AppCmdWnd, WM_Console2Downloader_Command_Download, ADownloadTask.DealItem.iCode, 0);
  end;
end;
               
function TStockDataConsoleApp.Console_GetNextDownloadDealItem(ADownloadTask: PDownloadTask): PRT_DealItem;
var
  tmpDealItem: PRT_DealItem;
begin
  Result := nil;
  if 1 > TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.RecordCount then
    exit;
  if 0 > ADownloadTask.DealItemIndex then
    ADownloadTask.DealItemIndex := 0;
  if TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.RecordCount <= ADownloadTask.DealItemIndex then
    exit;
  if 0 = ADownloadTask.DealItemCode then
  begin
    Result := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[ADownloadTask.DealItemIndex];
  end else
  begin
    tmpDealItem := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[ADownloadTask.DealItemIndex];
    if ADownloadTask.DealItemCode = tmpDealItem.iCode then
    begin
      while nil = Result do
      begin
        Inc(ADownloadTask.DealItemIndex);
        if TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.RecordCount > ADownloadTask.DealItemIndex then
        begin
          tmpDealItem := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[ADownloadTask.DealItemIndex];
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
    ADownloadTask.DealItemCode := Result.iCode;
  end;
end;

function TStockDataConsoleApp.Console_CheckDownloaderProcess(ADownloadTask: PDownloadTask): Boolean;
var
  i: integer;
  tmpRetCode: DWORD;
begin
  Result := IsWindow(ADownloadTask.DownloadProcess.Core.AppCmdWnd);
  if not Result then
  begin
    if 0 <> ADownloadTask.DownloadProcess.Core.ProcessHandle then
    begin
      if Windows.GetExitCodeProcess(ADownloadTask.DownloadProcess.Core.ProcessHandle, tmpRetCode) then
      begin
        if Windows.STILL_ACTIVE <> tmpRetCode then
          ADownloadTask.DownloadProcess.Core.ProcessId := 0;
      end;
    end else
    begin
      ADownloadTask.DownloadProcess.Core.ProcessId := 0;
    end;
    if 0 = ADownloadTask.DownloadProcess.Core.ProcessId then
      RunProcessA(@ADownloadTask.DownloadProcess, ParamStr(0));
    if (0 = ADownloadTask.DownloadProcess.Core.ProcessHandle) or
       (INVALID_HANDLE_VALUE = ADownloadTask.DownloadProcess.Core.ProcessHandle) then
      exit;

    for i := 0 to 100 do
    begin
      if IsWindow(ADownloadTask.DownloadProcess.Core.AppCmdWnd) then
        Break;
      ADownloadTask.DownloadProcess.Core.AppCmdWnd := Windows.FindWindowA(AppCmdWndClassName_StockDataDownloader, nil);
      Sleep(10);
    end;
  end;
  Result := IsWindow(ADownloadTask.DownloadProcess.Core.AppCmdWnd);
end;
       
end.
