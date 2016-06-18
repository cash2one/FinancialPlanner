unit StockDataConsoleApp;

interface

uses
  BaseApp,
  BaseForm,
  Forms,
  win.process;
  
type
  PConsoleAppData = ^TConsoleAppData;
  TConsoleAppData = record
    ConsoleForm: BaseForm.TfrmBase;
    Downloader_Process: win.process.TOwnedProcess;
    Download_DealItemIndex: Integer;     
    Download_DealItemCode: Integer;
  end;

  TStockDataConsoleApp = class(BaseApp.TBaseAppAgent)
  protected
  public
    function Initialize: Boolean; override;
  end;
  
implementation

{ TStockDataConsoleApp }

function TStockDataConsoleApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then
  begin
    Application.Initialize;
  end;
end;

end.
