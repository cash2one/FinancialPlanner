program DealAgentServer;

// {$APPTYPE CONSOLE}
{$APPTYPE CONSOLE}

uses
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  Base.Run in '..\..\..\devwintech\v0001\rec\app_base\Base.Run.pas',
  Base.thread in '..\..\..\devwintech\v0001\rec\app_base\Base.thread.pas',
  win.diskfile in '..\..\..\devwintech\v0001\rec\win_sys\win.diskfile.pas',
  win.cpu in '..\..\..\devwintech\v0001\rec\win_sys\win.cpu.pas',
  win.iocp in '..\..\..\devwintech\v0001\rec\win_sys\win.iocp.pas',
  win.thread in '..\..\..\devwintech\v0001\rec\win_sys\win.thread.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  windef_msg in '..\..\..\devwintech\v0001\windef\windef_msg.pas',
  win.wnd in '..\..\..\devwintech\v0001\winproc\win.wnd.pas',
  DataChain in 'net\DataChain.pas',
  NetBase in 'net\NetBase.pas',
  NetMgr in 'net\NetMgr.pas',
  NetBaseObj in 'net\NetBaseObj.pas',
  NetSrvClientIocp in 'net\NetSrvClientIocp.pas',
  NetServerIocp in 'net\NetServerIocp.pas',
  BaseDataIO in 'net\BaseDataIO.pas',
  DealAgentServerApp in 'DealAgentServerApp.pas',
  DealAgentServerAppStart in 'DealAgentServerAppStart.pas';

{$R *.res}

begin
  GlobalApp := TDealAgentServerApp.Create('dealAgentServer');
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
