unit StockDataPackerApp;

interface

uses
  define_stockapp,  
  define_dealItem,
  windef_msg, 
  win.process,
  BaseApp,
  Forms,
  BaseForm,
  BaseStockApp;

type
  TStockDataPackerAppData = record
    //AppAgent: TBaseAppAgent;
    PackerConsoleForm: TfrmBase;
  end;
  
  TStockDataPackerApp = class(TBaseStockApp)
  protected
    fStockDataPackerAppData: TStockDataPackerAppData;
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
  SDPackerForm,
  Define_Price,
  db_dealitem,
  Define_DataSrc,
  win.iobuffer,
  //UtilsLog,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
  DB_dealItem_Load,
  DB_dealItem_Save;

{ TStockDataApp }

constructor TStockDataPackerApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fStockDataPackerAppData, SizeOf(fStockDataPackerAppData), 0);
end;

function TStockDataPackerApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    Result := CheckSingleInstance(AppMutexName_StockDataPacker);
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

procedure TStockDataPackerApp.Finalize;
begin
end;

procedure TStockDataPackerApp.RunStart;
begin
end;

procedure TStockDataPackerApp.Run;
begin
  Application.CreateForm(SDPackerForm.TfrmSDPacker, fStockDataPackerAppData.PackerConsoleForm);
  Application.Run;
end;

end.
