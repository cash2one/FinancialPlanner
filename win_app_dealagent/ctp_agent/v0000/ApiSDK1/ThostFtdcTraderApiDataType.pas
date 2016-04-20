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

  
///�ʽ��˻�
  PhostFtdcTradingAccountField = ^ThostFtdcTradingAccountField;
  ThostFtdcTradingAccountField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ�����ʺ�
    AccountID: TThostFtdcAccountIDType;
    ///�ϴ���Ѻ���
    PreMortgage: TThostFtdcMoneyType;
    ///�ϴ����ö��
    PreCredit: TThostFtdcMoneyType;
    ///�ϴδ���
    PreDeposit: TThostFtdcMoneyType;
    ///�ϴν���׼����
    PreBalance: TThostFtdcMoneyType;
    ///�ϴ�ռ�õı�֤��
    PreMargin: TThostFtdcMoneyType;
    ///��Ϣ����
    InterestBase: TThostFtdcMoneyType;
    ///��Ϣ����
    Interest: TThostFtdcMoneyType;
    ///�����
    Deposit: TThostFtdcMoneyType;
    ///������
    Withdraw: TThostFtdcMoneyType;
    ///����ı�֤��
    FrozenMargin: TThostFtdcMoneyType;
    ///������ʽ�
    FrozenCash: TThostFtdcMoneyType;
    ///�����������
    FrozenCommission: TThostFtdcMoneyType;
    ///��ǰ��֤���ܶ�
    CurrMargin: TThostFtdcMoneyType;
    ///�ʽ���
    CashIn: TThostFtdcMoneyType;
    ///������
    Commission: TThostFtdcMoneyType;
    ///ƽ��ӯ��
    CloseProfit: TThostFtdcMoneyType;
    ///�ֲ�ӯ��
    PositionProfit: TThostFtdcMoneyType;
    ///�ڻ�����׼����
    Balance: TThostFtdcMoneyType;
    ///�����ʽ�
    Available: TThostFtdcMoneyType;
    ///��ȡ�ʽ�
    WithdrawQuota: TThostFtdcMoneyType;
    ///����׼����
    Reserve: TThostFtdcMoneyType;
    ///������
    TradingDay: TThostFtdcDateType;
    ///������
    SettlementID: TThostFtdcSettlementIDType;
    ///���ö��
    Credit: TThostFtdcMoneyType;
    ///��Ѻ���
    Mortgage: TThostFtdcMoneyType;
    ///��������֤��
    ExchangeMargin: TThostFtdcMoneyType;
    ///Ͷ���߽��֤��
    DeliveryMargin: TThostFtdcMoneyType;
    ///���������֤��
    ExchangeDeliveryMargin: TThostFtdcMoneyType;
    ///�����ڻ�����׼����
    ReserveBalance: TThostFtdcMoneyType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///�ϴλ���������
    PreFundMortgageIn: TThostFtdcMoneyType;
    ///�ϴλ����ʳ����
    PreFundMortgageOut: TThostFtdcMoneyType;
    ///����������
    FundMortgageIn: TThostFtdcMoneyType;
    ///�����ʳ����
    FundMortgageOut: TThostFtdcMoneyType;
    ///������Ѻ���
    FundMortgageAvailable: TThostFtdcMoneyType;
    ///����Ѻ���ҽ��
    MortgageableFund: TThostFtdcMoneyType;
    ///�����Ʒռ�ñ�֤��
    SpecProductMargin: TThostFtdcMoneyType;
    ///�����Ʒ���ᱣ֤��
    SpecProductFrozenMargin: TThostFtdcMoneyType;
    ///�����Ʒ������
    SpecProductCommission: TThostFtdcMoneyType;
    ///�����Ʒ����������
    SpecProductFrozenCommission: TThostFtdcMoneyType;
    ///�����Ʒ�ֲ�ӯ��
    SpecProductPositionProfit: TThostFtdcMoneyType;
    ///�����Ʒƽ��ӯ��
    SpecProductCloseProfit: TThostFtdcMoneyType;
    ///���ݳֲ�ӯ���㷨����������Ʒ�ֲ�ӯ��
    SpecProductPositionProfitByAlg: TThostFtdcMoneyType;
    ///�����Ʒ��������֤��
    SpecProductExchangeMargin: TThostFtdcMoneyType;
  end;

