clc; clear; close all;
format compact;

%%Modeling a DC Motor
J=0.01;
b=0.1;
K=0.01;
R=1;
L=0.5;

s = tf('s');
open_sys = K/((J*s+b)*(L*s+R)+K^2);

% Open loop response
step (open_sys,0:0.1:3);
title('Step Response for the Open Loop System');
disp(stepinfo(open_sys))