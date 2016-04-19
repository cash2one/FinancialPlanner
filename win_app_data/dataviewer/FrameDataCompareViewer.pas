unit FrameDataCompareViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  BaseApp, BaseForm, VirtualTrees, ExtCtrls, 
  define_dealItem,  
  db_dealItem,    QuickList_int,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA, 
  StockDayDataAccess, UIDealItemNode,
  StockDetailDataAccess;

type
  TDataViewerData = record
    StockItem: PStockItemNode;
    StockDayDataAccess_163: StockDayDataAccess.TStockDayDataAccess;
    StockDayDataAccess_Sina: StockDayDataAccess.TStockDayDataAccess;
    StockDayDataAccess_SinaW: StockDayDataAccess.TStockDayDataAccess;
    StockDayList: TALIntegerList;        
  end;

  TfmeDataCompareViewer = class(TfrmBase)
    pnMain: TPanel;
    pnTop: TPanel;
    pnData: TPanel;
    pnDataTop: TPanel;
    pnlDatas: TPanel;
    vtDayDatas: TVirtualStringTree;
    procedure vtDayDatasGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  protected
    fDataViewerData: TDataViewerData;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(App: TBaseApp); override;            
    procedure SetData(ADataType: integer; AData: Pointer); override;
    procedure SetStockItem(AStockItem: PStockItemNode);
  end;
                                               
implementation

{$R *.dfm}

uses
  BaseStockApp,
  Define_DataSrc,
  define_stock_quotes,
  StockDayData_Load,
  StockDetailData_Load,
  db_DealItem_Load;

type    
  TDayColumns = (
    colIndex,
    colDate163,
    colDateSina,  
    colDateSinaW,
    colOpen163, colClose163, colHigh163, colLow163, colDayVolume163, colDayAmount163, colWeight163
  );
  
  PStockDayDataNode = ^TStockDayDataNode;
  TStockDayDataNode = record
    DayIndex: integer;         
    QuoteData_163: PRT_Quote_M1_Day;
    QuoteData_Sina: PRT_Quote_M1_Day;
    QuoteData_SinaW: PRT_Quote_M1_Day;        
  end;
  
const
  DayColumnsText: array[TDayColumns] of String = (
    'Index',
    '日期163',   
    '日期Sina',   
    '日期SinaW',
    '开盘', '收盘', '最高', '最低', '成交量', '成交金额', '权重'
    //, 'BOLL', 'UP', 'LP'
    //, 'SK', 'SD'
  );
              
  DayColumnsWidth: array[TDayColumns] of integer = (
    60,
    80,
    80,    
    80,
    0, 0, 0, 0,
    0, 0, 0
    //, 'BOLL', 'UP', 'LP'
    //, 'SK', 'SD'
  );

constructor TfmeDataCompareViewer.Create(AOwner: TComponent);
begin
  inherited;
  //fStockDetailDataAccess := nil;
  FillChar(fDataViewerData, SizeOf(fDataViewerData), 0);
  fDataViewerData.StockDayList := TALIntegerList.Create;
  //fRule_Boll_Price := nil;
  //fRule_CYHT_Price := nil;
  //fRule_BDZX_Price := nil;
end;

destructor TfmeDataCompareViewer.Destroy;
begin
  fDataViewerData.StockDayList.Clear;
  fDataViewerData.StockDayList.Free;
  inherited;
end;

procedure TfmeDataCompareViewer.SetData(ADataType: integer; AData: Pointer);
begin
  SetStockItem(AData);
end;

procedure TfmeDataCompareViewer.SetStockItem(AStockItem: PStockItemNode);
var
  i: integer;
  tmpIndex: Integer;    
  tmpStockDataNode: PStockDayDataNode;
  tmpStockData: PRT_Quote_M1_Day;
  tmpNode: PVirtualNode;
  tmpStr: string;
begin
  vtDayDatas.Clear;
  if nil = AStockItem then
    exit;
  if fDataViewerData.StockItem <> AStockItem then
  begin
    fDataViewerData.StockDayDataAccess_163 := nil;
    fDataViewerData.StockDayDataAccess_sina := nil;
    fDataViewerData.StockDayDataAccess_sinaw := nil;
  end;
