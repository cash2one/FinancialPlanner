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

  
///用户登录应答
  PhostFtdcRspUserLoginField = ^ThostFtdcRspUserLoginField;
  ThostFtdcRspUserLoginField = record
    TradingDay: TThostFtdcDateType;  ///交易日
    LoginTime: TThostFtdcTimeType; ///登录成功时间
    BrokerID: TThostFtdcBrokerIDType; ///经纪公司代码
    UserID: TThostFtdcUserIDType; ///用户代码
    SystemName: TThostFtdcSystemNameType; ///交易系统名称
    FrontID: TThostFtdcFrontIDType;  ///前置编号
    SessionID: TThostFtdcSessionIDType; ///会话编号
    MaxOrderRef: TThostFtdcOrderRefType;  ///最大报单引用
    SHFETime: TThostFtdcTimeType;  ///上期所时间
    DCETime: TThostFtdcTimeType;  ///大商所时间
    CZCETime: TThostFtdcTimeType; ///郑商所时间
    FFEXTime: TThostFtdcTimeType; ///中金所时间
    INETime: TThostFtdcTimeType;   ///能源中心时间
  end;
          
///客户端认证响应
  PhostFtdcRspAuthenticateField = ^ThostFtdcRspAuthenticateField;   
  ThostFtdcRspAuthenticateField = record
    ///经纪公司代码
    BrokerID: TThostFtdcBrokerIDType;
    ///用户代码
    UserID: TThostFtdcUserIDType;
    ///用户端产品信息
    UserProductInfo: TThostFtdcProductInfoType;
  end;

///银行发起银行资金转期货响应
  PhostFtdcRspTransferField = ^ThostFtdcRspTransferField;
  ThostFtdcRspTransferField = record
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///客户姓名
    CustomerName: TThostFtdcIndividualNameType;
    ///证件类型
    IdCardType: TThostFtdcIdCardTypeType;
    ///证件号码
    IdentifiedCardNo: TThostFtdcIdentifiedCardNoType;
    ///客户类型
    CustType: TThostFtdcCustTypeType;
    ///银行帐号
    BankAccount: TThostFtdcBankAccountType;
    ///银行密码
    BankPassWord: TThostFtdcPasswordType;
    ///投资者帐号
    AccountID: TThostFtdcAccountIDType;
    ///期货密码
    Password: TThostFtdcPasswordType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///期货公司流水号
    FutureSerial: TThostFtdcFutureSerialType;
    ///用户标识
    UserID: TThostFtdcUserIDType;
    ///验证客户证件号码标志
    VerifyCertNoFlag: TThostFtdcYesNoIndicatorType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///转帐金额
    TradeAmount: TThostFtdcTradeAmountType;
    ///期货可取金额
    FutureFetchAmount: TThostFtdcTradeAmountType;
    ///费用支付标志
    FeePayFlag: TThostFtdcFeePayFlagType;
    ///应收客户费用
    CustFee: TThostFtdcCustFeeType;
    ///应收期货公司费用
    BrokerFee: TThostFtdcFutureFeeType;
    ///发送方给接收方的消息
    Message: TThostFtdcAddInfoType;
    ///摘要
    Digest: TThostFtdcDigestType;
    ///银行帐号类型
    BankAccType: TThostFtdcBankAccTypeType;
    ///渠道标志
    DeviceID: TThostFtdcDeviceIDType;
    ///期货单位帐号类型
    BankSecuAccType: TThostFtdcBankAccTypeType;
    ///期货公司银行编码
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///期货单位帐号
    BankSecuAcc: TThostFtdcBankAccountType;
    ///银行密码标志
    BankPwdFlag: TThostFtdcPwdFlagType;
    ///期货资金密码核对标志
    SecuPwdFlag: TThostFtdcPwdFlagType;
    ///交易柜员
    OperNo: TThostFtdcOperNoType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///交易ID
    TID: TThostFtdcTIDType;
    ///转账交易状态
    TransferStatus: TThostFtdcTransferStatusType;
    ///错误代码
    ErrorID: TThostFtdcErrorIDType;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
  end;


