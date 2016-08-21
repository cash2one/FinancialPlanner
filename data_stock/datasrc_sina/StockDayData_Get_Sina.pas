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
  
function GetStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode; ANetSession: PHttpClientSession; AHttpData: PIOBuffer): Boolean;        
function DataGet_DayData_SinaNow(ADataAccess: TStockDayDataAccess; ANetSession: PHttpClientSession; AHttpData: PIOBuffer): Boolean; overload;

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
  QuickList_Int,  
  UtilsLog,
  StockDayData_Parse_Sina,
  StockDayData_Load,
  StockDayData_Save;

function DataGet_DayData_SinaNow(ADataAccess: TStockDayDataAccess; ANetSession: PHttpClientSession; AHttpData: PIOBuffer): Boolean; overload;
var
  tmpurl: string;  
  tmpHttpData: PIOBuffer;
  tmpDayDatas: TALIntegerList;
  i: integer; 
begin          
  Result := false;
  if weightNone <> ADataAccess.WeightMode then
    tmpUrl := BaseSinaDayUrl_weight
  else
    tmpUrl := BaseSinaDayUrl1;
  tmpurl := tmpurl + ADataAccess.StockItem.sCode + '.phtml';
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession, AHttpData, SizeMode_512k);
  if nil <> tmpHttpData then
  begin
    try
      //Result := StockDayData_Parse_Sina_Html1.DataParse_DayData_Sina(ADataAccess, tmpHttpData);
      //Result := StockDayData_Parse_Sina_Html2.DataParse_DayData_Sina(ADataAccess, tmpHttpData);      
      tmpDayDatas := StockDayData_Parse_Sina_Html3.DataParse_DayData_Sina(tmpHttpData);
      if nil <> tmpDayDatas then
      begin
        try
          if 0 < tmpDayDatas.Count then
          begin
            for i := 0 to tmpDayDatas.Count - 1 do
            begin
              AddDealDayData(ADataAccess, PRT_Quote_Day(tmpDayDatas.Items[i]));
              Result := True;
            end;
          end;
          for i := tmpDayDatas.Count - 1 downto 0 do
          begin
            FreeMem(PRT_Quote_Day(tmpDayDatas.Items[i]));
          end;
          tmpDayDatas.Clear;
        finally
          tmpDayDatas.Free;
        end;
      end;
    finally
      if AHttpData <> tmpHttpData then
      begin
        CheckInIOBuffer(tmpHttpData);
      end;
    end;
  end;    
  Sleep(100);
end;

function DataGet_DayData_Sina(ADataAccess: TStockDayDataAccess; AYear, ASeason: Word; ANetSession: PHttpClientSession; AHttpData: PIOBuffer): Boolean; overload;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;
  tmpRepeat: Integer;  
  tmpDayDatas: TALIntegerList;   
  i: integer; 
begin
  Result := false;
  if weightNone <> ADataAccess.WeightMode then
  begin
    tmpUrl := BaseSinaDayUrl_weight;
    ADataAccess.WeightMode := weightBackward;
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
    tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession, AHttpData, SizeMode_512k);
    if nil <> tmpHttpData then
    begin
      try
        //Result := StockDayData_Parse_Sina_Html1.DataParse_DayData_Sina(ADataAccess, tmpHttpData);
        //Result := StockDayData_Parse_Sina_Html2.DataParse_DayData_Sina(ADataAccess, tmpHttpData);        
        tmpDayDatas := StockDayData_Parse_Sina_Html3.DataParse_DayData_Sina(tmpHttpData);
        if nil <> tmpDayDatas then
        begin
          try
            if 0 < tmpDayDatas.Count then
            begin
              for i := 0 to tmpDayDatas.Count - 1 do
              begin
                AddDealDayData(ADataAccess, PRT_Quote_Day(tmpDayDatas.Items[i]));
                Result := True;
              end;
            end; 
            for i := tmpDayDatas.Count - 1 downto 0 do
            begin
              FreeMem(PRT_Quote_Day(tmpDayDatas.Items[i]));
            end;
            tmpDayDatas.Clear;
          finally
            tmpDayDatas.Free;
          end;
        end;
      finally
        if AHttpData <> tmpHttpData then
        begin
          CheckInIOBuffer(tmpHttpData);
        end;
      end;
    end;
    if Result then
      Break;
    Dec(tmpRepeat);
    Sleep(500 * (3 - tmpRepeat));
  end;
end;

function GetStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode; ANetSession: PHttpClientSession; AHttpData: PIOBuffer): Boolean;
var
  tmpStockDataAccess: TStockDayDataAccess; 
  tmpLastDealDate: Word;
  tmpInt: integer; 
  tmpQuoteDay: PRT_Quote_Day;
  tmpFromYear: Word;   
  tmpFromMonth: Word;
  tmpFromDay: Word;
  tmpCurrentYear: Word; 
  tmpCurrentMonth: Word;
  tmpCurrentDay: Word;
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

    (*//
    // 先以 163 必须 获取到数据为前提 ???
    if AStockItem.FirstDealDate < 1 then
    begin
      exit;
    end;
    //*)

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
        DataGet_DayData_Sina(tmpStockDataAccess, tmpFromYear, tmpJidu, ANetSession, AHttpData);
        Inc(tmpJidu);
      end;
      Inc(tmpFromYear);
      tmpJidu := 1;
    end; 
    while tmpJidu < SeasonOfMonth(tmpCurrentMonth) do
    begin
      DataGet_DayData_Sina(tmpStockDataAccess, tmpCurrentYear, tmpJidu, ANetSession, AHttpData);
      Inc(tmpJidu);
    end;
    DataGet_DayData_SinaNow(tmpStockDataAccess, ANetSession, AHttpData);

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
