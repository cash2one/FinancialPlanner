unit DealItemsTreeView;

interface

uses
  Controls, Sysutils, VirtualTrees, define_dealitem;
  
type
  PDealItemNode = ^TDealItemNode; 
  TDealItemNode = record
    DealItem: PRT_DealItem;
  end;

  TDealItemTreeData = record
    TreeView: TVirtualStringTree;  
    Col_Code: TVirtualTreeColumn;
    Col_Name: TVirtualTreeColumn;
    Col_FirstDealDate: TVirtualTreeColumn;
    Col_LastDealDate: TVirtualTreeColumn;
    Col_EndDealDate: TVirtualTreeColumn;
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
  fDealItemTreeData.Col_Code := fDealItemTreeData.TreeView.Header.Columns.Add;
  fDealItemTreeData.Col_Code.Width := 70;
  fDealItemTreeData.Col_Code.Text := 'Code';
  
  fDealItemTreeData.Col_Name := fDealItemTreeData.TreeView.Header.Columns.Add;
  fDealItemTreeData.Col_Name.Width := 80;
  fDealItemTreeData.Col_Name.Text := 'Name';

  fDealItemTreeData.Col_FirstDealDate := fDealItemTreeData.TreeView.Header.Columns.Add;
  fDealItemTreeData.Col_FirstDealDate.Width := 80;
  fDealItemTreeData.Col_FirstDealDate.Text := 'FirstDate';

  fDealItemTreeData.Col_EndDealDate := fDealItemTreeData.TreeView.Header.Columns.Add;
  fDealItemTreeData.Col_EndDealDate.Width := 80;
  fDealItemTreeData.Col_EndDealDate.Text := 'EndDate';
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
      if nil <> fDealItemTreeData.Col_Code then
      begin
        if Column = fDealItemTreeData.Col_Code.Index then
        begin
          CellText := tmpVData.DealItem.sCode;
        end;
      end;
      if nil <> fDealItemTreeData.Col_Name then
      begin
        if Column = fDealItemTreeData.Col_Name.Index then
        begin
          CellText := tmpVData.DealItem.Name;
        end;
      end;
      if nil <> fDealItemTreeData.Col_FirstDealDate then
      begin
        if Column = fDealItemTreeData.Col_FirstDealDate.Index then
        begin
          if 0 < tmpVData.DealItem.FirstDealDate then
          begin
            CellText := FormatDateTime('yyyy-mm-dd', tmpVData.DealItem.FirstDealDate);
          end;
        end;
      end;               
      if nil <> fDealItemTreeData.Col_EndDealDate then
      begin
        if Column = fDealItemTreeData.Col_EndDealDate.Index then
        begin
          if 0 < tmpVData.DealItem.EndDealDate then
          begin
            CellText := FormatDateTime('yyyy-mm-dd', tmpVData.DealItem.EndDealDate);
          end;
        end;
      end;
    end;
  end;
end;

end.
