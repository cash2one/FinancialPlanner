unit utils_dealsimulation;

interface

uses
  define_dealItem,
  define_price,
  define_dealsimulation;

  function NewDealAccount(ADealSession: PRT_DealHistorySession): PDealAccountNode;
  function NewDealHistoryDay(ADealAccount: PDealAccountNode): PDealHistoryDayNode;

  function NewDealItemHold(ADealSettlement: PRT_DealSettlement): PDealItemHoldItemNode;
  function NewDealAction(ADealSettlement: PRT_DealSettlement): PDealActionNode;

  function RequestBuy(Account: PRT_DealAccount; ADealItem: TDealCodePack; APrice: TRT_PricePack; ANum: Integer): PDealActionNode;
  function RequestSale(Account: PRT_DealAccount; ADealItem: TDealCodePack; APrice: TRT_PricePack; ANum: Integer): PDealActionNode;
  
implementation
               
function NewDealAccount(ADealSession: PRT_DealHistorySession): PDealAccountNode;
begin
  Result := nil;
end;
              
function NewDealHistoryDay(ADealAccount: PDealAccountNode): PDealHistoryDayNode;
begin
  Result := nil;
end;

function NewDealItemHold(ADealSettlement: PRT_DealSettlement): PDealItemHoldItemNode;
begin
end;

function NewDealAction(ADealSettlement: PRT_DealSettlement): PDealActionNode;
begin
end;

function RequestBuy(Account: PRT_DealAccount; ADealItem: TDealCodePack; APrice: TRT_PricePack; ANum: Integer): PDealActionNode;
begin
  if Account.CurrentSettlement.DealSettlement.MoneyAvailable > (APrice.Value * ANum) then
  begin
    Result.DealAction.DealDirection := dealBuy;
    Result.DealAction.StockCode := ADealItem;
    Result.DealAction.Price := APrice;
    Result.DealAction.Num := ANum;
  end;
end;

function GetHoldItem(Account: PRT_DealAccount; ADealItem: TDealCodePack): PDealItemHoldItemNode;  
var
  tmpHoldItem: PDealItemHoldItemNode;
begin
  Result := nil;
  tmpHoldItem := Account.CurrentSettlement.DealSettlement.HoldItems.FirstHoldItemNode;
  while nil <> tmpHoldItem do
  begin
    if tmpHoldItem.HoldItem.StockCode = ADealItem then
    begin
      Result := tmpHoldItem;
      Break;
    end;
    tmpHoldItem := tmpHoldItem.NextSibling;
  end;
end;

function RequestSale(Account: PRT_DealAccount; ADealItem: TDealCodePack; APrice: TRT_PricePack; ANum: Integer): PDealActionNode;
var
  tmpHoldItem: PDealItemHoldItemNode;
begin
  Result := nil;
  tmpHoldItem := GetHoldItem(Account, ADealItem);
  if nil <> tmpHoldItem then
  begin
    if tmpHoldItem.HoldItem.Num > ANum then
    begin
      Result.DealAction.DealDirection := dealSale;
      Result.DealAction.StockCode := ADealItem;
      Result.DealAction.Price := APrice;
      Result.DealAction.Num := ANum;
    end;
  end;
end;

end.
