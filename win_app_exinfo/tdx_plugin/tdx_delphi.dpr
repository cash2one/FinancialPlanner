library tdx_delphi;

uses
  Windows,
  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  define_tdx_plugin in 'define_tdx_plugin.pas',
  tdx_plugin_test in 'tdx_plugin_test.pas';

{$R *.res}
        
function RegisterTdxFunc(pFun: PPPluginTCalcFuncInfo): LongBool; cdecl;
begin
  Result := False;
  Log('tdx_delphi', 'RegisterTdxFunc');
  if pFun^ = nil then
  begin
    pFun^ := @g_CalcFuncSets; //��dll������ʼ��ַ
    Result := True;
  end;
end;
           
function RegisterDataInterface(pFun: PPPluginTCalcFuncInfo): LongBool; cdecl;
begin
  Result := False;
  Log('tdx_delphi', 'RegisterDataInterface');
  if pFun^ = nil then
  begin
    pFun^ := @g_CalcFuncSets; //��dll������ʼ��ַ
    Result := True;
  end;
end;

procedure InitStruct;
begin
  Log('tdx_delphi', 'InitStruct');
  g_CalcFuncSets[0].nFuncMark := 1;
  g_CalcFuncSets[0].pCallFunc := @TestPlugin1;
  g_CalcFuncSets[1].nFuncMark := 2;
  g_CalcFuncSets[1].pCallFunc := @TestPlugin2;
  g_CalcFuncSets[2].nFuncMark := 3;
  g_CalcFuncSets[2].pCallFunc := @TestPlugin3;
  //�и���ĺ����Ļ����������ӵ�����
end;
            
function GetCopyRightInfo(pFun: PPPluginTCalcFuncInfo): LongBool; cdecl;
begin
  Result := false;
end;
            
function InputInfoThenCalc1(pFun: PPPluginTCalcFuncInfo): LongBool; cdecl;
begin
  Result := false;
end;

function InputInfoThenCalc2(pFun: PPPluginTCalcFuncInfo): LongBool; cdecl;
begin
  Result := false;
end;

exports
  RegisterTdxFunc,
  RegisterDataInterface,
  GetCopyRightInfo,//       ��д�����Ϣ�ĺ�������easy
  InputInfoThenCalc1,     //Ĭ�ϵ��ô˺�����ʹ��ȫ��������ʷ����
  InputInfoThenCalc2;
  
begin
  InitStruct;
end.
