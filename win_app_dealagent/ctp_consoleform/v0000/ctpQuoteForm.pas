unit ctpQuoteForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  BaseForm;

type
  TfrmCtpQuote = class(TfrmBase)
    pnlInit: TPanel;
    btnInitMD: TButton;
    btnConnectMD: TButton;
    edtAddrMD: TComboBox;
    btnShutDown: TButton;
    pnlLogin: TPanel;
    lblAccount: TLabel;
    lblPassowrd: TLabel;
    lblBrokeId: TLabel;
    btnLoginMD: TButton;
    edtAccount: TComboBox;
    edtPassword: TEdit;
    edtBrokeId: TComboBox;
    btnLogoutMD: TButton;
    pnlScribe: TPanel;
    lblItem: TLabel;
    btnSubscribe: TButton;
    edtInstItem: TEdit;
    btnUnsubscribe: TButton;
    procedure btnInitMDClick(Sender: TObject);
    procedure btnConnectMDClick(Sender: TObject);
    procedure btnLoginMDClick(Sender: TObject);
    procedure btnLogoutMDClick(Sender: TObject);
    procedure btnShutDownClick(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure btnUnsubscribeClick(Sender: TObject);
  protected                         
    procedure CreateParams(var Params: TCreateParams); override;    
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  define_app_msg,
  TcpInitUtils,
  TcpAgentConsole;
  
constructor TfrmCtpQuote.Create(Owner: TComponent);
begin
  inherited;
end;

procedure TfrmCtpQuote.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WinClassName := 'WndCtpQuote';
  Params.Caption := '';
  Self.Caption := '';
end;

procedure TfrmCtpQuote.btnInitMDClick(Sender: TObject);
begin
  GTcpAgentConsole.InitMD;
end;

procedure TfrmCtpQuote.btnConnectMDClick(Sender: TObject);
var
  tmpAddrDesc: AnsiString;
  tmpAddr: AnsiString;
begin
  tmpAddrDesc := Trim(edtAddrMD.Text);
  tmpAddr := ParseAddress(tmpAddrDesc);
  SaveIniAddress(tmpAddrDesc, tmpAddr, 'MDUrl');

  GTcpAgentConsole.ConnectMD(tmpAddr);
end;

procedure TfrmCtpQuote.btnShutDownClick(Sender: TObject);
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    SendMessage(GTcpAgentConsole.SrvWND, WM_C2S_Shutdown, 0, 0);
  end;
end;

procedure TfrmCtpQuote.btnLoginMDClick(Sender: TObject);
begin
  GTcpAgentConsole.LoginMD(Trim(edtBrokeId.Text), Trim(edtAccount.Text), Trim(edtPassword.Text));
  SaveIniAccount(Trim(edtBrokeId.Text), Trim(edtAccount.Text));
end;

procedure TfrmCtpQuote.btnLogoutMDClick(Sender: TObject);
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    SendMessage(GTcpAgentConsole.SrvWND, WM_C2S_MD_RequestUserLogout, GTcpAgentConsole.CheckOutRequestId, 0);
  end;
end;

procedure TfrmCtpQuote.btnSubscribeClick(Sender: TObject);
begin
  GTcpAgentConsole.MDSubscribe(Trim(edtInstItem.Text));
end;

procedure TfrmCtpQuote.btnUnsubscribeClick(Sender: TObject);
var
  tmpCopyData: TCopyDataCommand;
  tmpAnsi: AnsiString;
begin
  if GTcpAgentConsole.FindSrvWindow then
  begin
    //PostMessage(SrvWND, WM_C2S_UnSubscribeMarketData, 0, 0);
    FillChar(tmpCopyData, SizeOf(TCopyDataCommand), 0);
    tmpCopyData.Base.dwData := WM_C2S_UnSubscribeMarketData;
    tmpCopyData.Base.cbData := SizeOf(tmpCopyData.CommonCommand);
    tmpCopyData.Base.lpData := @tmpCopyData.CommonCommand;

    tmpAnsi := Trim(edtInstItem.Text);
    CopyMemory(@tmpCopyData.CommonCommand.scmd1[0], @tmpAnsi[1], Length(tmpAnsi));

    SendMessage(GTcpAgentConsole.SrvWND, WM_COPYDATA, Self.Handle, LongWord(@tmpCopyData));
  end;
end;

end.
