function stop = cntrlTotalPlot(optimvalues,flag, varargin)
%Plots the total energy of controllable profiles.
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

stop = false;
%Add Battery values
profile = optimvalues.x(1:48);
%Add controllable load profiles
start_index = 49;
for i=1:length(varargin)
    amount_of_cycles = length(varargin{i}.d);
    end_index = start_index+amount_of_cycles-1;
    profile = profile+constrProfile(optimvalues.x(start_index:end_index), varargin{i}.d, varargin{i}.demand);
    start_index = end_index+1;
end
switch flag
    case 'init'
        %Graph the plot
        Gridgraph = bar(profile);
        set(Gridgraph,'Tag','CntrlTotal');
        xlabel('Halfhour timeslots','interp','none'); 
        ylabel('Energy per timeslot','interp','none')
        title('Total profile for controllable loads','interp','none');
    case 'iter'
        %Reload the new iterations values
        Gridgraph = findobj(get(gca,'Children'),'Tag','CntrlTotal');
        set(Gridgraph, 'Ydata',profile);
end