unit ThostFtdcBaseDataType;

interface

type
  TThostFtdcPriceType = Double;  
  TThostFtdcMoneyType = Double;
  TThostFtdcRatioType = Double; 
  TThostFtdcLargeVolumeType = Double;
  TThostFtdcUnderlyingMultipleType = Double;
                                         
  TThostFtdcBoolType = Integer;     
  TThostFtdcErrorIDType = Integer;
  TThostFtdcVolumeType = Integer;    
  TThostFtdcMillisecType = Integer;  
  TThostFtdcFrontIDType = Integer;   
  TThostFtdcSessionIDType = Integer;  
  TThostFtdcInstallIDType = Integer;
  TThostFtdcYearType = Integer;
  TThostFtdcMonthType = Integer;
  TThostFtdcVolumeMultipleType = Integer;

  TThostFtdcYesNoIndicatorType = AnsiChar;
  TThostFtdcProductClassType = AnsiChar;
  TThostFtdcInstLifePhaseType = AnsiChar;
  TThostFtdcPositionTypeType = AnsiChar;
  TThostFtdcPositionDateTypeType = AnsiChar;
  TThostFtdcMaxMarginSideAlgorithmType = AnsiChar;
  TThostFtdcOptionsTypeType = AnsiChar;
  TThostFtdcCombinationTypeType = AnsiChar;
                                    
  TThostFtdcDateType = array[0..8] of AnsiChar;  
  TThostFtdcTimeType = array[0..8] of AnsiChar;      
  TThostFtdcCurrencyIDType = array[0..3] of AnsiChar; 
  TThostFtdcSystemNameType = array[0..40] of AnsiChar;   
  TThostFtdcErrorMsgType = array[0..80] of AnsiChar;
  TThostFtdcInstrumentIDType = array[0..30] of AnsiChar;    
  TThostFtdcInstrumentNameType = array[0..20] of AnsiChar;
                    
///响应信息
  PhostFtdcRspInfoField = ^ThostFtdcRspInfoField;
  ThostFtdcRspInfoField = record
    ///错误代码
    ErrorID: TThostFtdcErrorIDType	;
    ///错误信息
    ErrorMsg: TThostFtdcErrorMsgType;
  end;

implementation

end.
