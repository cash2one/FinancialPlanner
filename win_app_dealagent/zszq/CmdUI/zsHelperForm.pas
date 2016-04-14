unit zsHelperForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  BaseForm, zsHelperMessage;

type
  TfrmZSHelper = class(TfrmBase)
    btnbuy: TButton;
    mmo1: TMemo;
    pb1: TPaintBox;
    edtLeft: TEdit;
    edtTop: TEdit;
    btnMain: TButton;
    btnlaunch: TButton;
    edStock: TEdit;
    edPrice: TEdit;
    btnConfirmDeal: TButton;
    edMoney: TEdit;
    btnConfirmPwd: TButton;
    btnUnlock: TButton;
    btnCheckMoney: TButton;
    edNum: TEdit;
    btnSale: TButton;
    btnCheckDealPanelSize: TButton;
    procedure btnMainClick(Sender: TObject);
    procedure btnlaunchClick(Sender: TObject);
    procedure btnbuyClick(Sender: TObject);
    procedure btnConfirmDealClick(Sender: TObject);
    procedure btnConfirmPwdClick(Sender: TObject);
    procedure btnUnlockClick(Sender: TObject);
    procedure btnCheckMoneyClick(Sender: TObject);
    procedure btnSaleClick(Sender: TObject);
    procedure btnCheckDealPanelSizeClick(Sender: TObject);
  protected                         
    function GetBuyPriceStep1(APrice: double): double;
    function GetBuyPriceStep2(APrice: double): double;    
    procedure SaveBuyConfig;
    procedure LoadBuyConfig;    
    procedure CreateParams(var Params: TCreateParams); override;    
    procedure WMStockBuy(var Message: TMessage); message WM_C2S_StockBuy;
    procedure WMStockBuy_XueQiu(var Message: TMessage); message WM_C2S_StockBuy_XueQiu;
    procedure WMStockSale_XueQiu(var Message: TMessage); message WM_C2S_StockSale_XueQiu;
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  UtilsWindows,
  CommCtrl,
  IniFiles,
  UtilsApplication;

constructor TfrmZSHelper.Create(Owner: TComponent);
begin
  inherited;
  LoadBuyConfig;
end;

procedure TfrmZSHelper.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WinClassName := 'WndZSHelper';
  Params.Caption := '';
  Self.Caption := '';
end;

