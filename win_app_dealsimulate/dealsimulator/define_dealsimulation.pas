unit define_dealsimulation;

interface

uses
  define_dealItem,
  define_price;
  
type
  TDealDirection = (
    dealBuy,
    dealSale,
    dealMoneyIn,  // ������
    dealMoneyOut  // ȡ��
    );

  TRT_DealAction        = packed record
    DealDirection       : TDealDirection;
    StockCode           : TDealCodePack;
    Price               : TRT_PricePack;
    Num                 : Integer;
    DealTime            : Word;
  end;

  PDealActionNode       = ^TDealActionNode;
  TDealActionNode       = packed record
    PrevSibling         : PDealActionNode;
    NextSibling         : PDealActionNode;
    DealAction          : TRT_DealAction;
  end;

  TRT_DealActions       = packed record
    FirstActionNode     : PDealActionNode;
    LastActionNode      : PDealActionNode;
  end;

  TRT_DealItemHoldItem  = packed record
    StockCode           : TDealCodePack;
    Num                 : Integer;     
    DealDate            : Word;      
    DealTime            : Word;
    Cost                : TRT_PricePack// �ɱ��� 
  end;

  PDealItemHoldItemNode = ^TDealItemHoldItemNode;
  TDealItemHoldItemNode = packed record
    PrevSibling         : PDealItemHoldItemNode;
    NextSibling         : PDealItemHoldItemNode;
    HoldItem            : TRT_DealItemHoldItem;
  end;
  
  TRT_DealItemHoldItems = packed record
    FirstHoldItemNode   : PDealItemHoldItemNode;
    LastHoldItemNode    : PDealItemHoldItemNode;
  end;

  // ���׽���
  PRT_DealSettlement    = ^TRT_DealSettlement;
  TRT_DealSettlement    = packed record
    Date                : Word;  
    MoneyAvailable      : integer; // �ֽ�   
    MoneyLocked         : integer; // �ֽ�
    HoldItems           : TRT_DealItemHoldItems; // �ֲ�
  end;
          
  TRT_DealDaySettlement   = packed record
    Date                  : Word;
    DealSettlement        : TRT_DealSettlement;
    DealRequests          : TRT_DealActions; // ��������   
    DealActions           : TRT_DealActions; // ���׳ɽ�   
  end;

  PDealHistoryDayNode     = ^TDealHistoryDayNode;
  TDealHistoryDayNode     = record
    PrevSibling           : PDealHistoryDayNode;
    NextSibling           : PDealHistoryDayNode;
    DealSimulationDay     : TRT_DealDaySettlement;
  end;

  PRT_DealHistorys        = ^TRT_DealHistorys;
  TRT_DealHistorys        = packed record
    FirstDealHistoryDay   : PDealHistoryDayNode;
    LastDealHistoryDay    : PDealHistoryDayNode;
  end;
  
  // ����ģ�� Session
  PRT_DealAccount         = ^TRT_DealAccount;
  TRT_DealAccount         = record
    StartMoney            : Integer;
    EndAsset              : Integer;
    // ���ս���
    CurrentSettlement     : TRT_DealDaySettlement;
    // ������ʷ
    DealHistorys          : TRT_DealHistorys;
  end;

  PDealAccountNode        = ^TDealAccountNode;
  TDealAccountNode        = record        
    PrevSibling           : PDealAccountNode;
    NextSibling           : PDealAccountNode;
    DealAccount           : TRT_DealAccount;
  end;

  TRT_DealAccounts        = record
    FirstDealAccount      : PDealAccountNode;
    LastDealAccount       : PDealAccountNode;
  end;
  
  PRT_DealHistorySession  = ^TRT_DealHistorySession;
  TRT_DealHistorySession  = packed record
    StartDate             : Word;
    EndDate               : Word;
    DealAccounts          : TRT_DealAccounts;
  end;

implementation

end.
