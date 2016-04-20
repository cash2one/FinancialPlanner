unit TcpQuoteAgent;

interface

uses
  Windows,
  ThostFtdcBaseDataType,
  ThostFtdcMdApiDataType,
  define_price,
  define_ctp_quote;
  
type
  TTcpAgentQuoteConsoleData = record
    IsMDConnected: Boolean;
    IsMDLogined: Boolean;       
    //TCPAgentProcess: TExProcessA;
    SrvWND: HWND;         
    QuoteInstrumentIds: array[0..QuoteArraySize - 1] of AnsiString;
    QuoteArray: array[0..QuoteArraySize - 1] of TRT_QuoteData;
  end;
  
  TQuoteConsole = class
  protected
    fTcpAgentQuoteConsoleData: TTcpAgentQuoteConsoleData;
  public                   
    constructor Create; virtual;
    destructor Destroy; override;    
    //================================    
    function FindSrvWindow: Boolean;  
    //================================      
    procedure InitMD;
    procedure ConnectMD(Addr: AnsiString);
    procedure LoginMD(ABrokerId, Account, APassword: AnsiString);
    procedure MDSubscribe(AInstrumentId: AnsiString);
    procedure MDSaveAllQuote; 
    //================================
    function CheckOutQuoteData(AInstrumentId: AnsiString): PRT_QuoteData;
    //================================
    property SrvWND: HWND read fTcpAgentQuoteConsoleData.SrvWND;   
    property IsMDConnected: Boolean read fTcpAgentQuoteConsoleData.IsMDConnected write fTcpAgentQuoteConsoleData.IsMDConnected;
    property IsMDLogined: Boolean read fTcpAgentQuoteConsoleData.IsMDLogined write fTcpAgentQuoteConsoleData.IsMDLogined;
  end;
                
  function CheckOutQuoteDataRecords(ART_QuoteData: PRT_QuoteData): PRT_QuoteDataRecords;  
  procedure FtdcPrice2RTPricePack(APricePack: PRT_PricePack; APrice: TThostFtdcPriceType);    
  procedure MarketData2QuoteData(AMarketData: PhostFtdcDepthMarketDataField; ART_QuoteDataRecord: PRT_QuoteDataRecord);

implementation
               
uses
  Messages, Sysutils,
  TcpAgentConsole,
  define_app_msg;
  
{ TQuoteConsole }

function CheckOutQuoteDataRecords(ART_QuoteData: PRT_QuoteData): PRT_QuoteDataRecords;
begin
  Result := System.New(PRT_QuoteDataRecords);
  FillChar(Result^, SizeOf(TRT_QuoteDataRecords), 0);
  Windows.EnterCriticalSection(ART_QuoteData.PageLock);
  try
    if ART_QuoteData.FirstRecords = nil then
      ART_QuoteData.FirstRecords := Result;
    if ART_QuoteData.LastRecords <> nil then
    begin
      Result.PrevSibling := ART_QuoteData.LastRecords;
      ART_QuoteData.LastRecords.NextSibling := Result;
    end;
    ART_QuoteData.LastRecords := Result;
  finally
    Windows.LeaveCriticalSection(ART_QuoteData.PageLock);
  end;
end;
              
procedure FtdcPrice2RTPricePack(APricePack: PRT_PricePack; APrice: TThostFtdcPriceType);
begin
  try
    APricePack.Value := Trunc(APrice * 1000);
  except
    APricePack.Value := 0;  
  end;
end;

procedure MarketData2QuoteData(AMarketData: PhostFtdcDepthMarketDataField; ART_QuoteDataRecord: PRT_QuoteDataRecord);
begin                                    
    // 最新价
  FtdcPrice2RTPricePack(@ART_QuoteDataRecord.LastPrice, AMarketData.LastPrice);
    ///数量
  ART_QuoteDataRecord.Volume := AMarketData.Volume;  // 4 - 12
    ///成交金额
  ART_QuoteDataRecord.Turnover := AMarketData.Turnover; // 8 - 20
  // 持仓量
  ART_QuoteDataRecord.OpenInterest := AMarketData.OpenInterest; // 8 - 20
    ///申买价一
  FtdcPrice2RTPricePack(@ART_QuoteDataRecord.BidPrice1, AMarketData.BidPrice1);    ///
    ///申买量一
  ART_QuoteDataRecord.BidVolume1 := AMarketData.BidVolume1; // 4 - 32
    ///申卖价一
  FtdcPrice2RTPricePack(@ART_QuoteDataRecord.AskPrice1, AMarketData.AskPrice1); // 8 - 40
    ///申卖量一
  ART_QuoteDataRecord.AskVolume1 := AMarketData.AskVolume1; // 4 - 44 
    // 时间 ??? 
  ART_QuoteDataRecord.UpdateTime := 0; // 8 - 52  
    ///最后修改毫秒
  ART_QuoteDataRecord.UpdateMillisec := AMarketData.UpdateMillisec; // 4 - 56
    // 程序记录时间
  ART_QuoteDataRecord.RecordTime := Now(); // 8 - 64

  ART_QuoteDataRecord.UpdateTime2 := AMarketData.UpdateTime; // 9 - 81  
  ART_QuoteDataRecord.Status := 1;      // 1 -- 82
