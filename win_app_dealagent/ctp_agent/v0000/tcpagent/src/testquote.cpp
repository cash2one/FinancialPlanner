#include "testquote.h"
#include "config.h"
#include <Windows.h>
#include <tchar.h>

void DO_CTP_Initialize() {
	//��ʼ��UserApi

	//CThostFtdcMdApi*
	if (NULL == g_pFtdcMdApi) {
		g_pFtdcMdApi = CThostFtdcMdApi::CreateFtdcMdApi();
	}
	if (NULL == g_pMdSpi) {
		g_pMdSpi = new CtpMdSpi(g_pFtdcMdApi); //�����ص����������MdSpi
		//g_pUserSpi->fEvent = CreateEvent(NULL, true, false, NULL);   //�ӿ��߳�����, ��ʼ����
		g_pMdSpi->fwndHost = g_wndHost;// 
		g_pFtdcMdApi->RegisterSpi(g_pMdSpi);			 // �ص�����ע��ӿ���
	}
}

void DO_CTP_Finalize() {
	/*//
	// http ://blog.csdn.net/windhaunting/article/details/4735338
	// try{} catch(��){}������C++��һЩ���벻�����쳣
	// ������debug��û�����⣬�쳣�ᱻ���񣬻ᵯ����catched������Ϣ�� ����Release��ʽ�����ѡ���˱����������Ż�ѡ�
	// ��VC��������ȥ����try���еĴ��룬 ���û���ҵ�throw���룬 ���ͻ���Ϊtry catch�ṹ�Ƕ���ģ� ���Ż���
	// �����������м��� /EHa �Ĳ���������VC�����������try catchģ����Ż�����
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
		g_pFtdcMdApi->RegisterFront(pszFrontAddress);		     // ע������ǰ�õ�ַ
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
		g_pFtdcMdApi->Join();      //�ȴ��ӿ��߳��˳�
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
//��Ϣ������
LRESULT WINAPI WinProc(HWND AWnd, UINT AMsg, WPARAM wParam, LPARAM lParam)
{
	switch (AMsg)//������Ϣ����
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
		//	g_pUserApi->Join();      //�ȴ��ӿ��߳��˳�
		//	g_pUserApi = NULL;
		//}
		Sleep(100);
		PostQuitMessage(0);//�˳���Ϣ����
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
	case WM_DESTROY://��Ӧ��굥���رհ�ť�¼�
		g_bIsAppActive = false;
		Sleep(200);
		PostQuitMessage(0);//�˳���Ϣ����
		return 0;//�˳�����
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
	tmpWinClass.hbrBackground = 0;// (HBRUSH)GetStockObject(WHITE_BRUSH);//ͨ������������һ����ɫ�ı���������������ΪNULL�����������Ȥ��
	tmpWinClass.hCursor = NULL;//������
	tmpWinClass.hIcon = NULL;//������
	tmpWinClass.hIconSm = NULL;//������
	tmpWinClass.hInstance = hInstance;//��ǰ����ľ����hInstance����ϵͳ�����ݵ�
	tmpWinClass.lpfnWndProc = WinProc;//���ڴ�����̵Ļص�������
	tmpWinClass.lpszClassName = szClassName;//����������֡�
	tmpWinClass.lpszMenuName = NULL;
	tmpWinClass.style = 0;// CS_HREDRAW | CS_VREDRAW;
	RegisterClassEx(&tmpWinClass);//��ϵͳ��ע��
	g_ApplicationWindow = CreateWindowEx(
		WS_EX_TOOLWINDOW, // | WS_EX_TOPMOST,
		szClassName, 
		_T("quote"), //_T("srvside") //_T("�ҵĴ�����ϲ��"),
		WS_POPUP,
		0, //200, 
		0, //100, 
		0, //600, 
		0, //400, 
		HWND_MESSAGE, //NULL,
		NULL, 
		hInstance, 
		NULL);//�������ڣ����ڱ���Ϊ"�ҵĴ�����ϲ��"
	if (NULL == g_ApplicationWindow)
	{
		MessageBox(NULL, _T("There's an Error"), _T("Error Title"), MB_ICONEXCLAMATION | MB_OK);
		return 0;
	}
	SetParent(g_ApplicationWindow, HWND_MESSAGE);
	//ShowWindow(hWnd, nShowCmd);//��ʾ����
	PostMessage(g_ApplicationWindow, WM_APP_START, 0, 0);

	MSG tmpMsg = { 0 };
	//�����Ƕ���Ϣ��ѭ����������Ȳ��ع���Щ���½ڿ��һ�ϸ˵��
	while (GetMessage(&tmpMsg, NULL, 0, 0))
	{
		TranslateMessage(&tmpMsg);//������Ϣ
		DispatchMessage(&tmpMsg);//������Ϣ
	}
	return 0;
}
