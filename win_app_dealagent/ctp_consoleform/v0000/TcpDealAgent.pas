unit TcpDealAgent;

interface

uses
  Windows,
  define_ctp_deal;
  
type
  TTcpAgentDealConsoleData = record
    IsDealConnected: Boolean;
    IsDealLogined: Boolean;  
    IsSettlementConfirmed: Boolean;   
    //TCPAgentProcess: TExProcessA;
    SrvWND: HWND;
    //======================================      
    Index: Integer;           
    DealArray: array[0..300 - 1] of TDeal;              
    LastRequestDeal: PDeal;                
    //======================================  
  end;
  
  TDealConsole = class
  protected
    fTcpAgentDealConsoleData: TTcpAgentDealConsoleData;
  public                   
    constructor Create; virtual;
    destructor Destroy; override;
    //======================================
    function FindSrvWindow: Boolean;        
    //======================================
    procedure InitDeal;
    procedure ConnectDeal(Addr: AnsiString);
    procedure LoginDeal(ABrokerId, Account, APassword: AnsiString);
    procedure ChangeDealPwd(AOldPwd, ANewPwd: AnsiString);
    procedure ConfirmSettlementInfo;
    procedure QueryMoney;
    procedure QueryUserHold(AInstrumentId: AnsiString);
    //================================
    function CheckOutDeal: PDeal;    
    procedure RunDeal(ADeal: PDeal);      
    procedure CancelDeal(ADeal: PDeal);
    //================================    
    function FindDealByRequestId(ARequestId: Integer): PDeal;   
    function FindDealByOrderSysId(AOrderSysId: AnsiString): PDeal; 
    function FindDealByBrokerOrderSeq(ABrokerOrderSeq: Integer): PDeal;   
    
    property SrvWND: HWND read fTcpAgentDealConsoleData.SrvWND;   
    property IsDealConnected: Boolean read fTcpAgentDealConsoleData.IsDealConnected write fTcpAgentDealConsoleData.IsDealConnected;
    property IsDealLogined: Boolean read fTcpAgentDealConsoleData.IsDealLogined write fTcpAgentDealConsoleData.IsDealLogined;
    property IsSettlementConfirmed: Boolean read fTcpAgentDealConsoleData.IsSettlementConfirmed write fTcpAgentDealConsoleData.IsSettlementConfirmed;
  end;

implementation

uses
  Messages, Sysutils,
  TcpAgentConsole,
  define_app_msg;
  
{ TDealConsole }

constructor TDealConsole.Create;
begin
  FillChar(fTcpAgentDealConsoleData, SizeOf(fTcpAgentDealConsoleData), 0);
end;

destructor TDealConsole.Destroy;
begin

  inherited;
end;

function TDealConsole.FindSrvWindow: Boolean;
begin
  Result := false;
  if 0 <> fTcpAgentDealConsoleData.SrvWND then
  begin
    if not IsWindow(fTcpAgentDealConsoleData.SrvWND) then
    begin
      fTcpAgentDealConsoleData.SrvWND := 0;
    end else
    begin
      Result := true;
      exit;
    end;
  end;
  fTcpAgentDealConsoleData.SrvWND := FindWindow('Tftdc_api_srv', 'tcpagent');
  Result := (fTcpAgentDealConsoleData.SrvWND <> 0) and
            (fTcpAgentDealConsoleData.SrvWND <> INVALID_HANDLE_VALUE);
end;

procedure TDealConsole.InitDeal;
begin
  GTcpAgentConsole.StartAgentProcess();
  if FindSrvWindow then
  begin                   
    //ApplicationSleepProcessMessage(50);
    PostMessage(fTcpAgentDealConsoleData.SrvWND, WM_C2S_Deal_RequestInitialize, 0, 0);
  end;
end;

procedure TDealConsole.ConnectDeal(Addr: AnsiString); 
var
  tmpCopyData: TCopyDataCommand;
begin
  if FindSrvWindow then
  begin
    //PostMessage(SrvWND, WM_C2S_RequestConnectFront, 0, 0);    
    FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
    tmpCopyData.Base.dwData := WM_C2S_Deal_RequestConnectFront;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @Addr[1], Length(Addr));
    
    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
  end;
