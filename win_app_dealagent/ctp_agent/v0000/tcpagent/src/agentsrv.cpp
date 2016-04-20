#include "agentsrv.h"
#include <Windows.h>
#include <tchar.h>
#include "config.h"

void DO_CTP_MD_Initialize() {
	//初始化UserApi

	//CThostFtdcMdApi*
	if (NULL == g_pFtdcMdApi) {
		g_pFtdcMdApi = CThostFtdcMdApi::CreateFtdcMdApi();
	}
	if (NULL == g_pMdSpi) {
		g_pMdSpi = new CtpMdSpi(g_pFtdcMdApi); //创建回调处理类对象MdSpi
		//g_pUserSpi->fEvent = CreateEvent(NULL, true, false, NULL);   //接口线程启动, 开始工作
		g_pMdSpi->fwndHost = g_wndHost;// 
		g_pFtdcMdApi->RegisterSpi(g_pMdSpi);			 // 回调对象注入接口类
	}
}

void DO_CTP_Deal_Initialize() {
	//初始化UserApi

	//CThostFtdcMdApi*
	if (NULL == g_pFtdcTraderApi) {
		g_pFtdcTraderApi = CThostFtdcTraderApi::CreateFtdcTraderApi();
	}
	if (NULL == g_pTraderSpi) {
		g_pTraderSpi = new CtpTraderSpi(g_pFtdcTraderApi); //创建回调处理类对象MdSpi
		//g_pUserSpi->fEvent = CreateEvent(NULL, true, false, NULL);   //接口线程启动, 开始工作
		g_pTraderSpi->fwndHost = g_wndHost;// 
		g_pFtdcTraderApi->RegisterSpi(g_pTraderSpi);			 // 回调对象注入接口类
		g_pFtdcTraderApi->SubscribePublicTopic(THOST_TERT_RESTART);					// 注册公有流
		g_pFtdcTraderApi->SubscribePrivateTopic(THOST_TERT_RESTART);			  // 注册私有流
	}
}

void DO_CTP_MD_Finalize() {
	/*//
	// http ://blog.csdn.net/windhaunting/article/details/4735338
	// try{} catch(…){}来捕获C++中一些意想不到的异常
	// 代码在debug下没有问题，异常会被捕获，会弹出”catched”的消息框。 但在Release方式下如果选择了编译器代码优化选项，
	// 则VC编译器会去搜索try块中的代码， 如果没有找到throw代码， 他就会认为try catch结构是多余的， 给优化掉
	// 编译命令行中加入 /EHa 的参数。这样VC编译器不会把try catch模块给优化掉了
	//*/
	__try {
		if (NULL != g_pFtdcMdApi) {
			g_pFtdcMdApi->RegisterSpi(NULL);
			g_pFtdcMdApi->Release();
			g_pFtdcMdApi = NULL;// .Release();
		}
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
	}

	__try {
		if (NULL != g_pMdSpi) {
			delete g_pMdSpi;
		    g_pMdSpi = NULL;
	    }
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
	}
}

void DO_CTP_Deal_Finalize() {
	__try {
		if (NULL != g_pFtdcTraderApi) {
			g_pFtdcTraderApi->RegisterSpi(NULL);
			g_pFtdcTraderApi->Release();
			g_pFtdcTraderApi = NULL;// .Release();
		}
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
	}

	__try {
		if (NULL != g_pTraderSpi) {
			delete g_pTraderSpi;
			g_pTraderSpi = NULL;
		}
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
	}
}

void DO_CTP_MD_Connect(char *pszFrontAddress) {
	if (NULL != g_pFtdcMdApi) {
		g_pFtdcMdApi->RegisterFront(pszFrontAddress);		     // 注册行情前置地址
		g_pFtdcMdApi->Init();
	}
}

void DO_CTP_Deal_Connect(char *pszFrontAddress) {
	if (NULL != g_pFtdcTraderApi) {
		g_pFtdcTraderApi->RegisterFront(pszFrontAddress);		     // 注册行情前置地址
		g_pFtdcTraderApi->Init();
	}
}

void DO_CTP_MD_Login(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcPasswordType APassword, int ARequestId) {
	strcpy(g_brokerId, ABrokerId);
	strcpy(g_userId, AUserId);
	if (NULL != g_pMdSpi) {
		g_pMdSpi->ReqUserLogin(ABrokerId, AUserId, APassword, ARequestId);
	}
}

void DO_CTP_MD_Logout(int ARequestId) {
	if (NULL != g_pMdSpi) {
		g_pMdSpi->ReqUserLogout(g_brokerId, g_userId, ARequestId);
	}
}

