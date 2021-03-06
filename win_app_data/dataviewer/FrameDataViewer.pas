unit FrameDataViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  BaseApp, BaseForm, VirtualTrees, ExtCtrls, 
  define_dealItem,                         
  define_price,
  define_datasrc,  
  db_dealItem,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA, 
  StockDayDataAccess, UIDealItemNode,
  StockDetailDataAccess, StdCtrls;

type
  TDataViewerData = record
    DayDataAccess: StockDayDataAccess.TStockDayDataAccess;
    DetailDataAccess: StockDetailDataAccess.TStockDetailDataAccess;
     
    WeightMode: TWeightMode;
        
    Rule_BDZX_Price: TRule_BDZX_Price;  
    Rule_CYHT_Price: TRule_CYHT_Price;
    DayDataSrc: TDealDataSource;
    DetailDataSrc: TDealDataSource;
  end;

  TfmeDataViewer = class(TfrmBase)
    pnMain: TPanel;
    pnTop: TPanel;
    pnData: TPanel;
    pnDataTop: TPanel;
    pnlDatas: TPanel;
    spl1: TSplitter;
    pnlDetail: TPanel;
    vtDetailDatas: TVirtualStringTree;
    pnlDetailTop: TPanel;
    pnlDayData: TPanel;
    vtDayDatas: TVirtualStringTree;
    pnlDayDataTop: TPanel;
    edtDetailDataSrc: TComboBox;
    procedure vtDetailDatasGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtDayDatasGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtDayDatasChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure edtDetailDataSrcChange(Sender: TObject);
  protected
    fDataViewerData: TDataViewerData;
    procedure LoadDetailTreeView;
    procedure LoadDayDataTreeView(AStockItem: PStockItemNode);
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
  define_stock_quotes,
  define_dealstore_file,
  StockDayData_Load,
  StockDetailData_Load,
  db_DealItem_Load;

type    
  TDayColumns = (
    colIndex,
    colDate, colOpen, colClose, colHigh, colLow,
    colDayVolume, colDayAmount,
    colWeight
    //, colBoll, colBollUP, colBollLP
    //, colCYHT_SK, colCYHT_SD
    , colBDZX_AK, colBDZX_AD1, colBDZX_AJ
  );
  
  TDetailColumns = (
    colTime, colPrice, 
    colDetailVolume, colDetailAmount, colType
    //, colBoll, colBollUP, colBollLP
    //, colCYHT_SK, colCYHT_SD
    //, colBDZX_AK, colBDZX_AD1, colBDZX_AJ
  );
          
  PStockDayDataNode = ^TStockDayDataNode;
  TStockDayDataNode = record
    DayIndex: integer;         
    QuoteData: PRT_Quote_Day;
  end;
  
  PStockDetailDataNode = ^TStockDetailDataNode;
  TStockDetailDataNode = record
    QuoteData: PRT_Quote_Detail;
  end;
  
const
  DayColumnsText: array[TDayColumns] of String = (
    'Index', '日期',
    '开盘', '收盘', '最高', '最低',
    '成交量', '成交金额', '权重'
    //, 'BOLL', 'UP', 'LP'
    //, 'SK', 'SD'
    , 'AK', 'AD1', 'AJ'
  );
              
  DayColumnsWidth: array[TDayColumns] of integer = (
    60, 0,
    0, 0, 0, 0,
    0, 0, 0
    //, 'BOLL', 'UP', 'LP'
    //, 'SK', 'SD'
    , 0, 0, 0
  );
        
  DetailColumnsText: array[TDetailColumns] of String = (
    '时间',
    '价格',
    '成交量',
    '成交金额',
    '性质'
    //, 'BOLL', 'UP', 'LP'
    //, 'SK', 'SD'
    //, 'AK', 'AD1', 'AJ'
  );
             
{ TfrmDetailDataViewer }

