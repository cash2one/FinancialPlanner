unit DealAgentServerApp;

interface

uses
  Windows, BaseApp, BaseWinApp, NetMgr;
  
type
  TDealAgentServerAppData = record
    NetMgr: TNetMgr;
  end;
  
  TDealAgentServerApp = Class(TBaseWinApp)
  protected
    fSrvAppData: TDealAgentServerAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;        
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;     
    property NetMgr: TNetMgr read fSrvAppData.NetMgr;
  end;

var
  GlobalApp: TDealAgentServerApp = nil;
    
implementation

uses
  Messages, windef_msg, win.wnd, Sysutils, DealAgentServerAppStart;
  
{ THttpApiSrvApp }

constructor TDealAgentServerApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fSrvAppData, SizeOf(fSrvAppData), 0);
end;

destructor TDealAgentServerApp.Destroy;
begin
  inherited;
end;

procedure TDealAgentServerApp.Finalize;
begin
  //DestroyCommandWindow(@fSrvAppData.AppWindow.CommandWindow);
  FreeAndNIl(fSrvAppData.NetMgr);
end;
                      
function WndProcA_DealAgentServerApp(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case AMsg of
    WM_COPYDATA: begin

    end;
    WM_AppStart: begin
      WMAppStart;
    end
    else
      Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
  end;
end;

function TDealAgentServerApp.Initialize: Boolean;
begin
  fBaseWinAppData.AppCmdWnd := CreateCommandWndA(@WndProcA_DealAgentServerApp, 'dealAgentServerWindow');
  Result := IsWindow(fBaseWinAppData.AppCmdWnd);
  //Result := CreateCommandWindow(@fSrvAppData.AppWindow.CommandWindow, @AppWndProcA, 'dealAgentServerWindow');
  if not Result then
    exit;
  fSrvAppData.NetMgr := TNetMgr.Create(Self);
end;

procedure TDealAgentServerApp.Run;
begin
  //AppStartProc := DealAgentServerAppStart.WMAppStart;
  //PostMessage(fSrvAppData.AppWindow.CommandWindow.WindowHandle, WM_AppStart, 0, 0);
  PostMessage(fBaseWinAppData.AppCmdWnd, WM_AppStart, 0, 0);
  RunAppMsgLoop;
end;

end.
