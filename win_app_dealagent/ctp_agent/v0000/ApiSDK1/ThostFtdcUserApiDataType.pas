unit ThostFtdcUserApiDataType;

interface

uses
  ThostFtdcBaseDataType;
  
type                                      
  TThostFtdcSerialType = Integer;     
  TThostFtdcFutureSerialType = Integer;    
  TThostFtdcRequestIDType = Integer;  
  TThostFtdcTIDType = Integer;     
  TThostFtdcRepealTimeIntervalType = Integer;     
  TThostFtdcRepealedTimesType = Integer;    
  TThostFtdcPlateSerialType = Integer;

  TThostFtdcTradeAmountType = Double;
  TThostFtdcCustFeeType = Double;
  TThostFtdcFutureFeeType = Double;

  TThostFtdcLastFragmentType = AnsiChar;
  TThostFtdcIdCardTypeType = AnsiChar;
  TThostFtdcCustTypeType = AnsiChar;
  TThostFtdcFeePayFlagType = AnsiChar;
  TThostFtdcBankAccTypeType = AnsiChar;
  TThostFtdcPwdFlagType = AnsiChar;   
  TThostFtdcTransferStatusType = AnsiChar;
  TThostFtdcBankRepealFlagType = AnsiChar;
  TThostFtdcBrokerRepealFlagType = AnsiChar;
  TThostFtdcInstitutionTypeType = AnsiChar;
                                                
  TThostFtdcReturnCodeType = array[0..6] of AnsiChar; 
  TThostFtdcDescrInfoForReturnCodeType = array[0..128] of AnsiChar;

  TThostFtdcOperNoType = array[0..16] of AnsiChar;

  TThostFtdcBankCodingForFutureType = array[0..32] of AnsiChar;
  TThostFtdcPasswordKeyType = array[0..128] of AnsiChar;
  TThostFtdcOrganCodeType = array[0..35] of AnsiChar;
                                                
  TThostFtdcDeviceIDType = array[0..2] of AnsiChar;
  TThostFtdcBrokerIDType = array[0..10] of AnsiChar;
  TThostFtdcUserIDType = array[0..15] of AnsiChar;   
  TThostFtdcAccountIDType = array[0..12] of AnsiChar;
  TThostFtdcInvestorIDType = array[0..12] of AnsiChar; 
  TThostFtdcOrderRefType = array[0..12] of AnsiChar; 
  TThostFtdcPasswordType = array[0..40] of AnsiChar;  
  TThostFtdcProductInfoType = array[0..10] of AnsiChar;  
  TThostFtdcTradeCodeType = array[0..6] of AnsiChar;
  TThostFtdcBankIDType = array[0..3] of AnsiChar;     
  TThostFtdcBankBrchIDType = array[0..4] of AnsiChar;
  TThostFtdcFutureBranchIDType = array[0..30] of AnsiChar;
  TThostFtdcTradeDateType = array[0..8] of AnsiChar;
  TThostFtdcTradeTimeType = array[0..8] of AnsiChar;
  TThostFtdcBankSerialType = array[0..12] of AnsiChar;  
  TThostFtdcIndividualNameType = array[0..50] of AnsiChar;
  TThostFtdcIdentifiedCardNoType = array[0..50] of AnsiChar;
  TThostFtdcBankAccountType = array[0..40] of AnsiChar;  
  TThostFtdcAddInfoType = array[0..128] of AnsiChar;      
  TThostFtdcDigestType = array[0..35] of AnsiChar;

  
///�û���¼Ӧ��
  PhostFtdcRspUserLoginField = ^ThostFtdcRspUserLoginField;
  ThostFtdcRspUserLoginField = record
    TradingDay: TThostFtdcDateType;  ///������
    LoginTime: TThostFtdcTimeType; ///��¼�ɹ�ʱ��
    BrokerID: TThostFtdcBrokerIDType; ///���͹�˾����
    UserID: TThostFtdcUserIDType; ///�û�����
    SystemName: TThostFtdcSystemNameType; ///����ϵͳ����
    FrontID: TThostFtdcFrontIDType;  ///ǰ�ñ��
    SessionID: TThostFtdcSessionIDType; ///�Ự���
    MaxOrderRef: TThostFtdcOrderRefType;  ///��󱨵�����
    SHFETime: TThostFtdcTimeType;  ///������ʱ��
    DCETime: TThostFtdcTimeType;  ///������ʱ��
    CZCETime: TThostFtdcTimeType; ///֣����ʱ��
    FFEXTime: TThostFtdcTimeType; ///�н���ʱ��
    INETime: TThostFtdcTimeType;   ///��Դ����ʱ��
  end;
          
