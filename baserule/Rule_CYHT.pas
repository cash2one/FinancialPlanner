unit Rule_CYHT;

interface

uses
  BaseRule,
  Rule_LLV,
  Rule_EMA,
  Rule_HHV;

type
  TRule_CYHT_Price_Data = record            
    ParamN: Word;
    ParamEMASK: Word;
    ParamEMASD: Word;

    Var1_Float: PArrayDouble;
    Var2_LLV: TRule_LLV;
    Var3_HHV: TRule_HHV;
    Var4_Float: PArrayDouble;
    Ret_SK_EMA: TRule_EMA;
    Ret_SD_EMA: TRule_EMA;
  end;

  PRule_CYHT_Result_Day = ^TRule_CYHT_Result_Day;
  TRule_CYHT_Result_Day = record
    SK: double;
    SD: double;
  end;
  
  TRule_CYHT_Price = class(TBaseStockRule)
  protected
    fCYHT_Price_Data: TRule_CYHT_Price_Data;
    function GetSKValue(AIndex: integer): double;
    function GetSDValue(AIndex: integer): double;

    function GetParamN1: Word;
    procedure SetParamN1(const Value: Word);

    function GetParamEMASK: Word;
    procedure SetParamEMASK(const Value: Word);

    function GetParamEMASD: Word;
    procedure SetParamEMASD(const Value: Word);

    function DoGetSKData(AIndex: integer): double;
    function DoGetSDData(AIndex: integer): double;
  public
    constructor Create(ADataType: TRuleDataType = dtNone); override;
    destructor Destroy; override;
    procedure Execute; override;
    // 中间过程
    property FloatVar1: PArrayDouble read fCYHT_Price_Data.Var1_Float;
    property FloatVar4: PArrayDouble read fCYHT_Price_Data.Var4_Float;
    property LLV: TRule_LLV read fCYHT_Price_Data.Var2_LLV;
    property HHV: TRule_HHV read fCYHT_Price_Data.Var3_HHV;
    property EMA_SK: TRule_EMA read fCYHT_Price_Data.Ret_SK_EMA;
    property EMA_SD: TRule_EMA read fCYHT_Price_Data.Ret_SD_EMA;
    // 结果
    property SK[AIndex: integer]: double read GetSKValue;
    property SD[AIndex: integer]: double read GetSDValue;
    // 34
    property ParamN1: Word read GetParamN1 write SetParamN1;
    // 13
    property ParamEMASK: Word read GetParamEMASK write SetParamEMASK;
    // 3
    property ParamEMASD: Word read GetParamEMASD write SetParamEMASD;
  end;

implementation

