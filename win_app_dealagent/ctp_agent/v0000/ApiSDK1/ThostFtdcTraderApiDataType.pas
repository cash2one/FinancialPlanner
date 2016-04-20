unit ThostFtdcTraderApiDataType;

interface

uses
  ThostFtdcBaseDataType,
  ThostFtdcUserApiDataType,
  ThostFtdcMdApiDataType;
  
type                      
  TThostFtdcSettlementIDType = Integer;  
  TThostFtdcRequestIDType = Integer;     
  TThostFtdcOrderActionRefType = Integer;  
  TThostFtdcSequenceNoType = Integer;  
   
  TThostFtdcPosiDirectionType = AnsiChar;   
  TThostFtdcHedgeFlagType = AnsiChar; 
  TThostFtdcPositionDateType = AnsiChar;    
  TThostFtdcOrderPriceTypeType = AnsiChar;     
  TThostFtdcTimeConditionType = AnsiChar;    
  TThostFtdcVolumeConditionType = AnsiChar;    
  TThostFtdcContingentConditionType = AnsiChar;
  TThostFtdcOrderTypeType = AnsiChar;
  TThostFtdcOrderStatusType = AnsiChar;
  TThostFtdcOrderSourceType = AnsiChar;
  TThostFtdcActionFlagType = AnsiChar;       
  TThostFtdcForceCloseReasonType = AnsiChar;
  TThostFtdcOrderSubmitStatusType = AnsiChar;
  TThostFtdcTradingRoleType = AnsiChar;      
  TThostFtdcOffsetFlagType = AnsiChar;
  TThostFtdcTradeTypeType = AnsiChar;
  TThostFtdcPriceSourceType = AnsiChar;
  TThostFtdcTradeSourceType = AnsiChar;
                                        
  TThostFtdcCombOffsetFlagType = array[0..4] of AnsiChar;    
  TThostFtdcCombHedgeFlagType = array[0..4] of AnsiChar;    
  TThostFtdcTradeIDType = array[0..20] of AnsiChar;
  TThostFtdcProductInfoType = array[0..10] of AnsiChar;
  TThostFtdcParticipantIDType = array[0..10] of AnsiChar;
  TThostFtdcOrderLocalIDType = array[0..12] of AnsiChar;
  TThostFtdcClientIDType = array[0..10] of AnsiChar;
  TThostFtdcTraderIDType = array[0..20] of AnsiChar;

  TThostFtdcOrderSysIDType = array[0..20] of AnsiChar;
  TThostFtdcBusinessUnitType = array[0..20] of AnsiChar;

  
