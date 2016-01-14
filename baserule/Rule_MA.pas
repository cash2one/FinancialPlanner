unit Rule_MA;

interface

uses
  BaseRule;

type
  TRule_MA = class(TBaseRule)
  protected
    fParamN: Word;
    fInt64Ret: PArrayInt64;
    fFloatRet: PArrayDouble;
    function GetMAValueF(AIndex: integer): double;
    function GetMAValueI(AIndex: integer): Int64;
    function GetParamN: Word;
    procedure SetParamN(const Value: Word);
    procedure ComputeInt64;
    procedure ComputeFloat;
  public
    constructor Create(ADataType: TRuleDataType = dtDouble); override;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Clear; override;
    property ValueF[AIndex: integer]: double read GetMAValueF;
    property ValueI[AIndex: integer]: int64 read GetMAValueI;
    property ParamN: Word read GetParamN write SetParamN;
  end;

implementation

{ TRule_MA }

constructor TRule_MA.Create(ADataType: TRuleDataType = dtDouble);
begin
  inherited;
  fParamN := 20;
  fFloatRet := nil;
  fInt64Ret := nil;
end;

destructor TRule_MA.Destroy;
begin
  Clear;
  inherited;
end;

procedure TRule_MA.Execute;
begin
  Clear;
  if Assigned(OnGetDataLength) then
  begin
    fBaseRuleData.DataLength := OnGetDataLength;
    if fBaseRuleData.DataLength > 0 then
    begin
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
end;

procedure TRule_MA.Clear;
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

procedure TRule_MA.ComputeInt64;
var
  tmpInt64_Meta: array of Int64;
  i: integer;
  tmpCounter: integer;
begin
  if Assigned(OnGetDataI) then
  begin
    if fInt64Ret = nil then
    begin
      fInt64Ret := System.New(PArrayInt64);
    end;
    SetLength(fInt64Ret.value, fBaseRuleData.DataLength);
    SetLength(tmpInt64_Meta, fBaseRuleData.DataLength);
    for i := 0 to fBaseRuleData.DataLength - 1 do
    begin
      tmpInt64_Meta[i] := OnGetDataI(i);
      fInt64Ret.value[i] := tmpInt64_Meta[i];
      tmpCounter := fParamN - 1;
      while tmpCounter > 0 do
      begin
        if i > tmpCounter - 1 then
        begin
          fInt64Ret.value[i] := fInt64Ret.value[i] + tmpInt64_Meta[i - tmpCounter];
        end;
        Dec(tmpCounter);
      end;
    end;
    if fParamN > 1 then
    begin
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        if i > fParamN - 1 then
        begin
          fInt64Ret.value[i] := fInt64Ret.value[i] div fParamN;
        end else
        begin
          fInt64Ret.value[i] := fInt64Ret.value[i] div (i + 1);
        end;
      end;
    end;
  end;
end;

procedure TRule_MA.ComputeFloat;
var
  tmpFloat_Meta: array of double;
  i: integer;
  tmpCounter: integer;
begin
  if Assigned(OnGetDataF) then
  begin                  
    if fFloatRet = nil then
    begin
      fFloatRet := System.New(PArrayDouble);
    end;
    SetLength(fFloatRet.value, fBaseRuleData.DataLength);
    SetLength(tmpFloat_Meta, fBaseRuleData.DataLength);
    for i := 0 to fBaseRuleData.DataLength - 1 do
    begin
      tmpFloat_Meta[i] := OnGetDataF(i);
      fFloatRet.value[i] := tmpFloat_Meta[i];
      tmpCounter := fParamN - 1;
      while tmpCounter > 0 do
      begin
        if i > tmpCounter - 1 then
        begin
          fFloatRet.value[i] := fFloatRet.value[i] + tmpFloat_Meta[i - tmpCounter];
        end;
        Dec(tmpCounter);
      end;
    end;
    if fParamN > 1 then
    begin
      for i := 0 to fBaseRuleData.DataLength - 1 do
      begin
        if i > fParamN - 1 then
        begin
          fFloatRet.value[i] := fFloatRet.value[i] / fParamN;
        end else
        begin
          fFloatRet.value[i] := fFloatRet.value[i] / (i + 1);
        end;
      end;
    end;
  end;
end;

function TRule_MA.GetParamN: Word;
begin
  Result := fParamN;
end;

procedure TRule_MA.SetParamN(const Value: Word);
begin
  if Value > 0 then
  begin
    fParamN := Value;
  end;
end;

function TRule_MA.GetMAValueF(AIndex: integer): double;
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

function TRule_MA.GetMAValueI(AIndex: integer): Int64;
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
