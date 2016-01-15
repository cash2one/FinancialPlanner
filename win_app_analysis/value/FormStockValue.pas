unit FormStockValue;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, BaseForm, ExtCtrls,
  VirtualTrees,
  BaseApp, Define_DealItem, StdCtrls;

type                       
  {
     50           亿 以上
     50 -- 100    亿
     100 -- 150   亿
     150 -- 200   亿
     200 -- 500   亿
     500 -- 1000  亿
     1000         亿 以上
  }
  TStockValueNodes = record
    Node_50     : PVirtualNode;
    Node_100    : PVirtualNode;
    Node_150    : PVirtualNode;
    Node_200    : PVirtualNode;
    Node_500    : PVirtualNode;
    Node_1000   : PVirtualNode;
    Node_1000Ex : PVirtualNode;
  end;
  
  TfrmStockValueData = record
    ValueNodes: TStockValueNodes;
  end;
  
  TfrmStockValue = class(TfrmBase)
    pnlTop: TPanel;
    pnlmain: TPanel;
    pnlBottom: TPanel;
    pnlmainleft: TPanel;
    vtstock: TVirtualStringTree;
    btnRefreshData: TButton;
    mmo1: TMemo;
    procedure vtstockGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure btnRefreshDataClick(Sender: TObject);
  protected
    fStockValueFormData: TfrmStockValueData;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;          
    procedure Initialize(App: TBaseApp); override;     
    procedure InitializeStockTree;
  end;

implementation

{$R *.dfm}

uses
  Define_DataSrc,
  StockValueApp,
  StockValueData,
  StockDayData_Load,
  QuickList_Int64,
  define_stock_quotes,
  StockDayDataAccess;
  
type
  PVNodeData = ^TVNodeData;
  TVNodeData = record
    Caption: string;
    StockItem: PRT_DealItem;
    StockValue: PRT_StockValue;
  end;

{ TfrmStockValue }

constructor TfrmStockValue.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fStockValueFormData, SizeOf(fStockValueFormData), 0);
end;

destructor TfrmStockValue.Destroy;
begin
  inherited;
end;
                                                    
procedure TfrmStockValue.InitializeStockTree;

  function AddNode(AParent: PVirtualNode; ACaption: string): PVirtualNode;
  var
    tmpVData: PVNodeData;
  begin
    Result := vtstock.AddChild(AParent);
    tmpVData := vtstock.GetNodeData(Result);
    tmpVData.Caption := ACaption;
  end;
  
var
  i: integer;
  tmpVNode: PVirtualNode;
  tmpVData: PVNodeData;
  tmpCol: TVirtualTreeColumn;
  tmpStockItem: PRT_DealItem; 
  tmpStockValue: PRT_StockValue;
  tmpSortValue: TALInt64List;
  tmpAllDealValue: Int64;
  tmpAllTotalValue: Int64;
begin
  vtstock.NodeDataSize := SizeOf(TVNodeData);
  vtstock.Header.Options := [hoColumnResize, hoVisible];
  vtstock.Clear;

  FillChar(fStockValueFormData.ValueNodes, SizeOf(fStockValueFormData.ValueNodes), 0);

  tmpCol := vtstock.Header.Columns.Add;
  tmpCol.Text := 'Code';
  tmpCol.Width := 120;
  
  tmpCol := vtstock.Header.Columns.Add;
  tmpCol.Text := 'Name';
  tmpCol.Width := 80;
                         
  tmpCol := vtstock.Header.Columns.Add;
  tmpCol.Text := 'Deal Value';
  tmpCol.Width := 80;
                         
  tmpCol := vtstock.Header.Columns.Add;
  tmpCol.Text := 'Total Value';
  tmpCol.Width := 80;

  if 0 < TStockValueApp(App).StockValueDB.RecordCount then
  begin
    tmpAllDealValue := 0;
    tmpAllTotalValue := 0;

    tmpSortValue := TALInt64List.Create;
    try
      for i := 0 to TStockValueApp(App).StockValueDB.RecordCount - 1 do
      begin
        tmpStockValue := TStockValueApp(App).StockValueDB.RecordItem[i];
        tmpAllDealValue := tmpAllDealValue + tmpStockValue.DealValue;
        tmpAllTotalValue := tmpAllTotalValue + tmpStockValue.TotalValue;

        tmpSortValue.AddObject(tmpStockValue.DealValue, TObject(tmpStockValue));
      end;
      mmo1.Lines.Clear;
      mmo1.Lines.Add('All Deal Value:' + IntToStr(tmpAllDealValue));
      mmo1.Lines.Add('All Total Value:' + IntToStr(tmpAllTotalValue));

      tmpSortValue.Sort;
      fStockValueFormData.ValueNodes.Node_50     := AddNode(nil, '0 -- 50');
      fStockValueFormData.ValueNodes.Node_100    := AddNode(nil, '50 -- 100');
      fStockValueFormData.ValueNodes.Node_150    := AddNode(nil, '100 -- 150');
      fStockValueFormData.ValueNodes.Node_200    := AddNode(nil, '150 -- 200');
      fStockValueFormData.ValueNodes.Node_500    := AddNode(nil, '200 -- 500');
      fStockValueFormData.ValueNodes.Node_1000   := AddNode(nil, '500 -- 1000');
      fStockValueFormData.ValueNodes.Node_1000Ex := AddNode(nil, '1000+');
      
      for i := 0 to tmpSortValue.Count - 1 do
      begin
        tmpVNode := nil;                                   
        tmpStockValue := PRT_StockValue(tmpSortValue.Objects[i]);
        if tmpStockValue.DealValue < 5000000000 then
          tmpVNode := fStockValueFormData.ValueNodes.Node_50;
        if nil = tmpVNode then
          if tmpStockValue.DealValue < 10000000000 then
            tmpVNode := fStockValueFormData.ValueNodes.Node_100;
        if nil = tmpVNode then
          if tmpStockValue.DealValue < 15000000000 then
            tmpVNode := fStockValueFormData.ValueNodes.Node_150;
        if nil = tmpVNode then
          if tmpStockValue.DealValue < 20000000000 then
            tmpVNode := fStockValueFormData.ValueNodes.Node_200;
        if nil = tmpVNode then
          if tmpStockValue.DealValue < 50000000000 then
            tmpVNode := fStockValueFormData.ValueNodes.Node_500;
        if nil = tmpVNode then
          if tmpStockValue.DealValue < 100000000000 then
            tmpVNode := fStockValueFormData.ValueNodes.Node_1000;
        if nil = tmpVNode then
          if tmpStockValue.DealValue >= 100000000000 then
            tmpVNode := fStockValueFormData.ValueNodes.Node_1000Ex;

        tmpVNode := vtstock.AddChild(tmpVNode);
        tmpVData := vtstock.GetNodeData(tmpVNode);
        if nil <> tmpVData then
        begin
          tmpVData.StockValue := tmpStockValue;
          tmpVData.StockItem := tmpVData.StockValue.Item;
        end;
      end;
    finally
      tmpSortValue.Free;
    end;
  end else
  begin
    for i := 0 to TStockValueApp(App).StockItemDB.RecordCount - 1 do
    begin
      tmpStockItem := TStockValueApp(App).StockItemDB.Items[i];
      if 0 = tmpStockItem.EndDealDate then
      begin
        tmpVNode := vtstock.AddChild(nil);
        tmpVData := vtstock.GetNodeData(tmpVNode);
        if nil <> tmpVData then
        begin
          tmpVData.StockItem := tmpStockItem;
        end;
      end;
    end;
  end;
