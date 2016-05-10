unit DealAgentClientAppStart;

interface

  procedure WMAppStart();
  
implementation

uses
  //SDLogutils,
  BaseDataIO,
  NetBaseObj,
  DealAgentClientApp;
         
procedure TestTCPClient();  
var
//  tmpHttpClient: PNetHttpClient;
  tmpRet: AnsiString;
  tmpUrl: AnsiString;
begin
//  tmpHttpClient := GlobalApp.NetMgr.CheckOutHttpClient;
//  if nil <> tmpHttpClient then
//  begin
//    tmpUrl := 'http://market.finance.sina.com.cn/downxls.php?date=2015-12-03&symbol=sh600000';
//    tmpRet := HttpGet(tmpHttpClient, tmpUrl);
//  end;
end;
              
procedure StartDealAgentServer;
begin
end;

procedure WMAppStart();
begin
  //TestClient();
  //TestServer();
  //StartDealAgentServer();  
  //NetUdpServer.TestUDPServer;
end;

end.
