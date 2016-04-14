unit zsUserLogin;

interface

uses
  zsAttach, Windows, SysUtils;
                     
  function HandleZsLogin(AZsDealSession: PZsDealSession; AUserId, APassword: integer): Boolean;

implementation

uses
  UtilsWindows,
  zsLoginWindow,
  zsMainWindow,
  Graphics;
  
function HandleZsLogin(AZsDealSession: PZsDealSession; AUserId, APassword: integer): Boolean;
var
  i: integer;                  
  tmpVerifyCodeBitmap: Graphics.TBitmap;
  tmpVerifyCode: AnsiString;
  tmpAnsi: AnsiString;
begin
  Result := true;
  for i := 0 to 3 * 50 do
  begin
    SleepWait(20);
    if FindZSLoginWindow(AZsDealSession) then
    begin
      Break;
    end;
  end;
  if nil = AZsDealSession.LoginWindow.HostWindowPtr then
  begin
    Result := false;
    exit;
  end;
  if IsWindow(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle) then
  begin                 
    if '' = AZsDealSession.ZsAccount then
    begin
      tmpAnsi := IntToStr(AUserId);
      CopyMemory(@AZsDealSession.ZsAccount[0], @tmpAnsi[1], Length(tmpAnsi));
    end;
    if '' = AZsDealSession.ZsPassword then
    begin
      tmpAnsi := IntToStr(APassword);
      CopyMemory(@AZsDealSession.ZsPassword[0], @tmpAnsi[1], Length(tmpAnsi));
    end;
    SleepWait(20);
    CheckZSLoginWindow(@AZsDealSession.LoginWindow);
    ForceBringFrontWindow(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle);

    if '' <> AZsDealSession.ZsAccount then
    begin
      if IsWindow(AZsDealSession.LoginWindow.WndAccountEdit) then
      begin
        if IsWindowEnabled(AZsDealSession.LoginWindow.WndAccountEdit) then
        begin
          InputLoginAccount(@AZsDealSession.LoginWindow, AZsDealSession.ZsAccount); //  '1808175116'
          SleepWait(20);
          AZsDealSession.ZsAccount := '';
        end;
      end;
    end;
    if '' <> AZsDealSession.ZsPassword then
    begin         
      if IsWindow(AZsDealSession.LoginWindow.WndPasswordEdit) then
      begin
        if IsWindowEnabled(AZsDealSession.LoginWindow.WndPasswordEdit) then
        begin
          InputLoginPassword(@AZsDealSession.LoginWindow, AZsDealSession.ZsPassword);
          AZsDealSession.ZsPassword := '';
          SleepWait(20);
          tmpVerifyCodeBitmap := GetVerifyCodeBmp(AZsDealSession.LoginWindow.HostWindowPtr, 447, 241, 52, 21);
          if nil <> tmpVerifyCodeBitmap then
          begin
            try
              //tmpVerifyCodeBitmap.SaveToFile('e:\test.bmp');
              tmpVerifyCode := GetVerifyCode(tmpVerifyCodeBitmap);
              if '' <> tmpVerifyCode then
              begin
                InputLoginVerifyCode(@AZsDealSession.LoginWindow, tmpVerifyCode);
                SleepWait(20);
              end else      
                Result := false;
            finally
              tmpVerifyCodeBitmap.Free;
            end;
          end;
        end;
      end;
    end;            
    if Result then
    begin
      ClickLoginButton(@AZsDealSession.LoginWindow);
    end;
  end;           
  if Result then
  begin          
    for i := 1 to 20 * 50 do
    begin
      if not IsWindow(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle) then
        Break;
      if not IsWindowVisible(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle) then
        Break;
      SleepWait(20);
    end;
    for i := 1 to 20 * 50 do
    begin
      SleepWait(20);
      if FindZSMainWindow(AZsDealSession) then
      begin
        Break;
      end;
    end;
  end;
end;

end.
