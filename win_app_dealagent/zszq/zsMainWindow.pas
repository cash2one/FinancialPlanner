unit zsMainWindow;

interface
       
uses
  Windows, Messages, Graphics, zsAttach, zsProcess;
       
  function FindZSMainWindow(AZsDealSession: PZsDealSession): Boolean;
                                                         

  procedure CheckZSMainWindow(AMainWindow: PZSMainWindow);
  procedure CheckZSOrderWindow(AMainWindow: PZSMainWindow);
  procedure CheckZSMoneyWindow(AMainWindow: PZSMainWindow);
   
  procedure CheckDealPanelSize(AMainWindow: PZSMainWindow);
  procedure ClickMenuOrderMenuItem(AMainWindow: PZSMainWindow);
                                                              
implementation

uses
  SysUtils,
  UtilsWindows,
  zsDialogUtils,
  zsDealBuy,
  zsDealSale,
  CommCtrl;

{
  CommCtrl, SysTreeView32

  TreeNodeCount := return (uint)SendMessage(hwnd, TVM_GETCOUNT, 0, 0);

  function CommCtrl.TreeView_GetRoot(hwnd: HWND): HTreeItem;
  Root := TreeView_GetNextItem(hwnd, 0, TVGN_ROOT);
  function CommCtrl.TreeView_GetNextItem(hwnd: HWND; hitem: HTreeItem; code: Integer): HTreeItem; inline;
}       
procedure ClickMenuOrderMenuItem(AMainWindow: PZSMainWindow);
var
  tmpWnd: HWND;
begin
  tmpWnd := AMainWindow.TopMenu.WndOrderButton;
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
    UtilsWindows.ClickButtonWnd(tmpWnd);
  end;
end;
  
function FindZSMainWindow(AZsDealSession: PZsDealSession): Boolean;
begin
  if nil <> AZsDealSession.MainWindow.HostWindowPtr then
  begin
    if not IsWindow(AZsDealSession.MainWindow.HostWindowPtr.WindowHandle) then
    begin
      AZsDealSession.MainWindow.HostWindowPtr := nil;
    end;
  end;
  if nil = AZsDealSession.MainWindow.HostWindowPtr then
  begin
    AZsDealSession.ProcessAttach.FindSession.WndClassKey := 'TdxW_MainFrame_Class';
    AZsDealSession.ProcessAttach.FindSession.WndCaptionKey := '招商证券智远理财服务平台';
    AZsDealSession.ProcessAttach.FindSession.WndCaptionExcludeKey := '';
    AZsDealSession.ProcessAttach.FindSession.CheckFunc := nil;
    AZsDealSession.ProcessAttach.FindSession.NeedWinCount := 1;

    AZsDealSession.ProcessAttach.FindSession.FindCount := 0;
    FillChar(AZsDealSession.ProcessAttach.FindSession.FindWindow, SizeOf(AZsDealSession.ProcessAttach.FindSession.FindWindow), 0);
    
    Windows.EnumWindows(@EnumFindDesktopWindowProc, Integer(AZsDealSession));
  end;
  Result := AZsDealSession.ProcessAttach.FindSession.FindCount > 0;
  if Result then
  begin        
    AZsDealSession.MainWindow.HostWindowPtr := AZsDealSession.ProcessAttach.FindSession.FindWindow[0];
  end;
end;

function FindZSDealPanel(AMainWindow: PZSMainWindow): Boolean;
begin
  //通达信网上交易
  Result := false;
end;

type  
  PTraverse_MainWindow = ^TTraverse_MainWindow;
  TTraverse_MainWindow = record
    MainWindow: PZSMainWindow;
  end;

procedure ParseMoneyText(AMainWindow: PZSMainWindow; AText: string);
var
  tmpPos: integer;
  tmpHead: string;
  tmpValue: string;
  tmpData: string;
