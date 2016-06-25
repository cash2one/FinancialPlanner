unit define_dealsimulation;

interface

uses
  define_dealItem,
  define_price;
  
type
  TDealDirection = (dealBuy, dealSale);

  TDealAction           = packed record
    DealDirection       : TDealDirection;
    StockCode           : TDealCodePack;
    Price               : TRT_PricePack;
    Num                 : Integer;
  end;

  PDealActionNode       = ^TDealActionNode;
  TDealActionNode       = packed record
    PrevSibling         : PDealActionNode;
    NextSibling         : PDealActionNode;
    DealAction          : TDealAction;
  end;

  TDealActions          = packed record
    FirstActionNode     : PDealActionNode;
    LastActionNode      : PDealActionNode;
  end;

  TDealItemHoldItem     = packed record
    StockCode           : TDealCodePack;
    Num                 : Integer;
  end;

  PDealItemHoldItemNode = ^TDealItemHoldItemNode;
  TDealItemHoldItemNode = packed record
    PrevSibling         : PDealItemHoldItemNode;
    NextSibling         : PDealItemHoldItemNode;
    HoldItem            : TDealItemHoldItem;
  end;
  
  TDealItemHoldItems    = packed record
    FirstHoldItemNode   : PDealItemHoldItemNode;
    LastHoldItemNode    : PDealItemHoldItemNode;
  end;

  // ���׽���
  TDealSettlement       = packed record
    Date                : Word;  
    Money               : integer; // �ֽ�
    HoldItems           : TDealItemHoldItems; // �ֲ�
  end;
          
  TDealSimulationDay    = packed record
    Date                : Word;
    DealSettlement      : TDealSettlement;
    DealActions         : TDealActions;
  end;

  PDealSimulationDayNode = ^TDealSimulationDayNode;
  TDealSimulationDayNode = record     
    PrevSibling         : PDealSimulationDayNode;
    NextSibling         : PDealSimulationDayNode;
    DealSimulationDay   : TDealSimulationDay;
  end;

  TDealSimulationDays   = packed record
    FirstSimulationDay  : PDealSimulationDayNode;
    LastSimulationDay   : PDealSimulationDayNode;
  end;
  
  // ����ģ�� Session
  PDealSimulationSession = ^TDealSimulationSession;
  TDealSimulationSession = packed record
    StartDate            : Word;
    StartMoney           : Integer;
    DealSimulationDays   : TDealSimulationDays;
  end;

implementation

end.
