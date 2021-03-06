%Tielman Nieuwoudt
%University of Stellenbosch
%Skripsie
%13 October 2013

function stop = TotalControllable(optimvalues,flag)
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
timeslots = 48;
profile = zeros(1, timeslots);
for i=1:(length(optimvalues.x)/timeslots)
    current_index = (i-1)*timeslots+1;
    profile(1, :) = profile(1, :)+optimvalues.x(current_index:current_index+timeslots-1);
end
switch flag
    case 'init'
        %Graph the plot
        Gridgraph = bar(profile);
        set(Gridgraph,'Tag','Appl');
        xlabel('Halfhour timeslots','interp','none'); 
        ylabel('Energy use per halfhour [kWh]','interp','none')
        title('Total Controllable Profile','interp','none');
    case 'iter'
        %Reload the new iterations values
        Gridgraph = findobj(get(gca,'Children'),'Tag','Appl');
        set(Gridgraph, 'Ydata',profile);
end