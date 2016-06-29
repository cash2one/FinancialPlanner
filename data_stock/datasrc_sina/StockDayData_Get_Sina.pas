unit StockDayData_Get_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  win.iobuffer,
  define_price,
  define_dealitem,
  define_stockday_sina,
  StockDayDataAccess;
         
const
  BaseSinaDayUrl1 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/';
  BaseSinaDayUrl_weight = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/';
  (*//           
  // http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/600000.phtml
  // http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/600000.phtml
  // 上证指数
  // http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000001/type/S.phtml?year=2015&jidu=1
     深圳成分
     http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/399001/type/S.phtml
     沪深 300
     http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000300/type/S.phtml
  //*)
  
function GetStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  Windows,
  Define_DataSrc,    
  define_stock_quotes,
  UtilsDateTime,
  //StockDayData_Parse_Sina_Html1,
  //StockDayData_Parse_Sina_Html2,  
  StockDayData_Parse_Sina_Html3,  
  UtilsLog,
  StockDayData_Parse_Sina,
  StockDayData_Load,
  StockDayData_Save;

function DataGet_DayData_SinaNow(ADataAccess: TStockDayDataAccess; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean; overload;
var
  tmpurl: string;  
  tmpHttpData: PIOBuffer;        
begin          
  Result := false;
  if weightNone <> AWeightMode then
    tmpUrl := BaseSinaDayUrl_weight
  else
    tmpUrl := BaseSinaDayUrl1;
  tmpurl := tmpurl + ADataAccess.StockItem.sCode + '.phtml';
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession, SizeMode_512k);
  if nil <> tmpHttpData then
  begin
    try
      //Result := StockDayData_Parse_Sina_Html1.DataParse_DayData_Sina(ADataAccess, tmpHttpData);
      Result := StockDayData_Parse_Sina_Html3.DataParse_DayData_Sina(ADataAccess, tmpHttpData);      
    finally
      CheckInIOBuffer(tmpHttpData);
    end;
  end;    
  Sleep(100);
end;

function DataGet_DayData_Sina(ADataAccess: TStockDayDataAccess; AYear, ASeason: Word; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean; overload;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;
  tmpRepeat: Integer;    
begin
  Result := false;
  if weightNone <> AWeightMode then
  begin
    tmpUrl := BaseSinaDayUrl_weight;
    AWeightMode := weightBackward;
  end else
  begin
    tmpUrl := BaseSinaDayUrl1;
  end;
  tmpurl := tmpurl + ADataAccess.StockItem.sCode + '.phtml';
  if (0 <> AYear) and (0 < ASeason) then 
  begin
    tmpurl := tmpurl + '?year=' + inttostr(AYear);
    tmpUrl := tmpUrl + '&' + 'jidu=' + inttostr(ASeason);
  end;
  // parse html data
  tmpRepeat := 3;
  while tmpRepeat > 0 do
  begin
    tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession, SizeMode_512k);
    if nil <> tmpHttpData then
    begin
      try
        //Result := StockDayData_Parse_Sina_Html1.DataParse_DayData_Sina(ADataAccess, tmpHttpData);
        Result := StockDayData_Parse_Sina_Html3.DataParse_DayData_Sina(ADataAccess, tmpHttpData);        
      finally
        CheckInIOBuffer(tmpHttpData);
      end;
    end;
    if Result then
      Break;
    Dec(tmpRepeat);
    Sleep(500 * (3 - tmpRepeat));
  end;
end;

function GetStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean;
var
  tmpStockDataAccess: TStockDayDataAccess; 
  tmpLastDealDate: Word;
  tmpInt: integer; 
  tmpQuoteDay: PRT_Quote_M1_Day;
  tmpFromYear, tmpFromMonth, tmpFromDay: Word;   
  tmpCurrentYear, tmpCurrentMonth, tmpCurrentDay: Word; 
  tmpJidu: integer;
begin
  Result := false;
  if weightNone <> AWeightMode then
  begin
    AWeightMode := weightBackward;
  end;
  tmpStockDataAccess := TStockDayDataAccess.Create(AStockItem, DataSrc_Sina, AWeightMode);
  try                      
    tmpLastDealDate := Trunc(now());
    tmpInt := DayOfWeek(tmpLastDealDate);
    if 1 = tmpInt then
    begin
      tmpLastDealDate := tmpLastDealDate - 2;
    end else if 7 = tmpInt then
    begin
      tmpLastDealDate := tmpLastDealDate - 1;
    end else
    begin
      // 当天数据不下载
      tmpLastDealDate := tmpLastDealDate - 1;
    end;
                                               
    if CheckNeedLoadStockDayData(App, tmpStockDataAccess, tmpLastDealDate) then
    begin
    
    end else
      exit;
      
    if tmpStockDataAccess.StockItem.FirstDealDate < 1 then
      exit;
      
    DecodeDate(now, tmpCurrentYear, tmpCurrentMonth, tmpCurrentDay);
    if (0 < tmpStockDataAccess.LastDealDate) and (0 < tmpStockDataAccess.FirstDealDate) then
    begin
      DecodeDate(tmpStockDataAccess.LastDealDate, tmpFromYear, tmpFromMonth, tmpFromDay);
    end else
    begin
      if tmpStockDataAccess.StockItem.FirstDealDate > 0 then
      begin
        DecodeDate(tmpStockDataAccess.StockItem.FirstDealDate, tmpFromYear, tmpFromMonth, tmpFromDay);
      end else
      begin
      end;
    end;   
    if tmpFromYear < 1980 then
    begin
      if tmpStockDataAccess.StockItem.FirstDealDate = 0 then
      begin                 
        tmpFromYear := 2013;
        tmpFromYear := 1990;
        tmpFromMonth := 12;
      end;
    end;      
    tmpJidu := SeasonOfMonth(tmpFromMonth);
    while tmpFromYear < tmpCurrentYear do
    begin
      while tmpJidu < 5 do
      begin
        DataGet_DayData_Sina(tmpStockDataAccess, tmpFromYear, tmpJidu, AWeightMode, ANetSession);
        Inc(tmpJidu);
      end;
      Inc(tmpFromYear);
      tmpJidu := 1;
    end; 
    while tmpJidu < SeasonOfMonth(tmpCurrentMonth) do
    begin
      DataGet_DayData_Sina(tmpStockDataAccess, tmpCurrentYear, tmpJidu, AWeightMode, ANetSession);
      Inc(tmpJidu);
    end;
    DataGet_DayData_SinaNow(tmpStockDataAccess, AWeightMode, ANetSession);

    tmpStockDataAccess.Sort;
    SaveStockDayData(App, tmpStockDataAccess); 
    if 0 = AStockItem.FirstDealDate then
    begin
      if 0 < tmpStockDataAccess.RecordCount then
      begin
        tmpQuoteDay := tmpStockDataAccess.RecordItem[0];
        AStockItem.FirstDealDate := tmpQuoteDay.DealDate.Value;
        AStockItem.IsDataChange := 1;
      end;
    end;   
  finally
    tmpStockDataAccess.Free;
  end;
end;

end.
