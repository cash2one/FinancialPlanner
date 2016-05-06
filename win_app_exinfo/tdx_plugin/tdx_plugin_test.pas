unit tdx_plugin_test;

interface

uses
  define_tdx_plugin;
  
  procedure TestPlugin1(DataLen:integer;pfOUT:ArraySingle;pfINa:ArraySingle;pfINb:ArraySingle;pfINc:ArraySingle); cdecl; 
  procedure TestPlugin2(DataLen:integer;pfOUT:ArraySingle;pfINa:ArraySingle;pfINb:ArraySingle;pfINc:ArraySingle); cdecl;
  procedure TestPlugin3(DataLen:integer;pfOUT:ArraySingle;pfINa:ArraySingle;pfINb:ArraySingle;pfINc:ArraySingle); cdecl;
  
implementation

uses
  UtilsLog;
  
procedure TestPlugin1(DataLen:integer;pfOUT:ArraySingle;pfINa:ArraySingle;pfINb:ArraySingle;pfINc:ArraySingle);cdecl;
var       // F8F8F8F8 表示无效数据,通达信公式中将不会显示
  i:integer;
  pc1:PCardinal;
begin
  Log('tdx_delphi_test.pas', 'TestPlugin1');
  for i:=0 to datalen-1 do
  begin
    pfOUT[i]:=pfina[i];
    
    if i>=datalen-10 then
    begin
      pc1:=@pfout[i];
      pc1^:=$F8F8F8F8;
    end;
  end;
end;



procedure TestPlugin2(DataLen:integer;pfOUT:ArraySingle;pfINa:ArraySingle;pfINb:ArraySingle;pfINc:ArraySingle);cdecl;
var
  i:integer;
begin
  Log('tdx_delphi_test.pas', 'TestPlugin2');
  for i:=0 to datalen-1 do
  begin
    pfOUT[i]:=pfinb[i];
  end;
end;

procedure TestPlugin3(DataLen:integer;pfOUT:ArraySingle;pfINa:ArraySingle;pfINb:ArraySingle;pfINc:ArraySingle);cdecl;
var
  i:integer;
begin
  Log('tdx_delphi_test.pas', 'TestPlugin3');
  for i:=0 to datalen-1 do
  begin
    pfOUT[i]:=pfinc[i];
  end;
end;

end.
