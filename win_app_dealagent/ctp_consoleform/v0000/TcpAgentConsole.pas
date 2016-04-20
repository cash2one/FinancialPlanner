unit TcpAgentConsole;

interface

uses
  Windows,
  TcpDealAgent,
  TcpQuoteAgent;
                  
type
  TTcpAgentConsoleData = record
    Deal: TDealConsole;
    Quote: TQuoteConsole;
    //TCPAgentProcess: TExProcessA;
    SrvWND: HWND;
    RequestId: Integer;
    
    IsMDConnected: Boolean;
    IsDealConnected: Boolean;
    IsMDLogined: Boolean;
    IsDealLogined: Boolean;
    IsSettlementConfirmed: Boolean;
  end;
  
  TTcpAgentConsole = class
  protected
    fTcpAgentConsoleData: TTcpAgentConsoleData;
  public                               
    constructor Create;
    destructor Destroy; override;      
    procedure StartAgentProcess;    
    function FindSrvWindow: Boolean;  
    function CheckOutRequestId: Integer;    
    procedure LoadGlobalRequestId;
    procedure SaveGlobalRequestId;    
    property SrvWND: HWND read fTcpAgentConsoleData.SrvWND;
    property IsSettlementConfirmed: Boolean read fTcpAgentConsoleData.IsSettlementConfirmed
        write fTcpAgentConsoleData.IsSettlementConfirmed;
    // ------------------------------------
    procedure InitDeal;
    procedure ConnectDeal(Addr: AnsiString);
    procedure LoginDeal(ABrokerId, Account, APassword: AnsiString);
    procedure ChangeDealPwd(AOldPwd, ANewPwd: AnsiString);
    procedure ConfirmSettlementInfo;
    procedure QueryMoney;
    procedure QueryUserHold(AInstrumentId: AnsiString);
    property Deal: TDealConsole read fTcpAgentConsoleData.Deal;
    property IsDealConnected: Boolean read fTcpAgentConsoleData.IsDealConnected write fTcpAgentConsoleData.IsDealConnected;    
    property IsDealLogined: Boolean read fTcpAgentConsoleData.IsDealLogined write fTcpAgentConsoleData.IsDealLogined;    
  public
    // ------------------------------------
    procedure InitMD;
    procedure ConnectMD(Addr: AnsiString);
    procedure LoginMD(ABrokerId, Account, APassword: AnsiString);
    procedure MDSubscribe(AInstrumentId: AnsiString);
    procedure MDSaveAllQuote;                
    property Quote: TQuoteConsole read fTcpAgentConsoleData.Quote; 
    property IsMDConnected: Boolean read fTcpAgentConsoleData.IsMDConnected write fTcpAgentConsoleData.IsMDConnected;
    property IsMDLogined: Boolean read fTcpAgentConsoleData.IsMDLogined write fTcpAgentConsoleData.IsMDLogined; 
  end;
  
var
  GTcpAgentConsole: TTcpAgentConsole = nil;
  //G_BrokerId: AnsiString = '';
  
implementation

{ TTcpAgentConsole }

procedure TTcpAgentConsole.ChangeDealPwd(AOldPwd, ANewPwd: AnsiString);
begin

end;

function TTcpAgentConsole.CheckOutRequestId: Integer;
begin

end;

procedure TTcpAgentConsole.ConfirmSettlementInfo;
begin

end;

procedure TTcpAgentConsole.ConnectDeal(Addr: AnsiString);
begin

end;

procedure TTcpAgentConsole.ConnectMD(Addr: AnsiString);
begin

end;

constructor TTcpAgentConsole.Create;
begin

end;

destructor TTcpAgentConsole.Destroy;
begin

  inherited;
end;

function TTcpAgentConsole.FindSrvWindow: Boolean;
begin

end;

procedure TTcpAgentConsole.InitDeal;
begin

end;

procedure TTcpAgentConsole.InitMD;
begin

end;

procedure TTcpAgentConsole.LoadGlobalRequestId;
begin

end;

procedure TTcpAgentConsole.LoginDeal(ABrokerId, Account, APassword: AnsiString);
begin

end;

procedure TTcpAgentConsole.LoginMD(ABrokerId, Account, APassword: AnsiString);
begin

end;

procedure TTcpAgentConsole.MDSaveAllQuote;
begin

end;

procedure TTcpAgentConsole.MDSubscribe(AInstrumentId: AnsiString);
begin

end;

procedure TTcpAgentConsole.QueryMoney;
begin

end;

procedure TTcpAgentConsole.QueryUserHold(AInstrumentId: AnsiString);
begin

end;

procedure TTcpAgentConsole.SaveGlobalRequestId;
begin

end;

procedure TTcpAgentConsole.StartAgentProcess;
begin

end;

end.
