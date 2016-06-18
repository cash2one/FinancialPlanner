unit define_StockDataApp;

interface

uses
  windef_msg;
                 
const
  WM_Console2Downloader_Base = WM_CustomAppBase + 100;
  WM_Console2Downloader_Command_Download = WM_Console2Downloader_Base + 1;
                                                
  WM_Console_Base = WM_CustomAppBase + 200;   
                                             
  WM_Downloader2Console_Base = WM_CustomAppBase + 300;
  WM_Downloader2Console_Command_DownloadOK = WM_Downloader2Console_Base + 1;

  WM_Downloader_Base = WM_CustomAppBase + 400;   
  WM_Downloader_Command_Download = WM_Downloader_Base + 1;
  
type      
  TStockDataAppRunMode = (
    runMode_Undefine,
    runMode_Console,
    runMode_DataDownloader);

implementation

end.
