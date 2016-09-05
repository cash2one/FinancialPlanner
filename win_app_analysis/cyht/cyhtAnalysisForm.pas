unit cyhtAnalysisForm;

interface

uses
  Forms, BaseForm, Classes, Controls, SysUtils, StdCtrls,
  QuickSortList, QuickList_double, StockDayDataAccess,
  define_price, define_dealitem,
  Rule_CYHT;

type
  TfrmCyhtAnalysisData = record
    Rule_Cyht_Price: TRule_Cyht_Price;
    StockDayDataAccess: TStockDayDataAccess;
  end;
  
  TfrmCyhtAnalysis = class(TfrmBase)
    btncomputecyht: TButton;
    edtstock: TEdit;
    edtdatasrc: TComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure btncomputecyhtClick(Sender: TObject);
  protected
    fCyhtAnalysisData: TfrmCyhtAnalysisData;
    function getDataSrcCode: integer;
    function getDataSrcWeightMode: TWeightMode;
    function getStockCode: integer;
    procedure ComputeCYHT(ADataSrcCode: integer; AWeightMode: TWeightMode; AStockPackCode: integer); overload;
    procedure ComputeCYHT(ADataSrcCode: integer; ADealItem: PRT_DealItem; AWeightMode: TWeightMode; AOutput: TALDoubleList); overload;
  public        
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  define_datasrc,
  StockDayData_Load,
  BaseStockApp;
            
constructor TfrmCyhtAnalysis.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fCyhtAnalysisData, SizeOf(fCyhtAnalysisData), 0);
end;

function TfrmCyhtAnalysis.getDataSrcCode: integer;
begin
  Result := DataSrc_163;
end;
                              
function TfrmCyhtAnalysis.getDataSrcWeightMode: TWeightMode;
begin
  Result := weightNone;
end;
                            
function TfrmCyhtAnalysis.getStockCode: integer;
begin
  Result := getStockCodePack(edtstock.Text);
end;

procedure TfrmCyhtAnalysis.btncomputecyhtClick(Sender: TObject);
begin
  ComputeCYHT(getDataSrcCode, getDataSrcWeightMode, getStockCode);
end;

procedure TfrmCyhtAnalysis.ComputeCYHT(ADataSrcCode: integer; ADealItem: PRT_DealItem; AWeightMode: TWeightMode; AOutput: TALDoubleList);
var
  tmpSK: double;
begin
  if nil = ADealItem then
    exit;
  if 0 = ADealItem.EndDealDate then
  begin
    if nil <> fCyhtAnalysisData.StockDayDataAccess then
    begin
      fCyhtAnalysisData.StockDayDataAccess.Free;
    end;
    fCyhtAnalysisData.StockDayDataAccess := TStockDayDataAccess.Create(ADealItem, ADataSrcCode, AWeightMode);
    try
      StockDayData_Load.LoadStockDayData(App, fCyhtAnalysisData.StockDayDataAccess);

      if (0 < fCyhtAnalysisData.StockDayDataAccess.RecordCount) then
      begin
        if nil <> fCyhtAnalysisData.Rule_Cyht_Price then
        begin
          FreeAndNil(fCyhtAnalysisData.Rule_Cyht_Price);
        end;
        fCyhtAnalysisData.Rule_Cyht_Price := TRule_Cyht_Price.Create();
        try
          fCyhtAnalysisData.Rule_Cyht_Price.OnGetDataLength := fCyhtAnalysisData.StockDayDataAccess.DoGetRecords;
          fCyhtAnalysisData.Rule_Cyht_Price.OnGetPriceOpen := fCyhtAnalysisData.StockDayDataAccess.DoGetStockOpenPrice;
          fCyhtAnalysisData.Rule_Cyht_Price.OnGetPriceClose := fCyhtAnalysisData.StockDayDataAccess.DoGetStockClosePrice;
          fCyhtAnalysisData.Rule_Cyht_Price.OnGetPriceHigh := fCyhtAnalysisData.StockDayDataAccess.DoGetStockHighPrice;
          fCyhtAnalysisData.Rule_Cyht_Price.OnGetPriceLow := fCyhtAnalysisData.StockDayDataAccess.DoGetStockLowPrice;
          fCyhtAnalysisData.Rule_Cyht_Price.Execute;

          tmpSK := fCyhtAnalysisData.Rule_Cyht_Price.SK[fCyhtAnalysisData.StockDayDataAccess.RecordCount - 1];
          AOutput.AddObject(tmpSK, TObject(ADealItem));
        finally
          FreeAndNil(fCyhtAnalysisData.Rule_Cyht_Price);
        end;
      end;
    finally
      FreeAndNil(fCyhtAnalysisData.StockDayDataAccess);
    end;
  end;
end;

procedure TfrmCyhtAnalysis.ComputeCYHT(ADataSrcCode: integer; AWeightMode: TWeightMode; AStockPackCode: integer);
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpCyht: TALDoubleList;
  tmpResultOutput: TStringList;
begin
  tmpCyht := TALDoubleList.Create;
  try
    tmpCyht.Duplicates := lstDupAccept; 
    if 0 <> ADataSrcCode then
    begin
      tmpStockItem := TBaseStockApp(App).StockItemDB.FindItem(IntToStr(AStockPackCode));
      ComputeCYHT(ADataSrcCode, tmpStockItem, AWeightMode, tmpCyht);
    end else
    begin
      for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
      begin
        tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];
        ComputeCYHT(ADataSrcCode, tmpStockItem, AWeightMode, tmpCyht);  
      end;
    end;
    tmpCyht.Sort;

    tmpResultOutput := TStringList.Create;
    try
      for i := 0 to tmpCyht.Count - 1 do
      begin
        tmpStockItem := PRT_DealItem(tmpCyht.Objects[i]);
        tmpResultOutput.Add(FloatToStr(tmpCyht[i]) + ' -- ' + tmpStockItem.sCode);
      end;
      tmpResultOutput.SaveToFile('Cyht' + FormatDateTime('yyyymmdd_hhnnss', now) + '.txt');
    finally
      tmpResultOutput.Free;
    end;
  finally
    tmpCyht.Free;
  end;
end;

end.
