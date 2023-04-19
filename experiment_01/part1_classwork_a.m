clear; clc; close all;
format compact;
set(0,'defaulttextinterpreter','latex');

s = tf('s');
open_sys = 1/(s^2+6*s+25);
x = pole(open_sys);
x

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
