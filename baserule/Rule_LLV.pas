unit Rule_LLV;

interface

uses
  BaseRule;

type
  TRule_LLV = class(TBaseRule)
  protected
    fParamN: Word;
    fInt64Ret: PArrayInt64;
    fFloatRet: PArrayDouble;
    function GetLLVValueF(AIndex: integer): double;
    function GetLLVValueI(AIndex: integer): int64;
    function GetParamN: Word;
    procedure SetParamN(const Value: Word);
    procedure ComputeInt64;
    procedure ComputeFloat;
  public
    constructor Create(ADataType: TRuleDataType); override;
    destructor Destroy; override;
    procedure Execute; override;
    property ValueF[AIndex: integer]: double read GetLLVValueF;
    property ValueI[AIndex: integer]: int64 read GetLLVValueI;
    property ParamN: Word read GetParamN write SetParamN;
  end;

implementation

{ TRule_LLV }

constructor TRule_LLV.Create(ADataType: TRuleDataType);
begin
  inherited;
  fParamN := 20;          
  fInt64Ret := nil;
  fFloatRet := nil;
//  SetLength(fFloatRet, 0);
//  SetLength(fInt64Ret, 0);
end;

destructor TRule_LLV.Destroy;
begin                     
  if fFloatRet <> nil then
  begin
    SetLength(fFloatRet.value, 0);
    freeMem(fFloatRet);
  end;            
  if fInt64Ret <> nil then
  begin
    SetLength(fInt64Ret.value, 0);
    freeMem(fInt64Ret);
  end;
  inherited;
end;

procedure TRule_LLV.Execute;
begin
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

procedure TRule_LLV.ComputeInt64;
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
          if fInt64Ret.value[i] > tmpInt64_Meta[i - tmpCounter] then
          begin
            fInt64Ret.value[i] := tmpInt64_Meta[i - tmpCounter];
          end;
        end;
        Dec(tmpCounter);
      end;
    end;
  end;
end;

procedure TRule_LLV.ComputeFloat;
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
          if fFloatRet.value[i] > tmpFloat_Meta[i - tmpCounter] then
          begin
            fFloatRet.value[i] := tmpFloat_Meta[i - tmpCounter];
          end;
        end;
        Dec(tmpCounter);
      end;
    end;
  end;
end;

function TRule_LLV.GetParamN: Word;
begin
  Result := fParamN;
end;

procedure TRule_LLV.SetParamN(const Value: Word);
begin
  if Value > 0 then
  begin
    fParamN := Value;
  end;
end;

function TRule_LLV.GetLLVValueF(AIndex: integer): double;
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

function TRule_LLV.GetLLVValueI(AIndex: integer): int64;
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
