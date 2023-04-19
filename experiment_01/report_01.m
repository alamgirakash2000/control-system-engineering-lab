clc; clear; close all;

J=0.01;
b=0.1;
K=0.01;
R=1;
L=0.5;

s = tf('s');
open_sys = K/((J*s+b)*(L*s+R)+K^2);
step (open_sys,4);

xlabel('t(s)'),ylabel('Velocity(rad/s)');
title('Step Response for the Open Loop System');

stats = stepinfo(open_sys);
v_max = stats.Peak;
Ts = stats.SettlingTime;
fprintf("The maximum speed is: %.2f rad/s \n", v_max)
fprintf("Time to reach to the peak: %.2f s \n", Ts)