unit zsDealSale;

interface
                
uses
  Windows, SysUtils,
  zsAttach;
   
  procedure ClickTreeSaleNode(AMainWindow: PZSMainWindow);
                   
  function SaleStock(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; ANum: Integer): Boolean;
    
implementation

uses
  UtilsWindows,
  zsMainWindow;
  
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

function SaleStock(AZsDealSession: PZsDealSession;
    AStockCode: AnsiString; APrice: double; ANum: Integer): Boolean;
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

end.
