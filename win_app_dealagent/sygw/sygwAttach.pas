unit sygwAttach;

interface

uses
  Windows, exProcess;
                     
type
  PZSLoginWindow      = ^TZSLoginWindow;
  TZSLoginWindow      = record
    HostWindowPtr     : PExProcessWindow;
    WndAccountEdit    : HWND;
    WndPasswordEdit   : HWND;
    WndVerifyCodeEdit : HWND;
    WndLoginButton    : HWND;
  end;
            
  // 买卖
  PZSMainDealWindow = ^TZSMainDealWindow;
  TZSMainDealWindow = record
    WndAccountCombo: HWND; // 2EEF
    WndStockCodeEdit: HWND; // 2EE5
    WndPriceEdit: HWND; // 2EE6     
    WndNumEdit: HWND; // 2EE7
    WndOrderButton: HWND; // 7DA
  end;
           
  // 撤单
  PZSMainDealCancelWindow = ^TZSMainDealCancelWindow;
  TZSMainDealCancelWindow = record
    WndOrderListView: HWND; // $61F  SysListView32 SysHeader32
    WndCancelButton: HWND;  // $470
  end;
  
  // 资产 持仓
  PZSMainDealHoldWindow = ^TZSMainDealHoldWindow;
  TZSMainDealHoldWindow = record
    //  余额:32.09  可用:32.09  可取:32.09  参考市值:0.00  资产:32.09  盈亏:0.00
    //  $628
    WndMoneyLabel     : HWND; // $628
    WndStockHoldListView: HWND; // $61F  SysListView32 SysHeader32
  end;

  TZSMainTopMenuWindow = record
    WndOrderButton    : HWND;
  end;

  TZSMainDealLockPanelWindow = record
    WndPanel          : HWND;
    WndPasswordInput  : HWND; // $10F
    WndOKButton       : HWND; // $1BA
  end;

  TZSMoneyData        = record
    Balance           : double; // 余额
    Available         : double; // 可用
    Extractable       : double; // 可取
    ValueRef          : double; // 参考市值
    Asset             : double; // 资产
    ProfitAndLoss     : double; // 盈亏
  end;
  
  PZSMainWindow       = ^TZSMainWindow;
  TZSMainWindow       = record
    HostWindowPtr     : PExProcessWindow;
    WndFunctionTree   : HWND;
    WndDealPanelRoot  : HWND;
    WndDealPanel      : HWND; // E81E

    MoneyData         : TZSMoneyData;

    TopMenu           : TZSMainTopMenuWindow;
    BuyWindowPtr      : PZSMainDealWindow;
    SaleWindowPtr     : PZSMainDealWindow;
    CurrentDealWindow : TZSMainDealWindow;
    DealLockPanelWindow : TZSMainDealLockPanelWindow;
  end;
                    
  PZSDealPasswordConfirmDialogWindow = ^TZSDealPasswordConfirmDialogWindow;
  TZSDealPasswordConfirmDialogWindow = record
    HostWindowPtr     : PExProcessWindow;
    WndPasswordEdit   : HWND; // 1B6F
    WndNoInputNextCheck: HWND; // 1B70 下次不再提示
  end;
  
  PZsDealSession  = ^TZsDealSession;
  TZsDealSession  = record
    ProcessAttach : TExProcessAttach;
    LoginWindow   : TZSLoginWindow;
    MainWindow    : TZSMainWindow;
    DealPasswordConfirmDialogWindow: TZSDealPasswordConfirmDialogWindow; 
    DealConfirmDialog : PExProcessWindow;
    DialogWindow  : array[0..255] of PExProcessWindow; 
    ZsProgramFileUrl  : array[0..31] of AnsiChar;
    ZsProgramPathUrl  : array[0..31] of AnsiChar;
    ZsAccount         : array[0..15] of AnsiChar;
    ZsPassword        : array[0..15] of AnsiChar;
    ZsIsConfigReaded  : Boolean;
  end;
                
  function EnumFindDesktopWindowProc(AWnd: HWND; lParam: LPARAM): BOOL; stdcall;
                
  procedure InitFindSession(AWindowFind: PExWindowFind);   

implementation

