unit db_dealitem_loadIni;

interface

uses
  BaseApp, db_dealItem, Define_DealMarket;
  
  procedure LoadDBStockItemIni(App: TBaseApp; ADB: TDBDealItem);     
  procedure LoadDBStockItemIniFromFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);

implementation

uses
  define_dealItem,
  Windows,
  Classes,
  Sysutils,
  IniFiles;

procedure LoadDBStockItemIni(App: TBaseApp; ADB: TDBDealItem);
var                           
  tmpFilePath: string;
  tmpFileUrl: string;
  tmpFileName: string;
  tmpDicIni: TIniFile;
  tmpCnt: integer;
  idxFile: integer;
begin
  tmpFilePath := App.Path.DataBasePath[0, 0] + 'sdic\';
  tmpFileUrl := tmpFilePath + 'items.ini';
  if FileExists(tmpFileUrl) then
  begin
    tmpDicIni := TIniFile.Create(tmpFileUrl);
    try
      tmpCnt := tmpDicIni.ReadInteger('items', 'count', 0);
      for idxFile := 0 to tmpCnt - 1 do
      begin
        tmpFileName := tmpDicIni.ReadString('items', 'item' + IntToStr(idxFile + 1), '');
        tmpFileUrl := tmpFilePath + tmpFileName;
        if FileExists(tmpFileUrl) then
        begin
          LoadDBStockItemIniFromFile(App, ADB, tmpFileUrl);      
        end;
      end;
    finally
      tmpDicIni.Free;
    end;
  end;
end;

procedure LoadDBStockItemIniFromFile(App: TBaseApp; ADB: TDBDealItem; AFileUrl: string);
var            
  i: integer;
  tmpSections: TStringList;
  tmpStockItem: PRT_DealItem;   
  tmpItemsIni: TIniFile;   
  tmpStockCode: string;
  tmpMarket: string;
begin
  if not FileExists(AFileUrl) then
    exit;
  tmpSections := TStringList.Create;
  tmpItemsIni := TIniFile.Create(AFileUrl);
  try
    tmpItemsIni.ReadSections(tmpSections);
    for i := 0 to tmpSections.Count - 1 do
    begin
      tmpStockCode := Trim(LowerCase(tmpSections[i]));
      tmpMarket := '';
      if '' <> tmpStockCode then
      begin
        if Length(tmpStockCode) = 6 then
        begin
          if '6' = tmpStockCode[1] then
            tmpMarket := Market_SH
          else
            tmpMarket := Market_SZ;
        end else
        begin
          if Pos(Market_SH, tmpStockCode) > 0 then
            tmpMarket := Market_SH;
          if Pos(Market_SZ, tmpStockCode) > 0 then
            tmpMarket := Market_SZ;
          tmpStockCode := Copy(tmpStockCode, 3, maxint);
        end;
        if ('' <> tmpMarket) and (6 = Length(tmpStockCode)) then
        begin
          tmpStockItem := ADB.AddItem(tmpMarket, tmpStockCode);
          if nil <> tmpStockItem then
          begin
            tmpStockItem.FirstDealDate := tmpItemsIni.ReadInteger(tmpSections[i], 'FirstDeal', 0);
            tmpStockItem.EndDealDate := tmpItemsIni.ReadInteger(tmpSections[i], 'e', 0);
            if 0 = tmpStockItem.EndDealDate then
            begin
              tmpStockItem.EndDealDate := tmpItemsIni.ReadInteger(tmpSections[i], 'EndDeal', 0);
            end;
            tmpStockItem.Name := Trim(tmpItemsIni.ReadString(tmpSections[i], 'n', ''));
            if '' = tmpStockItem.Name then
            begin
              tmpStockItem.Name := Trim(tmpItemsIni.ReadString(tmpSections[i], 'name', ''));
            end;
          end;
        end;
      end;
    end;
  finally
    tmpItemsIni.Free;
    tmpSections.Free;
  end;
end;

end.
