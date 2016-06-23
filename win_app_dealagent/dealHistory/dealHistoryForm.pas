unit dealHistoryForm;

interface

uses
  Forms, Classes, Controls, StdCtrls, SysUtils, ExtCtrls,
  VirtualTrees,
  BaseApp, BaseForm;

type
  TfrmDealHistory = class(TfrmBase)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlMain: TPanel;
    pnlDeal: TPanel;
    vtDeal: TVirtualStringTree;
    procedure vtDealGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  protected
    procedure InitializeDealTree;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;     
    procedure Initialize(App: TBaseApp); override;  
  end;

implementation

{$R *.dfm}

uses
  define_deal;

(*//
    -- �˺� A  --> { ���ʲ� }
           Ͷ�ʷ���
           ȫ��Ͷ�ʼ�¼
           2016
             2016-03      
             2016-02
             2016-01
                2016-01-28
                2016-01-03  
           2015
             2015-12
             2015-11
    -- �˺� B    
//*)

type
  TSummaryNodeType = (
    nodeUndefine,
    nodeAnalysis
    );
  
  PDealSummaryNode  = ^TDealSummaryNode;
  TDealSummaryNode  = record
    NodeType        : TSummaryNodeType;   
    Caption         : string;
  end;

  PDealItemNode = ^TDealItemNode;
  TDealItemNode = record
    ID: Integer;
  end;
  
{ TfrmDealHistory }

constructor TfrmDealHistory.Create(AOwner: TComponent);
begin
  inherited;
//  mmo1.Lines.Add('TDealRequest:' + IntToStr(SizeOf(TDealRequest)));
//  mmo1.Lines.Add('TDealResultClose:' + IntToStr(SizeOf(TDealResultClose)));
//  mmo1.Lines.Add('TDealResultCancel:' + IntToStr(SizeOf(TDealResultCancel)));
end;

destructor TfrmDealHistory.Destroy;
begin
  inherited;
end;

procedure TfrmDealHistory.Initialize(App: TBaseApp);
begin
  inherited;
  InitializeDealTree;
end;

procedure TfrmDealHistory.InitializeDealTree;
var
  tmpVNode_Account: PVirtualNode;
  tmpVNode_Analysis: PVirtualNode;
  tmpVNode_DealHistorys: PVirtualNode;
  tmpVNode_DealPeriod: PVirtualNode;
  tmpVNodeData: PDealSummaryNode;  
begin
  vtDeal.NodeDataSize := SizeOf(TDealSummaryNode);
  vtDeal.OnGetText := vtDealGetText;

  tmpVNode_Account := nil; //
//  tmpVNode_Account := vtDeal.AddChild(nil);
//  tmpVNodeData := vtDeal.GetNodeData(tmpVNode_Account);
//  tmpVNodeData.Caption := '�˻�[39008900]';
// ����˻�ͬʱ��ʾ���ұ�

  tmpVNode_Analysis := vtDeal.AddChild(nil);
  tmpVNodeData := vtDeal.GetNodeData(tmpVNode_Analysis);
  tmpVNodeData.Caption := 'Ͷ�ʷ���';
                                                
  tmpVNode_DealHistorys := vtDeal.AddChild(tmpVNode_Account);
  tmpVNodeData := vtDeal.GetNodeData(tmpVNode_DealHistorys);
  tmpVNodeData.Caption := 'ȫ��Ͷ�ʼ�¼';
                                            
  tmpVNode_DealPeriod := vtDeal.AddChild(tmpVNode_DealHistorys);
  tmpVNodeData := vtDeal.GetNodeData(tmpVNode_DealPeriod);
  tmpVNodeData.Caption := '2016-06';
                                           
  tmpVNode_DealPeriod := vtDeal.AddChild(tmpVNode_DealHistorys);
  tmpVNodeData := vtDeal.GetNodeData(tmpVNode_DealPeriod);
  tmpVNodeData.Caption := '2016-05';
                                           
  tmpVNode_DealPeriod := vtDeal.AddChild(tmpVNode_DealHistorys);
  tmpVNodeData := vtDeal.GetNodeData(tmpVNode_DealPeriod);
  tmpVNodeData.Caption := '2016-04';  
  vtDeal.FullExpand(tmpVNode_Account);     
end;

procedure TfrmDealHistory.vtDealGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  tmpVNodeData: PDealSummaryNode;  
begin
  inherited;
  CellText := '';
  tmpVNodeData := Sender.GetNodeData(Node);
  if nil <> tmpVNodeData then
  begin
    CellText := tmpVNodeData.Caption;
  end;
  //
end;

end.
