unit XueQiuInfoApp;

interface

uses
  Windows, BaseApp, AppWindow, NetMgr;
  
type
  THttpApiClientAppData = record
    AppMsg: Windows.TMsg;
    AppWindow: TAppWindow;
    NetMgr: TNetMgr;
  end;
  
  TXueQiuInfoApp = Class(TBaseApp)
  protected
    fClientAppData: THttpApiClientAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;        
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
    procedure RunMessageLoop;     
    property NetMgr: TNetMgr read fClientAppData.NetMgr;
  end;

var
  GlobalApp: TXueQiuInfoApp = nil;
    
implementation

uses
  CmdWindow, Define_Message, Sysutils, XueQiuInfoAppWindow2;
  
{ THttpApiSrvApp }

constructor TXueQiuInfoApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fClientAppData, SizeOf(fClientAppData), 0);
end;

destructor TXueQiuInfoApp.Destroy;
begin
  inherited;
end;

procedure TXueQiuInfoApp.Finalize;
begin
  DestroyCommandWindow(@fClientAppData.AppWindow.CommandWindow);
  FreeAndNIl(fClientAppData.NetMgr);
end;

function TXueQiuInfoApp.Initialize: Boolean;
begin
  Result := CreateCommandWindow(@fClientAppData.AppWindow.CommandWindow, @AppWndProcA, 'XueQiuInfoApp');
  if not Result then
    exit;
  fClientAppData.NetMgr := TNetMgr.Create(Self);
  
  AppWindow.AppStartProc := XueQiuInfoAppWindow2.WMAppStart;
end;

procedure TXueQiuInfoApp.Run;
begin
  PostMessage(fClientAppData.AppWindow.CommandWindow.WindowHandle, WM_AppStart, 0, 0);
  RunMessageLoop;
end;

procedure TXueQiuInfoApp.RunMessageLoop;
begin
  while GetMessage(fClientAppData.AppMsg, 0, 0, 0) do
  begin
    TranslateMessage(fClientAppData.AppMsg);
    DispatchMessage(fClientAppData.AppMsg);
  end;
end;

end.
