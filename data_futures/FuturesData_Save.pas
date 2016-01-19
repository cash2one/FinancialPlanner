unit FuturesData_Save;

interface

uses
  BaseApp,
  FuturesDataAccess;

  procedure SaveFuturesData(App: TBaseApp; ADataAccess: TFuturesDataAccess);

implementation
        
uses
  Windows,
  BaseWinFile,
  Define_Price,
  define_futures_quotes,
  define_dealstore_header,
  define_dealstore_file;
                       
procedure SaveFuturesDataToBuffer(App: TBaseApp; ADataAccess: TFuturesDataAccess; AMemory: pointer); forward;

procedure SaveFuturesData(App: TBaseApp; ADataAccess: TFuturesDataAccess);
var
  tmpWinFile: TWinFile;
  tmpFileUrl: string;
  tmpFileMapView: Pointer; 
  tmpFileNewSize: integer;
begin
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DayData, ADataAccess.DataSourceId, 1, ADataAccess.StockItem);
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(tmpFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(TStore_Quote_M1_Day_Header_V1Rec) + ADataAccess.RecordCount * SizeOf(TStore_Quote64_M1); //400k
      tmpFileNewSize := ((tmpFileNewSize div (64 * 1024)) + 1) * 64 * 1024;
      tmpWinFile.FileSize := tmpFileNewSize;

      tmpFileMapView := tmpWinFile.OpenFileMap;
      if nil <> tmpFileMapView then
      begin                             
        SaveFuturesDataToBuffer(App, ADataAccess, tmpFileMapView);
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

procedure SaveFuturesDataToBuffer(App: TBaseApp; ADataAccess: TFuturesDataAccess; AMemory: pointer);
var
  tmpHead: PStore_Quote_M1_Day_Header_V1Rec;
  tmpQuoteData: PStore_Quote64_M1;
  tmpStoreDayData: PStore_Quote64_M1_Day_V1;
  tmpRTDayData: PRT_Quote_M1_Day;
  i: integer;
begin
  tmpHead := AMemory;  
  tmpHead.Header.BaseHeader.Signature.Signature := 7784; // 6
  tmpHead.Header.BaseHeader.Signature.DataVer1  := 1;
  tmpHead.Header.BaseHeader.Signature.DataVer2  := 0;
  tmpHead.Header.BaseHeader.Signature.DataVer3  := 0;
  // 字节存储顺序 java 和 delphi 不同
  // 00
  // 01
  tmpHead.Header.BaseHeader.Signature.BytesOrder:= 1;
  tmpHead.Header.BaseHeader.HeadSize            := SizeOf(TStore_Quote_M1_Day_Header_V1Rec);             // 1 -- 7
  tmpHead.Header.BaseHeader.StoreSizeMode.Value := 16;  // 1 -- 8 page size mode
  { 表明是什么数据 }
  tmpHead.Header.BaseHeader.DataType            := DataType_Stock;             // 2 -- 10
  tmpHead.Header.BaseHeader.DataMode            := DataMode_DayData;             // 1 -- 11
  tmpHead.Header.BaseHeader.RecordSizeMode.Value:= 6;  // 1 -- 12
  tmpHead.Header.BaseHeader.RecordCount         := ADataAccess.RecordCount;          // 4 -- 16
  tmpHead.Header.BaseHeader.CompressFlag        := 0;             // 1 -- 17
  tmpHead.Header.BaseHeader.EncryptFlag         := 0;             // 1 -- 18
  tmpHead.Header.BaseHeader.DataSourceId        := ADataAccess.DataSourceId;             // 2 -- 20
  CopyMemory(@tmpHead.Header.BaseHeader.Code[0], @ADataAccess.StockItem.sCode[1], Length(ADataAccess.StockItem.sCode));
  //Move(ADataAccess.StockItem.Code, tmpHead.Header.BaseHeader.Code[0], Length(ADataAccess.StockItem.Code)); // 12 - 32
  // ----------------------------------------------------
  tmpHead.Header.BaseHeader.StorePriceFactor    := 1000;             // 2 - 34
                                                
  tmpHead.Header.FirstDealDate       := ADataAccess.FirstDealDate;             // 2 - 36
  tmpHead.Header.LastDealDate        := ADataAccess.LastDealDate;             // 2 - 38
  tmpHead.Header.EndDealDate         := ADataAccess.EndDealDate;             // 2 - 40

  Inc(tmpHead);
  tmpQuoteData := PStore_Quote64_M1(tmpHead);
  for i := 0 to ADataAccess.RecordCount - 1 do
  begin
    tmpRTDayData := ADataAccess.RecordItem[i];
    if nil <> tmpRTDayData then
    begin
      tmpStoreDayData := PStore_Quote64_M1_Day_V1(tmpQuoteData);
      RTPricePackRange2StorePriceRange(@tmpStoreDayData.PriceRange, @tmpRTDayData.PriceRange); 
      tmpStoreDayData.DealVolume          := tmpRTDayData.DealVolume;         // 8 - 24 成交量
      tmpStoreDayData.DealAmount          := tmpRTDayData.DealAmount;         // 8 - 32 成交金额
      tmpStoreDayData.DealDate            := tmpRTDayData.DealDateTime.Value;       // 4 - 36 交易日期
      tmpStoreDayData.Weight.Value        := tmpRTDayData.Weight.Value; // 4 - 40 复权权重 * 100
      tmpStoreDayData.TotalValue          := tmpRTDayData.TotalValue;         // 8 - 48 总市值
      tmpStoreDayData.DealValue           := tmpRTDayData.DealValue;         // 8 - 56 流通市值
      Inc(tmpQuoteData);
    end;
  end;
end;

end.
