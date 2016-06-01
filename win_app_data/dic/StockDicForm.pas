unit StockDicForm;

interface

uses
  Windows, Messages, ActiveX, SysUtils, ShellApi, Dialogs,
  Classes, Controls, Forms, StdCtrls, ExtCtrls, VirtualTrees,   
  define_dealitem, DealItemsTreeView,
  BaseApp, BaseWinApp, db_dealitem, BaseStockApp, BaseForm;

type        
  TfrmStockDic = class(TfrmBase)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlLeft: TPanel;
    btnSaveDic: TButton;
    spl1: TSplitter;
    pnlRight: TPanel;
    mmo1: TMemo;
    btnOpen: TButton;
    btnClear: TButton;
    btnSaveIni: TButton;
    procedure btnSaveDicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAppStartTimer(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSaveIniClick(Sender: TObject);
  protected
    fDealItemTree: TDealItemTree;   
    fAppStartTimer: TTimer;
    procedure WMDropFiles(var msg : TWMDropFiles) ; message WM_DROPFILES;
    procedure SaveDealItemDBAsDic(AFileUrl: string); 
    procedure SaveDealItemDBAsIni(AFileUrl: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

  TStockDicApp = class(TBaseStockApp)
  protected
    frmStockDic: TfrmStockDic;
  public                     
    constructor Create(AppClassId: AnsiString); override;
    function Initialize: Boolean; override;
    procedure Run; override;
  end;

var
  GlobalApp: TStockDicApp = nil;

implementation

uses
  db_dealitem_load,
  db_dealItem_LoadIni,
  db_dealItem_Save;

{$R *.dfm}

constructor TStockDicApp.Create(AppClassId: AnsiString);
begin
  inherited;     
end;

function TStockDicApp.Initialize: Boolean; 
begin
  inherited Initialize;
  Result := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  InitializeDBStockItem;
end;

procedure TStockDicApp.Run;
begin
  Application.CreateForm(TfrmStockDic, frmStockDic);
  Application.Run;
end;

constructor TfrmStockDic.Create(AOwner: TComponent);
begin
  inherited;
  Self.OnCreate := FormCreate;
  App := GlobalApp;
  fAppStartTimer := TTimer.Create(Application);
  fAppStartTimer.Interval := 100;
  fAppStartTimer.OnTimer := tmrAppStartTimer;
  fAppStartTimer.Enabled := true;
  //fVtDealItems.Columns = <>;
end;

procedure TfrmStockDic.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True) ;
//
end;

procedure TfrmStockDic.tmrAppStartTimer(Sender: TObject);
begin
  if nil <> Sender then
  begin
    if Sender is TTimer then
    begin
      TTimer(Sender).Enabled := false;
      TTimer(Sender).OnTimer := nil;
    end;
    fAppStartTimer.Enabled := false;
    fAppStartTimer.OnTimer := nil;
  end;
  fDealItemTree := TDealItemTree.Create(pnlLeft);
  fDealItemTree.InitializeDealItemsTree;
  fDealItemTree.BuildDealItemsTreeNodes;
end;
                
procedure TfrmStockDic.WMDropFiles(var msg: TWMDropFiles);
const
  MAXFILENAME = 255;
var
  tmpcnt: integer;
  tmpfileCount : integer;
  tmpfileName : array [0..MAXFILENAME] of char;
  tmpFileUrl: string;
  tmpNewFileUrl: string;
  tmpPath: string;
begin
  // how many files dropped?
  tmpfileCount := DragQueryFile(msg.Drop, $FFFFFFFF, tmpfileName, MAXFILENAME) ;
  tmpPath := '';
  // query for file names
  for tmpcnt := 0 to tmpfileCount -1 do
  begin
    DragQueryFile(msg.Drop, tmpcnt, tmpfileName, MAXFILENAME) ;
    //do something with the file(s)
    mmo1.Lines.Insert(0, tmpfileName);
    tmpFileUrl := tmpfileName;
    if 0 < Pos('.ini', tmpFileUrl) then
    begin
      //DB_StockItem_LoadIni.LoadDBStockItemIni(GlobalApp, GlobalApp.fDBStockItem);
      db_dealItem_LoadIni.LoadDBStockItemIniFromFile(GlobalApp, GlobalApp.StockItemDB, tmpFileUrl);
    end;             
    if 0 < Pos('.dic', tmpFileUrl) then
    begin
      LoadDBStockItemDicFromFile(GlobalApp, GlobalApp.StockItemDB, tmpFileUrl);
    end;
    if '' = tmpPath then
      tmpPath := ExtractFilePath(tmpFileUrl);
  end;                       
  if 0 < GlobalApp.StockItemDB.RecordCount then
  begin
    tmpNewFileUrl := '';
    if 1 < tmpfileCount then
    begin
      tmpNewFileUrl := tmpPath + 'items' + FormatDateTime('yyyymmdd', now) + '.dic';
    end else
    begin
      tmpNewFileUrl := ChangeFileExt(tmpFileUrl, '.dic');
    end;
    if '' <> tmpNewFileUrl then
    begin
      if not FileExists(tmpNewFileUrl) then
      begin
        SaveDealItemDBAsDic(tmpNewFileUrl);
      end;
    end;
  end;
  //release memory
  DragFinish(msg.Drop) ;
  fDealItemTree.BuildDealItemsTreeNodes;
end;

procedure TfrmStockDic.SaveDealItemDBAsDic(AFileUrl: string);
begin                     
  GlobalApp.StockItemDB.Sort;
  db_dealItem_Save.SaveDBStockItemToDicFile(GlobalApp, GlobalApp.StockItemDB, AFileUrl);
end;

procedure TfrmStockDic.SaveDealItemDBAsIni(AFileUrl: string);
begin                     
  GlobalApp.StockItemDB.Sort;
  db_dealItem_Save.SaveDBStockItemToIniFile(GlobalApp, GlobalApp.StockItemDB, AFileUrl);
end;

procedure TfrmStockDic.btnClearClick(Sender: TObject);
begin
  inherited;
  fDealItemTree.Clear;    
  GlobalApp.StockItemDB.Clear;
end;

procedure TfrmStockDic.btnOpenClick(Sender: TObject);   
var
  tmpFileUrl: string;
  tmpOpenDlg: TOpenDialog;
  i: integer;
  tmpIsDone: Boolean;
begin
  tmpOpenDlg := TOpenDialog.Create(Self);
  try
    tmpOpenDlg.InitialDir := ExtractFilePath(ParamStr(0));
    tmpOpenDlg.DefaultExt := '.dic';
    tmpOpenDlg.Filter := 'dic file|*.dic|ini file|*.ini';
    tmpOpenDlg.Options := tmpOpenDlg.Options + [ofAllowMultiSelect];
    //tmpOpenDlg.OptionsEx := [];   
    if not tmpOpenDlg.Execute then
      exit;
    tmpIsDone := false;
    for i := 0 to tmpOpenDlg.Files.Count - 1 do
    begin
      tmpFileUrl := tmpOpenDlg.Files[i];
      if 0 < Pos('.ini', lowercase(tmpFileUrl)) then
      begin
        db_dealItem_LoadIni.LoadDBStockItemIniFromFile(GlobalApp, GlobalApp.StockItemDB, tmpFileUrl);
        tmpIsDone := true;
      end;                        
      if 0 < Pos('.dic', lowercase(tmpFileUrl)) then
      begin
        db_dealItem_Load.LoadDBStockItemDicFromFile(GlobalApp, GlobalApp.StockItemDB, tmpFileUrl);
        tmpIsDone := true;
      end;
    end;
    if tmpIsDone then
    begin
      fDealItemTree.BuildDealItemsTreeNodes;
    end;
  finally
    tmpOpenDlg.Free;
  end;
end;

procedure TfrmStockDic.btnSaveDicClick(Sender: TObject);
var
  tmpFileUrl: string;
  tmpSaveDlg: TSaveDialog;
begin
  tmpFileUrl := '';                    
  tmpSaveDlg := TSaveDialog.Create(Self);
  try
    tmpSaveDlg.InitialDir := ExtractFilePath(ParamStr(0));
    tmpSaveDlg.DefaultExt := '.dic';
    tmpSaveDlg.Filter := 'dic file|*.dic'; 
    if not tmpSaveDlg.Execute then
      exit;
    tmpFileUrl := tmpSaveDlg.FileName;
    if '' <> Trim(tmpFileUrl) then
    begin
      SaveDealItemDBAsDic(tmpFileUrl);
    end;
  finally
    tmpSaveDlg.Free;
  end;
end;

procedure TfrmStockDic.btnSaveIniClick(Sender: TObject);
var
  tmpFileUrl: string;
  tmpSaveDlg: TSaveDialog;
begin
  tmpFileUrl := '';                    
  tmpSaveDlg := TSaveDialog.Create(Self);
  try
    tmpSaveDlg.InitialDir := ExtractFilePath(ParamStr(0));
    tmpSaveDlg.DefaultExt := '.ini';
    tmpSaveDlg.Filter := 'ini file|*.ini'; 
    if not tmpSaveDlg.Execute then
      exit;
    tmpFileUrl := tmpSaveDlg.FileName;
    if '' <> Trim(tmpFileUrl) then
    begin
      SaveDealItemDBAsIni(tmpFileUrl);
    end;
  finally
    tmpSaveDlg.Free;
  end;
end;

end.
