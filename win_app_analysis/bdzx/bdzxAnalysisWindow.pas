unit bdzxAnalysisWindow;

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
  PRT_bdzxAnalysisWindow = ^TRT_bdzxAnalysisWindow;
  TRT_bdzxAnalysisWindow = record
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

  function CreatebdzxAnalysisWindow(App: TBaseApp): Boolean; overload;
  procedure CreateRefreshDataThread(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow);
  procedure ShowbdzxAnalysisWindow; overload;

implementation
              
uses
  IniFiles,
  UIBaseWndProc,
  windef_msg,
  Define_DealItem,
  bdzxAnalysisWinApp  //,Graphics
  ;

procedure SaveLayout(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow);
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteInteger('win', 'left', bdzxAnalysisWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', bdzxAnalysisWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;
end;

procedure Paint_bdzxAnalysisWindow(ADC: HDC; bdzxAnalysisWindow: PRT_bdzxAnalysisWindow);
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
  //Windows.MoveToEx(ADC, 0, bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom - 1, nil);
  //Windows.LineTo(ADC, bdzxAnalysisWindow.BaseWindow.ClientRect.Right, bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom - 1);
  //SelectObject(ADC, tmpOldBrush);
  //SelectObject(ADC, tmpOldPen);  
  //FillRect(ADC, bdzxAnalysisWindow.BaseWindow.ClientRect, GetStockObject(WHITE_BRUSH));
  //FrameRect(ADC, bdzxAnalysisWindow.BaseWindow.ClientRect, GetStockObject(BLACK_BRUSH));

  tmpOldFont := SelectObject(ADC, bdzxAnalysisWindow.Font);
  try
    SetTextColor(ADC, $FF000000);
    tmpIdx := bdzxAnalysisWindow.RateList.Count - 1;
    for i := 0 to bdzxAnalysisWindow.RowCount - 1 do
    begin
      tmpRate := 0;
      if 0 <= tmpIdx then
      begin
        tmpRate := bdzxAnalysisWindow.RateList[tmpIdx];
      end;
      tmpText := 'A';
      if 0 < tmpRate then
      begin
        tmpIdx := tmpIdx - 1;
        tmpText := PRT_DealItem(bdzxAnalysisWindow.RateList.Objects[tmpIdx]).sCode;
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
                 
function WMPaint_bdzxAnalysisWindowWndProcA(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow; AWnd: HWND): LRESULT;
var
  tmpPS: TPaintStruct;
  tmpDC: HDC;
begin
  Result := 0;
  tmpDC := BeginPaint(AWnd, tmpPS);
  try
    Paint_bdzxAnalysisWindow(tmpDC, bdzxAnalysisWindow);
  finally
  end;
  EndPaint(AWnd, tmpPS);
end;
                       
procedure Paint_bdzxAnalysisWindow_Layered(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow);
var
  tmpBlend: TBLENDFUNCTION;
  i, j: Integer;  
  tmpColor: PColor32Array;
begin
  if 0 = bdzxAnalysisWindow.MemDC.DCHandle then
  begin
    UpdateMemDC(@bdzxAnalysisWindow.MemDC,
        bdzxAnalysisWindow.BaseWindow.ClientRect.Right,
        bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom);
  end;                                   
  tmpColor := bdzxAnalysisWindow.MemDC.MemBitmap.BitsData;
  if tmpColor <> nil then
  begin
    for i := 0 to bdzxAnalysisWindow.MemDC.Height - 1 do
    begin
      for j := 0 to bdzxAnalysisWindow.MemDC.Width - 1 do
      begin
        //PColor32Entry(tmpColor).A := 255;
        PColor32Entry(tmpColor).A := 1;       
        //PColor32Entry(tmpColor).B := 255;
        Inc(tmpColor);
      end;
    end;
  end;
  Paint_bdzxAnalysisWindow(bdzxAnalysisWindow.MemDC.DCHandle, bdzxAnalysisWindow);  
  tmpColor := bdzxAnalysisWindow.MemDC.MemBitmap.BitsData;
  if tmpColor <> nil then
  begin
    for i := 0 to bdzxAnalysisWindow.MemDC.Height - 1 do
    begin
      for j := 0 to bdzxAnalysisWindow.MemDC.Width - 1 do
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
    bdzxAnalysisWindow.BaseWindow.UIWndHandle, 0,
        @bdzxAnalysisWindow.BaseWindow.WindowRect.TopLeft,
        @bdzxAnalysisWindow.BaseWindow.ClientRect.BottomRight,
        bdzxAnalysisWindow.MemDC.DCHandle,
        @bdzxAnalysisWindow.BaseWindow.ClientRect.TopLeft,
        0, // crKey: COLORREF
        @tmpBlend,// pblend: PBLENDFUNCTION;
        ULW_ALPHA // dwFlags: DWORD
        );
