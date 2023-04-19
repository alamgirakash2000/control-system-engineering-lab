% Overshoot is 10%
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

%% PI compensation
controller_pole = 1/s;
controller_zero = (s+0.001);
pi_comp_sys = uncomp_sys*controller_pole*controller_zero;

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