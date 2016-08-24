unit floatwindow;

interface

uses
  Windows,
  Messages,
  Sysutils,
  BaseApp,
  UtilsHttp,
  BaseFloatWindow,
  StockInstantData_Get_Sina;

type              
  PRT_FloatWindow = ^TRT_FloatWindow;
  TRT_FloatWindow = record
    BaseFloatWindow: TRT_BaseFloatWindow;
    StockQuoteInstants: TInstantArray;
    HttpSession: UtilsHttp.THttpClientSession;
    IsFirstGot    : Byte;
  end;

  function CreateFloatWindow(App: TBaseApp): Boolean; overload;
  procedure CreateRefreshDataThread(AFloatWindow: PRT_FloatWindow);
  procedure ShowFloatWindow; overload;

implementation
              
uses
  IniFiles,
  windef_msg,
  define_dealitem,
  define_stock_quotes_instant,
  DealTime,
  UIBaseWndProc,
  uiwin.memdc
  //,Graphics
  ;

procedure Paint_FloatWindow(ADC: HDC; ABaseFloatWindow: PRT_BaseFloatWindow);
var
  tmpQuote: PRT_InstantQuote;
  i: integer;
  tmpX, tmpY: Integer;
  tmpSize: TSize;
  tmpHeight: integer;
  tmpNameWidth: Integer;
  tmpText: AnsiString;
  tmpOldFont: HFONT;
  tmpFloatWindow: PRT_FloatWindow;
