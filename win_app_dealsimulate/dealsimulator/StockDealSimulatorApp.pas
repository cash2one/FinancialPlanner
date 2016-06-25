unit StockDealSimulatorApp;

interface

uses
  BaseForm,
  BaseStockApp;
                 
type
  TStockDealSimulatorApp = class(TBaseStockApp)
  protected
    fMainForm: TfrmBase;              
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
    function Initialize: Boolean; override;
  end;

implementation

uses
  Forms,
  FormDealSimulatorConsole;
  
{ TStockDealSimulatorApp }

constructor TStockDealSimulatorApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

function TStockDealSimulatorApp.Initialize: Boolean;
begin
  Application.Initialize;
  InitializeDBStockItem;
  Result := true;
end;
              
procedure TStockDealSimulatorApp.Run;
begin
  //FormDetailDataViewer.CreateMainForm(fMainForm);
  FormDealSimulatorConsole.CreateMainForm(fMainForm);     
  fMainForm.Initialize(Self);
  Application.Run;
end;

end.
