function stop = differencePlot(optimvalues,flag, ideal, varargin)
%PSPLOTBESTF PlotFcn to plot best function value.
%   STOP = PSPLOTBESTF(OPTIMVALUES,FLAG) where OPTIMVALUES is a structure
%   with the following fields:
%              x: current point X
%      iteration: iteration count
%           fval: function value
%       meshsize: current mesh size
%      funccount: number of function evaluations
%         method: method used in last iteration
%         TolFun: tolerance on function value in last iteration
%           TolX: tolerance on X value in last iteration
%
%   FLAG: Current state in which PlotFcn is called. Possible values are:
%           init: initialization state
%           iter: iteration state
%           done: final state
%
%   STOP: A boolean to stop the algorithm.
%
%   See also PATTERNSEARCH, GA, PSOPTIMSET.


%   Copyright 2003-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2009/08/29 08:25:12 $
%   REVISION: 14 October - adapted to two step optimization problem
%   Prints the difference betweeen the ideal profile and the current
%   optimized profile

stop = false;
profile_being_optimized = optimvalues.x(1:48);
%Add controllable load profiles
start_index = 49;
for i=1:length(varargin)
    amount_of_cycles = length(varargin{i}.d);
    end_index = start_index+amount_of_cycles-1;
    profile_being_optimized = profile_being_optimized+constrProfile(optimvalues.x(start_index:end_index), varargin{i}.d, varargin{i}.demand);
    start_index = end_index+1;
end
dif = profile_being_optimized - ideal;
switch flag
    case 'init'
        Dif = bar(dif);
        set(Dif,'Tag','Difference');
        xlabel('Halfhours through the day','interp','none'); 
        ylabel('Energy used per halfhour','interp','none')
        title('Optimized load profile minus ideal profile','interp','none');
    case 'iter'
        Dif = findobj(get(gca,'Children'),'Tag','Difference');
        set(Dif, 'Ydata',dif);
end