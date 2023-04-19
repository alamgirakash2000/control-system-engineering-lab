clc; clear; close all;
format compact;

t = 0:0.01:10;
% Defining functions
s=tf('s');
R_s = 1/s;
Open_s = 672*(s+5)/(s*(s+6)*(s+7)*(s+7));
Close_s = Open_s/(1+Open_s);

% Calculating response and error function
C_s = R_s*Close_s;
E_s = R_s - C_s;

% Finding Response and Error
output = impulse(C_s, t);
error = impulse(E_s, t);

%Plotting result
plot(t,output,"g",t,error,"r");
xlabel("Time(Second)"); ylabel("Amplitude");
legend('Output','Error');
