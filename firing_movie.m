%绘制发炮时的杆和重物的运动动画%
%% 初始化 %%
clc %清除命令窗口的内容
clear %清除作空间的所有变量
clear all %清除工作空间的所有变量，函数，和MEX文件
clf %清除当前的Figure
close %关闭当前的Figure窗口
close all %关闭所有的Figure窗口
num = 50;% 参数a的个数，及组成GIF图的总图片个数
theta = asin(2/3); %给theta赋值

%% 解y"=k*cos(y)%%
options = odeset('RelTol',1e-6,'AbsTol',1e-8); %积分的误差选项
[t,y] = ode45(@odefunction,0:0.01:0.5,[0; 0]); %积分结果

%% 生成每一时刻点的位置 %%
phi = theta-y(:,1);
%计算石块和杆子的位置
length = 8;
length0 = 6;
for ii=1:num
    x(ii,2) = (length-length0)*cos(phi(ii)); %重物和杆1的位置x
    y(ii,2) = 4+(length-length0)*sin(phi(ii)); %重物和杆1的位置y
    x(ii,1) = -length0*cos(phi(ii)); %杆子2的位置x
    y(ii,1) = 4-length0*sin(phi(ii)); %杆子2的位置y
    x(ii,3) = 0;
    y(ii,3) = 4;
end

%% 绘制动画 %%
h = animatedline('Marker','.','Color','magenta','LineWidth',1,'MarkerSize',25);%生成重物的形状格式
pic_num = 1;
for kk = 1:num  
    figure(1);
    set(figure(1), 'Color', 'white');% 设置图片窗口背景颜色为白色    
    addpoints(h,x(kk,1),y(kk,1));% 绘制重物
    animatedline(x(kk,:),y(kk,:),'Color',[1 0.5 0],'LineWidth',1);%绘制杆
    grid on;  %添加网格
    title('单稍炮发射动画','FontSize',14); %给图添加标题
    set(gca,'xlim',[-6,6]);%设置x轴坐标范围
    xlabel('长度(m)');
    set(gca,'ylim',[0,12]);%设置y轴坐标范围
    ylabel('长度(m)');
    pbaspect([1 1 1]);% 调节图片长宽比例
    drawnow;% 立即刷新当前绘图窗口    
    F = getframe(gcf);  % 获取当前绘图窗口的图片
    Im = frame2im(F);   % 返回与电影帧相关的图片数据
    [A, map] = rgb2ind(Im, 256); % 将RGB图片转化为索引图片
    if pic_num == 1
        imwrite(A, map, 'setoff.gif', 'gif', 'Loopcount', Inf, 'DelayTime', 0.01);
        % 将第一张图片写入‘setoff.gif’文件中，并且将GIF播放次数设置成无穷，即保存的GIF图会一直动下去
    else
        imwrite(A, map,'setoff.gif','gif','WriteMode','append','DelayTime',0.01);
        % 依次将其他的图片写入到GIF文件当中
    end
    pic_num = pic_num + 1;
end

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