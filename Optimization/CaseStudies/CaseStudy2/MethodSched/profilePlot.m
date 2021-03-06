function stop = profilePlot(optimvalues,flag, indexstart)
%PROFILEPLOT Plots a profile extracted from the optimvalues parameter
%   STOP = PROFILEPLOT(OPTIMVALUES,FLAG) where OPTIMVALUES is a structure
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
timeslots = 48;
profile = optimvalues.x(indexstart:indexstart+timeslots-1);
switch flag
    case 'init'
        %Plot graph initially
        Gridgraph = bar(profile);
        set(Gridgraph,'Tag','Battery');
        xlabel('Halfhours through the day','interp','none'); 
        ylabel('Energy per half hour','interp','none')
        title('Battery Energy Usage','interp','none');
    case 'iter'
        %Reload info for iteration
        Gridgraph = findobj(get(gca,'Children'),'Tag','Battery');
        set(Gridgraph, 'Ydata', profile);
end