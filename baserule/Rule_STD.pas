unit Rule_STD;

interface

uses
  BaseRule;

type
  TRule_STD = class(TBaseRule)
  protected
    FParamN: Word;
    fFloatRet: PArrayDouble;
    function GetStdValueF(AIndex: integer): double;
    procedure SetParamN(const Value: Word);
    procedure ComputeInt64;
    procedure ComputeFloat;
  public
    constructor Create(ADataType: TRuleDataType = dtDouble); override;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Clear; override;
    property ValueF[AIndex: integer]: double read GetStdValueF;
    property ParamN: Word read FParamN write SetParamN;
  end;

implementation

{ TRule_STD }

constructor TRule_STD.Create(ADataType: TRuleDataType = dtDouble);
begin
  inherited;
  fParamN := 2;
  fFloatRet := nil;
end;

destructor TRule_STD.Destroy;
begin
  Clear;
  inherited;
end;

procedure TRule_Std.Execute;
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

procedure TRule_Std.Clear;
begin
  if fFloatRet <> nil then
  begin
    SetLength(fFloatRet.value, 0);
    FreeMem(fFloatRet);
    fFloatRet := nil;
  end;
  fBaseRuleData.DataLength := 0;
end;

procedure TRule_Std.ComputeInt64;
var
  tmpInt64_Meta: array of Int64;
  tmpInt64_v1: array of Int64;
  tmpInt64_Ret: array of Int64;
  i, j: integer;
  tmpv: int64;
begin
  if Assigned(OnGetDataI) then
  begin
    SetLength(tmpInt64_Ret, fBaseRuleData.DataLength);
    SetLength(tmpInt64_Meta, fBaseRuleData.DataLength);
    SetLength(tmpInt64_v1, fBaseRuleData.DataLength);

    if fFloatRet = nil then
    begin
      fFloatRet := System.New(PArrayDouble);
    end;
    SetLength(fFloatRet.value, fBaseRuleData.DataLength);
    for i := 0 to fBaseRuleData.DataLength - 1 do
    begin
      tmpInt64_Meta[i] := OnGetDataI(i);
      fFloatRet.value[i] := 0;
      // -------------------------------
      tmpInt64_v1[i] := 0;
      for j := 0 to fParamN - 1 do
      begin
        tmpInt64_v1[i] := tmpInt64_v1[i] + tmpInt64_v1[i - j];
      end;
      tmpInt64_v1[i] := Round(tmpInt64_v1[i] / fParamN);
      // -------------------------------
      tmpInt64_Ret[i] := 0;
      for j := 0 to fParamN - 1 do
      begin
        tmpv := (tmpInt64_Meta[i - j] - tmpInt64_v1[i]);
        tmpInt64_Ret[i] := tmpInt64_Ret[i] + tmpv * tmpv;
      end;
      // -------------------------------
      fFloatRet.value[i] := Sqrt(tmpInt64_Ret[i] / (fParamN - 1));
      // -------------------------------
    end;
    SetLength(tmpInt64_Meta, 0);
    SetLength(tmpInt64_v1, 0);
    SetLength(tmpInt64_Ret, 0);
  end;
end;

(*
  STD(CLOSE,10),
    -------------------------------------
    x := (x[n] + x[n - 1] + x[1]) / n
    -------------------------------------
    v := (x[n]-x)^2 + (x[n - 1]-x)^2 + (x[1]-x)^2
    v := v / (n - 1)
    std = sqrt(v);
    -------------------------------------
    sqrt£¨4£© = 2
*)
procedure TRule_Std.ComputeFloat;
var
  tmpFloat_Meta: array of double;
  tmpFloat_v1: array of double;
  i, j, tmpCounter: integer;
  tmpv: double;
begin
  if Assigned(OnGetDataF) then
  begin
    if fFloatRet = nil then
    begin
      fFloatRet := System.New(PArrayDouble);
    end;
    SetLength(fFloatRet.value, fBaseRuleData.DataLength);
    SetLength(tmpFloat_Meta, fBaseRuleData.DataLength);
    SetLength(tmpFloat_v1, fBaseRuleData.DataLength);
    for i := 0 to fBaseRuleData.DataLength - 1 do
    begin
      tmpFloat_Meta[i] := OnGetDataF(i);
      // -------------------------------
      tmpFloat_v1[i] := 0;
      tmpCounter := 0;
      for j := 0 to fParamN - 1 do
      begin
        if i >= j then
        begin
          tmpFloat_v1[i] := tmpFloat_v1[i] + tmpFloat_Meta[i - j];
          Inc(tmpCounter);
        end else
        begin
          Break;
        end;
      end;
      tmpFloat_v1[i] := tmpFloat_v1[i] / tmpCounter;
      // -------------------------------
      fFloatRet.value[i] := 0;
      for j := 0 to tmpCounter - 1 do
      begin
        tmpv := (tmpFloat_Meta[i - j] - tmpFloat_v1[i]);
        fFloatRet.value[i] := fFloatRet.value[i] + tmpv * tmpv;
      end;
      // -------------------------------
      if tmpCounter > 1 then
      begin
        fFloatRet.value[i] := fFloatRet.value[i] / (tmpCounter - 1);
        fFloatRet.value[i] := Sqrt(fFloatRet.value[i]);
      end else
      begin
        fFloatRet.value[i] := 0;
      end;
      // -------------------------------
    end;
    SetLength(tmpFloat_Meta, 0);
    SetLength(tmpFloat_v1, 0);
  end;
end;

procedure TRule_Std.SetParamN(const Value: Word);
begin
  if Value > 0 then
  begin
    FParamN := Value;
  end;
end;

function TRule_Std.GetStdValueF(AIndex: integer): double;
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

end.
