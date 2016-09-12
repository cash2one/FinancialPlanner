unit define_dealstore_file;

interface

const                               
  FilePath_StockData      = 'sdata';
  FilePath_StockIndexData = 'sidx';     
  FilePath_FutureData     = 'fdat';

  FilePath_DBType_ItemDB        = 1;
  FilePath_DBType_DayData       = 2;
  FilePath_DBType_DayDataWeight = 3;

  FilePath_DBType_InstantData   = 4;
  FilePath_DBType_DetailData    = 5;
  FilePath_DBType_ValueData     = 6;
  
  FilePath_DBType_MinuteData    = 7;   
  FilePath_DBType_WeightData    = 8;
  
  // 日线
  // sd_31  sdw_31
  // 5日线
  // sd5_31 sdw5_31
  FileExt_StockDay        = 'd';


  FileExt_StockDayWeight  = 'dw';
  FileExt_StockDetail     = 'sdt';  // rename to se

  // 分钟线 由 detail 线 分析总结来的
  // sm60_31 60 分钟线 如果不带 分钟数 则为月线
  // smw60_31 smw60_32
  FileExt_StockMinute     = 'm';
  FileExt_StockMinuteWeight = 'mw';
  
  FileExt_StockWeek       = 'wk';
  FileExt_StockWeekWeight = 'wkw';

  // sm_31 smw_31
  FileExt_StockMonth      = 'mt';
  FileExt_StockMonthWeight = 'mtw';

  FileExt_StockAnalysis   = 'as';
  FileExt_StockInstant    = 'it';

  FileExt_StockWeight     = 'wt';

  // 总体统计分析
  FileExt_StockSummaryValue = 'sv';

  FileExt_FuturesDetail   = 'qe';
  FileExt_FuturesAnalysis = 'qa';

implementation

end.
