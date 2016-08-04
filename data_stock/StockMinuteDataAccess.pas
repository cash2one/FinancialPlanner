unit StockMinuteDataAccess;

interface

uses
  define_dealItem,
  BaseDataSet,
  QuickList_int,
  define_price,
  define_stock_quotes;
  
type
  { 行情分钟线数据访问 }
  TRT_StockMinuteData = record
    DealItem          : PRT_DealItem;
    IsDataChangedStatus: Byte;
    WeightMode        : Byte;
    MinuteDealData    : TALIntegerList;
    FirstDealDate     : Word;   // 2
    LastDealDate      : Word;   // 2 最后记录交易时间
    DataSourceId      : integer;
  end;
  
  TStockMinuteDataAccess = class(TBaseDataSetAccess)
  protected
    fStockMinuteData: TRT_StockMinuteData;
    function GetFirstDealDate: Word; 
    procedure SetFirstDealDate(const Value: Word);

    function GetLastDealDate: Word;             
    procedure SetLastDealDate(const Value: Word);

    function GetEndDealDate: Word;
    procedure SetEndDealDate(const Value: Word);

    procedure SetStockItem(AStockItem: PRT_DealItem);

    function GetWeightMode: TWeightMode;
    procedure SetWeightMode(value: TWeightMode);
        
    function GetRecordItem(AIndex: integer): Pointer; override;
    function GetRecordCount: Integer; override;
  public
    constructor Create(AStockItem: PRT_DealItem; ADataSrcId: integer; AWeightMode: TWeightMode);
    destructor Destroy; override;
    
    function FindRecord(ADate: Integer): PRT_Quote_M1_Day;
    function CheckOutRecord(ADate: Word): PRT_Quote_M1_Day;

    
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
    property StockItem: PRT_DealItem read fStockMinuteData.DealItem write SetStockItem;
    property DataSourceId: integer read fStockMinuteData.DataSourceId write fStockMinuteData.DataSourceId;
    property WeightMode: TWeightMode read GetWeightMode write SetWeightMode;
  end;
                            
  procedure AddDealDayData(ADataAccess: TStockMinuteDataAccess; ATempDealDayData: PRT_Quote_M1_Day);
  
implementation

uses
  QuickSortList,
  SysUtils;
  
{ TStockMinuteDataAccess }

procedure AddDealDayData(ADataAccess: TStockMinuteDataAccess; ATempDealDayData: PRT_Quote_M1_Day);
var
  tmpAddDealDayData: PRT_Quote_M1_Day;
//  tmpDate: string;
begin
  if (nil = ATempDealDayData) then
    exit;
  if (ATempDealDayData.DealDate.Value > 0) and
                 (ATempDealDayData.PriceRange.PriceOpen.Value > 0) and
                 (ATempDealDayData.PriceRange.PriceClose.Value > 0) and
                 (ATempDealDayData.DealVolume > 0) and
                 (ATempDealDayData.DealAmount > 0) then
  begin
//    tmpDate := FormatDateTime('', ATempDealDayData.DealDateTime.Value);
//    if '' <> tmpDate then
//    begin
//    end;
    tmpAddDealDayData := ADataAccess.CheckOutRecord(ATempDealDayData.DealDate.Value);
    tmpAddDealDayData.PriceRange.PriceHigh := ATempDealDayData.PriceRange.PriceHigh;
    tmpAddDealDayData.PriceRange.PriceLow := ATempDealDayData.PriceRange.PriceLow;
    tmpAddDealDayData.PriceRange.PriceOpen := ATempDealDayData.PriceRange.PriceOpen;
    tmpAddDealDayData.PriceRange.PriceClose := ATempDealDayData.PriceRange.PriceClose;
    tmpAddDealDayData.DealVolume := ATempDealDayData.DealVolume;
    tmpAddDealDayData.DealAmount := ATempDealDayData.DealAmount;
    tmpAddDealDayData.Weight := ATempDealDayData.Weight;
  end;
end;
        
constructor TStockMinuteDataAccess.Create(AStockItem: PRT_DealItem; ADataSrcId: integer; AWeightMode: TWeightMode);
begin
  //inherited;
  FillChar(fStockMinuteData, SizeOf(fStockMinuteData), 0);
  fStockMinuteData.DealItem := AStockItem;
  fStockMinuteData.MinuteDealData := TALIntegerList.Create;
  fStockMinuteData.MinuteDealData.Clear;
  fStockMinuteData.MinuteDealData.Duplicates := QuickSortList.lstDupIgnore;
   
  fStockMinuteData.FirstDealDate     := 0;   // 2
  fStockMinuteData.LastDealDate      := 0;   // 2 最后记录交易时间
  fStockMinuteData.DataSourceId := ADataSrcId;
  fStockMinuteData.WeightMode := Byte(AWeightMode);
