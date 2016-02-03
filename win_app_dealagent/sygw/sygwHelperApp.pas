unit sygwHelperApp;

interface

uses
  Forms, BaseApp, BaseWinApp, BaseForm;
  
type
  TswHelperApp = class(TBaseWinApp)
  protected          
    fMainForm: TfrmBase;
  public
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TswHelperApp = nil;

implementation

uses
  sygwHelperForm;
  
{ TswHelperApp }

procedure TswHelperApp.Finalize;
begin
  inherited;

end;

function TswHelperApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;  
  Application.CreateForm(TfrmZSHelper, fMainForm);
end;

procedure TswHelperApp.Run;
begin
  fMainForm.App := Self;
  Application.Run;
end;

end.
