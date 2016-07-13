unit zsDialogDeal;

interface
                       
uses
  Windows, Messages, Graphics, zsAttach, zsProcess;
    
  procedure ConfirmDeal(AZsDealSession: PZsDealSession);     
  function FindZSDealConfirmDialogWindow(AZsDealSession: PZsDealSession): Boolean;
  
implementation

uses
  zsMainWindow,
  zsDialogUtils,
  UtilsWindows;

function FindZSPasswordConfirmDialogWindow(AZsDealSession: PZsDealSession): Boolean;  
var
  i: integer;
begin
  InitFindSession(@AZsDealSession.ProcessAttach.FindSession);   
  AZsDealSession.DealConfirmDialog := nil;
  AZsDealSession.ProcessAttach.FindSession.NeedWinCount := 255;
  AZsDealSession.ProcessAttach.FindSession.WndClassKey := '#32770';  
  AZsDealSession.ProcessAttach.FindSession.WndCaptionKey := '密码确认';
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
      AZsDealSession.DealPasswordConfirmDialogWindow.HostWindowPtr := AZsDealSession.DialogWindow[i];
    end;
  end;
end;

procedure CheckZSPasswordConfirmDialogWindow(AWindow: PZSDealPasswordConfirmDialogWindow);
var
  tmpChildWnd: HWND;    
  tmpCtrlId: integer;
begin
  if nil = AWindow.HostWindowPtr then
    exit;
  CheckZSDialogWindow(AWindow.HostWindowPtr);
  tmpChildWnd := Windows.GetWindow(AWindow.HostWindowPtr.WindowHandle, GW_CHILD);
  while 0 <> tmpChildWnd do
  begin              
    tmpCtrlId := Windows.GetDlgCtrlID(tmpChildWnd); 
    if $1B6F = tmpCtrlId then
    begin
      AWindow.WndPasswordEdit := tmpChildWnd; // 1B6F
    end;                                    
    if $1B70 = tmpCtrlId then
    begin
      AWindow.WndNoInputNextCheck := tmpChildWnd; //  下次不再提示
    end;
    tmpChildWnd := Windows.GetWindow(tmpChildWnd, GW_HWNDNEXT);
  end;
end;

procedure ConfirmAlwaysPwdInput(AZsDealSession: PZsDealSession);
var
  tmpWnd: HWND;
  tmpIsChecked: integer;
  i: integer;
begin
  { 各种可能出现的 对话框 }
  if nil = AZsDealSession.MainWindow.HostWindowPtr then
  begin
    if not FindZSMainWindow(AZsDealSession) then
      exit;
  end;
  for i := 0 to 1 * 10 do
  begin
    Sleep(20);    
    if FindZSPasswordConfirmDialogWindow(AZsDealSession) then
    begin
      if nil <> AZsDealSession.DealPasswordConfirmDialogWindow.HostWindowPtr then
      begin
        CheckZSPasswordConfirmDialogWindow(@AZsDealSession.DealPasswordConfirmDialogWindow);
        tmpWnd := AZsDealSession.DealPasswordConfirmDialogWindow.WndNoInputNextCheck;
        if IsWindow(tmpWnd) then
        begin
          tmpIsChecked := SendMessage(tmpWnd, Messages.BM_GETCHECK, 0, 0);
          if 0 = tmpIsChecked then
          begin
            ClickButtonWnd(tmpWnd);
          end;
        end; 
        tmpWnd := AZsDealSession.DealPasswordConfirmDialogWindow.WndPasswordEdit;
        if IsWindow(tmpWnd) then
        begin
          InputEditWnd(tmpWnd, AZsDealSession.ZsPassword);
        end;
        tmpWnd := AZsDealSession.DealPasswordConfirmDialogWindow.HostWindowPtr.OKButton;    
        if IsWindow(tmpWnd) then
        begin
          ClickButtonWnd(tmpWnd);
        end;
      end;
      Break;
    end;
  end;
end;

function FindZSDealConfirmDialogWindow(AZsDealSession: PZsDealSession): Boolean;
var
  i: integer;
begin
  InitFindSession(@AZsDealSession.ProcessAttach.FindSession);   
  AZsDealSession.DealConfirmDialog := nil;
  AZsDealSession.ProcessAttach.FindSession.NeedWinCount := 255;
  AZsDealSession.ProcessAttach.FindSession.WndClassKey := '#32770';  
  AZsDealSession.ProcessAttach.FindSession.WndCaptionKey := '交易确认';
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
      AZsDealSession.DealConfirmDialog := AZsDealSession.DialogWindow[i];
    end;
  end;
end;
  
procedure ConfirmDeal(AZsDealSession: PZsDealSession);
var
  tmpWnd: HWND;
  i: integer;
  j: integer;
  tmpDialogWindow: PExProcessWindow;
begin
  for i := 1 to 10 do
  begin
    SleepWait(20);
    if FindZSDealConfirmDialogWindow(AZsDealSession) then
    begin
      if nil <> AZsDealSession.DealConfirmDialog then
      begin
        CheckZSDialogWindow(AZsDealSession.DealConfirmDialog);
        if IsWindow(AZsDealSession.DealConfirmDialog.OKButton) then
        begin
          tmpWnd := AZsDealSession.DealConfirmDialog.WindowHandle;
          if IsWindow(tmpWnd) then
          begin
            ForceBringFrontWindow(tmpWnd);
            SleepWait(20);
            ForceBringFrontWindow(tmpWnd);
            SleepWait(20);
          end;
          if ClickButtonWnd(AZsDealSession.DealConfirmDialog.OKButton) then
            Break;
        end;
      end;
    end;
  end;       
  ConfirmAlwaysPwdInput(AZsDealSession);
  for i := 1 to 20 do
  begin
    SleepWait(20);
    if FindZSDialogWindow(AZsDealSession) then
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
              tmpWnd := tmpDialogWindow.CancelButton;
              if not IsWindow(tmpWnd) then       
                tmpWnd := tmpDialogWindow.OKButton;  
              if IsWindow(tmpWnd) then       
              begin
                ForceBringFrontWindow(tmpDialogWindow.WindowHandle);
                SleepWait(20);
                ForceBringFrontWindow(tmpDialogWindow.WindowHandle);
                SleepWait(20);
                ClickButtonWnd(tmpWnd);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

end.
