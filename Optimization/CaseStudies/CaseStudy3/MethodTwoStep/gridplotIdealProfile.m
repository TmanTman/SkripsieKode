function stop = gridplotIdealProfile(optimvalues,flag, varargin)
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
stop = false;
%add all set appliances to the grid profile
grid = calcGridIdealProfile(optimvalues.x, varargin{:});
switch flag
    case 'init'
        Gridgraph = bar(grid);
        set(Gridgraph,'Tag','Grid');
        xlabel('Half hour timeslots','interp','none'); 
        ylabel('Energy use per half hour [Wh]','interp','none')
        title('Grid enery usage','interp','none');
    case 'iter'
        Gridgraph = findobj(get(gca,'Children'),'Tag','Grid');
        set(Gridgraph, 'Ydata',grid);
end