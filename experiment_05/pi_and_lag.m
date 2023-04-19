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

%let's see the root locus now again
figure()
subplot(211), rlocus(sys),title('Uncompensated Root Locus')
subplot(212), rlocus(pi_comp_sys),title('Root locus after adding pole and zero')

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


%%
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

%% Find the Lead Controller
% New Operating point --> 4.511+j*6.17
% Let zero at -6. So the position of pole is -469.63
controller_zero = (s+6);
controller_pole = 1/(s+469.63);
lead_comp_sys = uncomp_sys*controller_zero*controller_pole;

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

%% Plotting results for Lead compensator
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

%% Lag Control for error compensation
base_sys = comp_sys;

zero = s+0.003667;
pole = 1/(s+0.001);

lag_compensated_sys = base_sys*zero*pole;

%% Now check the Error after Lag Compensation
%Uncompensated error
t = 0:0.01:10000;
R_s = 1/s;

Open_s = uncomp_sys;
Close_s = Open_s/(1+Open_s);
C_s = R_s*Close_s;
E_s = R_s - C_s;
uncomp_error = impulse(E_s, t);

% Compensated Error
Open_s = lag_compensated_sys ;
Close_s = Open_s/(1+Open_s);
C_s = R_s*Close_s;
E_s = R_s - C_s;
comp_error = impulse(E_s, t);

%Plotting result
figure()

plot(t,uncomp_error,"r",t,comp_error,"b"),title("Error Analysis");
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Uncompensated error','Compensated Error');




