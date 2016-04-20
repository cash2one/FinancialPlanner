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

uses
  //ctpConsoleForm,
  TcpAgentConsole,
  ctpConsoleAppCommandWnd,
  FormFunctionsTab,
  ctpDealForm,
  ctpQuoteForm;
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

  fBaseWinAppData.AppCmdWnd := ctpConsoleAppCommandWnd.CreateAppCommandWindow;
  
  if nil = GTcpAgentConsole then
  begin
    GTcpAgentConsole := TTcpAgentConsole.Create;
  end;
end;

procedure TctpConsoleApp.Run;
begin                   
  //Application.CreateForm(TfrmCtpConsole, fMainForm);  
  Application.CreateForm(TfrmFunctionsTab, fMainForm);
  fMainForm.Initialize(Self);
  fMainForm.App := Self;    
  TfrmFunctionsTab(fMainForm).AddFunctionTab('交易', TfrmCtpDeal);
  TfrmFunctionsTab(fMainForm).AddFunctionTab('行情', TfrmCtpQuote);  
  Application.Run;
end;

end.
