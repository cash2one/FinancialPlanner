unit bollAnalysisWindow;

interface

uses
  Windows,
  Messages,
  Sysutils,
  BaseApp,
  QuickList_double,
  UtilsHttp,
  win.thread,
  UIBaseWin,
  ui.color,
  uiwin.memdc;

type
  PRT_BollAnalysisWindow = ^TRT_BollAnalysisWindow;
  TRT_BollAnalysisWindow = record
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

  function CreateBollAnalysisWindow(App: TBaseApp): Boolean; overload;
  procedure CreateRefreshDataThread(BollAnalysisWindow: PRT_BollAnalysisWindow);
  procedure ShowBollAnalysisWindow; overload;

implementation
              
uses
  IniFiles,
  UIBaseWndProc,
  windef_msg,
  Define_DealItem,
  define_stock_quotes_instant,
  StockInstantData_Get_Sina,
  BollAnalysisWinApp  //,Graphics
  ;

procedure SaveLayout(BollAnalysisWindow: PRT_BollAnalysisWindow);
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteInteger('win', 'left', BollAnalysisWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', BollAnalysisWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;
end;

procedure Paint_BollAnalysisWindow(ADC: HDC; BollAnalysisWindow: PRT_BollAnalysisWindow);
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
  //Windows.MoveToEx(ADC, 0, BollAnalysisWindow.BaseWindow.ClientRect.Bottom - 1, nil);
  //Windows.LineTo(ADC, BollAnalysisWindow.BaseWindow.ClientRect.Right, BollAnalysisWindow.BaseWindow.ClientRect.Bottom - 1);
  //SelectObject(ADC, tmpOldBrush);
  //SelectObject(ADC, tmpOldPen);  
  //FillRect(ADC, BollAnalysisWindow.BaseWindow.ClientRect, GetStockObject(WHITE_BRUSH));
  //FrameRect(ADC, BollAnalysisWindow.BaseWindow.ClientRect, GetStockObject(BLACK_BRUSH));

  tmpOldFont := SelectObject(ADC, BollAnalysisWindow.Font);
  try
    SetTextColor(ADC, $FF000000);
    tmpIdx := BollAnalysisWindow.RateList.Count - 1;
    for i := 0 to BollAnalysisWindow.RowCount - 1 do
    begin
      tmpRate := 0;
      if 0 <= tmpIdx then
      begin
        tmpRate := BollAnalysisWindow.RateList[tmpIdx];
      end;
      tmpText := 'A';
      if 0 < tmpRate then
      begin
        tmpIdx := tmpIdx - 1;
        tmpText := PRT_DealItem(BollAnalysisWindow.RateList.Objects[tmpIdx]).sCode;
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
                 
function WMPaint_BollAnalysisWindowWndProcA(BollAnalysisWindow: PRT_BollAnalysisWindow; AWnd: HWND): LRESULT;
var
  tmpPS: TPaintStruct;
  tmpDC: HDC;
begin
  Result := 0;
  tmpDC := BeginPaint(AWnd, tmpPS);
  try
    Paint_BollAnalysisWindow(tmpDC, BollAnalysisWindow);
  finally
  end;
  EndPaint(AWnd, tmpPS);
end;
                       
procedure Paint_BollAnalysisWindow_Layered(BollAnalysisWindow: PRT_BollAnalysisWindow);
var
  tmpBlend: TBLENDFUNCTION;
  i, j: Integer;  
  tmpColor: PColor32Array;
begin
  if 0 = BollAnalysisWindow.MemDC.DCHandle then
  begin
    UpdateMemDC(@BollAnalysisWindow.MemDC,
        BollAnalysisWindow.BaseWindow.ClientRect.Right,
        BollAnalysisWindow.BaseWindow.ClientRect.Bottom);
  end;                                   
  tmpColor := BollAnalysisWindow.MemDC.MemBitmap.BitsData;
  if tmpColor <> nil then
  begin
    for i := 0 to BollAnalysisWindow.MemDC.Height - 1 do
    begin
      for j := 0 to BollAnalysisWindow.MemDC.Width - 1 do
      begin
        //PColor32Entry(tmpColor).A := 255;
        PColor32Entry(tmpColor).A := 1;       
        //PColor32Entry(tmpColor).B := 255;
        Inc(tmpColor);
      end;
    end;
  end;
  Paint_BollAnalysisWindow(BollAnalysisWindow.MemDC.DCHandle, BollAnalysisWindow);  
  tmpColor := BollAnalysisWindow.MemDC.MemBitmap.BitsData;
  if tmpColor <> nil then
  begin
    for i := 0 to BollAnalysisWindow.MemDC.Height - 1 do
    begin
      for j := 0 to BollAnalysisWindow.MemDC.Width - 1 do
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
    BollAnalysisWindow.BaseWindow.UIWndHandle, 0,
        @BollAnalysisWindow.BaseWindow.WindowRect.TopLeft,
        @BollAnalysisWindow.BaseWindow.ClientRect.BottomRight,
        BollAnalysisWindow.MemDC.DCHandle,
        @BollAnalysisWindow.BaseWindow.ClientRect.TopLeft,
        0, // crKey: COLORREF
        @tmpBlend,// pblend: PBLENDFUNCTION;
        ULW_ALPHA // dwFlags: DWORD
        );
