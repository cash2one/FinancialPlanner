unit UIDealItemNode;

interface

uses
  define_DealItem, StockDayDataAccess,
  Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA;
  
type  
  PStockItemNode = ^TStockItemNode;
  TStockItemNode = record
    StockItem: PRT_DealItem;
    StockDayDataAccess: TStockDayDataAccess;
    Rule_BDZX_Price: TRule_BDZX_Price;  
    Rule_CYHT_Price: TRule_CYHT_Price;  
    Rule_Boll: TRule_Boll_Price;
  end;
  
implementation

end.
