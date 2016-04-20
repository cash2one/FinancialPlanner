unit ThostFtdcTraderApiDataDefine;

interface

const
/////////////////////////////////////////////////////////////////////////
///TFtdcDirectionType��һ��������������
/////////////////////////////////////////////////////////////////////////
///��
  THOST_FTDC_D_Buy = '0';
///��
  THOST_FTDC_D_Sell = '1';
  
/////////////////////////////////////////////////////////////////////////
///TFtdcOffsetFlagType��һ����ƽ��־����
/////////////////////////////////////////////////////////////////////////
///����
  THOST_FTDC_OF_Open = '0';
///ƽ��
  THOST_FTDC_OF_Close = '1';
///ǿƽ
  THOST_FTDC_OF_ForceClose = '2';
///ƽ��
  THOST_FTDC_OF_CloseToday = '3';
///ƽ��
  THOST_FTDC_OF_CloseYesterday = '4';
///ǿ��
  THOST_FTDC_OF_ForceOff = '5';
///����ǿƽ
  THOST_FTDC_OF_LocalForceClose = '6';

//typedef char TThostFtdcOffsetFlagType;
             
/////////////////////////////////////////////////////////////////////////
///TFtdcHedgeFlagType��һ��Ͷ���ױ���־����
/////////////////////////////////////////////////////////////////////////
///Ͷ��
  THOST_FTDC_HF_Speculation = '1';
///����
  THOST_FTDC_HF_Arbitrage = '2';
///�ױ�
  THOST_FTDC_HF_Hedge = '3';


/////////////////////////////////////////////////////////////////////////
///TFtdcOrderStatusType��һ������״̬����
/////////////////////////////////////////////////////////////////////////
/// �ɽ�˳��  a --> 3 --> 3 --> 0
///ȫ���ɽ�
  THOST_FTDC_OST_AllTraded = '0';
///���ֳɽ����ڶ�����
  THOST_FTDC_OST_PartTradedQueueing = '1';
///���ֳɽ����ڶ�����
  THOST_FTDC_OST_PartTradedNotQueueing = '2';
///δ�ɽ����ڶ�����
  THOST_FTDC_OST_NoTradeQueueing = '3';
///δ�ɽ����ڶ�����
  THOST_FTDC_OST_NoTradeNotQueueing = '4';
///����
  THOST_FTDC_OST_Canceled = '5';
///δ֪
  THOST_FTDC_OST_Unknown = 'a';
///��δ����
  THOST_FTDC_OST_NotTouched = 'b';
///�Ѵ���
  THOST_FTDC_OST_Touched = 'c';

/////////////////////////////////////////////////////////////////////////
///TFtdcTimeConditionType��һ����Ч����������
/////////////////////////////////////////////////////////////////////////
///������ɣ�������
  THOST_FTDC_TC_IOC = '1';
///������Ч
  THOST_FTDC_TC_GFS = '2';
///������Ч
  THOST_FTDC_TC_GFD = '3';
///ָ������ǰ��Ч
  THOST_FTDC_TC_GTD = '4';
///����ǰ��Ч
  THOST_FTDC_TC_GTC = '5';
///���Ͼ�����Ч
  THOST_FTDC_TC_GFA = '6';
  

/////////////////////////////////////////////////////////////////////////
///TFtdcOrderPriceTypeType��һ�������۸���������
/////////////////////////////////////////////////////////////////////////
///�����
  THOST_FTDC_OPT_AnyPrice = '1';
///�޼�
  THOST_FTDC_OPT_LimitPrice = '2';
///���ż�
  THOST_FTDC_OPT_BestPrice = '3';
///���¼�
  THOST_FTDC_OPT_LastPrice = '4';
///���¼۸����ϸ�1��ticks
  THOST_FTDC_OPT_LastPricePlusOneTicks = '5';
///���¼۸����ϸ�2��ticks
  THOST_FTDC_OPT_LastPricePlusTwoTicks = '6';
///���¼۸����ϸ�3��ticks
  THOST_FTDC_OPT_LastPricePlusThreeTicks = '7';
///��һ��
  THOST_FTDC_OPT_AskPrice1 = '8';
