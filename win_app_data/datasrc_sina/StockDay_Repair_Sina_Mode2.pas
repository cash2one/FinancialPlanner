unit StockDay_Repair_Sina_Mode2;

interface

uses      
  Define_Price,
  BaseApp;

  procedure RepairStockDataDay_Sina_All_Mode2(App: TBaseApp; AWeightMode: TWeightMode);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  Define_DealItem,
  Define_DataSrc,    
  define_stock_quotes,
  StockDayData_Repair_Sina_Mode2,
  UtilsDateTime,   
  //UtilsLog,
  StockDayDataAccess,
  DB_DealItem,
  DB_DealItem_Load;                 
                    

procedure RepairStockDataDay_Sina_All_Mode2(App: TBaseApp; AWeightMode: TWeightMode);
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
          tmpRepairSession.StockItem := tmpDealItem;
          tmpRepairSession.WeightMode := AWeightMode;
          if RepairStockDataDay_Sina_Mode2(App, @tmpRepairSession) then
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
