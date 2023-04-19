%This code is intended for a proportional-derivative controller
%Read the comments carefully

clc; clear; close all;

%% G(s) = 1/((s+1)*(s+2)*(s+5)), %OS = 20%, make settling time reduce by a factor of two
%by a PI controller

%since this is a type-0 system, we get finite error for only the step
%input, so even if it is not mentioned in the question, we can safely
%assume the system to be a step in this case, similarly if system were
%type-1/type-2, we would assume ramp/parabolic input respectively

%the first task is to plot the root locus of the uncompensated system, draw
%the overshoot line and find the gain for the uncompensated system

s = tf('s');
uncomp_open_sys = 1/((s+1)*(s+2)*(s+5));
rlocus(uncomp_open_sys);
overshoot = 0.2;
zeta = -log(overshoot)/(sqrt(pi^2 + (log(overshoot))^2 ));
sgrid(zeta, 0);
axis([-10 5 -5 5])
[k_uncomp, poles_uncomp] = rlocfind(uncomp_open_sys);


%% let's plot the step response for this system now and see the response
uncomp_closed_sys = feedback(k_uncomp*uncomp_open_sys, 1);
t = 0:0.001:10;
uncomp_response = step(uncomp_closed_sys, t);
figure()
plot(t, uncomp_response, t, ones(1, length(t)));
legend('Output', 'Input');
title('Uncompensated system response');

%% to make the settling time reduce by a factor of two, we need to operate
% the system at a point the real part of which is twice that of the
% uncompensated system, since settling time, Ts is inversely proportional
% to sigma_d, the real part of the complex pole

%through rlocfind, we see the current operating point is -1 + 1.9j
%so if we want to keep the same overshoot and reduce settling time by 2,
%we need to operate at -2 + 3.8j

%but we cannot operate at this point with the current shape of the root
%locus, so we change the shape by introducing a controller zero at z_c

%and we find the location of z_c by using the angle condition at the point
%-2+3.8j

%after manual calculation, we find z_c = -3.701

controller_zero = (s+3.701);
pd_compensated_open_sys = uncomp_open_sys*(controller_zero);

%let's see the root locus now again
figure()
subplot(211), rlocus(uncomp_open_sys);
title('Uncompensated Root Locus')
subplot(212), rlocus(pd_compensated_open_sys);
title('Root locus after adding zero')

%% so we can see that the shape of the root locus is changed, the next task
% to find out the gain at the new operating point. Since the shape has
% changed, and operating point is no longer the same, so of course there
% will be a change in gain

rlocus(pd_compensated_open_sys);
sgrid(zeta, 0);
axis([-10 5 -5 5])
[k_comp, poles_comp] = rlocfind(pd_compensated_open_sys);

%% now let's plot the step response for both uncompensated and compensated
%systems to see if the results are alright

t = 0:0.001:50;

uncomp_closed_sys = feedback(k_uncomp*uncomp_open_sys, 1);
uncompensated_response = step(uncomp_closed_sys, t);
stepinfo(uncompensated_response,t).SettlingTime

pd_compensated_closed_sys = feedback(k_comp*pd_compensated_open_sys, 1);
pd_compensated_response = step(pd_compensated_closed_sys, t);
stepinfo(pd_compensated_response,t).SettlingTime

figure()
plot(t, uncompensated_response, t, pd_compensated_response);
legend('Uncompensated response', 'Compensated response');
title('Transient improvement using PD controller');

%we can see that not only has the settling time improved, the PD controller
%has improved the error also, something that we will use later















