%Skripsie
%Tielman Nieuwoudt
%2 August 2013
%Reschedule optimization, Case study 1
%This function initializes all the vectors (load profiles and the
%generation profile for the pv panel)
%It creates a vector to be optimized and calls the patternsearch
%optimization function
%
%MAJOR REVISION 1: 27 September 2013
%Changed to 48 profile system
%
%MAJOR REVISION 2: 3 October 2013
%Adapted to optimize appliance start times
%
%MAJOR REVISION 3: 28 October 2013
%Adapted to Case study 2: No battery, 1kW PV

%Initialization
close all;
PV_in = -1*3*1000*[0,0,0,0,0,0,0,0,0,0,0,0,0.00688704565712588,0.0404407621075567,0.0786608646132515,0.116517109042290,0.152317742893929,0.184967440824007,0.213622202139249,0.237618079627612,0.256414912845400,0.269615083688224,0.276937258591661,0.278235144102209,0.273474980192136,0.262758046944637,0.246309411211251,0.224481677726057,0.197743735763098,0.166718270278300,0.132159255224324,0.0950382291769833,0.0567093443597108,0.0198921585619491,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PV_in = Uncontr_Appl(PV_in);
temp = [50*ones(1, 12) 63 63 226 59.5 40*ones(1, 2) 240*ones(1, 16) 40*ones(1, 2) 327.5 336.5 910 577 345 78.5*ones(1, 3) 72*ones(1, 2) 66 0];
lights = Uncontr_Appl(temp);

%Configure Appliances. This should later be read in from the database
%Information hardcoded according to 28 October database entries
%Converted to value in seconds

%Swimming pool pump
tmp_X0 = [43200 61200]; %Starttime Initial
tmp_d = [14400 14400];  %Duration (fixed)
tmp_demand = 750;     %watt
pump = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Geyser
tmp_X0 = [25200 68400];
tmp_d = [3600 10800];
tmp_demand = 3000;
geyser = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(pump, geyser);

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:14) = 55.10;
TOU(1, 15:20) = 174.87;
TOU(1, 21:36) = 55.1;
TOU(1, 37:40) = 174.87;
TOU(1, 41:48) = 55.1;

%Calculate the initial cost
fprintf('Initial Cost: %d\n', cost_func(X0, TOU, pump, geyser, PV_in, lights)/10^5);
%Calculate the total amount of energy received from PV
fprintf('Energy received from PV: %d\n', -1*sum(PV_in.profile));
%Calculate the total amount pumped back into grid
fprintf('Energy pumped back into grid: %d\n', pumpedIntoGrid(X0, pump, geyser, PV_in, lights)); 

%Call necessary function handles to make call to patternsearch
OFHandle = @(x)cost_func(x, TOU, pump, geyser, PV_in, lights);

%Define var for plot that indicates current appliance starttime vector
%beginning index in optimset
appl1_index = 1;
appl2_index = appl1_index + length(pump.d);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, PV_in.profile, 'PV energy profile'), ...
    @(optimset, flags)constantplot(optimset, flags, lights.profile, 'Uncontrollable load profile'), ...
    @(optimset, flags)cntrlApplPlot(optimset, flags, pump, appl1_index, 'Pump load profile'),...
    @(optimset, flags)cntrlApplPlot(optimset, flags, geyser, appl2_index, 'Geyser load profile'),...
    @(optimset, flags)gridplot(optimset, flags, pump, geyser, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', 'MaxFunEvals', 200000,...
    'InitialMeshSize',10);

[x, fval] = patternsearch(OFHandle, X0, A, b, [], [], LB, UB, [], options);

%Calculate the amount of PV pumped to the grid after optimization
fprintf('Energy pumped back into grid: %d\n', pumpedIntoGrid(x, pump, geyser, PV_in, lights)); 
%Get Controllable appliances start times
fprintf('Pump: ')
pump = x(1:2)
fprintf('Geyser: ')
geyser = x(3:4)
fprintf('Optimized cost: %d\n', fval/10^5)