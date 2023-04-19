clc; clear; close all;
format compact;

t = 0:0.01:50;
% Defining functions
s=tf('s');
G_s = 1/((s+4)*(s+3)*(s+2));

os = 60/100;
zeta = -log(os)/sqrt(pi^2+(log(os))^2);

rlocus(G_s);
sgrid(0, 0);   
[k, poles] = rlocfind(G_s)