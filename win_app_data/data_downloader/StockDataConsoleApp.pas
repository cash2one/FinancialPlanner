unit StockDataConsoleApp;

interface

uses      
  Forms, Sysutils, Windows, Classes,  
  BaseApp,
  BaseForm,
  define_datasrc,
  define_dealItem,
  define_stockapp,
  define_StockDataApp,
  win.process;

const
  TaskStatus_Active = 1;
  TaskStatus_End = 2;

type
  PDownloadTask       = ^TDownloadTask;
  TDownloadTask       = record
    DownloadProcess   : TRT_OwnedProcess;
    TaskID            : Integer;
    TaskDataSrc       : TDealDataSource; 
    TaskDealItemCode  : Integer;
    TaskDataType      : Integer;
    TaskStatus        : Integer;
    
    // monitor if task process is crashed
    MonitorTick       : DWORD;
    MonitorDealItem   : PRT_DealItem;

    DealItemIndex: Integer;
    DealItem: PRT_DealItem;
  end;
  
  PConsoleAppData = ^TConsoleAppData;
  TConsoleAppData = record
    ConsoleForm: BaseForm.TfrmBase;
    TaskList: TList;
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

    procedure ClearTask;    
    function GetDownloadTask(ATaskDataSrc: TDealDataSource; ATaskDealItemCode: integer): PDownloadTask;
    function NewDownloadTask(ATaskDataSrc: TDealDataSource; ATaskDealItemCode: integer): PDownloadTask;    
    function CheckOutDownloadTask(ATaskDataSrc: TDealDataSource; ATaskDealItemCode: integer): PDownloadTask;
    function GetDownloadTaskByProcessID(AProcessId: integer): PDownloadTask;
    
    function CreateAppCommandWindow: Boolean;
    function Console_GetNextDownloadDealItem(ADownloadTask: PDownloadTask): PRT_DealItem;
    procedure Console_NotifyDownloadData(ADownloadTask: PDownloadTask);
    function Console_CheckDownloaderProcess(ADownloadTask: PDownloadTask): Boolean;  
    procedure Console_NotifyDownloaderShutdown(ADownloadTask: PDownloadTask);
  end;
              
var
  G_StockDataConsoleApp: TStockDataConsoleApp = nil;
                     
implementation

uses
  windef_msg,
  //UtilsLog,
  BaseStockApp,
  SDConsoleForm;

function AppCommandWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  tmpStockCode: integer;
  tmpDataSrc: integer;
  tmpDownloadTask: PDownloadTask;
  tmpDealItem: PRT_DealItem;
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
    WM_AppNotifyShutdownMachine: begin
    
    end;   
    WM_Console_Command_Download: begin
      if nil <> GlobalBaseStockApp then
      begin
        //GlobalBaseStockApp.RunStart;
        if nil <> G_StockDataConsoleApp then
        begin                      
          tmpDataSrc := lParam;
          tmpStockCode := wParam;
          tmpDownloadTask := G_StockDataConsoleApp.GetDownloadTask(GetDealDataSource(tmpDataSrc), tmpStockCode);
          if nil = tmpDownloadTask then
          begin
            tmpDownloadTask := G_StockDataConsoleApp.NewDownloadTask(GetDealDataSource(tmpDataSrc), tmpStockCode);
          end;                    
          tmpDownloadTask.TaskStatus := TaskStatus_Active;
          if G_StockDataConsoleApp.Console_CheckDownloaderProcess(tmpDownloadTask) then
          begin
            G_StockDataConsoleApp.Console_NotifyDownloadData(tmpDownloadTask);
          end;
        end;
      end;
      exit;
    end;
    WM_Downloader2Console_Command_DownloadResult: begin
      tmpDownloadTask := G_StockDataConsoleApp.GetDownloadTaskByProcessID(wParam);
      if nil <> tmpDownloadTask then
      begin
        if 0 = lParam then
        begin
            // 下载成功
          tmpDealItem := G_StockDataConsoleApp.Console_GetNextDownloadDealItem(tmpDownloadTask);
          if nil <> tmpDealItem then
          begin
            tmpDownloadTask.DealItem := tmpDealItem;
            PostMessage(AWnd, WM_Console_Command_Download, tmpDownloadTask.TaskDealItemCode, GetDealDataSourceCode(tmpDownloadTask.TaskDataSrc));
          end else
          begin
            // 都下载完了 ???        
            tmpDownloadTask.DealItem := nil;
            tmpDownloadTask.TaskStatus := TaskStatus_End;             
            G_StockDataConsoleApp.Console_NotifyDownloaderShutdown(tmpDownloadTask);
            //PostMessage(AWnd, WM_AppRequestEnd, 0, 0);
          end;
        end else
        begin
            // 下载失败
          PostMessage(AWnd, WM_Console_Command_Download, 0, 0);
        end;
      end;
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

{ TStockDataConsoleApp }

constructor TStockDataConsoleApp.Create(AHostApp: TBaseApp);
begin
  inherited;
  G_StockDataConsoleApp := Self;
  FillChar(fConsoleAppData, SizeOf(fConsoleAppData), 0);
  AHostApp.AppAgent := Self;
  fConsoleAppData.TaskList := TList.Create;
end;
           
