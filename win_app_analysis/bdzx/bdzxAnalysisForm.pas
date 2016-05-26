unit bdzxAnalysisForm;

interface

uses
  Forms, BaseForm, Classes, Controls, SysUtils, StdCtrls,
  StockDayDataAccess,
  Rule_BDZX;

type
  TfrmBdzxAnalysisData = record
    Rule_BDZX_Price: TRule_BDZX_Price;
    StockDayDataAccess: TStockDayDataAccess;
  end;
  
  TfrmBdzxAnalysis = class(TfrmBase)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  protected
    fBdzxAnalysisData: TfrmBdzxAnalysisData;
  public        
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  define_dealitem,
  define_datasrc,
  StockDayData_Load,
  BaseStockApp;
            
constructor TfrmBdzxAnalysis.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fBdzxAnalysisData, SizeOf(fBdzxAnalysisData), 0);
end;

procedure TfrmBdzxAnalysis.btn1Click(Sender: TObject);
var
  i: integer;
  tmpStockItem: PRT_DealItem;
begin
  for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
  begin
    tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];   
    if 0 = tmpStockItem.EndDealDate then
    begin
      if nil <> fBdzxAnalysisData.StockDayDataAccess then
        fBdzxAnalysisData.StockDayDataAccess.Free;
      fBdzxAnalysisData.StockDayDataAccess := TStockDayDataAccess.Create(tmpStockItem, DataSrc_163, false);

      StockDayData_Load.LoadStockDayData(App, fBdzxAnalysisData.StockDayDataAccess);

      if (0 < fBdzxAnalysisData.StockDayDataAccess.RecordCount) then
      begin
        if nil <> fBdzxAnalysisData.Rule_BDZX_Price then
        begin
          FreeAndNil(fBdzxAnalysisData.Rule_BDZX_Price);
        end;
        fBdzxAnalysisData.Rule_BDZX_Price := TRule_BDZX_Price.Create();

        fBdzxAnalysisData.Rule_BDZX_Price.OnGetDataLength := fBdzxAnalysisData.StockDayDataAccess.DoGetRecords;
        fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceOpen := fBdzxAnalysisData.StockDayDataAccess.DoGetStockOpenPrice;
        fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceClose := fBdzxAnalysisData.StockDayDataAccess.DoGetStockClosePrice;
        fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceHigh := fBdzxAnalysisData.StockDayDataAccess.DoGetStockHighPrice;
        fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceLow := fBdzxAnalysisData.StockDayDataAccess.DoGetStockLowPrice;
        fBdzxAnalysisData.Rule_BDZX_Price.Execute;
      end;
    end;
  end;
end;

end.
