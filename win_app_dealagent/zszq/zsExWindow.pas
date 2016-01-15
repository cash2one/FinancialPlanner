unit zsExWindow;

interface

uses
  Windows, zsProcess;
  
type
  PExProcessWindow = ^TExProcessWindow;
  TExProcessWindow = record
    ParentWindow: HWND;
    Process: PExProcess;
    ProcessID: DWORD;
    WindowHandle: HWND;
    OKButton: HWND;
    CancelButton: HWND;
    WndClassKey: string;
    WndCaptionKey: string;
    WndCaptionExcludeKey: string;
    CheckFunc: function(AWnd: HWND): Boolean;
  end;
                    
  function EnumFindDesktopWindowProc(AWnd: HWND; lParam: LPARAM): BOOL; stdcall;

implementation

uses
  SysUtils,
  UtilsWindows;
                 
function EnumFindDesktopWindowProc(AWnd: HWND; lParam: LPARAM): BOOL; stdcall;  
var
  tmpStr: string;
  tmpParentWnd: HWND;
  tmpIsSet: Boolean;
  tmpWindow: PExProcessWindow;
  tmpIsSame: Boolean;
  tmpProcessId: DWORD;
begin      
  Result := true;
  tmpWindow := PExProcessWindow(lparam);
  if 0 = tmpWindow.WindowHandle then
  begin
    if 0 <> tmpWindow.ProcessID then
    begin
      Windows.GetWindowThreadProcessId(AWnd, tmpProcessId);
      if tmpProcessId <> tmpWindow.ProcessID then
      begin
        exit;
      end;
    end;
    if not IsWindowVisible(AWnd) then
      exit;
    
    tmpStr := GetWndClassName(AWnd);
    tmpIsSame := SameText(tmpStr, tmpWindow.WndClassKey);
    if not tmpIsSame then
    begin
      if SameText('#32770', tmpWindow.WndClassKey) then
      begin
        tmpIsSame := Pos(tmpWindow.WndClassKey, tmpStr) > 0;
      end;
    end;
    if tmpIsSame then
    begin                 
      tmpIsSet := true;                       
      tmpStr := GetWndTextName(AWnd);
      if '' <> tmpWindow.WndCaptionKey then
      begin
        if Pos(tmpWindow.WndCaptionKey, tmpStr) < 1 then
        begin            
          tmpIsSet := false;       
        end;
      end;       
      if tmpIsSet then
      begin
        if Trim(tmpWindow.WndCaptionExcludeKey) <> '' then
        begin
          if Pos(tmpWindow.WndCaptionExcludeKey, tmpStr) > 0 then
          begin
            tmpIsSet := false;
          end;
        end;
      end;
      if tmpIsSet then
      begin
        if Assigned(tmpWindow.CheckFunc) then
        begin
          if not tmpWindow.CheckFunc(AWnd) then
          begin
            tmpIsSet := false;
          end;
        end;
      end;
      if tmpIsSet then
      begin
        tmpWindow.WindowHandle := AWnd;
        tmpParentWnd := GetParent(AWnd);
        if tmpParentWnd = 0 then
        begin
        
        end;
        Windows.GetWindowThreadProcessId(tmpWindow.WindowHandle, tmpWindow.ProcessID);
      end;
    end;
  end;        
  Result := tmpWindow.WindowHandle = 0;
end;
                                         
           
end.
