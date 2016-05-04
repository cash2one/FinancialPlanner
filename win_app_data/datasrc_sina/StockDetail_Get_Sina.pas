unit StockDetail_Get_Sina;

interface

uses
  BaseApp;

  procedure GetStockDataDetail_Sina_All(App: TBaseApp);

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
  StockDetailData_Get_Sina;                 
                    
procedure DownloadDealItemDayDetailData(App: TBaseApp; AStockItem: PRT_DealItem; AHttpClientSession: PHttpClientSession);
var
  tmpDayData: TStockDayDataAccess;
begin                   
  tmpDayData := TStockDayDataAccess.Create(AStockItem, DataSrc_163, false);
  try                   
    if LoadStockDayData(App, tmpDayData) then
    begin
      GetStockDataDetail_Sina(App, tmpDayData, AHttpClientSession);
    end;
  except
    tmpDayData.Free;
  end;
end;
  
procedure GetStockDataDetail_Sina_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  tmpHttpClientSession: THttpClientSession;
  i: integer;
begin
  FillChar(tmpHttpClientSession, SizeOf(tmpHttpClientSession), 0);
  tmpHttpClientSession.IsKeepAlive := true;
  
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin
        DownloadDealItemDayDetailData(App, tmpDBStockItem.Items[i], @tmpHttpClientSession);
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
