unit StockDetail_Get_163;

interface

uses
  BaseApp;

  procedure GetStockDataDetail_163_All(App: TBaseApp);

implementation

uses
  define_datasrc,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save,    
  define_dealitem,  
  UtilsHttp,
  StockDayDataAccess,
  StockDayData_Load,
  StockDetailData_Get_163;                 
                    
procedure DownloadDealItemDayDetailData(App: TBaseApp; AStockItem: PRT_DealItem; ANetSession: PNetClientSession);
var
  tmpDayData: TStockDayDataAccess;
begin                   
  tmpDayData := TStockDayDataAccess.Create(AStockItem, DataSrc_163);
  try                   
    if LoadStockDayData(App, tmpDayData) then
    begin
      GetStockDataDetail_163(App, AStockItem, ANetSession);
    end;
  except
    tmpDayData.Free;
  end;
end;
  
procedure GetStockDataDetail_163_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  tmpNetClientSession: TNetClientSession;
  i: integer;
begin
  FillChar(tmpNetClientSession, SizeOf(tmpNetClientSession), 0);
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItem(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin
        DownloadDealItemDayDetailData(App, tmpDBStockItem.Items[i], @tmpNetClientSession);
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
