unit NetBaseObj;

interface

uses
  Windows, WinSock2, Win.Thread, BaseDataIO, DataChain, win.diskfile;

type                    
  PNetClient              = ^TNetClient;       
  PNetServerAddress       = ^TNetServerAddress;

  TNetClient              = packed record
    ConnectSocketHandle   : Winsock2.TSocket;  
    TimeOutConnect        : Integer; //单位毫秒 (>0 值有效)
    TimeOutRead           : Integer; //单位毫秒
    TimeOutSend           : Integer; //单位毫秒
    ConnectAddress        : PNetServerAddress;
  end;

  TNetServerAddress       = record
    Host                  : AnsiString;
    Ip                    : AnsiString;
    Port                  : Word;
  end;
  
implementation
                             
end.
