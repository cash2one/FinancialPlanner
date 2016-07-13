program zsHelper;

uses
  Forms,                                                          
  windef_msg in '..\..\..\devwintech\v0001\windef\windef_msg.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  UtilsWindows in '..\..\..\devwintech\v0000\win_utils\UtilsWindows.pas',
  UtilsApplication in '..\..\..\devwintech\v0000\win_utils\UtilsApplication.pas',
  define_price in '..\..\basedefine\define_price.pas',
  zsVariants in 'zsVariants.pas',
  zsLoginUtils in 'zsLoginUtils.pas',
  zsHelperForm in 'zsHelperForm.pas' {frmZSHelper},
  zsLoginWindow in 'zsLoginWindow.pas',
  zsMainWindow in 'zsMainWindow.pas',
  zsProcess in 'zsProcess.pas',
  zsAttach in 'zsAttach.pas',
  zsHelperApp in 'zsHelperApp.pas',
  zsHelperMessage in 'zsHelperMessage.pas';

{$R *.res}

begin
  RunApp(TzsHelperApp, 'zshelperApp', TBaseApp(GlobalApp));
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
