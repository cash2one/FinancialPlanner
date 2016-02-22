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

  FileExt_StockDay        = 'sday';
  FileExt_StockDayWeight  = 'sdaw';

  FileExt_StockDetail     = 'sdet';
  FileExt_StockAnalysis   = 'sana';
  FileExt_StockInstant    = 'sint';
  FileExt_StockValue      = 'svue';

  FileExt_FuturesDetail   = 'qdet';
  FileExt_FuturesAnalysis = 'qana';

implementation

end.
