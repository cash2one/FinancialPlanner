unit SDRepairForm;

interface

uses
  Windows, Forms, Classes, Controls, VirtualTrees, ExtCtrls,
  BaseForm, BaseApp, DealItemsTreeView;

type
  TRepairFormData = record
    TreeCtrl: TDealItemTreeCtrl;
  end;

  TfrmSDRepair = class(TfrmBase)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlMain: TPanel;
    pnlStocks: TPanel;
    vtStocks: TVirtualStringTree;
    vtDayData: TVirtualStringTree;
    procedure vtStocksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  private
    { Private declarations }    
    fRepairFormData: TRepairFormData;
    procedure InitializeStockListTree;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(App: TBaseApp); override;     
  end;

implementation

{$R *.dfm}

uses
  BaseStockApp,
  define_dealitem;
  
type
  PStockItemNode = ^TStockItemNode;
  TStockItemNode = record
    StockItem: PRT_DealItem;
  end;
  
{ TfrmSDRepair }

constructor TfrmSDRepair.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fRepairFormData, SizeOf(fRepairFormData), 0);
end;

destructor TfrmSDRepair.Destroy;
begin

  inherited;
end;

procedure TfrmSDRepair.Initialize(App: TBaseApp);
begin
  inherited;
  vtStocks.NodeDataSize := SizeOf(TStockItemNode);
  vtStocks.OnGetText := vtStocksGetText;
  InitializeStockListTree;
end;

procedure TfrmSDRepair.InitializeStockListTree;     
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpNode: PVirtualNode;
  tmpNodeData: PStockItemNode;
begin
  if nil = fRepairFormData.TreeCtrl then
  begin
    fRepairFormData.TreeCtrl := TDealItemTreeCtrl.Create(nil);
    fRepairFormData.TreeCtrl.InitializeDealItemsTree(vtStocks);
  end;
  for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
  begin
    tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];   
    if 0 = tmpStockItem.EndDealDate then
    begin
      tmpNode := vtStocks.AddChild(nil);
      tmpNodeData := vtStocks.GetNodeData(tmpNode);
      tmpNodeData.StockItem := tmpStockItem;
    end;
  end;
end;

procedure TfrmSDRepair.vtStocksGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  inherited;
//
end;

end.
