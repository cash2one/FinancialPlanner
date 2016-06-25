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
    pnMain: TPanel;
    pnStocks: TPanel;
    split1: TSplitter;
    vtStocks: TVirtualStringTree;
    pnTop: TPanel;
    pnData: TPanel;
    ts1: TTabSet;
    cbbDataSrc: TComboBox;
    procedure cbbDataSrcChange(Sender: TObject);
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
                       
procedure TfrmDataViewer.cbbDataSrcChange(Sender: TObject);
var
  tmpOldDataSrc: integer;
  tmpOldIsWeight: Boolean;
begin
  inherited;
  tmpOldDataSrc := fDataViewerData.DataSrc;
  tmpOldIsWeight := fDataViewerData.IsWeight;
  if 0 = cbbDataSrc.ItemIndex then
  begin
    fDataViewerData.DataSrc := DataSrc_163;
    fDataViewerData.IsWeight := false;
  end;
  if 1 = cbbDataSrc.ItemIndex then
  begin
    fDataViewerData.DataSrc := DataSrc_Sina;
    fDataViewerData.IsWeight := false;
  end;
  if 2 = cbbDataSrc.ItemIndex then
  begin
    fDataViewerData.DataSrc := DataSrc_Sina;
    fDataViewerData.IsWeight := true;
  end;              
  if (tmpOldDataSrc <> fDataViewerData.DataSrc) or
     (tmpOldIsWeight <> fDataViewerData.IsWeight) then
  begin
  end;
end;

constructor TfrmDataViewer.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fDataViewerData, SizeOf(fDataViewerData), 0);
  ts1.Tabs.Clear;
end;

destructor TfrmDataViewer.Destroy;
begin
  inherited;
end;
                                  
procedure TfrmDataViewer.Initialize(App: TBaseApp);
begin
  inherited;
  ts1.TabIndex := 0;
end;

end.
