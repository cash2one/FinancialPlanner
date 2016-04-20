unit ctpConsoleAppCommandWnd_CopyData;

interface

uses
  Windows;
                 
  procedure DoWMCopyData(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);

implementation

uses
  SysUtils,
  UtilsLog,
  define_app_msg,
  define_ctp_quote,
  define_ctp_deal,
  TcpQuoteAgent,
  TcpAgentConsole,
  ThostFtdcTraderApiDataDefine,
  ThostFtdcBaseDataType,
  ThostFtdcUserApiDataType,
  ThostFtdcTraderApiDataType,
  ThostFtdcMdApiDataType;
                           
procedure HandleMDRspUserLogin(ARsqUserLogin: PhostFtdcRspUserLoginField);
begin
  if ARsqUserLogin <> nil then
  begin
  end;
end;
                    
procedure HandleDealRspUserLogin(ARsqUserLogin: PhostFtdcRspUserLoginField);
begin
  if ARsqUserLogin <> nil then
  begin
  end;
end;

procedure HandleDepthMarketData(AMarketData: PhostFtdcDepthMarketDataField);
var
  tmpInstrumentCode: AnsiString;
  tmpRTQuoteData: PRT_QuoteData;
begin
  if AMarketData <> nil then
  begin                  
    tmpInstrumentCode := AMarketData.InstrumentID;
    tmpRTQuoteData := GTcpAgentConsole.Quote.CheckOutQuoteData(tmpInstrumentCode);
    if tmpRTQuoteData <> nil then
    begin
      Inc(tmpRTQuoteData.RecordCount);
      if tmpRTQuoteData.CurrentRecords = nil then
        tmpRTQuoteData.CurrentRecords := CheckOutQuoteDataRecords(tmpRTQuoteData);
      if tmpRTQuoteData.CurrentRecords <> nil then
      begin
        if tmpRTQuoteData.Header.PreClosePrice.Value = 0 then
        begin
          FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.PreClosePrice, AMarketData.PreClosePrice);
          FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.PreSettlementPrice, AMarketData.PreSettlementPrice);
          FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.PriceRange.PriceOpen, AMarketData.OpenPrice);
          FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.UpperLimitPrice, AMarketData.UpperLimitPrice);
          FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.LowerLimitPrice, AMarketData.LowerLimitPrice);
          tmpRTQuoteData.Header.PreOpenInterest := AMarketData.PreOpenInterest;
          CopyMemory(@tmpRTQuoteData.Header.InstrumentCode[0], @tmpInstrumentCode[1], Length(tmpInstrumentCode));
        end;

        FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.PriceRange.PriceHigh, AMarketData.HighestPrice);
        FtdcPrice2RTPricePack(@tmpRTQuoteData.Header.PriceRange.PriceLow, AMarketData.LowestPrice);                            
        
        MarketData2QuoteData(AMarketData, @tmpRTQuoteData.CurrentRecords.Datas[tmpRTQuoteData.CurrentRecords.Index]);
        tmpRTQuoteData.CurrentRecords.Datas[tmpRTQuoteData.CurrentRecords.Index].Status := 1;
        Inc(tmpRTQuoteData.CurrentRecords.Index);
        if tmpRTQuoteData.CurrentRecords.Index >= RT_QuoteDataArraySize then
        begin
          tmpRTQuoteData.CurrentRecords := CheckOutQuoteDataRecords(tmpRTQuoteData);
        end;
      end;
    end;
  end;  
end;

procedure HandleTradingAccount(ATradingAccount: PhostFtdcTradingAccountField);
begin
   // 查询保证金
  if ATradingAccount = nil then
    exit;
  //PTradingAccount(@GTcpAgentConsole.Deal.OrgData.TradingAccount).Data := ATradingAccount^;
  if ATradingAccount.AccountID <> '' then
  begin

  end;
end;

procedure HandleInvestorPosition(AInvestorPosition: PhostFtdcInvestorPositionField);
var
  tmpInstrumentId: AnsiString;
//  tmpInvestorPosition: PInvestorPosition;
begin
  if AInvestorPosition = nil then
    Exit;
  // 查询持仓
  tmpInstrumentId := AInvestorPosition.InstrumentId;
