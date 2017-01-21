% main.m
%
% This is a main script to simulate the approach, service, and departure of 
% vehicles passing through a toll plaza, , as governed by the parameters 
% defined below
%
%   iterations      =  the maximal iterations of simulation
%   B               =  number booths
%   L               =  number lanes in highway before and after plaza
%   Arrival         =  the mean total number of cars that arrives 
%   plazalength     =  length of the plaza
%   Service         =  Service rate of booth
%   plaza           =  plaza matrix
%                      1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%   v               =  velocity matrix
%   vmax            =  max speed of car
%   time            =  time matrix, to trace the time that the car cost to
%                      pass the plaza.
%   dt              =  time step
%   t_h             =  time factor
%   departurescount =  number of cars that departure the plaza in the step
%   departurestime  =  time cost of the departure cars
%   influx          =  influx vector
%   outflux         =  outflux vector
%   timecost        =  time cost of all car
%   h               =  handle of the graphics
%   
% zhou lvwen: zhou.lv.wen@gmail.com

clear;clc
iterations = 5000; %循坏次数
B = 8; % 收费站个数
L = 3; % 进入道路轨道数
Arrival=2; %抵达车辆数的平均值 0.1-light 2-heavy

plazalength = 101; %收费广场长度
[plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength);%创建地图
h = show_plaza(plaza, NaN, 0.01);

Service = 0.8; % Service rate
dt = 0.2; % time step
t_h = 1; % time factor
vmax = 5; % max speed

timecost = [];
influx=zeros(1,iterations);
outflux=zeros(1,iterations);
blank_sum=zeros(1,iterations);%
switch_times=zeros(1,iterations);
velocity_variance=zeros(1,iterations);
velocity_average=zeros(1,iterations);
time_average=zeros(1,iterations);
in_fan_in=zeros(1,iterations);%进入扇入区车流量
out_fan_in=zeros(1,iterations);%出扇入区车流量
for i = 1:iterations
    % introduce new cars
    [plaza, v, influx(i)] = new_cars(Arrival, plaza, v);
    
    h = show_plaza(plaza, h, 0.01);

    % update rules for lanes

    [plaza, v, time,switch_times(i)] = switch_lanes(plaza, v, time); % lane changes
    [plaza, v, time,in_fan_in(i)] = move_forward(plaza, v, time, vmax); % move cars forward
    [plaza, v, time, outflux(i), departurestime,blank_sum(i),velocity_variance(i),velocity_average(i),time_average(i),out_fan_in(i)]= clear_boundary(plaza, v, time,L,booth_bottom);
    %blank_sum-拥挤程度、空格数;velocity_variance-速度方差;velocity_average-速度均值
    timecost = [timecost, departurestime];%每辆车出去的时间
    su=sum(influx);
end
h = show_plaza(plaza, h, 0.01);
xlabel({strcat('B = ',num2str(B)), ...
strcat('mean cost time = ', num2str(round(mean(timecost))))})

throughput_rate=out_fan_in./in_fan_in;