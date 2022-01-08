//+------------------------------------------------------------------+
//|                                                 Tutorial-SMA.mq4 |
//|                                       Copyright 2021, Ian Kuzmik |
//|                                    https://www.taprootcoding.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Ian Kuzmik"
#property link      "https://www.taprootcoding.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot SMA
#property indicator_label1  "SMA"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      Periods=20;
//--- indicator buffers
double         SMABuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SMABuffer);
   
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
   int uncalculatedBars = rates_total - prev_calculated;
   
   for(int i=0;i<uncalculatedBars;i++)
     {
      SMABuffer[i] = iMA(NULL,NULL,Periods,0,MODE_SMA,PRICE_CLOSE,i);
     }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
