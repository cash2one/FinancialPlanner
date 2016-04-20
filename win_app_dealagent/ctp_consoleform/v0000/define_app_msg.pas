unit define_app_msg;

interface

uses
  Windows, Messages;
           
type
  PCommand = ^TCommand;                   
  TCommand = record // 192   
    fcmd1: double;  // 8
    fcmd2: double;  // 8
    fcmd3: double;  // 8
    fcmd4: double;  // 8
    icmd1: integer; // 4
    icmd2: integer; // 4
    icmd3: integer; // 4
    icmd4: integer; // 4     
    scmd1: array[0..32 - 1] of AnsiChar;  // 64
    scmd2: array[0..16 - 1] of AnsiChar;  // 16
    scmd3: array[0..16 - 1] of AnsiChar;   // 16
    scmd4: array[0..16 - 1] of AnsiChar;   // 16    
    scmd5: array[0..16 - 1] of AnsiChar;   // 16
    scmd6: array[0..16 - 1] of AnsiChar;   // 16  
  end;
  
  TCopyDataCommand = record
    Base: TCopyDataStruct;
    CommonCommand: TCommand;
  end;
   
const
  WM_App_Start        = $0401;
  WM_App_Quit         = $0402;

  WM_Start_ExProcess      = $0411;
  WM_End_ExProcess_Notify = $0412;
  WM_End_ExProcess_Force  = $0413;

  WM_User_Logined_Deal    = $0431;

  WM_C2C_Start_Quote        = $0441;
  WM_C2C_End_Quote          = $0442;

  WM_S2C_DEBUG_OUTPUT       = $0421;

  WM_M2M_OpenDeal           = $1001;

  WM_S2C_MD_FrontDisconnected  = $1101;
  WM_S2C_MD_FrontConnected  = $1102;
  WM_S2C_MD_RspUserLogin  = $1103;    
  WM_S2C_MD_IsErrorRspInfo  = $1104;
  WM_S2C_MD_RspError  = $1105;
  WM_S2C_MD_HeartBeatWarning  = $1106;
                                         
  WM_S2C_RspUnSubMarketData  = $1121;   
  WM_S2C_RspSubMarketData  = $1122;
  WM_S2C_RtnDepthMarketData  = $1123;

  WM_S2C_Deal_FrontDisconnected  = $1301;
  WM_S2C_Deal_FrontConnected  = $1302;
  WM_S2C_Deal_RspUserLogin  = $1303;
  WM_S2C_Deal_IsErrorRspInfo  = $1304;
  WM_S2C_Deal_RspError  = $1305;
  WM_S2C_Deal_HeartBeatWarning  = $1306;

  WM_S2C_RspOrderAction  = $0801;
  WM_S2C_RspOrderInsert  = $0802;
  WM_S2C_RspQryInstrument  = $0803;
  WM_S2C_RspQryInvestorPosition  = $0804;
  WM_S2C_RspQryTradingAccount  = $0805;
  WM_S2C_RspSettlementInfoConfirm  = $0806;
  WM_S2C_RtnOrder  = $0807;
  WM_S2C_RtnTrade  = $0808;
  WM_S2C_RspQryOrder = $0809;
  WM_S2C_RspQryTrade = $080A;

  WM_C2S_Shutdown  = $2001;  // 

  WM_C2S_MD_RequestInitialize  = $2101;  // 初始化
  WM_C2S_MD_RequestFinalize  = $2102; // 结束
  WM_C2S_MD_RequestConnectFront  = $2103;  // 连接
  WM_C2S_MD_RequestUserLogin  = $2104;  // 登录
  WM_C2S_MD_RequestUserLogout  = $2105;  // 登出

  WM_C2S_Deal_RequestInitialize  = $2201;  // 初始化
  WM_C2S_Deal_RequestFinalize  = $2202;  // 结束
  WM_C2S_Deal_RequestConnectFront  = $2203;  // 连接
  WM_C2S_Deal_RequestUserLogin  = $2204;  // 登录
  WM_C2S_Deal_RequestUserLogout  = $2205;  // 登出
  WM_C2S_Deal_RequestChangeDealPwd  = $2206;  // 修改交易密码

  WM_C2S_RequestSettlementInfoConfirm  = $2301;  // 结算单确认
  WM_C2S_RequestQueryInstrument  = $2302;  // 查询合约
  WM_C2S_RequestQueryMoney  = $2303;  // 查询资金
  WM_C2S_RequestQueryHold  = $2304;  // 查询持仓
  WM_C2S_RequestOrder  = $2305;  // 报单
  WM_C2S_RequestCancelOrder  = $2306;  // 撤单
  WM_C2S_RequestQueryOrder = $2307;  // 查询报单
  WM_C2S_RequestQueryTrade = $2308;  // 查询成交

  WM_C2S_SubscribeMarketData  = $2401;  // 请求行情订阅
  WM_C2S_UnSubscribeMarketData = $2402;  // 取消行情订阅

  function MsgText(AMsgId: Integer): string;

