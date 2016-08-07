unit StockDayData_Repair_Sina_Mode2;

interface

uses
  BaseApp,
  Sysutils,     
  define_price,
  define_dealitem,
  StockDayDataAccess;
         
type
  PRepairSession = ^TRepairSession;
  TRepairSession = record
    StockItem: PRT_DealItem;
    WeightMode: TWeightMode;
    StockDataSina: TStockDayDataAccess;
    StockData163: TStockDayDataAccess;
  end;
  
function RepairStockDataDay_Sina_Mode2(App: TBaseApp; ARepairSession: PRepairSession): Boolean;

implementation

uses
  Classes,
  Windows,
  Define_DataSrc,    
  define_stock_quotes,
  UtilsDateTime,
  UtilsLog,  
  StockDayData_Load,
  StockDayData_Save;

procedure RepairDayData_Sina_Mode2(ARepairSession: PRepairSession; APrev163Index, APrevSinaIndex, ANextSinaIndex: integer);
var   
  tmpIdx163: integer;
  tmpIdxSina: integer;
  tmpStockData_163: PRT_Quote_Day;
  tmpStockData_Sina: PRT_Quote_Day;
begin
  tmpStockData_163 := ARepairSession.StockData163.RecordItem[tmpIdx163];
  tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[tmpIdxSina];
end;

function RepairStockDataDay_Sina_Mode2(App: TBaseApp; ARepairSession: PRepairSession): Boolean;
var
  tmpYear, tmpMonth, tmpDay: Word;
  tmpJidu: integer;

  tmpUpdateTimes: TStringList;
  tmpStockData_163: PRT_Quote_Day;
  tmpStockData_Sina: PRT_Quote_Day;
  tmpIdx163: integer;
  tmpIdxSina: integer;

  tmpLastSinaWeight: integer;  
  tmpLastSinaIndex: integer;   
  tmpLastSinaDate: integer;    
  tmpLast163Index: integer;   

  tmpPrevSinaWeight: integer;
  tmpPrevSinaIndex: integer;
  tmpPrevSinaDate: integer;     
  tmpPrev163Index: integer;   
   
  tmpSeason: string;
  i: integer;
