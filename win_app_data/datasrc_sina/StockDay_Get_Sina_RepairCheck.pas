unit StockDay_Get_Sina_RepairCheck;

interface

uses
  BaseApp;

  procedure CheckStockDataDay_Sina_All_Repair(App: TBaseApp; AIsWeight: Boolean);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,    
  define_stock_quotes,
  StockDayData_Get_Sina_RepairCheck,     
  UtilsDateTime,   
  //UtilsLog,         
  StockDayDataAccess,
  StockDayData_Load,
  DB_DealItem,
  DB_DealItem_Load;                 
                    

procedure CheckStockDataDay_Sina_All_Repair(App: TBaseApp; AIsWeight: Boolean);
var
  tmpDBStockItem: TDBDealItem;
  i: integer;
  tmpDealItem: PRT_DealItem;
  tmpRepeat: Integer;
begin
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      tmpDealItem := tmpDBStockItem.Items[i];
      if 0 = tmpDealItem.EndDealDate then
      begin
        if CheckStockDataDay_Sina_Repair(App, tmpDealItem, AIsWeight) then
        begin
        end;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