///资金账户
  PhostFtdcTradingAccountField = ^ThostFtdcTradingAccountField;
  ThostFtdcTradingAccountField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者帐号
    AccountID: TThostFtdcAccountIDType;
    ///上次质押金额
    PreMortgage: TThostFtdcMoneyType;
    ///上次信用额度
    PreCredit: TThostFtdcMoneyType;
    ///上次存款额
    PreDeposit: TThostFtdcMoneyType;
    ///上次结算准备金
    PreBalance: TThostFtdcMoneyType;
    ///上次占用的保证金
    PreMargin: TThostFtdcMoneyType;
    ///利息基数
    InterestBase: TThostFtdcMoneyType;
    ///利息收入
    Interest: TThostFtdcMoneyType;
    ///入金金额
    Deposit: TThostFtdcMoneyType;
    ///出金金额
    Withdraw: TThostFtdcMoneyType;
    ///冻结的保证金
    FrozenMargin: TThostFtdcMoneyType;
    ///冻结的资金
    FrozenCash: TThostFtdcMoneyType;
    ///冻结的手续费
    FrozenCommission: TThostFtdcMoneyType;
    ///当前保证金总额
    CurrMargin: TThostFtdcMoneyType;
    ///资金差额
    CashIn: TThostFtdcMoneyType;
    ///手续费
    Commission: TThostFtdcMoneyType;
    ///平仓盈亏
    CloseProfit: TThostFtdcMoneyType;
    ///持仓盈亏
    PositionProfit: TThostFtdcMoneyType;
    ///期货结算准备金
    Balance: TThostFtdcMoneyType;
    ///可用资金
    Available: TThostFtdcMoneyType;
    ///可取资金
    WithdrawQuota: TThostFtdcMoneyType;
    ///基本准备金
    Reserve: TThostFtdcMoneyType;
    ///交易日
    TradingDay: TThostFtdcDateType;
    ///结算编号
    SettlementID: TThostFtdcSettlementIDType;
    ///信用额度
    Credit: TThostFtdcMoneyType;
    ///质押金额
    Mortgage: TThostFtdcMoneyType;
    ///交易所保证金
    ExchangeMargin: TThostFtdcMoneyType;
    ///投资者交割保证金
    DeliveryMargin: TThostFtdcMoneyType;
    ///交易所交割保证金
    ExchangeDeliveryMargin: TThostFtdcMoneyType;
    ///保底期货结算准备金
    ReserveBalance: TThostFtdcMoneyType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///上次货币质入金额
    PreFundMortgageIn: TThostFtdcMoneyType;
    ///上次货币质出金额
    PreFundMortgageOut: TThostFtdcMoneyType;
    ///货币质入金额
    FundMortgageIn: TThostFtdcMoneyType;
    ///货币质出金额
    FundMortgageOut: TThostFtdcMoneyType;
    ///货币质押余额
    FundMortgageAvailable: TThostFtdcMoneyType;
    ///可质押货币金额
    MortgageableFund: TThostFtdcMoneyType;
    ///特殊产品占用保证金
    SpecProductMargin: TThostFtdcMoneyType;
    ///特殊产品冻结保证金
    SpecProductFrozenMargin: TThostFtdcMoneyType;
    ///特殊产品手续费
    SpecProductCommission: TThostFtdcMoneyType;
    ///特殊产品冻结手续费
    SpecProductFrozenCommission: TThostFtdcMoneyType;
    ///特殊产品持仓盈亏
    SpecProductPositionProfit: TThostFtdcMoneyType;
    ///特殊产品平仓盈亏
    SpecProductCloseProfit: TThostFtdcMoneyType;
    ///根据持仓盈亏算法计算的特殊产品持仓盈亏
    SpecProductPositionProfitByAlg: TThostFtdcMoneyType;
    ///特殊产品交易所保证金
    SpecProductExchangeMargin: TThostFtdcMoneyType;
  end;

///投资者持仓
  PhostFtdcInvestorPositionField =^ThostFtdcInvestorPositionField;
  ThostFtdcInvestorPositionField = record
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者代码
    InvestorID: TThostFtdcInvestorIDType;
    ///持仓多空方向
    PosiDirection: TThostFtdcPosiDirectionType;
    ///投机套保标志
    HedgeFlag: TThostFtdcHedgeFlagType;
    ///持仓日期
    PositionDate: TThostFtdcPositionDateType;
    ///上日持仓
    YdPosition: TThostFtdcVolumeType;
    ///今日持仓
    Position: TThostFtdcVolumeType;
    ///多头冻结
    LongFrozen: TThostFtdcVolumeType;
    ///空头冻结
    ShortFrozen: TThostFtdcVolumeType;
    ///开仓冻结金额
    LongFrozenAmount: TThostFtdcMoneyType;
    ///开仓冻结金额
    ShortFrozenAmount: TThostFtdcMoneyType;
    ///开仓量
    OpenVolume: TThostFtdcVolumeType;
    ///平仓量
    CloseVolume: TThostFtdcVolumeType;
    ///开仓金额
    OpenAmount: TThostFtdcMoneyType;
    ///平仓金额
    CloseAmount: TThostFtdcMoneyType;
    ///持仓成本
    PositionCost: TThostFtdcMoneyType;
    ///上次占用的保证金
    PreMargin: TThostFtdcMoneyType;
    ///占用的保证金
    UseMargin: TThostFtdcMoneyType;
    ///冻结的保证金
    FrozenMargin: TThostFtdcMoneyType;
    ///冻结的资金
    FrozenCash: TThostFtdcMoneyType;
    ///冻结的手续费
    FrozenCommission: TThostFtdcMoneyType;
    ///资金差额
    CashIn: TThostFtdcMoneyType;
    ///手续费
    Commission: TThostFtdcMoneyType;
    ///平仓盈亏
    CloseProfit: TThostFtdcMoneyType;
    ///持仓盈亏
    PositionProfit: TThostFtdcMoneyType;
    ///上次结算价
    PreSettlementPrice: TThostFtdcPriceType;
    ///本次结算价
    SettlementPrice: TThostFtdcPriceType;
    ///交易日
    TradingDay: TThostFtdcDateType;
    ///结算编号
    SettlementID: TThostFtdcSettlementIDType;
    ///开仓成本
    OpenCost: TThostFtdcMoneyType;
    ///交易所保证金
    ExchangeMargin: TThostFtdcMoneyType;
    ///组合成交形成的持仓
    CombPosition: TThostFtdcVolumeType;
    ///组合多头冻结
    CombLongFrozen: TThostFtdcVolumeType;
    ///组合空头冻结
    CombShortFrozen: TThostFtdcVolumeType;
    ///逐日盯市平仓盈亏
    CloseProfitByDate: TThostFtdcMoneyType;
    ///逐笔对冲平仓盈亏
    CloseProfitByTrade: TThostFtdcMoneyType;
    ///今日持仓
    TodayPosition: TThostFtdcVolumeType;
    ///保证金率
    MarginRateByMoney: TThostFtdcRatioType;
    ///保证金率(按手数)
    MarginRateByVolume: TThostFtdcRatioType;
    ///执行冻结
    StrikeFrozen: TThostFtdcVolumeType;
    ///执行冻结金额
    StrikeFrozenAmount: TThostFtdcMoneyType;
    ///放弃执行冻结
    AbandonFrozen: TThostFtdcVolumeType;
  end;
        
