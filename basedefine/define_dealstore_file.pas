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
  
  // 日线
  // sd_31  sdw_31
  // 5日线
  // sd5_31 sdw5_31
  FileExt_StockDay        = 'sd';


  FileExt_StockDayWeight  = 'sdw';
  FileExt_StockDetail     = 'sdt';  // rename to se

  // 分钟线 由 detail 线 分析总结来的
  // sm60_31 60 分钟线 如果不带 分钟数 则为月线
  // smw60_31 smw60_32
  FileExt_StockMinute     = 'sm';
  FileExt_StockMinuteWeight = 'smw';
  
  FileExt_StockWeek       = 'sk';  
  FileExt_StockWeekWeight = 'skw';

  // sm_31 smw_31
  FileExt_StockMonth      = 'sm';
  FileExt_StockMonthWeight = 'smw';

  FileExt_StockAnalysis   = 'sa';
  FileExt_StockInstant    = 'si';

  // 总体统计分析
  FileExt_StockSummaryValue = 'ssv';

  FileExt_FuturesDetail   = 'qe';
  FileExt_FuturesAnalysis = 'qa';

implementation

end.
