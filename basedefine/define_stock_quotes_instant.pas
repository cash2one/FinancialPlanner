unit define_stock_quotes_instant;

interface

uses
  Define_dealItem,
  define_dealstore_Header,
  Define_Price;
  
type
  PStore_InstantQuote = ^TStore_InstantQuote;
  TStore_InstantQuote = packed record
    StockCode   : TDealCodePack; // 4
    PriceRange  : TStore_PriceRange;    // 16 -- 20
    Amount      : Int64;                // 8 -- 28
    Volume      : Int64;                // 36
  end;

  PStore_InstantQuoteRec = ^TStore_InstantQuoteRec;
  TStore_InstantQuoteRec = packed record
    Data        : TStore_InstantQuote;
    // 16 32 48 64
    //Reserve     : array[0..64 - 1 - SizeOf(TStore_InstantQuote)] of Byte;
    Reserve     : array[0..40 - 1 - SizeOf(TStore_InstantQuote)] of Byte;    
  end;

  PStore_InstantQuoteHeader = ^TStore_InstantQuoteHeader;
  TStore_InstantQuoteHeader = packed record
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
  end;

  PStore_InstantQuoteHeaderRec = ^TStore_InstantQuoteHeaderRec;
  TStore_InstantQuoteHeaderRec = packed record
    Header: TStore_InstantQuoteHeader;
    Reserve: array[0..64 - 1 - SizeOf(TStore_InstantQuoteHeader)] of Byte;
  end;
  
  PRT_InstantQuote = ^TRT_InstantQuote;
  TRT_InstantQuote = packed record
    Item        : PRT_DealItem;        //     
    PriceRange  : TRT_PricePack_Range;  // 16 -- 20      
    Amount      : Int64;                // 8 -- 28
    Volume      : Int64;                // 36
    ExtendParam : Pointer;
    //Day         : Word;
  end;

implementation

end.
