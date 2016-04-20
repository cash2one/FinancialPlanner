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
    ///交易日
    TradingDay: TThostFtdcDateType;
    ///合约代码
    InstrumentID: TThostFtdcInstrumentIDType;
    ///交易所代码
    ExchangeID: TThostFtdcExchangeIDType	;
    ///合约在交易所的代码
    ExchangeInstID: TThostFtdcExchangeInstIDType;
    ///最新价
    LastPrice: TThostFtdcPriceType;
    ///上次结算价
    PreSettlementPrice: TThostFtdcPriceType	;
    ///昨收盘
    PreClosePrice: TThostFtdcPriceType;
    ///昨持仓量
    PreOpenInterest: TThostFtdcLargeVolumeType	;
    ///今开盘
    OpenPrice: TThostFtdcPriceType	;
    ///最高价
    HighestPrice: TThostFtdcPriceType	;
    ///最低价
    LowestPrice: TThostFtdcPriceType;
    ///数量
    Volume: TThostFtdcVolumeType	;
    ///成交金额
    Turnover: TThostFtdcMoneyType	;
    ///持仓量
    OpenInterest: TThostFtdcLargeVolumeType;
    ///今收盘
    ClosePrice: TThostFtdcPriceType	;
    ///本次结算价
    SettlementPrice: TThostFtdcPriceType	;
    ///涨停板价
    UpperLimitPrice: TThostFtdcPriceType	;
    ///跌停板价
    LowerLimitPrice: TThostFtdcPriceType	;
    ///昨虚实度
    PreDelta: TThostFtdcRatioType	;
    ///今虚实度
    CurrDelta: TThostFtdcRatioType	;
    ///最后修改时间
    UpdateTime: TThostFtdcTimeType	;
    ///最后修改毫秒
    UpdateMillisec: TThostFtdcMillisecType	;
    ///申买价一
    BidPrice1: TThostFtdcPriceType	;
    ///申买量一
    BidVolume1: TThostFtdcVolumeType	;
    ///申卖价一
    AskPrice1: TThostFtdcPriceType	;
    ///申卖量一
    AskVolume1: TThostFtdcVolumeType	;
    ///申买价二
    BidPrice2: TThostFtdcPriceType	;
    ///申买量二
    BidVolume2: TThostFtdcVolumeType	;
    ///申卖价二
    AskPrice2: TThostFtdcPriceType	;
    ///申卖量二
    AskVolume2: TThostFtdcVolumeType	;
    ///申买价三
    BidPrice3: TThostFtdcPriceType	;
    ///申买量三
    BidVolume3: TThostFtdcVolumeType	;
    ///申卖价三
    AskPrice3: TThostFtdcPriceType	;
    ///申卖量三
    AskVolume3: TThostFtdcVolumeType	;
    ///申买价四
    BidPrice4: TThostFtdcPriceType	;
    ///申买量四
    BidVolume4: TThostFtdcVolumeType	;
    ///申卖价四
    AskPrice4: TThostFtdcPriceType	;
    ///申卖量四
    AskVolume4: TThostFtdcVolumeType	;
    ///申买价五
    BidPrice5: TThostFtdcPriceType	;
    ///申买量五
    BidVolume5: TThostFtdcVolumeType	;
    ///申卖价五
    AskPrice5: TThostFtdcPriceType	;
    ///申卖量五
    AskVolume5: TThostFtdcVolumeType	;
    ///当日均价
    AveragePrice: TThostFtdcPriceType	;
    ///业务日期
    ActionDay: TThostFtdcDateType;
  end;

implementation

end.
