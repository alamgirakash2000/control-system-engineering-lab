clc; clear; close all;
format compact;

% Defining variables
k = 672;           % from the calcultaion
t = 0:0.01:25;     % Time

% Defining systems
s = tf('s');
open_sys = (k*s+5*k)/(s*(s+6)*(s+7)*(s+8));
close_sys = feedback(open_sys, 1);

% Finding the responses
step_res = step(close_sys, t);              % Step response
ramp_res = step(close_sys*1/s, t);          % Ramp response
parabola_res = step(close_sys*1/s^2, t);    % Parabolic response 

% Plotting the output
subplot(311), plot(t, step_res, 'LineWidth',2), title("Step Response"), xlabel("Time(s)"), ylabel("Response")
subplot(312), plot(t, ramp_res, 'LineWidth',2), title("Ramp Response"), xlabel("Time(s)"), ylabel("Response")
subplot(313), plot(t, parabola_res, 'LineWidth',2), title("Parabolic Response"), xlabel("Time(s)"), ylabel("Response")