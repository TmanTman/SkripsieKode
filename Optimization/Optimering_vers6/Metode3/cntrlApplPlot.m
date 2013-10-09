function stop = cntrlApplPlot(optimvalues,flag, appl, appl_index, name)
%Plots a single applicance profile.
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
amount_of_cycles = length(appl.d);
profile = constrProfile(optimvalues.x(appl_index:(appl_index+amount_of_cycles-1)), appl.d, appl.demand);
switch flag
    case 'init'
        %Graph the plot
        Gridgraph = bar(profile);
        set(Gridgraph,'Tag','Appl');
        xlabel('Halfhour timeslots','interp','none'); 
        ylabel('Energy per timeslot','interp','none')
        title(name,'interp','none');
    case 'iter'
        %Reload the new iterations values
        Gridgraph = findobj(get(gca,'Children'),'Tag','Appl');
        set(Gridgraph, 'Ydata',profile);
pause(0.2)
end