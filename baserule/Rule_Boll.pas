unit Rule_Boll;

interface

uses
  BaseRule,
  Rule_MA,
  Rule_STD;

type
  TRule_Boll_Price = class(TBaseRule)
  protected
    fMA: TRule_MA;
    fStd: TRule_Std;
    fParamN: Word;
    function GetBoll(AIndex: integer): double;
    function GetLB(AIndex: integer): double;
    function GetUB(AIndex: integer): double;
    function GetParamN: Word;
    procedure SetParamN(const Value: Word);
  public
    constructor Create(ADataType: TRuleDataType = dtDouble); override;
    destructor Destroy; override;
    procedure Execute; override;
    property Boll[AIndex: integer]: double read GetBoll;
    property UB[AIndex: integer]: double read GetUB;
    property LB[AIndex: integer]: double read GetLB;
    property ParamN: Word read GetParamN write SetParamN;  
    property MA: TRule_MA read fMA;
    property Std: TRule_Std read fStd;
  end;

implementation

{ TRule_Boll }

(*//
BOLL:MA(CLOSE,N);
UB:BOLL+2*STD(CLOSE,N);
LB:BOLL-2*STD(CLOSE,N);
======================================================
输出BOLL:收盘价的N日简单移动平均
输出UB:BOLL+2*收盘价的N日估算标准差
输出LB:BOLL-2*收盘价的N日估算标准差
//*)

constructor TRule_Boll_Price.Create(ADataType: TRuleDataType = dtDouble);
begin
  inherited;
  fParamN := 20;
  fMA := TRule_MA.Create(dtDouble);
  fMA.ParamN := fParamN;
  fStd := TRule_Std.Create(dtDouble);
  fStd.ParamN := fParamN;
end;

destructor TRule_Boll_Price.Destroy;
begin

  inherited;
end;

procedure TRule_Boll_Price.Execute;
begin     
  fMA.OnGetDataLength := Self.OnGetDataLength;
  fMA.OnGetDataF := Self.OnGetDataF;
  fMA.Execute;
  
  fStd.OnGetDataLength := Self.OnGetDataLength;
  fStd.OnGetDataF := Self.OnGetDataF;
  fStd.Execute;
end;

function TRule_Boll_Price.GetParamN: Word;
begin
  Result := fParamN;
end;

procedure TRule_Boll_Price.SetParamN(const Value: Word);
begin
  if Value > 0 then
  begin
    fParamN := Value;
    fMA.ParamN := fParamN;
    fStd.ParamN := fParamN;
  end;
end;

function TRule_Boll_Price.GetBoll(AIndex: integer): double;
begin
  Result := fMA.ValueF[AIndex];
end;

function TRule_Boll_Price.GetLB(AIndex: integer): double;
begin
  Result := Boll[AIndex] - 2 * fStd.ValueF[AIndex];
end;

function TRule_Boll_Price.GetUB(AIndex: integer): double;
begin
  Result := Boll[AIndex] + 2 * fStd.ValueF[AIndex];
end;

end.
