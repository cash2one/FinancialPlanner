unit StockValueApp;

interface

uses
  Forms,
  BaseForm,
  BaseWinApp,
  StockValueData,
  BaseStockApp;

type
  TStockValueAppData = record
    MainForm: TfrmBase;
    StockValueDB: TDBStockValue;
  end;
  
  TStockValueApp = class(TBaseStockApp)
  protected
    fStockValueAppData: TStockValueAppData;
  public   
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;

    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
    
    property StockValueDB: TDBStockValue read fStockValueAppData.StockValueDB; 
  end;  
            
implementation

uses
  SysUtils,
  Define_DataSrc,
  Define_dealStore_File,
  FormStockValue;
  
{ TStockFloatApp }

constructor TStockValueApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fStockValueAppData, SizeOf(fStockValueAppData), 0);
end;

destructor TStockValueApp.Destroy;
begin
  inherited;
end;
           
function TStockValueApp.Initialize: Boolean;
var
  tmpPathUrl: AnsiString;
  tmpFileUrl: AnsiString;
begin
  inherited Initialize;
  Result := false;
  InitializeDBStockItem;
  if nil <> fBaseStockAppData.StockItemDB then
  begin
    if 0 < fBaseStockAppData.StockItemDB.RecordCount then
    begin
      fStockValueAppData.StockValueDB := TDBStockValue.Create(DataSrc_163);
      
      tmpPathUrl := Path.DataBasePath[FilePath_DBType_ValueData, 0];
      tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', now()), 5, MaxInt) + '.' + FileExt_StockValue;
      if FileExists(tmpFileUrl) then
      begin
        LoadDBStockValue(fBaseStockAppData.StockItemDB, fStockValueAppData.StockValueDB, tmpFileUrl);
      end;
      
      Application.Initialize;
      Result := true;
    end;
  end;
end;

procedure TStockValueApp.Finalize;
begin
  inherited;
end;

procedure TStockValueApp.Run;
begin
  inherited;
  //ShowAmountRateWindow;
  Application.CreateForm(TfrmStockValue, fStockValueAppData.MainForm);
  fStockValueAppData.MainForm.Initialize(Self);
  Application.Run;
end;

end.
