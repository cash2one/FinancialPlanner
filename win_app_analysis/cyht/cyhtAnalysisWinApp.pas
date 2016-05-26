unit cyhtAnalysisWinApp;

interface

uses
  BaseForm,
  BaseWinApp,
  BaseStockApp;

type
  TCyhtAnalysisAppData = record
    MainForm: TfrmBase;
  end;
  
  TcyhtAnalysisApp = class(TBaseStockApp)
  protected
    fCyhtAnalysisAppData: TCyhtAnalysisAppData;
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
  Forms,
  define_datasrc,
  define_dealstore_file,
  cyhtAnalysisForm,
  cyhtAnalysisWindow;
  
{ TStockFloatApp }

constructor TcyhtAnalysisApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fCyhtAnalysisAppData, SizeOf(fCyhtAnalysisAppData), 0);
end;

destructor TcyhtAnalysisApp.Destroy;
begin
  inherited;
end;
           
function TcyhtAnalysisApp.Initialize: Boolean;
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

procedure TcyhtAnalysisApp.Finalize;
begin
  inherited;
end;

procedure TcyhtAnalysisApp.Run;
begin
  inherited;
  //ShowcyhtAnalysisWindow;
  //RunAppMsgLoop;
  Application.CreateForm(TfrmCyhtAnalysis, fCyhtAnalysisAppData.MainForm);
  fCyhtAnalysisAppData.MainForm.Initialize(Self);   
  Application.Run;
end;

end.
