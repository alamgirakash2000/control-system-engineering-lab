%% PD and Lead Controller
% Overshoot is 20% and peak time down by factor of 2/3
clc; clear; close all;
format compact;

s= tf('s');
sys = (s+8)/((s+3)*(s+6)*(s+10));      % uncompensated system
OS = 0.20;                             % Given %OS
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
rlocus(sys);
sgrid(zeta,0);
axis([-10 20 -5 20])
[k,] = rlocfind(sys)
uncomp_sys = k*sys;

%% PD 
controller_zero = (s+55.9);
pd_comp_sys = uncomp_sys*(controller_zero);

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(pd_comp_sys),title('Root locus after adding pole and zero')

%% Now we need to find k_comp as the shape gets changed
figure();
rlocus(pd_comp_sys);
sgrid(zeta, 0);
[k_comp,] = rlocfind(pd_comp_sys);
axis([-10 5 -5 5])
comp_sys = pd_comp_sys*k_comp;

%% Plotting results for PD controller
t = 0:0.01:10;
R_s = 1;          %  step -->1 ; ramp --> 1/s ; parabola --> 1/s^2

%Uncompensated Response
Open_s = uncomp_sys;
Close_s = Open_s/(1+Open_s);
uncomp_C_s = Close_s*R_s;

% Compensated Response
Open_s = comp_sys;
Close_s = Open_s/(1+Open_s);
comp_C_s = R_s*Close_s;

%Plotting result
figure()
step(uncomp_C_s,t,"r");
hold on
step(comp_C_s,t,'g')
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Uncompensated Response','Compensated response');

%% PI compensation
controller_pole = 1/s;
controller_zero = (s+0.001);
pi_comp_sys = comp_sys*controller_pole*controller_zero;

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(pi_comp_sys),title('Root locus after adding pole and zero')

%% Now check the Error after PI Controller
%Uncompensated error
t = 0:0.01:10000;
R_s = 1/s;

Open_s = uncomp_sys;
Close_s = Open_s/(1+Open_s);
C_s = R_s*Close_s;
E_s = R_s - C_s;
uncomp_error = impulse(E_s, t);

% Compensated Error
Open_s = pi_comp_sys;
Close_s = Open_s/(1+Open_s);
C_s = R_s*Close_s;
E_s = R_s - C_s;
comp_error = impulse(E_s, t);

%Plotting result
figure()

plot(t,uncomp_error,"r",t,comp_error,"b"),title("Error Analysis");
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Uncompensated error','Compensated Error');

