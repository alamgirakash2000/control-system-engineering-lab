clc; clear; close all;
format compact;

% Defining System
s=tf('s');
sys=1/(s*(s+36)*(s+100));

% Drawing Bode Plot
omega = logspace(-5,4,10000);
bode(sys,omega), grid on;

% Finding parameters related to bode plot
[Gm,Pm,wpm,wgm]=margin(sys);       % finding GM, PM, PCF, GCF
Gm_db = 20*log10(Gm);              % Gm in dB
bw = bandwidth(feedback(sys,1));   % Finding Bandwidth

%% Required formula's
% OS to zeta and Pm
OS = 0.2;
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5
Pm = atan(2*zeta/sqrt(-2*zeta^2+sqrt(1+4*zeta^4)))*180/pi

% Closed-loop bandwidth
% w_n = 4/(Ts*zeta)
% w_n = pi/(Tp*sqrt(1-zeta^2));
Tp= 0.1;
w_n = pi/(Tp*sqrt(1-zeta^2));
w_BW = w_n * sqrt((1-2*zeta^2)+sqrt(4*zeta^4-4*zeta^2+2))


%% Trial and Error for lag Compensator
% Get these two values from the bode plot
w = 9.29;
gain_db = 12.4;

b=0.222;     % Change b and check the errors

zero = w/10;
gain = 10^(-gain_db/20);
trail_gain_error = abs((b/zero)*(zero+w*i)/(b+w*i)) - gain
