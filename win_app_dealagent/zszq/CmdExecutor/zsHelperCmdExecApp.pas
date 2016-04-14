unit zsHelperCmdExecApp;

interface

uses
  BaseApp, BaseWinApp;
  
type
  TzsHelperCmdExecApp = class(TBaseWinApp)
  protected          
  public
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TzsHelperCmdExecApp = nil;

implementation

{ TzsHelperApp }

uses
  Windows,
  zsLoginUtils,
  win.wnd_cmd,
  zsVariants,
  zsHelperDefine,
  Define_Message,
  zsHelperMessage;
  
function AppCmdWndProcA(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
begin
  case AMsg of
    WM_C2S_LaunchProgram: begin     
      zsLoginUtils.LaunchZSProgram(@zsVariants.GZsDealSession);   
    end;
    WM_C2S_LoginUser: begin//        = WM_CustomAppBase + 21; 
      zsLoginUtils.AutoLogin(@zsVariants.GZsDealSession, wParam, lParam);
    end;
    WM_C2S_Unlock: begin //           = WM_CustomAppBase + 22;
    end;
    WM_C2S_StockBuy_Mode_1: begin //         = WM_CustomAppBase + 41;
    end;
    WM_C2S_StockSale_Mode_1: begin
    end;
    WM_C2S_Query: begin
    end;
  end;
  Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
end;

function CreateAppCmdWnd(AWndClassName: AnsiString): HWND;
var  
  tmpRegWndClass: TWndClassA;
begin
  Result := 0;       
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);

  tmpRegWndClass.style := 0;//CS_VREDRAW;
  
  tmpRegWndClass.lpszClassName := PAnsiChar(AWndClassName);
  tmpRegWndClass.lpfnWndProc := @AppCmdWndProcA;
  if 0 = Windows.RegisterClassA(tmpRegWndClass) then
    exit;

  Result := Windows.CreateWindowExA(
    0, //AUIWnd.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    0, //AUIWnd.Style {+ 0},
    0, //AUIWnd.WindowRect.Left,
    0, //AUIWnd.WindowRect.Top,
    0, //AUIWnd.ClientRect.Right,
    0, //AUIWnd.ClientRect.Bottom,
    HWND_MESSAGE, // wndParent
    0, // menu
    HInstance, nil);
  WIndows.SetParent(Result, HWND_MESSAGE);
end;

function TzsHelperCmdExecApp.Initialize: Boolean;
var
  tmpRegWndClassName: AnsiString;
begin
  Result := inherited Initialize;
  if Result then
  begin
    tmpRegWndClassName := zsHelperCmdExecApp_AppCmdWndClassName;
    fBaseWinAppData.AppCmdWnd := CreateAppCmdWnd(tmpRegWndClassName);
    Result := IsWindow(fBaseWinAppData.AppCmdWnd);
  end;
end;

procedure TzsHelperCmdExecApp.Finalize;
begin
  inherited;
end;

procedure TzsHelperCmdExecApp.Run;
var
  dealParam: TWMDeal_LParam;
begin
  //PostMessage(fBaseWinAppData.AppCmdWnd, WM_C2S_LaunchProgram, 0, 0);
  PostMessage(fBaseWinAppData.AppCmdWnd, WM_C2S_LoginUser, 39008990, 123456);
  //dealParam.Price := 2300;
  //dealParam.Hand := 5;  
  //PostMessage(fBaseWinAppData.AppCmdWnd, WM_C2S_StockBuy_Mode_1, 1002414, lParam(dealParam));  
  RunAppMsgLoop;
end;

end.