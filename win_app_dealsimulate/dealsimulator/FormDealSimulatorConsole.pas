unit FormDealSimulatorConsole;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  BaseApp, BaseForm, VirtualTrees, ExtCtrls, Tabs,
  db_dealItem, StockDayDataAccess, define_dealsimulation,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA, StdCtrls,
  ComCtrls;

type
  TDataViewerData = record
    ActiveFrame: TfrmBase;
    Rule_CYHT_Price: TRule_CYHT_Price;
    Rule_BDZX_Price: TRule_BDZX_Price;
    Rule_Boll: TRule_Boll_Price;

    StockDayDataAccess: TStockDayDataAccess;   
    DataSrc: integer;
    IsWeight: Boolean;
  end;

  TfrmDealSimulation = class(TfrmBase)
    pnTop: TPanel;
    pnlMain: TPanel;
    edLogs: TMemo;
    pnlConsole: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edStartMoney: TEdit;
    btnStart: TButton;
    Label4: TLabel;
    Label5: TLabel;
    pnlDealCmd: TPanel;
    pnlDealHistory: TPanel;
    Label3: TLabel;
    vtDealHistory: TVirtualStringTree;
    edStock: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edPrice: TEdit;
    Label8: TLabel;
    edNum: TEdit;
    pnlHolds: TPanel;
    Label9: TLabel;
    vtHoldsNow: TVirtualStringTree;
    btnBuy: TButton;
    btnSale: TButton;
    dateDeal: TDateTimePicker;
    dateStart: TDateTimePicker;
  protected
    fDataViewerData: TDataViewerData;        
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
  utils_dealsimulation,
  StockDayData_Load,
  db_dealItem_Load;
      
procedure CreateMainForm(var AForm: TfrmBase);
begin
  Application.CreateForm(TfrmDealSimulation, AForm);
end;

{ TfrmDataViewer }
                       
constructor TfrmDealSimulation.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fDataViewerData, SizeOf(fDataViewerData), 0);
end;

destructor TfrmDealSimulation.Destroy;
begin
  inherited;
end;
                                  
procedure TfrmDealSimulation.Initialize(App: TBaseApp);
begin
  inherited;
end;

end.
