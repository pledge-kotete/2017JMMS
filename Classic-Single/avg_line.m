function [temp_x,temp_y,avg_out] = avg_line( a,b )
temp=[a',b',zeros(length(a'),1)];
temp=sortrows(temp,1);
temp_x=[];
temp_y=[];
repeat_count=1;
for i=2:length(temp)
    if (temp(i,1)==temp(i-1,1))&&(i~=length(temp))
        repeat_count=repeat_count+1;
    elseif(i~=length(temp))
        temp(i-1,3)=(sum(temp((i-repeat_count):(i-1),2))/repeat_count);
        temp_x=[temp_x,temp(i-1,1)];
        temp_y=[temp_y,temp(i-1,3)];
    else
        temp(i,3)=(sum(temp((i-repeat_count+1):i,2))/repeat_count);
        temp_x=[temp_x,temp(i,1)];
        temp_y=[temp_y,temp(i,3)];
    end
end
hold on
avg_out=mean(temp_y);
end