end;

procedure RefreshRateList(BollAnalysisWindow: PRT_BollAnalysisWindow);   
var
  i: integer;
  tmpCurrentQuote: PRT_InstantQuote;
  tmpLastQuote: PRT_InstantQuote;  
begin
  BollAnalysisWindow.RateList.Clear;
  for i := 0 to GlobalApp.CurrentStockInstant.RecordCount - 1 do
  begin
    tmpCurrentQuote := GlobalApp.CurrentStockInstant.RecordItem[i];
    if 0 < tmpCurrentQuote.Amount then
    begin
      tmpLastQuote := tmpCurrentQuote.ExtendParam;
      if nil = tmpLastQuote then
      begin
        tmpLastQuote := GlobalApp.LastStockInstant.FindItem(tmpCurrentQuote.Item);
      end;
      if nil <> tmpLastQuote then
      begin
        if tmpLastQuote.Item.sCode = tmpCurrentQuote.Item.sCode then
        begin
          tmpCurrentQuote.ExtendParam := tmpLastQuote;
          if 0 < tmpLastQuote.Amount then
          begin
            BollAnalysisWindow.RateList.AddObject(tmpCurrentQuote.Amount / tmpLastQuote.Amount, TObject(tmpCurrentQuote.Item));
          end;
        end;
      end;
    end;
  end;
  BollAnalysisWindow.RateList.Sort;
end;