///�ͻ�����֤��Ӧ
  PhostFtdcRspAuthenticateField = ^ThostFtdcRspAuthenticateField;   
  ThostFtdcRspAuthenticateField = record
    ///���͹�˾����
    BrokerID: TThostFtdcBrokerIDType;
    ///�û�����
    UserID: TThostFtdcUserIDType;
    ///�û��˲�Ʒ��Ϣ
    UserProductInfo: TThostFtdcProductInfoType;
  end;

///���з��������ʽ�ת�ڻ���Ӧ
  PhostFtdcRspTransferField = ^ThostFtdcRspTransferField;
  ThostFtdcRspTransferField = record
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ����
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///�ͻ�����
    CustomerName: TThostFtdcIndividualNameType;
    ///֤������
    IdCardType: TThostFtdcIdCardTypeType;
    ///֤������
    IdentifiedCardNo: TThostFtdcIdentifiedCardNoType;
    ///�ͻ�����
    CustType: TThostFtdcCustTypeType;
    ///�����ʺ�
    BankAccount: TThostFtdcBankAccountType;
    ///��������
    BankPassWord: TThostFtdcPasswordType;
    ///Ͷ�����ʺ�
    AccountID: TThostFtdcAccountIDType;
    ///�ڻ�����
    Password: TThostFtdcPasswordType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�ڻ���˾��ˮ��
    FutureSerial: TThostFtdcFutureSerialType;
    ///�û���ʶ
    UserID: TThostFtdcUserIDType;
    ///��֤�ͻ�֤�������־
    VerifyCertNoFlag: TThostFtdcYesNoIndicatorType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///ת�ʽ��
    TradeAmount: TThostFtdcTradeAmountType;
    ///�ڻ���ȡ���
    FutureFetchAmount: TThostFtdcTradeAmountType;
    ///����֧����־
    FeePayFlag: TThostFtdcFeePayFlagType;
    ///Ӧ�տͻ�����
    CustFee: TThostFtdcCustFeeType;
    ///Ӧ���ڻ���˾����
    BrokerFee: TThostFtdcFutureFeeType;
    ///���ͷ������շ�����Ϣ
    Message: TThostFtdcAddInfoType;
    ///ժҪ
    Digest: TThostFtdcDigestType;
    ///�����ʺ�����
    BankAccType: TThostFtdcBankAccTypeType;
    ///������־
    DeviceID: TThostFtdcDeviceIDType;
    ///�ڻ���λ�ʺ�����
    BankSecuAccType: TThostFtdcBankAccTypeType;
    ///�ڻ���˾���б���
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///�ڻ���λ�ʺ�
    BankSecuAcc: TThostFtdcBankAccountType;
    ///���������־
    BankPwdFlag: TThostFtdcPwdFlagType;
    ///�ڻ��ʽ�����˶Ա�־
    SecuPwdFlag: TThostFtdcPwdFlagType;
    ///���׹�Ա
    OperNo: TThostFtdcOperNoType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///����ID
    TID: TThostFtdcTIDType;
    ///ת�˽���״̬
    TransferStatus: TThostFtdcTransferStatusType;
    ///�������
    ErrorID: TThostFtdcErrorIDType;
    ///������Ϣ
    ErrorMsg: TThostFtdcErrorMsgType;
  end;


