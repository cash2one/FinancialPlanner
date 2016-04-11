unit FormDataHostViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  BaseApp, BaseForm, VirtualTrees, ExtCtrls, Tabs,
  db_dealItem, StockDayDataAccess,
  FrameDataViewer, FrameDayChartViewer, UIDealItemNode,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA;

type
  TDataViewerData = record
    FrameDataViewer: TfmeDataViewer;
    FrameChartViewer: TfmeDayChartViewer;
    ActiveFrame: TfrmBase;
    Rule_CYHT_Price: TRule_CYHT_Price;
    Rule_BDZX_Price: TRule_BDZX_Price;
    Rule_Boll: TRule_Boll_Price;
    
    StockDayDataAccess: TStockDayDataAccess; 
    IsWeight: Boolean;
  end;

  TfrmDataViewer = class(TfrmBase)
    pnMain: TPanel;
    pnStocks: TPanel;
    split1: TSplitter;
    vtStocks: TVirtualStringTree;
    pnTop: TPanel;
    pnData: TPanel;
    ts1: TTabSet;
    procedure vtStocksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtStocksClick(Sender: TObject);
    procedure ts1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  protected
    fDataViewerData: TDataViewerData;     
    function DoGetStockDealDays: integer;
    function DoGetStockClosePrice(AIndex: integer): double;     
    function DoGetStockOpenPrice(AIndex: integer): double;
    function DoGetStockHighPrice(AIndex: integer): double;
    function DoGetStockLowPrice(AIndex: integer): double;
  public                        
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(App: TBaseApp); override;     
    procedure InitializeStockListTree;
  end;
                                               
  procedure CreateMainForm(var AForm: TfrmBase);

implementation

{$R *.dfm}

uses
  BaseStockApp,
  Define_DataSrc,
  define_DealItem,
  define_stock_quotes,
  StockDayData_Load,
  db_dealItem_Load;
      
procedure CreateMainForm(var AForm: TfrmBase);
begin
  Application.CreateForm(TfrmDataViewer, AForm);
end;

{ TfrmDataViewer }
                       
constructor TfrmDataViewer.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fDataViewerData, SizeOf(fDataViewerData), 0);
  ts1.Tabs.Clear;
end;

destructor TfrmDataViewer.Destroy;
begin
  inherited;
end;
                                  
procedure TfrmDataViewer.Initialize(App: TBaseApp);
begin
  inherited;
  vtStocks.NodeDataSize := SizeOf(TStockItemNode);
  vtStocks.OnGetText := vtStocksGetText;
  InitializeStockListTree;
                    
  if nil = fDataViewerData.FrameDataViewer then
  begin
    fDataViewerData.FrameDataViewer := TfmeDataViewer.Create(Self);
    fDataViewerData.FrameDataViewer.Initialize(App);

    fDataViewerData.FrameDataViewer.Parent := pnData;
    fDataViewerData.FrameDataViewer.BorderStyle := bsNone;
    fDataViewerData.FrameDataViewer.Align := alClient;
    fDataViewerData.FrameDataViewer.Initialize(App);
    ts1.Tabs.AddObject('明细数据', fDataViewerData.FrameDataViewer);
  end;          
  if nil = fDataViewerData.FrameChartViewer then
  begin                                   
    fDataViewerData.FrameChartViewer := TfmeDayChartViewer.Create(Self);
    fDataViewerData.FrameChartViewer.Initialize(App);
    fDataViewerData.FrameChartViewer.Parent := pnData;
    fDataViewerData.FrameChartViewer.BorderStyle := bsNone;
    fDataViewerData.FrameChartViewer.Align := alClient;
    fDataViewerData.FrameChartViewer.Initialize(App);
    ts1.Tabs.AddObject('日线', fDataViewerData.FrameChartViewer);
  end;
  ts1.TabIndex := 0;
end;

procedure TfrmDataViewer.ts1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if nil <> fDataViewerData.ActiveFrame then
  begin
    fDataViewerData.ActiveFrame.Hide;
  end;
  fDataViewerData.ActiveFrame := TfrmBase(ts1.Tabs.Objects[NewTab]);
  if nil <> fDataViewerData.ActiveFrame then
  begin
    fDataViewerData.ActiveFrame.Visible := true;
  end;
end;


procedure TfrmDataViewer.InitializeStockListTree;
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpNode: PVirtualNode;
  tmpNodeData: PStockItemNode;
begin
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

procedure TfrmDataViewer.vtStocksClick(Sender: TObject);  
var
  tmpNodeData: PStockItemNode;
