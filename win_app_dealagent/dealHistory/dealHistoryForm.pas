unit dealHistoryForm;

interface

uses
  Forms, BaseForm, Classes, Controls, StdCtrls, SysUtils;

type
  TfrmDealHistory = class(TfrmBase)
    mmo1: TMemo;
  protected
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  define_deal;
  
{ TfrmDealHistory }

constructor TfrmDealHistory.Create(AOwner: TComponent);
begin
  inherited;
  mmo1.Lines.Add('TDealRequest:' + IntToStr(SizeOf(TDealRequest)));
  mmo1.Lines.Add('TDealResultClose:' + IntToStr(SizeOf(TDealResultClose)));
  mmo1.Lines.Add('TDealResultCancel:' + IntToStr(SizeOf(TDealResultCancel)));
end;

end.
