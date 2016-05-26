unit cyhtAnalysisForm;

interface

uses
  Forms, BaseForm, Classes, Controls, SysUtils, StdCtrls,
  StockDayDataAccess,
  Rule_CYHT;

type
  TfrmCyhtAnalysisData = record
    Rule_Cyht_Price: TRule_Cyht_Price;
    StockDayDataAccess: TStockDayDataAccess;
  end;
  
  TfrmCyhtAnalysis = class(TfrmBase)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  protected
    fCyhtAnalysisData: TfrmCyhtAnalysisData;
  public        
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  define_dealitem,
  define_datasrc,
  QuickSortList,
  QuickList_double,
  StockDayData_Load,
  BaseStockApp;
            
constructor TfrmCyhtAnalysis.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fCyhtAnalysisData, SizeOf(fCyhtAnalysisData), 0);
end;

procedure TfrmCyhtAnalysis.btn1Click(Sender: TObject);
var
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpSK: double;
  tmpCyht: TALDoubleList;
  tmpResultOutput: TStringList;
begin
  tmpCyht := TALDoubleList.Create;
  try
    tmpCyht.Duplicates := lstDupAccept;

    for i := 0 to TBaseStockApp(App).StockItemDB.RecordCount - 1 do
    begin
      tmpStockItem := TBaseStockApp(App).StockItemDB.RecordItem[i];   
      if 0 = tmpStockItem.EndDealDate then
      begin
        if nil <> fCyhtAnalysisData.StockDayDataAccess then
        begin
          fCyhtAnalysisData.StockDayDataAccess.Free;
        end;
        fCyhtAnalysisData.StockDayDataAccess := TStockDayDataAccess.Create(tmpStockItem, DataSrc_163, false);
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
              tmpCyht.AddObject(tmpSK, TObject(tmpStockItem));
            finally
              FreeAndNil(fCyhtAnalysisData.Rule_Cyht_Price);
            end;
          end;
        finally
          FreeAndNil(fCyhtAnalysisData.StockDayDataAccess);
        end;
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
      tmpResultOutput.SaveToFile('Cyht' + FormatDateTime('yyyymmdd', now) + '.txt');
    finally
      tmpResultOutput.Free;
    end;
  finally
    tmpCyht.Free;
  end;
end;

end.
