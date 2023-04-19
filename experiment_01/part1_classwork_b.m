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
    grid('on'),xlabel('Seconds'),ylabel('Amplitude');
    legend;
    title("Responses for horizontally moving poles", 'FontSize',20)
    
    % Print Values
    info = stepinfo(open_sys);
    Ts= info.SettlingTime;
    OS = info.Overshoot;
    Tp = info.PeakTime;
    fprintf('For the poles: %s --> Settling Time: %.2f s; Overshoot: %.2f; Peak Time: %.2f s \n',p,Ts, OS, Tp)  
end