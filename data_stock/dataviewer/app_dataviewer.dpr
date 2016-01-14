program App_DataViewer;

{ % File '..\StockDataGet_Day\StockDay_163.bdsproj'}

uses
  Windows,
  Forms,
  QuickList_int in '..\..\..\devwintech\comps\list\QuickList_int.pas',
  QuickList_double in '..\..\..\devwintech\comps\list\QuickList_double.pas',
  QuickSortList in '..\..\..\devwintech\comps\list\QuickSortList.pas',
  BaseDataSet in '..\..\..\devwintech\v0000\win_base\BaseDataSet.pas',
  BaseApp in '..\..\..\devwintech\v0000\win_base\BaseApp.pas',
  BasePath in '..\..\..\devwintech\v0000\win_base\BasePath.pas',
  BaseWinFile in '..\..\..\devwintech\v0000\win_base\BaseWinFile.pas',
  BaseFile in '..\..\..\devwintech\v0000\win_base\BaseFile.pas',
  BaseForm in '..\..\..\devwintech\v0000\win_base\BaseForm.pas' {frmBase},
  Define_String in '..\..\..\devwintech\v0000\win_basedefine\Define_String.pas',
  define_price in '..\..\basedefine\define_price.pas',
  define_datasrc in '..\..\basedefine\define_datasrc.pas',
  Define_Store_File in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_File.pas',
  Define_Store_Header in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_Header.pas',
  Define_RunTime_StockQuote in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_RunTime_StockQuote.pas',
  Define_Store_StockQuote in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_StockQuote.pas',
  DefineWinMsg in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\DefineBase\DefineWinMsg.pas',
  BaseWinApp in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseApp\BaseWinApp.pas',
  StockAppPath in '..\..\base\StockAppPath.pas',
  BaseStockApp in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockApp\BaseStockApp.pas',
  StockDayDataAccess in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockDataAccess\StockDayDataAccess.pas',
  StockDayData_Load in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockDataAccess\StockDayData_Load.pas',
  StockDetailDataAccess in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockDataAccess\StockDetailDataAccess.pas',
  StockDetailData_Load in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockDataAccess\StockDetailData_Load.pas',
  BaseRule in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\BaseRule.pas',
  Rule_STD in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_STD.pas',
  Rule_Boll in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_Boll.pas',
  Rule_MA in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_MA.pas',
  Rule_CYHT in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_CYHT.pas',
  Rule_LLV in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_LLV.pas',
  Rule_HHV in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_HHV.pas',
  Rule_EMA in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_EMA.pas',
  Rule_BDZX in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Rule\Rule_BDZX.pas',
  FrameDataViewer in 'FrameDataViewer.pas' {fmeDataViewer},
  FormDataHostViewer in 'FormDataHostViewer.pas' {frmDataViewer},
  FrameDayChartViewer in 'FrameDayChartViewer.pas' {fmeDayChartViewer},
  UIStockData in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\App_DataViewer\UIStockData.pas',
  define_dealitem in '..\..\basedefine\define_dealitem.pas',
  db_dealitem in '..\..\dealitem\db_dealitem.pas',
  define_dealmarket in '..\..\basedefine\define_dealmarket.pas',
  define_dealstore_header in '..\..\basedefine\define_dealstore_header.pas',
  db_dealitem_load in '..\..\dealitem\db_dealitem_load.pas',
  define_dealstore_file in '..\..\basedefine\define_dealstore_file.pas';

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
