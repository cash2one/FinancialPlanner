unit StockDetailData_Get_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  StockDayDataAccess,
  define_dealitem,
  win.iobuffer;

type
  TDealDetailDataHeadName_Sina = (
    headNone,
    headDealTime,
    headDealPrice,
    headDealPriceOffset,
    headDealVolume,
    headDealAmount,
    headDealType); 
                 
  THeaderColumn = record      
    Col_DealTime    : Integer;
    Col_DealPrice   : Integer;
    Col_DealPriceOffset: Integer;
    Col_DealVolume  : Integer;
    Col_DealAmount  : Integer;
    Col_DealType    : Integer;
  end;
    
  PRT_DealDetailData_HeaderSina = ^TRT_DealDetailData_HeaderSina;
  TRT_DealDetailData_HeaderSina = record
    IsReady         : Byte;          
    DateFormat_Sina : Sysutils.TFormatSettings;
    HeadNameIndex   : array[TDealDetailDataHeadName_Sina] of SmallInt;
  end;
                   
const
  // 获取代码为sh600900，在2011-07-08的成交明细，数据为xls格式
  BaseSinaDetailUrl1 = 'http://market.finance.sina.com.cn/downxls.php?';

  // http://market.finance.sina.com.cn/downxls.php?date=2016-05-29&symbol=sh600000
  // http://market.finance.sina.com.cn/downxls.php?date=2016-05-30&symbol=sh601988
               
  DealDetailDataHeadNames_Sina: array[TDealDetailDataHeadName_Sina] of string = ('',
    '成交时间', '成交价', '价格变动',
    '成交量', '成交额', '性质');

  function GetStockDataDetail_Sina(App: TBaseApp; AStockDayAccess: TStockDayDataAccess; ANetSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  UtilsLog,
  define_dealstore_file,
  define_datasrc,
  define_price,  
  define_stock_quotes,
  StockDetailDataAccess,
  StockDetailData_Save;
                
function GetRowData(ADatas: TStringList; ARowIndex: Integer): string;
begin
  Result := '';
  if ADatas.Count > ARowIndex then
  begin
    if 0 <= ARowIndex then
    begin
      Result := Trim(ADatas[ARowIndex]);
    end;
  end;
end;
     
function DataParse_DetailData_Sina(ADetailData: TStockDetailDataAccess; ARetData: TStrings; ADealDay: Word): Boolean;
var                
  tmpIsFindHead: Boolean;
  tmpHeader: TRT_DealDetailData_HeaderSina;
  tmpCellDatas: TStringList;
  iRow: integer;
  iCol: integer;    
  tmpTimeIndex: integer;   
  tmpDetailData: PRT_Quote_M2;      
  tmpText: string;      
  tmpPrice: double;
  tmpDealVolume: integer;   
  tmpDealAmount: integer;
begin
  Result := false;
  FillChar(tmpHeader, SizeOf(tmpHeader), 0);  
  FillChar(tmpHeader.HeadNameIndex, SizeOf(tmpHeader.HeadNameIndex), -1);
  tmpCellDatas := TStringList.Create;
  try
    tmpIsFindHead := False; 
    for iRow := 0 to ARetData.Count - 1 do
    begin
      tmpCellDatas.Text :=  StringReplace(Trim(ARetData[iRow]), #9, #13#10, [rfReplaceAll]);
          
      if not tmpIsFindHead then
      begin
        for iCol := 0 to tmpCellDatas.Count - 1 do
        begin
          tmpText := Trim(tmpCellDatas[iCol]);
          if SameText('成交时间', tmpText) then
          begin            
            Result := true;
            tmpIsFindHead := true;
            tmpHeader.HeadNameIndex[headDealTime] := iCol;
          end;         
          if SameText('成交价', tmpText) then
          begin
            tmpIsFindHead := true;
            tmpHeader.HeadNameIndex[headDealPrice] := iCol;
          end;          
          if Pos('成交量', tmpText) > 0 then
          begin
            tmpIsFindHead := true;
            tmpHeader.HeadNameIndex[headDealVolume] := iCol;
          end;
          if Pos('成交额', tmpText) > 0 then
          begin
            tmpIsFindHead := true;
            tmpHeader.HeadNameIndex[headDealAmount] := iCol;
          end;       
          if SameText('性质', tmpText) then
          begin
            tmpIsFindHead := true;
            tmpHeader.HeadNameIndex[headDealType] := iCol;
          end;
        end;
      end else
      begin    
        tmpText := GetRowData(tmpCellDatas, tmpHeader.HeadNameIndex[headDealTime]);
        // 15:00:02 09:25:05
        tmpTimeIndex := GetDetailTimeIndex(tmpText);
        if 0 < tmpTimeIndex then
        begin                
          tmptext := GetRowData(tmpCellDatas, tmpHeader.HeadNameIndex[headDealVolume]);
          tmpDealVolume := StrToIntDef(tmptext, 0);
          tmptext := GetRowData(tmpCellDatas, tmpHeader.HeadNameIndex[headDealAmount]);
          tmpDealAmount := StrToIntDef(tmptext, 0);
          if (0 < tmpDealVolume) and (0 < tmpDealAmount) then
          begin
            Result := true;
            tmpDetailData := ADetailData.NewRecord(ADealDay, tmpTimeIndex);
            if nil <> tmpDetailData then
            begin
              tmpText := GetRowData(tmpCellDatas, tmpHeader.HeadNameIndex[headDealPrice]);
              //tmpText := '18.9';
              TryStrToFloat(tmptext, tmpPrice);
              //tmpText := formatFloat('0.00',tmpText);
              SetRTPricePack(@tmpDetailData.Price, tmpPrice);
              tmpDetailData.DealVolume := tmpDealVolume;   
              tmpDetailData.DealAmount := tmpDealAmount;
              tmpText := GetRowData(tmpCellDatas, tmpHeader.HeadNameIndex[headDealType]);
              if Pos('卖', tmpText) > 0 then
              begin
                tmpDetailData.DealType := DealType_Sale;
              end else
              begin
                if Pos('买', tmpText) > 0 then
                begin
                  tmpDetailData.DealType := DealType_Buy;
                end else
                begin
                  if Pos('中性', tmpText) > 0 then
                  begin
                    tmpDetailData.DealType := DealType_Neutral;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    tmpCellDatas.Free;
  end;
end;

function GetStockDayDetailData_Sina(App: TBaseApp; AStockItem: PRT_DealItem; ANetSession: PHttpClientSession; ADealDay: Word): Boolean;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;  
  tmpFilePathYear: AnsiString;
  tmpFileName: AnsiString;
  tmpHttpHeadParse: THttpHeadParseSession;  
  tmpRowDatas: TStringList;
  tmpDetailData: TStockDetailDataAccess;
begin
  Result := false;
  tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_Sina, ADealDay, AStockItem);
  tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, DataSrc_Sina, ADealDay, AStockItem, ''); 
  Log('', 'GetStockDayDetailData_Sina:' + tmpFilePathYear + tmpFileName + ':' + FormatDateTime('yyyymmdd', ADealDay)); 
  if FileExists(tmpFilePathYear + tmpFileName) then
  begin
    Result := true;
    exit;
  end;
  Log('', 'GetStockDayDetailData_Sina begin' + AStockItem.sCode + ':' + FormatDateTime('yyyymmdd', ADealDay));
    
  tmpUrl := BaseSinaDetailUrl1 + 'date=' + FormatDateTime('yyyy-mm-dd', ADealDay) + '&' + 'symbol=' + GetStockCode_Sina(AStockItem);
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession);
  if nil <> tmpHttpData then
  begin
    FillChar(tmpHttpHeadParse, SizeOf(tmpHttpHeadParse), 0);
    HttpBufferHeader_Parser(tmpHttpData, @tmpHttpHeadParse);
    if 0 < tmpHttpHeadParse.HeadEndPos then
    begin
      tmpRowDatas := TStringList.Create;   
      try
        tmpRowDatas.Text := AnsiString(@tmpHttpData.Data[tmpHttpHeadParse.HeadEndPos + 1]);
        //                           
        tmpDetailData := TStockDetailDataAccess.Create(AStockItem, DataSrc_Sina);
        try
          tmpDetailData.FirstDealDate := ADealDay;
          tmpDetailData.LastDealDate := ADealDay;          
          Result := DataParse_DetailData_Sina(tmpDetailData, tmpRowDatas, ADealDay);
          if 0 < tmpDetailData.RecordCount then
          begin
            tmpDetailData.Sort;
            Log('', 'GetStockDayDetailData_Sina ok' + AStockItem.sCode + ':' + FormatDateTime('yyyymmdd', ADealDay));
            SaveStockDetailData(App, tmpDetailData);
          end;
          //Sysutils.DeleteFile(tmpDownloadFileUrl);
        finally
          tmpDetailData.Free;
        end;
      finally
        tmpRowDatas.Free;
      end; 
    end;
  end;
