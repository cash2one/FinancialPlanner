unit define_stock_quotes;

interface

uses
  Define_Price;
  
type
  PRT_WeightPack      = ^TRT_WeightPack;
  TRT_WeightPack      = record
    Value             : LongWord;
  end;
  
  PRT_WeightFull      = ^TRT_WeightFull;
  TRT_WeightFull      = record
    Value             : double;
  end;
                
  PRT_DatePack        = ^TRT_DateTimePack;
  TRT_DatePack        = record
    Value             : Word;
  end;
                                        
  PRT_TimePack        = ^TRT_TimePack;
  TRT_TimePack        = record
    Value             : Word;
  end;

  PRT_DateTimePack    = ^TRT_DateTimePack;
  TRT_DateTimePack    = record
    DateValue         : Word;
    TimeValue         : Word;
  end;

  PRT_DateTimeFull    = ^TRT_DateTimeFull;
  TRT_DateTimeFull    = record
    Value             : double;
  end;     

  { 日线数据 }
  PRT_Quote_Day       = ^TRT_Quote_Day;
  TRT_Quote_Day       = record           // 56
    DealDate          : TRT_DatePack;    // 4
    PriceRange        : TRT_PricePack_Range; // 16 - 20
    DealVolume        : Int64;               // 8 - 28 成交量
    DealAmount        : Int64;               // 8 - 36 成交金额
    Weight            : TRT_WeightPack;      // 4 - 40 复权权重 * 100
    TotalValue        : Int64;               // 8 - 48 总市值
    DealValue         : Int64;               // 8 - 56 流通市值
  end;

  { 及时行情数据
    1 分钟 -- 60 分钟 < 日线
  }
  PRT_Quote_Minute    = ^TRT_Quote_Minute;
  TRT_Quote_Minute    = record
    DealDateTime      : TRT_DateTimeFull;    // 8  
    PriceRange        : TRT_PricePack_Range; // 16 - 24   
    DealVolume        : Integer;             // 4 - 28 成交量
    DealAmount        : Integer;             // 4 - 32 成交金额
  end;
  
  { 交易明细 }
  PRT_Quote_Detail    = ^TRT_Quote_Detail;
  TRT_Quote_Detail    = record
    DealDateTime      : TRT_DateTimePack;    // 4 - 4
    Price             : TRT_PricePack;       // 4 - 8
    DealVolume        : Integer;             // 4 - 12 成交量
    DealAmount        : Integer;             // 4 - 16
    DealType          : Integer;
    // Buyer: Integer;
    // Saler: Integer;
  end;