constructor TfmeDataViewer.Create(AOwner: TComponent);
begin
  inherited;
  //fStockDetailDataAccess := nil;
  FillChar(fDataViewerData, SizeOf(fDataViewerData), 0);
  fDataViewerData.DayDataSrc := Src_163;
  fDataViewerData.DetailDataSrc := Src_Sina;

  edtDetailDataSrc.Items.Clear;  
  edtDetailDataSrc.Items.AddObject('Sina', TObject(DataSrc_Sina));
  edtDetailDataSrc.Items.AddObject('163', TObject(DataSrc_163));
  edtDetailDataSrc.ItemIndex := 0;
  edtDetailDataSrc.OnChange := edtDetailDataSrcChange;
  //fRule_Boll_Price := nil;
  //fRule_CYHT_Price := nil;
  //fRule_BDZX_Price := nil;
end;

destructor TfmeDataViewer.Destroy;
begin
  inherited;
end;

procedure TfmeDataViewer.edtDetailDataSrcChange(Sender: TObject);
begin
  inherited;
  fDataViewerData.DetailDataSrc := GetDealDataSource(Integer(edtDetailDataSrc.Items.Objects[edtDetailDataSrc.ItemIndex]));
end;

procedure TfmeDataViewer.SetData(ADataType: integer; AData: Pointer);
begin
  SetStockItem(AData);
end;

procedure TfmeDataViewer.SetStockItem(AStockItem: PStockItemNode);
begin
  LoadDayDataTreeView(AStockItem);
end;
                          
procedure TfmeDataViewer.LoadDetailTreeView;     
var
  i: integer;
  tmpNodeData: PStockDetailDataNode;
  tmpDetailData: PRT_Quote_Detail;   
  tmpNode: PVirtualNode;
begin
  vtDetailDatas.Clear;
  vtDetailDatas.BeginUpdate;
  try
    if nil <> fDataViewerData.DetailDataAccess then
    begin
      for i := 0 to fDataViewerData.DetailDataAccess.RecordCount - 1 do
      begin
        tmpDetailData := fDataViewerData.DetailDataAccess.RecordItem[i];  
        tmpNode := vtDetailDatas.AddChild(nil);
        tmpNodeData := vtDetailDatas.GetNodeData(tmpNode);
        tmpNodeData.QuoteData := tmpDetailData;
      end;
    end;      
  finally
    vtDetailDatas.EndUpdate;
  end;
end;

procedure TfmeDataViewer.LoadDayDataTreeView(AStockItem: PStockItemNode);
var
  i: integer;       
  tmpStockDataNode: PStockDayDataNode;
  tmpStockData: PRT_Quote_Day;
  tmpNode: PVirtualNode;
