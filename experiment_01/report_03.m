clear;clc; close all
format compact;

% Given Parameters
J=0.01;
b=0.1;
K=0.01;
L=0.5;
num=K;
time = 0:0.1:10;
R=0.1:0.1:4;
voltage = 0.1:1:30;

settling_time = zeros(length(R),length(voltage));
steady_state_val = zeros(length(R),length(voltage));
for j=1:length(R)
    for k=1:length(voltage)
        den=[(J*L) ((J*R(j))+(L*b)) ((b*R(j))+K^2)];
        open_sys = tf(num,den);
        opt = stepDataOptions;
        opt.InputOffset = 0;
        opt.StepAmplitude = voltage(k);
        response = step(open_sys,time,opt);
        stats = stepinfo(response,time);settling_time(j,k) = stats.SettlingTime;
        steady_stat_val(j,k) = response(end);
    end
end
figure()
[X,Y] = meshgrid(voltage,R);
surf(X,Y,settling_time)
figure()
surf(X,Y,steady_stat_val)