///������Ӧ
  PhostFtdcRspRepealField = ^ThostFtdcRspRepealField;
  ThostFtdcRspRepealField = record
    ///����ʱ����
    RepealTimeInterval: TThostFtdcRepealTimeIntervalType;
    ///�Ѿ���������
    RepealedTimes: TThostFtdcRepealedTimesType;
    ///���г�����־
    BankRepealFlag: TThostFtdcBankRepealFlagType;
    ///���̳�����־
    BrokerRepealFlag: TThostFtdcBrokerRepealFlagType;
    ///������ƽ̨��ˮ��
    PlateRepealSerial: TThostFtdcPlateSerialType;
    ///������������ˮ��
    BankRepealSerial: TThostFtdcBankSerialType;
    ///�������ڻ���ˮ��
    FutureRepealSerial: TThostFtdcFutureSerialType;
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ����
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///�ͻ�����
    CustomerName: TThostFtdcIndividualNameType;
    ///֤������
    IdCardType: TThostFtdcIdCardTypeType;
    ///֤������
    IdentifiedCardNo: TThostFtdcIdentifiedCardNoType;
    ///�ͻ�����
    CustType: TThostFtdcCustTypeType;
    ///�����ʺ�
    BankAccount: TThostFtdcBankAccountType;
    ///��������
    BankPassWord: TThostFtdcPasswordType;
    ///Ͷ�����ʺ�
    AccountID: TThostFtdcAccountIDType;
    ///�ڻ�����
    Password: TThostFtdcPasswordType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�ڻ���˾��ˮ��
    FutureSerial: TThostFtdcFutureSerialType;
    ///�û���ʶ
    UserID: TThostFtdcUserIDType;
    ///��֤�ͻ�֤�������־
    VerifyCertNoFlag: TThostFtdcYesNoIndicatorType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///ת�ʽ��
    TradeAmount: TThostFtdcTradeAmountType;
    ///�ڻ���ȡ���
    FutureFetchAmount: TThostFtdcTradeAmountType;
    ///����֧����־
    FeePayFlag: TThostFtdcFeePayFlagType;
    ///Ӧ�տͻ�����
    CustFee: TThostFtdcCustFeeType;
    ///Ӧ���ڻ���˾����
    BrokerFee: TThostFtdcFutureFeeType;
    ///���ͷ������շ�����Ϣ
    Message: TThostFtdcAddInfoType;
    ///ժҪ
    Digest: TThostFtdcDigestType;
    ///�����ʺ�����
    BankAccType: TThostFtdcBankAccTypeType;
    ///������־
    DeviceID: TThostFtdcDeviceIDType;
    ///�ڻ���λ�ʺ�����
    BankSecuAccType: TThostFtdcBankAccTypeType;
    ///�ڻ���˾���б���
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///�ڻ���λ�ʺ�
    BankSecuAcc: TThostFtdcBankAccountType;
    ///���������־
    BankPwdFlag: TThostFtdcPwdFlagType;
    ///�ڻ��ʽ�����˶Ա�־
    SecuPwdFlag: TThostFtdcPwdFlagType;
    ///���׹�Ա
    OperNo: TThostFtdcOperNoType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///����ID
    TID: TThostFtdcTIDType;
    ///ת�˽���״̬
    TransferStatus: TThostFtdcTransferStatusType;
    ///�������
    ErrorID: TThostFtdcErrorIDType;
    ///������Ϣ
    ErrorMsg: TThostFtdcErrorMsgType;
  end;


///��ѯ�˻���Ϣ��Ӧ
  PhostFtdcRspQueryAccountField = ^ThostFtdcRspQueryAccountField;
  ThostFtdcRspQueryAccountField = record
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ����
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///�ͻ�����
    CustomerName: TThostFtdcIndividualNameType;
    ///֤������
    IdCardType: TThostFtdcIdCardTypeType;
    ///֤������
    IdentifiedCardNo: TThostFtdcIdentifiedCardNoType;
    ///�ͻ�����
    CustType: TThostFtdcCustTypeType;
    ///�����ʺ�
    BankAccount: TThostFtdcBankAccountType;
    ///��������
    BankPassWord: TThostFtdcPasswordType;
    ///Ͷ�����ʺ�
    AccountID: TThostFtdcAccountIDType;
    ///�ڻ�����
    Password: TThostFtdcPasswordType;
    ///�ڻ���˾��ˮ��
    FutureSerial: TThostFtdcFutureSerialType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�û���ʶ
    UserID: TThostFtdcUserIDType;
    ///��֤�ͻ�֤�������־
    VerifyCertNoFlag: TThostFtdcYesNoIndicatorType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///ժҪ
    Digest: TThostFtdcDigestType;
    ///�����ʺ�����
    BankAccType: TThostFtdcBankAccTypeType;
    ///������־
    DeviceID: TThostFtdcDeviceIDType;
    ///�ڻ���λ�ʺ�����
    BankSecuAccType: TThostFtdcBankAccTypeType;
    ///�ڻ���˾���б���
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///�ڻ���λ�ʺ�
    BankSecuAcc: TThostFtdcBankAccountType;
    ///���������־
    BankPwdFlag: TThostFtdcPwdFlagType;
    ///�ڻ��ʽ�����˶Ա�־
    SecuPwdFlag: TThostFtdcPwdFlagType;
    ///���׹�Ա
    OperNo: TThostFtdcOperNoType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///����ID
    TID: TThostFtdcTIDType;
    ///���п��ý��
    BankUseAmount: TThostFtdcTradeAmountType;
    ///���п�ȡ���
    BankFetchAmount: TThostFtdcTradeAmountType;
  end;

