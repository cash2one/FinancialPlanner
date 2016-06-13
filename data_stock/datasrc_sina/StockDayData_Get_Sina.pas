unit StockDayData_Get_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  win.iobuffer,
  define_dealitem,
  define_stockday_sina,
  StockDayDataAccess;
         
const
  BaseSinaDayUrl1 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/';
  BaseSinaDayUrl2 = 'http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/';
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
  
function GetStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean;

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
  StockDayData_Parse_Sina,
  StockDayData_Load,
  StockDayData_Save;

type
  PParseRecord = ^TParseRecord;
  TParseRecord = record
     HtmlRoot: IHtmlElement; 
     IsInTable: Integer;   
     IsTableHeadReady: Boolean;  
     TableHeader: TRT_DealDayData_HeaderSina;
     DealDayData: TRT_Quote_M1_Day;
  end;
               
procedure ParseStockDealDataTableRow(ADataAccess: TStockDayDataAccess; AParseRecord: PParseRecord; ANode: IHtmlElement);
var
  i: integer;
  tmpChild: IHtmlElement;
  tmpHeadColName: TDealDayDataHeadName_Sina;
  tmpStr: string;
  tmpTDIndex: integer;
  tmpIsHead: Boolean;
begin              
  FillChar(AParseRecord.DealDayData, SizeOf(AParseRecord.DealDayData), 0);
  tmpTDIndex := -1;
  tmpIsHead := false;
  for i := 0 to ANode.ChildrenCount - 1 do
  begin
    tmpChild := ANode[i];
    if SameText(tmpChild.TagName, 'td') then
    begin
      inc (tmpTDIndex);
      // 处理 行数据
      tmpStr := trim(tmpChild.InnerText);
      if (not AParseRecord.IsTableHeadReady) then
      begin   
        for tmpHeadColName := Low(TDealDayDataHeadName_Sina) to High(TDealDayDataHeadName_Sina) do
        begin
          if SameText(tmpStr, DealDayDataHeadNames_Sina[tmpHeadColName]) or
                       (Pos(DealDayDataHeadNames_Sina[tmpHeadColName], tmpStr) > 0) then
          begin
            AParseRecord.TableHeader.HeadNameIndex[tmpHeadColName] := tmpTDIndex;
            tmpIsHead := true;
          end;
        end;
      end else
      begin            
        for tmpHeadColName := Low(TDealDayDataHeadName_Sina) to High(TDealDayDataHeadName_Sina) do
        begin           
          if AParseRecord.TableHeader.HeadNameIndex[tmpHeadColName] = tmpTDIndex then
          begin     
            ParseCellData(tmpHeadColName, @AParseRecord.DealDayData, tmpStr);
          end;
        end;
      end;
    end;
  end;
  if not AParseRecord.IsTableHeadReady then
  begin
    AParseRecord.IsTableHeadReady := tmpIsHead;
  end else
  begin
    AddDealDayData(ADataAccess, @AParseRecord.DealDayData);
  end;
end;
                         
function HtmlParse_DayData_Sina_Table(ADataAccess: TStockDayDataAccess; AParseRecord: PParseRecord; ANode: IHtmlElement): Boolean;
var
  i, j: integer;
  tmpNode1: IHtmlElement;
  tmpcnt1: integer;
  tmpcnt2: integer;
  tmpRow: integer;
  tmpTagName: string;
var
  tmpHeadColName: TDealDayDataHeadName_Sina;
begin
  Result := false;
  AParseRecord.IsTableHeadReady := false;    
  for tmpHeadColName := low(TDealDayDataHeadName_Sina) to high(TDealDayDataHeadName_Sina) do
  begin
    AParseRecord.TableHeader.HeadNameIndex[tmpHeadColName] := -1;
  end;       
  tmpcnt1 := ANode.ChildrenCount;
  tmpRow := 0;
  for i := 0 to tmpcnt1 - 1 do
  begin
    tmpTagName := lowercase(ANode[i].TagName);
    if SameText(tmpTagName, 'tr') then
    begin
      ParseStockDealDataTableRow(ADataAccess, AParseRecord, ANode[i]);
    end;
    if SameText(tmpTagName, 'tbody') then
    begin
      tmpNode1 := ANode[i];
      tmpcnt2 := tmpNode1.ChildrenCount;
      for j := 0 to tmpcnt2 - 1 do
      begin
        if SameText(tmpNode1[j].TagName, 'tr') then
        begin    
          ParseStockDealDataTableRow(ADataAccess, AParseRecord, ANode[i]);
        end;
      end;
      continue;
    end;
  end;
  if AParseRecord.IsTableHeadReady then
  begin
    Result := true;
  end;
end;

