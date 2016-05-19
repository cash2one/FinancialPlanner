unit cyhtAnalysisWinApp;

interface

uses
  BaseWinApp,
  BaseStockApp;

type
  TcyhtAnalysisApp = class(TBaseStockApp)
  protected
  public   
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;

    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;  
  end;  

var
  GlobalApp: TcyhtAnalysisApp = nil;
  
implementation

uses
  SysUtils,
  define_datasrc,
  define_dealstore_file,
  cyhtAnalysisForm,
  cyhtAnalysisWindow;
  
{ TStockFloatApp }

constructor TcyhtAnalysisApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

destructor TcyhtAnalysisApp.Destroy;
begin
  inherited;
end;
           
function TcyhtAnalysisApp.Initialize: Boolean;
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

procedure TcyhtAnalysisApp.Finalize;
begin
  inherited;
end;

procedure TcyhtAnalysisApp.Run;
begin
  inherited;
  //ShowcyhtAnalysisWindow;
  //RunAppMsgLoop;
end;

end.
