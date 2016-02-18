unit StockInstantData_Get_Sina;

interface

uses                
  define_stock_quotes_instant,    
  UtilsHttp,
  BaseApp;
                                          
type
  PInstantArray = ^TInstantArray;
  TInstantArray = record
    Data: array[0..10 - 1] of PRT_InstantQuote;
  end;
                
  procedure GetStockDataReal_Sina_All(App: TBaseApp);         
  procedure DataGet_InstantArray_Sina(App: TBaseApp; AInstantArray: PInstantArray; ANetSession: PNetClientSession);

implementation

uses
  Sysutils,
  Classes,
  win.iobuffer,
  Define_Price,
  define_dealItem,
  define_datasrc,
  Define_DealStore_File,
  DB_DealItem,
  DB_DealItem_Load,
  StockInstantDataAccess;

const
  // 及时报价                                                       
  BaseSinaInstantUrl1 = 'http://hq.sinajs.cn/list='; // + sh601003,sh601001
  // 分钟线
  BaseSinaRealMinuteUrl1 = 'http://vip.stock.finance.sina.com.cn/quotes_service/view/vML_DataList.php?';
    //'asc=j&symbol=sh600100&num=240';
  
function DataParse_Instant_Sina(AInstant: PRT_InstantQuote; AResultData: string): Boolean;
var
  tmpRows: TStringList;
  tmpRowData: string;
  tmpRowStrs: TStringList;
  i: integer;
