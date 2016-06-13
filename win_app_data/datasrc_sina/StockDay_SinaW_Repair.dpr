program StockDay_SinaW_Repair;

uses
  Windows,
  DIHtmlParser in '..\..\..\devdcomps\htmlparser\dihtml\DIHtmlParser.pas',
  HTMLParser in '..\..\..\devdcomps\htmlparser\htmlp\HTMLParser.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  Base.Run in '..\..\..\devwintech\v0001\rec\app_base\Base.Run.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  xlNetwork in '..\..\..\devwintech\v0000\win_net\xlNetwork.pas',
  xlTcpClient in '..\..\..\devwintech\v0000\win_netclient\xlTcpClient.pas',
  xlClientSocket in '..\..\..\devwintech\v0000\win_netclient\xlClientSocket.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHtmlParser in '..\..\..\devwintech\v0000\win_utils\UtilsHtmlParser.pas',
  UtilsHttp_Socket in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Socket.pas',
  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  UtilsDateTime in '..\..\..\devwintech\v0000\win_utils\UtilsDateTime.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
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
  StockDayData_Repair_Sina in '..\..\data_stock\datasrc_sina\StockDayData_Repair_Sina.pas',
  StockDayData_Parse_Sina in '..\..\data_stock\datasrc_sina\StockDayData_Parse_Sina.pas',
  StockDayData_Parse_Sina_Html1 in '..\..\data_stock\datasrc_sina\StockDayData_Parse_Sina_Html1.pas', 
  StockDayData_Parse_Sina_Html2 in '..\..\data_stock\datasrc_sina\StockDayData_Parse_Sina_Html2.pas',
  StockDay_Repair_Sina in 'StockDay_Repair_Sina.pas',
  define_stockday_sina in 'define_stockday_sina.pas';

{$R *.res}

type
  TStockDaySinaApp = class(TBaseStockApp)
  protected
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
  end;

{ TStockDay163App }

constructor TStockDaySinaApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

procedure TStockDaySinaApp.Run;
begin
  RepairStockDataDay_Sina_All(Self, true);
end;

var
  GlobalApp: TStockDaySinaApp;
begin
  GlobalApp := TStockDaySinaApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.