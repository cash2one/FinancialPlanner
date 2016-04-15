unit zsDialogUtils;

interface
             
uses
  Windows,
  Messages,   
  zsProcess,                       
  zsAttach;

  function FindAndCloseZsDialog(AZsDealSession: PZsDealSession): Boolean;
  function FindZSDialogWindow(AZsDealSession: PZsDealSession): Boolean;
  function FuncCheckDialogWnd(AWnd: HWND): Boolean;   
  procedure CheckZSDialogWindow(AWindow: PExProcessWindow);

implementation

uses
  Sysutils,
  UtilsWindows;

function FuncCheckDialogWnd(AWnd: HWND): Boolean;
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
   
function FindZSDialogWindow(AZsDealSession: PZsDealSession): Boolean;
var
  i: integer;
begin
  InitFindSession(@AZsDealSession.ProcessAttach.FindSession);
  AZsDealSession.ProcessAttach.FindSession.NeedWinCount := 255;
  AZsDealSession.ProcessAttach.FindSession.WndClassKey := '#32770';
  AZsDealSession.ProcessAttach.FindSession.CheckFunc := FuncCheckDialogWnd;
  //Result := FindDesktopWindow(AWindow);
  Windows.EnumWindows(@EnumFindDesktopWindowProc, Integer(AZsDealSession));
  Result := AZsDealSession.ProcessAttach.FindSession.FindCount > 0;
  if Result then
  begin
    FillChar(AZsDealSession.DialogWindow, SizeOf(AZsDealSession.DialogWindow), 0);
    for i := 0 to AZsDealSession.ProcessAttach.FindSession.FindCount - 1 do
    begin
      AZsDealSession.DialogWindow[i] := AZsDealSession.ProcessAttach.FindSession.FindWindow[i];
    end;
  end;
end;

procedure TraverseCheckChildWindowA(AWnd: HWND; AWindow: PExProcessWindow); 
var
  tmpChildWnd: HWND; 
  tmpStr: Widestring;
  tmpIsHandled: Boolean;
begin
  tmpChildWnd := Windows.GetWindow(AWnd, GW_CHILD);
  while 0 <> tmpChildWnd do
  begin
    tmpIsHandled := false;
    tmpStr := Trim(GetWndTextName(tmpChildWnd));
    if '' <> tmpStr then
    begin
      if SameText('关闭', tmpStr) then
      begin
        AWindow.CancelButton := tmpChildWnd;
        tmpIsHandled := true;
      end;          
      if not tmpIsHandled then
      begin
        if SameText('取消', tmpStr) then
        begin
          AWindow.CancelButton := tmpChildWnd;
          tmpIsHandled := true;
        end;
      end;
      if not tmpIsHandled then
      begin
        if Length(tmpStr) < 5 then
        begin
          if Pos('确', tmpStr) > 0 then
          begin
            AWindow.OKButton := tmpChildWnd;
            tmpIsHandled := true;
          end;
        end;
      end;
    end;
    if not tmpIsHandled then
    begin
      TraverseCheckChildWindowA(tmpChildWnd, AWindow);
    end;
    tmpChildWnd := Windows.GetWindow(tmpChildWnd, GW_HWNDNEXT);
  end;
end;
                    
procedure CheckZSDialogWindow(AWindow: PExProcessWindow);
begin
  TraverseCheckChildWindowA(AWindow.WindowHandle, AWindow);
end;

function FindAndCloseZsDialog(AZsDealSession: PZsDealSession): Boolean;
var
  i: integer;
  tmpCount: integer;
  j: integer;
  tmpDialogWindow: PExProcessWindow;
begin
  Result := false;
  tmpCount := 0;
  for i := 1 to 2 * 50 do
  begin
    SleepWait(20);
    if FindZSDialogWindow(AZsDealSession) then
    begin
      tmpCount := 0;
      Result := true;
    end else
    begin
      Inc(tmpCount);
    end;
    if 20 < tmpCount then
      Break;
    if 0 = tmpCount then
    begin
      for j := Low(AZsDealSession.DialogWindow) to High(AZsDealSession.DialogWindow) do
      begin
        if nil <> AZsDealSession.DialogWindow[j] then
        begin
          tmpDialogWindow := AZsDealSession.DialogWindow[j];
          if IsWindow(tmpDialogWindow.WindowHandle) then
          begin
            if IsWindowVisible(tmpDialogWindow.WindowHandle) then
            begin
              CheckZSDialogWindow(tmpDialogWindow);
              if IsWindow(tmpDialogWindow.CancelButton) then
              begin
                ForceBringFrontWindow(tmpDialogWindow.WindowHandle);
                SleepWait(20);
                ForceBringFrontWindow(tmpDialogWindow.WindowHandle);
                SleepWait(20);
                ClickButtonWnd(tmpDialogWindow.CancelButton);
              end else
              begin
                PostMessage(tmpDialogWindow.WindowHandle, WM_Close, 0, 0);   
                SleepWait(20);
              end;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;
            
end.