///����ǩ����Ӧ
  PhostFtdcRspFutureSignInField = ^ThostFtdcRspFutureSignInField;
  ThostFtdcRspFutureSignInField = record
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ����
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�û���ʶ
    UserID: TThostFtdcUserIDType;
    ///ժҪ
    Digest: TThostFtdcDigestType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///������־
    DeviceID: TThostFtdcDeviceIDType;
    ///�ڻ���˾���б���
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///���׹�Ա
    OperNo: TThostFtdcOperNoType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///����ID
    TID: TThostFtdcTIDType;
    ///�������
    ErrorID: TThostFtdcErrorIDType;
    ///������Ϣ
    ErrorMsg: TThostFtdcErrorMsgType;
    ///PIN��Կ
    PinKey: TThostFtdcPasswordKeyType;
    ///MAC��Կ
    MacKey: TThostFtdcPasswordKeyType;
  end;


///����ǩ����Ӧ
  PhostFtdcRspFutureSignOutField = ^ThostFtdcRspFutureSignOutField;
  ThostFtdcRspFutureSignOutField = record
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ����
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�û���ʶ
    UserID: TThostFtdcUserIDType;
    ///ժҪ
    Digest: TThostFtdcDigestType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///������־
    DeviceID: TThostFtdcDeviceIDType;
    ///�ڻ���˾���б���
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///���׹�Ա
    OperNo: TThostFtdcOperNoType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///����ID
    TID: TThostFtdcTIDType;
    ///�������
    ErrorID: TThostFtdcErrorIDType;
    ///������Ϣ
    ErrorMsg: TThostFtdcErrorMsgType;
  end;

///��ѯָ����ˮ�ŵĽ��׽����Ӧ
  PhostFtdcRspQueryTradeResultBySerialField = ^ThostFtdcRspQueryTradeResultBySerialField;
  ThostFtdcRspQueryTradeResultBySerialField = record
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ����
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///�������
    ErrorID: TThostFtdcErrorIDType;
    ///������Ϣ
    ErrorMsg: TThostFtdcErrorMsgType;
    ///��ˮ��
    Reference: TThostFtdcSerialType;
    ///����ˮ�ŷ����ߵĻ�������
    RefrenceIssureType: TThostFtdcInstitutionTypeType;
    ///����ˮ�ŷ����߻�������
    RefrenceIssure: TThostFtdcOrganCodeType;
    ///ԭʼ���ش���
    OriginReturnCode: TThostFtdcReturnCodeType;
    ///ԭʼ����������
    OriginDescrInfoForReturnCode: TThostFtdcDescrInfoForReturnCodeType;
    ///�����ʺ�
    BankAccount: TThostFtdcBankAccountType;
    ///��������
    BankPassWord: TThostFtdcPasswordType;
    ///Ͷ�����ʺ�
    AccountID: TThostFtdcAccountIDType;
    ///�ڻ�����
    Password: TThostFtdcPasswordType;
    ///���ִ���
    CurrencyID: TThostFtdcCurrencyIDType;
    ///ת�ʽ��
    TradeAmount: TThostFtdcTradeAmountType;
    ///ժҪ
    Digest: TThostFtdcDigestType;
  end;


///���׺��������ڱ��̷�����Կͬ����Ӧ
  PhostFtdcRspSyncKeyField = ^ThostFtdcRspSyncKeyField;
  ThostFtdcRspSyncKeyField = record
    ///ҵ������
    TradeCode: TThostFtdcTradeCodeType;
    ///���д���
    BankID: TThostFtdcBankIDType;
    ///���з�֧��������
    BankBranchID: TThostFtdcBankBrchIDType;
    ///���̴���
    BrokerID: TThostFtdcBrokerIDType;
    ///���̷�֧��������
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///��������
    TradeDate: TThostFtdcTradeDateType;
    ///����ʱ��
    TradeTime: TThostFtdcTradeTimeType;
    ///������ˮ��
    BankSerial: TThostFtdcBankSerialType;
    ///����ϵͳ���� 
    TradingDay: TThostFtdcTradeDateType;
    ///����ƽ̨��Ϣ��ˮ��
    PlateSerial: TThostFtdcSerialType;
    ///����Ƭ��־
    LastFragment: TThostFtdcLastFragmentType;
    ///�Ự��
    SessionID: TThostFtdcSessionIDType;
    ///��װ���
    InstallID: TThostFtdcInstallIDType;
    ///�û���ʶ
    UserID: TThostFtdcUserIDType;
    ///���׺��ĸ����ڱ��̵���Ϣ
    Message: TThostFtdcAddInfoType;
    ///������־
    DeviceID: TThostFtdcDeviceIDType;
    ///�ڻ���˾���б���
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///���׹�Ա
    OperNo: TThostFtdcOperNoType;
    ///������
    RequestID: TThostFtdcRequestIDType;
    ///����ID
    TID: TThostFtdcTIDType;
    ///�������
    ErrorID: TThostFtdcErrorIDType;
    ///������Ϣ
    ErrorMsg: TThostFtdcErrorMsgType;
  end;

implementation

end.
