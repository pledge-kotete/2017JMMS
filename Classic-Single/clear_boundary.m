function [plaza, v, time, departurescount, departurestime,blank_sum,velocity_variance,velocity_average,time_average,out_flow] = clear_boundary(plaza, v, time,L,booth_bottom)
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
%计算出收费区的耗时
time_average=mean(time(booth_bottom+1,b-L:b-1));
%计算流出收费区域的车流量
out_flow=sum(v(booth_bottom,:));