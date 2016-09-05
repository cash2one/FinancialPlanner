unit bdzxAnalysisForm;

interface

uses
  Forms, BaseForm, Classes, Controls, SysUtils, StdCtrls,
  QuickSortList, QuickList_double, StockDayDataAccess,
  define_price, define_dealitem,
  Rule_BDZX;

type
  TfrmBdzxAnalysisData = record
    Rule_BDZX_Price: TRule_BDZX_Price;
    StockDayDataAccess: TStockDayDataAccess;
  end;
  
  TfrmBdzxAnalysis = class(TfrmBase)
    btnComputeBDZX: TButton;
    edtstock: TEdit;
    edtdatasrc: TComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure btnComputeBDZXClick(Sender: TObject);
  protected
    fBdzxAnalysisData: TfrmBdzxAnalysisData;
    function getDataSrcCode: integer;
    function getDataSrcWeightMode: TWeightMode;
    function getStockCode: integer;
    procedure ComputeBDZX(ADataSrcCode: integer; AWeightMode: TWeightMode; AStockPackCode: integer); overload;
    procedure ComputeBDZX(ADataSrcCode: integer; ADealItem: PRT_DealItem; AWeightMode: TWeightMode; AOutput: TALDoubleList); overload;
  public        
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  define_datasrc,
  StockDayData_Load,
  BaseStockApp;
            
constructor TfrmBdzxAnalysis.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fBdzxAnalysisData, SizeOf(fBdzxAnalysisData), 0);
end;

function TfrmBdzxAnalysis.getDataSrcCode: integer;
begin
  Result := DataSrc_163;
end;

function TfrmBdzxAnalysis.getDataSrcWeightMode: TWeightMode;
begin
  Result := weightNone;
end;
                            
function TfrmBdzxAnalysis.getStockCode: integer;
begin
  Result := getStockCodePack(edtstock.Text);
end;

procedure TfrmBdzxAnalysis.btnComputeBDZXClick(Sender: TObject);
begin
  ComputeBDZX(getDataSrcCode, getDataSrcWeightMode, getStockCode);
end;

procedure TfrmBdzxAnalysis.ComputeBDZX(ADataSrcCode: integer; ADealItem: PRT_DealItem; AWeightMode: TWeightMode; AOutput: TALDoubleList);
var
  tmpAj: double;
begin
  if nil = ADealItem then
    exit;
  if 0 = ADealItem.EndDealDate then
  begin
    if nil <> fBdzxAnalysisData.StockDayDataAccess then
    begin
      fBdzxAnalysisData.StockDayDataAccess.Free;
    end;
    fBdzxAnalysisData.StockDayDataAccess := TStockDayDataAccess.Create(ADealItem, DataSrc_163, weightNone);
    try
      StockDayData_Load.LoadStockDayData(App, fBdzxAnalysisData.StockDayDataAccess);

      if (0 < fBdzxAnalysisData.StockDayDataAccess.RecordCount) then
      begin
        if nil <> fBdzxAnalysisData.Rule_BDZX_Price then
        begin
          FreeAndNil(fBdzxAnalysisData.Rule_BDZX_Price);
        end;
        fBdzxAnalysisData.Rule_BDZX_Price := TRule_BDZX_Price.Create();
        try
          fBdzxAnalysisData.Rule_BDZX_Price.OnGetDataLength := fBdzxAnalysisData.StockDayDataAccess.DoGetRecords;
          fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceOpen := fBdzxAnalysisData.StockDayDataAccess.DoGetStockOpenPrice;
          fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceClose := fBdzxAnalysisData.StockDayDataAccess.DoGetStockClosePrice;
          fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceHigh := fBdzxAnalysisData.StockDayDataAccess.DoGetStockHighPrice;
          fBdzxAnalysisData.Rule_BDZX_Price.OnGetPriceLow := fBdzxAnalysisData.StockDayDataAccess.DoGetStockLowPrice;
          fBdzxAnalysisData.Rule_BDZX_Price.Execute;

          tmpAj := fBdzxAnalysisData.Rule_BDZX_Price.Ret_AJ.value[fBdzxAnalysisData.StockDayDataAccess.RecordCount - 1];
          AOutput.AddObject(tmpAj, TObject(ADealItem));
        finally
          FreeAndNil(fBdzxAnalysisData.Rule_BDZX_Price);
        end;
      end;
    finally
      FreeAndNil(fBdzxAnalysisData.StockDayDataAccess);
    end;
  end;
end;

procedure TfrmBdzxAnalysis.ComputeBDZX(ADataSrcCode: integer; AWeightMode: TWeightMode; AStockPackCode: integer);
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpBDZX: TALDoubleList;
  tmpResultOutput: TStringList;
begin
  tmpBDZX := TALDoubleList.Create;
  try
    tmpBDZX.Duplicates := lstDupAccept; 
    if 0 <> ADataSrcCode then
    begin
      tmpStockItem := TBaseStockApp(App).StockItemDB.FindItem(IntToStr(AStockPackCode));
      ComputeBDZX(ADataSrcCode, tmpStockItem, AWeightMode, tmpBDZX);
    end else
    begin
      for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
      begin
        Application.ProcessMessages;
        tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];
        ComputeBDZX(ADataSrcCode, tmpStockItem, AWeightMode, tmpBDZX);
      end;
    end;
    tmpBDZX.Sort;
    
    tmpResultOutput := TStringList.Create;
    try
      for i := 0 to tmpBDZX.Count - 1 do
      begin
        tmpStockItem := PRT_DealItem(tmpBDZX.Objects[i]);
        tmpResultOutput.Add(FloatToStr(tmpBDZX[i]) + ' -- ' + tmpStockItem.sCode);
      end;
      tmpResultOutput.SaveToFile('bdzx' + FormatDateTime('yyyymmdd', now) + '.txt');
    finally
      tmpResultOutput.Free;
    end;
  finally
    tmpBDZX.Free;
  end;
end;

end.
