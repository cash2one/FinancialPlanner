unit Rule_BDZX;

interface

uses
  BaseRule,             
  Rule_STD,
  Rule_EMA;

type
  TRule_BDZX_Price_Data = record
    ParamN: Word;
    ParamN_AK_EMA: WORD;
    ParamN_VAR6_EMA : WORD;
    ParamN_AD1_EMA : WORD;
    Var2_Float: PArrayDouble;
    Var5_Float: PArrayDouble;
    Var6_Float: PArrayDouble;
    Ret_AK_Float: PArrayDouble;
    Ret_AJ: PArrayDouble;

    Var3_EMA: TRule_EMA;
    Var4_STD: TRule_STD;
    Var6_EMA: TRule_EMA;
    Ret_VAR_AK_EMA: TRule_EMA;
    Ret_AD1_EMA: TRule_EMA;
  end;

  TRule_BDZX_Price = class(TBaseStockRule)
  protected
    fBDZX_Price_Data: TRule_BDZX_Price_Data;
    function GetParamN: Word;
    procedure SetParamN(const Value: Word);  
    function OnGetVar2Data(AIndex: integer): double; 
    function OnGetVar5Data(AIndex: integer): double;
    function OnGetVar6Data(AIndex: integer): double;
    function OnGetAD1Data(AIndex: integer): double;
  public
    constructor Create(ADataType: TRuleDataType = dtDouble); override;
    destructor Destroy; override;
    procedure Execute; override;

    property Var2_Float: PArrayDouble read fBDZX_Price_Data.Var2_Float;
    property Var3_EMA: TRule_EMA read fBDZX_Price_Data.Var3_EMA;
    property Var4_STD: TRule_STD read fBDZX_Price_Data.Var4_STD;
    property Var5_Float: PArrayDouble read fBDZX_Price_Data.Var5_Float;
    property Var6_EMA: TRule_EMA read fBDZX_Price_Data.Var6_EMA;
    property Var6_Float: PArrayDouble read fBDZX_Price_Data.Var6_Float;
    property Ret_VAR_AK_EMA: TRule_EMA read fBDZX_Price_Data.Ret_VAR_AK_EMA;
    property Ret_AK_Float: PArrayDouble read fBDZX_Price_Data.Ret_AK_Float;
    property Ret_AD1_EMA: TRule_EMA read fBDZX_Price_Data.Ret_AD1_EMA;
    property Ret_AJ: PArrayDouble read fBDZX_Price_Data.Ret_AJ;
  end;

implementation

{ TRule_BDZX }

(*
VAR2:=(HIGH+LOW+CLOSE*2)/4;
VAR3:=EMA(VAR2,21);
VAR4:=STD(VAR2,21);
VAR5:=((VAR2-VAR3)/VAR4*100+200)/4;
VAR6:=(EMA(VAR5,5)-25)*1.56;
AK: EMA(VAR6,2)*1.22;
AD1: EMA(AK,2);
AJ: 3*AK-2*AD1;

org
VAR2:=(HIGH+LOW+CLOSE*2)/4;
VAR3:=EMA(VAR2,21);
VAR4:=STD(VAR2,21);
VAR5:=((VAR2-VAR3)/VAR4*100+200)/4;
VAR6:=(EMA(VAR5,5)-25)*1.56;
AK: EMA(VAR6,2)*1.22;
AD1: EMA(AK,2);
AJ: 3*AK-2*AD1;
AA:100;
BB:0;
CC:80;
Âò½ø: IF(CROSS(AK,AD1),58,20);
Âô³ö: IF(CROSS(AD1,AK),58,20);
*)

constructor TRule_BDZX_Price.Create(ADataType: TRuleDataType = dtDouble);
begin
  inherited;
  FillChar(fBDZX_Price_Data, SizeOf(fBDZX_Price_Data), 0);
  fBDZX_Price_Data.ParamN := 21;
  fBDZX_Price_Data.ParamN_VAR6_EMA := 5;
  fBDZX_Price_Data.ParamN_AK_EMA := 2;
  fBDZX_Price_Data.ParamN_AD1_EMA := 2;
  fBDZX_Price_Data.Var3_EMA := TRule_EMA.Create(dtDouble);
  fBDZX_Price_Data.Var4_STD := TRule_STD.Create(dtDouble);
  fBDZX_Price_Data.Var6_EMA := TRule_EMA.Create(dtDouble);
  fBDZX_Price_Data.Ret_VAR_AK_EMA := TRule_EMA.Create(dtDouble);
  fBDZX_Price_Data.Ret_AD1_EMA := TRule_EMA.Create(dtDouble);
end;

destructor TRule_BDZX_Price.Destroy;
begin

  inherited;
end;

procedure TRule_BDZX_Price.Execute;
var 
  i: integer;
