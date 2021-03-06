%Skripsie
%ObjectFunction
%2 August 2013
%This function is the function object, which specifies that the amount of
%energy withdrawn from the grid should be a minimum.
%List of inputs:
%Optimize Profile - the entire variable vector for optimization
%TOU - The TOU scheme
%varargin - the profiles of the set appliances

function y = object_function(optimize_profile, TOU, varargin)
timeslots = length(varargin{1});
grid = zeros(1, timeslots);
grid_usage = zeros(1, timeslots);

%Add all appliances with set profiles to the grid
for i=1:length(varargin)
    grid=grid+varargin{i};   
end

%Add all appliance data being optimized to the grid profile
for i=1:(length(optimize_profile)/timeslots)  % Divide the optimize_profile into its respective appliances
    grid = grid + optimize_profile(1, (1+(i-1)*timeslots):(i*timeslots)); %
end

%Assign grid_usage vector values
for i=1:length(grid)
    if(grid(i)>0)
        grid_usage(i) = grid(i);
    end
end
y = sum(grid_usage.*TOU);

