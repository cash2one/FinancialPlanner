unit define_tdx_plugin;

interface

type
  ArraySingle   = array of single;

type
  PPluginFUNC   = procedure(p1: Integer; var p2, p3, p4, p5: ArraySingle); cdecl;

  TagPluginTCalcFuncInfo = packed record
    nFuncMark   : Word;
    pCallFunc   : pPluginFUNC;
  end;

  PluginTCalcFuncInfo = tagPluginTCalcFuncInfo;
  PPluginTCalcFuncInfo = ^PluginTCalcFuncInfo;
  PPPluginTCalcFuncInfo = ^PPluginTCalcFuncInfo;

  pRegisterPluginFUNC = function(pFun: PPPluginTCalcFuncInfo):LongBool; cdecl;


var
  g_CalcFuncSets: array[0..2] of PluginTCalcFuncInfo;

implementation

end.
