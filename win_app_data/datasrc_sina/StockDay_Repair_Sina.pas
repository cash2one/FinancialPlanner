unit StockDay_Repair_Sina;

interface

uses
  BaseApp;

  procedure RepairStockDataDay_Sina_All(App: TBaseApp; AIsWeight: Boolean);

implementation

uses
  Windows,
  Sysutils,
  Classes,
  UtilsHttp,
  Define_Price,
  Define_DealItem,
  Define_DataSrc,    
  define_stock_quotes,
  StockDayData_Repair_Sina,
     
  UtilsDateTime,
  HtmlParser,
  UtilsLog,
  
  StockDayDataAccess,
  StockDayData_Load,
  StockDayData_Save,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save;                 
                    

procedure TestParseHtmlDom;
begin

end;
                  

procedure TestParseDiHtml;
begin

end;
            
procedure TestParseHtml;
begin

end;
                 
procedure DoTest(App: TBaseApp; ADealItem: PRT_DealItem; AIsWeight: Boolean);
var
  tmpTestStockDataAccess: TStockDayDataAccess;
begin
  tmpTestStockDataAccess := TStockDayDataAccess.Create(ADealItem, DataSrc_Sina, AIsWeight);
  StockDayData_Load.LoadStockDayData(App, tmpTestStockDataAccess);
  if 0 < tmpTestStockDataAccess.RecordCount then
  begin
    //DataGet_DayData_Sina(tmpTestStockDataAccess, 2014, 2, AIsWeight, @tmpRepairSession);
  end;
end;

procedure RepairStockDataDay_Sina_All(App: TBaseApp; AIsWeight: Boolean);
var
  tmpDBStockItem: TDBDealItem;
  tmpRepairSession: TRepairSession;
  i: integer;
  tmpDealItem: PRT_DealItem;
  tmpRepeat: Integer;
  tmpIsTest: Boolean;
begin
  FillChar(tmpRepairSession, SizeOf(tmpRepairSession), 0);
  tmpRepairSession.NetSession.IsKeepAlive := true;
  tmpRepairSession.NetSession.ConnectionSession.ConnectTimeOut := 5000;
  tmpRepairSession.NetSession.ConnectionSession.ReceiveTimeOut := 5000;
  tmpRepairSession.NetSession.ConnectionSession.SendTimeOut := 1000;

  tmpIsTest := true; 
  tmpIsTest := false;
  tmpDBStockItem := TDBDealItem.Create;
  try
    LoadDBStockItemDic(App, tmpDBStockItem);
    for i := 0 to tmpDBStockItem.RecordCount - 1 do
    begin
      tmpDealItem := tmpDBStockItem.Items[i];
      if 0 = tmpDealItem.EndDealDate then
      begin
        try            
          if nil <> tmpRepairSession.StockDataSina then
            FreeAndNil(tmpRepairSession.StockDataSina);
          if nil <> tmpRepairSession.StockData163 then
            FreeAndNil(tmpRepairSession.StockData163);
          if tmpIsTest then
          begin
            if not SameText('600064', tmpDealItem.sCode) then
            begin
              Continue;
            end;
            DoTest(App, tmpDealItem, AIsWeight);
            exit;
          end;
          if RepairStockDataDay_Sina(App, tmpDealItem, AIsWeight, @tmpRepairSession) then
          begin
            //Log('', 'GetStockDataDay_Sina ' + tmpDealItem.sCode + ' Succ');
            Sleep(200);
            if RepairStockDataDay_Sina(App, tmpDealItem, AIsWeight, @tmpRepairSession) then
            begin
              Sleep(200);
              if RepairStockDataDay_Sina(App, tmpDealItem, AIsWeight, @tmpRepairSession) then
              begin
                Sleep(200);
              end;
            end;
          end else
          begin
            //Log('', 'GetStockDataDay_Sina ' + tmpDealItem.sCode + ' Fail');
          end;
        finally
          if nil <> tmpRepairSession.StockDataSina then
            FreeAndNil(tmpRepairSession.StockDataSina);
          if nil <> tmpRepairSession.StockData163 then
            FreeAndNil(tmpRepairSession.StockData163);
        end;
      end;
    end;
  finally
    tmpDBStockItem.Free;
  end;
end;

end.
