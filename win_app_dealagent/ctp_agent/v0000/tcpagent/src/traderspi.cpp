#include <iostream>
#include <vector>

using namespace std;
#include "api/trade/win/public/ThostFtdcTraderApi.h"
#include "traderspi.h"
#include "./config.h"
#include "windows.h"

#pragma warning(disable :4996)

// �Ự����
int	 g_deal_frontId;	//ǰ�ñ��
int	 g_deal_sessionId;	//�Ự���
char g_deal_orderRef[13];

//vector<CThostFtdcOrderField*> g_orderList;
//vector<CThostFtdcTradeField*> g_tradeList;

char MapDirection(char src);
char MapOffset(char src);
    


void CtpTraderSpi::OnFrontConnected()
{
	SendMessage(fwndHost, WM_S2C_Deal_FrontConnected, 0, 0);
	//cerr<<" ���ӽ���ǰ��...�ɹ�"<<endl;
}

void CtpTraderSpi::ReqUserLogin(TThostFtdcBrokerIDType ABrokerID, TThostFtdcUserIDType	AUserId, TThostFtdcPasswordType APassword, int ARequestId)
{
  
	CThostFtdcReqUserLoginField req;
	memset(&req, 0, sizeof(req));
	//strcpy(req.BrokerID, vAppId); 
	strcpy(req.BrokerID, ABrokerID);

	//strcpy(appId, vAppId); 
	//strcpy(g_brokerId, ABrokerID);

	//strcpy(req.UserID, vUserId);  
	strcpy(req.UserID, AUserId);

	//strcpy(userId, vUserId); 
	//strcpy(g_userId, AUserId);

	//strcpy(req.Password, vPasswd);
	strcpy(req.Password, APassword);

	int ret = fTraderApi->ReqUserLogin(&req, ARequestId);
	if (0 == ret) {

	}
	else {
	}
	//	cerr << " ���� | ���͵�¼..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;
}

void CtpTraderSpi::OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin,
		CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if ( !IsErrorRspInfo(pRspInfo) && pRspUserLogin ) {  
    // ����Ự����	
		g_deal_frontId = pRspUserLogin->FrontID;
		g_deal_sessionId = pRspUserLogin->SessionID;
		int nextOrderRef = atoi(pRspUserLogin->MaxOrderRef);
		sprintf(g_deal_orderRef, "%d", ++nextOrderRef);

		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_Deal_RspUserLogin;
		CopyData.cbData = sizeof(CThostFtdcRspUserLoginField);
		CopyData.lpData = pRspUserLogin;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);

	//		cerr << " ��Ӧ | ��¼�ɹ�...��ǰ������:"
		//			<< pRspUserLogin->TradingDay << endl;
		SendMessage(fwndHost, WM_S2C_Deal_RspUserLogin, 1, nRequestID);
	}
	else {
		SendMessage(fwndHost, WM_S2C_Deal_RspUserLogin, 100, nRequestID);
	}
}

void CtpTraderSpi::ReqSettlementInfoConfirm(TThostFtdcBrokerIDType ABrokerID, TThostFtdcUserIDType	AUserId, int ARequestId)
{
	CThostFtdcSettlementInfoConfirmField req;
	memset(&req, 0, sizeof(req));
	strcpy(req.BrokerID, ABrokerID);
	strcpy(req.InvestorID, AUserId);
	int ret = fTraderApi->ReqSettlementInfoConfirm(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
	//	cerr << " ���� | ���ͽ��㵥ȷ��..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;
}

void CtpTraderSpi::OnRspSettlementInfoConfirm(
        CThostFtdcSettlementInfoConfirmField  *pSettlementInfoConfirm, 
        CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pSettlementInfoConfirm){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspSettlementInfoConfirm;
		CopyData.cbData = sizeof(CThostFtdcSettlementInfoConfirmField);
		CopyData.lpData = pSettlementInfoConfirm;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
		//	cerr << " ��Ӧ | ���㵥..." << pSettlementInfoConfirm->InvestorID
		//		<< "...<" << pSettlementInfoConfirm->ConfirmDate
		//	<< " " << pSettlementInfoConfirm->ConfirmTime << ">...ȷ��" << endl;
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspSettlementInfoConfirm, 100, nRequestID);
	}
}

///�ͻ�����֤���� 
void CtpTraderSpi::ReqAuthenticate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID) {
	CThostFtdcReqAuthenticateField tmpreq;
	///���͹�˾����
	strcpy(tmpreq.BrokerID, ABrokerId);
	///�û�����
	strcpy(tmpreq.UserID, AUserId);
	///�û��˲�Ʒ��Ϣ
	//TThostFtdcProductInfoType	tmpreq.UserProductInfo;
	///��֤��
	//TThostFtdcAuthCodeType	tmpreq.AuthCode;
	int ret = fTraderApi->ReqAuthenticate(&tmpreq, ARequestID);
	if (0 == ret) {
	}
	else {
	}
}

///�ǳ�����
void CtpTraderSpi::ReqUserLogout(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID) {
	CThostFtdcUserLogoutField tmpreq;
	strcpy(tmpreq.BrokerID, ABrokerId);
	strcpy(tmpreq.UserID, AUserId);
	int ret = fTraderApi->ReqUserLogout(&tmpreq, ARequestID);
	if (0 == ret) {
	}
	else {
	}
}