begin
  tmpData := Trim(AText);
  tmpPos := Pos(':', tmpData);
  while 0 < tmpPos do
  begin
    tmpHead := Trim(Copy(tmpData, 1, tmpPos - 1));
    tmpValue := '';
    tmpData := Copy(tmpData, tmpPos + 1, maxint);
    tmpPos := Pos(#32, tmpData);
    if 0 < tmpPos then
    begin
      tmpValue := Copy(tmpData, 1, tmpPos - 1);
      tmpData := Copy(tmpData, tmpPos + 1, maxint);      
    end else
    begin
      tmpValue := tmpData;
    end;
    if '' <> tmpValue then
    begin
      if SameText('余额', tmpHead) then
      begin
        AMainWindow.MoneyData.Balance := StrToFloatDef(tmpValue, 0); 
      end;           
      if SameText('可用', tmpHead) then
      begin
        AMainWindow.MoneyData.Available := StrToFloatDef(tmpValue, 0); 
      end;         
      if SameText('可取', tmpHead) then
      begin
        AMainWindow.MoneyData.Extractable := StrToFloatDef(tmpValue, 0); 
      end;    
      if SameText('参考市值', tmpHead) then
      begin
        AMainWindow.MoneyData.ValueRef := StrToFloatDef(tmpValue, 0); 
      end;        
      if SameText('资产', tmpHead) then
      begin
        AMainWindow.MoneyData.Asset := StrToFloatDef(tmpValue, 0); 
      end;       
      if SameText('盈亏', tmpHead) then
      begin
        AMainWindow.MoneyData.ProfitAndLoss := StrToFloatDef(tmpValue, 0);
      end; 
    end;
    tmpPos := Pos(':', tmpData);
  end;
end;

procedure TraverseCheckMainChildWindowA(AWnd: HWND; ATraverseWindow: PTraverse_MainWindow);
var
  tmpWndChild: HWND;
  tmpStr: string;  
  tmpCtrlId: integer;
  tmpIsHandled: Boolean;
begin
  if not IsWindowVisible(AWnd) then
    exit;             
  if not IsWindowEnabled(AWnd) then
    exit;                       
  tmpStr := GetWndClassName(AWnd); 
  tmpIsHandled := False;
  tmpCtrlId := Windows.GetDlgCtrlID(AWnd); 
  if 0 = tmpCtrlId then
  begin
    if 0 = ATraverseWindow.MainWindow.WndDealPanel then
    begin
      tmpStr := GetWndTextName(AWnd);
      if 0 < Pos('通达信网上交易', tmpStr) then
      begin
        ATraverseWindow.MainWindow.WndDealPanel := AWnd;
      end;
    end;
  end;    
  if SameText('SysTreeView32', tmpStr) then
  begin
    if $E900 = tmpCtrlId then
    begin
      tmpIsHandled := true;
      ATraverseWindow.MainWindow.WndFunctionTree := AWnd;
    end;
  end;    
  if not tmpIsHandled then
  begin
    if SameText('AfxWnd42', tmpStr) then
    begin
      if $BC5 = tmpCtrlId then
      begin                   
        tmpIsHandled := true;
        ATraverseWindow.MainWindow.TopMenu.WndOrderButton := AWnd;
      end;
    end;
  end;   
  if not tmpIsHandled then
  begin         
    if SameText('Edit', tmpStr) then
    begin                    
      tmpIsHandled := true;
      if $2EE5 = tmpCtrlId then
      begin
        ATraverseWindow.MainWindow.CurrentDealWindow.WndStockCodeEdit := AWnd;
      end;
      if $2EE6 = tmpCtrlId then
      begin
        ATraverseWindow.MainWindow.CurrentDealWindow.WndPriceEdit := AWnd;
      end;        
      if $2EE7 = tmpCtrlId then
      begin
        ATraverseWindow.MainWindow.CurrentDealWindow.WndNumEdit := AWnd;
      end;
    end;
  end;    
  if not tmpIsHandled then
  begin
    if SameText('Button', tmpStr) then
    begin
      tmpIsHandled := true;    
      if $7DA = tmpCtrlId then
        ATraverseWindow.MainWindow.CurrentDealWindow.WndOrderButton := AWnd;
    end;
  end;      
  if not tmpIsHandled then
  begin
    if $628 = tmpCtrlId then
    begin
      tmpIsHandled := true;
      tmpStr := GetWndTextName(AWnd);
      if '' <> tmpStr then
      begin
        ParseMoneyText(ATraverseWindow.MainWindow, tmpStr);
      end;
    end;
  end;     
  if not tmpIsHandled then
  begin                         
    if ($1FCB = tmpCtrlId) then
    begin
      tmpIsHandled := true;   
      tmpStr := GetWndTextName(AWnd);   
      ATraverseWindow.MainWindow.BuyWindowPtr := nil;     
      if '' <> tmpStr then
      begin
        if Pos('买入', tmpStr) > 0 then
        begin
          ATraverseWindow.MainWindow.BuyWindowPtr := @ATraverseWindow.MainWindow.CurrentDealWindow;
          ATraverseWindow.MainWindow.SaleWindowPtr := nil;
        end;
      end;
    end;
    if ($1FD7 = tmpCtrlId) then
    begin           
      tmpIsHandled := true;   
      tmpStr := GetWndTextName(AWnd);
      ATraverseWindow.MainWindow.SaleWindowPtr := nil;
      if '' <> tmpStr then
      begin
        if Pos('卖出', tmpStr) > 0 then
        begin
          ATraverseWindow.MainWindow.SaleWindowPtr := @ATraverseWindow.MainWindow.CurrentDealWindow;  
          ATraverseWindow.MainWindow.BuyWindowPtr := nil;
        end;
      end;
    end;
  end;                     
  if not tmpIsHandled then
  begin
    if ($E81E = tmpCtrlId) then
    begin
      if SameText('AfxControlBar42', tmpStr) then
      begin
        ATraverseWindow.MainWindow.WndDealPanelRoot := AWnd;
        CheckDealPanelSize(ATraverseWindow.MainWindow);
      end;
    end;
  end;
  //=====================================================      
  if not tmpIsHandled then
  begin
    tmpWndChild := Windows.GetWindow(AWnd, GW_CHILD);
    while 0 <> tmpWndChild do
    begin
      TraverseCheckMainChildWindowA(tmpWndChild, ATraverseWindow);       
      tmpWndChild := Windows.GetWindow(tmpWndChild, GW_HWNDNEXT);
    end;
  end;
end;

procedure CheckDealPanelSize(AMainWindow: PZSMainWindow);
var  
  tmpWinRect: TRect;
  tmpClientRect: TRect;
  i: Integer;
  dy: integer;
  tmpDy1: integer;
  tmpDyOffset: integer;

  tmpMoveDownOffset: integer;

  tmpCounter: integer;
  tmpIsHandled: Boolean; 
begin
  if not IsWindow(AMainWindow.WndDealPanelRoot) then
    exit;
  if not IsWindowVisible(AMainWindow.WndDealPanelRoot) then
    exit;            
  Windows.GetClientRect(AMainWindow.WndDealPanelRoot, tmpClientRect);
  if tmpClientRect.Bottom = tmpClientRect.Top then
    exit;
  if 4 > (tmpClientRect.Bottom - tmpClientRect.Top) then
    exit;
    
  tmpCounter := 0;
  tmpIsHandled := false;
  while (tmpCounter < 2) and (not tmpIsHandled) do
  begin
    if tmpIsHandled then
      Break;
    tmpDyOffset := 3;
    while (0 <= tmpDyOffset) and (not tmpIsHandled) do
    begin
      Windows.GetClientRect(AMainWindow.WndDealPanelRoot, tmpClientRect);
      if 350 > (tmpClientRect.Bottom - tmpClientRect.Top) then
      begin
        ForceBringFrontWindow(AMainWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
        ForceBringFrontWindow(AMainWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
        // 242                                                      
        Windows.GetWindowRect(AMainWindow.WndDealPanelRoot, tmpWinRect);
        tmpDy1 := 400 - (tmpWinRect.Bottom - tmpWinRect.Top);

        for tmpMoveDownOffset := 5 to 7 do
        begin
          Windows.SetCursorPos(tmpWinRect.Left + tmpWinRect.Right div 2, tmpWinRect.Top - tmpDyOffset);
          for i := 1 to tmpMoveDownOffset do
          begin  
            Windows.mouse_event(MOUSEEVENTF_MOVE, // MOUSEEVENTF_ABSOLUTE or
                0,
                1,
                0,
                0);
          end;         
          dy := tmpDy1;       
          SleepWait(20);
                             
          Windows.mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);   
          SleepWait(20);
          while dy > 0 do
          begin
            Windows.mouse_event(MOUSEEVENTF_MOVE, // MOUSEEVENTF_ABSOLUTE or
              0,
              DWORD(-10),
              0,
              0);
            SleepWait(20);
            dy := dy - 10;
          end;
          Windows.mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0); 
          SleepWait(20);
        
          Windows.GetClientRect(AMainWindow.WndDealPanelRoot, tmpClientRect);     
          if 350 < (tmpClientRect.Bottom - tmpClientRect.Top) then
          begin
            tmpIsHandled := True;
            Break;
          end;
        end;
      end else
      begin
        tmpCounter := 5;
      end;
      tmpDyOffset := tmpDyOffset - 1;
    end;
    tmpCounter := tmpCounter + 1;
  end;
end;

procedure CheckZSMainWindow(AMainWindow: PZSMainWindow);
var
  tmpTraverse_Window: TTraverse_MainWindow;
begin
  if nil = AMainWindow.HostWindowPtr then
    exit;
  if IsWindow(AMainWindow.WndFunctionTree) then
    exit;
  FillChar(tmpTraverse_Window, SizeOf(tmpTraverse_Window), 0);
  tmpTraverse_Window.MainWindow := AMainWindow;   
  if not IsWindow(AMainWindow.WndDealPanel) then
    AMainWindow.WndDealPanel := 0;  
  if not IsWindow(AMainWindow.WndDealPanelRoot) then
    AMainWindow.WndDealPanelRoot := 0;
    
  TraverseCheckMainChildWindowA(AMainWindow.HostWindowPtr.WindowHandle, @tmpTraverse_Window);
end;
                             
procedure CheckZSMoneyWindow(AMainWindow: PZSMainWindow);
var
  tmpTraverse_Window: TTraverse_MainWindow;
begin
  if nil = AMainWindow.HostWindowPtr then
    exit;
  FillChar(tmpTraverse_Window, SizeOf(tmpTraverse_Window), 0);
  tmpTraverse_Window.MainWindow := AMainWindow;
  if not IsWindow(AMainWindow.WndDealPanel) then
    AMainWindow.WndDealPanel := 0;      
  if not IsWindow(AMainWindow.WndDealPanelRoot) then
    AMainWindow.WndDealPanelRoot := 0;
    
  TraverseCheckMainChildWindowA(AMainWindow.HostWindowPtr.WindowHandle, @tmpTraverse_Window);
end;                                         
    
procedure CheckZSOrderWindow(AMainWindow: PZSMainWindow);
var
  tmpTraverse_Window: TTraverse_MainWindow;
begin
  if nil = AMainWindow.HostWindowPtr then
    exit;
  FillChar(tmpTraverse_Window, SizeOf(tmpTraverse_Window), 0);
  tmpTraverse_Window.MainWindow := AMainWindow;
  if not IsWindow(AMainWindow.WndDealPanel) then
    AMainWindow.WndDealPanel := 0;
  if not IsWindow(AMainWindow.WndDealPanelRoot) then
    AMainWindow.WndDealPanelRoot := 0;

  if 0 = AMainWindow.WndDealPanel then
  begin
    TraverseCheckMainChildWindowA(AMainWindow.HostWindowPtr.WindowHandle, @tmpTraverse_Window);
  end else
  begin
    TraverseCheckMainChildWindowA(AMainWindow.WndDealPanel, @tmpTraverse_Window);
  end;
end;
                         
end.
