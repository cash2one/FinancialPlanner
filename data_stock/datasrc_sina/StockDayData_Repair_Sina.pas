unit StockDayData_Repair_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  win.iobuffer,
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

function RepairStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ARepairSession: PRepairSession): Boolean;

implementation

uses
  Classes,
  Windows,
  define_price,         
  Define_DataSrc,    
  define_stock_quotes,
  UtilsHtmlParser,
  DIHtmlParser,
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

function RepairStockDataDay_Sina(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ARepairSession: PRepairSession): Boolean;
var 
  tmpYear, tmpMonth, tmpDay: Word;   
  tmpJidu: integer;
  
  tmpUpdateTimes: TStringList;   
  tmpStockData_163: PRT_Quote_M1_Day;   
  tmpStockData_Sina: PRT_Quote_M1_Day;
  tmpIdx163, tmpIdxSina: integer;
  tmpSeason: string;
  i: integer;
begin
  Result := false;
  if nil = ARepairSession.StockDataSina then
    ARepairSession.StockDataSina := TStockDayDataAccess.Create(AStockItem, DataSrc_Sina, AIsWeight);
  if nil = ARepairSession.StockData163 then
    ARepairSession.StockData163 := TStockDayDataAccess.Create(AStockItem, DataSrc_163, false);
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
        DataGet_DayData_Sina(ARepairSession.StockDataSina, tmpYear, tmpJidu, AIsWeight, @ARepairSession.NetSession);
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