///投资者结算结果确认信息
  PhostFtdcSettlementInfoConfirmField = ^ThostFtdcSettlementInfoConfirmField;
  ThostFtdcSettlementInfoConfirmField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者代码
    InvestorID: TThostFtdcInvestorIDType;
    ///确认日期
    ConfirmDate: TThostFtdcDateType;
    ///确认时间
    ConfirmTime: TThostFtdcTimeType;
  end;
           
///输入报单
  PhostFtdcInputOrderField = ^ThostFtdcInputOrderField;
  ThostFtdcInputOrderField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者代码
    InvestorID: TThostFtdcInvestorIDType;
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
    ///报单引用
    OrderRef: TThostFtdcOrderRefType;
    ///用户代码
    UserID: TThostFtdcUserIDType;
    ///报单价格条件
    OrderPriceType: TThostFtdcOrderPriceTypeType;
    ///买卖方向
    Direction: TThostFtdcDirectionType;
    ///组合开平标志
    CombOffsetFlag: TThostFtdcCombOffsetFlagType;
    ///组合投机套保标志
    CombHedgeFlag: TThostFtdcCombHedgeFlagType;
    ///价格
    LimitPrice: TThostFtdcPriceType;
    ///数量
    VolumeTotalOriginal: TThostFtdcVolumeType;
    ///有效期类型
    TimeCondition: TThostFtdcTimeConditionType;
    ///GTD日期
    GTDDate: TThostFtdcDateType;
    ///成交量类型
    VolumeCondition: TThostFtdcVolumeConditionType;
    ///最小成交量
    MinVolume: TThostFtdcVolumeType;
    ///触发条件
    ContingentCondition: TThostFtdcContingentConditionType;
    ///止损价
    StopPrice: TThostFtdcPriceType;
    ///强平原因
    ForceCloseReason: TThostFtdcForceCloseReasonType;
    ///自动挂起标志
    IsAutoSuspend: TThostFtdcBoolType;
    ///业务单元
    BusinessUnit: TThostFtdcBusinessUnitType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///用户强评标志
    UserForceClose: TThostFtdcBoolType;
    ///互换单标志
    IsSwapOrder: TThostFtdcBoolType;
  end;
             
///输入报单操作
  PhostFtdcInputOrderActionField = ^ThostFtdcInputOrderActionField;
  ThostFtdcInputOrderActionField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者代码
    InvestorID: TThostFtdcInvestorIDType;
    ///报单操作引用
    OrderActionRef: TThostFtdcOrderActionRefType;
    ///报单引用
    OrderRef: TThostFtdcOrderRefType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///前置编号
    FrontID: TThostFtdcFrontIDType;
    ///会话编号
    SessionID: TThostFtdcSessionIDType;
    ///交易所代码
    ExchangeID: TThostFtdcExchangeIDType;
    ///报单编号
    OrderSysID: TThostFtdcOrderSysIDType;
    ///操作标志
    ActionFlag: TThostFtdcActionFlagType;
    ///价格
    LimitPrice: TThostFtdcPriceType;
    ///数量变化
    VolumeChange: TThostFtdcVolumeType;
    ///用户代码
    UserID: TThostFtdcUserIDType;
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
  end;


