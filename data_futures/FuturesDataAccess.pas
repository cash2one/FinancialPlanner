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
    fFuturesData: TFuturesData;
    function GetFirstDealDate: Word; 
    procedure SetFirstDealDate(const Value: Word);

    function GetLastDealDate: Word;             
    procedure SetLastDealDate(const Value: Word);

    function GetEndDealDate: Word;
    procedure SetEndDealDate(const Value: Word);

    procedure SetDealItem(ADealItem: PRT_DealItem);
    
    function GetRecordItem(AIndex: integer): Pointer; override;
    function GetRecordCount: Integer; override;
  public
    constructor Create(ADealItem: PRT_DealItem; ADataSrcId: integer);
    destructor Destroy; override;
    
    function FindRecord(ADate: Integer): PRT_Quote_M1_Day;
    function CheckOutRecord(ADate: Integer): PRT_Quote_M1_Day;
    procedure Sort; override;
    property FirstDealDate: Word read GetFirstDealDate;
    property LastDealDate: Word read GetLastDealDate;
    property EndDealDate: Word read GetEndDealDate write SetEndDealDate;
    property DealItem: PRT_DealItem read fFuturesData.DealItem write SetDealItem;
    property DataSourceId: integer read fFuturesData.DataSourceId write fFuturesData.DataSourceId;
  end;
  
implementation

constructor TFuturesDataAccess.Create(ADealItem: PRT_DealItem; ADataSrcId: integer);
begin
  //inherited;
  FillChar(fFuturesData, SizeOf(fFuturesData), 0);
  fFuturesData.DealItem := ADealItem;
  fFuturesData.DayDealData := TALIntegerList.Create; 
  fFuturesData.FirstDealDate     := 0;   // 2
  fFuturesData.LastDealDate      := 0;   // 2 最后记录交易时间
  fFuturesData.DataSourceId := ADataSrcId;
end;

destructor TFuturesDataAccess.Destroy;
var
  i: integer;
  tmpQuoteDay: PRT_Quote_M1_Day;
begin
  for i := fFuturesData.DayDealData.Count - 1 downto 0 do
  begin
    tmpQuoteDay := PRT_Quote_M1_Day(fFuturesData.DayDealData.Objects[i]);
    FreeMem(tmpQuoteDay);
  end;
  fFuturesData.DayDealData.Clear;
  fFuturesData.DayDealData.Free;
  inherited;
end;

procedure TFuturesDataAccess.SetDealItem(ADealItem: PRT_DealItem);
begin
  if nil <> ADealItem then
  begin
    if fFuturesData.DealItem <> ADealItem then
    begin
    
    end;
  end;
  fFuturesData.DealItem := ADealItem;
  if nil <> fFuturesData.DealItem then
  begin

  end;
end;

function TFuturesDataAccess.GetFirstDealDate: Word;
begin         
  Result := fFuturesData.FirstDealDate;
end;
                  
procedure TFuturesDataAccess.SetFirstDealDate(const Value: Word);
begin
  fFuturesData.FirstDealDate := Value;
end;

function TFuturesDataAccess.GetLastDealDate: Word;
begin
  Result := fFuturesData.LastDealDate;
end;
              
procedure TFuturesDataAccess.SetLastDealDate(const Value: Word);
begin
  fFuturesData.LastDealDate := Value;
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
  Result := fFuturesData.DayDealData.Count;
end;

function TFuturesDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fFuturesData.DayDealData.Objects[AIndex];
end;

procedure TFuturesDataAccess.Sort;
begin
  fFuturesData.DayDealData.Sort;
end;

function TFuturesDataAccess.CheckOutRecord(ADate: Integer): PRT_Quote_M1_Day;
begin             
  Result := nil;
  if ADate < 1 then
    exit;
  Result := FindRecord(ADate);
  if nil = Result then
  begin
    if fFuturesData.FirstDealDate = 0 then
      fFuturesData.FirstDealDate := ADate;
    if fFuturesData.FirstDealDate > ADate then
      fFuturesData.FirstDealDate := ADate;
    if fFuturesData.LastDealDate < ADate then
      fFuturesData.LastDealDate := ADate;
    Result := System.New(PRT_Quote_M1_Day);
    FillChar(Result^, SizeOf(TRT_Quote_M1_Day), 0);
    Result.DealDateTime.Value := ADate;
    fFuturesData.DayDealData.AddObject(ADate, TObject(Result));
  end;
end;

function TFuturesDataAccess.FindRecord(ADate: Integer): PRT_Quote_M1_Day;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fFuturesData.DayDealData.IndexOf(ADate);
  if 0 <= tmpPos then
    Result := PRT_Quote_M1_Day(fFuturesData.DayDealData.Objects[tmpPos]);
end;

end.
