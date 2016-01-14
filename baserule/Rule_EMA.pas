unit Rule_EMA;

interface

uses
  BaseRule;

type
  TRule_EMA = class(TBaseRule)
  protected
    fParamN: Word;
    fInt64Ret: PArrayInt64;
    fFloatRet: PArrayDouble;
    function GetEMAValueF(AIndex: integer): double;
    function GetEMAValueI(AIndex: integer): int64;
    function GetParamN: Word;
    procedure SetParamN(const Value: Word);
    procedure ComputeInt64;
    procedure ComputeFloat;   
  public
    constructor Create(ADataType: TRuleDataType = dtNone); override;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Clear; override;
    property ValueF[AIndex: integer]: double read GetEMAValueF;
    property ValueI[AIndex: integer]: int64 read GetEMAValueI;
    property ParamN: Word read GetParamN write SetParamN;
  end;

  // 分子 numerator 分母 denominator 比 ratio
  TParamFactor  = record { 系数 }
    Numerator   : int64; // 分子
    Denominator : int64; // 分母
    Ratio       : double; // value
  end;

  PEMAParam     = ^TEMAParam;
  TEMAParam     = record
    ParamN      : Word;
    ParamFactor1: TParamFactor; 
    ParamFactor2: TParamFactor;
  end;
                
  procedure InitEMAParam(AParam: PEMAParam; AParamN: word);

implementation

{ TRule_EMA }

constructor TRule_EMA.Create(ADataType: TRuleDataType = dtNone);
begin
  inherited;               
  fInt64Ret := nil;
  fFloatRet := nil;
//  SetLength(fFloatRet, 0);
//  SetLength(fInt64Ret, 0);
end;

destructor TRule_EMA.Destroy;
begin
  Clear;
  inherited;
end;

procedure TRule_EMA.Execute;
begin
  Clear;
  if Assigned(OnGetDataLength) then
  begin
    fBaseRuleData.DataLength := OnGetDataLength;
    case fBaseRuleData.DataType of
      dtInt64: begin
        ComputeInt64;
      end;
      dtDouble: begin
        ComputeFloat;
      end;
    end;
  end;
end;

procedure TRule_EMA.Clear;
begin
  if fInt64Ret <> nil then
  begin
    SetLength(fInt64Ret.value, 0);
    FreeMem(fInt64Ret);
    fInt64Ret := nil;
  end;
  if fFloatRet <> nil then
  begin
    SetLength(fFloatRet.value, 0);
    FreeMem(fFloatRet);
    fFloatRet := nil;
  end;
  fBaseRuleData.DataLength := 0;
end;

(*
  当日指数平均值 = 平滑系数*（当日指数值-昨日指数平均值）+ 昨日指数平均值
  平滑系数 = 2 /（周期单位+1）
  EMA(X,N) = 2*X/(N+1)+(N-1)/(N+1)*昨天的指数收盘平均值

http://blog.csdn.net/wlr_tang/article/details/7243287
2、EMA(X，N)求X的

N日指数平滑移动平均

。算法是：
若Y=EMA(X，N)，则Y=［2*X+(N-1)*Y’］/(N+1)，其中Y’表示上一周期的Y值。
EMA引用函数在计算机上使用递归算法很容易实现，但不容易理解。例举分析说明EMA函数。

X是变量，每天的X值都不同，从远到近地标记，它们分别记为X1，X2，X3，….，Xn
如果N=1，则EMA(X，1)=［2*X1+(1-1)*Y’］/(1+1)=X1
如果N=2，则EMA(X，2)=［2*X2+(2-1)*Y’］/(2+1)=
   (2/3)*X2+(1/3)Y’
如果N=3，则EMA(X，3)=［2*X3+(3-1)*Y’］/(3+1)=   
  ［2*X3+2*Y’］/4=
  ［2*X3+2*((2/3)*X2+(1/3)*Y’)］/4=
  (1/2)*X3+(1/3)*X2+(1/6)*Y’

如果N=4，则EMA(X，4)=［2*X4+(4-1)*Y’］/(4+1)=
  2/5*X4 + 3/5*((1/2)*X3+(1/3)*X2+(1/6)*X1)=
  2/5*X4 + 3/10*X3+3/15*X2+3/30*X1

如果N=5，则EMA(X，5)=
     2/(5+1)*X5+(5-1)/(5+1)(2/5*X4+3/10*X3+3/15*X2+3/30*X1)=
     (1/3)*X5+(4/15)*X4+(3/15)*X3+(2/15)*X2+(1/15)*X1


  EMA(X，3)=［2*X3+(3-1)*Y’］/(3+1)
           =［2*X3+(3-1)* (2*X2+(2-1) * X1)］/(3+1)
*)


