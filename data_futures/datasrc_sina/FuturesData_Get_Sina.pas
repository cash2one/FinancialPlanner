unit FuturesData_Get_Sina;

interface
             
uses
  BaseApp,
  Sysutils,
  UtilsHttp,  
  define_dealitem,
  win.iobuffer;
       
const            
  BaseSinaFuturesInstantDataUrl = 'http://hq.sinajs.cn/list=';  //http://hq.sinajs.cn/list=CFF_RE_IF1603
  { var hq_str_CFF_RE_IF1603="2890.2,2917.6,2890.2,2917.4,732,638026000,14061,0.0,,3153.4,2580.2,,,2879.4,2866.8,14291,0,0,
        --,--,--,--,--,--,--,--,0,0,--,--,--,--,--,--,--,--,
        2016-02-04,09:51:00,0,2,2906.600,2743.000,3069.000,2743.000,3341.800,2743.000,3768.000,2743.000,104.037"; }

  BaseSinaFuturesData5MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine5m?symbol='; // IF1603
  BaseSinaFuturesData15MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine15m?symbol=';// IF1606
  BaseSinaFuturesData30MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine30m?symbol=';// IF1606  
  BaseSinaFuturesData60MinUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesMiniKLine60m?symbol=';// IF1606
  { ["2016-02-03 15:15:00","2719.000","2749.800","2716.200","2746.000","91"] }

  BaseSinaFuturesDayUrl = 'http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFuturesDailyKLine?symbol=';//IF1606
  { ["2015-10-19","3177","3219.8","3106.2","3131.2","107"] }
                     
  function GetFuturesData_Sina_5m(App: TBaseApp; ADealItem: PRT_DealItem; ANetSession: PNetClientSession): Boolean;

implementation

uses
  Classes;
//function GetFuturesData_Sina(App: TBaseApp; AUrl: string; ANetSession: PNetClientSession): Boolean;
//begin
//end;

function ParseFuturesData_Sina(AHttpData: PIOBuffer): Boolean;
var
  tmpHttpHeadParse: THttpHeadParseSession;
  tmpData: AnsiString;
  tmpRowDatas: TStringList;
  i: integer;
begin
  Result := false;
  if nil = AHttpData then
    Exit;
  FillChar(tmpHttpHeadParse, SizeOf(tmpHttpHeadParse), 0);
  HttpBufferHeader_Parser(AHttpData, @tmpHttpHeadParse);
  if 0 < tmpHttpHeadParse.HeadEndPos then
  begin
    tmpData := PAnsiChar(@AHttpData.Data[tmpHttpHeadParse.HeadEndPos + 1]);   
    tmpRowDatas := TStringList.Create;
    try
      tmpRowDatas.Text := StringReplace(tmpData, ']', #13#10, [rfReplaceAll]);
      for i := 0 to tmpRowDatas.Count - 1 do
      begin
        tmpData := StringReplace(tmpRowDatas[i], '[', '', [rfReplaceAll]);
        if '' <> tmpData then
        begin
          Result := true;
        end;
      end;
    finally
      tmpRowDatas.Free;
    end;
  end;
end;

function GetFuturesData_Sina_5m(App: TBaseApp; ADealItem: PRT_DealItem; ANetSession: PNetClientSession): Boolean;
var
  tmpUrl: string;
  tmpHttpData: PIOBuffer;
begin
  Result := false;
  tmpUrl := BaseSinaFuturesData5MinUrl + ADealItem.sCode;
  tmpHttpData := GetHttpUrlData(tmpUrl, ANetSession);
  if nil <> tmpHttpData then
  begin
    ParseFuturesData_Sina(tmpHttpData);
  end;
end;

end.
