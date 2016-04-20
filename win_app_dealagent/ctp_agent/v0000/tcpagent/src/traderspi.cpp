#include <iostream>
#include <vector>

using namespace std;
#include "api/trade/win/public/ThostFtdcTraderApi.h"
#include "traderspi.h"
#include "./config.h"
#include "windows.h"

#pragma warning(disable :4996)

// 会话参数
int	 g_deal_frontId;	//前置编号
int	 g_deal_sessionId;	//会话编号
char g_deal_orderRef[13];

//vector<CThostFtdcOrderField*> g_orderList;
//vector<CThostFtdcTradeField*> g_tradeList;

char MapDirection(char src);
char MapOffset(char src);
    


void CtpTraderSpi::OnFrontConnected()
{
	SendMessage(fwndHost, WM_S2C_Deal_FrontConnected, 0, 0);
	//cerr<<" 连接交易前置...成功"<<endl;
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
	//	cerr << " 请求 | 发送登录..." << ((ret == 0) ? "成功" : "失败") << endl;
}

void CtpTraderSpi::OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin,
		CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if ( !IsErrorRspInfo(pRspInfo) && pRspUserLogin ) {  
    // 保存会话参数	
		g_deal_frontId = pRspUserLogin->FrontID;
		g_deal_sessionId = pRspUserLogin->SessionID;
		int nextOrderRef = atoi(pRspUserLogin->MaxOrderRef);
		sprintf(g_deal_orderRef, "%d", ++nextOrderRef);

		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_Deal_RspUserLogin;
		CopyData.cbData = sizeof(CThostFtdcRspUserLoginField);
		CopyData.lpData = pRspUserLogin;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);

	//		cerr << " 响应 | 登录成功...当前交易日:"
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
	//	cerr << " 请求 | 发送结算单确认..." << ((ret == 0) ? "成功" : "失败") << endl;
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
		//	cerr << " 响应 | 结算单..." << pSettlementInfoConfirm->InvestorID
		//		<< "...<" << pSettlementInfoConfirm->ConfirmDate
		//	<< " " << pSettlementInfoConfirm->ConfirmTime << ">...确认" << endl;
	}
	else {
		SendMessage(fwndHost, WM_S2C_RspSettlementInfoConfirm, 100, nRequestID);
	}
}

///客户端认证请求 
void CtpTraderSpi::ReqAuthenticate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID) {
	CThostFtdcReqAuthenticateField tmpreq;
	///经纪公司代码
	strcpy(tmpreq.BrokerID, ABrokerId);
	///用户代码
	strcpy(tmpreq.UserID, AUserId);
	///用户端产品信息
	//TThostFtdcProductInfoType	tmpreq.UserProductInfo;
	///认证码
	//TThostFtdcAuthCodeType	tmpreq.AuthCode;
	int ret = fTraderApi->ReqAuthenticate(&tmpreq, ARequestID);
	if (0 == ret) {
	}
	else {
	}
}

///登出请求
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

///用户口令更新请求
void CtpTraderSpi::ReqUserPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, 
	TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID) {
	CThostFtdcUserPasswordUpdateField tmpreq;
	///经纪公司代码
	strcpy(tmpreq.BrokerID, ABrokerId);
	///用户代码
	strcpy(tmpreq.UserID, AUserId);
	///原来的口令
	strcpy(tmpreq.OldPassword, AOldPassword);
	///新的口令
	strcpy(tmpreq.NewPassword, ANewPassword);
	int ret = fTraderApi->ReqUserPasswordUpdate(&tmpreq, ARequestID);
	if (0 == ret) {
	}
	else {
	}
}