begin
  vtDayDatas.Clear;
  if nil = AStockItem then
    exit;
  fDataViewerData.DayDataAccess := AStockItem.StockDayDataAccess;
  if nil = fDataViewerData.DayDataAccess then
    fDataViewerData.DayDataAccess := TStockDayDataAccess.Create(AStockItem.StockItem, fDataViewerData.DayDataSrc, fDataViewerData.WeightMode);
  fDataViewerData.Rule_BDZX_Price := AStockItem.Rule_BDZX_Price;
  fDataViewerData.Rule_CYHT_Price := AStockItem.Rule_CYHT_Price;

  for i := fDataViewerData.DayDataAccess.RecordCount - 1 downto 0 do
  begin
    tmpStockData := fDataViewerData.DayDataAccess.RecordItem[i];
    tmpNode := vtDayDatas.AddChild(nil);
    tmpStockDataNode := vtDayDatas.GetNodeData(tmpNode);
    tmpStockDataNode.QuoteData := tmpStockData;
    tmpStockDataNode.DayIndex := i;
  end;
  //StockDetailData_Load.LoadStockDetailData(App, fStockDetailDataAccess, 'E:\StockApp\sdata\sdetsina\600000\600000_20151125.sdet');
        (*//
        if nil <> fRule_Boll_Price then
        begin
          FreeAndNil(fRule_Boll_Price);
        end;
        fRule_Boll_Price := TRule_Boll_Price.Create();
        fRule_Boll_Price.OnGetDataLength := DoGetStockDealDays;
        fRule_Boll_Price.OnGetDataF := DoGetStockClosePrice;
        fRule_Boll_Price.Execute;
        //*)

        (*//    
        if nil <> fRule_CYHT_Price then
        begin
          FreeAndNil(fRule_CYHT_Price);
        end;
        fRule_CYHT_Price := TRule_CYHT_Price.Create();
        fRule_CYHT_Price.OnGetDataLength := DoGetStockDealDays;  
        fRule_CYHT_Price.OnGetPriceOpen := DoGetStockOpenPrice;
        fRule_CYHT_Price.OnGetPriceClose := DoGetStockClosePrice;
        fRule_CYHT_Price.OnGetPriceHigh := DoGetStockHighPrice;
        fRule_CYHT_Price.OnGetPriceLow := DoGetStockLowPrice;
        fRule_CYHT_Price.Execute;
        //*)
        (*//       
        if nil <> fRule_BDZX_Price then
        begin
          FreeAndNil(fRule_BDZX_Price);
        end;
        fRule_BDZX_Price := TRule_BDZX_Price.Create();   
        fRule_BDZX_Price.OnGetDataLength := DoGetStockDealDays;
        fRule_BDZX_Price.OnGetPriceOpen := DoGetStockOpenPrice;
        fRule_BDZX_Price.OnGetPriceClose := DoGetStockClosePrice;
        fRule_BDZX_Price.OnGetPriceHigh := DoGetStockHighPrice;
        fRule_BDZX_Price.OnGetPriceLow := DoGetStockLowPrice;
        fRule_BDZX_Price.Execute;
        //*)                        
        (*//
        for i := 0 to fStockDetailDataAccess.RecordCount - 1 do
        begin
          tmpStockData := fStockDetailDataAccess.RecordItem[i];
          tmpNode := vtDatas.AddChild(nil);
          tmpStockDataNode := vtDatas.GetNodeData(tmpNode);
          tmpStockDataNode.QuoteData := tmpStockData;
          tmpStockDataNode.DayIndex := i;
        end;
        //*)
end;

procedure TfmeDataViewer.Initialize(App: TBaseApp);
var
  col_day: TDayColumns;    
  col_detail: TDetailColumns;
  tmpCol: TVirtualTreeColumn;
begin
  inherited;
  vtDayDatas.NodeDataSize := SizeOf(TStockDayDataNode);  
  vtDayDatas.Header.Options := [hoColumnResize, hoVisible];
  vtDayDatas.Header.Columns.Clear;

  vtDayDatas.TreeOptions.SelectionOptions := [toFullRowSelect];
  vtDayDatas.TreeOptions.AnimationOptions := [];
  vtDayDatas.TreeOptions.MiscOptions := [toAcceptOLEDrop,toFullRepaintOnResize,toInitOnSave,toToggleOnDblClick,toWheelPanning,toEditOnClick];
  vtDayDatas.TreeOptions.PaintOptions := [toShowButtons,toShowDropmark,{toShowRoot} toShowTreeLines,toThemeAware,toUseBlendedImages];
  vtDayDatas.TreeOptions.StringOptions := [toSaveCaptions,toAutoAcceptEditChange];

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

  vtDetailDatas.NodeDataSize := SizeOf(TStockDetailDataNode);
  vtDetailDatas.OnGetText := vtDetailDatasGetText;
  vtDetailDatas.Header.Options := [hoColumnResize, hoVisible];
  vtDetailDatas.Header.Columns.Clear;  
  for col_detail := low(TDetailColumns) to high(TDetailColumns) do
  begin
    tmpCol := vtDetailDatas.Header.Columns.Add;
    tmpCol.Text := DetailColumnsText[col_detail];
    tmpCol.Width := 120;
  end;

  vtDayDatas.OnGetText := vtDayDatasGetText;
  vtDayDatas.OnChange := vtDayDatasChange;
  fDataViewerData.DayDataSrc := Src_163;
end;
                   
procedure TfmeDataViewer.vtDayDatasChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var      
  tmpNodeData: PStockDayDataNode;
  tmpFileUrl: string;
begin
  inherited;
  if nil = Node then
    exit;
  tmpNodeData := Sender.GetNodeData(Node);
  if nil = tmpNodeData then
    exit;
  if nil = tmpNodeData.QuoteData then
    exit;
  if nil = fDataViewerData.DetailDataAccess then
  begin
    fDataViewerData.DetailDataAccess := TStockDetailDataAccess.Create(fDataViewerData.DayDataAccess.StockItem, fDataViewerData.DetailDataSrc);
  end;
  fDataViewerData.DetailDataAccess.Clear;
  fDataViewerData.DetailDataAccess.StockItem := fDataViewerData.DayDataAccess.StockItem;
  fDataViewerData.DetailDataAccess.FirstDealDate := tmpNodeData.QuoteData.DealDate.Value;
  
  tmpFileUrl := TBaseStockApp(App).StockAppPath.GetFileUrl(FilePath_DBType_DetailData, GetDealDataSourceCode(fDataViewerData.DetailDataSrc),
    tmpNodeData.QuoteData.DealDate.Value,
    fDataViewerData.DayDataAccess.StockItem);
  if not FileExists(tmpFileUrl) then
  begin
    tmpFileUrl := ChangeFileExt(tmpFileUrl, '.sdet');
  end;
  //tmpFileUrl := 'E:\StockApp\sdata\sdetsina\600000\600000_20151125.sdet';
  if FileExists(tmpFileUrl) then
  begin
    LoadStockDetailData(
      App,
      fDataViewerData.DetailDataAccess,
      tmpFileUrl);
  end;            
  LoadDetailTreeView;
end;

procedure TfmeDataViewer.vtDayDatasGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  tmpNodeData: PStockDayDataNode;
begin     
  CellText := '';    
  tmpNodeData := Sender.GetNodeData(Node);
  if nil <> tmpNodeData then
  begin
    if nil <> tmpNodeData.QuoteData then
    begin
      if Integer(colIndex) = Column then
      begin
        CellText := IntToStr(Node.Index);
        exit;
      end;
      if Integer(colDate) = Column then
      begin
        CellText := FormatDateTime('yyyymmdd', tmpNodeData.QuoteData.DealDate.Value);
        exit;
      end;
      if Integer(colOpen) = Column then
      begin         
        CellText := IntToStr(tmpNodeData.QuoteData.PriceRange.PriceOpen.Value);
        exit;
      end;
      if Integer(colClose) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.PriceRange.PriceClose.Value);
        exit;
      end;
      if Integer(colHigh) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.PriceRange.PriceHigh.Value);
        exit;
      end;
      if Integer(colLow) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.PriceRange.PriceLow.Value);
        exit;
      end;
      if Integer(colDayVolume) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.DealVolume);
        exit;
      end;
      if Integer(colDayAmount) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.DealAmount);
        exit;
      end;
      if Integer(colWeight) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.Weight.Value);
        exit;
      end;
      if Integer(colBDZX_AK) = Column then
      begin
        if nil <> fDataViewerData.Rule_BDZX_Price then
        begin
          if nil <> fDataViewerData.Rule_BDZX_Price.Ret_AK_Float then
          begin
            CellText := FormatFloat('0.00', fDataViewerData.Rule_BDZX_Price.Ret_AK_Float.value[tmpNodeData.DayIndex]);
          end;
        end;
        exit;
      end;
      if Integer(colBDZX_AD1) = Column then
      begin             
        if nil <> fDataViewerData.Rule_BDZX_Price then
        begin
          if nil <> fDataViewerData.Rule_BDZX_Price.Ret_AD1_EMA then
          begin
            CellText := FormatFloat('0.00', fDataViewerData.Rule_BDZX_Price.Ret_AD1_EMA.ValueF[tmpNodeData.DayIndex]);
          end;
        end;
        exit;
      end;
      if Integer(colBDZX_AJ) = Column then
      begin         
        if nil <> fDataViewerData.Rule_BDZX_Price then
        begin
          if nil <> fDataViewerData.Rule_BDZX_Price.Ret_AJ then
          begin
            CellText := FormatFloat('0.00', fDataViewerData.Rule_BDZX_Price.Ret_AJ.value[tmpNodeData.DayIndex]);
          end;
        end;
        exit;
      end;
      (*//
      if Integer(colCYHT_SK) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Cyht_Price.SK[tmpNodeData.DayIndex]);
        exit;
      end;
      if Integer(colCYHT_SD) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Cyht_Price.SD[tmpNodeData.DayIndex]);
        exit;
      end;  
      //*)
      (*//
      if Integer(colBoll) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Boll_Price.Boll[tmpNodeData.DayIndex]);
        exit;
      end;
      if Integer(colBollUP) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Boll_Price.UB[tmpNodeData.DayIndex]);
        exit;
      end;
      if Integer(colBollLP) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Boll_Price.LB[tmpNodeData.DayIndex]);
        exit;
      end;
      //*)
    end;
  end;
