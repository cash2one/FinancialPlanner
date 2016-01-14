unit define_datasrc;

interface

uses
  define_StockItem;
               
const          
  DataSrc_CTP        = 11;
  DataSrc_Standard   = 12; // 来至官方 证券交易所
                           
  DataSrc_TongDaXin  = 21; // 通达信
  DataSrc_TongHuaSun = 22; // 同花顺
  DataSrc_DaZhiHui   = 23; // 大智慧

  DataSrc_Sina       = 31;
  DataSrc_163        = 32;
  DataSrc_QQ         = 33;
  DataSrc_XQ         = 34; // 雪球
            
  function GetDataSrcCode(ADataSrc: integer): String;
                                                     
  function GetStockCode_163(AStockItem: PRT_StockItem): string;
  function GetStockCode_Sina(AStockItem: PRT_StockItem): string;
              
implementation
         
function GetDataSrcCode(ADataSrc: integer): String;
begin
  Result := '';
  case ADataSrc of
    DataSrc_CTP        : Result := 'cp';
    DataSrc_Standard   : Result := 'gov'; //  official 来至官方 证券交易所
    DataSrc_Sina       : Result := 'sina';
    DataSrc_163        : Result := '163';
    DataSrc_QQ         : Result := 'qq';
    DataSrc_XQ         : Result := 'xq'; // 雪球
    
    DataSrc_TongDaXin  : Result := 'tdx'; // 通达信
    DataSrc_TongHuaSun : Result := 'ths'; // 同花顺
    DataSrc_DaZhiHui   : Result := 'dzh'; // 大智慧
  end;
end;
         
function GetStockCode_163(AStockItem: PRT_StockItem): string;
begin
  if AStockItem.sCode[1] = '6' then
  begin
    Result := '0' + AStockItem.sCode;
  end else
  begin
    Result := '1' + AStockItem.sCode;
  end;
end;
      
function GetStockCode_Sina(AStockItem: PRT_StockItem): string;
begin
  if AStockItem.sCode[1] = '6' then
  begin
    Result := 'sh' + AStockItem.sCode;
  end else
  begin
    Result := 'sz' + AStockItem.sCode;
  end;
end;

end.
