clc; clear; close all;
format compact;

t = 0:0.01:50;

% Defining functions
s=tf('s');
R_s = 1/s;
k= 206;
G_s = 1/((s+4)*(s+3)*(s+2));
Open_s = k*G_s;
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