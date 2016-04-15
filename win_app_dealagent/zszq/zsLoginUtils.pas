unit zsLoginUtils;

interface

uses                          
  zsAttach;
                                                            
  procedure FindZSProgram(AZsDealSession: PZsDealSession);
  procedure LaunchZSProgram(AZsDealSession: PZsDealSession);
  
  procedure AutoLogin(AZsDealSession: PZsDealSession; AUserId, APassword: Integer); 
  procedure ReadZsConfig(AZsDealSession: PZsDealSession);

implementation

uses
  Windows, Sysutils, Messages,
  UtilsWindows,
  //UtilsLog,
  IniFiles,
  zsMainWindow,
  zsLoginWindow, 
  zsDialogUtils,
  zsUserLogin,
  zsProcess;
                           
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
      //Log('', 'ReadZsConfig host1:' + tmpAnsi);
      CopyMemory(@AZsDealSession.ZsProgramFileUrl[0], @tmpAnsi[1], Length(tmpAnsi));
      //Log('', 'ReadZsConfig host2:' + AZsDealSession.ZsProgramFileUrl);
            
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
  tmpAnsi: AnsiString;
begin          
  ReadZsConfig(AZsDealSession);
  tmpAnsi := AnsiString(PAnsiChar(@AZsDealSession.ZsProgramFileUrl[0]));
  if '' <> tmpAnsi then
  begin  
    //Log('', 'LaunchZSProgram:' + tmpAnsi);
    if FileExists(tmpAnsi) then
    begin                  
      //Log('', 'LaunchZSProgram Run');
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

procedure AutoLogin(AZsDealSession: PZsDealSession; AUserId, APassword: Integer);
var
  i: Integer;
begin
  FindZSProgram(AZsDealSession);  
  ReadZsConfig(AZsDealSession);
  if 0 = AZsDealSession.ProcessAttach.Process.ProcessId then
  begin             
    LaunchZSProgram(AZsDealSession);    
    HandleZsLogin(AZsDealSession, AUserId, APassword);
  end else
  begin
    if nil <> AZsDealSession.LoginWindow.HostWindowPtr then
    begin
      if IsWindow(AZsDealSession.LoginWindow.HostWindowPtr.WindowHandle) then
      begin
        HandleZsLogin(AZsDealSession, AUserId, APassword);
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
      while FindAndCloseZsDialog(AZsDealSession) do
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
      if not HandleZsLogin(AZsDealSession, AUserId, APassword) then
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
    (*//
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
    //*)
  end;
end;

end.
