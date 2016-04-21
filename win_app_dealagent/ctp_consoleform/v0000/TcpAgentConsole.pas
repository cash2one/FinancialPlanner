unit TcpAgentConsole;

interface

uses
  Windows,
  BaseWinProcess,
  TcpDealAgent,
  TcpQuoteAgent;
                  
type
  TTcpAgentConsoleData = record
    RequestId : Integer;
    SrvWND    : HWND;
    Deal      : TDealConsole;
    Quote     : TQuoteConsole;
  end;
  
  TTcpAgentConsole = class
  protected
    fTcpAgentConsoleData: TTcpAgentConsoleData;
  public                               
    constructor Create; virtual;
    destructor Destroy; override;      
    
    //function FindSrvWindow: Boolean;
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

uses
  IniFiles,
  SysUtils,
  UtilsApplication
  ;
  
{ TTcpAgentConsole }
constructor TTcpAgentConsole.Create;
begin
  FillChar(fTcpAgentConsoleData, SizeOf(fTcpAgentConsoleData), 0);  
  fTcpAgentConsoleData.Deal := TDealConsole.Create;
  fTcpAgentConsoleData.Quote := TQuoteConsole.Create;
end;

destructor TTcpAgentConsole.Destroy;
begin
  if GTcpAgentConsole = Self then
    GTcpAgentConsole := nil;   
  fTcpAgentConsoleData.Deal.Free;
  fTcpAgentConsoleData.Quote.Free;
  inherited;
end;
(*//             
procedure TTcpAgentConsole.StartAgentProcess;
var
  tmpProcessFileUrl: AnsiString;
begin     
  if not FindSrvWindow then
  begin
    //CloseExProcess(@fTcpAgentConsoleData.TCPAgentProcess);  
    //fTcpAgentConsoleData.TCPAgentProcess.FilePath := ExtractFilePath(ParamStr(0));
    //fTcpAgentConsoleData.TCPAgentProcess.FileUrl := fTcpAgentConsoleData.TCPAgentProcess.FilePath + 'tcpagent.exe';
    tmpProcessFileUrl := ExtractFilePath(ParamStr(0)) + 'tcpagent.exe';
    if FileExists(tmpProcessFileUrl) then
    begin
      RunProcessA(@fTcpAgentConsoleData.TCPAgentProcess,
        tmpProcessFileUrl,
        nil);
    end;
    //RunExProcess(@fTcpAgentConsoleData.TCPAgentProcess);
  end;   
  SleepWait(200);
end;
              
function TTcpAgentConsole.FindSrvWindow: Boolean;
begin
  Result := false;
  if 0 <> fTcpAgentConsoleData.SrvWND then
  begin
    if not IsWindow(fTcpAgentConsoleData.SrvWND) then
    begin
      fTcpAgentConsoleData.SrvWND := 0;
    end else
    begin
      Result := true;
      exit;
    end;
  end;
  fTcpAgentConsoleData.SrvWND := FindWindow('Tftdc_api_srv', 'tcpagent');
  Result := (fTcpAgentConsoleData.SrvWND <> 0) and
            (fTcpAgentConsoleData.SrvWND <> INVALID_HANDLE_VALUE);
end;
//*) 
function TTcpAgentConsole.CheckOutRequestId: Integer;
begin
  Result := fTcpAgentConsoleData.RequestId;
  Inc(fTcpAgentConsoleData.RequestId);
end;

procedure TTcpAgentConsole.LoadGlobalRequestId;
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    fTcpAgentConsoleData.RequestId := tmpIni.ReadInteger('ptc', 'requestid', fTcpAgentConsoleData.RequestId);
  finally
    tmpIni.Free;
  end;
end;

procedure TTcpAgentConsole.SaveGlobalRequestId; 
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteInteger('ptc', 'requestid', fTcpAgentConsoleData.RequestId);
  finally
    tmpIni.Free;
  end;
end;

end.
