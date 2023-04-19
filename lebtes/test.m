%% PI and Lag compensated controller
clc; clear; close all;

s= tf('s');
sys = 1/(s*(s+2)*(s+5));   % uncompensated system
OS = 0.2;                  % Given %OS
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
rlocus(sys);
sgrid(zeta,0);
axis([-10 5 -5 5])
[k, poles] = rlocfind(sys)
uncomp_sys = k*sys;

%% PI compensation
controller_pole = 1/s;
controller_zero = (s+0.001);
pi_comp_sys = uncomp_sys*controller_pole*controller_zero;
 locus after adding pole and zero')

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(pi_comp_sys),title('Root
%% Now check the Error after PI Controller
%Uncompensated error
t = 0:0.01:10000;
R_s = 1/s^2;

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

%% Lag compensation by factor of 10
% k = 13.1 from rlocfind... and for this k--> Kv is 1.31 and e is 0.763
% from (Zc/Pc) = (Kv_new/Kv_old) --> Pc = 0.001 and Zc = 0.01

controller_pole = 1/(s+0.001);
controller_zero = (s+0.01);
lag_comp_sys = uncomp_sys*controller_pole*controller_zero;

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(lag_comp_sys),title('Root locus after adding pole and zero')

%% Now check the Error after Lag Compensation
%Uncompensated error
t = 0:0.01:10000;
R_s = 1/s^2;

Open_s = uncomp_sys;
Close_s = Open_s/(1+Open_s);
C_s = R_s*Close_s;
E_s = R_s - C_s;
uncomp_error = impulse(E_s, t);

% Compensated Error
Open_s = lag_comp_sys;
Close_s = Open_s/(1+Open_s);
C_s = R_s*Close_s;
E_s = R_s - C_s;
comp_error = impulse(E_s, t);

%Plotting result
figure()

plot(t,uncomp_error,"r",t,comp_error,"b"),title("Error Analysis");
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Uncompensated error','Compensated Error');



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