end;

constructor TQuoteConsole.Create;
begin
  FillChar(fTcpAgentQuoteConsoleData, SizeOf(fTcpAgentQuoteConsoleData), 0);
end;

destructor TQuoteConsole.Destroy;
begin

  inherited;
end;

function TQuoteConsole.FindSrvWindow: Boolean;
begin
  Result := false;
  if 0 <> fTcpAgentQuoteConsoleData.SrvWND then
  begin
    if not IsWindow(fTcpAgentQuoteConsoleData.SrvWND) then
    begin
      fTcpAgentQuoteConsoleData.SrvWND := 0;
    end else
    begin
      Result := true;
      exit;
    end;
  end;
  fTcpAgentQuoteConsoleData.SrvWND := FindWindow('Tftdc_api_srv', 'tcpagent');
  Result := (fTcpAgentQuoteConsoleData.SrvWND <> 0) and
            (fTcpAgentQuoteConsoleData.SrvWND <> INVALID_HANDLE_VALUE);
end;
 
procedure TQuoteConsole.InitMD;
begin
  GTcpAgentConsole.StartAgentProcess();
  if FindSrvWindow then
  begin                              
    //ApplicationSleepProcessMessage(50);
    PostMessage(SrvWND, WM_C2S_MD_RequestInitialize, 0, 0);
  end;
end;
              
procedure TQuoteConsole.ConnectMD(Addr: AnsiString);
var
  tmpCopyData: TCopyDataCommand;
begin
  if FindSrvWindow then
  begin
    //PostMessage(SrvWND, WM_C2S_RequestConnectFront, 0, 0);

    FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
    tmpCopyData.Base.dwData := WM_C2S_MD_RequestConnectFront;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @Addr[1], Length(Addr));

    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
  end;
end;

procedure TQuoteConsole.LoginMD(ABrokerId, Account, APassword: AnsiString);
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if FindSrvWindow then
  begin
    //PostMessage(SrvWND, WM_C2S_RequestUserLogin, 0, 0);   
    FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
    tmpCopyData.Base.dwData := WM_C2S_MD_RequestUserLogin;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;
    
    tmpAnsi := ABrokerId;
    CopyMemory(@tmpCopyData.CommonCommand.scmd3[0], @tmpAnsi[1], Length(tmpAnsi));
                                                                                     
    tmpAnsi := Account;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpAnsi := APassword;
    CopyMemory(@tmpCopyData.CommonCommand.scmd2[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpCopyData.CommonCommand.icmd1 := GTcpAgentConsole.CheckOutRequestId;
    
    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));

    //ApplicationSleepProcessMessage(1000);
    if GTcpAgentConsole.Deal.IsDealLogined then
    begin
      GTcpAgentConsole.Deal.ConfirmSettlementInfo;
    end;
  end;
end;

procedure TQuoteConsole.MDSaveAllQuote;
//var
//  i: integer;
//  tmpFileUrl: string;
begin
//  for i := 0 to Quote.QuoteCount - 1 do
//  begin
//    if Quote.QuoteCode[i] <> '' then
//    begin
//      tmpFileUrl := ExtractFilePath(ParamStr(0)) + 'q'+ Quote.QuoteCode[i] + '_' + FormatDateTime('yyyymmdd_hh', now) + '.ptc';
//      SaveQuoteData(Quote.QuoteData[i], tmpFileUrl);
//    end;
//  end;
end;

procedure TQuoteConsole.MDSubscribe(AInstrumentId: AnsiString);   
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if FindSrvWindow then
  begin
    //PostMessage(SrvWND, WM_C2S_SubscribeMarketData, 0, 0);
    FillChar(tmpCopyData, SizeOf(TCopyDataCommand), 0);
    tmpCopyData.Base.dwData := WM_C2S_SubscribeMarketData;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;

    tmpAnsi := AInstrumentId;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
  end;
end;

function TQuoteConsole.CheckOutQuoteData(AInstrumentId: AnsiString): PRT_QuoteData;
var
  i: integer;
begin
  Result := nil;
  for i := Low(fTcpAgentQuoteConsoleData.QuoteInstrumentIds) to High(fTcpAgentQuoteConsoleData.QuoteInstrumentIds) do
  begin       
    if fTcpAgentQuoteConsoleData.QuoteInstrumentIds[i] <> '' then
    begin
      if fTcpAgentQuoteConsoleData.QuoteInstrumentIds[i] = AInstrumentId then
      begin
        Result := @fTcpAgentQuoteConsoleData.QuoteArray[i];
        Break;
      end;
    end else
    begin
      fTcpAgentQuoteConsoleData.QuoteInstrumentIds[i] := AInstrumentId;  
      Result := @fTcpAgentQuoteConsoleData.QuoteArray[i];
      Break;
    end;
  end;
end;

end.
