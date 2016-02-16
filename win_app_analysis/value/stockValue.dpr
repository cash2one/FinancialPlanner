program stockValue;

uses
  Windows,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int64 in '..\..\..\devwintech\comps\list\QuickList_Int64.pas',
  VirtualTrees in '..\..\..\devdcomps\virtualtree\VirtualTrees.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BaseFile in '..\..\..\devwintech\v0000\app_base\BaseFile.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  BaseForm in '..\..\..\devwintech\v0000\win_ui\BaseForm.pas' {frmBase},
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  FormStockValue in 'FormStockValue.pas' {frmStockValue},
  StockValueApp in 'StockValueApp.pas',
  StockValueData in 'StockValueData.pas';

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
