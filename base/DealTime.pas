unit DealTime;

interface
  
type                   
  TStockDealTimeType = (
    dealNone,
    dealRestDay,      // 休息日
    dealDayBefore,    // 1-- 8 前一天交易
    dealPrepare,      // 8 -- 9:15
    dealRequestStart, // 9:15 -- 9:25 集合竞价
    dealing1,         // 交易中 上午 9:25 -- 11:30
    dealNoontime,     // 11:30 -- 1:00
    dealing2,         // 交易中 下午 1:00 -- 3:08  
    dealDayAfter,     // 交易结算 下午 3:05 -- 3:30
    dealDayEnd        // 15:30-- 24:00
  );

  function stockDealTimeType(ADateTime: TDateTime): TStockDealTimeType;
  function IsValidStockDealTime(ADateTime: TDateTime = 0): Boolean;

implementation

uses
  Sysutils;
  
function stockDealTimeType(ADateTime: TDateTime): TStockDealTimeType;
var
  tmpHour, tmpMin, tmpSec: Word;
  tmpWord: Word;
begin  
  Result := dealRestDay;
  tmpWord := DayOfWeek(ADateTime);
  if (1 = tmpWord) or (7 = tmpWord) then
    exit;
  Result := dealDayBefore;    // 1-- 8 前一天交易
  DecodeTime(ADateTime, tmpHour, tmpMin, tmpSec, tmpWord);
  if (tmpHour < 8) then
    exit;
  Result := dealPrepare;    // 1-- 8 前一天交易
  if (tmpHour = 9) then
  begin
    if 15 > tmpMin then
      exit;
    Result := dealRequestStart; // 9:15 -- 9:25 集合竞价
    if 25 > tmpMin then
      exit;
    Result := dealing1;// 交易中 上午 9:25 -- 11:30
    exit;
  end;
  Result := dealing1;
  if (10 = tmpHour) then
    exit;
  if (11 = tmpHour) then
  begin
    if 32 > tmpMin then
      exit;
  end;
  Result := dealNoontime; // 11:30 -- 1:00
  if (tmpHour < 13) then
    exit;    
  Result := dealing2; 
  if (tmpHour < 15) then
    exit;
  if (tmpHour = 15) then
  begin
    if tmpMin < 05 then
      exit;            
    Result := dealDayAfter; // 15:08-- 24:00
    if tmpMin < 30 then
      exit;            
  end;
  Result := dealDayEnd; // 15:08-- 24:00
end;

function IsValidStockDealTime(ADateTime: TDateTime = 0): Boolean;
var    
  tmpHour, tmpMin, tmpSec, tmpMSec: Word;
begin
  Result := false;
  if 0 = ADateTime then
  begin
    DecodeTime(now, tmpHour, tmpMin, tmpSec, tmpMSec);
  end else
  begin
    DecodeTime(ADateTime, tmpHour, tmpMin, tmpSec, tmpMSec);
  end;
  if 9 > tmpHour then
    exit;
  if 15 < tmpHour then
    exit;
  if 9 = tmpHour then
  begin
    if 29 > tmpMin then
      exit;
  end;
  if 11 = tmpHour then
  begin
    if 30 < tmpMin then
      exit;
  end;
  if 12 = tmpHour then
    exit;          
  if 15 = tmpHour then
  begin
    if 1 < tmpMin then
      exit;
  end;
  Result := true;
end;
                 
end.