///报单
  PhostFtdcOrderField = ^ThostFtdcOrderField;
  ThostFtdcOrderField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者代码
    InvestorID: TThostFtdcInvestorIDType;
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
    ///报单引用
    OrderRef: TThostFtdcOrderRefType;
    ///用户代码
    UserID: TThostFtdcUserIDType;
    ///报单价格条件
    OrderPriceType: TThostFtdcOrderPriceTypeType;
    ///买卖方向
    Direction: TThostFtdcDirectionType;
    ///组合开平标志
    CombOffsetFlag: TThostFtdcCombOffsetFlagType;
    ///组合投机套保标志
    CombHedgeFlag: TThostFtdcCombHedgeFlagType;
    ///价格
    LimitPrice: TThostFtdcPriceType;
    ///数量
    VolumeTotalOriginal: TThostFtdcVolumeType;
    ///有效期类型
    TimeCondition: TThostFtdcTimeConditionType;
    ///GTD日期
    GTDDate: TThostFtdcDateType;
    ///成交量类型
    VolumeCondition: TThostFtdcVolumeConditionType;
    ///最小成交量
    MinVolume: TThostFtdcVolumeType;
    ///触发条件
    ContingentCondition: TThostFtdcContingentConditionType;
    ///止损价
    StopPrice: TThostFtdcPriceType;
    ///强平原因
    ForceCloseReason: TThostFtdcForceCloseReasonType;
    ///自动挂起标志
    IsAutoSuspend: TThostFtdcBoolType;
    ///业务单元
    BusinessUnit: TThostFtdcBusinessUnitType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///本地报单编号
    OrderLocalID: TThostFtdcOrderLocalIDType;
    ///交易所代码
    ExchangeID: TThostFtdcExchangeIDType;
    ///会员代码
    ParticipantID: TThostFtdcParticipantIDType;
    ///客户代码
    ClientID: TThostFtdcClientIDType;
    ///合约在交易所的代码
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///交易所交易员代码
    TraderID: TThostFtdcTraderIDType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///报单提交状态
    OrderSubmitStatus: TThostFtdcOrderSubmitStatusType;
    ///报单提示序号
    NotifySequence: TThostFtdcSequenceNoType;
    ///交易日
    TradingDay: TThostFtdcDateType;
    ///结算编号
    SettlementID: TThostFtdcSettlementIDType;
    ///报单编号
    OrderSysID: TThostFtdcOrderSysIDType;
    ///报单来源
    OrderSource: TThostFtdcOrderSourceType;
    ///报单状态
    OrderStatus: TThostFtdcOrderStatusType;
    ///报单类型
    OrderType: TThostFtdcOrderTypeType;
    ///今成交数量
    VolumeTraded: TThostFtdcVolumeType;
    ///剩余数量
    VolumeTotal: TThostFtdcVolumeType;
    ///报单日期
    InsertDate: TThostFtdcDateType;
    ///委托时间
    InsertTime: TThostFtdcTimeType;
    ///激活时间
    ActiveTime: TThostFtdcTimeType;
    ///挂起时间
    SuspendTime: TThostFtdcTimeType;
    ///最后修改时间
    UpdateTime: TThostFtdcTimeType;
    ///撤销时间
    CancelTime: TThostFtdcTimeType;
    ///最后修改交易所交易员代码
    ActiveTraderID: TThostFtdcTraderIDType;
    ///结算会员编号
    ClearingPartID: TThostFtdcParticipantIDType;
    ///序号
    SequenceNo: TThostFtdcSequenceNoType;
    ///前置编号
    FrontID: TThostFtdcFrontIDType;
    ///会话编号
    SessionID: TThostFtdcSessionIDType;
    ///用户端产品信息
    UserProductInfo: TThostFtdcProductInfoType;
    ///状态信息
    StatusMsg: TThostFtdcErrorMsgType;
    ///用户强评标志
    UserForceClose: TThostFtdcBoolType;
    ///操作用户代码
    ActiveUserID: TThostFtdcUserIDType;
    ///经纪公司报单编号
    BrokerOrderSeq: TThostFtdcSequenceNoType;
    ///相关报单
    RelativeOrderSysID: TThostFtdcOrderSysIDType;
    ///郑商所成交数量
    ZCETotalTradedVolume: TThostFtdcVolumeType;
    ///互换单标志
    IsSwapOrder: TThostFtdcBoolType;
  end;
                  
