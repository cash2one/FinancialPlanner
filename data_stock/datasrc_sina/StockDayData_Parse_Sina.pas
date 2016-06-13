unit StockDayData_Parse_Sina;

interface

uses
  Sysutils,
  define_stockday_sina,
  define_stock_quotes,
  define_price;
                 
  procedure ParseCellData(AHeadCol: TDealDayDataHeadName_Sina; ADealDayData: PRT_Quote_M1_Day; AStringData: string);

implementation
                             
procedure ParseCellData(AHeadCol: TDealDayDataHeadName_Sina; ADealDayData: PRT_Quote_M1_Day; AStringData: string);
var
  tmpPos: integer; 
  tmpDate: TDateTime;
begin
  if AStringData <> '' then
  begin
    case AHeadCol of
      headDay: begin
        tmpDate := StrToDateDef(AStringData, 0, DateFormat_Sina);
        ADealDayData.DealDate.Value := Trunc(tmpDate);
      end; // 1 ����,
      headPrice_Open: begin // 7���̼�,
        SetRTPricePack(@ADealDayData.PriceRange.PriceOpen, StrToFloatDef(AStringData, 0.00));
      end;
      headPrice_High: begin // 5��߼�,
        SetRTPricePack(@ADealDayData.PriceRange.PriceHigh, StrToFloatDef(AStringData, 0.00));
      end;
      headPrice_Close: begin // 4���̼�,
        SetRTPricePack(@ADealDayData.PriceRange.PriceClose, StrToFloatDef(AStringData, 0.00));
      end;
      headPrice_Low: begin // 6��ͼ�,
        SetRTPricePack(@ADealDayData.PriceRange.PriceLow, StrToFloatDef(AStringData, 0.00));
      end;
      headDeal_Volume: begin // 12�ɽ���,
        tmpPos := Sysutils.LastDelimiter('.', AStringData);
        if tmpPos > 0 then
        begin
          AStringData := Copy(AStringData, 1, tmpPos - 1);
        end;
        ADealDayData.DealVolume := StrToInt64Def(AStringData, 0);
      end;
      headDeal_Amount: begin // 13�ɽ����,
        tmpPos := Sysutils.LastDelimiter('.', AStringData);
        if tmpPos > 0 then
        begin
          AStringData := Copy(AStringData, 1, tmpPos - 1);
        end;
        ADealDayData.DealAmount := StrToInt64Def(AStringData, 0);
      end;
      headDeal_WeightFactor: begin
        ADealDayData.Weight.Value := Trunc(StrToFloatDef(AStringData, 0.00) * 1000);
      end;
    end;
  end;
end;
                
end.
