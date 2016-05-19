unit bollAnalysisWinApp;

interface

uses
  BaseWinApp,
  BaseStockApp,
  StockInstantDataAccess;

type
  TBollAnalysisApp = class(TBaseStockApp)
  protected
    fLastStockInstant: TDBStockInstant;
    fCurrentStockInstant: TDBStockInstant;
  public   
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;

    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;  
    property LastStockInstant: TDBStockInstant read fLastStockInstant;
    property CurrentStockInstant: TDBStockInstant read fCurrentStockInstant;
  end;  

var
  GlobalApp: TBollAnalysisApp = nil;
  
implementation

uses
  SysUtils,
  define_datasrc,
  define_dealstore_file,
  BollAnalysisForm,
  BollAnalysisWindow;
  
{ TStockFloatApp }

constructor TBollAnalysisApp.Create(AppClassId: AnsiString);
begin
  inherited;
  fLastStockInstant := nil;
  fCurrentStockInstant := nil;
end;

destructor TBollAnalysisApp.Destroy;
begin
  inherited;
end;
           
function TBollAnalysisApp.Initialize: Boolean;
begin
  inherited Initialize;
  Result := false;
  InitializeDBStockItem;
  if nil <> fBaseStockAppData.StockItemDB then
  begin
    if 0 < fBaseStockAppData.StockItemDB.RecordCount then
    begin
    end;
  end;
end;

procedure TBollAnalysisApp.Finalize;
begin
  if nil <> fCurrentStockInstant then
    FreeAndNil(fCurrentStockInstant);
  if nil <> fLastStockInstant then
    FreeAndNil(fLastStockInstant);
  inherited;
end;

procedure TBollAnalysisApp.Run;
begin
  inherited;
  //ShowBollAnalysisWindow;
  //RunAppMsgLoop;
end;

end.