///Ͷ���ֲ߳�
  PhostFtdcInvestorPositionField =^ThostFtdcInvestorPositionField;
  ThostFtdcInvestorPositionField = record
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ���ߴ���
    InvestorID: TThostFtdcInvestorIDType;
    ///�ֲֶ�շ���
    PosiDirection: TThostFtdcPosiDirectionType;
    ///Ͷ���ױ���־
    HedgeFlag: TThostFtdcHedgeFlagType;
    ///�ֲ�����
    PositionDate: TThostFtdcPositionDateType;
    ///���ճֲ�
    YdPosition: TThostFtdcVolumeType;
    ///���ճֲ�
    Position: TThostFtdcVolumeType;
    ///��ͷ����
    LongFrozen: TThostFtdcVolumeType;
    ///��ͷ����
    ShortFrozen: TThostFtdcVolumeType;
    ///���ֶ�����
    LongFrozenAmount: TThostFtdcMoneyType;
    ///���ֶ�����
    ShortFrozenAmount: TThostFtdcMoneyType;
    ///������
    OpenVolume: TThostFtdcVolumeType;
    ///ƽ����
    CloseVolume: TThostFtdcVolumeType;
    ///���ֽ��
    OpenAmount: TThostFtdcMoneyType;
    ///ƽ�ֽ��
    CloseAmount: TThostFtdcMoneyType;
    ///�ֲֳɱ�
    PositionCost: TThostFtdcMoneyType;
    ///�ϴ�ռ�õı�֤��
    PreMargin: TThostFtdcMoneyType;
    ///ռ�õı�֤��
    UseMargin: TThostFtdcMoneyType;
    ///����ı�֤��
    FrozenMargin: TThostFtdcMoneyType;
    ///������ʽ�
    FrozenCash: TThostFtdcMoneyType;
    ///�����������
    FrozenCommission: TThostFtdcMoneyType;
    ///�ʽ���
    CashIn: TThostFtdcMoneyType;
    ///������
    Commission: TThostFtdcMoneyType;
    ///ƽ��ӯ��
    CloseProfit: TThostFtdcMoneyType;
    ///�ֲ�ӯ��
    PositionProfit: TThostFtdcMoneyType;
    ///�ϴν����
    PreSettlementPrice: TThostFtdcPriceType;
    ///���ν����
    SettlementPrice: TThostFtdcPriceType;
    ///������
    TradingDay: TThostFtdcDateType;
    ///������
    SettlementID: TThostFtdcSettlementIDType;
    ///���ֳɱ�
    OpenCost: TThostFtdcMoneyType;
    ///��������֤��
    ExchangeMargin: TThostFtdcMoneyType;
    ///��ϳɽ��γɵĳֲ�
    CombPosition: TThostFtdcVolumeType;
    ///��϶�ͷ����
    CombLongFrozen: TThostFtdcVolumeType;
    ///��Ͽ�ͷ����
    CombShortFrozen: TThostFtdcVolumeType;
    ///���ն���ƽ��ӯ��
    CloseProfitByDate: TThostFtdcMoneyType;
    ///��ʶԳ�ƽ��ӯ��
    CloseProfitByTrade: TThostFtdcMoneyType;
    ///���ճֲ�
    TodayPosition: TThostFtdcVolumeType;
    ///��֤����
    MarginRateByMoney: TThostFtdcRatioType;
    ///��֤����(������)
    MarginRateByVolume: TThostFtdcRatioType;
    ///ִ�ж���
    StrikeFrozen: TThostFtdcVolumeType;
    ///ִ�ж�����
    StrikeFrozenAmount: TThostFtdcMoneyType;
    ///����ִ�ж���
    AbandonFrozen: TThostFtdcVolumeType;
  end;
        
///Ͷ���߽�����ȷ����Ϣ
  PhostFtdcSettlementInfoConfirmField = ^ThostFtdcSettlementInfoConfirmField;
  ThostFtdcSettlementInfoConfirmField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ���ߴ���
    InvestorID: TThostFtdcInvestorIDType;
    ///ȷ������
    ConfirmDate: TThostFtdcDateType;
    ///ȷ��ʱ��
    ConfirmTime: TThostFtdcTimeType;
  end;
           
