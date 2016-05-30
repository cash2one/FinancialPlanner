unit StockDetailDataAccess;

interface

uses
  define_DealItem,
  BaseDataSet,
  QuickList_int,
  define_stock_quotes;
  
type
  TStockDetailDataAccess = class(TBaseDataSetAccess)
  protected
    fStockItem: PRT_DealItem;  
    fDetailDealData: TALIntegerList;
    fDataSourceId: integer;
    fFirstDealDate: Word;
    fLastDealDate: Word;    
    function GetFirstDealDate: Word;
    procedure SetFirstDealDate(const Value: Word);

    function GetLastDealDate: Word;
    procedure SetLastDealDate(const Value: Word);

    procedure SetStockItem(AStockItem: PRT_DealItem);
    
    function GetRecordItem(AIndex: integer): Pointer; override;
    function GetRecordCount: Integer; override;
  public
    constructor Create(AStockItem: PRT_DealItem; ADataSrcId: integer);
    destructor Destroy; override;
    
    function FindRecord(ADateTime: Integer): PRT_Quote_M2;
    function CheckOutRecord(ADateTime: Integer): PRT_Quote_M2;
    function NewRecord(ADateTime: Integer): PRT_Quote_M2;
    procedure Sort; override;    
    procedure Clear; override;
    property FirstDealDate: Word read GetFirstDealDate write SetFirstDealDate;
    property LastDealDate: Word read GetLastDealDate write SetLastDealDate;
    property StockItem: PRT_DealItem read fStockItem write SetStockItem;
    property DataSourceId: integer read fDataSourceId write fDataSourceId;
  end;
          
  function GetDetailTimeIndex(ADetailTime: string): Word;
  function DecodeTimeIndex(ADetailTime: Word;
      var AHour: integer;
      var AMinute: integer;
      var ASecond: integer): Boolean;

implementation

uses
  SysUtils,
  QuickSortList;
                       
function DecodeTimeIndex(ADetailTime: Word;
      var AHour: integer;
      var AMinute: integer;
      var ASecond: integer): Boolean;
begin
  Result := false;
  if 0 < ADetailTime then
  begin
    AHour := Trunc(ADetailTime div 3600);
    ASecond := ADetailTime - AHour * 3600;
    AMinute := Trunc(ASecond div 60);
    ASecond := ASecond - AMinute * 60;
    AHour := AHour + 9;
    if AHour < 16 then
    begin
      if AMinute < 61 then
      begin
        Result := true;
      end;
    end;
  end;
end;

function GetDetailTimeIndex(ADetailTime: string): Word;
var
  tmpHour: integer;
  tmpMinute: integer;
  tmpSecond: integer;
  tmpPos: integer;
begin
  Result := 0;
  tmpPos := Pos(':', ADetailTime);
  if 0 < tmpPos then
  begin
    tmpHour := StrToIntDef(Copy(ADetailTime, 1, tmpPos - 1), 0);
    if (8 < tmpHour) and (16 > tmpHour) then
    begin
      ADetailTime := Copy(ADetailTime, tmpPos + 1, maxint); 
      tmpPos := Pos(':', ADetailTime);
      if 0 < tmpPos then
      begin
        tmpMinute := StrToIntDef(Copy(ADetailTime, 1, tmpPos - 1), 0);
        if (61 > tmpMinute) and (-1 < tmpMinute) then
        begin
          tmpSecond := StrToIntDef(Copy(ADetailTime, tmpPos + 1, maxint), 0);
          Result := (tmpHour - 9) * 60 * 60 + tmpMinute * 60 + tmpSecond;
        end;
      end;
    end;
  end;
end;     
{ TStockDetailDataAccess }

constructor TStockDetailDataAccess.Create(AStockItem: PRT_DealItem; ADataSrcId: integer);
begin
  fStockItem := AStockItem;   
  fDetailDealData := TALIntegerList.Create;
  fDetailDealData.Duplicates := lstDupAccept; 
  fDataSourceId := ADataSrcId;
end;

destructor TStockDetailDataAccess.Destroy;
begin
  Clear;
  FreeAndNil(fDetailDealData);
  inherited;
end;

procedure TStockDetailDataAccess.SetStockItem(AStockItem: PRT_DealItem);
begin
  if nil <> AStockItem then
  begin
    if fStockItem <> AStockItem then
    begin
      Self.Clear;
    end;
  end;
  fStockItem := AStockItem;
  if nil <> fStockItem then
  begin

  end;
end;
                           
function TStockDetailDataAccess.GetFirstDealDate: Word;
begin
  Result := fFirstDealDate;
end;

procedure TStockDetailDataAccess.SetFirstDealDate(const Value: Word);
begin
  fFirstDealDate := Value;
end;
                    
function TStockDetailDataAccess.GetLastDealDate: Word;
begin
  Result := fLastDealDate;
end;
                    
procedure TStockDetailDataAccess.SetLastDealDate(const Value: Word);
begin
  fLastDealDate := Value;
end;

function TStockDetailDataAccess.GetRecordCount: Integer;
begin
  Result := fDetailDealData.Count;
end;

function TStockDetailDataAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := nil;
  if AIndex < fDetailDealData.Count then
  begin
    Result := fDetailDealData.Objects[AIndex];
  end else
  begin
    if AIndex > 0 then
    begin
    
    end;
  end;
end;

procedure TStockDetailDataAccess.Sort;
begin                   
  if nil <> fDetailDealData then
    fDetailDealData.Sort;
end;

procedure TStockDetailDataAccess.Clear;  
var
  i: integer;
  tmpQuote: PRT_Quote_M2;
begin
  inherited;
  if nil <> fDetailDealData then
  begin
    for i := fDetailDealData.Count - 1 downto 0 do
    begin
      tmpQuote := PRT_Quote_M2(fDetailDealData.Objects[i]);
      FreeMem(tmpQuote);
    end;
    fDetailDealData.Clear;
  end;
end;

function TStockDetailDataAccess.NewRecord(ADateTime: Integer): PRT_Quote_M2;
begin
  Result := System.New(PRT_Quote_M2);
  FillChar(Result^, SizeOf(TRT_Quote_M2), 0);
  Result.DealTime.Value := ADateTime;
  fDetailDealData.AddObject(ADateTime, TObject(Result));
end;

function TStockDetailDataAccess.CheckOutRecord(ADateTime: Integer): PRT_Quote_M2;
begin
  Result := nil;
  if ADateTime < 1 then
    exit;
  Result := FindRecord(ADateTime);
  if nil = Result then
  begin
    Result := NewRecord(ADateTime);
  end;
end;

function TStockDetailDataAccess.FindRecord(ADateTime: Integer): PRT_Quote_M2;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fDetailDealData.IndexOf(ADateTime);
  if 0 <= tmpPos then
    Result := PRT_Quote_M2(fDetailDealData.Objects[tmpPos]);
end;

end.
