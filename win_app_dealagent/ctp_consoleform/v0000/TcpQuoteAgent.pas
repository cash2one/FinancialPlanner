unit TcpQuoteAgent;

interface

uses
  Windows;
  
type
  TTcpAgentQuoteConsoleData = record
    IsMDConnected: Boolean;
    IsMDLogined: Boolean;       
    //TCPAgentProcess: TExProcessA;
    SrvWND: HWND;
  end;
  
  TQuoteConsole = class
  protected
    fTcpAgentQuoteConsoleData: TTcpAgentQuoteConsoleData;
  public             
    function FindSrvWindow: Boolean;  
    //================================      
    procedure InitMD;
    procedure ConnectMD(Addr: AnsiString);
    procedure LoginMD(ABrokerId, Account, APassword: AnsiString);
    procedure MDSubscribe(AInstrumentId: AnsiString);
    procedure MDSaveAllQuote; 
    //================================     
    property SrvWND: HWND read fTcpAgentQuoteConsoleData.SrvWND;   
    property IsMDConnected: Boolean read fTcpAgentQuoteConsoleData.IsMDConnected write fTcpAgentQuoteConsoleData.IsMDConnected;
    property IsMDLogined: Boolean read fTcpAgentQuoteConsoleData.IsMDLogined write fTcpAgentQuoteConsoleData.IsMDLogined;
  end;

implementation

{ TQuoteConsole }

procedure TQuoteConsole.ConnectMD(Addr: AnsiString);
begin

end;

function TQuoteConsole.FindSrvWindow: Boolean;
begin
  Result := false;
end;

procedure TQuoteConsole.InitMD;
begin

end;

procedure TQuoteConsole.LoginMD(ABrokerId, Account, APassword: AnsiString);
begin

end;

procedure TQuoteConsole.MDSaveAllQuote;
begin

end;

procedure TQuoteConsole.MDSubscribe(AInstrumentId: AnsiString);
begin

end;

end.
