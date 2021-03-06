//+------------------------------------------------------------------+
//|                                                        ZBlue.mq4 |
//|                                    Copyright 2017, zuojia & zlbd |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "zuojia & zlbd"
#property link      ""
#property version   "1.00"
#property strict
#include <stderror.mqh>
#include <stdlib.mqh>
#include "lib\ZCommon.mqh"
/*
[策略1]
关于多单的描述（以下策略描述中的参数，均可自行在 EA 启动前更改）：

    1.如果多单数为 0 ， 则开 一仓多单 0.01 手
    2.多单底单如果亏损 30 点，则加一仓多单， 底单再亏 40 点，再加一仓多单... 以此类推，多单最多下10次

        加单仓位参考:
        0.01 0.02 0.03 0.04 0.05 0.06   
        0.08 0.10  
        0.13 0.16
        0.2

        加仓的间隔距离参考（外汇点）：
        30  40  50 ...

    3. 多单1单，盈利达 40 个外汇点，该多单平仓
    4. 多单2单以上，多单盈利达 3 个外汇点*多单总手数，所有多单整体平仓（先平手数大的）
        参考：
        （ 多单的盈利值 - 多单的亏损值 ）> 多单总的手数 * 3个外汇点

备注：
关于空单的描述，与多单一样
如果账户亏损（多单和空单的总亏损），占当前保证金 40 %， 则全部出仓 （说明EA和当前行情有较大的违背，需反省） 
比如多单，如果多单全部平仓了，那么新开的一单的入场价格，会作为2中的亏损点的基准，来计算30,40,50...

后期修正：
    一. 需要能调整加仓比例和加仓手数之间的关系
*/

//+------------------------------------------------------------------+
//| macro defination 
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| function declaration
//+------------------------------------------------------------------+
bool fit_strategy_1(void)
{
    bool bret = true;
    return bret;
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- create timer
    EventSetTimer(10);
    //---
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //--- destroy timer
    EventKillTimer();
    printf("reason=%d", reason);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    /* 1. add protect */
    if(Bars<100)
    {
        Print("bars less than 100");
        return;
    }

    /* 2. open order */
    int total = OrdersTotal();
    if(0 == total) {
        ZOrder_buyopen();
        //ZOrder_sellopen();
    }

    /* 3. close order */
    int i = 0;
    for(i=0; i<total; i++) {
        if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            continue;
        }
        // check for opened position & symbol
        if(OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
            //--- long position is opened
            if(OrderType() == OP_BUY) {
                if(fit_strategy_1()) {
                    //--- close order and exit
                    ZOrder_buyclose(OrderTicket());
                }
            }
        }
    }
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    //---
}
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
{
    //---
    double ret=0.0;
    //---
    printf("hello world");
    ZLog_test();
    ZOrder_test();
    ZLOG();
    return(ret);
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
        const long &lparam,
        const double &dparam,
        const string &sparam)
{
    //---
    ZLOG();
    printf("id=%d, lparam=%d, dparam=%d, sparam=%d",id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