///�û������������
void CtpTraderSpi::ReqUserPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, 
	TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID) {
	CThostFtdcUserPasswordUpdateField tmpreq;
	///���͹�˾����
	strcpy(tmpreq.BrokerID, ABrokerId);
	///�û�����
	strcpy(tmpreq.UserID, AUserId);
	///ԭ���Ŀ���
	strcpy(tmpreq.OldPassword, AOldPassword);
	///�µĿ���
	strcpy(tmpreq.NewPassword, ANewPassword);
	int ret = fTraderApi->ReqUserPasswordUpdate(&tmpreq, ARequestID);
	if (0 == ret) {
	}
	else {
	}
}

///�ʽ��˻������������
void CtpTraderSpi::ReqTradingAccountPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcAccountIDType AccountID,
	TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID) {
	CThostFtdcTradingAccountPasswordUpdateField tmpreq;
	///���͹�˾����
	strcpy(tmpreq.BrokerID, ABrokerId);
	///Ͷ�����ʺ�
	strcpy(tmpreq.AccountID, AccountID);
	///ԭ���Ŀ���
	strcpy(tmpreq.OldPassword, AOldPassword);
	///�µĿ���
	strcpy(tmpreq.NewPassword, ANewPassword);
	///���ִ���
	strcpy(tmpreq.CurrencyID, "CNY");
	int ret = fTraderApi->ReqTradingAccountPasswordUpdate(&tmpreq, ARequestID);
	if (0 == ret) {
	}
	else {
	}
}

void CtpTraderSpi::ReqQryInstrument(TThostFtdcInstrumentIDType instId, int ARequestId)
{
	CThostFtdcQryInstrumentField req;
	memset(&req, 0, sizeof(req));
  strcpy(req.InstrumentID, instId);//Ϊ�ձ�ʾ��ѯ���к�Լ
  int ret = fTraderApi->ReqQryInstrument(&req, ARequestId);
  if (0 == ret) {
  }
  else {
  }
	//  cerr << " ���� | ���ͺ�Լ��ѯ..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;
}

void CtpTraderSpi::OnRspQryInstrument(CThostFtdcInstrumentField *pInstrument, 
         CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pInstrument){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryInstrument;
		CopyData.cbData = sizeof(CThostFtdcInstrumentField);
		CopyData.lpData = pInstrument;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
	//		cerr << " ��Ӧ | ��Լ:" << pInstrument->InstrumentID
		//			<< " ������:" << pInstrument->DeliveryMonth
		//	<< " ��ͷ��֤����:" << pInstrument->LongMarginRatio
		//	<< " ��ͷ��֤����:" << pInstrument->ShortMarginRatio << endl;
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspQryInstrument, 100, nRequestID);
	}
}

