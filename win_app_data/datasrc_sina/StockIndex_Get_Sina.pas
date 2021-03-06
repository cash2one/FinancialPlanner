unit StockIndex_Get_Sina;

interface

uses
  BaseApp;

  procedure GetStockIndexData_Sina_All(App: TBaseApp; AIsWeight: Boolean);

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
  StockIndexData_Get_Sina,
     
  UtilsDateTime,   
  //UtilsLog,
  
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  DB_DealItem,
  DB_DealItem_LoadIni,
  DB_DealItem_Save;                 
                    

procedure GetStockIndexData_Sina_All(App: TBaseApp; AIsWeight: Boolean);
var
  tmpDBStockItem: TDBDealItem;
  tmpNetClientSession: THttpClientSession;
  i: integer;
  tmpDealItem: PRT_DealItem;      
  tmpFileUrl: string;
begin
  FillChar(tmpNetClientSession, SizeOf(tmpNetClientSession), 0);
  tmpNetClientSession.IsKeepAlive := true;
  tmpNetClientSession.ConnectionSession.ConnectTimeOut := 5000;
  tmpNetClientSession.ConnectionSession.ReceiveTimeOut := 5000;
  tmpNetClientSession.ConnectionSession.SendTimeOut := 1000;

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
        if GetStockIndexData_Sina(App, tmpDealItem, AIsWeight, @tmpNetClientSession) then
        begin
          //Log('', 'GetStockDataDay_Sina ' + tmpDealItem.sCode + ' Succ');
          Sleep(2000);
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