function HtmlParse_DayData_Sina(ADataAccess: TStockDayDataAccess; AParseRecord: PParseRecord; ANode: IHtmlElement): Boolean;
var
  i: integer;
  tmpcnt: integer;
  tmpData: WideString;
begin
  result := false;
  if ANode <> nil then
  begin
    if SameText(string(lowercase(ANode.TagName)), 'table') then
    begin           
      Inc(AParseRecord.IsInTable);
      tmpcnt := ANode.ChildrenCount;
      tmpData := ANode.Attributes['id'];
      if tmpData <> '' then
      begin
        if SameText('FundHoldSharesTable', tmpData) then
        begin
          result := HtmlParse_DayData_Sina_Table(ADataAccess, AParseRecord, ANode);
        end else
        begin
          if Pos('fundholdsharestable', lowercase(tmpData)) = 1 then
          begin
            result := HtmlParse_DayData_Sina_Table(ADataAccess, AParseRecord, ANode);
          end;
        end;
      end;
      Dec(AParseRecord.IsInTable);
    end else
    begin
      tmpcnt := ANode.ChildrenCount;
      for i := 0 to tmpcnt - 1 do
      begin
        if not result then
        begin
          result := HtmlParse_DayData_Sina(ADataAccess, AParseRecord, ANode[i]);
        end else
        begin
          HtmlParse_DayData_Sina(ADataAccess, AParseRecord, ANode[i]);
        end;
      end;
    end;
  end;
end;

function DataParse_DayData_Sina(ADataAccess: TStockDayDataAccess; AResultData: PIOBuffer): Boolean; overload;
var     
  tmpParseRec: TParseRecord;
  // 168k 的数据太大 不能这样设置
  tmpHttpHeadSession: THttpHeadParseSession;
begin
  Result := False;
  if nil = AResultData then
    exit;
  FillChar(tmpParseRec, SizeOf(tmpParseRec), 0);
  FIllChar(tmpHttpHeadSession, SizeOf(tmpHttpHeadSession), 0);
  
  HttpBufferHeader_Parser(AResultData, @tmpHttpHeadSession);
  if (199 < tmpHttpHeadSession.RetCode) and (300 > tmpHttpHeadSession.RetCode)then
  begin
    try
      tmpParseRec.HtmlRoot := UtilsHtmlParser.ParserHtml(AnsiString(PAnsiChar(@AResultData.Data[tmpHttpHeadSession.HeadEndPos + 1])));
    except
      Log('ParserSinaDataError:', ADataAccess.StockItem.sCode + 'error html');// + AnsiString(PAnsiChar(@AResultData.Data[tmpHttpHeadSession.HeadEndPos + 1])));
    end;
    if tmpParseRec.HtmlRoot <> nil then
    begin
      Result := HtmlParse_DayData_Sina(ADataAccess, @tmpParseRec, tmpParseRec.HtmlRoot);
    end;
  end;
end;

function DataGet_DayData_SinaNow(ADataAccess: TStockDayDataAccess; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean; overload;
var
  tmpurl: string;  
  tmpHttpData: PIOBuffer;        
begin          
  Result := false;
  if AIsWeight then
    tmpUrl := BaseSinaDayUrl2
  else
    tmpUrl := BaseSinaDayUrl1;
  tmpurl := tmpurl + ADataAccess.StockItem.sCode + '.phtml';
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession, SizeMode_512k);
  if nil <> tmpHttpData then
  begin
    try
      Result := DataParse_DayData_Sina(ADataAccess, tmpHttpData);
    finally
      CheckInIOBuffer(tmpHttpData);
    end;
  end;    
  Sleep(100);
end;

function DataGet_DayData_Sina(ADataAccess: TStockDayDataAccess; AYear, ASeason: Word; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean; overload;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;
  tmpRepeat: Integer;    
begin
  Result := false;
  if AIsWeight then
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
        Result := DataParse_DayData_Sina(ADataAccess, tmpHttpData);
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

function GetStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean;
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
  tmpStockDataAccess := TStockDayDataAccess.Create(AStockItem, DataSrc_Sina, AIsWeight);
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
        DataGet_DayData_Sina(tmpStockDataAccess, tmpFromYear, tmpJidu, AIsWeight, ANetSession);
        Inc(tmpJidu);
      end;
      Inc(tmpFromYear);
      tmpJidu := 1;
    end; 
    while tmpJidu < SeasonOfMonth(tmpCurrentMonth) do
    begin
      DataGet_DayData_Sina(tmpStockDataAccess, tmpCurrentYear, tmpJidu, AIsWeight, ANetSession);
      Inc(tmpJidu);
    end;
    DataGet_DayData_SinaNow(tmpStockDataAccess, AIsWeight, ANetSession);

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
