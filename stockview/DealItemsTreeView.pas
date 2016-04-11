unit DealItemsTreeView;

interface

uses
  Controls, Sysutils, VirtualTrees, define_dealitem;
  
type
  PDealItemNode = ^TDealItemNode; 
  TDealItemNode = record
    DealItem: PRT_DealItem;
  end;

  TDealItemColumns_BaseInfo = record
    Col_Code: TVirtualTreeColumn;
    Col_Name: TVirtualTreeColumn;
    Col_FirstDealDate: TVirtualTreeColumn;
    Col_LastDealDate: TVirtualTreeColumn;
    Col_EndDealDate: TVirtualTreeColumn;
  end;
                          
  TDealItemColumns_BaseInfoEx = record
    Col_VolumeTotal : TVirtualTreeColumn; // 当前总股本
    Col_VolumeDeal  : TVirtualTreeColumn; // 当前流通股本
    Col_VolumeDate  : TVirtualTreeColumn; // 当前股本结构开始时间    

    Col_Industry    : TVirtualTreeColumn; // 行业     
    Col_Area        : TVirtualTreeColumn; // 地区
    Col_PERatio     : TVirtualTreeColumn; // 市盈率    
  end;

  TDealItemColumns_Quote = record
    Col_PrePriceClose: TVirtualTreeColumn;
    Col_PreDealVolume: TVirtualTreeColumn;
    Col_PreDealAmount: TVirtualTreeColumn;

    Col_PriceOpen: TVirtualTreeColumn;  // 开盘价
    Col_PriceHigh: TVirtualTreeColumn;  // 最高价
    Col_PriceLow: TVirtualTreeColumn;   // 最低价
    Col_PriceClose: TVirtualTreeColumn; // 收盘价
    Col_DealVolume: TVirtualTreeColumn; // 成交量
    Col_DealAmount: TVirtualTreeColumn; // 成交金额  (总金额)
    Col_DealVolumeRate: TVirtualTreeColumn; // 换手率                        
  end;
  
  TDealItemTreeData = record
    TreeView: TVirtualStringTree;
    Columns_BaseInfo: TDealItemColumns_BaseInfo;
    ParentControl: TWinControl;
  end;

  TDealItemTree = class
  protected
    fDealItemTreeData: TDealItemTreeData;
    procedure vtDealItemGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  public
    constructor Create(AParent: TWinControl);
    destructor Destroy; override;
    procedure BuildDealItemsTreeNodes;
    procedure InitializeDealItemsTree;
    procedure Clear;    

    function AddDealItemsTreeColumn_Code: TVirtualTreeColumn;
    function AddDealItemsTreeColumn_Name: TVirtualTreeColumn;
    function AddDealItemsTreeColumn_FirstDeal: TVirtualTreeColumn;
    function AddDealItemsTreeColumn_EndDeal: TVirtualTreeColumn;
  end;
  
implementation

uses
  BaseStockApp;
  
constructor TDealItemTree.Create(AParent: TWinControl);
begin
  FillChar(fDealItemTreeData, SizeOf(fDealItemTreeData), 0);
  fDealItemTreeData.ParentControl := AParent;
end;
                              
destructor TDealItemTree.Destroy;
begin
  inherited;
end;

procedure TDealItemTree.InitializeDealItemsTree;
begin
  fDealItemTreeData.TreeView := TVirtualStringTree.Create(fDealItemTreeData.ParentControl);
  fDealItemTreeData.TreeView.Parent := fDealItemTreeData.ParentControl;
  fDealItemTreeData.TreeView.Align := alClient;   
  fDealItemTreeData.TreeView.NodeDataSize := SizeOf(TDealItemNode);
  fDealItemTreeData.TreeView.OnGetText := vtDealItemGetText;
  // -----------------------------------
  fDealItemTreeData.TreeView.Header.Options := [hoVisible, hoColumnResize];
  // -----------------------------------
  AddDealItemsTreeColumn_Code;
  AddDealItemsTreeColumn_Name;
  AddDealItemsTreeColumn_FirstDeal;
  AddDealItemsTreeColumn_EndDeal;
  // -----------------------------------
  fDealItemTreeData.TreeView.TreeOptions.AnimationOptions := []; 
  fDealItemTreeData.TreeView.TreeOptions.SelectionOptions := [toExtendedFocus,toFullRowSelect];
  fDealItemTreeData.TreeView.TreeOptions.AutoOptions := [
    {toAutoDropExpand,
    toAutoScrollOnExpand,
    toAutoSort,
    toAutoTristateTracking,
    toAutoDeleteMovedNodes,
    toAutoChangeScale}];
end;
                                                                    
