unit bdzxAnalysisWinApp;

interface

uses
  BaseWinApp,
  BaseStockApp;

type
  TBdzxAnalysisApp = class(TBaseStockApp)
  protected
  public   
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;

    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;  
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
  inherited;
end;

procedure TBdzxAnalysisApp.Run;
begin
  inherited;
  //ShowbdzxAnalysisWindow;
  //RunAppMsgLoop;
end;

end.
