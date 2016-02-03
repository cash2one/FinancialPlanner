unit StockDay_Get_163;

interface

uses
  BaseApp;

  procedure GetStockDataDay_163_All(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  db_dealitem,
  define_dealItem,
  Define_DataSrc,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
  DB_dealItem_Load,
  DB_dealItem_Save;

const
  Base163DayUrl1 = 'http://quotes.money.163.com/service/chddata.html?';
                          
type
  TDealDayDataHeadName_163 = (headNone, headDay, headCode, headName,
    headPrice_Close, headPrice_High, headPrice_Low, headPrice_Open, headPrice_PrevClose,
    headPrice_Change, headPrice_ChangeRate, headDeal_VolumeRate, headDeal_Volume, 
    headDeal_Amount, headTotal_Value, headDeal_Value); 
                 
  PRT_DealData_Header163 = ^TRT_DealData_Header163;
  TRT_DealData_Header163 = record
    IsReady: Byte;          
    DateFormat_163: Sysutils.TFormatSettings;
    HeadNameIndex     : array[TDealDayDataHeadName_163] of SmallInt;
  end;

  PRT_DealData_163    = ^TRT_DealData_163;
  TRT_DealData_163    = record
    Stock             : PRT_DealItem;
    Day               : Integer;
    Code              : AnsiString;
    Name              : AnsiString;
    // price
    Price_Close       : double;
    Price_High        : double;
    Price_Low         : double;
    Price_Open        : double;
    Price_PrevClose   : double;
    Price_Change      : double;
    Price_ChangeRate  : double;
    // deal
    Deal_VolumeRate   : double;
    Deal_Volume       : int64;
    Deal_Amount       : int64;
    // value
    Total_Value       : int64;
    Deal_Value        : int64;
  end;
  
const
  DealDayDataHeadNames_163: array[TDealDayDataHeadName_163] of string = ('',
    '日期', '股票代码', '名称',
    '收盘价', '最高价', '最低价', '开盘价', '前收盘',
    '涨跌额', '涨跌幅', '换手率', '成交量',
    '成交金额', '总市值', '流通市值');
                             
function ParseDataHeader_163(A163HeadData: PRT_DealData_Header163; AData: string; AParseDatas: TStringList): Boolean;
var
  tmpHeader: TDealDayDataHeadName_163;
  tmpHeader2: TDealDayDataHeadName_163;
  tmpInt: integer;
begin
  Result := false;
  for tmpHeader := Low(TDealDayDataHeadName_163) to High(TDealDayDataHeadName_163) do
    A163HeadData.HeadNameIndex[tmpHeader] := -1;
  AParseDatas.Text := StringReplace(AData, ',', #13#10, [rfReplaceAll]);
  for tmpInt := 0 to AParseDatas.Count - 1 do
  begin
    tmpHeader2 := headNone;
    for tmpHeader := Low(TDealDayDataHeadName_163) to High(TDealDayDataHeadName_163) do
    begin
      if DealDayDataHeadNames_163[tmpHeader] = AParseDatas[tmpInt] then
      begin
        tmpHeader2 := tmpHeader;
        Break;
      end;
    end;
    if tmpHeader2 <> headNone then
    begin
      Result := true;
      A163HeadData.HeadNameIndex[tmpHeader2] := tmpInt + 1;
    end;
  end;
end;


function ParseData_163(A163Data: PRT_DealData_163; A163HeadData: PRT_DealData_Header163; AData: string; AParseDatas: TStringList): Boolean;
                       
  function Get163Int64Value(value: string): int64;
  var
    s: string;
    p: integer;
    s1: string;
    s2: string;
    v1: double;
  begin
    Result := 0;
    s := lowercase(value);
    if s <> '' then
    begin
      p := Pos('e+', s);
      if p > 0 then
      begin
        // '1.47514908121e+12'
        s1 := copy(s, 1, p - 1);
        s2 := copy(s, p + 2, maxint);
        v1 := StrToFloatDef(s1, 0);
        if v1 <> 0 then
        begin
          p := strtointdef(s2, 0);
          Result := 1;
          while p > 0 do
          begin
            Result := Result * 10;
            p := p - 1;
          end;
          Result := Round(Result * v1);
        end;
      end else
      begin
        p := Pos('.', s);
        if P > 0 then
        begin
          Result := StrToInt64Def(Copy(s, 1, p - 1), 0);
        end else
        begin
          Result := StrToInt64Def(s, 0);
        end;
      end;
    end;
  end;

  function GetParseTypeValue(AHeadNameType: TDealDayDataHeadName_163): string;
  begin
    Result := '';
    if A163HeadData.HeadNameIndex[AHeadNameType] > 0 then
      Result := AParseDatas[A163HeadData.HeadNameIndex[AHeadNameType] - 1];
  end;

var
  tmpstr: string;
  tmpDate: TDateTime;
  tmpInt: integer;
begin
  Result := false;
  tmpstr := StringReplace(AData, #9, '', [rfReplaceAll]);
  tmpstr := StringReplace(tmpstr, #13, '', [rfReplaceAll]);
  tmpstr := StringReplace(tmpstr, #10, '', [rfReplaceAll]);
  tmpstr := Trim(tmpstr);
  AParseDatas.Text := StringReplace(tmpstr, ',', #13#10, [rfReplaceAll]);
  tmpInt := Integer(High(TDealDayDataHeadName_163));
  if AParseDatas.Count >= tmpInt then
  begin
    tmpstr := GetParseTypeValue(headDay);
    TryStrToDate(tmpstr, tmpDate, A163HeadData.DateFormat_163);
    if tmpDate <> 0 then
    begin
      A163Data.Code := GetParseTypeValue(headCode);
      A163Data.Name := GetParseTypeValue(headName);
      A163Data.Name := StringReplace(A163Data.Name, #32, '', [rfReplaceAll]);
      A163Data.Day := Trunc(TmpDate);

      // price
      A163Data.Price_Close       := StrToFloatDef(GetParseTypeValue(headPrice_Close), 0);
      A163Data.Price_High        := StrToFloatDef(GetParseTypeValue(headPrice_High), 0);
      A163Data.Price_Low         := StrToFloatDef(GetParseTypeValue(headPrice_Low), 0);
      A163Data.Price_Open        := StrToFloatDef(GetParseTypeValue(headPrice_Open), 0);
      A163Data.Price_PrevClose   := StrToFloatDef(GetParseTypeValue(headPrice_PrevClose), 0);
      A163Data.Price_Change      := StrToFloatDef(GetParseTypeValue(headPrice_Change), 0);
      A163Data.Price_ChangeRate  := StrToFloatDef(GetParseTypeValue(headPrice_ChangeRate), 0);
      // deal
      A163Data.Deal_VolumeRate   := StrToFloatDef(GetParseTypeValue(headDeal_VolumeRate), 0);

      A163Data.Deal_Volume       := Get163Int64Value(GetParseTypeValue(headDeal_Volume));
      A163Data.Deal_Amount       := Get163Int64Value(GetParseTypeValue(headDeal_Amount));
      // value
      A163Data.Total_Value       := Get163Int64Value(GetParseTypeValue(headTotal_Value));
      A163Data.Deal_Value        := Get163Int64Value(GetParseTypeValue(headDeal_Value));
      
      Result := true;
    end;
  end;
end;

function ParseStockDataDay_163(ADataAccess: TStockDayDataAccess; AData: string): Boolean;
var 
  tmp163data: TRT_DealData_163;
  tmp163header: TRT_DealData_Header163;
  tmpRowDatas: TStringList;
  tmpParseDatas: TStringList;
  i: integer;
  tmpDealData: PRT_Quote_M1_Day;
  tmpIsCheckedName: Boolean;
begin
  Result := false;
  tmpIsCheckedName := false;
  FillChar(tmp163header, SizeOf(tmp163header), 0);
  tmpRowDatas := TStringList.Create;
  tmpParseDatas := TStringList.Create;
  try
    tmpRowDatas.Text := AData;
    if 1 < tmpRowDatas.Count then
    begin         
      for i := 0 to tmpRowDatas.Count - 1 do
      begin
        if 0 = tmp163header.IsReady then
        begin
          if ParseDataHeader_163(@tmp163header, tmpRowDatas[i], tmpParseDatas) then
          begin
            tmp163header.IsReady := 1;
            tmp163header.DateFormat_163.DateSeparator := '-';
            tmp163header.DateFormat_163.TimeSeparator := ':';            
            tmp163header.DateFormat_163.ListSeparator := ';';
            tmp163header.DateFormat_163.ShortDateFormat := 'yyyy-mm-dd';
            tmp163header.DateFormat_163.LongDateFormat := 'yyyy-mm-dd';
          end;
        end else
        begin
          if ParseData_163(@tmp163data, @tmp163header, tmpRowDatas[i], tmpParseDatas) then
          begin         
            Result := true;
            // 网易是倒叙排的 以最早的为准
            if not tmpIsCheckedName then
            begin
              tmpIsCheckedName := true;
              if tmp163data.Name <> ADataAccess.StockItem.Name  then
              begin
                ADataAccess.StockItem.Name := tmp163data.Name;
                ADataAccess.StockItem.IsDataChange := 1;
              end;
            end;
            
            if (0 < tmp163data.Day) and (tmp163data.Price_Low > 0) and (tmp163data.Price_High > 0) and
               (tmp163data.Deal_Amount > 0) and (tmp163data.Deal_Volume > 0) then
            begin
              tmpDealData := ADataAccess.CheckOutRecord(tmp163data.Day);
              if (nil <> tmpDealData) then
              begin
                SetRTPricePack(@tmpDealData.PriceRange.PriceHigh, tmp163data.Price_High);
                SetRTPricePack(@tmpDealData.PriceRange.PriceLow, tmp163data.Price_Low);
                SetRTPricePack(@tmpDealData.PriceRange.PriceOpen, tmp163data.Price_Open);
                SetRTPricePack(@tmpDealData.PriceRange.PriceClose, tmp163data.Price_Close);
                tmpDealData.DealVolume := tmp163data.Deal_Volume;
                tmpDealData.DealAmount := tmp163data.Deal_Amount;
                tmpDealData.TotalValue := tmp163data.Total_Value;
                tmpDealData.DealValue := tmp163data.Deal_Value;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    tmpRowDatas.Free;
    tmpParseDatas.Free;
  end;
  ADataAccess.Sort;
end;

function GetStockDataDay_163(App: TBaseApp; AStockItem: PRT_DealItem; ANetSession: PNetClientSession): Boolean;
var
  tmpStockDataAccess: TStockDayDataAccess;
  tmpUrl: string;
  tmpRetData: string;
  tmpLastDealDate: Word;
  tmpInt: integer;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  Result := false;
  tmpStockDataAccess := TStockDayDataAccess.Create(AStockItem, DataSrc_163);
  try
    tmpLastDealDate := Trunc(now());
    tmpInt := DayOfWeek(tmpLastDealDate);
    if 1 = tmpInt then
      tmpLastDealDate := tmpLastDealDate - 2;
    if 7 = tmpInt then
      tmpLastDealDate := tmpLastDealDate - 1;
                                     
    //LoadStockDayData(App, tmpStockDataAccess); 
    if CheckNeedLoadStockDayData(App, tmpStockDataAccess, tmpLastDealDate) then
    begin
      tmpUrl := Base163DayUrl1 + 'code=' + GetStockCode_163(AStockItem);
      if tmpStockDataAccess.LastDealDate > 0 then
      begin
        if tmpLastDealDate >= tmpStockDataAccess.LastDealDate + 1 then
        begin
          tmpUrl := tmpUrl +
            '&start=' + FormatDateTime('yyyymmdd', tmpStockDataAccess.LastDealDate + 1) +
            '&end=' + FormatDateTime('yyyymmdd', tmpLastDealDate) +
            '&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP';
        end else
        begin
          exit;
        end;
      end;
    end else
      exit;
    tmpRetData := GetHttpUrlData(tmpUrl, ANetSession);
    // parse result data
    if ParseStockDataDay_163(tmpStockDataAccess, tmpRetData) then
    begin        
      Result := true;
      SaveStockDayData(App, tmpStockDataAccess);
    end;     
    if 0 = AStockItem.FirstDealDate then
    begin
      if 0 < tmpStockDataAccess.RecordCount then
      begin
        tmpQuoteDay := tmpStockDataAccess.RecordItem[0];
        AStockItem.FirstDealDate := tmpQuoteDay.DealDateTime.Value;
        AStockItem.IsDataChange := 1;
      end;
    end;
  finally
    tmpStockDataAccess.Free;
  end;
end;

procedure GetStockDataDay_163_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  tmpIsNeedSaveStockItemDB: Boolean;
  tmpNetClientSession: TNetClientSession;
  i: integer;
begin
  FillChar(tmpNetClientSession, SizeOf(tmpNetClientSession), 0);
  tmpIsNeedSaveStockItemDB := false;
  tmpDBStockItem := TDBDealItem.Create;
  try
    //LoadDBStockItemIni(App, tmpDBStockItem1);
    //SaveDBStockItem(App, tmpDBStockItem1);
    //exit;
    LoadDBStockItem(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin              
        if 0 = tmpDBStockItem.Items[i].FirstDealDate then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
        tmpDBStockItem.Items[i].IsDataChange := 0;
        if GetStockDataDay_163(App, tmpDBStockItem.Items[i], @tmpNetClientSession) then
        begin
          Sleep(2000);
        end;                                      
        if 0 <> tmpDBStockItem.Items[i].IsDataChange then
        begin
          tmpIsNeedSaveStockItemDB := true;
        end;
      end;
    end;
    if tmpIsNeedSaveStockItemDB then
    begin
      SaveDBStockItem(App, tmpDBStockItem);
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
