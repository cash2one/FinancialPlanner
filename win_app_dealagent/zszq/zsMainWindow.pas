unit zsMainWindow;

interface
       
uses
  Windows, Messages, Graphics, zsAttach, zsProcess;
       
  function FindZSMainWindow(AZsDealSession: PZsDealSession): Boolean;
                                                         
  function FindZSHintDialogWindow(AZsDealSession: PZsDealSession): Boolean;   
  function FindZSDealConfirmDialogWindow(AZsDealSession: PZsDealSession): Boolean;

  function FindZSPasswordConfirmDialogWindow(AZsDealSession: PZsDealSession): Boolean;
  procedure CheckZSPasswordConfirmDialogWindow(AWindow: PZSDealPasswordConfirmDialogWindow);

  function FindZSLockPanelWindow(AZsDealSession: PZsDealSession): Boolean;

  procedure CheckZSMainWindow(AMainWindow: PZSMainWindow);
  procedure CheckZSOrderWindow(AMainWindow: PZSMainWindow);
  procedure CheckZSMoneyWindow(AMainWindow: PZSMainWindow);
   
  procedure CheckDealPanelSize(AMainWindow: PZSMainWindow);


  procedure ClickTreeBuyNode(AMainWindow: PZSMainWindow);
  procedure ClickTreeSaleNode(AMainWindow: PZSMainWindow);
  procedure ClickTreeCancelNode(AMainWindow: PZSMainWindow);
  procedure ClickTreeQueryHoldNode(AMainWindow: PZSMainWindow);
  procedure ClickMenuOrderMenuItem(AMainWindow: PZSMainWindow);
                                                                                                            
  function BuyStock(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; AMoney: Integer): Boolean;  
  function SaleStock(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; ANum: Integer): Boolean;
    
  procedure ConfirmDeal(AZsDealSession: PZsDealSession);
  procedure ConfirmAlwaysPwdInput(AZsDealSession: PZsDealSession);

implementation

uses
  SysUtils,
  UtilsWindows,
  zsDialogUtils,
  CommCtrl;

{
  CommCtrl, SysTreeView32

  TreeNodeCount := return (uint)SendMessage(hwnd, TVM_GETCOUNT, 0, 0);

  function CommCtrl.TreeView_GetRoot(hwnd: HWND): HTreeItem;
  Root := TreeView_GetNextItem(hwnd, 0, TVGN_ROOT);
  function CommCtrl.TreeView_GetNextItem(hwnd: HWND; hitem: HTreeItem; code: Integer): HTreeItem; inline;
}
function BuyStock(AZsDealSession: PZsDealSession; AStockCode: AnsiString; APrice: double; AMoney: Integer): Boolean;
var
  tmpNum: integer;
  tmpWnd: HWND;
  i: integer;
begin
  Result := false;
  if 0 < APrice then
  begin
    tmpNum := (Trunc(AMoney / APrice) div 100) * 100;
    if 0 < tmpNum then
    begin    
      if nil = AZsDealSession.MainWindow.HostWindowPtr then
      begin
        if not FindZSMainWindow(AZsDealSession) then
          exit;
      end;
      CheckZSMainWindow(@AZsDealSession.MainWindow);
      if nil = AZsDealSession.MainWindow.HostWindowPtr then
        exit;           
      if nil <> AZsDealSession.MainWindow.BuyWindowPtr then
      begin
        if not IsWindow(AZsDealSession.MainWindow.BuyWindowPtr.WndStockCodeEdit) then
        begin
          AZsDealSession.MainWindow.BuyWindowPtr := nil;
        end;
      end;                                              
      if nil = AZsDealSession.MainWindow.BuyWindowPtr then
      begin
        CheckZSOrderWindow(@AZsDealSession.MainWindow);
      end;
      if nil = AZsDealSession.MainWindow.BuyWindowPtr then
      begin
        ClickTreeBuyNode(@AZsDealSession.MainWindow);  
        for i := 0 to 10 do
        begin
          SleepWait(20);
          CheckZSOrderWindow(@AZsDealSession.MainWindow);
          if nil <> AZsDealSession.MainWindow.BuyWindowPtr then
            Break;
        end;
      end;
  
      tmpWnd := AZsDealSession.MainWindow.HostWindowPtr.WindowHandle;
      if IsWindow(tmpWnd) then
      begin
        ForceBringFrontWindow(tmpWnd);
        SleepWait(20);
        ForceBringFrontWindow(tmpWnd);
        SleepWait(20);
      end;
      if nil <> AZsDealSession.MainWindow.BuyWindowPtr then
      begin
        if IsWindow(AZsDealSession.MainWindow.BuyWindowPtr.WndStockCodeEdit) then
        begin
          InputEditWnd(AZsDealSession.MainWindow.BuyWindowPtr.WndStockCodeEdit, AStockCode);
          SleepWait(20);
          InputEditWnd(AZsDealSession.MainWindow.BuyWindowPtr.WndPriceEdit, FormatFloat('0.00', APrice));
          SleepWait(20);
          InputEditWnd(AZsDealSession.MainWindow.BuyWindowPtr.WndNumEdit, IntToStr(tmpNum));
          SleepWait(20);
          Result := ClickButtonWnd(AZsDealSession.MainWindow.BuyWindowPtr.WndOrderButton);
          if Result then
          begin
            ConfirmDeal(AZsDealSession);
          end;
        end;
      end;      
    end;
  end;