end;

procedure TDealConsole.LoginDeal(ABrokerId, Account, APassword: AnsiString);
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  
  if FindSrvWindow then
  begin
    //PostMessage(SrvWND, WM_C2S_RequestUserLogin, 0, 0);   
    FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
    tmpCopyData.Base.dwData := WM_C2S_Deal_RequestUserLogin;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;

    tmpAnsi := ABrokerId;
    //G_BrokerId := tmpAnsi;
    CopyMemory(@tmpCopyData.CommonCommand.scmd3[0], @tmpAnsi[1], Length(tmpAnsi));
                                                                                     
    tmpAnsi := Account;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpAnsi := APassword;
    CopyMemory(@tmpCopyData.CommonCommand.scmd2[0], @tmpAnsi[1], Length(tmpAnsi));
    
    tmpCopyData.CommonCommand.icmd1 := GTcpAgentConsole.CheckOutRequestId;
    
    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
                          
    //ApplicationSleepProcessMessage(500);
  end;

end;
                
procedure TDealConsole.ConfirmSettlementInfo;
begin
  if FindSrvWindow then
  begin
    SendMessage(SrvWND, WM_C2S_RequestSettlementInfoConfirm, GTcpAgentConsole.CheckOutRequestId, 0);
  end;
end;

procedure TDealConsole.ChangeDealPwd(AOldPwd, ANewPwd: AnsiString);
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if FindSrvWindow then
  begin  
    FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
    tmpCopyData.Base.dwData := WM_C2S_Deal_RequestChangeDealPwd;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;
                                                                                 
    tmpAnsi := AOldPwd;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpAnsi := ANewPwd;
    CopyMemory(@tmpCopyData.CommonCommand.scmd2[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpCopyData.CommonCommand.icmd1 := GTcpAgentConsole.CheckOutRequestId;

    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
  end;
end;
                          
procedure TDealConsole.QueryUserHold(AInstrumentId: AnsiString);
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if AInstrumentId = '' then
    exit;
  if FindSrvWindow then
  begin
    FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
    tmpCopyData.Base.dwData := WM_C2S_RequestQueryHold;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;
    
    tmpAnsi := AInstrumentId;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpCopyData.CommonCommand.icmd1 := GTcpAgentConsole.CheckOutRequestId;

    SendMessage(SrvWND, WM_COPYDATA,0, LongWord(@tmpCopyData));
  end;
end;
                  
procedure TDealConsole.QueryMoney;
begin
  if FindSrvWindow then
  begin
    SendMessage(SrvWND, WM_C2S_RequestQueryMoney, GTcpAgentConsole.CheckOutRequestId, 0);
  end;
end;
             
function TDealConsole.CheckOutDeal: PDeal;
begin
//  Result := System.New(PDeal);
//  FillChar(Result^, SizeOf(TDeal), 0);
  Result := @fTcpAgentDealConsoleData.DealArray[fTcpAgentDealConsoleData.Index];
  Inc(fTcpAgentDealConsoleData.Index);
end;
            
procedure TDealConsole.RunDeal(ADeal: PDeal);
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if ADeal = nil then
    exit;
  if ADeal.Status = deal_Invalid then
    ADeal.Status := deal_Open;
  fTcpAgentDealConsoleData.LastRequestDeal := ADeal;
  ADeal.OrderRequest.RequestId := GTcpAgentConsole.CheckOutRequestId;
  if ADeal.OrderRequest.Price > 0 then
  begin
    if ADeal.OrderRequest.Num > 0 then
    begin
      FillChar(tmpCopyData, SizeOf(tmpCopyData), 0);
      tmpCopyData.CommonCommand.fcmd1 := ADeal.OrderRequest.Price;// StrToFloatDef(edtPrice.text, 0);
      tmpCopyData.CommonCommand.icmd2 := ADeal.OrderRequest.Num;//StrToIntDef(edtNum.text, 0);

      if ADeal.OrderRequest.Direction = directionBuy then
        tmpCopyData.CommonCommand.icmd1 := 0;//StrToInt(THOST_FTDC_D_Buy); // Âò
      if ADeal.OrderRequest.Direction = directionSale then
        tmpCopyData.CommonCommand.icmd1 := 1;// StrToInt(THOST_FTDC_D_Sell); // Âô
                                             
      if ADeal.OrderRequest.Mode = modeOpen then
        tmpCopyData.CommonCommand.icmd3 := 0;//StrToInt(THOST_FTDC_OF_Open); // ¿ª²Ö
      if ADeal.OrderRequest.Mode = modeCloseOut then
        tmpCopyData.CommonCommand.icmd3 := 1;//StrToInt(THOST_FTDC_OF_Close); // Æ½²Ö
      if ADeal.OrderRequest.Mode = modeCloseNow then
        tmpCopyData.CommonCommand.icmd3 := 3;//StrToInt(THOST_FTDC_OF_CloseToday); // Æ½²Ö

      tmpCopyData.CommonCommand.icmd4 := ADeal.OrderRequest.RequestId;

      //tmpAnsi := G_BrokerId;
      //CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

      tmpAnsi := Trim(ADeal.OrderRequest.InstrumentID);
      CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));
                                       
      tmpCopyData.Base.dwData := WM_C2S_RequestOrder;   
      tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
      tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;
      SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
    end;
  end;
