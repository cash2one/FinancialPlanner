program zsHelper;

uses
  Forms,
  BaseWinThread in '..\..\devwintech\v0000\win_base\BaseWinThread.pas',
  BaseForm in '..\..\devwintech\v0000\win_base\BaseForm.pas' {frmBase},
  BaseApp in '..\..\devwintech\v0000\win_base\BaseApp.pas',
  BasePath in '..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseWinApp in '..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  Define_String in '..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  Define_Message in '..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  UtilsWindows in '..\..\devwintech\v0000\win_utils\UtilsWindows.pas',
  UtilsApplication in '..\..\devwintech\v0000\win_utils\UtilsApplication.pas',
  define_price in '..\basedefine\define_price.pas',
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
