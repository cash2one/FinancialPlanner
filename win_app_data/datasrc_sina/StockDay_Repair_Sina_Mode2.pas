unit StockDay_Repair_Sina_Mode2;

interface

uses
  BaseApp;

  procedure RepairStockDataDay_Sina_All_Mode2(App: TBaseApp; AIsWeight: Boolean);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,    
  define_stock_quotes,
  StockDayData_Repair_Sina_Mode2,
     
  UtilsDateTime,   
  //UtilsLog,
  
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;                 
                    

procedure RepairStockDataDay_Sina_All_Mode2(App: TBaseApp; AIsWeight: Boolean);
var
  tmpDBStockItem: TDBDealItem;
  tmpRepairSession: TRepairSession;
  i: integer;
  tmpDealItem: PRT_DealItem;
  tmpRepeat: Integer;
begin
  FillChar(tmpRepairSession, SizeOf(tmpRepairSession), 0);

  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      tmpDealItem := tmpDBStockItem.Items[i];
      if 0 = tmpDealItem.EndDealDate then
      begin
        try            
          if nil <> tmpRepairSession.StockDataSina then
            FreeAndNil(tmpRepairSession.StockDataSina);
          if nil <> tmpRepairSession.StockData163 then
            FreeAndNil(tmpRepairSession.StockData163);
          if RepairStockDataDay_Sina_Mode2(App, tmpDealItem, AIsWeight, @tmpRepairSession) then
          begin
            Sleep(200);
          end;
        finally
          if nil <> tmpRepairSession.StockDataSina then
            FreeAndNil(tmpRepairSession.StockDataSina);
          if nil <> tmpRepairSession.StockData163 then
            FreeAndNil(tmpRepairSession.StockData163);
        end;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
