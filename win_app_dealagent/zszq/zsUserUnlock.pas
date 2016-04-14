unit zsUserUnlock;

interface

uses
  zsAttach, Windows, SysUtils;
                     
  function HandleZsUserUnlock(AZsDealSession: PZsDealSession; APassword: integer): Boolean;

implementation

uses
  zsLoginUtils,
  zsMainWindow;
  
function HandleZsUserUnlock(AZsDealSession: PZsDealSession; APassword: integer): Boolean;
begin
  Result := false; 
  FindZSProgram(AZsDealSession); 
  if FindZSMainWindow(AZsDealSession) then
  begin

  end; 
end;

end.
