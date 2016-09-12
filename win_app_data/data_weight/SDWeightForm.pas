unit SDWeightForm;

interface

uses
  Windows, Forms, Classes, Controls, ExtCtrls, SysUtils, Graphics,
  VirtualTrees, define_price,   
  VirtualTree_Editor,
  BaseForm, BaseApp, DealItemsTreeView, StockWeightDataAccess, StdCtrls;

type
  PStockDayDataColumns = ^TStockDayDataColumns;
  TStockDayDataColumns = record
    Col_PriceOpen: TVirtualTreeColumn;  // 开盘价
    Col_PriceHigh: TVirtualTreeColumn;  // 最高价
    Col_PriceLow: TVirtualTreeColumn;   // 最低价
    Col_PriceClose: TVirtualTreeColumn; // 收盘价   
    Col_Weight: TVirtualTreeColumn;     // 权重
  end;

  TStockDataTreeCtrlData = record       
    Col_Date: TVirtualTreeColumn;
    Cols_DataSrc1: TStockDayDataColumns;
    Cols_DataSrc2: TStockDayDataColumns;   
    Col_WeightPriceOffset: TVirtualTreeColumn;     // 权重
    
    DataSrcId_1 : Integer;
    WeightDataAccess1: TStockWeightDataAccess;
  end;
  
  TRepairFormData = record
    StockListTreeCtrl: TDealItemTreeCtrl;
    StockDataTreeCtrlData: TStockDataTreeCtrlData;
  end;

  TfrmSDWeight = class(TfrmBase)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlMain: TPanel;
    pnlStocks: TPanel;
    vtStocks: TVirtualStringTree;
    vtWeightData: TVirtualStringTree;
    btnCheckFirstDate: TButton;
    btnFindError: TButton;
    mmoLogs: TMemo;
    procedure vtDayDataGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtStocksChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtDayDataPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);      
    procedure btnCheckFirstDateClick(Sender: TObject);
    procedure btnFindErrorClick(Sender: TObject);
    procedure vtDayDataCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vtDayDataEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
  private
    { Private declarations }    
    fRepairFormData: TRepairFormData;
    procedure InitializeStockListTree;  
    procedure InitializeStockWeightDataListView(ATreeView: TVirtualStringTree); 
    procedure ClearDayData;

    function vtDayDataGetEditDataType(ATree: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex): TEditorValueType;
    function vtDayDataGetEditText(ATree: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex): WideString;
    procedure vtDayDataGetEditUpdateData(ATree: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex; AData: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(App: TBaseApp); override;     
  end;

implementation

{$R *.dfm}

uses
  BaseStockApp,
  define_datasrc,
  define_stock_quotes,
  StockWeightData_Load,
  db_dealitem_save,
  define_dealitem;
  
type
  PStockDayDataNode = ^TStockDayDataNode;
  TStockDayDataNode = record
    Date: Word;
    QuoteData1: PRT_Quote_Day;
    QuoteData2: PRT_Quote_Day;
    ErrorCheckStatus: Word; 
  end;

{ TfrmSDRepair }

constructor TfrmSDWeight.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fRepairFormData, SizeOf(fRepairFormData), 0);
end;

destructor TfrmSDWeight.Destroy;
begin
  ClearDayData;
  inherited;
end;

procedure TfrmSDWeight.Initialize(App: TBaseApp);
begin
  inherited;
  InitializeStockListTree;
  InitializeStockWeightDataListView(vtWeightData);
end;
                         
procedure TfrmSDWeight.btnCheckFirstDateClick(Sender: TObject);
var
  i: integer; 
  tmpStockItem: PRT_DealItem;
  tmpWeightDataAccess: TStockWeightDataAccess;
  tmpIsChanged: Boolean;
