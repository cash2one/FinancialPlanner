unit StockDay_Get_163;

interface

uses
  BaseApp;

  procedure GetStockDataDay_163_All(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  db_dealitem,
  define_dealItem,
  Define_DataSrc,
  StockDayData_Get_163,
  win.iobuffer,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
  DB_dealItem_Load,
  DB_dealItem_Save;
         
procedure GetStockDataDay_163_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  tmpIsNeedSaveStockItemDB: Boolean;
  tmpNetClientSession: TNetClientSession;
  i: integer;
begin
  FillChar(tmpNetClientSession, SizeOf(tmpNetClientSession), 0);
  tmpIsNeedSaveStockItemDB := false;
  tmpDBStockItem := TDBDealItem.Create;
  try
    //LoadDBStockItemIni(App, tmpDBStockItem1);
    //SaveDBStockItem(App, tmpDBStockItem1);
    //exit;
    LoadDBStockItem(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin              
        if 0 = tmpDBStockItem.Items[i].FirstDealDate then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
        tmpDBStockItem.Items[i].IsDataChange := 0;
        if GetStockDataDay_163(App, tmpDBStockItem.Items[i], false, @tmpNetClientSession) then
        begin
          Sleep(2000);
        end;                                      
        if 0 <> tmpDBStockItem.Items[i].IsDataChange then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
      end;
    end;
    if tmpIsNeedSaveStockItemDB then
    begin
      SaveDBStockItem(App, tmpDBStockItem);
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
