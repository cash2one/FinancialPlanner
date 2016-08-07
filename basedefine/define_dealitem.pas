unit define_dealitem;

interface
                   
uses
  Define_Price;
              
type            
  TDealCodePack = integer;

  PRT_DealItem          = ^TRT_DealItem;
  TRT_DealItem          = packed record
    Country             : Word;
    //MarketCode          : array[0..3] of AnsiChar; 
    sMarketCode         : AnsiString;
    iMarketCode         : integer;    
    //Code                : array[0..7] of AnsiChar;   
    sCode               : AnsiString;
    iCode               : TDealCodePack;    
    //Name                : array[0..5] of WideChar;
    Name                : AnsiString;
    //ItemFlag            : Byte;
    IsDataChange        : Byte;
    FirstDealDate       : Word;          // 2
    LastDealDate        : Word;          // 2
    EndDealDate         : Word;          // 2
  end;
         
  PStore_DealItem32     = ^TStore_DealItem32;
  TStore_DealItem32     = packed record // 128
    Code                : array[0..12 - 1] of AnsiChar; // 12   
    Name                : array[0..6 - 1] of WideChar; // 12    
    Country             : Word; // 2 26
    FirstDealDate       : Word; // 2 28
    EndDate             : Word; // 2 30
  end;

  PStore_DealItem32Rec  = ^TStore_DealItem32Rec;
  TStore_DealItem32Rec  = packed record
    ItemRecord          : TStore_DealItem32;
    Reserve             : array[0..32 - 1 - SizeOf(TStore_DealItem32)] of Byte;
  end;

  function getStockCodePack(AStockCode: string) : integer;
  function getStockCodeByPackCode(AStockCode: integer) : string;
    
implementation

uses
  SysUtils, sysdef_string;
  
function getStockCodePack(AStockCode: AnsiString) : integer;
begin
  Result := 0;                 
  if 6 > Length(AStockCode) then
    AStockCode := Copy('000000', 1, 6 - length(AStockCode)) + AStockCode;  
  if 6 < Length(AStockCode) then
    AStockCode := Copy(AStockCode, Length(AStockCode) - 6 + 1, maxint);
  if 6 = Length(AStockCode) then
  begin
    if '6' = AStockCode[FirstStringIndex] then
    begin
      Result := StrToIntDef(AStockCode, 0);
    end else
    begin
      Result := StrToIntDef('1' + AStockCode, 0);
    end;
  end;
end;

function getStockCodeByPackCode(AStockCode: integer) : AnsiString;
begin
  Result := IntToStr(AStockCode);
  if 6 < Length(Result) then
  begin
    Result := Copy(Result, Length(Result) - 6 + 1, maxint);
  end;
end;

end.
