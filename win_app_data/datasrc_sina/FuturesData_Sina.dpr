program FuturesData_Sina;

uses
  Windows,
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseFile in '..\..\..\devwintech\v0000\app_base\BaseFile.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BaseRun in '..\..\..\devwintech\v0000\app_base\BaseRun.pas',
  BaseThread in '..\..\..\devwintech\v0000\app_base\BaseThread.pas',
  BaseWinThread in '..\..\..\devwintech\v0000\win_base\BaseWinThread.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  UtilsHttp in '..\..\..\devwintech\v0000\win_utils\UtilsHttp.pas',
  UtilsHttp_Indy in '..\..\..\devwintech\v0000\win_utils\UtilsHttp_Indy.pas',
  UtilsHtmlParser in '..\..\..\devwintech\v0000\win_utils\UtilsHtmlParser.pas',
  UtilsDateTime in '..\..\..\devwintech\v0000\win_utils\UtilsDateTime.pas',
  BaseFutureApp in '..\..\base\BaseFutureApp.pas',
  FutureAppPath in '..\..\base\FutureAppPath.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_futures_quotes in '..\..\basedefine\define_futures_quotes.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem_save in '..\..\dealitem\db_dealitem_save.pas',
  FuturesDataAccess in '..\..\data_futures\FuturesDataAccess.pas',
  FuturesData_Load in '..\..\data_futures\FuturesData_Load.pas',
  FuturesData_Save in '..\..\data_futures\FuturesData_Save.pas',
  FuturesData_Get_Sina in '..\..\data_futures\datasrc_sina\FuturesData_Get_Sina.pas',
  Futures_Get_Sina in 'Futures_Get_Sina.pas';

{$R *.res}

type
  TFuturesSinaApp = class(TBaseFutureApp)
  protected
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
  end;

constructor TFuturesSinaApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

procedure TFuturesSinaApp.Run;
begin
  GetFuturesData_Sina_All(Self);
end;

var
  GlobalApp: TFuturesSinaApp;
begin
  GlobalApp := TFuturesSinaApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.