{
  M1 区间数据
     1 分钟 5 分钟 --- 日线 周线 月线 都是 区间数据
     Open High Low Close
  M2 明细数据
     Price Time Volume Acount
}  
type
  PStore_Weight         = ^TStore_Weight;
  TStore_Weight         = record
    Value               : Cardinal;
  end;
  
  PStore_Quote64_M1     = ^TStore_Quote64_M1;
  TStore_Quote64_M1     = packed record // 128       
  // 一个时间段内的 价格表示  
    PriceRange          : TStore_PriceRange;  // 16
    Reserve             : array[0..64 - 1 - SizeOf(TStore_PriceRange)] of Byte;
  end;
            
  PStore_Quote32_M1     = ^TStore_Quote32_M1;
  TStore_Quote32_M1     = packed record // 128
  // 一个时间段内的 价格表示
    PriceRange          : TStore_PriceRange;  // 16
    Reserve             : array[0..32 - 1 - SizeOf(TStore_PriceRange)] of Byte;
  end;

  { 日线数据 } 
  PStore_Quote64_Day    = ^TStore_Quote64_Day;
  TStore_Quote64_Day    = packed record  // 56
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Int64;         // 8 - 24 成交量
    DealAmount          : Int64;         // 8 - 32 成交金额
    DealDate            : Integer;       // 4 - 36 交易日期
    Weight              : TStore_Weight; // 4 - 40 复权权重 * 100
    TotalValue          : Int64;         // 8 - 48 总市值
    DealValue           : Int64;         // 8 - 56 流通市值 
  end;
        
  PStore_Quote64_Day_V1 = ^TStore_Quote64_Day_V1;
  TStore_Quote64_Day_V1 = packed record  // 56
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Int64;         // 8 - 24 成交量
    DealAmount          : Int64;         // 8 - 32 成交金额
    DealDate            : Integer;       // 4 - 36 交易日期
    Weight              : TStore_Weight; // 4 - 40 复权权重 * 100
    TotalValue          : Int64;         // 8 - 48 总市值
    DealValue           : Int64;         // 8 - 56 流通市值 
  end;
                 
  PStore_Quote64_Day_V2 = ^TStore_Quote64_Day_V2; //--> PStore_Quote64_M1
  TStore_Quote64_Day_V2 = packed record  // 56
    QuoteDay            : TStore_Quote64_Day;   
    Reserve             : array [0..64 - SizeOf(TStore_Quote64_Day) - 1] of Byte;
  end;
           
  { 分时数据 detail }
  PStore_Quote32_Minute = ^TStore_Quote32_Minute;  //
  TStore_Quote32_Minute = packed record  // 28
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Integer;       // 4 - 20 成交量
    DealAmount          : Integer;       // 4 - 24 成交金额
    DealDate            : Word;        // 2 - 26 交易日期
    DealStartTime       : Word;        // 2 - 28 时间
  end;

  TStore_Quote32_Minute_V1 = record
    QuoteTime            : TStore_Quote32_Minute;
    Reserve             : array [0..32 - SizeOf(TStore_Quote32_Minute) - 1] of Byte;
  end;
  
  PStore_Quote64_Minute_V1  = ^TStore_Quote64_Minute_V1;  //
  TStore_Quote64_Minute_V1  = packed record  // 56
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Integer;       // 8 - 24 成交量
    DealAmount          : Integer;       // 8 - 32 成交金额
    DealDateTime        : Double;        // 4 - 36 交易日期
  end;

  TStore_Quote64_Detail_V1  = packed record  // 56
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Integer;       // 8 - 24 成交量
    DealAmount          : Integer;       // 8 - 32 成交金额
    DealDateTime        : Double;        // 4 - 36 交易日期
  end;
               
  // 只有一个价格 必然是 及时报价数据
  PStore_Quote_Detail   = ^TStore_Quote_Detail;
  TStore_Quote_Detail   = packed record  // 8     
    QuoteDealTime       : Word;       // 4 - 8 1 小时 3600 秒  9 -- 15
    QuoteDealDate       : Word;            
    Price               : TStore_Price;  // 4 - 4
    DealVolume          : Integer;          // 4 - 12 成交量
    DealAmount          : Integer;          // 4 - 16 成交金额
    DealType            : Byte; // 买盘卖盘中性盘
  end;

  PStore_Quote32_Detail_V1  = ^TStore_Quote32_Detail_V1;
  TStore_Quote32_Detail_V1  = packed record
    Quote               : TStore_Quote_Detail;
    Reserve             : array [0..32 - SizeOf(TStore_Quote_Detail) - 1] of Byte;
  end;          

  PStore_WeightRecord   = ^TStore_WeightRecord;
  TStore_WeightRecord   = packed record  // 16
    WeightValue         : TStore_Weight; // 4
    WeightValue2        : double; // 8
    StartDate           : Word; // 2
    EndDate             : Word; // 2   
  end;          

const
  DealType_Buy  = 1;
  DealType_Sale = 2;
  DealType_Neutral = 3;  

  function GetTimeText(ATime: PRT_TimePack): AnsiString;
  
implementation

uses
  Sysutils;
  
function GetTimeText(ATime: PRT_TimePack): AnsiString;
var
  tmpHour: Integer;
  tmpMinute: Integer;
  tmpSecond: Integer;
begin
  Result := '';
  if nil <> ATime then
  begin
    tmpHour := Trunc(ATime.Value div 3600);
    tmpSecond := ATime.Value - tmpHour * 3600;
    tmpMinute := Trunc(tmpSecond div 60);
    tmpSecond := tmpSecond - tmpMinute * 60;
    Result := IntToStr(tmpHour + 9) + ':' + IntToStr(tmpMinute) + ':' + IntToStr(tmpSecond);
  end;
end;

end.
