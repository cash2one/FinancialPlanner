unit ctpDealForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  BaseForm;

type
  TfrmCtpDeal = class(TfrmBase)
    pnlQuery: TPanel;
    btnQueryMoney: TButton;
    btnQueryHold: TButton;
    edtHold: TEdit;
    pnlDealBuy: TPanel;
    lblDealItem: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtDealBuyItem: TEdit;
    edtDealBuyPrice: TEdit;
    edtDealBuyNum: TEdit;
    btnDealBuy: TButton;
    rgDealBuyMode: TRadioGroup;
    pnlInit: TPanel;
    btnInitDeal: TButton;
    btnConnectDeal: TButton;
    edtAddrDeal: TComboBox;
    pnlLogin: TPanel;
    lblAccount: TLabel;
    lblPassowrd: TLabel;
    lblBrokeId: TLabel;
    btnLoginDeal: TButton;
    edtAccount: TComboBox;
    edtPassword: TEdit;
    edtBrokeId: TComboBox;
    btnLogoutDeal: TButton;
    pnlDealSale: TPanel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    edtDealSaleItem: TEdit;
    edtDealSalePrice: TEdit;
    edtDealSaleNum: TEdit;
    btnDealSale: TButton;
    rgDealSaleMode: TRadioGroup;
    btnShutDown: TButton;
    mmo1: TMemo;
    btnConfirmSettlement: TButton;
    procedure btnInitDealClick(Sender: TObject);
    procedure btnConnectDealClick(Sender: TObject);
    procedure btnLoginDealClick(Sender: TObject);
    procedure btnConfirmSettlementClick(Sender: TObject);
    procedure btnLogoutDealClick(Sender: TObject);
    procedure btnShutDownClick(Sender: TObject);
    procedure btnDealBuyClick(Sender: TObject);
    procedure btnDealSaleClick(Sender: TObject);
  protected                         
    procedure CreateParams(var Params: TCreateParams); override;    
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  TcpAgentConsole,
  define_app_msg,
  define_ctp_deal,
  TcpInitUtils;
  
constructor TfrmCtpDeal.Create(Owner: TComponent);
begin
  inherited;
end;
  
procedure TfrmCtpDeal.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WinClassName := 'WndCtpDeal';
  Params.Caption := '';
  Self.Caption := '';
end;

procedure TfrmCtpDeal.btnInitDealClick(Sender: TObject);
begin
  GTcpAgentConsole.InitDeal;
end;

procedure TfrmCtpDeal.btnConnectDealClick(Sender: TObject);
var
  tmpAddr: AnsiString;
  tmpAddrDesc: AnsiString;
begin
  tmpAddrDesc := Trim(edtAddrDeal.Text);
  tmpAddr := ParseAddress(tmpAddrDesc);
  SaveIniAddress(tmpAddrDesc, tmpAddr, 'DealUrl');
  GTcpAgentConsole.ConnectDeal(tmpAddr);
end;

procedure TfrmCtpDeal.btnShutDownClick(Sender: TObject);
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    SendMessage(GTcpAgentConsole.SrvWND, WM_C2S_Shutdown, 0, 0);
  end;
end;

procedure TfrmCtpDeal.btnLoginDealClick(Sender: TObject);
begin
  GTcpAgentConsole.LoginDeal(Trim(edtBrokeId.Text), Trim(edtAccount.Text), Trim(edtPassword.Text));
  SaveIniAccount(edtBrokeId.Text, edtAccount.Text);
end;

procedure TfrmCtpDeal.btnConfirmSettlementClick(Sender: TObject);
begin
  GTcpAgentConsole.ConfirmSettlementInfo;
end;

procedure TfrmCtpDeal.btnLogoutDealClick(Sender: TObject);
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    SendMessage(GTcpAgentConsole.SrvWND, WM_C2S_Deal_RequestUserLogout, GTcpAgentConsole.CheckOutRequestId, 0);
  end;
end;

procedure TfrmCtpDeal.btnDealBuyClick(Sender: TObject);
var
  tmpDeal: PDeal;
  tmpNum: Integer;
  tmpPrice: double;
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    tmpNum := StrToIntDef(edtDealBuyNum.text, 0);
    if tmpNum < 1 then
      exit;
    if tmpNum > 1 then
      exit;
    tmpPrice := StrToFloatDef(edtDealBuyPrice.text, 0);
    if tmpPrice < 0 then
      exit;
    tmpDeal := GTcpAgentConsole.Deal.CheckOutDeal;
    if tmpDeal <> nil then
    begin
      tmpDeal.OrderRequest.Direction := directionBuy; // 买
      if rgDealBuyMode.ItemIndex = 0 then
        tmpDeal.OrderRequest.Mode := modeOpen; // 开仓
      if rgDealBuyMode.ItemIndex = 1 then
        tmpDeal.OrderRequest.Mode := modeCloseNow; // 平仓
      if rgDealBuyMode.ItemIndex = 2 then
        tmpDeal.OrderRequest.Mode := modeCloseOut; // 平仓

      tmpDeal.OrderRequest.InstrumentID := Trim(edtDealBuyItem.Text);
      tmpDeal.OrderRequest.Price := tmpPrice;
      tmpDeal.OrderRequest.Num := tmpNum;
      GTcpAgentConsole.Deal.RunDeal(tmpDeal);
    end;
  end;
end;

procedure TfrmCtpDeal.btnDealSaleClick(Sender: TObject);
var
  tmpDeal: PDeal;
  tmpNum: Integer;
  tmpPrice: double;
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    tmpNum := StrToIntDef(edtDealSaleNum.text, 0);
    if tmpNum < 1 then
      exit;
    if tmpNum > 1 then
      exit;
    tmpPrice := StrToFloatDef(edtDealSalePrice.text, 0);
    if tmpPrice < 0 then
      exit;
    tmpDeal := GTcpAgentConsole.Deal.CheckOutDeal;
    if tmpDeal <> nil then
    begin
      tmpDeal.OrderRequest.Direction := directionSale; // 卖

      if rgDealSaleMode.ItemIndex = 0 then
        tmpDeal.OrderRequest.Mode := modeOpen; // 开仓
      if rgDealSaleMode.ItemIndex = 1 then
        tmpDeal.OrderRequest.Mode := modeCloseNow; // 平仓
      if rgDealSaleMode.ItemIndex = 2 then
        tmpDeal.OrderRequest.Mode := modeCloseOut; // 平仓

      tmpDeal.OrderRequest.InstrumentID := Trim(edtDealSaleItem.Text);
      tmpDeal.OrderRequest.Price := tmpPrice;
      tmpDeal.OrderRequest.Num := tmpNum;
      GTcpAgentConsole.Deal.RunDeal(tmpDeal);
    end;
  end;
end;

end.
