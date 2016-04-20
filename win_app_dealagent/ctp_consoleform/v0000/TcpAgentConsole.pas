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
    RequestId: Integer;
  end;
  
  TTcpAgentConsole = class
  protected
    fTcpAgentConsoleData: TTcpAgentConsoleData;
  public                               
    constructor Create;
    destructor Destroy; override;      
    procedure StartAgentProcess;    
    function CheckOutRequestId: Integer;    
    procedure LoadGlobalRequestId;
    procedure SaveGlobalRequestId;    
    // ------------------------------------
    property Deal: TDealConsole read fTcpAgentConsoleData.Deal;  
  public
    // ------------------------------------              
    property Quote: TQuoteConsole read fTcpAgentConsoleData.Quote; 
  end;
  
var
  GTcpAgentConsole: TTcpAgentConsole = nil;
  //G_BrokerId: AnsiString = '';
  
implementation

{ TTcpAgentConsole }
constructor TTcpAgentConsole.Create;
begin
end;

destructor TTcpAgentConsole.Destroy;
begin
  inherited;
end;
             
procedure TTcpAgentConsole.StartAgentProcess;
begin
end;
               
function TTcpAgentConsole.CheckOutRequestId: Integer;
begin
  Result := 0;
end;

procedure TTcpAgentConsole.LoadGlobalRequestId;
begin
end;

procedure TTcpAgentConsole.SaveGlobalRequestId;
begin
end;

end.
