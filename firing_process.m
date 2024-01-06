%解微分方程并绘制杆的角度、角速度、角加速度和末端速度随时间变化关系图%
%% 初始化 %%
clc %清除命令窗口的内容
clear %清除作空间的所有变量
clear all %清除工作空间的所有变量，函数，和MEX文件
clf %清除当前的Figure
close %关闭当前的Figure窗口
close all %关闭所有的Figure窗口
theta = asin(2/3); %给theta赋值

%% 解y"=k*cos(y) %%
options = odeset('RelTol',1e-6,'AbsTol',1e-8); %积分的误差选项
[t,y] = ode45(@odefunction,0:0.001:0.5,[0; 0]); %积分结果
z=diff(y(:,2))/0.001;%计算角加速度
z(501)=z(500);%补充缺少的一个值，利于之后绘图

%% 绘图 %%

subplot(2,2,1);%绘制图(a)
plot(t,theta-y(:,1),'-','Color','#f65314',LineWidth=1);%绘制角度随时间变化图
title('(a) 杆的角度\phi随时间变化关系图',"FontSize",12);%设定标题
xlabel('时间t(s)');%x轴的标签
ylabel('角度\phi (rad)');%y轴的标签
set(gca,'ylim',[-0.5*pi,0.5.*pi]);%设置y轴坐标范围
set(gca,'ytick',-0.5*pi:0.25*pi:0.5*pi);%设置y轴坐标间隔
set(gca,'yTickLabel',{'-\pi/2','-\pi/4','0','\pi/4','\pi/2'});%设置y轴坐标 \pi=π
grid on

subplot(2,2,2);%绘制图(b)
plot(t,y(:,2),'-','Color','#7cbb00',LineWidth=1);%绘制角速度随时间变化图
title('(b) 杆的角速度\omega随时间变化关系图',"FontSize",12);%设定标题
xlabel('时间t(s)');%x轴的标签
ylabel('角速度\omega (rad/s)');%y轴的标签
grid on

subplot(2,2,3);%绘制图(c)
plot(t,z,'-','Color','#00a1f1',LineWidth=1);%绘制角加速度随时间变化图
title('(c) 杆的角加速度\epsilon随时间变化关系图',"FontSize",12);%设定标题
xlabel('时间t(s)');%x轴的标签
ylabel('角加速度\epsilon (rad/s^2)');%y轴的标签
grid on

subplot(2,2,4);%绘制图(d)
plot(t,6.*y(:,2),'-','Color','#ffbb00',LineWidth=1);%绘制杆末端速度随时间变化图
title('(d) 杆的末端速度v随时间变化关系图',"FontSize",12);%设定标题
xlabel('时间t(s)');%x轴的标签
ylabel('速度v (m/s)');%y轴的标签
grid on

%% 解微分方程所用函数 %%
function dydt = odefunction(t,y)
F = 4000;
l = 8;
l0 = 6;
m1 = 1.25;
m2 = 30;
k = F*(l-l0)/((m1+m2)*l0^2+m2*l^2/3-m2*l*l0);
dydt = [y(2);k*cos(y(1))];
end