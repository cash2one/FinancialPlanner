unit StockDetail_Get_Sina;

interface

uses
  BaseApp;

  procedure GetStockDataDetail_Sina_All(App: TBaseApp);

implementation

uses
  Windows,
  define_datasrc,  
  define_price,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save,    
  define_dealitem,  
  UtilsHttp,       
  UtilsLog,
  StockDayDataAccess,
  StockDayData_Load,
  StockDetailData_Get_Sina;                 
                    
procedure DownloadDealItemDayDetailData(App: TBaseApp; AStockItem: PRT_DealItem; AHttpClientSession: PHttpClientSession);
var
  tmpDayData: TStockDayDataAccess;
begin                   
  tmpDayData := TStockDayDataAccess.Create(AStockItem, DataSrc_163, weightNone);
  try
    try
      if LoadStockDayData(App, tmpDayData) then
      begin
        Log('', 'Dowload Stock Detail:' + AStockItem.sCode);
        if GetStockDataDetail_Sina(App, tmpDayData, AHttpClientSession) then
        begin
          Log('', 'Dowload Stock Detail ok:' + AStockItem.sCode);
          Sleep(500);
        end;
      end;
    except
    end;
  finally
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