begin
  inherited;
  tmpIsChanged := false;
  for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
  begin
    tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];
    if 0 = tmpStockItem.FirstDealDate then
    begin       
      tmpWeightDataAccess := TStockWeightDataAccess.Create(tmpStockItem, Src_163, weightNone);
      try
        if 0 < tmpWeightDataAccess.RecordCount then
        begin
          tmpWeightDataAccess.Sort;
          tmpIsChanged := true;
        end;
      finally
        tmpWeightDataAccess.Free;
      end;
    end;
  end;
  if tmpIsChanged then
  begin
    SaveDBStockItem(App, TBaseStockApp(App).StockItemDB);
  end;
end;

procedure TfrmSDWeight.btnFindErrorClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TfrmSDWeight.ClearDayData;
begin
end;

procedure TfrmSDWeight.InitializeStockListTree;
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpNode: PVirtualNode;
  tmpNodeData: PDealItemNode;
begin               
  if nil = fRepairFormData.StockListTreeCtrl then
  begin
    fRepairFormData.StockListTreeCtrl := TDealItemTreeCtrl.Create(nil);
    fRepairFormData.StockListTreeCtrl.InitializeDealItemsTree(vtStocks);
  end;
  for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
  begin
    tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];   
    if 0 = tmpStockItem.EndDealDate then
    begin
      tmpNode := vtStocks.AddChild(nil);
      tmpNodeData := vtStocks.GetNodeData(tmpNode);
      tmpNodeData.DealItem := tmpStockItem;
    end;
  end;
  vtStocks.OnChange := vtStocksChange;
end;
             
procedure TfrmSDWeight.vtStocksChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var   
  tmpNodeData: PDealItemNode;
  tmpVNode: PVirtualNode;
  tmpVNodeData: PStockDayDataNode;
  tmpDayData1: PRT_Quote_Day;
  tmpDayData2: PRT_Quote_Day;  
  tmpIndex1: integer;
  tmpIndex2: integer;
begin
  inherited;
  if nil <> Node then
  begin
    ClearDayData;
    tmpNodeData := vtStocks.GetNodeData(Node);
    if nil <> tmpNodeData then
    begin
      if nil <> tmpNodeData.DealItem then
      begin
      end;
    end;
  end;
end;

procedure TfrmSDWeight.vtDayDataGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);

  function GetDayDataCellText(ADayData: PRT_Quote_Day; ADayDataCols: PStockDayDataColumns): Boolean;
  begin
    Result := false;
    if nil = ADayData then
      exit;     
    if nil <> ADayDataCols.Col_PriceOpen then
    begin
      if Column = ADayDataCols.Col_PriceOpen.Index then
      begin
        CellText := IntToStr(ADayData.PriceRange.PriceOpen.Value);
        Result := true;
        exit;
      end;
    end;   
    if nil <> ADayDataCols.Col_PriceHigh then
    begin
      if Column = ADayDataCols.Col_PriceHigh.Index then
      begin
        CellText := IntToStr(ADayData.PriceRange.PriceHigh.Value);  
        Result := true;
        exit;
      end;
    end;
    if nil <> ADayDataCols.Col_PriceLow then
    begin
      if Column = ADayDataCols.Col_PriceLow.Index then
      begin
        CellText := IntToStr(ADayData.PriceRange.PriceLow.Value); 
        Result := true;
        exit;
      end;
    end;
    if nil <> ADayDataCols.Col_PriceClose then
    begin
      if Column = ADayDataCols.Col_PriceClose.Index then
      begin
        CellText := IntToStr(ADayData.PriceRange.PriceClose.Value); 
        Result := true;
        exit;
      end;
    end;        
    if nil <> ADayDataCols.Col_Weight then
    begin
      if Column = ADayDataCols.Col_Weight.Index then
      begin
        CellText := IntToStr(ADayData.Weight.Value); 
        Result := true;
        exit;
      end;
    end;
  end;
  
var
  tmpVData: PStockDayDataNode;
  tmpOffset: double;
