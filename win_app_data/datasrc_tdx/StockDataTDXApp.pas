unit StockDataTDXApp;

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
  TStockDataTdxAppData = record
    //AppAgent: TBaseAppAgent;
    MainForm: TfrmBase;
  end;
  
  TStockDataTdxApp = class(TBaseStockApp)
  protected
    fStockDataTdxAppData: TStockDataTdxAppData;
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
  SDTdxForm,
  Define_Price,
  db_dealitem,
  Define_DataSrc,
  win.iobuffer,
  UtilsLog,
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  define_stock_quotes,
  DB_dealItem_Load,
  DB_dealItem_Save;

{ TStockDataApp }

constructor TStockDataTdxApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fStockDataTdxAppData, SizeOf(fStockDataTdxAppData), 0);
end;

function TStockDataTdxApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    //Result := CheckSingleInstance(AppMutexName_StockDataTdxer);
    if Result then
    begin
      //InitializeDBStockItem;
      //Result := 0 < Self.StockItemDB.RecordCount;
      if Result then
      begin                        
      end;
    end;
  end;
end;

procedure TStockDataTdxApp.Finalize;
begin
end;

procedure TStockDataTdxApp.RunStart;
begin
end;

procedure TStockDataTdxApp.Run;
begin
  Application.CreateForm(SDTdxForm.TfrmSDTdx, fStockDataTdxAppData.MainForm);
  Application.Run;
end;

end.
