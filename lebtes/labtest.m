clc; clear; close all;
format compact;

s= tf('s');
sys = 1/((s+2)*(s+8));   % uncompensated system
OS = 0.2;                  
zeta = -log(OS)/(pi^2+(log(OS))^2)^0.5;
rlocus(sys);
sgrid(zeta,0);
axis([-10 20 -5 20])
[k, poles] = rlocfind(sys)
uncomp_sys = k*sys;

Move the poles vertically in the s-plane by keeping their real part constant.
clear; clc; close all;
format compact;
set(0,'defaulttextinterpreter','latex');

s = tf('s');
open_sys = 1/(s^2+6*s+25);
x = pole(open_sys);

%%Moving the pole vertically
for k=2:7
    num =1;
    den = conv([1 3-k*i],[1 3+k*i]);
    open_sys = tf(num,den);
    time = 0:0.1:10;
    response = step(open_sys,time);

    % Legend
    p1 = num2str(-3+k*i);
    p2 =num2str(-3-k*i);
    p = strcat(p1," & ",p2);

    plot(time,response,'DisplayName',p,'LineWidth',3);
    hold on;
    grid('on'),xlabel('Seconds'),ylabel('Amplitude');
    legend;
    title("Responses for vertically moving poles", 'FontSize',22)

    % Print Values
    info = stepinfo(open_sys);
    Ts= info.SettlingTime;
    OS = info.Overshoot;
    Tp = info.PeakTime;
    fprintf('For the poles: %s --> Settling Time: %.2f s; Overshoot: %.2f; Peak Time: %.2f s \n',p,Ts, OS, Tp)
end
For the poles: -3+2i & -3-2i --> Settling Time: 1.12 s; Overshoot: 0.90; Peak Time: 1.57 s 
For the poles: -3+3i & -3-3i --> Settling Time: 1.41 s; Overshoot: 4.32; Peak Time: 1.04 s 
For the poles: -3+4i & -3-4i --> Settling Time: 1.19 s; Overshoot: 9.48; Peak Time: 0.78 s 
For the poles: -3+5i & -3-5i --> Settling Time: 1.35 s; Overshoot: 15.18; Peak Time: 0.63 s 
For the poles: -3+6i & -3-6i --> Settling Time: 1.25 s; Overshoot: 20.79; Peak Time: 0.52 s 
For the poles: -3+7i & -3-7i --> Settling Time: 1.10 s; Overshoot: 26.01; Peak Time: 0.45 s 
 
Fig-01: Responses for the vertically moving poles

1.2 Class Work (b)
Move the poles horizontally in the s-plane by keeping their imaginary part constant.
clear; clc; close all;
format compact;
set(0,'defaulttextinterpreter','latex');

%%Finding pole
s = tf('s');
open_sys = 1/(s^2+6*s+25);
x = pole(open_sys);

%%Moving the pole Horizontally keeping imaginary part constant
for k=-4:3
    num =1;
    den = conv([1 -k-4*i],[1 -k+4*i]);
    open_sys = tf(num,den);
    time = 0:0.01:1.1;
    response = step(open_sys,time);

    % Legend
    p1 = num2str(k+4*i);
    p2 =num2str(k-4*i);
    p = strcat(p1," & ",p2);

    % Plotting
    plot(time,response,'DisplayName',p,'LineWidth',2);
    hold on;
    grid('on'),xlabel('Sec
