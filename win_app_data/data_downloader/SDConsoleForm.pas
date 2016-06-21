unit SDConsoleForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, StdCtrls;

type
  TfrmSDConsole = class(TfrmBase)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  windef_msg,
  define_StockDataApp,
  BaseWinApp;
  
procedure TfrmSDConsole.btn1Click(Sender: TObject);
begin
  inherited;
  //
  if IsWindow(TBaseWinApp(App).AppWindow) then
  begin
    PostMessage(TBaseWinApp(App).AppWindow, WM_Console_Command_Download, 0, 0);
  end;
end;

end.
