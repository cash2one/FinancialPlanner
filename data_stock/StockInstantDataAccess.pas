unit StockInstantDataAccess;

interface

uses
  BaseApp,
  BaseDataSet,
  QuickList_int,
  Define_DealItem,
  define_stock_quotes_instant,
  DB_DealItem;

type
  TDBStockInstant = class(TBaseDataSetAccess)
  protected
    fDataSrc: integer; 
    fStockList: TALIntegerList; 
    function GetRecordCount: Integer; override;
    function GetRecordItem(AIndex: integer): Pointer; override;
  public
    constructor Create(ADataSrc: integer);
    destructor Destroy; override;          
    function FindRecordByKey(AKey: Integer): Pointer; override;
    function AddItem(AStockItem: PRT_DealItem): PRT_InstantQuote;
    function FindItem(AStockItem: PRT_DealItem): PRT_InstantQuote;      
  end;
  
  function SaveDBStockInstant(App: TBaseApp; ADB: TDBStockInstant): Boolean;   
  procedure LoadDBStockInstant(AStockItemDB: TDBDealItem; AInstantDB: TDBStockInstant; AFileUrl: string);
  
implementation

uses
  Windows,
  SysUtils,
  BaseWinFile,
  Define_DealStore_File,
  Define_Price,    
  Define_DealStore_Header;
                 
procedure LoadDBStockInstantFromBuffer(AStockItemDB: TDBDealItem; AInstantDB: TDBStockInstant; AMemory: Pointer);
var
  tmpStockItem: PRT_DealItem;
  tmpRTInstantQuote: PRT_InstantQuote; 
  tmpHead: PStore_InstantQuoteHeaderRec; 
  tmpItemRec: PStore_InstantQuoteRec;
  tmpStockCode: AnsiString;
  tmpCount: integer;
  i: integer;
begin
  if nil = AMemory then
    Exit;
  tmpHead := AMemory;            
  if (7784 = tmpHead.Header.Signature.Signature) and
     (1 = tmpHead.Header.Signature.DataVer1) and
     (0 = tmpHead.Header.Signature.DataVer2) and
     (0 = tmpHead.Header.Signature.DataVer3) and
     (DataType_Stock = tmpHead.Header.DataType) and             // 2 -- 10
     (DataMode_DayInstant = tmpHead.Header.DataMode) then   // 1 -- 11
  begin
    tmpCount := tmpHead.Header.RecordCount;
    Inc(tmpHead);
    tmpItemRec := PStore_InstantQuoteRec(tmpHead);
    for i := 0 to tmpCount - 1 do
    begin
      tmpStockItem := nil;
      if nil <> tmpItemRec then
      begin
        tmpStockCode := getStockCodeByPackCode(tmpItemRec.Data.StockCode);
        tmpStockItem := AStockItemDB.FindItem(tmpStockCode);
      end;
      if nil <> tmpStockItem then
      begin
        tmpRTInstantQuote := AInstantDB.AddItem(tmpStockItem);
        if nil <> tmpRTInstantQuote then
        begin
          StorePriceRange2RTPricePackRange(@tmpRTInstantQuote.PriceRange, @tmpItemRec.Data.PriceRange);
          tmpRTInstantQuote.Amount := tmpItemRec.Data.Amount; // 8 -- 28
          tmpRTInstantQuote.Volume := tmpItemRec.Data.Volume; // 36
        end;
      end;

      Inc(tmpItemRec);
    end;
  end;
end;

procedure SaveDBStockInstantToBuffer(App: TBaseApp; ADB: TDBStockInstant; AMemory: Pointer);  
var  
  tmpHead: PStore_InstantQuoteHeaderRec;
  tmpItemRec: PStore_InstantQuoteRec;
  tmpRTItem: PRT_InstantQuote;
  i: integer;
