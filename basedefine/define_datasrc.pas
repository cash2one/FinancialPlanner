unit define_datasrc;

interface

uses
  define_dealitem;

type
  TDealDataSource = (
    src_unknown,
    src_all,
    src_ctp,
    src_offical,
    src_tongdaxin,
    src_tonghuasun,
    src_dazhihui,
    src_sina,
    src_163,
    src_qq,
    src_xq
  );

const                     
  DataSrc_All        = 1;
  DataSrc_CTP        = 11;
  DataSrc_Standard   = 12; // 来至官方 证券交易所
                           
  DataSrc_TongDaXin  = 21; // 通达信
  DataSrc_TongHuaSun = 22; // 同花顺
  DataSrc_DaZhiHui   = 23; // 大智慧

  DataSrc_Sina       = 31;
  DataSrc_163        = 32;
  DataSrc_QQ         = 33;
  DataSrc_XQ         = 34; // 雪球
            
  function GetDataSrcCode(ADataSrc: integer): AnsiString;
                                                     
  function GetStockCode_163(AStockItem: PRT_DealItem): AnsiString;
  function GetStockCode_Sina(AStockItem: PRT_DealItem): AnsiString;
  function GetStockCode_QQ(AStockItem: PRT_DealItem): AnsiString;

  function GetDealDataSource(ASourceCode: integer): TDealDataSource;
  function GetDealDataSourceCode(ASource: TDealDataSource): integer;

implementation
         
function GetDealDataSource(ASourceCode: integer): TDealDataSource;
begin
  Result := src_unknown;
  case ASourceCode of
    DataSrc_All: Result := src_all;
    DataSrc_CTP: Result := src_ctp;
    DataSrc_Standard: Result := src_offical;
    DataSrc_tongdaxin: Result := src_tongdaxin;
    DataSrc_tonghuasun: Result := src_tonghuasun;
    DataSrc_dazhihui: Result := src_dazhihui;
    DataSrc_Sina: Result := src_sina;
    DataSrc_163: Result := src_163;
    DataSrc_QQ: Result := src_qq;
    DataSrc_XQ: Result := src_xq;
  end;
end;

function GetDealDataSourceCode(ASource: TDealDataSource): integer;
begin           
  Result := 0;
  case ASource of            
    src_all: Result := DataSrc_All;
    src_ctp: Result := DataSrc_Ctp;
    src_offical: Result := DataSrc_Standard;
    src_tongdaxin: Result := DataSrc_tongdaxin;
    src_tonghuasun: Result := DataSrc_tonghuasun;
    src_dazhihui: Result := DataSrc_dazhihui;
    src_sina: Result := DataSrc_sina;
    src_163: Result := DataSrc_163;
    src_qq: Result := DataSrc_qq;
    src_xq: Result := DataSrc_xq;
  end;
end;

function GetDataSrcCode(ADataSrc: integer): AnsiString;
begin
  Result := '';
  case ADataSrc of
    DataSrc_CTP        : Result := 'ctp';
    DataSrc_Standard   : Result := 'gov'; //  official 来至官方 证券交易所
    DataSrc_Sina       : Result := 'sina';
    DataSrc_163        : Result := '163';
    DataSrc_QQ         : Result := 'qq';
    DataSrc_XQ         : Result := 'xq'; // 雪球
    
    DataSrc_TongDaXin  : Result := 'tdx'; // 通达信
    DataSrc_TongHuaSun : Result := 'ths'; // 同花顺
    DataSrc_DaZhiHui   : Result := 'dzh'; // 大智慧
  end;
end;
         
function GetStockCode_163(AStockItem: PRT_DealItem): AnsiString;
begin
  if AStockItem.sCode[1] = '6' then
  begin
    Result := '0' + AStockItem.sCode;
  end else
  begin
    Result := '1' + AStockItem.sCode;
  end;
end;
      
function GetStockCode_Sina(AStockItem: PRT_DealItem): AnsiString;
begin
  if AStockItem.sCode[1] = '6' then
  begin
    Result := 'sh' + AStockItem.sCode;
  end else
  begin
    Result := 'sz' + AStockItem.sCode;
  end;
end;

function GetStockCode_QQ(AStockItem: PRT_DealItem): AnsiString;
begin
  Result := GetStockCode_Sina(AStockItem);
end;

end.
