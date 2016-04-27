unit StockIndexData_Get_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  win.iobuffer,
  define_dealitem,
  StockDayDataAccess;
         
type
  TDealDayDataHeadName_Sina = (
    headNone, // 0
    headDay, // 1 日期,
    headPrice_Open, // 7开盘价,
    headPrice_High, // 5最高价,
    headPrice_Close, // 4收盘价,
    headPrice_Low, // 6最低价,
    headDeal_Volume, // 12成交量,
    headDeal_Amount, // 13成交金额,
    headDeal_WeightFactor
    ); // 15流通市值);

  PRT_DealDayData_HeaderSina = ^TRT_DealDayData_HeaderSina;
  TRT_DealDayData_HeaderSina = record
    HeadNameIndex     : array[TDealDayDataHeadName_Sina] of SmallInt;
  end;

const
  DealDayDataHeadNames_Sina: array[TDealDayDataHeadName_Sina] of string = (
    '',
    '日期',
    '开盘价',
    '最高价',
    '收盘价',
    '最低价',
    '交易量(股)',
    '交易金额(元)',
    '复权因子'
  );
    
const
  BaseSinaDayUrl1 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/';
  BaseSinaDayUrl2 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/';
  (*//
  // 上证指数
  // http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000001/type/S.phtml?year=2015&jidu=1
     深圳成分
     http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/399001/type/S.phtml
     沪深 300
     http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000300/type/S.phtml
  //*)

var
  DateFormat_Sina: Sysutils.TFormatSettings;(*// =(
    CurrencyString: '';
    DateSeparator: '-';
    TimeSeparator: ':';
    ListSeparator: ';';
    ShortDateFormat : 'yyyy-mm-dd';
    LongDateFormat : 'yyyy-mm-dd';
  );//*)
             
function GetStockIndexData_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  Windows,
  define_price,         
  Define_DataSrc,    
  define_stock_quotes,
  UtilsHtmlParser,
  UtilsDateTime,
  UtilsLog,  
  StockDayData_Load,
  StockDayData_Save;

function GetStockIndexData_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean;
begin
  Result := false;
end;

initialization
  FillChar(DateFormat_Sina, SizeOf(DateFormat_Sina), 0);
  DateFormat_Sina.DateSeparator := '-';
  DateFormat_Sina.TimeSeparator := ':';
  DateFormat_Sina.ListSeparator := ';';
  DateFormat_Sina.ShortDateFormat := 'yyyy-mm-dd';
  DateFormat_Sina.LongDateFormat := 'yyyy-mm-dd';
                          
end.
