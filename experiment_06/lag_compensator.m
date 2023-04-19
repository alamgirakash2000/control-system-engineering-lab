%this code designs a lag compensator from manual calculation through bode
%plot

clc; clear; close all;

%% frequency response via gain adjustment

%first make the system transfer function

s = tf('s');
sys = 100/(s*(s+36)*(s+100));

%you will need to operate the system at 9.5% overshoot with Kv = 40

%for Kv = 40, we need to set the gain at 36*40 = 1440
gain = 1440;
w = logspace(-1,4, 20000);
bode(sys*gain,w);
grid on

%% 
%we can see that even though the error condition is now satisfied, the
%phase margin has become 34.1 degree

%for 9.5% overshoot, we need a phase margin of 60 degree
%to ensure this, we need a lag compensator

%so first go back to the bode plot and find out the frequency at which the
%phase margin is 60+10(safety margin) = 70 degree, as in the current phase is
%-(180-70) = -110 degree

%we can see that at frequency 9.6 rad/s, and the phase is -110 degrees
%and gain is 12.2 db

%so if we can add negative -12.2 db at that point, then the phase margin
%condition is maintained, and we get the required overshoot

%but this newly added -12.2 db should be added near that point only, if it
%affects the low frequency portion, then the error condition will not be
%met

%so let us assume a flat line of -12.2 db will start at (9.6)/10 = 0.96
%rad/s, this will be the position of the compensator zero, a

%extend a -20 db/decade line from (0.96, -12.2) db and see where it
%intersects the x axis from trial and error method, this will be the
%position of the compensator pole, b

%trial and error: we know at 9.8 rad/s, the magnitude of compensator will
%be -12.2, so,
%|(b/0.96) * (j*9.6 + 0.96)/(j*9.6 + b)| = 10^(-12.2/20), hence b = 0.235

%% let us multiply the system by the controller and see the bode plot

%now the phase margin should be 60 degree 

lag_zero = 0.96;
lag_pole = 0.222;

figure()
bode(sys, w);
hold on
grid on
bode(sys*gain, w);
bode(sys*gain*(lag_pole/lag_zero)*(s+lag_zero)/(s+lag_pole), w);
bode((lag_pole/lag_zero)*(s+lag_zero)/(s+lag_pole), w);
legend('Uncompensated', 'After error compensation', 'Lag compensated', ...
    'Compensator only')

%we get a phase margin of 65 degree which is fine since 65 degree
%corresponds to a higher zeta, and hence lower overshoot than the required
%9.5 percent


































