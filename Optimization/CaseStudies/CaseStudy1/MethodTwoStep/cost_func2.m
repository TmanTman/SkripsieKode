function y = cost_func2(optimize_profile, ideal_profile, varargin)
%COST_FUNC2 Minimizes overshoot of ideal_profile
%   Each optimize profile element that is more than its corresponding
%   ideal_profile element when ideal_profile element is positive, induces a
%   penalty.
%   The penalties should be minimized

%Initialize variables
grid = calcGrid(optimize_profile, varargin{:});
y = 0;
for i=1:length(grid)
   if grid(i) > 0
       if grid(i) > ideal_profile(i)
           y = y + grid(i)-ideal_profile(i);
       end
   end
end

end

