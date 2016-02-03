program sygwHelper;

uses
  Forms,
  BaseApp in '..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  Define_Message in '..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  BaseForm in '..\..\..\devwintech\v0000\win_ui\BaseForm.pas' {frmBase},
  UtilsWindows in '..\..\..\devwintech\v0000\win_utils\UtilsWindows.pas',
  UtilsApplication in '..\..\..\devwintech\v0000\win_utils\UtilsApplication.pas',
  define_price in '..\..\basedefine\define_price.pas',
  sygwVariants in 'sygwVariants.pas',
  sygwLoginUtils in 'sygwLoginUtils.pas',
  sygwHelperForm in 'sygwHelperForm.pas' {frmZSHelper},
  sygwLoginWindow in 'sygwLoginWindow.pas',
  sygwMainWindow in 'sygwMainWindow.pas',
  exProcess in '..\exProcess.pas',
  zsHelperMessage in '..\zszq\zsHelperMessage.pas',
  sygwAttach in 'sygwAttach.pas',
  sygwHelperApp in 'sygwHelperApp.pas';

{$R *.res}

begin
  RunApp(TswHelperApp, 'zshelperApp', TBaseApp(GlobalApp));
//  GlobalApp := TzsHelperApp.Create('zshelperApp');
//  try
//    if GlobalApp.Initialize then
//    begin
//      GlobalApp.Run;
//    end;
//    GlobalApp.Finalize;
//  finally
//    GlobalApp.Free;
//  end;
end.