begin
  tmpHead := AMemory;
  tmpHead.Header.Signature.Signature := 7784; // 6
  tmpHead.Header.Signature.DataVer1  := 1;
  tmpHead.Header.Signature.DataVer2  := 0;
  tmpHead.Header.Signature.DataVer3  := 0;
  // 字节存储顺序 java 和 delphi 不同
  // 00
  // 01
  tmpHead.Header.Signature.BytesOrder:= 1;
  tmpHead.Header.HeadSize            := SizeOf(TStore_InstantQuoteHeaderRec);             // 1 -- 7   
  tmpHead.Header.StoreSizeMode.Value := 16;  // 1 -- 8 page size mode
  { 表明是什么数据 }
  tmpHead.Header.DataType            := DataType_Stock;             // 2 -- 10
  tmpHead.Header.DataMode            := DataMode_DayInstant;        // 1 -- 11
  tmpHead.Header.RecordSizeMode.Value:= 6;  // 1 -- 12
  tmpHead.Header.RecordCount         := ADB.RecordCount;          // 4 -- 16
  tmpHead.Header.CompressFlag        := 0;             // 1 -- 17
  tmpHead.Header.EncryptFlag         := 0;             // 1 -- 18
  tmpHead.Header.DataSourceId        := 0;             // 2 -- 20
        
  Inc(tmpHead);
  tmpItemRec := PStore_InstantQuoteRec(tmpHead);
  for i := 0 to ADB.RecordCount - 1 do
  begin
    tmpRTItem := ADB.RecordItem[i];
    
    tmpItemRec.Data.StockCode := getStockCodePack(tmpRTItem.Item.sCode); // 4
    RTPricePackRange2StorePriceRange(@tmpItemRec.Data.PriceRange, @tmpRTItem.PriceRange);
    tmpItemRec.Data.Amount      := tmpRTItem.Amount;    // 8 -- 28
    tmpItemRec.Data.Volume      := tmpRTItem.Volume;                // 36
        
    Inc(tmpItemRec);
  end;
end;

function SaveDBStockInstant(App: TBaseApp; ADB: TDBStockInstant): Boolean;
var
  tmpPathUrl: string;     
  tmpFileUrl: string;   
  tmpWinFile: TWinFile;   
  tmpFileNewSize: integer;   
  tmpFileContentBuffer: Pointer;   
  tmpBytesWrite: DWORD;
begin
  Result := false;
  tmpPathUrl := App.Path.DataBasePath[FilePath_DBType_InstantData, 0];
  tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', now()), 5, MaxInt) + '.' + FileExt_StockInstant;
  //tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', now()), 7, MaxInt) + '.' + FileExt_StockInstant;
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(tmpFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(TStore_InstantQuoteHeaderRec) + ADB.RecordCount * SizeOf(TStore_InstantQuoteRec); //400k
      tmpFileNewSize := ((tmpFileNewSize div (1 * 1024)) + 1) * 1 * 1024;
      tmpWinFile.FileSize := tmpFileNewSize;  
      GetMem(tmpFileContentBuffer, tmpWinFile.FileSize);
      if nil <> tmpFileContentBuffer then
      begin
        try
          SaveDBStockInstantToBuffer(App, ADB, tmpFileContentBuffer);
          if Windows.WriteFile(tmpWinFile.FileHandle,
                tmpFileContentBuffer^, tmpWinFile.FileSize, tmpBytesWrite, nil) then
          begin
            Result := true;
          end;
        finally
          FreeMem(tmpFileContentBuffer);
        end;
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

procedure LoadDBStockInstant(AStockItemDB: TDBDealItem; AInstantDB: TDBStockInstant; AFileUrl: string);
var  
  tmpWinFile: TWinFile;
  tmpFileContentBuffer: Pointer;   
begin
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(AFileUrl, false) then
    begin
      tmpFileContentBuffer := tmpWinFile.OpenFileMap;
      if nil <> tmpFileContentBuffer then
      begin
        LoadDBStockInstantFromBuffer(AStockItemDB, AInstantDB, tmpFileContentBuffer);
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

{ TDBStockInstant }

constructor TDBStockInstant.Create(ADataSrc: integer);
begin
  fDataSrc := ADataSrc;   
  fStockList := TALIntegerList.Create;
end;

destructor TDBStockInstant.Destroy;
begin
  fStockList.Free;
  inherited;
end;
           
function TDBStockInstant.GetRecordCount: Integer;
begin
  Result := fStockList.Count;
end;

function TDBStockInstant.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fStockList.Objects[AIndex];
end;

function TDBStockInstant.AddItem(AStockItem: PRT_DealItem): PRT_InstantQuote;
begin
  Result := System.New(PRT_InstantQuote);
  FillChar(Result^, SizeOf(TRT_InstantQuote), 0);
  Result.Item := AStockItem;
  fStockList.AddObject(getStockCodePack(AStockItem.sCode), TObject(Result));
end;

function TDBStockInstant.FindItem(AStockItem: PRT_DealItem): PRT_InstantQuote;
begin
  Result := FindRecordByKey(getStockCodePack(AStockItem.sCode));
end;

function TDBStockInstant.FindRecordByKey(AKey: Integer): Pointer;
var
  tmpPos: integer;
begin
  Result := nil;
  tmpPos := fStockList.IndexOf(AKey);
  if 0 <= tmpPos then
  begin
    Result := fStockList.Objects[tmpPos];
  end;
end;

end.
