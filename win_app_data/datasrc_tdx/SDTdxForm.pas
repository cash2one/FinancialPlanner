unit SDTdxForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, Sysutils, StdCtrls;
  win.diskfile;

type
  TfrmSDTdx = class(TfrmBase)
    btnImport: TButton;
    procedure btnImportClick(Sender: TObject);
  protected
    procedure ImportDayData;
    procedure ImportTxtData; overload; 
    procedure ImportTxtData(AFileUrl: string); overload;
    procedure ImportLcData;
  public
  end;

implementation

{$R *.dfm}

uses
  define_datasrc,
  define_price,
  StockMinuteDataAccess,
  StockMinuteData_Save;
  
type
  TTdxMinuteDataHead = packed record  // 26 �ֽ�
    // 570 �Ļ���ʾ9:30��(570/60=9.5)
    DealTime: Word;        // 2
    PriceNow: Integer;     // 4
    PriceAverage: Integer; // 4 ����
    Volume: Word; // 2 ���� 4 ���ֽ�
  end;

  TTdxMinuteDataSection = packed record
    DataHead: TTdxMinuteDataHead;
    DataReserve: array[0..26 - 1 - SizeOf(TTdxMinuteDataHead)] of Byte;
  end;

  TTdxDayHead = packed record
    dDate: DWORD;            //��������
    fOpen: DWORD;            //���̼�(Ԫ)
    fHigh: DWORD;            //��߼�(Ԫ)
    fLow: DWORD;             //��ͼ�(Ԫ)
    fClose: DWORD;           //���̼�(Ԫ)
    fAmount: DWORD;          //�ɽ���(Ԫ)
    dVol: DWORD ;             //�ɽ���(��)
  end;

  TTdxDayDataSection = packed record
    DataHead: TTdxDayHead;
    Reservation: DWORD; //����δ��
  end;
  
  TTdxDataHead = packed record

  end;
  
  PTdxData = ^TTdxData;
  TTdxData = packed record
    MinuteData: array[0..65565] of TTdxMinuteDataSection;
  end;

