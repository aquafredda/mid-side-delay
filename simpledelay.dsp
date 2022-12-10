declare name "Simple Mid Side Ping Pong Flip Flop Tic Tac Zip Zap Delay";
declare vendor "G.A.";
declare author "Gabriele Acquafredda";
ts = library("12ts.lib");

import("stdfaust.lib");
import("filters.lib");


delay_matrix = hgroup("Delay Matrix",simple_delayL, simple_delayL, simple_delayR, simple_delayR*(-1))
with {
    del_timeL = hslider("Delay Time L (ms)",0,0,1000,1)*ma.SR/1000;
    del_timeR = hslider("Delay Time R (ms)",0,0,1000,1)*ma.SR/1000;
    
    simple_delayL =  +~(@(2*del_timeL) : *(feedbk));
    simple_delayR = @(del_timeR) : +~(@(2*del_timeR) : *(feedbk));
    
    feedbk = hslider("Feedback %",0,0,110,1)/100;
};


filters = hgroup("Filters", filterlphp, filterlphp)
with {
    flp = hslider("LoPass Freq",22000,20,22000,1);
    qlp = hslider("LoPass Q",1,1,5,0.05);

    fhp = hslider("HiPass Freq",20,20,22000,1);
    qhp = hslider("HiPass Q",1,1,5,0.05);

    filterlphp = resonlp(flp,qlp,1) : resonhp(fhp,qhp,1) ;
};


mod_matrix = hgroup("Modulation", modulations, modulations)
with {
    freq_down = hslider("Downsample Frequency",22000,20,22000,1);
    modulations = ba.downSample(freq_down);
};

process = _ , _ <: delay_matrix :> mod_matrix : filters;
