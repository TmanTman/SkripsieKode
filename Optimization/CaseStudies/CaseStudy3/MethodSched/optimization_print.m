function stop = optimization_print(optimvalues,flag)
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

stop = false;
switch flag
    case 'init'
        Pumpgraph = bar(optimvalues.x);
        set(Pumpgraph,'Tag','Pump');
        xlabel('Hours through the day','interp','none'); 
        ylabel('Energy used per hour','interp','none')
        title(['Optimized profile'],'interp','none');
    case 'iter'
        Pumpgraph = findobj(get(gca,'Children'),'Tag','Pump');
        newY = [optimvalues.x];
        set(Pumpgraph, 'Ydata',newY);
end