unit StockDicForm;

interface

uses
  Windows, Messages, ActiveX, SysUtils, ShellApi,
  Classes, Controls, Forms, StdCtrls,
  BaseApp, BaseWinApp, DB_StockItem;

type
  TfrmStockDic = class(TForm)
    btn1: TButton;
    mmo1: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    procedure WMDropFiles(var msg : TWMDropFiles) ; message WM_DROPFILES;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

  TStockDicApp = class(TBaseWinApp)
  protected
    frmStockDic: TfrmStockDic;
    fDBStockItem: TDBStockItem;
  public                     
    constructor Create(AppClassId: AnsiString); override;
    function Initialize: Boolean; override;
    procedure Run; override;
  end;

var
  GlobalApp: TStockDicApp = nil;

implementation

uses
  DB_StockItem_LoadIni,
  DB_StockItem_Save;

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
  fDBStockItem := TDBStockItem.Create;
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
end;

procedure TfrmStockDic.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True) ;
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
    DB_StockItem_LoadIni.LoadDBStockItemIniFromFile(GlobalApp, GlobalApp.fDBStockItem, tmpFileUrl);
    if '' = tmpPath then
      tmpPath := ExtractFilePath(tmpFileUrl);
    if 1 = tmpfileCount then
    begin
      if 0 < GlobalApp.fDBStockItem.RecordCount then
      begin                            
        GlobalApp.fDBStockItem.Sort;
        tmpNewFileUrl := ChangeFileExt(tmpFileUrl, '.dic');
        if not FileExists(tmpNewFileUrl) then
        begin
          DB_StockItem_Save.SaveDBStockItemToFile(GlobalApp, GlobalApp.fDBStockItem, tmpNewFileUrl);
        end;
      end;
    end;
  end;    
  if 1 < tmpfileCount then
  begin                           
    if 0 < GlobalApp.fDBStockItem.RecordCount then
    begin
      GlobalApp.fDBStockItem.Sort;
      DB_StockItem_Save.SaveDBStockItemToFile(GlobalApp, GlobalApp.fDBStockItem, tmpPath + 'items' + FormatDateTime('yyyymmdd', now) + '.dic');
    end;
  end;
  //release memory
  DragFinish(msg.Drop) ;
end;

procedure TfrmStockDic.btn1Click(Sender: TObject);
begin
//
end;

end.
