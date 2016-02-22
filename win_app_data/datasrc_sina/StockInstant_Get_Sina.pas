unit StockInstant_Get_Sina;

interface

uses
  BaseApp;

  procedure GetStockDataInstant_Sina_All(App: TBaseApp);

implementation

uses
  define_datasrc,
  DB_DealItem,
  DB_DealItem_Load,
  DB_DealItem_Save,    
  define_dealitem,  
  UtilsHttp,
  Windows,
  StockInstantDataAccess,
  StockInstantData_Get_Sina;                 
                    
procedure GetStockDataInstant_Sina_All(App: TBaseApp);
var
  tmpDBStockItem: TDBDealItem;
  tmpDBStockInstant: TDBStockInstant;
  tmpInstantArray: TInstantArray;
  i: integer;
  tmpIdx: integer;     
  tmpHttpClientSession: THttpClientSession;
  //tmpPathUrl: AnsiString;
  //tmpFileUrl: AnsiString;
begin
  tmpDBStockItem := TDBDealItem.Create;
  tmpDBStockInstant := TDBStockInstant.Create(DataSrc_Sina);
  try
    LoadDBStockItem(App, tmpDBStockItem);
                       
    //=================
//    tmpPathUrl := App.Path.DataBasePath[Define_Store_File.FilePath_DBType_InstantData, 0];
//    tmpFileUrl := tmpPathUrl + Copy(FormatDateTime('yyyymmdd', now()), 7, MaxInt) + '.' + FileExt_StockInstant;
//    LoadDBStockInstant(tmpDBStockItem, tmpDBStockInstant, tmpFileUrl);
//    exit;
    //=================
    if 0 < tmpDBStockItem.RecordCount then
    begin
      tmpIdx := 0;
      FillChar(tmpInstantArray, SizeOf(tmpInstantArray), 0); 
      FillChar(tmpHttpClientSession, SizeOf(tmpHttpClientSession), 0);
      tmpHttpClientSession.IsKeepAlive := true;
      
      for i := 0 to tmpDBStockItem.RecordCount - 1 do
      begin
        if 0 <> tmpDBStockItem.Items[i].EndDealDate then
          Continue;
        tmpInstantArray.Data[tmpIdx] := tmpDBStockInstant.AddItem(tmpDBStockItem.Items[i]);
        Inc(tmpIdx);
        if tmpIdx >= Length(tmpInstantArray.Data) then
        begin
          DataGet_InstantArray_Sina(App, @tmpInstantArray, @tmpHttpClientSession);
          FillChar(tmpInstantArray, SizeOf(tmpInstantArray), 0);        
          tmpIdx := 0;  
          Sleep(100);
        end;
      end;      
      DataGet_InstantArray_Sina(App, @tmpInstantArray, @tmpHttpClientSession);

      SaveDBStockInstant(App, tmpDBStockInstant);
    end;
  finally
    tmpDBStockItem.Free;
    tmpDBStockInstant.Free;
  end;
end;

end.
