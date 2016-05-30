unit StockDetailData_Load;

interface
                           
uses
  BaseApp,
  StockDetailDataAccess;
  
  procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess); overload;
  procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: AnsiString); overload; 

implementation

uses
  BaseWinFile,          
  Define_Price,
  define_stock_quotes,
  define_dealstore_header,
  define_dealstore_file;
                          
procedure LoadStockDetailDataFromBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer); forward;

procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess);
begin
  LoadStockDetailData(App, ADataAccess,
      App.Path.GetFileUrl(FilePath_DBType_DetailData, ADataAccess.DataSourceId, ADataAccess.FirstDealDate, ADataAccess.StockItem));
end;
             
procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: AnsiString);
var                   
  tmpWinFile: TWinFile;
  tmpFileMapView: Pointer;
begin
  if App.Path.IsFileExists(AFileUrl) then
  begin
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(AFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin
          LoadStockDetailDataFromBuffer(App, ADataAccess, tmpFileMapView);
        end;
      end;
    finally
      tmpWinFile.Free;
    end;
  end;
end;

procedure LoadStockDetailDataFromBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer);
var 
  tmpHead: PStore_Quote_M2_Detail_Header_V1Rec;
  tmpStoreDetailData: PStore_Quote32_M2_V1;
  
  tmpRTDetailData: PRT_Quote_M2;
  tmpRecordCount: integer; 
  i: integer;
begin
  tmpHead := AMemory;    
  if tmpHead.Header.BaseHeader.HeadSize = SizeOf(TStore_Quote_M2_Detail_Header_V1Rec) then
  begin
    if (tmpHead.Header.BaseHeader.DataType = DataType_Stock) then
    begin
      if (tmpHead.Header.BaseHeader.DataMode = DataMode_DayDetailDataM2) then
      begin
        if 0 = ADataAccess.DataSourceId then
          ADataAccess.DataSourceId  := tmpHead.Header.BaseHeader.DataSourceId;
        if ADataAccess.DataSourceId = tmpHead.Header.BaseHeader.DataSourceId then
        begin
          tmpRecordCount := tmpHead.Header.BaseHeader.RecordCount;
          Inc(tmpHead);
          tmpStoreDetailData := PStore_Quote32_M2_V1(tmpHead);
          for i := 0 to tmpRecordCount - 1 do
          begin             
            tmpRTDetailData := ADataAccess.CheckOutRecord(tmpStoreDetailData.Quote.QuoteDateTime);
            if nil <> tmpRTDetailData then
            begin
              StorePrice2RTPricePack(@tmpRTDetailData.Price, @tmpStoreDetailData.Quote.Price);   
              tmpRTDetailData.DealVolume := tmpStoreDetailData.Quote.DealVolume;
              tmpRTDetailData.DealAmount := tmpStoreDetailData.Quote.DealAmount;
              tmpRTDetailData.DealType := tmpStoreDetailData.Quote.DealType;         
            end;
            Inc(tmpStoreDetailData);
          end;
        end;
      end;
    end;
  end;
end;

end.
