unit FutureAppPath;

interface

uses
  SysUtils, BaseWinApp, 
  define_datasrc,
  define_dealitem,
  define_dealstore_file;
  
type
  TFutureAppPath = class(TBaseWinAppPath)
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

function TFutureAppPath.GetDataBasePath(ADBType: integer; ADataSrc: integer): string;
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
//    if FilePath_DBType_DayData = ADBType then
//      fDataBasePath := GetInstallPath + FilePath_FutureData + '\' + FileExt_FuturesDay + tmpDataSrcCode + '\';
//    if FilePath_DBType_InstantData = ADBType then
//      fDataBasePath := GetInstallPath + FilePath_FutureData + '\' + FileExt_FuturesInstant + tmpDataSrcCode + '\';
    if FilePath_DBType_DetailData = ADBType then
      fDataBasePath := GetInstallPath + FilePath_FutureData + '\' + FileExt_FuturesDetail + tmpDataSrcCode + '\';
      
    if FilePath_DBType_ItemDB = ADBType then
      fDataBasePath := GetInstallPath + FilePath_FutureData + '\' + 'sdic' + '\';
    if '' = fDataBasePath then
    begin
      if '' <> tmpDataSrcCode then
        fDataBasePath := GetInstallPath + FilePath_FutureData + '\' + 's' + tmpDataSrcCode + '\'
      else
        fDataBasePath := GetInstallPath + FilePath_FutureData + '\';
    end;
    Sysutils.ForceDirectories(fDataBasePath);
    fDBType := ADBType;
  end;
  Result := fDataBasePath;
end;

function TFutureAppPath.GetFilePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): string;
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

function TFutureAppPath.GetFileName(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string;
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
      Result := Result + '.' + FileExt_FuturesDetail;
    end;
    exit;
  end;              
  if FilePath_DBType_DayData = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := PRT_DealItem(AParam).sCode + '.' + FileExt_FuturesDetail;
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

function TFutureAppPath.CheckOutFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string;
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

function TFutureAppPath.GetFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: string): string;
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

function TFutureAppPath.GetInstallPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

end.
