program DealAgentClient;

uses
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  windef_msg in '..\..\..\devwintech\v0001\windef\windef_msg.pas',
  Base.Run in '..\..\..\devwintech\v0001\rec\app_base\Base.Run.pas',
  Base.thread in '..\..\..\devwintech\v0001\rec\app_base\Base.thread.pas',
  win.diskfile in '..\..\..\devwintech\v0001\rec\win_sys\win.diskfile.pas',
  win.cpu in '..\..\..\devwintech\v0001\rec\win_sys\win.cpu.pas',
  win.iocp in '..\..\..\devwintech\v0001\rec\win_sys\win.iocp.pas',
  win.thread in '..\..\..\devwintech\v0001\rec\win_sys\win.thread.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseWinFormApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinFormApp.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  win.wnd in '..\..\..\devwintech\v0001\winproc\win.wnd.pas',
  DataChain in '..\dealAgentServer\net\DataChain.pas',
  NetBase in '..\dealAgentServer\net\NetBase.pas',
  NetMgr in 'net\NetMgr.pas',
  NetObjClient in 'net\NetObjClient.pas',
  NetBaseObj in 'net\NetBaseObj.pas',
  NetObjClientProc in 'net\NetObjClientProc.pas',
  BaseDataIO in 'net\BaseDataIO.pas',
  DealAgentClientApp in 'DealAgentClientApp.pas',
  DealAgentClientAppStart in 'DealAgentClientAppStart.pas',
  DealAgentClientForm in 'DealAgentClientForm.pas' {frmDealAgentClient};

{$R *.res}

begin
  GlobalApp := TDealAgentClientApp.Create('dealAgentServer');
  try
    if GlobalApp.Initialize then
    begin
      GlobalApp.Run;
    end;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
