program dealHistory;

uses
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0000\win_ui\BaseForm.pas' {frmBase},
  FormFunctionsTab in '..\..\..\devwintech\v0000\win_ui\FormFunctionsTab.pas' {frmFunctionsTab},
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
