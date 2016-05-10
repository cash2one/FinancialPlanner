unit NetMgr;

interface

uses
  BaseApp,
  NetBase,
  NetObjClient,    
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
    function CheckOutNetClient: PNetClient;
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

function TNetMgr.CheckOutNetClient: PNetClient;
begin
  Result := System.New(PNetClient);
  FillChar(Result^, SizeOf(TNetClient), 0);
  Result.TimeOutConnect := 10 * 1000; //���ӳ�ʱ
  Result.TimeOutRead := 30 * 1000;
end;
           
//function TNetMgr.CheckOutHttpClient: PNetHttpClient;
//begin
//  Result := System.New(PNetHttpClient);
//  FillChar(Result^, SizeOf(TNetHttpClient), 0);
//  Result.NetClient := CheckOutNetClient;
//end;

end.
