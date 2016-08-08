unit TestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btnParseHtml: TButton;
    mmo1: TMemo;
    mmo2: TMemo;
    btnClear: TButton;
    procedure btnParseHtmlClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  HTMLParserAll3;
  
procedure TForm1.btnClearClick(Sender: TObject);
begin
  mmo1.Lines.Clear;
end;

procedure TForm1.btnParseHtmlClick(Sender: TObject);
var
  tmpHtmlParser: PHtmlParser;
  tmpHtmlDoc: PHtmlDocDomNode;
  tmpDomNode: PHtmlDomNode;
  i: integer;
begin
  mmo2.Lines.Clear;
  tmpHtmlDoc := nil;
  tmpHtmlParser := CheckoutHtmlParser;
  try
    tmpHtmlDoc := HtmlParserparseString(tmpHtmlParser, mmo1.Lines.Text);
  finally
    CheckInHtmlParser(tmpHtmlParser);
  end;
  if nil <> tmpHtmlDoc then
  begin
    //mmo2.Lines.Add(IntToStr(GlobalTestNodeCount));
    HtmlDomNodeFree(PHtmlDomNode(tmpHtmlDoc));
  end;
  //mmo2.Lines.Add(IntToStr(GlobalTestNodeCount));
  mmo2.Lines.Add('----------------------------');
//  for i := 0 to tmpHtmlDoc.Count - 1 do
//  begin
//    tmpDomNode := tmpHtmlDoc.Items[i];
//    mmo2.Lines.Add(IntToStr(tmpDomNode.NodeType) + ' - ' + tmpDomNode.NodeName);
//    if HTMLDOM_NODE_TEXT = tmpDomNode.NodeType then
//    begin
//      mmo2.Lines.Add(IntToStr(tmpDomNode.NodeType) + ' - ' + tmpDomNode.NodeValue);    
//    end;
//  end;
  mmo2.Lines.Add('----------------------------');
end;

end.
