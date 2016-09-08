unit FrameDayChartViewer;

interface

uses
  Classes, Controls, Graphics, Forms, Messages, SysUtils, Windows,  
  define_DealItem, define_price, define_datasrc,
  BaseApp, BaseForm, StockDayDataAccess, UIDealItemNode,
  BaseRule, Rule_CYHT, Rule_BDZX, Rule_Boll, Rule_Std, Rule_MA, ExtCtrls;

type             
  TDataChartViewerData = record
    StockDayDataAccess: StockDayDataAccess.TStockDayDataAccess;  
    WeightMode: TWeightMode;
    
    //fRule_Boll_Price: TRule_Boll_Price;
    Rule_CYHT_Price: TRule_CYHT_Price;
    Rule_BDZX_Price: TRule_BDZX_Price;   
    Rule_Boll: TRule_Boll_Price;

    DataSrc: TDealDataSource;
  end;
                       
  TfmeDayChartViewer = class(TfrmBase)
    pbChart: TPaintBox;
    procedure pbChartPaint(Sender: TObject);
  private
    { Private declarations }
    fDataChartData: TDataChartViewerData;
  public                         
    { Public declarations }     
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize(App: TBaseApp); override;
    procedure SetData(ADataType: integer; AData: Pointer); override;
    procedure SetStockItem(AStockItem: PStockItemNode);
  end;

implementation

{$R *.dfm}

uses
  StockDayData_Load, define_stock_quotes;
  
constructor TfmeDayChartViewer.Create(AOwner: TComponent);
begin
  inherited;
  FillChar(fDataChartData, SizeOf(fDataChartData), 0);
  fDataChartData.DataSrc := Src_163;
end;

destructor TfmeDayChartViewer.Destroy; 
begin
  inherited;
end;

procedure TfmeDayChartViewer.Initialize(App: TBaseApp); 
begin
  inherited;
end;

procedure TfmeDayChartViewer.SetData(ADataType: integer; AData: Pointer);
begin
  SetStockItem(AData);
end;

procedure TfmeDayChartViewer.SetStockItem(AStockItem: PStockItemNode);
begin            
  fDataChartData.StockDayDataAccess := AStockItem.StockDayDataAccess;

  if nil = fDataChartData.StockDayDataAccess then
    fDataChartData.StockDayDataAccess := TStockDayDataAccess.Create(AStockItem.StockItem, fDataChartData.DataSrc, fDataChartData.WeightMode);  
  fDataChartData.Rule_BDZX_Price := AStockItem.Rule_BDZX_Price;
  fDataChartData.Rule_CYHT_Price := AStockItem.Rule_CYHT_Price;
  fDataChartData.Rule_Boll := AStockItem.Rule_Boll;
  pbChart.Repaint;
end;
             
procedure TfmeDayChartViewer.pbChartPaint(Sender: TObject);
type
  TDrawLine = record
    Y1: integer;
    Y2: integer;    
  end;
  
  function GetCoordPosition(ARect: TRect; AHigh, ALow, AValue: double): integer;
  begin
    Result := ARect.Bottom - Trunc(((AValue - ALow) / (AHigh - ALow)) * (ARect.Bottom - ARect.Top));
  end;
  
var
  tmpBgRect: TRect;
  tmpPriceRect: TRect;
  tmpAnalysisRect: TRect;
  
  tmpCandleRect: TRect;
  tmpPaintBox: TPaintBox;
  tmpCandleWidth: integer;
  tmpDayQuote: PRT_Quote_Day;
  tmpPaintCount: integer;
  tmpFirstDayIndex: integer;
  i: integer;
  tmpMaxPrice: integer;
  tmpMinPrice: integer;
  tmpX: integer;
  tmpX0: integer;
  tmpY: integer;
                            
  tmpLineBoll: TDrawLine;    
  tmpLineBoll_UB: TDrawLine;
  tmpLineBoll_LB: TDrawLine;
  
  tmpLineCYHT_SD: TDrawLine;
  tmpLineCYHT_SK: TDrawLine;
  tmpYLine: integer;
  
  tmpAnalysisMaxValue: double;
  tmpAnalysisMinValue: double;
