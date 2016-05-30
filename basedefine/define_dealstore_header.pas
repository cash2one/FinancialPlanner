unit define_dealstore_header;

interface
             
uses
  define_price;
  
type           
  // ================================================================
  // header define
  // ================================================================

  TStore_Signature      = packed record // 6
    Signature           : Word;
    DataVer1            : Byte;
    DataVer2            : Byte;
    DataVer3            : Byte;
    // 字节存储顺序 java 和 delphi 不同
    // 00
    // 01
    BytesOrder          : Byte;
  end;

  // SizeMode = 0 -- 未定义
  // [ 一段一段 表明自己的 begin -- end 无明显 pagesize 区分]
  // SizeMode = 01 -- 流式存储
  // SizeMode = 02 -- 4            2^(2 )
  // SizeMode = 03 -- 8            2^(3 )
  // SizeMode = 04 -- 16           2^(4 )
  // SizeMode = 05 -- 32           2^(5 )
  // SizeMode = 06 -- 64           2^(6 )
  // SizeMode = 10 -- 1k
  // SizeMode = 16 -- 64k
  // -------------------------
  // SizeMode = 19 -- 512k
  // SizeMode = 20 -- 1m
  // SizeMode = 30 -- 1G
  // -------------------------   
  TStore_SizeMode       = packed record
    Value               : Byte;
  end;
       
  // java 存 int 和 delphi 纯 integer 字节存储顺序是反的
  TStore_Quote_M1_Header_V1 = packed record
    Signature           : TStore_Signature; // 6
    HeadSize            : Byte;             // 1 -- 7
    StoreSizeMode       : TStore_SizeMode;  // 1 -- 8 page size mode
    { 表明是什么数据 }
    DataType            : Word;             // 2 -- 10   
    DataMode            : Byte;             // 1 -- 11
    RecordSizeMode      : TStore_SizeMode;  // 1 -- 12
    RecordCount         : integer;          // 4 -- 16
    CompressFlag        : Byte;             // 1 -- 17
    EncryptFlag         : Byte;             // 1 -- 18
    DataSourceId        : Word;             // 2 -- 20
    Code                : array[0..11] of AnsiChar; // 12 - 32
    // ----------------------------------------------------
    StorePriceFactor    : Word;             // 2 - 34
  end;
           
  // 日线
  PStore_Quote_M1_Day_Header_V1 = ^TStore_Quote_M1_Day_Header_V1;
  TStore_Quote_M1_Day_Header_V1 = packed record
    BaseHeader          : TStore_Quote_M1_Header_V1; // 34
    FirstDealDate       : Word;             // 2 - 36
    LastDealDate        : Word;             // 2 - 38
    EndDealDate         : Word;             // 2 - 40
  end;   

  PStore_Quote_M1_Day_Header_V1Rec = ^TStore_Quote_M1_Day_Header_V1Rec;
  TStore_Quote_M1_Day_Header_V1Rec = packed record
    Header: TStore_Quote_M1_Day_Header_V1;
    Reserve: array[0..64 - SizeOf(TStore_Quote_M1_Day_Header_V1) - 1] of Byte;
  end;
  
  // 日交易明细 1min
  TStore_Quote_M1_Time_Header_V1 = packed record
    BaseHeader          : TStore_Quote_M1_Header_V1; // 34      
    FirstDealDate       : Word;             // 2 - 36
    LastDealDate        : Word;             // 2 - 38
    DateTimeInterval    : Word;             // 2 - 40
    ///昨收盘
    PreClosePrice       : TStore_Price;     // 4 - 44
    ///涨停板价
    UpperLimitPrice     : TStore_Price;     // 4 - 48
    ///跌停板价
    LowerLimitPrice     : TStore_Price;     // 4 - 52
    // 这里不需要做统计 放到 日线数据里去吧    
    //PriceRange          : TStore_PriceRange;
    //DealAmount          : Int64;  // 成交金额      // 8 - 62
    //DealVolume          : Int64;  // 成交量        // 8 - 70
  end;
       
  // 日交易明细
  TStore_Quote_M2_Header_V1 = packed record     
    Signature           : TStore_Signature; // 6
    HeadSize            : Byte;             // 1 -- 7
    StoreSizeMode       : TStore_SizeMode;  // 1 -- 8 page size mode
    { 表明是什么数据 }
    DataType            : Word;             // 2 -- 10   
    DataMode            : Byte;             // 1 -- 11
    RecordSizeMode      : TStore_SizeMode;  // 1 -- 12
    RecordCount         : integer;          // 4 -- 16
    CompressFlag        : Byte;             // 1 -- 17
    EncryptFlag         : Byte;             // 1 -- 18
    
    DataSourceId        : Word;             // 2 -- 20
    Code                : array[0..11] of AnsiChar; // 12 - 32
    // ----------------------------------------------------
    StorePriceFactor    : Word;             // 2 - 34
    FirstDealDate       : Word;
    LastDealDate        : Word;    
  end;
                 
  PStore_Quote_M2_Detail_Header_V1 = ^TStore_Quote_M2_Detail_Header_V1;
  TStore_Quote_M2_Detail_Header_V1 = packed record
    BaseHeader: TStore_Quote_M2_Header_V1;
  end;
  
  PStore_Quote_M2_Detail_Header_V1Rec = ^TStore_Quote_M2_Detail_Header_V1Rec;
  TStore_Quote_M2_Detail_Header_V1Rec = packed record
    Header: TStore_Quote_M2_Detail_Header_V1;
    Reserve: array[0..64 - SizeOf(TStore_Quote_M2_Detail_Header_V1) - 1] of Byte;
  end;

const
  DataType_Stock            = 1;
  DataType_Futures          = 2;
  DataType_DBItem           = 3;  

  DataMode_DayData          = 1; // 日线数据 M1
  // M1 Stock
  // M1 CTP    
  //    5秒
  //    15秒
  
  //    1分钟
  //    5分钟
  //    10分钟     
  //    15分钟
  //    30分钟
  //    60分钟
  DataMode_DayDetailDataM1  = 2; // 日明细 M1 --
  DataMode_DayDetailDataM2  = 3; // 日明细 M2
  DataMode_DayInstant       = 4;
  DataMode_DayValue         = 5;  

  // 日线不需要 实时不需要 DataType_QuoteRangeData 需要
  // 0.1  秒为单位 ???
  // 600 -- 1分钟
  // 36000 < 65565 -- 1小时 < 一天
  // 9:00 -- 15:00   -- 7 * 36000 [可以使用 Integer 不需要 double]
  // 一旦大于 36000 则使用新的 单位 方式

  DateTimeInterval_1Sec       = 1 * 10;
  DateTimeInterval_5Sec       = 5 * DateTimeInterval_1Sec;
  DateTimeInterval_15Sec      = 15 * DateTimeInterval_1Sec;
      
  DateTimeInterval_1Min       = 1 * 60 * 10;
  DateTimeInterval_5Min       = 5 * DateTimeInterval_1Min;
  DateTimeInterval_10Min      = 10 * DateTimeInterval_1Min;
  DateTimeInterval_15Min      = 15 * DateTimeInterval_1Min;
  DateTimeInterval_20Min      = 20 * DateTimeInterval_1Min;
  DateTimeInterval_30Min      = 30 * DateTimeInterval_1Min;
  DateTimeInterval_60Min      = 60 * DateTimeInterval_1Min; // 36000

implementation

end.
