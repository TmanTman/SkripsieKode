%University of Stellenbosch
%Bachelors thesis
%Tielman Nieuwoudt
%16082370

%This function accepts the y values and creates a graph fit for the report

function GraphingFunc(yval, name, xtitle, ytitle)
hold on
%create numeric equivalent of time division 
dv = 0:1/48:1-1/48;
a = datenum(dv);
bar(a, yval);
%Convert x values to date values
datetick('x', 'HH:MM');
%Edit settings of graph
title(name, 'FontSize', 16);
xlabel(xtitle);
ylabel(ytitle);


