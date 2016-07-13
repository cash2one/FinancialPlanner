unit zsHelperMessage;

interface

uses
  windef_msg;

const
  WM_C2S_LaunchProgram    = WM_CustomAppBase + 11;
  
  WM_C2S_LoginUser        = WM_CustomAppBase + 21;
  WM_C2S_Unlock           = WM_CustomAppBase + 22;

  WM_C2S_DialogCloseNormal  = WM_CustomAppBase + 31;
  
  WM_C2S_StockBuy_Mode_1  = WM_CustomAppBase + 41;

  // wParam stock id
  // lparam price + num * 100

  WM_C2S_StockBuy_XueQiu  = WM_CustomAppBase + 42;

  WM_C2S_StockSale_Mode_1 = WM_CustomAppBase + 51;
  WM_C2S_StockSale_XueQiu = WM_CustomAppBase + 52;

  WM_C2S_Query            = WM_CustomAppBase + 71;

type
  TWMDeal_LParam  = packed record
    Price         : Word; // º€∏Ò
    Hand          : Word; //  ÷
  end;
  
  TWMDeal_Mode_1  = record
    StockCode     : Integer;
    DealLParam    : TWMDeal_LParam;    
  end;

implementation

end.
