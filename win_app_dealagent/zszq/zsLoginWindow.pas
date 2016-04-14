unit zsLoginWindow;

interface

uses
  Windows, Graphics, zsAttach, zsProcess;
  
  function FindZSLoginWindow(AZsDealSession: PZsDealSession): Boolean;

  procedure CheckZSLoginWindow(ALoginWindow: PZSLoginWindow);
  function GetVerifyCodeBmp(ALoginWindow: PExProcessWindow;
      ALeft, ATop, AWidth, AHeight: integer): Graphics.TBitmap;
  procedure ClickLoginButton(ALoginWindow: PZSLoginWindow);
  procedure InputLoginAccount(ALoginWindow: PZSLoginWindow; Account: AnsiString);
  procedure InputLoginPassword(ALoginWindow: PZSLoginWindow; APassword: AnsiString);
  procedure InputLoginVerifyCode(ALoginWindow: PZSLoginWindow; AVerifyCode: AnsiString);
  
implementation

uses
  Classes, Sysutils, 
  UtilsWindows;

                            
procedure ClickLoginButton(ALoginWindow: PZSLoginWindow);
var
  tmpRect: TRect;
begin
  if IsWindow(ALoginWindow.WndLoginButton) then
  begin
    if nil <> ALoginWindow.HostWindowPtr then
    begin
      ForceBringFrontWindow(ALoginWindow.HostWindowPtr.WindowHandle);
      SleepWait(20);
      ForceBringFrontWindow(ALoginWindow.HostWindowPtr.WindowHandle);
      SleepWait(20);
    end;
    GetWindowRect(ALoginWindow.WndLoginButton, tmpRect);
    Windows.SetCursorPos(tmpRect.Left + 10, tmpRect.Top + 10);
    Windows.mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    SleepWait(20);
  end;
end;

procedure InputLoginAccount(ALoginWindow: PZSLoginWindow; Account: AnsiString);
var
  tmpAccount: AnsiString;
  i: integer;
  tmpKeyCode: Byte;