(*//
    ͨ�������ߺͷ�ʱͼ���ݸ�ʽ
    http://blog.csdn.net/coollzt/article/details/7245298
    http://blog.csdn.net/coollzt/article/details/7245312
    http://blog.csdn.net/coollzt/article/details/7245304

    http://www.tdx.com.cn/list_66_68.html
    ԭ�� ����֤ȯ ͨ���� ����ֱ�ӵ��� �Ǿ�ֱ�ӵ�������
//*)
                                   
procedure TfrmSDTdx.ImportLcData;   
var
  tmpFileUrl: string;
begin
  tmpFileUrl := 'E:\StockApp\sdata\sh999999.lc5';
end;

procedure TfrmSDTdx.ImportDayData;  
var
  tmpFileUrl: string;     
  //tmpWinFile: PWinFile;
  tmpFileData: PTdxData;
begin                 
  // Vipdoc\sh\lday\*.day
  (*
  tmpFileUrl := 'E:\StockApp\sdata\sh600000.day';  
  tmpWinFile := CheckOutWinFile;
  try
    if WinFileOpen(tmpWinFile, tmpFileUrl, false) then
    begin
      if WinFileOpenMap(tmpWinFile) then
      begin
        tmpFileData := tmpWinFile.FileMapRootView;
        if nil <> tmpFileData then
        begin
        end;
      end;
    end;
  finally
    CheckInWinFile(tmpWinFile);
  end;
  //*)
end;

type
  PDateTimeParseRecord = ^TDateTimeParseRecord;
  TDateTimeParseRecord = record
    Year: Word;
    Month: Word;
    Day: Word;
    Hour: Word;
    Minute: Word;
    Second: Word;
    MSecond: Word;
    Date: TDate;
    Time: TTime;
  end;

procedure ParseDateTime(ADateTimeParse: PDateTimeParseRecord; ADateTimeString: AnsiString);
var
  i: integer;
  tmpStrDate: AnsiString;
  tmpStrTime: AnsiString;
  tmpStrHead: AnsiString;
  tmpStrEnd: AnsiString;
  tmpFormat: TFormatSettings;
begin
  // 2014/06/12-10:30
  i := Pos('-', ADateTimeString);
  if 0 < i then
  begin
    tmpStrDate := Copy(ADateTimeString, 1, i - 1);
    tmpStrTime := Copy(ADateTimeString, i + 1, maxint);
    FillChar(tmpFormat, SizeOf(tmpFormat), 0);
    tmpFormat.DateSeparator := '/';
    tmpFormat.TimeSeparator := ':'; 
    tmpFormat.ShortDateFormat := 'yyyy/mm/dd';
    tmpFormat.LongDateFormat := 'yyyy/mm/dd';
    tmpFormat.ShortTimeFormat := 'hh:nn:ss';
    tmpFormat.LongTimeFormat := 'hh:nn:ss';
    ADateTimeParse.Date := StrToDateDef(tmpStrDate, 0, tmpFormat);
    ADateTimeParse.Time := StrToTimeDef(tmpStrTime, 0, tmpFormat);
    if 0 < ADateTimeParse.Date then
      DecodeDate(ADateTimeParse.Date, ADateTimeParse.Year, ADateTimeParse.Month, ADateTimeParse.Day);
    if 0 < ADateTimeParse.Time then
      DecodeTime(ADateTimeParse.Time, ADateTimeParse.Hour, ADateTimeParse.Minute, ADateTimeParse.Second, ADateTimeParse.MSecond);
  end;
end;

procedure TfrmSDTdx.ImportTxtData();
var        
  tmpFileUrl: string;
begin
  tmpFileUrl := 'E:\StockApp\sdata\999999.txt';
end;

procedure TfrmSDTdx.ImportTxtData(AFileUrl: string);
type
  TColumns = (colTime, colOpen, colHigh, colLow, colClose, colVolume);
  TColumnsHeader = array[TColumns] of string;
  TColumnsIndex = array[TColumns] of Integer;  
const
  ColumnsHeader: TColumnsHeader =
    ('ʱ��','����','���','���','����','�ɽ���');   
var
  tmpFileName: string;
  tmpRowData: string;
  tmpTime: string;
  tmpFileContent: TStringList;    
  tmpRowDatas: TStringList;
  tmpColumnIndex: TColumnsIndex;
  tmpIsReadHead: Boolean;
  iCol: TColumns;
  i, j: integer;
  tmpDateTimeParse: TDateTimeParseRecord;
  tmpMinuteDataAccess: TStockMinuteDataAccess;
begin                 
  if not FileExists(AFileUrl) then
    exit;
  tmpFileName := ExtractFileName(AFileUrl);
    
  tmpMinuteDataAccess := nil;
  tmpFileContent := TStringList.Create;
  tmpRowDatas := TStringList.Create;
  try
    tmpFileContent.LoadFromFile(AFileUrl);
    tmpIsReadHead := false;
    for iCol := Low(TColumns) to High(TColumns) do
      tmpColumnIndex[iCol] := -1;
    for i := 0 to tmpFileContent.Count - 1 do
    begin
      tmpRowData := Trim(tmpFileContent[i]);
      if '' <> tmpRowData then
      begin
        // ��ָ֤�� (999999)
        // 'ʱ��'#9'    ����'#9'    ���'#9'    ���'#9'    ����'#9'         �ɽ���'#9'BOLL-M.BOLL  '#9'BOLL-M.UB    '#9'BOLL-M.LB    '#9'  VOL.VOLUME'#9'  VOL.MAVOL1'#9'  VOL.MAVOL2'#9' CYHT.����  '#9' CYHT.SK    '#9' CYHT.SD    '#9' CYHT.����  '#9' CYHT.ǿ���ֽ�'#9' CYHT.����  '#9' CYHT.���  '#9' BDZX.AK    '#9' BDZX.AD1   '#9' BDZX.AJ    '#9' BDZX.aa    '#9' BDZX.bb    '#9' BDZX.cc    '#9' BDZX.���  '#9' BDZX.����'
        tmpRowDatas.Text := StringReplace(tmpRowData, #9, #13#10, [rfReplaceAll]);
        if not tmpIsReadHead then
        begin                    
          for iCol := Low(TColumns) to High(TColumns) do
          begin
            for j := 0 to tmpRowDatas.Count - 1 do
            begin
              if SameText(ColumnsHeader[iCol], Trim(tmpRowDatas[j])) then
              begin
                tmpIsReadHead := True;
                tmpColumnIndex[iCol] := j; 
              end;
            end;
          end;
        end else
        begin
          FillChar(tmpDateTimeParse, SizeOf(tmpDateTimeParse), 0);
          tmpTime := '';
          if 0 <= tmpColumnIndex[colTime] then
          begin
            tmpTime := tmpRowDatas[tmpColumnIndex[colTime]];
            // 2014/06/12-10:30
          end;
          if '' <> tmpTime then
          begin
            ParseDateTime(@tmpDateTimeParse, tmpTime);
          end;
          if (0 < tmpDateTimeParse.Date) and (0 < tmpDateTimeParse.Time) then
          begin
            if nil = tmpMinuteDataAccess then
            begin
              tmpMinuteDataAccess := TStockMinuteDataAccess.Create(nil, DataSrc_TongDaXin, weightNone);
            end;  
            //tmpMinuteDataAccess.CheckOutRecord(ADate: Word): PRT_Quote_M1_Day;
          end;
        end;
      end;
    end;
  //except
  finally
    tmpRowDatas.Clear;
    tmpRowDatas.Free;
    tmpFileContent.Free;
  end;
end;

procedure TfrmSDTdx.btnImportClick(Sender: TObject);
begin
  inherited;
  //tmpFileUrl := 'E:\StockApp\sdata\20160617\sh160617.mhq';
  //tmpFileUrl := 'E:\StockApp\sdata\20160617\sh160617.ref';
  //tmpFileUrl := 'E:\StockApp\sdata\20160617\20160617.tic';
  ImportTxtData;
end;

end.