///成交
  PhostFtdcTradeField = ^ThostFtdcTradeField;
  ThostFtdcTradeField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///投资者代码
    InvestorID: TThostFtdcInvestorIDType;
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
    ///报单引用
    OrderRef: TThostFtdcOrderRefType;
    ///用户代码
    UserID: TThostFtdcUserIDType;
    ///交易所代码
    ExchangeID: TThostFtdcExchangeIDType;
    ///成交编号
    TradeID: TThostFtdcTradeIDType;
    ///买卖方向
    Direction: TThostFtdcDirectionType;
    ///报单编号
    OrderSysID: TThostFtdcOrderSysIDType;
    ///会员代码
    ParticipantID: TThostFtdcParticipantIDType;
    ///客户代码
    ClientID: TThostFtdcClientIDType;
    ///交易角色
    TradingRole: TThostFtdcTradingRoleType;
    ///合约在交易所的代码
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///开平标志
    OffsetFlag: TThostFtdcOffsetFlagType;
    ///投机套保标志
    HedgeFlag: TThostFtdcHedgeFlagType;
    ///价格
    Price: TThostFtdcPriceType;
    ///数量
    Volume: TThostFtdcVolumeType;
    ///成交时期
    TradeDate: TThostFtdcDateType;
    ///成交时间
    TradeTime: TThostFtdcTimeType;
    ///成交类型
    TradeType: TThostFtdcTradeTypeType;
    ///成交价来源
    PriceSource: TThostFtdcPriceSourceType;
    ///交易所交易员代码
    TraderID: TThostFtdcTraderIDType;
    ///本地报单编号
    OrderLocalID: TThostFtdcOrderLocalIDType;
    ///结算会员编号
    ClearingPartID: TThostFtdcParticipantIDType;
    ///业务单元
    BusinessUnit: TThostFtdcBusinessUnitType;
    ///序号
    SequenceNo: TThostFtdcSequenceNoType;
    ///交易日
    TradingDay: TThostFtdcDateType;
    ///结算编号
    SettlementID: TThostFtdcSettlementIDType;
    ///经纪公司报单编号
    BrokerOrderSeq: TThostFtdcSequenceNoType;
    ///成交来源
    TradeSource: TThostFtdcTradeSourceType;
  end;
           
///合约
  PhostFtdcInstrumentField = ^ThostFtdcInstrumentField;
  ThostFtdcInstrumentField = record
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
    ///交易所代码
    ExchangeID: TThostFtdcExchangeIDType;
    ///合约名称
    InstrumentName: TThostFtdcInstrumentNameType;
    ///合约在交易所的代码
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///产品代码
    ProductID: TThostFtdcInstrumentIDType;
    ///产品类型
    ProductClass: TThostFtdcProductClassType;
    ///交割年份
    DeliveryYear: TThostFtdcYearType;
    ///交割月
    DeliveryMonth: TThostFtdcMonthType;
    ///市价单最大下单量
    MaxMarketOrderVolume: TThostFtdcVolumeType;
    ///市价单最小下单量
    MinMarketOrderVolume: TThostFtdcVolumeType;
    ///限价单最大下单量
    MaxLimitOrderVolume: TThostFtdcVolumeType;
    ///限价单最小下单量
    MinLimitOrderVolume: TThostFtdcVolumeType;
    ///合约数量乘数
    VolumeMultiple: TThostFtdcVolumeMultipleType;
    ///最小变动价位
    PriceTick: TThostFtdcPriceType;
    ///创建日
    CreateDate: TThostFtdcDateType;
    ///上市日
    OpenDate: TThostFtdcDateType;
    ///到期日
    ExpireDate: TThostFtdcDateType;
    ///开始交割日
    StartDelivDate: TThostFtdcDateType;
    ///结束交割日
    EndDelivDate: TThostFtdcDateType;
    ///合约生命周期状态
    InstLifePhase: TThostFtdcInstLifePhaseType;
    ///当前是否交易
    IsTrading: TThostFtdcBoolType;
    ///持仓类型
    PositionType: TThostFtdcPositionTypeType;
    ///持仓日期类型
    PositionDateType: TThostFtdcPositionDateTypeType;
    ///多头保证金率
    LongMarginRatio: TThostFtdcRatioType;
    ///空头保证金率
    ShortMarginRatio: TThostFtdcRatioType;
    ///是否使用大额单边保证金算法
    MaxMarginSideAlgorithm: TThostFtdcMaxMarginSideAlgorithmType;
    ///基础商品代码
    UnderlyingInstrID: TThostFtdcInstrumentIDType;
    ///执行价
    StrikePrice: TThostFtdcPriceType;
    ///期权类型
    OptionsType: TThostFtdcOptionsTypeType;
    ///合约基础商品乘数
    UnderlyingMultiple: TThostFtdcUnderlyingMultipleType;
    ///组合类型
    CombinationType: TThostFtdcCombinationTypeType;
  end;

implementation

end.
