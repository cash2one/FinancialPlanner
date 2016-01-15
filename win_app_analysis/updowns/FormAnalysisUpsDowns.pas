unit FormAnalysisUpsDowns;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls, Tabs, VirtualTrees, 
  BaseApp, BaseForm, QuickList_double,
  DB_DealItem, StockDayDataAccess, 
  Define_AnalysisUpsDowns,
  Define_DealItem;

type
  TAnalysisUpsDownsData = record
    ActiveFrame: TfrmBase;
    StockDayDataAccess: TStockDayDataAccess; 
  end;
        
  PStockItemNode = ^TStockItemNode;
  TStockItemNode = record
    StockItem: PRT_DealItem;
    AnalysisUpsDowns: PRT_AnalysisUpsDowns;
  end;
               
  TAnalysisColumns = (
    colStock,
    colUpdownStatus,
    
    colUpTrueDays,    
    colUpTrueRate,
    colUpViewDays,
    colUpViewRate,
        
    colDownTrueDays,  
    colDownTrueRate,
    colDownViewDays,
    colDownViewRate
    //, colBoll, colBollUP, colBollLP
    //, colCYHT_SK, colCYHT_SD
    //, colBDZX_AK, colBDZX_AD1, colBDZX_AJ
  );
          
  TfrmAnalysisUpsDowns = class(TfrmBase)
    pnMain: TPanel;
    pnStocks: TPanel;
    split1: TSplitter;
    vtStocks: TVirtualStringTree;
    pnTop: TPanel;
    pnData: TPanel;
    btnComputeUpsDowns: TButton;
    mmo1: TMemo;
    lbl1: TLabel;
    procedure vtStocksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtStocksClick(Sender: TObject);
    procedure btnComputeUpsDownsClick(Sender: TObject);
  protected
    fAnalysisUpsDownsData: TAnalysisUpsDownsData;
    procedure ComputeAllAnalysisUpsDowns(); 
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
      
const
  AnalysisColumnsText: array[TAnalysisColumns] of String = ('证券',
    '涨跌',
    '涨(实际)', '涨比率(实际)', '涨(可见)', '涨比率(可见)',
    '跌(实际)', '跌比率(实际)', '跌(可见)', '跌比率(可见)' 
  );
                                           
  procedure CreateMainForm(var AForm: TfrmBase);

implementation

{$R *.dfm}

uses
  BaseStockApp,
  Define_DataSrc,
  Define_Price,  
  define_stock_quotes,
  StockDayData_Load,
  DB_DealItem_Load;

procedure CreateMainForm(var AForm: TfrmBase);
begin
  Application.CreateForm(TfrmAnalysisUpsDowns, AForm);
end;

{ TfrmDataViewer }
constructor TfrmAnalysisUpsDowns.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fAnalysisUpsDownsData, SizeOf(fAnalysisUpsDownsData), 0);
end;

destructor TfrmAnalysisUpsDowns.Destroy;
begin
  inherited;
end;
                                  
procedure TfrmAnalysisUpsDowns.Initialize(App: TBaseApp);
begin
  inherited;
  vtStocks.NodeDataSize := SizeOf(TStockItemNode);
  vtStocks.OnGetText := vtStocksGetText;
  InitializeStockListTree;
end;

procedure TfrmAnalysisUpsDowns.InitializeStockListTree;
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpNode: PVirtualNode;
  tmpNodeData: PStockItemNode;    
  tmpCol: TVirtualTreeColumn;
  col_analysis: TAnalysisColumns;
begin                   
  vtStocks.Header.Options := [hoColumnResize, hoVisible];
  vtStocks.Header.Columns.Clear;
                           
  for col_analysis := low(TAnalysisColumns) to high(TAnalysisColumns) do
  begin
    tmpCol := vtStocks.Header.Columns.Add;
    tmpCol.Text := AnalysisColumnsText[col_analysis];
    tmpCol.Width := 120;
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
                  
                       
procedure TfrmAnalysisUpsDowns.btnComputeUpsDownsClick(Sender: TObject);
begin
  ComputeAllAnalysisUpsDowns;
end;

procedure TfrmAnalysisUpsDowns.ComputeAllAnalysisUpsDowns();
var
  tmpNode: PVirtualNode;
  tmpNodeData: PStockItemNode;
