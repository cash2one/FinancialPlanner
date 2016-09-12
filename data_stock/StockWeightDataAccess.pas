unit StockWeightDataAccess;

interface

uses
  define_dealItem,
  BaseDataSet,
  QuickList_int,
  define_price,
  define_datasrc,
  define_stock_quotes;
  
type
  TStockWeightData = record
    DealItem          : PRT_DealItem;
    IsDataChangedStatus: Byte;
    WeightData        : TALIntegerList;
    FirstDealDate     : Word;   // 2
    LastDealDate      : Word;   // 2 最后记录交易时间
    DataSource        : TDealDataSource;
  end;
  
  TStockWeightDataAccess = class(TBaseDataSetAccess)
  protected
    fStockWeightData: TStockWeightData;
    function GetFirstDealDate: Word; 
    procedure SetFirstDealDate(const Value: Word);

    function GetLastDealDate: Word;             
    procedure SetLastDealDate(const Value: Word);

    function GetEndDealDate: Word;
    procedure SetEndDealDate(const Value: Word);

    procedure SetStockItem(AStockItem: PRT_DealItem);

    function GetRecordItem(AIndex: integer): Pointer; override;
    function GetRecordCount: Integer; override;
  public
    constructor Create(AStockItem: PRT_DealItem; ADataSrc: TDealDataSource);
    destructor Destroy; override;
    
    function FindRecord(ADate: Integer): PRT_Stock_Weight;
    function CheckOutRecord(ADate: Word): PRT_Stock_Weight;

    
    function DoGetRecords: integer; 
    function DoGetStockOpenPrice(AIndex: integer): double;
    function DoGetStockClosePrice(AIndex: integer): double;
    function DoGetStockHighPrice(AIndex: integer): double;
    function DoGetStockLowPrice(AIndex: integer): double;

    procedure Sort; override;
    procedure Clear; override;
    property FirstDealDate: Word read GetFirstDealDate;
    property LastDealDate: Word read GetLastDealDate;
    property EndDealDate: Word read GetEndDealDate write SetEndDealDate;
    property StockItem: PRT_DealItem read fStockWeightData.DealItem write SetStockItem;
    property DataSource: TDealDataSource read fStockWeightData.DataSource write fStockWeightData.DataSource;
  end;
                      
implementation

uses
  QuickSortList,
  SysUtils;
  
{ TStockWeightDataAccess }

constructor TStockWeightDataAccess.Create(AStockItem: PRT_DealItem; ADataSrc: TDealDataSource);
begin
  //inherited;
  FillChar(fStockWeightData, SizeOf(fStockWeightData), 0);
  fStockWeightData.DealItem := AStockItem;
  fStockWeightData.WeightData := TALIntegerList.Create;
  fStockWeightData.WeightData.Clear;
  fStockWeightData.WeightData.Duplicates := QuickSortList.lstDupIgnore;
   
  fStockWeightData.FirstDealDate     := 0;   // 2
  fStockWeightData.LastDealDate      := 0;   // 2 最后记录交易时间
  fStockWeightData.DataSource := ADataSrc;
end;

destructor TStockWeightDataAccess.Destroy;
begin
  Clear;
  FreeAndNil(fStockWeightData.DayDealData);
  inherited;
end;
                
procedure TStockWeightDataAccess.Clear;   
var
  i: integer;
  tmpQuoteDay: PRT_Quote_Day;
begin
  if nil <> fStockWeightData.WeightData then
  begin
    for i := fStockWeightData.WeightData.Count - 1 downto 0 do
    begin
      tmpQuoteDay := PRT_Quote_Day(fStockWeightData.WeightData.Objects[i]);
      FreeMem(tmpQuoteDay);
    end;
    fStockWeightData.WeightData.Clear;
  end;
end;

procedure TStockWeightDataAccess.SetStockItem(AStockItem: PRT_DealItem);
begin
  if nil <> AStockItem then
  begin
    if fStockWeightData.DealItem <> AStockItem then
    begin
    
    end;
  end;
  fStockWeightData.DealItem := AStockItem;
  if nil <> fStockWeightData.DealItem then
  begin

  end;
end;

function TStockWeightDataAccess.GetFirstDealDate: Word;
begin         
  Result := fStockWeightData.FirstDealDate;
end;
                  
procedure TStockWeightDataAccess.SetFirstDealDate(const Value: Word);
begin
  fStockWeightData.FirstDealDate := Value;
end;

function TStockWeightDataAccess.GetLastDealDate: Word;
begin
  Result := fStockWeightData.LastDealDate;
end;
              
procedure TStockWeightDataAccess.SetLastDealDate(const Value: Word);
begin
  fStockWeightData.LastDealDate := Value;
end;

function TStockWeightDataAccess.GetEndDealDate: Word;
begin
  Result := 0;
end;
                       
procedure TStockWeightDataAccess.SetEndDealDate(const Value: Word);
begin
end;

function TStockWeightDataAccess.GetRecordCount: Integer;
begin
  Result := fStockWeightData.WeightData.Count;
end;

function TStockWeightDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fStockWeightData.WeightData.Objects[AIndex];
end;

procedure TStockWeightDataAccess.Sort;
begin
  fStockWeightData.WeightData.Sort;
end;

function TStockWeightDataAccess.CheckOutRecord(ADate: Word): PRT_Stock_Weight;
begin             
  Result := nil;
  if ADate < 1 then
    exit;
  Result := FindRecord(ADate);
  if nil = Result then
  begin
    if fStockWeightData.FirstDealDate = 0 then
      fStockWeightData.FirstDealDate := ADate;
    if fStockWeightData.FirstDealDate > ADate then
      fStockWeightData.FirstDealDate := ADate;
    if fStockWeightData.LastDealDate < ADate then
      fStockWeightData.LastDealDate := ADate;
    Result := System.New(PRT_Quote_Day);
    FillChar(Result^, SizeOf(TRT_Quote_Day), 0);
    Result.DealDate.Value := ADate;
    fStockWeightData.DayDealData.AddObject(ADate, TObject(Result));
  end;
end;

function TStockWeightDataAccess.FindRecord(ADate: Integer): PRT_Quote_Day;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fStockWeightData.DayDealData.IndexOf(ADate);
  if 0 <= tmpPos then
    Result := PRT_Quote_Day(fStockWeightData.DayDealData.Objects[tmpPos]);
end;

function TStockWeightDataAccess.DoGetStockOpenPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_Day(RecordItem[AIndex]).PriceRange.PriceOpen.Value;
end;
                          
function TStockWeightDataAccess.DoGetStockClosePrice(AIndex: integer): double;
begin
  Result := PRT_Quote_Day(RecordItem[AIndex]).PriceRange.PriceClose.Value;
end;

function TStockWeightDataAccess.DoGetStockHighPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_Day(RecordItem[AIndex]).PriceRange.PriceHigh.Value;
end;

function TStockWeightDataAccess.DoGetStockLowPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_Day(RecordItem[AIndex]).PriceRange.PriceLow.Value;
end;


function TStockWeightDataAccess.DoGetRecords: integer;
begin          
  Result := Self.RecordCount;
end;

end.
