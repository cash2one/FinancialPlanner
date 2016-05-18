program StockDic;

uses
  Forms,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  VirtualTrees in '..\..\..\devdcomps\virtualtree\VirtualTrees.pas',
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase}, 
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',    
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_Save in '..\..\dealitem\db_dealitem_Save.pas',
  db_dealitem_loadIni in '..\..\dealitem\db_dealitem_loadIni.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  DealItemsTreeView in '..\..\stockview\DealItemsTreeView.pas',
  StockDicForm in 'StockDicForm.pas' {frmStockDic};

{$R *.res}

begin
  GlobalApp := TStockDicApp.Create('');
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
