function stop = profilePlot(optimvalues,flag, name)
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
profile = optimvalues.x(1:48);
switch flag
    case 'init'
        %Plot graph initially
        Gridgraph = bar(profile);
        set(Gridgraph,'Tag',name);
        xlabel('Half hour timeslots','interp','none'); 
        ylabel('Energy use per half hour [Wh]','interp','none')
        title(name,'interp','none');
    case 'iter'
        %Reload info for iteration
        Gridgraph = findobj(get(gca,'Children'),'Tag',name);
        set(Gridgraph, 'Ydata', profile);
end