end;

procedure TfmeDataViewer.vtDetailDatasGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  tmpNodeData: PStockDetailDataNode;
  tmpHour: Integer;
  tmpMinute: Integer;
  tmpSecond: Integer;
begin
  CellText := '';    
  tmpNodeData := Sender.GetNodeData(Node);
  if nil <> tmpNodeData then
  begin
    if nil <> tmpNodeData.QuoteData then
    begin
      if Integer(colTime) = Column then
      begin
        tmpHour := Trunc(tmpNodeData.QuoteData.DealDateTime.TimeValue div 3600);
        tmpSecond := tmpNodeData.QuoteData.DealDateTime.TimeValue - tmpHour * 3600;
        tmpMinute := Trunc(tmpSecond div 60);
        tmpSecond := tmpSecond - tmpMinute * 60;
        CellText := IntToStr(tmpHour + 9) + ':' + IntToStr(tmpMinute) + ':' + IntToStr(tmpSecond);
        exit;
      end;
      if Integer(colPrice) = Column then
      begin         
        CellText := IntToStr(tmpNodeData.QuoteData.Price.Value);
        exit;
      end;
      if Integer(colDetailVolume) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.DealVolume);
        exit;
      end;
      if Integer(colDetailAmount) = Column then
      begin
        CellText := IntToStr(tmpNodeData.QuoteData.DealAmount);
        exit;
      end;   
      if Integer(colType) = Column then
      begin             
        CellText := 'U';
        if DealType_Buy = tmpNodeData.QuoteData.DealType then
        begin
          CellText := '买';
        end;
        if DealType_Sale = tmpNodeData.QuoteData.DealType then
        begin
          CellText := '卖';
        end;
        if DealType_Neutral = tmpNodeData.QuoteData.DealType then
        begin
          CellText := '中';
        end;
        exit;
      end;     
      (*//
      if Integer(colCYHT_SK) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Cyht_Price.SK[tmpNodeData.DayIndex]);
        exit;
      end;
      if Integer(colCYHT_SD) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Cyht_Price.SD[tmpNodeData.DayIndex]);
        exit;
      end;  
      //*)
      (*//
      if Integer(colBoll) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Boll_Price.Boll[tmpNodeData.DayIndex]);
        exit;
      end;
      if Integer(colBollUP) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Boll_Price.UB[tmpNodeData.DayIndex]);
        exit;
      end;
      if Integer(colBollLP) = Column then
      begin
        CellText := FormatFloat('0.00', fRule_Boll_Price.LB[tmpNodeData.DayIndex]);
        exit;
      end;
      //*)
    end;
  end;
end;

end.
