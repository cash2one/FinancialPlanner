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
    headDay, // 1 ����,
    headPrice_Open, // 7���̼�,
    headPrice_High, // 5��߼�,
    headPrice_Close, // 4���̼�,
    headPrice_Low, // 6��ͼ�,
    headDeal_Volume, // 12�ɽ���,
    headDeal_Amount, // 13�ɽ����,
    headDeal_WeightFactor
    ); // 15��ͨ��ֵ);

  PRT_DealDayData_HeaderSina = ^TRT_DealDayData_HeaderSina;
  TRT_DealDayData_HeaderSina = record
    HeadNameIndex     : array[TDealDayDataHeadName_Sina] of SmallInt;
  end;

const
  DealDayDataHeadNames_Sina: array[TDealDayDataHeadName_Sina] of string = (
    '',
    '����',
    '���̼�',
    '��߼�',
    '���̼�',
    '��ͼ�',
    '������(��)',
    '���׽��(Ԫ)',
    '��Ȩ����'
  );
    
const
  BaseSinaDayUrl1 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/';
  BaseSinaDayUrl2 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/';
  (*//
  // ��ָ֤��
  // http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000001/type/S.phtml?year=2015&jidu=1
     ���ڳɷ�
     http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/399001/type/S.phtml
     ���� 300
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
