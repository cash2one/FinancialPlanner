unit StockValueData;

interface

uses
  QuickList_int,
  Define_DealItem, define_dealStore_Header,
  BaseApp, BaseDataSet, DB_DealItem;
  
type           
  PStore_StockValue = ^TStore_StockValue;
  TStore_StockValue = packed record
    StockCode   : TDealCodePack; // 4
    ValueDate   : Word;   // 2 -- 6
    DealVolume  : Int64;  // 8 -- 14 流通股本
    TotalVolume : Int64;  // 8 -- 22 总股本
    DealValue   : Int64;  // 8 -- 30 流通市值
    TotalValue  : Int64;  // 8 -- 38 总市值
  end;
              

  PStore_StockValueRec = ^TStore_StockValueRec;
  TStore_StockValueRec = packed record
    Data        : TStore_StockValue;
    // 16 32 48 64
    //Reserve     : array[0..64 - 1 - SizeOf(TStore_InstantQuote)] of Byte;
    Reserve     : array[0..40 - 1 - SizeOf(TStore_StockValue)] of Byte;    
  end;
     
  PStore_StockValueHeader = ^TStore_StockValueHeader;
  TStore_StockValueHeader = packed record
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
  end;

  PStore_StockValueHeaderRec = ^TStore_StockValueHeaderRec;
  TStore_StockValueHeaderRec = packed record
    Header: TStore_StockValueHeader;
    Reserve: array[0..64 - 1 - SizeOf(TStore_StockValueHeader)] of Byte;
  end;
          
  PRT_StockValue        = ^TRT_StockValue;
  TRT_StockValue        = packed record
    Item                : PRT_DealItem;
    Date                : Word;      
    DealVolume          : Int64;
    DealValue           : Int64;      
    TotalVolume         : Int64;
    TotalValue          : Int64;
  end;
          
  TDBStockValue = class(TBaseDataSetAccess)
  protected
    fDataSrc: integer; 
    fStockList: TALIntegerList; 
    function GetRecordCount: Integer; override;
    function GetRecordItem(AIndex: integer): Pointer; override;
  public
    constructor Create(ADataSrc: integer);
    destructor Destroy; override;          
    function FindRecordByKey(AKey: Integer): Pointer; override;
    function AddItem(AStockItem: PRT_DealItem): PRT_StockValue;
    function FindItem(AStockItem: PRT_DealItem): PRT_StockValue;      
  end;
  
  function SaveDBStockValue(App: TBaseApp; ADB: TDBStockValue): Boolean;   
  procedure LoadDBStockValue(AStockItemDB: TDBStockItem; ADB: TDBStockValue; AFileUrl: string);
  
implementation

uses
  Windows,
  SysUtils,
  Define_dealStore_File,
  BaseWinFile;
  
procedure LoadDBStockValueFromBuffer(AStockItemDB: TDBStockItem; ADB: TDBStockValue; AMemory: Pointer);
var
  tmpStockItem: PRT_DealItem;
  tmpRTStockValue: PRT_StockValue; 
  tmpHead: PStore_StockValueHeaderRec; 
  tmpItemRec: PStore_StockValueRec;
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
     (DataMode_DayValue = tmpHead.Header.DataMode) then   // 1 -- 11
  begin
    tmpCount := tmpHead.Header.RecordCount;
    Inc(tmpHead);
    tmpItemRec := PStore_StockValueRec(tmpHead);
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
        tmpRTStockValue := ADB.AddItem(tmpStockItem);
        if nil <> tmpRTStockValue then
        begin
          tmpRTStockValue.Date := tmpItemRec.Data.ValueDate; // 8 -- 28
          tmpRTStockValue.DealVolume := tmpItemRec.Data.DealVolume; // 36
          tmpRTStockValue.DealValue := tmpItemRec.Data.DealValue;
          tmpRTStockValue.TotalVolume := tmpItemRec.Data.TotalVolume;
          tmpRTStockValue.TotalValue := tmpItemRec.Data.TotalValue;
        end;
      end;

      Inc(tmpItemRec);
    end;
  end;
end;

