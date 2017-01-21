function [plaza, v, number_cars] = new_cars(Arrival, plaza, v)
%
% new_cars   introduce new cars. Cars arrive at the toll plaza uniformly in
% time (the interarrival distribution is exponential with rate Arrival?).
% "rush hour" phenomena can be consider by varying the arrival rate.
%
% USAGE: [plaza, v, number_cars] = new_cars(Arrival, dt, plaza, v, vmax)
%        Arrival = the mean total number of cars that arrives
%        dt = time step
%        plaza = plaza matrix
%                1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%        v = velocity matrix
%        vmax = max speed of car
%
% zhou lvwen: zhou.lv.wen@gmail.com

% Find the empty lanes of the entrance where a new car can be add.
[unoccupied_i,unoccupied_j]= find(plaza(1:5,:) == 0);
n = length(unoccupied_i);
number_cars =min( poissrnd(Arrival,1), n);%使用泊松分布
if number_cars > 0
    x = randperm(n);
    for j = 1:number_cars
        plaza(unoccupied_i(x(j)),unoccupied_j(x(j)))= 1;
        v(unoccupied_i(x(j)),unoccupied_j(x(j))) = 5;
    end
end
