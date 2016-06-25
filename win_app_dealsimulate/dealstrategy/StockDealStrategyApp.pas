unit StockDealStrategyApp;

interface

uses
  BaseForm,
  BaseStockApp;
                 
type
  TStockDealStrategyApp = class(TBaseStockApp)
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
  FormDealStrategyConsole;
  
{ TStockDealStrategyApp }

constructor TStockDealStrategyApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

function TStockDealStrategyApp.Initialize: Boolean;
begin
  Application.Initialize;
  InitializeDBStockItem;
  Result := true;
end;
              
procedure TStockDealStrategyApp.Run;
begin
  //FormDetailDataViewer.CreateMainForm(fMainForm);
  FormDealStrategyConsole.CreateMainForm(fMainForm);     
  fMainForm.Initialize(Self);
  Application.Run;
end;

end.
