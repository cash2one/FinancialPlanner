unit floatwinapp;

interface

uses
  BaseWinApp;

type
  TStockFloatApp = class(TBaseWinApp)
  protected
  public   
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;

    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;
  end;  

var
  GlobalApp: TStockFloatApp = nil;
  
implementation

uses
  floatwindow;
  
{ TStockFloatApp }

constructor TStockFloatApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

destructor TStockFloatApp.Destroy;
begin
  inherited;
end;
           
function TStockFloatApp.Initialize: Boolean;
begin
  inherited Initialize;
  Result := CreateFloatWindow(Self);
end;

procedure TStockFloatApp.Finalize;
begin
  inherited;
end;

procedure TStockFloatApp.Run;
begin
  inherited;
  ShowFloatWindow;
  RunAppMsgLoop;
end;

end.
