unit sygwLoginUtils;

interface

uses                          
  sygwAttach,
  Graphics;

  procedure AutoLogin(AZsDealSession: PZsDealSession);

implementation

uses
  Windows, Sysutils, Messages,
  UtilsApplication,
  UtilsWindows,
  IniFiles,
  sygwMainWindow,
  sygwLoginWindow,
  exProcess;
                           
procedure FindZSProgram(AZsDealSession: PZsDealSession);
begin
  if 0 = AZsDealSession.ProcessAttach.Process.ProcessId then
  begin
    if FindZSMainWindow(AZsDealSession) then
    begin
      if nil <> AZsDealSession.MainWindow.HostWindowPtr then
      begin
        Windows.GetWindowThreadProcessId(AZsDealSession.MainWindow.HostWindowPtr.WindowHandle,
          AZsDealSession.ProcessAttach.Process.ProcessId);
      end;
    end;
  end;    
  if 0 = AZsDealSession.ProcessAttach.Process.ProcessId then
  begin
    if FindZSLoginWindow(AZsDealSession) then
    begin
      if nil <> AZsDealSession.LoginWindow.HostWindowPtr then
      begin
        Windows.GetWindowThreadProcessId(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle,
          AZsDealSession.ProcessAttach.Process.ProcessId);
      end;
    end;
  end;          
end;
             
procedure ReadZsConfig(AZsDealSession: PZsDealSession);
var  
  tmpIni: TIniFile;
  tmpAnsi: AnsiString;
begin
  if (not AZsDealSession.ZsIsConfigReaded) then
  begin
    AZsDealSession.ZsIsConfigReaded := true;
    tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    try
      //ZsProgramFileUrl := ZsProgramPathUrl + 'TdxW.exe';
      //ZsProgramPathUrl := 'D:\stock\zd_zszq\';
      tmpAnsi := tmpIni.ReadString('ZS', 'Host', '');
      CopyMemory(@AZsDealSession.ZsProgramFileUrl[0], @tmpAnsi[1], Length(tmpAnsi));
      
      tmpAnsi := tmpIni.ReadString('ZS', 'Acc', '');
      CopyMemory(@AZsDealSession.ZsAccount[0], @tmpAnsi[1], Length(tmpAnsi));
      tmpAnsi := tmpIni.ReadString('ZS', 'Pwd', '');
      CopyMemory(@AZsDealSession.ZsPassword[0], @tmpAnsi[1], Length(tmpAnsi));
      if '' <> AZsDealSession.ZsProgramFileUrl then
      begin
        tmpAnsi := ExtractFilePath(AZsDealSession.ZsProgramFileUrl);
        CopyMemory(@AZsDealSession.ZsProgramPathUrl[0], @tmpAnsi[1], Length(tmpAnsi));
      end;
      tmpIni.WriteString('ZS', 'Host', AZsDealSession.ZsProgramFileUrl);
      tmpIni.WriteString('ZS', 'Pwd', AZsDealSession.ZsPassword);
      tmpIni.WriteString('ZS', 'Acc', AZsDealSession.ZsAccount);
    finally
      tmpIni.Free;
    end;
  end;
end;

procedure LaunchZSProgram(AZsDealSession: PZsDealSession);
var
  i: integer;
begin          
  ReadZsConfig(AZsDealSession);
  if '' <> AZsDealSession.ZsProgramFileUrl then
  begin
    if FileExists(AZsDealSession.ZsProgramFileUrl) then
    begin
      FillChar(AZsDealSession.ProcessAttach.Process.StartInfo, SizeOf(AZsDealSession.ProcessAttach.Process.StartInfo), 0);
      FillChar(AZsDealSession.ProcessAttach.Process.ProcInfo, SizeOf(AZsDealSession.ProcessAttach.Process.ProcInfo), 0);
      Windows.CreateProcessA(PAnsiChar(@AZsDealSession.ZsProgramFileUrl[0]),
          nil, nil, nil, false, 0, nil, @AZsDealSession.ZsProgramPathUrl[0],
          AZsDealSession.ProcessAttach.Process.StartInfo,
          AZsDealSession.ProcessAttach.Process.ProcInfo);
      SleepWait(100);     
      AZsDealSession.ProcessAttach.Process.ProcessId :=
        AZsDealSession.ProcessAttach.Process.ProcInfo.dwProcessId;
      for i := 1 to 50 do
      begin
        SleepWait(20); 
        if FindZSLoginWindow(AZsDealSession) then
          Break;
      end;
      AZsDealSession.ProcessAttach.Process.ProcessId :=
        AZsDealSession.ProcessAttach.Process.ProcInfo.dwProcessId;
    end;
  end;
