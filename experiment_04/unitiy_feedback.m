clc; clear; close all;
format compact;

% Defining functions
syms s t;
G(s) = 5/(s^2+7*s+10);
R(s) = 1/s;

% Calculating response and error
C(s) = R(s)*G(s);
E(s) = R(s) - C(s);

% Time domain conversion
c(t) = ilaplace(C(s));
e(t) = ilaplace(E(s));

% Plotting result
fplot(c(t), [0 5]);
hold on;
fplot(e(t),[0 5]);

xlabel("Time(Second)"); ylabel("Amplitude");
legend('Output','Error');
