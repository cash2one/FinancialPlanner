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
  
  // ����
  // sd_31  sdw_31
  // 5����
  // sd5_31 sdw5_31
  FileExt_StockDay        = 'sd';


  FileExt_StockDayWeight  = 'sdw';
  FileExt_StockDetail     = 'sdt';  // rename to se

  // ������ �� detail �� �����ܽ�����
  // sm60_31 60 ������ ������� ������ ��Ϊ����
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

  // ����ͳ�Ʒ���
  FileExt_StockSummaryValue = 'ssv';

  FileExt_FuturesDetail   = 'qe';
  FileExt_FuturesAnalysis = 'qa';

implementation

end.