void DO_CTP_Deal_Login(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcPasswordType APassword, int ARequestId) {
	strcpy(g_brokerId, ABrokerId);
	strcpy(g_userId, AUserId);
	if (NULL != g_pTraderSpi) {
		g_pTraderSpi->ReqUserLogin(ABrokerId, AUserId, APassword, ARequestId);
	}
}

void DO_CTP_Deal_ChangeDealPwd(TThostFtdcPasswordType AOldPassword, TThostFtdcPasswordType ANewPassword, int ARequestId) {
	if (NULL != g_pTraderSpi) {
		g_pTraderSpi->ReqUserPasswordUpdate(g_brokerId, g_userId, AOldPassword, ANewPassword, ARequestId);
	}
}

void DO_CTP_Deal_Logout(int ARequestId) {
	if (NULL != g_pTraderSpi) {
		g_pTraderSpi->ReqUserLogout(g_brokerId, g_userId, ARequestId);
	}
}

void DO_CTP_MD_Subscribe(char* instIdList) {
	if (NULL != g_pMdSpi) {
		g_pMdSpi->SubscribeMarketData(instIdList);
	}
}

void DO_CTP_MD_UnSubscribe(char* instIdList) {
	if (NULL != g_pMdSpi) {
		g_pMdSpi->UnSubscribeMarketData(instIdList);
	}
}
/*//
DWORD  WINAPI CTP_ThreadProc(LPVOID lpParam) {
	DO_CTP_Initialize();
	DO_CTP_Connect(mdFront);
	while (g_bIsAppActive) {
		Sleep(100);
	}
	if (NULL != g_pFtdcMdApi) {
		g_pFtdcMdApi->Join();      //等待接口线程退出
	}
	return 0;
}
//*/
DWORD  WINAPI MonitorHost_ThreadProc(LPVOID lpParam) {
	BOOL tmpIsFindHost = TRUE;
	while (g_bIsAppActive) {
		Sleep(100);
		tmpIsFindHost = IsWindow(g_wndHost);
		if (tmpIsFindHost == FALSE) {
			g_bIsAppActive = false;
		}
	}
	g_bIsAppActive = false;
	Sleep(200);
	PostMessage(g_ApplicationWindow, WM_APP_QUIT, 0, 0);
	Sleep(500);
	TerminateProcess(GetCurrentProcess, 0);
	return 0;
}
//消息处理函数
LRESULT WINAPI WinProc(HWND AWnd, UINT AMsg, WPARAM wParam, LPARAM lParam)
{
	switch (AMsg)//处理消息过程
	{
	case WM_APP_START:
		//DO_CTP_Initialize();
		//DO_CTP_Connect();
		//CTP_Thead = CreateThread(NULL, 0, CTP_ThreadProc, NULL, 0, &CTP_ThreadID);
		return 0;
	case WM_APP_QUIT:
		g_bIsAppActive = false;
		//PostMessage(AWnd, WM_QUIT, 0, 0);
		//PostMessage(AWnd, WM_CLOSE, 0, 0);
		//CloseWindow(AWnd);
		//if (NULL != g_pUserApi) {
		//	g_pUserApi->Join();      //等待接口线程退出
		//	g_pUserApi = NULL;
		//}
		Sleep(100);
		PostQuitMessage(0);//退出消息队列
		return 0;
	case WM_C2S_ShutDown:
		g_bIsAppActive = false;
		PostMessage(g_ApplicationWindow, WM_APP_QUIT, 0, 0);
		return 0;
	case WM_COPYDATA: {
		COPYDATASTRUCT *pCopyData = (COPYDATASTRUCT*)lParam;
		TCopyData_Command command;
		ZeroMemory(&command, sizeof(command));
		memcpy(&command, pCopyData->lpData, sizeof(command));
		// 把重要的需要第一时间处理 的command 放前面
		if (WM_C2S_RequestOrder == pCopyData->dwData) {
			// 下单
			//#define THOST_FTDC_D_Buy '0'
			//#define THOST_FTDC_D_Sell '1'
			TThostFtdcDirectionType direction = THOST_FTDC_D_Buy;
			if (1 == command.icmd1) {
				direction = THOST_FTDC_D_Sell;
			}

			//#define THOST_FTDC_OF_Open '0' 开仓
			//#define THOST_FTDC_OF_Close '1' 平仓
			//#define THOST_FTDC_OF_ForceClose '2' 强平
			//#define THOST_FTDC_OF_CloseToday '3' 平今
			//#define THOST_FTDC_OF_CloseYesterday '4' 平昨
			//#define THOST_FTDC_OF_ForceOff '5' 强减
			//#define THOST_FTDC_OF_LocalForceClose '6' 本地强平

			TThostFtdcCombOffsetFlagType kpflag;
			kpflag[0] = THOST_FTDC_OF_Open;
			if (1 == command.icmd3) {
				kpflag[0] = THOST_FTDC_OF_Close;
			}
			if (3 == command.icmd3) {
				kpflag[0] = THOST_FTDC_OF_CloseToday;
			}

			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqOrderInsert(g_brokerId, g_userId, command.scmd1, // 合约 IF1508
					direction, // 方向
					kpflag,  // 开仓 平仓 
					command.fcmd1,
					1 //command.icmd2
					, command.icmd4);
			}
			return 0;
		}
		if (WM_C2S_RequestCancelOrder == pCopyData->dwData) {
			// 撤单
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqOrderAction(g_brokerId, g_userId,
					command.icmd1,
					command.scmd1,
					command.scmd2,
					command.icmd2);
			}
			return 0;
		}
		if (WM_C2S_RequestMDConnectFront == pCopyData->dwData) {
			DO_CTP_MD_Connect(command.scmd1);
			return 0;
		}
		if (WM_C2S_RequestDealConnectFront == pCopyData->dwData) {
			DO_CTP_Deal_Connect(command.scmd1);
			return 0;
		}
		if (WM_C2S_RequestMDUserLogin == pCopyData->dwData) {
			DO_CTP_MD_Login(command.scmd3, command.scmd1, command.scmd2, command.icmd1);
			return 0;
		}
		if (WM_C2S_RequestDealUserLogin == pCopyData->dwData) {
			DO_CTP_Deal_Login(command.scmd3, command.scmd1, command.scmd2, command.icmd1);
			return 0;
		}
		if (WM_C2S_RequestDealChangeDealPwd == pCopyData->dwData) {
			DO_CTP_Deal_ChangeDealPwd(command.scmd1, command.scmd2, command.icmd1);
		    return 0;
		}
		if (WM_C2S_SubscribeMarketData == pCopyData->dwData) {
			DO_CTP_MD_Subscribe(command.scmd1);
			return 0;
		}
		if (WM_C2S_UnSubscribeMarketData == pCopyData->dwData) {
			DO_CTP_MD_UnSubscribe(command.scmd1);
			return 0;
		}
		if (WM_C2S_RequestQueryMoney == pCopyData->dwData) {
			// 查询资金
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqQryTradingAccount(g_brokerId, g_userId, "CNY", command.icmd1);
			}
			return 0;
		}
		if (WM_C2S_RequestQueryHold == pCopyData->dwData) {
			// 查询持仓
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqQryInvestorPosition(g_brokerId, g_userId, command.scmd1, command.icmd1);
			}
			return 0;
		}
		if (WM_C2S_RequestQueryInstrumentCommissionRate == pCopyData->dwData) {
			// 查询合约手续费率
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqQryInstrumentCommissionRate(g_brokerId, g_userId, command.scmd1, command.icmd1);
			}
			return 0;
		}
		if (WM_C2S_RequestQueryInstrument == pCopyData->dwData) {
			// 查询合约 ?? 这是什么 查行情 ???
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqQryInstrument(command.scmd1, command.icmd1);
			}
			return 0;
		}
		if (WM_C2S_RequestQueryOrder == pCopyData->dwData) {
			// 查询报单
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqQryOrder(g_brokerId, g_userId, 
					command.scmd1, command.scmd2, command.scmd3, command.scmd4, command.scmd5, command.icmd1);
			}
			return 0;
		}
		if (WM_C2S_RequestQueryTrade == pCopyData->dwData) {
			// 查询成交
			if (NULL != g_pTraderSpi) {
				g_pTraderSpi->ReqQryTrade(g_brokerId, g_userId, command.scmd1, command.scmd2, command.scmd3, 
					command.scmd4, command.scmd5, command.icmd1);
			}
			return 0;
		}
		return 0;
	}
	case WM_C2S_RequestMDInitialize:
		DO_CTP_MD_Initialize();
		return 0;
	//*/
	case WM_C2S_RequestDealInitialize:
		DO_CTP_Deal_Initialize();
		return 0;//*/
	case WM_C2S_RequestMDConnectFront:
		DO_CTP_MD_Connect("tcp://180.166.65.114:41213");
		return 0;
	case WM_C2S_RequestDealConnectFront:
		DO_CTP_Deal_Connect("tcp://180.166.65.114:41213");
		return 0;
	case WM_C2S_RequestMDFinalize:
		DO_CTP_MD_Finalize();
		return 0;
	case WM_C2S_RequestDealFinalize:
		DO_CTP_Deal_Finalize();
		return 0;
	case WM_C2S_RequestMDUserLogin:
		DO_CTP_MD_Login("8060", "99686047", "166335", 1);
		return 0;
	case WM_C2S_RequestMDUserLogout:
		DO_CTP_MD_Logout(wParam);
		return 0;
	case WM_C2S_RequestDealUserLogin:
		DO_CTP_Deal_Login("8060", "99686047", "166335", 1);
		return 0;
	case WM_C2S_RequestDealUserLogout:
		DO_CTP_Deal_Logout(wParam);
		return 0;
	case WM_C2S_SubscribeMarketData:
		DO_CTP_MD_Subscribe("IF1508");
		return 0;
	case WM_C2S_UnSubscribeMarketData:
		DO_CTP_MD_UnSubscribe("IF1508");
		return 0;
	case WM_C2S_RequestSettlementInfoConfirm: //    0x0602  // 结算单确认
		if (NULL != g_pTraderSpi) {
			g_pTraderSpi->ReqSettlementInfoConfirm(g_brokerId, g_userId, wParam);
		}
		return 0;
	case WM_C2S_RequestQueryMoney: {//               0x0604  // 查询资金
		if (NULL != g_pTraderSpi) {
			g_pTraderSpi->ReqQryTradingAccount(g_brokerId, g_userId, "CNY", wParam);
		}
		return 0;
	}
	case WM_NCHITTEST:
		return HTCAPTION;
	case WM_DESTROY://响应鼠标单击关闭按钮事件
		g_bIsAppActive = false;
		Sleep(300);
		PostQuitMessage(0);//退出消息队列
		return 0;//退出函数
	}
	return DefWindowProc(AWnd, AMsg, wParam, lParam);
}

