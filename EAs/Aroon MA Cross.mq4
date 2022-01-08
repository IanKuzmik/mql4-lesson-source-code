//+------------------------------------------------------------------+
//|                                               Aroon MA Cross.mq4 |
//|                                       Copyright 2021, Ian Kuzmik |
//|                                    https://www.taprootcoding.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Ian Kuzmik"
#property link      "https://www.taprootcoding.com"
#property version   "1.00"
#property strict
//--- Inputs
input int            iAroonLength   = 7;
input int            iShortMALength = 50;
input int            iLongMALength  = 200;
input ENUM_MA_METHOD iMAMethod      = MODE_EMA;
//--- Enums
enum ENUM_EXIT_PRICE {
   LONG_TP,
   LONG_SL,
   SHORT_TP,
   SHORT_SL
};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){ return(INIT_SUCCEEDED);}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   
   if(Volume[0] > 1) return;
   
   double shortMA   = iCustom(_Symbol, _Period, "tapRoot Tutorials/MA Crossover", iShortMALength, iLongMALength, iMAMethod, 0,0);
   double longMA    = iCustom(_Symbol, _Period, "tapRoot Tutorials/MA Crossover", iShortMALength, iLongMALength, iMAMethod, 1,0);
   double aroonUp   = iCustom(_Symbol, _Period, "tapRoot Tutorials/Aroon UpandDown", iAroonLength,0,0);
   double aroonDown = iCustom(_Symbol, _Period, "tapRoot Tutorials/Aroon UpandDown", iAroonLength,1,0);

   bool   longCondition = (shortMA > longMA && aroonUp > aroonDown);
   
   int    slippage;
   double takeProfit;
   double stopLoss;
   double lots;
   
   string comment = "This is the comment";
   
   if(longCondition && OrdersTotal() < 1) {
      slippage   = (int)MarketInfo(_Symbol,MODE_SPREAD) * 2;
      takeProfit = CalculateTPSL(Ask, 2.0, LONG_TP);
      stopLoss   = CalculateTPSL(Ask, 1.5, LONG_SL);
      lots       = CalculateLotsSize(Ask, stopLoss, 0.02);
      
      if(lots == 0) return;
      
      if(OrderSend(_Symbol,OP_BUY,lots,Ask,slippage,stopLoss,takeProfit,comment,12345,0,clrGreen) < 0) Print(GetLastError());
      
   } 
   
   if(!longCondition && OrdersTotal() > 0){
      slippage = (int)MarketInfo(_Symbol,MODE_SPREAD) * 2;
      if(OrderSelect(0,SELECT_BY_POS)){
         if(!OrderClose(OrderTicket(),OrderLots(),Bid, slippage,clrRed)) Print(GetLastError());
      } else Print(GetLastError());
   }
   
   
 }
//+------------------------------------------------------------------+


double CalculateLotsSize(double price, double stopLoss, double risk) {
   double maxLoss = AccountFreeMargin() * risk;
   double potLoss = MathAbs(price - stopLoss);
   int    units;
   
   if(AccountCurrency() == SymbolInfoString(_Symbol, SYMBOL_CURRENCY_PROFIT)){
      units = (int)floor(maxLoss/potLoss);
      if((units * price) > (AccountFreeMargin()*AccountLeverage())) units = (int)floor((AccountFreeMargin()*AccountLeverage()) / price);
   }
   else if(AccountCurrency() == SymbolInfoString(_Symbol, SYMBOL_CURRENCY_BASE)){
      units = (int)floor((maxLoss*price)/potLoss);
      if(units > (AccountFreeMargin()*AccountLeverage())) units = (int)floor(AccountFreeMargin()*AccountLeverage());
   }
   else {Print("Error: Invalid currency pair (for the sake of brevity)"); return 0;}
   
   double lotSize = MarketInfo(_Symbol, MODE_LOTSIZE);
   double minLots = MarketInfo(_Symbol, MODE_MINLOT);
   double maxLots = MarketInfo(_Symbol, MODE_MAXLOT);
   double lotStep = MarketInfo(_Symbol, MODE_LOTSTEP);
   
   double lots = units/lotSize;
   
   if(lots < minLots) {Print("Error: Not enough funds"); return 0;}
   if(lots > maxLots) return maxLots;
   
   lots = floor(lots/lotStep) * lotStep; 
   
   return lots;

}

double CalculateTPSL(double price, double deviation, ENUM_EXIT_PRICE exit) {
   double atr = iATR(_Symbol,_Period,14,0); 
   switch(exit){
      case LONG_TP : return price + (atr * deviation);
      case LONG_SL : return price - (atr * deviation);
      case SHORT_TP: return price - (atr * deviation);
      case SHORT_SL: return price + (atr * deviation);
      default      : return 0;
   }

}





