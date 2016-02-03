unit StockDetail_Get_Sina;

interface

uses
  BaseApp;

  procedure GetStockDataDetail_Sina_All(App: TBaseApp);

implementation

uses
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;                 
                    

procedure GetStockDataDetail_Sina_All(App: TBaseApp);
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
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
