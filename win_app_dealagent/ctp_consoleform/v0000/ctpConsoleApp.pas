unit ctpConsoleApp;

interface

uses
  Forms, BaseApp, BaseWinApp, BaseForm;
  
type
  TctpConsoleApp = class(TBaseWinApp)
  protected          
    fMainForm: TfrmBase;
  public
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TctpConsoleApp = nil;

implementation
  
{ TswHelperApp }

procedure TctpConsoleApp.Finalize;
begin
  inherited;

end;

function TctpConsoleApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;  
end;

procedure TctpConsoleApp.Run;
begin
  fMainForm.App := Self;
  Application.Run;
end;

end.
