unit StockDay_Get_Sina;

interface

uses          
  Define_Price,
  BaseApp;

  procedure GetStockDataDay_Sina_All(App: TBaseApp; AWeightMode: TWeightMode);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_DealItem,
  Define_DataSrc,    
  define_stock_quotes,
  StockDayData_Get_Sina,
     
  UtilsDateTime,   
  //UtilsLog,
  
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;                 
                    

procedure GetStockDataDay_Sina_All(App: TBaseApp; AWeightMode: TWeightMode);
var
  tmpDBStockItem: TDBDealItem;
  tmpNetClientSession: THttpClientSession;
  i: integer;
  tmpDealItem: PRT_DealItem;
begin
  FillChar(tmpNetClientSession, SizeOf(tmpNetClientSession), 0);
  tmpNetClientSession.IsKeepAlive := true;
  tmpNetClientSession.ConnectionSession.ConnectTimeOut := 5000;
  tmpNetClientSession.ConnectionSession.ReceiveTimeOut := 10000;
  tmpNetClientSession.ConnectionSession.SendTimeOut := 1000;

  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      tmpDealItem := tmpDBStockItem.Items[i];
      if 0 = tmpDealItem.EndDealDate then
      begin                                        
        if GetStockDataDay_Sina(App, tmpDealItem, AWeightMode, @tmpNetClientSession) then
        begin
          //Log('', 'GetStockDataDay_Sina ' + tmpDealItem.sCode + ' Succ');
          Sleep(100);
        end else
        begin
          //Log('', 'GetStockDataDay_Sina ' + tmpDealItem.sCode + ' Fail');
        end;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