int WinMain(
	__in HINSTANCE hInstance,
	__in_opt HINSTANCE hPrevInstance,
	__in LPSTR lpCmdLine,
	__in int nShowCmd)
{
	g_bIsAppActive = true;
	g_wndHost = FindWindowA("53A21E38-BE70-447E-B76E-9C07C9C250F8", "");
	BOOL tmpIsFindHost = IsWindow(g_wndHost);
	if (tmpIsFindHost == FALSE) {
		return 0;
	}
	g_MonitorHost_Thread = CreateThread(NULL, 0, MonitorHost_ThreadProc, NULL, 0, &g_MonitorHost_ThreadID);
	TCHAR *szClassName = _T("Tftdc_api_srv");
	WNDCLASSEX tmpWinClass = { 0 };
	tmpWinClass.cbClsExtra = 0;
	tmpWinClass.cbWndExtra = 0;
	tmpWinClass.cbSize = sizeof(WNDCLASSEX);
	tmpWinClass.hbrBackground = 0;// (HBRUSH)GetStockObject(WHITE_BRUSH);//通过函数来设置一个白色的背景，这里大家设置为NULL看看，会很有趣的
	tmpWinClass.hCursor = NULL;//不设置
	tmpWinClass.hIcon = NULL;//不设置
	tmpWinClass.hIconSm = NULL;//不设置
	tmpWinClass.hInstance = hInstance;//当前程序的句柄，hInstance是有系统给传递的
	tmpWinClass.lpfnWndProc = WinProc;//窗口处理过程的回调函数。
	tmpWinClass.lpszClassName = szClassName;//窗口类的名字。
	tmpWinClass.lpszMenuName = NULL;
	tmpWinClass.style = 0;// CS_HREDRAW | CS_VREDRAW;
	RegisterClassEx(&tmpWinClass);//在系统中注册
	g_ApplicationWindow = CreateWindowEx(
		WS_EX_TOOLWINDOW, // | WS_EX_TOPMOST,
		szClassName, 
		_T("tcpagent"), //_T("srvside") //_T("我的窗口我喜欢"),
		WS_POPUP,
		0, //200, 
		0, //100, 
		0, //600, 
		0, //400, 
		HWND_MESSAGE, //NULL,
		NULL, 
		hInstance, 
		NULL);//创建窗口，窗口标题为"我的窗口我喜欢"
	if (NULL == g_ApplicationWindow)
	{
		MessageBox(NULL, _T("There's an Error"), _T("Error Title"), MB_ICONEXCLAMATION | MB_OK);
		return 0;
	}
	SetParent(g_ApplicationWindow, HWND_MESSAGE);
	//ShowWindow(hWnd, nShowCmd);//显示窗口
	PostMessage(g_ApplicationWindow, WM_APP_START, 0, 0);

	MSG tmpMsg = { 0 };
	//下面是对消息的循环处理，大家先不必管这些，下节课我会细说的
	while (GetMessage(&tmpMsg, NULL, 0, 0))
	{
		TranslateMessage(&tmpMsg);//翻译消息
		DispatchMessage(&tmpMsg);//分派消息
	}
	return 0;
}
