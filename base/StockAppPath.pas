unit StockAppPath;

interface

uses
  SysUtils, BaseApp, BaseWinApp, 
  define_datasrc,
  define_dealitem,
  define_dealstore_file;
  
type
  TStockAppPathData = record
    DBPathRoot: string;
    DetailDBPath: string;
  end;
  
  TStockAppPath = class(TBaseWinAppPath)
  protected
    fStockAppPathData: TStockAppPathData;
    function GetDataBasePath(ADBType: integer; ADataSrc: integer): WideString; override;
    function GetInstallPath: WideString; override;
  public                    
    constructor Create(App: TBaseApp); override;

    function GetRootPath: WideString; override;
    function GetFileRelativePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; override;
    function GetFilePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; override;

    function GetFileName(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; override; 
    function GetFileExt(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; override;

    function GetFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; override;

    function CheckOutFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; override;

    property DBPathRoot: string read fStockAppPathData.DBPathRoot write fStockAppPathData.DBPathRoot;
  end;
  
implementation

uses
  IniFiles;
  
{ TStockDay163AppPath }

constructor TStockAppPath.Create(App: TBaseApp);
begin
  inherited;
  FillChar(fStockAppPathData, SizeOf(fStockAppPathData), 0);
  fStockAppPathData.DBPathRoot := FilePath_StockData;
end;
                          
function TStockAppPath.GetRootPath: WideString;
begin
  Result := GetInstallPath;
end;
                    
function TStockAppPath.GetFileRelativePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; 
var
  tmpDataSrcCode: string;
  tmpIni: TIniFile;
begin
  Result := '';
  tmpDataSrcCode := GetDataSrcCode(ADataSrc);
  if FilePath_DBType_DayData = ADBType then
    Result := fStockAppPathData.DBPathRoot + '\' + FileExt_StockDay + tmpDataSrcCode + '\';
  if FilePath_DBType_DayDataWeight  = ADBType then
    Result := fStockAppPathData.DBPathRoot + '\' + FileExt_StockDayWeight + tmpDataSrcCode + '\';
  if FilePath_DBType_InstantData = ADBType then
    Result := fStockAppPathData.DBPathRoot + '\' + FileExt_StockInstant + tmpDataSrcCode + '\';
  if FilePath_DBType_DetailData = ADBType then
  begin
    if '' = fStockAppPathData.DetailDBPath then
    begin
      tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
      try
        fStockAppPathData.DetailDBPath := tmpIni.ReadString('Path', 'DetailRoot_' + tmpDataSrcCode, '');
        if '' = fStockAppPathData.DetailDBPath then
        begin
          fStockAppPathData.DetailDBPath := fStockAppPathData.DBPathRoot + '\' + FileExt_StockDetail + tmpDataSrcCode + '\';
        end;
        tmpIni.WriteString('Path', 'DetailRoot_' + tmpDataSrcCode, fStockAppPathData.DetailDBPath);
      finally
        tmpIni.Free;
      end;
    end;
    Result := fStockAppPathData.DetailDBPath;
  end;
  if FilePath_DBType_ValueData = ADBType then
    Result := fStockAppPathData.DBPathRoot + '\' + FileExt_StockSummaryValue + tmpDataSrcCode + '\';
      
  if FilePath_DBType_ItemDB = ADBType then
    Result := fStockAppPathData.DBPathRoot + '\' + 's_dic' + '\';
  if '' = Result then
  begin
    if '' <> tmpDataSrcCode then
      Result := fStockAppPathData.DBPathRoot + '\' + 's' + tmpDataSrcCode + '\'
    else
      Result := fStockAppPathData.DBPathRoot + '\';
  end;
end;

function TStockAppPath.GetDataBasePath(ADBType: integer; ADataSrc: integer): WideString;
var
  tmpDataSrcCode: string;
  tmpIni: TIniFile;
begin
  Result := '';
  tmpDataSrcCode := GetDataSrcCode(ADataSrc);
  if FilePath_DBType_DayData = ADBType then
    Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + FileExt_StockDay + tmpDataSrcCode + '\';
  if FilePath_DBType_DayDataWeight  = ADBType then
    Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + FileExt_StockDayWeight + tmpDataSrcCode + '\';
  if FilePath_DBType_InstantData = ADBType then
    Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + FileExt_StockInstant + tmpDataSrcCode + '\';
  if FilePath_DBType_DetailData = ADBType then
  begin
    if '' = fStockAppPathData.DetailDBPath then
    begin
      tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
      try
        fStockAppPathData.DetailDBPath := tmpIni.ReadString('Path', 'DetailRoot_' + tmpDataSrcCode, '');
        if '' = fStockAppPathData.DetailDBPath then
        begin
          fStockAppPathData.DetailDBPath := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + FileExt_StockDetail + tmpDataSrcCode + '\';
        end;
        tmpIni.WriteString('Path', 'DetailRoot_' + tmpDataSrcCode, fStockAppPathData.DetailDBPath);
      finally
        tmpIni.Free;
      end;
    end;
    Result := fStockAppPathData.DetailDBPath;
  end;
  if FilePath_DBType_ValueData = ADBType then
    Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + FileExt_StockSummaryValue + tmpDataSrcCode + '\';
      
  if FilePath_DBType_ItemDB = ADBType then
    Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + 's_dic' + '\';
  if '' = Result then
  begin
    if '' <> tmpDataSrcCode then
      Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\' + 's' + tmpDataSrcCode + '\'
    else
      Result := GetInstallPath + fStockAppPathData.DBPathRoot + '\';
  end;
  if '' <> Result then
  begin
    Sysutils.ForceDirectories(Result);
  end;
end;

function TStockAppPath.GetFilePath(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString;
begin
  Result := '';
  if FilePath_DBType_DetailData = ADBType then
  begin
    if nil = AParam then
      exit;
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

function TStockAppPath.GetFileName(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString;
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
      Result := Result + '.' + GetFileExt(ADBType, ADataSrc, AParamType, AParam);
    end;
    exit;
  end;              
  if FilePath_DBType_DayData = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := PRT_DealItem(AParam).sCode + '.' + GetFileExt(ADBType, ADataSrc, AParamType, AParam);
    end;
    exit;
  end;
  if FilePath_DBType_DayDataWeight = ADBType then
  begin
    if nil <> AParam then
    begin
      Result := PRT_DealItem(AParam).sCode + '.' + GetFileExt(ADBType, ADataSrc, AParamType, AParam);
    end;
    exit;
  end;
  if FilePath_DBType_InstantData = ADBType then
  begin
    exit;
  end;      
  if FilePath_DBType_ItemDB = ADBType then
  begin
    Result := 'items.' + GetFileExt(ADBType, ADataSrc, AParamType, AParam);
    exit;
  end;
end;

function TStockAppPath.GetFileExt(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString;
begin
  Result := '';
  if FilePath_DBType_DetailData = ADBType then
  begin
    Result := FileExt_StockDetail + IntToStr(ADataSrc);
    exit;
  end;
  if FilePath_DBType_DayData = ADBType then
  begin
    Result := FileExt_StockDay + '_' + IntToStr(ADataSrc);
    exit;
  end;
  if FilePath_DBType_DayDataWeight = ADBType then
  begin                                             
    Result := FileExt_StockDayWeight + '_' + IntToStr(ADataSrc);
    exit;
  end;
  if FilePath_DBType_InstantData = ADBType then
  begin
    exit;
  end;
  if FilePath_DBType_ItemDB = ADBType then
  begin
    Result := 'dic';
    exit;
  end;
end;

function TStockAppPath.CheckOutFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString;
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

function TStockAppPath.GetFileUrl(ADBType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString;
var
  tmpFileName: AnsiString;
  tmpFilePath: AnsiString;
begin
  Result := '';             
  if FilePath_DBType_ItemDB = ADBType then
  begin
    Result := ChangeFileExt(ParamStr(0), '.dic');
    if FileExists(Result) then
    begin
      exit;
    end;
  end;
  tmpFilePath := GetFilePath(ADBType, ADataSrc, AParamType, AParam);
  tmpFileName := GetFileName(ADBType, ADataSrc, AParamType, AParam, AFileExt);  
  if ('' <> tmpFilePath) and ('' <> tmpFileName) then
  begin
    Result := tmpFilePath + tmpFileName;
  end;
end;

function TStockAppPath.GetInstallPath: WideString;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

end.
