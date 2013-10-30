function stop = costPlot(optimvalues,flag, TOU, varargin)
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
%   REVISION: 14 October - Calculates total cost to client

stop = false;

%Calculate the total grid usage
grid = calcGrid(optimvalues.x, varargin{:});
%Assign grid_usage vector values
grid_usage = zeros(1, 48);
for i=1:length(grid)
    if(grid(i)>0)
        grid_usage(i) = grid(i);
    end
end
switch flag
    case 'init'
        cost = sum(TOU.*grid_usage)/100000;
        Gridgraph = plot(1:length(cost), cost);
        set(Gridgraph,'Tag','Cost');
        xlabel('Iterations','interp','none'); 
        ylabel('Cost to client [R/day]','interp','none')
        title('Cost optimization','interp','none');
    case 'iter'
        Gridgraph = findobj(get(gca,'Children'),'Tag','Cost');
        cost = get(Gridgraph, 'YData');
        cost = [cost sum(TOU.*grid_usage)/100000];
        xdata = 1:length(cost);
        set(Gridgraph, 'Xdata', xdata)
        set(Gridgraph, 'Ydata',cost);
end