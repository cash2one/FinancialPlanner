unit define_dealstore_file;

interface

const                               
  FilePath_StockData      = 'sdata';   
  FilePath_FutureData     = 'fdata';

  FilePath_DBType_ItemDB        = 1;
  FilePath_DBType_DayData       = 2;
  FilePath_DBType_DayDataWeight = 3;
  FilePath_DBType_InstantData   = 4;
  FilePath_DBType_DetailData    = 5;
  FilePath_DBType_ValueData     = 6;

  FileExt_StockDay        = 'sd';
  FileExt_StockDayWeight  = 'sdw';

  FileExt_StockDetail     = 'sdt';
  FileExt_StockAnalysis   = 'sas';
  FileExt_StockInstant    = 'sit';
  FileExt_StockValue      = 'sve';

  FileExt_FuturesDetail   = 'qdt';
  FileExt_FuturesAnalysis = 'qas';

implementation

end.
