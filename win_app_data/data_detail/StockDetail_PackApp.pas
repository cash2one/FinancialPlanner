unit StockDetail_PackApp;

interface

uses
  BaseApp,
  BaseStockApp;
            
type
  TStockDetailPackApp = class(TBaseStockApp)
  protected
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
  end;

implementation

uses
  Sysutils,    
  define_dealitem,
  define_datasrc,
  define_dealstore_file,       
  DB_DealItem,
  DB_DealItem_Load,
  UtilsLog,
  QuickList_Int,  
  StockDayDataAccess,
  StockDayData_Load,
  StockDetailDataAccess,
  StockDetailData_Load;

{ TStockDay163App }

constructor TStockDetailPackApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

type
  PStockDetailPack_Month = ^TStockDetailPack_Month;
  TStockDetailPack_Month = record
    IsReady: Integer;
    Year: Word;
    Month: Word;
    StockDetails: TALIntegerList;
  end;
  
procedure ClearStockDetailPack_Month(AStockDetailPack_Month: PStockDetailPack_Month);
var
  i: integer;  
  tmpDetailData: TStockDetailDataAccess;
begin
  if nil <> AStockDetailPack_Month.StockDetails then
  begin
    for i := AStockDetailPack_Month.StockDetails.Count - 1 downto 0 do
    begin
      tmpDetailData := TStockDetailDataAccess(AStockDetailPack_Month.StockDetails.Objects[i]);
      tmpDetailData.Clear;
      tmpDetailData.Free;
      AStockDetailPack_Month.StockDetails.Delete(i);
    end;
    AStockDetailPack_Month.StockDetails.Clear;
  end;
end;
                
procedure PackStockDetailPack_Month(AStockDetailPack_Month: PStockDetailPack_Month);
begin
  Log('PackStockDetailPack_Month', '');    
  if 0 = AStockDetailPack_Month.Year then
    exit;
  if 0 = AStockDetailPack_Month.Month then
    exit;
end;

procedure StockDetailPack_Item(App: TBaseApp; AStockDayAccess: TStockDayDataAccess); overload;
var
  i, j: integer;  
  tmpYear, tmpMonth, tmpDay: Word;
  tmpDetailPackData: TStockDetailPack_Month;  
  tmpDetailData: TStockDetailDataAccess;
  tmpIsNew: Boolean;    
  tmpFilePathYear: string;
  tmpFileName: string;
  tmpFileUrl: string;
begin
  FillChar(tmpDetailPackData, SizeOf(tmpDetailPackData), 0);
  tmpIsNew := false;
  for i := AStockDayAccess.LastDealDate downto AStockDayAccess.FirstDealDate do
  begin
    DecodeDate(i, tmpYear, tmpMonth, tmpDay);
    if tmpYear <> tmpDetailPackData.Year then
      tmpIsNew := true;
    if tmpMonth <> tmpDetailPackData.Month then
      tmpIsNew := true;
    if tmpIsNew then
    begin
      PackStockDetailPack_Month(@tmpDetailPackData);
      tmpDetailPackData.IsReady := 0;
      tmpDetailPackData.Year := tmpYear;
      tmpDetailPackData.Month := tmpMonth;
      tmpIsNew := false;
      if nil = tmpDetailPackData.StockDetails then
        tmpDetailPackData.StockDetails := TALIntegerList.Create;
      ClearStockDetailPack_Month(@tmpDetailPackData);
    end;      
    if 2016 > tmpYear then
    begin
      Break;
    end;

    tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, DataSrc_Sina, i, AStockDayAccess.StockItem);
    tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, DataSrc_Sina, i, AStockDayAccess.StockItem, '');

    if '' <> tmpFileName then
    begin
      tmpFileUrl := tmpFilePathYear + tmpFileName;
      if not FileExists(tmpFileUrl) then
        tmpFileUrl := ChangeFileExt(tmpFileUrl, '.sdet');
      if FileExists(tmpFileUrl) then
      begin
        tmpDetailData := TStockDetailDataAccess.Create(AStockDayAccess.StockItem, DataSrc_Sina);
        LoadStockDetailData(App, tmpDetailData, tmpFileUrl);
      end;
    end;
  end;
end;

procedure StockDetailPack_Item(App: TBaseApp; AStockItem: PRT_DealItem); overload;
var
  tmpDayData: TStockDayDataAccess;
begin
  tmpDayData := TStockDayDataAccess.Create(AStockItem, DataSrc_163, false);
  try
    if LoadStockDayData(App, tmpDayData) then
    begin
      StockDetailPack_Item(App, tmpDayData);
    end;
  finally
    tmpDayData.Free;
  end;
end;

procedure TStockDetailPackApp.Run;  
var
  tmpDBStockItem: TDBDealItem;
  i: integer;
begin       
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(Self, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      if 0 = tmpDBStockItem.Items[i].EndDealDate then
      begin
        StockDetailPack_Item(Self, tmpDBStockItem.Items[i]);
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
