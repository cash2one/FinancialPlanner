unit StockDayData_Repair_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,    
  define_price,        
  define_dealitem,
  define_stockday_sina,
  StockDayDataAccess;
         
type
  PRepairSession = ^TRepairSession;
  TRepairSession = record
    NetSession: THttpClientSession;   
    StockDataSina: TStockDayDataAccess;
    StockData163: TStockDayDataAccess;
  end;
  
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

  function RepairStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode; ARepairSession: PRepairSession): Boolean;
  function DataGet_DayData_Sina(ADataAccess: TStockDayDataAccess; AYear, ASeason: Word; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean; overload;
  function DataGet_DayData_SinaNow(ADataAccess: TStockDayDataAccess; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean; overload;
  
implementation

uses
  Classes,
  Windows, 
  Define_DataSrc,    
  define_stock_quotes,  
  UtilsDateTime,
  UtilsLog,        
  win.iobuffer,
  //StockDayData_Parse_Sina_Html1,
  //StockDayData_Parse_Sina_Html2,
  StockDayData_Parse_Sina_Html3,
  StockDayData_Load,
  StockDayData_Save;

function DataGet_DayData_SinaNow(ADataAccess: TStockDayDataAccess; AWeightMode: TWeightMode; ANetSession: PHttpClientSession): Boolean; overload;
var
  tmpurl: string;  
  tmpHttpData: PIOBuffer;        
begin          
  Result := false;
  if weightNone <> AWeightMode then
    tmpUrl := BaseSinaDayUrl2
  else
    tmpUrl := BaseSinaDayUrl1;
  tmpurl := tmpurl + ADataAccess.StockItem.sCode + '.phtml';
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession, SizeMode_512k);
  if nil <> tmpHttpData then
  begin
    try
      //Result := StockDayData_Parse_Sina_Html2.DataParse_DayData_Sina(ADataAccess, tmpHttpData);
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
    tmpUrl := BaseSinaDayUrl2
  else
    tmpUrl := BaseSinaDayUrl1;
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
        //Result := StockDayData_Parse_Sina_Html2.DataParse_DayData_Sina(ADataAccess, tmpHttpData);
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

function RepairStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode; ARepairSession: PRepairSession): Boolean;
var 
  tmpYear, tmpMonth, tmpDay: Word;   
  tmpJidu: integer;
  
  tmpUpdateTimes: TStringList;   
  tmpStockData_163: PRT_Quote_Day;
  tmpStockData_Sina: PRT_Quote_Day;
  tmpIdx163: integer;
  tmpIdxSina: integer;
  tmpSeason: string;
  i: integer;
begin
  Result := false;
  if nil = ARepairSession.StockDataSina then
    ARepairSession.StockDataSina := TStockDayDataAccess.Create(AStockItem, DataSrc_Sina, AWeightMode);
  if nil = ARepairSession.StockData163 then
    ARepairSession.StockData163 := TStockDayDataAccess.Create(AStockItem, DataSrc_163, weightNone);
  tmpUpdateTimes := TStringList.Create;
  try
    if 1 > ARepairSession.StockData163.RecordCount then
    begin
      StockDayData_Load.LoadStockDayData(App, ARepairSession.StockData163);     
      ARepairSession.StockData163.Sort;
    end;            
    if 1 > ARepairSession.StockData163.RecordCount then
      exit;

    if 1 > ARepairSession.StockDataSina.RecordCount then
    begin
      StockDayData_Load.LoadStockDayData(App, ARepairSession.StockDataSina);   
      ARepairSession.StockDataSina.Sort;
    end;
    if ARepairSession.StockData163.RecordCount <= ARepairSession.StockDataSina.RecordCount then
      exit;
    tmpIdx163 := 0;
    tmpIdxSina := 0;
    while (tmpIdx163 < ARepairSession.StockData163.RecordCount) and
          (tmpIdxSina < ARepairSession.StockDataSina.RecordCount) do
    begin
      tmpStockData_163 := ARepairSession.StockData163.RecordItem[tmpIdx163];
      tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[tmpIdxSina];
      if tmpStockData_163.DealDate.Value = tmpStockData_Sina.DealDate.Value then
      begin
        Inc(tmpIdx163);
        Inc(tmpIdxSina);
      end else
      begin
        if tmpStockData_163.DealDate.Value > tmpStockData_Sina.DealDate.Value then
        begin
          // 这个是完完全全的错误啊 怎么出现的 ???
          // 2014-06-16 解析成 2014-06-1 漏了个日期字符 ??? 搞什么
          // html 解析器的问题 :(      
          DecodeDate(tmpStockData_Sina.DealDate.Value, tmpYear, tmpMonth, tmpDay);
          if 0 <> tmpMonth then
          begin
          end;
          Inc(tmpIdxSina);
        end else
        begin
          // sina 漏了数据了
          DecodeDate(tmpStockData_163.DealDate.Value, tmpYear, tmpMonth, tmpDay);
          tmpJidu := SeasonOfMonth(tmpMonth);
          if 1988 < tmpYear then
          begin
            tmpSeason := IntToStr(tmpYear) + '_' + IntToStr(tmpJidu);
            if tmpUpdateTimes.IndexOf(tmpSeason) < 0 then
            begin
              tmpUpdateTimes.Add(tmpSeason);
            end;
          end;
          Inc(tmpIdx163);
        end;
      end;
    end;
    if 0 < tmpUpdateTimes.Count then
    begin
      Log('Repair', AStockItem.sCode + ':' + IntToStr(tmpUpdateTimes.Count));
      for i := 0 to tmpUpdateTimes.Count - 1 do
      begin
        tmpSeason := tmpUpdateTimes[i];
        tmpYear := StrToIntDef(Copy(tmpSeason, 1, 4), 0);
        tmpJidu := StrToIntDef(Copy(tmpSeason, 6, maxint), 0);
        DataGet_DayData_Sina(ARepairSession.StockDataSina, tmpYear, tmpJidu, AWeightMode, @ARepairSession.NetSession);
        Sleep(500);
      end;
      ARepairSession.StockDataSina.Sort;
      SaveStockDayData(App, ARepairSession.StockDataSina);
      Result := True;
    end;
    if 0 = AStockItem.FirstDealDate then
    begin
      if 0 < ARepairSession.StockDataSina.RecordCount then
      begin
        tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[0];
        AStockItem.FirstDealDate := tmpStockData_Sina.DealDate.Value;
        AStockItem.IsDataChange := 1;
      end;
    end;   
  finally
    tmpUpdateTimes.Free;
  end;
end;
    
end.