end;

function HandleZsLogin(AZsDealSession: PZsDealSession): Boolean;
var
  i: integer;                  
  tmpVerifyCodeBitmap: Graphics.TBitmap;
  tmpVerifyCode: AnsiString;
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
    ReadZsConfig(AZsDealSession);   
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

function HandleZsDialog(AZsDealSession: PZsDealSession): Boolean;
var
  i: integer;
  tmpCount: integer;
  j: integer;
  tmpDialogWindow: PExProcessWindow;
begin
  Result := false;
  tmpCount := 0;
  for i := 1 to 2 * 50 do
  begin
    SleepWait(20);
    if FindZSDialogWindow(AZsDealSession) then
    begin
      tmpCount := 0;
      Result := true;
    end else
    begin
      Inc(tmpCount);
    end;
    if 20 < tmpCount then
      Break;
    if 0 = tmpCount then
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
              if IsWindow(tmpDialogWindow.CancelButton) then
              begin
                ForceBringFrontWindow(tmpDialogWindow.WindowHandle);
                SleepWait(20);
                ForceBringFrontWindow(tmpDialogWindow.WindowHandle);
                SleepWait(20);
                ClickButtonWnd(tmpDialogWindow.CancelButton);
              end else
              begin
                PostMessage(tmpDialogWindow.WindowHandle, WM_Close, 0, 0);   
                SleepWait(20);
              end;
              Break;
            end;
          end;
        end;
      end;
    end;
  end;
end;
            
procedure AutoLogin(AZsDealSession: PZsDealSession);
var
  i: Integer;
begin
  FindZSProgram(AZsDealSession);
  if 0 = AZsDealSession.ProcessAttach.Process.ProcessId then
  begin             
    LaunchZSProgram(AZsDealSession);    
    HandleZsLogin(AZsDealSession);
  end else
  begin
    if nil <> AZsDealSession.LoginWindow.HostWindowPtr then
    begin
      if IsWindow(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle) then
      begin
        HandleZsLogin(AZsDealSession);
      end;
    end;
  end;
  // 确认主窗体一定存在
  for i := 1 to 2 * 50 do
  begin
    SleepWait(20);
    if FindZSMainWindow(AZsDealSession) then
    begin
      Break;
    end;
  end;
  if nil = AZsDealSession.MainWindow.HostWindowPtr then
    exit;
  if IsWindow(AZsDealSession.MainWindow.HostWindowPtr.WindowHandle) then
  begin
    CheckZSMainWindow(@AZsDealSession.MainWindow);
    if not IsWindow(AZsDealSession.MainWindow.WndFunctionTree) then
    begin
      i := 0;
      while HandleZsDialog(AZsDealSession) do
      begin
        SleepWait(20);
        Inc(i);
        if 3 < i then
          Break;
      end;
      for i := 1 to 10 * 50 do
      begin
        if not IsWindow(AZsDealSession.MainWindow.TopMenu.WndOrderButton) then
        begin
          SleepWait(20);
          CheckZSMainWindow(@AZsDealSession.MainWindow);
        end;
      end;
      if IsWindow(AZsDealSession.MainWindow.TopMenu.WndOrderButton) then
      begin                 
        SleepWait(20);
        ForceBringFrontWindow(AZsDealSession.MainWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
        ForceBringFrontWindow(AZsDealSession.MainWindow.HostWindowPtr.WindowHandle);
        SleepWait(20);
        ClickMenuOrderMenuItem(@AZsDealSession.MainWindow);
        for i := 0 to 2 * 50 do
        begin
          FillChar(AZsDealSession.LoginWindow, SizeOf(AZsDealSession.LoginWindow), 0);
          if FindZSLoginWindow(AZsDealSession) then
          begin
            Break;
          end;
        end;
      end;
      if not HandleZsLogin(AZsDealSession) then
      begin
        exit;
      end;
    end;                    
    for i := 1 to 10 * 50 do
    begin               
      SleepWait(20);
      CheckZSMainWindow(@AZsDealSession.MainWindow);    
      if IsWindow(AZsDealSession.MainWindow.WndFunctionTree) then
        Break;
    end;
    if IsWindow(AZsDealSession.MainWindow.WndFunctionTree) then
    begin
      i := 0;
      while HandleZsDialog(AZsDealSession) do
      begin
        SleepWait(20);
        Inc(i);
        if 3 < i then
          Break;
      end;
      ClickTreeBuyNode(@AZsDealSession.MainWindow);
      //ClickTreeCancelNode(@MainWindow);
      //ClickTreeQueryHoldNode(@MainWindow);
    end else
    begin
    
    end;
  end;
end;

end.
