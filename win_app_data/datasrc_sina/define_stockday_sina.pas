unit define_stockday_sina;

interface

uses
  Sysutils;
  
type                 
  TDealDayDataHeadName_Sina = (
    headNone, // 0
    headDay, // 1 日期,
    headPrice_Open, // 7开盘价,
    headPrice_High, // 5最高价,
    headPrice_Close, // 4收盘价,
    headPrice_Low, // 6最低价,
    headDeal_Volume, // 12成交量,
    headDeal_Amount, // 13成交金额,
    headDeal_WeightFactor
    ); // 15流通市值);

  PRT_DealDayData_HeaderSina = ^TRT_DealDayData_HeaderSina;
  TRT_DealDayData_HeaderSina = record
    HeadNameIndex     : array[TDealDayDataHeadName_Sina] of SmallInt;
  end;
          
const
  DealDayDataHeadNames_Sina: array[TDealDayDataHeadName_Sina] of string = (
    '',
    '日期',
    '开盘价',
    '最高价',
    '收盘价',
    '最低价',
    '交易量(股)',
    '交易金额(元)',
    '复权因子'
  );
    
var
  DateFormat_Sina: Sysutils.TFormatSettings;(*// =(
    CurrencyString: '';
    DateSeparator: '-';
    TimeSeparator: ':';
    ListSeparator: ';';
    ShortDateFormat : 'yyyy-mm-dd';
    LongDateFormat : 'yyyy-mm-dd';
  );//*)
             
implementation

initialization
  FillChar(DateFormat_Sina, SizeOf(DateFormat_Sina), 0);
  DateFormat_Sina.DateSeparator := '-';
  DateFormat_Sina.TimeSeparator := ':';
  DateFormat_Sina.ListSeparator := ';';
  DateFormat_Sina.ShortDateFormat := 'yyyy-mm-dd';
  DateFormat_Sina.LongDateFormat := 'yyyy-mm-dd';
                      
end.
