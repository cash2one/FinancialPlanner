program AnalysisBdzx;

uses
  Windows,
  WinSock2 in '..\..\..\devwintech\common\WinSock2.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickList_double in '..\..\..\devwintech\comps\list\QuickList_double.pas',
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  windef_msg in '..\..\..\devwintech\v0001\windef\windef_msg.pas',
  Base.Run in '..\..\..\devwintech\v0001\rec\app_base\Base.Run.pas',
  base.thread in '..\..\..\devwintech\v0001\rec\app_base\base.thread.pas',
  win.thread in '..\..\..\devwintech\v0001\rec\win_sys\win.thread.pas',
  win.diskfile in '..\..\..\devwintech\v0001\rec\win_sys\win.diskfile.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseThread in '..\..\..\devwintech\v0001\obj\app_base\BaseThread.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  ui.color in '..\..\..\devwintech\v0000\uibase\ui.color.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  win.iobuffer in '..\..\..\devwintech\v0000\win_data\win.iobuffer.pas',
  uiwin.memdc in '..\..\..\devwintech\v0000\win_ui\uiwin.memdc.pas',
  uiwin.gdi in '..\..\..\devwintech\v0000\win_ui\uiwin.gdi.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  Rule_BDZX in '..\..\baserule\Rule_BDZX.pas',
  Rule_STD in '..\..\baserule\Rule_STD.pas',
  Rule_EMA in '..\..\baserule\Rule_EMA.pas',
  BaseRule in '..\..\baserule\BaseRule.pas',
  bdzxAnalysisWinApp in 'bdzxAnalysisWinApp.pas',
  bdzxAnalysisWindow in 'bdzxAnalysisWindow.pas',
  bdzxAnalysisForm in 'bdzxAnalysisForm.pas' {frmBdzxAnalysis},
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas';

{$R *.res}

begin
  GlobalApp := TBdzxAnalysisApp.Create('');
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
