unit StockDayDataAccess;

interface

uses
  define_dealItem,
  BaseDataSet,
  QuickList_int,
  define_stock_quotes;
  
type
  TStockDayDataAccess = class(TBaseDataSetAccess)
  protected
    fStockItem: PRT_DealItem;  
    fDayDealData: TALIntegerList;
    fFirstDealDate     : Word;   // 2
    fLastDealDate      : Word;   // 2 最后记录交易时间
    fDataSourceId: integer;
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
    property StockItem: PRT_DealItem read fStockItem write SetStockItem;
    property DataSourceId: integer read fDataSourceId write fDataSourceId;
  end;
  
implementation

{ TStockDayDataAccess }

constructor TStockDayDataAccess.Create(AStockItem: PRT_DealItem; ADataSrcId: integer);
begin
  fStockItem := AStockItem;   
  fDayDealData := TALIntegerList.Create; 
  fFirstDealDate     := 0;   // 2
  fLastDealDate      := 0;   // 2 最后记录交易时间
  fDataSourceId := ADataSrcId;
end;

destructor TStockDayDataAccess.Destroy;
var
  i: integer;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  for i := fDayDealData.Count - 1 downto 0 do
  begin
    tmpQuoteDay := PRT_Quote_M1_Day(fDayDealData.Objects[i]);
    FreeMem(tmpQuoteDay);
  end;
  fDayDealData.Clear;
  fDayDealData.Free;
  inherited;
end;

procedure TStockDayDataAccess.SetStockItem(AStockItem: PRT_DealItem);
begin
  if nil <> AStockItem then
  begin
    if fStockItem <> AStockItem then
    begin
    
    end;
  end;
  fStockItem := AStockItem;
  if nil <> fStockItem then
  begin

  end;
end;

function TStockDayDataAccess.GetFirstDealDate: Word;
begin         
  Result := fFirstDealDate;
end;
                  
procedure TStockDayDataAccess.SetFirstDealDate(const Value: Word);
begin
  fFirstDealDate := Value;
end;

function TStockDayDataAccess.GetLastDealDate: Word;
begin
  Result := fLastDealDate;
end;
              
procedure TStockDayDataAccess.SetLastDealDate(const Value: Word);
begin
  fLastDealDate := Value;
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
  Result := fDayDealData.Count;
end;

function TStockDayDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fDayDealData.Objects[AIndex];
end;

procedure TStockDayDataAccess.Sort;
begin
  fDayDealData.Sort;
end;

function TStockDayDataAccess.CheckOutRecord(ADate: Integer): PRT_Quote_M1_Day;
begin             
  Result := nil;
  if ADate < 1 then
    exit;
  Result := FindRecord(ADate);
  if nil = Result then
  begin
    if fFirstDealDate = 0 then
      fFirstDealDate := ADate;
    if fFirstDealDate > ADate then
      fFirstDealDate := ADate;
    if fLastDealDate < ADate then
      fLastDealDate := ADate;
    Result := System.New(PRT_Quote_M1_Day);
    FillChar(Result^, SizeOf(TRT_Quote_M1_Day), 0);
    Result.DealDateTime.Value := ADate;
    fDayDealData.AddObject(ADate, TObject(Result));
  end;
end;

function TStockDayDataAccess.FindRecord(ADate: Integer): PRT_Quote_M1_Day;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fDayDealData.IndexOf(ADate);
  if 0 <= tmpPos then
    Result := PRT_Quote_M1_Day(fDayDealData.Objects[tmpPos]);
end;

end.
