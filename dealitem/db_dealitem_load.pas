unit db_dealitem_load;

interface

uses
  BaseApp,
  db_dealitem,
  define_price,
  define_dealstore_header;
  
  procedure LoadDBStockItemDic(App: TBaseApp; ADB: TDBDealItem);  
  procedure LoadDBStockItemDicFromFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);

implementation

uses
  Windows,
  define_dealitem,
  define_dealstore_file,
  BaseWinFile;
                            
procedure LoadDBStockItemFromBuffer(App: TBaseApp; ADB: TDBDealItem; AMemory: Pointer);
var
  tmpRecordCount: integer;   
  tmpHead: PStore_HeaderRec;
  tmpItemRec: PStore_DealItem32Rec;
  i: integer;
  tmpStockItem: PRT_DealItem;
  tmpMarket: string;
  tmpStockCode: string;
begin
  tmpHead := AMemory;
  if tmpHead.Header.HeadSize = SizeOf(TStore_HeaderRec) then
  begin
    if (tmpHead.Header.DataType = DataType_DBItem) then
    begin
      tmpRecordCount := tmpHead.Header.RecordCount;
      Inc(tmpHead);
      tmpItemRec := PStore_DealItem32Rec(tmpHead);
      for i := 0 to tmpRecordCount - 1 do
      begin
        tmpStockCode := tmpItemRec.ItemRecord.Code;
        tmpMarket := '';
        if (8 = length(tmpStockCode)) then
        begin
          tmpMarket := Copy(tmpStockCode, 1, 2);
          tmpStockCode := Copy(tmpStockCode, 3, maxint);
        end;
        if ('' <> tmpMarket) and ('' <> tmpStockCode) then
        begin
          tmpStockItem := ADB.AddItem(tmpMarket, tmpStockCode);
          if nil <> tmpStockItem then
          begin
            tmpStockItem.FirstDealDate := tmpItemRec.ItemRecord.FirstDealDate;
            tmpStockItem.EndDealDate := tmpItemRec.ItemRecord.EndDate;
            tmpStockItem.Name := tmpItemRec.ItemRecord.Name;
          end;
        end;
        Inc(tmpItemRec);
      end;
    end;  
  end;
end;

procedure LoadDBStockItem2(App: TBaseApp; ADB: TDBDealItem);
var
  tmpFileUrl: string; 
  tmpWinFile: TWinFile;
  tmpFileContentBuffer: Pointer;
  tmpBytesRead: DWORD;
begin
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_ItemDB, 0, 2, nil);
  if App.Path.IsFileExists(tmpFileUrl) then
  begin
    tmpWinFile := TWinFile.Create;
    try         
      if tmpWinFile.OpenFile(tmpFileUrl, false) then
      begin
        GetMem(tmpFileContentBuffer, tmpWinFile.FileSize);
        if nil <> tmpFileContentBuffer then
        begin
          try
            if Windows.ReadFile(tmpWinFile.FileHandle,
                tmpFileContentBuffer^, tmpWinFile.FileSize, tmpBytesRead, nil) then
            begin
              LoadDBStockItemFromBuffer(App, ADB, tmpFileContentBuffer);
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
end;

procedure LoadDBStockItemDicFromFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);
var
  tmpWinFile: TWinFile;
  tmpFileMapView: Pointer;
begin
  // ≤‚ ‘ 601857 ÷–π˙ Ø”Õ           
  //ADB.AddItem('sh', '601857');
  //Exit;      
  if not App.Path.IsFileExists(AFileUrl) then
    exit;
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(AFileUrl, false) then
    begin
      tmpFileMapView := tmpWinFile.OpenFileMap;
      if nil <> tmpFileMapView then
      begin
        LoadDBStockItemFromBuffer(App, ADB, tmpFileMapView);
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

procedure LoadDBStockItemDic(App: TBaseApp; ADB: TDBDealItem);
var   
  tmpFileUrl: string;
begin
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_ItemDB, 0, 2, nil);
  if App.Path.IsFileExists(tmpFileUrl) then
  begin
    LoadDBStockItemDicFromFile(App, ADB, tmpFileUrl);  
  end;
end;

end.
