unit SDConsoleForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, StdCtrls, Sysutils,
  StockDataConsoleApp, ExtCtrls,
  define_datasrc;

type
  TFormSDConsoleData = record
    Download163AllTask: PDownloadTask;
    DownloadSinaAllTask: PDownloadTask;
    DownloadQQAllTask: PDownloadTask;
    DownloadXQAllTask: PDownloadTask;
  end;

  TfrmSDConsole = class(TfrmBase)
    btnDownload163: TButton;
    btnDownloadSina: TButton;
    edtStockCode: TEdit;
    btnImportTDX: TButton;
    lbl1: TLabel;
    btnDownload163All: TButton;
    btnDownloadSinaAll: TButton;
    btnDownloadAll: TButton;
    btnDownloadXueqiu: TButton;
    btnDownloadXueqiuAll: TButton;
    btnDownloadQQ: TButton;
    btnDownloadQQAll: TButton;
    lbStock163: TEdit;
    lbStockSina: TEdit;
    lbStockXQ: TEdit;
    lbStockQQ: TEdit;
    btnShutDown: TButton;
    tmrRefreshDownloadTask: TTimer;
    chkShutDown: TCheckBox;
    procedure btnDownload163Click(Sender: TObject);
    procedure btnDownloadSinaClick(Sender: TObject);
    procedure btnDownloadXueqiuClick(Sender: TObject);
    procedure btnDownload163AllClick(Sender: TObject);
    procedure btnDownloadSinaAllClick(Sender: TObject);
    procedure btnDownloadXueqiuAllClick(Sender: TObject);
    procedure btnDownloadQQClick(Sender: TObject);
    procedure btnDownloadQQAllClick(Sender: TObject);
    procedure btnDownloadAllClick(Sender: TObject);
    procedure btnShutDownClick(Sender: TObject);
    procedure tmrRefreshDownloadTaskTimer(Sender: TObject);
  private
    { Private declarations }
    fFormSDConsoleData: TFormSDConsoleData;
    function GetStockCode: integer;     
    function NewDownloadAllTask(ADataSrc: TDealDataSource; ADownloadTask: PDownloadTask): PDownloadTask;
    procedure RequestDownloadStockData(ADataSrc: TDealDataSource; AStockCode: integer);
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  windef_msg,
  win.shutdown,
  define_StockDataApp,
  BaseWinApp;
              
constructor TfrmSDConsole.Create(Owner: TComponent);
begin
  inherited;
  FillChar(fFormSDConsoleData, SizeOf(fFormSDConsoleData), 0);
end;

function TfrmSDConsole.GetStockCode: integer;
begin
  Result := StrToIntDef(edtStockCode.Text, 0);
end;
                                     
procedure TfrmSDConsole.RequestDownloadStockData(ADataSrc: TDealDataSource; AStockCode: integer);
begin
  if IsWindow(TBaseWinApp(App).AppWindow) then
  begin
    PostMessage(TBaseWinApp(App).AppWindow, WM_Console_Command_Download, AStockCode, GetDealDataSourceCode(ADataSrc))
  end;
end;
                    
procedure TfrmSDConsole.tmrRefreshDownloadTaskTimer(Sender: TObject);

  function CheckTask(ADownloadTask: PDownloadTask; AStockCodeDisplay: TEdit): integer;
  var
    exitcode_process: DWORD;
    tick_gap: DWORD;
  begin
    Result := 0;
    if nil = ADownloadTask then
      exit;
    Result := 1;
    if nil <> ADownloadTask.DealItem then
      AStockCodeDisplay.Text := ADownloadTask.DealItem.sCode;
    if TaskStatus_End = ADownloadTask.TaskStatus then
    begin
      Result := 0;
    end else
    begin
      Windows.GetExitCodeProcess(ADownloadTask.DownloadProcess.Core.ProcessHandle, exitcode_process);
      if Windows.STILL_ACTIVE <> exitcode_process then
      begin
        ADownloadTask.DownloadProcess.Core.ProcessHandle := 0;
        ADownloadTask.DownloadProcess.Core.ProcessId := 0;
        ADownloadTask.DownloadProcess.Core.AppCmdWnd := 0;   
        ADownloadTask.DealItem := TStockDataConsoleApp(App.AppAgent).Console_GetNextDownloadDealItem(ADownloadTask);
        RequestDownloadStockData(ADownloadTask.TaskDataSrc, ADownloadTask.TaskDealItemCode);
      end else
      begin        
        if ADownloadTask.MonitorDealItem <> ADownloadTask.DealItem then
        begin
          ADownloadTask.MonitorDealItem := ADownloadTask.DealItem;
          ADownloadTask.MonitorTick := GetTickCount;
        end else
        begin
          tick_gap := GetTickCount - ADownloadTask.MonitorTick;
          if tick_gap > 10000 then
          begin
            TerminateProcess(ADownloadTask.DownloadProcess.Core.ProcessHandle, 0);  
            ADownloadTask.DownloadProcess.Core.ProcessHandle := 0;
            ADownloadTask.DownloadProcess.Core.ProcessId := 0;
            ADownloadTask.DownloadProcess.Core.AppCmdWnd := 0;
          end;
        end;
      end;
    end;
  end;
  
