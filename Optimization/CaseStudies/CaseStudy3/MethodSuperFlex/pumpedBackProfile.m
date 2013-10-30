function grid_pumped_back = pumpedBackProfile( varargin )
%GRIDUSAGE Calculates the energy drawn from the grid
%   For all the energy profiles given, this function calculates the amount
%   of energy drawn from the grid
grid = zeros(1, 48);
for i=1:length(varargin)
    grid=grid+varargin{i};
end
grid_pumped_back = zeros(1, 48);
for i=1:length(grid)
    if grid(i) < 0
        grid_pumped_back(i)=grid(i);
    end
end
end

