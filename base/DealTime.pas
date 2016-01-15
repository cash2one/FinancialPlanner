unit DealTime;

interface
               
  function IsValidStockDealTime(ADateTime: TDateTime = 0): Boolean;

implementation

uses
  Sysutils;
  
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
