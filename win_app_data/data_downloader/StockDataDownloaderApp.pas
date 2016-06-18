unit StockDataDownloaderApp;

interface

uses
  UtilsHttp,
  BaseApp,
  win.process;

type
  PDownloaderAppData = ^TDownloaderAppData;
  TDownloaderAppData = record
    Console_Process: TExProcess;
    HttpClientSession: THttpClientSession;
  end;
               
  TStockDataDownloaderApp = class(BaseApp.TBaseAppAgent)
  protected
  public
  end;
  
implementation

end.