end;

procedure TfrmStockValue.vtstockGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var     
  tmpVData: PVNodeData;    
begin
  CellText := '';       
  tmpVData := Sender.GetNodeData(Node);
  if nil <> tmpVData then
  begin                
    if 0 = Column then
    begin
      CellText := tmpVData.Caption + '[' + IntToStr(Node.ChildCount) + ']';
    end;
    if nil <> tmpVData.StockItem then
    begin
      if 0 = Column then
      begin
        if nil <> tmpVData.StockItem then
        begin
          CellText := '[' + IntToStr(Node.Index) + ']' + tmpVData.StockItem.sCode;
        end;
        exit;
      end;
      if 1 = Column then
      begin
        if nil <> tmpVData.StockItem then
        begin
          CellText := tmpVData.StockItem.Name;
        end;
        exit;
      end;                       
      if nil <> tmpVData.StockItem then
      begin
        if nil = tmpVData.StockValue then
        begin
          tmpVData.StockValue := TStockValueApp(App).StockValueDB.FindItem(tmpVData.StockItem);
        end;     
        if nil <> tmpVData.StockValue then
        begin
          if 2 = Column then
          begin
            CellText := IntToStr(tmpVData.StockValue.DealValue);
          end;
          if 3 = Column then
          begin
            CellText := IntToStr(tmpVData.StockValue.TotalValue);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmStockValue.Initialize(App: TBaseApp);
begin
  inherited;
  InitializeStockTree;
end;

type
  TStockValueRresh = class
  protected
    fApp: TBaseApp;
  public
    procedure DoRefreshData();
  end;

  TRefreshDataThread = class(TThread)
  protected
    fApp: TBaseApp;
    procedure Execute; override;
  public
  end;

procedure TRefreshDataThread.Execute;
var
  tmpRresher: TStockValueRresh;
begin
  tmpRresher := TStockValueRresh.Create;
  try
    tmpRresher.fApp := fApp;
    tmpRresher.DoRefreshData;
  finally
    tmpRresher.Free;
  end;
end;

procedure TfrmStockValue.btnRefreshDataClick(Sender: TObject);
var
  tmpRefreshThread: TRefreshDataThread;
begin
  tmpRefreshThread := TRefreshDataThread.Create(false);
  tmpRefreshThread.fApp := App;
  tmpRefreshThread.Resume;
  //DoRefreshData();
end;

procedure TStockValueRresh.DoRefreshData();
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpStockValue: PRT_StockValue;
  tmpStockDataAccess: TStockDayDataAccess;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  inherited;
  if 1 > TStockValueApp(fApp).StockValueDB.RecordCount then
  begin
    for i := 0 to TStockValueApp(fApp).StockItemDB.RecordCount - 1 do
    begin
      tmpStockItem := TStockValueApp(fApp).StockItemDB.Items[i];
      if 0 = tmpStockItem.EndDealDate then
      begin
        tmpStockValue := TStockValueApp(fApp).StockValueDB.AddItem(tmpStockItem);
        if nil <> tmpStockValue then
        begin                         
          tmpStockDataAccess := TStockDayDataAccess.Create(tmpStockItem, DataSrc_163);
          try
            if StockDayData_Load.LoadStockDayData(fApp, tmpStockDataAccess) then
            begin
              if 0 < tmpStockDataAccess.RecordCount then
              begin
                tmpQuoteDay := tmpStockDataAccess.RecordItem[tmpStockDataAccess.RecordCount - 1];
                if nil <> tmpQuoteDay then
                begin
                  tmpStockValue.DealValue := tmpQuoteDay.DealValue;
                  tmpStockValue.TotalValue:= tmpQuoteDay.TotalValue;
                end;
              end;
            end;
          finally
            tmpStockDataAccess.Free;
          end;
        end;
      end;
    end;
  end;
  StockValueData.SaveDBStockValue(GlobalBaseApp, TStockValueApp(fApp).StockValueDB);
end;

end.
