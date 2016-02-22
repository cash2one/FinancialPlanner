unit StockAppPath;

interface

uses
  SysUtils, BaseWinApp, 
  define_datasrc,
  define_dealitem,
  define_dealstore_file;
  
type
  TStockAppPath = class(TBaseWinAppPath)
  protected
    fDataBasePath: string;
    fDBType: integer;   
    function GetDataBasePath(ADBType: integer; ADataSrc: integer): string; override;
    function GetInstallPath: string; override;
  public
    function GetFilePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): string; override;
    function GetFileName(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string; override;
    function CheckOutFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string; override;
    function GetFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string; override;
  end;
  
implementation

{ TStockDay163AppPath }

function TStockAppPath.GetDataBasePath(ADBType: integer; ADataSrc: integer): string;
var
  tmpDataSrcCode: string;
begin
  if fDBType <> ADBType then
  begin
    fDataBasePath := '';
  end;
  if ('' = fDataBasePath) then
  begin
    tmpDataSrcCode := GetDataSrcCode(ADataSrc);
    if FilePath_DBType_DayData = ADBType then
      fDataBasePath := GetInstallPath + FilePath_StockData + '\' + FileExt_StockDay + tmpDataSrcCode + '\';
    if FilePath_DBType_DayDataWeight  = ADBType then
      fDataBasePath := GetInstallPath + FilePath_StockData + '\' + FileExt_StockDayWeight + tmpDataSrcCode + '\';
    if FilePath_DBType_InstantData = ADBType then
      fDataBasePath := GetInstallPath + FilePath_StockData + '\' + FileExt_StockInstant + tmpDataSrcCode + '\';
    if FilePath_DBType_DetailData = ADBType then
      fDataBasePath := GetInstallPath + FilePath_StockData + '\' + FileExt_StockDetail + tmpDataSrcCode + '\';
    if FilePath_DBType_ValueData = ADBType then
      fDataBasePath := GetInstallPath + FilePath_StockData + '\' + FileExt_StockValue + tmpDataSrcCode + '\';
      
    if FilePath_DBType_ItemDB = ADBType then
      fDataBasePath := GetInstallPath + FilePath_StockData + '\' + 'sdic' + '\';
    if '' = fDataBasePath then
    begin
      if '' <> tmpDataSrcCode then
        fDataBasePath := GetInstallPath + FilePath_StockData + '\' + 's' + tmpDataSrcCode + '\'
      else
        fDataBasePath := GetInstallPath + FilePath_StockData + '\';
    end;
    Sysutils.ForceDirectories(fDataBasePath);
    fDBType := ADBType;
  end;
  Result := fDataBasePath;
end;

function TStockAppPath.GetFilePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): string;
begin
  Result := '';
  if FilePath_DBType_DetailData = ADBType then
  begin
    Result := DataBasePath[ADBType, ADataSrc] +
        Copy(PRT_DealItem(AParam).sCode, 1, 4) + '\' +
        PRT_DealItem(AParam).sCode + '\';
    if 0 < AParamType then
    begin
      Result := Result + Copy(FormatDateTime('yyyymmdd', AParamType), 1, 4) + '\';
    end;
    exit;
  end;
  if FilePath_DBType_DayData = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := DataBasePath[ADBType, ADataSrc];
    end;
  end;           
  if FilePath_DBType_DayDataWeight  = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := DataBasePath[ADBType, ADataSrc];
    end;
  end;
  if FilePath_DBType_InstantData = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := DataBasePath[ADBType, ADataSrc];
    end;
  end;
  if FilePath_DBType_ItemDB = ADBType then
  begin
    Result := DataBasePath[ADBType, 0];
  end;   
  if '' = Result then
  begin
    Result := DataBasePath[ADBType, ADataSrc];
  end;
end;

function TStockAppPath.GetFileName(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string;
begin
  Result := '';
  if FilePath_DBType_DetailData = ADBType then
  begin
    Result := PRT_DealItem(AParam).sCode + '_' + FormatDateTime('yyyymmdd', AParamType);
    if '' <> AFileExt then
    begin
      if Pos('.', AFileExt) > 0 then
      begin
        Result := Result + AFileExt;
      end else
      begin
        Result := Result + '.' + AFileExt;
      end;
    end else
    begin
      Result := Result + '.' + FileExt_StockDetail;
    end;
    exit;
  end;              
  if FilePath_DBType_DayData = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := PRT_DealItem(AParam).sCode + '.' + FileExt_StockDay;
    end;
    exit;
  end;
  if FilePath_DBType_DayDataWeight = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := PRT_DealItem(AParam).sCode + '.' + FileExt_StockDayWeight;
    end;
    exit;
  end;
  if FilePath_DBType_InstantData = ADBType then
  begin
    exit;
  end;      
  if FilePath_DBType_ItemDB = ADBType then
  begin
    Result := 'items.dic';
    exit;
  end;
end;

function TStockAppPath.CheckOutFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string;
var
  tmpFileName: AnsiString;
  tmpFilePath: AnsiString;
begin
  Result := '';
  tmpFilePath := GetFilePath(ADBType, ADataSrc, AParamType, AParam);
  tmpFileName := GetFileName(ADBType, ADataSrc, AParamType, AParam, AFileExt);  
  if ('' <> tmpFilePath) and ('' <> tmpFileName) then
  begin
    ForceDirectories(tmpFilePath);
    Result := tmpFilePath + tmpFileName;
  end;
end;

function TStockAppPath.GetFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string;
var
  tmpFileName: AnsiString;
  tmpFilePath: AnsiString;
begin
  Result := '';
  tmpFilePath := GetFilePath(ADBType, ADataSrc, AParamType, AParam);
  tmpFileName := GetFileName(ADBType, ADataSrc, AParamType, AParam, AFileExt);  
  if ('' <> tmpFilePath) and ('' <> tmpFileName) then
  begin
    Result := tmpFilePath + tmpFileName;
  end;
end;

function TStockAppPath.GetInstallPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

end.
