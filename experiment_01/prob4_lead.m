clc; clear; close all;
format compact;

% Calculating rootlocus
s = tf('s');
G_s = 1/(s*(s+20)*(s+40));
rlocus(G_s);
zeta= 0.455;
omega = 0;
sgrid(zeta, omega);   
%axis([-6, 6, -6, 6]);
[k, poles] = rlocfind(G_s)

%% Finding G_new and k1
close all; clc;
k=8.8946e+03;

H_s = (s+10)/(s+40.23);
G_new = G_s*H_s;
rlocus(G_new);
zeta= 0.455;
omega = 0;
sgrid(zeta, omega);   
axis([-50,50 ,-50 , 50]);
[k1, poles1] = rlocfind(G_new)
%k1 = 2.1237e+03;



%% Finding response
close all;
k1 =  4.0238e+04;
t = 0:.01:5;
f_s = feedback(k1*G_new,1);

f_s2 = feedback(k*G_s,1);

figure,step(f_s,t);
hold on
step(f_s2,t);