begin
  Result := false;
  if nil = ARepairSession.StockDataSina then
    ARepairSession.StockDataSina := TStockDayDataAccess.Create(ARepairSession.StockItem, DataSrc_Sina, ARepairSession.WeightMode);
  if nil = ARepairSession.StockData163 then
    ARepairSession.StockData163 := TStockDayDataAccess.Create(ARepairSession.StockItem, DataSrc_163, weightNone);
  tmpUpdateTimes := TStringList.Create;
  try
    if 1 > ARepairSession.StockData163.RecordCount then
    begin
      StockDayData_Load.LoadStockDayData(App, ARepairSession.StockData163);     
      ARepairSession.StockData163.Sort;
    end;            
    if 1 > ARepairSession.StockData163.RecordCount then
      exit;

    if 1 > ARepairSession.StockDataSina.RecordCount then
    begin
      StockDayData_Load.LoadStockDayData(App, ARepairSession.StockDataSina);   
      ARepairSession.StockDataSina.Sort;
    end;
    if ARepairSession.StockData163.RecordCount <= ARepairSession.StockDataSina.RecordCount then
      exit;
    tmpIdx163 := 0;
    tmpIdxSina := 0;
    
    tmpLastSinaWeight := -1;
    tmpLastSinaIndex := -1;
    tmpLastSinaDate := -1;
    tmpLast163Index := -1;
    
    tmpPrevSinaWeight := -1;  
    tmpPrevSinaIndex := -1;
    tmpPrevSinaDate := -1;
    tmpPrev163Index := 1;
    
    while (tmpIdx163 < ARepairSession.StockData163.RecordCount) and
          (tmpIdxSina < ARepairSession.StockDataSina.RecordCount) do
    begin
      tmpStockData_163 := ARepairSession.StockData163.RecordItem[tmpIdx163];
      tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[tmpIdxSina];
      if tmpStockData_163.DealDate.Value = tmpStockData_Sina.DealDate.Value then
      begin
        if (-1 <> tmpPrevSinaIndex) and
           (-1 <> tmpPrevSinaWeight) and
           (-1 <> tmpPrevSinaDate) and
           (-1 <> tmpPrev163Index) then
        begin                      
          DecodeDate(tmpPrevSinaDate, tmpYear, tmpMonth, tmpDay);

          if tmpPrevSinaWeight = tmpStockData_Sina.Weight.Value then
          begin
            // 权重值没有改变
            // 修复失去数据的时间区间
            //RepairStockDayData();
            RepairDayData_Sina_Mode2(ARepairSession, tmpPrev163Index, tmpPrevSinaIndex, tmpIdxSina);
          end;
          tmpPrevSinaWeight := -1;
          tmpPrevSinaIndex := -1;
          tmpPrevSinaDate := -1;
          tmpPrev163Index := -1;   
        end;
        tmpLastSinaWeight := tmpStockData_Sina.Weight.Value;
        tmpLastSinaIndex := tmpIdxSina;
        tmpLastSinaDate := tmpStockData_Sina.DealDate.Value;
        tmpLast163Index := tmpIdx163;

        Inc(tmpIdx163);
        Inc(tmpIdxSina);
      end else
      begin
        if tmpStockData_163.DealDate.Value > tmpStockData_Sina.DealDate.Value then
        begin                
          DecodeDate(tmpStockData_Sina.DealDate.Value, tmpYear, tmpMonth, tmpDay);
          if 0 <> tmpYear then
          begin
          end;
          Inc(tmpIdxSina);
        end else
        begin
          // sina 漏了数据了      
          if (-1 = tmpPrevSinaIndex) and
             (-1 = tmpPrevSinaWeight) and
             (-1 = tmpPrevSinaDate)then
          begin
            tmpPrevSinaIndex := tmpLastSinaIndex;
            tmpPrevSinaWeight := tmpLastSinaWeight;
            tmpPrevSinaDate := tmpLastSinaDate;
            tmpPrev163Index := tmpLast163Index;
          end;
          
          DecodeDate(tmpStockData_163.DealDate.Value, tmpYear, tmpMonth, tmpDay);
          tmpJidu := SeasonOfMonth(tmpMonth);
          if 1988 < tmpYear then
          begin
            tmpSeason := IntToStr(tmpYear) + '_' + IntToStr(tmpJidu);
            if tmpUpdateTimes.IndexOf(tmpSeason) < 0 then
            begin
              tmpUpdateTimes.Add(tmpSeason);
            end;
          end;
          Inc(tmpIdx163);
        end;
      end;
    end;
    if 0 < tmpUpdateTimes.Count then
    begin
      Log('Repair', ARepairSession.StockItem.sCode + ':' + IntToStr(tmpUpdateTimes.Count));
      for i := 0 to tmpUpdateTimes.Count - 1 do
      begin
        tmpSeason := tmpUpdateTimes[i];
        tmpYear := StrToIntDef(Copy(tmpSeason, 1, 4), 0);
        tmpJidu := StrToIntDef(Copy(tmpSeason, 6, maxint), 0);
        Sleep(500);
      end;
      ARepairSession.StockDataSina.Sort;
      SaveStockDayData(App, ARepairSession.StockDataSina);
      Result := True;
    end;
    if 0 = ARepairSession.StockItem.FirstDealDate then
    begin
      if 0 < ARepairSession.StockDataSina.RecordCount then
      begin
        tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[0];
        ARepairSession.StockItem.FirstDealDate := tmpStockData_Sina.DealDate.Value;
        ARepairSession.StockItem.IsDataChange := 1;
      end;
    end;   
  finally
    tmpUpdateTimes.Free;
  end;
end;
                
end.
