unit zsDealCancel;

interface
                           
uses
  Windows,
  zsAttach;
  
  procedure ClickTreeCancelNode(AMainWindow: PZSMainWindow);
  
implementation

uses
  UtilsWindows;
  
procedure ClickTreeCancelNode(AMainWindow: PZSMainWindow);   
var
  tmpRect: TRect;
  tmpWnd: HWND;
begin                     
  tmpWnd := AMainWindow.WndFunctionTree;
  if IsWindow(tmpWnd) then
  begin
    if nil <> AMainWindow.HostWindowPtr then
    begin
      ForceBringFrontWindow(AMainWindow.HostWindowPtr.WindowHandle);
      SleepWait(20);
      ForceBringFrontWindow(AMainWindow.HostWindowPtr.WindowHandle);
      SleepWait(20);
    end;
    ForceBringFrontWindow(tmpWnd);

    GetWindowRect(tmpWnd, tmpRect);
    Windows.SetCursorPos(tmpRect.Left + 30, tmpRect.Top + 70);
    SleepWait(20);
    Windows.mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;
end;

end.
