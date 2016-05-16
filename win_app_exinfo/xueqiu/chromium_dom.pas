unit chromium_dom;

interface

uses
  sysutils,
  cef_type, cef_api, cef_apiobj;

type            
  PDomTraverseParam = ^TDomTraverseParam;
  TDomTraverseParam = record
    Level       : integer;
    LevelStep1  : integer;
    LevelStep2  : integer;
    LevelStep3  : integer;    
    IsDoLog     : Boolean;
    ExParam     : Pointer;
    ExObject    : TObject;
  end;

  TCefDomVisitProc = procedure (self: PCefDomVisitor; document: PCefDomDocument); stdcall;
  TTraverseDomNode_Proc = procedure (ANode: PCefDomNode; ADomTraverseParam: PDomTraverseParam);

  { ���� html dom �ڵ� }
  procedure TestTraverseChromiumDom(AClientObject: PCefClientObject; ACefDomVisitProc: TCefDomVisitProc);

var
  ExTraverseDomNode_Proc: TTraverseDomNode_Proc = nil;

type
  TInfoType_Xueqiu = (infxq_Undefine,
    infxq_EPS,  // earnings per share
    infxq_PE,   //  price earning ratio 
    infxq_GeneralCapital,
    infxq_NAPS, // ÿ�ɾ��ʲ� net asset per share
    infxq_PB,    // �о���
    infxq_Flow,
    infxq_DPS,
    infxq_PS
    );

const
  InfoKeyWord_Xueqiu: array[TInfoType_Xueqiu] of String = ('',
    'ÿ������',
    '��ӯ��LYR/TTM', // ��ӯ��LYR ��̬��ӯ�� ��ӯ��TTM ��̬��ӯ��
    '�ܹɱ�',   // capitalization
    'ÿ�ɾ��ʲ�',
    '�о���TTM',       // ÿ�ɹɼ���ÿ�ɾ��ʲ��ı���
    '��ͨ�ɱ�',  // capital stock in circulation  / Flow of equity
    'ÿ�ɹ�Ϣ',  // Dividend Per Share
    '������TTM'  // ������( Price-to-sales,PS), PS = ����ֵ ������Ӫҵ��������� PS=�ɼ� ����ÿ�����۶�
    );

implementation

uses
  UtilsLog,
  cef_apilib,
  cef_apilib_domvisitor;
  
procedure TraverseDomNode_Proc(ANode: PCefDomNode; ADomTraverseParam: PDomTraverseParam);
var
  tmpName: ustring;
  tmpValue: ustring;
  tmpAttrib: ustring;
  tmpStr: ustring;
  tmpCefStr: TCefString;
  tmpChild: PCefDomNode;
  tmpIsDoLog: Boolean;
  tmpLevelStep1: Integer;
  tmpLevelStep2: Integer;
  tmpLevelStep3: Integer;    
begin
  { ����ǰ�ڵ� }
  tmpIsDoLog := ADomTraverseParam.IsDoLog;
  tmpLevelStep1 := ADomTraverseParam.LevelStep1;
  tmpLevelStep2 := ADomTraverseParam.LevelStep2;
  tmpLevelStep3 := ADomTraverseParam.LevelStep3;
  try
    tmpName := CefStringFreeAndGet(ANode.get_name(ANode));
    if SameText(tmpName, 'SCRIPT') then
      exit;              
    if SameText(tmpName, 'span') then
      exit;
    tmpValue := '';
    if SameText(tmpName, '#text') then
    begin             
      tmpValue := CefStringFreeAndGet(ANode.get_value(ANode));
      exit;
    end;
    if SameText(tmpName, 'TD') then
    begin
      tmpValue := CefStringFreeAndGet(ANode.get_element_inner_text(ANode));    
    end;
    if SameText(tmpName, 'TABLE') then
    begin
      tmpCefStr := CefString('class');
      tmpAttrib := CefStringFreeAndGet(ANode.get_element_attribute(ANode, @tmpCefStr));
      if SameText('topTable', tmpAttrib) then
      begin          
        ADomTraverseParam.IsDoLog := True;//topTable
        ADomTraverseParam.LevelStep1 := 1;
      end;
    end;
    if ADomTraverseParam.IsDoLog then
    begin
      Log('TraverseDomNode', 'Level' + IntToStr(ADomTraverseParam.Level) + ':' + tmpName + ':' + tmpValue);
    end;
    tmpCefStr := CefString('href');
    tmpAttrib := CefStringFreeAndGet(ANode.get_element_attribute(ANode, @tmpCefStr)); 
    tmpStr := CefStringFreeAndGet(ANode.get_element_inner_text(ANode));

    { �����ӽڵ� }
    ADomTraverseParam.Level := ADomTraverseParam.Level + 1;
    tmpChild := ANode.get_first_child(ANode);
    while tmpChild <> nil do
    begin
      TraverseDomNode_Proc(tmpChild, ADomTraverseParam);
      tmpChild := tmpChild.get_next_sibling(tmpChild);
    end;
    ADomTraverseParam.Level := ADomTraverseParam.Level - 1;
  finally
    ADomTraverseParam.IsDoLog := tmpIsDoLog;
    ADomTraverseParam.LevelStep1 := tmpLevelStep1;
    ADomTraverseParam.LevelStep2 := tmpLevelStep2;
    ADomTraverseParam.LevelStep3 := tmpLevelStep3;
  end;
end;

procedure CefDomVisit_Proc(self: PCefDomVisitor; document: PCefDomDocument); stdcall;
var
  tmpNode: PCefDomNode;
  tmpDomTraverseParam: TDomTraverseParam;
begin           
  if document <> nil then
  begin
    tmpNode := document.get_document(document);
    if tmpNode <> nil then
    begin
      FillChar(tmpDomTraverseParam, SizeOf(tmpDomTraverseParam), 0);
      if Assigned(ExTraverseDomNode_Proc) then
      begin
        ExTraverseDomNode_Proc(tmpNode, @tmpDomTraverseParam);
      end else
      begin
        TraverseDomNode_Proc(tmpNode, @tmpDomTraverseParam);
      end;
    end;
  end;
end;

procedure TestTraverseChromiumDom(AClientObject: PCefClientObject; ACefDomVisitProc: TCefDomVisitProc);
var
  tmpMainFrame: PCefFrame;
begin
  FillChar(AClientObject.CefDomVisitor, SizeOf(AClientObject.CefDomVisitor), 0);
  AClientObject.CefDomVisitor.CefClientObj := AClientObject;
  
  tmpMainFrame := AClientObject.CefBrowser.get_main_frame(AClientObject.CefBrowser);
  if tmpMainFrame <> nil then
  begin
    if Assigned(ACefDomVisitProc) then
    begin
      InitCefDomVisitor(@AClientObject.CefDomVisitor, AClientObject, ACefDomVisitProc);
    end else
    begin
      InitCefDomVisitor(@AClientObject.CefDomVisitor, AClientObject, CefDomVisit_Proc);
    end;
    tmpMainFrame.visit_dom(tmpMainFrame, @AClientObject.CefDomVisitor.CefDomVisitor);
  end;
end;

end.
