unit XueQiuInfoAppWindow2;

interface

uses
  Windows, Messages, BaseFloatWindow, BaseApp, BaseWinThread;
  
type              
  PRT_FloatWindow = ^TRT_FloatWindow;
  TRT_FloatWindow = record
    BaseFloatWindow: TRT_BaseFloatWindow;
    
    DrawBuyStockCode: AnsiString;
    BuyStockCode: AnsiString;
    BuyPrice: AnsiString;

    SaleStockCode: AnsiString;
    SalePrice: AnsiString;

    LastBuyStockCode: AnsiString;
    LastSaleStockCode: AnsiString;

    IsFirstGot: Byte;
    IsTwinkle: Byte;
    IsTwinkleShow: Boolean;
    TwinkleThread: TSysWinThread;
  end;
                
  procedure WMAppStart(); 
  function CreateFloatWindow(App: TBaseApp): Boolean; overload;
  procedure CreateRefreshDataThread(ABaseFloatWindow: PRT_BaseFloatWindow);
  procedure ShowFloatWindow; overload;
                          
implementation

uses
  IniFiles, Sysutils, uiwin_memdc, define_DealItem,
  UtilsLog,
  zsHelperMessage,
  UIBaseWndProc,
  Classes, 
  JsonTestData,
  superobject2_define,
  superobject2_parse,
  Define_Price,
  def_basemessage,

  NetHttpClient,
  NetHttpClientProc,
  NetClientIocpProc,
  HttpProtocol,
  XueQiuInfoApp;

procedure TestClient();  
var
  tmpHttpClient: PNetHttpClient;
  tmpRet: AnsiString;
  tmpHeader: AnsiString;
  tmpCookie: AnsiString;
  tmpUrl: AnsiString;
  tmpHttpInfo: THttpUrlInfo;
begin
  tmpHttpClient := GlobalApp.NetMgr.CheckOutHttpClient;
  if nil <> tmpHttpClient then
  begin
    //tmpUrl := 'http://market.finance.sina.com.cn/downxls.php?date=2015-12-03&symbol=sh600000';
    //tmpUrl := 'http://xueqiu.com/P/ZH010389';
    tmpUrl := 'http://xueqiu.com/cubes/rebalancing/history.json?cube_symbol=ZH010389&count=5&page=1';
    //tmpUrl := 'http://127.0.0.1/';
    //tmpUrl := 'http://www.163.com';
    FillChar(tmpHttpInfo, SizeOf(tmpHttpInfo), 0);
    if HttpProtocol.HttpUrlInfoParse(tmpUrl, @tmpHttpInfo) then
    begin
      tmpCookie := 'Cookie:s=2bxb1yl5un' + '; ' +
                   'Hm_lvt_1db88642e346389874251b5a1eded6e3=1450080574; ' +
                   '__utma=1.976138422.1450081342.1450081342.1450081342.1; ' +
                   '__utmz=1.1450081342.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ' +
                   'xq_a_token=726b01d9f1825d1c7cd7c561bd110c037fffeade; ' +
                   'xq_r_token=6a975187c5c6d7c58b0f99b376864ebec47b46d3';
      tmpHeader := HttpClientGenRequestHeader(@tmpHttpInfo, tmpCookie, '', false);
      tmpRet := NetHttpClientProc.HttpGet(GlobalApp.NetMgr, tmpHttpClient, tmpUrl, tmpHeader, false);
    end;
    //tmpRet := NetClientIocpProc.HttpGet(GlobalApp.NetMgr, tmpHttpClient, tmpUrl);
  end;
end;
                    
procedure LoadFloatWindowConfig(AFloatWindow: PRT_FloatWindow);
var
  tmpRect: TRect;
  tmpIni: TIniFile;
begin     
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    
    AFloatWindow.LastBuyStockCode := tmpIni.ReadString('stock', 'buy', '');
    AFloatWindow.LastSaleStockCode := tmpIni.ReadString('stock', 'sale', '');
        
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
end;
      
