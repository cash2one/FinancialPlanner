unit StockDayData_Get_Sina_RepairCheck;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  win.iobuffer,
  define_dealitem,
  StockDayDataAccess;
  
function CheckStockDataDay_Sina_Repair(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  Windows,
  define_price,         
  Define_DataSrc,    
  define_stock_quotes,
  UtilsDateTime,
  UtilsLog,  
  StockDayData_Load;

function CheckStockDataDay_Sina_Repair(App: TBaseApp; AStockItem: PRT_DealItem; AIsWeight: Boolean; ANetSession: PHttpClientSession): Boolean;
var
  tmpStockDataSina: TStockDayDataAccess;
  tmpStockData163: TStockDayDataAccess;   
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
  tmpStockDataSina := TStockDayDataAccess.Create(AStockItem, DataSrc_Sina, AIsWeight);
  tmpStockData163 := TStockDayDataAccess.Create(AStockItem, DataSrc_163, false);
  tmpUpdateTimes := TStringList.Create;
  try                
    StockDayData_Load.LoadStockDayData(App, tmpStockData163);
    StockDayData_Load.LoadStockDayData(App, tmpStockDataSina);
    if 1 > tmpStockData163.RecordCount then
      exit;

    if tmpStockData163.RecordCount <= tmpStockDataSina.RecordCount then
      exit;
    tmpStockData163.Sort;
    tmpStockDataSina.Sort;
    tmpIdx163 := 0;
    tmpIdxSina := 0;
    while (tmpIdx163 < tmpStockData163.RecordCount) and
          (tmpIdxSina < tmpStockDataSina.RecordCount) do
    begin
      tmpStockData_163 := tmpStockData163.RecordItem[tmpIdx163];
      tmpStockData_Sina := tmpStockDataSina.RecordItem[tmpIdxSina];
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
              Log('RepairDate:', AStockItem.sCode + ':' + FormatDateTime('yyyy/mm/dd', tmpStockData_163.DealDate.Value));
              tmpUpdateTimes.Add(tmpSeason);
            end;
          end;
          Inc(tmpIdx163);
        end;
      end;
    end;
    if 0 < tmpUpdateTimes.Count then
    begin
      Result := True;
    end;
  finally
    tmpUpdateTimes.Free;
    tmpStockDataSina.Free;
    tmpStockData163.Free;
  end;
end;

end.
