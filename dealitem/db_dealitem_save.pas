unit db_dealitem_save;

interface

uses
  BaseApp,
  db_dealitem,
  Define_Price,
  define_dealitem,
  define_dealstore_header;
  
             
  procedure SaveDBStockItem(App: TBaseApp; ADB: TDBDealItem);    
  procedure SaveDBStockItemToDicFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);
  procedure SaveDBStockItemToIniFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);

implementation

uses
  Windows,
  IniFiles,
  SysUtils,
  define_dealstore_file,           
  BaseWinFile;
                        
procedure SaveDBStockItemToBuffer(App: TBaseApp; ADB: TDBDealItem; AMemory: Pointer);
var  
  tmpHead: PStore_HeaderRec;
  tmpItemRec: PStore_DealItem32Rec;
  i: integer;
  tmpRTItem: PRT_DealItem;
  tmpLen: integer;
  tmpCode: AnsiString;
  tmpName: WideString;
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

        
  tmpHead.Header.HeadSize            := SizeOf(TStore_HeaderRec);             // 1 -- 7
  tmpHead.Header.StoreSizeMode.Value := 16;  // 1 -- 8 page size mode
  { 表明是什么数据 }
  tmpHead.Header.DataType            := DataType_DBItem;             // 2 -- 10
  tmpHead.Header.DataMode            := 0;             // 1 -- 11
  tmpHead.Header.RecordSizeMode.Value:= 6;  // 1 -- 12
  tmpHead.Header.RecordCount         := ADB.RecordCount;          // 4 -- 16
  tmpHead.Header.CompressFlag        := 0;             // 1 -- 17
  tmpHead.Header.EncryptFlag         := 0;             // 1 -- 18
  tmpHead.Header.DataSourceId        := 0;             // 2 -- 20
        
  Inc(tmpHead);
  tmpItemRec := PStore_DealItem32Rec(tmpHead);
  for i := 0 to ADB.RecordCount - 1 do
  begin
    tmpRTItem := ADB.Items[i];
    tmpCode := tmpRTItem.sMarketCode + tmpRTItem.sCode;
    CopyMemory(@tmpItemRec.ItemRecord.Code[0], @tmpCode[1], Length(tmpCode));
    tmpItemRec.ItemRecord.FirstDealDate := tmpRTItem.FirstDealDate;
    tmpItemRec.ItemRecord.EndDate := tmpRTItem.EndDealDate;
    tmpName := tmpRTItem.Name;

    tmpLen := Length(tmpName);
    if 5 < tmpLen then
      tmpLen := 5;
    CopyMemory(@tmpItemRec.ItemRecord.Name[0], @tmpName[1], tmpLen * SizeOf(WideChar));
    tmpItemRec.ItemRecord.Name[tmpLen] := #0;
    Inc(tmpItemRec);
  end;
end;
                                                            
function SaveDBStockItem2(App: TBaseApp; ADB: TDBDealItem): Boolean;   
var
  tmpFileUrl: string;   
  tmpWinFile: TWinFile;   
  tmpFileNewSize: integer;   
  tmpFileContentBuffer: Pointer;   
  tmpBytesWrite: DWORD;
begin
  Result := false;
  tmpFileUrl := App.Path.GetFileUrl(FilePath_DBType_ItemDB, 0, 2, nil);
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(tmpFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(TStore_HeaderRec) + ADB.RecordCount * SizeOf(TStore_DealItem32Rec); //400k
      tmpFileNewSize := ((tmpFileNewSize div (1 * 1024)) + 1) * 1 * 1024;
      tmpWinFile.FileSize := tmpFileNewSize;  
      GetMem(tmpFileContentBuffer, tmpWinFile.FileSize);
      if nil <> tmpFileContentBuffer then
      begin
        try
          SaveDBStockItemToBuffer(App, ADB, tmpFileContentBuffer);
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

procedure SaveDBStockItem(App: TBaseApp; ADB: TDBDealItem);
begin
  SaveDBStockItemToDicFile(App, ADB, App.Path.GetFileUrl(FilePath_DBType_ItemDB, 0, 2, nil));
end;

procedure SaveDBStockItemToDicFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);
var
  tmpWinFile: TWinFile;
  tmpFileMapView: Pointer; 
  tmpFileNewSize: integer;
begin
  tmpWinFile := TWinFile.Create;
  try
    if tmpWinFile.OpenFile(AFileUrl, true) then
    begin
      tmpFileNewSize := SizeOf(TStore_HeaderRec) + ADB.RecordCount * SizeOf(TStore_DealItem32Rec); //400k
      tmpFileNewSize := ((tmpFileNewSize div (1 * 1024)) + 1) * 1 * 1024;
      tmpWinFile.FileSize := tmpFileNewSize;

      tmpFileMapView := tmpWinFile.OpenFileMap;
      if nil <> tmpFileMapView then
      begin
        SaveDBStockItemToBuffer(App, ADB, tmpFileMapView);
      end;
    end;
  finally
    tmpWinFile.Free;
  end;
end;

procedure SaveDBStockItemToIniFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);
var
  tmpIniFile: TIniFile;
  i: integer;
  tmpRTItem: PRT_DealItem;
  tmpSection: string;
begin
  tmpIniFile := TIniFile.Create(AFileUrl);
  try
    for i := 0 to ADB.RecordCount - 1 do
    begin
      tmpRTItem := ADB.Items[i];
      if 0 < tmpRTItem.iCode then
      begin
        tmpSection := tmpRTItem.sMarketCode + IntToStr(tmpRTItem.iCode);
      end else
      begin
        tmpSection := Trim(tmpRTItem.sCode);
        if 6 = Length(tmpSection) then
        begin
          tmpSection := tmpRTItem.sMarketCode + tmpSection;
        end;
      end;
      if '' <> tmpSection then
      begin
        tmpIniFile.WriteString(tmpSection, 'n', tmpRTItem.Name);
        if 0 < tmpRTItem.FirstDealDate then
        begin
          tmpIniFile.WriteString(tmpSection, 'f', IntToStr(tmpRTItem.FirstDealDate));
        end;
        if 0 < tmpRTItem.EndDealDate then
        begin
          tmpIniFile.WriteString(tmpSection, 'e', IntToStr(tmpRTItem.EndDealDate));
        end;
      end;
    end;
  finally
    tmpIniFile.Free;
  end;
end;

end.
