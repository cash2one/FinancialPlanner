#ifndef ORDER_TRADERSPI_H_
#define ORDER_TRADERSPI_H_
#pragma once

#include "api/trade/win/public/ThostFtdcTraderApi.h"
#include <Windows.h>

class CtpTraderSpi : public CThostFtdcTraderSpi
{
public:
	CtpTraderSpi(CThostFtdcTraderApi* api) :fTraderApi(api){};

	///当客户端与交易后台建立起通信连接时（还未登录前），该方法被调用。
	virtual void OnFrontConnected();

	///登录请求响应
	virtual void OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin,	CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///投资者结算结果确认响应
	virtual void OnRspSettlementInfoConfirm(CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
	
	///请求查询合约响应
	virtual void OnRspQryInstrument(CThostFtdcInstrumentField *pInstrument, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///请求查询资金账户响应
	virtual void OnRspQryTradingAccount(CThostFtdcTradingAccountField *pTradingAccount, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///请求查询报单响应
	virtual void OnRspQryOrder(CThostFtdcOrderField *pOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///请求查询成交响应
	virtual void OnRspQryTrade(CThostFtdcTradeField *pTrade, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///请求查询投资者持仓响应
	virtual void OnRspQryInvestorPosition(CThostFtdcInvestorPositionField *pInvestorPosition, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///报单录入请求响应
	virtual void OnRspOrderInsert(CThostFtdcInputOrderField *pInputOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///报单操作请求响应
	virtual void OnRspOrderAction(CThostFtdcInputOrderActionField *pInputOrderAction, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	virtual void OnRspQryInstrumentCommissionRate(CThostFtdcInstrumentCommissionRateField *pInstrumentCommissionRate,
		CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///错误应答
	virtual void OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
	
	///当客户端与交易后台通信连接断开时，该方法被调用。当发生这个情况后，API会自动重新连接，客户端可不做处理。
	virtual void OnFrontDisconnected(int nReason);
		
	///心跳超时警告。当长时间未收到报文时，该方法被调用。
	virtual void OnHeartBeatWarning(int nTimeLapse);
	
	///报单通知
	virtual void OnRtnOrder(CThostFtdcOrderField *pOrder);

	///成交通知
	virtual void OnRtnTrade(CThostFtdcTradeField *pTrade);

	///请求查询签约银行响应
	virtual void OnRspQryContractBank(CThostFtdcContractBankField *pContractBank, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///请求查询银期签约关系响应
	virtual void OnRspQryAccountregister(CThostFtdcAccountregisterField *pAccountregister, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///期货发起银行资金转期货应答
	virtual void OnRspFromBankToFutureByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///期货发起期货资金转银行应答
	virtual void OnRspFromFutureToBankByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///银行发起银行资金转期货通知
	virtual void OnRtnFromBankToFutureByBank(CThostFtdcRspTransferField *pRspTransfer);

	///银行发起期货资金转银行通知
	virtual void OnRtnFromFutureToBankByBank(CThostFtdcRspTransferField *pRspTransfer);
	///请求查询投资者响应
	virtual void OnRspQryInvestor(CThostFtdcInvestorField *pInvestor, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
public:
	///客户端认证请求 
	void ReqAuthenticate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID);
	///用户登录请求
	void ReqUserLogin(TThostFtdcBrokerIDType ABrokerID, TThostFtdcUserIDType AUserId, TThostFtdcPasswordType APassword, int ARequestId);
	///登出请求
	void ReqUserLogout(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID);

	///用户口令更新请求
	void ReqUserPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId,
		TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID);
	///资金账户口令更新请求
	void ReqTradingAccountPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcAccountIDType AccountId,
		TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID);


	///投资者结算结果确认
	void ReqSettlementInfoConfirm(TThostFtdcBrokerIDType ABrokerID, TThostFtdcUserIDType AUserId, int ARequestId);
	///请求查询合约
	void ReqQryInstrument(TThostFtdcInstrumentIDType instId, int ARequestId);
	///请求查询资金账户
	void ReqQryTradingAccount(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcCurrencyIDType ACurrencyID, int ARequestId);
	///请求查询投资者持仓
	void ReqQryInvestorPosition(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcInstrumentIDType instId, int ARequestId);
	///报单录入请求
	void ReqOrderInsert(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, 
		TThostFtdcInstrumentIDType instId,
        TThostFtdcDirectionType dir, TThostFtdcCombOffsetFlagType kpp,
		TThostFtdcPriceType price, TThostFtdcVolumeType vol, int ARequestId);
	// 查询报单
	void ReqQryOrder(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AInvestorID,
		TThostFtdcInstrumentIDType AInstrumentID, TThostFtdcExchangeIDType AExchangeID,
		TThostFtdcOrderSysIDType AOrderSysID, TThostFtdcTimeType AInsertTimeStart,
		TThostFtdcTimeType AInsertTimeEnd, int ARequestId);
	// 查询成交
	void ReqQryTrade(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AInvestorID,
		TThostFtdcInstrumentIDType AInstrumentID, TThostFtdcExchangeIDType AExchangeID,
		TThostFtdcTradeIDType ATradeID, TThostFtdcTimeType ATradeTimeStart,
		TThostFtdcTimeType ATradeTimeEnd, int ARequestId);
	// 请求查询合约手续费率
	void ReqQryInstrumentCommissionRate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId,
		TThostFtdcInstrumentIDType instId, int ARequestId);
	///报单操作请求
	void ReqOrderAction(TThostFtdcBrokerIDType ABrokerId, 
		TThostFtdcUserIDType AUserId, 
		TThostFtdcSequenceNoType AorderSeq,
		TThostFtdcExchangeIDType AExchangeID,
		TThostFtdcOrderSysIDType AOrderSysID, 
		int ARequestId);

	///请求查询签约银行
	void ReqQryContractBank(TThostFtdcBrokerIDType ABrokerId, TThostFtdcBankIDType ABankID, TThostFtdcBankBrchIDType	ABankBrchID, int ARequestId);

	///请求查询银期签约关系
	void ReqQryAccountregister(TThostFtdcBrokerIDType ABrokerId,
		TThostFtdcAccountIDType	AccountID,
		TThostFtdcBankIDType	ABankID,
		TThostFtdcBankBrchIDType ABankBranchID, int ARequestId);

	///期货发起银行资金转期货请求
	void ReqFromBankToFutureByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId);

	///期货发起期货资金转银行请求
	void ReqFromFutureToBankByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId);

	///请求查询投资者
	void ReqQryInvestor(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AUserId, int ARequestId);

	// 是否收到成功的响应
	bool IsErrorRspInfo(CThostFtdcRspInfoField *pRspInfo);
private:
  CThostFtdcTraderApi* fTraderApi;
public:
	HWND fwndHost;
};

#endif