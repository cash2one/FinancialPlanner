unit define_dealmarket;

interface

type             
  PRT_DealMarket        = ^TRT_DealMarket;
  TRT_DealMarket        = record       
    //Code                : array[0..3] of AnsiChar; 
    sCode               : AnsiString;
    //Name                : array[0..5] of WideChar;
    Name                : AnsiString;
    iCode               : Word;
  end;

const
  Market_SH = 'sh';
  Market_SZ = 'sz';

implementation

end.
