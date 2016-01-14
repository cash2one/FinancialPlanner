unit define_datasrc;

interface

uses
  define_StockItem;
               
const          
  DataSrc_CTP        = 11;
  DataSrc_Standard   = 12; // �����ٷ� ֤ȯ������
                           
  DataSrc_TongDaXin  = 21; // ͨ����
  DataSrc_TongHuaSun = 22; // ͬ��˳
  DataSrc_DaZhiHui   = 23; // ���ǻ�

  DataSrc_Sina       = 31;
  DataSrc_163        = 32;
  DataSrc_QQ         = 33;
  DataSrc_XQ         = 34; // ѩ��
            
  function GetDataSrcCode(ADataSrc: integer): String;
                                                     
  function GetStockCode_163(AStockItem: PRT_StockItem): string;
  function GetStockCode_Sina(AStockItem: PRT_StockItem): string;
              
implementation
         
function GetDataSrcCode(ADataSrc: integer): String;
begin
  Result := '';
  case ADataSrc of
    DataSrc_CTP        : Result := 'cp';
    DataSrc_Standard   : Result := 'gov'; //  official �����ٷ� ֤ȯ������
    DataSrc_Sina       : Result := 'sina';
    DataSrc_163        : Result := '163';
    DataSrc_QQ         : Result := 'qq';
    DataSrc_XQ         : Result := 'xq'; // ѩ��
    
    DataSrc_TongDaXin  : Result := 'tdx'; // ͨ����
    DataSrc_TongHuaSun : Result := 'ths'; // ͬ��˳
    DataSrc_DaZhiHui   : Result := 'dzh'; // ���ǻ�
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
