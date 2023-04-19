%% Variation of R by keeping Input Voltage constant
clear; clc; close all;
format compact;

% Given Values
J=0.01;
b=0.1;
K=0.01;
L=0.5;
num=K;

time = 0:0.1:4;
R = 0.1:0.1:4;
settling_time = zeros(1,length(R));
steady_state_val = zeros(1,length(R));

for k=1:length(R)
    den=[(J*L) ((J*R(k))+(L*b)) ((b*R(k))+K^2)];
    open_sys = tf(num,den);
    response = step(open_sys,time);
    stats = stepinfo(open_sys);
    settling_time(k) = stats.SettlingTime;
    steady_stat_val(k) = response(end);
end
figure()
subplot(2,1,1)
plot(R,settling_time);
title("R vs Settling time");
xlabel("R"),ylabel("Settling time(s)");

subplot(2,1,2)
plot(R,steady_stat_val);
title("R vs Steady State Value");
xlabel("R"),ylabel("Stady state value($\omega$)");


%% Variation of Input Voltage by keeping R constant
clear;
% Values
J=0.01;
b=0.1;
K=0.01;
L=0.5;
num=K;
time = 0:0.1:10;
R=1;
voltage = 0.1:1:30;
settling_time = zeros(1,length(voltage));
steady_state_val = zeros(1,length(voltage));

for k=1:length(voltage)
    den=[(J*L) ((J*R)+(L*b)) ((b*R)+K^2)];
    open_sys = tf(num,den);
    opt = stepDataOptions;
    opt.InputOffset = 0;
    opt.StepAmplitude = voltage(k);
    response = step(open_sys,time,opt);
    stats = stepinfo(response,time);
    settling_time(k) = stats.SettlingTime;
    steady_stat_val(k) = response(end);
end

figure()
subplot(2,1,1)
plot(voltage,settling_time);
title("Voltage vs Settling time");
xlabel("Volt"),ylabel("Settling time(s)");

subplot(2,1,2)
plot(voltage,steady_stat_val);
title("Voltage vs Steady State Value");
xlabel("Volt"),ylabel("Stady state value($\omega$)");