implementation

function MsgText(AMsgId: Integer): string;
begin
  Result := 'unknown msg';
  case AMsgId of
    WM_C2C_Start_Quote : Result := 'WM_C2C_Start_Quote';
    WM_S2C_DEBUG_OUTPUT       : Result := 'WM_S2C_DEBUG_OUTPUT';

    WM_S2C_MD_FrontDisconnected  : Result := 'WM_S2C_MD_FrontDisconnected';
    WM_S2C_MD_FrontConnected  : Result := 'WM_S2C_MD_FrontConnected';    
    WM_S2C_MD_HeartBeatWarning  : Result := 'WM_S2C_MD_HeartBeatWarning';  
    WM_S2C_MD_RspUserLogin  : Result := 'WM_S2C_MD_RspUserLogin';
    WM_S2C_MD_IsErrorRspInfo  : Result := 'WM_S2C_MD_IsErrorRspInfo';
    WM_S2C_MD_RspError  : Result := 'WM_S2C_MD_RspError';
                                             
    WM_S2C_Deal_FrontDisconnected  : Result := 'WM_S2C_Deal_FrontDisconnected';
    WM_S2C_Deal_FrontConnected  : Result := 'WM_S2C_Deal_FrontConnected';   
    WM_S2C_Deal_HeartBeatWarning  : Result := 'WM_S2C_Deal_HeartBeatWarning';
    WM_S2C_Deal_RspUserLogin  : Result := 'WM_S2C_Deal_RspUserLogin';
    WM_S2C_Deal_IsErrorRspInfo  : Result := 'WM_S2C_Deal_IsErrorRspInfo';
    WM_S2C_Deal_RspError  : Result := 'WM_S2C_Deal_RspError';

    WM_S2C_RspUnSubMarketData  : Result := 'WM_S2C_RspUnSubMarketData';
    WM_S2C_RtnDepthMarketData  : Result := 'WM_S2C_RtnDepthMarketData';
    WM_S2C_RspSubMarketData  : Result := 'WM_S2C_RspSubMarketData';

    WM_S2C_RspOrderAction  : Result := 'WM_S2C_RspOrderAction';
    WM_S2C_RspOrderInsert  : Result := 'WM_S2C_RspOrderInsert';
    WM_S2C_RspQryInstrument  : Result := 'WM_S2C_RspQryInstrument';
    WM_S2C_RspQryInvestorPosition  : Result := 'WM_S2C_RspQryInvestorPosition';
    WM_S2C_RspQryTradingAccount  : Result := 'WM_S2C_RspQryTradingAccount';
    WM_S2C_RspSettlementInfoConfirm  : Result := 'WM_S2C_RspSettlementInfoConfirm';
    WM_S2C_RtnOrder  : Result := 'WM_S2C_RtnOrder';
    WM_S2C_RtnTrade  : Result := 'WM_S2C_RtnTrade';
    WM_S2C_RspQryOrder : Result := 'WM_S2C_RspQryOrder';
    WM_S2C_RspQryTrade : Result := 'WM_S2C_RspQryTrade';
  end;
end;

end.
