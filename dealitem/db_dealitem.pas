unit db_dealitem;

interface

uses
  define_dealitem, BaseDataSet, QuickList_int, Define_DealMarket, define_dealstore_header;
  
type
  TDBStockItem = class(TBaseDataSetAccess)
  protected
    fStockList: TALIntegerList;
    function GetRecordCount: Integer; override;  
    function GetRecordItem(AIndex: integer): Pointer; override;
    function GetItem(AIndex: integer): PRT_DealItem; overload;
    function GetItem(ACode: string): PRT_DealItem; overload;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Sort; override;     
    function AddItem(AMarketCode, AStockCode: AnsiString): PRT_DealItem;  
    function FindItem(AStockCode: AnsiString): PRT_DealItem;
    function CheckOutItem(AMarketCode, AStockCode: AnsiString): PRT_DealItem;
    property Items[AIndex: integer]: PRT_DealItem read GetItem;       
    property Item[ACode: string]: PRT_DealItem read GetItem;
  end;
             
  PStore_Header     = ^TStore_Header;
  TStore_Header     = packed record // 128  
    Signature           : TStore_Signature; // 6
    HeadSize            : Byte;             // 1 -- 7
    StoreSizeMode       : TStore_SizeMode;  // 1 -- 8 page size mode
    { 表明是什么数据 }
    DataType            : Word;             // 2 -- 10   
    DataMode            : Byte;             // 1 -- 11
    RecordSizeMode      : TStore_SizeMode;  // 1 -- 12
    RecordCount         : integer;          // 4 -- 16
    CompressFlag        : Byte;             // 1 -- 17
    EncryptFlag         : Byte;             // 1 -- 18    
    DataSourceId        : Word;             // 2 -- 20
    Code                : array[0..11] of AnsiChar; // 12 - 32
  end;

  PStore_HeaderRec  = ^TStore_HeaderRec;
  TStore_HeaderRec  = packed record // 128
    Header          : TStore_Header;        
    Reserve         : array[0..64 - 1 - SizeOf(TStore_Header)] of Byte;
  end;

implementation

uses
  QuickSortList;
  
{ TDBStockItem }

constructor TDBStockItem.Create;
begin
  fStockList := TALIntegerList.Create;
  fStockList.Duplicates := QuickSortList.lstdupIgnore;
end;

destructor TDBStockItem.Destroy;
begin
  fStockList.Free;
  inherited;
end;

function TDBStockItem.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := Pointer(fStockList.Objects[AIndex]);
end;

function TDBStockItem.GetItem(AIndex: integer): PRT_DealItem;
begin
  Result := GetRecordItem(AIndex);
end;

function TDBStockItem.GetItem(ACode: string): PRT_DealItem;
begin
  Result := nil;
end;

function TDBStockItem.GetRecordCount: integer;
begin
  Result := fStockList.Count;
end;

procedure TDBStockItem.Sort;
begin
  fStockList.Sort;
end;
                       
function TDBStockItem.AddItem(AMarketCode, AStockCode: AnsiString): PRT_DealItem;
begin
  Result := System.New(PRT_DealItem);
  FillChar(Result^, SizeOf(TRT_DealItem), 0);
  Result.sMarketCode := AMarketCode;
  Result.sCode := AStockCode;
  fStockList.AddObject(getStockCodePack(AStockCode), TObject(Result));
end;
                    
function TDBStockItem.FindItem(AStockCode: AnsiString): PRT_DealItem;   
var
  tmpIndex: integer;
  tmpPackStockCode: integer;
begin
  Result := nil;
  tmpPackStockCode := 0;
  if 8 = Length(AStockCode) then
  begin
    tmpPackStockCode := getStockCodePack(Copy(AStockCode, 3, MaxInt));
  end else if 6 = Length(AStockCode) then
  begin                                                          
    tmpPackStockCode := getStockCodePack(AStockCode);
  end;
  if 0 < tmpPackStockCode then
  begin
    tmpIndex := fStockList.IndexOf(tmpPackStockCode);
    if 0 <= tmpIndex then
    begin
      Result := PRT_DealItem(fStockList.Objects[tmpIndex]);
    end;
  end;
end;

function TDBStockItem.CheckOutItem(AMarketCode, AStockCode: AnsiString): PRT_DealItem;
begin
  Result := FindItem(AMarketCode + AStockCode);
  if nil = Result then
  begin
    Result := AddItem(AMarketCode, AStockCode);
  end;
end;

end.
