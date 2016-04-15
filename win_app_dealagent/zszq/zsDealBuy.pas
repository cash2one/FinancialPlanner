unit zsDealBuy;

interface

uses     
  Windows, Sysutils,
  zsAttach;
  
  procedure ClickTreeBuyNode(AMainWindow: PZSMainWindow);
                                                                              
  function BuyStockByMoney(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; AMoney: Integer): Boolean;
  function BuyStockByNum(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; ANum: Integer): Boolean;
    
implementation

uses
  UtilsWindows,
  zsDialogDeal,
  zsMainWindow;
  
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


function BuyStockByMoney(AZsDealSession: PZsDealSession; AStockCode: AnsiString; APrice: double; AMoney: Integer): Boolean;
var  
  tmpNum: integer;
begin
  Result := false;  
  tmpNum := (Trunc(AMoney / APrice) div 100) * 100;
  if 0 < tmpNum then
  begin
    Result := BuyStockByNum(AZsDealSession, AStockCode, APrice, tmpNum);
  end;    
end;

function BuyStockByNum(AZsDealSession: PZsDealSession; AStockCode: AnsiString; APrice: double; ANum: Integer): Boolean;
var
  tmpWnd: HWND;
  i: integer;
begin
  Result := false;
  if 6 < Length(AStockCode) then
    AStockCode := Copy(AStockCode, Length(AStockCode) -  6 + 1, maxint);
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
          InputEditWnd(AZsDealSession.MainWindow.BuyWindowPtr.WndNumEdit, IntToStr(ANum));
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
       
end.
