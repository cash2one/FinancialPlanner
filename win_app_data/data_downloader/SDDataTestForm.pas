unit SDDataTestForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, StdCtrls, Sysutils;

type
  TfrmSDDataTest = class(TfrmBase)
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
    btTestMem: TButton;
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
    procedure btTestMemClick(Sender: TObject);
  private
    { Private declarations }      
    function GetStockCode: integer;       
    procedure RequestDownloadStockData(AStockCode, ADataSrc: integer);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  windef_msg,
  win.shutdown,
  define_price,
  define_datasrc,
  define_dealitem,
  define_StockDataApp,
  UtilsHttp, 
  StockDayData_Get_Sina,
  BaseWinApp;

function TfrmSDDataTest.GetStockCode: integer;
begin
  Result := StrToIntDef(edtStockCode.Text, 0);
end;
                                     
procedure TfrmSDDataTest.RequestDownloadStockData(AStockCode, ADataSrc: integer);
begin
  if IsWindow(TBaseWinApp(App).AppWindow) then
  begin
    PostMessage(TBaseWinApp(App).AppWindow, WM_Console_Command_Download, AStockCode, ADataSrc);
  end;
end;
                    
procedure TfrmSDDataTest.btnDownloadAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, 0);
end;

procedure TfrmSDDataTest.btnDownload163AllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_163);
end;

procedure TfrmSDDataTest.btnDownload163Click(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_163);
end;

procedure TfrmSDDataTest.btnDownloadQQAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_QQ);
end;

procedure TfrmSDDataTest.btnDownloadQQClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_QQ);
end;

procedure TfrmSDDataTest.btnDownloadSinaAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_Sina);
end;

procedure TfrmSDDataTest.btnDownloadSinaClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_Sina);
end;

procedure TfrmSDDataTest.btnDownloadXueqiuAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_XQ);
end;

procedure TfrmSDDataTest.btnDownloadXueqiuClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_XQ);
end;

procedure TfrmSDDataTest.btnShutDownClick(Sender: TObject);
begin
  inherited;
  win.shutdown.ShutDown;
end;

procedure TfrmSDDataTest.btTestMemClick(Sender: TObject);
var
  tmpHttpClientSession: THttpClientSession;
  tmpStockItem: TRT_DealItem;
begin
  inherited;
//                
  FillChar(tmpHttpClientSession, SizeOf(tmpHttpClientSession), 0);
  FillChar(tmpStockItem, SizeOf(tmpStockItem), 0);

  tmpStockItem.iCode := 600016;
  tmpStockItem.sCode := '600016';
  GetStockDataDay_Sina(App, @tmpStockItem, weightBackward, @tmpHttpClientSession);
end;

end.