(*//
VAR1:=(2*CLOSE+HIGH+LOW+OPEN)/5;
VAR2:=LLV(LOW,34);
VAR3:=HHV(HIGH,34);
SK: EMA((VAR1-VAR2)/(VAR3-VAR2)*100,13);
SD: EMA(SK,3);
//*)

(*
做一点 小创新 把 时间轴 挪动一天
可能更准确 指标具有滞后性
前挪动 ?
  后挪动 ?
*)
{ TRule_CYHT }

constructor TRule_CYHT_Price.Create(ADataType: TRuleDataType = dtNone);
begin
  inherited;
  FillChar(fCYHT_Price_Data, SizeOf(fCYHT_Price_Data), 0);
  fCYHT_Price_Data.ParamN := 34;
  fCYHT_Price_Data.ParamEMASK := 13;  
  fCYHT_Price_Data.ParamEMASD := 3;
  fCYHT_Price_Data.Var2_LLV := TRule_LLV.Create(dtDouble);
  fCYHT_Price_Data.Var3_HHV := TRule_HHV.Create(dtDouble);
  fCYHT_Price_Data.Ret_SK_EMA := TRule_EMA.Create(dtDouble);
  fCYHT_Price_Data.Ret_SD_EMA := TRule_EMA.Create(dtDouble);
end;

destructor TRule_CYHT_Price.Destroy;
begin
  if fCYHT_Price_Data.Var1_Float <> nil then
  begin
    SetLength(fCYHT_Price_Data.Var1_Float.value, 0);
    FreeMem(fCYHT_Price_Data.Var1_Float);
    fCYHT_Price_Data.Var1_Float := nil;
  end;
  if fCYHT_Price_Data.Var4_Float <> nil then
  begin
    SetLength(fCYHT_Price_Data.Var4_Float.value, 0);
    FreeMem(fCYHT_Price_Data.Var4_Float);
    fCYHT_Price_Data.Var4_Float := nil;
  end;
  fCYHT_Price_Data.Var2_LLV.Free;
  fCYHT_Price_Data.Var3_HHV.Free;
  fCYHT_Price_Data.Ret_SK_EMA.Free;
  fCYHT_Price_Data.Ret_SD_EMA.Free;
  inherited;
end;

procedure TRule_CYHT_Price.Execute;
var
  i: integer;
  tmpV: double;
begin
  if Assigned(OnGetDataLength) then
  begin
    fBaseRuleData.DataLength := OnGetDataLength;
    if fBaseRuleData.DataLength > 0 then
    begin                              
      // -----------------------------------
      if fCYHT_Price_Data.Var1_Float = nil then
      begin
        fCYHT_Price_Data.Var1_Float := System.New(PArrayDouble);
        FillChar(fCYHT_Price_Data.Var1_Float^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fCYHT_Price_Data.Var1_Float.value, fBaseRuleData.DataLength);
      // -----------------------------------
      if fCYHT_Price_Data.Var4_Float = nil then
      begin
        fCYHT_Price_Data.Var4_Float := System.New(PArrayDouble);
        FillChar(fCYHT_Price_Data.Var4_Float^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fCYHT_Price_Data.Var4_Float.value, fBaseRuleData.DataLength);
      // -----------------------------------
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        // (2*CLOSE+HIGH+LOW+OPEN)/5;
        fCYHT_Price_Data.Var1_Float.value[i] := 2 * OnGetPriceClose(i);
        fCYHT_Price_Data.Var1_Float.value[i] := fCYHT_Price_Data.Var1_Float.value[i] + OnGetPriceHigh(i);
        fCYHT_Price_Data.Var1_Float.value[i] := fCYHT_Price_Data.Var1_Float.value[i] + OnGetPriceLow(i);
        fCYHT_Price_Data.Var1_Float.value[i] := fCYHT_Price_Data.Var1_Float.value[i] + OnGetPriceOpen(i);
        fCYHT_Price_Data.Var1_Float.value[i] := fCYHT_Price_Data.Var1_Float.value[i] / 5;
      end;
    end;
  end;                                           
  fCYHT_Price_Data.Var2_LLV.ParamN := fCYHT_Price_Data.ParamN;
  fCYHT_Price_Data.Var2_LLV.OnGetDataLength := Self.OnGetDataLength;
  fCYHT_Price_Data.Var2_LLV.OnGetDataF := Self.OnGetPriceLow;
  fCYHT_Price_Data.Var2_LLV.Execute;

  fCYHT_Price_Data.Var3_HHV.ParamN := fCYHT_Price_Data.ParamN;
  fCYHT_Price_Data.Var3_HHV.OnGetDataLength := Self.OnGetDataLength;
  fCYHT_Price_Data.Var3_HHV.OnGetDataF := Self.OnGetPriceHigh;
  fCYHT_Price_Data.Var3_HHV.Execute;

  for i := 0 to fBaseRuleData.DataLength - 1 do
  begin
    tmpV := (fCYHT_Price_Data.Var1_Float.value[i] - fCYHT_Price_Data.Var2_LLV.ValueF[i]);
    tmpV := tmpV * 100;
    if fCYHT_Price_Data.Var3_HHV.valueF[i] <> fCYHT_Price_Data.Var2_LLV.ValueF[i] then
    begin
      tmpV := tmpV / (fCYHT_Price_Data.Var3_HHV.valueF[i] - fCYHT_Price_Data.Var2_LLV.ValueF[i]);
    end else
    begin
      tmpV := $FFFFFFFF;
    end;
    //**tmpV := Round(tmpV * 100) / 100;
    fCYHT_Price_Data.Var4_Float.value[i] := tmpV;
  end;                      
  fCYHT_Price_Data.Ret_SK_EMA.ParamN := fCYHT_Price_Data.ParamEMASK;
  fCYHT_Price_Data.Ret_SK_EMA.OnGetDataLength := Self.OnGetDataLength;
  fCYHT_Price_Data.Ret_SK_EMA.OnGetDataF := Self.DoGetSKData;
  fCYHT_Price_Data.Ret_SK_EMA.Execute;
                           
  fCYHT_Price_Data.Ret_SD_EMA.ParamN := fCYHT_Price_Data.ParamEMASD;
  fCYHT_Price_Data.Ret_SD_EMA.OnGetDataLength := Self.OnGetDataLength;
  fCYHT_Price_Data.Ret_SD_EMA.OnGetDataF := Self.DoGetSDData;
  fCYHT_Price_Data.Ret_SD_EMA.Execute;
end;

function TRule_CYHT_Price.DoGetSKData(AIndex: integer): double;
var
  tmpV: double;
begin
  // (VAR1-VAR2)/(VAR3-VAR2)*100,
  tmpV := (fCYHT_Price_Data.Var1_Float.value[AIndex] - fCYHT_Price_Data.Var2_LLV.ValueF[AIndex]);
  tmpV := tmpV * 100;
  if fCYHT_Price_Data.Var3_HHV.valueF[AIndex] <> fCYHT_Price_Data.Var2_LLV.ValueF[AIndex] then
  begin
    tmpV := tmpV / (fCYHT_Price_Data.Var3_HHV.valueF[AIndex] - fCYHT_Price_Data.Var2_LLV.ValueF[AIndex]);
  end else
  begin
    tmpV := $FFFFFFFF;
  end;
  //**tmpV := Round(tmpV * 100) / 100;
  Result := tmpV;
end;
             
function TRule_CYHT_Price.GetSKValue(AIndex: integer): double;
begin
  Result := fCYHT_Price_Data.Ret_SK_EMA.valueF[AIndex];
end;

function TRule_CYHT_Price.GetSDValue(AIndex: integer): double;
begin
  Result := fCYHT_Price_Data.Ret_SD_EMA.valueF[AIndex];
end;

function TRule_CYHT_Price.DoGetSDData(AIndex: integer): double;
begin
  Result := fCYHT_Price_Data.Ret_SK_EMA.ValueF[AIndex];
end;

function TRule_CYHT_Price.GetParamN1: Word;
begin
  Result := fCYHT_Price_Data.ParamN;
end;

procedure TRule_CYHT_Price.SetParamN1(const Value: Word);
begin
  if Value > 0 then
  begin
    fCYHT_Price_Data.ParamN := Value;
  end;
end;

function TRule_CYHT_Price.GetParamEMASK: Word;
begin
  Result := fCYHT_Price_Data.ParamEMASK;
end;

procedure TRule_CYHT_Price.SetParamEMASK(const Value: Word);
begin
  if Value > 0 then
  begin
    fCYHT_Price_Data.ParamEMASK := Value;
  end;
end;

function TRule_CYHT_Price.GetParamEMASD: Word;
begin
  Result := fCYHT_Price_Data.ParamEMASD;
end;

procedure TRule_CYHT_Price.SetParamEMASD(const Value: Word);
begin
  if Value > 0 then
  begin
    fCYHT_Price_Data.ParamEMASD := Value;
  end;
end;

end.
