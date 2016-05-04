unit BaseStockApp;

interface

uses
  BaseWinApp, BaseApp, 
  StockAppPath, db_dealitem;
  
type
  TBaseStockAppData = record
    StockItemDB: TDBDealItem;
  end;
  
  TBaseStockApp = class(TBaseWinApp)
  protected
    fBaseStockAppData: TBaseStockAppData; 
    function GetPath: TBaseAppPath; override;
    function GetStockAppPath: TStockAppPath;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;     
    procedure InitializeDBStockItem(AIsLoadDBStockItemDic: Boolean = True);    
    property StockItemDB: TDBDealItem read fBaseStockAppData.StockItemDB;
    property StockAppPath: TStockAppPath read GetStockAppPath;
  end;

var
  GlobalBaseStockApp: TBaseStockApp = nil;
    
implementation

uses
  db_dealitem_Load;
                     
constructor TBaseStockApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fBaseStockAppData, SizeOf(fBaseStockAppData), 0);
  GlobalBaseStockApp := Self;
end;

destructor TBaseStockApp.Destroy;
begin
  if GlobalBaseStockApp = Self then
    GlobalBaseStockApp := nil;
  if nil <> fBaseStockAppData.StockItemDB then
  begin
    fBaseStockAppData.StockItemDB.Free;
    fBaseStockAppData.StockItemDB := nil;
  end;
  inherited;
end;

function TBaseStockApp.GetPath: TBaseAppPath;
begin
  Result := GetStockAppPath;
end;

function TBaseStockApp.GetStockAppPath: TStockAppPath;
begin
  if nil = fBaseWinAppData.AppPath then
    fBaseWinAppData.AppPath := TStockAppPath.Create(Self);
  Result := TStockAppPath(fBaseWinAppData.AppPath);
end;

procedure TBaseStockApp.InitializeDBStockItem(AIsLoadDBStockItemDic: Boolean = True);
begin              
  if nil = fBaseStockAppData.StockItemDB then
  begin              
    fBaseStockAppData.StockItemDB := TDBDealItem.Create;
    if AIsLoadDBStockItemDic then
    begin
      db_dealitem_Load.LoadDBStockItemDic(Self, fBaseStockAppData.StockItemDB);
    end;
  end;
end;

end.
