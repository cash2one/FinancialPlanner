unit zsVariants;

interface

uses
  Windows,
  zsProcess,
  ZsAttach;
                   
var
  GZsDealSession: TZsDealSession;
                          
  procedure zsVariantsInitialize;   

implementation

procedure zsVariantsInitialize;
begin
  FillChar(GZsDealSession, SizeOf(GZsDealSession), 0);
end;

initialization
  zsVariantsInitialize;
  
end.