end;

procedure TDealConsole.CancelDeal(ADeal: PDeal); 
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if ADeal.CancelRequest = nil then
  begin
    ADeal.CancelRequest := System.New(PDealCancelRequest);
    FillChar(ADeal.CancelRequest^, SizeOf(TDealCancelRequest), 0);
                                                      
    tmpCopyData.CommonCommand.icmd1 := ADeal.BrokerOrderSeq; 
    tmpCopyData.CommonCommand.icmd2 := GTcpAgentConsole.CheckOutRequestId; 

    tmpAnsi := ADeal.ExchangeID;
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    tmpAnsi := ADeal.OrderSysID;
    CopyMemory(@tmpCopyData.CommonCommand.scmd2[0], @tmpAnsi[1], Length(tmpAnsi));
    
    tmpCopyData.Base.dwData := WM_C2S_RequestCancelOrder;
    SendMessage(SrvWND, WM_COPYDATA, 0, LongWord(@tmpCopyData));
  end;
end;

function TDealConsole.FindDealByOrderSysId(AOrderSysId: AnsiString): PDeal;    
var
  i: integer;
begin
  Result := nil;
  for i := 0 to fTcpAgentDealConsoleData.Index - 1 do
  begin
    if fTcpAgentDealConsoleData.DealArray[i].Status <> deal_Invalid then
    begin
      if fTcpAgentDealConsoleData.DealArray[i].OrderSysID = AOrderSysId then
      begin
        Result := @fTcpAgentDealConsoleData.DealArray[i];
        Break;
      end;
    end;
  end;
end;

function TDealConsole.FindDealByBrokerOrderSeq(ABrokerOrderSeq: Integer): PDeal;
var
  i: integer;
begin
  Result := nil;
  if ABrokerOrderSeq = 0 then
    exit;
  for i := fTcpAgentDealConsoleData.Index - 1 downto 0 do
  begin
    if fTcpAgentDealConsoleData.DealArray[i].Status <> deal_Invalid then
    begin
      if fTcpAgentDealConsoleData.DealArray[i].BrokerOrderSeq = ABrokerOrderSeq then
      begin
        Result := @fTcpAgentDealConsoleData.DealArray[i];
        Break;
      end;
    end;
  end;
end;

function TDealConsole.FindDealByRequestId(ARequestId: Integer): PDeal;
var
  i: integer;
begin
  Result := nil;
  if ARequestId = 0 then
    exit;
  for i := 0 to fTcpAgentDealConsoleData.Index - 1 do
  begin
    if fTcpAgentDealConsoleData.DealArray[i].Status <> deal_Invalid then
    begin
      if fTcpAgentDealConsoleData.DealArray[i].OrderRequest.RequestId = ARequestId then
      begin
        Result := @fTcpAgentDealConsoleData.DealArray[i];
        Break;
      end;
    end;
  end;
end;

end.
