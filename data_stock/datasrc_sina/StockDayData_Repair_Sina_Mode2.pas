unit StockDayData_Repair_Sina_Mode2;

interface

uses
  BaseApp,
  Sysutils,
  define_dealitem,
  StockDayDataAccess;
         
type
  PRepairSession = ^TRepairSession;
  TRepairSession = record
    StockDataSina: TStockDayDataAccess;
    StockData163: TStockDayDataAccess;
  end;
  
function RepairStockDataDay_Sina_Mode2(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ARepairSession: PRepairSession): Boolean;

implementation

uses
  Classes,
  Windows,
  define_price,         
  Define_DataSrc,    
  define_stock_quotes,
  UtilsDateTime,
  UtilsLog,  
  StockDayData_Load,
  StockDayData_Save;
    
function RepairStockDataDay_Sina_Mode2(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ARepairSession: PRepairSession): Boolean;
var 
  tmpYear, tmpMonth, tmpDay: Word;   
  tmpJidu: integer;
  
  tmpUpdateTimes: TStringList;   
  tmpStockData_163: PRT_Quote_M1_Day;   
  tmpStockData_Sina: PRT_Quote_M1_Day;
  tmpIdx163, tmpIdxSina: integer;
  tmpSeason: string;
  i: integer;
begin
  Result := false;
  if nil = ARepairSession.StockDataSina then
    ARepairSession.StockDataSina := TStockDayDataAccess.Create(AStockItem, DataSrc_Sina, AIsWeight);
  if nil = ARepairSession.StockData163 then
    ARepairSession.StockData163 := TStockDayDataAccess.Create(AStockItem, DataSrc_163, false);
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
    while (tmpIdx163 < ARepairSession.StockData163.RecordCount) and
          (tmpIdxSina < ARepairSession.StockDataSina.RecordCount) do
    begin
      tmpStockData_163 := ARepairSession.StockData163.RecordItem[tmpIdx163];
      tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[tmpIdxSina];
      if tmpStockData_163.DealDate.Value = tmpStockData_Sina.DealDate.Value then
      begin
        Inc(tmpIdx163);
        Inc(tmpIdxSina);
      end else
      begin
        if tmpStockData_163.DealDate.Value > tmpStockData_Sina.DealDate.Value then
        begin
          Inc(tmpIdxSina);
        end else
        begin
          // sina 漏了数据了
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
      Log('Repair', AStockItem.sCode + ':' + IntToStr(tmpUpdateTimes.Count));
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
    if 0 = AStockItem.FirstDealDate then
    begin
      if 0 < ARepairSession.StockDataSina.RecordCount then
      begin
        tmpStockData_Sina := ARepairSession.StockDataSina.RecordItem[0];
        AStockItem.FirstDealDate := tmpStockData_Sina.DealDate.Value;
        AStockItem.IsDataChange := 1;
      end;
    end;   
  finally
    tmpUpdateTimes.Free;
  end;
end;
                
end.