///��һ�۸����ϸ�1��ticks
  THOST_FTDC_OPT_AskPrice1PlusOneTicks = '9';
///��һ�۸����ϸ�2��ticks
  THOST_FTDC_OPT_AskPrice1PlusTwoTicks = 'A';
///��һ�۸����ϸ�3��ticks
  THOST_FTDC_OPT_AskPrice1PlusThreeTicks = 'B';
///��һ��
  THOST_FTDC_OPT_BidPrice1 = 'C';
///��һ�۸����ϸ�1��ticks
  THOST_FTDC_OPT_BidPrice1PlusOneTicks = 'D';
///��һ�۸����ϸ�2��ticks
  THOST_FTDC_OPT_BidPrice1PlusTwoTicks = 'E';
///��һ�۸����ϸ�3��ticks
  THOST_FTDC_OPT_BidPrice1PlusThreeTicks = 'F';
///�嵵��
  THOST_FTDC_OPT_FiveLevelPrice = 'G';


/////////////////////////////////////////////////////////////////////////
///TFtdcContingentConditionType��һ��������������
/////////////////////////////////////////////////////////////////////////
///����
  THOST_FTDC_CC_Immediately = '1';
///ֹ��
  THOST_FTDC_CC_Touch = '2';
///ֹӮ
  THOST_FTDC_CC_TouchProfit = '3';
///Ԥ��
  THOST_FTDC_CC_ParkedOrder = '4';
///���¼۴���������
  THOST_FTDC_CC_LastPriceGreaterThanStopPrice = '5';
///���¼۴��ڵ���������
  THOST_FTDC_CC_LastPriceGreaterEqualStopPrice = '6';
///���¼�С��������
  THOST_FTDC_CC_LastPriceLesserThanStopPrice = '7';
///���¼�С�ڵ���������
  THOST_FTDC_CC_LastPriceLesserEqualStopPrice = '8';
///��һ�۴���������
  THOST_FTDC_CC_AskPriceGreaterThanStopPrice = '9';
///��һ�۴��ڵ���������
  THOST_FTDC_CC_AskPriceGreaterEqualStopPrice = 'A';
///��һ��С��������
  THOST_FTDC_CC_AskPriceLesserThanStopPrice = 'B';
///��һ��С�ڵ���������
  THOST_FTDC_CC_AskPriceLesserEqualStopPrice = 'C';
///��һ�۴���������
  THOST_FTDC_CC_BidPriceGreaterThanStopPrice = 'D';
///��һ�۴��ڵ���������
  THOST_FTDC_CC_BidPriceGreaterEqualStopPrice = 'E';
///��һ��С��������
  THOST_FTDC_CC_BidPriceLesserThanStopPrice = 'F';
///��һ��С�ڵ���������
  THOST_FTDC_CC_BidPriceLesserEqualStopPrice = 'H';
             
/////////////////////////////////////////////////////////////////////////
///TFtdcVolumeConditionType��һ���ɽ�����������
/////////////////////////////////////////////////////////////////////////
///�κ�����
  THOST_FTDC_VC_AV = '1';
///��С����
  THOST_FTDC_VC_MV = '2';
///ȫ������
  THOST_FTDC_VC_CV = '3';
               
/////////////////////////////////////////////////////////////////////////
///TFtdcForceCloseReasonType��һ��ǿƽԭ������
/////////////////////////////////////////////////////////////////////////
///��ǿƽ
  THOST_FTDC_FCC_NotForceClose = '0';
///�ʽ���
  THOST_FTDC_FCC_LackDeposit = '1';
///�ͻ�����
  THOST_FTDC_FCC_ClientOverPositionLimit = '2';
///��Ա����
  THOST_FTDC_FCC_MemberOverPositionLimit = '3';
///�ֲַ�������
  THOST_FTDC_FCC_NotMultiple = '4';
///Υ��
  THOST_FTDC_FCC_Violation = '5';
///����
  THOST_FTDC_FCC_Other = '6';
///��Ȼ���ٽ�����
  THOST_FTDC_FCC_PersonDeliv = '7';

implementation

end.
