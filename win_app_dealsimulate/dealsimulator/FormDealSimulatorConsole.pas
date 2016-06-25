unit FormDealSimulatorConsole;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  BaseApp, BaseForm, VirtualTrees, ExtCtrls, Tabs,
  db_dealItem, StockDayDataAccess,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA, StdCtrls;

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

  TfrmDataViewer = class(TfrmBase)
    pnTop: TPanel;
    pnlMain: TPanel;
    edStartMoney: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edStartDate: TEdit;
    Memo1: TMemo;
    Label3: TLabel;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
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
  StockDayData_Load,
  db_dealItem_Load;
      
procedure CreateMainForm(var AForm: TfrmBase);
begin
  Application.CreateForm(TfrmDataViewer, AForm);
end;

{ TfrmDataViewer }
                       
constructor TfrmDataViewer.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fDataViewerData, SizeOf(fDataViewerData), 0);
end;

destructor TfrmDataViewer.Destroy;
begin
  inherited;
end;
                                  
procedure TfrmDataViewer.Initialize(App: TBaseApp);
begin
  inherited;
end;

end.
