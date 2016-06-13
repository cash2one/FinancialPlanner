unit define_stockday_sina;

interface

uses
  Sysutils;
  
type                 
  TDealDayDataHeadName_Sina = (
    headNone, // 0
    headDay, // 1 ����,
    headPrice_Open, // 7���̼�,
    headPrice_High, // 5��߼�,
    headPrice_Close, // 4���̼�,
    headPrice_Low, // 6��ͼ�,
    headDeal_Volume, // 12�ɽ���,
    headDeal_Amount, // 13�ɽ����,
    headDeal_WeightFactor
    ); // 15��ͨ��ֵ);

  PRT_DealDayData_HeaderSina = ^TRT_DealDayData_HeaderSina;
  TRT_DealDayData_HeaderSina = record
    HeadNameIndex     : array[TDealDayDataHeadName_Sina] of SmallInt;
  end;
          
const
  DealDayDataHeadNames_Sina: array[TDealDayDataHeadName_Sina] of string = (
    '',
    '����',
    '���̼�',
    '��߼�',
    '���̼�',
    '��ͼ�',
    '������(��)',
    '���׽��(Ԫ)',
    '��Ȩ����'
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
