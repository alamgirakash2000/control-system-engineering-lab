%This code is intended for a lag controller
%Read the comments carefully

clc; clear; close all;

%% G(s) = 1/(s*(s+2)*(s+5)), %OS = 20%, make error reduce by a factor of 10 by lag controller

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

%let's plot the ramp response for this system now and see the error
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

%since we do not need to make the error zero, we do not have to place the
%pole at the origin, rather we can place the pole very close to the origin,
%and place a zero very close to it to nullify the pole's effect to change
%the shape of the root locus

%here we need to reduce the error by a factor of 10, so the new Kv will be 10
%times larger than the old Kv

%the old Kv was lim (s=0) sG(s) = 1/(2*5) = 0.1
%the new Kv is therefore, Kv' = 10*0.1 = 1

%now Kv' = lim (s=0) sG'(s) where G'(s) = ((s + z_c)/(s + p_c)) * G(s)
%therefore, if we put the limit in, we get, 1 = (z_c/p_c) * (1/10)
%so, (z_c)/(p_c) = 10
%then, we can place the pole at 0.001, and the zero at 0.01 and see what's
%happening

controller_pole = 1/(s+0.001);
controller_zero = (s+0.01);
lag_compensated_open_sys = uncomp_open_sys*(controller_zero*controller_pole);

%let's see the root locus now again
figure()
subplot(211), rlocus(uncomp_open_sys);
title('Uncompensated Root Locus')
subplot(212), rlocus(lag_compensated_open_sys);
title('Root locus after adding pole and zero')

%so we can see that the shape of the root locus is unchanged, let's see the
%error now, we can keep the same K value since we are still operating at
%the same point with pretty much an unchanged root locus

%you wil see that the error is decreasing gradually and reduces by a factor
%of 10

%if it didn't work, you will most likely need to place your pole and zero
%closer to the origin

t = 0:0.001:5000;

lag_compensated_closed_sys = feedback(k_uncomp*lag_compensated_open_sys, 1);
lag_compensated_response = step(lag_compensated_closed_sys*(1/s), t);
error_lag_compesated = t' - lag_compensated_response;

%calculating the error again for the new t array
uncomp_closed_sys = feedback(k_uncomp*uncomp_open_sys, 1);
uncomp_response = step(uncomp_closed_sys*(1/s), t);
error_uncomp = t' - uncomp_response;

figure()
plot(t, error_uncomp, t, error_lag_compesated);
legend('Uncompensated error', 'Compensated error');
title('Error after pi compensation');
















