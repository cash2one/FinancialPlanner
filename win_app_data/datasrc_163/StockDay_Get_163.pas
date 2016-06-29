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
  tmpHttpClientSession: THttpClientSession;
  i: integer;
  tmpDealItem: PRT_DealItem;
begin
  FillChar(tmpHttpClientSession, SizeOf(tmpHttpClientSession), 0);
  tmpHttpClientSession.IsKeepAlive := true;
  
  tmpIsNeedSaveStockItemDB := false;
  tmpDBStockItem := TDBDealItem.Create;
  try
    //LoadDBStockItemIni(App, tmpDBStockItem1);
    //SaveDBStockItem(App, tmpDBStockItem1);
    //exit;
    LoadDBStockItemDic(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      tmpDealItem := tmpDBStockItem.Items[i];
      if 0 = tmpDealItem.EndDealDate then
      begin              
        if 0 = tmpDealItem.FirstDealDate then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
        tmpDealItem.IsDataChange := 0;
        if GetStockDataDay_163(App, tmpDealItem, weightNone, @tmpHttpClientSession) then
        begin
          Sleep(2000);
        end;                                      
        if 0 <> tmpDealItem.IsDataChange then
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
