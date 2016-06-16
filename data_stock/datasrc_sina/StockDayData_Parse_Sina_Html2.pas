unit StockDayData_Parse_Sina_Html2;

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
  DomCore,
  HtmlParser;
  
type
  PParseRecord = ^TParseRecord;
  TParseRecord = record
     HtmlParser: THtmlParser;
     HtmlDoc: TDocument; 
     IsInTable: Integer;   
     IsTableHeadReady: Boolean;  
     TableHeader: TRT_DealDayData_HeaderSina;
     DealDayData: TRT_Quote_M1_Day;
  end;

function GetNodeText(ANode: TNode): WideString;
var
  i: integer;
  tmpNode: TNode;
begin
  Result := '';
  if nil = ANode then
    exit;
  if nil = ANode.childNodes then
    Exit;
  for i := 0 to ANode.childNodes.length - 1 do
  begin
    tmpNode := ANode.childNodes.item(i);
    if ELEMENT_NODE = tmpNode.nodetype then
    begin
      if 1 = ANode.childNodes.length then
      begin
        Result := GetNodeText(ANode.childNodes.item(0));
      end;
    end;
    if TEXT_NODE = tmpNode.nodetype then
    begin
      Result := tmpNode.nodeValue;   
    end;
  end;
end;

procedure ParseStockDealDataTableRow(ADataAccess: TStockDayDataAccess; AParseRecord: PParseRecord; ANode: TNode);
var
  i: integer;
  tmpChild: TNode;
  tmpHeadColName: TDealDayDataHeadName_Sina;
  tmpStr: string;
  tmpTDIndex: integer;
  tmpIsHead: Boolean;
begin              
  FillChar(AParseRecord.DealDayData, SizeOf(AParseRecord.DealDayData), 0);
  tmpTDIndex := -1;
  tmpIsHead := false;
  for i := 0 to ANode.childNodes.length - 1 do
  begin
    tmpChild := ANode.childNodes.item(i);
    if SameText(tmpChild.nodeName, 'td') then
    begin
      inc (tmpTDIndex);
      if (not AParseRecord.IsTableHeadReady) then
      begin          
        // 处理 行数据
        tmpStr := trim(tmpChild.nodeValue);
        if '' = tmpStr then
        begin
          tmpStr := GetNodeText(tmpChild);
        end;
        if '' <> tmpStr then
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
        end;
      end else
      begin    
        // 处理 行数据
        tmpStr := trim(tmpChild.nodeValue);
        if '' = tmpStr then
        begin
          tmpStr := Trim(GetNodeText(tmpChild));
        end;        
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
                         
function HtmlParse_DayData_Sina_Table(ADataAccess: TStockDayDataAccess; AParseRecord: PParseRecord; ANode: TNode): Boolean;
var
  i, j: integer;
  tmpNode1: TNode;
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
  tmpcnt1 := ANode.childNodes.length;
  tmpRow := 0;
  for i := 0 to tmpcnt1 - 1 do
  begin                         
    tmpNode1 := ANode.childNodes.item(i);
    tmpTagName := lowercase(tmpNode1.nodeName);
    if SameText(tmpTagName, 'tr') then
    begin
      ParseStockDealDataTableRow(ADataAccess, AParseRecord, tmpNode1);
    end;
    if SameText(tmpTagName, 'tbody') then
    begin
      tmpcnt2 := tmpNode1.childNodes.length;
      for j := 0 to tmpcnt2 - 1 do
      begin
        if SameText(tmpNode1.childNodes.item(j).nodeName, 'tr') then
        begin    
          ParseStockDealDataTableRow(ADataAccess, AParseRecord, ANode.childNodes.item(i));
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

function HtmlParse_DayData_Sina(ADataAccess: TStockDayDataAccess; AParseRecord: PParseRecord; ANode: TNode): Boolean;
var
  i, j: integer;
  tmpcnt: integer;
  tmpTableId: WideString;
  tmpNode: TNode;      
  tmpIsHandledNode: Boolean;
begin
  result := false;
  if nil = ANode then
    exit;
  tmpIsHandledNode := false;
  if SameText(string(lowercase(ANode.nodeName)), 'table') then
  begin           
    Inc(AParseRecord.IsInTable);
    tmpcnt := 0;
    if nil <> ANode.childNodes then
      tmpcnt := ANode.childNodes.length;
    tmpTableId := '';
    tmpNode := nil;
    if nil <> ANode.attributes then
    begin                            
      for i := 0 to ANode.attributes.length - 1 do
      begin
        tmpNode := ANode.attributes.item(i);
        if SameText('id', tmpNode.nodeName) then
        begin
          tmpTableId := GetNodeText(tmpNode);
          Break;
        end;
      end;
    end;
    if tmpTableId <> '' then
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
    if nil <> ANode.childNodes then
    begin
      tmpcnt := ANode.childNodes.length;
      for i := 0 to tmpcnt - 1 do
      begin
        tmpNode := ANode.childNodes.item(i);
        if not result then
        begin
          result := HtmlParse_DayData_Sina(ADataAccess, AParseRecord, tmpNode);
        end else
        begin
          HtmlParse_DayData_Sina(ADataAccess, AParseRecord, tmpNode);
        end;
      end;
    end;
  end;        
  if SameText(string(lowercase(ANode.nodeName)), 'table') then
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
    SaveHttpResponseToFile(AResultData, @tmpHttpHeadSession, 'e:\test.html');

    tmpParseRec.HtmlParser := THtmlParser.Create;
    try
      try                         
        tmpParseRec.HtmlDoc := tmpParseRec.HtmlParser.parseString(
            TDomString(AnsiString(PAnsiChar(@AResultData.Data[tmpHttpHeadSession.HeadEndPos + 1]))));
        if tmpParseRec.HtmlDoc <> nil then
        begin
          Result := HtmlParse_DayData_Sina(ADataAccess, @tmpParseRec, tmpParseRec.HtmlDoc.documentElement);
        end;
      except
        Log('ParserSinaDataError:', ADataAccess.StockItem.sCode + 'error html');// + AnsiString(PAnsiChar(@AResultData.Data[tmpHttpHeadSession.HeadEndPos + 1])));
      end;
    finally
      FreeAndNil(tmpParseRec.HtmlParser);
    end;
  end;
end;

end.