begin
  inherited;
  CellText := '';
  tmpVData := Sender.GetNodeData(Node);
  if nil <> tmpVData then
  begin
    if nil <> fRepairFormData.StockDataTreeCtrlData.Col_Date then
    begin
      if Column = fRepairFormData.StockDataTreeCtrlData.Col_Date.Index then
      begin
        CellText := FormatDateTime('yyyy-mm-dd', tmpVData.Date);
        exit;        
      end;
    end;
    if nil <> fRepairFormData.StockDataTreeCtrlData.Col_WeightPriceOffset then
    begin
      if Column = fRepairFormData.StockDataTreeCtrlData.Col_WeightPriceOffset.Index then
      begin
        CellText := '0';   
        if (nil <> tmpVData.QuoteData1) and (nil <> tmpVData.QuoteData2) then
        begin
          if tmpVData.QuoteData2.Weight.Value > 1000 then
          begin
            tmpOffset := (tmpVData.QuoteData1.PriceRange.PriceOpen.Value * tmpVData.QuoteData2.Weight.Value) / 1000;
            tmpOffset := tmpOffset - tmpVData.QuoteData2.PriceRange.PriceOpen.Value;
            //tmpOffset := Abs(tmpOffset);
            CellText := FloatToStr(tmpOffset);   
          end;
        end;
        exit;        
      end;
    end;
    if GetDayDataCellText(tmpVData.QuoteData1, @fRepairFormData.StockDataTreeCtrlData.Cols_DataSrc1) then
      exit;
    GetDayDataCellText(tmpVData.QuoteData2, @fRepairFormData.StockDataTreeCtrlData.Cols_DataSrc2);
  end;           
end;

procedure TfrmSDWeight.vtDayDataPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType); 
var
  tmpVData: PStockDayDataNode;
  tmpOffset: double;
begin
  inherited;           
  tmpVData := Sender.GetNodeData(Node);
  if nil <> tmpVData then
  begin
    if (nil = tmpVData.QuoteData1) or (nil = tmpVData.QuoteData2) then
    begin
      TargetCanvas.Font.Color := clRed;
    end else
    begin
      if tmpVData.QuoteData2.Weight.Value > 1000 then
      begin
        tmpOffset := Abs((tmpVData.QuoteData1.PriceRange.PriceOpen.Value * tmpVData.QuoteData2.Weight.Value) / 1000 -
             tmpVData.QuoteData2.PriceRange.PriceOpen.Value);
        if tmpOffset > 20 then
        begin
          TargetCanvas.Font.Color := clRed;
        end else
        begin
          if tmpOffset > 10 then
          begin
            TargetCanvas.Font.Color := clBlue;
          end;
        end;
      end else
      begin
        if tmpVData.QuoteData2.Weight.Value < 1000 then
        begin
          TargetCanvas.Font.Color := clRed;
        end;
      end;
    end;
  end;
end;
                           
function TfrmSDWeight.vtDayDataGetEditDataType(ATree: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex): TEditorValueType;
begin
  Result := editString;
end;

function TfrmSDWeight.vtDayDataGetEditText(ATree: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex): WideString;
begin
  vtDayDataGetText(ATree, ANode, AColumn, ttNormal, Result);
end;

procedure TfrmSDWeight.vtDayDataGetEditUpdateData(ATree: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex; AData: WideString);
var
  tmpVData: PStockDayDataNode;
begin                    
  tmpVData := ATree.GetNodeData(ANode);
  if nil <> tmpVData then
  begin
  
  end;
end;

procedure TfrmSDWeight.vtDayDataCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TPropertyEditLink.Create(vtDayDataGetEditDataType, vtDayDataGetEditText, vtDayDataGetEditUpdateData);
end;
                     
procedure TfrmSDWeight.vtDayDataEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := true;
end;

