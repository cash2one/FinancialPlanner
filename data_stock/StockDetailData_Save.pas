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
  Sysutils,
  BaseWinFile,
  define_dealstore_file,
  define_stock_quotes,
  define_dealstore_header,
  Define_Price;
                       
procedure SaveStockDetailDataToBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer); forward;

procedure SaveStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess);
var
  tmpFileUrl: string;
begin
  tmpFileUrl := App.Path.GetFileUrl(define_dealstore_file.FilePath_DBType_DetailData,
    ADataAccess.DataSourceId, ADataAccess.FirstDealDate, ADataAccess.StockItem);
  SaveStockDetailData2File(App, ADataAccess, tmpFileUrl);
end;

procedure SaveStockDetailData2File(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: string);
var
  tmpWinFile: TWinFile;
  tmpFileMapView: Pointer;
  tmpFileNewSize: integer;
begin
  if '' = AFileUrl then
    exit;
  ForceDirectories(ExtractFilePath(AFileUrl));
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(AFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(define_dealstore_header.TStore_Quote_M2_Detail_Header_V1Rec) +
          ADataAccess.RecordCount * SizeOf(define_stock_quotes.TStore_Quote32_M2_V1); //400k
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
  tmpHead.Header.BaseHeader.Signature.Signature := 7784; // 6
  tmpHead.Header.BaseHeader.Signature.DataVer1  := 1;
  tmpHead.Header.BaseHeader.Signature.DataVer2  := 0;
  tmpHead.Header.BaseHeader.Signature.DataVer3  := 0;
  // 字节存储顺序 java 和 delphi 不同
  // 00
  // 01
  tmpHead.Header.BaseHeader.Signature.BytesOrder:= 1;
  tmpHead.Header.BaseHeader.HeadSize            := SizeOf(TStore_Quote_M2_Detail_Header_V1Rec);             // 1 -- 7
  tmpHead.Header.BaseHeader.StoreSizeMode.Value := 16;  // 1 -- 8 page size mode
  { 表明是什么数据 }
  tmpHead.Header.BaseHeader.DataType            := DataType_Stock;             // 2 -- 10
  tmpHead.Header.BaseHeader.DataMode            := DataMode_DayDetailDataM2;             // 1 -- 11
  tmpHead.Header.BaseHeader.RecordSizeMode.Value:= 6;  // 1 -- 12
  tmpHead.Header.BaseHeader.RecordCount         := ADataAccess.RecordCount;          // 4 -- 16
  tmpHead.Header.BaseHeader.CompressFlag        := 0;             // 1 -- 17
  tmpHead.Header.BaseHeader.EncryptFlag         := 0;             // 1 -- 18
  tmpHead.Header.BaseHeader.DataSourceId        := ADataAccess.DataSourceId;             // 2 -- 20
  CopyMemory(@tmpHead.Header.BaseHeader.Code[0], @ADataAccess.StockItem.sCode[1], Length(ADataAccess.StockItem.sCode));
  //Move(ADataAccess.StockItem.Code, tmpHead.Header.BaseHeader.Code[0], Length(ADataAccess.StockItem.Code)); // 12 - 32
  // ----------------------------------------------------
  tmpHead.Header.BaseHeader.StorePriceFactor    := 1000;             // 2 - 34
                                                
  tmpHead.Header.BaseHeader.FirstDealDate       := ADataAccess.FirstDealDate;             // 2 - 36
  tmpHead.Header.BaseHeader.LastDealDate       := ADataAccess.LastDealDate;             // 2 - 36
  
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