begin
  if Assigned(OnGetDataLength) then
  begin
    fBaseRuleData.DataLength := OnGetDataLength; 
    if fBaseRuleData.DataLength > 0 then
    begin
      // -----------------------------------
      if fBDZX_Price_Data.Var2_Float = nil then
      begin
        fBDZX_Price_Data.Var2_Float := System.New(PArrayDouble);
        FillChar(fBDZX_Price_Data.Var2_Float^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fBDZX_Price_Data.Var2_Float.value, fBaseRuleData.DataLength);
      // -----------------------------------
      if fBDZX_Price_Data.Var5_Float = nil then
      begin
        fBDZX_Price_Data.Var5_Float := System.New(PArrayDouble);
        FillChar(fBDZX_Price_Data.Var5_Float^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fBDZX_Price_Data.Var5_Float.value, fBaseRuleData.DataLength);
      // -----------------------------------
      if fBDZX_Price_Data.Var6_Float = nil then
      begin
        fBDZX_Price_Data.Var6_Float := System.New(PArrayDouble);
        FillChar(fBDZX_Price_Data.Var6_Float^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fBDZX_Price_Data.Var6_Float.value, fBaseRuleData.DataLength);
      // -----------------------------------
      if fBDZX_Price_Data.Ret_AK_Float = nil then
      begin
        fBDZX_Price_Data.Ret_AK_Float := System.New(PArrayDouble);
        FillChar(fBDZX_Price_Data.Ret_AK_Float^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fBDZX_Price_Data.Ret_AK_Float.value, fBaseRuleData.DataLength);
      // -----------------------------------
      if fBDZX_Price_Data.Ret_AJ = nil then
      begin
        fBDZX_Price_Data.Ret_AJ := System.New(PArrayDouble);
        FillChar(fBDZX_Price_Data.Ret_AJ^, SizeOf(TArrayDouble), 0);
      end;
      SetLength(fBDZX_Price_Data.Ret_AJ.value, fBaseRuleData.DataLength);
      // -----------------------------------
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        // (HIGH+LOW+CLOSE*2)/4;
        fBDZX_Price_Data.Var2_Float.value[i] := 2 * OnGetPriceClose(i);
        fBDZX_Price_Data.Var2_Float.value[i] := fBDZX_Price_Data.Var2_Float.value[i] + OnGetPriceHigh(i);
        fBDZX_Price_Data.Var2_Float.value[i] := fBDZX_Price_Data.Var2_Float.value[i] + OnGetPriceLow(i);
        fBDZX_Price_Data.Var2_Float.value[i] := fBDZX_Price_Data.Var2_Float.value[i] / 4;
      end;           
      // -----------------------------------    
      fBDZX_Price_Data.Var3_EMA.ParamN := fBDZX_Price_Data.ParamN;
      fBDZX_Price_Data.Var3_EMA.OnGetDataLength := Self.OnGetDataLength;
      fBDZX_Price_Data.Var3_EMA.OnGetDataF := Self.OnGetVar2Data;
      fBDZX_Price_Data.Var3_EMA.Execute;
      // -----------------------------------
      fBDZX_Price_Data.Var4_STD.ParamN := fBDZX_Price_Data.ParamN;
      fBDZX_Price_Data.Var4_STD.OnGetDataLength := Self.OnGetDataLength;
      fBDZX_Price_Data.Var4_STD.OnGetDataF := Self.OnGetVar2Data;
      fBDZX_Price_Data.Var4_STD.Execute;
      // -----------------------------------
      // VAR5:=((VAR2-VAR3)/VAR4*100+200)/4;
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        fBDZX_Price_Data.Var5_Float.value[i] := fBDZX_Price_Data.Var2_Float.value[i] - fBDZX_Price_Data.Var3_EMA.ValueF[i];
        fBDZX_Price_Data.Var5_Float.value[i] := fBDZX_Price_Data.Var5_Float.value[i] * 100;
        if fBDZX_Price_Data.Var4_STD.ValueF[i] = 0 then
        begin
          fBDZX_Price_Data.Var5_Float.value[i] := fBDZX_Price_Data.Var5_Float.value[i];
        end else
        begin
          fBDZX_Price_Data.Var5_Float.value[i] := fBDZX_Price_Data.Var5_Float.value[i] / fBDZX_Price_Data.Var4_STD.ValueF[i];
        end;
        fBDZX_Price_Data.Var5_Float.value[i] := fBDZX_Price_Data.Var5_Float.value[i] + 200;
        fBDZX_Price_Data.Var5_Float.value[i] := fBDZX_Price_Data.Var5_Float.value[i] / 4;
      end;
      // -----------------------------------
      //VAR6:=(EMA(VAR5,5)-25)*1.56;
      fBDZX_Price_Data.Var6_EMA.ParamN := 5;
      fBDZX_Price_Data.Var6_EMA.OnGetDataLength := Self.OnGetDataLength;
      fBDZX_Price_Data.Var6_EMA.OnGetDataF := Self.OnGetVar5Data;
      fBDZX_Price_Data.Var6_EMA.Execute;
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        fBDZX_Price_Data.Var6_Float.value[i] := (fBDZX_Price_Data.Var6_EMA.ValueF[i] - 25) * 1.56;
      end;
      // -----------------------------------
      // AK: EMA(VAR6,2)*1.22;
      fBDZX_Price_Data.Ret_VAR_AK_EMA.ParamN := fBDZX_Price_Data.ParamN_AK_EMA;
      fBDZX_Price_Data.Ret_VAR_AK_EMA.OnGetDataLength := Self.OnGetDataLength;
      fBDZX_Price_Data.Ret_VAR_AK_EMA.OnGetDataF := Self.OnGetVar6Data;
      fBDZX_Price_Data.Ret_VAR_AK_EMA.Execute;
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        fBDZX_Price_Data.Ret_AK_Float.value[i] := fBDZX_Price_Data.Ret_VAR_AK_EMA.valueF[i] * 1.22;
        if 0 = i then
        begin
          fBDZX_Price_Data.Ret_AK_Float.MaxValue := fBDZX_Price_Data.Ret_AK_Float.value[i];
          fBDZX_Price_Data.Ret_AK_Float.MinValue := fBDZX_Price_Data.Ret_AK_Float.MaxValue;
        end else
        begin
          if fBDZX_Price_Data.Ret_AK_Float.value[i] > fBDZX_Price_Data.Ret_AK_Float.MaxValue then
          begin
            fBDZX_Price_Data.Ret_AK_Float.MaxValue := fBDZX_Price_Data.Ret_AK_Float.value[i];
          end;
          if fBDZX_Price_Data.Ret_AK_Float.value[i] < fBDZX_Price_Data.Ret_AK_Float.MinValue then
          begin
            fBDZX_Price_Data.Ret_AK_Float.MinValue := fBDZX_Price_Data.Ret_AK_Float.value[i];
          end;
        end;
      end;
      // -----------------------------------
      // AD1: EMA(AK,2);
      fBDZX_Price_Data.Ret_AD1_EMA.ParamN := fBDZX_Price_Data.ParamN_AD1_EMA;
      fBDZX_Price_Data.Ret_AD1_EMA.OnGetDataLength := Self.OnGetDataLength;
      fBDZX_Price_Data.Ret_AD1_EMA.OnGetDataF := Self.OnGetAD1Data;
      fBDZX_Price_Data.Ret_AD1_EMA.Execute;
      // -----------------------------------
      // AJ: 3*AK-2*AD1;
      // -----------------------------------
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        fBDZX_Price_Data.Ret_AJ.value[i] :=
            3 * fBDZX_Price_Data.Ret_AK_Float.value[i] -
            2 * fBDZX_Price_Data.Ret_AD1_EMA.valueF[i];  
        if 0 = i then
        begin
          fBDZX_Price_Data.Ret_AJ.MaxValue := fBDZX_Price_Data.Ret_AJ.value[i];
          fBDZX_Price_Data.Ret_AJ.MinValue := fBDZX_Price_Data.Ret_AJ.MaxValue;
        end else
        begin
          if fBDZX_Price_Data.Ret_AJ.value[i] > fBDZX_Price_Data.Ret_AJ.MaxValue then
          begin
            fBDZX_Price_Data.Ret_AJ.MaxValue := fBDZX_Price_Data.Ret_AJ.value[i];
          end;
          if fBDZX_Price_Data.Ret_AJ.value[i] < fBDZX_Price_Data.Ret_AJ.MinValue then
          begin
            fBDZX_Price_Data.Ret_AJ.MinValue := fBDZX_Price_Data.Ret_AJ.value[i];
          end;
        end;
      end;
    end;
  end;
end;

function TRule_BDZX_Price.GetParamN: Word;
begin
  Result := fBDZX_Price_Data.ParamN;
end;

procedure TRule_BDZX_Price.SetParamN(const Value: Word);
begin
  if Value > 0 then
  begin
    fBDZX_Price_Data.ParamN := Value;
  end;
end;

function TRule_BDZX_Price.OnGetVar2Data(AIndex: integer): double;
begin
  Result := fBDZX_Price_Data.Var2_Float.Value[AIndex];
end;
                        
function TRule_BDZX_Price.OnGetVar5Data(AIndex: integer): double;
begin
  Result := fBDZX_Price_Data.Var5_Float.Value[AIndex];
end;

function TRule_BDZX_Price.OnGetVar6Data(AIndex: integer): double;
begin
  Result := fBDZX_Price_Data.Var6_Float.Value[AIndex];
end;

function TRule_BDZX_Price.OnGetAD1Data(AIndex: integer): double;
begin
  Result := fBDZX_Price_Data.Ret_AK_Float.Value[AIndex];
end;

end.
