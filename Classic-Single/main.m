clear;clc
B = 9; % 收费站个数
L = 3; % 进入道路轨道数
plazalength = 101; %收费广场长度
Arrival=1; %抵达车辆数的平均值 0.1-light 2-heavy
iterations = 3000; %循坏次数
Service = 0.8; % Service rate
traffic_light_1=0;
traffic_light_2=10;
traffic_light_3=20;
show_time=0.01;

dt = 0.2; % time step
t_h = 1; % time factor
vmax = 2; % max speed

timecost = [];
influx=zeros(1,iterations);
outflux=zeros(1,iterations);
blank_sum=zeros(1,iterations);%扇入区的空余位置
switch_times=zeros(1,iterations);%扇入区中的换道区域
velocity_variance=zeros(1,iterations);%扇入区的速度方差
velocity_average=zeros(1,iterations);%扇入区中的平均速度
time_average=zeros(1,iterations);%在扇入区中的耗时平均值
in_fan_in=zeros(1,iterations);%进入扇入区车流量
out_car_flow=zeros(1,iterations);%出扇入区车流量
out_cars=zeros(1,iterations);%出扇入区车数量

[plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength);%创建地图 road_sum-路块总数
h = show_plaza(plaza, NaN,show_time);
for i = 1:iterations
    [plaza, v, influx(i)] = new_cars(Arrival, plaza, v);%生成车
    h = show_plaza(plaza, h,show_time);%刷新图
    [plaza,traffic_light_1,traffic_light_2,traffic_light_3] = traffic_light(plaza,traffic_light_1,traffic_light_2,traffic_light_3);%加交通灯
    [plaza, v, time,switch_times(i)] = switch_lanes(plaza, v, time); % 换道
    [plaza, v, time,in_fan_in(i)] = move_forward(plaza, v, time, vmax); %前进
    [plaza, v, time,blank_sum(i),velocity_variance(i),velocity_average(i),time_average(i),out_car_flow(i),out_cars(i)]...
        = clear_boundary(plaza, v, time,booth_bottom,vmax);%消亡抵达的车并结算
    %blank_sum-拥挤程度、空格数;velocity_variance-速度方差;velocity_average-速度均值
end
h = show_plaza(plaza, h,show_time);
xlabel({strcat('B = ',num2str(B)), ...
strcat('mean cost time = ', num2str(round(mean(timecost))))})

throughput_rate=out_car_flow./in_fan_in;
cars_num_fan_in=road_sum-L*(plazalength-booth_bottom)-blank_sum;
%%画平均线
figure(2);
[temp_x,temp_y,flow_avg]=avg_line(cars_num_fan_in,out_car_flow);
plot(temp_x,temp_y,'r');
hold on
[temp_x,temp_y,cars_avg]=avg_line(cars_num_fan_in,out_cars);
plot(temp_x,temp_y,'b');
hold on