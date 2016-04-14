unit zsHelperCmdExecApp;

interface

uses
  BaseApp, BaseWinApp;
  
type
  TzsHelperCmdExecApp = class(TBaseWinApp)
  protected          
  public
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TzsHelperCmdExecApp = nil;

implementation

{ TzsHelperApp }

procedure TzsHelperCmdExecApp.Finalize;
begin
  inherited;

end;

function TzsHelperCmdExecApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
end;

procedure TzsHelperCmdExecApp.Run;
begin
end;

end.
