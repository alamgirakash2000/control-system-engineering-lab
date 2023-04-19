%% Bode Plot Lag
% Design a lag compensator that will improve the steady state error tenfold
%, while still operating with 20% overshoot
clc; clear; close all;
format compact;

% Define System
s = tf('s');
sys = 1/(s*(s+50)*(s+120));

% Pm from %OS
OS = 0.2;
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
Pm = atan(2*zeta/sqrt(-2*zeta^2+sqrt(1+4*zeta^4)))*180/pi;

%bode plot
w = logspace(-2,4,10000);
figure, bode(sys,w),grid on;

%% From bode plot at w = 27.7
gain_db = -106;
k  = 10^(-gain_db/20);
uncomp_sys = k*sys;

%% As the error is tenfold, Kv = 10 --> k=k*10
err_comp_sys = uncomp_sys*10;
figure, bode(err_comp_sys,w),grid on;

%% Trial and Error for lag Compensator
% Get these two values from the bode plot
omega = 20.5;
gain_db = 23.4;

b=0.139;     % Change b and check the errors

lag_zero = omega/10;
gain = 10^(-gain_db/20);
trail_gain_error = abs((b/lag_zero)*(lag_zero+omega*i)/(b+omega*i)) - gain
lag_pole = b;

%% Lag compensated system
compensator = (lag_pole/lag_zero)*((s+lag_zero)/(s+lag_pole));
lag_comp_sys = compensator*err_comp_sys;

figure()
bode(uncomp_sys, w);
hold on
grid on
bode(err_comp_sys, w);
bode(lag_comp_sys, w);
legend('Uncompensated', 'After error compensation', 'Lag compensated')


