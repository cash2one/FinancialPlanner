#ifndef ORDER_TRADERSPI_H_
#define ORDER_TRADERSPI_H_
#pragma once

#include "api/trade/win/public/ThostFtdcTraderApi.h"
#include <Windows.h>

class CtpTraderSpi : public CThostFtdcTraderSpi
{
public:
	CtpTraderSpi(CThostFtdcTraderApi* api) :fTraderApi(api){};

	///���ͻ����뽻�׺�̨������ͨ������ʱ����δ��¼ǰ�����÷��������á�
	virtual void OnFrontConnected();

	///��¼������Ӧ
	virtual void OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin,	CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///Ͷ���߽�����ȷ����Ӧ
	virtual void OnRspSettlementInfoConfirm(CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
	
	///�����ѯ��Լ��Ӧ
	virtual void OnRspQryInstrument(CThostFtdcInstrumentField *pInstrument, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�����ѯ�ʽ��˻���Ӧ
	virtual void OnRspQryTradingAccount(CThostFtdcTradingAccountField *pTradingAccount, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�����ѯ������Ӧ
	virtual void OnRspQryOrder(CThostFtdcOrderField *pOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�����ѯ�ɽ���Ӧ
	virtual void OnRspQryTrade(CThostFtdcTradeField *pTrade, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�����ѯͶ���ֲ߳���Ӧ
	virtual void OnRspQryInvestorPosition(CThostFtdcInvestorPositionField *pInvestorPosition, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///����¼��������Ӧ
	virtual void OnRspOrderInsert(CThostFtdcInputOrderField *pInputOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///��������������Ӧ
	virtual void OnRspOrderAction(CThostFtdcInputOrderActionField *pInputOrderAction, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	virtual void OnRspQryInstrumentCommissionRate(CThostFtdcInstrumentCommissionRateField *pInstrumentCommissionRate,
		CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///����Ӧ��
	virtual void OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
	
	///���ͻ����뽻�׺�̨ͨ�����ӶϿ�ʱ���÷��������á���������������API���Զ��������ӣ��ͻ��˿ɲ�������
	virtual void OnFrontDisconnected(int nReason);
		
	///������ʱ���档����ʱ��δ�յ�����ʱ���÷��������á�
	virtual void OnHeartBeatWarning(int nTimeLapse);
	
	///����֪ͨ
	virtual void OnRtnOrder(CThostFtdcOrderField *pOrder);

	///�ɽ�֪ͨ
	virtual void OnRtnTrade(CThostFtdcTradeField *pTrade);

	///�����ѯǩԼ������Ӧ
	virtual void OnRspQryContractBank(CThostFtdcContractBankField *pContractBank, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�����ѯ����ǩԼ��ϵ��Ӧ
	virtual void OnRspQryAccountregister(CThostFtdcAccountregisterField *pAccountregister, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�ڻ����������ʽ�ת�ڻ�Ӧ��
	virtual void OnRspFromBankToFutureByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///�ڻ������ڻ��ʽ�ת����Ӧ��
	virtual void OnRspFromFutureToBankByFuture(CThostFtdcReqTransferField *pReqTransfer, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

	///���з��������ʽ�ת�ڻ�֪ͨ
	virtual void OnRtnFromBankToFutureByBank(CThostFtdcRspTransferField *pRspTransfer);

	///���з����ڻ��ʽ�ת����֪ͨ
	virtual void OnRtnFromFutureToBankByBank(CThostFtdcRspTransferField *pRspTransfer);
	///�����ѯͶ������Ӧ
	virtual void OnRspQryInvestor(CThostFtdcInvestorField *pInvestor, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);
public:
	///�ͻ�����֤���� 
	void ReqAuthenticate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID);
	///�û���¼����
	void ReqUserLogin(TThostFtdcBrokerIDType ABrokerID, TThostFtdcUserIDType AUserId, TThostFtdcPasswordType APassword, int ARequestId);
	///�ǳ�����
	void ReqUserLogout(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestID);

	///�û������������
	void ReqUserPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId,
		TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID);
	///�ʽ��˻������������
	void ReqTradingAccountPasswordUpdate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcAccountIDType AccountId,
		TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestID);


	///Ͷ���߽�����ȷ��
	void ReqSettlementInfoConfirm(TThostFtdcBrokerIDType ABrokerID, TThostFtdcUserIDType AUserId, int ARequestId);
	///�����ѯ��Լ
	void ReqQryInstrument(TThostFtdcInstrumentIDType instId, int ARequestId);
	///�����ѯ�ʽ��˻�
	void ReqQryTradingAccount(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcCurrencyIDType ACurrencyID, int ARequestId);
	///�����ѯͶ���ֲ߳�
	void ReqQryInvestorPosition(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcInstrumentIDType instId, int ARequestId);
	///����¼������
	void ReqOrderInsert(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, 
		TThostFtdcInstrumentIDType instId,
        TThostFtdcDirectionType dir, TThostFtdcCombOffsetFlagType kpp,
		TThostFtdcPriceType price, TThostFtdcVolumeType vol, int ARequestId);
	// ��ѯ����
	void ReqQryOrder(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AInvestorID,
		TThostFtdcInstrumentIDType AInstrumentID, TThostFtdcExchangeIDType AExchangeID,
		TThostFtdcOrderSysIDType AOrderSysID, TThostFtdcTimeType AInsertTimeStart,
		TThostFtdcTimeType AInsertTimeEnd, int ARequestId);
	// ��ѯ�ɽ�
	void ReqQryTrade(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AInvestorID,
		TThostFtdcInstrumentIDType AInstrumentID, TThostFtdcExchangeIDType AExchangeID,
		TThostFtdcTradeIDType ATradeID, TThostFtdcTimeType ATradeTimeStart,
		TThostFtdcTimeType ATradeTimeEnd, int ARequestId);
	// �����ѯ��Լ��������
	void ReqQryInstrumentCommissionRate(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId,
		TThostFtdcInstrumentIDType instId, int ARequestId);
	///������������
	void ReqOrderAction(TThostFtdcBrokerIDType ABrokerId, 
		TThostFtdcUserIDType AUserId, 
		TThostFtdcSequenceNoType AorderSeq,
		TThostFtdcExchangeIDType AExchangeID,
		TThostFtdcOrderSysIDType AOrderSysID, 
		int ARequestId);

	///�����ѯǩԼ����
	void ReqQryContractBank(TThostFtdcBrokerIDType ABrokerId, TThostFtdcBankIDType ABankID, TThostFtdcBankBrchIDType	ABankBrchID, int ARequestId);

	///�����ѯ����ǩԼ��ϵ
	void ReqQryAccountregister(TThostFtdcBrokerIDType ABrokerId,
		TThostFtdcAccountIDType	AccountID,
		TThostFtdcBankIDType	ABankID,
		TThostFtdcBankBrchIDType ABankBranchID, int ARequestId);

	///�ڻ����������ʽ�ת�ڻ�����
	void ReqFromBankToFutureByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId);

	///�ڻ������ڻ��ʽ�ת��������
	void ReqFromFutureToBankByFuture(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, int ARequestId);

	///�����ѯͶ����
	void ReqQryInvestor(TThostFtdcBrokerIDType ABrokerId, TThostFtdcInvestorIDType AUserId, int ARequestId);

	// �Ƿ��յ��ɹ�����Ӧ
	bool IsErrorRspInfo(CThostFtdcRspInfoField *pRspInfo);
private:
  CThostFtdcTraderApi* fTraderApi;
public:
	HWND fwndHost;
};

#endif