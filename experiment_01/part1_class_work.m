clc; clear; close all;
format compact;

%%Given info
num = 2;
den = [1 -6 25];
open_sys = tf(num, den);
poles = pole(open_sys);
fprintf("Poles are: \n")
disp(poles)