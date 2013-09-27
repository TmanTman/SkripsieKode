%Skripsie
%Tielman Nieuwoudt
%2 Augustus 2013
%This function initializes all the vectors (load profiles and the
%generation profile for the pv panel)
%It creates a vector to be optimized and calls the patternsearch
%optimization function

%Initialization
close all;
temp = [50 100 200 500 900 1000];
PV_in = -1*[zeros(1, 6) temp fliplr(temp) zeros(1, 6)];
lights = [150 75 50 25 15 10 10 50 40 35 35 30 30 20 20 20 20 20 50 100 150 250 150 150];

%Configure pump appliance
tmp_X0 = [475*ones(1, 6) zeros(1,16) 475*ones(1, 2)];
tmp_LB = zeros(1, 24);
tmp_UB = ones(1, 24)*1100;
tmp_A = ones(2, 24);
tmp_A(2, :) = -1*tmp_A(2, :);
tmp_b = [7200; -7000];
pump = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Configure battery
tmp_X0 = 500*ones(1, 24);
tmp_LB = -500*ones(1, 24);
tmp_UB = 800*ones(1, 24);
[tmp_A, tmp_b] = BatteryInequalityGenerator(1500);
battery = Appliance(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(pump, battery);

%Set up TOU vector
TOU = ones(1, 24);
TOU(1, 1:6) = 70;
TOU(1, 7:18) = 100;
TOU(1, 19:24) = 70;
TOU(1, 21:22) = 60;

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)object_function(x, TOU, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, -1*PV_in, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights, 'Lights'), ...
    @optimization_print, ...
    @(optimset, flags)gridplot(optimset, flags, PV_in, lights) ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter');
[x, fval] = patternsearch(OFHandle, X0, A, b, [], [], LB, UB, [], options);