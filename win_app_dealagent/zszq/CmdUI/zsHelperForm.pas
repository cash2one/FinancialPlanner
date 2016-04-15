unit zsHelperForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  BaseForm, zsHelperMessage, zsHelperDefine;

type
  TZSHelperFormData = record
    ZsHelperCmdWnd: HWND;               
  end;
  
  TfrmZSHelper = class(TfrmBase)
    btnbuy: TButton;
    mmo1: TMemo;
    btnlaunch: TButton;
    edStock: TEdit;
    edPrice: TEdit;
    edMoney: TEdit;
    edNum: TEdit;
    btnSale: TButton;
    btnUnlock: TButton;
    btnLogin: TButton;
    edtUserId: TEdit;
    edtPassword: TEdit;
    procedure btnMainClick(Sender: TObject);
    procedure btnlaunchClick(Sender: TObject);
    procedure btnbuyClick(Sender: TObject);
    procedure btnConfirmDealClick(Sender: TObject);
    procedure btnConfirmPwdClick(Sender: TObject);
    procedure btnUnlockClick(Sender: TObject);
    procedure btnCheckMoneyClick(Sender: TObject);
    procedure btnSaleClick(Sender: TObject);
    procedure btnCheckDealPanelSizeClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  protected
    fZSHelperFormData: TZSHelperFormData;   
    function FindZsHelperCmdWnd: Boolean; 
    function GetBuyPriceStep1(APrice: double): double;
    function GetBuyPriceStep2(APrice: double): double;    
    procedure SaveBuyConfig;
    procedure LoadBuyConfig;    
    procedure CreateParams(var Params: TCreateParams); override;    
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
  FillChar(fZSHelperFormData, SizeOf(fZSHelperFormData), 0);
  LoadBuyConfig;
end;

procedure TfrmZSHelper.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WinClassName := 'WndZSHelper';
  Params.Caption := '';
  Self.Caption := '';
end;

function TfrmZSHelper.FindZsHelperCmdWnd: Boolean;
begin
  if not IsWindow(fZSHelperFormData.ZsHelperCmdWnd) then
  begin
    fZSHelperFormData.ZsHelperCmdWnd := Windows.FindWindow(zsHelperCmdExecApp_AppCmdWndClassName, '');
  end;
  Result := IsWindow(fZSHelperFormData.ZsHelperCmdWnd);
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
(*//
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
      PostMessage(Handle, WM_C2S_StockBuy_Mode_1, Message.WParam, Trunc(tmpNewPrice * 1000));   
    tmpNewPrice := GetBuyPriceStep2(tmpPrice);
    if 0 < tmpNewPrice then
      PostMessage(Handle, WM_C2S_StockBuy_Mode_1, Message.WParam, Trunc(tmpNewPrice * 1000));
  end;
end;
//*)
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
//var
//  tmpWnd: HWND;
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

procedure TfrmZSHelper.btnConfirmPwdClick(Sender: TObject);
//var
//  tmpWnd: HWND;
//  tmpIsChecked: Integer;
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
  if FindZsHelperCmdWnd then
  begin
    PostMessage(fZSHelperFormData.ZsHelperCmdWnd, WM_C2S_LaunchProgram, 0, 0);
  end;
end;

procedure TfrmZSHelper.btnLoginClick(Sender: TObject);
var
  tmpPassword: integer;
  tmpNewOneId: Integer;
begin
  if FindZsHelperCmdWnd then
  begin
    tmpPassword := StrToIntDef(edtPassword.Text, 0);
    if 0 < tmpPassword then
    begin
      tmpNewOneId := StrToIntDef(edtUserId.Text, 0);
      if 0 = tmpNewOneId then
        tmpNewOneId := 39008990;
      PostMessage(fZSHelperFormData.ZsHelperCmdWnd, WM_C2S_LoginUser, tmpNewOneId, tmpPassword);
    end;
  end;
end;

procedure TfrmZSHelper.btnUnlockClick(Sender: TObject);
var    
  tmpPassword: integer;
begin              
  if FindZsHelperCmdWnd then
  begin
    tmpPassword := StrToIntDef(edtPassword.Text, 0);
    if 0 < tmpPassword then
    begin
      PostMessage(fZSHelperFormData.ZsHelperCmdWnd, WM_C2S_Unlock, 0, tmpPassword);
    end;
  end;
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

procedure TfrmZSHelper.btnbuyClick(Sender: TObject);
var
  tmpStock: AnsiString; 
  tmpStockId: Integer;
  tmpPrice: double;       
  dealBuyParam: TWMDeal_LParam;
begin
  SaveBuyConfig();   
  if FindZsHelperCmdWnd then
  begin                               
    tmpStock := Trim(edStock.Text);
    tmpStockId := StrToIntDef(tmpStock, 0);
    if 0 < tmpStockId then
    begin                     
      tmpPrice := StrToFloatDef(Trim(edPrice.Text), 0);
      if 0 < tmpPrice then
      begin
        dealBuyParam.Price := Trunc(tmpPrice * 100);
        dealBuyParam.Hand := Trunc(StrToIntDef(edNum.Text, 0) / 100);
        if 0 < dealBuyParam.Hand then
        begin
          PostMessage(fZSHelperFormData.ZsHelperCmdWnd, WM_C2S_StockBuy_Mode_1, tmpStockId, Integer(dealBuyParam));
        end;
      end;
    end;
  end;
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
  tmpStockId: Integer;
  tmpPrice: double;       
  dealSaleParam: TWMDeal_LParam;
begin
  SaveBuyConfig();   
  if FindZsHelperCmdWnd then
  begin                               
    tmpStock := Trim(edStock.Text);
    tmpStockId := StrToIntDef(tmpStock, 0);
    if 0 < tmpStockId then
    begin                     
      tmpPrice := StrToFloatDef(Trim(edPrice.Text), 0);
      if 0 < tmpPrice then
      begin
        dealSaleParam.Price := Trunc(tmpPrice * 100);
        dealSaleParam.Hand := Trunc(StrToIntDef(edNum.Text, 0) / 100);
        if 0 < dealSaleParam.Hand then
        begin
          PostMessage(fZSHelperFormData.ZsHelperCmdWnd, WM_C2S_StockSale_Mode_1, tmpStockId, Integer(dealSaleParam));
        end;
      end;
    end;
  end;
  (*//
  if SaleStock(@GZsDealSession, tmpStock, tmpPrice, tmpNum) then
  begin
    // 出错 非交易时间内 下单
    ConfirmDeal(@GZsDealSession);
  end;
  //*)
end;

end.
