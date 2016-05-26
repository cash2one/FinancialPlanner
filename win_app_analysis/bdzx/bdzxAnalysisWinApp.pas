unit bdzxAnalysisWinApp;

interface

uses
  BaseForm,
  BaseWinApp,
  BaseStockApp;

type
  TBdzxAnalysisAppData = record
    MainForm: TfrmBase;
  end;
  
  TBdzxAnalysisApp = class(TBaseStockApp)
  protected
    fBdzxAnalysisAppData: TBdzxAnalysisAppData;
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
  Forms,
  define_datasrc,
  define_dealstore_file,
  bdzxAnalysisForm,
  bdzxAnalysisWindow;
  
{ TStockFloatApp }

constructor TBdzxAnalysisApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fBdzxAnalysisAppData, SizeOf(fBdzxAnalysisAppData), 0);
end;

destructor TBdzxAnalysisApp.Destroy;
begin
  inherited;
end;
           
function TBdzxAnalysisApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if result then
  begin
    InitializeDBStockItem;
    Result := false;
    if nil <> fBaseStockAppData.StockItemDB then
    begin
      if 0 < fBaseStockAppData.StockItemDB.RecordCount then
      begin
        Result := true;
      end;
    end;
  end;
  if Result then
  begin
    Application.Initialize;
    Application.MainFormOnTaskBar := true;
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
  Application.CreateForm(TfrmBdzxAnalysis, fBdzxAnalysisAppData.MainForm);
  fBdzxAnalysisAppData.MainForm.Initialize(Self);   
  Application.Run;
end;

end.
