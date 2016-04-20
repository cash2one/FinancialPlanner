#include "testquote.h"
#include "config.h"
#include <Windows.h>
#include <tchar.h>

void DO_CTP_Initialize() {
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

void DO_CTP_Finalize() {
	/*//
	// http ://blog.csdn.net/windhaunting/article/details/4735338
	// try{} catch(…){}来捕获C++中一些意想不到的异常
	// 代码在debug下没有问题，异常会被捕获，会弹出”catched”的消息框。 但在Release方式下如果选择了编译器代码优化选项，
	// 则VC编译器会去搜索try块中的代码， 如果没有找到throw代码， 他就会认为try catch结构是多余的， 给优化掉
	// 编译命令行中加入 /EHa 的参数。这样VC编译器不会把try catch模块给优化掉了
	//*/
	__try {
		if (NULL != g_pFtdcMdApi) {
			g_pFtdcMdApi = NULL;// .Release();
		}
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
	}

	__try {
	    if (NULL != g_pMdSpi) {
		    g_pMdSpi = NULL;
	    }
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
	}
}

void DO_CTP_Connect(char *pszFrontAddress) {
	if (NULL != g_pFtdcMdApi) {
		g_pFtdcMdApi->RegisterFront(pszFrontAddress);		     // 注册行情前置地址
		g_pFtdcMdApi->Init();
	}
}

void DO_CTP_Login(TThostFtdcBrokerIDType ABrokerId, TThostFtdcUserIDType AUserId, TThostFtdcPasswordType APassword, int ARequestId) {
	if (NULL != g_pMdSpi) {
		g_pMdSpi->ReqUserLogin(ABrokerId, AUserId, APassword, ARequestId);
	}
}

void DO_CTP_Subscribe(char* instIdList) {
	if (NULL != g_pMdSpi) {
		g_pMdSpi->SubscribeMarketData(instIdList);
	}
}

void DO_CTP_UnSubscribe(char* instIdList) {
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
	case WM_COPYDATA: {
		COPYDATASTRUCT *pCopyData = (COPYDATASTRUCT*)lParam;
		TCopyData_Command command;
		ZeroMemory(&command, sizeof(command));
		memcpy(&command, pCopyData->lpData, sizeof(command));
		if (WM_C2S_RequestConnectFront == pCopyData->dwData) {
			DO_CTP_Connect(command.scmd1);
		}
		if (WM_C2S_RequestUserLogin == pCopyData->dwData) {
			DO_CTP_Login(command.scmd3, command.scmd1, command.scmd2, command.icmd1);
		}
		if (WM_C2S_SubscribeMarketData == pCopyData->dwData) {
			DO_CTP_Subscribe(command.scmd1);
		}
		if (WM_C2S_UnSubscribeMarketData == pCopyData->dwData) {
			DO_CTP_UnSubscribe(command.scmd1);
		}
		return 0;
	}
	case WM_C2S_RequestInitialize:
		DO_CTP_Initialize();
		return 0;
	case WM_C2S_RequestConnectFront:
		DO_CTP_Connect(mdFront_zs);
		return 0;
	case WM_C2S_RequestFinalize:
		DO_CTP_Finalize();
		return 0;
	case WM_C2S_RequestUserLogin:
		DO_CTP_Login("8060", "99686047", "166335", 1);
		return 0;
	case WM_C2S_SubscribeMarketData:
		DO_CTP_Subscribe("IF1508");
		return 0;
	case WM_C2S_UnSubscribeMarketData:
		DO_CTP_UnSubscribe("IF1508");
		return 0;
	case WM_NCHITTEST:
		return HTCAPTION;
	case WM_DESTROY://响应鼠标单击关闭按钮事件
		g_bIsAppActive = false;
		Sleep(200);
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
		_T("quote"), //_T("srvside") //_T("我的窗口我喜欢"),
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
