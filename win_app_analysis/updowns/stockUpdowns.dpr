program stockUpdowns;

{ % File '..\StockDataGet_Day\StockDay_163.bdsproj'}

uses
  Windows,
  Forms,
  QuickList_Int in '..\..\..\devwintech\comps\list\QuickList_Int.pas',
  QuickList_double in '..\..\..\devwintech\comps\list\QuickList_double.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  BaseWinApp in '..\..\..\devwintech\v0000\win_base\BaseWinApp.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\win_base\BaseDataSet.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseFile in '..\..\..\devwintech\v0000\win_base\BaseFile.pas',
  BaseForm in '..\..\..\devwintech\v0000\win_base\BaseForm.pas' {frmBase},
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  FormAnalysisUpsDowns in 'FormAnalysisUpsDowns.pas' {frmAnalysisUpsDowns},
  Define_AnalysisUpsDowns in 'Define_AnalysisUpsDowns.pas';

{$R *.res}

type
  TAIAnalysisUpsDownsApp = class(TBaseStockApp)
  protected
    fMainForm: TfrmBase;              
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
    function Initialize: Boolean; override;
  end;

{ TStockDay163App }

constructor TAIAnalysisUpsDownsApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

function TAIAnalysisUpsDownsApp.Initialize: Boolean;
begin
  Application.Initialize;
  InitializeDBStockItem;
  Result := true;
end;
              
procedure TAIAnalysisUpsDownsApp.Run;
begin
  //FormDetailDataViewer.CreateMainForm(fMainForm);
  FormAnalysisUpsDowns.CreateMainForm(fMainForm);     
  fMainForm.App := Self;
  fMainForm.Initialize(Self);
  Application.Run;
end;

var
  GlobalApp: TAIAnalysisUpsDownsApp;
begin
  GlobalApp := TAIAnalysisUpsDownsApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
