unit BaseFutureApp;

interface

uses
  BaseWinApp, BaseApp, db_dealitem;
  
type
  TBaseFutureAppData = record
    DealItemDB: TDBDealItem;
  end;
  
  TBaseFutureApp = class(TBaseWinApp)
  protected
    fBaseFutureAppData: TBaseFutureAppData; 
    function GetPath: TBaseAppPath; override;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;     
    procedure InitializeDBDealItem;    
    property DealItemDB: TDBDealItem read fBaseFutureAppData.DealItemDB;
  end;

implementation

uses
  FutureAppPath,
  db_dealitem_Load;
                     
constructor TBaseFutureApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fBaseFutureAppData, SizeOf(fBaseFutureAppData), 0);
end;

destructor TBaseFutureApp.Destroy;
begin
  if nil <> fBaseFutureAppData.DealItemDB then
  begin
    fBaseFutureAppData.DealItemDB.Free;
    fBaseFutureAppData.DealItemDB := nil;
  end;
  inherited;
end;

function TBaseFutureApp.GetPath: TBaseAppPath;
begin
  if nil = fBaseWinAppData.AppPath then
    fBaseWinAppData.AppPath := TFutureAppPath.Create(Self);
  Result := fBaseWinAppData.AppPath;
end;
              
procedure TBaseFutureApp.InitializeDBDealItem;
begin              
  if nil = fBaseFutureAppData.DealItemDB then
  begin              
    fBaseFutureAppData.DealItemDB := TDBDealItem.Create;
  end;
end;

end.
