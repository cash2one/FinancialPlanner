unit dealHistoryApp;

interface
        
uses
  Forms, BaseApp, BaseWinApp, BaseForm;
  
type
  TdealHistoryApp = class(TBaseWinApp)
  protected          
    fMainForm: TfrmBase; 
  public
    procedure DoLog(ALog: string);
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;

var
  GlobalApp: TdealHistoryApp = nil;

implementation

uses
  FormFunctionsTab,
  dealHistoryForm;

function TdealHistoryApp.Initialize: Boolean;
begin
  Result := inherited Initialize;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
end;

procedure TdealHistoryApp.Finalize;
begin
  inherited;
end;
                 
procedure TdealHistoryApp.Run;
begin                   
  //Application.CreateForm(TfrmCtpConsole, fMainForm);  
  Application.CreateForm(TfrmFunctionsTab, fMainForm);
  fMainForm.Initialize(Self);
  fMainForm.App := Self;    
  TfrmFunctionsTab(fMainForm).AddFunctionTab('交易历史', TfrmDealHistory);
  Application.Run;
end;

procedure TdealHistoryApp.DoLog(ALog: string);
begin
  if '' <> ALog then
  begin  
  end;
end;

end.
