unit define_ctp_quote;

interface

uses
  Windows,
  ThostFtdcBaseDataType,
  define_price;
  
const
  BrokerID_ZSQH = 8060; // �����ڻ�  
  BrokerID_SWQH = 88888; // �����ڻ�

type
  PStore_QuoteData_V1 = ^TStore_QuoteData_V1;
  TStore_QuoteData_V1 = packed record //44    
    // ���¼�
    LastPrice: TStore_Price; // 4   
    ///����
    Volume: Integer	;  // 4 - 8
    // �����¼ʱ��
    RecordTime: TDateTime; // 8 - 16    
    // ʱ�� ??? 
    UpdateTime: TDateTime; // 8 - 24
    ///����޸ĺ���
    UpdateMillisec: Integer; // 4 - 28
    ///����޸�ʱ��
    UpdateTime2: TThostFtdcTimeType; // 9 - 53
  end;

  PStore_QuoteDataFileFirstPage = ^TStore_QuoteDataFileFirstPage;
  TStore_QuoteDataFileFirstPage = packed record //36
//    Header: TStore_Head_Quote_V1;
//    DataRecords: array[0..((64 * 1024 - SizeOf(TStore_Head_Quote_V1))
//        div SizeOf(TStore_QuoteRec64_M1_Rec)) - 1] of TStore_QuoteRec64_M1_Rec;
  end;
               
  PStore_QuoteDataFileDataPage = ^TStore_QuoteDataFileDataPage;
  TStore_QuoteDataFileDataPage = packed record //36
//    DataRecords: array[0..(64 * 1024 div SizeOf(TStore_QuoteRec64_M1_Rec)) - 1] of TStore_QuoteRec64_M1_Rec;
  end;

  PRT_QuoteDataHead = ^TRT_QuoteDataHead;
  TRT_QuoteDataHead = packed record
    // ������
    TradingDay: Integer;
    // ���׺�Լ�� --> ���׺�Լ 
    InstrumentID: Integer;      
    InstrumentCode: array[0.. 8 - 1] of AnsiChar;
    ///������
    PreClosePrice: TRT_PricePack;    
    PreSettlementPrice: TRT_PricePack;
    PreOpenInterest: Double;
    ///��ͣ���
    UpperLimitPrice: TRT_PricePack;
    ///��ͣ���
    LowerLimitPrice: TRT_PricePack;

    PriceRange: TRT_PricePack_Range;
    ///����
    Volume: Double;
    ///�ɽ����
    Turnover: Double;   
  end;

  // ��ʽ���� 1 ���� 2 ������
  // 4.5 3600 * 2 < 40000 ������
  // 40000 * 128 = 5120000 ��Լ 5MB ����
  PRT_QuoteDataRecord = ^TRT_QuoteDataRecord;
  TRT_QuoteDataRecord = packed record //82
    // ���¼�
    LastPrice: TRT_PricePack; // 8 - 8  
    ///����
    Volume: Integer	;  // 4 - 12
    ///�ɽ����
    Turnover: Double	; // 8 - 20   
    ///�ֲ���
    OpenInterest: Double;  // 8 -- 28
    ///�����һ
    BidPrice1: TRT_PricePack; // 8 - 36
    ///������һ
    BidVolume1: Integer; // 4 - 40
    ///������һ
    AskPrice1: TRT_PricePack; // 8 - 48
    ///������һ
    AskVolume1: Integer; // 4 - 52 
    // ʱ�� ??? 
    UpdateTime: TDateTime; // 8 - 60  
    ///����޸ĺ���
    UpdateMillisec: Integer; // 4 - 64
    // �����¼ʱ��
    RecordTime: TDateTime; // 8 - 72   
    UpdateTime2: TThostFtdcTimeType; // 9 - 81  
    Status: Byte;      // 1 -- 82
  end;

  PRT_QuotePeriodData = ^TRT_QuotePeriodData;
  TRT_QuotePeriodData = packed record //36 
    PriceRange: TRT_PricePack_Range;
    Turnover: Double;// 8 - 40 
    Volume: Integer;  // 4 - 44
    Hold: Integer;    // 4 - 48 �ֲ���
    Status: Byte;      // 1 -- 49
  end;
                 
  TRT_QuotePeriodDataRecord = packed record //36
    Data: TRT_QuotePeriodData;
    Reserve: array[0.. 64 - SizeOf(TRT_QuotePeriodData) - 1] of Byte;
  end;
  
  TRT_QuoteMinuteDataRecord = packed record //36     
    Summary: TRT_QuotePeriodData;
    SecondData: array[0..60 - 1] of TRT_QuotePeriodDataRecord;
  end;
  
  TRT_QuoteHourDataRecord = packed record //36
    MinuteData: array[0..60 - 1] of TRT_QuoteMinuteDataRecord;
  end;

  // 09:15-11:30��13:00-15:15
  TRT_QuoteDayDataRecord = packed record //36    
    Hour09Data: array[0..46 - 1] of TRT_QuoteMinuteDataRecord; // 09:15
    Hour10Data: TRT_QuoteHourDataRecord; // 10:00
    Hour11Data: array[0..31 - 1] of TRT_QuoteMinuteDataRecord; // 11:00 -- 11:30  
    Hour13Data: TRT_QuoteHourDataRecord; // 13:00
    Hour14Data: TRT_QuoteHourDataRecord; // 14:00
    Hour15Data: array[0..16 - 1] of TRT_QuoteMinuteDataRecord; // 15:00 -- 15:15
  end;
  
const
  RT_QuoteDataArraySize = 1024;
  QuoteArraySize = 4;
    
type
  PRT_QuoteDataRecords = ^TRT_QuoteDataRecords;           
  TRT_QuoteDataRecords = record
    PrevSibling: PRT_QuoteDataRecords;
    NextSibling: PRT_QuoteDataRecords;    
    Index: integer;
    Datas: array[0..RT_QuoteDataArraySize - 1] of TRT_QuoteDataRecord;
  end;
  
  PRT_QuoteData = ^TRT_QuoteData;
  TRT_QuoteData = record
    Header: TRT_QuoteDataHead;
    // �ܼ�¼��
    RecordCount: Integer;
    PageLock: TRTLCriticalSection;
    CurrentRecords: PRT_QuoteDataRecords;
    FirstRecords: PRT_QuoteDataRecords;
    LastRecords: PRT_QuoteDataRecords;
  end;

implementation

end.
