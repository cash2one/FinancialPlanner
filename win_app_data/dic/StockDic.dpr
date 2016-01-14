program StockDic;

uses
  Forms,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\win_base\BaseDataSet.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseFile in '..\..\..\devwintech\v0000\win_base\BaseFile.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_Save in '..\..\dealitem\db_dealitem_Save.pas',
  db_dealitem_loadIni in '..\..\dealitem\db_dealitem_loadIni.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
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
