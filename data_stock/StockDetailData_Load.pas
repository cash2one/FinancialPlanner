unit StockDetailData_Load;

interface
                           
uses
  BaseApp,
  StockDetailDataAccess;
  
  procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AIsDoLog: Boolean = false); overload;
  procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: AnsiString; AIsDoLog: Boolean = false); overload; 

implementation

uses
  SysUtils,
  UtilsLog,
  BaseWinFile,          
  Define_Price,
  define_stock_quotes,
  define_dealstore_header,
  define_dealstore_file;
                          
procedure LoadStockDetailDataFromBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer; AIsDoLog: Boolean = false); forward;

procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AIsDoLog: Boolean = false);
begin
  LoadStockDetailData(App, ADataAccess,
      App.Path.GetFileUrl(FilePath_DBType_DetailData, ADataAccess.DataSourceId, ADataAccess.FirstDealDate, ADataAccess.StockItem),
      AIsDoLog);
end;
             
procedure LoadStockDetailData(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AFileUrl: AnsiString; AIsDoLog: Boolean = false);
var                   
  tmpWinFile: TWinFile;
  tmpFileMapView: Pointer;
begin
  if AIsDoLog then
  begin     
    Log('StockDetailData_Load.pas', 'LoadStockDetailData ' + AFileUrl);
  end;
  if App.Path.IsFileExists(AFileUrl) then
  begin
    tmpWinFile := TWinFile.Create;
    try
      if tmpWinFile.OpenFile(AFileUrl, false) then
      begin
        tmpFileMapView := tmpWinFile.OpenFileMap;
        if nil <> tmpFileMapView then
        begin
          LoadStockDetailDataFromBuffer(App, ADataAccess, tmpFileMapView, AIsDoLog);
        end else
        begin
          if AIsDoLog then
          begin
            Log('StockDetailData_Load.pas', 'LoadStockDetailData map open error ');
          end;
        end;
      end else
      begin
        if AIsDoLog then
        begin
          Log('StockDetailData_Load.pas', 'LoadStockDetailData file open error ');
        end;
      end;
    finally
      tmpWinFile.Free;
    end;
  end else
  begin      
    if AIsDoLog then
    begin
      Log('StockDetailData_Load.pas', 'LoadStockDetailData file not exists ' + AFileUrl);
    end;
  end;
end;

procedure LoadStockDetailDataFromBuffer(App: TBaseApp; ADataAccess: TStockDetailDataAccess; AMemory: pointer; AIsDoLog: Boolean = false);
var 
  tmpHead: PStore_Quote_M2_Detail_Header_V1Rec;
  tmpStoreDetailData: PStore_Quote32_Detail_V1;
  
  tmpRTDetailData: PRT_Quote_Detail;
  tmpRecordCount: integer;
  tmpDate: Word;
  i: integer;
  tmpDateStr: string;
begin             
  if AIsDoLog then
  begin
    Log('StockDetailData_Load.pas', 'LoadStockDetailData buffer');
  end;
  tmpHead := AMemory;
  tmpDate := 0;    
  if tmpHead.Header.BaseHeader.HeadSize = SizeOf(TStore_Quote_M2_Detail_Header_V1Rec) then
  begin
    if (tmpHead.Header.BaseHeader.DataType = DataType_Stock) then
    begin
      if (tmpHead.Header.BaseHeader.DataMode = DataMode_DayDetailDataM2) then
      begin
        if 0 = ADataAccess.DataSourceId then
          ADataAccess.DataSourceId  := tmpHead.Header.BaseHeader.DataSourceId;  
        if AIsDoLog then
        begin
          Log('StockDetailData_Load.pas', 'ADataAccess.DataSourceId' + IntToStr(ADataAccess.DataSourceId) + '/' +
            IntToStr(tmpHead.Header.BaseHeader.DataSourceId));
        end;
        if ADataAccess.DataSourceId = tmpHead.Header.BaseHeader.DataSourceId then
        begin
          tmpRecordCount := tmpHead.Header.BaseHeader.RecordCount;
          Inc(tmpHead);
          tmpStoreDetailData := PStore_Quote32_Detail_V1(tmpHead);
          for i := 0 to tmpRecordCount - 1 do
          begin
            tmpDate := tmpStoreDetailData.Quote.QuoteDealDate;
            if 0 = tmpDate then
            begin
              tmpDate := tmpHead.Header.BaseHeader.FirstDealDate;  
              if 0 = tmpDate then
                tmpDate := ADataAccess.FirstDealDate;
              if 0 < tmpDate then
              begin
                tmpDateStr := FormatDateTime('yyyymmdd', tmpDate);
                if '' = tmpDateStr then
                begin
                end;
              end;
            end;
            if 0 < tmpDate then
            begin
              if (0 < tmpStoreDetailData.Quote.DealVolume) and
                 (0 < tmpStoreDetailData.Quote.DealAmount) then
              begin
                tmpRTDetailData := ADataAccess.CheckOutRecord(tmpDate, tmpStoreDetailData.Quote.QuoteDealTime);
                if nil <> tmpRTDetailData then
                begin
                  StorePrice2RTPricePack(@tmpRTDetailData.Price, @tmpStoreDetailData.Quote.Price);   
                  tmpRTDetailData.DealVolume := tmpStoreDetailData.Quote.DealVolume;
                  tmpRTDetailData.DealAmount := tmpStoreDetailData.Quote.DealAmount;
                  tmpRTDetailData.DealType := tmpStoreDetailData.Quote.DealType;
                end;
              end;
            end else
            begin
              if AIsDoLog then
              begin
                Log('StockDetailData_Load.pas', 'tmpDate Error' + IntToStr(tmpDate) + '/' + IntToStr(ADataAccess.FirstDealDate));
              end;
            end;
            Inc(tmpStoreDetailData);
          end;
        end;
      end else
      begin
        if AIsDoLog then
        begin
          Log('StockDetailData_Load.pas', 'tmpHead.Header.BaseHeader.DataMode Error');
        end;
      end;
    end else
    begin
      if AIsDoLog then
      begin
        Log('StockDetailData_Load.pas', 'tmpHead.Header.BaseHeader.DataType Error');
      end;
    end;
  end else
  begin
    if AIsDoLog then
    begin
      Log('StockDetailData_Load.pas', 'tmpHead.Header.BaseHeader.HeadSize Error');
    end;
  end;
end;

end.
