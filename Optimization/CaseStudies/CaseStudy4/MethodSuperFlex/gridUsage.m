function grid_usage = gridUsage( varargin )
%GRIDUSAGE Calculates the energy drawn from the grid
%   For all the energy profiles given, this function calculates the amount
%   of energy drawn from the grid
grid = zeros(1, 48);
for i=1:length(varargin)
    varargin{i}
    grid=grid+varargin{i};
end
grid
grid_usage = zeros(1, 48);
for i=1:length(grid)
    if grid(i) > 0
        grid_usage(i)=grid(i);
    end
end
grid_usage
end

