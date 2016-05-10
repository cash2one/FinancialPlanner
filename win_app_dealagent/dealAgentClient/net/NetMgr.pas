unit NetMgr;

interface

uses
  BaseApp,
  NetBase,
  NetObjClient,
  NetClientIocp, 
  NetBaseObj;
  
type
  TNetMgrData = record
    NetBase: TNetBase;
  end;

  TNetMgr = class(TBaseAppObj)
  protected
    fNetMgrData: TNetMgrData;
  public
    constructor Create(App: TBaseApp); override;
    destructor Destroy; override;
    function CheckOutNetClient: PNetClientIocp;
  end;
  
implementation

uses
  Windows;
  
{ TNetMgr }
constructor TNetMgr.Create(App: TBaseApp);
begin
  inherited;
  FillChar(fNetMgrData, SizeOf(fNetMgrData), 0);
  InitializeNet(@fNetMgrData.NetBase);
end;

destructor TNetMgr.Destroy;
begin
  inherited;
end;

function TNetMgr.CheckOutNetClient: PNetClientIocp;
begin
  Result := System.New(PNetClientIocp);
  FillChar(Result^, SizeOf(TNetClientIocp), 0);
  Result.BaseClient.TimeOutConnect := 10 * 1000; //Á¬½Ó³¬Ê±
  Result.BaseClient.TimeOutRead := 30 * 1000;
end;
           
//function TNetMgr.CheckOutHttpClient: PNetHttpClient;
//begin
//  Result := System.New(PNetHttpClient);
//  FillChar(Result^, SizeOf(TNetHttpClient), 0);
//  Result.NetClient := CheckOutNetClient;
//end;

end.