function TDealItemTree.AddDealItemsTreeColumn_Code: TVirtualTreeColumn;
begin
  if nil = fDealItemTreeData.Columns_BaseInfo.Col_Code then
  begin
    fDealItemTreeData.Columns_BaseInfo.Col_Code := fDealItemTreeData.TreeView.Header.Columns.Add;
    fDealItemTreeData.Columns_BaseInfo.Col_Code.Width := 70;
    fDealItemTreeData.Columns_BaseInfo.Col_Code.Text := 'Code';
  end;
  Result := fDealItemTreeData.Columns_BaseInfo.Col_Code;
end;

function TDealItemTree.AddDealItemsTreeColumn_Name: TVirtualTreeColumn;
begin
  if nil = fDealItemTreeData.Columns_BaseInfo.Col_Name then
  begin
    fDealItemTreeData.Columns_BaseInfo.Col_Name := fDealItemTreeData.TreeView.Header.Columns.Add;
    fDealItemTreeData.Columns_BaseInfo.Col_Name.Width := 80;
    fDealItemTreeData.Columns_BaseInfo.Col_Name.Text := 'Name';
  end;
  Result := fDealItemTreeData.Columns_BaseInfo.Col_Name;
end;

function TDealItemTree.AddDealItemsTreeColumn_FirstDeal: TVirtualTreeColumn;
begin
  if nil = fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate then
  begin
    fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate := fDealItemTreeData.TreeView.Header.Columns.Add;
    fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate.Width := 80;
    fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate.Text := 'FirstDate';
  end;
  Result := fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate;
end;

function TDealItemTree.AddDealItemsTreeColumn_EndDeal: TVirtualTreeColumn;
begin
  if nil = fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate then
  begin
    fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate := fDealItemTreeData.TreeView.Header.Columns.Add;
    fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate.Width := 80;
    fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate.Text := 'EndDate';
  end;
  Result := fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate;
end;

procedure TDealItemTree.Clear;
begin
  if nil <> fDealItemTreeData.TreeView then
  begin
    fDealItemTreeData.TreeView.Clear;
  end;
end;

procedure TDealItemTree.BuildDealItemsTreeNodes;
var
  i: integer;
  tmpVNode: PVirtualNode;
  tmpVData: PDealItemNode;  
begin
  fDealItemTreeData.TreeView.Clear;
  fDealItemTreeData.TreeView.BeginUpdate;
  try
    if nil <> GlobalBaseStockApp then
    begin
      for i := 0 to GlobalBaseStockApp.StockItemDB.RecordCount - 1 do
      begin
        tmpVNode := fDealItemTreeData.TreeView.AddChild(nil);
        if nil <> tmpVNode then
        begin
          tmpVData := fDealItemTreeData.TreeView.GetNodeData(tmpVNode);
          if nil <> tmpVData then
          begin
            tmpVData.DealItem := GlobalBaseStockApp.StockItemDB.Items[i];
          end;
        end;
      end;
    end;
  finally
    fDealItemTreeData.TreeView.EndUpdate;
  end;
end;

procedure TDealItemTree.vtDealItemGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var   
  tmpVData: PDealItemNode;
begin
  CellText := '';
  tmpVData := Sender.GetNodeData(Node);
  if nil <> tmpVData then
  begin
    if nil <> tmpVData.DealItem then
    begin
      if nil <> fDealItemTreeData.Columns_BaseInfo.Col_Code then
      begin
        if Column = fDealItemTreeData.Columns_BaseInfo.Col_Code.Index then
        begin
          CellText := tmpVData.DealItem.sCode;
          exit;
        end;
      end;
      if nil <> fDealItemTreeData.Columns_BaseInfo.Col_Name then
      begin
        if Column = fDealItemTreeData.Columns_BaseInfo.Col_Name.Index then
        begin
          CellText := tmpVData.DealItem.Name;
          exit;
        end;
      end;
      if nil <> fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate then
      begin
        if Column = fDealItemTreeData.Columns_BaseInfo.Col_FirstDealDate.Index then
        begin
          if 0 < tmpVData.DealItem.FirstDealDate then
          begin
            CellText := FormatDateTime('yyyy-mm-dd', tmpVData.DealItem.FirstDealDate);
          end;
          exit;
        end;
      end;
      if nil <> fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate then
      begin
        if Column = fDealItemTreeData.Columns_BaseInfo.Col_EndDealDate.Index then
        begin
          if 0 < tmpVData.DealItem.EndDealDate then
          begin
            CellText := FormatDateTime('yyyy-mm-dd', tmpVData.DealItem.EndDealDate);
          end;
          exit;
        end;
      end;
      if nil <> fDealItemTreeData.Columns_BaseInfo.Col_LastDealDate then
      begin
        if Column = fDealItemTreeData.Columns_BaseInfo.Col_LastDealDate.Index then
        begin
          if 0 < tmpVData.DealItem.LastDealDate then
          begin
            CellText := FormatDateTime('yyyy-mm-dd', tmpVData.DealItem.LastDealDate);
          end;
          exit;
        end;
      end;
    end;
  end;
end;

end.
