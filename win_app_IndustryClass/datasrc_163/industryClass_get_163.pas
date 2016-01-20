unit industryClass_get_163;

interface

uses
  BaseApp;

  procedure GetIndustryClass_163(App: TBaseApp);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,     
  UtilsDateTime,
  
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;

(*
  证监会行业(新)

  http://quotes.money.163.com/old/#query=HS
  
  http://quotes.money.163.com/old/#query=leadIndustry
  http://quotes.money.163.com/old/#query=leadIndustry&DataType=industryPlate&sort=PERCENT&order=desc&count=25&page=0 领涨行业
  http://quotes.money.163.com/old/#query=leadRegion&DataType=regionPlate&sort=PERCENT&order=desc&count=25&page=0 领涨地域
  http://quotes.money.163.com/old/#query=leadNotation&DataType=notationPlate&sort=PERCENT&order=desc&count=25&page=0 领涨概念          

  传媒艺术
  http://quotes.money.163.com/old/#query=hy003011&DataType=HS_RANK&sort=PERCENT&order=desc&count=24&page=0

  农林牧渔
  http://quotes.money.163.com/old/#query=hy001000&DataType=HS_RANK&sort=PERCENT&order=desc&count=24&page=0
  采矿业
  粮食加工
  食品制造
  茶酒饮料
  纺织业
  服装制造
  皮毛制鞋
  木材加工
  家具制造
  造纸印刷
  传媒艺术
  石油加工
  化学制品
  医药制造
  化纤制造
  橡胶塑料
  非金属制品
  黑色金属
  有色金属
  金属制品
  通用设备制造
  专用设备制造
  汽车制造
  交运设备
  电器制造
  通信设备
  仪器仪表
  其他制造业
  废品利用
  水电燃气
  建筑业
  批发零售
  交通物流
  餐饮酒店
  信息技术
  金融业
  房地产业
  租赁和商务
  科研技术
  旅游环境
  教育卫生
  出版传媒
  综合
  ======================================================
  概念
  ======================================================
  3D打印  4G  安防  仓储物流  参股基金  车联网  触摸屏
  创投  大数据  多晶硅  地热能  第三方检测  电视  迪士尼
  电子商务  分拆上市  风电  钒钛资源  高端白酒  广东国资重组
  广东三旧改造  光伏  国际板  高铁  核电第三代技术  黄金股
  互联网金融  航母动力装置  航母造船  海南国际旅游岛
  海水淡化  合同能源管理  海洋工程  IPV6  军工  机器人
  抗癌  垃圾焚烧  旅游  煤层气  美丽中国  农药  苹果
  期货  前海开发  软件  上海国资  上海自贸区  手机支付  水利建设
  石墨烯  三沙  三网融合  铁路建设  物联网  网络游戏  卫星导航
  新能源汽车  新三板  稀土永磁  医药  页岩气  智能穿戴  智能电网  炸药
*)
procedure GetIndustryClass_163(App: TBaseApp);
begin
end;

end.
