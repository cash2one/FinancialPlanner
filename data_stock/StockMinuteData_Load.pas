unit StockMinuteData_Load;

interface
                           
uses
  BaseApp,
  StockMinuteDataAccess;
  
  function LoadStockMinuteData(App: TBaseApp; ADataAccess: TStockMinuteDataAccess): Boolean;
  function CheckNeedLoadStockMinuteData(App: TBaseApp; ADataAccess: TStockMinuteDataAccess; ALastDate: Word): Boolean;
  
implementation

uses
  Sysutils,
  BaseWinFile,          
  Define_Price,
  //UtilsLog,
  define_stock_quotes,
  define_dealstore_header,
  define_dealstore_file;
                          
function LoadStockMinuteDataFromBuffer(ADataAccess: TStockMinuteDataAccess; AMemory: pointer): Boolean; forward;

function LoadStockMinuteData(App: TBaseApp; ADataAccess: TStockMinuteDataAccess): Boolean;
var
  tmpWinFile: TWinFile;
  tmpFileUrl: WideString;
  tmpFileMapView: Pointer;   
begin
  Result := false;
  if weightNone <> ADataAccess.WeightMode then
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayDataWeight, ADataAccess.DataSourceId, 1, ADataAccess.StockItem);
  end else
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, ADataAccess.DataSourceId, 1, ADataAccess.StockItem);
  end;
  //Log('LoadStockDayData', 'FileUrl:' + tmpFileUrl);
  if App.Path.IsFileExists(tmpFileUrl) then
  begin                                 
    //Log('LoadStockDayData', 'FileUrl exist');
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(tmpFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin        
          Result := LoadStockMinuteDataFromBuffer(ADataAccess, tmpFileMapView);
        end else
        begin
          //Log('LoadStockDayData', 'FileUrl map fail');
        end;
      end else
      begin
        //Log('LoadStockDayData', 'FileUrl open fail');
      end;
    finally
      tmpWinFile.Free;
    end;
  end;
end;
                                  
function ReadStockMinuteDataHeader(ADataAccess: TStockMinuteDataAccess; AMemory: pointer): PStore_Quote_M1_Day_Header_V1Rec;
var
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
begin
  Result := nil;
  tmpHead := AMemory;
  if tmpHead.Header.BaseHeader.HeadSize = SizeOf(TStore_Quote_M1_Day_Header_V1Rec) then
  begin
    if (tmpHead.Header.BaseHeader.DataType = DataType_Stock) then
    begin
      if (tmpHead.Header.BaseHeader.DataMode = DataMode_DayData) then
      begin
        if 0 = ADataAccess.DataSourceId then
          ADataAccess.DataSourceId  := tmpHead.Header.BaseHeader.DataSourceId;
        if ADataAccess.DataSourceId = tmpHead.Header.BaseHeader.DataSourceId then
        begin
          Result := tmpHead;
        end;
      end;
    end;
  end;
end;

function LoadStockMinuteDataFromBuffer(ADataAccess: TStockMinuteDataAccess; AMemory: pointer): Boolean;
var 
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
  tmpQuoteData: PStore_Quote64_M1;
  tmpStoreMinuteData: PStore_Quote64_Minute_V1;
  tmpRTMinuteData: PRT_Quote_Minute;
  tmpRecordCount: integer; 
  i: integer;
begin
  Result := false; 
  //Log('LoadStockDayData', 'LoadStockDayDataFromBuffer');
  tmpHead := ReadStockMinuteDataHeader(ADataAccess, AMemory);
  if nil <> tmpHead then
  begin
    tmpRecordCount := tmpHead.Header.BaseHeader.RecordCount;
    //Log('LoadStockDayData', 'LoadStockDayDataFromBuffer record count:' + IntToStr(tmpRecordCount));    
    Inc(tmpHead);
    tmpQuoteData := PStore_Quote64_M1(tmpHead);
    for i := 0 to tmpRecordCount - 1 do
    begin            
      Result := true;
      tmpStoreMinuteData := PStore_Quote64_Minute_V1(tmpQuoteData);
      //tmpRTMinuteData := ADataAccess.CheckOutRecord(tmpStoreMinuteData.DealDateTime);
      if nil <> tmpRTMinuteData then
      begin
        StorePriceRange2RTPricePackRange(@tmpRTMinuteData.PriceRange, @tmpStoreMinuteData.PriceRange);   
        tmpRTMinuteData.DealVolume := tmpStoreMinuteData.DealVolume;         // 8 - 24 成交量
        tmpRTMinuteData.DealAmount := tmpStoreMinuteData.DealAmount;         // 8 - 32 成交金额
        //tmpRTMinuteData.Weight.Value := tmpStoreMinuteData.Weight.Value; // 4 - 40 复权权重 * 100
        //tmpRTMinuteData.TotalValue := tmpStoreMinuteData.TotalValue;         // 8 - 48 总市值
        //tmpRTMinuteData.DealValue := tmpStoreMinuteData.DealValue;         // 8 - 56 流通市值
      end;
      Inc(tmpQuoteData);
    end;
    ADataAccess.Sort;
  end;
end;

function CheckNeedLoadStockMinuteData(App: TBaseApp; ADataAccess: TStockMinuteDataAccess; ALastDate: Word): Boolean;  
var
  tmpWinFile: TWinFile;
  tmpFileUrl: string;
  tmpFileMapView: Pointer;     
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
begin
  Result := true;
  if weightNone <> ADataAccess.WeightMode then
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayDataWeight, ADataAccess.DataSourceId, 1, ADataAccess.StockItem);
  end else
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, ADataAccess.DataSourceId, 1, ADataAccess.StockItem);
  end;
  if App.Path.IsFileExists(tmpFileUrl) then
  begin      
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(tmpFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin                             
          tmpHead := ReadStockMinuteDataHeader(ADataAccess, tmpFileMapView);
          if nil <> tmpHead then
          begin
            if tmpHead.Header.LastDealDate >= ALastDate then
            begin
              Result := false;
            end;
            if Result then
            begin
              LoadStockMinuteDataFromBuffer(ADataAccess, tmpFileMapView);
            end;
          end;
        end;
      end;
    finally
      tmpWinFile.Free;
    end;
  end;
end;

end.
