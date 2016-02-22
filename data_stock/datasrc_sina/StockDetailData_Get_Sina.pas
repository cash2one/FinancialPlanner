unit StockDetailData_Get_Sina;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,   
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
                   
  PRT_DealDetailData_HeaderSina = ^TRT_DealDetailData_HeaderSina;
  TRT_DealDetailData_HeaderSina = record
    IsReady         : Byte;          
    DateFormat_Sina : Sysutils.TFormatSettings;
    HeadNameIndex   : array[TDealDetailDataHeadName_Sina] of SmallInt;
  end;
                   
const
  // 获取代码为sh600900，在2011-07-08的成交明细，数据为xls格式
  BaseSinaDetailUrl1 = 'http://market.finance.sina.com.cn/downxls.php?';
               
  DealDetailDataHeadNames_Sina: array[TDealDetailDataHeadName_Sina] of string = ('',
    '成交时间', '成交价', '价格变动',
    '成交量', '成交额', '性质');

  function GetStockDataDetail_Sina(App: TBaseApp; AStockItem: PRT_DealItem; ANetSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  define_dealstore_file,
  define_datasrc;
  
function GetStockDayDetailData_Sina(App: TBaseApp; AStockItem: PRT_DealItem; ANetSession: PHttpClientSession; ADealDay: Word): Boolean;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;  
  tmpFilePathRoot: AnsiString;
  tmpFilePathYear: AnsiString;
  tmpFileName: AnsiString;
  tmpFileName2: AnsiString;  
  tmpFileExt: AnsiString; 
  tmpHttpHeadParse: THttpHeadParseSession;  
  tmpRowDatas: TStringList;
  tmpCellDatas: TStringList;
  tmpIsFindHead: Boolean;
  iRow: integer;
  iCol: integer;
  tmpText: string;
  tmpHeader: TRT_DealDetailData_HeaderSina;
begin
  Result := false;
  tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_Sina, ADealDay, AStockItem);
  tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, DataSrc_Sina, ADealDay, AStockItem, '');  
  if FileExists(tmpFilePathYear + tmpFileName) then
  begin
    Result := true;
    exit;
  end;
  tmpFilePathRoot := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_Sina, 0, AStockItem);
  tmpFileExt := ExtractFileExt(tmpFileName);
  
  tmpUrl := BaseSinaDetailUrl1 + 'date=' + FormatDateTime('yyyy-mm-dd', ADealDay) + '&' + 'symbol=' + GetStockCode_Sina(AStockItem);
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession);
  if nil <> tmpHttpData then
  begin
    FillChar(tmpHttpHeadParse, SizeOf(tmpHttpHeadParse), 0);
    HttpBufferHeader_Parser(tmpHttpData, @tmpHttpHeadParse);
    if 0 < tmpHttpHeadParse.HeadEndPos then
    begin
      tmpRowDatas := TStringList.Create;     
      tmpCellDatas := TStringList.Create;
      try
        tmpRowDatas.Text := AnsiString(@tmpHttpData.Data[tmpHttpHeadParse.HeadEndPos + 1]);
        //
        FillChar(tmpHeader, SizeOf(tmpHeader), 0);  
        FillChar(tmpHeader.HeadNameIndex, SizeOf(tmpHeader.HeadNameIndex), -1);
        tmpIsFindHead := False;
        for iRow := 0 to tmpRowDatas.Count - 1 do
        begin
          tmpCellDatas.Text :=  StringReplace(Trim(tmpRowDatas[iRow]), #9, #13#10, [rfReplaceAll]);
          
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
          end;
        end;
      finally
        tmpRowDatas.Free;
        tmpCellDatas.Free;
      end; 
    end;
  end;
end;

function GetStockDataDetail_Sina(App: TBaseApp; AStockItem: PRT_DealItem; ANetSession: PHttpClientSession): Boolean;
begin             
  Result := false;
  GetStockDayDetailData_Sina(App, AStockItem, ANetSession, Trunc(now) - 2);
end;

end.