procedure SaveDBStockValueToBuffer(App: TBaseApp; ADB: TDBStockValue; AMemory: Pointer);  
var  
  tmpHead: PStore_StockValueHeaderRec;
  tmpItemRec: PStore_StockValueRec;
  tmpRTItem: PRT_StockValue;
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
  tmpHead.Header.HeadSize            := SizeOf(TStore_StockValueHeaderRec);             // 1 -- 7   
  tmpHead.Header.StoreSizeMode.Value := 16;  // 1 -- 8 page size mode
  { 表明是什么数据 }
  tmpHead.Header.DataType            := DataType_Stock;             // 2 -- 10
  tmpHead.Header.DataMode            := DataMode_DayValue;        // 1 -- 11
  tmpHead.Header.RecordSizeMode.Value:= 6;  // 1 -- 12
  tmpHead.Header.RecordCount         := ADB.RecordCount;          // 4 -- 16
  tmpHead.Header.CompressFlag        := 0;             // 1 -- 17
  tmpHead.Header.EncryptFlag         := 0;             // 1 -- 18
  tmpHead.Header.DataSourceId        := 0;             // 2 -- 20
        
  Inc(tmpHead);
  tmpItemRec := PStore_StockValueRec(tmpHead);
  for i := 0 to ADB.RecordCount - 1 do
  begin
    tmpRTItem := ADB.RecordItem[i];
    
    tmpItemRec.Data.StockCode := getStockCodePack(tmpRTItem.Item.sCode); // 4
    tmpItemRec.Data.ValueDate      := tmpRTItem.Date;    // 8 -- 28
    tmpItemRec.Data.DealVolume     := tmpRTItem.DealVolume;                // 36
    tmpItemRec.Data.DealValue      := tmpRTItem.DealValue;
    tmpItemRec.Data.TotalVolume    := tmpRTItem.TotalVolume;
    tmpItemRec.Data.TotalValue     := tmpRTItem.TotalValue;
    Inc(tmpItemRec);
  end;
end;

function SaveDBStockValue(App: TBaseApp; ADB: TDBStockValue): Boolean;
var
  tmpPathUrl: string;     
  tmpFileUrl: string;   
  tmpWinFile: TWinFile;   
  tmpFileNewSize: integer;   
  tmpFileContentBuffer: Pointer;   
  tmpBytesWrite: DWORD;
begin
  Result := false;
  tmpPathUrl := App.Path.DataBasePath[FilePath_DBType_ValueData, 0];
  tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', now()), 5, MaxInt) + '.' + FileExt_StockValue;
  //tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', now()), 7, MaxInt) + '.' + FileExt_StockInstant;
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(tmpFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(TStore_StockValueHeaderRec) + ADB.RecordCount * SizeOf(TStore_StockValueRec); //400k
      tmpFileNewSize := ((tmpFileNewSize div (1 * 1024)) + 1) * 1 * 1024;
      tmpWinFile.FileSize := tmpFileNewSize;  
      GetMem(tmpFileContentBuffer, tmpWinFile.FileSize);
      if nil <> tmpFileContentBuffer then
      begin
        try
          SaveDBStockValueToBuffer(App, ADB, tmpFileContentBuffer);
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

procedure LoadDBStockValue(AStockItemDB: TDBStockItem; ADB: TDBStockValue; AFileUrl: string);
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
        LoadDBStockValueFromBuffer(AStockItemDB, ADB, tmpFileContentBuffer);
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

{ TDBStockInstant }

constructor TDBStockValue.Create(ADataSrc: integer);
begin
  fDataSrc := ADataSrc;   
  fStockList := TALIntegerList.Create;
end;

destructor TDBStockValue.Destroy;
begin
  fStockList.Free;
  inherited;
end;
           
function TDBStockValue.GetRecordCount: Integer;
begin
  Result := fStockList.Count;
end;

function TDBStockValue.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := fStockList.Objects[AIndex];
end;

function TDBStockValue.AddItem(AStockItem: PRT_DealItem): PRT_StockValue;
begin
  Result := System.New(PRT_StockValue);
  FillChar(Result^, SizeOf(TRT_StockValue), 0);
  Result.Item := AStockItem;
  fStockList.AddObject(getStockCodePack(AStockItem.sCode), TObject(Result));
end;

function TDBStockValue.FindItem(AStockItem: PRT_DealItem): PRT_StockValue;
begin
  Result := FindRecordByKey(getStockCodePack(AStockItem.sCode));
end;

function TDBStockValue.FindRecordByKey(AKey: Integer): Pointer;
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
