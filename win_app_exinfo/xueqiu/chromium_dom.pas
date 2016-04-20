unit chromium_dom;

interface

uses
  sysutils,
  cef_type, cef_api, cef_apiobj;

type  
  TCefDomVisitProc = procedure (self: PCefDomVisitor; document: PCefDomDocument); stdcall;

  { 遍历 html dom 节点 }
  procedure TestTraverseChromiumDom(AClientObject: PCefClientObject; ACefDomVisitProc: TCefDomVisitProc);

implementation

uses
  UtilsLog,
  cef_apilib,
  cef_apilib_domvisitor;
  
type
  PDomTraverseParam = ^TDomTraverseParam;
  TDomTraverseParam = record
    Level: integer;
    IsDoLog: Boolean;
  end;

procedure TraverseDomNode_Proc(ANode: PCefDomNode; ADomTraverseParam: PDomTraverseParam);
var
  tmpName: ustring;
  tmpValue: ustring;
  tmpAttrib: ustring;
  tmpStr: ustring;
  tmpCefStr: TCefString;
  tmpChild: PCefDomNode;
  tmpIsDoLog: Boolean; 
begin
  { 处理当前节点 }
  tmpIsDoLog := ADomTraverseParam.IsDoLog;
  try
    tmpName := CefStringFreeAndGet(ANode.get_name(ANode));
    if SameText(tmpName, 'SCRIPT') then
      exit;              
    tmpValue := '';
    if SameText(tmpName, '#text') then
    begin             
      tmpValue := CefStringFreeAndGet(ANode.get_value(ANode));
    end;
    if SameText(tmpName, 'TABLE') then
    begin
      tmpCefStr := CefString('class');
      tmpAttrib := CefStringFreeAndGet(ANode.get_element_attribute(ANode, @tmpCefStr));
      if SameText('topTable', tmpAttrib) then
      begin          
        ADomTraverseParam.IsDoLog := True;//topTable
      end;
    end;
    if ADomTraverseParam.IsDoLog then
    begin
      Log('TraverseDomNode', 'Level' + IntToStr(ADomTraverseParam.Level) + ':' + tmpName + ':' + tmpValue);
    end;
    tmpCefStr := CefString('href');
    tmpAttrib := CefStringFreeAndGet(ANode.get_element_attribute(ANode, @tmpCefStr)); 
    tmpStr := CefStringFreeAndGet(ANode.get_element_inner_text(ANode));

    { 处理子节点 }
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
      TraverseDomNode_Proc(tmpNode, @tmpDomTraverseParam);
    end;
  end;
end;

var
  tmpCefDomVisitor: TCefIntfDomVisitor;
  
procedure TestTraverseChromiumDom(AClientObject: PCefClientObject; ACefDomVisitProc: TCefDomVisitProc);
var
  tmpMainFrame: PCefFrame;
begin
  FillChar(tmpCefDomVisitor, SizeOf(tmpCefDomVisitor), 0);
  
  tmpMainFrame := AClientObject.CefBrowser.get_main_frame(AClientObject.CefBrowser);
  if tmpMainFrame <> nil then
  begin
    if Assigned(ACefDomVisitProc) then
    begin
      InitCefDomVisitor(@tmpCefDomVisitor, AClientObject, ACefDomVisitProc);
    end else
    begin
      InitCefDomVisitor(@tmpCefDomVisitor, AClientObject, CefDomVisit_Proc);
    end;
    tmpMainFrame.visit_dom(tmpMainFrame, @tmpCefDomVisitor.CefDomVisitor);
  end;
end;

end.