end;

destructor TStockMinuteDataAccess.Destroy;
begin
  Clear;
  FreeAndNil(fStockMinuteData.MinuteDealData);
  inherited;
end;
                
procedure TStockMinuteDataAccess.Clear;   
var
  i: integer;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  if nil <> fStockMinuteData.MinuteDealData then
  begin
    for i := fStockMinuteData.MinuteDealData.Count - 1 downto 0 do
    begin
      tmpQuoteDay := PRT_Quote_M1_Day(fStockMinuteData.MinuteDealData.Objects[i]);
      FreeMem(tmpQuoteDay);
    end;
    fStockMinuteData.MinuteDealData.Clear;
  end;
end;

procedure TStockMinuteDataAccess.SetStockItem(AStockItem: PRT_DealItem);
begin
  if nil <> AStockItem then
  begin
    if fStockMinuteData.DealItem <> AStockItem then
    begin
    
    end;
  end;
  fStockMinuteData.DealItem := AStockItem;
  if nil <> fStockMinuteData.DealItem then
  begin

  end;
end;

function TStockMinuteDataAccess.GetFirstDealDate: Word;
begin         
  Result := fStockMinuteData.FirstDealDate;
end;
                  
function TStockMinuteDataAccess.GetWeightMode: TWeightMode;
begin
  Result := TWeightMode(fStockMinuteData.WeightMode);
end;

procedure TStockMinuteDataAccess.SetWeightMode(value: TWeightMode);
begin
  fStockMinuteData.WeightMode := Byte(value);
end;

procedure TStockMinuteDataAccess.SetFirstDealDate(const Value: Word);
begin
  fStockMinuteData.FirstDealDate := Value;
end;

function TStockMinuteDataAccess.GetLastDealDate: Word;
begin
  Result := fStockMinuteData.LastDealDate;
end;
              
procedure TStockMinuteDataAccess.SetLastDealDate(const Value: Word);
begin
  fStockMinuteData.LastDealDate := Value;
end;

function TStockMinuteDataAccess.GetEndDealDate: Word;
begin
  Result := 0;
end;
                       
procedure TStockMinuteDataAccess.SetEndDealDate(const Value: Word);
begin
end;

function TStockMinuteDataAccess.GetRecordCount: Integer;
begin
  Result := fStockMinuteData.MinuteDealData.Count;
end;

function TStockMinuteDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fStockMinuteData.MinuteDealData.Objects[AIndex];
end;

procedure TStockMinuteDataAccess.Sort;
begin
  fStockMinuteData.MinuteDealData.Sort;
end;

function TStockMinuteDataAccess.CheckOutRecord(ADate: Word): PRT_Quote_M1_Day;
begin             
  Result := nil;
  if ADate < 1 then
    exit;
  Result := FindRecord(ADate);
  if nil = Result then
  begin
    if fStockMinuteData.FirstDealDate = 0 then
      fStockMinuteData.FirstDealDate := ADate;
    if fStockMinuteData.FirstDealDate > ADate then
      fStockMinuteData.FirstDealDate := ADate;
    if fStockMinuteData.LastDealDate < ADate then
      fStockMinuteData.LastDealDate := ADate;
    Result := System.New(PRT_Quote_M1_Day);
    FillChar(Result^, SizeOf(TRT_Quote_M1_Day), 0);
    Result.DealDate.Value := ADate;
    fStockMinuteData.MinuteDealData.AddObject(ADate, TObject(Result));
  end;
end;

function TStockMinuteDataAccess.FindRecord(ADate: Integer): PRT_Quote_M1_Day;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fStockMinuteData.MinuteDealData.IndexOf(ADate);
  if 0 <= tmpPos then
    Result := PRT_Quote_M1_Day(fStockMinuteData.MinuteDealData.Objects[tmpPos]);
end;

function TStockMinuteDataAccess.DoGetStockOpenPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceOpen.Value;
end;
                          
function TStockMinuteDataAccess.DoGetStockClosePrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceClose.Value;
end;

function TStockMinuteDataAccess.DoGetStockHighPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceHigh.Value;
end;

function TStockMinuteDataAccess.DoGetStockLowPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceLow.Value;
end;


function TStockMinuteDataAccess.DoGetRecords: integer;
begin          
  Result := Self.RecordCount;
end;

end.
