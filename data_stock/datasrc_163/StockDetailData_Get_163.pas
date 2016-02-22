unit StockDetailData_Get_163;

interface

uses
  BaseApp,
  Sysutils,
  UtilsHttp,   
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

  function GetStockDataDetail_163(App: TBaseApp; AStockItem: PRT_DealItem; AHttpClientSession: PHttpClientSession): Boolean;

implementation

uses
  Classes,
  define_dealstore_file,
  define_datasrc;
  
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

  // 2016/20160216/1002414.xls
  tmpUrl := Base163DetailUrl1 + FormatDateTime('yyyy', ADealDay) + '/' + FormatDateTime('yyyymmdd', ADealDay) + '/' + GetStockCode_163(AStockItem) + '.xls';
  tmpHttpData := GetHttpUrlData(tmpUrl, AHttpClientSession);
  if nil <> tmpHttpData then
  begin
    FillChar(tmpHttpHeadParse, SizeOf(tmpHttpHeadParse), 0);
    HttpBufferHeader_Parser(tmpHttpData, @tmpHttpHeadParse);
    if 0 < tmpHttpHeadParse.HeadEndPos then
    begin
    end;
  end;
end;

function GetStockDataDetail_163(App: TBaseApp; AStockItem: PRT_DealItem; AHttpClientSession: PHttpClientSession): Boolean;
begin             
  Result := false;
  GetStockDayDetailData_163(App, AStockItem, AHttpClientSession, Trunc(now) - 2);
end;

end.