procedure TfrmZSHelper.btnMainClick(Sender: TObject);
begin
  (*//
  if FindZSMainWindow(@GZsDealSession) then
  begin
    CheckZSMainWindow(@GZsDealSession.MainWindow);
    if nil <> GZsDealSession.MainWindow.HostWindowPtr then
    begin
      mmo1.Lines.Add('main wnd:' + IntToHex(GZsDealSession.MainWindow.HostWindowPtr.WindowHandle, 2));
    end;
    mmo1.Lines.Add('tree wnd:' + IntToHex(GZsDealSession.MainWindow.WndFunctionTree, 2));
    ClickMenuOrderMenuItem(@GZsDealSession.MainWindow);
  end;
  //*)
end;

procedure TfrmZSHelper.WMStockBuy(var Message: TMessage);
var  
  tmpStock: AnsiString;
begin
  tmpStock := IntToStr(Message.WParam);
  if 7 = Length(tmpStock) then
    tmpStock := Copy(tmpStock, 2, maxint);
  (*//
  if BuyStock(@GZsDealSession, tmpStock, Message.LParam / 1000, 10000) then
  begin
        // 出错 可能未 开通创业板权限
    ConfirmDeal(@GZsDealSession);
  end;
  //*)
end;

function TfrmZSHelper.GetBuyPriceStep1(APrice: double): double;
begin
  Result := 0;
  if APrice < 10 then
  begin
    Result := APrice * 0.995;
    exit;
  end;
  if APrice < 20 then
  begin
    Result := APrice * 0.993;  // 0.002
    exit;
  end;
  if APrice < 30 then
  begin
    Result := APrice * 0.990;  // 0.003
    exit;
  end;
  if APrice < 40 then
  begin
    Result := APrice * 0.986;  // 0.004
    exit;
  end;
  if APrice < 50 then
  begin
    Result := APrice * 0.981;  // 0.005                                
    exit;
  end;
end;

function TfrmZSHelper.GetBuyPriceStep2(APrice: double): double;
begin
  Result := 0;
  if APrice < 10 then
  begin
    Result := APrice * 0.985;
    Exit;
  end;
  if APrice < 20 then
  begin
    Result := APrice * 0.982;  // 0.003
    exit;
  end;
  if APrice < 30 then
  begin        
    Result := APrice * 0.979;  // 0.003  
    exit;
  end;
  if APrice < 40 then
  begin         
    Result := APrice * 0.975;  // 0.004  
    exit;
  end;
  if APrice < 50 then
  begin       
    Result := APrice * 0.970; // 0.005 
    exit;
  end;
  if APrice < 60 then
  begin       
    Result := APrice * 0.960;  // 0.01   
    exit;
  end;
end;

procedure TfrmZSHelper.WMStockBuy_XueQiu(var Message: TMessage);
var
  tmpNewPrice: double;
  tmpPrice: double; 
begin
  if 0 <> Message.WParam then
  begin
    tmpPrice := Message.LParam / 1000;
    tmpNewPrice := GetBuyPriceStep1(tmpPrice);
    if 0 < tmpNewPrice then
      PostMessage(Handle, WM_C2S_StockBuy, Message.WParam, Trunc(tmpNewPrice * 1000));   
    tmpNewPrice := GetBuyPriceStep2(tmpPrice);
    if 0 < tmpNewPrice then
      PostMessage(Handle, WM_C2S_StockBuy, Message.WParam, Trunc(tmpNewPrice * 1000));
  end;
end;

procedure TfrmZSHelper.WMStockSale_XueQiu(var Message: TMessage);
begin
  if 0 <> Message.WParam then
  begin
  
  end;
end;

procedure TfrmZSHelper.LoadBuyConfig;  
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    edStock.Text := tmpIni.ReadString('Test', 'Stock', '');
    edPrice.Text := tmpIni.ReadString('Test', 'Price', '0.00');
    edMoney.Text := tmpIni.ReadString('Test', 'Money', '5000');
  finally
    tmpIni.Free;
  end;
end;

procedure TfrmZSHelper.SaveBuyConfig;
var
  tmpIni: TIniFile;
begin
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpIni.WriteString('Test', 'Stock', Trim(edStock.Text));
    tmpIni.WriteString('Test', 'Price', FormatFloat('0.00', StrToFloatDef(Trim(edPrice.Text), 0)));
    tmpIni.WriteString('Test', 'Money', IntToStr(StrToIntDef(Trim(edMoney.Text), 5000)));    
  finally
    tmpIni.Free;
  end;
end;

procedure TfrmZSHelper.btnbuyClick(Sender: TObject);
var
  tmpStock: AnsiString;
  tmpPrice: double;
begin
  tmpStock := Trim(edStock.Text);
  tmpPrice := StrToFloatDef(Trim(edPrice.Text), 0);
  SaveBuyConfig();
  (*//
  if BuyStock(@GZsDealSession, tmpStock, tmpPrice, StrToIntDef(edMoney.Text, 5000)) then
  begin
    // 出错 可能未 开通创业板权限
    ConfirmDeal(@GZsDealSession);
  end;
  //*)
end;
             
procedure TfrmZSHelper.btnSaleClick(Sender: TObject); 
var
  tmpStock: AnsiString;
  tmpPrice: double;
  tmpNum: integer;
begin
  tmpStock := Trim(edStock.Text);
  tmpPrice := StrToFloatDef(Trim(edPrice.Text), 0);
  tmpNum := StrToIntDef(edNum.Text, 100);
  (*//
  if SaleStock(@GZsDealSession, tmpStock, tmpPrice, tmpNum) then
  begin
    // 出错 非交易时间内 下单
    ConfirmDeal(@GZsDealSession);
  end;
  //*)
end;

procedure TfrmZSHelper.btnCheckDealPanelSizeClick(Sender: TObject);
begin
  inherited;
  (*//
  if nil = GZsDealSession.MainWindow.HostWindowPtr then
  begin
    if not FindZSMainWindow(@GZsDealSession) then
      exit;
  end;
  CheckZSMainWindow(@GZsDealSession.MainWindow);
  CheckDealPanelSize(@GZsDealSession.MainWindow);
  //*)
end;

procedure TfrmZSHelper.btnCheckMoneyClick(Sender: TObject);
begin
  (*//
  if nil = GZsDealSession.MainWindow.HostWindowPtr then
  begin
    if not FindZSMainWindow(@GZsDealSession) then
      exit;
  end;
  CheckZSMoneyWindow(@GZsDealSession.MainWindow);
  //*)
end;

procedure TfrmZSHelper.btnConfirmDealClick(Sender: TObject);
var
  tmpWnd: HWND;
begin
  (*//
  FindZSDealConfirmDialogWindow(@GZsDealSession);
  if nil <> GZsDealSession.DealConfirmDialog then
  begin              
    CheckZSDialogWindow(GZsDealSession.DealConfirmDialog);
    if IsWindow(GZsDealSession.DealConfirmDialog.OKButton) then
    begin                   
      tmpWnd := GZsDealSession.DealConfirmDialog.WindowHandle;
      if IsWindow(tmpWnd) then
      begin
        ForceBringFrontWindow(tmpWnd);
        SleepWait(20);
        ForceBringFrontWindow(tmpWnd);
        SleepWait(20);
      end;
      ClickButtonWnd(GZsDealSession.DealConfirmDialog.OKButton);
    end;
  end;
  //*)
end;

procedure TfrmZSHelper.btnUnlockClick(Sender: TObject);
begin
  { 各种可能出现的 对话框 }
  (*//
  if nil = GZsDealSession.MainWindow.HostWindowPtr then
  begin
    if not FindZSMainWindow(@GZsDealSession) then
      exit;
  end;    
  FindZSLockPanelWindow(@GZsDealSession);
  //*)
end;

procedure TfrmZSHelper.btnConfirmPwdClick(Sender: TObject);
var
  tmpWnd: HWND;
  tmpIsChecked: Integer;
begin
  { 各种可能出现的 对话框 }
  (*//
  if nil = GZsDealSession.MainWindow.HostWindowPtr then
  begin
    if not FindZSMainWindow(@GZsDealSession) then
      exit;
  end;
  FindZSPasswordConfirmDialogWindow(@GZsDealSession);
  if nil <> GZsDealSession.DealPasswordConfirmDialogWindow.HostWindowPtr then
  begin
    CheckZSPasswordConfirmDialogWindow(@GZsDealSession.DealPasswordConfirmDialogWindow);
    tmpWnd := GZsDealSession.DealPasswordConfirmDialogWindow.WndNoInputNextCheck;
    if IsWindow(tmpWnd) then
    begin
      tmpIsChecked := SendMessage(tmpWnd, BM_GETCHECK, 0, 0);
      if 0 = tmpIsChecked then
      begin
        ClickButtonWnd(tmpWnd);
      end;
    end; 
    tmpWnd := GZsDealSession.DealPasswordConfirmDialogWindow.WndPasswordEdit;
    if IsWindow(tmpWnd) then
    begin
      InputEditWnd(tmpWnd, '111111');
    end;
    tmpWnd := GZsDealSession.DealPasswordConfirmDialogWindow.HostWindowPtr.OKButton;    
    if IsWindow(tmpWnd) then
    begin
      ClickButtonWnd(tmpWnd);
    end;
  end;
  //*)
end;

procedure TfrmZSHelper.btnlaunchClick(Sender: TObject);
begin
  //AutoLogin(@GZsDealSession);
end;

end.
