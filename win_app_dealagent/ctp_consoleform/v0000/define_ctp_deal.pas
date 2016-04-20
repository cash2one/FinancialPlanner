unit define_ctp_deal;

interface

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


implementation

end.
