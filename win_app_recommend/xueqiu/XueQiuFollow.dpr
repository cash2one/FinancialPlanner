program XueQiuFollow;

uses
  BaseWinThread in '..\..\..\devwintech\v0000\win_base\BaseWinThread.pas',
  UIBaseWndProc in '..\..\..\devwintech\v0000\win_base\UIBaseWndProc.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  UIBaseWin in '..\..\..\devwintech\v0000\win_base\UIBaseWin.pas',
  UIBaseWinMemDC in '..\..\..\devwintech\v0000\win_base\UIBaseWinMemDC.pas',
  UIWinColor in '..\..\..\devwintech\v0000\win_base\UIWinColor.pas',

  Define_Message in '..\..\..\devwintech\v0000\win_basedefine\Define_Message.pas',
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',

  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',

  WinSock2 in '..\..\..\litwrd_git\Common\WinSock2.pas',
  AppWindow in '..\..\..\litwrd_git\AppStock\base\AppWindow.pas',
  BaseFloatWindow in '..\..\..\litwrd_git\AppStock\base\BaseFloatWindow.pas',
  CmdWindow in '..\..\..\litwrd_git\AppStock\base\CmdWindow.pas',
  BaseDataIO in '..\..\..\litwrd_git\AppStock\base\BaseDataIO.pas',
  NetBase in '..\..\..\litwrd_git\AppStock\base\net\NetBase.pas',
  NetMgr in '..\..\..\litwrd_git\AppStock\base\net\NetMgr.pas',
  NetClientIocpProc in '..\..\..\litwrd_git\AppStock\base\net\NetClientIocpProc.pas',
  NetObjClientIocp in '..\..\..\litwrd_git\AppStock\base\net\NetObjClientIocp.pas',
  NetObjClient in '..\..\..\litwrd_git\AppStock\base\net\NetObjClient.pas',
  NetHttpClient in '..\..\..\litwrd_git\AppStock\base\net\NetHttpClient.pas',
  NetObjClientProc in '..\..\..\litwrd_git\AppStock\base\net\NetObjClientProc.pas',
  NetHttpClientProc in '..\..\..\litwrd_git\AppStock\base\net\NetHttpClientProc.pas',
  HttpProtocol in '..\..\..\litwrd_git\AppStock\base\net\HttpProtocol.pas',
  uiwin_memdc in '..\..\..\litwrd_git\AppStock\win_base\uiwin_memdc.pas',
  def_basemessage in '..\..\..\litwrd_git\AppStock\win_base\def_basemessage.pas',
  zsHelperMessage in '..\..\..\litwrd_git\AppStock\win_deal_zshelper\zsHelperMessage.pas',
  XueQiuInfoAppWindow2 in 'XueQiuInfoAppWindow2.pas',
  XueQiuInfoApp in 'XueQiuInfoApp.pas',
  superobject2_define in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\superobject2_define.pas',
  superobject2_avl in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\superobject2_avl.pas',
  superobject2_write in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\superobject2_write.pas',
  superobject2_Tokenizer in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\superobject2_Tokenizer.pas',
  superobject2_jsonobj in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\superobject2_jsonobj.pas',
  JsonTestData in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\JsonTestData.pas',
  xlJsonObject in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\xlJsonObject.pas',
  xlDataType in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\xlDataType.pas',
  xlCharset in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\xlCharset.pas',
  xlCharsetW in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\xlCharsetW.pas',
  superobject2_parse in '..\..\..\litwrd_git\AppStock\win_xueqiuInfo\Json\superobject2_parse.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_price in '..\..\basedefine\define_price.pas';

{$R *.res}

begin
  GlobalApp := TXueQiuInfoApp.Create('xueqiufollow');
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