///���뱨��
  PhostFtdcInputOrderField = ^ThostFtdcInputOrderField;
  ThostFtdcInputOrderField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ���ߴ���
    InvestorID: TThostFtdcInvestorIDType;
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
    ///��������
    OrderRef: TThostFtdcOrderRefType;
    ///�û�����
    UserID: TThostFtdcUserIDType;
    ///�����۸�����
    OrderPriceType: TThostFtdcOrderPriceTypeType;
    ///��������
    Direction: TThostFtdcDirectionType;
    ///��Ͽ�ƽ��־
    CombOffsetFlag: TThostFtdcCombOffsetFlagType;
    ///���Ͷ���ױ���־
    CombHedgeFlag: TThostFtdcCombHedgeFlagType;
    ///�۸�
    LimitPrice: TThostFtdcPriceType;
    ///����
    VolumeTotalOriginal: TThostFtdcVolumeType;
    ///��Ч������
    TimeCondition: TThostFtdcTimeConditionType;
    ///GTD����
    GTDDate: TThostFtdcDateType;
    ///�ɽ�������
    VolumeCondition: TThostFtdcVolumeConditionType;
    ///��С�ɽ���
    MinVolume: TThostFtdcVolumeType;
    ///��������
    ContingentCondition: TThostFtdcContingentConditionType;
    ///ֹ���
    StopPrice: TThostFtdcPriceType;
    ///ǿƽԭ��
    ForceCloseReason: TThostFtdcForceCloseReasonType;
    ///�Զ������־
    IsAutoSuspend: TThostFtdcBoolType;
    ///ҵ��Ԫ
    BusinessUnit: TThostFtdcBusinessUnitType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///�û�ǿ����־
    UserForceClose: TThostFtdcBoolType;
    ///��������־
    IsSwapOrder: TThostFtdcBoolType;
  end;
             
///���뱨������
  PhostFtdcInputOrderActionField = ^ThostFtdcInputOrderActionField;
  ThostFtdcInputOrderActionField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ���ߴ���
    InvestorID: TThostFtdcInvestorIDType;
    ///������������
    OrderActionRef: TThostFtdcOrderActionRefType;
    ///��������
    OrderRef: TThostFtdcOrderRefType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///ǰ�ñ��
    FrontID: TThostFtdcFrontIDType;
    ///�Ự���
    SessionID: TThostFtdcSessionIDType;
    ///����������
    ExchangeID: TThostFtdcExchangeIDType;
    ///�������
    OrderSysID: TThostFtdcOrderSysIDType;
    ///������־
    ActionFlag: TThostFtdcActionFlagType;
    ///�۸�
    LimitPrice: TThostFtdcPriceType;
    ///�����仯
    VolumeChange: TThostFtdcVolumeType;
    ///�û�����
    UserID: TThostFtdcUserIDType;
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
  end;


