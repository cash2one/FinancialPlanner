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
  end;
  
  TDealConsole = class
  protected
    fTcpAgentDealConsoleData: TTcpAgentDealConsoleData;
  public                                   
    function FindSrvWindow: Boolean;  
    //================================  
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
    property SrvWND: HWND read fTcpAgentDealConsoleData.SrvWND;   
    property IsDealConnected: Boolean read fTcpAgentDealConsoleData.IsDealConnected write fTcpAgentDealConsoleData.IsDealConnected;
    property IsDealLogined: Boolean read fTcpAgentDealConsoleData.IsDealLogined write fTcpAgentDealConsoleData.IsDealLogined;
    property IsSettlementConfirmed: Boolean read fTcpAgentDealConsoleData.IsSettlementConfirmed write fTcpAgentDealConsoleData.IsSettlementConfirmed;
  end;

implementation

{ TDealConsole }

procedure TDealConsole.CancelDeal(ADeal: PDeal);
begin
end;

procedure TDealConsole.ChangeDealPwd(AOldPwd, ANewPwd: AnsiString);
begin
end;

function TDealConsole.CheckOutDeal: PDeal;
begin
  Result := nil;
end;

procedure TDealConsole.ConfirmSettlementInfo;
begin

end;

procedure TDealConsole.ConnectDeal(Addr: AnsiString);
begin

end;

function TDealConsole.FindSrvWindow: Boolean;
begin
  Result := false;
end;

procedure TDealConsole.InitDeal;
begin

end;

procedure TDealConsole.LoginDeal(ABrokerId, Account, APassword: AnsiString);
begin

end;

procedure TDealConsole.QueryMoney;
begin

end;

procedure TDealConsole.QueryUserHold(AInstrumentId: AnsiString);
begin

end;

procedure TDealConsole.RunDeal(ADeal: PDeal);
begin
end;

end.