end;

function bdzxAnalysisWindowWndProcA(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    WM_Paint: begin
      WMPaint_bdzxAnalysisWindowWndProcA(bdzxAnalysisWindow, AWnd);
    end;
    WM_LBUTTONDBLCLK: begin
      SaveLayout(bdzxAnalysisWindow);
      bdzxAnalysisWindow.BaseApp.IsActiveStatus := 0;
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
      if (PSmallPoint(@lParam).y - bdzxAnalysisWindow.BaseWindow.WindowRect.Top) > bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom - 3 then
      begin
        //Result := HTBOTTOM;
      end;
    end;
    WM_WINDOWPOSCHANGED: begin   
      if ((PWindowPos(LParam).flags and SWP_NOSIZE) = 0) then
      begin
        UpdateMemDC(@bdzxAnalysisWindow.MemDC, PWindowPos(LParam).cx, PWindowPos(LParam).cy);
      end;
      Result := UIWndProcA(@bdzxAnalysisWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
    end;
    CM_INVALIDATE: begin
      Windows.BringWindowToTop(AWnd);

      Paint_bdzxAnalysisWindow_Layered(bdzxAnalysisWindow);
//      //Windows.InvalidateRect(AWnd, nil, true);
    end;
    else
      Result := UIWndProcA(@bdzxAnalysisWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
  end;
end;
                
function ThreadProc_RefreshData(AParam: PRT_bdzxAnalysisWindow): HResult; stdcall;
begin
  Result := 0;
  ExitThread(Result);
end;

procedure CreateRefreshDataThread(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow);
begin
  bdzxAnalysisWindow.DataThread.Core.ThreadHandle := Windows.CreateThread(nil, 0, @ThreadProc_RefreshData,
      bdzxAnalysisWindow, Create_Suspended,
      bdzxAnalysisWindow.DataThread.Core.ThreadID);
  Windows.ResumeThread(bdzxAnalysisWindow.DataThread.Core.ThreadHandle);
end;

function CreatebdzxAnalysisWindow(App: TBaseApp; bdzxAnalysisWindow: PRT_bdzxAnalysisWindow; AWndProc: TFNWndProc): Boolean; overload;
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
  if not IsWindow(bdzxAnalysisWindow.BaseWindow.UIWndHandle) then
  begin
    //FillChar(bdzxAnalysisWindow^, SizeOf(TRT_bdzxAnalysisWindow), 0);
    bdzxAnalysisWindow.BaseWindow.UIWndHandle := 0;
  end;
  
  if nil = bdzxAnalysisWindow.RateList then
  begin
    bdzxAnalysisWindow.RateList := TALDoubleList.Create;
  end;

  bdzxAnalysisWindow.BaseApp := App;
  FillChar(tmpLogFontA, SizeOf(tmpLogFontA), 0);
  tmpLogFontA.lfHeight := 12;
  tmpLogFontA.lfHeight := 10;  
  tmpLogFontA.lfWidth := 0;  
  tmpLogFontA.lfFaceName := 'MS Sans Serif';
  tmpLogFontA.lfCharSet := DEFAULT_CHARSET;
  tmpLogFontA.lfPitchAndFamily := FIXED_PITCH;
  bdzxAnalysisWindow.Font := Windows.CreateFontIndirectA(tmpLogFontA);

  tmpDC := GetDC(0);
  try
    tmpOldFont := SelectObject(tmpDC, bdzxAnalysisWindow.Font);
    try
      tmpText := 'Äã 100.00';
      Windows.GetTextExtentPoint32A(tmpDC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
    finally
      SelectObject(tmpDC, tmpOldFont);
    end;
  finally
    ReleaseDC(0, tmpDC);
  end;

  bdzxAnalysisWindow.RowCount := 0;
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    bdzxAnalysisWindow.BaseWindow.WindowRect.Left := tmpIni.ReadInteger('win', 'left', 0);
    bdzxAnalysisWindow.BaseWindow.WindowRect.Top := tmpIni.ReadInteger('win', 'top', 0);

    bdzxAnalysisWindow.RowCount := tmpIni.ReadInteger('rate', 'rows', 5);

    
    Windows.SystemParametersInfo(SPI_GETWORKAREA, 0, @tmpRect, 0);
    if bdzxAnalysisWindow.BaseWindow.WindowRect.Top > tmpRect.Bottom - 100 then
      bdzxAnalysisWindow.BaseWindow.WindowRect.Top := tmpRect.Bottom - 100;
    if bdzxAnalysisWindow.BaseWindow.WindowRect.Left > tmpRect.Right - 100 then
      bdzxAnalysisWindow.BaseWindow.WindowRect.Left := tmpRect.Right - 100;
    tmpIni.WriteInteger('win', 'left', bdzxAnalysisWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', bdzxAnalysisWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;

  tmpRegWndClass.style := CS_VREDRAW or CS_HREDRAW or CS_DBLCLKS;
  tmpRegWndClass.hInstance := HInstance;
  //tmpRegWndClass.hbrBackground := GetStockObject(GRAY_BRUSH);
  tmpRegWndClass.hbrBackground := GetStockObject(WHITE_BRUSH);  
  tmpRegWndClass.hCursor := LoadCursorA(0, IDC_ARROW);
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.lpszClassName := 'bdzxAnalysis1';
  
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
  bdzxAnalysisWindow.BaseWindow.Style := WS_POPUP;
  bdzxAnalysisWindow.BaseWindow.ExStyle := WS_EX_TOOLWINDOW
      or WS_EX_LAYERED 
      or WS_EX_TOPMOST;

  if 0 < tmpSize.cx then
  begin
    bdzxAnalysisWindow.BaseWindow.ClientRect.Right := tmpSize.cx + 8;
  end else
  begin
    bdzxAnalysisWindow.BaseWindow.ClientRect.Right := 80;
  end;
  if 0 < tmpSize.cy then
  begin
    bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom := bdzxAnalysisWindow.RowCount * (tmpSize.cy + 4) + 4;
  end;
                     
  UpdateMemDC(@bdzxAnalysisWindow.MemDC,
      bdzxAnalysisWindow.BaseWindow.ClientRect.Right,
      bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom);

  bdzxAnalysisWindow.BaseWindow.UIWndHandle := Windows.CreateWindowExA(
    bdzxAnalysisWindow.BaseWindow.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    bdzxAnalysisWindow.BaseWindow.Style {+ 0},
    bdzxAnalysisWindow.BaseWindow.WindowRect.Left,
    bdzxAnalysisWindow.BaseWindow.WindowRect.Top,
    bdzxAnalysisWindow.BaseWindow.ClientRect.Right,
    bdzxAnalysisWindow.BaseWindow.ClientRect.Bottom, 0, 0, HInstance, nil);
    
  Result := IsWindow(bdzxAnalysisWindow.BaseWindow.UIWndHandle);
end;
          
procedure ShowbdzxAnalysisWindow(bdzxAnalysisWindow: PRT_bdzxAnalysisWindow); overload;
begin
  ShowWindow(bdzxAnalysisWindow.BaseWindow.UIWndHandle, SW_SHOW);
  UpdateWindow(bdzxAnalysisWindow.BaseWindow.UIWndHandle); 
  Paint_bdzxAnalysisWindow_Layered(bdzxAnalysisWindow);
  CreateRefreshDataThread(bdzxAnalysisWindow);
end;
             
var
  Global_bdzxAnalysisWindow_1: TRT_bdzxAnalysisWindow;
                      
function bdzxAnalysisWndProcA_1(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := bdzxAnalysisWindowWndProcA(@Global_bdzxAnalysisWindow_1, AWnd, AMsg, wParam, lParam);
end;

function CreatebdzxAnalysisWindow(App: TBaseApp): Boolean;
begin
  Result := CreatebdzxAnalysisWindow(App, @Global_bdzxAnalysisWindow_1, @bdzxAnalysisWndProcA_1);
end;

procedure ShowbdzxAnalysisWindow;
begin
  ShowbdzxAnalysisWindow(@Global_bdzxAnalysisWindow_1);
end;

procedure bdzxAnalysisWindowInitialize;
begin
  FillChar(Global_bdzxAnalysisWindow_1, SizeOf(Global_bdzxAnalysisWindow_1), 0);
end;

initialization
  bdzxAnalysisWindowInitialize;

end.

