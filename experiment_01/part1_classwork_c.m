clear; clc; close all;
format compact;
set(0,'defaulttextinterpreter','latex');

num = 1;
%%keeping costheta constant
for k=1:4
    num =1 ;
    den = conv([1 3*k-4*k*i],[1 3+4*k*i]);
    open_sys = tf(num,den);
    time = 0:0.1:10;
    response = step(open_sys,time);
    
        % Legend
    p1 = num2str(3*k+4*k*i);
    p2 =num2str(3*k-4*k*i);
    p = strcat(p1," & ",p2);
    
    % Plotting
    plot(time,response,'DisplayName',p,'LineWidth',1);
    hold on;
    grid('on'),xlabel('Seconds'),ylabel('Amplitude');
    legend;
     title("Responses moving poles by keeping cos(theta) constant", 'FontSize',20)
     
 % Print Values
    info = stepinfo(open_sys);
    Ts= info.SettlingTime;
    OS = info.Overshoot;
    Tp = info.PeakTime;
    fprintf('For the poles: %s --> Settling Time: %.2f s; Overshoot: %.2f; Peak Time: %.2f s \n',p,Ts, OS, Tp)
    
end