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
  Define_DataSrc in '..\..\basedefine\define_datasrc.pas',
  Define_Store_File in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_File.pas',
  Define_Store_Header in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_Header.pas',
  Define_StockItem in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_StockItem.pas',
  Define_DealMarket in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_DealMarket.pas',
  Define_RunTime_StockQuote in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_RunTime_StockQuote.pas',
  Define_Store_StockQuote in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\Define\Define_Store_StockQuote.pas',
  DefineWinMsg in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\DefineBase\DefineWinMsg.pas',
  BaseWinApp in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\BaseApp\BaseWinApp.pas',
  DB_StockItem in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockItem\DB_StockItem.pas',
  DB_StockItem_Load in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockItem\DB_StockItem_Load.pas',
  StockAppPath in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\StockApp\StockAppPath.pas',
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
  UIStockData in '..\..\..\litwrd_git\AppPrestudy\Windows\DealData\v03\App_DataViewer\UIStockData.pas';

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
