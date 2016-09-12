unit StockWeightData_Load;

interface
                           
uses
  BaseApp,
  StockWeightDataAccess;
  
  function LoadStockWeightData(App: TBaseApp; ADataAccess: TStockWeightDataAccess): Boolean;
  function CheckNeedLoadStockWeightData(App: TBaseApp; ADataAccess: TStockWeightDataAccess; ALastDate: Word): Boolean;
  
implementation

uses
  Sysutils,
  BaseWinFile,          
  define_Price,
  define_datasrc,
  //UtilsLog,
  define_stock_quotes,
  define_dealstore_header,
  define_dealstore_file;
                          
function LoadStockWeightDataFromBuffer(ADataAccess: TStockWeightDataAccess; AMemory: pointer): Boolean; forward;

function LoadStockWeightData(App: TBaseApp; ADataAccess: TStockWeightDataAccess): Boolean;
var
  tmpWinFile: TWinFile;
  tmpFileUrl: WideString;
  tmpFileMapView: Pointer;   
begin
  Result := false;
  if weightNone <> ADataAccess.WeightMode then
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayDataWeight, GetDealDataSourceCode(ADataAccess.DataSource), 1, ADataAccess.StockItem);
  end else
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, GetDealDataSourceCode(ADataAccess.DataSource), 1, ADataAccess.StockItem);
  end;
  //Log('LoadStockWeightData', 'FileUrl:' + tmpFileUrl);
  if App.Path.IsFileExists(tmpFileUrl) then
  begin                                 
    //Log('LoadStockWeightData', 'FileUrl exist');
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(tmpFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin        
          Result := LoadStockWeightDataFromBuffer(ADataAccess, tmpFileMapView);
        end else
        begin
          //Log('LoadStockWeightData', 'FileUrl map fail');
        end;
      end else
      begin
        //Log('LoadStockWeightData', 'FileUrl open fail');
      end;
    finally
      tmpWinFile.Free;
    end;
  end;
end;
                                  
function ReadStockWeightDataHeader(ADataAccess: TStockWeightDataAccess; AMemory: pointer): PStore_Quote_M1_Day_Header_V1Rec;
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
        if src_unknown = ADataAccess.DataSource then
          ADataAccess.DataSource  := GetDealDataSource(tmpHead.Header.BaseHeader.DataSourceId);
        if ADataAccess.DataSource = GetDealDataSource(tmpHead.Header.BaseHeader.DataSourceId) then
        begin
          Result := tmpHead;
        end;
      end;
    end;
  end;
end;

function LoadStockWeightDataFromBuffer(ADataAccess: TStockWeightDataAccess; AMemory: pointer): Boolean;
var 
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
  tmpQuoteData: PStore_Quote64_M1;
  tmpStoreDayData: PStore_Quote64_Day_V1;
  tmpRTDayData: PRT_Quote_Day;
  tmpRecordCount: integer; 
  i: integer;
begin
  Result := false; 
  //Log('LoadStockWeightData', 'LoadStockWeightDataFromBuffer');
  tmpHead := ReadStockWeightDataHeader(ADataAccess, AMemory);
  if nil <> tmpHead then
  begin
    tmpRecordCount := tmpHead.Header.BaseHeader.RecordCount;
    //Log('LoadStockWeightData', 'LoadStockWeightDataFromBuffer record count:' + IntToStr(tmpRecordCount));    
    Inc(tmpHead);
    tmpQuoteData := PStore_Quote64_M1(tmpHead);
    for i := 0 to tmpRecordCount - 1 do
    begin            
      Result := true;
      tmpStoreDayData := PStore_Quote64_Day_V1(tmpQuoteData);
      tmpRTDayData := ADataAccess.CheckOutRecord(tmpStoreDayData.DealDate);
      if nil <> tmpRTDayData then
      begin
        StorePriceRange2RTPricePackRange(@tmpRTDayData.PriceRange, @tmpStoreDayData.PriceRange);   
        tmpRTDayData.DealVolume := tmpStoreDayData.DealVolume;         // 8 - 24 成交量
        tmpRTDayData.DealAmount := tmpStoreDayData.DealAmount;         // 8 - 32 成交金额
        tmpRTDayData.Weight.Value := tmpStoreDayData.Weight.Value; // 4 - 40 复权权重 * 100
        tmpRTDayData.TotalValue := tmpStoreDayData.TotalValue;         // 8 - 48 总市值
        tmpRTDayData.DealValue := tmpStoreDayData.DealValue;         // 8 - 56 流通市值
      end;
      Inc(tmpQuoteData);
    end;
    ADataAccess.Sort;
  end;
end;

function CheckNeedLoadStockWeightData(App: TBaseApp; ADataAccess: TStockWeightDataAccess; ALastDate: Word): Boolean;  
var
  tmpWinFile: TWinFile;
  tmpFileUrl: string;
  tmpFileMapView: Pointer;     
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
begin
  Result := true;
  if weightNone <> ADataAccess.WeightMode then
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayDataWeight, GetDealDataSourceCode(ADataAccess.DataSource), 1, ADataAccess.StockItem);
  end else
  begin
    tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, GetDealDataSourceCode(ADataAccess.DataSource), 1, ADataAccess.StockItem);
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
          tmpHead := ReadStockWeightDataHeader(ADataAccess, tmpFileMapView);
          if nil <> tmpHead then
          begin
            if tmpHead.Header.LastDealDate >= ALastDate then
            begin
              Result := false;
            end;
            if Result then
            begin
              LoadStockWeightDataFromBuffer(ADataAccess, tmpFileMapView);
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
