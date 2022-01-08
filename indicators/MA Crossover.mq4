//+------------------------------------------------------------------+
//|                                                 MA Crossover.mq4 |
//|                                       Copyright 2021, Ian Kuzmik |
//|                                    https://www.taprootcoding.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Ian Kuzmik"
#property link      "https://www.taprootcoding.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot ShortMA
#property indicator_label1  "ShortMA"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDarkOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot LongMA
#property indicator_label2  "LongMA"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrAqua
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- input parameters
input int            iShortLength = 50;
input int            iLongLength  = 200;
input ENUM_MA_METHOD iMAMethod    = MODE_EMA;
//--- indicator buffers
double         ShortMABuffer[];
double         LongMABuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ShortMABuffer);
   SetIndexBuffer(1,LongMABuffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit = rates_total - prev_calculated;
   
   for(int i=0;i<limit;i++)
     {
      ShortMABuffer[i] = iMA(_Symbol,_Period,iShortLength,0,iMAMethod,PRICE_CLOSE,i);
      LongMABuffer[i]  = iMA(_Symbol,_Period,iLongLength,0,iMAMethod,PRICE_CLOSE,i);
     }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
