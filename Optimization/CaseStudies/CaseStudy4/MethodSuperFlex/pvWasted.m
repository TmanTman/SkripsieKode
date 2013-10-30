function wasted_profile = pvWasted( pv, varargin )
%GRIDUSAGE Calculates the energy drawn from the grid
%   For all the energy profiles given, this function calculates the amount
%   of energy drawn from the grid
pv_counter = pv;
for i=1:length(varargin)
    pv_counter=pv_counter+varargin{i};
end
wasted_profile = zeros(1, 48);
for i=13:1:34
    if pv_counter(i) < 0
        wasted_profile(i)=pv_counter(i);
    end
end
end

