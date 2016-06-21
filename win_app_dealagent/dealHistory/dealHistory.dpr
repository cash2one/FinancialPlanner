program dealHistory;

uses            
  QuickList_int in '..\..\..\devwintech\comps\list\QuickList_int.pas',
  QuickList_double in '..\..\..\devwintech\comps\list\QuickList_double.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  VirtualTrees in '..\..\..\devdcomps\virtualtree\VirtualTrees.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  FormFunctionsTab in '..\..\..\devwintech\v0001\obj\win_uiform\FormFunctionsTab.pas' {frmFunctionsTab},
  define_deal in '..\..\basedefine\define_deal.pas',
  define_price in '..\..\basedefine\define_price.pas',
  dealHistoryForm in 'dealHistoryForm.pas' {frmDealHistory},
  dealHistoryApp in 'dealHistoryApp.pas';

{$R *.res}

begin
  RunApp(TdealHistoryApp, 'dealHistoryApp', TBaseApp(GlobalApp));
//  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
////  Application.CreateForm(TfrmDealHistory, frmDealHistory);
//  Application.Run;
end.
