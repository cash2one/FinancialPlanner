unit StockDetailData_Save;

interface

uses
  BaseApp,
  StockDetailDataAccess;

  procedure SaveStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess);   
  procedure SaveStockDetailData2File(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: string);

implementation
        
uses
  Windows,
  BaseWinFile,
  Define_Price,
  Define_RunTime_StockQuote,
  Define_Store_Header,
  Define_Store_StockQuote,
  Define_Store_File;
                       
procedure SaveStockDetailDataToBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer); forward;

procedure SaveStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess);
var
  tmpFileUrl: string;
begin
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_DetailData, ADataAccess.DataSourceId, ADataAccess.DealDate, ADataAccess.StockItem);
  SaveStockDetailData2File(App, ADataAccess, tmpFileUrl);
end;

procedure SaveStockDetailData2File(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: string);
var
  tmpWinFile: TWinFile;
  tmpFileMapView: Pointer;
  tmpFileNewSize: integer;
begin
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(AFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(TStore_Quote_M2_Detail_Header_V1Rec) + ADataAccess.RecordCount * SizeOf(TStore_Quote32_M2_V1); //400k
      tmpFileNewSize := ((tmpFileNewSize div (1 * 1024)) + 1) * 1 * 1024;
      tmpWinFile.FileSize := tmpFileNewSize;

      tmpFileMapView := tmpWinFile.OpenFileMap;
      if nil <> tmpFileMapView then
      begin
        SaveStockDetailDataToBuffer(App, ADataAccess, tmpFileMapView);
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

procedure SaveStockDetailDataToBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer);
var
  tmpHead: PStore_Quote_M2_Detail_Header_V1Rec;
  tmpStoreDetailData: PStore_Quote32_M2_V1;
  tmpRTDetailData: PRT_Quote_M2;
  i: integer;
begin
  tmpHead := AMemory;  
  tmpHead.Header.Signature.Signature := 7784; // 6
  tmpHead.Header.Signature.DataVer1  := 1;
  tmpHead.Header.Signature.DataVer2  := 0;
  tmpHead.Header.Signature.DataVer3  := 0;
  // 字节存储顺序 java 和 delphi 不同
  // 00
  // 01
  tmpHead.Header.Signature.BytesOrder:= 1;
  tmpHead.Header.HeadSize            := SizeOf(TStore_Quote_M2_Detail_Header_V1Rec);             // 1 -- 7
  tmpHead.Header.StoreSizeMode.Value := 16;  // 1 -- 8 page size mode
  { 表明是什么数据 }
  tmpHead.Header.DataType            := DataType_Stock;             // 2 -- 10
  tmpHead.Header.DataMode            := DataMode_DayDetailDataM2;             // 1 -- 11
  tmpHead.Header.RecordSizeMode.Value:= 6;  // 1 -- 12
  tmpHead.Header.RecordCount         := ADataAccess.RecordCount;          // 4 -- 16
  tmpHead.Header.CompressFlag        := 0;             // 1 -- 17
  tmpHead.Header.EncryptFlag         := 0;             // 1 -- 18
  tmpHead.Header.DataSourceId        := ADataAccess.DataSourceId;             // 2 -- 20
  CopyMemory(@tmpHead.Header.Code[0], @ADataAccess.StockItem.Code[1], Length(ADataAccess.StockItem.Code));
  //Move(ADataAccess.StockItem.Code, tmpHead.Header.BaseHeader.Code[0], Length(ADataAccess.StockItem.Code)); // 12 - 32
  // ----------------------------------------------------
  tmpHead.Header.StorePriceFactor    := 1000;             // 2 - 34
                                                
  tmpHead.Header.DealDate           := ADataAccess.DealDate;             // 2 - 36

  Inc(tmpHead);
  tmpStoreDetailData := PStore_Quote32_M2_V1(tmpHead);
  for i := 0 to ADataAccess.RecordCount - 1 do
  begin
    tmpRTDetailData := ADataAccess.RecordItem[i];
    if nil <> tmpRTDetailData then
    begin
      RTPricePack2StorePrice(@tmpStoreDetailData.Quote.Price, @tmpRTDetailData.Price); 
      tmpStoreDetailData.Quote.DealVolume          := tmpRTDetailData.DealVolume;         // 8 - 24 成交量
      tmpStoreDetailData.Quote.DealAmount          := tmpRTDetailData.DealAmount;         // 8 - 32 成交金额
      tmpStoreDetailData.Quote.QuoteDateTime       := tmpRTDetailData.DealTime.Value;       // 4 - 36 交易日期
      tmpStoreDetailData.Quote.DealType       := tmpRTDetailData.DealType;
      Inc(tmpStoreDetailData);
    end;
  end;
end;

end.
