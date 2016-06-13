unit StockDayDataAccess;

interface

uses
  define_dealItem,
  BaseDataSet,
  QuickList_int,
  define_stock_quotes;
  
type
  { 行情日线数据访问 }
  TStockDayData = record
    DealItem          : PRT_DealItem;
    IsDataChangedStatus: Byte;
    IsWeight          : Byte;
    DayDealData       : TALIntegerList;
    FirstDealDate     : Word;   // 2
    LastDealDate      : Word;   // 2 最后记录交易时间
    DataSourceId      : integer;
  end;
  
  TStockDayDataAccess = class(TBaseDataSetAccess)
  protected
    fStockDayData: TStockDayData;
    function GetFirstDealDate: Word; 
    procedure SetFirstDealDate(const Value: Word);

    function GetLastDealDate: Word;             
    procedure SetLastDealDate(const Value: Word);

    function GetEndDealDate: Word;
    procedure SetEndDealDate(const Value: Word);

    procedure SetStockItem(AStockItem: PRT_DealItem);

    function GetIsWeight: Boolean;
    
    function GetRecordItem(AIndex: integer): Pointer; override;
    function GetRecordCount: Integer; override;
  public
    constructor Create(AStockItem: PRT_DealItem; ADataSrcId: integer; AIsWeight: Boolean);
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
    property StockItem: PRT_DealItem read fStockDayData.DealItem write SetStockItem;
    property DataSourceId: integer read fStockDayData.DataSourceId write fStockDayData.DataSourceId;
    property IsWeight: Boolean read GetIsWeight;
  end;
                            
  procedure AddDealDayData(ADataAccess: TStockDayDataAccess; ATempDealDayData: PRT_Quote_M1_Day);
  
implementation

uses
  QuickSortList,
  SysUtils;
  
{ TStockDayDataAccess }

procedure AddDealDayData(ADataAccess: TStockDayDataAccess; ATempDealDayData: PRT_Quote_M1_Day);
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
        
constructor TStockDayDataAccess.Create(AStockItem: PRT_DealItem; ADataSrcId: integer; AIsWeight: Boolean);
begin
  //inherited;
  FillChar(fStockDayData, SizeOf(fStockDayData), 0);
  fStockDayData.DealItem := AStockItem;
  fStockDayData.DayDealData := TALIntegerList.Create;
  fStockDayData.DayDealData.Clear;
  fStockDayData.DayDealData.Duplicates := QuickSortList.lstDupIgnore;
   
  fStockDayData.FirstDealDate     := 0;   // 2
  fStockDayData.LastDealDate      := 0;   // 2 最后记录交易时间
  fStockDayData.DataSourceId := ADataSrcId;
  fStockDayData.IsWeight := Byte(AIsWeight);
end;

destructor TStockDayDataAccess.Destroy;
begin
  Clear;
  FreeAndNil(fStockDayData.DayDealData);
  inherited;
end;
                
procedure TStockDayDataAccess.Clear;   
var
  i: integer;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  if nil <> fStockDayData.DayDealData then
  begin
    for i := fStockDayData.DayDealData.Count - 1 downto 0 do
    begin
      tmpQuoteDay := PRT_Quote_M1_Day(fStockDayData.DayDealData.Objects[i]);
      FreeMem(tmpQuoteDay);
    end;
    fStockDayData.DayDealData.Clear;
  end;
end;

procedure TStockDayDataAccess.SetStockItem(AStockItem: PRT_DealItem);
begin
  if nil <> AStockItem then
  begin
    if fStockDayData.DealItem <> AStockItem then
    begin
    
    end;
  end;
  fStockDayData.DealItem := AStockItem;
  if nil <> fStockDayData.DealItem then
  begin

  end;
end;

function TStockDayDataAccess.GetFirstDealDate: Word;
begin         
  Result := fStockDayData.FirstDealDate;
end;
                  
function TStockDayDataAccess.GetIsWeight: Boolean;
begin
  Result := fStockDayData.IsWeight <> 0;
end;

procedure TStockDayDataAccess.SetFirstDealDate(const Value: Word);
begin
  fStockDayData.FirstDealDate := Value;
end;

function TStockDayDataAccess.GetLastDealDate: Word;
begin
  Result := fStockDayData.LastDealDate;
end;
              
procedure TStockDayDataAccess.SetLastDealDate(const Value: Word);
begin
  fStockDayData.LastDealDate := Value;
end;

function TStockDayDataAccess.GetEndDealDate: Word;
begin
  Result := 0;
end;
                       
procedure TStockDayDataAccess.SetEndDealDate(const Value: Word);
begin
end;

function TStockDayDataAccess.GetRecordCount: Integer;
begin
  Result := fStockDayData.DayDealData.Count;
end;

function TStockDayDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fStockDayData.DayDealData.Objects[AIndex];
end;

procedure TStockDayDataAccess.Sort;
begin
  fStockDayData.DayDealData.Sort;
end;

function TStockDayDataAccess.CheckOutRecord(ADate: Word): PRT_Quote_M1_Day;
begin             
  Result := nil;
  if ADate < 1 then
    exit;
  Result := FindRecord(ADate);
  if nil = Result then
  begin
    if fStockDayData.FirstDealDate = 0 then
      fStockDayData.FirstDealDate := ADate;
    if fStockDayData.FirstDealDate > ADate then
      fStockDayData.FirstDealDate := ADate;
    if fStockDayData.LastDealDate < ADate then
      fStockDayData.LastDealDate := ADate;
    Result := System.New(PRT_Quote_M1_Day);
    FillChar(Result^, SizeOf(TRT_Quote_M1_Day), 0);
    Result.DealDate.Value := ADate;
    fStockDayData.DayDealData.AddObject(ADate, TObject(Result));
  end;
end;

function TStockDayDataAccess.FindRecord(ADate: Integer): PRT_Quote_M1_Day;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fStockDayData.DayDealData.IndexOf(ADate);
  if 0 <= tmpPos then
    Result := PRT_Quote_M1_Day(fStockDayData.DayDealData.Objects[tmpPos]);
end;

function TStockDayDataAccess.DoGetStockOpenPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceOpen.Value;
end;
                          
function TStockDayDataAccess.DoGetStockClosePrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceClose.Value;
end;

function TStockDayDataAccess.DoGetStockHighPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceHigh.Value;
end;

function TStockDayDataAccess.DoGetStockLowPrice(AIndex: integer): double;
begin
  Result := PRT_Quote_M1_Day(RecordItem[AIndex]).PriceRange.PriceLow.Value;
end;


function TStockDayDataAccess.DoGetRecords: integer;
begin          
  Result := Self.RecordCount;
end;

end.
