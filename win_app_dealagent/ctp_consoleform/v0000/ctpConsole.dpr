program ctpConsole;

uses
  Forms,
  BaseApp in '..\..\..\..\devwintech\v0000\app_base\BaseApp.pas',
  BaseThread in '..\..\..\..\devwintech\v0000\app_base\BaseThread.pas',
  BaseRun in '..\..\..\..\devwintech\v0000\app_base\BaseRun.pas',
  BasePath in '..\..\..\..\devwintech\v0000\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BaseWinProcess in '..\..\..\..\devwintech\v0000\win_base\BaseWinProcess.pas',
  BaseMemory in '..\..\..\..\devwintech\v0000\win_base\BaseMemory.pas',
  Define_String in '..\..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  Define_Message in '..\..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  BaseForm in '..\..\..\..\devwintech\v0000\win_ui\BaseForm.pas' {frmBase},
  FormFunctionsTab in '..\..\..\..\devwintech\v0000\win_ui\FormFunctionsTab.pas' {frmFunctionsTab},
  UtilsWindows in '..\..\..\..\devwintech\v0000\win_utils\UtilsWindows.pas',
  UtilsLog in '..\..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  UtilsApplication in '..\..\..\..\devwintech\v0000\win_utils\UtilsApplication.pas',
  define_price in '..\..\..\basedefine\define_price.pas',
  ThostFtdcTraderApiDataType in '..\..\ctp_agent\v0000\ApiSDK1\ThostFtdcTraderApiDataType.pas',
  ThostFtdcTraderApiDataDefine in '..\..\ctp_agent\v0000\ApiSDK1\ThostFtdcTraderApiDataDefine.pas',
  ThostFtdcMdApiDataType in '..\..\ctp_agent\v0000\ApiSDK1\ThostFtdcMdApiDataType.pas',
  ThostFtdcBaseDataType in '..\..\ctp_agent\v0000\ApiSDK1\ThostFtdcBaseDataType.pas',
  ThostFtdcUserApiDataType in '..\..\ctp_agent\v0000\ApiSDK1\ThostFtdcUserApiDataType.pas',
  ctpConsoleApp in 'ctpConsoleApp.pas',
  ctpDealForm in 'ctpDealForm.pas' {frmCtpDeal},
  ctpQuoteForm in 'ctpQuoteForm.pas' {frmCtpQuote},
  TcpAgentConsole in 'TcpAgentConsole.pas',
  TcpQuoteAgent in 'TcpQuoteAgent.pas',
  TcpDealAgent in 'TcpDealAgent.pas',
  ctpConsoleAppCommandWnd in 'ctpConsoleAppCommandWnd.pas',
  ctpConsoleAppCommandWnd_CopyData in 'ctpConsoleAppCommandWnd_CopyData.pas',
  define_ctp_quote in 'define_ctp_quote.pas',
  define_ctp_deal in 'define_ctp_deal.pas';

{$R *.res}

begin
  RunApp(TctpConsoleApp, 'ctpConsoleApp', TBaseApp(GlobalApp));
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
