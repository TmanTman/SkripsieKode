%Skripsie
%Cost Function
%7 October 2013
%This cost function specifies that the amount of
%energy withdrawn from the grid should be a minimum.
%List of inputs:
%Optimize Profile - the entire variable vector for optimization
%TOU - The TOU scheme
%varargin - profiles of 1) Controllable 2) Uncontrollable

function y = cost_func(optimize_profile, TOU, varargin)
%Initialize variables
grid = calcGrid(optimize_profile, varargin{:});
    
%Assign grid_usage vector values
grid_usage = zeros(1, 48);
for i=1:length(grid)
    if(grid(i)>0)
        grid_usage(i) = grid(i);
    end
end
y = sum(grid_usage.*TOU);
