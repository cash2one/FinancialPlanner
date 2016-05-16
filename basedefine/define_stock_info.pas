unit define_stock_info;

interface
      
type
  TStockInfoType = (inf_Undefine,
    inf_EPS,      // earnings per share
    inf_PE_LYR,   //  price earning ratio
    inf_PE_TTM,   //  price earning ratio
    inf_GeneralCapital,
    inf_NAPS,     // 每股净资产 net asset per share
    inf_PB,       // 市净率
    inf_Flow,
    inf_DPS,
    inf_PS
  );

const
  StockInfoKeyWord: array[TStockInfoType] of String = ('',
    '每股收益',
    '静态市盈率', // 市盈率LYR 静态市盈率 市盈率TTM 动态市盈率
    '动态市盈率', // 市盈率LYR 静态市盈率 市盈率TTM 动态市盈率
    '总股本',   // capitalization
    '每股净资产',
    '市净率',       // 每股股价与每股净资产的比率
    '流通股本',  // capital stock in circulation  / Flow of equity
    '每股股息',  // Dividend Per Share
    '市销率'  // 市销率( Price-to-sales,PS), PS = 总市值 除以主营业务收入或者 PS=股价 除以每股销售额
    );

implementation

end.
