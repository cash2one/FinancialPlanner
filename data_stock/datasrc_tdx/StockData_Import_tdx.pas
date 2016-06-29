unit StockData_Import_tdx;

interface

uses
  BaseApp,
  define_dealitem,
  define_price;
                     
  function ImportStockData_TDX(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode): Boolean;

implementation

function ImportStockData_TDX(App: TBaseApp; AStockItem: PRT_DealItem; AWeightMode: TWeightMode): Boolean;
begin

end;

end.
