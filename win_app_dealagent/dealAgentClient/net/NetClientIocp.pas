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
   
implementation

procedure NetClientConnect(ANetClient: PNetClientIocp; AConnectAddress: PNetServerAddress);
var
  tmpRet: DWORD;    
  tmpSockAddr: WinSock2.TSockAddrIn;
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
  // 一般情况用connect就可以了，WSAConnect是微软的扩展函数，高级的特性你又没用上
  tmpRet := Winsock2.connect(ANetClient.BaseClient.ConnectSocketHandle, PSockAddr(@tmpSockAddr), SizeOf(tmpSockAddr));
  
  //tmpRet := WinSock2.WSAConnect(ANetClient.BaseClient.ConnectSocketHandle, PSockAddr(@tmpSockAddr), SizeOf(tmpSockAddr));
  //WinSock2.WSAConnectEx();
end;

end.
