unit define_deal;

interface

uses
  define_price;
  
type
  // 下单
  TDealRequest      = packed record  { 22 }
    // ??? DataVersion     : Word;      
    ActionDate      : Word;
    ActionTime      : Word; // 9:00 3600 * 
    
    ActionID        : integer;
    Price           : Integer;
    Num             : Integer;
    ResultCode      : Word;
    // 0 未成交
    // 1 部分成交
    // 2 全部成交
    // 3 撤单
    RequestNo       : Integer; //AnsiString; // 委托编号
    //RequestSeqNo    : AnsiString; // 委托序号
  end;
                   
  // 成交
  TDealResultClose  = packed record   { 28 }   
    // ??? DataVersion     : Word;
    ActionDate      : Word;
    ActionTime      : Word; // 9:00 3600 *
     
    ActionID        : integer;
    TargetID        : Integer; // --> request.ActionID
    Price           : Integer; // 成交价格
    Num             : Integer; // 成交数量
    Amount          : Integer; // 金额
    Fee             : Integer; // 手续费 等等
  end;

  // 撤单
  TDealResultCancel = packed record   { 16 }    
    // ??? DataVersion     : Word;      
    ActionDate      : Word;
    ActionTime      : Word; // 9:00 3600 *
    
    ActionID        : Integer;    // 4 - 12
    TargetID        : Integer; // 16 --> request.ActionID
  end;

implementation

end.