end;
              
function SaleStock(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; ANum: Integer): Boolean;
var     
  tmpWnd: HWND;
  i: integer;
begin
  Result := false;
  if 0 < APrice then
  begin
    if 0 < ANum then
    begin    
      if nil = AZsDealSession.MainWindow.HostWindowPtr then
      begin
        if not FindZSMainWindow(AZsDealSession) then
          exit;
      end;
      CheckZSMainWindow(@AZsDealSession.MainWindow);
      if nil = AZsDealSession.MainWindow.HostWindowPtr then
        exit;
      if nil <> AZsDealSession.MainWindow.SaleWindowPtr then
      begin
        if not IsWindow(AZsDealSession.MainWindow.SaleWindowPtr.WndStockCodeEdit) then
        begin
          AZsDealSession.MainWindow.SaleWindowPtr := nil;
        end;
      end;                                     
      if nil = AZsDealSession.MainWindow.SaleWindowPtr then
      begin
        CheckZSOrderWindow(@AZsDealSession.MainWindow);
      end;
      if nil = AZsDealSession.MainWindow.SaleWindowPtr then
      begin
        ClickTreeSaleNode(@AZsDealSession.MainWindow);
        for i := 0 to 10 do
        begin
          SleepWait(20);
          CheckZSOrderWindow(@AZsDealSession.MainWindow);  
          if nil <> AZsDealSession.MainWindow.SaleWindowPtr then
            Break;
        end;
      end;
  
      tmpWnd := AZsDealSession.MainWindow.HostWindowPtr.WindowHandle;
      if IsWindow(tmpWnd) then
      begin
        ForceBringFrontWindow(tmpWnd);
        SleepWait(20);
        ForceBringFrontWindow(tmpWnd);
        SleepWait(20);
      end;
      if nil <> AZsDealSession.MainWindow.SaleWindowPtr then
      begin
        if IsWindow(AZsDealSession.MainWindow.SaleWindowPtr.WndStockCodeEdit) then
        begin
          InputEditWnd(AZsDealSession.MainWindow.SaleWindowPtr.WndStockCodeEdit, AStockCode);
          SleepWait(20);
          InputEditWnd(AZsDealSession.MainWindow.SaleWindowPtr.WndPriceEdit, FormatFloat('0.00', APrice));
          SleepWait(20);
          InputEditWnd(AZsDealSession.MainWindow.SaleWindowPtr.WndNumEdit, IntToStr(ANum));
          SleepWait(20);
          Result := ClickButtonWnd(AZsDealSession.MainWindow.SaleWindowPtr.WndOrderButton);
          if Result then
          begin
            ConfirmDeal(AZsDealSession);
          end;
        end;
      end;      
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

procedure ClickTreeBuyNode(AMainWindow: PZSMainWindow);
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
    Windows.SetCursorPos(tmpRect.Left + 30, tmpRect.Top + 10);
    SleepWait(20);
    Windows.mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;
end;

procedure ClickTreeSaleNode(AMainWindow: PZSMainWindow);  
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
    Windows.SetCursorPos(tmpRect.Left + 30, tmpRect.Top + 30);
    SleepWait(20);
    Windows.mouse_event(MOUSEEVENTF_LEFTDOWN or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;
end;

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

function FindZSHintDialogWindow(AZsDealSession: PZsDealSession): Boolean;
var
  i: integer;
begin
  InitFindSession(@AZsDealSession.ProcessAttach.FindSession);   
  AZsDealSession.DealConfirmDialog := nil;
  AZsDealSession.ProcessAttach.FindSession.NeedWinCount := 255;
  AZsDealSession.ProcessAttach.FindSession.WndClassKey := '#32770';  
  AZsDealSession.ProcessAttach.FindSession.WndCaptionKey := '提示';
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
  if IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput) then
  begin
    InputEditWnd(AZsDealSession.MainWindow.DealLockPanelWindow.WndPasswordInput, '275318');
    ClickButtonWnd(AZsDealSession.MainWindow.DealLockPanelWindow.WndOKButton);
  end;
  Result := IsWindow(AZsDealSession.MainWindow.DealLockPanelWindow.WndPanel);
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
