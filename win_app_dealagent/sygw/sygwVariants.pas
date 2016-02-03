unit sygwVariants;

interface

uses
  Windows,
  exProcess,
  sygwAttach;
                   
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
