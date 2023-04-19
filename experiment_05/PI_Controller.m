%This code is intended for a proportional-integral controller
%Read the comments carefully

clc; clear; close all;

%% G(s) = 1/(s*(s+2)*(s+5)), %OS = 20%, make error zero by PI controller

%since this is a type-1 system, we get finite error for only the ramp
%input, so even if it is not mentioned in the question, we can safely
%assume the system to be a ramp in this case, similarly if system were
%type-0/type-2, we would assume step/parabolic input respectively

%the first task is to plot the root locus of the uncompensated system, draw
%the overshoot line and find the gain for the uncompensated system

s = tf('s');
uncomp_open_sys = 1/(s*(s+2)*(s+5));
rlocus(uncomp_open_sys);
overshoot = 0.2;
zeta = -log(overshoot)/(sqrt(pi^2 + (log(overshoot))^2 ));
sgrid(zeta, 0);
axis([-10 5 -5 5])
[k_uncomp, poles_uncomp] = rlocfind(uncomp_open_sys);


%% let's plot the ramp response for this system now and see the error
uncomp_closed_sys = feedback(k_uncomp*uncomp_open_sys, 1);
t = 0:0.001:500;
uncomp_response = step(uncomp_closed_sys*(1/s), t);
figure()
plot(t, uncomp_response, t, t);
legend('Output', 'Input');
title('Uncompensated system response');

error_uncomp = t' - uncomp_response;
figure()
plot(t, error_uncomp)
title('Uncompensated system error');

%% we can place a pole at the origin to improve the system's type and make
%the error zero, but this will change the shape of the locus, let's see
%that

controller_pole = 1/s;
pole_compensated_sys = uncomp_open_sys*controller_pole;
figure()
subplot(211), rlocus(uncomp_open_sys);
title('Uncompensated Root Locus')
subplot(212), rlocus(pole_compensated_sys);
title('Root locus after adding pole')

%% so of course we can never get a operating point with a 20% overshoot here,
%further, the root locus has changed its shape so much so that for any
%value of K, we get a pole ar the right half plane making the system
%unstable

%to keep the shape of the original locus, and make error go to zero, we can
%place a controller zero very much close to the controller pole at the
%origin, effectively nullifying each other

controller_zero = (s+0.001);
pi_compensated_open_sys = uncomp_open_sys*(controller_zero*controller_pole);

%let's see the root locus now again
figure()
subplot(311), rlocus(uncomp_open_sys);
title('Uncompensated Root Locus')
subplot(312), rlocus(pole_compensated_sys);
title('Root locus after adding pole')
subplot(313), rlocus(pi_compensated_open_sys);
title('Root locus after adding pole and zero')

%% so we can see that the shape of the root locus is unchanged, let's see the
%error now, we can keep the same K value since we are still operating at
%the same point with pretty much an unchanged root locus

%you wil see that the error is decreasing gradually, if you take a really
%long t value, then the error goes to zero
t = 0:0.001:10000;

pi_compensated_closed_sys = feedback(k_uncomp*pi_compensated_open_sys, 1);
pi_compensated_response = step(pi_compensated_closed_sys*(1/s), t);
error_pi_compesated = t' - pi_compensated_response;

%calculating the error again for the new t array
uncomp_closed_sys = feedback(k_uncomp*uncomp_open_sys, 1);
uncomp_response = step(uncomp_closed_sys*(1/s), t);
error_uncomp = t' - uncomp_response;

figure()
plot(t, error_uncomp, t, error_pi_compesated);
legend('Uncompensated error', 'Compensated error');
title('Error after pi compensation');
