///资金账户口令更新请求
void CtpTraderSpi::ReqTradingAccountPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcAccountIDType AccountID,
	TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID) {
	CThostFtdcTradingAccountPasswordUpdateField tmpreq;
	///经纪公司代码
	strcpy(tmpreq.BrokerID, ABrokerId);
	///投资者帐号
	strcpy(tmpreq.AccountID, AccountID);
	///原来的口令
	strcpy(tmpreq.OldPassword, AOldPassword);
	///新的口令
	strcpy(tmpreq.NewPassword, ANewPassword);
	///币种代码
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
  strcpy(req.InstrumentID, instId);//为空表示查询所有合约
  int ret = fTraderApi->ReqQryInstrument(&req, ARequestId);
  if (0 == ret) {
  }
  else {
  }
	//  cerr << " 请求 | 发送合约查询..." << ((ret == 0) ? "成功" : "失败") << endl;
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
	//		cerr << " 响应 | 合约:" << pInstrument->InstrumentID
		//			<< " 交割月:" << pInstrument->DeliveryMonth
		//	<< " 多头保证金率:" << pInstrument->LongMarginRatio
		//	<< " 空头保证金率:" << pInstrument->ShortMarginRatio << endl;
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
	///经纪公司代码  TThostFtdcBrokerIDType	
	strcpy(tmpreq.BrokerID, ABrokerId);
	///投资者代码  TThostFtdcInvestorIDType
	strcpy(tmpreq.InvestorID, AInvestorID);
	///合约代码  TThostFtdcInstrumentIDType
	strcpy(tmpreq.InstrumentID, AInstrumentID);
	///交易所代码  TThostFtdcExchangeIDType
	strcpy(tmpreq.ExchangeID, AExchangeID);
	///报单编号  TThostFtdcOrderSysIDType
	strcpy(tmpreq.OrderSysID, AOrderSysID);
	///开始时间  TThostFtdcTimeType
	strcpy(tmpreq.InsertTimeStart, AInsertTimeStart);
	///结束时间  TThostFtdcTimeType
	strcpy(tmpreq.InsertTimeEnd, AInsertTimeEnd);
	int ret = fTraderApi->ReqQryOrder(&tmpreq, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///请求查询报单响应
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
	///投资者代码
	strcpy(tmpreq.InvestorID, AInvestorID);
	///合约代码
	strcpy(tmpreq.InstrumentID, AInstrumentID);
	///交易所代码
	strcpy(tmpreq.ExchangeID, AExchangeID);
	///成交编号
	strcpy(tmpreq.TradeID, ATradeID);
	///开始时间
	strcpy(tmpreq.TradeTimeStart, ATradeTimeStart);
	///结束时间
	strcpy(tmpreq.TradeTimeEnd, ATradeTimeEnd);
	int ret = fTraderApi->ReqQryTrade(&tmpreq, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///请求查询成交响应
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
	///投资者代码
	//TThostFtdcInvestorIDType	InvestorID;
	///币种代码
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
		//	cerr << " 请求 | 发送资金查询..." << ((ret == 0) ? "成功" : "失败") << endl;

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
				<< " PreBalance:" << pTradingAccount->PreBalance //上次结算准备金
				<< " PreMargin:" << pTradingAccount->PreMargin
				<< " InterestBase:" << pTradingAccount->InterestBase
				<< " Interest:" << pTradingAccount->Interest
				<< " Deposit:" << pTradingAccount->Deposit
				<< " Withdraw:" << pTradingAccount->Withdraw
				<< " 冻结保证金:" << pTradingAccount->FrozenMargin
				<< " FrozenCash:" << pTradingAccount->FrozenCash
				<< " FrozenCommission:" << pTradingAccount->FrozenCommission
				<< " 保证金:" << pTradingAccount->CurrMargin //当前保证金总额
				<< " CashIn:" << pTradingAccount->CashIn
				<< " 手续费:" << pTradingAccount->Commission
				<< " 平仓盈亏:" << pTradingAccount->CloseProfit
				<< " 持仓盈亏" << pTradingAccount->PositionProfit
				<< " 响应 | 权益:" << pTradingAccount->Balance // 期货结算准备金
				<< " 可用:" << pTradingAccount->Available   // 可用资金
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

///请求查询投资者
void CtpTraderSpi::ReqQryInvestor(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AUserId, int ARequestId)
{
	CThostFtdcQryInvestorField req;
	///经纪公司代码
	strcpy(req.BrokerID, ABrokerId);
	///投资者代码
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
	///投资者代码
	TThostFtdcInvestorIDType	InvestorID;
	///经纪公司代码
	TThostFtdcBrokerIDType	BrokerID;
	///投资者分组代码
	TThostFtdcInvestorIDType	InvestorGroupID;
	///投资者名称
	TThostFtdcPartyNameType	InvestorName;
	///证件类型
	TThostFtdcIdCardTypeType	IdentifiedCardType;
	///证件号码
	TThostFtdcIdentifiedCardNoType	IdentifiedCardNo;
	///是否活跃
	TThostFtdcBoolType	IsActive;
	///联系电话
	TThostFtdcTelephoneType	Telephone;
	///通讯地址
	TThostFtdcAddressType	Address;
	///开户日期
	TThostFtdcDateType	OpenDate;
	///手机
	TThostFtdcMobileType	Mobile;
	///手续费率模板代码
	TThostFtdcInvestorIDType	CommModelID;
	///保证金率模板代码
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
		//cerr << " 请求 | 发送持仓查询..." << ((ret == 0) ? "成功" : "失败") << endl;
}

void CtpTraderSpi::OnRspQryInvestorPosition(
    CThostFtdcInvestorPositionField *pInvestorPosition, 
    CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pInvestorPosition){
		if (NULL == pInvestorPosition) {
			// 没有任何持仓
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
			//cerr << " 响应 | 合约:" << pInvestorPosition->InstrumentID
		//	<< " 方向:" << MapDirection(pInvestorPosition->PosiDirection - 2, false)
		//	<< " 总持仓:" << pInvestorPosition->Position
		//	<< " 昨仓:" << pInvestorPosition->YdPosition
		//	<< " 今仓:" << pInvestorPosition->TodayPosition
		//	<< " 持仓盈亏:" << pInvestorPosition->PositionProfit
		//	<< " 保证金:" << pInvestorPosition->UseMargin << endl;
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
	strcpy(req.BrokerID, ABrokerId);  //应用单元代码	
	strcpy(req.InvestorID, AUserId); //投资者代码	
	strcpy(req.InstrumentID, instId); //合约代码	
	strcpy(req.OrderRef, g_deal_orderRef);  //报单引用
	int nextOrderRef = atoi(g_deal_orderRef);
	sprintf(g_deal_orderRef, "%d", ++nextOrderRef);
  
  req.LimitPrice = price;	//价格
  if(0==req.LimitPrice){
	  req.OrderPriceType = THOST_FTDC_OPT_AnyPrice;//价格类型=市价
	  req.TimeCondition = THOST_FTDC_TC_IOC;//有效期类型:立即完成，否则撤销
  }else{
    req.OrderPriceType = THOST_FTDC_OPT_LimitPrice;//价格类型=限价	
    req.TimeCondition = THOST_FTDC_TC_GFD;  //有效期类型:当日有效
  }
  req.Direction = MapDirection(dir);  //买卖方向	
  req.CombOffsetFlag[0] = MapOffset(kpp[0]); //组合开平标志:开仓
	req.CombHedgeFlag[0] = THOST_FTDC_HF_Speculation;	  //组合投机套保标志	
	req.VolumeTotalOriginal = vol;	///数量		
	req.VolumeCondition = THOST_FTDC_VC_AV; //成交量类型:任何数量
	req.MinVolume = 1;	//最小成交量:1	
	req.ContingentCondition = THOST_FTDC_CC_Immediately;  //触发条件:立即
	
  //TThostFtdcPriceType	StopPrice;  //止损价
	req.ForceCloseReason = THOST_FTDC_FCC_NotForceClose;	//强平原因:非强平	
	req.IsAutoSuspend = 0;  //自动挂起标志:否	
	req.UserForceClose = 0;   //用户强评标志:否

	int ret = fTraderApi->ReqOrderInsert(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}

		//cerr << " 请求 | 发送报单..." << ((ret == 0) ? "成功" : "失败") << endl;
}

void CtpTraderSpi::OnRspOrderInsert(CThostFtdcInputOrderField *pInputOrder, 
          CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pInputOrder){
		//	cerr << "响应 | 报单提交成功...报单引用:" << pInputOrder->OrderRef << endl;
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

// 请求查询合约手续费率
void CtpTraderSpi::ReqQryInstrumentCommissionRate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId,
	TThostFtdcInstrumentIDType instId, int ARequestId)
{
	CThostFtdcQryInstrumentCommissionRateField req;
	strcpy(req.BrokerID, ABrokerId);  //应用单元代码	
	strcpy(req.InvestorID, AUserId); //投资者代码	
	strcpy(req.InstrumentID, instId); //合约代码	

	int ret = fTraderApi->ReqQryInstrumentCommissionRate(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///请求查询合约手续费率响应
void CtpTraderSpi::OnRspQryInstrumentCommissionRate(CThostFtdcInstrumentCommissionRateField *pInstrumentCommissionRate, 
	CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
	if (!IsErrorRspInfo(pRspInfo) && pInstrumentCommissionRate){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RspQryInstrumentCommissionRate;
		CopyData.cbData = sizeof(CThostFtdcInstrumentCommissionRateField);
		CopyData.lpData = pInstrumentCommissionRate;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
		//	cerr << " 响应 | 撤单成功..."
		//		<< "交易所:" << pInputOrderAction->ExchangeID
		//	<< " 报单编号:" << pInputOrderAction->OrderSysID << endl;
	}
	else {
	}
};

void CtpTraderSpi::ReqQryContractBank(TThostFtdcBrokerIDType ABrokerId, TThostFtdcBankIDType ABankID, TThostFtdcBankBrchIDType	ABankBrchID, int ARequestId) {
	///请求查询签约银行
	CThostFtdcQryContractBankField req;
	///经纪公司代码
	strcpy(req.BrokerID, ABrokerId); 
	///银行代码
	strcpy(req.BankID, ABankID);  
	///银行分中心代码
	strcpy(req.BankBrchID, ABankBrchID);
	int ret = fTraderApi->ReqQryContractBank(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///请求查询签约银行响应
void CtpTraderSpi::OnRspQryContractBank(CThostFtdcContractBankField *pContractBank, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

void CtpTraderSpi::ReqQryAccountregister(TThostFtdcBrokerIDType ABrokerId, 
	  TThostFtdcAccountIDType	AccountID, 
	  TThostFtdcBankIDType	ABankID, 
	  TThostFtdcBankBrchIDType ABankBranchID, int ARequestId) {
	///请求查询银期签约关系
	CThostFtdcQryAccountregisterField req;
	///经纪公司代码
	strcpy(req.BrokerID, ABrokerId);
	///投资者帐号
	strcpy(req.AccountID, AccountID);
	///银行编码
	strcpy(req.BankID, ABankID);
	///银行分支机构编码
	strcpy(req.BankBranchID, ABankBranchID);
	///币种代码
	strcpy(req.CurrencyID, "CNY");
	int ret = fTraderApi->ReqQryAccountregister(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///请求查询银期签约关系响应
void CtpTraderSpi::OnRspQryAccountregister(CThostFtdcAccountregisterField *pAccountregister, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

void CtpTraderSpi::ReqFromBankToFutureByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId) {

	///期货发起银行资金转期货请求
	CThostFtdcReqTransferField req;
	/*//
	///业务功能码
	TThostFtdcTradeCodeType	TradeCode;
	///银行代码
	TThostFtdcBankIDType	BankID;
	///银行分支机构代码
	TThostFtdcBankBrchIDType	BankBranchID;
	///期商代码
	TThostFtdcBrokerIDType	BrokerID;
	///期商分支机构代码
	TThostFtdcFutureBranchIDType	BrokerBranchID;
	///交易日期
	TThostFtdcTradeDateType	TradeDate;
	///交易时间
	TThostFtdcTradeTimeType	TradeTime;
	///银行流水号
	TThostFtdcBankSerialType	BankSerial;
	///交易系统日期 
	TThostFtdcTradeDateType	TradingDay;
	///银期平台消息流水号
	TThostFtdcSerialType	PlateSerial;
	///最后分片标志
	TThostFtdcLastFragmentType	LastFragment;
	///会话号
	TThostFtdcSessionIDType	SessionID;
	///客户姓名
	TThostFtdcIndividualNameType	CustomerName;
	///证件类型
	TThostFtdcIdCardTypeType	IdCardType;
	///证件号码
	TThostFtdcIdentifiedCardNoType	IdentifiedCardNo;
	///客户类型
	TThostFtdcCustTypeType	CustType;
	///银行帐号
	TThostFtdcBankAccountType	BankAccount;
	///银行密码
	TThostFtdcPasswordType	BankPassWord;
	///投资者帐号
	TThostFtdcAccountIDType	AccountID;
	///期货密码
	TThostFtdcPasswordType	Password;
	///安装编号
	TThostFtdcInstallIDType	InstallID;
	///期货公司流水号
	TThostFtdcFutureSerialType	FutureSerial;
	///用户标识
	TThostFtdcUserIDType	UserID;
	///验证客户证件号码标志
	TThostFtdcYesNoIndicatorType	VerifyCertNoFlag;
	///币种代码
	TThostFtdcCurrencyIDType	CurrencyID;
	///转帐金额
	TThostFtdcTradeAmountType	TradeAmount;
	///期货可取金额
	TThostFtdcTradeAmountType	FutureFetchAmount;
	///费用支付标志
	TThostFtdcFeePayFlagType	FeePayFlag;
	///应收客户费用
	TThostFtdcCustFeeType	CustFee;
	///应收期货公司费用
	TThostFtdcFutureFeeType	BrokerFee;
	///发送方给接收方的消息
	TThostFtdcAddInfoType	Message;
	///摘要
	TThostFtdcDigestType	Digest;
	///银行帐号类型
	TThostFtdcBankAccTypeType	BankAccType;
	///渠道标志
	TThostFtdcDeviceIDType	DeviceID;
	///期货单位帐号类型
	TThostFtdcBankAccTypeType	BankSecuAccType;
	///期货公司银行编码
	TThostFtdcBankCodingForFutureType	BrokerIDByBank;
	///期货单位帐号
	TThostFtdcBankAccountType	BankSecuAcc;
	///银行密码标志
	TThostFtdcPwdFlagType	BankPwdFlag;
	///期货资金密码核对标志
	TThostFtdcPwdFlagType	SecuPwdFlag;
	///交易柜员
	TThostFtdcOperNoType	OperNo;
	///请求编号
	TThostFtdcRequestIDType	RequestID;
	///交易ID
	TThostFtdcTIDType	TID;
	///转账交易状态
	TThostFtdcTransferStatusType	TransferStatus;
	//*/
	int ret = fTraderApi->ReqFromBankToFutureByFuture(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///期货发起银行资金转期货应答
void CtpTraderSpi::OnRspFromBankToFutureByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

///银行发起银行资金转期货通知
void CtpTraderSpi::OnRtnFromBankToFutureByBank(CThostFtdcRspTransferField *pRspTransfer) {
};

void CtpTraderSpi::ReqFromFutureToBankByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId) {
	///期货发起期货资金转银行请求
	CThostFtdcReqTransferField req;
	/*//
	///业务功能码
	TThostFtdcTradeCodeType	TradeCode;
	///银行代码
	TThostFtdcBankIDType	BankID;
	///银行分支机构代码
	TThostFtdcBankBrchIDType	BankBranchID;
	///期商代码
	TThostFtdcBrokerIDType	BrokerID;
	///期商分支机构代码
	TThostFtdcFutureBranchIDType	BrokerBranchID;
	///交易日期
	TThostFtdcTradeDateType	TradeDate;
	///交易时间
	TThostFtdcTradeTimeType	TradeTime;
	///银行流水号
	TThostFtdcBankSerialType	BankSerial;
	///交易系统日期
	TThostFtdcTradeDateType	TradingDay;
	///银期平台消息流水号
	TThostFtdcSerialType	PlateSerial;
	///最后分片标志
	TThostFtdcLastFragmentType	LastFragment;
	///会话号
	TThostFtdcSessionIDType	SessionID;
	///客户姓名
	TThostFtdcIndividualNameType	CustomerName;
	///证件类型
	TThostFtdcIdCardTypeType	IdCardType;
	///证件号码
	TThostFtdcIdentifiedCardNoType	IdentifiedCardNo;
	///客户类型
	TThostFtdcCustTypeType	CustType;
	///银行帐号
	TThostFtdcBankAccountType	BankAccount;
	///银行密码
	TThostFtdcPasswordType	BankPassWord;
	///投资者帐号
	TThostFtdcAccountIDType	AccountID;
	///期货密码
	TThostFtdcPasswordType	Password;
	///安装编号
	TThostFtdcInstallIDType	InstallID;
	///期货公司流水号
	TThostFtdcFutureSerialType	FutureSerial;
	///用户标识
	TThostFtdcUserIDType	UserID;
	///验证客户证件号码标志
	TThostFtdcYesNoIndicatorType	VerifyCertNoFlag;
	///币种代码
	TThostFtdcCurrencyIDType	CurrencyID;
	///转帐金额
	TThostFtdcTradeAmountType	TradeAmount;
	///期货可取金额
	TThostFtdcTradeAmountType	FutureFetchAmount;
	///费用支付标志
	TThostFtdcFeePayFlagType	FeePayFlag;
	///应收客户费用
	TThostFtdcCustFeeType	CustFee;
	///应收期货公司费用
	TThostFtdcFutureFeeType	BrokerFee;
	///发送方给接收方的消息
	TThostFtdcAddInfoType	Message;
	///摘要
	TThostFtdcDigestType	Digest;
	///银行帐号类型
	TThostFtdcBankAccTypeType	BankAccType;
	///渠道标志
	TThostFtdcDeviceIDType	DeviceID;
	///期货单位帐号类型
	TThostFtdcBankAccTypeType	BankSecuAccType;
	///期货公司银行编码
	TThostFtdcBankCodingForFutureType	BrokerIDByBank;
	///期货单位帐号
	TThostFtdcBankAccountType	BankSecuAcc;
	///银行密码标志
	TThostFtdcPwdFlagType	BankPwdFlag;
	///期货资金密码核对标志
	TThostFtdcPwdFlagType	SecuPwdFlag;
	///交易柜员
	TThostFtdcOperNoType	OperNo;
	///请求编号
	TThostFtdcRequestIDType	RequestID;
	///交易ID
	TThostFtdcTIDType	TID;
	///转账交易状态
	TThostFtdcTransferStatusType	TransferStatus;
	//*/
	int ret = fTraderApi->ReqFromFutureToBankByFuture(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
}

///期货发起期货资金转银行应答
void CtpTraderSpi::OnRspFromFutureToBankByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
};

///银行发起期货资金转银行通知
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
		//  cerr << " 请求 | 报单不存在." << endl;
	//return;
	//} 

	CThostFtdcInputOrderActionField req;
	memset(&req, 0, sizeof(req));
	strcpy(req.BrokerID, ABrokerId);   //经纪公司代码	
	strcpy(req.InvestorID, AUserId); //投资者代码
	//strcpy(req.OrderRef, pOrderRef); //报单引用	
	//req.FrontID = frontId;           //前置编号	
	//req.SessionID = sessionId;       //会话编号
	// TThostFtdcExchangeIDType	ExchangeID;
	strcpy(req.ExchangeID, AExchangeID);// g_orderList[i]->ExchangeID);
	strcpy(req.OrderSysID, AOrderSysID);// g_orderList[i]->OrderSysID);
	req.ActionFlag = THOST_FTDC_AF_Delete;  //操作标志 

	int ret = fTraderApi->ReqOrderAction(&req, ARequestId);
	if (0 == ret) {
	}
	else {
	}
		//cerr << " 请求 | 发送撤单..." << ((ret == 0) ? "成功" : "失败") << endl;
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
		//	cerr << " 响应 | 撤单成功..."
		//		<< "交易所:" << pInputOrderAction->ExchangeID
		//	<< " 报单编号:" << pInputOrderAction->OrderSysID << endl;
	}
	else {
	}
}

///报单回报
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
	 // cerr << " 回报 | 报单已提交...序号:" << order->BrokerOrderSeq << endl;
}

///成交通知
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

	 // cerr << " 回报 | 报单已成交...成交编号:" << trade->TradeID << endl;
}

void CtpTraderSpi::OnFrontDisconnected(int nReason)
{
	SendMessage(fwndHost, WM_S2C_Deal_FrontDisconnected, nReason, 0);
	//	cerr << " 响应 | 连接中断..."
	//		<< " reason=" << nReason << endl;
}
		
void CtpTraderSpi::OnHeartBeatWarning(int nTimeLapse)
{
	SendMessage(fwndHost, WM_S2C_Deal_HeartBeatWarning, nTimeLapse, 0);

		//cerr << " 响应 | 心跳超时警告..."
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
	// 如果ErrorID != 0, 说明收到了错误的响应
	bool ret = ((pRspInfo) && (pRspInfo->ErrorID != 0));
	if (ret){
		//	cerr << " 响应 | " << pRspInfo->ErrorMsg << endl;
  }
	return ret;
}

/*//
void CtpTraderSpi::PrintOrders(){
  //CThostFtdcOrderField* pOrder; 
	//for (unsigned int i = 0; i<g_orderList.size(); i++){
	//pOrder = g_orderList[i];
		//  cerr << " 报单 | 合约:" << pOrder->InstrumentID
	  //	  << " 方向:" << MapDirection(pOrder->Direction, false)
	  //	  << " 开平:" << MapOffset(pOrder->CombOffsetFlag[0], false)
	  //	  << " 价格:" << pOrder->LimitPrice
	  //	  << " 数量:" << pOrder->VolumeTotalOriginal
	  //	  << " 序号:" << pOrder->BrokerOrderSeq
	  //	  << " 报单编号:" << pOrder->OrderSysID
	  //	  << " 状态:" << pOrder->StatusMsg << endl;
	//}
}
void CtpTraderSpi::PrintTrades(){
  CThostFtdcTradeField* pTrade;
  for (unsigned int i = 0; i<g_tradeList.size(); i++){
	  pTrade = g_tradeList[i];
		//  cerr << " 成交 | 合约:" << pTrade->InstrumentID
	  //	  << " 方向:" << MapDirection(pTrade->Direction, false)
	  //	  << " 开平:" << MapOffset(pTrade->OffsetFlag, false)
	  //	  << " 价格:" << pTrade->Price
	  //	  << " 数量:" << pTrade->Volume
	  //	  << " 报单编号:" << pTrade->OrderSysID
	  //	  << " 成交编号:" << pTrade->TradeID << endl;
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