function BollAnalysisWindowWndProcA(BollAnalysisWindow: PRT_BollAnalysisWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    WM_Paint: begin
      WMPaint_BollAnalysisWindowWndProcA(BollAnalysisWindow, AWnd);
    end;
    WM_LBUTTONDBLCLK: begin
      SaveLayout(BollAnalysisWindow);
      BollAnalysisWindow.BaseApp.IsActiveStatus := 0;
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
      if (PSmallPoint(@lParam).y - BollAnalysisWindow.BaseWindow.WindowRect.Top) > BollAnalysisWindow.BaseWindow.ClientRect.Bottom - 3 then
      begin
        //Result := HTBOTTOM;
      end;
    end;
    WM_WINDOWPOSCHANGED: begin   
      if ((PWindowPos(LParam).flags and SWP_NOSIZE) = 0) then
      begin
        UpdateMemDC(@BollAnalysisWindow.MemDC, PWindowPos(LParam).cx, PWindowPos(LParam).cy);
      end;
      Result := UIWndProcA(@BollAnalysisWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
    end;
    CM_INVALIDATE: begin
      Windows.BringWindowToTop(AWnd);

      RefreshRateList(BollAnalysisWindow);
      Paint_BollAnalysisWindow_Layered(BollAnalysisWindow);
//      //Windows.InvalidateRect(AWnd, nil, true);
    end;
    else
      Result := UIWndProcA(@BollAnalysisWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
  end;
end;
                
function ThreadProc_RefreshData(AParam: PRT_BollAnalysisWindow): HResult; stdcall;
var
  i: integer;
  tmpHour, tmpMin, tmpSec, tmpMSec: Word; 
  tmpInstantArray: TInstantArray;  
  tmpIdx: integer;
  tmpCount: integer;
  tmpNetSession: THttpClientSession;
begin
  Result := 0;
  FillChar(tmpNetSession, SizeOf(tmpNetSession), 0); 
  while true do
  begin           
    Sleep(20);
    if nil = AParam.BaseApp then
      Break;
    if 0 = AParam.IsFirstGot then
    begin
      AParam.IsFirstGot := 1;
    end else
    begin
      DecodeTime(now, tmpHour, tmpMin, tmpSec, tmpMSec);
      if 9 > tmpHour then
        Continue;
      if 15 < tmpHour then
        Continue;
      if 9 = tmpHour then
      begin
        if 29 > tmpMin then
          Continue;
      end;
      if 11 = tmpHour then
      begin
        if 30 < tmpMin then
          Continue;
      end;
      if 12 = tmpHour then
        Continue;
    end;
    if 0 <> AParam.BaseApp.IsActiveStatus then
    begin
//      DataGet_InstantArray_Sina(AParam.BaseApp, @AParam.StockQuoteInstants);
      tmpIdx := 0;
      FillChar(tmpInstantArray, SizeOf(tmpInstantArray), 0);
      tmpCount := 0;
      for i := 0 to GlobalApp.CurrentStockInstant.RecordCount - 1 do
      begin                 
        if nil <> AParam.BaseApp then
        begin
          if 0 <> AParam.BaseApp.IsActiveStatus then
          begin
            tmpInstantArray.Data[tmpIdx] := GlobalApp.CurrentStockInstant.RecordItem[i];
            Inc(tmpIdx);
            if tmpIdx >= Length(tmpInstantArray.Data) then
            begin
              DataGet_InstantArray_Sina(GlobalApp, @tmpInstantArray, @tmpNetSession);
              FillChar(tmpInstantArray, SizeOf(tmpInstantArray), 0);
              tmpIdx := 0;  
              Sleep(100);
              Inc(tmpCount);
              if 10 < tmpCount then
              begin
                //Break;
              end;     
              //PostMessage(AParam.BaseWindow.WindowHandle, DefineWinMsg.CM_INVALIDATE, 0, 0);
            end;
          end else
            Break;
        end else
          Break;
      end;
      if nil <> AParam.BaseApp then
      begin
        if 0 <> AParam.BaseApp.IsActiveStatus then
        begin
          DataGet_InstantArray_Sina(GlobalApp, @tmpInstantArray, @tmpNetSession);
          PostMessage(AParam.BaseWindow.UIWndHandle, CM_INVALIDATE, 0, 0);
        end;
      end;
    end else
    begin
      Break;
    end;
    // 三分钟 更新一次排名
    for i := 1 to 3 * 60 * 50 do
    begin
      Sleep(20);
      if nil = AParam.BaseApp then
        Break;
      if 0 = AParam.BaseApp.IsActiveStatus then
        Break;
    end;
  end;
  ExitThread(Result);
end;

procedure CreateRefreshDataThread(BollAnalysisWindow: PRT_BollAnalysisWindow);
begin
  BollAnalysisWindow.DataThread.Core.ThreadHandle := Windows.CreateThread(nil, 0, @ThreadProc_RefreshData,
      BollAnalysisWindow, Create_Suspended,
      BollAnalysisWindow.DataThread.Core.ThreadID);
  Windows.ResumeThread(BollAnalysisWindow.DataThread.Core.ThreadHandle);
end;

function CreateBollAnalysisWindow(App: TBaseApp; BollAnalysisWindow: PRT_BollAnalysisWindow; AWndProc: TFNWndProc): Boolean; overload;
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
  if not IsWindow(BollAnalysisWindow.BaseWindow.UIWndHandle) then
  begin
    //FillChar(BollAnalysisWindow^, SizeOf(TRT_BollAnalysisWindow), 0);
    BollAnalysisWindow.BaseWindow.UIWndHandle := 0;
  end;
  
  if nil = BollAnalysisWindow.RateList then
  begin
    BollAnalysisWindow.RateList := TALDoubleList.Create;
  end;

  BollAnalysisWindow.BaseApp := App;
  FillChar(tmpLogFontA, SizeOf(tmpLogFontA), 0);
  tmpLogFontA.lfHeight := 12;
  tmpLogFontA.lfHeight := 10;  
  tmpLogFontA.lfWidth := 0;  
  tmpLogFontA.lfFaceName := 'MS Sans Serif';
  tmpLogFontA.lfCharSet := DEFAULT_CHARSET;
  tmpLogFontA.lfPitchAndFamily := FIXED_PITCH;
  BollAnalysisWindow.Font := Windows.CreateFontIndirectA(tmpLogFontA);

  tmpDC := GetDC(0);
  try
    tmpOldFont := SelectObject(tmpDC, BollAnalysisWindow.Font);
    try
      tmpText := '你 100.00';
      Windows.GetTextExtentPoint32A(tmpDC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
    finally
      SelectObject(tmpDC, tmpOldFont);
    end;
  finally
    ReleaseDC(0, tmpDC);
  end;

  BollAnalysisWindow.RowCount := 0;
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    BollAnalysisWindow.BaseWindow.WindowRect.Left := tmpIni.ReadInteger('win', 'left', 0);
    BollAnalysisWindow.BaseWindow.WindowRect.Top := tmpIni.ReadInteger('win', 'top', 0);

    BollAnalysisWindow.RowCount := tmpIni.ReadInteger('rate', 'rows', 5);

    
    Windows.SystemParametersInfo(SPI_GETWORKAREA, 0, @tmpRect, 0);
    if BollAnalysisWindow.BaseWindow.WindowRect.Top > tmpRect.Bottom - 100 then
      BollAnalysisWindow.BaseWindow.WindowRect.Top := tmpRect.Bottom - 100;
    if BollAnalysisWindow.BaseWindow.WindowRect.Left > tmpRect.Right - 100 then
      BollAnalysisWindow.BaseWindow.WindowRect.Left := tmpRect.Right - 100;
    tmpIni.WriteInteger('win', 'left', BollAnalysisWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', BollAnalysisWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;

  tmpRegWndClass.style := CS_VREDRAW or CS_HREDRAW or CS_DBLCLKS;
  tmpRegWndClass.hInstance := HInstance;
  //tmpRegWndClass.hbrBackground := GetStockObject(GRAY_BRUSH);
  tmpRegWndClass.hbrBackground := GetStockObject(WHITE_BRUSH);  
  tmpRegWndClass.hCursor := LoadCursorA(0, IDC_ARROW);
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.lpszClassName := 'BollAnalysis1';
  
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
  BollAnalysisWindow.BaseWindow.Style := WS_POPUP;
  BollAnalysisWindow.BaseWindow.ExStyle := WS_EX_TOOLWINDOW
      or WS_EX_LAYERED 
      or WS_EX_TOPMOST;

  if 0 < tmpSize.cx then
  begin
    BollAnalysisWindow.BaseWindow.ClientRect.Right := tmpSize.cx + 8;
  end else
  begin
    BollAnalysisWindow.BaseWindow.ClientRect.Right := 80;
  end;
  if 0 < tmpSize.cy then
  begin
    BollAnalysisWindow.BaseWindow.ClientRect.Bottom := BollAnalysisWindow.RowCount * (tmpSize.cy + 4) + 4;
  end;
                     
  UpdateMemDC(@BollAnalysisWindow.MemDC,
      BollAnalysisWindow.BaseWindow.ClientRect.Right,
      BollAnalysisWindow.BaseWindow.ClientRect.Bottom);

  BollAnalysisWindow.BaseWindow.UIWndHandle := Windows.CreateWindowExA(
    BollAnalysisWindow.BaseWindow.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    BollAnalysisWindow.BaseWindow.Style {+ 0},
    BollAnalysisWindow.BaseWindow.WindowRect.Left,
    BollAnalysisWindow.BaseWindow.WindowRect.Top,
    BollAnalysisWindow.BaseWindow.ClientRect.Right,
    BollAnalysisWindow.BaseWindow.ClientRect.Bottom, 0, 0, HInstance, nil);
    
  Result := IsWindow(BollAnalysisWindow.BaseWindow.UIWndHandle);
end;
          
procedure ShowBollAnalysisWindow(BollAnalysisWindow: PRT_BollAnalysisWindow); overload;
begin
  ShowWindow(BollAnalysisWindow.BaseWindow.UIWndHandle, SW_SHOW);
  UpdateWindow(BollAnalysisWindow.BaseWindow.UIWndHandle); 
  Paint_BollAnalysisWindow_Layered(BollAnalysisWindow);
  CreateRefreshDataThread(BollAnalysisWindow);
end;
             
var
  Global_BollAnalysisWindow_1: TRT_BollAnalysisWindow;
                      
function BollAnalysisWndProcA_1(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := BollAnalysisWindowWndProcA(@Global_BollAnalysisWindow_1, AWnd, AMsg, wParam, lParam);
end;

function CreateBollAnalysisWindow(App: TBaseApp): Boolean;
begin
  Result := CreateBollAnalysisWindow(App, @Global_BollAnalysisWindow_1, @BollAnalysisWndProcA_1);
end;

procedure ShowBollAnalysisWindow;
begin
  ShowBollAnalysisWindow(@Global_BollAnalysisWindow_1);
end;

procedure BollAnalysisWindowInitialize;
begin
  FillChar(Global_BollAnalysisWindow_1, SizeOf(Global_BollAnalysisWindow_1), 0);
end;

initialization
  BollAnalysisWindowInitialize;

end.

