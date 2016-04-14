unit zsLoginVerifyCode;

interface

uses
  Windows, Graphics, Classes, Sysutils;
                         
  function GetVerifyCode(AVerifyCodeBitmap: Graphics.TBitmap): string;

implementation

function IsSameColor4(AColor1, AColor2: TRGBQuad): Boolean;
begin
  Result :=
    (AColor1.rgbBlue = AColor2.rgbBlue) and
    (AColor1.rgbGreen = AColor2.rgbGreen) and
    (AColor1.rgbRed = AColor2.rgbRed);
end;

function GetVerifyCode(AVerifyCodeBitmap: Graphics.TBitmap): string;
type
  PRGBBytes_Quad = ^TRGBBytes_Quad;
  TRGBBytes_Quad = packed record
    Data: array[0..128 - 1] of TRGBQuad;
  end;
                 
  TVerifyNum = record
    Num: integer;
    X: integer;
  end;
  
var
  tmpNumDic: array[0..9] of Graphics.TBitmap;

  function IsNum(AVerifyBmp: Graphics.TBitmap; ARow, ACol: integer; ANum: integer; ABgColor: TRGBQuad): Boolean;
  var
    i, j: integer;      
    tmpNumBytes: PRGBBytes_Quad;
    tmpVerifyBytes: PRGBBytes_Quad;
    tmpFindPoint: Boolean;
    tmpFirstPointX: integer;
    //tmpFirstPointY: integer;
  begin
    Result := false;
    tmpFirstPointX := 0;
    if nil <> tmpNumDic[ANum] then
    begin
      if pf32bit = tmpNumDic[ANum].PixelFormat then
      begin
        if AVerifyBmp.Height = tmpNumDic[ANum].Height  then
        begin
          tmpFindPoint := false; 
          Result := true;
          for i := 0 to tmpNumDic[ANum].Height - 1 do
          begin
            if not Result then
              Break; 
            tmpNumBytes := tmpNumDic[ANum].ScanLine[i];
            tmpVerifyBytes := AVerifyBmp.ScanLine[i];
            for j := 0 to tmpNumDic[ANum].Width - 1 do
            begin            
              if not Result then
                Break; 
              if (0 = tmpNumBytes.Data[j].rgbBlue) and
                (0 = tmpNumBytes.Data[j].rgbGreen) and
                (0 = tmpNumBytes.Data[j].rgbRed) then
              begin                                  
                if not tmpFindPoint then
                begin
                  tmpFindPoint := true;
                  tmpFirstPointX := j;
                  //tmpFirstPointY := i;
                end else
                begin
                  if IsSameColor4(tmpVerifyBytes.Data[ACol + j - tmpFirstPointX], ABgColor) then
                  begin     
                    Result := false;
                  end else
                  begin
                
                  end;
                end;
              end else
              begin                          
                if tmpFindPoint then
                begin
                  if not IsSameColor4(tmpVerifyBytes.Data[ACol + j - tmpFirstPointX], ABgColor) then
                  begin
                    Result := false;
                  end;
                end;
              end;
            end;
          end;
          if Result then
          begin
            for i := 0 to tmpNumDic[ANum].Height - 1 do
            begin        
              tmpNumBytes := tmpNumDic[ANum].ScanLine[i];
              tmpVerifyBytes := AVerifyBmp.ScanLine[i];
              for j := 0 to tmpNumDic[ANum].Width - 1 do
              begin
                if (0 = tmpNumBytes.Data[j].rgbBlue) and
                  (0 = tmpNumBytes.Data[j].rgbGreen) and
                  (0 = tmpNumBytes.Data[j].rgbRed) then
                begin
                  tmpVerifyBytes.Data[ACol + j - tmpFirstPointX].rgbReserved := 255;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
 
var
  i, j: integer;
  tmpFileUrl: string;
  tmpVerifyBytes: PRGBBytes_Quad;
  tmpLoadDic: Boolean;
  tmpNum: integer;
  VerifyNumIndex: integer;          
  tmpBgColor: TRGBQuad;    
  tmpInit: Boolean;
  num: integer;
  VerifyNums: array[0..10] of TVerifyNum;
  tmpStrs: TStringList;
begin
  Result := '';
  tmpLoadDic := true;
  FillChar(tmpNumDic, SizeOf(tmpNumDic), 0);
  for i := low(tmpNumDic) to high(tmpNumDic) do
  begin                   
    tmpFileUrl := ExtractFilePath(ParamStr(0)) + 'num' + IntToStr(i) + '.bmp';
    if not FileExists(tmpFileUrl) then
      tmpFileUrl := ExtractFilePath(ParamStr(0)) + 'res\' + 'num' + IntToStr(i) + '.bmp';
    if FileExists(tmpFileUrl) then
    begin
      tmpNumDic[i] := Graphics.TBitmap.Create;
      tmpNumDic[i].LoadFromFile(tmpFileUrl);
    end else
    begin
      tmpLoadDic := false;
    end;
  end;
  if not tmpLoadDic then
    exit;
    
  for i := 0 to AVerifyCodeBitmap.Height - 1 do
  begin
    tmpVerifyBytes := AVerifyCodeBitmap.ScanLine[i];
    for j := 0 to AVerifyCodeBitmap.Width - 1 do
    begin
      tmpVerifyBytes.Data[j].rgbReserved := 0;
    end;
  end;  
  for i := Low(VerifyNums) to High(VerifyNums) do
  begin
    VerifyNums[i].Num := -1;
  end;   
  VerifyNumIndex := 0;
  tmpInit := false;
  for i := 0 to AVerifyCodeBitmap.Height - 1 do
  begin
    tmpVerifyBytes := AVerifyCodeBitmap.ScanLine[i];
    for j := 0 to AVerifyCodeBitmap.Width - 1 do
    begin
      if (0 = i) then
      begin
        if (1 = j) then
        begin
          tmpBgColor := tmpVerifyBytes.Data[j];
          tmpInit := True;
        end;
      end;
      if tmpInit then
      begin
        if 0 = tmpVerifyBytes.Data[j].rgbReserved then
        begin
          if not IsSameColor4(tmpBgColor, tmpVerifyBytes.Data[j]) then
          begin
            tmpNum := -1;
            for num := 0 to 9 do
            begin
              if -1 = tmpNum then
              begin
                if IsNum(AVerifyCodeBitmap, i, j, num, tmpBgColor) then
                begin
                  tmpNum := num;
                  VerifyNums[VerifyNumIndex].Num := tmpNum;
                  VerifyNums[VerifyNumIndex].X := j;
                  Inc(VerifyNumIndex);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;  
  tmpStrs := TStringList.Create;
  try
    for i := Low(VerifyNums) to High(VerifyNums) do
    begin
      if -1 <> VerifyNums[i].Num then
      begin
        tmpStrs.AddObject(IntToStr(VerifyNums[i].X + 100), TObject(i));
      end;
    end;
    tmpStrs.Sort;
    for I := 0 to tmpStrs.Count - 1 do
    begin
      Result := Result + IntToStr(VerifyNums[Integer(tmpStrs.Objects[i])].Num);
    end;
  finally
    tmpStrs.Free;
  end;
end;

end.
