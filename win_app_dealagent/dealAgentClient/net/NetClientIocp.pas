unit NetClientIocp;

interface

uses
  Windows, WinSock2,
  win.iocp, Win.Thread,
  BaseDataIO,
  NetBaseObj;

type          
  TIocpOperate = (ioNone, ioExit, ioSockRead, ioSockWrite, ioHandle, ioStream);
                                         
  PNetClientIocp    = ^TNetClientIocp;
  
  TNetIOCPClientWorkThread = packed record
    SysThread       : TSysWinThread;
    Client          : PNetClientIocp; 
  end;

  TNetClientIocp    = record
    BaseClient      : TNetClient;
    Iocp            : TWinIocp;
    IocpWorkThread  : TSysWinThread;
  end;
              
  PNetIocpBuffer      = ^TNetIocpBuffer;
  TNetIocpBuffer      = packed record
    Overlapped        : TOverlapped;   //完成端口重叠结构
    WsaBuf            : TWsaBuf;           //完成端口的缓冲区定义
    IocpOperate       : TIocpOperate; //当前操作类型
    ClientConnect     : PNetClientIocp;                 
    DataBufferPtr     : BaseDataIO.PDataBuffer;
  end;
 
  procedure NetClientConnect(ANetClient: PNetClientIocp; AConnectAddress: PNetServerAddress);
  procedure NetClientDisconnect(ANetClient: PNetClientIocp);   
  procedure NetClientSendBuf(ANetClient: PNetClientIocp; ABuf: Pointer; ABufSize: Integer; var ASendCount:Integer); 

implementation

uses
  NetObjClient;
                       
function CheckOutIocpBuffer(): PNetIocpBuffer;
begin
  Result := nil;
  if nil = Result then
  begin
    Result := System.New(PNetIocpBuffer);
    FillChar(Result^, SizeOf(TNetIocpBuffer), 0);

    Result.DataBufferPtr := System.New(PDataBuffer);
    FillChar(Result.DataBufferPtr^, SizeOf(TDataBuffer), 0);

    Result.DataBufferPtr.BufferHead.BufferSize := SizeOf(Result.DataBufferPtr.Data);
    Result.DataBufferPtr.BufferHead.Owner := Result;
  end else
  begin
    Result.DataBufferPtr.BufferHead.DataLength := 0;
    FillChar(Result.DataBufferPtr.Data, SizeOf(Result.DataBufferPtr.Data), 0);
  end;
end;

function CheckOutIocpDataOutBuffer(AClient: PNetClientIocp): PDataBuffer;
var    
  tmpBuffer: PNetIocpBuffer;
begin
  Result := nil;
  tmpBuffer := CheckOutIocpBuffer;
  if nil <> tmpBuffer then
  begin
    tmpBuffer.ClientConnect := AClient;
    Result := tmpBuffer.DataBufferPtr;
  end;
end;
                   
function ThreadProc_IOCPClientWorkThread(ANetClient: PNetClientIocp): HResult; stdcall; 
var
  tmpCompleteKey: DWORD;
  tmpBytes: Cardinal;   
  tmpIocpBuffer: PNetIocpBuffer;
begin
  Result := 0;
  while True do
  begin
    if not GetQueuedCompletionStatus(ANetClient.Iocp.Handle, tmpBytes, tmpCompleteKey, POverlapped(tmpIocpBuffer), INFINITE) then
    begin
      if nil <> tmpIocpBuffer then
      begin
      end;
    end else
    begin
      if 0 = tmpBytes then
      begin
      end else
      begin
      end;
    end;
  end;
  ExitThread(Result);
end;

procedure NetClientConnect(ANetClient: PNetClientIocp; AConnectAddress: PNetServerAddress);
var
  tmpRet: DWORD;    
  tmpSockAddr: WinSock2.TSockAddrIn;
  tmpIocpHandle: THandle;
begin                     
  InitWinIocp(@ANetClient.Iocp);
  
  if (Winsock2.INVALID_SOCKET = ANetClient.BaseClient.ConnectSocketHandle) or
     (0 = ANetClient.BaseClient.ConnectSocketHandle) then
  begin
    ANetClient.BaseClient.ConnectSocketHandle := WSASocket(AF_INET, SOCK_STREAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);
    //ANetClient.BaseClient.ConnectSocketHandle := Winsock2.Socket(AF_INET,SOCK_STREAM,0);
    if ANetClient.BaseClient.ConnectSocketHandle = INVALID_SOCKET  then
    begin
      //RaiseWSExcption();
    end;
  end;
  //ioctlsocket(ANetClient.BaseClient.ConnectSocketHandle);
  if nil <> AConnectAddress then
  begin
    ANetClient.BaseClient.ConnectAddress := AConnectAddress;
  end;
  
  ZeroMemory(@tmpSockAddr,SizeOf(tmpSockAddr));
  tmpSockAddr.sin_family      := AF_INET;
  if '' = AConnectAddress.Ip then
  begin
    AConnectAddress.Ip := NetObjClient.ResolveIP(ANetClient.BaseClient.ConnectAddress.HOST);
  end;
  tmpSockAddr.sin_addr.S_addr := Winsock2.inet_addr(PAnsiChar(@AConnectAddress.Ip[1]));

  tmpSockAddr.sin_port        := Winsock2.htons(ANetClient.BaseClient.ConnectAddress.Port);
  // 一般情况用connect就可以了，WSAConnect是微软的扩展函数，高级的特性你又没用上
  tmpRet := Winsock2.connect(ANetClient.BaseClient.ConnectSocketHandle, PSockAddr(@tmpSockAddr), SizeOf(tmpSockAddr));

  if DWORD(SOCKET_ERROR) = tmpRet then
  begin
    tmpRet := Winsock2.WSAGetLastError();
    if tmpRet <> WSAEWOULDBLOCK then
    begin
      //strErr := GetLastErrorErrorMessage(iRet);
      //raise exception.CreateFmt('Connect socket [2] error %d  %s',[iRet,strErr]);
    end;
  end;
  tmpIocpHandle := Windows.CreateIoCompletionPort(ANetClient.BaseClient.ConnectSocketHandle,
      ANetClient.Iocp.Handle, 1, 0);
  if ANetClient.Iocp.Handle = tmpIocpHandle then
  begin
    if 0 = ANetClient.IocpWorkThread.Core.ThreadHandle then
    begin
      ANetClient.IocpWorkThread.Core.ThreadHandle :=
          Windows.CreateThread(nil, 0, @ThreadProc_IOCPClientWorkThread, ANetClient,
          CREATE_SUSPENDED, ANetClient.IocpWorkThread.Core.ThreadID);
      Windows.ResumeThread(ANetClient.IocpWorkThread.Core.ThreadHandle);
    end;
  end;
  //tmpRet := WinSock2.WSAConnect(ANetClient.BaseClient.ConnectSocketHandle, PSockAddr(@tmpSockAddr), SizeOf(tmpSockAddr));
  //WinSock2.WSAConnectEx();
