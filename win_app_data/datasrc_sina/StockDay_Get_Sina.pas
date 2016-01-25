unit StockDay_Get_Sina;

interface

uses
  BaseApp;

  procedure GetStockDataDay_Sina_All(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,    
  define_stock_quotes,
  StockDayData_Get_Sina,
     
  UtilsHtmlParser,
  UtilsDateTime,
  
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;                 
                    

procedure GetStockDataDay_Sina_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  i: integer;
begin
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItem(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin
        if GetStockDataDay_Sina(App, tmpDBStockItem.Items[i], true) then
        begin
          Sleep(2000);
        end;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.