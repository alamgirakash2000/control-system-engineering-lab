clc; clear; close all;
format compact;

% Calculating rootlocus
s = tf('s');
G_s = 1/(s*(s+6)*(s+10));
rlocus(G_s);
zeta= 0.455;
omega = 0;
sgrid(zeta, omega);   
axis([-6, 6, -6, 6]);
[k, poles] = rlocfind(G_s)

%% Finding G_new and k1
close all; clc;
H_s = (s+6)/(s+29);
G_new = G_s*H_s;
rlocus(G_new);
sgrid(zeta, omega);   
axis([-50,50 ,-50 , 50]);
[k1, poles1] = rlocfind(G_new)
%k1 = 2.1237e+03;

%% Adding lag
H_s2 = (s+0.047)/(s+0.01);
G_new2 = G_new*H_s2;
rlocus(G_new2);
sgrid(zeta, omega);   
axis([-50,50 ,-50 , 50]);
[k2, poles2] = rlocfind(G_new2)

%% Finding response
close all;
t = 0:.01:10;
f_s = feedback(k2*G_new2,1);
f_s2 = feedback(k*G_s,1);
figure,step(f_s/s,t);
hold on
step(f_s2/s,t);
