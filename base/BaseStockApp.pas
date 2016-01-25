unit BaseStockApp;

interface

uses
  BaseWinApp, BaseApp, db_dealitem;
  
type
  TBaseStockAppData = record
    StockItemDB: TDBDealItem;
  end;
  
  TBaseStockApp = class(TBaseWinApp)
  protected
    fBaseStockAppData: TBaseStockAppData; 
    function GetPath: TBaseAppPath; override;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;     
    procedure InitializeDBStockItem;    
    property StockItemDB: TDBDealItem read fBaseStockAppData.StockItemDB;
  end;

implementation

uses
  StockAppPath,
  db_dealitem_Load;
                     
constructor TBaseStockApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fBaseStockAppData, SizeOf(fBaseStockAppData), 0);
end;

destructor TBaseStockApp.Destroy;
begin
  if nil <> fBaseStockAppData.StockItemDB then
  begin
    fBaseStockAppData.StockItemDB.Free;
    fBaseStockAppData.StockItemDB := nil;
  end;
  inherited;
end;

function TBaseStockApp.GetPath: TBaseAppPath;
begin
  if nil = fBaseWinAppData.AppPath then
    fBaseWinAppData.AppPath := TStockAppPath.Create(Self);
  Result := fBaseWinAppData.AppPath;
end;
              
procedure TBaseStockApp.InitializeDBStockItem;
begin              
  if nil = fBaseStockAppData.StockItemDB then
  begin              
    fBaseStockAppData.StockItemDB := TDBDealItem.Create;
    db_dealitem_Load.LoadDBStockItem(Self, fBaseStockAppData.StockItemDB);
  end;
end;

end.