var
  tmpActiveCount: integer;
begin
  inherited;
  tmpActiveCount := CheckTask(fFormSDConsoleData.Download163AllTask, lbStock163);
  tmpActiveCount := tmpActiveCount + CheckTask(fFormSDConsoleData.DownloadSinaAllTask, lbStockSina);
  tmpActiveCount := tmpActiveCount + CheckTask(fFormSDConsoleData.DownloadQQAllTask, lbStockQQ);
  tmpActiveCount := tmpActiveCount + CheckTask(fFormSDConsoleData.DownloadXQAllTask, lbStockXQ);
  if 0 = tmpActiveCount then
  begin
    if chkShutDown.Checked then
      win.shutdown.ShutDown;
  end;
end;
               
procedure TfrmSDConsole.btnDownload163Click(Sender: TObject);
begin
  RequestDownloadStockData(src_163, GetStockCode);
end;
                      
procedure TfrmSDConsole.btnDownloadSinaClick(Sender: TObject);
begin
  RequestDownloadStockData(Src_Sina, GetStockCode);
end;
                    
procedure TfrmSDConsole.btnDownloadQQClick(Sender: TObject);
begin
  RequestDownloadStockData(Src_QQ, GetStockCode);  
end;

procedure TfrmSDConsole.btnDownloadXueqiuClick(Sender: TObject);
begin
  RequestDownloadStockData(Src_XQ, GetStockCode);
end;

function TfrmSDConsole.NewDownloadAllTask(ADataSrc: TDealDataSource; ADownloadTask: PDownloadTask): PDownloadTask;
begin
  Result := ADownloadTask;
  if nil = Result then
  begin
    Result := TStockDataConsoleApp(App.AppAgent).GetDownloadTask(ADataSrc, 0);
    if nil = Result then
    begin
      Result := TStockDataConsoleApp(App.AppAgent).NewDownloadTask(ADataSrc, 0);
    end;
    RequestDownloadStockData(ADataSrc, 0);
  end;
  if not tmrRefreshDownloadTask.Enabled then
    tmrRefreshDownloadTask.Enabled := True;
end;

procedure TfrmSDConsole.btnDownload163AllClick(Sender: TObject);
begin
  fFormSDConsoleData.Download163AllTask := NewDownloadAllTask(src_163, fFormSDConsoleData.Download163AllTask);
end;

procedure TfrmSDConsole.btnDownloadSinaAllClick(Sender: TObject); 
begin                     
  fFormSDConsoleData.DownloadSinaAllTask := NewDownloadAllTask(src_sina, fFormSDConsoleData.DownloadSinaAllTask);
end;
           
procedure TfrmSDConsole.btnDownloadQQAllClick(Sender: TObject);
begin       
  fFormSDConsoleData.DownloadQQAllTask := NewDownloadAllTask(src_QQ, fFormSDConsoleData.DownloadQQAllTask);
end;

procedure TfrmSDConsole.btnDownloadXueqiuAllClick(Sender: TObject);   
begin                 
  fFormSDConsoleData.DownloadXQAllTask := NewDownloadAllTask(Src_XQ, fFormSDConsoleData.DownloadXQAllTask);
end;
                
procedure TfrmSDConsole.btnDownloadAllClick(Sender: TObject);  
var
  i: integer;
begin
  RequestDownloadStockData(Src_All, 0);  
  Application.ProcessMessages;
  for i := 0 to 100 do
  begin             
    Application.ProcessMessages;
    Sleep(10);                                                                            
    fFormSDConsoleData.Download163AllTask := TStockDataConsoleApp(App).GetDownloadTask(Src_163, 0);
    fFormSDConsoleData.DownloadSinaAllTask := TStockDataConsoleApp(App).GetDownloadTask(Src_Sina, 0);
    fFormSDConsoleData.DownloadQQAllTask := TStockDataConsoleApp(App).GetDownloadTask(Src_QQ, 0);
    fFormSDConsoleData.DownloadXQAllTask := TStockDataConsoleApp(App).GetDownloadTask(Src_XQ, 0);
  end;
  tmrRefreshDownloadTask.Enabled := True;
end;
           
procedure TfrmSDConsole.btnShutDownClick(Sender: TObject);
begin
  inherited;
  win.shutdown.ShutDown;
end;

end.
