unit StockDetail_PackApp;

interface

uses
  BaseApp,
  BaseStockApp;
            
type
  TStockDetailPackApp = class(TBaseStockApp)
  protected
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
  end;

implementation

uses          
  define_dealitem,           
  DB_DealItem,
  DB_DealItem_Load,    
  StockDetailDataAccess,
  StockDetailData_Load;

{ TStockDay163App }

constructor TStockDetailPackApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

procedure StockDetailPack_Item(App: TBaseApp; AStockItem: PRT_DealItem);
begin

end;

procedure TStockDetailPackApp.Run;  
var
  tmpDBStockItem: TDBDealItem;
  i: integer;
begin       
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(Self, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin
        StockDetailPack_Item(Self, tmpDBStockItem.Items[i]);
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