begin
  tmpY := 4;
  tmpX := 4;
  tmpHeight := 0;
  tmpNameWidth := 0;
  //FillRect(ADC, AFloatWindow.BaseWindow.ClientRect, GetStockObject(BLACK_BRUSH));
  tmpFloatWindow := PRT_FloatWindow(ABaseFloatWindow);
  tmpOldFont := SelectObject(ADC, ABaseFloatWindow.Font);
  try
    SetBkMode(ADC, Transparent);
    SetTextColor(ADC, $FF000000);
    for i := low(tmpFloatWindow.StockQuoteInstants.Data) to high(tmpFloatWindow.StockQuoteInstants.Data) do
    begin
      tmpQuote := tmpFloatWindow.StockQuoteInstants.Data[i];
      if nil <> tmpQuote then
      begin
        tmpText := tmpQuote.Item.sCode;
        if '' <> tmpQuote.Item.Name then
        begin
          tmpText := Copy(tmpQuote.Item.Name, 1, 2);
        end;
        
        if 0 = tmpHeight then
        begin
          Windows.GetTextExtentPoint32A(ADC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
          tmpHeight := tmpSize.cy;
          tmpNameWidth := tmpSize.cx;
        end;             
        Windows.TextOutA(ADC, tmpX, tmpY, @tmpText[1], Length(tmpText));

        if 0 < tmpQuote.PriceRange.PriceClose.Value then
        begin
          tmpText := FormatFloat('0.00', tmpQuote.PriceRange.PriceClose.Value / 1000);  
          Windows.GetTextExtentPoint32A(ADC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
          Windows.TextOutA(ADC, tmpX + tmpNameWidth + 4, tmpY + 2, @tmpText[1], Length(tmpText));
        end;                                                                                   
        tmpY := tmpY + tmpHeight + 4;
      end;
    end;
  finally
    SelectObject(ADC, tmpOldFont);
  end;
end;
                 
function FloatWindowWndProcA(ABaseFloatWindow: PRT_BaseFloatWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    WM_Paint: begin
      WMPaint_FloatWindowWndProcA(ABaseFloatWindow, AWnd);
    end;
    WM_LBUTTONDBLCLK: begin
      SaveLayout(ABaseFloatWindow);
      ABaseFloatWindow.BaseApp.IsActiveStatus := 0;
      // sleep wait thread exit
      Sleep(500);
      PostQuitMessage(0);
    end;
    WM_MOVE: begin
      Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
    end;
    WM_LBUTTONDOWN: begin
      SendMessage(AWnd, WM_SysCommand, SC_Move or HTCaption, 0);
    end;
    WM_NCHITTEST: begin
      Result := HTCLIENT;//CAPTION;
    end;
    CM_INVALIDATE: begin
      Windows.BringWindowToTop(AWnd);
      Paint_FloatWindow_Layered(ABaseFloatWindow);
      //Windows.InvalidateRect(AWnd, nil, true);
    end;
    else
      Result := UIWndProcA(@ABaseFloatWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
  end;
end;

function ThreadProc_RefreshData(AParam: PRT_FloatWindow): HResult; stdcall;
var
  i: integer;
begin
  Result := 0;
  while True do
  begin           
    Sleep(20);
    if nil = AParam.BaseFloatWindow.BaseApp then
      Break;
    if 0 = AParam.IsFirstGot then
    begin
      AParam.IsFirstGot := 1;
    end else
    begin
      if not IsValidStockDealTime then
        Continue;  
    end;
    if 0 <> AParam.BaseFloatWindow.BaseApp.IsActiveStatus then
    begin
      DataGet_InstantArray_Sina(AParam.BaseFloatWindow.BaseApp, @AParam.StockQuoteInstants, @AParam.HttpSession, nil);
      PostMessage(AParam.BaseFloatWindow.BaseWindow.UIWndHandle, CM_INVALIDATE, 0, 0);
    end else
    begin
      Break;
    end; 
    for i := 1 to 300 do
    begin
      Sleep(20);
      if nil = AParam.BaseFloatWindow.BaseApp then
        Break;
      if 0 = AParam.BaseFloatWindow.BaseApp.IsActiveStatus then
        Break;
    end;
  end;
  ExitThread(Result);
end;

procedure CreateRefreshDataThread(AFloatWindow: PRT_FloatWindow);
begin
  AFloatWindow.BaseFloatWindow.DataThread.Core.ThreadHandle := Windows.CreateThread(nil, 0, @ThreadProc_RefreshData,
      AFloatWindow, Create_Suspended, AFloatWindow.BaseFloatWindow.DataThread.Core.ThreadID);
  Windows.ResumeThread(AFloatWindow.BaseFloatWindow.DataThread.Core.ThreadHandle);
end;

function CheckOutInstantQuote: PRT_InstantQuote;
begin
  Result := System.New(PRT_InstantQuote);
  FillChar(Result^, SizeOf(TRT_InstantQuote), 0);
end;

function CheckOutStockItem: PRT_DealItem;
begin
  Result := System.New(PRT_DealItem);
  FillChar(Result^, SizeOf(TRT_DealItem), 0);
end;

function CheckQuoteItem(AStockCode: AnsiString): PRT_InstantQuote;
begin
  Result := nil;
  if '' <> AStockCode then
  begin
    Result := CheckOutInstantQuote;
    Result.Item := CheckOutStockItem;
    Result.Item.sCode := AStockCode;
  end;
end;

function CreateFloatWindow(App: TBaseApp; AFloatWindow: PRT_FloatWindow; AWndProc: TFNWndProc): Boolean; overload;
var
  tmpRegWndClass: TWndClassA;
  tmpCheckWndClass: TWndClassA;  
  tmpIsRegistered: Boolean;
  tmpIni: TIniFile;
  i: integer;
  idx: integer;
  tmpDC: HDC;
  tmpText: AnsiString;
  tmpSize: TSize;
  tmpRowCount: integer;
  tmpLogFontA: TLogFontA;
  tmpOldFont: HFONT;
  tmpRect: TRect;
begin
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  FillChar(tmpCheckWndClass, SizeOf(tmpCheckWndClass), 0);
  if not IsWindow(AFloatWindow.BaseFloatWindow.BaseWindow.UIWndHandle) then
  begin
    FillChar(AFloatWindow^, SizeOf(TRT_FloatWindow), 0);
  end;

  AFloatWindow.BaseFloatWindow.BaseApp := App;
  AFloatWindow.BaseFloatWindow.OnPaint := Paint_FloatWindow;
  //AFloatWindow.HttpSession.ConnectionSession.SendTimeOut := 200;
  //AFloatWindow.HttpSession.ConnectionSession.ConnectTimeOut := 200;
  //AFloatWindow.HttpSession.ConnectionSession.ReceiveTimeOut := 200;

  FillChar(tmpLogFontA, SizeOf(tmpLogFontA), 0);
  tmpLogFontA.lfHeight := 12;
  tmpLogFontA.lfHeight := 10;  
  tmpLogFontA.lfWidth := 0;  
  tmpLogFontA.lfFaceName := 'MS Sans Serif';
  tmpLogFontA.lfCharSet := DEFAULT_CHARSET;
  tmpLogFontA.lfPitchAndFamily := FIXED_PITCH;
  AFloatWindow.BaseFloatWindow.Font := Windows.CreateFontIndirectA(tmpLogFontA);

  tmpDC := GetDC(0);
  try
    tmpOldFont := SelectObject(tmpDC, AFloatWindow.BaseFloatWindow.Font);
    try
      tmpText := 'Äã 100.00';
      Windows.GetTextExtentPoint32A(tmpDC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
    finally
      SelectObject(tmpDC, tmpOldFont);
    end;
  finally
    ReleaseDC(0, tmpDC);
  end;

  tmpRowCount := 0;
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    idx := 1;
    for i := Low(AFloatWindow.StockQuoteInstants.Data) to High(AFloatWindow.StockQuoteInstants.Data) do
    begin
      AFloatWindow.StockQuoteInstants.Data[i] := CheckQuoteItem(tmpIni.ReadString('stock' + IntToStr(idx), 'code', ''));
      Inc(idx);
      if nil <> AFloatWindow.StockQuoteInstants.Data[i] then
      begin
        Inc(tmpRowCount);
      end;
    end;
    AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Left := tmpIni.ReadInteger('win', 'left', 0);
    AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Top := tmpIni.ReadInteger('win', 'top', 0);


    Windows.SystemParametersInfo(SPI_GETWORKAREA, 0, @tmpRect, 0);
    if AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Top > tmpRect.Bottom - 100 then
      AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Top := tmpRect.Bottom - 100;
    if AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Left > tmpRect.Right - 100 then
      AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Left := tmpRect.Right - 100;
    tmpIni.WriteInteger('win', 'left', AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;

  tmpRegWndClass.style := CS_VREDRAW or CS_HREDRAW or CS_DBLCLKS;
  tmpRegWndClass.hInstance := HInstance;
  //tmpRegWndClass.hbrBackground := GetStockObject(GRAY_BRUSH);
  tmpRegWndClass.hbrBackground := GetStockObject(WHITE_BRUSH);  
  tmpRegWndClass.hCursor := LoadCursorA(0, IDC_ARROW);
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.lpszClassName := 'StockFloater1';
  
  tmpIsRegistered := Windows.GetClassInfoA(HInstance, tmpRegWndClass.lpszClassName, tmpCheckWndClass);

  if tmpIsRegistered then
  begin
    if tmpCheckWndClass.lpfnWndProc <> AWndProc then
    begin
      Windows.UnregisterClass(tmpRegWndClass.lpszClassName, HInstance);
      tmpIsRegistered := false;
    end;
  end;
  if not tmpIsRegistered then
  begin
    Windows.RegisterClassA(tmpRegWndClass);
  end;
  AFloatWindow.BaseFloatWindow.BaseWindow.Style := WS_POPUP;
  AFloatWindow.BaseFloatWindow.BaseWindow.ExStyle := WS_EX_TOOLWINDOW
      or WS_EX_LAYERED 
      or WS_EX_TOPMOST;

  if 0 < tmpSize.cx then
  begin
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Right := tmpSize.cx + 8;
  end else
  begin
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Right := 80;
  end;
  if 0 < tmpSize.cy then
  begin
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Bottom := tmpRowCount * (tmpSize.cy + 4) + 4;
  end;

  UpdateMemDC(@AFloatWindow.BaseFloatWindow.MemDC,
      AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Right,
      AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Bottom);

  AFloatWindow.BaseFloatWindow.BaseWindow.UIWndHandle := Windows.CreateWindowExA(
    AFloatWindow.BaseFloatWindow.BaseWindow.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    AFloatWindow.BaseFloatWindow.BaseWindow.Style {+ 0},
    AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Left,
    AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Top,
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Right,
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Bottom, 0, 0, HInstance, nil);

  Result := IsWindow(AFloatWindow.BaseFloatWindow.BaseWindow.UIWndHandle);
end;

procedure ShowFloatWindow(AFloatWindow: PRT_FloatWindow); overload;
begin
  ShowWindow(AFloatWindow.BaseFloatWindow.BaseWindow.UIWndHandle, SW_SHOW);
  UpdateWindow(AFloatWindow.BaseFloatWindow.BaseWindow.UIWndHandle);
  Paint_FloatWindow_Layered(@AFloatWindow.BaseFloatWindow);
  CreateRefreshDataThread(AFloatWindow);
end;
             
var
  Global_FloatWindow_1: TRT_FloatWindow;
                      
function FloatWndProcA_1(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := FloatWindowWndProcA(@Global_FloatWindow_1, AWnd, AMsg, wParam, lParam);
end;

function CreateFloatWindow(App: TBaseApp): Boolean;
begin
  Result := CreateFloatWindow(App, @Global_FloatWindow_1, @FloatWndProcA_1);
end;
           
procedure ShowFloatWindow;
begin
  ShowFloatWindow(@Global_FloatWindow_1);
end;
             
end.
