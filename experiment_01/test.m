clc; clear; close all;
format compact;

%% Modeling a DC Motor
J=0.01;
b=0.1;
K=0.01;
R=1;
L=0.5;
num=K;
den=[(J*L) ((J*R)+(L*b)) ((b*R)+K^2)];
open_sys = tf(num,den);

% Open loop response
step (open_sys,0:0.1:3);
title('Step Response for the Open Loop System');