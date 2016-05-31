program StockDetail_Sina;

uses
  Windows,
  Sysutils,
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  Base.Run in '..\..\..\devwintech\v0001\rec\app_base\Base.Run.pas',
  win.diskfile in '..\..\..\devwintech\v0001\rec\win_sys\win.diskfile.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
  xlNetwork in '..\..\..\devwintech\v0000\win_net\xlNetwork.pas',
  xlTcpClient in '..\..\..\devwintech\v0000\win_netclient\xlTcpClient.pas',
  xlClientSocket in '..\..\..\devwintech\v0000\win_netclient\xlClientSocket.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Indy in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Indy.pas',
  UtilsHttp_Socket in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Socket.pas',
  UtilsHtmlParser in '..\..\..\devwintech\v0000\win_utils\UtilsHtmlParser.pas',
  UtilsDateTime in '..\..\..\devwintech\v0000\win_utils\UtilsDateTime.pas',
  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem_save in '..\..\dealitem\db_dealitem_save.pas',
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  StockDayData_Save in '..\..\data_stock\StockDayData_Save.pas',
  StockDetailDataAccess in '..\..\data_stock\StockDetailDataAccess.pas',
  StockDetailData_Save in '..\..\data_stock\StockDetailData_Save.pas',
  StockDetailData_Load in '..\..\data_stock\StockDetailData_Load.pas',
  StockDetailData_Get_Sina in '..\..\data_stock\datasrc_sina\StockDetailData_Get_Sina.pas',
  StockDetail_Get_Sina in 'StockDetail_Get_Sina.pas';

{$R *.res}

type
  TStockDetailSinaApp = class(TBaseStockApp)
  protected                
    procedure Test1;
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
  end;

{ TStockDay163App }

constructor TStockDetailSinaApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;


procedure TStockDetailSinaApp.Test1;
var
  tmpDetailData: TStockDetailDataAccess;
  tmpStockItem: TRT_DealItem;
  tmpPath: string;
  tmpFileName: string;
begin
  FillChar(tmpStockItem, SizeOf(tmpStockItem), 0);
  tmpStockItem.sMarketCode := 'sh';
  tmpStockItem.sCode := '600000';
  tmpDetailData := TStockDetailDataAccess.Create(@tmpStockItem, DataSrc_Sina);
  try
    tmpPath := 'E:\StockApp\sdata\sdtsina\6000\600000\2016\';
    tmpFileName := '600000_20160215.sdt31';
    tmpDetailData.FirstDealDate := Trunc(EncodeDate(2016, 2, 15));
    tmpDetailData.LastDealDate := tmpDetailData.FirstDealDate;
    
    LoadStockDetailData(Self, tmpDetailData, tmpPath + tmpFileName);
    if 0 < tmpDetailData.RecordCount then
    begin
    end;
  finally
    tmpDetailData.Free;
  end;
end;

procedure TStockDetailSinaApp.Run;
begin
  //Test1;  
  GetStockDataDetail_Sina_All(Self);
end;

var
  GlobalApp: TStockDetailSinaApp;
begin
  GlobalApp := TStockDetailSinaApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.