function [ A, b ] = BatteryInequalityGenerator(r)
%BATTERYINEQUALITYGENERATOR Generates the A and b inequality vectors for
%the battery
%This function takes the current charge level of the battery (r) and generates
%the inequalities that ensures the battery will not charge itself beyond
%the maximum capacity, or discharge itself beyond 20% discharge.

%The following scheme works for the battery, and fits into the scheme for
%the whole calculation:
%If the battery draws energy (from the panel or the grid) it acts as a load
%and the energy for that time period is positive. It charges the battery
%If the battery provides energy to the system, it acts as a source, and the
%energy for that time period is modeled as negative.
%E.g. if r  = 1500, and if max charge level is 2000
% 2000 >= r - x(1), with x(1) the battery's first hour
%It prevents x(1) to charge more than 500 units (from being smaller than
%-500)
% 1200 <= r - x(1) prevents x(1) from being larger than 300.

%Each time period has to check for both over and undercharge, thus the
%amount of rows = time periods * 2

%Set up b matrix
b = ones(96, 1);
b(1:2:95, 1) = 2000 - r;
b(2:2:96, 1) = -1200 + r;

%Set up A matrix
A = zeros(96, 48);
for i=1:96
    if  mod(i, 2) == 1
        A(i, 1:floor((i+1)/2)) = -1;
    else 
        A(i, 1:floor((i+1)/2)) = 1;
    end
end
end