begin
  tmpNode := vtStocks.RootNode;
  if nil <> tmpNode then
  begin
    if nil <> tmpNode.FirstChild then
    begin
      tmpNode := tmpNode.FirstChild;
    end;
    while nil <> tmpNode do
    begin
      if Application.Terminated then
        Break;
      tmpNodeData := vtStocks.GetNodeData(tmpNode);
      if nil <> tmpNodeData then
      begin
        if nil <> tmpNodeData.StockItem then
        begin                         
          if nil = tmpNodeData.AnalysisUpsDowns then
          begin
            tmpNodeData.AnalysisUpsDowns := System.New(PRT_AnalysisUpsDowns);
            FillChar(tmpNodeData.AnalysisUpsDowns^, SizeOf(TRT_AnalysisUpsDowns), 0);
            tmpNodeData.AnalysisUpsDowns.StockItem := tmpNodeData.StockItem;
          end;
          
          if nil <> fAnalysisUpsDownsData.StockDayDataAccess then
            FreeAndNil(fAnalysisUpsDownsData.StockDayDataAccess);
          fAnalysisUpsDownsData.StockDayDataAccess := TStockDayDataAccess.Create(tmpNodeData.StockItem, DataSrc_163);
          StockDayData_Load.LoadStockDayData(App, fAnalysisUpsDownsData.StockDayDataAccess);
  
          ComputeAnalysisUpsDowns(tmpNodeData.StockItem, tmpNodeData.AnalysisUpsDowns, fAnalysisUpsDownsData.StockDayDataAccess);

          if nil <> tmpNodeData.AnalysisUpsDowns then
          begin

          end;
        end;
      end;
      Application.ProcessMessages;
      vtStocks.InvalidateNode(tmpNode);
      tmpNode := tmpNode.NextSibling;
    end;
  end;
end;

procedure TfrmAnalysisUpsDowns.vtStocksClick(Sender: TObject);
var
  tmpNodeData: PStockItemNode;
begin
  if nil <> vtStocks.FocusedNode then
  begin                 
    tmpNodeData := vtStocks.GetNodeData(vtStocks.FocusedNode);
    if (nil <> tmpNodeData) and (nil <> tmpNodeData.StockItem) then
    begin                                        
      if nil <> fAnalysisUpsDownsData.StockDayDataAccess then
        FreeAndNil(fAnalysisUpsDownsData.StockDayDataAccess);
      fAnalysisUpsDownsData.StockDayDataAccess := TStockDayDataAccess.Create(tmpNodeData.StockItem, DataSrc_163);    
      StockDayData_Load.LoadStockDayData(App, fAnalysisUpsDownsData.StockDayDataAccess);                                                        
    end;
  end;
end;

procedure TfrmAnalysisUpsDowns.vtStocksGetText(Sender: TBaseVirtualTree;
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
      if Integer(colStock) = Column then
      begin
        CellText := '[' + IntToStr(node.Index) + ']' + tmpNodeData.StockItem.sCode + '-' + tmpNodeData.StockItem.Name;
        exit;
      end;           
      if Integer(colUpdownStatus) = Column then
      begin
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
          CellText := '';
          case tmpNodeData.AnalysisUpsDowns.UpDownTrueStatus of
            udFlatline : CellText := '平'; // 持平
            udUp : CellText := '涨';      // 上涨
            udDown : CellText := '跌';      // 下跌
          end;
        end;
        exit;
      end;
      if Integer(colUpTrueDays) = Column then
      begin           
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
          CellText := IntToStr(tmpNodeData.AnalysisUpsDowns.UpTrueDays);      
        end;
        exit;
      end;
      if Integer(colUpTrueRate) = Column then
      begin
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin

        end;
        exit;
      end;
      if Integer(colUpViewDays) = Column then
      begin
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
          CellText := IntToStr(tmpNodeData.AnalysisUpsDowns.UpViewDays);
        end;
        exit;
      end;
      if Integer(colUpViewRate) = Column then
      begin       
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
        
        end;
        exit;
      end;
      if Integer(colDownTrueDays) = Column then
      begin         
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
          CellText := IntToStr(tmpNodeData.AnalysisUpsDowns.DownTrueDays);
        end;
        exit;
      end;
      if Integer(colDownTrueRate) = Column then
      begin    
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
        
        end;
        exit;
      end;
      if Integer(colDownViewDays) = Column then
      begin    
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
          CellText := IntToStr(tmpNodeData.AnalysisUpsDowns.DownViewDays);
        end;
        exit;
      end;
      if Integer(colDownViewRate) = Column then
      begin   
        if (nil <> tmpNodeData.AnalysisUpsDowns) then
        begin
        
        end;
        exit;
      end;
    end;
  end;
end;

function TfrmAnalysisUpsDowns.DoGetStockOpenPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fAnalysisUpsDownsData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceOpen.Value;
end;
                          
function TfrmAnalysisUpsDowns.DoGetStockClosePrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fAnalysisUpsDownsData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceClose.Value;
end;

function TfrmAnalysisUpsDowns.DoGetStockHighPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fAnalysisUpsDownsData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceHigh.Value;
end;

function TfrmAnalysisUpsDowns.DoGetStockLowPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(fAnalysisUpsDownsData.StockDayDataAccess.RecordItem[AIndex]).PriceRange.PriceLow.Value;
end;

function TfrmAnalysisUpsDowns.DoGetStockDealDays: integer;
begin          
  Result := fAnalysisUpsDownsData.StockDayDataAccess.RecordCount;
end;

end.