end;

function GetStockDataDetail_Sina(App: TBaseApp; AStockDayAccess: TStockDayDataAccess; ANetSession: PHttpClientSession): Boolean;
var
  i: integer;
  tmpFilePathYear: string;
  tmpFileName: string;
  tmpYear, tmpMonth, tmpDay: Word;
  tmpDealDay: PRT_Quote_M1_Day;
begin             
  Result := false;
  if 0 < AStockDayAccess.LastDealDate then
  begin
    // Trunc(now) - 2
    AStockDayAccess.Sort;                      
    for i := AStockDayAccess.RecordCount - 1 downto 0 do
    begin
      tmpDealDay := AStockDayAccess.RecordItem[i];
      if 1 > tmpDealDay.DealVolume then
        Continue;
      if 1 > tmpDealDay.DealAmount then
        Continue;
      DecodeDate(tmpDealDay.DealDate.Value, tmpYear, tmpMonth, tmpDay);
      if 2016 > tmpYear then
        Break;
      tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_Sina, tmpDealDay.DealDate.Value, AStockDayAccess.StockItem);
      tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, DataSrc_Sina, tmpDealDay.DealDate.Value, AStockDayAccess.StockItem, '');
      if '' <> tmpFileName then
      begin
        if not FileExists(tmpFilePathYear + tmpFileName) then
        begin
          if not FileExists(ChangeFileExt(tmpFilePathYear + tmpFileName, '.sdet')) then
          begin           
            Result := true;
            GetStockDayDetailData_Sina(App, AStockDayAccess.StockItem, ANetSession, tmpDealDay.DealDate.Value);
            Sleep(100);
          end else
          begin
            //Break;
          end;
        end else
        begin
          //Break;
        end;
      end else
      begin
        //Break;
      end;
    end;
  end;
end;

end.
