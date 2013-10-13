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
%Adapted to optimize appliance start times

%Initialization
close all;
temp = [50 50 100 100 200 200 500 500 900 900 1000 1000];
temp = 0.5*-1*[zeros(1, 12) temp fliplr(temp) zeros(1, 12)];
PV_in = Uncontr_Appl(temp);
temp = [25 25 25 25 25 25 25 25 15 15 10 10 10 50 100 100 75 75 35 35 35 35 30 30 30 30 20 20 20 20 20 20 20 20 20 20 50 50 100 150 200 200 250 250 150 150 150 150];
lights = Uncontr_Appl(temp);

%Configure battery
tmp_X0 = 100*ones(1,48);
tmp_LB = -800*ones(1, 48);
tmp_UB = 500*ones(1, 48);
[tmp_A, tmp_b] = BatteryInequalityGenerator(1500);
battery = Battery(tmp_LB, tmp_UB, tmp_A, tmp_b, tmp_X0);

%Configure Appliances. This should later be read in from the database
%Information hardcoded according to 4 October database entries
%Values recieved by running ExtractSingleSource.py in Optimizaiton
%version5, in folder toetsLoads
%Converted to value in seconds

%Swimming pool pump
tmp_X0 = [43200 61200]; %Starttime Initial
tmp_d = [14400 14400];  %Duration (fixed)
tmp_demand = 750;     %Kilowatt
pump = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Geyser
tmp_X0 = [25200 68400];
tmp_d = [3600 10800];
tmp_demand = 1000;
geyser = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(battery, pump, geyser);
%The equality vector is hardcoded because its only a single line
Aeq = [ones(1, 48) zeros(1,4)];
beq = 0;

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:13) = 70;
TOU(1, 14:20) = 100;
TOU(1, 21:35) = 70;
TOU(1, 36:42) = 100;
TOU(1, 43:48) = 70;

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)cost_func(x, TOU, pump, geyser, PV_in, lights);

%Define var for plot that indicates current appliance starttime vector
%beginning index in optimset
appl1_index = 49;
appl2_index = appl1_index + length(pump.d);


%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, -1*PV_in.profile, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights.profile, 'Lights'), ...
    @(optimset, flags)profilePlot(optimset, flags, 1), ...
    @(optimset, flags)cntrlApplPlot(optimset, flags, pump, appl1_index, 'Pump'),...
    @(optimset, flags)cntrlApplPlot(optimset, flags, geyser, appl2_index, 'Geyser'),...
    @(optimset, flags)gridplot(optimset, flags, pump, geyser, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', 'MaxFunEvals', 200000,...
    'InitialMeshSize',10);
[x, fval] = patternsearch(OFHandle, X0, A, b, Aeq, beq, LB, UB, [], options);