unit NetBaseObj;

interface

uses
  Windows, WinSock2, Win.Thread, BaseDataIO, DataChain, win.diskfile;

type                    
  PNetClient              = ^TNetClient;       
  PNetServerAddress       = ^TNetServerAddress;

  TNetClient              = packed record
    ConnectSocketHandle   : Winsock2.TSocket;  
    TimeOutConnect        : Integer; //��λ���� (>0 ֵ��Ч)
    TimeOutRead           : Integer; //��λ����
    TimeOutSend           : Integer; //��λ����
    ConnectAddress        : PNetServerAddress;
  end;

  TNetServerAddress       = record
    Host                  : AnsiString;
    Ip                    : AnsiString;
    Port                  : Word;
  end;
  
implementation
                             
end.
