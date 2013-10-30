%Skripsie
%Cost Function
%30 October 2013
%This function calculates the amount of energy pumped back into the grid
%List of inputs:
%Optimize Profile - the entire variable vector for optimization
%varargin - profiles of 1) Controllable 2) Uncontrollable

function y = pumpedIntoGrid(optimize_profile, varargin)
%Initialize variables
grid = calcGrid(optimize_profile, varargin{:});
    
%Assign grid_usage vector values
grid_pumped_back = zeros(1, 48);
for i=1:length(grid)
    if(grid(i)<0)
        grid_pumped_back(i) = grid(i);
    end
end
y = -1*sum(grid_pumped_back);

