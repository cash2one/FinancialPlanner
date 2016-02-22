unit StockDicForm;

interface

uses
  Windows, Messages, ActiveX, SysUtils, ShellApi,
  Classes, Controls, Forms, StdCtrls, ExtCtrls, VirtualTrees, 
  BaseApp, BaseWinApp, db_dealitem, BaseStockApp;

type
  TfrmStockDic = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlLeft: TPanel;
    btnSave: TButton;
    spl1: TSplitter;
    pnlRight: TPanel;
    mmo1: TMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    fVtDealItems: TVirtualStringTree;
    procedure WMDropFiles(var msg : TWMDropFiles) ; message WM_DROPFILES;  
    procedure vtDealItemGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
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

type
  PDealItemNode = ^TDealItemNode; 
  TDealItemNode = record

  end;

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
  fVtDealItems := TVirtualStringTree.Create(Self);
  fVtDealItems.Parent := pnlLeft;
  fVtDealItems.Align := alClient;   
  fVtDealItems.NodeDataSize := SizeOf(TDealItemNode);
  fVtDealItems.OnGetText := vtDealItemGetText;
  //fVtDealItems.Columns = <>;
end;

procedure TfrmStockDic.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True) ;
//
end;

procedure TfrmStockDic.vtDealItemGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := '1234';
//
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
    //DB_StockItem_LoadIni.LoadDBStockItemIni(GlobalApp, GlobalApp.fDBStockItem);
    db_dealItem_LoadIni.LoadDBStockItemIniFromFile(GlobalApp, GlobalApp.StockItemDB, tmpFileUrl);
    if '' = tmpPath then
      tmpPath := ExtractFilePath(tmpFileUrl);
    if 1 = tmpfileCount then
    begin
      if 0 < GlobalApp.StockItemDB.RecordCount then
      begin                            
        GlobalApp.StockItemDB.Sort;
        tmpNewFileUrl := ChangeFileExt(tmpFileUrl, '.dic');
        if not FileExists(tmpNewFileUrl) then
        begin
          db_dealItem_Save.SaveDBStockItemToFile(GlobalApp, GlobalApp.StockItemDB, tmpNewFileUrl);
        end;
      end;
    end;
  end;    
  if 1 < tmpfileCount then
  begin                           
    if 0 < GlobalApp.StockItemDB.RecordCount then
    begin
      GlobalApp.StockItemDB.Sort;
      db_dealitem_Save.SaveDBStockItemToFile(GlobalApp, GlobalApp.StockItemDB, tmpPath + 'items' + FormatDateTime('yyyymmdd', now) + '.dic');
    end;
  end;
  //release memory
  DragFinish(msg.Drop) ;
end;

procedure TfrmStockDic.btnSaveClick(Sender: TObject);
begin
//
end;

end.
