unit FuturesData_Load;

interface
                           
uses
  BaseApp,
  FuturesDataAccess;
  
  function LoadFuturesData(App: TBaseApp; ADataAccess: TFuturesDataAccess): Boolean;
  function CheckNeedLoadFuturesData(App: TBaseApp; ADataAccess: TFuturesDataAccess; ALastDate: Word): Boolean;
  
implementation

uses
  BaseWinFile,          
  Define_Price,
  define_futures_quotes,
  define_dealstore_header,
  define_dealstore_file;
                          
function LoadFuturesDataFromBuffer(ADataAccess: TFuturesDataAccess; AMemory: pointer): Boolean; forward;

function LoadFuturesData(App: TBaseApp; ADataAccess: TFuturesDataAccess): Boolean;
var
  tmpWinFile: TWinFile;
  tmpFileUrl: string;
  tmpFileMapView: Pointer;   
begin
  Result := false;
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, ADataAccess.DataSourceId, 1, ADataAccess.DealItem);
  if App.Path.IsFileExists(tmpFileUrl) then
  begin
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(tmpFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin        
          Result := LoadFuturesDataFromBuffer(ADataAccess, tmpFileMapView);
        end;
      end;
    finally
      tmpWinFile.Free;
    end;
  end;
end;
                                  
function ReadFuturesDataHeader(ADataAccess: TFuturesDataAccess; AMemory: pointer): PStore_Quote_M1_Day_Header_V1Rec;
var
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
begin
  Result := nil;
  tmpHead := AMemory;
  if tmpHead.Header.BaseHeader.HeadSize = SizeOf(TStore_Quote_M1_Day_Header_V1Rec) then
  begin
    if (tmpHead.Header.BaseHeader.DataType = DataType_Futures) then
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

function LoadFuturesDataFromBuffer(ADataAccess: TFuturesDataAccess; AMemory: pointer): Boolean;
var 
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
  tmpQuoteData: PStore_Quote64_M1;
  tmpStoreDayData: PStore_Quote64_M1_Day_V1;
  tmpRTDayData: PRT_Quote_M1_Day;
  tmpRecordCount: integer; 
  i: integer;
begin
  Result := false;
  tmpHead := ReadFuturesDataHeader(ADataAccess, AMemory);
  if nil <> tmpHead then
  begin
    tmpRecordCount := tmpHead.Header.BaseHeader.RecordCount;
    Inc(tmpHead);
    tmpQuoteData := PStore_Quote64_M1(tmpHead);
    for i := 0 to tmpRecordCount - 1 do
    begin            
      Result := true;
      tmpStoreDayData := PStore_Quote64_M1_Day_V1(tmpQuoteData);
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
  end;
end;

function CheckNeedLoadFuturesData(App: TBaseApp; ADataAccess: TFuturesDataAccess; ALastDate: Word): Boolean;  
var
  tmpWinFile: TWinFile;
  tmpFileUrl: string;
  tmpFileMapView: Pointer;     
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
begin
  Result := true; 
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, ADataAccess.DataSourceId, 1, ADataAccess.DealItem);
  if App.Path.IsFileExists(tmpFileUrl) then
  begin      
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(tmpFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin                             
          tmpHead := ReadFuturesDataHeader(ADataAccess, tmpFileMapView);
          if nil <> tmpHead then
          begin
            if tmpHead.Header.LastDealDate >= ALastDate then
            begin
              Result := false;
            end;
            if Result then
            begin
              LoadFuturesDataFromBuffer(ADataAccess, tmpFileMapView);
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
