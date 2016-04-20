unit define_ctp_deal;

interface

type
  TDealDirection = (directionNone, directionBuy, directionSale);   
  TDealOffsetMode = (
    modeNone,
    modeOpen, // ����
    modeCloseOut, // ƽ��
    modeCloseNow  // ƽ��
    );

  TPriceMode = (priceLimit, priceNow);
                                      
  PDeal             = ^TDeal;
  PDealOrderRequest = ^TDealOrderRequest;  
  PDealOrderResponse = ^TDealOrderResponse;
  PDealCancelRequest = ^TDealCancelRequest;
  PDealCancelResponse = ^TDealCancelResponse;
  PDealResponse     = ^TDealResponse;
                              
  // �µ�
  TDealOrderRequest = record
    CloseDeal       : PDeal;
    InstrumentID    : AnsiString; // ��Լ IF1508
    Direction       : TDealDirection;
    Mode            : TDealOffsetMode;
    PriceMode       : TPriceMode;
    Price           : double;
    Num             : Integer;
    OrderNo         : AnsiString;

    // exchangeId for cancel
    RequestId       : Integer;
  end;
                      
  // �µ�����
  TDealOrderResponse = record
//    BrokerOrderSeq   : Integer;
//		ExchangeID       : AnsiString;
//		OrderSysID       : AnsiString;
  end;
  
  // ����
  TDealCancelRequest = record
    RequestId       : Integer;
  end;

  TDealCancelResponse = record

  end;
  
  // �ɽ�
  TDealResponse     = record
    Price           : double;
    Num             : Integer;
  end;

  TDealStatus = (
    deal_Invalid,
    deal_Unknown,
    deal_Open,     // �ȴ� �ɽ� ��ȡ��
    deal_Cancel,   // �Ѿ�ȡ��
    deal_Deal,     // �Ѿ��ɽ�
    deal_DealClose // �Ѿ����ֲ����Ѿ�ƽ��
    );
  
  TDeal               = record
    Status            : TDealStatus;
    // ----------------------------------
    OrderRequest      : TDealOrderRequest;
    // ----------------------------------
    // ��������
		ExchangeID        : AnsiString;
		OrderSysID        : AnsiString;
    BrokerOrderSeq    : Integer;
    OrderResponse     : PDealOrderResponse;
    // ----------------------------------
    // �ɽ�����
    Deal              : PDealResponse;
    // ----------------------------------
    // �������� Ҫ������ Ҫ���ɽ�
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
