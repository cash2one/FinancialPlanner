unit bdzxAnalysisWinApp;

interface

uses
  BaseWinApp,
  BaseStockApp,
  StockInstantDataAccess;

type
  TBdzxAnalysisApp = class(TBaseStockApp)
  protected
    fLastStockInstant: TDBStockInstant;
    fCurrentStockInstant: TDBStockInstant;
  public   
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;

    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;  
    property LastStockInstant: TDBStockInstant read fLastStockInstant;
    property CurrentStockInstant: TDBStockInstant read fCurrentStockInstant;
  end;  

var
  GlobalApp: TBdzxAnalysisApp = nil;
  
implementation

uses
  SysUtils,
  define_datasrc,
  define_dealstore_file,
  bdzxAnalysisWindow;
  
{ TStockFloatApp }

constructor TBdzxAnalysisApp.Create(AppClassId: AnsiString);
begin
  inherited;
  fLastStockInstant := nil;
  fCurrentStockInstant := nil;
end;

destructor TBdzxAnalysisApp.Destroy;
begin
  inherited;
end;
           
function TBdzxAnalysisApp.Initialize: Boolean;
var
  tmpPathUrl: AnsiString;
  tmpFileUrl: AnsiString;
  tmpDay: Integer;
  tmpDayOfWeek: Integer;
  i: integer;
begin
  inherited Initialize;
  Result := false;
  InitializeDBStockItem;
  if nil <> fBaseStockAppData.StockItemDB then
  begin
    if 0 < fBaseStockAppData.StockItemDB.RecordCount then
    begin
      fLastStockInstant := TDBStockInstant.Create(DataSrc_Sina);
      tmpDay := Trunc(now()) - 1;
      tmpDayOfWeek := DayOfWeek(tmpDay);
      if 1 = tmpDayOfWeek then
        tmpDay := tmpDay - 2;
      if 6 = tmpDayOfWeek then
        tmpDay := tmpDay - 1;
      tmpPathUrl := Self.Path.DataBasePath[FilePath_DBType_InstantData, 0];
      tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', tmpDay), 5, MaxInt) + '.' + FileExt_StockInstant;
      if not FileExists(tmpFileUrl) then
      begin
        tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', tmpDay), 7, MaxInt) + '.' + FileExt_StockInstant;
      end;
      if FileExists(tmpFileUrl) then
      begin
        LoadDBStockInstant(fBaseStockAppData.StockItemDB, fLastStockInstant, tmpFileUrl);
        if 0 < fLastStockInstant.RecordCount then
        begin
          fCurrentStockInstant := TDBStockInstant.Create(DataSrc_Sina);
          for i := 0 to StockItemDB.RecordCount - 1 do
          begin
            if 0 <> StockItemDB.Items[i].EndDealDate then
              Continue;
            fCurrentStockInstant.AddItem(StockItemDB.Items[i]);
          end;
          Result := CreateAmountRateWindow(Self);
        end;
      end;
    end;
  end;
end;

procedure TBdzxAnalysisApp.Finalize;
begin
  if nil <> fCurrentStockInstant then
    FreeAndNil(fCurrentStockInstant);
  if nil <> fLastStockInstant then
    FreeAndNil(fLastStockInstant);
  inherited;
end;

procedure TBdzxAnalysisApp.Run;
begin
  inherited;
  ShowAmountRateWindow;
  RunAppMsgLoop;
end;

end.
