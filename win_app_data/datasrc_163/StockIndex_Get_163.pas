unit StockIndex_Get_163;

interface

uses
  BaseApp;

  procedure GetStockIndexData_163_All(App: TBaseApp);

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
  StockIndexData_Get_163,
  win.iobuffer,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
  DB_dealItem_LoadIni,
  DB_dealItem_Save;
         
procedure GetStockIndexData_163_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  tmpIsNeedSaveStockItemDB: Boolean;
  tmpHttpClientSession: THttpClientSession;
  i: integer;
  tmpDealItem: PRT_DealItem;
  tmpFileUrl: string;
begin
  FillChar(tmpHttpClientSession, SizeOf(tmpHttpClientSession), 0);
  tmpHttpClientSession.IsKeepAlive := true;
  
  tmpIsNeedSaveStockItemDB := false;
  tmpDBStockItem := TDBDealItem.Create;
  try
    //LoadDBStockItemDic(App, tmpDBStockItem);
    tmpFileUrl := ChangeFileExt(ParamStr(0), '.ini');
    LoadDBStockItemIniFromFile(App, tmpDBStockItem, tmpFileUrl);
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
        if GetStockIndexData_163(App, tmpDealItem, false, @tmpHttpClientSession) then
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
      //SaveDBStockItem(App, tmpDBStockItem);
      SaveDBStockItemIniToFile(App, tmpDBStockItem, tmpFileUrl);
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
