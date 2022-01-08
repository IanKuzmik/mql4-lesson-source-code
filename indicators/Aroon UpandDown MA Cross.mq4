//+------------------------------------------------------------------+
//|                                     Aroon UpandDown MA Cross.mq4 |
//|                                       Copyright 2021, Ian Kuzmik |
//|                                    https://www.taprootcoding.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Ian Kuzmik"
#property link      "https://www.taprootcoding.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_plots   3
//--- plot AroonUp
#property indicator_label1  "AroonUp"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrChartreuse
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot AroonDown
#property indicator_label2  "AroonDown"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot GoLongHisto
#property indicator_label3  "GoLongHisto"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrPapayaWhip
#property indicator_style3  STYLE_DOT
#property indicator_width3  1
//--- indicator buffers
double         AroonUpBuffer[];
double         AroonDownBuffer[];
double         GoLongHistoBuffer[];
//--- indicator inputs
input int      iAroonLength = 7; 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,AroonUpBuffer);
   SetIndexBuffer(1,AroonDownBuffer);
   SetIndexBuffer(2,GoLongHistoBuffer);
   
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
   int barsSinceHigh    = 0;
   int barsSinceLow     = 0;
   
   double shortMA;
   double longMA;
   
   for(int i=0;i<uncalculatedBars;i++)
     {
     
      if(i >= rates_total-iAroonLength) return rates_total;
      
      for(int j=0;j<=iAroonLength;j++)
        {
         if(high[i+j] > high[i+barsSinceHigh]) barsSinceHigh = j;
         if(low[i+j]  < low[i+barsSinceLow])   barsSinceLow  = j;
        }
        
        shortMA = iCustom(_Symbol,_Period,"MA Crossover",0,i);
        longMA  = iCustom(_Symbol,_Period,"MA Crossover",1,i);
        
        AroonUpBuffer[i]     = ((iAroonLength - (double)barsSinceHigh)/iAroonLength) * 100;
        AroonDownBuffer[i]   = ((iAroonLength - (double)barsSinceLow)/iAroonLength)  * 100;
        GoLongHistoBuffer[i] = (shortMA > longMA && AroonUpBuffer[i] > AroonDownBuffer[i]) ? 100 : 0;
      
     }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
