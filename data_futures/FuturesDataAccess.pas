unit FuturesDataAccess;

interface

uses
  define_dealItem,
  BaseDataSet,
  QuickList_int,
  define_futures_quotes;
  
type
  { 行情日线数据访问 }
  TFuturesData = record
    DealItem: PRT_DealItem;
    IsDataChangedStatus: Byte;
    DayDealData: TALIntegerList;
    FirstDealDate     : Word;   // 2
    LastDealDate      : Word;   // 2 最后记录交易时间
    DataSourceId: integer;
  end;
  
  TFuturesDataAccess = class(TBaseDataSetAccess)
  protected
    fStockDayData: TFuturesData;
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
    constructor Create(AStockItem: PRT_DealItem; ADataSrcId: integer);
    destructor Destroy; override;
    
    function FindRecord(ADate: Integer): PRT_Quote_M1_Day;
    function CheckOutRecord(ADate: Integer): PRT_Quote_M1_Day;
    procedure Sort; override;
    property FirstDealDate: Word read GetFirstDealDate;
    property LastDealDate: Word read GetLastDealDate;
    property EndDealDate: Word read GetEndDealDate write SetEndDealDate;
    property StockItem: PRT_DealItem read fStockDayData.DealItem write SetStockItem;
    property DataSourceId: integer read fStockDayData.DataSourceId write fStockDayData.DataSourceId;
  end;
  
implementation

{ TStockDayDataAccess }

constructor TFuturesDataAccess.Create(AStockItem: PRT_DealItem; ADataSrcId: integer);
begin
  //inherited;
  FillChar(fStockDayData, SizeOf(fStockDayData), 0);
  fStockDayData.DealItem := AStockItem;
  fStockDayData.DayDealData := TALIntegerList.Create; 
  fStockDayData.FirstDealDate     := 0;   // 2
  fStockDayData.LastDealDate      := 0;   // 2 最后记录交易时间
  fStockDayData.DataSourceId := ADataSrcId;
end;

destructor TFuturesDataAccess.Destroy;
var
  i: integer;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  for i := fStockDayData.DayDealData.Count - 1 downto 0 do
  begin
    tmpQuoteDay := PRT_Quote_M1_Day(fStockDayData.DayDealData.Objects[i]);
    FreeMem(tmpQuoteDay);
  end;
  fStockDayData.DayDealData.Clear;
  fStockDayData.DayDealData.Free;
  inherited;
end;

procedure TFuturesDataAccess.SetStockItem(AStockItem: PRT_DealItem);
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

function TFuturesDataAccess.GetFirstDealDate: Word;
begin         
  Result := fStockDayData.FirstDealDate;
end;
                  
procedure TFuturesDataAccess.SetFirstDealDate(const Value: Word);
begin
  fStockDayData.FirstDealDate := Value;
end;

function TFuturesDataAccess.GetLastDealDate: Word;
begin
  Result := fStockDayData.LastDealDate;
end;
              
procedure TFuturesDataAccess.SetLastDealDate(const Value: Word);
begin
  fStockDayData.LastDealDate := Value;
end;

function TFuturesDataAccess.GetEndDealDate: Word;
begin
  Result := 0;
end;
                       
procedure TFuturesDataAccess.SetEndDealDate(const Value: Word);
begin
end;

function TFuturesDataAccess.GetRecordCount: Integer;
begin
  Result := fStockDayData.DayDealData.Count;
end;

function TFuturesDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fStockDayData.DayDealData.Objects[AIndex];
end;

procedure TFuturesDataAccess.Sort;
begin
  fStockDayData.DayDealData.Sort;
end;

function TFuturesDataAccess.CheckOutRecord(ADate: Integer): PRT_Quote_M1_Day;
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
    Result.DealDateTime.Value := ADate;
    fStockDayData.DayDealData.AddObject(ADate, TObject(Result));
  end;
end;

function TFuturesDataAccess.FindRecord(ADate: Integer): PRT_Quote_M1_Day;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fStockDayData.DayDealData.IndexOf(ADate);
  if 0 <= tmpPos then
    Result := PRT_Quote_M1_Day(fStockDayData.DayDealData.Objects[tmpPos]);
end;

end.
