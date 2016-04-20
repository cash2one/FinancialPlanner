#ifndef MD_CONFIG_H_
#define MD_CONFIG_H_

#pragma once

/*/
extern struct TCopyData_Command
{
	char Command1[16];
	char Command2[16];
	char Command3[16];
	char Command4[16];
	double Command5;
	double Command6;
	int Command7;
	int Command8;
};
//*/

/*
extern typedef struct {
	char Command1[16];
	char Command2[16];
	char Command3[16];
	char Command4[16];
	double Command5;
	double Command6;
	int Command7;
	int Command8;
} TCopyData_Command;

*/
//请求编号
#define WM_APP_START  0x0401
#define WM_APP_QUIT  0x0402

#define WM_S2C_DEBUG_OUTPUT  0x0421


#define WM_S2C_MD_FrontDisconnected  0x1101
#define WM_S2C_MD_FrontConnected  0x1102
#define WM_S2C_MD_RspUserLogin  0x1103
#define WM_S2C_MD_IsErrorRspInfo  0x1104
#define WM_S2C_MD_RspError  0x1105
#define WM_S2C_MD_HeartBeatWarning  0x1106

#define WM_S2C_RspUnSubMarketData  0x1121
#define WM_S2C_RspSubMarketData  0x1122
#define WM_S2C_RtnDepthMarketData  0x1123

#define WM_S2C_Deal_FrontDisconnected  0x1301
#define WM_S2C_Deal_FrontConnected  0x1302
#define WM_S2C_Deal_RspUserLogin  0x1303
#define WM_S2C_Deal_IsErrorRspInfo  0x1304
#define WM_S2C_Deal_RspError  0x1305
#define WM_S2C_Deal_HeartBeatWarning  0x1306

#define WM_S2C_RspOrderAction  0x0801
#define WM_S2C_RspOrderInsert  0x0802
#define WM_S2C_RspQryInstrument  0x0803
#define WM_S2C_RspQryInvestorPosition  0x0804
#define WM_S2C_RspQryTradingAccount  0x0805
#define WM_S2C_RspSettlementInfoConfirm  0x0806
#define WM_S2C_RtnOrder  0x0807
#define WM_S2C_RtnTrade  0x0808
#define WM_S2C_RspQryOrder  0x0809
#define WM_S2C_RspQryTrade  0x080A
#define WM_S2C_RspQryInstrumentCommissionRate 0x080B  // 查询合约手续费率

#define WM_C2S_ShutDown  0x2001

#define WM_C2S_RequestMDInitialize  0x2101  // 初始化
#define WM_C2S_RequestMDFinalize  0x2102 // 结束
#define WM_C2S_RequestMDConnectFront  0x2103  // 连接
#define WM_C2S_RequestMDUserLogin  0x2104  // 登录
#define WM_C2S_RequestMDUserLogout  0x2105  // 登出

#define WM_C2S_RequestDealInitialize  0x2201  // 初始化
#define WM_C2S_RequestDealFinalize  0x2202  // 结束
#define WM_C2S_RequestDealConnectFront  0x2203  // 连接
#define WM_C2S_RequestDealUserLogin  0x2204  // 登录
#define WM_C2S_RequestDealUserLogout  0x2205  // 登出
#define WM_C2S_RequestDealChangeDealPwd  0x2206  // 修改交易密码

#define WM_C2S_RequestSettlementInfoConfirm  0x2301  // 结算单确认
#define WM_C2S_RequestQueryInstrument  0x2302  // 查询合约
#define WM_C2S_RequestQueryMoney  0x2303  // 查询资金
#define WM_C2S_RequestQueryHold  0x2304  // 查询持仓
#define WM_C2S_RequestOrder  0x2305  // 报单
#define WM_C2S_RequestCancelOrder  0x2306  // 撤单
#define WM_C2S_RequestQueryOrder 0x2307  // 查询报单
#define WM_C2S_RequestQueryTrade 0x2308  // 查询成交
#define WM_C2S_RequestQueryInstrumentCommissionRate 0x2309  // 查询合约手续费率

#define WM_C2S_SubscribeMarketData  0x2401  // 请求行情订阅
#define WM_C2S_UnSubscribeMarketData 0x2402  // 取消行情订阅


// 前置地址
//char mdFront[]   ="tcp://asp-sim2-front1.financial-trading-platform.com:26213";
//char tradeFront[]="tcp://asp-sim2-front1.financial-trading-platform.com:26205";

//char mdFront_zs[] = "tcp://180.166.65.119:41213"; // 正式 上海电信1
//char mdFront_zs[] = "tcp://180.166.65.120:41213"; // 正式 上海电信2

//char mdFront_zs[] = "tcp://140.206.80.229:41213"; // 正式 上海联通1
//char mdFront_zs[] = "tcp://140.206.80.230:41213"; // 正式 上海联通2

//char mdFront_zs[] = "tcp://183.62.98.29:41213"; // 正式 深圳电信1
//char mdFront_zs[] = "tcp://210.21.232.125:41213"; // 正式 深圳联通1

//char mdFront[] = "tcp://180.166.65.119:41213"; // 正式 上海电信1
//char mdFront_zs[] = "tcp://180.166.65.114:41213"; // 仿真 电信
//char mdFront_zs[] = "tcp://183.62.98.29:41213"; // 正式 深圳电信1
//char mdFront_zs[] = "tcp://140.206.80.234:41213"; // 仿真 联通
//char mdFront_zs_dianxin[] = "tcp://180.166.65.114:41213"; // 仿真 电信
//char mdFront_zs_liantong[] = "tcp://140.206.80.234:41213"; // 仿真 联通

//char mdFront_sw_1[] = "tcp://180.168.212.51:41213"; // 申万
//char mdFront_sw_2[] = "tcp://180.168.212.52:41213"; // 申万
//char mdFront_sw_3[] = "tcp://180.168.212.55:41213"; // 申万
// ---------------------------------------------------------------
//char tradeFront_zs[] = "tcp://180.166.65.119:41205"; // 正式 上海电信1
//char tradeFront_zs[] = "tcp://180.166.65.114:41205"; // 仿真 电信
//char tradeFront_zs_fz_dianxin[] = "tcp://180.166.65.114:41205"; // 招商仿真 电信
//char tradeFront_zs_fz_liantong[] = "tcp://140.206.80.234:41205"; // 招商仿真 联通

//char tradeFront_sw_1[] = "tcp://180.168.212.51:41205"; // 申万
//char tradeFront_sw_2[] = "tcp://180.168.212.52:41205"; // 申万
//char tradeFront_sw_3[] = "tcp://180.168.212.53:41205"; // 申万
//char tradeFront_sw_4[] = "tcp://180.168.212.54:41205"; // 申万
//char tradeFront_sw_5[] = "tcp://180.168.212.55:41205"; // 申万

//char tradeFront_sw_6[] = "tcp://222.73.226.106:41205"; // 申万
//char tradeFront_sw_7[] = "tcp://222.73.226.106:41207"; // 申万
//char tradeFront_sw_8[] = "tcp://222.73.226.106:41209"; // 申万
//char tradeFront_sw_9[] = "tcp://222.73.226.106:412011"; // 申万

#endif