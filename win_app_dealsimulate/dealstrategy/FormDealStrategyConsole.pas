unit FormDealStrategyConsole;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  BaseApp, BaseForm, VirtualTrees, ExtCtrls, Tabs,
  db_dealItem, StockDayDataAccess,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA, StdCtrls;

type
  TDealStrategyFormData = record
    ActiveFrame: TfrmBase;
    Rule_CYHT_Price: TRule_CYHT_Price;
    Rule_BDZX_Price: TRule_BDZX_Price;
    Rule_Boll: TRule_Boll_Price;

    StockDayDataAccess: TStockDayDataAccess;   
    DataSrc: integer;
    IsWeight: Boolean;
  end;

  TfrmDealStrategy = class(TfrmBase)
  protected
    fDealStrategyFormData: TDealStrategyFormData;        
  public                        
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(App: TBaseApp); override;  
  end;
                                               
  procedure CreateMainForm(var AForm: TfrmBase);

implementation

{$R *.dfm}

uses
  BaseStockApp,
  Define_DataSrc,
  define_DealItem,
  define_stock_quotes,
  StockDayData_Load,
  db_dealItem_Load;
      
procedure CreateMainForm(var AForm: TfrmBase);
begin
  Application.CreateForm(TfrmDealStrategy, AForm);
end;

{ TfrmDataViewer }
                       
constructor TfrmDealStrategy.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fDealStrategyFormData, SizeOf(fDealStrategyFormData), 0);
end;

destructor TfrmDealStrategy.Destroy;
begin
  inherited;
end;
                                  
procedure TfrmDealStrategy.Initialize(App: TBaseApp);
begin
  inherited;
end;

end.
