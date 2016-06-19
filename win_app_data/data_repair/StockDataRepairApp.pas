unit StockDataRepairApp;

interface

uses
  define_stockapp,  
  define_dealItem,
  windef_msg, 
  UtilsHttp,
  win.process,
  BaseApp,
  Forms,
  BaseForm,
  BaseStockApp;

type
  TStockDataRepairAppData = record
    AppAgent: TBaseAppAgent;
    RepairConsoleForm: TfrmBase;
  end;
  
  TStockDataRepairApp = class(TBaseStockApp)
  protected
    fStockDataRepairAppData: TStockDataRepairAppData;
    procedure RunStart;    
  public
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;   
    function Initialize: Boolean; override;
    procedure Finalize; override;
  end;

implementation

uses
  Windows,
  Sysutils,
  Classes,
  SDRepairForm,
  Define_Price,
  db_dealitem,
  Define_DataSrc,
  StockDayData_Get_163,
  win.iobuffer,
  UtilsLog,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
  DB_dealItem_Load,
  DB_dealItem_Save;

{ TStockDataApp }

constructor TStockDataRepairApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fStockDataRepairAppData, SizeOf(fStockDataRepairAppData), 0);
end;

function TStockDataRepairApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    Result := CheckSingleInstance(AppMutexName_StockDataRepairer);
    if Result then
    begin
      InitializeDBStockItem;
      Result := 0 < Self.StockItemDB.RecordCount;
      if Result then
      begin                        
      end;
    end;
  end;
end;

procedure TStockDataRepairApp.Finalize;
begin
end;

procedure TStockDataRepairApp.RunStart;
begin
end;

procedure TStockDataRepairApp.Run;
begin
  Application.CreateForm(SDRepairForm.TfrmSDRepair, fStockDataRepairAppData.RepairConsoleForm);
  Application.Run;
end;

end.
