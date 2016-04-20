#ifndef TEST_H_
#define TEST_H_

#include "api/trade/win/public/ThostFtdcMdApi.h"
#include "api/trade/win/public/ThostFtdcTraderApi.h"
#include "mdspi.h"
#include "windows.h"
#include <iostream>
using namespace std;

typedef struct 
{
	char scmd1[32];
	char scmd2[32];
	char scmd3[8];
	char scmd4[8];
	double fcmd1;
	double fcmd2;
	double fcmd3;
	double fcmd4;
	int icmd1;
	int icmd2;
	int icmd3;
	int icmd4;
} TCopyData_Command;

bool g_bIsAppActive = false;
HWND g_wndHost = NULL;
HWND g_ApplicationWindow = NULL;
//HANDLE g_CTP_Thread;    //���ڴ洢�߳̾��  
//DWORD  g_CTP_ThreadID;//���ڴ洢�̵߳�ID  
HANDLE g_MonitorHost_Thread;
DWORD g_MonitorHost_ThreadID;

CThostFtdcMdApi* g_pFtdcMdApi = NULL;
CtpMdSpi* g_pMdSpi = NULL;

#endif