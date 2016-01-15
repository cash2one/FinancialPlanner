unit Define_AnalysisUpsDowns;

interface

uses
  Define_DealItem, Define_Price, StockDayDataAccess;
  
type
  PRT_AnalysisUpsDowns = ^TRT_AnalysisUpsDowns;
  TRT_AnalysisUpsDowns = record
    StockItem: PRT_DealItem;

    UpDownTrueStatus: TRT_UpDownStatus;
    UpDownViewStatus: TRT_UpDownStatus;
    
    UpTrueDays: Integer; // 事实上涨天数 ( 收盘 > 昨收盘 )
    UpViewDays: Integer; // 看起来上涨天数 ( 收盘 > 开盘 )

    UpTrueRate: double;
    UpTrueBeginPrice: TRT_PricePack;
    UpTrueEndPrice: TRT_PricePack;
    
    UpViewRate: double;
    UpViewBeginPrice: TRT_PricePack;
    UpViewEndPrice: TRT_PricePack;

    UpMaxTrueDays: Integer;
    UpMaxViewDays: Integer;
    
    DownTrueDays: Integer; // 事实下跌天数 ( 收盘 < 昨收盘 )
    DownViewDays: Integer; // 看起来下跌天数 ( 收盘 < 开盘 )

    DownTrueRate: double;
    DownTrueBeginPrice: TRT_PricePack;
    DownTrueEndPrice: TRT_PricePack;

    DownViewRate: double;
    DownViewBeginPrice: TRT_PricePack;
    DownViewEndPrice: TRT_PricePack;
    
    DownMaxTrueDays: Integer;
    DownMaxViewDownDays: Integer;    
  end;

  PStock_AnalysisUpsDowns = ^TStock_AnalysisUpsDowns;
  TStock_AnalysisUpsDowns = record
    StockCode: TDealCodePack;    
    CurrentUpDownStatus: TStore_UpDownStatus;
    CurrentContinueTrueUpDays: Integer; // 事实上涨天数 ( 收盘 > 昨收盘 )
    CurrentContinueViewUpDays: Integer; // 看起来上涨天数 ( 收盘 > 开盘 )
    MaxContinueTrueUpDays: Integer;
    MaxContinueViewUpDays: Integer;

    CurrentContinueTrueDownDays: Integer; // 事实下跌天数 ( 收盘 < 昨收盘 )
    CurrentContinueViewDownDays: Integer; // 看起来下跌天数 ( 收盘 < 开盘 )
    MaxContinueTrueDownDays: Integer;
    MaxContinueViewDownDays: Integer;     
  end;
  
  procedure ComputeAnalysisUpsDowns(AStockItem: PRT_DealItem; AnalysisData: PRT_AnalysisUpsDowns; ADataAccess: TStockDayDataAccess);

implementation

uses
  define_stock_quotes;
  
procedure ComputeAnalysisUpsDowns(AStockItem: PRT_DealItem; AnalysisData: PRT_AnalysisUpsDowns; ADataAccess: TStockDayDataAccess);
var
  i: integer;
  tmpQuoteDay: PRT_Quote_M1_Day; 
  tmpNextDayPrice: PRT_PricePack_Range;
  
  tmpUpTrueStatus: Byte;
  tmpUpViewStatus: Byte;
  tmpDownTrueStatus: Byte;
  tmpDownViewStatus: Byte;    
begin
  if nil = ADataAccess then
    exit;
  if 0 < ADataAccess.RecordCount then
  begin
    tmpQuoteDay := ADataAccess.RecordItem[ADataAccess.RecordCount - 1];
    //if tmpQuoteDay.DealDateTime.Value + 4 > now then
    begin
      AnalysisData.UpDownTrueStatus := udNone;
      AnalysisData.UpDownViewStatus := udNone;
            
      tmpUpTrueStatus := 0;
      tmpUpViewStatus := 0;  
      tmpDownTrueStatus := 0;
      tmpDownViewStatus := 0;                
      tmpNextDayPrice := nil;
            
      for i := ADataAccess.RecordCount - 1 downto 0 do
      begin
        if (2 = tmpUpTrueStatus) and
           (2 = tmpUpViewStatus) and
           (2 = tmpDownTrueStatus) and
           (2 = tmpDownViewStatus) then
        begin
          if nil <> tmpQuoteDay then
          begin
        
          end;
          Break;
        end;
        tmpQuoteDay := ADataAccess.RecordItem[i];

        if tmpQuoteDay.PriceRange.PriceClose.Value > tmpQuoteDay.PriceRange.PriceOpen.Value then
        begin                    
          if 0 = tmpUpViewStatus then
          begin
            tmpUpViewStatus := 1;
          end;                    
          if 1 = tmpDownViewStatus then
          begin
            tmpDownViewStatus := 2;
          end;
          if 1 = tmpUpViewStatus then
          begin
            if AnalysisData.UpDownViewStatus = udNone then
              AnalysisData.UpDownViewStatus := udUp;
            Inc(AnalysisData.UpViewDays);
          end;
        end;
        if tmpQuoteDay.PriceRange.PriceClose.Value < tmpQuoteDay.PriceRange.PriceOpen.Value then
        begin
          if 0 = tmpDownViewStatus then
          begin
            tmpDownViewStatus := 1;
          end;                       
          if 1 = tmpUpViewStatus then
          begin
            tmpUpViewStatus := 2;
          end;
          if 1 = tmpDownViewStatus then
          begin                                  
            if AnalysisData.UpDownViewStatus = udNone then
              AnalysisData.UpDownViewStatus := udDown;
            Inc(AnalysisData.DownViewDays);
          end; 
        end;
        if nil <> tmpNextDayPrice then
        begin
          if tmpQuoteDay.PriceRange.PriceClose.Value > tmpNextDayPrice.PriceClose.Value then
          begin
            // 下跌      
            if 0 = tmpDownTrueStatus then
            begin
              tmpDownTrueStatus := 1;
            end;                      
            if 1 = tmpUpTrueStatus then
            begin
              tmpUpTrueStatus := 2;
            end;
            if 1 = tmpDownTrueStatus then
            begin                             
              if AnalysisData.UpDownTrueStatus = udNone then
                AnalysisData.UpDownTrueStatus := udDown;
              Inc(AnalysisData.DownTrueDays);
            end;
          end;              
          if tmpQuoteDay.PriceRange.PriceClose.Value < tmpNextDayPrice.PriceClose.Value then
          begin
            // 上涨     
            if 0 = tmpUpTrueStatus then
            begin
              tmpUpTrueStatus := 1;
            end;                      
            if 1 = tmpDownTrueStatus then
            begin
              tmpDownTrueStatus := 2;
            end;
            if 1 = tmpUpTrueStatus then
            begin                          
              if AnalysisData.UpDownTrueStatus = udNone then
                AnalysisData.UpDownTrueStatus := udUp;
              Inc(AnalysisData.UpTrueDays);
            end;
          end;                 
        end;  
        tmpNextDayPrice := @tmpQuoteDay.PriceRange;
      end;
    end;
  end;
end;

end.
