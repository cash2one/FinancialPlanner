unit SDTdxForm;

interface

uses
  Windows, Forms, BaseForm, Classes, Controls, StdCtrls, win.diskfile;

type
  TfrmSDTdx = class(TfrmBase)
    btnExport: TButton;
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

type
  TTdxMinuteDataHead = packed record  // 26 字节
    // 570 的话表示9:30分(570/60=9.5)
    DealTime: Word;        // 2
    PriceNow: Integer;     // 4
    PriceAverage: Integer; // 4 均价
    Volume: Word; // 2 个或 4 个字节
  end;

  TTdxMinuteDataSection = packed record
    DataHead: TTdxMinuteDataHead;
    DataReserve: array[0..26 - 1 - SizeOf(TTdxMinuteDataHead)] of Byte;
  end;

  TTdxDataHead = packed record

  end;
  
  PTdxData = ^TTdxData;
  TTdxData = packed record
    MinuteData: array[0..65565] of TTdxMinuteDataSection;
  end;

(*//
    通达信日线和分时图数据格式
    http://blog.csdn.net/coollzt/article/details/7245298
    http://blog.csdn.net/coollzt/article/details/7245312
    http://blog.csdn.net/coollzt/article/details/7245304

    原来 招商证券 通达信 可以直接导出 那就直接导出好了
//*)

procedure TfrmSDTdx.btnExportClick(Sender: TObject);
var
  tmpFileUrl: string;
  tmpWinFile: PWinFile;
  tmpFileData: PTdxData;
begin
  inherited;
  tmpFileUrl := 'E:\StockApp\sdata\sh999999.lc5';  
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
//
end;

end.