destructor TStockDataConsoleApp.Destroy;
begin
  if G_StockDataConsoleApp = Self then
  begin
    G_StockDataConsoleApp := nil;
  end;
  ClearTask;
  FreeAndNil(fConsoleAppData.TaskList);  
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

procedure TStockDataConsoleApp.ClearTask;
var
  i: Integer;
  tmpTask: PDownloadTask;
begin
  if nil <> fConsoleAppData.TaskList then
  begin
    for i := fConsoleAppData.TaskList.Count - 1 downto 0 do
    begin
      tmpTask := fConsoleAppData.TaskList.Items[i];
      FreeMem(tmpTask);
    end;
    fConsoleAppData.TaskList.Clear;
  end;
end;

function TStockDataConsoleApp.GetDownloadTask(ATaskDataSrc: TDealDataSource; ATaskDealItemCode: integer): PDownloadTask;   
var
  i: Integer;   
  tmpTask: PDownloadTask;
begin
  Result := nil; 
  if nil <> fConsoleAppData.TaskList then
  begin
    for i := fConsoleAppData.TaskList.Count - 1 downto 0 do
    begin
      tmpTask := fConsoleAppData.TaskList.Items[i];   
      if (tmpTask.TaskDataSrc = ATaskDataSrc) and ((tmpTask.TaskDealItemCode = ATaskDealItemCode)) then
      begin
        Result := tmpTask;
        Break;
      end;
    end;
  end;
end;

function TStockDataConsoleApp.GetDownloadTaskByProcessID(AProcessId: integer): PDownloadTask;
var
  i: Integer;   
  tmpTask: PDownloadTask;
begin
  Result := nil;
  if nil <> fConsoleAppData.TaskList then
  begin
    for i := fConsoleAppData.TaskList.Count - 1 downto 0 do
    begin
      tmpTask := fConsoleAppData.TaskList.Items[i];
      if tmpTask.DownloadProcess.Core.ProcessId = AProcessId then
      begin
        Result := tmpTask;
        Break;
      end;
    end;
  end;
end;

function TStockDataConsoleApp.NewDownloadTask(ATaskDataSrc: TDealDataSource; ATaskDealItemCode: integer): PDownloadTask;
begin
  Result := System.New(PDownloadTask);
  FillChar(Result^, SizeOf(TDownloadTask), 0);

  Result.TaskDataSrc := ATaskDataSrc;
  Result.TaskDealItemCode := ATaskDealItemCode;
  fConsoleAppData.TaskList.Add(Result);
end;

function TStockDataConsoleApp.CheckOutDownloadTask(ATaskDataSrc: TDealDataSource; ATaskDealItemCode: integer): PDownloadTask;
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
    PostMessage(ADownloadTask.DownloadProcess.Core.AppCmdWnd, WM_Console2Downloader_Command_Download, ADownloadTask.DealItem.iCode, GetDealDataSourceCode(ADownloadTask.TaskDataSrc));
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
  if 0 <> ADownloadTask.TaskDealItemCode then
  begin                                       
    if nil = ADownloadTask.DealItem then
    begin
      ADownloadTask.DealItem := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.FindItem(IntToStr(ADownloadTask.TaskDealItemCode));
      Result := ADownloadTask.DealItem;
    end;
    if nil <> ADownloadTask.DealItem then
    begin
      if ADownloadTask.DealItem.iCode = ADownloadTask.TaskDealItemCode then
      begin
      end;
    end;   
    exit;
  end;
  
  if nil = ADownloadTask.DealItem then
  begin
    ADownloadTask.DealItemIndex := 0;
  end;
  if nil = ADownloadTask.DealItem  then
  begin
    Result := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[ADownloadTask.DealItemIndex];
    ADownloadTask.DealItem := Result;
  end else
  begin
    tmpDealItem := TBaseStockApp(fBaseAppAgentData.HostApp).StockItemDB.Items[ADownloadTask.DealItemIndex];
    if ADownloadTask.DealItem.iCode = tmpDealItem.iCode then
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
            ADownloadTask.DealItem := Result;
          end;
        end else
        begin
          Break;
        end;
      end;
    end;
  end;
end;

function TStockDataConsoleApp.Console_CheckDownloaderProcess(ADownloadTask: PDownloadTask): Boolean;
var
  i: integer;
  tmpRetCode: DWORD;
  tmpWindowName: AnsiString;
begin
  Result := false;
  if nil = ADownloadTask then
    exit;
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
    tmpWindowName := IntToStr(ADownloadTask.DownloadProcess.Core.ProcessId);
    for i := 0 to 100 do
    begin
      if IsWindow(ADownloadTask.DownloadProcess.Core.AppCmdWnd) then
        Break;                   
      Sleep(10);
      ADownloadTask.DownloadProcess.Core.AppCmdWnd := Windows.FindWindowA(AppCmdWndClassName_StockDataDownloader, PAnsiChar(tmpWindowName));
    end;
  end;
  Result := IsWindow(ADownloadTask.DownloadProcess.Core.AppCmdWnd);
end;

procedure TStockDataConsoleApp.Console_NotifyDownloaderShutdown(ADownloadTask: PDownloadTask);
begin
  if IsWindow(ADownloadTask.DownloadProcess.Core.AppCmdWnd) then
  begin
    PostMessage(ADownloadTask.DownloadProcess.Core.AppCmdWnd, WM_AppRequestEnd, 0, 0);
  end;
end;

end.
