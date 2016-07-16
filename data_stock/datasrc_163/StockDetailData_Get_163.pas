unit StockDetailData_Get_163;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,
  StockDayDataAccess, 
  define_dealitem,
  win.iobuffer;

type
  TDealDetailDataHeadName_163 = (
    headNone,
    headDealTime,
    headDealPrice,
    headDealPriceOffset,
    headDealVolume,
    headDealAmount,
    headDealType); 
                   
  PRT_DealDetailData_HeaderSina = ^TRT_DealDetailData_HeaderSina;
  TRT_DealDetailData_HeaderSina = record
    IsReady         : Byte;          
    DateFormat_163 : Sysutils.TFormatSettings;
    HeadNameIndex   : array[TDealDetailDataHeadName_163] of SmallInt;
  end;
                   
const
  // 获取代码为sh600900，在2011-07-08的成交明细，数据为xls格式
  // http://quotes.money.163.com/cjmx/2016/20160216/1002414.xls
  Base163DetailUrl1 = 'http://quotes.money.163.com/cjmx/';
               
  DealDetailDataHeadNames_163: array[TDealDetailDataHeadName_163] of string = ('',
    '成交时间', '成交价', '价格变动',
    '成交量', '成交额', '性质');

  function GetStockDataDetail_163(App: TBaseApp; AStockDayAccess: TStockDayDataAccess; AHttpClientSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  nexcel,
  define_price,     
  UtilsLog,
  StockDetailDataAccess,
  StockDetailData_Save,
  define_stock_quotes,
  define_dealstore_file,
  define_datasrc;

function GetCellText(ASheet: IXLSWorkSheet; ARowIndex, AColIndex: integer): WideString;
var  
  tmpCell: IXLSRange;
begin
  Result := '';
  tmpCell := ASheet.Cells.Item[ARowIndex, AColIndex];
  if nil <> tmpCell then
  begin
    Result := tmpCell.Value;
  end;
end;

function DataParse_DetailData_163(App: TBaseApp; ADetailData: TStockDetailDataAccess; ADataStream: TStream): Boolean;
var
  tmpXls: TXLSWorkbook;
  tmpSheet: IXLSWorkSheet;
  tmpRowIdx: integer;
  tmpColIdx: integer;
  tmpParse163: TRT_DealDetailData_HeaderSina;
  tmp163head: TDealDetailDataHeadName_163;
                           
  tmpText: WideString;      
  tmpTimeIndex: integer;   
  tmpDetailData: PRT_Quote_M2; 
  tmpDealVolume: integer;   
  tmpDealAmount: integer;   
  tmpPrice: double;
begin
  Result := false;
  tmpXls := TXLSWorkbook.Create;
  try
    //tmpXls.Open(AFileUrl);
    tmpXls.Open(ADataStream);
    if nil = tmpXls.WorkSheets then
      exit;
    if 1 > tmpXls.WorkSheets.Count then
      exit;
    try
      tmpSheet := tmpXls.WorkSheets.Entries[1];
      if nil = tmpSheet then
        exit;
      if '' = tmpSheet.Name then
        exit;
      if 1 > tmpSheet._RowInfo.RowCount then
        exit;
      if nil = tmpSheet.Cells then
        exit;
      FillChar(tmpParse163, SizeOf(tmpParse163), 0);     
      for tmpRowIdx := 1 to tmpSheet._RowInfo.RowCount do
      begin
        if 0 = tmpParse163.IsReady then
        begin       
          for tmpColIdx := 1 to 6{tmpSheet._ColumnInfo.ColCount - 1} do
          begin
            tmpText := GetCellText(tmpSheet, tmpRowIdx, tmpColIdx);
            if '' <> tmpText then
            begin
              for tmp163head := Low(TDealDetailDataHeadName_163) to High(TDealDetailDataHeadName_163) do
              begin
                if 0 < Pos(DealDetailDataHeadNames_163[tmp163head], tmpText) then
                begin
                  tmpParse163.HeadNameIndex[tmp163head] := tmpColIdx;
                  tmpParse163.IsReady := 1;
                end;
              end;
            end;
          end;
        end else
        begin
          tmpText := GetCellText(tmpSheet, tmpRowIdx, tmpParse163.HeadNameIndex[headDealTime]); 
          tmpTimeIndex := GetDetailTimeIndex(tmpText); 
          if 0 < tmpTimeIndex then
          begin
            tmptext := GetCellText(tmpSheet, tmpRowIdx, tmpParse163.HeadNameIndex[headDealVolume]);
            tmpDealVolume := StrToIntDef(tmptext, 0);
            tmptext := GetCellText(tmpSheet, tmpRowIdx, tmpParse163.HeadNameIndex[headDealAmount]);
            tmpDealAmount := StrToIntDef(tmptext, 0);    
            if (0 < tmpDealVolume) and (0 < tmpDealAmount) then
            begin
              if 0 < ADetailData.FirstDealDate then
              begin
                if ADetailData.FirstDealDate = ADetailData.LastDealDate then
                begin
                  Result := true;
                  tmpDetailData := ADetailData.NewRecord(ADetailData.FirstDealDate, tmpTimeIndex);
                  if nil <> tmpDetailData then
                  begin
                    tmpText := GetCellText(tmpSheet, tmpRowIdx, tmpParse163.HeadNameIndex[headDealPrice]);
                    //tmpText := '18.9';
                    TryStrToFloat(tmptext, tmpPrice);
                    //tmpText := formatFloat('0.00',tmpText);
                    SetRTPricePack(@tmpDetailData.Price, tmpPrice);
                    tmpDetailData.DealVolume := tmpDealVolume;   
                    tmpDetailData.DealAmount := tmpDealAmount;
                    tmpText := GetCellText(tmpSheet, tmpRowIdx, tmpParse163.HeadNameIndex[headDealType]);
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
                        tmpDetailData.DealType := DealType_Neutral;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    except
    end;
  finally
    tmpXls.Free;
  end;
end;

function GetStockDayDetailData_163(App: TBaseApp; AStockItem: PRT_DealItem; AHttpClientSession: PHttpClientSession; ADealDay: Word): Boolean;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;  
  tmpFilePathRoot: AnsiString;
  tmpFilePathYear: AnsiString;
  tmpFileName: AnsiString;
  tmpFileExt: AnsiString; 
  tmpHttpHeadParse: THttpHeadParseSession;
  tmpStream: TMemoryStream;    
  tmpDetailData: TStockDetailDataAccess;
begin
  Result := false;
  tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_163, ADealDay, AStockItem);
  tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, DataSrc_163, ADealDay, AStockItem, '');  
  if FileExists(tmpFilePathYear + tmpFileName) then
  begin
    Result := true;
    exit;
  end;
  tmpFilePathRoot := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_163, 0, AStockItem);
  tmpFileExt := ExtractFileExt(tmpFileName);

  //ADealDay := Trunc(EncodeDate(2016, 6, 6));
  // 2016/20160216/1002414.xls
  tmpUrl := Base163DetailUrl1 + FormatDateTime('yyyy', ADealDay) + '/' + FormatDateTime('yyyymmdd', ADealDay) + '/' + GetStockCode_163(AStockItem) + '.xls';

  //Log('', 'Get Stock Detail:' + tmpUrl);  
  tmpHttpData := GetHttpUrlData(tmpUrl, AHttpClientSession);
  if nil <> tmpHttpData then
  begin
    try
      FillChar(tmpHttpHeadParse, SizeOf(tmpHttpHeadParse), 0);
      HttpBufferHeader_Parser(tmpHttpData, @tmpHttpHeadParse);
      if (199 < tmpHttpHeadParse.RetCode) and (300 > tmpHttpHeadParse.RetCode) then
      begin
        if 0 < tmpHttpHeadParse.HeadEndPos then
        begin
          tmpStream := TMemoryStream.Create;  
          tmpDetailData := TStockDetailDataAccess.Create(AStockItem, DataSrc_163);
          try               
            tmpDetailData.FirstDealDate := ADealDay;
            tmpDetailData.LastDealDate := ADealDay;      
            tmpStream.WriteBuffer(tmpHttpData.Data[tmpHttpHeadParse.HeadEndPos + 1], tmpHttpData.BufferHead.BufDataLength - tmpHttpHeadParse.HeadEndPos);
            try
              Result := DataParse_DetailData_163(App, tmpDetailData, tmpStream);
            except
            end;                
            tmpStream.Clear;
            if 0 < tmpDetailData.RecordCount then
            begin
              tmpDetailData.Sort;
              //Log('', 'GetStockDayDetailData_Sina ok' + AStockItem.sCode + ':' + FormatDateTime('yyyymmdd', ADealDay));
              SaveStockDetailData(App, tmpDetailData);
              Result := True;
            end;
          finally
            tmpStream.Free;
            tmpDetailData.Free;
          end;
          {
          tmpUrl := 'e:\' + GetStockCode_163(AStockItem) + '.xls';
          SaveHttpResponseToFile(tmpHttpData, @tmpHttpHeadParse, tmpUrl);
          if FileExists(tmpUrl) then
          begin
            Parser_163Xls(App, AStockItem, tmpUrl);
          end;
          }
        end;
      end;
    finally
      CheckInIOBuffer(tmpHttpData);
    end;
  end;
