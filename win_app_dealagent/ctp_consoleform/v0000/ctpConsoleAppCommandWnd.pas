unit ctpConsoleAppCommandWnd;

interface

uses
  Windows, Messages, sysutils;
                
  function CreateAppCommandWindow: HWND;

implementation

uses
  define_app_msg,
  UtilsApplication,
  ctpConsoleAppCommandWnd_CopyData,
  {WMCopyData, } TcpAgentConsole;

procedure DoWMDEBUGOUTPUT(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('DoWMDEBUGOUTPUT');
end;

procedure WMMDFrontDisconnected(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMMDFrontDisconnected');
  GTcpAgentConsole.Quote.IsMDConnected := false;
end;
              
procedure WMDealFrontDisconnected(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMDealFrontDisconnected');
  GTcpAgentConsole.Deal.IsDealConnected := false;
end;

procedure WMMDHeartBeatWarning(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMHeartBeatWarning');
end;
             
procedure WMDealHeartBeatWarning(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMDealHeartBeatWarning');
end;

procedure WMMDFrontConnected(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMMDFrontConnected');
  GTcpAgentConsole.Quote.IsMDConnected := true;
end;
               
procedure WMDealFrontConnected(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMDealFrontConnected');
  GTcpAgentConsole.Deal.IsDealConnected := true;
end;

procedure WMMDRspUserLogin(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin                               
  if 1 = wParam then
  begin
    //AppCmdWinLog('WMMDRspUserLogin succ');
    GTcpAgentConsole.Quote.IsMDLogined := true;
  end else
  begin
    if 100 = wParam then
    begin
      //AppCmdWinLog('WMMDRspUserLogin fail');
    end;
  end;
end;
           
procedure WMDealRspUserLogin(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  if 1 = wParam then
  begin                   
    //AppCmdWinLog('WMDealRspUserLogin succ');
    GTcpAgentConsole.Deal.IsDealLogined := true;
    PostMessage(AWnd, WM_User_Logined_Deal, 0, 0);
  end else
  begin
    if 100 = wParam then
    begin
      //AppCmdWinLog('WMDealRspUserLogin fail');
    end;
  end;
end;

procedure WMRspUnSubMarketData(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMRspUnSubMarketData');
end;

procedure WMRtnDepthMarketData(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMRtnDepthMarketData');
end;

procedure WMMDIsErrorRspInfo(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMMDIsErrorRspInfo');
end;
                
procedure WMDealIsErrorRspInfo(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMDealIsErrorRspInfo');
end;

procedure WMRspSubMarketData(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMRspSubMarketData');
end;
                           
procedure WMRspQryTradingAccount(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //AppCmdWinLog('WMRspQryTradingAccount');
end;
                   
var
  GIsQuoteMode: Boolean = False;
  GIsEndQuote: Boolean = False;
  
procedure WMC2CStartQuote();
var
  tmpCounter: Integer;
  tmpHour: Word;
  tmpMin: Word;
  tmpSec: Word;
  tmpMSec: Word;
begin
  // 知道了, 如果提早时间连接 可能一直没有连接上 最后就跳掉了
  GIsQuoteMode := true;
  GTcpAgentConsole.Quote.InitMD;
  SleepWait(500);
  DecodeTime(now, tmpHour, tmpMin, tmpSec, tmpMSec);
  if tmpHour = 9 then
  begin
    while tmpMin < 14 do
    begin
      SleepWait(100);   
      DecodeTime(now, tmpHour, tmpMin, tmpSec, tmpMSec);
    end;                  
    if tmpMin = 14 then
    begin
      while (tmpMin = 14) and (tmpSec < 55) do
      begin
        SleepWait(100);
        DecodeTime(now, tmpHour, tmpMin, tmpSec, tmpMSec);
      end;                
    end;
  end;
  tmpCounter := 0;
  while not GTcpAgentConsole.Quote.IsMDConnected do
  begin                                  
    GTcpAgentConsole.Quote.ConnectMD('tcp://180.166.65.119:41213'); 
    SleepWait(500);
    Inc(tmpCounter);
    if tmpCounter > 30 then
      Break;
  end;            
  if GTcpAgentConsole.Quote.IsMDConnected then
  begin
    tmpCounter := 0;
    while not GTcpAgentConsole.Quote.IsMDLogined do
    begin                                   
      GTcpAgentConsole.Quote.LoginMD('8060', '039753', '841122');
      SleepWait(500);
      Inc(tmpCounter);
      if tmpCounter > 10 then
        Break;
    end;           
    GTcpAgentConsole.Quote.MDSubscribe('IF1606');
  end;
end;

procedure WMC2CEndQuote(AWnd: HWND);
begin
  if GIsQuoteMode then
  begin
    if not GIsEndQuote then
    begin
      GIsEndQuote := true;
      GTcpAgentConsole.Quote.MDSaveAllQuote;
      PostMessage(AWnd, WM_App_Quit, 0, 0);
    end;
  end;
end;

procedure DoWMM2MOpenDeal(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  if lParam = 0 then
  begin
    // 否则 不符合价格规则 :) 难怪 下单被自动取消了
    // offset 必须是 0.2 的倍数
    //GTcpAgentConsole.Deal.HandleDealOpenDeal(Pointer(wParam), 1.2);
  end else
  begin
    //GTcpAgentConsole.Deal.HandleDealOpenDeal(Pointer(wParam), Integer(lparam) / 1000);
  end;
end;

procedure DoWM_UserLoginedDeal(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  //1. 一旦完成登录 马上确认 信息
  //2. 获取资金明细
  //3. 获取持仓明细
  GTcpAgentConsole.Deal.ConfirmSettlementInfo;
  SleepWait(1000);
  GTcpAgentConsole.Deal.QueryMoney;        
  SleepWait(1000);   
  GTcpAgentConsole.Deal.QueryUserHold('IF1606');        
  SleepWait(1000);
end;

function AppCommandWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case AMsg of
    WM_App_Quit: begin
      //App.GApp.Quit;
    end;
    WM_CopyData: begin
      DoWMCopyData(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_User_Logined_Deal: begin
      DoWM_UserLoginedDeal(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_DEBUG_OUTPUT:  begin
      DoWMDEBUGOUTPUT(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_M2M_OpenDeal: begin    
      DoWMM2MOpenDeal(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_MD_FrontDisconnected:  begin
      WMMDFrontDisconnected(AWnd, AMsg, wParam, lParam);
      exit;
    end;     
    WM_S2C_Deal_FrontDisconnected:  begin
      WMDealFrontDisconnected(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_MD_HeartBeatWarning: begin
      WMMDHeartBeatWarning(AWnd, AMsg, wParam, lParam);
      exit;
    end;        
    WM_S2C_Deal_HeartBeatWarning: begin
      WMDealHeartBeatWarning(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_MD_FrontConnected: begin
      WMMDFrontConnected(AWnd, AMsg, wParam, lParam);
      exit;
    end;       
    WM_S2C_Deal_FrontConnected: begin
      WMDealFrontConnected(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_MD_RspUserLogin: begin
      WMMDRspUserLogin(AWnd, AMsg, wParam, lParam);
      exit;
    end;          
    WM_S2C_Deal_RspUserLogin: begin
      WMDealRspUserLogin(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_RspUnSubMarketData: begin
      WMRspUnSubMarketData(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_RtnDepthMarketData: begin
      WMRtnDepthMarketData(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_MD_IsErrorRspInfo: begin
      WMMDIsErrorRspInfo(AWnd, AMsg, wParam, lParam);
      exit;
    end;        
    WM_S2C_Deal_IsErrorRspInfo: begin
      WMDealIsErrorRspInfo(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_RspSubMarketData: begin
      WMRspSubMarketData(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_S2C_RspQryTradingAccount: begin
      WMRspQryTradingAccount(AWnd, AMsg, wParam, lParam);
      exit;
    end;
    WM_C2C_Start_Quote: begin
      if wParam = 0 then
      begin
        Result := 1;   
        PostMessage(AWnd, WM_C2C_Start_Quote, 1, 0);
      end else
      begin
        WMC2CStartQuote();
      end;
      exit;
    end;
    WM_C2C_End_Quote: begin
      WMC2CEndQuote(AWnd);
      exit;
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

function CreateAppCommandWindow: HWND;
var
  tmpRegWinClass: TWndClassA;  
  tmpGetWinClass: TWndClassA;
  tmpIsReged: Boolean;
begin
  Result := 0;
  FillChar(tmpRegWinClass, SizeOf(tmpRegWinClass), 0);
  tmpRegWinClass.hInstance := HInstance;
  tmpRegWinClass.lpfnWndProc := @AppCommandWndProcA;
  tmpRegWinClass.lpszClassName := '53A21E38-BE70-447E-B76E-9C07C9C250F8';
  tmpIsReged := GetClassInfoA(HInstance, tmpRegWinClass.lpszClassName, tmpGetWinClass);
  if tmpIsReged then
  begin
    if (tmpGetWinClass.lpfnWndProc <> tmpRegWinClass.lpfnWndProc) then
    begin                           
      UnregisterClassA(tmpRegWinClass.lpszClassName, HInstance);
      tmpIsReged := false;
    end;
  end;
  if not tmpIsReged then
  begin
    if 0 = RegisterClassA(tmpRegWinClass) then
      exit;
  end;
  Result := CreateWindowExA(
    WS_EX_TOOLWINDOW
    //or WS_EX_APPWINDOW
    //or WS_EX_TOPMOST
    ,
    tmpRegWinClass.lpszClassName,
    '', WS_POPUP {+ 0},
    0, 0, 0, 0,
    HWND_MESSAGE, 0, HInstance, nil);
end;

end.
