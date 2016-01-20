unit futuresData_get_ctp;

interface

uses
  BaseApp;

  procedure GetFuturesData_ctp(App: TBaseApp);

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
     
  UtilsDateTime,
  
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;
     
procedure GetFuturesData_ctp(App: TBaseApp);
begin
end;

end.