///冲正响应
  PhostFtdcRspRepealField = ^ThostFtdcRspRepealField;
  ThostFtdcRspRepealField = record
    ///冲正时间间隔
    RepealTimeInterval: TThostFtdcRepealTimeIntervalType;
    ///已经冲正次数
    RepealedTimes: TThostFtdcRepealedTimesType;
    ///银行冲正标志
    BankRepealFlag: TThostFtdcBankRepealFlagType;
    ///期商冲正标志
    BrokerRepealFlag: TThostFtdcBrokerRepealFlagType;
    ///被冲正平台流水号
    PlateRepealSerial: TThostFtdcPlateSerialType;
    ///被冲正银行流水号
    BankRepealSerial: TThostFtdcBankSerialType;
    ///被冲正期货流水号
    FutureRepealSerial: TThostFtdcFutureSerialType;
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///客户姓名
    CustomerName: TThostFtdcIndividualNameType;
    ///证件类型
    IdCardType: TThostFtdcIdCardTypeType;
    ///证件号码
    IdentifiedCardNo: TThostFtdcIdentifiedCardNoType;
    ///客户类型
    CustType: TThostFtdcCustTypeType;
    ///银行帐号
    BankAccount: TThostFtdcBankAccountType;
    ///银行密码
    BankPassWord: TThostFtdcPasswordType;
    ///投资者帐号
    AccountID: TThostFtdcAccountIDType;
    ///期货密码
    Password: TThostFtdcPasswordType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///期货公司流水号
    FutureSerial: TThostFtdcFutureSerialType;
    ///用户标识
    UserID: TThostFtdcUserIDType;
    ///验证客户证件号码标志
    VerifyCertNoFlag: TThostFtdcYesNoIndicatorType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///转帐金额
    TradeAmount: TThostFtdcTradeAmountType;
    ///期货可取金额
    FutureFetchAmount: TThostFtdcTradeAmountType;
    ///费用支付标志
    FeePayFlag: TThostFtdcFeePayFlagType;
    ///应收客户费用
    CustFee: TThostFtdcCustFeeType;
    ///应收期货公司费用
    BrokerFee: TThostFtdcFutureFeeType;
    ///发送方给接收方的消息
    Message: TThostFtdcAddInfoType;
    ///摘要
    Digest: TThostFtdcDigestType;
    ///银行帐号类型
    BankAccType: TThostFtdcBankAccTypeType;
    ///渠道标志
    DeviceID: TThostFtdcDeviceIDType;
    ///期货单位帐号类型
    BankSecuAccType: TThostFtdcBankAccTypeType;
    ///期货公司银行编码
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///期货单位帐号
    BankSecuAcc: TThostFtdcBankAccountType;
    ///银行密码标志
    BankPwdFlag: TThostFtdcPwdFlagType;
    ///期货资金密码核对标志
    SecuPwdFlag: TThostFtdcPwdFlagType;
    ///交易柜员
    OperNo: TThostFtdcOperNoType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///交易ID
    TID: TThostFtdcTIDType;
    ///转账交易状态
    TransferStatus: TThostFtdcTransferStatusType;
    ///错误代码
    ErrorID: TThostFtdcErrorIDType;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
  end;


///查询账户信息响应
  PhostFtdcRspQueryAccountField = ^ThostFtdcRspQueryAccountField;
  ThostFtdcRspQueryAccountField = record
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///客户姓名
    CustomerName: TThostFtdcIndividualNameType;
    ///证件类型
    IdCardType: TThostFtdcIdCardTypeType;
    ///证件号码
    IdentifiedCardNo: TThostFtdcIdentifiedCardNoType;
    ///客户类型
    CustType: TThostFtdcCustTypeType;
    ///银行帐号
    BankAccount: TThostFtdcBankAccountType;
    ///银行密码
    BankPassWord: TThostFtdcPasswordType;
    ///投资者帐号
    AccountID: TThostFtdcAccountIDType;
    ///期货密码
    Password: TThostFtdcPasswordType;
    ///期货公司流水号
    FutureSerial: TThostFtdcFutureSerialType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///用户标识
    UserID: TThostFtdcUserIDType;
    ///验证客户证件号码标志
    VerifyCertNoFlag: TThostFtdcYesNoIndicatorType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///摘要
    Digest: TThostFtdcDigestType;
    ///银行帐号类型
    BankAccType: TThostFtdcBankAccTypeType;
    ///渠道标志
    DeviceID: TThostFtdcDeviceIDType;
    ///期货单位帐号类型
    BankSecuAccType: TThostFtdcBankAccTypeType;
    ///期货公司银行编码
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///期货单位帐号
    BankSecuAcc: TThostFtdcBankAccountType;
    ///银行密码标志
    BankPwdFlag: TThostFtdcPwdFlagType;
    ///期货资金密码核对标志
    SecuPwdFlag: TThostFtdcPwdFlagType;
    ///交易柜员
    OperNo: TThostFtdcOperNoType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///交易ID
    TID: TThostFtdcTIDType;
    ///银行可用金额
    BankUseAmount: TThostFtdcTradeAmountType;
    ///银行可取金额
    BankFetchAmount: TThostFtdcTradeAmountType;
  end;