//  tmpInvestorPosition := GTcpAgentConsole.Deal.OrgData.CheckOutInvestorPosition(tmpInstrumentId);
//  if tmpInvestorPosition <> nil then
//  begin
//    tmpInvestorPosition.Data := AInvestorPosition^;
//  end;
  if AInvestorPosition.InvestorID <> '' then
  begin

  end;
end;

procedure HandleInputOrder(AInputOrder: PhostFtdcInputOrderField);
var
  tmpDeal: PDeal;
  tmpInputOrder: PInputOrder;
begin
  if AInputOrder = nil then
    exit;          
  // 报单回报   
  //tmpInputOrder := GTcpAgentConsole.Deal.OrgData.CheckOutInputOrder;
  if tmpInputOrder <> nil then
  begin
    tmpInputOrder.Data := AInputOrder^;
  end;
  if AInputOrder.RequestID <> 0 then
  begin
    tmpDeal := GTcpAgentConsole.Deal.FindDealByRequestId(AInputOrder.RequestID);
    if tmpDeal <> nil then
    begin
      //tmpDeal.OrderResponse := GTcpAgentConsole.Deal.CheckOutOrderResponse(tmpDeal);
          //tmpDeal.OrderResponse.ExchangeID := tmpData3.
          //tmpDeal.OrderResponse.OrderSysID :=
    end;
  end;    
end;

procedure HandleRspOrderAction(AOrderAction: PhostFtdcInputOrderActionField);
var
  tmpInputOrderAction: PInputOrderAction;
begin           
  // 撤单回报
  if AOrderAction = nil then
    exit;       
  //tmpInputOrderAction := GTcpAgentConsole.Deal.OrgData.CheckOutInputOrderAction;
  if tmpInputOrderAction <> nil then
  begin
    tmpInputOrderAction.Data := AOrderAction^;
  end;
end;

procedure HandleRspQryInstrument(AInstrument: PhostFtdcInstrumentField);
begin
  // 查询合约
  if AInstrument = nil then
    exit;
  if AInstrument.ExchangeID <> '' then
  begin

  end;
end;

procedure HandleRtnOrder(AWnd: HWND; AOrder: PhostFtdcOrderField);  
var
  tmpDeal: PDeal;
  tmpOrder: POrder;
  tmpIsHandleStep: Boolean;
begin           
  //报单回报
  if AOrder <> nil then
  begin
    //tmpOrder := GTcpAgentConsole.Deal.OrgData.CheckOutOrder;
    if tmpOrder <> nil then
    begin
      tmpOrder.MsgSrc := WM_S2C_RtnOrder;
      tmpOrder.Data := AOrder^;
    end;
    //tmpData5.BrokerOrderSeq  198219                               
    tmpDeal := GTcpAgentConsole.Deal.FindDealByBrokerOrderSeq(AOrder.BrokerOrderSeq);
//    if tmpDeal = nil then
//    begin
//      tmpDeal := GTcpAgentConsole.Deal.FindDealByRequestId(AOrder.RequestID);
//    end;
    if tmpDeal = nil then
    begin
