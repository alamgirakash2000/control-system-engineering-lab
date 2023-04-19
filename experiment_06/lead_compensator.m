%this code designs a lead compensator without plotting/manual calculation

clc; clear; close all;

%% frequency response via gain adjustment

%first make the system transfer function

s = tf('s');
sys = 100/(s*(s+36)*(s+100));

%you will need to operate the system at 20% overshoot with Kv = 40 and
%peak time of 0.1 second

%from peak time, we find the bandwidth requirement to be 46.1 rad/s

%for Kv = 40, we need to set the gain at 36*40 = 1440
%you will need to find out if the bandwidth requirement is satisfied at
%this gain, for this search for the frequency where the magntiude of the
%open loop is -7 db, that is the bandwidth of the system

gain = 1440;
w = logspace(-1,4, 20000);
mag_response = 20*log10(squeeze(bode(sys*gain,w))); %get the values in db
tolerance = 0.005;
index = find(abs(mag_response+7) < tolerance); %find the index for -7 db
bw_plot = w(index(1)); %from plot

bw_code = bandwidth(feedback(sys*gain, 1)); %from code

%we see that the bandwidth requirement is satisfied since we get a 49 rad/s
%bandwidth where the requirement is 46.1 rad/s

%if the bandwidth was not enough, we would need to provide more gain to
%vertically shift the curve upwards, this would push the -7 db point to the
%right and increase the bandwidth. It would also decrease the error by
%increasing the Kv

%now that we have our error and bandwidth met, we need to adjust for the
%overshoot

%we first need to evaluate the current phase margin
[~, pm, ~, ~] = margin(sys*gain)

%we see that our current phase margin is 34 degree, for 20 percent
%overshoot, we need 48 degree phase margin

%so the additional phase required by the lead compensator is (60 - 34 + 10)
% = 24 degrees, 10 degree is added as a safety margin

%%
%since phi_max = 24 degree, we can find beta from this

phi_max = 24*(pi/180);
b = sin(phi_max);
beta = (1-b)/(1+b);

%from beta, we find the additional gain by the compensator
compensator_gain = 1/sqrt(beta);
compensator_gain_db = 20*log10(compensator_gain);

%find where the open loop response is equal to negative of the compensator
%gain in db, since that will be the new phase margin frequency

index = find(abs(mag_response+compensator_gain_db) < tolerance);
wmax = w(index(1)); %new phase margin frequency

%from this phase margin frequency, calculate T
T = 1/(wmax*sqrt(beta));

%lead compensator transfer function
% we place a zero at 1/T and a zero at 1/(beta*T) and normalize by beta

lead_zero = 1/T;
lead_pole = 1/(beta*T);

%%
bode(sys, w);
hold on
grid on
bode(sys*gain, w);
bode(sys*gain*(lead_pole/lead_zero)*(s+lead_zero)/(s+lead_pole), w);
bode((lead_pole/lead_zero)*(s+lead_zero)/(s+lead_pole), w);
legend('Uncompensated', 'After error and bw compensation', 'Lead compensated', ...
    'Compensator only')


%we can see the phase margin is now 45 degree, we needed around 48 degree,
%so it's fine, if you want to add more phase margin, then keep increasing
%the safety margin while keeping track of the bandwidth




















