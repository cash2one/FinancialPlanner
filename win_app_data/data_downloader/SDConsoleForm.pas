unit SDConsoleForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, StdCtrls, Sysutils;

type
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
    procedure btnDownload163Click(Sender: TObject);
    procedure btnDownloadSinaClick(Sender: TObject);
    procedure btnDownloadXueqiuClick(Sender: TObject);
    procedure btnDownload163AllClick(Sender: TObject);
    procedure btnDownloadSinaAllClick(Sender: TObject);
    procedure btnDownloadXueqiuAllClick(Sender: TObject);
    procedure btnDownloadQQClick(Sender: TObject);
    procedure btnDownloadQQAllClick(Sender: TObject);
    procedure btnDownloadAllClick(Sender: TObject);
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
  define_datasrc,
  define_StockDataApp,
  BaseWinApp;

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
                    
procedure TfrmSDConsole.btnDownloadAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, 0);
end;

procedure TfrmSDConsole.btnDownload163AllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_163);
end;

procedure TfrmSDConsole.btnDownload163Click(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_163);
end;

procedure TfrmSDConsole.btnDownloadQQAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_QQ);
end;

procedure TfrmSDConsole.btnDownloadQQClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_QQ);
end;

procedure TfrmSDConsole.btnDownloadSinaAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_Sina);
end;

procedure TfrmSDConsole.btnDownloadSinaClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_Sina);
end;

procedure TfrmSDConsole.btnDownloadXueqiuAllClick(Sender: TObject);
begin
  RequestDownloadStockData(0, DataSrc_XQ);
end;

procedure TfrmSDConsole.btnDownloadXueqiuClick(Sender: TObject);
begin
  RequestDownloadStockData(GetStockCode, DataSrc_XQ);
end;

end.
