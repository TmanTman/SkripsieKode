%Skripsie
%Tielman Nieuwoudt
%This file enables the plot of several graphs on the graphs produces by the
%patternsearch call
%Usage:
%options = optimset('PlotFncs', {@(optimvalues,
%flag)constantplots(optimvalues, flag, <vectorYouWantToGraph>), ...(repeat
%if required)}, 'Display', 'iter')

function stop = constantplot(optimset, flag, profile, name)
%constantplot - This function plots a constant 48 element vector
%   Profiles such as the uncontrollable loads and the PV_in is not
%   controllable and will not change. This function can print those
%   profiles and won't reprint them (saves resources)
stop = false;
switch flag
    case 'init'
        bar(profile);
        xlabel('Hours through the day', 'interp', 'none');
        ylabel('Energy used per hour', 'interp', 'none');
        title(name, 'interp', 'none')
end

end

