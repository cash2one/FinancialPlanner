unit FuturesData_Get_Sina;

interface

uses
  BaseApp;

  procedure GetFuturesData_Sina_All(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,    
  define_futures_quotes,
     
  UtilsDateTime,
  
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;

const            
  BaseSinaFuturesInstantDataUrl = 'http://hq.sinajs.cn/list=';  //http://hq.sinajs.cn/list=CFF_RE_IF1603
  BaseSinaFuturesData5MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine5m?symbol='; // IF1603
  BaseSinaFuturesData15MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine15m?symbol=';// IF1606
  BaseSinaFuturesData30MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine30m?symbol=';// IF1606  
  BaseSinaFuturesData60MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine60m?symbol=';// IF1606
  BaseSinaFuturesDayUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesDailyKLine?symbol=';//IF1606

var
  DateFormat_Sina: Sysutils.TFormatSettings;(*// =(
    CurrencyString: '';
    DateSeparator: '-';
    TimeSeparator: ':';
    ListSeparator: ';';
    ShortDateFormat : 'yyyy-mm-dd';
    LongDateFormat : 'yyyy-mm-dd';
  );//*)
                    
procedure GetFuturesData_Sina_All(App: TBaseApp);
var
  tmpDBStockItem: TDBStockItem;
  i: integer;
begin
  tmpDBStockItem := TDBStockItem.Create;
  try
    LoadDBStockItem(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin
        begin
          Sleep(2000);
        end;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

initialization
  FillChar(DateFormat_Sina, SizeOf(DateFormat_Sina), 0);
  DateFormat_Sina.DateSeparator := '-';
  DateFormat_Sina.TimeSeparator := ':';
  DateFormat_Sina.ListSeparator := ';';
  DateFormat_Sina.ShortDateFormat := 'yyyy-mm-dd';
  DateFormat_Sina.LongDateFormat := 'yyyy-mm-dd';

end.
