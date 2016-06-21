unit dealHistoryForm;

interface

uses
  Forms, Classes, Controls, StdCtrls, SysUtils,
  BaseForm, ExtCtrls, VirtualTrees;

type
  TfrmDealHistory = class(TfrmBase)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlMain: TPanel;
    pnlDeal: TPanel;
    vtDeal: TVirtualStringTree;
  protected
  public
    constructor Create(AOwner: TComponent); override;
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

end.