//      if GTcpAgentConsole.Deal.LastRequestDeal <> nil then
//      begin
//        if GTcpAgentConsole.Deal.LastRequestDeal.BrokerOrderSeq = 0 then
//        begin
//          tmpDeal := GTcpAgentConsole.Deal.LastRequestDeal;
//          tmpDeal.BrokerOrderSeq := AOrder.BrokerOrderSeq;
//        end;
//      end;
    end;
    if tmpDeal = nil then
    begin
      tmpDeal := GTcpAgentConsole.Deal.CheckOutDeal;    
      tmpDeal.Status := deal_Unknown;
      tmpDeal.BrokerOrderSeq := AOrder.BrokerOrderSeq;
      tmpDeal.OrderRequest.RequestId := AOrder.RequestID;   
      if tmpDeal.OrderRequest.Price = 0 then
      begin
        tmpDeal.OrderRequest.Price := AOrder.LimitPrice;
      end;
      if THOST_FTDC_D_Buy = AOrder.Direction then
      begin
        tmpDeal.OrderRequest.Direction := directionBuy;
      end else if THOST_FTDC_D_Sell = AOrder.Direction then
      begin
        tmpDeal.OrderRequest.Direction := directionSale;
      end;
                    
      tmpIsHandleStep := false;
      if THOST_FTDC_OF_Open = AOrder.CombOffsetFlag then
      begin                        
        tmpDeal.OrderRequest.Mode := modeOpen;
        tmpIsHandleStep := true;
      end;
      if not tmpIsHandleStep then
      begin
        if THOST_FTDC_OF_Close = AOrder.CombOffsetFlag then
        begin
          tmpDeal.OrderRequest.Mode := modeCloseOut;
          tmpIsHandleStep := true;
        end;
      end;        
      if not tmpIsHandleStep then
      begin
        if THOST_FTDC_OF_ForceClose = AOrder.CombOffsetFlag then
        begin
          tmpDeal.OrderRequest.Mode := modeCloseOut;
          tmpIsHandleStep := true;
        end;
      end;         
      if not tmpIsHandleStep then
      begin
        if THOST_FTDC_OF_CloseToday = AOrder.CombOffsetFlag then
        begin
          tmpDeal.OrderRequest.Mode := modeCloseOut;
          tmpIsHandleStep := true;
        end;
      end;           
      if not tmpIsHandleStep then
      begin
        if THOST_FTDC_OF_CloseYesterday = AOrder.CombOffsetFlag then
        begin
          tmpDeal.OrderRequest.Mode := modeCloseOut;
          tmpIsHandleStep := true;
        end;
      end;     
      if not tmpIsHandleStep then
      begin
      end;
    end;
    if tmpDeal <> nil then
    begin                 
      if tmpDeal.OrderResponse = nil then
      begin
        //tmpDeal.OrderResponse := GTcpAgentConsole.Deal.CheckOutOrderResponse(tmpDeal);
      end;
      if tmpDeal.ExchangeID = '' then // CFFEX
        tmpDeal.ExchangeID := AOrder.ExchangeID; // CFFEX
      if tmpDeal.OrderSysID = '' then
        tmpDeal.OrderSysID := AOrder.OrderSysID;
        
      tmpIsHandleStep := false;
      // 全部成交 '0'
      if THOST_FTDC_OST_AllTraded = AOrder.OrderStatus then
      begin              
        tmpIsHandleStep := true;   
        tmpDeal.Status := deal_Deal;
//        if tmpDeal.OrderRequest.Mode = modeOpen then
//        begin                         
//          if GTcpAgentConsole.Deal.LastRequestDeal <> nil then
//          begin
//            if GTcpAgentConsole.Deal.LastRequestDeal.BrokerOrderSeq = AOrder.BrokerOrderSeq then
//            begin
//              PostMessage(AWnd, WM_M2M_OpenDeal, Integer(tmpDeal), 0);
//            end;
//          end;
//        end;
      end;
      if not tmpIsHandleStep then
      begin
        // 撤单 '5'
        if THOST_FTDC_OST_Canceled = AOrder.OrderStatus then
        begin
          tmpDeal.Status := deal_Cancel;
        end;
      end;
    end;
  end;
end;

procedure HandleRspQryOrder(AOrder: PhostFtdcOrderField);
var          
  tmpOrder: POrder;
begin
  // 查询报单   
  if AOrder <> nil then
  begin
    //tmpOrder := GTcpAgentConsole.Deal.OrgData.CheckOutOrder;
    if tmpOrder <> nil then
    begin           
      tmpOrder.MsgSrc := WM_S2C_RspQryOrder;
      tmpOrder.Data := AOrder^;
    end;
  end;
end;

procedure HandleRtnTrade(AWnd: HWND; ATrade: PhostFtdcTradeField);   
var          
  tmpTrade: PTrade;     
  tmpDeal: PDeal;
  tmpDealResponse: PDealResponse;