begin
  if nil <> vtStocks.FocusedNode then
  begin                 
    tmpNodeData := vtStocks.GetNodeData(vtStocks.FocusedNode);
    if (nil <> tmpNodeData) and (nil <> tmpNodeData.StockItem) then
    begin                                        
      if nil <> fDataViewerData.StockDayDataAccess then
        FreeAndNil(fDataViewerData.StockDayDataAccess);
      fDataViewerData.StockDayDataAccess := TStockDayDataAccess.Create(tmpNodeData.StockItem, DataSrc_163, fDataViewerData.IsWeight);    
      StockDayData_Load.LoadStockDayData(App, fDataViewerData.StockDayDataAccess);
      tmpNodeData.StockDayDataAccess := fDataViewerData.StockDayDataAccess;
                                                                 
      if nil <> fDataViewerData.Rule_CYHT_Price then
      begin
        FreeAndNil(fDataViewerData.Rule_CYHT_Price);
      end;
      fDataViewerData.Rule_CYHT_Price := TRule_CYHT_Price.Create();
      if nil <> fDataViewerData.Rule_Boll then
      begin
        FreeAndNil(fDataViewerData.Rule_Boll);
      end;
      fDataViewerData.Rule_Boll := TRule_Boll_Price.Create();
      
      tmpNodeData.Rule_CYHT_Price := fDataViewerData.Rule_CYHT_Price; 
      tmpNodeData.Rule_CYHT_Price.OnGetDataLength := DoGetStockDealDays;
      tmpNodeData.Rule_CYHT_Price.OnGetPriceOpen := DoGetStockOpenPrice;
      tmpNodeData.Rule_CYHT_Price.OnGetPriceClose := DoGetStockClosePrice;
      tmpNodeData.Rule_CYHT_Price.OnGetPriceHigh := DoGetStockHighPrice;
      tmpNodeData.Rule_CYHT_Price.OnGetPriceLow := DoGetStockLowPrice;
      tmpNodeData.Rule_CYHT_Price.Execute;
                                 
      tmpNodeData.Rule_Boll := fDataViewerData.Rule_Boll;
      tmpNodeData.Rule_Boll.OnGetDataLength := DoGetStockDealDays;
      tmpNodeData.Rule_Boll.OnGetDataF := DoGetStockClosePrice;
      tmpNodeData.Rule_Boll.Execute;
      (*//
      if nil <> fDataViewerData.Rule_BDZX_Price then
      begin
        FreeAndNil(fDataViewerData.Rule_BDZX_Price);
      end;
      fDataViewerData.Rule_BDZX_Price := TRule_BDZX_Price.Create();
      tmpNodeData.Rule_BDZX_Price := fDataViewerData.Rule_BDZX_Price;
      
      tmpNodeData.Rule_BDZX_Price.OnGetDataLength := DoGetStockDealDays;
      tmpNodeData.Rule_BDZX_Price.OnGetPriceOpen := DoGetStockOpenPrice;
      tmpNodeData.Rule_BDZX_Price.OnGetPriceClose := DoGetStockClosePrice;
      tmpNodeData.Rule_BDZX_Price.OnGetPriceHigh := DoGetStockHighPrice;
      tmpNodeData.Rule_BDZX_Price.OnGetPriceLow := DoGetStockLowPrice;
      tmpNodeData.Rule_BDZX_Price.Execute;
      //*)
      
      if nil <> fDataViewerData.FrameDataViewer then
      begin
        fDataViewerData.FrameDataViewer.SetStockItem(tmpNodeData);
      end;
      if nil <> fDataViewerData.FrameChartViewer then
      begin
        fDataViewerData.FrameChartViewer.SetStockItem(tmpNodeData);
      end;
    end;
  end;
end;

procedure TfrmDataViewer.vtStocksGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  tmpNodeData: PStockItemNode;
begin
  CellText := '';
  if nil = node then
    exit;
  tmpNodeData := vtStocks.GetNodeData(Node);
  if nil <> tmpNodeData then
  begin
    if nil <> tmpNodeData.StockItem then
    begin
      CellText := '[' + IntToStr(node.Index) + ']' + tmpNodeData.StockItem.sCode + '-' + tmpNodeData.StockItem.Name;
    end;
  end;
end;

function TfrmDataViewer.DoGetStockOpenPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fDataViewerData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceOpen.Value;
end;
                          
function TfrmDataViewer.DoGetStockClosePrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fDataViewerData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceClose.Value;
end;

function TfrmDataViewer.DoGetStockHighPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fDataViewerData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceHigh.Value;
end;

function TfrmDataViewer.DoGetStockLowPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fDataViewerData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceLow.Value;
end;

function TfrmDataViewer.DoGetStockDealDays: integer;
begin          
  Result := fDataViewerData.StockDayDataAccess.RecordCount;
end;

end.
