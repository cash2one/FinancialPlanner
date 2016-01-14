unit BaseRule;

interface

type
  TRuleDataType = (
    dtNone,
    dtInt64,
    dtDouble);

  TOnGetDataLength = function: integer of object;
  TOnGetDataI = function (AIndex: integer): int64 of object;
  TOnGetDataF = function (AIndex: integer): double of object;

  PArrayInt64 = ^TArrayInt64;
  TArrayInt64 = record
    Length: integer;
    MaxValue: Int64;
    MinValue: Int64;
    value: array of Int64;
  end;

  PArrayDouble = ^TArrayDouble;
  TArrayDouble = record
    Length: integer;
    MaxValue: double;
    MinValue: double;
    value: array of double;
  end;

  TBaseRuleData = record
    OnGetDataLength: TOnGetDataLength;
    OnGetDataI: TOnGetDataI;
    OnGetDataF: TOnGetDataF;
    DataType: TRuleDataType;
    DataLength: integer;
    MaxI: int64;
    MinI: int64;
    MaxF: double;
    MinF: double;
  end;
  
  TBaseRule = class
  protected
    fBaseRuleData: TBaseRuleData;
    function GetMaxI: int64; virtual;
    function GetMinI: int64; virtual;
    function GetMaxF: double; virtual;
    function GetMinF: double; virtual;
  public
    constructor Create(ADataType: TRuleDataType = dtNone); virtual;
    destructor Destroy; override;
    procedure Execute; virtual;
    procedure Clear; virtual;
    property OnGetDataLength: TOnGetDataLength
        read fBaseRuleData.OnGetDataLength write fBaseRuleData.OnGetDataLength;
    property OnGetDataI: TOnGetDataI
        read fBaseRuleData.OnGetDataI write fBaseRuleData.OnGetDataI;
    property OnGetDataF: TOnGetDataF
        read fBaseRuleData.OnGetDataF write fBaseRuleData.OnGetDataF;
    property DataType: TRuleDataType
        read fBaseRuleData.DataType write fBaseRuleData.DataType;
    property DataLength: integer read fBaseRuleData.DataLength;

    property MaxI: int64 read GetMaxI;
    property MinI: int64 read GetMinI;
    property MaxF: double read GetMaxF;
    property MinF: double read GetMinF;
  end;

  TBaseRuleTest = class
  protected
    fRule: TBaseRule;
  public
    property Rule: TBaseRule read fRule write fRule;
  end;

  TBaseStockRule = class(TBaseRule)
  protected
    // 开盘价
    fOnGetPriceOpen: TOnGetDataF;
    // 收盘价
    fOnGetPriceClose: TOnGetDataF;
    // 最高价
    fOnGetPriceHigh: TOnGetDataF;
    // 最低价
    fOnGetPriceLow: TOnGetDataF;
    // 交易日期
    fOnGetDealDay: TOnGetDataI;
    // 交易金额
    fOnGetDealAmount: TOnGetDataI;
    // 流通股本
    fOnGetDealVolume: TOnGetDataI;
    // 总股本
    fOnGetTotalVolume: TOnGetDataI;
    // 流通市值
    fOnGetDealValue: TOnGetDataI;
    // 总市值
    fOnGetTotalValue: TOnGetDataI;
  public
    property OnGetPriceOpen: TOnGetDataF read fOnGetPriceOpen write fOnGetPriceOpen;
    property OnGetPriceClose: TOnGetDataF read fOnGetPriceClose write fOnGetPriceClose;
    property OnGetPriceHigh: TOnGetDataF read fOnGetPriceHigh write fOnGetPriceHigh;
    property OnGetPriceLow: TOnGetDataF read fOnGetPriceLow write fOnGetPriceLow;
    property OnGetDealDay: TOnGetDataI read fOnGetDealDay write fOnGetDealDay;
    property OnGetDealAmount: TOnGetDataI read fOnGetDealAmount write fOnGetDealAmount;
    property OnGetDealVolume: TOnGetDataI read fOnGetDealVolume write fOnGetDealVolume;
    property OnGetTotalVolume: TOnGetDataI read fOnGetTotalVolume write fOnGetTotalVolume;
    property OnGetDealValue: TOnGetDataI read fOnGetDealValue write fOnGetDealValue;
    property OnGetTotalValue: TOnGetDataI read fOnGetTotalValue write fOnGetTotalValue;
  end;

implementation

{ TBaseRule }

constructor TBaseRule.Create(ADataType: TRuleDataType = dtNone);
begin
  FillChar(fBaseRuleData, SizeOf(fBaseRuleData), 0);
  fBaseRuleData.DataType := ADataType;
end;

destructor TBaseRule.Destroy;
begin

  inherited;
end;

procedure TBaseRule.Execute;
begin

end;

procedure TBaseRule.Clear;
begin

end;
      
function TBaseRule.GetMaxI: int64;
begin
  Result := fBaseRuleData.MaxI;
end;

function TBaseRule.GetMinI: int64;
begin
  Result := fBaseRuleData.MinI;
end;

function TBaseRule.GetMaxF: double;
begin
  Result := fBaseRuleData.MaxF;
end;

function TBaseRule.GetMinF: double;
begin
  Result := fBaseRuleData.MinF;
end;

end.
