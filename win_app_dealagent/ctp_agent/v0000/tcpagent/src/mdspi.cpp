#include "mdspi.h"
#include <iostream>
#include <vector>
#include "windows.h"
#include "config.h"

using namespace std;
#pragma warning(disable : 4996)

void CtpMdSpi::OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	SendMessage(fwndHost, WM_S2C_MD_IsErrorRspInfo, nRequestID, 0);

	bool ret = ((pRspInfo) && (pRspInfo->ErrorID != 0));
	if (ret){
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_MD_IsErrorRspInfo;
		CopyData.cbData = sizeof(CThostFtdcRspInfoField);
		CopyData.lpData = pRspInfo;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
	}
    IsErrorRspInfo(pRspInfo);
}

void CtpMdSpi::OnFrontDisconnected(int nReason)
{
	SendMessage(fwndHost, WM_S2C_MD_FrontDisconnected, nReason, 0);
		//cerr << " 响应 | 连接中断..."
	//	<< " reason=" << nReason << endl;
}
		
void CtpMdSpi::OnHeartBeatWarning(int nTimeLapse)
{
	SendMessage(fwndHost, WM_S2C_MD_HeartBeatWarning, nTimeLapse, 0);
		//	cerr << " 响应 | 心跳超时警告..."
		//<< " TimerLapse = " << nTimeLapse << endl;
}

void CtpMdSpi::OnFrontConnected()
{
	SendMessage(fwndHost, WM_S2C_MD_FrontConnected, 0, 0);
		//cerr << " 连接交易前置...成功" << endl;
}

void CtpMdSpi::ReqUserLogin(TThostFtdcBrokerIDType	ABrokerId,
	TThostFtdcUserIDType	AUserId, TThostFtdcPasswordType	APassword, int ARequestID)
{
	CThostFtdcReqUserLoginField tmpLoginRequest;
	memset(&tmpLoginRequest, 0, sizeof(tmpLoginRequest));
	strcpy(tmpLoginRequest.BrokerID, ABrokerId);
	strcpy(tmpLoginRequest.UserID, AUserId);
	strcpy(tmpLoginRequest.Password, APassword);
	int ret = fMdApi->ReqUserLogin(&tmpLoginRequest, ARequestID);
		//cerr << " 请求 | 发送登录..." << ((ret == 0) ? "成功" : "失败") << endl;
}

void CtpMdSpi::ReqUserLogout(TThostFtdcBrokerIDType	ABrokerId, TThostFtdcUserIDType	AUserId, int ARequestID)
{
	CThostFtdcUserLogoutField tmpLogout;
	strcpy(tmpLogout.BrokerID, ABrokerId);
	strcpy(tmpLogout.UserID, AUserId);
	int ret = fMdApi->ReqUserLogout(&tmpLogout, ARequestID);
}

void CtpMdSpi::OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin,
		CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pRspUserLogin)
	{
		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_MD_RspUserLogin;
		CopyData.cbData = sizeof(CThostFtdcRspUserLoginField);
		CopyData.lpData = pRspUserLogin;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)nRequestID, (LPARAM)&CopyData);
			//cerr << " 响应 | 登录成功...当前交易日:"
			//	<< pRspUserLogin->TradingDay << endl;
		SendMessage(fwndHost, WM_S2C_MD_RspUserLogin, 1, nRequestID);
	}
	else
	{
		SendMessage(fwndHost, WM_S2C_MD_RspUserLogin, 100, nRequestID);
	}
}

void CtpMdSpi::SubscribeMarketData(char* instIdList)
{
  vector<char*> list;
  char *token = strtok(instIdList, ",");
  while( token != NULL ){
    list.push_back(token); 
    token = strtok(NULL, ",");
  }
  unsigned int len = list.size();
  char** pInstId = new char* [len];  
  for(unsigned int i=0; i<len;i++)  pInstId[i]=list[i]; 
  int ret = fMdApi->SubscribeMarketData(pInstId, len);
	//  cerr << " 请求 | 发送行情订阅... " << ((ret == 0) ? "成功" : "失败") << endl;
}

void CtpMdSpi::UnSubscribeMarketData(char* instIdList)
{
  vector<char*> list;
  char *token = strtok(instIdList, ",");
  while (token != NULL){
	list.push_back(token);
	token = strtok(NULL, ",");
  }
  unsigned int len = list.size();
  char** pInstId = new char*[len];
  for (unsigned int i = 0; i<len; i++)  pInstId[i] = list[i];
  int ret = fMdApi->UnSubscribeMarketData(pInstId, len);
}

void CtpMdSpi::OnRspSubMarketData(
         CThostFtdcSpecificInstrumentField *pSpecificInstrument, 
         CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pSpecificInstrument)
	{
		SendMessage(fwndHost, WM_S2C_RspSubMarketData, nRequestID, 0);
	}
		//cerr << " 响应 |  行情订阅...成功" << endl;
	
}

void CtpMdSpi::OnRspUnSubMarketData(CThostFtdcSpecificInstrumentField *pSpecificInstrument,
             CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
	if (!IsErrorRspInfo(pRspInfo) && pSpecificInstrument)
	{
		SendMessage(fwndHost, WM_S2C_RspUnSubMarketData, nRequestID, 0);
	}
		//cerr << " 响应 |  行情取消订阅...成功" << endl;
}

void CtpMdSpi::OnRtnDepthMarketData(CThostFtdcDepthMarketDataField *pDepthMarketData)
{
		//cerr << " 行情 | 合约:" << pDepthMarketData->InstrumentID
	//	<< " 现价:" << pDepthMarketData->LastPrice
	//	<< " 最高价:" << pDepthMarketData->HighestPrice
	//	<< " 最低价:" << pDepthMarketData->LowestPrice
	//	<< " 卖一价:" << pDepthMarketData->AskPrice1
	//	<< " 卖一量:" << pDepthMarketData->AskVolume1
	//	<< " 买一价:" << pDepthMarketData->BidPrice1
	//	<< " 买一量:" << pDepthMarketData->BidVolume1
	//	<< " 持仓量:" << pDepthMarketData->OpenInterest << endl;

		//static CThostFtdcDepthMarketDataField szSendBuf;
		//ZeroMemory(&szSendBuf, sizeof(CThostFtdcDepthMarketDataField));

		COPYDATASTRUCT CopyData;
		CopyData.dwData = WM_S2C_RtnDepthMarketData;
		CopyData.cbData = sizeof(CThostFtdcDepthMarketDataField);
		CopyData.lpData = pDepthMarketData;

		SendMessage(fwndHost, WM_COPYDATA, (WPARAM)0, (LPARAM)&CopyData);
}

bool CtpMdSpi::IsErrorRspInfo(CThostFtdcRspInfoField *pRspInfo)
{
  bool ret = ((pRspInfo) && (pRspInfo->ErrorID != 0));
  if (ret){
		 // cerr << " 响应 | " << pRspInfo->ErrorMsg << endl;
  }
  return ret;
}