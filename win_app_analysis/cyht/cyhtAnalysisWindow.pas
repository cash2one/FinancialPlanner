unit cyhtAnalysisWindow;

interface

uses
  Windows,
  Messages,
  Sysutils,
  BaseApp,
  QuickList_double,
  win.thread,
  UIBaseWin,
  ui.color,
  uiwin.memdc;

type
  PRT_cyhtAnalysisWindow = ^TRT_cyhtAnalysisWindow;
  TRT_cyhtAnalysisWindow = record
    BaseApp       : TBaseApp;
    BaseWindow    : TUIBaseWnd;
    DataThread    : TSysWinThread;
    Font          : HFONT;
    MemDC         : TWinMemDC;
//    StockQuoteInstants: TInstantArray;
    IsFirstGot    : Byte;
    RowCount      : integer;
    RateList      : TALDoubleList;
  end;

  function CreatecyhtAnalysisWindow(App: TBaseApp): Boolean; overload;
  procedure CreateRefreshDataThread(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow);
  procedure ShowcyhtAnalysisWindow; overload;

implementation
              
uses
  IniFiles,
  UIBaseWndProc,
  windef_msg,
  Define_DealItem,
  cyhtAnalysisWinApp  //,Graphics
  ;

procedure SaveLayout(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow);
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteInteger('win', 'left', cyhtAnalysisWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', cyhtAnalysisWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;
end;

procedure Paint_cyhtAnalysisWindow(ADC: HDC; cyhtAnalysisWindow: PRT_cyhtAnalysisWindow);
var
//  tmpQuote: PRT_InstantQuote;
  i: integer;
  tmpX, tmpY: Integer;
  tmpSize: TSize;
  tmpHeight: integer;
  tmpNameWidth: Integer;
  tmpText: AnsiString;
  tmpOldFont: HFONT;
  //tmpOldBrush: HBRUSH;
  //tmpOldPen: HPEN;
  tmpIdx: integer;
  tmpRate: Double;
begin
  tmpY := 4;
  tmpX := 4;
  tmpHeight := 0;
  tmpNameWidth := 0;
                          
  SetBkMode(ADC, Transparent);
  //tmpOldPen := SelectObject(ADC, GetStockObject(BLACK_PEN));
  //tmpOldPen := SelectObject(ADC, GetStockObject(WHITE_PEN));
  //tmpOldBrush := SelectObject(ADC, GetStockObject(GRAY_BRUSH));
  //Windows.MoveToEx(ADC, 0, cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom - 1, nil);
  //Windows.LineTo(ADC, cyhtAnalysisWindow.BaseWindow.ClientRect.Right, cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom - 1);
  //SelectObject(ADC, tmpOldBrush);
  //SelectObject(ADC, tmpOldPen);  
  //FillRect(ADC, cyhtAnalysisWindow.BaseWindow.ClientRect, GetStockObject(WHITE_BRUSH));
  //FrameRect(ADC, cyhtAnalysisWindow.BaseWindow.ClientRect, GetStockObject(BLACK_BRUSH));

  tmpOldFont := SelectObject(ADC, cyhtAnalysisWindow.Font);
  try
    SetTextColor(ADC, $FF000000);
    tmpIdx := cyhtAnalysisWindow.RateList.Count - 1;
    for i := 0 to cyhtAnalysisWindow.RowCount - 1 do
    begin
      tmpRate := 0;
      if 0 <= tmpIdx then
      begin
        tmpRate := cyhtAnalysisWindow.RateList[tmpIdx];
      end;
      tmpText := 'A';
      if 0 < tmpRate then
      begin
        tmpIdx := tmpIdx - 1;
        tmpText := PRT_DealItem(cyhtAnalysisWindow.RateList.Objects[tmpIdx]).sCode;
      end;
//        if '' <> tmpQuote.Item.Name then
//        begin
//          tmpText := Copy(tmpQuote.Item.Name, 1, 2);
//        end;
//
      if 0 = tmpHeight then
      begin
        Windows.GetTextExtentPoint32A(ADC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
        tmpHeight := tmpSize.cy;
        tmpNameWidth := tmpSize.cx;
      end;
      if '' <> tmpText then
      begin
        Windows.TextOutA(ADC, tmpX, tmpY, @tmpText[1], Length(tmpText));  
        tmpY := tmpY + tmpHeight + 4;
      end;
//
//        if 0 < tmpQuote.PriceRange.PriceClose.Value then
//        begin
//          tmpText := FormatFloat('0.00', tmpQuote.PriceRange.PriceClose.Value / 1000);
//          Windows.GetTextExtentPoint32A(ADC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
//          Windows.TextOutA(ADC, tmpX + tmpNameWidth + 4, tmpY + 2, @tmpText[1], Length(tmpText));
//        end;
    end;
  finally
    SelectObject(ADC, tmpOldFont);
  end;
end;
                 
function WMPaint_cyhtAnalysisWindowWndProcA(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow; AWnd: HWND): LRESULT;
var
  tmpPS: TPaintStruct;
  tmpDC: HDC;
begin
  Result := 0;
  tmpDC := BeginPaint(AWnd, tmpPS);
  try
    Paint_cyhtAnalysisWindow(tmpDC, cyhtAnalysisWindow);
  finally
  end;
  EndPaint(AWnd, tmpPS);
end;
                       
procedure Paint_cyhtAnalysisWindow_Layered(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow);
var
  tmpBlend: TBLENDFUNCTION;
  i, j: Integer;  
  tmpColor: PColor32Array;
begin
  if 0 = cyhtAnalysisWindow.MemDC.DCHandle then
  begin
    UpdateMemDC(@cyhtAnalysisWindow.MemDC,
        cyhtAnalysisWindow.BaseWindow.ClientRect.Right,
        cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom);
  end;                                   
  tmpColor := cyhtAnalysisWindow.MemDC.MemBitmap.BitsData;
  if tmpColor <> nil then
  begin
    for i := 0 to cyhtAnalysisWindow.MemDC.Height - 1 do
    begin
      for j := 0 to cyhtAnalysisWindow.MemDC.Width - 1 do
      begin
        //PColor32Entry(tmpColor).A := 255;
        PColor32Entry(tmpColor).A := 1;       
        //PColor32Entry(tmpColor).B := 255;
        Inc(tmpColor);
      end;
    end;
  end;
  Paint_cyhtAnalysisWindow(cyhtAnalysisWindow.MemDC.DCHandle, cyhtAnalysisWindow);  
  tmpColor := cyhtAnalysisWindow.MemDC.MemBitmap.BitsData;
  if tmpColor <> nil then
  begin
    for i := 0 to cyhtAnalysisWindow.MemDC.Height - 1 do
    begin
      for j := 0 to cyhtAnalysisWindow.MemDC.Width - 1 do
      begin
        //if 2 <> PColor32Entry(tmpColor).ARGB then
        if 1 <> PColor32Entry(tmpColor).A then
        begin                        
          PColor32Entry(tmpColor).A := 255;
        end;
        //PColor32Entry(tmpColor).B := 255;
        Inc(tmpColor);
      end;
    end;
  end;

  tmpBlend.BlendOp :=  AC_SRC_OVER;
  tmpBlend.BlendFlags := 0;
  tmpBlend.SourceConstantAlpha := 255; //$FF;
  tmpBlend.AlphaFormat := AC_SRC_ALPHA;// $FF;
  UpdateLayeredWindow(
    cyhtAnalysisWindow.BaseWindow.UIWndHandle, 0,
        @cyhtAnalysisWindow.BaseWindow.WindowRect.TopLeft,
        @cyhtAnalysisWindow.BaseWindow.ClientRect.BottomRight,
        cyhtAnalysisWindow.MemDC.DCHandle,
        @cyhtAnalysisWindow.BaseWindow.ClientRect.TopLeft,
        0, // crKey: COLORREF
        @tmpBlend,// pblend: PBLENDFUNCTION;
        ULW_ALPHA // dwFlags: DWORD
        );
end;

function cyhtAnalysisWindowWndProcA(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    WM_Paint: begin
      WMPaint_cyhtAnalysisWindowWndProcA(cyhtAnalysisWindow, AWnd);
    end;
    WM_LBUTTONDBLCLK: begin
      SaveLayout(cyhtAnalysisWindow);
      cyhtAnalysisWindow.BaseApp.IsActiveStatus := 0;
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
//      if PSmallPoint(@lParam).x < 3 then
//      begin
//
//      end;
      if (PSmallPoint(@lParam).y - cyhtAnalysisWindow.BaseWindow.WindowRect.Top) > cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom - 3 then
      begin
        //Result := HTBOTTOM;
      end;
    end;
    WM_WINDOWPOSCHANGED: begin   
      if ((PWindowPos(LParam).flags and SWP_NOSIZE) = 0) then
      begin
        UpdateMemDC(@cyhtAnalysisWindow.MemDC, PWindowPos(LParam).cx, PWindowPos(LParam).cy);
      end;
      Result := UIWndProcA(@cyhtAnalysisWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
    end;
    CM_INVALIDATE: begin
      Windows.BringWindowToTop(AWnd);

      Paint_cyhtAnalysisWindow_Layered(cyhtAnalysisWindow);
//      //Windows.InvalidateRect(AWnd, nil, true);
    end;
    else
      Result := UIWndProcA(@cyhtAnalysisWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
  end;
end;
                
function ThreadProc_RefreshData(AParam: PRT_cyhtAnalysisWindow): HResult; stdcall;
begin
  Result := 0;
  ExitThread(Result);
end;

procedure CreateRefreshDataThread(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow);
begin
  cyhtAnalysisWindow.DataThread.Core.ThreadHandle := Windows.CreateThread(nil, 0, @ThreadProc_RefreshData,
      cyhtAnalysisWindow, Create_Suspended,
      cyhtAnalysisWindow.DataThread.Core.ThreadID);
  Windows.ResumeThread(cyhtAnalysisWindow.DataThread.Core.ThreadHandle);
end;

function CreatecyhtAnalysisWindow(App: TBaseApp; cyhtAnalysisWindow: PRT_cyhtAnalysisWindow; AWndProc: TFNWndProc): Boolean; overload;
var
  tmpRegWndClass: TWndClassA;
  tmpCheckWndClass: TWndClassA;  
  tmpIsRegistered: Boolean;
  tmpIni: TIniFile;       
  tmpDC: HDC;
  tmpText: AnsiString;
  tmpSize: TSize;
  tmpLogFontA: TLogFontA;
  tmpOldFont: HFONT;
  tmpRect: TRect;
begin
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  FillChar(tmpCheckWndClass, SizeOf(tmpCheckWndClass), 0);
  if not IsWindow(cyhtAnalysisWindow.BaseWindow.UIWndHandle) then
  begin
    //FillChar(cyhtAnalysisWindow^, SizeOf(TRT_cyhtAnalysisWindow), 0);
    cyhtAnalysisWindow.BaseWindow.UIWndHandle := 0;
  end;
  
  if nil = cyhtAnalysisWindow.RateList then
  begin
    cyhtAnalysisWindow.RateList := TALDoubleList.Create;
  end;

  cyhtAnalysisWindow.BaseApp := App;
  FillChar(tmpLogFontA, SizeOf(tmpLogFontA), 0);
  tmpLogFontA.lfHeight := 12;
  tmpLogFontA.lfHeight := 10;  
  tmpLogFontA.lfWidth := 0;  
  tmpLogFontA.lfFaceName := 'MS Sans Serif';
  tmpLogFontA.lfCharSet := DEFAULT_CHARSET;
  tmpLogFontA.lfPitchAndFamily := FIXED_PITCH;
  cyhtAnalysisWindow.Font := Windows.CreateFontIndirectA(tmpLogFontA);

  tmpDC := GetDC(0);
  try
    tmpOldFont := SelectObject(tmpDC, cyhtAnalysisWindow.Font);
    try
      tmpText := 'Äã 100.00';
      Windows.GetTextExtentPoint32A(tmpDC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
    finally
      SelectObject(tmpDC, tmpOldFont);
    end;
  finally
    ReleaseDC(0, tmpDC);
  end;

  cyhtAnalysisWindow.RowCount := 0;
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    cyhtAnalysisWindow.BaseWindow.WindowRect.Left := tmpIni.ReadInteger('win', 'left', 0);
    cyhtAnalysisWindow.BaseWindow.WindowRect.Top := tmpIni.ReadInteger('win', 'top', 0);

    cyhtAnalysisWindow.RowCount := tmpIni.ReadInteger('rate', 'rows', 5);

    
    Windows.SystemParametersInfo(SPI_GETWORKAREA, 0, @tmpRect, 0);
    if cyhtAnalysisWindow.BaseWindow.WindowRect.Top > tmpRect.Bottom - 100 then
      cyhtAnalysisWindow.BaseWindow.WindowRect.Top := tmpRect.Bottom - 100;
    if cyhtAnalysisWindow.BaseWindow.WindowRect.Left > tmpRect.Right - 100 then
      cyhtAnalysisWindow.BaseWindow.WindowRect.Left := tmpRect.Right - 100;
    tmpIni.WriteInteger('win', 'left', cyhtAnalysisWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', cyhtAnalysisWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;

  tmpRegWndClass.style := CS_VREDRAW or CS_HREDRAW or CS_DBLCLKS;
  tmpRegWndClass.hInstance := HInstance;
  //tmpRegWndClass.hbrBackground := GetStockObject(GRAY_BRUSH);
  tmpRegWndClass.hbrBackground := GetStockObject(WHITE_BRUSH);  
  tmpRegWndClass.hCursor := LoadCursorA(0, IDC_ARROW);
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.lpszClassName := 'cyhtAnalysis1';
  
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
  cyhtAnalysisWindow.BaseWindow.Style := WS_POPUP;
  cyhtAnalysisWindow.BaseWindow.ExStyle := WS_EX_TOOLWINDOW
      or WS_EX_LAYERED 
      or WS_EX_TOPMOST;

  if 0 < tmpSize.cx then
  begin
    cyhtAnalysisWindow.BaseWindow.ClientRect.Right := tmpSize.cx + 8;
  end else
  begin
    cyhtAnalysisWindow.BaseWindow.ClientRect.Right := 80;
  end;
  if 0 < tmpSize.cy then
  begin
    cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom := cyhtAnalysisWindow.RowCount * (tmpSize.cy + 4) + 4;
  end;
                     
  UpdateMemDC(@cyhtAnalysisWindow.MemDC,
      cyhtAnalysisWindow.BaseWindow.ClientRect.Right,
      cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom);

  cyhtAnalysisWindow.BaseWindow.UIWndHandle := Windows.CreateWindowExA(
    cyhtAnalysisWindow.BaseWindow.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    cyhtAnalysisWindow.BaseWindow.Style {+ 0},
    cyhtAnalysisWindow.BaseWindow.WindowRect.Left,
    cyhtAnalysisWindow.BaseWindow.WindowRect.Top,
    cyhtAnalysisWindow.BaseWindow.ClientRect.Right,
    cyhtAnalysisWindow.BaseWindow.ClientRect.Bottom, 0, 0, HInstance, nil);
    
  Result := IsWindow(cyhtAnalysisWindow.BaseWindow.UIWndHandle);
end;
          
procedure ShowcyhtAnalysisWindow(cyhtAnalysisWindow: PRT_cyhtAnalysisWindow); overload;
begin
  ShowWindow(cyhtAnalysisWindow.BaseWindow.UIWndHandle, SW_SHOW);
  UpdateWindow(cyhtAnalysisWindow.BaseWindow.UIWndHandle); 
  Paint_cyhtAnalysisWindow_Layered(cyhtAnalysisWindow);
  CreateRefreshDataThread(cyhtAnalysisWindow);
end;
             
var
  Global_cyhtAnalysisWindow_1: TRT_cyhtAnalysisWindow;
                      
function cyhtAnalysisWndProcA_1(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := cyhtAnalysisWindowWndProcA(@Global_cyhtAnalysisWindow_1, AWnd, AMsg, wParam, lParam);
end;

function CreatecyhtAnalysisWindow(App: TBaseApp): Boolean;
begin
  Result := CreatecyhtAnalysisWindow(App, @Global_cyhtAnalysisWindow_1, @cyhtAnalysisWndProcA_1);
end;

procedure ShowcyhtAnalysisWindow;
begin
  ShowcyhtAnalysisWindow(@Global_cyhtAnalysisWindow_1);
end;

procedure cyhtAnalysisWindowInitialize;
begin
  FillChar(Global_cyhtAnalysisWindow_1, SizeOf(Global_cyhtAnalysisWindow_1), 0);
end;

initialization
  cyhtAnalysisWindowInitialize;

end.

