unit bdzxAnalysisWinApp;

interface

uses
  BaseWinApp,
  BaseStockApp,
  StockInstantDataAccess;

type
  TBdzxAnalysisApp = class(TBaseStockApp)
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
  GlobalApp: TBdzxAnalysisApp = nil;
  
implementation

uses
  SysUtils,
  define_datasrc,
  define_dealstore_file,
  bdzxAnalysisForm,
  bdzxAnalysisWindow;
  
{ TStockFloatApp }

constructor TBdzxAnalysisApp.Create(AppClassId: AnsiString);
begin
  inherited;
  fLastStockInstant := nil;
  fCurrentStockInstant := nil;
end;

destructor TBdzxAnalysisApp.Destroy;
begin
  inherited;
end;
           
function TBdzxAnalysisApp.Initialize: Boolean;
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

procedure TBdzxAnalysisApp.Finalize;
begin
  if nil <> fCurrentStockInstant then
    FreeAndNil(fCurrentStockInstant);
  if nil <> fLastStockInstant then
    FreeAndNil(fLastStockInstant);
  inherited;
end;

procedure TBdzxAnalysisApp.Run;
begin
  inherited;
  ShowAmountRateWindow;
  RunAppMsgLoop;
end;

end.
