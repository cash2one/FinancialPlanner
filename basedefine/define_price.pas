unit define_price;

interface

type               
  TRT_UpDownStatus = (
    udNone,
    udFlatline, // 持平    
    udUp,       // 上涨
    udDown      // 下跌
  );

  TWeightMode = (
    weightNone,  // 不复权
    weightForward,  // 前复权
    weightBackward  // 后复权    
  );

  TStore_UpDownStatus   = Integer;
  
  PRT_PricePack         = ^TRT_PricePack;
  TRT_PricePack         = record
    Value               : LongWord; // 4
  end;

  PRT_PricePack_Range   = ^TRT_PricePack_Range;
  TRT_PricePack_Range   = record         // 16
    PriceOpen           : TRT_PricePack; // 4
    PriceClose          : TRT_PricePack; // 4
    PriceHigh           : TRT_PricePack; // 4
    PriceLow            : TRT_PricePack; // 4
  end;
                  
  PRT_PriceFull         = ^TRT_PriceFull;
  TRT_PriceFull         = record
    Value               : double;
  end;
  
  PRT_PriceFull_Range   = ^TRT_PriceFull_Range;
  TRT_PriceFull_Range   = record
    PriceOpen           : TRT_PriceFull;
    PriceClose          : TRT_PriceFull;
    PriceHigh           : TRT_PriceFull;
    PriceLow            : TRT_PriceFull;
  end;
  
  PStore_Price          = ^TStore_Price;
  TStore_Price          = record
    Value               : LongWord;
  end;

  PStore_PriceRange     = ^TStore_PriceRange;
  TStore_PriceRange     = packed record
    PriceOpen           : TStore_Price;  // 4 - 4
    PriceHigh           : TStore_Price;  // 4 - 8  ( price * 100 )
    PriceLow            : TStore_Price;  // 4 - 12
    PriceClose          : TStore_Price;  // 4 - 16
  end;
                             
  PStore_PriceSmall     = ^TStore_PriceSmall;
  TStore_PriceSmall     = record
    Value               : Word;
  end;
                                                
  PStore_PriceFull      = ^TStore_PriceFull;
  TStore_PriceFull      = record
    Value               : double;
  end;

  
  function GetRTPricePackValue(AValue: double): LongWord; overload;
  function GetRTPricePackValue(AValue: string): LongWord; overload;
  procedure SetRTPricePack(ARTPrice: PRT_PricePack; AValue: double);

  procedure StorePrice2RTPricePack(ARTPrice: PRT_PricePack; AStorePrice: PStore_Price);
  procedure RTPricePack2StorePrice(AStorePrice: PStore_Price; ARTPrice: PRT_PricePack);

  procedure StorePriceRange2RTPricePackRange(ARTPrice: PRT_PricePack_Range; AStorePrice: PStore_PriceRange);    
  procedure RTPricePackRange2StorePriceRange(AStorePrice: PStore_PriceRange; ARTPrice: PRT_PricePack_Range);

  function tryGetInt64Value(AStringData: string): Int64;
  procedure trySetRTPricePack(ARTPrice: PRT_PricePack; AStringData: string);

const
  DefaultPriceFactor = 1000;
     
implementation

uses
  Sysutils;

procedure trySetRTPricePack(ARTPrice: PRT_PricePack; AStringData: string);
begin
  ARTPrice.Value := Trunc(StrToFloatDef(AStringData, 0.00) * DefaultPriceFactor);
end;

function tryGetInt64Value(AStringData: string): Int64;
var
  tmpPos: integer;
begin
  tmpPos := Sysutils.LastDelimiter('.', AStringData);
  if tmpPos > 0 then
    AStringData := Copy(AStringData, 1, tmpPos - 1);
  Result := StrToInt64Def(AStringData, 0);
end;

function GetRTPricePackValue(AValue: double): LongWord;
var
  tmpValue: double;
begin
  tmpValue := AValue * DefaultPriceFactor;
  Result := Trunc(tmpValue);
end;
                         
function GetRTPricePackValue(AValue: string): LongWord;
begin
  Result := GetRTPricePackValue(StrToFloatDef(AValue, 0.00));
end;

procedure SetRTPricePack(ARTPrice: PRT_PricePack; AValue: double);
begin
  ARTPrice.Value := GetRTPricePackValue(AValue);
end;

procedure StorePrice2RTPricePack(ARTPrice: PRT_PricePack; AStorePrice: PStore_Price);
begin
  ARTPrice.Value := AStorePrice.Value;
end;
                
procedure RTPricePack2StorePrice(AStorePrice: PStore_Price; ARTPrice: PRT_PricePack);
begin
  AStorePrice.Value := ARTPrice.Value;
end;
           
procedure StorePriceRange2RTPricePackRange(ARTPrice: PRT_PricePack_Range; AStorePrice: PStore_PriceRange);
begin            
  StorePrice2RTPricePack(@ARTPrice.PriceClose, @AStorePrice.PriceClose);
  StorePrice2RTPricePack(@ARTPrice.PriceHigh, @AStorePrice.PriceHigh);
  StorePrice2RTPricePack(@ARTPrice.PriceLow, @AStorePrice.PriceLow);
  StorePrice2RTPricePack(@ARTPrice.PriceOpen, @AStorePrice.PriceOpen); 
end;
                        
procedure RTPricePackRange2StorePriceRange(AStorePrice: PStore_PriceRange; ARTPrice: PRT_PricePack_Range);
begin
  RTPricePack2StorePrice(@AStorePrice.PriceClose, @ARTPrice.PriceClose);
  RTPricePack2StorePrice(@AStorePrice.PriceHigh, @ARTPrice.PriceHigh);
  RTPricePack2StorePrice(@AStorePrice.PriceLow, @ARTPrice.PriceLow);
  RTPricePack2StorePrice(@AStorePrice.PriceOpen, @ARTPrice.PriceOpen);      
end;

end.