procedure TfrmSDWeight.InitializeStockWeightDataListView(ATreeView: TVirtualStringTree);
var
  tmpCol: TVirtualTreeColumn;
  
  procedure InitializeDayDataColumns(ADayDataColumns: PStockDayDataColumns; ATag: string);
  begin
    tmpCol := ATreeView.Header.Columns.Add;  
    tmpCol.Text := 'Open' + ATag;            
    tmpCol.Width := ATreeView.Canvas.TextWidth('1000000');
    tmpCol.Width := tmpCol.Width + ATreeView.TextMargin + ATreeView.Indent;
    ADayDataColumns.Col_PriceOpen := tmpCol;

    tmpCol := ATreeView.Header.Columns.Add;
    tmpCol.Text := 'High' + ATag;           
    tmpCol.Width := ATreeView.Canvas.TextWidth('1000000');
    tmpCol.Width := tmpCol.Width + ATreeView.TextMargin + ATreeView.Indent;
    ADayDataColumns.Col_PriceHigh := tmpCol;

    tmpCol := ATreeView.Header.Columns.Add;
    tmpCol.Text := 'Low' + ATag;           
    tmpCol.Width := ATreeView.Canvas.TextWidth('1000000');
    tmpCol.Width := tmpCol.Width + ATreeView.TextMargin + ATreeView.Indent;
    ADayDataColumns.Col_PriceLow := tmpCol;

    tmpCol := ATreeView.Header.Columns.Add;
    tmpCol.Text := 'Close' + ATag;         
    tmpCol.Width := ATreeView.Canvas.TextWidth('1000000');
    tmpCol.Width := tmpCol.Width + ATreeView.TextMargin + ATreeView.Indent;
    ADayDataColumns.Col_PriceClose := tmpCol;

    tmpCol := ATreeView.Header.Columns.Add;
    tmpCol.Text := 'Weight' + ATag;      
    tmpCol.Width := ATreeView.Canvas.TextWidth('10000000');
    tmpCol.Width := tmpCol.Width + ATreeView.TextMargin + ATreeView.Indent;
    ADayDataColumns.Col_Weight := tmpCol;
  end;

begin      
  ATreeView.NodeDataSize := SizeOf(TStockDayDataNode);
  ATreeView.Header.Options := [hoVisible, hoColumnResize];
  ATreeView.OnGetText := vtDayDataGetText;
  ATreeView.OnPaintText := vtDayDataPaintText;
  ATreeView.OnCreateEditor := vtDayDataCreateEditor;
  ATreeView.OnEditing := vtDayDataEditing;

  ATreeView.Indent := 4;
  ATreeView.TreeOptions.AnimationOptions := [];
  ATreeView.TreeOptions.SelectionOptions := [toExtendedFocus,toFullRowSelect];
  ATreeView.TreeOptions.SelectionOptions := [toExtendedFocus];  
  ATreeView.TreeOptions.AutoOptions := [];
  
  tmpCol := ATreeView.Header.Columns.Add;
  tmpCol.Text := 'Date';
  tmpCol.Width := ATreeView.Canvas.TextWidth('2000-12-12');
  tmpCol.Width := tmpCol.Width + ATreeView.TextMargin * 2 + ATreeView.Indent * 2;
  fRepairFormData.StockDataTreeCtrlData.Col_Date := tmpCol;
                                                    
  tmpCol := ATreeView.Header.Columns.Add;
  tmpCol.Text := 'WeightPrice Offset';
  tmpCol.Width := ATreeView.Canvas.TextWidth('2000');
  tmpCol.Width := tmpCol.Width + ATreeView.TextMargin * 2 + ATreeView.Indent;
  fRepairFormData.StockDataTreeCtrlData.Col_WeightPriceOffset := tmpCol;
  
  InitializeDayDataColumns(@fRepairFormData.StockDataTreeCtrlData.Cols_DataSrc1, '1');    
  InitializeDayDataColumns(@fRepairFormData.StockDataTreeCtrlData.Cols_DataSrc2, '2');
end;

end.