end;

procedure NetClientDisconnect(ANetClient: PNetClientIocp);      
var
  ErrCode:Integer;
  tmpLinger: TLinger;
begin
  if Winsock2.INVALID_SOCKET = ANetClient.BaseClient.ConnectSocketHandle then
    Exit;
  WinSock2.Shutdown(ANetClient.BaseClient.ConnectSocketHandle, SD_SEND);
  //Self.FErrorCode := 0;
  tmpLinger.l_onoff  := 1;
  tmpLinger.l_linger := 0;
  if SOCKET_ERROR = Winsock2.SetSockOpt(ANetClient.BaseClient.ConnectSocketHandle,
                        SOL_SOCKET,
                        SO_LINGER,
                        @tmpLinger,
                        SizeOf(tmpLinger)) then
  begin
   // ErrCode := WSAGetLastError();
   // TmpStr := IntToStr(ErrCode);
   // MessageBox(0,'aaaaaaaaaaaaaaaaaaa',PChar(TmpStr),0);
  end;
  Winsock2.CloseSocket(ANetClient.BaseClient.ConnectSocketHandle);
  ANetClient.BaseClient.ConnectSocketHandle := Winsock2.INVALID_SOCKET; 
end;
                   
procedure SendIocpDataOut(AClient: PNetClientIocp; ADataBuffer: PDataBuffer);
var
  iFlags: DWORD;
  iTransfer: DWORD;
  iErrCode: DWORD;
  tmpBufferCount: DWORD;
  tmpIocpBuffer: PNetIocpBuffer;
begin
  if nil = ADataBuffer then
    exit;
  tmpIocpBuffer := ADataBuffer.BufferHead.Owner;
  if nil = tmpIocpBuffer then
    exit;
  tmpIocpBuffer.ClientConnect := AClient;
  tmpIocpBuffer.IocpOperate := ioSockWrite;
  tmpIocpBuffer.WsaBuf.len := Length(tmpIocpBuffer.DataBufferPtr.Data);
  tmpIocpBuffer.WsaBuf.len := 4096;
  tmpIocpBuffer.WsaBuf.len := tmpIocpBuffer.DataBufferPtr.BufferHead.DataLength;
  tmpIocpBuffer.WsaBuf.buf := @tmpIocpBuffer.DataBufferPtr.Data[0]; 
  (*//            
  iTransfer := 0;
  iFlags := 0;
  if SOCKET_ERROR = WinSock2.send(
    tmpBuffer.ClientConnect.ConnectSocketHandle,
    tmpBuffer.ClientConnect.WriteBuffer.Data,
    tmpBuffer.ClientConnect.WriteBuffer.WsaBuf.len,
    iFlags) then
  begin
    iErrCode := WSAGetLastError;
    if iErrCode = WSAECONNRESET then //客户端被关闭
    begin

    end;
  end;
  //*)
  //(*//
  tmpBufferCount := 1;  
  iTransfer := 0;
  iFlags := MSG_PARTIAL;
  iFlags := MSG_OOB;
  if SOCKET_ERROR = WinSock2.WSASend(tmpIocpBuffer.ClientConnect.BaseClient.ConnectSocketHandle,
      @tmpIocpBuffer.WsaBuf,
      tmpBufferCount,
      @iTransfer,
      iFlags,
      @tmpIocpBuffer.Overlapped, nil) then
  begin
    iErrCode := WSAGetLastError;
    if iErrCode = WSAECONNRESET then //客户端被关闭
    begin

    end;    
  end;
  //*)
end;
        
procedure NetClientSendBuf(ANetClient: PNetClientIocp; ABuf: Pointer; ABufSize: Integer; var ASendCount:Integer);
var
  tmpBuffer: PDataBuffer;
begin
  tmpBuffer := CheckOutIocpDataOutBuffer(ANetClient);
  if nil <> tmpBuffer then
  begin
    tmpBuffer.BufferHead.DataLength := ABufSize + 1;    
    CopyMemory(@tmpBuffer.Data[0], ABuf, ABufSize);
    SendIocpDataOut(ANetClient, tmpBuffer);
  end;
end;

end.