void CtpTraderSpi::ReqQryOrder(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AInvestorID,
	TThostFtdcInstrumentIDType AInstrumentID, TThostFtdcExchangeIDType AExchangeID,
	TThostFtdcOrderSysIDType AOrderSysID, TThostFtdcTimeType AInsertTimeStart,
	TThostFtdcTimeType AInsertTimeEnd, int ARequestId)
{
	CThostFtdcQryOrderField tmpreq;
	memset(&tmpreq, 0, sizeof(tmpreq));
	///���͹�˾����  TThostFtdcBrokerIDType	
	strcpy(tmpreq.BrokerID, ABrokerId);
	///Ͷ���ߴ���  TThostFtdcInvestorIDType
	strcpy(tmpreq.InvestorID, AInvestorID);
	///��Լ����  TThostFtdcInstrumentIDType
	strcpy(tmpreq.InstrumentID, AInstrumentID);
	///����������  TThostFtdcExchangeIDType
	strcpy(tmpreq.ExchangeID, AExchangeID);
	///�������  TThostFtdcOrderSysIDType
	strcpy(tmpreq.OrderSysID, AOrderSysID);
	///��ʼʱ��  TThostFtdcTimeType
	strcpy(tmpreq.InsertTimeStart, AInsertTimeStart);
	///����ʱ��  TThostFtdcTimeType
	strcpy(tmpreq.InsertTimeEnd, AInsertTimeEnd);
	int ret = fTraderApi->ReqQryOrder(&tmpreq, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�����ѯ������Ӧ
void CtpTraderSpi::OnRspQryOrder(CThostFtdcOrderField *pOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
	if (!IsErrorRspInfo(pRspInfo) && pOrder){
		//SendMessage(fwndHost, WM_S2C_RspQryOrder, 0, 0);
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryOrder;
		CopyData.cbData = sizeof(CThostFtdcOrderField);
		CopyData.lpData = pOrder;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspQryOrder, 100, nRequestID);
	}
}

void CtpTraderSpi::ReqQryTrade(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AInvestorID,
	TThostFtdcInstrumentIDType AInstrumentID, TThostFtdcExchangeIDType AExchangeID,
	TThostFtdcTradeIDType ATradeID, TThostFtdcTimeType ATradeTimeStart,
	TThostFtdcTimeType ATradeTimeEnd, int ARequestId)
{
	CThostFtdcQryTradeField tmpreq;
	memset(&tmpreq, 0, sizeof(tmpreq));
	strcpy(tmpreq.BrokerID, ABrokerId);
	///Ͷ���ߴ���
	strcpy(tmpreq.InvestorID, AInvestorID);
	///��Լ����
	strcpy(tmpreq.InstrumentID, AInstrumentID);
	///����������
	strcpy(tmpreq.ExchangeID, AExchangeID);
	///�ɽ����
	strcpy(tmpreq.TradeID, ATradeID);
	///��ʼʱ��
	strcpy(tmpreq.TradeTimeStart, ATradeTimeStart);
	///����ʱ��
	strcpy(tmpreq.TradeTimeEnd, ATradeTimeEnd);
	int ret = fTraderApi->ReqQryTrade(&tmpreq, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�����ѯ�ɽ���Ӧ
void CtpTraderSpi::OnRspQryTrade(CThostFtdcTradeField *pTrade, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
	if (!IsErrorRspInfo(pRspInfo) && pTrade){
		//SendMessage(fwndHost, WM_S2C_RspQryTrade, 0, 0);
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryTrade;
		CopyData.cbData = sizeof(CThostFtdcTradeField);
		CopyData.lpData = pTrade;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspQryTrade, 100, nRequestID);
	}
}

void CtpTraderSpi::ReqQryTradingAccount(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcCurrencyIDType ACurrencyID, int ARequestId)
{

	//TThostFtdcBrokerIDType	BrokerID;
	///Ͷ���ߴ���
	//TThostFtdcInvestorIDType	InvestorID;
	///���ִ���
	//TThostFtdcCurrencyIDType	CurrencyID;

	CThostFtdcQryTradingAccountField req;
	memset(&req, 0, sizeof(req));
	//strcpy(req.BrokerID, appId);
	strcpy(req.BrokerID, ABrokerId);
	//strcpy(req.InvestorID, userId);
	strcpy(req.InvestorID, AUserId);
	strcpy(req.CurrencyID, ACurrencyID); //"CNY"
	int ret = fTraderApi->ReqQryTradingAccount(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
		//	cerr << " ���� | �����ʽ��ѯ..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;

}

void CtpTraderSpi::OnRspQryTradingAccount(
    CThostFtdcTradingAccountField *pTradingAccount, 
   CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	//SendMessage(fhostwindow, WM_S2C_RspQryTradingAccount, 0, 0);
	if (!IsErrorRspInfo(pRspInfo) && pTradingAccount){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryTradingAccount;
		CopyData.cbData = sizeof(CThostFtdcTradingAccountField);
		CopyData.lpData = pTradingAccount;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
		/*//
			cerr
				<< " BrokerID:" << pTradingAccount->BrokerID
				<< " AccountID:" << pTradingAccount->AccountID
				<< " PreMortgage:" << pTradingAccount->PreMortgage
				<< " PreCredit:" << pTradingAccount->PreCredit
				<< " PreDeposit:" << pTradingAccount->PreDeposit
				<< " PreBalance:" << pTradingAccount->PreBalance //�ϴν���׼����
				<< " PreMargin:" << pTradingAccount->PreMargin
				<< " InterestBase:" << pTradingAccount->InterestBase
				<< " Interest:" << pTradingAccount->Interest
				<< " Deposit:" << pTradingAccount->Deposit
				<< " Withdraw:" << pTradingAccount->Withdraw
				<< " ���ᱣ֤��:" << pTradingAccount->FrozenMargin
				<< " FrozenCash:" << pTradingAccount->FrozenCash
				<< " FrozenCommission:" << pTradingAccount->FrozenCommission
				<< " ��֤��:" << pTradingAccount->CurrMargin //��ǰ��֤���ܶ�
				<< " CashIn:" << pTradingAccount->CashIn
				<< " ������:" << pTradingAccount->Commission
				<< " ƽ��ӯ��:" << pTradingAccount->CloseProfit
				<< " �ֲ�ӯ��" << pTradingAccount->PositionProfit
				<< " ��Ӧ | Ȩ��:" << pTradingAccount->Balance // �ڻ�����׼����
				<< " ����:" << pTradingAccount->Available   // �����ʽ�
				<< " WithdrawQuota:" << pTradingAccount->WithdrawQuota
				<< " Reserve:" << pTradingAccount->Reserve
				<< " TradingDay:" << pTradingAccount->TradingDay
				<< " SettlementID:" << pTradingAccount->SettlementID
				<< " Mortgage:" << pTradingAccount->Mortgage
				<< " ExchangeMargin:" << pTradingAccount->ExchangeMargin
				<< " DeliveryMargin:" << pTradingAccount->DeliveryMargin
				<< " ExchangeDeliveryMargin:" << pTradingAccount->ExchangeDeliveryMargin
				<< " ReserveBalance:" << pTradingAccount->ReserveBalance
				<< " CurrencyID:" << pTradingAccount->CurrencyID
				<< " PreFundMortgageIn:" << pTradingAccount->PreFundMortgageIn
				<< " PreFundMortgageOut:" << pTradingAccount->PreFundMortgageOut
				<< " FundMortgageIn:" << pTradingAccount->FundMortgageIn
				<< " FundMortgageOut:" << pTradingAccount->FundMortgageOut
				<< " FundMortgageAvailable:" << pTradingAccount->FundMortgageAvailable
				<< " MortgageableFund:" << pTradingAccount->MortgageableFund
				<< " SpecProductMargin:" << pTradingAccount->SpecProductMargin
				<< " SpecProductFrozenMargin:" << pTradingAccount->SpecProductFrozenMargin
				<< " SpecProductCommission:" << pTradingAccount->SpecProductCommission
				<< " SpecProductFrozenCommission:" << pTradingAccount->SpecProductFrozenCommission
				<< " SpecProductPositionProfit:" << pTradingAccount->SpecProductPositionProfit
				<< " SpecProductCloseProfit:" << pTradingAccount->SpecProductCloseProfit
				<< " SpecProductPositionProfitByAlg:" << pTradingAccount->SpecProductPositionProfitByAlg
				<< " SpecProductExchangeMargin:" << pTradingAccount->SpecProductExchangeMargin
				<< endl;
			//*/
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspQryTradingAccount, 100, nRequestID);
	}
}

///�����ѯͶ����
void CtpTraderSpi::ReqQryInvestor(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AUserId, int ARequestId)
{
	CThostFtdcQryInvestorField req;
	///���͹�˾����
	strcpy(req.BrokerID, ABrokerId);
	///Ͷ���ߴ���
	strcpy(req.InvestorID, AUserId);
	int ret = fTraderApi->ReqQryInvestor(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

void CtpTraderSpi::OnRspQryInvestor(CThostFtdcInvestorField *pInvestor, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	/*//
	///Ͷ���ߴ���
	TThostFtdcInvestorIDType	InvestorID;
	///���͹�˾����
	TThostFtdcBrokerIDType	BrokerID;
	///Ͷ���߷������
	TThostFtdcInvestorIDType	InvestorGroupID;
	///Ͷ��������
	TThostFtdcPartyNameType	InvestorName;
	///֤������
	TThostFtdcIdCardTypeType	IdentifiedCardType;
	///֤������
	TThostFtdcIdentifiedCardNoType	IdentifiedCardNo;
	///�Ƿ��Ծ
	TThostFtdcBoolType	IsActive;
	///��ϵ�绰
	TThostFtdcTelephoneType	Telephone;
	///ͨѶ��ַ
	TThostFtdcAddressType	Address;
	///��������
	TThostFtdcDateType	OpenDate;
	///�ֻ�
	TThostFtdcMobileType	Mobile;
	///��������ģ�����
	TThostFtdcInvestorIDType	CommModelID;
	///��֤����ģ�����
	TThostFtdcInvestorIDType	MarginModelID;
	//*/
}

void CtpTraderSpi::ReqQryInvestorPosition(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcInstrumentIDType instId, int ARequestId)
{
	CThostFtdcQryInvestorPositionField req;
	memset(&req, 0, sizeof(req));
	strcpy(req.BrokerID, ABrokerId);
	strcpy(req.InvestorID, AUserId);
	strcpy(req.InstrumentID, instId);	
	int ret = fTraderApi->ReqQryInvestorPosition(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
		//cerr << " ���� | ���ͳֲֲ�ѯ..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;
}

void CtpTraderSpi::OnRspQryInvestorPosition(
    CThostFtdcInvestorPositionField *pInvestorPosition, 
    CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pInvestorPosition){
		if (NULL == pInvestorPosition) {
			// û���κγֲ�
			SendMessage(fwndHost, WM_S2C_RspQryInvestorPosition, 0, nRequestID);
		}
		else {
			SendMessage(fwndHost, WM_S2C_RspQryInvestorPosition, 1, nRequestID);
		}
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryInvestorPosition;
		CopyData.cbData = sizeof(CThostFtdcInvestorPositionField);
		CopyData.lpData = pInvestorPosition;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
			//cerr << " ��Ӧ | ��Լ:" << pInvestorPosition->InstrumentID
		//	<< " ����:" << MapDirection(pInvestorPosition->PosiDirection - 2, false)
		//	<< " �ֲܳ�:" << pInvestorPosition->Position
		//	<< " ���:" << pInvestorPosition->YdPosition
		//	<< " ���:" << pInvestorPosition->TodayPosition
		//	<< " �ֲ�ӯ��:" << pInvestorPosition->PositionProfit
		//	<< " ��֤��:" << pInvestorPosition->UseMargin << endl;
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspQryInvestorPosition, 100, nRequestID);
	}
}

void CtpTraderSpi::ReqOrderInsert(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, 
	TThostFtdcInstrumentIDType instId,
    TThostFtdcDirectionType dir, TThostFtdcCombOffsetFlagType kpp,
	TThostFtdcPriceType price, TThostFtdcVolumeType vol, int ARequestId)
{
	CThostFtdcInputOrderField req;
	memset(&req, 0, sizeof(req));	
	strcpy(req.BrokerID, ABrokerId);  //Ӧ�õ�Ԫ����	
	strcpy(req.InvestorID, AUserId); //Ͷ���ߴ���	
	strcpy(req.InstrumentID, instId); //��Լ����	
	strcpy(req.OrderRef, g_deal_orderRef);  //��������
	int nextOrderRef = atoi(g_deal_orderRef);
	sprintf(g_deal_orderRef, "%d", ++nextOrderRef);
  
  req.LimitPrice = price;	//�۸�
  if(0==req.LimitPrice){
	  req.OrderPriceType = THOST_FTDC_OPT_AnyPrice;//�۸�����=�м�
	  req.TimeCondition = THOST_FTDC_TC_IOC;//��Ч������:������ɣ�������
  }else{
    req.OrderPriceType = THOST_FTDC_OPT_LimitPrice;//�۸�����=�޼�	
    req.TimeCondition = THOST_FTDC_TC_GFD;  //��Ч������:������Ч
  }
  req.Direction = MapDirection(dir);  //��������	
  req.CombOffsetFlag[0] = MapOffset(kpp[0]); //��Ͽ�ƽ��־:����
	req.CombHedgeFlag[0] = THOST_FTDC_HF_Speculation;	  //���Ͷ���ױ���־	
	req.VolumeTotalOriginal = vol;	///����		
	req.VolumeCondition = THOST_FTDC_VC_AV; //�ɽ�������:�κ�����
	req.MinVolume = 1;	//��С�ɽ���:1	
	req.ContingentCondition = THOST_FTDC_CC_Immediately;  //��������:����
	
  //TThostFtdcPriceType	StopPrice;  //ֹ���
	req.ForceCloseReason = THOST_FTDC_FCC_NotForceClose;	//ǿƽԭ��:��ǿƽ	
	req.IsAutoSuspend = 0;  //�Զ������־:��	
	req.UserForceClose = 0;   //�û�ǿ����־:��

	int ret = fTraderApi->ReqOrderInsert(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}

		//cerr << " ���� | ���ͱ���..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;
}

void CtpTraderSpi::OnRspOrderInsert(CThostFtdcInputOrderField *pInputOrder, 
          CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pInputOrder){
		//	cerr << "��Ӧ | �����ύ�ɹ�...��������:" << pInputOrder->OrderRef << endl;
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspOrderInsert;
		CopyData.cbData = sizeof(CThostFtdcInputOrderField);
		CopyData.lpData = pInputOrder;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspOrderInsert, 100, nRequestID);
	}
}

// �����ѯ��Լ��������
void CtpTraderSpi::ReqQryInstrumentCommissionRate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId,
	TThostFtdcInstrumentIDType instId, int ARequestId)
{
	CThostFtdcQryInstrumentCommissionRateField req;
	strcpy(req.BrokerID, ABrokerId);  //Ӧ�õ�Ԫ����	
	strcpy(req.InvestorID, AUserId); //Ͷ���ߴ���	
	strcpy(req.InstrumentID, instId); //��Լ����	

	int ret = fTraderApi->ReqQryInstrumentCommissionRate(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�����ѯ��Լ����������Ӧ
void CtpTraderSpi::OnRspQryInstrumentCommissionRate(CThostFtdcInstrumentCommissionRateField *pInstrumentCommissionRate, 
	CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
	if (!IsErrorRspInfo(pRspInfo) && pInstrumentCommissionRate){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryInstrumentCommissionRate;
		CopyData.cbData = sizeof(CThostFtdcInstrumentCommissionRateField);
		CopyData.lpData = pInstrumentCommissionRate;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
		//	cerr << " ��Ӧ | �����ɹ�..."
		//		<< "������:" << pInputOrderAction->ExchangeID
		//	<< " �������:" << pInputOrderAction->OrderSysID << endl;
	}
	else {
	}
};

void CtpTraderSpi::ReqQryContractBank(TThostFtdcBrokerIDType ABrokerId, TThostFtdcBankIDType ABankID, TThostFtdcBankBrchIDType	ABankBrchID, int ARequestId) {
	///�����ѯǩԼ����
	CThostFtdcQryContractBankField req;
	///���͹�˾����
	strcpy(req.BrokerID, ABrokerId); 
	///���д���
	strcpy(req.BankID, ABankID);  
	///���з����Ĵ���
	strcpy(req.BankBrchID, ABankBrchID);
	int ret = fTraderApi->ReqQryContractBank(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�����ѯǩԼ������Ӧ
void CtpTraderSpi::OnRspQryContractBank(CThostFtdcContractBankField *pContractBank, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

void CtpTraderSpi::ReqQryAccountregister(TThostFtdcBrokerIDType ABrokerId, 
	  TThostFtdcAccountIDType	AccountID, 
	  TThostFtdcBankIDType	ABankID, 
	  TThostFtdcBankBrchIDType ABankBranchID, int ARequestId) {
	///�����ѯ����ǩԼ��ϵ
	CThostFtdcQryAccountregisterField req;
	///���͹�˾����
	strcpy(req.BrokerID, ABrokerId);
	///Ͷ�����ʺ�
	strcpy(req.AccountID, AccountID);
	///���б���
	strcpy(req.BankID, ABankID);
	///���з�֧��������
	strcpy(req.BankBranchID, ABankBranchID);
	///���ִ���
	strcpy(req.CurrencyID, "CNY");
	int ret = fTraderApi->ReqQryAccountregister(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�����ѯ����ǩԼ��ϵ��Ӧ
void CtpTraderSpi::OnRspQryAccountregister(CThostFtdcAccountregisterField *pAccountregister, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

void CtpTraderSpi::ReqFromBankToFutureByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId) {

	///�ڻ����������ʽ�ת�ڻ�����
	CThostFtdcReqTransferField req;
	/*//
	///ҵ������
	TThostFtdcTradeCodeType	TradeCode;
	///���д���
	TThostFtdcBankIDType	BankID;
	///���з�֧��������
	TThostFtdcBankBrchIDType	BankBranchID;
	///���̴���
	TThostFtdcBrokerIDType	BrokerID;
	///���̷�֧��������
	TThostFtdcFutureBranchIDType	BrokerBranchID;
	///��������
	TThostFtdcTradeDateType	TradeDate;
	///����ʱ��
	TThostFtdcTradeTimeType	TradeTime;
	///������ˮ��
	TThostFtdcBankSerialType	BankSerial;
	///����ϵͳ���� 
	TThostFtdcTradeDateType	TradingDay;
	///����ƽ̨��Ϣ��ˮ��
	TThostFtdcSerialType	PlateSerial;
	///����Ƭ��־
	TThostFtdcLastFragmentType	LastFragment;
	///�Ự��
	TThostFtdcSessionIDType	SessionID;
	///�ͻ�����
	TThostFtdcIndividualNameType	CustomerName;
	///֤������
	TThostFtdcIdCardTypeType	IdCardType;
	///֤������
	TThostFtdcIdentifiedCardNoType	IdentifiedCardNo;
	///�ͻ�����
	TThostFtdcCustTypeType	CustType;
	///�����ʺ�
	TThostFtdcBankAccountType	BankAccount;
	///��������
	TThostFtdcPasswordType	BankPassWord;
	///Ͷ�����ʺ�
	TThostFtdcAccountIDType	AccountID;
	///�ڻ�����
	TThostFtdcPasswordType	Password;
	///��װ���
	TThostFtdcInstallIDType	InstallID;
	///�ڻ���˾��ˮ��
	TThostFtdcFutureSerialType	FutureSerial;
	///�û���ʶ
	TThostFtdcUserIDType	UserID;
	///��֤�ͻ�֤�������־
	TThostFtdcYesNoIndicatorType	VerifyCertNoFlag;
	///���ִ���
	TThostFtdcCurrencyIDType	CurrencyID;
	///ת�ʽ��
	TThostFtdcTradeAmountType	TradeAmount;
	///�ڻ���ȡ���
	TThostFtdcTradeAmountType	FutureFetchAmount;
	///����֧����־
	TThostFtdcFeePayFlagType	FeePayFlag;
	///Ӧ�տͻ�����
	TThostFtdcCustFeeType	CustFee;
	///Ӧ���ڻ���˾����
	TThostFtdcFutureFeeType	BrokerFee;
	///���ͷ������շ�����Ϣ
	TThostFtdcAddInfoType	Message;
	///ժҪ
	TThostFtdcDigestType	Digest;
	///�����ʺ�����
	TThostFtdcBankAccTypeType	BankAccType;
	///������־
	TThostFtdcDeviceIDType	DeviceID;
	///�ڻ���λ�ʺ�����
	TThostFtdcBankAccTypeType	BankSecuAccType;
	///�ڻ���˾���б���
	TThostFtdcBankCodingForFutureType	BrokerIDByBank;
	///�ڻ���λ�ʺ�
	TThostFtdcBankAccountType	BankSecuAcc;
	///���������־
	TThostFtdcPwdFlagType	BankPwdFlag;
	///�ڻ��ʽ�����˶Ա�־
	TThostFtdcPwdFlagType	SecuPwdFlag;
	///���׹�Ա
	TThostFtdcOperNoType	OperNo;
	///������
	TThostFtdcRequestIDType	RequestID;
	///����ID
	TThostFtdcTIDType	TID;
	///ת�˽���״̬
	TThostFtdcTransferStatusType	TransferStatus;
	//*/
	int ret = fTraderApi->ReqFromBankToFutureByFuture(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�ڻ����������ʽ�ת�ڻ�Ӧ��
void CtpTraderSpi::OnRspFromBankToFutureByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

///���з��������ʽ�ת�ڻ�֪ͨ
void CtpTraderSpi::OnRtnFromBankToFutureByBank(CThostFtdcRspTransferField *pRspTransfer) {
};

void CtpTraderSpi::ReqFromFutureToBankByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId) {
	///�ڻ������ڻ��ʽ�ת��������
	CThostFtdcReqTransferField req;
	/*//
	///ҵ������
	TThostFtdcTradeCodeType	TradeCode;
	///���д���
	TThostFtdcBankIDType	BankID;
	///���з�֧��������
	TThostFtdcBankBrchIDType	BankBranchID;
	///���̴���
	TThostFtdcBrokerIDType	BrokerID;
	///���̷�֧��������
	TThostFtdcFutureBranchIDType	BrokerBranchID;
	///��������
	TThostFtdcTradeDateType	TradeDate;
	///����ʱ��
	TThostFtdcTradeTimeType	TradeTime;
	///������ˮ��
	TThostFtdcBankSerialType	BankSerial;
	///����ϵͳ����
	TThostFtdcTradeDateType	TradingDay;
	///����ƽ̨��Ϣ��ˮ��
	TThostFtdcSerialType	PlateSerial;
	///����Ƭ��־
	TThostFtdcLastFragmentType	LastFragment;
	///�Ự��
	TThostFtdcSessionIDType	SessionID;
	///�ͻ�����
	TThostFtdcIndividualNameType	CustomerName;
	///֤������
	TThostFtdcIdCardTypeType	IdCardType;
	///֤������
	TThostFtdcIdentifiedCardNoType	IdentifiedCardNo;
	///�ͻ�����
	TThostFtdcCustTypeType	CustType;
	///�����ʺ�
	TThostFtdcBankAccountType	BankAccount;
	///��������
	TThostFtdcPasswordType	BankPassWord;
	///Ͷ�����ʺ�
	TThostFtdcAccountIDType	AccountID;
	///�ڻ�����
	TThostFtdcPasswordType	Password;
	///��װ���
	TThostFtdcInstallIDType	InstallID;
	///�ڻ���˾��ˮ��
	TThostFtdcFutureSerialType	FutureSerial;
	///�û���ʶ
	TThostFtdcUserIDType	UserID;
	///��֤�ͻ�֤�������־
	TThostFtdcYesNoIndicatorType	VerifyCertNoFlag;
	///���ִ���
	TThostFtdcCurrencyIDType	CurrencyID;
	///ת�ʽ��
	TThostFtdcTradeAmountType	TradeAmount;
	///�ڻ���ȡ���
	TThostFtdcTradeAmountType	FutureFetchAmount;
	///����֧����־
	TThostFtdcFeePayFlagType	FeePayFlag;
	///Ӧ�տͻ�����
	TThostFtdcCustFeeType	CustFee;
	///Ӧ���ڻ���˾����
	TThostFtdcFutureFeeType	BrokerFee;
	///���ͷ������շ�����Ϣ
	TThostFtdcAddInfoType	Message;
	///ժҪ
	TThostFtdcDigestType	Digest;
	///�����ʺ�����
	TThostFtdcBankAccTypeType	BankAccType;
	///������־
	TThostFtdcDeviceIDType	DeviceID;
	///�ڻ���λ�ʺ�����
	TThostFtdcBankAccTypeType	BankSecuAccType;
	///�ڻ���˾���б���
	TThostFtdcBankCodingForFutureType	BrokerIDByBank;
	///�ڻ���λ�ʺ�
	TThostFtdcBankAccountType	BankSecuAcc;
	///���������־
	TThostFtdcPwdFlagType	BankPwdFlag;
	///�ڻ��ʽ�����˶Ա�־
	TThostFtdcPwdFlagType	SecuPwdFlag;
	///���׹�Ա
	TThostFtdcOperNoType	OperNo;
	///������
	TThostFtdcRequestIDType	RequestID;
	///����ID
	TThostFtdcTIDType	TID;
	///ת�˽���״̬
	TThostFtdcTransferStatusType	TransferStatus;
	//*/
	int ret = fTraderApi->ReqFromFutureToBankByFuture(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///�ڻ������ڻ��ʽ�ת����Ӧ��
void CtpTraderSpi::OnRspFromFutureToBankByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

///���з����ڻ��ʽ�ת����֪ͨ
void CtpTraderSpi::OnRtnFromFutureToBankByBank(CThostFtdcRspTransferField *pRspTransfer) {
};

void CtpTraderSpi::ReqOrderAction(TThostFtdcBrokerIDType ABrokerId, 
	TThostFtdcUserIDType AUserId, 
	TThostFtdcSequenceNoType AOrderSeq,
	TThostFtdcExchangeIDType AExchangeID,
	TThostFtdcOrderSysIDType AOrderSysID,
	int ARequestId)
{
  //bool found=false; 
	//unsigned int i=0;
	//for (i = 0; i<g_orderList.size(); i++){
	//if (g_orderList[i]->BrokerOrderSeq == orderSeq){ found = true; break; }
	//}
	//if (!found){
		//  cerr << " ���� | ����������." << endl;
	//return;
	//} 

	CThostFtdcInputOrderActionField req;
	memset(&req, 0, sizeof(req));
	strcpy(req.BrokerID, ABrokerId);   //���͹�˾����	
	strcpy(req.InvestorID, AUserId); //Ͷ���ߴ���
	//strcpy(req.OrderRef, pOrderRef); //��������	
	//req.FrontID = frontId;           //ǰ�ñ��	
	//req.SessionID = sessionId;       //�Ự���
	// TThostFtdcExchangeIDType	ExchangeID;
	strcpy(req.ExchangeID, AExchangeID);// g_orderList[i]->ExchangeID);
	strcpy(req.OrderSysID, AOrderSysID);// g_orderList[i]->OrderSysID);
	req.ActionFlag = THOST_FTDC_AF_Delete;  //������־ 

	int ret = fTraderApi->ReqOrderAction(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
		//cerr << " ���� | ���ͳ���..." << ((ret == 0) ? "�ɹ�" : "ʧ��") << endl;
}

void CtpTraderSpi::OnRspOrderAction(
      CThostFtdcInputOrderActionField *pInputOrderAction, 
      CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	//SendMessage(fwndHost, WM_S2C_RspOrderAction, 0, 0);
	if (!IsErrorRspInfo(pRspInfo) && pInputOrderAction){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspOrderAction;
		CopyData.cbData = sizeof(CThostFtdcInputOrderActionField);
		CopyData.lpData = pInputOrderAction;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
		//	cerr << " ��Ӧ | �����ɹ�..."
		//		<< "������:" << pInputOrderAction->ExchangeID
		//	<< " �������:" << pInputOrderAction->OrderSysID << endl;
	}
	else {
	}
}

///�����ر�
void CtpTraderSpi::OnRtnOrder(CThostFtdcOrderField *pOrder)
{
	//SendMessage(fwndHost, WM_S2C_RtnOrder, 0, 0);
	COPYDATASTRUCT CopyData;
	CopyData.dwData = WM_S2C_RtnOrder;
	CopyData.cbData = sizeof(CThostFtdcOrderField);
	CopyData.lpData = pOrder;

	SendMessage(fwndHost, WM_COPYDATA, (WPARAM)0, (LPARAM)&CopyData);
  /*//
  CThostFtdcOrderField* order = new CThostFtdcOrderField();
  memcpy(order,  pOrder, sizeof(CThostFtdcOrderField));
  bool founded=false;    
  unsigned int i=0;
  for (i = 0; i<g_orderList.size(); i++){
	if (g_orderList[i]->BrokerOrderSeq == order->BrokerOrderSeq) {
      founded=true;    
	  break;
    }
  }
  if (founded) {
	  g_orderList[i] = order;
  }
  else  {
	  g_orderList.push_back(order);
  }
  //*/
	 // cerr << " �ر� | �������ύ...���:" << order->BrokerOrderSeq << endl;
}

///�ɽ�֪ͨ
void CtpTraderSpi::OnRtnTrade(CThostFtdcTradeField *pTrade)
{
  /*//
  CThostFtdcTradeField* trade = new CThostFtdcTradeField();
  memcpy(trade,  pTrade, sizeof(CThostFtdcTradeField));
  bool founded=false;     
  unsigned int i=0;
  for (i = 0; i<g_tradeList.size(); i++){
	if (g_tradeList[i]->TradeID == trade->TradeID) {
      founded=true;   
	  break;
    }
  }
  if (founded) {
	  g_tradeList[i] = trade;
  }
  else {
	  g_tradeList.push_back(trade);
  }
  //*/
  //SendMessage(fwndHost, WM_S2C_RtnTrade, 0, 0);
  COPYDATASTRUCT CopyData;
  CopyData.dwData = WM_S2C_RtnTrade;
  CopyData.cbData = sizeof(CThostFtdcTradeField);
  CopyData.lpData = pTrade;

  SendMessage(fwndHost, WM_COPYDATA, (WPARAM)0, (LPARAM)&CopyData);

	 // cerr << " �ر� | �����ѳɽ�...�ɽ����:" << trade->TradeID << endl;
}

void CtpTraderSpi::OnFrontDisconnected(int nReason)
{
	SendMessage(fwndHost, WM_S2C_Deal_FrontDisconnected, nReason, 0);
	//	cerr << " ��Ӧ | �����ж�..."
	//		<< " reason=" << nReason << endl;
}
		
void CtpTraderSpi::OnHeartBeatWarning(int nTimeLapse)
{
	SendMessage(fwndHost, WM_S2C_Deal_HeartBeatWarning, nTimeLapse, 0);

		//cerr << " ��Ӧ | ������ʱ����..."
	//	<< " TimerLapse = " << nTimeLapse << endl;
}

void CtpTraderSpi::OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	bool ret = ((pRspInfo) && (pRspInfo->ErrorID != 0));
	if (ret) {
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_Deal_RspError;
		CopyData.cbData = sizeof(CThostFtdcRspInfoField);
		CopyData.lpData = pRspInfo;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
	}
	else {
		SendMessage(fwndHost, WM_S2C_Deal_RspError, 100, nRequestID);
	}
	//IsErrorRspInfo(pRspInfo);
}

bool CtpTraderSpi::IsErrorRspInfo(CThostFtdcRspInfoField *pRspInfo)
{
	// ���ErrorID != 0, ˵���յ��˴������Ӧ
	bool ret = ((pRspInfo) && (pRspInfo->ErrorID != 0));
	if (ret){
		//	cerr << " ��Ӧ | " << pRspInfo->ErrorMsg << endl;
  }
	return ret;
}

/*//
void CtpTraderSpi::PrintOrders(){
  //CThostFtdcOrderField* pOrder; 
	//for (unsigned int i = 0; i<g_orderList.size(); i++){
	//pOrder = g_orderList[i];
		//  cerr << " ���� | ��Լ:" << pOrder->InstrumentID
	  //	  << " ����:" << MapDirection(pOrder->Direction, false)
	  //	  << " ��ƽ:" << MapOffset(pOrder->CombOffsetFlag[0], false)
	  //	  << " �۸�:" << pOrder->LimitPrice
	  //	  << " ����:" << pOrder->VolumeTotalOriginal
	  //	  << " ���:" << pOrder->BrokerOrderSeq
	  //	  << " �������:" << pOrder->OrderSysID
	  //	  << " ״̬:" << pOrder->StatusMsg << endl;
	//}
}
void CtpTraderSpi::PrintTrades(){
  CThostFtdcTradeField* pTrade;
  for (unsigned int i = 0; i<g_tradeList.size(); i++){
	  pTrade = g_tradeList[i];
		//  cerr << " �ɽ� | ��Լ:" << pTrade->InstrumentID
	  //	  << " ����:" << MapDirection(pTrade->Direction, false)
	  //	  << " ��ƽ:" << MapOffset(pTrade->OffsetFlag, false)
	  //	  << " �۸�:" << pTrade->Price
	  //	  << " ����:" << pTrade->Volume
	  //	  << " �������:" << pTrade->OrderSysID
	  //	  << " �ɽ����:" << pTrade->TradeID << endl;
  }
}
//*/
//*//
char MapDirection(char src){
  if ('b' == src || 'B' == src) { 
	src = THOST_FTDC_D_Buy; 
  }
  else if ('s' == src || 'S' == src){ 
	src = THOST_FTDC_D_Sell; 
  }
  return src;
}
char MapOffset(char src){
  if('o'==src||'O'==src){
	  src = THOST_FTDC_OF_Open;
  }
  else if('c'==src||'C'==src){
	  src = THOST_FTDC_OF_Close;
  }
  else if('j'==src||'J'==src){
	  src = THOST_FTDC_OF_CloseToday;
  }
  return src;
}

//*/