uses
  Sysutils,
  UtilsWindows;
  
function EnumFindDesktopWindowProc(AWnd: HWND; lParam: LPARAM): BOOL; stdcall;  
var
  tmpStr: string;
  tmpIsFind: Boolean;
  tmpSession: PZsDealSession;
  tmpAttach: PExProcessAttach;
  tmpProcessId: DWORD;
begin      
  Result := true;
  tmpSession := PZsDealSession(lparam);
  if nil = tmpSession then
  begin      
    Result := false;
    exit;
  end;
  tmpAttach := @tmpSession.ProcessAttach;
  if nil = tmpAttach then
  begin
    Result := false;
    exit;
  end;
  if 0 <> tmpAttach.Process.ProcessID then
  begin
    Windows.GetWindowThreadProcessId(AWnd, tmpProcessId);
    if tmpProcessId <> tmpAttach.Process.ProcessID then
    begin
      exit;
    end;
  end;    
  if not IsWindowVisible(AWnd) then
    exit;       
//  tmpParentWnd := GetParent(AWnd);
//  if 0 <> tmpParentWnd then
//  begin
//    exit;
//  end;       
  tmpIsFind := true;
  if '' <> tmpAttach.FindSession.WndClassKey then
  begin
    tmpStr := GetWndClassName(AWnd);
    if (not SameText(tmpStr, tmpAttach.FindSession.WndClassKey)) then
    begin
      if Pos(tmpAttach.FindSession.WndClassKey, tmpStr) < 1 then
      begin
        tmpIsFind := false;
      end;
    end;
  end;
  if tmpIsFind then
  begin
    if ('' <> Trim(tmpAttach.FindSession.WndCaptionKey)) or
       ('' <> Trim(tmpAttach.FindSession.WndCaptionExcludeKey))then
    begin         
      tmpStr := GetWndTextName(AWnd);
      if ('' <> Trim(tmpAttach.FindSession.WndCaptionKey)) then
      begin
        if Pos(tmpAttach.FindSession.WndCaptionKey, tmpStr) < 1 then
        begin
          tmpIsFind := false;
        end;
      end;
      if ('' <> Trim(tmpAttach.FindSession.WndCaptionExcludeKey)) then
      begin
        if Pos(tmpAttach.FindSession.WndCaptionExcludeKey, tmpStr) > 0 then
        begin
          tmpIsFind := false;
        end;
      end;
    end;
  end;    
  if tmpIsFind then
  begin
    if Assigned(tmpAttach.FindSession.CheckFunc) then
    begin
      if (not tmpAttach.FindSession.CheckFunc(AWnd)) then
      begin
        tmpIsFind := false;
      end;
    end;
  end;
  if tmpIsFind then
  begin
    tmpAttach.ProcessWins[tmpAttach.ProcessWinCount].WindowHandle := AWnd;
    tmpAttach.FindSession.FindWindow[tmpAttach.FindSession.FindCount] :=
      @tmpAttach.ProcessWins[tmpAttach.ProcessWinCount];

    tmpAttach.FindSession.FindCount := tmpAttach.FindSession.FindCount + 1;
    tmpAttach.ProcessWinCount := tmpAttach.ProcessWinCount + 1;

    if 0 = tmpAttach.Process.ProcessId then
    begin
      Windows.GetWindowThreadProcessId(AWnd, tmpAttach.Process.ProcessId);
    end;
    if 255 <> tmpAttach.FindSession.NeedWinCount then
      tmpAttach.FindSession.NeedWinCount := tmpAttach.FindSession.NeedWinCount - 1;
    if tmpAttach.FindSession.NeedWinCount < 1 then
      // 找到不用再找了
      Result := false;
  end;
end;
       
procedure InitFindSession(AWindowFind: PExWindowFind);
begin
  AWindowFind.FindCount := 0;
  FillChar(AWindowFind.FindWindow, SizeOf(AWindowFind.FindWindow), 0);
  AWindowFind.NeedWinCount := 1;
  AWindowFind.WndClassKey := '';
  AWindowFind.WndCaptionKey := '';
  AWindowFind.WndCaptionExcludeKey := '';
  AWindowFind.CheckFunc := nil;        
end;
                 
end.
