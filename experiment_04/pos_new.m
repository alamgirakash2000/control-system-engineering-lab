clc; clear; close all;
format compact;

% Defining functions
t = 0:0.01:5;     % Time
s = tf('s');
G_s = 5/(s^2+7*s+10);
R_s = 1/s;

% Calculating response and error
C_s= R_s*G_s;
E_s = R_s - C_s;

rep =  impulse(C_s, t);
rep2 = impulse(E_s, t);

plot (t,rep,'r');
hold on ;
plot(t, rep2, 'g');