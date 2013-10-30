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
%
%MAJOR REVISION 3: 30 October 2013
%Adapted to Case Study 4 parameters

%Initialization
close all;
PV_in = -1*3*1000*[0,0,0,0,0,0,0,0,0,0,0,0,0.00688704565712588,0.0404407621075567,0.0786608646132515,0.116517109042290,0.152317742893929,0.184967440824007,0.213622202139249,0.237618079627612,0.256414912845400,0.269615083688224,0.276937258591661,0.278235144102209,0.273474980192136,0.262758046944637,0.246309411211251,0.224481677726057,0.197743735763098,0.166718270278300,0.132159255224324,0.0950382291769833,0.0567093443597108,0.0198921585619491,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PV_in = Uncontr_Appl(PV_in);
lights = [50*ones(1, 12) 63 63 226 59.5 40*ones(1, 2) 240*ones(1, 16) 40*ones(1, 2) 327.5 336.5 910 577 345 78.5*ones(1, 3) 72*ones(1, 2) 66 0];
lights = Uncontr_Appl(lights);

%Configure battery
tmp_X0 = zeros(1, 48); %IF THIS CHANGES THE INITIAL PRICE METHOD IS INVALID
tmp_LB = -250*ones(1, 48);
tmp_UB = 250*ones(1, 48);
[tmp_A, tmp_b] = BatteryInequalityGenerator(4500);
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
tmp_demand = 3000;
geyser = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Create the variable matrices from the configurable appliances
[LB, UB, A, b, X0] = CombineConfigAppl(battery, pump, geyser);
%The equality vector is hardcoded because its only a single line
%This ensures the battery has same charge level after 24 hour period
Aeq = [ones(1, 48) zeros(1,4)];
beq = 0;

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:14) = 55.10;
TOU(1, 15:20) = 174.87;
TOU(1, 21:36) = 55.1;
TOU(1, 37:40) = 174.87;
TOU(1, 41:48) = 55.1;

%THIS ONLY WORKS FOR NO INITIAL CHARGE ON BATTERY
%Calculate PV energy used before opt
fprintf('Energy received from PV: %d\n', -1*sum(PV_in.profile));
%Calculate the total amount pumped back into grid
fprintf('Energy pumped back into grid: %d\n', sum(pvWasted(X0, pump, geyser, PV_in, lights))); 
%Calculate the initial cost
fprintf('Initial Cost: %d\n', cost_func(X0, TOU, pump, geyser, PV_in, lights)/10^5);

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

%PV used and cost after optimization
%Calculate the total amount pumped back into grid
fprintf('PV energy not utilised: %d\n', sum(pvWasted(x, pump, geyser, PV_in, lights))); 
%Calculate the initial cost
fprintf('Cost after optimization: %d\n', cost_func(x, TOU, pump, geyser, PV_in, lights)/10^5);