procedure SaveFloatWindowConfig(AFloatWindow: PRT_FloatWindow);
var 
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteString('stock', 'buy', AFloatWindow.BuyStockCode);
    tmpIni.WriteString('stock', 'buyprice', AFloatWindow.BuyPrice);
    tmpIni.WriteString('stock', 'sale', AFloatWindow.SaleStockCode);
    tmpIni.WriteString('stock', 'saleprice', AFloatWindow.SalePrice);    
    
    tmpIni.WriteInteger('win', 'left', AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', AFloatWindow.BaseFloatWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;
end;

function ThreadProc_Twinkle(AParam: PRT_FloatWindow): HResult; stdcall;
var
  i: integer;
begin
  Result := 0;
  while 1 = AParam.IsTwinkle do
  begin
    for i := 0 to 25 do
    begin
      if 0 = AParam.BaseFloatWindow.BaseApp.IsActiveStatus then
        Break;
      Sleep(20);
    end;
    if 0 = AParam.BaseFloatWindow.BaseApp.IsActiveStatus then
      Break;
    AParam.IsTwinkleShow := not AParam.IsTwinkleShow;
    PostMessage(AParam.BaseFloatWindow.BaseWindow.UIWndHandle, CM_INVALIDATE, 1, 0);
  end;
  ExitThread(Result);
end;

procedure Paint_FloatWindow(ADC: HDC; ABaseFloatWindow: PRT_BaseFloatWindow);
var
  i: integer;
  tmpX, tmpY: Integer;
  tmpSize: TSize;
  tmpHeight: integer;
  tmpNameWidth: Integer;
  tmpBuyText: AnsiString;
  tmpSaleText: AnsiString;  
  tmpOldFont: HFONT;
  tmpFloatWindow: PRT_FloatWindow;
begin
  tmpNameWidth := 0;
  tmpBuyText := '';
  tmpSaleText := '';
  //FillRect(ADC, ABaseFloatWindow.BaseWindow.ClientRect, GetStockObject(BLACK_BRUSH));
  tmpFloatWindow := PRT_FloatWindow(ABaseFloatWindow);
  if nil <> tmpFloatWindow then
  begin
    if '' <> tmpFloatWindow.BuyStockCode then
      tmpBuyText := 'B' + tmpFloatWindow.BuyStockCode + ':' + tmpFloatWindow.BuyPrice;
    if '' <> tmpFloatWindow.SaleStockCode then
      tmpSaleText := 'S' + tmpFloatWindow.SaleStockCode + ':' + tmpFloatWindow.SalePrice;
    
    if not SameText(tmpFloatWindow.DrawBuyStockCode, tmpFloatWindow.BuyStockCode) then
    begin
      if '' <> tmpFloatWindow.DrawBuyStockCode then
      begin                           
        if 0 = tmpFloatWindow.IsTwinkle then
        begin
          tmpFloatWindow.IsTwinkle := 1;
        end;
        if 1 = tmpFloatWindow.IsTwinkle then
        begin
          tmpFloatWindow.IsTwinkleShow := true;
          if 0 = tmpFloatWindow.TwinkleThread.ThreadHandle then
          begin
            tmpFloatWindow.TwinkleThread.ThreadHandle := Windows.CreateThread(nil, 0, @ThreadProc_Twinkle, ABaseFloatWindow,
              Create_Suspended, ABaseFloatWindow.DataThread.ThreadID);
            Windows.ResumeThread(tmpFloatWindow.TwinkleThread.ThreadHandle);
          end;
        end;
      end;
      tmpFloatWindow.DrawBuyStockCode := tmpFloatWindow.BuyStockCode;
    end;          
    if 1 <> tmpFloatWindow.IsTwinkle then
    begin
      tmpFloatWindow.IsTwinkleShow := false;
    end;
    if tmpFloatWindow.IsTwinkleShow then
    begin
      FrameRect(ADC, ABaseFloatWindow.BaseWindow.ClientRect, GetStockObject(BLACK_BRUSH));
      BringWindowToTop(ABaseFloatWindow.BaseWindow.UIWndHandle);
    end;       
    tmpY := 4;
    tmpX := 4;
    tmpOldFont := SelectObject(ADC, ABaseFloatWindow.Font);
    try                  
      SetBkMode(ADC, Transparent);
      SetTextColor(ADC, $FF000000);
      tmpHeight := 0;
      if '' <> tmpBuyText then
      begin                  
        if 0 = tmpHeight then
        begin
          Windows.GetTextExtentPoint32A(ADC, PAnsiChar(@tmpBuyText[1]), Length(tmpBuyText), tmpSize);
          tmpHeight := tmpSize.cy;
          tmpNameWidth := tmpSize.cx;
        end;
        Windows.TextOutA(ADC, tmpX, tmpY, @tmpBuyText[1], Length(tmpBuyText));  
        tmpY := tmpY + tmpHeight + 4;
      end;
      if '' <> tmpSaleText then
      begin
        Windows.TextOutA(ADC, tmpX, tmpY, @tmpSaleText[1], Length(tmpSaleText));  
      end;
    finally
      SelectObject(ADC, tmpOldFont);
    end;
  end;
end;

procedure NotifyXueQiuBuyMessage(AParam: PRT_FloatWindow);
var
  tmpWnd: HWND;
  tmpLParam: string;
begin
  tmpWnd := FindWindow('WndZSHelper', '');
  if IsWindow(tmpWnd) then
  begin
    SDLog('XueQiuInfoAppWindow.pas', 'buy:' + AParam.BuyStockCode + '/' + AParam.BuyPrice);
    SDLog('XueQiuInfoAppWindow.pas', 'sale:' + AParam.SaleStockCode + '/' + AParam.SalePrice);
    PostMessage(tmpWnd, WM_StockBuy_XueQiu,
        getStockCodePack(AParam.BuyStockCode),
        getRTPricePackValue(AParam.BuyPrice));
    PostMessage(tmpWnd, WM_StockSale_XueQiu,
        getStockCodePack(AParam.SaleStockCode),
        getRTPricePackValue(AParam.SalePrice));
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
      if 1 = PRT_FloatWindow(ABaseFloatWindow).IsTwinkle then
      begin
        PRT_FloatWindow(ABaseFloatWindow).IsTwinkle := 2;
        PRT_FloatWindow(ABaseFloatWindow).IsTwinkleShow := false;
      end;
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
      Result := UIBaseWndProc.UIWndProcA(@ABaseFloatWindow.BaseWindow, AWnd, AMsg, wParam, lParam);
  end;
end;

function ParseXueQiuData(const AParam: PRT_FloatWindow; const AXueqiuData:string): Boolean;
var
  tmpSO: PJsonObject;
begin
  tmpSO := JsonParseStringW(PWideChar(WideString(AXueqiuData)), False);
  if nil = tmpSO then
    exit;
  if joObject <> tmpSO.DataType then
  begin

  end;
end;

function ParseXueQiuData2(const AParam: PRT_FloatWindow; const AXueqiuData:string): Boolean;
begin
end;

function GetXueQiuCookie(AHttpClient: PNetHttpClient): string;
var
  tmpUrl: AnsiString; 
  tmpHttpInfo: THttpUrlInfo;
  tmpHeader: AnsiString;    
  tmpRet: string;  
  tmpPos: integer;
  i: integer;   
  tmpCookieItem: string;
  tmpCookieKey: string;
  tmpIsUseCookieKey: Boolean;
begin
  Result := '';
  tmpUrl := 'http://xueqiu.com/P/ZH010389';   
  if not HttpProtocol.HttpUrlInfoParse(tmpUrl, @tmpHttpInfo) then
    exit;                   
  tmpHeader := 'GET' + #32 + tmpHttpInfo.PathName + #32 + 'HTTP/' + '1.1' + #13#10;
  tmpHeader := tmpHeader + 'Accept:text/html, application/xhtml+xml, */*' + #13#10;
  tmpHeader := tmpHeader + 'Accept-Language:zh-CN' + #13#10;
  tmpHeader := tmpHeader + 'User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' + #13#10;
  tmpHeader := tmpHeader + 'Accept-Encoding:gzip, deflate' + #13#10;
  tmpHeader := tmpHeader + 'Host:xueqiu.com' + #13#10;
  tmpHeader := tmpHeader + 'Connection:Keep-Alive' + #13#10;
  tmpHeader := tmpHeader + #13#10;
  tmpRet := NetHttpClientProc.HttpGet(GlobalApp.NetMgr, AHttpClient, tmpUrl, tmpHeader, true);
  if '' <> tmpRet then
  begin
    tmpPos := Pos('Set-Cookie', tmpRet);
    while 0 < tmpPos do
    begin
      tmpRet := Copy(tmpRet, tmpPos + Length('Set-Cookie') + 1, maxint);
      tmpCookieItem := '';
      for i := 1 to Length(tmpRet) do
      begin
        if (';' = tmpRet[i]) or
           (#13 = tmpRet[i]) or
           (#10 = tmpRet[i])then
        begin
          tmpCookieItem := Copy(tmpRet, 1, i - 1);
          Break;
        end;
      end;
      if '' <> tmpCookieItem then
      begin
        tmpPos := Pos('=', tmpCookieItem);
        if 0 < tmpPos then
        begin
          tmpCookieKey := Trim(Copy(tmpCookieItem, 1, tmpPos - 1));
          tmpIsUseCookieKey := false;
          if SameText('s', tmpCookieKey) then
            tmpIsUseCookieKey := true;
          if SameText('xq_a_token', tmpCookieKey) then
            tmpIsUseCookieKey := true;
          if SameText('xq_r_token', tmpCookieKey) then
            tmpIsUseCookieKey := true;
          if tmpIsUseCookieKey then
          begin
            if '' <> Result then
            begin
              Result := Result + ';';
            end else
            begin
              Result := 'Cookie:';
            end;
            Result := Result + tmpCookieItem;
          end;
        end;
      end;
      tmpPos := Pos('Set-Cookie', tmpRet);
    end;
  end;          
end;

function ThreadProc_RefreshData(AParam: PRT_FloatWindow): HResult; stdcall;
var
  i: integer;
  tmpPos: integer;   
  tmpHttpClient: PNetHttpClient;
  tmpUrl: AnsiString;
  tmpHttpInfo: THttpUrlInfo;
  tmpHeader: AnsiString;
  tmpPost: AnsiString;
  tmpCookie: AnsiString;
  tmpRet: string;
  tmpStr: string;
  tmpIni: TIniFile;
begin
  Result := 0;
  //(*//               
  tmpHttpClient := GlobalApp.NetMgr.CheckOutHttpClient; 
  tmpCookie := '';//GetXueQiuCookie(tmpHttpClient);
  tmpUrl := '';
  //*)
  (*//
  xueqiu login

  md5(password)
  
  areacode=86&
  password=467E2CDD0CD8B6AAE0446A4CD60DDC97&
  remember_me=on&
  telephone=13917781774

  Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0
P3P: CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"
X-Whom: hzali-ngx-228-73
P3P: CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"
X-Whom: hzali-ngx-228-73

  {}16 05:05:41 GMT; httpOnly
  X-RT: 8
  Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0
  Content-Encoding: gzip
  P3P: CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"
  X-Whom: hzali-ngx-228-73
  P3P: CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"
  X-Whom: hzali-ngx-228-73
  //*)
  if '' = tmpCookie then
  begin          
    tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    try
      tmpCookie := '';//Trim(tmpIni.ReadString('XQ', 'cookie', ''));
      if '' = tmpCookie then
      begin
        tmpCookie :=
          'Cookie:' +
            's=2tto120zt0; ' +
            'xq_a_token=5cd91d6495cb27f5bbf5e60e3be4b041329f42b2; ' +
            'xq_r_token=00333e2391d332225466a980ddc7b5fb83f0bf8e; ' + 
            'xqat=5cd91d6495cb27f5bbf5e60e3be4b041329f42b2; ' +
            'xq_is_login=1; ' +
            'u=1834645252; ' +
            'xq_token_expire=Tue%20Feb%2002%202016%2010%3A14%3A08%20GMT%2B0800%20(CST); ' +

            'Hm_lvt_1db88642e346389874251b5a1eded6e3=1452219252; ' +
            'Hm_lpvt_1db88642e346389874251b5a1eded6e3=1452219252; ' +
            
            '__utma=1.1671392041.1452219252.1452219252.1452219252.1; ' +
            '__utmb=1.1.10.1452219252; '  +
            '__utmz=1.1452219252.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ' +
            '__utmt=1; ' +
            '_sid=5DF0ETDcbmZeNaT8payG4padtveXX1; ' +
            '__utmc=1; ' +
            'bid=fd46228ed88baf1babe077973b522d02_ij51uimj';
      end;      
      tmpUrl := Trim(tmpIni.ReadString('XQ', 'url', 'http://xueqiu.com/cubes/rebalancing/history.json?cube_symbol=ZH010389&count=20&page=1'));
      tmpIni.WriteString('XQ', 'url', tmpUrl);
    finally
      tmpIni.Free;
    end;
  end;
  if '' = tmpUrl then
    exit;            
  //tmpUrl := 'http://xueqiu.com/user/login';
  if not HttpProtocol.HttpUrlInfoParse(tmpUrl, @tmpHttpInfo) then
    exit;       
  //tmpCookie :=
  //'s=c0314lsw8q' + '; ' +
  //'xq_a_token=51ae43fe10914e301fb74017584c7bee426ed0e6' + '; ' +
  //'xq_r_token=5630ffe651fb9190c98bb2f9bddcd2284e76463b';
  tmpHeader := HttpClientGenRequestHeader(@tmpHttpInfo, tmpCookie, 'POST', true);
  while True do
  begin           
    Sleep(20);
    if nil = AParam.BaseFloatWindow.BaseApp then
      Break;
    if 0 <> AParam.BaseFloatWindow.BaseApp.IsActiveStatus then
    begin        
      if 0 = AParam.IsFirstGot then
      begin
      end else
      begin
        //if not IsValidStockDealTime then
        //  Continue;
      end;
    //tmpUrl := 'http://127.0.0.1/';
    //tmpUrl := 'http://www.163.com';
      //tmpPost := 'areacode=86&password=467E2CDD0CD8B6AAE0446A4CD60DDC97&remember_me=on&telephone=13917781774';
      //tmpRet := NetHttpClientProc.HttpPost(GlobalApp.NetMgr, tmpHttpClient, tmpUrl, tmpHeader, tmpPost, false);

      tmpRet := JsonTestData.JsonData; //NetHttpClientProc.HttpGet(GlobalApp.NetMgr, tmpHttpClient, tmpUrl, tmpHeader, false);
      
      tmpPos := Pos('{', tmpRet);
      if 0 < tmpPos then
      begin
        tmpRet := Copy(tmpRet, tmpPos, MaxInt);
        for i := Length(tmpRet) downto 1 do
        begin
          if '}' = tmpRet[i] then
          begin
            tmpRet := Trim(Copy(tmpRet, 1, i + 1));
            Break;
          end;
        end;   
      end;
      if 1 = AParam.IsTwinkle then
      begin
        // 一旦获取过新的 买卖记录 不必再刷了
        Break;
      end;
      if not ParseXueQiuData(AParam, tmpRet) then
      begin
        tmpCookie := GetXueQiuCookie(tmpHttpClient);
        tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
        try
          if '' <> tmpCookie then
          begin
            tmpIni.WriteString('XQ', 'cookie', Trim(tmpCookie));
          end;
        finally
          tmpIni.Free;
        end;
        tmpHeader := HttpClientGenRequestHeader(@tmpHttpInfo, tmpCookie, 'POST', true);
        Continue;      
      end else
      begin
        with Classes.TStringList.Create do
        try
          Text := tmpRet;
          SaveToFile('e:\xueqiu.txt');
        finally
          Free;
        end;
        if 0 = AParam.IsFirstGot then
        begin
          AParam.IsFirstGot := 1;
        end;
      end;
      if not SameText(AParam.DrawBuyStockCode, AParam.BuyStockCode) then
      begin
        PostMessage(AParam.BaseFloatWindow.BaseWindow.UIWndHandle, CM_INVALIDATE, 0, 0);
      end;
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
         
procedure CreateRefreshDataThread(ABaseFloatWindow: PRT_BaseFloatWindow);
begin
  ABaseFloatWindow.DataThread.ThreadHandle := Windows.CreateThread(nil, 0, @ThreadProc_RefreshData,
      ABaseFloatWindow, Create_Suspended, ABaseFloatWindow.DataThread.ThreadID);
  Windows.ResumeThread(ABaseFloatWindow.DataThread.ThreadHandle);
end;

function CreateFloatWindow(App: TBaseApp; AFloatWindow: PRT_FloatWindow; AWndProc: TFNWndProc): Boolean; overload;
var
  tmpRegWndClass: TWndClassA;
  tmpCheckWndClass: TWndClassA;  
  tmpIsRegistered: Boolean;
  i: integer;
  tmpDC: HDC;
  tmpText: AnsiString;
  tmpSize: TSize;
  tmpRowCount: integer;
  tmpLogFontA: TLogFontA;
  tmpOldFont: HFONT;
begin
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  FillChar(tmpCheckWndClass, SizeOf(tmpCheckWndClass), 0);
  if not IsWindow(AFloatWindow.BaseFloatWindow.BaseWindow.UIWndHandle) then
  begin
    FillChar(AFloatWindow^, SizeOf(TRT_FloatWindow), 0);
  end;

  AFloatWindow.BaseFloatWindow.BaseApp := App;
  AFloatWindow.BaseFloatWindow.OnPaint := Paint_FloatWindow;

  FillChar(tmpLogFontA, SizeOf(tmpLogFontA), 0);
  tmpLogFontA.lfHeight := 12;
  tmpLogFontA.lfHeight := 10;  
  tmpLogFontA.lfWidth := 0;  
  tmpLogFontA.lfFaceName := 'MS Sans Serif';
  tmpLogFontA.lfCharSet := DEFAULT_CHARSET;
  tmpLogFontA.lfPitchAndFamily := FIXED_PITCH;
  AFloatWindow.BaseFloatWindow.Font := Windows.CreateFontIndirectA(tmpLogFontA);
  
  LoadFloatWindowConfig(AFloatWindow);

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
                  
  tmpDC := GetDC(0);
  try
    tmpOldFont := SelectObject(tmpDC, AFloatWindow.BaseFloatWindow.Font);
    try
      tmpText := 'B600000:100.00';
      Windows.GetTextExtentPoint32A(tmpDC, PAnsiChar(@tmpText[1]), Length(tmpText), tmpSize);
    finally
      SelectObject(tmpDC, tmpOldFont);
    end;
  finally
    ReleaseDC(0, tmpDC);
  end;

  if 0 < tmpSize.cx then
  begin
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Right := tmpSize.cx + 8;
  end else
  begin
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Right := 80;
  end;
  if 0 < tmpSize.cy then
  begin              
    tmpRowCount := 2;
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Bottom := tmpRowCount * (tmpSize.cy + 4) + 4;
  end;
  if 10 > AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Bottom then
  begin
    AFloatWindow.BaseFloatWindow.BaseWindow.ClientRect.Bottom := 10;
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

procedure ShowFloatWindow(ABaseFloatWindow: PRT_BaseFloatWindow); overload;
begin
  ShowWindow(ABaseFloatWindow.BaseWindow.UIWndHandle, SW_SHOW);
  UpdateWindow(ABaseFloatWindow.BaseWindow.UIWndHandle);
  Paint_FloatWindow_Layered(ABaseFloatWindow);
  CreateRefreshDataThread(ABaseFloatWindow);
end;
               
var
  Global_FloatWindow_1: TRT_FloatWindow;
                      
function FloatWndProcA_1(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := FloatWindowWndProcA(@Global_FloatWindow_1, AWnd, AMsg, wParam, lParam);
end;

function CreateFloatWindow(App: TBaseApp): Boolean; overload;
begin
  Result := CreateFloatWindow(App, @Global_FloatWindow_1, @FloatWndProcA_1);
end;

procedure ShowFloatWindow;
begin
  ShowFloatWindow(@Global_FloatWindow_1);
end;

procedure WMAppStart();
begin
  if CreateFloatWindow(GlobalBaseApp) then
  begin
    ShowFloatWindow;
  end;
end;

end.
