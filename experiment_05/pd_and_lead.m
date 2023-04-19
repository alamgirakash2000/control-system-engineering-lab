%% PD and Lead Controller
% Overshoot is 16% and setting time down by factor of 2
clc; clear; close all;
format compact;

s= tf('s');
sys = 1/((s+1)*(s+2)*(s+5));      % uncompensated system
OS = 0.16;                        % Given %OS
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
rlocus(sys);
sgrid(zeta,0);
axis([-10 5 -5 5])
[k,] = rlocfind(sys)
uncomp_sys = k*sys;

%% PD Controller
% From the rlocfind we have to find k and pole = -sigma + j*omega
% Ts_old = 4/sigma ----  Ts_new = Ts_old / factor
% sigma_new = 4 / Ts_new
% omega_new = sigma_new * tan(cos^-1(zeta))
% new_pole = -sigma_new + j*omega_new
% Now find the required angle for the zero
% Find the position of zero. Here zero = -3.73

controller_zero = (s+3.73);
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
t = 0:0.01:50;
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

%%
%% Lead Compensator
%%
%the difference with PD controller is that for PD, the position of z_c was
%fixed, but in lead, we can place the zero wherever we want and then from
%angle condition we find the location of the pole

%so let us assume we place a controller zero at -2, an open loop pole for
%the ease of calculation, then we find the position of the pole p_c using
%angle condition

%after manual calculation, we find p_c = -8.053

controller_zero = s+2;
controller_pole = 1/(s+8.053);
lead_comp_sys = uncomp_sys*(controller_zero*controller_pole);

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(lead_comp_sys),title('Root locus after adding pole and zero')

%% Now we need to find k_comp as the shape gets changed
figure();
rlocus(lead_comp_sys);
sgrid(zeta, 0);
[k_comp_lead,] = rlocfind(lead_comp_sys);
axis([-10 5 -5 5])
comp_sys = lead_comp_sys*k_comp_lead;

%% Plotting results for Lead compensation
t = 0:0.01:50;
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
title("Lead Compensation")
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Uncompensated Response','Compensated response');