begin
  Result := False;     
  tmpRows := TStringList.Create;
  tmpRowStrs := TStringList.Create;
  try
    tmpRows.Text := AResultData;
    for i := 0 to tmpRows.Count - 1 do
    begin
      tmpRowData := Trim(tmpRows[i]);
      if '' <> tmpRowData then
      begin
        tmpRowStrs.text := StringReplace(tmpRowData, ',', #13#10, [rfReplaceAll]);
        if (31 < tmpRowStrs.Count) and (35 > tmpRowStrs.Count) then
        begin
          // 33
          if 0 < Pos(AInstant.item.scode, tmpRowStrs[0]) then
          begin
            trySetRTPricePack(@AInstant.PriceRange.PriceOpen, tmpRowStrs[1]);
            trySetRTPricePack(@AInstant.PriceRange.PriceClose, tmpRowStrs[3]);
            trySetRTPricePack(@AInstant.PriceRange.PriceHigh, tmpRowStrs[4]);
            trySetRTPricePack(@AInstant.PriceRange.PriceLow, tmpRowStrs[5]);
            AInstant.Volume := tryGetInt64Value(tmpRowStrs[8]);
            AInstant.Amount := tryGetInt64Value(tmpRowStrs[9]);
            // 2008-01-11
            //AInstant.Day := Trunc(StrToDateDef(tmpRowStrs[30], 0));
          end;
        end;
      end;
    end;
  finally
    tmpRows.Free;
    tmpRowStrs.Free;
  end;
end;
       
procedure DataGet_Instant_Sina(App: TBaseApp; AInstant: PRT_InstantQuote);
var  
  tmpUrl: string;
  tmpRetData: PIOBuffer;
  tmpHttpParse: THttpHeadParseSession;
begin
  tmpUrl := BaseSinaInstantUrl1 + GetStockCode_Sina(AInstant.Item);
  tmpRetData := GetHttpUrlData(tmpUrl, nil); 
  if nil <> tmpRetData then
  begin
    FillChar(tmpHttpParse, SizeOf(tmpHttpParse), 0);
    HttpBufferHeader_Parser(tmpRetData, @tmpHttpParse);
    if 200 = tmpHttpParse.RetCode then
    begin
      if 0 < tmpHttpParse.HeadEndPos  then
      begin
    // parse result data
        DataParse_Instant_Sina(AInstant, PAnsiChar(@PIOBufferX(tmpRetData).Data[tmpHttpParse.HeadEndPos + 1]));
      end;
    end;
  end;
end;

function DataParse_InstantArray_Sina(AInstantArray: PInstantArray; AResultData: string): Boolean;   
var
  tmpRows: TStringList;
  tmpRowData: string;
  tmpRowStrs: TStringList;
  i: integer;
  j: integer;
  tmpInstant: PRT_InstantQuote;
begin
  Result := False;     
  tmpRows := TStringList.Create;
  tmpRowStrs := TStringList.Create;
  try
    tmpRows.Text := AResultData;
    for i := 0 to tmpRows.Count - 1 do
    begin
      tmpRowData := Trim(tmpRows[i]);
      if '' <> tmpRowData then
      begin
        tmpRowStrs.text := StringReplace(tmpRowData, ',', #13#10, [rfReplaceAll]);
        if (31 < tmpRowStrs.Count) and (35 > tmpRowStrs.Count) then
        begin
          tmpInstant := nil;
          for j := Low(AInstantArray.Data) to High(AInstantArray.Data) do
          begin
            if nil <> AInstantArray.Data[j] then
            begin
              if 0 < Pos(AInstantArray.Data[j].item.scode, tmpRowStrs[0]) then
              begin
                tmpInstant := AInstantArray.Data[j];
              end;
            end;
          end;
          // 33
          if nil <> tmpInstant then
          begin
            if '' = tmpInstant.Item.Name then
            begin
              tmpRowData := tmpRowStrs[0];
              j := Pos('=', tmpRowData);
              if j > 0 then
              begin
                tmpRowData := Copy(tmpRowData, j + 1, maxint);
                tmpRowData := StringReplace(tmpRowData, '"', '', [rfReplaceAll]);
                tmpInstant.Item.Name := tmpRowData;
              end;
            end;
            trySetRTPricePack(@tmpInstant.PriceRange.PriceOpen, tmpRowStrs[1]);
            trySetRTPricePack(@tmpInstant.PriceRange.PriceClose, tmpRowStrs[3]);
            trySetRTPricePack(@tmpInstant.PriceRange.PriceHigh, tmpRowStrs[4]);
            trySetRTPricePack(@tmpInstant.PriceRange.PriceLow, tmpRowStrs[5]);
            tmpInstant.Volume := tryGetInt64Value(tmpRowStrs[8]);
            tmpInstant.Amount := tryGetInt64Value(tmpRowStrs[9]);
              // 2008-01-11
              //AInstant.Day := Trunc(StrToDateDef(tmpRowStrs[30], 0));
          end;
        end;
      end;
    end;
  finally
    tmpRows.Free;
    tmpRowStrs.Free;
  end;
end;

procedure DataGet_InstantArray_Sina(App: TBaseApp; AInstantArray: PInstantArray; ANetSession: PNetClientSession);
var  
  tmpUrl: string;
  tmpRetData: PIOBuffer;
  tmpHttpParse: THttpHeadParseSession;
  i: integer;
begin
  tmpUrl := '';
  for i := Low(AInstantArray.Data) to High(AInstantArray.Data) do
  begin
    if (nil <> AInstantArray.Data[i]) then
    begin
      if '' <> tmpUrl then
        tmpUrl := tmpUrl + ',';
      tmpUrl := tmpUrl + GetStockCode_Sina(AInstantArray.Data[i].Item);
    end;
  end;
  if '' <> tmpUrl then
  begin
    tmpUrl := BaseSinaInstantUrl1 + tmpUrl;
    tmpRetData := GetHttpUrlData(tmpUrl, ANetSession);
    if nil <> tmpRetData then
    begin
      FillChar(tmpHttpParse, SizeOf(tmpHttpParse), 0);
      HttpBufferHeader_Parser(tmpRetData, @tmpHttpParse);
      if 200 = tmpHttpParse.RetCode then
      begin
        if 0 < tmpHttpParse.HeadEndPos  then
        begin
          DataParse_InstantArray_Sina(AInstantArray, PAnsiChar(@PIOBufferX(tmpRetData).Data[tmpHttpParse.HeadEndPos + 1]));
        end;
      end;
    end;
  end;
end;

procedure GetStockDataReal_Sina_All(App: TBaseApp);
begin
end;

end.
