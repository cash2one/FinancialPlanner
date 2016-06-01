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

function Parser_163Xls(App: TBaseApp; AStockItem: PRT_DealItem; AFileUrl: string): Boolean;
var
  tmpXls: TXLSWorkbook;
  tmpSheet: IXLSWorkSheet;
  tmpRowIdx: integer;
  tmpColIdx: integer;
  tmpCellText: WideString;
  tmpParse163: TRT_DealDetailData_HeaderSina;
  tmp163head: TDealDetailDataHeadName_163;
  tmpDetailData: TStockDetailDataAccess;
  tmpDetailRecord: PRT_Quote_M2;
  tmpQuote: TRT_Quote_M2;
begin
  Result := false;
  tmpXls := TXLSWorkbook.Create;
  try
    tmpXls.Open(AFileUrl);
    if nil <> tmpXls.WorkSheets then
    begin
      if 0 < tmpXls.WorkSheets.Count then
      begin
        try
          tmpSheet := tmpXls.WorkSheets.Entries[1];
          if nil <> tmpSheet then
          begin
            if '' <> tmpSheet.Name then
            begin
              if 0 < tmpSheet._RowInfo.RowCount then
              begin
                if nil <> tmpSheet.Cells then
                begin
                  FillChar(tmpParse163, SizeOf(tmpParse163), 0);     
                                        
                  tmpDetailData := TStockDetailDataAccess.Create(AStockItem, DataSrc_163);
                  try
                    for tmpRowIdx := 1 to tmpSheet._RowInfo.RowCount do
                    begin
                      if 0 = tmpParse163.IsReady then
                      begin       
                        for tmpColIdx := 1 to 6{tmpSheet._ColumnInfo.ColCount - 1} do
                        begin
                          tmpCellText := GetCellText(tmpSheet, tmpRowIdx, tmpColIdx);
                          if '' <> tmpCellText then
                          begin
                            for tmp163head := Low(TDealDetailDataHeadName_163) to High(TDealDetailDataHeadName_163) do
                            begin
                              if 0 < Pos(DealDetailDataHeadNames_163[tmp163head], tmpCellText) then
                              begin
                                tmpParse163.HeadNameIndex[tmp163head] := tmpColIdx;
                                tmpParse163.IsReady := 1;
                              end;
                            end;
                          end;
                        end;
                      end else
                      begin
                        FillChar(tmpQuote, SizeOf(tmpQuote), 0);
                        tmpCellText := GetCellText(tmpSheet, tmpRowIdx, tmpParse163.HeadNameIndex[headDealTime]); 
                        tmpQuote.DealTime.Value := tmpParse163.HeadNameIndex[headDealTime];
                        tmpQuote.Price.Value := tmpParse163.HeadNameIndex[headDealPrice];
                        //tmpParse163.HeadNameIndex[headDealPriceOffset]
                        tmpQuote.DealVolume := tmpParse163.HeadNameIndex[headDealVolume];
                        tmpQuote.DealAmount :=tmpParse163.HeadNameIndex[headDealAmount];
                        tmpQuote.DealType := tmpParse163.HeadNameIndex[headDealType];
                        if 0 < tmpQuote.DealTime.Value then
                        begin
                          tmpDetailRecord := tmpDetailData.CheckOutRecord(tmpQuote.DealTime.Value);
                          tmpDetailRecord^ := tmpQuote;
                        end;
                      end;
                    end;
                    SaveStockDetailData2File(App, tmpDetailData, ChangeFileExt(AFileUrl, '.sdet'));
                  finally
                    tmpDetailData.Free;
                  end;
                end;
              end;
            end;
          end;
        except
        end;
      end;
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
  tmpFileName2: AnsiString;  
  tmpFileExt: AnsiString; 
  tmpHttpHeadParse: THttpHeadParseSession;
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

  ADealDay := Trunc(EncodeDate(2016, 5, 17));
  // 2016/20160216/1002414.xls
  tmpUrl := Base163DetailUrl1 + FormatDateTime('yyyy', ADealDay) + '/' + FormatDateTime('yyyymmdd', ADealDay) + '/' + GetStockCode_163(AStockItem) + '.xls';
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
          tmpUrl := 'e:\' + GetStockCode_163(AStockItem) + '.xls';
          SaveHttpResponseToFile(tmpHttpData, @tmpHttpHeadParse, tmpUrl);
          if FileExists(tmpUrl) then
          begin
            Parser_163Xls(App, AStockItem, tmpUrl);
          end;
        end;
      end;
    finally
      CheckInIOBuffer(tmpHttpData);
    end;
  end;
end;

function GetStockDataDetail_163(App: TBaseApp; AStockDayAccess: TStockDayDataAccess; AHttpClientSession: PHttpClientSession): Boolean;
begin             
  Result := false;
//  Parser_163Xls('e:\0600000.xls');
//  Exit;
  if 0 < AStockDayAccess.LastDealDate then
  begin
    GetStockDayDetailData_163(App, AStockDayAccess.StockItem, AHttpClientSession, AStockDayAccess.LastDealDate);
  end;
end;

end.
