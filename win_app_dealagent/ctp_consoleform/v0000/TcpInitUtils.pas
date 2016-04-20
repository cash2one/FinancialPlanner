unit TcpInitUtils;

interface

  function ParseAddress(AddressDesc: string): string;   
  procedure SaveIniAddress(AddressDesc, Address, AIniSection: string);
  procedure SaveIniAccount(ABrokeId, Account: string);
  
implementation

uses
  IniFiles, SysUtils;
  
function ParseAddress(AddressDesc: string): string;
var
  tmpPos1, tmpPos2: integer;
begin
  Result := AddressDesc;
  tmpPos1 := pos('(', AddressDesc);
  tmpPos2 := pos(')', AddressDesc);
  if (tmpPos1 > 0) and (tmpPos2 > 0) then
  begin
    if tmpPos1 = 1 then
    begin
      Result := Copy(AddressDesc, tmpPos2 + 1, maxint);
    end else
    begin
      Result := Copy(AddressDesc, 1, tmpPos1 - 1);
    end;
  end;
end;

procedure SaveIniAddress(AddressDesc, Address, AIniSection: string);
var
  tmpIni: TIniFile;
  i: integer;
  tmpCount: integer;
  tmpIsFind: Boolean;
  tmpAddr: string;
begin
  if Trim(Address) = '' then
    exit;
  tmpIsFind := false;
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpCount := 0;
    for i := 1 to 100 - 1 do
    begin
      tmpAddr := tmpIni.ReadString(AIniSection + IntToStr(i), 'addr', '');
      if tmpAddr = '' then
        Break;
      Inc(tmpCount);
      if SameText(tmpAddr, Address) then
        tmpIsFind := true;
    end;
    if not tmpIsFind then
    begin
      Inc(tmpCount);
      tmpIni.WriteString(AIniSection + IntToStr(tmpCount), 'addr', Address);
      tmpIni.WriteString(AIniSection + IntToStr(tmpCount), 'desc', AddressDesc);
    end;
    tmpIni.WriteString(AIniSection, 'addr', Address);
    tmpIni.WriteString(AIniSection, 'desc', AddressDesc);
  finally
    tmpIni.Free;
  end;
end;

procedure SaveIniAccount(ABrokeId, Account: string);
var
  tmpIni: TIniFile;
  tmpAnsi: AnsiString;
  tmpBrokerId: AnsiString;
  tmpUserId: AnsiString;
  tmpIsFind: Boolean;
  i: integer;
  tmpCounter: Integer;
begin         
  tmpBrokerId := Trim(ABrokeId);
  tmpUserId := Trim(Account);
  if tmpBrokerId = '' then
    exit;
  if tmpUserId = '' then
    exit;
  tmpIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    tmpCounter := 0;
    tmpIsFind := False;
    for i := 1 to 100 do
    begin
      tmpAnsi := tmpIni.ReadString('acc' + IntToStr(i), 'brokerid', '');
      if tmpAnsi = '' then
        Break;
      Inc(tmpCounter);
      if SameText(tmpAnsi, tmpBrokerId) then
      begin                             
        tmpAnsi := tmpIni.ReadString('acc' + IntToStr(i), 'userid', '');
        if SameText(tmpAnsi, tmpUserId) then
        begin
          tmpIsFind := true;
        end;
      end;
    end;
    if not tmpIsFind then
    begin
      Inc(tmpCounter);
      tmpIni.WriteString('acc' + IntToStr(tmpCounter), 'brokerid', tmpBrokerId);
      tmpIni.WriteString('acc' + IntToStr(tmpCounter), 'userid',tmpUserId);
      //tmpIni.WriteString('acc' + IntToStr(tmpCounter), 'pwd', Trim(edtPassword.Text));
    end;
    tmpIni.WriteString('acc', 'brokerid', tmpBrokerId);
    tmpIni.WriteString('acc', 'userid', tmpUserId);
    //tmpIni.WriteString('acc', 'pwd', Trim(edtPassword.Text));
  finally
    tmpIni.Free;
  end;
end;

end.
