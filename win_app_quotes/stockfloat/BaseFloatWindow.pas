unit BaseFloatWindow;

interface

uses
  Windows, BaseApp, UIBaseWin, BaseWinThread, UIBaseWinMemDC;
  
type           
  PRT_BaseFloatWindow = ^TRT_BaseFloatWindow;
  TRT_BaseFloatWindow = record
    BaseApp       : TBaseApp;
    BaseWindow    : TUIBaseWnd;
    DataThread    : TSysWinThread;
    Font          : HFONT;
    MemDC         : TMemDC;
    OnPaint       : procedure(ADC: HDC; ABaseFloatWindow: PRT_BaseFloatWindow);
  end;
                                                                              
  procedure SaveLayout(ABaseFloatWindow: PRT_BaseFloatWindow);
  procedure Paint_FloatWindow_Layered(ABaseFloatWindow: PRT_BaseFloatWindow);  
  function WMPaint_FloatWindowWndProcA(ABaseFloatWindow: PRT_BaseFloatWindow; AWnd: HWND): LRESULT;

implementation

uses
  IniFiles, SysUtils, UIWinColor;
                
function WMPaint_FloatWindowWndProcA(ABaseFloatWindow: PRT_BaseFloatWindow; AWnd: HWND): LRESULT;
var
  tmpPS: TPaintStruct;
  tmpDC: HDC;
begin
  Result := 0;
  tmpDC := BeginPaint(AWnd, tmpPS);
  try
    if Assigned(ABaseFloatWindow.OnPaint) then
    begin
      ABaseFloatWindow.OnPaint(tmpDC, ABaseFloatWindow);
    end;
  finally
  end;
  EndPaint(AWnd, tmpPS);
end;
                                 
procedure SaveLayout(ABaseFloatWindow: PRT_BaseFloatWindow);
var
  tmpIni: TIniFile;
begin
  
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteInteger('win', 'left', ABaseFloatWindow.BaseWindow.WindowRect.Left);
    tmpIni.WriteInteger('win', 'top', ABaseFloatWindow.BaseWindow.WindowRect.Top);
  finally
    tmpIni.Free;
  end;
end;

procedure Paint_FloatWindow_Layered(ABaseFloatWindow: PRT_BaseFloatWindow);
var
  tmpBlend: TBLENDFUNCTION;
  i, j: Integer;  
  tmpColor: PColor32;
begin
  if 0 = ABaseFloatWindow.MemDC.Handle then
  begin
    UpdateMemDC(@ABaseFloatWindow.MemDC,
        ABaseFloatWindow.BaseWindow.ClientRect.Right,
        ABaseFloatWindow.BaseWindow.ClientRect.Bottom);
  end;                                   
  tmpColor := ABaseFloatWindow.MemDC.MemData;
  if tmpColor <> nil then
  begin
    for i := 0 to ABaseFloatWindow.MemDC.Height - 1 do
    begin
      for j := 0 to ABaseFloatWindow.MemDC.Width - 1 do
      begin
        PColor32Entry(tmpColor).A := 255;
        PColor32Entry(tmpColor).A := 1;
        //PColor32Entry(tmpColor).B := 255;
        Inc(tmpColor);
      end;
    end;
  end;
  if Assigned(ABaseFloatWindow.OnPaint) then
  begin
    ABaseFloatWindow.OnPaint(ABaseFloatWindow.MemDC.Handle, ABaseFloatWindow);
  end;
  tmpColor := ABaseFloatWindow.MemDC.MemData;
  if tmpColor <> nil then
  begin
    for i := 0 to ABaseFloatWindow.MemDC.Height - 1 do
    begin
      for j := 0 to ABaseFloatWindow.MemDC.Width - 1 do
      begin
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
    ABaseFloatWindow.BaseWindow.UIWndHandle, 0,
        @ABaseFloatWindow.BaseWindow.WindowRect.TopLeft,
        @ABaseFloatWindow.BaseWindow.ClientRect.BottomRight,
        ABaseFloatWindow.MemDC.Handle,
        @ABaseFloatWindow.BaseWindow.ClientRect.TopLeft,
        0, // crKey: COLORREF
        @tmpBlend,// pblend: PBLENDFUNCTION;
        ULW_ALPHA // dwFlags: DWORD
        );
end;

end.
