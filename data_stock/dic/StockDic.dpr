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
  DefineSys in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\DefineBase\DefineSys.pas',
  Define_StockItem in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_StockItem.pas',
  Define_Price in '..\..\basedefine\Define_Price.pas',
  Define_Store_Header in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_Header.pas',
  Define_DealMarket in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_DealMarket.pas',
  Define_Store_File in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_File.pas',
  DB_StockItem in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockItem\DB_StockItem.pas',
  DB_StockItem_Save in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockItem\DB_StockItem_Save.pas',
  DB_StockItem_LoadIni in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockItem\DB_StockItem_LoadIni.pas',
  DB_StockItem_Load in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockItem\DB_StockItem_Load.pas',
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