end;

function GetStockDataDetail_163(App: TBaseApp; AStockDayAccess: TStockDayDataAccess; AHttpClientSession: PHttpClientSession): Boolean;
var
  i: integer;               
  tmpFilePathYear: string;
  tmpFileName: string;
  tmpFileUrl: string;
  tmpLastDealDate: integer;
  tmpYear, tmpMonth, tmpDay: Word;
  tmpDealDay: PRT_Quote_M1_Day;
  tmpCount: integer;
begin             
  Result := false;
//  Parser_163Xls('e:\0600000.xls');
//  Exit;               
  //Log('', 'Get Stock Detail:' + AStockDayAccess.StockItem.sCode + ' last:' + FormatDateTime('yyyymmdd', AStockDayAccess.LastDealDate));
  if 0 < AStockDayAccess.LastDealDate then
  begin            
    AStockDayAccess.Sort;
    tmpCount :=0;
    tmpLastDealDate := 0;         
    for i := AStockDayAccess.RecordCount - 1 downto 0 do
    begin
      tmpDealDay := AStockDayAccess.RecordItem[i];
      if 1 > tmpDealDay.DealVolume then
        Continue;
      if 1 > tmpDealDay.DealAmount then
        Continue;
      if 5 < tmpCount then
        Break;
      DecodeDate(tmpDealDay.DealDate.Value, tmpYear, tmpMonth, tmpDay);
      if 2016 > tmpYear then
        Break;
      if 0 = tmpLastDealDate then
      begin
        tmpLastDealDate := tmpDealDay.DealDate.Value;
      end else
      begin
        if 14 < tmpLastDealDate - tmpDealDay.DealDate.Value then
          Break;
      end;
      tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_163, tmpDealDay.DealDate.Value, AStockDayAccess.StockItem);
      tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, DataSrc_163, tmpDealDay.DealDate.Value, AStockDayAccess.StockItem, '');   
      if '' <> tmpFileName then
      begin
        if not FileExists(tmpFilePathYear + tmpFileName) then
        begin          
          tmpFileUrl := ChangeFileExt(tmpFilePathYear + tmpFileName, '.sdet');
          if not FileExists(tmpFileUrl) then
          begin          
            //Log('', 'Get Stock Detail:' + tmpFileUrl);   
            if GetStockDayDetailData_163(App, AStockDayAccess.StockItem, AHttpClientSession, tmpDealDay.DealDate.Value) then
            begin
              if not Result then
                Result := True;
            end;
            Inc(tmpCount);
          end else
          begin
            Inc(tmpCount);
            Continue;
          end;
        end else
        begin
          Inc(tmpCount);
          Continue;
        end;
      end else
      begin
        Inc(tmpCount);
        Continue;
      end;
    end;
  end;
end;

end.
