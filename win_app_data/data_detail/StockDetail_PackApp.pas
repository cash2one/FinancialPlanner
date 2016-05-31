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
  define_stock_quotes,
  define_dealstore_file,       
  DB_DealItem,
  DB_DealItem_Load,
  UtilsLog,
  QuickList_Int,  
  StockDayDataAccess,
  StockDayData_Load,
  StockDetailDataAccess,
  StockDetailData_Save,
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
    DataSrcId: Integer;
    StockItem: PRT_DealItem;
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
                
procedure PackStockDetailPack_Month(App: TBaseApp; AStockDetailPack_Month: PStockDetailPack_Month);
var
  i, j: integer;                
  tmpMonthDetailData: TStockDetailDataAccess;   
  tmpDayDetailData: TStockDetailDataAccess;
  tmpDayDetailRec: PRT_Quote_M2;
  tmpMonthDetailRec: PRT_Quote_M2;        
begin
  if 0 = AStockDetailPack_Month.Year then
    exit;
  if 0 = AStockDetailPack_Month.Month then
    exit;                           
  if 0 = AStockDetailPack_Month.IsReady then
  begin
    if nil <> AStockDetailPack_Month.StockDetails then
    begin               
      //Log('StockDetail_PackApp.pas', 'PackStockDetailPack_Month' + AStockDetailPack_Month.StockItem.sCode + ':' +
      //   IntToStr(AStockDetailPack_Month.Year) + '/' + IntToStr(AStockDetailPack_Month.Month));  
      AStockDetailPack_Month.StockDetails.Sort;
      tmpMonthDetailData := TStockDetailDataAccess.Create(AStockDetailPack_Month.StockItem, AStockDetailPack_Month.DataSrcId);
      try
        for i := 0 to AStockDetailPack_Month.StockDetails.Count - 1 do
        begin
          tmpDayDetailData := TStockDetailDataAccess(AStockDetailPack_Month.StockDetails.Objects[i]);
          if 0 = tmpMonthDetailData.FirstDealDate then
            tmpMonthDetailData.FirstDealDate := tmpDayDetailData.FirstDealDate;
          tmpMonthDetailData.LastDealDate := tmpDayDetailData.FirstDealDate;
          for j := 0 to tmpDayDetailData.RecordCount - 1 do
          begin
            tmpDayDetailRec := tmpDayDetailData.RecordItem[j];
            
            tmpMonthDetailRec := tmpMonthDetailData.NewRecord(tmpDayDetailRec.DealDateTime.DateValue, tmpDayDetailRec.DealDateTime.TimeValue);
            tmpMonthDetailRec^ := tmpDayDetailRec^; 
          end;
        end;
        //tmpMonthDetailData.Sort;
        //SaveStockDetailData(App, tmpMonthDetailData);
      finally
        tmpMonthDetailData.Free;
      end;
    end;
  end;
end;

procedure StockDetailPack_Item(App: TBaseApp; AStockDayAccess: TStockDayDataAccess; ADataSrcId: Integer); overload;
var
  i: integer;  
  tmpYear, tmpMonth, tmpDay: Word;
  tmpDetailPackData: TStockDetailPack_Month;  
  tmpDetailData: TStockDetailDataAccess;
  tmpIsNew: Boolean;    
  tmpFilePathYear: string;
  tmpFileName: string;
  tmpFileUrl: string;
  tmpDealDay: PRT_Quote_M1_Day;
