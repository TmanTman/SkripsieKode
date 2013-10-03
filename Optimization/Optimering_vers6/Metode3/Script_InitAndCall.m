%Skripsie
%Tielman Nieuwoudt
%2 August 2013
%This function initializes all the vectors (load profiles and the
%generation profile for the pv panel)
%It creates a vector to be optimized and calls the patternsearch
%optimization function
%
%MAJOR REVISION 1: 27 September 2013
%Changed to 48 profile system
%
%MAJOR REVISION 2: 3 Oktober 2013
%Het aangepas om begintye te optimeer

%Initialization
close all;
temp = [50 50 100 100 200 200 500 500 900 900 1000 1000];
PV_in = -1*[zeros(1, 12) temp fliplr(temp) zeros(1, 12)];
lights = [25 25 25 25 25 25 25 25 15 15 10 10 10 50 100 100 75 75 35 35 35 35 30 30 30 30 20 20 20 20 20 20 20 20 20 20 50 50 100 150 200 200 250 250 150 150 150 150];

%Configure battery
tmp_X0 = 500*ones(1, 48);
tmp_LB = -500*ones(1, 48);
tmp_UB = 800*ones(1, 48);
[tmp_A, tmp_b] = BatteryInequalityGenerator(1500);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(battery);

%Set up TOU vector
TOU = ones(1, 24);
TOU(1, 1:13) = 70;
TOU(1, 14:20) = 100;
TOU(1, 21:35) = 70;
TOU(1, 36:42) = 100;
TOU(1, 43:48) = 70;

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)object_function(x, TOU, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, -1*PV_in, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights, 'Lights'), ...
    @optimization_print, ...
    @(optimset, flags)gridplot(optimset, flags, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', ...
    'InitialMeshSize',10);
[x, fval] = patternsearch(OFHandle, X0, A, b, [], [], LB, UB, [], options);