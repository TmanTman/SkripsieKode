%Skripsie
%Tielman Nieuwoudt
%This file enables the plot of several graphs on the graphs produces by the
%patternsearch call
%Usage:
%options = optimset('PlotFncs', {@(optimvalues,
%flag)constantplots(optimvalues, flag, <vectorYouWantToGraph>), ...(repeat
%if required)}, 'Display', 'iter')

function stop = constantplot(optimvalues, flag, profile, name)
%PLOT_CONSTANT Summary of this function goes here
%   Detailed explanation goes here
stop = false;
switch flag
    case 'init'
        bar(profile);
        xlabel('Half hour timeslots', 'interp', 'none');
        ylabel('Energy use per half hour [Wh]', 'interp', 'none');
        title(name, 'interp', 'none')
end

end