begin    
  if '' <> Account then
  begin
    if nil = ALoginWindow.HostWindowPtr then
      exit;
    if IsWindow(ALoginWindow.HostWindowPtr.WindowHandle) then
    begin
      for i := 1 to 2 do
      begin
        ForceBringFrontWindow(ALoginWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
      end;
      if IsWindow(ALoginWindow.WndAccountEdit) then
      begin
        ForceBringFrontWindow(ALoginWindow.WndAccountEdit);
        for i := 1 to 10 do
        begin
          SimulateKeyPress(VK_BACK, 20);
          SimulateKeyPress(VK_DELETE, 20);
        end;
        tmpAccount := UpperCase(Account);
        for i := 1 to Length(tmpAccount) do
        begin
          tmpKeyCode := Byte(tmpAccount[i]);
          SimulateKeyPress(tmpKeyCode, 20);
        end;      
        SimulateKeyPress(VK_RETURN, 20); 
        SimulateKeyPress(VK_TAB, 20);
      end;
    end;
  end;
end;
               
procedure InputLoginPassword(ALoginWindow: PZSLoginWindow; APassword: AnsiString);
var
  tmpPassword: AnsiString;
  tmpKeyCode: Byte;
  i: integer;
begin
  if '' <> APassword then
  begin
    if nil = ALoginWindow.HostWindowPtr then
      exit;
    if IsWindow(ALoginWindow.HostWindowPtr.WindowHandle) then
    begin
      for i := 1 to 2 do
      begin
        ForceBringFrontWindow(ALoginWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);              
        ForceBringFrontWindow(ALoginWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
      end;
      if IsWindow(ALoginWindow.WndPasswordEdit) then
      begin
        ForceBringFrontWindow(ALoginWindow.WndPasswordEdit);
        for i := 1 to 8 do
        begin
          SimulateKeyPress(VK_BACK, 20);
          SimulateKeyPress(VK_DELETE, 20);
        end;
        tmpPassword := UpperCase(APassword);
        for i := 1 to Length(tmpPassword) do
        begin
          tmpKeyCode := Byte(tmpPassword[i]);
          SimulateKeyPress(tmpKeyCode, 20);    
        end;
        SimulateKeyPress(VK_RETURN, 20);  
        SimulateKeyPress(VK_TAB, 20);
      end;
    end;
  end;
end;

procedure InputLoginVerifyCode(ALoginWindow: PZSLoginWindow; AVerifyCode: AnsiString);
var
  tmpVerifyCode: AnsiString;   
  tmpKeyCode: Byte;
  i: integer;
begin
  if '' <> AVerifyCode then
  begin
    if nil = ALoginWindow.HostWindowPtr then
      exit;
    if IsWindow(ALoginWindow.HostWindowPtr.WindowHandle) then
    begin
      for i := 1 to 3 do
      begin
        ForceBringFrontWindow(ALoginWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
      end;
      if IsWindow(ALoginWindow.WndVerifyCodeEdit) then
      begin
        ForceBringFrontWindow(ALoginWindow.WndVerifyCodeEdit);
        for i := 1 to 8 do
        begin
          SimulateKeyPress(VK_BACK, 20);
          SimulateKeyPress(VK_DELETE, 20);
        end;
        tmpVerifyCode := UpperCase(AVerifyCode);
        for i := 1 to Length(tmpVerifyCode) do
        begin
          tmpKeyCode := Byte(tmpVerifyCode[i]);
          SimulateKeyPress(tmpKeyCode, 20);
        end;
      end;
    end;
  end;
end;

function FuncCheckLoginWnd(AWnd: HWND): Boolean;
var
  tmpChildWnd: HWND;
begin
  Result := true;
  tmpChildWnd := Windows.GetWindow(AWnd, GW_CHILD);
  if 0 = tmpChildWnd then
  begin
    Result := false;
  end;
end;

function FindZSLoginWindow(AZsDealSession: PZsDealSession): Boolean;
begin
  if nil <> AZsDealSession.LoginWindow.HostWindowPtr then
  begin
    if not IsWindow(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle) then
    begin
      AZsDealSession.LoginWindow.HostWindowPtr := nil;
    end;
  end;
  if nil = AZsDealSession.LoginWindow.HostWindowPtr then
  begin
    InitFindSession(@AZsDealSession.ProcessAttach.FindSession);
    AZsDealSession.ProcessAttach.FindSession.NeedWinCount := 1;
    AZsDealSession.ProcessAttach.FindSession.WndClassKey := '#32770';
    AZsDealSession.ProcessAttach.FindSession.WndCaptionKey := '招商证券智远理财服务平台';
    AZsDealSession.ProcessAttach.FindSession.CheckFunc := FuncCheckLoginWnd;
    Windows.EnumWindows(@EnumFindDesktopWindowProc, Integer(AZsDealSession));
  end;
  Result := AZsDealSession.ProcessAttach.FindSession.FindCount > 0;    
  if Result then
  begin        
    AZsDealSession.LoginWindow.HostWindowPtr := AZsDealSession.ProcessAttach.FindSession.FindWindow[0];
  end;
end;

type  
  PTraverse_LoginWindow = ^TTraverse_LoginWindow;
  TTraverse_LoginWindow = record
    LoginWindow: PZSLoginWindow;
  end;
           
procedure TraverseCheckChildWindowA(AWnd: HWND; ATraverseWindow: PTraverse_LoginWindow);
var
  tmpChildWnd: HWND;
  tmpStr: string;  
  tmpCtrlId: integer;
  tmpRect: TRect;
  tmpIsHandled: Boolean;
begin
  tmpChildWnd := Windows.GetWindow(AWnd, GW_CHILD);
  while 0 <> tmpChildWnd do
  begin          
    tmpStr := GetWndClassName(tmpChildWnd);
    tmpIsHandled := False;
    tmpCtrlId := Windows.GetDlgCtrlID(tmpChildWnd);
    if SameText('SafeEdit', tmpStr) then
    begin
      if tmpCtrlId = $ED then
      begin
        tmpIsHandled := true;
        ATraverseWindow.LoginWindow.WndVerifyCodeEdit := tmpChildWnd;
        Windows.GetWindowRect(ATraverseWindow.LoginWindow.WndVerifyCodeEdit, tmpRect);
        if 0 < tmpRect.Left then
        begin
        
        end;
      end;
    end;
    if not tmpIsHandled then
    begin
      if SameText('Edit', tmpStr) then
      begin
        if tmpCtrlId = $EC then
        begin
          tmpIsHandled := true;
          ATraverseWindow.LoginWindow.WndPasswordEdit := tmpChildWnd;
        end;                  
        if tmpCtrlId = $3E9 then
        begin
          tmpIsHandled := true;
          ATraverseWindow.LoginWindow.WndAccountEdit := tmpChildWnd;
        end;                            
      end;
    end;
    if not tmpIsHandled then
    begin
      if tmpCtrlId = 1 then
      begin
        tmpIsHandled := true;
        ATraverseWindow.LoginWindow.WndLoginButton := tmpChildWnd;
      end;
    end;
    if not tmpIsHandled then
    begin    
    end;
    TraverseCheckChildWindowA(tmpChildWnd, ATraverseWindow);
    tmpChildWnd := Windows.GetWindow(tmpChildWnd, GW_HWNDNEXT);
  end;
end;

procedure CheckZSLoginWindow(ALoginWindow: PZSLoginWindow);
var
  tmpTraverse_Window: TTraverse_LoginWindow;
begin
  if nil = ALoginWindow.HostWindowPtr then
    exit;
  if IsWindow(ALoginWindow.WndVerifyCodeEdit) then
  begin
    exit;
  end;
  FillChar(tmpTraverse_Window, SizeOf(tmpTraverse_Window), 0);
  tmpTraverse_Window.LoginWindow := ALoginWindow;
  TraverseCheckChildWindowA(ALoginWindow.HostWindowPtr.WindowHandle, @tmpTraverse_Window);
end;
                                
function GetVerifyCodeBmp(ALoginWindow: PExProcessWindow; ALeft, ATop, AWidth, AHeight: integer): Graphics.TBitmap;
const
  CAPTUREBLT = $40000000;
var
  tmpWnd: HWND;
  tmpForegroundWnd: HWND;
  tmpProcessID: DWORD;
  tmpWinRect: TRect;
  tmpMemDC: HDC;
  tmpDC: HDC;
  tmpMemBmp: HBITMAP;
  tmpOldBmp: HBITMAP;
begin
  Result := nil;       
  ForceBringFrontWindow(ALoginWindow.WindowHandle);
  SleepWait(20);
  ForceBringFrontWindow(ALoginWindow.WindowHandle);
  SleepWait(20);
  tmpWnd := ALoginWindow.WindowHandle;
  if IsWindow(tmpWnd) and IsWindowVisible(tmpWnd) then
  begin
    tmpForegroundWnd := GetForegroundWindow;
    GetWindowThreadProcessId(tmpForegroundWnd, tmpProcessID);
    AttachThreadInput(tmpProcessID, GetCurrentThreadId(), TRUE);
    if Windows.GetForegroundWindow <> tmpWnd then
      SetForegroundWindow(tmpWnd);
    if Windows.GetFocus <> tmpWnd then
      SetFocus(tmpWnd);          
    AttachThreadInput(tmpProcessID, GetCurrentThreadId(), FALSE);
    ForceBringFrontWindow(tmpWnd);

    Windows.GetWindowRect(tmpWnd, tmpWinRect);
    Result := Graphics.TBitmap.Create;
    Result.PixelFormat := pf32bit;  
    //tmpVerifyCodeBmp.Width := tmpWinRect.Right - tmpWinRect.Left;
    //tmpVerifyCodeBmp.Height := tmpWinRect.Bottom - tmpWinRect.Top;
    Result.Width := AWidth; //52;
    Result.Height := AHeight; //21;
    
    //tmpDC := Windows.GetDC(tmpWnd);
    tmpDC := Windows.GetDC(0);
    try
      tmpMemDC := Windows.CreateCompatibleDC(tmpDC);
      tmpMemBmp := Windows.CreateCompatibleBitmap(tmpDC, Result.Width, Result.Height);
      tmpOldBmp := Windows.SelectObject(tmpMemDC, tmpMemBmp);
      try                     
        Windows.BitBlt(tmpMemDC,
            0,
            0, //tmpWinRect.Top,
          //Windows.BitBlt(tmpVerifyCodeBmp.Canvas.Handle, 0, 0,
            Result.Width,
            Result.Height,
            tmpDC,
            tmpWinRect.Left + ALeft, //0,
            tmpWinRect.Top + ATop, //0,
            SRCCOPY or CAPTUREBLT);
        Windows.BitBlt(Result.Canvas.Handle, 0, 0,
        //Windows.BitBlt(tmpVerifyCodeBmp.Canvas.Handle, 0, 0,
          Result.Width,
          Result.Height,
          tmpMemDC,
          0, 0, SRCCOPY);
      finally
        Windows.SelectObject(tmpMemDC, tmpOldBmp);
        Windows.DeleteDC(tmpMemDC);
        Windows.DeleteObject(tmpMemBmp);
      end;
    finally
      Windows.ReleaseDC(tmpWnd, tmpDC);
    end;          
  end;
end;
            
end.
