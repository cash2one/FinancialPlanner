unit zsDealQueryHold;

interface
                              
uses
  Windows,
  zsAttach;
  
  procedure ClickTreeQueryHoldNode(AMainWindow: PZSMainWindow);
  
implementation

uses
  UtilsWindows;
  
procedure ClickTreeQueryHoldNode(AMainWindow: PZSMainWindow);  
var
  tmpRect: TRect;
  tmpWnd: HWND;
  i: integer;
begin
  tmpWnd := AMainWindow.WndFunctionTree;
  if IsWindow(tmpWnd) then
  begin
    if nil <> AMainWindow.HostWindowPtr then
    begin
      for i := 1 to 2 do
      begin
        ForceBringFrontWindow(AMainWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
      end;
    end;
    ForceBringFrontWindow(tmpWnd);      
    SleepWait(20);

    GetWindowRect(tmpWnd, tmpRect);
    Windows.SetCursorPos(tmpRect.Left + 50, tmpRect.Top + 110);
    SleepWait(20);
    Windows.mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;
end;

end.