procedure InitEMAParam(AParam: PEMAParam; AParamN: word);
begin                                   
  AParam.ParamN := AParamN;
  AParam.ParamFactor1.Numerator := 2;
  AParam.ParamFactor1.Denominator := AParamN + 1; 
  AParam.ParamFactor1.Ratio := AParam.ParamFactor1.Numerator / AParam.ParamFactor1.Denominator;

  AParam.ParamFactor2.Numerator := AParamN - 1;
  AParam.ParamFactor2.Denominator := AParamN + 1; 
  AParam.ParamFactor2.Ratio := AParam.ParamFactor2.Numerator / AParam.ParamFactor2.Denominator;
end;

procedure TRule_EMA.ComputeInt64;
var
  tmpInt64_Meta: array of Int64;
  i: integer;
  tmpEMAParam: TEMAParam;
begin       
  if Assigned(OnGetDataI) then
  begin
    if fInt64Ret = nil then
    begin
      fInt64Ret := System.New(PArrayInt64);
    end;
    SetLength(fInt64Ret.value, fBaseRuleData.DataLength);
    SetLength(tmpInt64_Meta, fBaseRuleData.DataLength);
    FillChar(tmpEMAParam, SizeOf(tmpEMAParam), 0);
    InitEMAParam(@tmpEMAParam, fParamN);
    for i := 0 to fBaseRuleData.DataLength - 1 do
    begin
      tmpInt64_Meta[i] := OnGetDataI(i);
      if i = 0 then
      begin  
        fInt64Ret.value[i] := tmpInt64_Meta[i];
        fBaseRuleData.MaxI := fInt64Ret.value[i];
        fBaseRuleData.MinI := fBaseRuleData.MaxI;
        fInt64Ret.MaxValue := fBaseRuleData.MaxI;
        fInt64Ret.MinValue := fBaseRuleData.MaxI;
      end else
      begin
        fInt64Ret.value[i] := Round(tmpInt64_Meta[i] * tmpEMAParam.ParamFactor1.Ratio +
                              fInt64Ret.value[i - 1] * tmpEMAParam.ParamFactor2.Ratio);
        if fBaseRuleData.MaxI < fInt64Ret.value[i] then
        begin
          fBaseRuleData.MaxI := fInt64Ret.value[i];
          fInt64Ret.MaxValue := fBaseRuleData.MaxI;
        end;
        if fBaseRuleData.MinI > fInt64Ret.value[i] then
        begin
          fBaseRuleData.MinI := fInt64Ret.value[i];
          fInt64Ret.MinValue := fBaseRuleData.MinI;
        end;
      end;
    end;
  end; 
end;

procedure TRule_EMA.ComputeFloat;
var
  tmpFloat_Meta: array of double;
  i: integer;
  tmpEMAParam: TEMAParam;
begin
  if Assigned(OnGetDataF) then
  begin                 
    if fFloatRet = nil then
    begin
      fFloatRet := System.New(PArrayDouble);
    end;
    SetLength(fFloatRet.value, fBaseRuleData.DataLength);
    SetLength(tmpFloat_Meta, fBaseRuleData.DataLength);
    FillChar(tmpEMAParam, SizeOf(tmpEMAParam), 0);
    InitEMAParam(@tmpEMAParam, fParamN);
    for i := 0 to fBaseRuleData.DataLength - 1 do
    begin
      tmpFloat_Meta[i] := OnGetDataF(i);
      if i = 0 then
      begin  
        fFloatRet.value[i] := tmpFloat_Meta[i];    
        fBaseRuleData.MaxF := fFloatRet.value[i];
        fBaseRuleData.MinF := fBaseRuleData.MaxF;
        fFloatRet.MaxValue := fBaseRuleData.MaxF;
        fFloatRet.MinValue := fBaseRuleData.MaxF;
      end else
      begin     
        fFloatRet.value[i] := tmpFloat_Meta[i] * tmpEMAParam.ParamFactor1.Ratio +
                              fFloatRet.value[i - 1] * tmpEMAParam.ParamFactor2.Ratio;
        if fBaseRuleData.MaxF < fFloatRet.value[i] then
        begin
          fBaseRuleData.MaxF := fFloatRet.value[i]; 
          fFloatRet.MaxValue := fBaseRuleData.MaxF;
        end;
        if fBaseRuleData.MinF > fFloatRet.value[i] then
        begin
          fBaseRuleData.MinF := fFloatRet.value[i];
          fFloatRet.MinValue := fBaseRuleData.MinF;
        end;
      end;
    end;
  end;
end;

function TRule_EMA.GetParamN: Word;
begin
  Result := fParamN;
end;

procedure TRule_EMA.SetParamN(const Value: Word);
begin
  if Value > 0 then
  begin
    fParamN := Value;
  end;
end;

function TRule_EMA.GetEMAValueF(AIndex: integer): double;
begin
  Result := 0;
  if fBaseRuleData.DataType = dtDouble then
  begin
    if fFloatRet <> nil then
    begin
      Result := fFloatRet.value[AIndex];
    end;
  end;
end;

function TRule_EMA.GetEMAValueI(AIndex: integer): int64;
begin
  Result := 0;
  if fBaseRuleData.DataType = dtInt64 then
  begin
    if fInt64Ret <> nil then
    begin
      Result := fInt64Ret.value[AIndex];
    end;
  end;
end;

end.
