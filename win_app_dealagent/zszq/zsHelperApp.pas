unit zsHelperApp;

interface

uses
  Forms, BaseApp, BaseWinApp, BaseForm;
  
type
  TzsHelperApp = class(TBaseWinApp)
  protected          
    fMainForm: TfrmBase;
  public
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TzsHelperApp = nil;

implementation

uses
  zsHelperForm;
  
{ TzsHelperApp }

procedure TzsHelperApp.Finalize;
begin
  inherited;

end;

function TzsHelperApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;  
  Application.CreateForm(TfrmZSHelper, fMainForm);
end;

procedure TzsHelperApp.Run;
begin
  fMainForm.App := Self;
  Application.Run;
end;

end.