///����
  PhostFtdcOrderField = ^ThostFtdcOrderField;
  ThostFtdcOrderField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ���ߴ���
    InvestorID: TThostFtdcInvestorIDType;
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
    ///��������
    OrderRef: TThostFtdcOrderRefType;
    ///�û�����
    UserID: TThostFtdcUserIDType;
    ///�����۸�����
    OrderPriceType: TThostFtdcOrderPriceTypeType;
    ///��������
    Direction: TThostFtdcDirectionType;
    ///��Ͽ�ƽ��־
    CombOffsetFlag: TThostFtdcCombOffsetFlagType;
    ///���Ͷ���ױ���־
    CombHedgeFlag: TThostFtdcCombHedgeFlagType;
    ///�۸�
    LimitPrice: TThostFtdcPriceType;
    ///����
    VolumeTotalOriginal: TThostFtdcVolumeType;
    ///��Ч������
    TimeCondition: TThostFtdcTimeConditionType;
    ///GTD����
    GTDDate: TThostFtdcDateType;
    ///�ɽ�������
    VolumeCondition: TThostFtdcVolumeConditionType;
    ///��С�ɽ���
    MinVolume: TThostFtdcVolumeType;
    ///��������
    ContingentCondition: TThostFtdcContingentConditionType;
    ///ֹ���
    StopPrice: TThostFtdcPriceType;
    ///ǿƽԭ��
    ForceCloseReason: TThostFtdcForceCloseReasonType;
    ///�Զ������־
    IsAutoSuspend: TThostFtdcBoolType;
    ///ҵ��Ԫ
    BusinessUnit: TThostFtdcBusinessUnitType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///���ر������
    OrderLocalID: TThostFtdcOrderLocalIDType;
    ///����������
    ExchangeID: TThostFtdcExchangeIDType;
    ///��Ա����
    ParticipantID: TThostFtdcParticipantIDType;
    ///�ͻ�����
    ClientID: TThostFtdcClientIDType;
    ///��Լ�ڽ������Ĵ���
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///����������Ա����
    TraderID: TThostFtdcTraderIDType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�����ύ״̬
    OrderSubmitStatus: TThostFtdcOrderSubmitStatusType;
    ///������ʾ���
    NotifySequence: TThostFtdcSequenceNoType;
    ///������
    TradingDay: TThostFtdcDateType;
    ///������
    SettlementID: TThostFtdcSettlementIDType;
    ///�������
    OrderSysID: TThostFtdcOrderSysIDType;
    ///������Դ
    OrderSource: TThostFtdcOrderSourceType;
    ///����״̬
    OrderStatus: TThostFtdcOrderStatusType;
    ///��������
    OrderType: TThostFtdcOrderTypeType;
    ///��ɽ�����
    VolumeTraded: TThostFtdcVolumeType;
    ///ʣ������
    VolumeTotal: TThostFtdcVolumeType;
    ///��������
    InsertDate: TThostFtdcDateType;
    ///ί��ʱ��
    InsertTime: TThostFtdcTimeType;
    ///����ʱ��
    ActiveTime: TThostFtdcTimeType;
    ///����ʱ��
    SuspendTime: TThostFtdcTimeType;
    ///����޸�ʱ��
    UpdateTime: TThostFtdcTimeType;
    ///����ʱ��
    CancelTime: TThostFtdcTimeType;
    ///����޸Ľ���������Ա����
    ActiveTraderID: TThostFtdcTraderIDType;
    ///�����Ա���
    ClearingPartID: TThostFtdcParticipantIDType;
    ///���
    SequenceNo: TThostFtdcSequenceNoType;
    ///ǰ�ñ��
    FrontID: TThostFtdcFrontIDType;
    ///�Ự���
    SessionID: TThostFtdcSessionIDType;
    ///�û��˲�Ʒ��Ϣ
    UserProductInfo: TThostFtdcProductInfoType;
    ///״̬��Ϣ
    StatusMsg: TThostFtdcErrorMsgType;
    ///�û�ǿ����־
    UserForceClose: TThostFtdcBoolType;
    ///�����û�����
    ActiveUserID: TThostFtdcUserIDType;
    ///���͹�˾�������
    BrokerOrderSeq: TThostFtdcSequenceNoType;
    ///��ر���
    RelativeOrderSysID: TThostFtdcOrderSysIDType;
    ///֣�����ɽ�����
    ZCETotalTradedVolume: TThostFtdcVolumeType;
    ///��������־
    IsSwapOrder: TThostFtdcBoolType;
  end;
                  
