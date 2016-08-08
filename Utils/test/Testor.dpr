program Testor;

uses
  Forms,
  TestForm in 'TestForm.pas' {Form1},
  HTMLParserAll2 in '..\HTMLParserAll2.pas',
  WStrings in '..\WStrings.pas',
  HTMLParserAll3 in '..\HTMLParserAll3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