begin
  tmpPaintBox := TPaintBox(Sender);
  tmpBgRect.Left := 0;
  tmpBgRect.Right := tmpPaintBox.Width;
  tmpBgRect.Top := 0;
  tmpBgRect.Bottom := tmpPaintBox.Height;  
  tmpPaintBox.Canvas.Brush.Color := clBlack;
  tmpPaintBox.Canvas.FillRect(tmpBgRect);
                                                  
  tmpPriceRect.Left := 1;
  tmpPriceRect.Right := tmpBgRect.Right;
  tmpPriceRect.Top := 1;
  tmpPriceRect.Bottom:= tmpBgRect.Bottom - 80;

  tmpAnalysisRect.Left := 1;
  tmpAnalysisRect.Right := tmpBgRect.Right;  
  tmpAnalysisRect.Top := tmpPriceRect.Bottom + 1;
  tmpAnalysisRect.Bottom:= tmpBgRect.Bottom - 1;
               
  tmpMaxPrice := 0;
  tmpMinPrice := 0;   
  tmpAnalysisMaxValue := 0;
  tmpAnalysisMinValue := 0;
  tmpX0 := 0;

  tmpCandleWidth := 5;
  tmpPaintBox.Canvas.Brush.Color := clRed;
  tmpPaintBox.Canvas.FrameRect(tmpPriceRect);

  if nil <> fDataChartData.StockDayDataAccess then
  begin
    if 0 < fDataChartData.StockDayDataAccess.RecordCount then
    begin
      tmpPaintCount := (tmpPriceRect.Right - tmpPriceRect.Left) div (tmpCandleWidth + 1);
      if fDataChartData.StockDayDataAccess.RecordCount > tmpPaintCount then
      begin
        tmpFirstDayIndex := fDataChartData.StockDayDataAccess.RecordCount - tmpPaintCount;
      end else
      begin
        tmpFirstDayIndex := 0;
        tmpPaintCount := fDataChartData.StockDayDataAccess.RecordCount;
      end;
                  
      (*//
      if nil <> fDataChartData.Rule_BDZX_Price then
      begin      
        tmpAnalysisMaxValue := fDataChartData.Rule_BDZX_Price.Ret_AD1_EMA.MaxF;
        if tmpAnalysisMaxValue < fDataChartData.Rule_BDZX_Price.Ret_AK_Float.MaxValue then
          tmpAnalysisMaxValue := fDataChartData.Rule_BDZX_Price.Ret_AK_Float.MaxValue;
        if tmpAnalysisMaxValue < fDataChartData.Rule_BDZX_Price.Ret_AJ.MaxValue then
          tmpAnalysisMaxValue := fDataChartData.Rule_BDZX_Price.Ret_AJ.MaxValue;

        tmpAnalysisMinValue := fDataChartData.Rule_BDZX_Price.Ret_AD1_EMA.MinF;
        if tmpAnalysisMinValue > fDataChartData.Rule_BDZX_Price.Ret_AK_Float.MinValue then
          tmpAnalysisMinValue := fDataChartData.Rule_BDZX_Price.Ret_AK_Float.MinValue;
        if tmpAnalysisMinValue > fDataChartData.Rule_BDZX_Price.Ret_AJ.MinValue then
          tmpAnalysisMinValue := fDataChartData.Rule_BDZX_Price.Ret_AJ.MinValue;
          
        tmpYLine1_1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              20);
        tmpPaintBox.Canvas.Pen.Color := clWhite;
        tmpPaintBox.Canvas.MoveTo(tmpAnalysisRect.Left, tmpYLine1_1);
        tmpPaintBox.Canvas.LineTo(tmpAnalysisRect.Right, tmpYLine1_1);
        
        tmpYLine1_1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              80);
        tmpPaintBox.Canvas.Pen.Color := clBlue;
        tmpPaintBox.Canvas.MoveTo(tmpAnalysisRect.Left, tmpYLine1_1);
        tmpPaintBox.Canvas.LineTo(tmpAnalysisRect.Right, tmpYLine1_1);
        
        tmpYLine1_1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              100);
        tmpPaintBox.Canvas.Pen.Color := clGreen;
        tmpPaintBox.Canvas.MoveTo(tmpAnalysisRect.Left, tmpYLine1_1);
        tmpPaintBox.Canvas.LineTo(tmpAnalysisRect.Right, tmpYLine1_1);
      end;
      //*)
      //(*//
      if nil <> fDataChartData.Rule_CYHT_Price then
      begin                 
        tmpAnalysisMaxValue := fDataChartData.Rule_CYHT_Price.EMA_SK.MaxF;
        if tmpAnalysisMaxValue < fDataChartData.Rule_CYHT_Price.EMA_SD.MaxF then
          tmpAnalysisMaxValue := fDataChartData.Rule_CYHT_Price.EMA_SD.MaxF;

        tmpAnalysisMinValue := fDataChartData.Rule_CYHT_Price.EMA_SK.MinF;
        if tmpAnalysisMinValue > fDataChartData.Rule_CYHT_Price.EMA_SD.MinF then
          tmpAnalysisMinValue := fDataChartData.Rule_CYHT_Price.EMA_SD.MinF;
          
        tmpYLine := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              20);
        tmpPaintBox.Canvas.Pen.Color := clWhite;
        tmpPaintBox.Canvas.MoveTo(tmpAnalysisRect.Left, tmpYLine);
        tmpPaintBox.Canvas.LineTo(tmpAnalysisRect.Right, tmpYLine);
        
        tmpYLine := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              80);
        tmpPaintBox.Canvas.Pen.Color := clBlue;
        tmpPaintBox.Canvas.MoveTo(tmpAnalysisRect.Left, tmpYLine);
        tmpPaintBox.Canvas.LineTo(tmpAnalysisRect.Right, tmpYLine);
        
        tmpYLine := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              100);
        tmpPaintBox.Canvas.Pen.Color := clGreen;
        tmpPaintBox.Canvas.MoveTo(tmpAnalysisRect.Left, tmpYLine);
        tmpPaintBox.Canvas.LineTo(tmpAnalysisRect.Right, tmpYLine);
      end;
      //*)

      i := tmpFirstDayIndex;    
      while i < tmpFirstDayIndex + tmpPaintCount do
      begin              
        tmpDayQuote := fDataChartData.StockDayDataAccess.RecordItem[i];
        if 0 = tmpMaxPrice then
        begin
          tmpMaxPrice := tmpDayQuote.PriceRange.PriceHigh.Value;
        end else
        begin
          if tmpMaxPrice < tmpDayQuote.PriceRange.PriceHigh.Value then
            tmpMaxPrice := tmpDayQuote.PriceRange.PriceHigh.Value;
        end;           
        if 0 = tmpMinPrice then
        begin
          tmpMinPrice := tmpDayQuote.PriceRange.PriceLow.Value;
        end else
        begin
          if tmpMinPrice > tmpDayQuote.PriceRange.PriceLow.Value then
            if 0 < tmpDayQuote.PriceRange.PriceLow.Value then
              tmpMinPrice := tmpDayQuote.PriceRange.PriceLow.Value;
        end;
        Inc(i);
      end;
      
      i := tmpFirstDayIndex;
      tmpCandleRect.Left := tmpPriceRect.Left + 1; 
      while i < tmpFirstDayIndex + tmpPaintCount do
      begin                                   
        tmpDayQuote := fDataChartData.StockDayDataAccess.RecordItem[i];  
        tmpCandleRect.Right := tmpCandleRect.Left + tmpCandleWidth;    
        tmpX := (tmpCandleRect.Left + tmpCandleRect.Right) div 2;
        //(*//                                                                                           
        if tmpDayQuote.PriceRange.PriceOpen.Value = tmpDayQuote.PriceRange.PriceClose.Value then
        begin               
          tmpPaintBox.Canvas.Brush.Color := clWhite;
          tmpCandleRect.Top := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceClose.Value);
          tmpCandleRect.Bottom := tmpCandleRect.Top + 1;    
          tmpPaintBox.Canvas.FrameRect(tmpCandleRect);

          tmpPaintBox.Canvas.Pen.Color := tmpPaintBox.Canvas.Brush.Color;
          tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceHigh.Value);
          tmpPaintBox.Canvas.MoveTo(tmpX, tmpY);
          tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceLow.Value);
          tmpPaintBox.Canvas.LineTo(tmpX, tmpY);                    
        end else
        begin
          if tmpDayQuote.PriceRange.PriceOpen.Value < tmpDayQuote.PriceRange.PriceClose.Value then
          begin                               
            tmpPaintBox.Canvas.Brush.Color := clred;
            tmpCandleRect.Top := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceClose.Value);
            tmpCandleRect.Bottom := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceOpen.Value);
            tmpPaintBox.Canvas.FrameRect(tmpCandleRect);
            tmpPaintBox.Canvas.Pen.Color := tmpPaintBox.Canvas.Brush.Color;
            tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceHigh.Value);
            tmpPaintBox.Canvas.MoveTo(tmpX, tmpY);
            tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceClose.Value);
            tmpPaintBox.Canvas.LineTo(tmpX, tmpY);

            tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceOpen.Value);
            tmpPaintBox.Canvas.MoveTo(tmpX, tmpY);
            tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceLow.Value);
            tmpPaintBox.Canvas.LineTo(tmpX, tmpY);
          end else
          begin
            tmpPaintBox.Canvas.Brush.Color := clgreen;
            tmpCandleRect.Top := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceOpen.Value);
            tmpCandleRect.Bottom := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceClose.Value);
            tmpPaintBox.Canvas.FillRect(tmpCandleRect);
            tmpPaintBox.Canvas.Pen.Color := tmpPaintBox.Canvas.Brush.Color;
            tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceHigh.Value);
            tmpPaintBox.Canvas.MoveTo(tmpX, tmpY);
            tmpY := GetCoordPosition(tmpPriceRect, tmpMaxPrice, tmpMinPrice, tmpDayQuote.PriceRange.PriceLow.Value);
            tmpPaintBox.Canvas.LineTo(tmpX, tmpY);
          end;
        end;
        //*)   
        //(*//
        if nil <> fDataChartData.Rule_Boll then
        begin      
          if i > tmpFirstDayIndex then
          begin    
            tmpLineBoll.Y2 := GetCoordPosition(tmpPriceRect,
              tmpMaxPrice,
              tmpMinPrice,
              fDataChartData.Rule_Boll.Boll[i]);
            tmpLineBoll_UB.Y2 := GetCoordPosition(tmpPriceRect,
              tmpMaxPrice,
              tmpMinPrice,
              fDataChartData.Rule_Boll.UB[i]);
            tmpLineBoll_LB.Y2 := GetCoordPosition(tmpPriceRect,
              tmpMaxPrice,
              tmpMinPrice,
              fDataChartData.Rule_Boll.LB[i]);

            if (tmpPriceRect.Top < tmpLineBoll.Y1) and
               (tmpPriceRect.Bottom > tmpLineBoll.Y1) and
               (tmpPriceRect.Top < tmpLineBoll.Y2) and
               (tmpPriceRect.Bottom > tmpLineBoll.Y2) then
            begin
              tmpPaintBox.Canvas.Pen.Color := clWhite;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpLineBoll.Y1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpLineBoll.Y2);
            end;    
            if (tmpPriceRect.Top < tmpLineBoll_UB.Y1) and
               (tmpPriceRect.Bottom > tmpLineBoll_UB.Y1) and
               (tmpPriceRect.Top < tmpLineBoll_UB.Y2) and
               (tmpPriceRect.Bottom > tmpLineBoll_UB.Y2) then
            begin
              tmpPaintBox.Canvas.Pen.Color := clYellow;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpLineBoll_UB.Y1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpLineBoll_UB.Y2);
            end;
            if (tmpPriceRect.Top < tmpLineBoll_LB.Y1) and
               (tmpPriceRect.Bottom > tmpLineBoll_LB.Y1) and
               (tmpPriceRect.Top < tmpLineBoll_LB.Y2) and
               (tmpPriceRect.Bottom > tmpLineBoll_LB.Y2) then
            begin
              tmpPaintBox.Canvas.Pen.Color := clRed;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpLineBoll_LB.Y1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpLineBoll_LB.Y2);
            end;

            tmpLineBoll.Y1 := tmpLineBoll.Y2;   
            tmpLineBoll_UB.Y1 := tmpLineBoll_UB.Y2;
            tmpLineBoll_LB.Y1 := tmpLineBoll_LB.Y2;
          end else
          begin           
            tmpLineBoll.Y1 := GetCoordPosition(tmpPriceRect,
              tmpMaxPrice,
              tmpMinPrice,
              fDataChartData.Rule_Boll.Boll[i]); 
            tmpLineBoll_UB.Y1 := GetCoordPosition(tmpPriceRect,
              tmpMaxPrice,
              tmpMinPrice,
              fDataChartData.Rule_Boll.UB[i]);
            tmpLineBoll_LB.Y1 := GetCoordPosition(tmpPriceRect,
              tmpMaxPrice,
              tmpMinPrice,
              fDataChartData.Rule_Boll.LB[i]);
          end;
          //  tmpLineBoll
        end;   
        //*)
        (*//
        if nil <> fDataChartData.Rule_BDZX_Price then
        begin            
          if i > tmpFirstDayIndex then
          begin
            try
              tmpYLine1_2 := GetCoordPosition(tmpAnalysisRect,
                tmpAnalysisMaxValue,
                tmpAnalysisMinValue,
                fDataChartData.Rule_BDZX_Price.Ret_AD1_EMA.ValueF[i]);
              tmpYLine2_2 := GetCoordPosition(tmpAnalysisRect,
                tmpAnalysisMaxValue,
                tmpAnalysisMinValue,
                fDataChartData.Rule_BDZX_Price.Ret_AJ.value[i]);  
              tmpYLine3_2 := GetCoordPosition(tmpAnalysisRect,
                tmpAnalysisMaxValue,
                tmpAnalysisMinValue,
                fDataChartData.Rule_BDZX_Price.Ret_AK_Float.value[i]);
                
              tmpPaintBox.Canvas.Pen.Color := clYellow;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpYLine1_1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpYLine1_2);

              tmpPaintBox.Canvas.Pen.Color := clRed;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpYLine2_1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpYLine2_2);
                                                          
              tmpPaintBox.Canvas.Pen.Color := clWhite;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpYLine3_1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpYLine3_2);

              tmpX0 := tmpX;
              tmpYLine1_1 := tmpYLine1_2;
              tmpYLine2_1 := tmpYLine2_2;
              tmpYLine3_1 := tmpYLine3_2;              
            except
            end;
          end else
          begin
            tmpYLine1_1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              fDataChartData.Rule_BDZX_Price.Ret_AD1_EMA.ValueF[i]); 
            tmpYLine2_1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              fDataChartData.Rule_BDZX_Price.Ret_AJ.value[i]);
            tmpYLine3_1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              fDataChartData.Rule_BDZX_Price.Ret_AK_Float.value[i]);
            tmpX0 := tmpX;
          end;
        end;
        //*)
        //(*//                        
        if nil <> fDataChartData.Rule_CYHT_Price then
        begin            
          if i > tmpFirstDayIndex then
          begin
            try
              tmpLineCYHT_SK.Y2 := GetCoordPosition(tmpAnalysisRect,
                tmpAnalysisMaxValue,
                tmpAnalysisMinValue,
                fDataChartData.Rule_CYHT_Price.SK[i]);
              tmpLineCYHT_SD.Y2 := GetCoordPosition(tmpAnalysisRect,
                tmpAnalysisMaxValue,
                tmpAnalysisMinValue,
                fDataChartData.Rule_CYHT_Price.SD[i]);
                
              tmpPaintBox.Canvas.Pen.Color := clYellow;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpLineCYHT_SK.Y1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpLineCYHT_SK.Y2);

              tmpPaintBox.Canvas.Pen.Color := clRed;
              tmpPaintBox.Canvas.MoveTo(tmpX0, tmpLineCYHT_SD.Y1);
              tmpPaintBox.Canvas.LineTo(tmpX, tmpLineCYHT_SD.Y2);

              tmpLineCYHT_SK.Y1 := tmpLineCYHT_SK.Y2;
              tmpLineCYHT_SD.Y1 := tmpLineCYHT_SD.Y2;           
            except
            end;
          end else
          begin
            tmpLineCYHT_SK.Y1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              fDataChartData.Rule_CYHT_Price.SK[i]);
            tmpLineCYHT_SD.Y1 := GetCoordPosition(tmpAnalysisRect,
              tmpAnalysisMaxValue,
              tmpAnalysisMinValue,
              fDataChartData.Rule_CYHT_Price.SD[i]);
          end;
        end;   
        tmpX0 := tmpX;
        //*)

        tmpCandleRect.Left := tmpCandleRect.Right + tmpCandleWidth;

        Inc(i);
        tmpCandleRect.Left := tmpCandleRect.Right + 1;
      end;
    end;
  end;
end;

end.
