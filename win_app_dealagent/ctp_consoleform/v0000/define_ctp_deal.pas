unit define_ctp_deal;

interface

uses
  ThostFtdcTraderApiDataType;
  
type
  TDealDirection = (directionNone, directionBuy, directionSale);   
  TDealOffsetMode = (
    modeNone,
    modeOpen, // 开仓
    modeCloseOut, // 平仓
    modeCloseNow  // 平今
    );

  TPriceMode = (priceLimit, priceNow);
                                      
  PDeal             = ^TDeal;
  PDealOrderRequest = ^TDealOrderRequest;  
  PDealOrderResponse = ^TDealOrderResponse;
  PDealCancelRequest = ^TDealCancelRequest;
  PDealCancelResponse = ^TDealCancelResponse;
  PDealResponse     = ^TDealResponse;
                              
  // 下单
  TDealOrderRequest = record
    CloseDeal       : PDeal;
    InstrumentID    : AnsiString; // 合约 IF1508
    Direction       : TDealDirection;
    Mode            : TDealOffsetMode;
    PriceMode       : TPriceMode;
    Price           : double;
    Num             : Integer;
    OrderNo         : AnsiString;

    // exchangeId for cancel
    RequestId       : Integer;
  end;
                      
  // 下单反馈
  TDealOrderResponse = record
//    BrokerOrderSeq   : Integer;
//		ExchangeID       : AnsiString;
//		OrderSysID       : AnsiString;
  end;
  
  // 撤单
  TDealCancelRequest = record
    RequestId       : Integer;
  end;

  TDealCancelResponse = record

  end;
  
  // 成交
  TDealResponse     = record
    Price           : double;
    Num             : Integer;
  end;

  TDealStatus = (
    deal_Invalid,
    deal_Unknown,
    deal_Open,     // 等待 成交 或取消
    deal_Cancel,   // 已经取消
    deal_Deal,     // 已经成交
    deal_DealClose // 已经开仓并且已经平仓
    );
  
  TDeal               = record
    Status            : TDealStatus;
    // ----------------------------------
    OrderRequest      : TDealOrderRequest;
    // ----------------------------------
    // 报单返回
		ExchangeID        : AnsiString;
		OrderSysID        : AnsiString;
    BrokerOrderSeq    : Integer;
    OrderResponse     : PDealOrderResponse;
    // ----------------------------------
    // 成交返回
    Deal              : PDealResponse;
    // ----------------------------------
    // 两个方向 要不撤单 要不成交
    CancelRequest     : PDealCancelRequest;
    CancelResponse    : PDealCancelResponse;
  end;

  TDealConsoleData = record
    Index: Integer;
    DealArray: array[0..300 - 1] of TDeal;  
    //OrgData: TDealOrgDataConsole;
    LastRequestDeal: PDeal;
  end;
                
  PTradingAccount = ^TTradingAccount;
  TTradingAccount = record
    RecordTime: TDateTime;
    Data: ThostFtdcTradingAccountField;
  end;

  PInvestorPosition = ^TInvestorPosition;
  TInvestorPosition = record
    RecordTime: TDateTime;
    InstrumentId: AnsiString;
    Data: ThostFtdcInvestorPositionField;
  end;

  PInputOrder = ^TInputOrder;
  TInputOrder = record
    RecordTime: TDateTime;
    Data: ThostFtdcInputOrderField;
  end;

  PInputOrderAction = ^TInputOrderAction;
  TInputOrderAction = record
    RecordTime: TDateTime;
    Data: ThostFtdcInputOrderActionField;
  end;

  POrder = ^TOrder;
  TOrder = record
    MsgSrc: Integer;
    RecordTime: TDateTime;
    Data: ThostFtdcOrderField;
  end;

  PTrade = ^TTrade;
  TTrade = record
    MsgSrc: Integer;
    RecordTime: TDateTime;
    Data: ThostFtdcTradeField;
  end;

  PInstrument = ^TInstrument;
  TInstrument = record
    RecordTime: TDateTime;
    Data: ThostFtdcInstrumentField;
  end;
             
  TInputOrderCache = record
    Count: integer;
    InputOrderArray: array[0..1 * 1024 - 1] of PInputOrder;
  end;

  TInputOrderActionCache = record
    Count: integer;       
    InputOrderActionArray: array[0..1 * 1024 - 1] of PInputOrderAction;
  end;

  TOrderCache = record
    Count: integer;
    OrderArray: array[0..1 * 1024 - 1] of POrder;
  end;

  TTradeCache = record
    Count: integer;
    TradeArray: array[0..1 * 1024 - 1] of PTrade;
  end;

  TInvestorPositionCache = record  
    Count: integer;
    InvestorPositionArray: array[0..7] of PInvestorPosition;
  end;

  TConsoleData = record
    TradingAccount: TTradingAccount;
    InvestorPositionCache: TInvestorPositionCache;
    // -------------------------------
    InputOrderCache: TInputOrderCache;
    InputOrderActionCache: TInputOrderActionCache;
    OrderCache: TOrderCache;
    TradeCache: TTradeCache;
  end;
  
implementation

end.