///�ɽ�
  PhostFtdcTradeField = ^ThostFtdcTradeField;
  ThostFtdcTradeField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///Ͷ���ߴ���
    InvestorID: TThostFtdcInvestorIDType;
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
    ///��������
    OrderRef: TThostFtdcOrderRefType;
    ///�û�����
    UserID: TThostFtdcUserIDType;
    ///����������
    ExchangeID: TThostFtdcExchangeIDType;
    ///�ɽ����
    TradeID: TThostFtdcTradeIDType;
    ///��������
    Direction: TThostFtdcDirectionType;
    ///�������
    OrderSysID: TThostFtdcOrderSysIDType;
    ///��Ա����
    ParticipantID: TThostFtdcParticipantIDType;
    ///�ͻ�����
    ClientID: TThostFtdcClientIDType;
    ///���׽�ɫ
    TradingRole: TThostFtdcTradingRoleType;
    ///��Լ�ڽ������Ĵ���
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///��ƽ��־
    OffsetFlag: TThostFtdcOffsetFlagType;
    ///Ͷ���ױ���־
    HedgeFlag: TThostFtdcHedgeFlagType;
    ///�۸�
    Price: TThostFtdcPriceType;
    ///����
    Volume: TThostFtdcVolumeType;
    ///�ɽ�ʱ��
    TradeDate: TThostFtdcDateType;
    ///�ɽ�ʱ��
    TradeTime: TThostFtdcTimeType;
    ///�ɽ�����
    TradeType: TThostFtdcTradeTypeType;
    ///�ɽ�����Դ
    PriceSource: TThostFtdcPriceSourceType;
    ///����������Ա����
    TraderID: TThostFtdcTraderIDType;
    ///���ر������
    OrderLocalID: TThostFtdcOrderLocalIDType;
    ///�����Ա���
    ClearingPartID: TThostFtdcParticipantIDType;
    ///ҵ��Ԫ
    BusinessUnit: TThostFtdcBusinessUnitType;
    ///���
    SequenceNo: TThostFtdcSequenceNoType;
    ///������
    TradingDay: TThostFtdcDateType;
    ///������
    SettlementID: TThostFtdcSettlementIDType;
    ///���͹�˾�������
    BrokerOrderSeq: TThostFtdcSequenceNoType;
    ///�ɽ���Դ
    TradeSource: TThostFtdcTradeSourceType;
  end;
           
///��Լ
  PhostFtdcInstrumentField = ^ThostFtdcInstrumentField;
  ThostFtdcInstrumentField = record
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
    ///����������
    ExchangeID: TThostFtdcExchangeIDType;
    ///��Լ����
    InstrumentName: TThostFtdcInstrumentNameType;
    ///��Լ�ڽ������Ĵ���
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///��Ʒ����
    ProductID: TThostFtdcInstrumentIDType;
    ///��Ʒ����
    ProductClass: TThostFtdcProductClassType;
    ///�������
    DeliveryYear: TThostFtdcYearType;
    ///������
    DeliveryMonth: TThostFtdcMonthType;
    ///�м۵�����µ���
    MaxMarketOrderVolume: TThostFtdcVolumeType;
    ///�м۵���С�µ���
    MinMarketOrderVolume: TThostFtdcVolumeType;
    ///�޼۵�����µ���
    MaxLimitOrderVolume: TThostFtdcVolumeType;
    ///�޼۵���С�µ���
    MinLimitOrderVolume: TThostFtdcVolumeType;
    ///��Լ��������
    VolumeMultiple: TThostFtdcVolumeMultipleType;
    ///��С�䶯��λ
    PriceTick: TThostFtdcPriceType;
    ///������
    CreateDate: TThostFtdcDateType;
    ///������
    OpenDate: TThostFtdcDateType;
    ///������
    ExpireDate: TThostFtdcDateType;
    ///��ʼ������
    StartDelivDate: TThostFtdcDateType;
    ///����������
    EndDelivDate: TThostFtdcDateType;
    ///��Լ��������״̬
    InstLifePhase: TThostFtdcInstLifePhaseType;
    ///��ǰ�Ƿ���
    IsTrading: TThostFtdcBoolType;
    ///�ֲ�����
    PositionType: TThostFtdcPositionTypeType;
    ///�ֲ���������
    PositionDateType: TThostFtdcPositionDateTypeType;
    ///��ͷ��֤����
    LongMarginRatio: TThostFtdcRatioType;
    ///��ͷ��֤����
    ShortMarginRatio: TThostFtdcRatioType;
    ///�Ƿ�ʹ�ô��߱�֤���㷨
    MaxMarginSideAlgorithm: TThostFtdcMaxMarginSideAlgorithmType;
    ///������Ʒ����
    UnderlyingInstrID: TThostFtdcInstrumentIDType;
    ///ִ�м�
    StrikePrice: TThostFtdcPriceType;
    ///��Ȩ����
    OptionsType: TThostFtdcOptionsTypeType;
    ///��Լ������Ʒ����
    UnderlyingMultiple: TThostFtdcUnderlyingMultipleType;
    ///�������
    CombinationType: TThostFtdcCombinationTypeType;
  end;

implementation

end.
