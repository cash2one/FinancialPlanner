unit zsProcess;

interface

uses
  Windows;
  
type
  PExProcess          = ^TExProcess;
  TExProcess          = record
    IsLaunchedFlag    : Boolean;
    ApplicationWindow : HWND;
    ProcessId         : DWORD;
    StartInfo         : TStartupInfoA;
    ProcInfo          : TProcessInformation;
  end;
         
  PExProcessWindow    = ^TExProcessWindow;
  TExProcessWindow    = record
    ParentWindow      : HWND;
    WindowHandle      : HWND;
    OKButton          : HWND;
    CancelButton      : HWND;
  end;

  PExWindowFind       = ^TExWindowFind;
  TExWindowFind       = record
    FindCount         : integer;
    FindWindow        : array[0..255] of PExProcessWindow;
    NeedWinCount      : integer;
    WndClassKey       : string;
    WndCaptionKey     : string;
    WndCaptionExcludeKey: string;
    CheckFunc         : function(AWnd: HWND): Boolean;
  end;
  
  PExProcessAttach    = ^TExProcessAttach;
  TExProcessAttach    = record
    Process           : TExProcess;
    ProcessWinCount   : integer;
    FindSession       : TExWindowFind;
    ProcessWins       : array[0..255] of TExProcessWindow;
  end;

implementation

end.