///期商签到响应
  PhostFtdcRspFutureSignInField = ^ThostFtdcRspFutureSignInField;
  ThostFtdcRspFutureSignInField = record
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///用户标识
    UserID: TThostFtdcUserIDType;
    ///摘要
    Digest: TThostFtdcDigestType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///渠道标志
    DeviceID: TThostFtdcDeviceIDType;
    ///期货公司银行编码
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///交易柜员
    OperNo: TThostFtdcOperNoType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///交易ID
    TID: TThostFtdcTIDType;
    ///错误代码
    ErrorID: TThostFtdcErrorIDType;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
    ///PIN密钥
    PinKey: TThostFtdcPasswordKeyType;
    ///MAC密钥
    MacKey: TThostFtdcPasswordKeyType;
  end;


///期商签退响应
  PhostFtdcRspFutureSignOutField = ^ThostFtdcRspFutureSignOutField;
  ThostFtdcRspFutureSignOutField = record
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///用户标识
    UserID: TThostFtdcUserIDType;
    ///摘要
    Digest: TThostFtdcDigestType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///渠道标志
    DeviceID: TThostFtdcDeviceIDType;
    ///期货公司银行编码
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///交易柜员
    OperNo: TThostFtdcOperNoType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///交易ID
    TID: TThostFtdcTIDType;
    ///错误代码
    ErrorID: TThostFtdcErrorIDType;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
  end;

///查询指定流水号的交易结果响应
  PhostFtdcRspQueryTradeResultBySerialField = ^ThostFtdcRspQueryTradeResultBySerialField;
  ThostFtdcRspQueryTradeResultBySerialField = record
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///错误代码
    ErrorID: TThostFtdcErrorIDType;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
    ///流水号
    Reference: TThostFtdcSerialType;
    ///本流水号发布者的机构类型
    RefrenceIssureType: TThostFtdcInstitutionTypeType;
    ///本流水号发布者机构编码
    RefrenceIssure: TThostFtdcOrganCodeType;
    ///原始返回代码
    OriginReturnCode: TThostFtdcReturnCodeType;
    ///原始返回码描述
    OriginDescrInfoForReturnCode: TThostFtdcDescrInfoForReturnCodeType;
    ///银行帐号
    BankAccount: TThostFtdcBankAccountType;
    ///银行密码
    BankPassWord: TThostFtdcPasswordType;
    ///投资者帐号
    AccountID: TThostFtdcAccountIDType;
    ///期货密码
    Password: TThostFtdcPasswordType;
    ///币种代码
    CurrencyID: TThostFtdcCurrencyIDType;
    ///转帐金额
    TradeAmount: TThostFtdcTradeAmountType;
    ///摘要
    Digest: TThostFtdcDigestType;
  end;


///交易核心向银期报盘发出密钥同步响应
  PhostFtdcRspSyncKeyField = ^ThostFtdcRspSyncKeyField;
  ThostFtdcRspSyncKeyField = record
    ///业务功能码
    TradeCode: TThostFtdcTradeCodeType;
    ///银行代码
    BankID: TThostFtdcBankIDType;
    ///银行分支机构代码
    BankBranchID: TThostFtdcBankBrchIDType;
    ///期商代码
    BrokerID: TThostFtdcBrokerIDType;
    ///期商分支机构代码
    BrokerBranchID: TThostFtdcFutureBranchIDType;
    ///交易日期
    TradeDate: TThostFtdcTradeDateType;
    ///交易时间
    TradeTime: TThostFtdcTradeTimeType;
    ///银行流水号
    BankSerial: TThostFtdcBankSerialType;
    ///交易系统日期 
    TradingDay: TThostFtdcTradeDateType;
    ///银期平台消息流水号
    PlateSerial: TThostFtdcSerialType;
    ///最后分片标志
    LastFragment: TThostFtdcLastFragmentType;
    ///会话号
    SessionID: TThostFtdcSessionIDType;
    ///安装编号
    InstallID: TThostFtdcInstallIDType;
    ///用户标识
    UserID: TThostFtdcUserIDType;
    ///交易核心给银期报盘的消息
    Message: TThostFtdcAddInfoType;
    ///渠道标志
    DeviceID: TThostFtdcDeviceIDType;
    ///期货公司银行编码
    BrokerIDByBank: TThostFtdcBankCodingForFutureType;
    ///交易柜员
    OperNo: TThostFtdcOperNoType;
    ///请求编号
    RequestID: TThostFtdcRequestIDType;
    ///交易ID
    TID: TThostFtdcTIDType;
    ///错误代码
    ErrorID: TThostFtdcErrorIDType;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
  end;

implementation

end.
