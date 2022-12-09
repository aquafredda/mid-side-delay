declare name "Simple Mid Side Ping Pong Flip Flop Tic Tac Zip Zap Delay";
declare vendor "G.A.";
declare author "Gabriele Acquafredda";
ts = library("12ts.lib");

import("stdfaust.lib");

del_time = hslider("Delay Time (ms)",0,0,1000,1)*ma.SR/1000;
feedbk = hslider("Feedback %",0,0,110,1)/100;

simple_delayL =  +~(@(2*del_time) : *(feedbk));
simple_delayR = @(del_time) : +~(@(2*del_time) : *(feedbk));

process = _ , _ <: simple_delayL, simple_delayL, simple_delayR, simple_delayR*(-1) :> _, _;
