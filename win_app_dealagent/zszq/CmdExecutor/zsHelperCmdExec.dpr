program zsHelperCmdExec;

uses
  Messages,
  BaseApp in '..\..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BasePath in '..\..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseThread in '..\..\..\..\devwintech\v0000\app_base\BaseThread.pas',
  BaseRun in '..\..\..\..\devwintech\v0000\app_base\BaseRun.pas',
  BaseWinApp in '..\..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  Define_String in '..\..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  Define_Message in '..\..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  win.wnd_cmd in '..\..\..\..\devwintech\v0000\win_system\win.wnd_cmd.pas',
  win.thread in '..\..\..\..\devwintech\v0000\win_system\win.thread.pas',
  UtilsWindows in '..\..\..\..\devwintech\v0000\win_utils\UtilsWindows.pas',
  define_price in '..\..\..\basedefine\define_price.pas',
  zsVariants in '..\zsVariants.pas',
  zsLoginUtils in '..\zsLoginUtils.pas',
  zsLoginWindow in '..\zsLoginWindow.pas',
  zsMainWindow in '..\zsMainWindow.pas',
  zsProcess in '..\zsProcess.pas',
  zsAttach in '..\zsAttach.pas',
  zsHelperMessage in '..\zsHelperMessage.pas',
  zsHelperDefine in '..\zsHelperDefine.pas',
  zsDialogUtils in '..\zsDialogUtils.pas',
  zsHelperCmdExecApp in 'zsHelperCmdExecApp.pas';

{$R *.res}

begin
  RunApp(TzsHelperCmdExecApp, 'zsHelperCmdExecApp', TBaseApp(GlobalApp));
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
