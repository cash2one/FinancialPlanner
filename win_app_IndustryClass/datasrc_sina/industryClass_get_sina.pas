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
  新浪行业
  申万行业
  证监会行业          
  ======================================================
  http://vip.stock.finance.sina.com.cn/mkt/#hangye_ZA01 农业
  http://vip.stock.finance.sina.com.cn/mkt/#hangye_ZC0
  
  ======================================================
  概念板块
  ======================================================
  #智能电网#黄河三角#海峡西岸#成渝特区#铁路基建#物联网
  #军工航天#黄金概念#创投概念#ST板块#低碳经济#含H股
  #含B股#次新股#含可转债#稀缺资源#融资融券#三网融合#武汉规划
  #多晶硅#锂电池#稀土永磁#核电核能#触摸屏#水利建设#长株潭
  #皖江区域#太阳能#卫星导航#云计算#电子支付#新三板#海工装备
  #保障房#涉矿概念#金融改革#页岩气#生物疫苗#文化振兴#宽带提速
  #IPV6概念#食品安全#奢侈品#图们江#三沙概念#3D打印#海水淡化
  #碳纤维#地热能#摘帽概念#苹果概念#重组概念#安防服务#建筑节能
  #智能交通#空气治理#充电桩#4G概念#石墨烯#风沙治理#土地流转
  #聚氨酯#生物质能#东亚自贸#丝绸之路#体育概念#博彩概念#O2O模式
  #特斯拉#生态农业#水域改革#风能#燃料电池#草甘膦#京津冀#粤港澳
  #基因概念#阿里概念#海上丝路#抗癌#抗流感#维生素#农村金融
  #汽车电子#固废处理#装饰园林#赛马概念#猪肉#节能#污水处理
  #国产软件#基因测序#电商概念#基因芯片#氢燃料#国企改革
  #超导概念#智能家居#蓝宝石#智能机器#机器人概念#天津自贸
  #信息安全#油气改革#民营医院#养老概念#民营银行#婴童概念
  #广东自贸#上海自贸#互联金融#网络游戏#智能穿戴#前海概念
  #绿色照明#风能概念#生物育种#内贸规划#生物燃料#准ST股
  #业绩预降#业绩预升#送转潜力#高校背景#节能环保#陕甘宁
  #自贸区#日韩贸易#外资背景#整体上市#本月解禁#金融参股
  #社保重仓#保险重仓#信托重仓#券商重仓#QFII重仓#精选指数
  #分拆上市#超级细菌#权证类#上海本地#深圳本地#振兴沈阳
  #沿海发展#央企50#超大盘#参股金融#基金重仓#股期概念#股权激励
  #甲型流感#迪士尼#出口退税#新能源#未股改#循环经济#资产注入
  ======================================================
  地域板块
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
