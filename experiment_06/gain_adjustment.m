clc; clear; close all;
format compact;

s = tf('s');
sys = 1/(s*(s+50)*(s+120));

% Pm from %OS
OS = 0.2;
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
Pm = atan(2*zeta/sqrt(-2*zeta^2+sqrt(1+4*zeta^4)))*180/pi;

%bode plot
w = logspace(-2,4,10000);
figure, bode(sys,w),grid on;

% From bode plot
omega = 27.6;
gain_db = -106;
k  = 10^(-gain_db/20);

%% Compensated System
gain_comp_sys = k*sys;

figure()
bode(sys, w);
hold on
grid on
bode(gain_comp_sys, w);
legend('Uncompensated', 'After compensation')

%% using sisotool

%run the sisotool command
sisotool(sys)

%for gain adjustment, just double click on C at the top left under 'Controller and Fixed Blocks'
%set the gain to a value, see what difference it makes on the phase margin
%keep adjusting the gain till you reach the desired phase margin

%from the bottom right graph of step response, you can see the desired
%overshoot





























