%Skripsie
%Tielman Nieuwoudt
%7 Oktober 2013
%This script optimizes the energy profile with the two step method
%
%REVISION 1: 28 October 2013. Adapted the system according to Strategy 1

close all;

% Create uncontrollable loads as Uncontr_Appl objects
temp = zeros(1, 48);
PV_in = Uncontr_Appl(temp);
temp = [50*ones(1, 12) 63 63 226 59.5 40*ones(1, 2) 240*ones(1, 16) 40*ones(1, 2) 327.5 336.5 910 577 345 78.5*ones(1, 3) 72*ones(1, 2) 66 0];
lights = Uncontr_Appl(temp);

%Configure Appliances. This should later be read in from the database
%Information hardcoded according to 4 October database entries
%Converted to value in seconds

%Swimming pool pump
tmp_X0 = [18000 30000]; %Starttime Initial
tmp_d = [14400 14400];  %Duration (fixed)
tmp_demand = 750;     %watt
pump = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Geyser
tmp_X0 = [20000 25000];
tmp_d = [3600 10800];
tmp_demand = 3000;
geyser = Contr_Appl(tmp_X0, tmp_d, tmp_demand);

%Constraint that ideal profile have exactly as much energy as contr appl
%require
%Aeq
Aeq = ones(1, 48);
%beq calculations
pump_duration_in_hours = sum(pump.d)/3600;
pump_energy = pump_duration_in_hours*pump.demand;
geyser_duration_in_hours = sum(geyser.d)/3600;
geyser_energy = geyser_duration_in_hours*geyser.demand;
beq = geyser_energy+pump_energy;

%Create constraints for initial optimization
%Lowest value for ideal profile is zero
LB = zeros(1, 48);
%Highest value is appliance maximum demand from system
all_appliances_on_demand = 0.5*(pump.demand+geyser.demand);
UB = all_appliances_on_demand*ones(1, 48);
%beq should be the total amount of energy required to power the loads
%Loop would be appropriate if more Appliances are declared
X0 = zeros(1, 48);

%Set up TOU vector
TOU = ones(1, 48);
TOU(1, 1:14) = 55.10;
TOU(1, 15:20) = 174.87;
TOU(1, 21:36) = 55.1;
TOU(1, 37:40) = 174.87;
TOU(1, 41:48) = 55.1;

%Call necessary function handles to make call to patternsearch
OFHandle1 = @(x)cost_func1(x, TOU, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, -1*PV_in.profile, 'PV energy'), ...
    @(optimset, flags)constantplot(optimset, flags, lights.profile, 'Lights'), ...
    @(optimset, flags)profilePlot(optimset, flags, 'Ideal controllable load profile'), ...
    @(optimset, flags)gridplot(optimset, flags, PV_in, lights), ...
    @(optimset, flags)constantplot(optimset, flags, TOU, 'Time-of-use Tariffs'), ...
    @psplotbestf...
    }, 'Display', 'iter', 'MaxFunEvals', 200000,...
    'InitialMeshSize',10);

[x1, fval1] = patternsearch(OFHandle1, X0, [], [], Aeq, beq, LB, UB, [], options);

%Now configure second optimization
[LB UB A b X0] = CombineConfigAppl(pump, geyser);
 
%Call necessary function handles to make call to patternsearch
OFHandle2 = @(x)cost_func2(x, x1, pump, geyser, PV_in, lights);

%Set up optimization options and run optimization
options = psoptimset('PlotFcns', {@(optimset, flags)constantplot(optimset, flags, x1, 'Ideal Profile'), ...
    @(optimset, flags)cntrlApplPlot(optimset, flags, pump, 1, 'Pump'),...
    @(optimset, flags)cntrlApplPlot(optimset, flags, geyser, 3, 'Geyser'),...
    @(optimset, flags)gridPlot(optimset, flags, pump, geyser, lights, PV_in),...
    @(optimset, flags)cntrlTotalPlot(optimset, flags, pump, geyser),...
    @(optimset, flags)differencePlot(optimset, flags, x1, pump, geyser), ...
    @(optimset, flags)costPlot(optimset, flags, TOU, pump, geyser, PV_in, lights), ...
    @psplotbestf...
    }, 'Display', 'iter', 'MaxFunEvals', 200000,...
    'InitialMeshSize',10);

[x2, fval2] = patternsearch(OFHandle2, X0, A, b, [], [], LB, UB, [], options);

