unit ctpConsoleForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  BaseForm;

type
  TfrmCtpConsole = class(TfrmBase)
  protected                         
    procedure CreateParams(var Params: TCreateParams); override;    
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfrmCtpConsole.Create(Owner: TComponent);
begin
  inherited;
end;

procedure TfrmCtpConsole.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WinClassName := 'WndCtpConsole';
  Params.Caption := '';
  Self.Caption := '';
end;

end.
