unit ThostFtdcMdApiDataType;

interface

uses
  ThostFtdcBaseDataType;
  
type                               
  TThostFtdcDirectionType = AnsiChar;
  
  TThostFtdcExchangeIDType = array[0..8] of AnsiChar;   
  TThostFtdcExchangeInstIDType = array[0..30] of AnsiChar;
  
  PhostFtdcDepthMarketDataField = ^ThostFtdcDepthMarketDataField;
  ThostFtdcDepthMarketDataField = packed record
    ///������
    TradingDay: TThostFtdcDateType;
    ///��Լ����
    InstrumentID: TThostFtdcInstrumentIDType;
    ///����������
    ExchangeID: TThostFtdcExchangeIDType	;
    ///��Լ�ڽ������Ĵ���
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///���¼�
    LastPrice: TThostFtdcPriceType;
    ///�ϴν����
    PreSettlementPrice: TThostFtdcPriceType	;
    ///������
    PreClosePrice: TThostFtdcPriceType;
    ///��ֲ���
    PreOpenInterest: TThostFtdcLargeVolumeType	;
    ///����
    OpenPrice: TThostFtdcPriceType	;
    ///��߼�
    HighestPrice: TThostFtdcPriceType	;
    ///��ͼ�
    LowestPrice: TThostFtdcPriceType;
    ///����
    Volume: TThostFtdcVolumeType	;
    ///�ɽ����
    Turnover: TThostFtdcMoneyType	;
    ///�ֲ���
    OpenInterest: TThostFtdcLargeVolumeType;
    ///������
    ClosePrice: TThostFtdcPriceType	;
    ///���ν����
    SettlementPrice: TThostFtdcPriceType	;
    ///��ͣ���
    UpperLimitPrice: TThostFtdcPriceType	;
    ///��ͣ���
    LowerLimitPrice: TThostFtdcPriceType	;
    ///����ʵ��
    PreDelta: TThostFtdcRatioType	;
    ///����ʵ��
    CurrDelta: TThostFtdcRatioType	;
    ///����޸�ʱ��
    UpdateTime: TThostFtdcTimeType	;
    ///����޸ĺ���
    UpdateMillisec: TThostFtdcMillisecType	;
    ///�����һ
    BidPrice1: TThostFtdcPriceType	;
    ///������һ
    BidVolume1: TThostFtdcVolumeType	;
    ///������һ
    AskPrice1: TThostFtdcPriceType	;
    ///������һ
    AskVolume1: TThostFtdcVolumeType	;
    ///����۶�
    BidPrice2: TThostFtdcPriceType	;
    ///��������
    BidVolume2: TThostFtdcVolumeType	;
    ///�����۶�
    AskPrice2: TThostFtdcPriceType	;
    ///��������
    AskVolume2: TThostFtdcVolumeType	;
    ///�������
    BidPrice3: TThostFtdcPriceType	;
    ///��������
    BidVolume3: TThostFtdcVolumeType	;
    ///��������
    AskPrice3: TThostFtdcPriceType	;
    ///��������
    AskVolume3: TThostFtdcVolumeType	;
    ///�������
    BidPrice4: TThostFtdcPriceType	;
    ///��������
    BidVolume4: TThostFtdcVolumeType	;
    ///��������
    AskPrice4: TThostFtdcPriceType	;
    ///��������
    AskVolume4: TThostFtdcVolumeType	;
    ///�������
    BidPrice5: TThostFtdcPriceType	;
    ///��������
    BidVolume5: TThostFtdcVolumeType	;
    ///��������
    AskPrice5: TThostFtdcPriceType	;
    ///��������
    AskVolume5: TThostFtdcVolumeType	;
    ///���վ���
    AveragePrice: TThostFtdcPriceType	;
    ///ҵ������
    ActionDay: TThostFtdcDateType;
  end;

implementation

end.
