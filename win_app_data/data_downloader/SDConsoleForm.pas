unit SDConsoleForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, StdCtrls, Sysutils,
  StockDataConsoleApp, ExtCtrls;

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
    procedure RequestDownloadStockData(AStockCode, ADataSrc: integer);
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  windef_msg,
  win.shutdown,
  define_datasrc,
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
                                     
procedure TfrmSDConsole.RequestDownloadStockData(AStockCode, ADataSrc: integer);
begin
  if IsWindow(TBaseWinApp(App).AppWindow) then
  begin
    PostMessage(TBaseWinApp(App).AppWindow, WM_Console_Command_Download, AStockCode, ADataSrc);
  end;
end;
                    
procedure TfrmSDConsole.tmrRefreshDownloadTaskTimer(Sender: TObject);
begin
  inherited;
  if nil <> fFormSDConsoleData.Download163AllTask then
  begin
    if nil <> fFormSDConsoleData.Download163AllTask.DealItem then
      lbStock163.Text := fFormSDConsoleData.Download163AllTask.DealItem.sCode;
  end;
  if nil <> fFormSDConsoleData.DownloadSinaAllTask then
  begin
    if nil <> fFormSDConsoleData.DownloadSinaAllTask.DealItem then
      lbStock163.Text := fFormSDConsoleData.DownloadSinaAllTask.DealItem.sCode;
  end;
  if nil <> fFormSDConsoleData.DownloadQQAllTask then
  begin
    lbStock163.Text := IntToStr(fFormSDConsoleData.DownloadQQAllTask.TaskDealItemCode);  
    if nil <> fFormSDConsoleData.DownloadQQAllTask.DealItem then
      lbStock163.Text := fFormSDConsoleData.DownloadQQAllTask.DealItem.sCode;
  end;
  if nil <> fFormSDConsoleData.DownloadXQAllTask then
  begin
    lbStock163.Text := IntToStr(fFormSDConsoleData.DownloadXQAllTask.TaskDealItemCode); 
    if nil <> fFormSDConsoleData.DownloadXQAllTask.DealItem then
      lbStock163.Text := fFormSDConsoleData.DownloadXQAllTask.DealItem.sCode;
  end;
end;
               
procedure TfrmSDConsole.btnDownload163Click(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_163);
end;
                      
procedure TfrmSDConsole.btnDownloadSinaClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_Sina);
end;
                    
procedure TfrmSDConsole.btnDownloadQQClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_QQ);  
end;

procedure TfrmSDConsole.btnDownloadXueqiuClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_XQ);
end;

procedure TfrmSDConsole.btnDownload163AllClick(Sender: TObject);
var
  i: integer;
begin
  RequestDownloadStockData(0, DataSrc_163);
  Application.ProcessMessages;
  for i := 0 to 100 do
  begin
    Application.ProcessMessages;
    Sleep(10);
    fFormSDConsoleData.Download163AllTask := TStockDataConsoleApp(App.AppAgent).GetDownloadTask(DataSrc_163, 0);
    if nil <> fFormSDConsoleData.Download163AllTask then
      Break;
  end;
  if nil <> fFormSDConsoleData.Download163AllTask then
  begin
    tmrRefreshDownloadTask.Enabled := True;
  end;
end;

procedure TfrmSDConsole.btnDownloadSinaAllClick(Sender: TObject); 
var
  i: integer;
begin
  RequestDownloadStockData(0, DataSrc_Sina);   
  Application.ProcessMessages; 
  for i := 0 to 100 do
  begin           
    Application.ProcessMessages;
    Sleep(10);
    fFormSDConsoleData.DownloadSinaAllTask := TStockDataConsoleApp(App).GetDownloadTask(DataSrc_Sina, 0);
    if nil <> fFormSDConsoleData.DownloadSinaAllTask then
      Break;
  end;       
  if nil <> fFormSDConsoleData.DownloadSinaAllTask then
  begin
    tmrRefreshDownloadTask.Enabled := True;
  end;
end;
           
procedure TfrmSDConsole.btnDownloadQQAllClick(Sender: TObject); 
var
  i: integer;
begin
  RequestDownloadStockData(0, DataSrc_QQ);   
  Application.ProcessMessages;
  for i := 0 to 100 do
  begin            
    Application.ProcessMessages;
    Sleep(10);
    fFormSDConsoleData.DownloadQQAllTask := TStockDataConsoleApp(App).GetDownloadTask(0, DataSrc_QQ);
    if nil <> fFormSDConsoleData.DownloadQQAllTask then
      Break;
  end;       
  if nil <> fFormSDConsoleData.DownloadQQAllTask then
  begin
    tmrRefreshDownloadTask.Enabled := True;
  end;
end;

procedure TfrmSDConsole.btnDownloadXueqiuAllClick(Sender: TObject);   
var
  i: integer;
begin
  RequestDownloadStockData(0, DataSrc_XQ); 
  Application.ProcessMessages; 
  for i := 0 to 100 do
  begin                 
    Application.ProcessMessages;
    Sleep(10);
    fFormSDConsoleData.DownloadXQAllTask := TStockDataConsoleApp(App).GetDownloadTask(0, DataSrc_XQ);
    if nil <> fFormSDConsoleData.DownloadXQAllTask then
      Break;
  end;       
  if nil <> fFormSDConsoleData.DownloadXQAllTask then
  begin
    tmrRefreshDownloadTask.Enabled := True;
  end;
end;
                
procedure TfrmSDConsole.btnDownloadAllClick(Sender: TObject);  
var
  i: integer;
begin
  RequestDownloadStockData(0, 0);  
  Application.ProcessMessages;
  for i := 0 to 100 do
  begin             
    Application.ProcessMessages;
    Sleep(10);                                                                            
    fFormSDConsoleData.Download163AllTask := TStockDataConsoleApp(App).GetDownloadTask(DataSrc_163, 0);
    fFormSDConsoleData.DownloadSinaAllTask := TStockDataConsoleApp(App).GetDownloadTask(DataSrc_Sina, 0);
    fFormSDConsoleData.DownloadQQAllTask := TStockDataConsoleApp(App).GetDownloadTask(DataSrc_QQ, 0);
    fFormSDConsoleData.DownloadXQAllTask := TStockDataConsoleApp(App).GetDownloadTask(DataSrc_XQ, 0);
  end;
  tmrRefreshDownloadTask.Enabled := True;
end;
           
procedure TfrmSDConsole.btnShutDownClick(Sender: TObject);
begin
  inherited;
  win.shutdown.ShutDown;
end;

end.
