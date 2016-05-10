unit DealAgentClientApp;

interface

uses
  Windows, BaseForm, BaseApp, BaseWinFormApp, NetMgr;
  
type
  TDealAgentClientAppData = record
    NetMgr: TNetMgr;
    ConsoleForm: TfrmBase;
  end;
  
  TDealAgentClientApp = Class(TBaseWinFormApp)
  protected
    fAppData: TDealAgentClientAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;        
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;     
    property NetMgr: TNetMgr read fAppData.NetMgr;
  end;

var
  GlobalApp: TDealAgentClientApp = nil;
    
implementation

uses
  Messages, Forms, Sysutils,
  windef_msg, win.wnd, DealAgentClientAppStart, DealAgentClientForm;
  
{ THttpApiSrvApp }

constructor TDealAgentClientApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fAppData, SizeOf(fAppData), 0);
end;

destructor TDealAgentClientApp.Destroy;
begin
  inherited;
end;

procedure TDealAgentClientApp.Finalize;
begin
  //DestroyCommandWindow(@fSrvAppData.AppWindow.CommandWindow);
  FreeAndNIl(fAppData.NetMgr);
end;
                      
function WndProcA_DealAgentClientApp(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
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

function TDealAgentClientApp.Initialize: Boolean;
begin
  Application.Initialize;
  fBaseWinAppData.AppCmdWnd := CreateCommandWndA(@WndProcA_DealAgentClientApp, 'DealAgentClientWindow');
  Result := IsWindow(fBaseWinAppData.AppCmdWnd);
  //Result := CreateCommandWindow(@fSrvAppData.AppWindow.CommandWindow, @AppWndProcA, 'DealAgentClientWindow');
  if not Result then
    exit;
  fAppData.NetMgr := TNetMgr.Create(Self);
end;

procedure TDealAgentClientApp.Run;
begin
  //AppStartProc := DealAgentClientAppStart.WMAppStart;
  //PostMessage(fSrvAppData.AppWindow.CommandWindow.WindowHandle, WM_AppStart, 0, 0);
  PostMessage(fBaseWinAppData.AppCmdWnd, WM_AppStart, 0, 0);
  //RunAppMsgLoop;
  Application.CreateForm(TfrmDealAgentClient, fAppData.ConsoleForm);
  fAppData.ConsoleForm.Initialize(Self);         
  Application.Run;
end;

end.