//  if nil <> AStockItem.StockDayDataAccess then
//    fDataViewerData.StockDayDataAccess_163 := AStockItem.StockDayDataAccess;

  if nil = fDataViewerData.StockDayDataAccess_163 then
  begin
    fDataViewerData.StockDayDataAccess_163 := TStockDayDataAccess.Create(AStockItem.StockItem, DataSrc_163, false);
    StockDayData_Load.LoadStockDayData(App, fDataViewerData.StockDayDataAccess_163);
  end;
  if nil = fDataViewerData.StockDayDataAccess_sina then
  begin
    fDataViewerData.StockDayDataAccess_sina := TStockDayDataAccess.Create(AStockItem.StockItem, DataSrc_Sina, false);
  end;
  if nil = fDataViewerData.StockDayDataAccess_SinaW then
  begin
    fDataViewerData.StockDayDataAccess_SinaW := TStockDayDataAccess.Create(AStockItem.StockItem, DataSrc_Sina, true);
    StockDayData_Load.LoadStockDayData(App, fDataViewerData.StockDayDataAccess_SinaW);
  end;
  tmpStr := '';
  fDataViewerData.StockDayList.Clear;
  for i := fDataViewerData.StockDayDataAccess_163.RecordCount - 1 downto 0 do
  begin
    tmpStockData := fDataViewerData.StockDayDataAccess_163.RecordItem[i];
    tmpNode := vtDayDatas.AddChild(nil);     
    fDataViewerData.StockDayList.AddObject(tmpStockData.DealDateTime.Value, TObject(tmpNode));

    tmpStockDataNode := vtDayDatas.GetNodeData(tmpNode);
    if '' = tmpStr then
    begin
      tmpStr := FormatDateTime('yyyymmdd', tmpStockData.DealDateTime.Value);
    end;
    tmpStockDataNode.QuoteData_163 := tmpStockData;
    tmpStockDataNode.QuoteData_Sina := nil;
    tmpStockDataNode.QuoteData_SinaW := nil;    
    tmpStockDataNode.DayIndex := i;
  end;
  for i := fDataViewerData.StockDayDataAccess_SinaW.RecordCount - 1 downto 0 do
  begin          
    tmpStockData := fDataViewerData.StockDayDataAccess_SinaW.RecordItem[i];
    tmpIndex := fDataViewerData.StockDayList.IndexOf(tmpStockData.DealDateTime.Value);
    if 0 <= tmpIndex then
    begin
      tmpNode := PVirtualNode(fDataViewerData.StockDayList.Objects[tmpIndex]); 
      tmpStockDataNode := vtDayDatas.GetNodeData(tmpNode); 
      tmpStockDataNode.QuoteData_SinaW := tmpStockData;
    end;
  end;
end;

procedure TfmeDataCompareViewer.Initialize(App: TBaseApp);
var
  col_day: TDayColumns;    
  tmpCol: TVirtualTreeColumn;
begin
  inherited;
  vtDayDatas.NodeDataSize := SizeOf(TStockDayDataNode);  
  vtDayDatas.OnGetText := vtDayDatasGetText;
  vtDayDatas.Header.Options := [hoColumnResize, hoVisible];
  vtDayDatas.Header.Columns.Clear;   
  for col_day := low(TDayColumns) to high(TDayColumns) do
  begin
    tmpCol := vtDayDatas.Header.Columns.Add;
    tmpCol.Text := DayColumnsText[col_day];
    if 0 = DayColumnsWidth[col_day] then
    begin
      tmpCol.Width := 120;
    end else
    begin
      tmpCol.Width := DayColumnsWidth[col_day];
    end;
  end;
end;
                   
procedure TfmeDataCompareViewer.vtDayDatasGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  tmpNodeData: PStockDayDataNode;
begin
  CellText := '';    
  tmpNodeData := Sender.GetNodeData(Node);
  if nil <> tmpNodeData then
  begin            
    if nil <> tmpNodeData.QuoteData_Sina then
    begin      
      if Integer(colDateSina) = Column then
      begin
        CellText := FormatDateTime('yyyymmdd', tmpNodeData.QuoteData_Sina.DealDateTime.Value);
        exit;
      end;
    end;        
    if nil <> tmpNodeData.QuoteData_SinaW then
    begin      
      if Integer(colDateSinaW) = Column then
      begin
        CellText := FormatDateTime('yyyymmdd', tmpNodeData.QuoteData_SinaW.DealDateTime.Value);
        exit;
      end;
    end;
    if nil <> tmpNodeData.QuoteData_163 then
    begin
      if Integer(colIndex) = Column then
      begin
        CellText := IntToStr(Node.Index);
        exit;
      end;
      if Integer(colDate163) = Column then
      begin
        CellText := FormatDateTime('yyyymmdd', tmpNodeData.QuoteData_163.DealDateTime.Value);
        exit;
      end;
      if Integer(colOpen163) = Column then
      begin         
        CellText := IntToStr(tmpNodeData.QuoteData_163.PriceRange.PriceOpen.Value);
        exit;
      end;
      if Integer(colClose163) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData_163.PriceRange.PriceClose.Value);
        exit;
      end;
      if Integer(colHigh163) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData_163.PriceRange.PriceHigh.Value);
        exit;
      end;
      if Integer(colLow163) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData_163.PriceRange.PriceLow.Value);
        exit;
      end;
      if Integer(colDayVolume163) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData_163.DealVolume);
        exit;
      end;
      if Integer(colDayAmount163) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData_163.DealAmount);
        exit;
      end;
      if Integer(colWeight163) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData_163.Weight.Value);
        exit;
      end;
    end;
  end;
end;

end.
