unit define_deal;

interface

uses
  define_price;
  
type
  // �µ�
  TDealRequest      = packed record  { 22 }
    // ??? DataVersion     : Word;      
    ActionDate      : Word;
    ActionTime      : Word; // 9:00 3600 * 
    
    ActionID        : integer;
    Price           : Integer;
    Num             : Integer;
    ResultCode      : Word;
    // 0 δ�ɽ�
    // 1 ���ֳɽ�
    // 2 ȫ���ɽ�
    // 3 ����
    RequestNo       : Integer; //AnsiString; // ί�б��
    //RequestSeqNo    : AnsiString; // ί�����
  end;
                   
  // �ɽ�
  TDealResultClose  = packed record   { 28 }   
    // ??? DataVersion     : Word;
    ActionDate      : Word;
    ActionTime      : Word; // 9:00 3600 *
     
    ActionID        : integer;
    TargetID        : Integer; // --> request.ActionID
    Price           : Integer; // �ɽ��۸�
    Num             : Integer; // �ɽ�����
    Amount          : Integer; // ���
    Fee             : Integer; // ������ �ȵ�
  end;

  // ����
  TDealResultCancel = packed record   { 16 }    
    // ??? DataVersion     : Word;      
    ActionDate      : Word;
    ActionTime      : Word; // 9:00 3600 *
    
    ActionID        : Integer;    // 4 - 12
    TargetID        : Integer; // 16 --> request.ActionID
  end;

implementation

end.
