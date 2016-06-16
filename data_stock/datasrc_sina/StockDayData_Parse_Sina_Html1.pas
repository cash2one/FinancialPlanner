unit StockDayData_Parse_Sina_Html1;

interface

uses
  win.iobuffer,      
  define_stockday_sina,
  define_stock_quotes,
  StockDayDataAccess;
  
  function DataParse_DayData_Sina(ADataAccess: TStockDayDataAccess; AResultData: PIOBuffer): Boolean; overload;

implementation

uses
  Sysutils,  
  StockDayData_Parse_Sina, 
  UtilsHttp,    
  UtilsLog,
  UtilsHtmlParser;
  
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
  tmpTableId: WideString;
  tmpIsHandledNode: Boolean;
begin
  result := false;
  if nil = ANode then
    exit;          
  tmpIsHandledNode := false;
  if SameText(string(lowercase(ANode.TagName)), 'table') then
  begin           
    Inc(AParseRecord.IsInTable);
    tmpcnt := ANode.ChildrenCount;
    tmpTableId := ANode.Attributes['id'];
    if '' <> tmpTableId then
    begin
      if SameText('FundHoldSharesTable', tmpTableId) then
      begin
        tmpIsHandledNode := true;
      end else
      begin
        if Pos('fundholdsharestable', lowercase(tmpTableId)) = 1 then
        begin
          tmpIsHandledNode := true;
        end;
      end;
    end;
  end;      
  if tmpIsHandledNode then
  begin
    result := HtmlParse_DayData_Sina_Table(ADataAccess, AParseRecord, ANode);
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
  if SameText(string(lowercase(ANode.TagName)), 'table') then
  begin
    Dec(AParseRecord.IsInTable);
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

end.
