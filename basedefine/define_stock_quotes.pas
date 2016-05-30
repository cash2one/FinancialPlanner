unit define_stock_quotes;

interface

uses
  Define_Price;
  
type
  PRT_WeightPack      = ^TRT_WeightPack;
  TRT_WeightPack      = record
    Value             : LongWord;
  end;
  
  PRT_WeightFull      = ^TRT_WeightFull;
  TRT_WeightFull      = record
    Value             : double;
  end;

  PRT_DateTimePack    = ^TRT_DateTimePack;
  TRT_DateTimePack    = record
    Value             : Integer;
  end;
                                          
  PRT_TimePack        = ^TRT_TimePack;
  TRT_TimePack        = record
    Value             : Integer;
  end;


  PRT_DateTimeFull    = ^TRT_DateTimeFull;
  TRT_DateTimeFull    = record
    Value             : double;
  end;     

  { �������� }
  PRT_Quote_M1_Day    = ^TRT_Quote_M1_Day;
  TRT_Quote_M1_Day    = record           // 56
    DealDateTime      : TRT_DateTimePack;    // 4
    PriceRange        : TRT_PricePack_Range; // 16 - 20
    DealVolume        : Int64;               // 8 - 28 �ɽ���
    DealAmount        : Int64;               // 8 - 36 �ɽ����
    Weight            : TRT_WeightPack;      // 4 - 40 ��ȨȨ�� * 100
    TotalValue        : Int64;               // 8 - 48 ����ֵ
    DealValue         : Int64;               // 8 - 56 ��ͨ��ֵ
  end;

  { ��ʱ��������
    1 ���� -- 60 ���� < ����
  }
  PRT_Quote_M1_Time   = ^TRT_Quote_M1_Time;
  TRT_Quote_M1_Time   = record
    DealDateTime      : TRT_DateTimeFull;    // 8  
    PriceRange        : TRT_PricePack_Range; // 16 - 24   
    DealVolume        : Integer;             // 4 - 28 �ɽ���
    DealAmount        : Integer;             // 4 - 32 �ɽ����
  end;
  
  { ������ϸ }
  PRT_Quote_M2        = ^TRT_Quote_M2;
  TRT_Quote_M2        = record
    DealTime          : TRT_TimePack;    // 4 - 4
    Price             : TRT_PricePack;       // 4 - 8
    DealVolume        : Integer;             // 4 - 12 �ɽ���
    DealAmount        : Integer;             // 4 - 16
    DealType          : Integer;
    // Buyer: Integer;
    // Saler: Integer;
  end;

{
  M1 ��������
     1 ���� 5 ���� --- ���� ���� ���� ���� ��������
     Open High Low Close
  M2 ��ϸ����
     Price Time Volume Acount
}  
type
  PStore_Weight         = ^TStore_Weight;
  TStore_Weight         = record
    Value               : Cardinal;
  end;
  
  PStore_Quote64_M1     = ^TStore_Quote64_M1;
  TStore_Quote64_M1     = packed record // 128       
  // һ��ʱ����ڵ� �۸��ʾ  
    PriceRange          : TStore_PriceRange;  // 16
    Reserve             : array[0..64 - 1 - SizeOf(TStore_PriceRange)] of Byte;
  end;

  { �������� }
  PStore_Quote64_M1_Day_V1  = ^TStore_Quote64_M1_Day_V1;
  TStore_Quote64_M1_Day_V1  = packed record  // 56      
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Int64;         // 8 - 24 �ɽ���
    DealAmount          : Int64;         // 8 - 32 �ɽ����
    DealDate            : Integer;       // 4 - 36 ��������
    Weight              : TStore_Weight; // 4 - 40 ��ȨȨ�� * 100
    TotalValue          : Int64;         // 8 - 48 ����ֵ
    DealValue           : Int64;         // 8 - 56 ��ͨ��ֵ 
  end;
         
  { ��ʱ���� detail }
  PStore_Quote64_M1_Time_V1  = ^TStore_Quote64_M1_Time_V1;  //
  TStore_Quote64_M1_Time_V1  = packed record  // 56
    PriceRange          : TStore_PriceRange;  // 16
    DealVolume          : Integer;       // 8 - 24 �ɽ���
    DealAmount          : Integer;       // 8 - 32 �ɽ����
    DealDateTime        : Double;        // 4 - 36 ��������
  end;

  TStore_Quote64_M1_Detail_V1 = TStore_Quote64_M1_Time_V1;
               
  // ֻ��һ���۸� ��Ȼ�� ��ʱ��������
  PStore_Quote_M2       = ^TStore_Quote_M2;
  TStore_Quote_M2       = packed record  // 8     
    QuoteDealTime       : Word;       // 4 - 8 1 Сʱ 3600 ��  9 -- 15
    QuoteDealDate       : Word;            
    Price               : TStore_Price;  // 4 - 4
    DealVolume          : Integer;          // 4 - 12 �ɽ���
    DealAmount          : Integer;          // 4 - 16 �ɽ����
    DealType            : Byte; // ��������������
  end;

  PStore_Quote32_M2_V1  = ^TStore_Quote32_M2_V1;
  TStore_Quote32_M2_V1  = packed record
    Quote               : TStore_Quote_M2;
    Reserve             : array [0..32 - SizeOf(TStore_Quote_M2) - 1] of Byte;
  end;          

const
  DealType_Buy  = 1;
  DealType_Sale = 2;
  DealType_Neutral = 3;  

  function GetTimeText(ATime: PRT_TimePack): AnsiString;
  
implementation

uses
  Sysutils;
  
function GetTimeText(ATime: PRT_TimePack): AnsiString;
var
  tmpHour: Integer;
  tmpMinute: Integer;
  tmpSecond: Integer;
begin
  Result := '';
  if nil <> ATime then
  begin
    tmpHour := Trunc(ATime.Value div 3600);
    tmpSecond := ATime.Value - tmpHour * 3600;
    tmpMinute := Trunc(tmpSecond div 60);
    tmpSecond := tmpSecond - tmpMinute * 60;
    Result := IntToStr(tmpHour + 9) + ':' + IntToStr(tmpMinute) + ':' + IntToStr(tmpSecond);
  end;
end;

end.