begin  
  //成交通知
  if ATrade <> nil then
  begin
    //tmpTrade := GTcpAgentConsole.Deal.OrgData.CheckOutTrade;
    if tmpTrade <> nil then
    begin
      tmpTrade.MsgSrc := WM_S2C_RtnTrade;
      tmpTrade.Data := ATrade^;
      
      tmpDeal := GTcpAgentConsole.Deal.FindDealByBrokerOrderSeq(ATrade.BrokerOrderSeq);
      if tmpDeal <> nil then
      begin
        //tmpDealResponse := GTcpAgentConsole.Deal.CheckOutOrderDeal(tmpDeal);
        if tmpDealResponse <> nil then
        begin
          tmpDealResponse.Price := ATrade.Price;

          if tmpDeal.OrderRequest.Mode = modeOpen then
          begin                         
            //if GTcpAgentConsole.Deal.LastRequestDeal <> nil then
            begin
              //if GTcpAgentConsole.Deal.LastRequestDeal.BrokerOrderSeq = ATrade.BrokerOrderSeq then
              begin
                PostMessage(AWnd, WM_M2M_OpenDeal, Integer(tmpDeal), 0);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure HandleRspQryTrade(ATrade: PhostFtdcTradeField);    
var          
  tmpTrade: PTrade;
begin
  // 查询成交   
  if ATrade <> nil then
  begin
    //tmpTrade := GTcpAgentConsole.Deal.OrgData.CheckOutTrade;
    if tmpTrade <> nil then
    begin
      tmpTrade.MsgSrc := WM_S2C_RspQryTrade;
      tmpTrade.Data := ATrade^;
    end;
  end;
end;

procedure HandleMDIsErrorRspInfo(ARspInfo: PhostFtdcRspInfoField);
begin
  if ARspInfo = nil then
    exit;
end;
              
procedure HandleDealIsErrorRspInfo(ARspInfo: PhostFtdcRspInfoField);
begin
  if ARspInfo = nil then
    exit;
end;

procedure HandleWMCopyData(AWnd: HWND; wParam: WPARAM; ACopyData: PCopyDataStruct);
begin
  if ACopyData = nil then
    exit;
  if ACopyData.dwData <> WM_S2C_RtnDepthMarketData then
  begin
    sdlog('WMCopyData.pas', 'HandleWMCopyData ' + IntToStr(ACopyData.dwData) + ' ' + MsgText(ACopyData.dwData));
  end;
  case ACopyData.dwData of
    WM_S2C_MD_IsErrorRspInfo: begin
      HandleMDIsErrorRspInfo(ACopyData.lpData);
    end;
    WM_S2C_MD_RspUserLogin: begin
      HandleMDRspUserLogin(ACopyData.lpData);
    end;
    WM_S2C_Deal_IsErrorRspInfo: begin
      HandleDealIsErrorRspInfo(ACopyData.lpData);
    end;
    WM_S2C_Deal_RspUserLogin: begin
      HandleDealRspUserLogin(ACopyData.lpData); 
    end;
    WM_S2C_RtnDepthMarketData: begin
      HandleDepthMarketData(ACopyData.lpData);
    end;
    WM_S2C_RspSettlementInfoConfirm: begin
    
    end;
    WM_S2C_RspQryTradingAccount: begin
      HandleTradingAccount(ACopyData.lpData);
    end;
    WM_S2C_RspQryInvestorPosition: begin
      HandleInvestorPosition(ACopyData.lpData);
    end;
    WM_S2C_RspOrderInsert: begin
      HandleInputOrder(ACopyData.lpData);
    end;
    WM_S2C_RspOrderAction: begin
      HandleRspOrderAction(ACopyData.lpData);
    end;
    WM_S2C_RtnOrder: begin
      HandleRtnOrder(AWnd, ACopyData.lpData);
    end;
    WM_S2C_RtnTrade: begin
      HandleRtnTrade(AWnd, ACopyData.lpData);
    end;
    WM_S2C_RspQryInstrument: begin
      HandleRspQryInstrument(ACopyData.lpData);
    end;
    WM_S2C_RspQryOrder: begin
      HandleRspQryOrder(ACopyData.lpData);
    end;
    WM_S2C_RspQryTrade: begin
      HandleRspQryTrade(ACopyData.lpData);
    end;
  end;
end;

procedure DoWMCopyData(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM);  
//var
//  tmpCopyDataStruct: PCopyDataStruct;
//  tmpData: PhostFtdcDepthMarketDataField;
begin
  //AppCmdWinLog('DoWMCopyData');  
  HandleWMCopyData(AWnd, wParam, PCopyDataStruct(lParam));
//  if Assigned(App.AppCmdWMCopyData) then
//  begin
//    App.AppCmdWMCopyData(AWnd, AMsg, wParam, lParam);
//  end;
end;

end.
