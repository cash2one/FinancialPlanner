unit TcpDealAgent;

interface

uses
  define_ctp_deal;
  
type              
  TDealConsole = class
  protected
  public
    function CheckOutDeal: PDeal;    
    procedure RunDeal(ADeal: PDeal);      
    procedure CancelDeal(ADeal: PDeal);
  end;

implementation

{ TDealConsole }

procedure TDealConsole.CancelDeal(ADeal: PDeal);
begin
end;

function TDealConsole.CheckOutDeal: PDeal;
begin
end;

procedure TDealConsole.RunDeal(ADeal: PDeal);
begin
end;

end.