begin
  FillChar(tmpDetailPackData, SizeOf(tmpDetailPackData), 0);
  tmpDetailPackData.StockItem := AStockDayAccess.StockItem;
  tmpDetailPackData.DataSrcId := ADataSrcId; 
  tmpIsNew := false;
  for i := AStockDayAccess.RecordCount - 1 downto 0 do
  begin
    tmpDealDay := AStockDayAccess.RecordItem[i];
    if 1 > tmpDealDay.DealVolume then
      Continue;
    if 1 > tmpDealDay.DealAmount then
      Continue;

    DecodeDate(tmpDealDay.DealDate.Value, tmpYear, tmpMonth, tmpDay);
    if tmpYear <> tmpDetailPackData.Year then
      tmpIsNew := true;
    if tmpMonth <> tmpDetailPackData.Month then
      tmpIsNew := true;
    if tmpIsNew then
    begin
      PackStockDetailPack_Month(App, @tmpDetailPackData);
      tmpDetailPackData.IsReady := 0;
      tmpDetailPackData.Year := tmpYear;
      tmpDetailPackData.Month := tmpMonth;
      
      DecodeDate(now, tmpYear, tmpMonth, tmpDay);

      if (tmpDetailPackData.Year = tmpYear) and
         (tmpDetailPackData.Month = tmpMonth) then
      begin
        tmpDetailPackData.IsReady := 1;
      end;

      tmpIsNew := false;
      if nil = tmpDetailPackData.StockDetails then
        tmpDetailPackData.StockDetails := TALIntegerList.Create;
      ClearStockDetailPack_Month(@tmpDetailPackData);
    end;      
    if 2016 > tmpDetailPackData.Year then
    begin
      Break;
    end;
    if 0 = tmpDetailPackData.IsReady then
    begin
      tmpFilePathYear := App.Path.GetFilePath(FilePath_DBType_DetailData, ADataSrcId, tmpDealDay.DealDate.Value, AStockDayAccess.StockItem);
      tmpFileName := App.Path.GetFileName(FilePath_DBType_DetailData, ADataSrcId, tmpDealDay.DealDate.Value, AStockDayAccess.StockItem, '');
      if '' <> tmpFileName then
      begin
        tmpFileUrl := tmpFilePathYear + tmpFileName;
        if not FileExists(tmpFileUrl) then
          tmpFileUrl := ChangeFileExt(tmpFileUrl, '.sdet');
        if FileExists(tmpFileUrl) then
        begin
          tmpDetailData := TStockDetailDataAccess.Create(AStockDayAccess.StockItem, ADataSrcId);
          tmpDetailPackData.StockDetails.AddObject(tmpDealDay.DealDate.Value, tmpDetailData);
          
          tmpDetailData.FirstDealDate := tmpDealDay.DealDate.Value;
          tmpDetailData.LastDealDate := tmpDealDay.DealDate.Value;

          LoadStockDetailData(App, tmpDetailData, tmpFileUrl, false);
          if 1 > tmpDetailData.RecordCount then
          begin
            tmpDetailPackData.IsReady := 1;    
            Log('StockDetail_PackApp.pas', 'Load Detail Data Error Data Empty:' +
                AStockDayAccess.StockItem.sCode + ':' +
                FormatDateTime('yyyy-mm-dd', tmpDealDay.DealDate.Value) + ' ' +
                tmpFileUrl);    
            LoadStockDetailData(App, tmpDetailData, tmpFileUrl, true);
          end;
        end else
        begin
          tmpDetailPackData.IsReady := 1; 
          Log('StockDetail_PackApp.pas', 'Load Detail Data Error File not Exists:' +
              AStockDayAccess.StockItem.sCode + ':' +
              FormatDateTime('yyyy-mm-dd', tmpDealDay.DealDate.Value) + ' ' +
              tmpFileUrl);
        end;
      end;
    end;
  end;
end;

procedure StockDetailPack_Item(App: TBaseApp; AStockItem: PRT_DealItem; ADataSrcId: integer); overload;
var
  tmpDayData: TStockDayDataAccess;
begin
  tmpDayData := TStockDayDataAccess.Create(AStockItem, DataSrc_163, false);
  try
    if LoadStockDayData(App, tmpDayData) then
    begin
      StockDetailPack_Item(App, tmpDayData, ADataSrcId);
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
        StockDetailPack_Item(Self, tmpDBStockItem.Items[i], DataSrc_Sina);
        Break;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
