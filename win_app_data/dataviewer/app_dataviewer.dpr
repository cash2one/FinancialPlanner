program App_DataViewer;

{ % File '..\StockDataGet_Day\StockDay_163.bdsproj'}

uses
  Windows,
  Forms,
  QuickList_int in '..\..\..\devwintech\comps\list\QuickList_int.pas',
  QuickList_double in '..\..\..\devwintech\comps\list\QuickList_double.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  VirtualTrees in '..\..\..\devdcomps\virtualtree\VirtualTrees.pas',
  BaseApp in '..\..\..\devwintech\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0001\obj\app_base\BasePath.pas',
  BaseFile in '..\..\..\devwintech\v0001\obj\app_base\BaseFile.pas',
  BaseWinApp in '..\..\..\devwintech\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\devwintech\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  sysdef_string in '..\..\..\devwintech\v0001\sysdef\sysdef_string.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\app_base\BaseDataSet.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  UtilsLog in '..\..\..\devwintech\v0000\win_utils\UtilsLog.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas',
  define_stock_quotes in '..\..\basedefine\define_stock_quotes.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  BaseStockApp in '..\..\base\BaseStockApp.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  BaseRule in '..\..\baserule\BaseRule.pas',
  Rule_STD in '..\..\baserule\Rule_STD.pas',
  Rule_Boll in '..\..\baserule\Rule_Boll.pas',
  Rule_MA in '..\..\baserule\Rule_MA.pas',
  Rule_CYHT in '..\..\baserule\Rule_CYHT.pas',
  Rule_LLV in '..\..\baserule\Rule_LLV.pas',
  Rule_HHV in '..\..\baserule\Rule_HHV.pas',
  Rule_EMA in '..\..\baserule\Rule_EMA.pas',
  Rule_BDZX in '..\..\baserule\Rule_BDZX.pas',
  StockDayDataAccess in '..\..\data_stock\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\data_stock\StockDayData_Load.pas',
  StockDetailDataAccess in '..\..\data_stock\StockDetailDataAccess.pas',
  StockDetailData_Load in '..\..\data_stock\StockDetailData_Load.pas',
  FrameDataViewer in 'FrameDataViewer.pas' {fmeDataViewer},
  FrameDataCompareViewer in 'FrameDataCompareViewer.pas' {fmeDataCompareViewer},
  FormDataHostViewer in 'FormDataHostViewer.pas' {frmDataViewer},
  FrameDayChartViewer in 'FrameDayChartViewer.pas' {fmeDayChartViewer},
  UIDealItemNode in 'UIDealItemNode.pas';

{$R *.res}

type
  TAIStockDataViewerApp = class(TBaseStockApp)
  protected
    fMainForm: TfrmBase;              
  public     
    constructor Create(AppClassId: AnsiString); override;
    procedure Run; override;
    function Initialize: Boolean; override;
  end;

{ TStockDay163App }

constructor TAIStockDataViewerApp.Create(AppClassId: AnsiString);
begin
  inherited;
end;

function TAIStockDataViewerApp.Initialize: Boolean;
begin
  Application.Initialize;
  InitializeDBStockItem;
  Result := true;
end;
              
procedure TAIStockDataViewerApp.Run;
begin
  //FormDetailDataViewer.CreateMainForm(fMainForm);
  FormDataHostViewer.CreateMainForm(fMainForm);     
  fMainForm.Initialize(Self);
  Application.Run;
end;

var
  GlobalApp: TAIStockDataViewerApp;
begin
  GlobalApp := TAIStockDataViewerApp.Create('');
  try
    if GlobalApp.Initialize then
      GlobalApp.Run;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
