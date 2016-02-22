program StockInstant_Sina;

uses
  Windows,
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseFile in '..\..\..\devwintech\v0000\app_base\BaseFile.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BaseThread in '..\..\..\devwintech\v0000\app_base\BaseThread.pas',
  BaseRun in '..\..\..\devwintech\v0000\app_base\BaseRun.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
  xlTcpClient in '..\..\..\devwintech\v0000\win_net\xlTcpClient.pas',
  xlNetwork in '..\..\..\devwintech\v0000\win_net\xlNetwork.pas',
  xlClientSocket in '..\..\..\devwintech\v0000\win_net\xlClientSocket.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Indy in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Indy.pas',
  UtilsHttp_Socket in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Socket.pas',
  UtilsHtmlParser in '..\..\..\devwintech\v0000\win_utils\UtilsHtmlParser.pas',
  UtilsDateTime in '..\..\..\devwintech\v0000\win_utils\UtilsDateTime.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  define_stock_quotes_instant in '..\..\basedefine\define_stock_quotes_instant.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem_save in '..\..\dealitem\db_dealitem_save.pas',
  StockInstantDataAccess in '..\..\data_stock\StockInstantDataAccess.pas',
  StockInstantData_Get_Sina in '..\..\data_stock\datasrc_sina\StockInstantData_Get_Sina.pas',
  StockInstant_Get_Sina in 'StockInstant_Get_Sina.pas';

{$R *.res}

type
  TStockInstantSinaApp = class(TBaseStockApp)
  protected
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
  end;

{ TStockDay163App }

constructor TStockInstantSinaApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

procedure TStockInstantSinaApp.Run;
begin
  GetStockDataInstant_Sina_All(Self);
end;

var
  GlobalApp: TStockInstantSinaApp;
begin
  GlobalApp := TStockInstantSinaApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.