clc; clear; close all;
format compact;

% Defining variables
t = 0:0.01:25; % Time

% Defining systems
s = tf('s');
G_s= 100/(s*(s+10));
H_s = 1/(s+5);
close_sys = feedback(G_s, H_s);
input = ones(length(t),1);

% Finding the responses
step_res = step(close_sys, t); % Step response
error = abs(step_res - input');

plot(t, error), title('Error Response'), xlabel("Time(s)"), ylabel("Error");