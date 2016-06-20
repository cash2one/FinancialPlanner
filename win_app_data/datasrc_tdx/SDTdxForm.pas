unit SDTdxForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, Sysutils, StdCtrls,
  win.diskfile;

type
  TfrmSDTdx = class(TfrmBase)
    btnImport: TButton;
    procedure btnImportClick(Sender: TObject);
  protected
    procedure ImportDayData;
    procedure ImportTxtData;   
    procedure ImportLcData;
  public
  end;

implementation

{$R *.dfm}

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
  tmpWinFile: PWinFile;
  tmpFileData: PTdxData;
begin                 
  // Vipdoc\sh\lday\*.day
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
end;

procedure TfrmSDTdx.ImportTxtData;  
type
  TColumns = (colTime, colOpen, colHigh, colLow, colClose, colVolume);
  TColumnsHeader = array[TColumns] of string;
  TColumnsIndex = array[TColumns] of Integer;  
const
  ColumnsHeader: TColumnsHeader =
    ('ʱ��','����','���','���','����','�ɽ���');   
var
  tmpFileUrl: string;
  tmpRowData: string;
  tmpTime: string;
  tmpFileContent: TStringList;    
  tmpRowDatas: TStringList;
  tmpColumnIndex: TColumnsIndex;
  tmpIsReadHead: Boolean;
  iCol: TColumns;
  i, j: integer;
begin                 
  tmpFileUrl := 'E:\StockApp\sdata\999999.txt';
  if FileExists(tmpFileUrl) then
  begin
    tmpFileContent := TStringList.Create;
    tmpRowDatas := TStringList.Create;
    try
      tmpFileContent.LoadFromFile(tmpFileUrl);
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
            tmpTime := '';
            if 0 <= tmpColumnIndex[colTime] then
            begin
              tmpTime := tmpRowDatas[tmpColumnIndex[colTime]];
              // 2014/06/12-10:30
            end;
            if '' <> tmpTime then
            begin

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
