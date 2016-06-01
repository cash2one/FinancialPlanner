unit industryClass_get_sina;

interface

uses
  BaseApp;

  procedure GetIndustryClass_Sina(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  win.iobuffer,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,     
  UtilsDateTime,

  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;

(*                            
  ======================================================
  ������ҵ
  ������ҵ
  ֤�����ҵ          
  ======================================================
  http://vip.stock.finance.sina.com.cn/mkt/#hangye_ZA01 ũҵ
  http://vip.stock.finance.sina.com.cn/mkt/#hangye_ZC0
  
  ======================================================
  ������
  ======================================================
  #���ܵ���#�ƺ�����#��Ͽ����#��������#��·����#������
  #��������#�ƽ����#��Ͷ����#ST���#��̼����#��H��
  #��B��#���¹�#����תծ#ϡȱ��Դ#������ȯ#�����ں�#�人�滮
  #�ྦྷ��#﮵��#ϡ������#�˵����#������#ˮ������#����̶
  #�����#̫����#���ǵ���#�Ƽ���#����֧��#������#����װ��
  #���Ϸ�#������#���ڸĸ�#ҳ����#��������#�Ļ�����#�������
  #IPV6����#ʳƷ��ȫ#�ݳ�Ʒ#ͼ�ǽ�#��ɳ����#3D��ӡ#��ˮ����
  #̼��ά#������#ժñ����#ƻ������#�������#��������#��������
  #���ܽ�ͨ#��������#���׮#4G����#ʯīϩ#��ɳ����#������ת
  #�۰���#��������#������ó#˿��֮·#��������#���ʸ���#O2Oģʽ
  #��˹��#��̬ũҵ#ˮ��ĸ�#����#ȼ�ϵ��#�ݸ��#����#���۰�
  #�������#�������#����˿·#����#������#ά����#ũ�����
  #��������#�̷ϴ���#װ��԰��#�������#����#����#��ˮ����
  #�������#�������#���̸���#����оƬ#��ȼ��#����ĸ�
  #��������#���ܼҾ�#����ʯ#���ܻ���#�����˸���#�����ó
  #��Ϣ��ȫ#�����ĸ�#��ӪҽԺ#���ϸ���#��Ӫ����#Ӥͯ����
  #�㶫��ó#�Ϻ���ó#��������#������Ϸ#���ܴ���#ǰ������
  #��ɫ����#���ܸ���#��������#��ó�滮#����ȼ��#׼ST��
  #ҵ��Ԥ��#ҵ��Ԥ��#��תǱ��#��У����#���ܻ���#�¸���
  #��ó��#�պ�ó��#���ʱ���#��������#���½��#���ڲι�
  #�籣�ز�#�����ز�#�����ز�#ȯ���ز�#QFII�ز�#��ѡָ��
  #�ֲ�����#����ϸ��#Ȩ֤��#�Ϻ�����#���ڱ���#��������
  #�غ���չ#����50#������#�ιɽ���#�����ز�#���ڸ���#��Ȩ����
  #��������#��ʿ��#������˰#����Դ#δ�ɸ�#ѭ������#�ʲ�ע��
  ======================================================
  ������
  ======================================================
*)
procedure GetIndustryClass_Sina(App: TBaseApp);
var
  tmpUrl: AnsiString;
  tmpHttpClientSession: THttpClientSession;
  tmpHttpData: PIOBuffer;
  tmpHttpHead: THttpHeadParseSession;
  tmpStrs: TStringList;
begin
  // http://vip.stock.finance.sina.com.cn/mkt            
  tmpUrl := 'http://vip.stock.finance.sina.com.cn/mkt'; // --> 301
  tmpUrl := 'http://vip.stock.finance.sina.com.cn/mkt/'; // --> 200
  tmpUrl := 'http://vip.stock.finance.sina.com.cn/mkt/#sw_qgzz';
  tmpUrl := 'http://vip.stock.finance.sina.com.cn/quotes_service/' +
      'api/json_v2.php/Market_Center.getHQNodeStockCount?node=gn_jght';
  tmpUrl := 'http://vip.stock.finance.sina.com.cn/quotes_service/' +
      'api/json_v2.php/Market_Center.getHQNodeData?page=1&num=40&sort=symbol&asc=1&node=gn_jght&symbol=&_s_r_a=init';
  (*//
  //tmpUrl := 'http://stock.finance.sina.com.cn/yuanchuang/api/jsonp.json/IO.XSRV2.CallbackList[''5CULssnjh8Scn80w'']/
  StockMarket_Service.getSelectInfo?num=20';
  //*)
  FillChar(tmpHttpClientSession, SizeOf(tmpHttpClientSession), 0);
  tmpHttpClientSession.IsKeepAlive := True;
  tmpHttpData := GetHttpUrlData(tmpUrl, @tmpHttpClientSession);
  if nil <> tmpHttpData then
  begin
    try
      HttpBufferHeader_Parser(tmpHttpData, @tmpHttpHead);
      if 200 = tmpHttpHead.RetCode then
      begin
        tmpStrs := TStringList.Create;
        try
          tmpStrs.Text := AnsiString(PAnsiChar(@tmpHttpData.Data[tmpHttpHead.HeadEndPos + 1]));
          tmpStrs.SaveToFile('e:\sina_mkt.html');
        finally
          tmpStrs.Free;
        end;  
      end;
    finally
      CheckInIOBuffer(tmpHttpData);
    end;
  end;
end;

end.
