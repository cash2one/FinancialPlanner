program stockValue;

uses
  Windows,
  HttpUtils in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseNet\HttpUtils.pas',
  Http_Indy in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseNet\Http_Indy.pas',
  StockValueApp in 'StockValueApp.pas',
  FormStockValue in 'FormStockValue.pas' {frmStockValue},
  StockValueData in 'StockValueData.pas',
  BaseForm in '..\..\..\devwintech\v0000\win_base\BaseForm.pas' {frmBase},
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\win_base\BaseDataSet.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  define_price in '..\..\basedefine\define_price.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseFile in '..\..\..\devwintech\v0000\win_base\BaseFile.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  QuickList_Int64 in '..\..\..\devwintech\comps\list\QuickList_Int64.pas';

{$R *.res}
        
var
  GlobalApp: TStockValueApp = nil;
begin
  GlobalApp := TStockValueApp.Create('');
  try
    if GlobalApp.Initialize then
    begin
      GlobalApp.Run;
    end;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
