unit zsHelperCmdUIApp;

interface

uses
  Forms, BaseApp, BaseWinApp, BaseForm;
  
type
  TzsHelperCmdUIApp = class(TBaseWinApp)
  protected          
    fMainForm: TfrmBase;
  public
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TzsHelperCmdUIApp = nil;

implementation

uses
  zsHelperForm;
  
{ TzsHelperApp }

procedure TzsHelperCmdUIApp.Finalize;
begin
  inherited;

end;

function TzsHelperCmdUIApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;  
  Application.CreateForm(TfrmZSHelper, fMainForm);
end;

procedure TzsHelperCmdUIApp.Run;
begin
  fMainForm.App := Self;
  Application.Run;
end;

end.
