unit Futures_Get_Sina;

interface

uses
  BaseApp;

  procedure GetFuturesData_Sina_All(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,    
  define_futures_quotes,
  FuturesData_Get_Sina,
     
  UtilsDateTime,
  
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;

procedure GetFuturesData_Sina_All(App: TBaseApp);
var
  tmpDBDealItem: TDBDealItem;  
  tmpNetClientSession: TNetClientSession;
  i: integer;
begin              
  FillChar(tmpNetClientSession, SizeOf(tmpNetClientSession), 0);
  tmpDBDealItem := TDBDealItem.Create;
  try                
    tmpDBDealItem.AddItem('', 'IF1606');
          
    for i := 0 to tmpDBDealItem.RecordCount - 1 do
    begin
      if GetFuturesData_Sina_5m(App, tmpDBDealItem.Items[i], @tmpNetClientSession) then
      begin
        Sleep(2000);
      end;
    end;
  finally
    tmpDBDealItem.Free;
  end;
end;

end.
