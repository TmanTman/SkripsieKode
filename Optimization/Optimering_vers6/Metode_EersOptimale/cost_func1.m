%Skripsie
%ObjectFunction
%2 August 2013
%This function is the function object, which specifies that the amount of
%energy withdrawn from the grid should be a minimum.
%List of inputs:
%Optimize Profile - the entire variable vector for optimization
%TOU - The TOU scheme
%varargin - the profiles of the set appliances
%
%REVISION: 14 October - Adapted for two step optimization

function y = cost_func1(optimize_profile, TOU, varargin)
timeslots = 48;
grid = zeros(1, timeslots);
grid_usage = zeros(1, timeslots);

%Add all appliances with set profiles to the grid
for i=1:length(varargin)
    grid=grid+varargin{i}.profile;   
end

%Add optimal profile to grid calculation
grid = grid + optimize_profile; %

%Assign grid_usage vector values
for i=1:length(grid)
    if(grid(i)>0)
        grid_usage(i) = grid(i);
    end
end
y = sum(grid_usage.*TOU);

