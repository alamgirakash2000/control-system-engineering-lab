clc; clear; close all;
format compact;

% zeta = -log(os)/sqrt(pi^2+(log(os))^2);
%Ts = 4/(zeta*omega)
% sgrid(zeta, omega)


% Calculating rootlocus
s = tf('s');
G_s = 1/(s*(s+5)*(s+11));
rlocus(G_s);
sgrid(0.28, 31.74);   
axis([-10, 10, -10, 10]);
[k, poles] = rlocfind(G_s)

%% Finding response
close all;
t = 0:.01:5;
f_s = feedback(k*G_s,1);
figure,step(f_s,t);
