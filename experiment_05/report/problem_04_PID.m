%% Lead controller
% Overshoot is 10% and setting time is reduced by factor of 2
clc; clear; close all;
format compact;

s= tf('s');
sys = 1/((s+1)*(s+8)*(s+6));      % uncompensated system
OS = 0.10;                        % Given %OS
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
rlocus(sys);
sgrid(zeta,0);
axis([-10 5 -5 5])
[k,] = rlocfind(sys)
uncomp_sys = k*sys;

%% Find the PD Controller
% Let zero at -6. So the position of pole is -8.126
controller_zero = (s+6);
lead_comp_sys = uncomp_sys*controller_zero;

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(lead_comp_sys),title('Root locus after adding pole and zero')

%% Now we need to find k_comp as the shape gets changed
figure();
rlocus(lead_comp_sys);
sgrid(zeta, 0);
axis([-10 20 -20 20])
[k_comp,] = rlocfind(lead_comp_sys);
comp_sys = lead_comp_sys*k_comp;

%% Plotting results for PD controller
t = 0:0.01:10;
R_s = 1;          

%Uncompensated Response
uncomp_Open_s = uncomp_sys;
uncomp_Close_s = uncomp_Open_s/(1+uncomp_Open_s);
uncomp_C_s = uncomp_Close_s*R_s;

% Compensated Response
comp_Open_s = comp_sys;
comp_Close_s = comp_Open_s/(1+comp_Open_s);
comp_C_s = R_s*comp_Close_s;

%Plotting result
figure()
step(uncomp_C_s,t,"r");
hold on
step(comp_C_s,t,'g')
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Uncompensated Response','Compensated response');