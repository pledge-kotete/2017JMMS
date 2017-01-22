function [plaza, v, time,blank_sum,velocity_variance,velocity_average,time_average,out_flow,out_cars] = clear_boundary(plaza, v, time,booth_bottom,vmax)
%
% clear_boundary  remove the cars of the exit cell
%
% USAGE: [plaza, v, time, departurescount, departurestime] = clear_boundary(plaza, v, time)
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        v = velocity matrix
%        time = time matrix, to trace the time that the car cost to pass the plaza.
%
% zhou lvwen: zhou.lv.wen@gmail.com
departurescount = 0;
departurestime = [];
[a,b] = size(plaza);
for i = 2:b-1
    if plaza(a,i) > 0
        departurescount = departurescount + 1;
        departurestime(departurescount) = time(a,i);
        plaza(a,i) = 0;
        v(a,i) = 0;
        time(a,i) = 0;
    end
end
blank_sum=0;
%计算空格部分
booth_row=ceil(a/2);
temp=0;
for i=booth_row+1:booth_bottom
    for j=1:length(plaza(1,:))
        if plaza(i,j)==0
            blank_sum=blank_sum+1;
        end
    end
end
%计算速度方差部分
temp=plaza+v;
velocity_list=[];
for i=booth_row+1:booth_bottom
    for j=1:length(plaza(1,:))
        if(temp(i,j)>0)
            velocity_list=[velocity_list,temp(i,j)-1];
        end
    end
end
velocity_variance=var(velocity_list);
velocity_average=var(velocity_list);
%统计出扇入区的车数、车流、平均耗时
out_flow=0;%出去车辆的吞吐量
out_cars=0;%出去车辆的台数
time_average=0;%出区消耗的平均时间
for i=1:vmax
    row=booth_bottom-i+1;
    for j=1:b
        if(v(row,j)>=i)
          out_flow=out_flow+v(row,j);
          out_cars=out_cars+1;
          time_average=time_average+time(row,j);%这里的time_average暂时是时间总和
        end
    end
end
time_average=time_average/out_cars;


o=0;