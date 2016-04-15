unit zsUserUnlock;

interface

uses
  zsAttach, Windows, SysUtils;
                     
  function HandleZsUserUnlock(AZsDealSession: PZsDealSession; APassword: integer): Boolean;
  function FindZSLockPanelWindow(AZsDealSession: PZsDealSession): Boolean;

implementation

uses
  UtilsWindows,
  zsLoginUtils,
  zsMainWindow;

function FindZSLockPanelWindow(AZsDealSession: PZsDealSession): Boolean;

  procedure FindLockPanelWindow(AWnd: HWND);  
  var
    tmpParent: HWND;
    tmpChildWnd: HWND;
    tmpStr: string;  
    tmpCtrlId: integer;
  begin
    if IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput) then
      exit;
    tmpStr := GetWndTextName(AWnd);
    if Pos('通达信网上交易', tmpStr) > 0 then
    begin
      AZsDealSession.MainWindow.DealLockPanelWindow.WndPanel := AWnd;
    end else
    begin
      if 0 <> AZsDealSession.MainWindow.DealLockPanelWindow.WndPanel then
      begin
        if Pos('已锁定', tmpStr) > 0 then
        begin
          if Pos('交易密码', tmpStr) > 0 then
          begin
            if Pos('解锁', tmpStr) > 0 then
            begin
              tmpParent := GetParent(AWnd);  
              tmpChildWnd := Windows.GetWindow(tmpParent, GW_CHILD);
              while 0 <> tmpChildWnd do
              begin         
                tmpCtrlId := Windows.GetDlgCtrlID(tmpChildWnd); 
                if $10F = tmpCtrlId then
                begin
                  AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput := tmpChildWnd; // $10F
                end;
                if $1BA = tmpCtrlId then
                begin
                  AZsDealSession.MainWindow.DealLockPanelWindow.WndOKButton      := tmpChildWnd; // $1BA
                end;
                tmpChildWnd := Windows.GetWindow(tmpChildWnd, GW_HWNDNEXT);
              end;
              exit;
            end;
          end;
        end;
      end;
    end;
    tmpChildWnd := Windows.GetWindow(AWnd, GW_CHILD);
    while 0 <> tmpChildWnd do
    begin
      if IsWindowVisible(tmpChildWnd) then
      begin
        FindLockPanelWindow(tmpChildWnd);
      end;              
      if IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput) then
        Break;
      tmpChildWnd := Windows.GetWindow(tmpChildWnd, GW_HWNDNEXT);
    end;
  end;
  
begin
  Result := false;
  if not IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPanel) then
  begin
    AZsDealSession.MainWindow.DealLockPanelWindow.WndPanel := 0;
    if nil = AZsDealSession.MainWindow.HostWindowPtr then
    begin
      if not FindZSMainWindow(AZsDealSession) then
        exit;
    end;
    if nil <> AZsDealSession.MainWindow.HostWindowPtr then
    begin
      FindLockPanelWindow(AZsDealSession.MainWindow.HostWindowPtr.WindowHandle);
    end;
  end;                     
  Result := IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPanel);
end;
  
function HandleZsUserUnlock(AZsDealSession: PZsDealSession; APassword: integer): Boolean;
var
  tmpAnsi: AnsiString;
begin
  Result := false; 
  FindZSProgram(AZsDealSession); 
  if FindZSMainWindow(AZsDealSession) then
  begin
    if FindZSLockPanelWindow(AZsDealSession) then
    begin
      if IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput) then
      begin
        tmpAnsi := IntToStr(APassword);
        InputEditWnd(AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput, tmpAnsi);
        ClickButtonWnd(AZsDealSession.MainWindow.DealLockPanelWindow.WndOKButton);
        Result := true;
      end;
    end;
  end; 
end;

end.
